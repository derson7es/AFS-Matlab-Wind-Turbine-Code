function WindTurbine_MainAssembly(action)
% ########## SYSTEM DYNAMICS (WIND TURBINE) ##########
% ####################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Oceanic 
% Engineering in 2025. Reviewed and supervised by Professor Dr. Helio 
% Mitio Morishita. Code developed in Matlab 2022b.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains almost all functions of the dynamics 
% of the models related to the wind turbine components, such as tower, 
% rotor, drive train and nacelle.

% ---------- Global Variables and Structures Array ----------
global s who t it SimulationEnvironment WindTurbine_data Sensor WindTurbineOutput MeasurementCovariances ProcessCovariances BladePitchSystem GeneratorTorqueSystem PowerGeneration DriveTrainDynamics TowerDynamics RotorDynamics NacelleDynamics OffshoreAssembly AerodynamicModels BEM_Theory Wind_IEC614001_1 Waves_IEC614001_3 Currents_IEC614001_3 GeneratorTorqueController BladePitchController PIGainScheduledOTC PIGainScheduledTSR KalmanFilter ExtendedKalmanFilter



% ---------- Calling Logical Instance 01 of this function ----------
if nargin == 0
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 't', t);    
    assignin('base', 'it', it);    
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);
    assignin('base', 'WindTurbine_data', WindTurbine_data);    
    assignin('base', 'Sensor', Sensor);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);
    assignin('base', 'MeasurementCovariances', MeasurementCovariances);
    assignin('base', 'ProcessCovariances', ProcessCovariances);
    assignin('base', 'BladePitchSystem', BladePitchSystem);
    assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem); 
    assignin('base', 'PowerGeneration', PowerGeneration);
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);
    assignin('base', 'TowerDynamics', TowerDynamics);      
    assignin('base', 'RotorDynamics', RotorDynamics);      
    assignin('base', 'NacelleDynamics', NacelleDynamics); 
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);      
    assignin('base', 'AerodynamicModels', AerodynamicModels);      
    assignin('base', 'BEM_Theory', BEM_Theory);          
    assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);      
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);  
    assignin('base', 'Currents_IEC614001_3', Currents_IEC614001_3);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);      
    assignin('base', 'BladePitchController', BladePitchController);  
    assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);  
    assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);  
    assignin('base', 'KalmanFilter', KalmanFilter);  
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);  
    %   
    action = 'logical_instance_01';
end

if strcmp(action, 'logical_instance_01')
%==================== LOGICAL INSTANCE 01 ====================
%=============================================================
    % DESIGN CHOICES, HYPOTHESES AND THEIR OPTIONS (OFFILINE):    
    % Purpose of this Logical Instance: to define the option choices 
    % related to this recursive function "WindTurbine_MainAssembly.m". 


    % ---------- Option 01: Blade Pitch Actuator System (Blade Pitch Dynamics) ----------
    who.Option01f3.Option_01 = 'Option 01 of Recursive Function f3';
    who.Option01f3.about = 'According to Simani (2015), two different blade pitch technologies are usually implemented using hydraulic and electromechanical actuation systems.';
    who.Option01f3.choose_01 = 'Option06f3 == 1 to NOT consider the Blade Pitch dynamics, assuming that the blade pitch as relatively fast (Beta = Beta_d).';
    who.Option01f3.choose_02 = 'Option06f3 == 2 to choose Electromechanical Blade Pitch Systems (first-order model - delay behavior).';
    who.Option01f3.choose_03 = 'Option06f3 == 3 to choose Hydraulic Blade Pitch Systems (second-order model - oscillatory behavior).';
        % Choose your option:
    s.Option01f3 = 1; 
    if s.Option01f3 == 1 || s.Option01f3 == 2 || s.Option01f3 == 3
        BladePitchSystem.Option01f3 = s.Option01f3;
    else
        error('Invalid option selected for Option01f3. Please choose 1 or 2 or 3.');
    end 




    % ---------- Option 02: Generator/Converter Actuator System (Generator Torque Dynamics) ----------
    who.Option02f3.Option_02 = 'Option 02 of Recursive Function f3';
    who.Option02f3.about = 'According to Simani (2015), simulation-oriented models do not include it, since the generator/converter dynamics are relatively fast. However, when advanced control designs need to be investigated, an explicit generator/converter model may be necessary. In this situation, a simple first-order delay model may be sufficient.';
    who.Option02f3.choose_01 = 'Option02f3 == 1 to NOT consider the Generator/Converter Dynamics, assuming that the generator torque systems as relatively fast (Tg = Tg_d)';
    who.Option02f3.choose_02 = 'Option02f3 == 2 to consider the Generator/Converter Dynamics (first-order model - delay behavior)';
        % Choose your option:
    s.Option02f3 = 1; 
    if s.Option02f3 == 1 || s.Option02f3 == 2
        % See "Generator Models" of BLADED DOCUMENTARION (comercial
        % software) sugested used dynamic torque with small constante time
        % to fast response Tg =~Tg_d. 
        GeneratorTorqueSystem.Option02f3 = s.Option02f3;
    else
        error('Invalid option selected for Option02f3. Please choose 1 or 2.');
    end  


    % ---------- Option 03: Flexible or rigid modeling for the drivetrain ----------
    who.Option03f3.Option_03 = 'Option 03 of Recursive Function f3';
    who.Option03f3.about = 'Flexible or rigid shaft model in drive train dynamics.';
    who.Option03f3.choose_01 = 'Option03f3 == 1 to choose the One-Mass Model (Low Speed). See details Tahiri (2017).';
    who.Option03f3.choose_02 = 'Option03f3 == 2 to choose the High Speed One-Mass Model. See details Abbas (2020/2021) and Jonkman (2009).';    
    who.Option03f3.choose_03 = 'Option03f3 == 3 to choose the Two-Mass Model. See details Abbas (2020/2021) and Jonkman (2009).';          
        % Choose your option:
    s.Option03f3 = 1; 
    if s.Option03f3 == 1 || s.Option03f3 == 2 || s.Option03f3 == 3
        DriveTrainDynamics.Option03f3 = s.Option03f3;
    else
        error('Invalid option selected for Option03f3. Please choose 1 or 2 or 3.');
    end



    % ---------- Option 04: Tower Dynamics ----------
    who.Option04f3.Option_04 = 'Option 06 of Recursive Function f3';
    who.Option04f3.about = 'Define whether to consider inclinations in the Rotor Dynamics.';
    who.Option04f3.choose_01 = 'Option04f3 == 1 to consider the TOWER DYNAMICS (fore-aft movement).';
    who.Option04f3.choose_02 = 'Option04f3 == 2 to NOT consider the Tower Dynamics, assuming that it is completely rigid.';
        % Choose your option:
    s.Option04f3 = 2; 
    if s.Option04f3 == 1 || s.Option04f3 == 2
        RotorDynamics.Option04f3 = s.Option04f3;
    else
        error('Invalid option selected for Option04f3. Please choose 1 or 2 .');
    end
         % WARNING: I have not evaluated stiffness (Kb) and damping (Cb)
         % values ​​for use in tower dynamics for onshore wind turbines. 
         % Future work will evaluate dynamics and redesign parameters if necessary.


    % ---------- Option 05: Flexible or Rigid Blades ----------
    who.Option05f3.Option_05 = 'Option 05 of Recursive Function f3';
    who.Option05f3.about = 'Define whether to consider Blade Dynamics in the simulation.';
    who.Option05f3.choose_01 = 'Option05f3 == 1 to consider the BLADE DYNAMICS (flap-wise blade bending).';
    who.Option05f3.choose_02 = 'Option05f3 == 2 to NOT consider the BLADE DYNAMICS, assuming that it is completely rigid.';
        % Choose your option: 
    s.Option05f3 = 2; 
    if s.Option05f3 == 1 || s.Option05f3 == 2
        RotorDynamics.Option05f3 = s.Option05f3;
    else
        error('Invalid option selected for Option05f3. Please choose 1 or 2.');
    end
         % WARNING: I have not evaluated the stiffness (Kb) and damping (Cb)
         % values ​​for use in blade dynamics. Currently the values ​​may 
         % introduce instability in the control system, since in theory 
         % the value has a contribution to the effective wind speed. 
         % Therefore, before activating and simulating, adopt coherent values.
         % And in the Matlab function/file "System_WindFieldIEC614001_1",
         % I left an option to regardless of whether or not there is an 
         % effect of the blade dynamics in the system, there is an option 
         % to disregard the effect, if desired.
         % TIP: if you are going to study this problem, go to the file 
         % "System_WindFieldIEC614001_1" and use the option "s.Option07f6 = 2" 
         % and implement the dynamics. After the results are achieved,
         % add the effect and redesign.



    % ---------- Option 06: Hub/Rotor Dynamics (Rotor Inclinations) ----------
    who.Option06f3.Option_06 = 'Option 06 of Recursive Function f3';
    who.Option06f3.about = 'Define whether to consider inclinations in the Rotor Dynamics.';
    who.Option06f3.choose_01 = 'Option06f3 == 1 to consider the HUB/ROTOR DYNAMICS (rotor-teeter, rotor-furl, tail inclination, and furling action).';
    who.Option06f3.choose_02 = 'Option06f3 == 2 to NOT consider the HUB/ROTOR DYNAMICS, assuming that it is completely rigid.';
        % Choose your option:
    s.Option06f3 = 2; 
    if s.Option06f3 == 1 || s.Option06f3 == 2
        RotorDynamics.Option06f3 = s.Option06f3;
    else
        error('Invalid option selected for Option06f3. Please choose 1 or 2 .');
    end


    % ---------- Option 07: Nacelle Dynamics ----------
    who.Option07f3.Option_07 = 'Option 07 of Recursive Function f3';
    who.Option07f3.about = 'Define whether to consider inclinations in the Rotor Dynamics.';
    who.Option07f3.choose_01 = 'Option07f3 == 1 to consider Nacelle Dynamics, assuming that the nacelle is rotated to align the rotor with the wind direction.';
    who.Option07f3.choose_02 = 'Option07f3 == 2 to NOT consider Nacelle Dynamics, assuming that the rotor is always aligned with the wind direction.';
        % Choose your option:
    s.Option07f3 = 2; 
    if s.Option07f3 == 1 || s.Option07f3 == 2
        RotorDynamics.Option07f3 = s.Option07f3;
    else
        error('Invalid option selected for Option07f3. Please choose 1 or 2 .');
    end


    % ---------- Option 08: Plot wind turbine results ----------
    who.Option08f3.Option_08 = 'Option 08 of Recursive Function f3';
    who.Option08f3.about = 'Plot wind turbine results of simulation.';
    who.Option08f3.choose_01 = 'Option08f3 == 1 to choose DO NOT plot wind turbine results (simulation).';
    who.Option08f3.choose_02 = 'Option08f3 == 2 to choose PLOT THE MAIN FIGURES of wind turbine results (simulation).';
    who.Option08f3.choose_03 = 'Option08f3 == 3 to choose Plot ALL FIGURES of wind turbine results (simulation).';    
        % Choose your option:
    s.Option08f3 = 2; 
    if s.Option08f3 == 1 || s.Option08f3 == 2 || s.Option08f3 == 3
        RotorDynamics.Option08f3 = s.Option08f3;
    else
        error('Invalid option selected for Option08f3. Please choose 1 or 2 or 3.');
    end

    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'BladePitchSystem', BladePitchSystem);
    assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem);
    assignin('base', 'PowerGeneration', PowerGeneration);
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);
    assignin('base', 'TowerDynamics', TowerDynamics);
    assignin('base', 'RotorDynamics', RotorDynamics);
    assignin('base', 'NacelleDynamics', NacelleDynamics);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);



    % Calling the next logic instance 
    if s.Option02f2 == 1 
        % ONSHORE WIND TURBINE
        System_LoadsAerodynamics;

    elseif s.Option02f2 == 2 
        % OFFSHORE WIND TURBINE

        % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
        WindTurbine_OffshoreAssembly_SparBuoyBetti2012;  
        

    elseif s.Option02f2 == 3
        % OFFSHORE WIND TURBINE        

        % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
        WindTurbine_OffshoreAssembly_SparBuoy;

    elseif s.Option02f2 == 4 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Submersible Platform ----------
        WindTurbine_OffshoreAssembly_Submersible;

    elseif s.Option02f2 == 5 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Barge Platform ----------
        WindTurbine_OffshoreAssembly_Barge;

    elseif s.Option02f2 == 6 
        % OFFSHORE WIND TURBINE

        % ---------- Fixed-Bottom Offshore Wind Turbine ----------
        WindTurbine_OffshoreAssembly_FixedBottom;
        %     
    end

    

elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES BASED ON CHOSEN OPTIONS (OFFLINE):
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f9), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.


    % ---------- Properties Blade Pitch Actuator System ----------  
    BladePitchSystem.Notef2_2 = who.Notef2_2;   
    who.tau_Beta = 'Time constant for first-order model of Blade Pitch actuator system dynamics, in [seg].';   
    BladePitchSystem.tau_Beta = s.tau_Beta;
    who.BetaDot_max = 'Maximum Rate Blade Pitch, in [deg/seg]. See page 27 Jonkman (2009).';
    BladePitchSystem.BetaDot_max = s.BetaDot_max; 
    who.Beta_d = 'Desired or Demanded Collective Blade Pitch (Beta_d), in [deg].';
    BladePitchSystem.Beta_d = s.Beta_d;  

    who.Beta_before = 'Last Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta_before = s.Beta_measured ;    
    who.Beta_dot_before = 'Last Collective Blade Pitch Rate (first time derivative), in [deg/seg].';
    s.Beta_dot_before = 0;  

    if s.Option01f3 == 3 
        who.MM_Beta = 'Mass of the second-order model, in [N.seg^2/deg].';
        BladePitchSystem.MM_Beta = s.MM_Beta; 
        who.CC_Beta = 'Damping coefficient of the second-order model, in [N.seg/deg].';
        BladePitchSystem.CC_Beta = s.CC_Beta;    
        who.KK_Beta = 'Stiffness coefficient of the second-order model, in [N/deg].';
        BladePitchSystem.KK_Beta = s.KK_Beta;    
    end 


    % ---------- Properties the Generator Torque/Conversor System ----------
    GeneratorTorqueSystem.Notef2_3 = who.Notef2_3;
    who.tau_Tg = 'Time constant for first-order model of blade pitch actuator system dynamics, in [seg].';
    GeneratorTorqueSystem.tau_Tg = s.tau_Tg;
    who.TgDot_max = 'Maximum Rate Generator Torque, in [N.m/seg]. See page 20 Jonkman (2009).';
    GeneratorTorqueSystem.TgDot_max = s.TgDot_max*s.eta_gb;
    who.Tg = 'Last Generator Torque, in [N.m]';
    s.Tg_before = s.Tg_measured ;  
    who.Tg_d = 'Desired or Demanded Generator Torque (Tg_d), in [N.m].';
    GeneratorTorqueSystem.Tg_d = s.Tg_d;    


    % ---------- Power Generation Properties ----------
    who.Notef2_10 = who.Notef2_10;
    who.etaElec_op = 'Electrical Generator Efficiency, in [-].'; 
    PowerGeneration.etaElec_op = s.etaElec_op;
    who.Pmec_max = 'Maximum Mechanical Power, in [W].';
    PowerGeneration.Pmec_max = s.Pmec_max;    
    who.Tmec_max = 'Maximum Mechanical Torque, in [W].';
    PowerGeneration.Tmec_max = s.Tmec_max;
    who.Te_max = 'Maximum Electrical Torque, in [W].';
    PowerGeneration.Te_max = s.Te_max; 
    who.Tg_rated = 'Rated Generator Torque, in [W]. See page 19-20 Jonkman (2009).';
    PowerGeneration.Tg_rated = s.Tg_rated;      
        
    

    % ---------- Drive Train Properties (Drive Train Dynamics) ---------- 
    DriveTrainDynamics.Notef2_8 = who.Notef2_8;
    who.eta_gb = 'Gearbox gear ratio, in [-].'; 
    DriveTrainDynamics.eta_gb = s.eta_gb;
    who.FNdt_1 = 'Natural frequency of the fist Drivetrain Torsion, in [Hz]. See page 30 Jonkman (2009).'; 
    DriveTrainDynamics.FNdt_1 = s.FNdt_1;      
    who.tau_brakeDt = 'High-Speed Shaft Brake Time Constant, in [seg].'; 
    DriveTrainDynamics.tau_brakeDt = s.tau_brakeDt; 
    who.OmegaR_before = 'Last Rotor speed, in [rad/s].';
    s.OmegaR_before = interp1(s.Vop, s.OmegaR_op, s.Uews_full(1)); 
    who.OmegaG_before = 'Last Generator speed, in [rad/s].';
    s.OmegaG_before = s.OmegaG_measured; 

    if s.Option03f3 == 1 
        % Low Speed - One-Mass Model
        who.J_t = 'Total inertia for the One-Mass Model, in [kg.m^2]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.J_t = s.J_t;  
        who.KKdt = 'Total/Equivalent Drive-Shaft Torsional-Spring Constant for the One-Mass Model, in [N.m]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.KKdt = s.KKdt;  
        who.CCdt = 'Total/Equivalent Drive-Shaft Torsional-Damping Constant for the One-Mass Model, in [N.m.s]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.CCdt = s.CCdt;
    end    

    if s.Option03f3 == 2 || s.Option03f3 == 3 
        % High Speed One-Mass Model and Two-Mass Model

        who.J_r = 'Rotor disk inertia, in [kg.m^2].'; 
        DriveTrainDynamics.J_r = s.J_r;    
        who.KK_ls = 'Low-speed shaft stiffness constant, in [N.m]. Parameter used in the Two-Mass and Three-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.KK_ls = s.KK_ls;  
        who.CC_ls = 'Low-speed shaft damping constant, in [N.m.s]. Parameter used in the Two-Mass and Three-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.CC_ls = s.CC_ls;
        who.CC_r = 'Rotor damping constant, in [N.m.s]. Parameter used in the Two-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.CC_r = s.CC_r;
    end


    if s.Option03f3 == 3 
        % Two-Mass Model
        
        who.J_gb1 = 'Gearbox inertia relative to the low-speed shaft, in [kg.m^2].'; 
        DriveTrainDynamics.J_gb1 = s.J_gb1;      
        who.J_gb1 = 'Gearbox inertia relative to the low-speed shaft, in [kg.m^2].'; 
        DriveTrainDynamics.J_gb1 = s.J_gb1;             

        who.J_g = 'Generator disk inertia, in [kg.m^2]'; 
        DriveTrainDynamics.J_g = s.J_g;              
        who.KK_hs = 'High-speed shaft stiffness constant, in [N.m]. Parameter used in the Three-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.KK_hs = s.KK_hs;  
        who.CC_hs = 'High-speed shaft damping constant, in [N.m.s]. Parameter used in the Three-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.CC_hs = s.CC_hs;
        who.CC_g = 'Generator damping constant, in [N.m.s]. Parameter used in the Two-Mass models, in the drivetrain dynamics.';
        DriveTrainDynamics.CC_g = s.CC_g;    
    end     


    % ---------- Tower Properties ----------
        % Note: see (NREL-5MW/DTU-10MW/IEA-15MW) MAIN DATA OF TOWER PROPERTIES
    TowerDynamics.Notef2_9 = who.Notef2_9;
    who.HtowerG = 'Height above Ground, in [m].';
    TowerDynamics.HtowerG = s.HtowerG;
    who.MMtower_overall = 'Overall (integrated) Mass, in [kg].';
    TowerDynamics.MMtower_overall = s.MMtower_overall;
    who.CM_tower = 'CM Location (w.rt. Ground along Tower Centerline), in [m].';
    TowerDynamics.CM_tower = s.CM_tower;
    who.CC_StrucRatio = 'Structural-Damping Ratio (All Modes), in [decimal].';
    TowerDynamics.CC_StrucRatio = s.CC_StrucRatio;
    who.Jxt = 'Total system inertia in the platform pitching direction, in [unit in SI]';
    TowerDynamics.Jxt = s.Jxt;
    who.CCxt = 'Total damping constant in the platform pitching direction, in [unit in SI]';
    TowerDynamics.CCxt = s.CCxt;
    who.KKxt = 'Total restoring constant, in the platform pitching direction, in [unit in SI]';
    TowerDynamics.KKxt = s.KKxt;
    who.FNtw_FA1 = 'Natural frequency of the fist Tower Fore-Aft, in [Hz]. See page 30 Jonkman (2009).'; 
    TowerDynamics.FNtw_FA1 = s.FNtw_FA1;
    who.FNtw_FA2 = 'Natural frequency of the second Tower Fore-Aft, in [Hz]. See page 30 Jonkman (2009).'; 
    TowerDynamics.FNtw_FA2 = s.FNtw_FA2;      
    who.FNtw_SS1 = 'Natural frequency of the fist Tower Side-to-Side, in [Hz]. See page 30 Jonkman (2009).'; 
    TowerDynamics.FNtw_SS1 = s.FNtw_SS1;
    who.FNtw_SS2 = 'Natural frequency of the second Tower Side-to-Side, in [Hz]. See page 30 Jonkman (2009).'; 
    TowerDynamics.FNtw_SS2 = s.FNtw_SS2;
    who.Fa_0 = 'Initial aerodynamic Thrust (Fa), [N].';
    s.Fa_0 = interp1(s.Vop, s.Fa_op, s.V_meanHub_0);    
    who.Xt_Ddot_0 = 'Initial Tower-top acceleration in the Fore–Aft direction (Xt_Ddot), in [m/s]';
    s.Xt_Ddot_0 = (  (1/s.Jxt)*s.Fa_0 - (s.CCxt/s.Jxt)*0 - (s.KKxt/s.Jxt)*0 + 0  );     


    % ---------- Blade Bending Properties (Rotor Dynamics) ----------
    RotorDynamics.Notef2_5 = who.Notef2_5;
    who.FNba_FY1 = 'Natural frequency of the fist Blade Asymmetric Flapwise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_FY1 = s.FNba_FY1;
    who.FNba_FY2 = 'Natural frequency of the second Blade Asymmetric Flapwise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_FY2 = s.FNba_FY2; 
    who.FNba_EY1 = 'Natural frequency of the fist Blade Asymmetric Edgewise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_EY1 = s.FNba_EY1;       
    who.FNba_FP1 = 'Natural frequency of the fist Blade Asymmetric Flapwise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_FP1 = s.FNba_FP1;
    who.FNba_FP2 = 'Natural frequency of the second Blade Asymmetric Flapwise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_FP2 = s.FNba_FP2; 
    who.FNba_EP1 = 'Natural frequency of the fist Blade Asymmetric Edgewise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNba_EP1 = s.FNba_EP1; 
    who.FNb_CF1 = 'Natural frequency of the fist Blade Collective Flap, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNb_CF1 = s.FNb_CF1;
    who.FNb_CF2 = 'Natural frequency of the second Blade Collective Flap, in [Hz]. See page 30 Jonkman (2009).'; 
    RotorDynamics.FNb_CF2 = s.FNb_CF2;
    who.FlpStff = 'The flapwise stiffness “FlpStff” at each blade section along the blade, in [N*m^2]. Value according Jonkman (2009)';
    RotorDynamics.FlpStff = s.FlpStff;
    who.Rb_FlpStff = 'Radius discretization for blade structure properties, in [m]';
    RotorDynamics.Rb_FlpStff = s.Rb_FlpStff; 
    who.Rrd = 'Rotor Disk Radius, in [m].';
    RotorDynamics.Rrd = s.Rrd;     
    who.weighted_FlpStff = 'Weighted Average Blade Stiffness, in [N*m]';
    RotorDynamics.weighted_FlpStff = s.weighted_FlpStff; 
    who.KKb = 'Stiffness of the Blade, in [N*m/rad]';
    RotorDynamics.KKb = s.KKb; 
    who.CCb_StrucRatio = 'Critical Damping Ratio. According to Jonkman (2009)';
    RotorDynamics.CCb_StrucRatio = s.CCb_StrucRatio;
    who.CCb = 'Damping of the Blade, in [N*m*s]';
    RotorDynamics.CCb = s.CCb;
    who.Mblades = 'Blade mass (integrated assembly), em [kg].';
    RotorDynamics.Mblades = s.Mblades; 
    who.JJb = 'Total system inertia in the flawise direction, in [kg.m^2]';  
    RotorDynamics.JJb = s.JJb;      


    % ---------- Hub and Nacelle Properties (Nacelle Dynamics) ----------    
    NacelleDynamics.Notef2_7 = who.Notef2_7;
    if s.Option07f3 == 1    
        who.HYawBearing = 'Elevation of Yaw Bearing above Ground, in [m].';
        NacelleDynamics.HYawBearing = s.HYawBearing;
        who.DzYaw = 'Vertical Distance along from Hub Center to Yaw Axis, in [m].';
        NacelleDynamics.DzYaw = s.DzYaw;
        who.DxYaw = 'Distance along shaft from Hub Center to Yaw Axis, in [m].';
        NacelleDynamics.DxYaw = s.DxYaw;  
        who.DxYawBearing = 'Distance along shaft from Hub Center to Main Bearing, in [m].';
        NacelleDynamics.DxYawBearing = s.DxYawBearing;
        who.Mhub = 'Hub Mass, em [kg].';
        NacelleDynamics.Mhub = s.Mhub; 
        who.J_hub = 'Hub Inertia about Low-Speed Shaft, em [kg.m^2].';
        NacelleDynamics.J_hub = s.J_hub;     
        who.Mnacelle = 'Nacelle Mass, em [kg].';
        NacelleDynamics.Mnacelle = s.Mnacelle;
        who.J_nacelle = 'Nacelle Inertia about Yaw Axis, em [kg].';
        NacelleDynamics.J_nacelle = s.J_nacelle;
        who.DxYaw = 'Nacelle CM Location Downwind of Yaw Axis, in [m].';
        NacelleDynamics.DxYaw = s.DxYaw;
        who.DxYawBearing = 'Nacelle CM Location above Yaw Bearing, in [m].';
        NacelleDynamics.DxYawBearing = s.DxYawBearing;
        who.KKnacelle = 'Equivalent Nacelle-Yaw-Actuator Linear-Sprint Constant, in [N.m/rad].';
        NacelleDynamics.KKnacelle = s.KKnacelle;
        who.CCnacelle = 'Equivalent Nacelle-Yaw-Actuator Linear-Damping Constant, in [N.m/(rad/s)].';
        NacelleDynamics.CCnacelle = s.CCnacelle; 
        who.YawDot_rated = 'Nominal Nacelle-Yaw Rate, in [deg/seg]';
        NacelleDynamics.YawDot_rated = s.YawDot_rated;        
        who.tau_Yaw = 'Time constant for first-order model of yaw dynamics, in [seg].';
        NacelleDynamics.tau_Yaw = s.tau_Yaw;    
    end
 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'BladePitchSystem', BladePitchSystem);
    assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem);
    assignin('base', 'PowerGeneration', PowerGeneration);
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);
    assignin('base', 'TowerDynamics', TowerDynamics);
    assignin('base', 'RotorDynamics', RotorDynamics);
    assignin('base', 'NacelleDynamics', NacelleDynamics);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);


    % Returns to " WindTurbine_data"


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % BLADE PITCH ACTUATOR SYSTEM - BLADE PITCH DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to simulate the blade pitch system,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (Option06f3 == 1), it is assumed that the
    % system is relatively fast and therefore Beta = Beta_d .


    % ---------- Receiving Control Output Values ----------
    who.Beta_d = 'Desired or Demanded Collective Blade Pitch (Beta_d), in [deg].';
    BladePitchSystem.Beta_d(it) = s.Beta_d;   
      

    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseBeta_Dot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseBeta_Dot = s.WhiteNoiseP_Beta_Dot(randi([1, numel(s.WhiteNoiseP_Beta_Dot)]));

    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseBeta_Dot = s.PNoiseBeta_Dot_comp(it);    
    end


    % ---------- Blade Pitch Systems (without blade pitch dynamics) ----------   
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = s.Beta_d  ;  


    % ---------- Collective Blade Pitch Rate (first time derivative). ----------        
    who.Beta_dot = 'Collective Blade Pitch Rate (first time derivative), in [deg/seg]. Using "Backward Difference" method to calculate the time derivative.';
    s.Beta_dot = 0 + s.PNoiseBeta_Dot ; % s.Beta_dDot*sqrt(s.dt) + s.PNoiseBeta_Dot ;
    s.Beta_dot = min(max(  s.Beta_dot , (- s.BetaDot_max) ),  (s.BetaDot_max) );   

    
    % ----- Acceleration Rate of the Collective Blade Pitch (second time derivative) --------  
    who.Beta_Ddot = 'Acceleration Rate of the Collective Blade Pitch (second time derivative), in [deg/seg^2].';
    delta = t - s.Time(end); 
    if delta == 0            
        s.Beta_Ddot = 0;
    else  
        s.Beta_Ddot = ( s.Beta_dot - s.Beta_dot_before )/delta;      
    end 


    % ---------- Updating the last calculated values ----------
    s.Beta_before = s.Beta;
    s.Beta_dot_before = s.Beta_dot;
     

    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(1) = s.Beta_dot;
    s.dy(2) = s.Beta_Ddot;

    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'BladePitchSystem', BladePitchSystem);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % BLADE PITCH ACTUATOR SYSTEM - BLADE PITCH DYNAMICS (ONLINE):    
    % Purpose of this Logical Instance: to simulate the blade pitch system,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (Option06f3 == 2), an Electromechanical 
    % Blade Pitch Systems (first order model or delay behavior) is assumed.


    % ---------- Receiving Control Output Values ----------
    who.Beta_d = 'Desired or Demanded Collective Blade Pitch (Beta_d), in [deg].';
    BladePitchSystem.Beta_d(it) = s.Beta_d;   
      
    
    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseBeta_Dot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseBeta_Dot = s.WhiteNoiseP_Beta_Dot(randi([1, numel(s.WhiteNoiseP_Beta_Dot)]));

    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseBeta_Dot = s.PNoiseBeta_Dot_comp(it);    
    end


    % ----- Electromechanical Blade Pitch Systems (first-order model - delay behavior) -----
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = max( s.y(1), min(s.Beta_op) ) ;    
        
    who.Beta_dot = 'Collective Blade Pitch Rate (first time derivative), in [deg/seg].';
    s.Beta_dot = (1/s.tau_Beta)*( s.Beta_d - s.Beta ) + s.PNoiseBeta_Dot ;
    s.Beta_dot = min(max(  s.Beta_dot , (- s.BetaDot_max*s.dt) ),  (s.BetaDot_max*s.dt) );


    % ----- Acceleration Rate of the Collective Blade Pitch (second time derivative) --------  
    who.Beta_Ddot = 'Acceleration Rate of the Collective Blade Pitch (second time derivative), in [deg/seg^2].';
    delta = t - s.Time(it); 
    if delta == 0            
        s.Beta_Ddot = 0;
    else  
        s.Beta_Ddot = ( s.Beta_dot - s.Beta_dot_before )/delta ;      
    end 


    % ---------- Updating the last calculated values ----------
    s.Beta_before = s.Beta;
    s.Beta_dot_before = s.Beta_dot;

     
    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(1) = s.Beta_dot;
    s.dy(2) = s.Beta_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'BladePitchSystem', BladePitchSystem);


    % Returns to " WindTurbine('logical_instance_06')"



elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % BLADE PITCH ACTUATOR SYSTEM - BLADE PITCH DYNAMICS (ONLINE):    
    % Purpose of this Logical Instance: to simulate the blade pitch system,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (Option06f3 == 3), an Hydraulic 
    % Blade Pitch System (second-order model - oscillatory behavior) is assumed.

    % ---------- Receiving Control Output Values ----------
    who.Beta_d = 'Desired or Demanded Collective Blade Pitch (Beta_d), in [deg].';
    BladePitchSystem.Beta_d(it) = s.Beta_d;   

    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseBeta_Dot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseBeta_Dot = s.WhiteNoiseP_Beta_Dot(randi([1, numel(s.WhiteNoiseP_Beta_Dot)]));

    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseBeta_Dot = s.PNoiseBeta_Dot_comp(it);    
    end


    % ---------- Hydraulic Blade Pitch Systems (second-order model - oscillatory behavior) ----------  
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = max( s.y(1) , min(s.Beta_op) );

    who.Beta_dot = 'Collective Blade Pitch Rate (first time derivative), in [deg/seg].';
    s.Beta_dot = min(max(  s.y(2) , (- s.BetaDot_max) ),  (s.BetaDot_max) );


    who.Beta_dot = 'Collective Blade Pitch Rate (first time derivative), in [deg/seg].';    
    s.FF_Beta = s.MM_Beta * (s.Beta_dot / 1)  ; 

    who.Beta_Ddot = 'Collective Blade Pitch Acceleration (second time derivative), in [deg/seg^2].';
    s.Beta_Ddot = (1/s.MM_Beta)*s.FF_Beta - (s.CC_Beta/s.MM_Beta)*s.Beta_dot - (s.KK_Beta/s.MM_Beta)*s.Beta + s.PNoiseBeta_Dot*0.5 ;    


    % ---------- Updating the last calculated values ----------
    s.Beta_before = s.Beta;
    s.Beta_dot_before = s.Beta_dot;

     
    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(1) = s.Beta_dot;
    s.dy(2) = s.Beta_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'BladePitchSystem', BladePitchSystem);


    % Returns to " WindTurbine('logical_instance_06')"


%=============================================================
elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % GENERATOR/CONVERTER SYSTEM - GENERATOR TORQUE DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to simulate the Generator Torque
    % system, according to the options chosen in logic instance 01 of this
    % file. In this Logic Instance (s.Option02f3==1), it is assumed that
    % the system is relatively fast and therefore Tg = Tg_d .


    % ---------- Receiving reference values ​​required in the Control Law ----------
    who.Tg_d = 'Desired or Demanded Generator Torque (Tg_d), in [N.m].';
    GeneratorTorqueSystem.Tg_d(it) = s.Tg_d;


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseTg_Dot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseTg_Dot = s.WhiteNoiseP_Tg_Dot(randi([1, numel(s.WhiteNoiseP_Tg_Dot)]));
         
    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseTg_Dot = s.PNoiseTg_Dot_comp(it);    
    end


    % ---------- Generator Torque System (without generator torque dynamics) ----------    
    who.Tg = 'Generator Torque, in [N.m]';
    s.Tg = s.Tg_d ;

    % ---------- Generator Torque Rate (first time derivative). ----------        
    who.Tg_dot = 'Generator Torque Rate (first time derivative), in [N.m/seg]. Using "Backward Difference" method to calculate the time derivative.';
    s.Tg_dot = 0 + s.PNoiseTg_Dot ; % s.Tg_dDot + s.PNoiseTg_Dot
    s.Tg_dot = min(max(  s.Tg_dot , (-s.TgDot_max*s.eta_gb) ),  (s.TgDot_max*s.eta_gb) );    

    
    % ---------- Updating the last calculated values ----------
    s.Tg_before = s.Tg;


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(3) = s.Tg_dot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem);


    % Returns to " WindTurbine('logical_instance_06')"


%=============================================================
elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % GENERATOR/CONVERTER SYSTEM - GENERATOR TORQUE DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to simulate the Generator Torque
    % system, according to the options chosen in logic instance 01 of this
    % file. In this Logical Instance (Option02f3 == 2), an Generator Dynamics 
    % or Converter dynamics (first-order model - delay behavior) is assumed.

    % ---------- Receiving reference values ​​required in the Control Law ----------
    who.Tg_d = 'Desired or Demanded Generator Torque (Tg_d), in [N.m].';
    GeneratorTorqueSystem.Tg_d(it) = s.Tg_d;


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseTg_Dot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseTg_Dot = s.WhiteNoiseP_Tg_Dot(randi([1, numel(s.WhiteNoiseP_Tg_Dot)]));
         
    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseTg_Dot = s.PNoiseTg_Dot_comp(it);    
    end

    
    % ----- Generator Torque System (first-order model - Generator Torque Dynamics) ----- 
    who.Tg = 'Generator Torque, in [N.m]';
    s.Tg = max( s.y(3) , min(s.Tg_op) );

    who.Tg_dot = 'Generator Torque Rate (first time derivative), in [N.m/seg].';
    s.Tg_dot = (1/s.tau_Tg)*( s.Tg_d - s.Tg ) + s.PNoiseTg_Dot;
    s.Tg_dot = min(max(  s.Tg_dot , (-s.TgDot_max*s.eta_gb) ),  (s.TgDot_max*s.eta_gb) );


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(3) = s.Tg_dot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % DRIVE TRAIN DYNAMICS (ONLINE):
    % Purpose of this Logical Instance: to simulate the Drivetrain Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option03f3 = 1), a One-Mass Model written
    % in terms of the low-speed shaft is assumed. This model considers 
    % all the blades and the shaft as an inertia and a shock absorber that 
    % brings the entire friction and amortization system, the transmission 
    % shaft is considered rigid. See details in Tahiri (2017).


         %######## ONE-MASS MODEL (Low Speed) %########    


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseOmegaR_Ddot = 'Process noise of rotor shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaR_Ddot = s.WhiteNoiseP_OmegaR_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaR_Ddot)]));
    who.PNoiseOmegaG_Ddot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaG_Ddot = s.WhiteNoiseP_OmegaG_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaG_Ddot)]));
    who.PNoiseTa_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.PNoiseTa_Dot = s.WhiteNoiseP_Ta_Dot(randi([1, numel(s.WhiteNoiseP_Ta_Dot)]));  
              
    % Comparison tests
    if (s.Option05f1 == 1) 
        s.PNoiseOmegaR_Ddot = s.PNoiseOmegaR_Ddot_comp(it);    
    end

    
    % ------------ Dynamics of the Low-Speed Shaft ------------
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = max( s.y(4) , min(s.OmegaR_op) ); 

    who.OmegaR_dot = 'Rotor acceleration (drive train dynamics), in [rad/s^2].';
    s.OmegaR_dot = ( s.Ta - ( s.CCdt*s.OmegaR ) - s.Tg )*(1/s.J_t) + s.PNoiseOmegaR_Ddot ;

    
    % ------------ Dynamics of High-Speed Shaft -------------        
    who.OmegaG= 'Generator speed, in [rad/s].';
    s.OmegaG = max( s.y(5) , s.eta_gb*min(s.OmegaR_op) );

    who.OmegaG_dot = 'Generator acceleration (drive train dynamics), in [rad/s^2].';
    s.OmegaG_dot = s.eta_gb*s.OmegaR_dot ;


    % ------ Dynamics of Deformation on the Low Speed ​​Shaft ---------       
    who.Tls= 'Low speed shaft resistance torque, in [N.m].';
    s.Tls = 0;          
    who.Tls_dot = 'Low-Speed Shaft Torque Rate, in [N.m].';
    s.Tls_dot = 0;
        % Note: It will not be used in modeling, but will be used in the
        % Simulation Integrator only to maintain the fixed implementation 
        % of state variables.


    % ---------- Updating the last calculated values ----------
    s.OmegaR_before = s.OmegaR ;
    s.OmegaG_before = s.OmegaG ;
    s.Ta_dot = 0 + s.PNoiseTa_Dot ; % Random Walk Model (for the purpose of analyzing this model)
    s.Ta_RWM = s.y(27) ; 

    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(4) = s.OmegaR_dot;
    s.dy(5) = s.OmegaG_dot;
    s.dy(6) = s.Tls_dot; 
    s.dy(27) = s.Ta_dot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % DRIVE TRAIN DYNAMICS (ONLINE):
    % Purpose of this Logical Instance: to simulate the Drivetrain Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option03f3 = 2), a One-Mass Model written
    % in terms of the high-speed shaft is assumed. This model considers 
    % all the blades and the shaft as an inertia and a shock absorber that 
    % brings the entire friction and amortization system, the transmission 
    % shaft is considered rigid. See details in Tahiri (2017) and it is 
    % the same model that is adopted in the works of Abbas (2020/2021) 
    % and Jonkman (2009).    


         %######## ONE-MASS MODEL (High Speed) %########


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseOmegaR_Ddot = 'Process noise of rotor shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaR_Ddot = s.WhiteNoiseP_OmegaR_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaR_Ddot)]));
    who.PNoiseOmegaG_Ddot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaG_Ddot = s.WhiteNoiseP_OmegaG_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaG_Ddot)]));
    who.PNoiseTa_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.PNoiseTa_Dot = s.WhiteNoiseP_Ta_Dot(randi([1, numel(s.WhiteNoiseP_Ta_Dot)]));  
       
    % ------------ Dynamics of High-Speed Shaft -------------    
    who.OmegaG= 'Generator speed, in [rad/s].';        
    s.OmegaG = max( s.y(5) , s.eta_gb*min(s.OmegaR_op) );

    who.OmegaG_dot = 'Generator acceleration (drive train dynamics), in [rad/s^2].';
    s.OmegaG_dot = ( s.Ta - s.eta_gb*s.Tg  )*(s.eta_gb/s.J_r) + s.PNoiseOmegaG_Ddot ;
                      
       % NOTE: Abbas (2022) changed his model, compared to the works of (2020) and
         % (2021), adding electrical efficiency in the term "s.eta_gb*s.Tg". 
         %    In this code we will not adopt this approach.


    % ------------ Dynamics of the Low-Speed Shaft ------------
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = max( s.y(4) , min(s.OmegaR_op) ) ; 

    who.OmegaR_dot = 'Rotor acceleration (drive train dynamics), in [rad/s^2].';
    s.OmegaR_dot = s.OmegaG/s.eta_gb ;



    % ------ Dynamics of Deformation on the Low Speed ​​Shaft ---------       
    who.Tls= 'Low speed shaft resistance torque, in [N.m].';
    s.Tls = 0;    
    who.Tls_dot = 'Low-Speed Shaft Torque Rate, in [N.m].';
    s.Tls_dot = 0;
        % Note: It will not be used in modeling, but will be used in the
        % Simulation Integrator only to maintain the fixed implementation 
        % of state variables.


    % ---------- Updating the last calculated values ----------
    s.OmegaR_before = s.OmegaR ;
    s.OmegaG_before = s.OmegaG ;
    s.Ta_dot = 0 + s.PNoiseTa_Dot ; % Random Walk Model (for the purpose of analyzing this model)
    s.Ta_RWM = s.y(27) ;


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(4) = s.OmegaR_dot;
    s.dy(5) = s.OmegaG_dot;
    s.dy(6) = s.Tls_dot; 
    s.dy(27) = s.Ta_dot;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % DRIVE TRAIN DYNAMICS (ONLINE):
    % Purpose of this Logical Instance: to simulate the Drivetrain Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option03f3 = 3), a Two-Mass Model written 
    % in terms of high and low speed shafts is assumed. This model considers
    % that the first mass describes the deformation of the low-speed shaft
    % and the second mass describes the vibrational behavior of the
    % low-speed shaft.


         %######## TWO-MASS MODEL (flexible shaft) %########


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseOmegaR_Ddot = 'Process noise of rotor shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaR_Ddot = s.WhiteNoiseP_OmegaR_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaR_Ddot)]));
    who.PNoiseOmegaG_Ddot = 'Process noise of generator shaft dynamics, in [rad/s^2]';
    s.PNoiseOmegaG_Ddot = s.WhiteNoiseP_OmegaG_Ddot(randi([1, numel(s.WhiteNoiseP_OmegaG_Ddot)]));
    who.PNoiseTa_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.PNoiseTa_Dot = s.WhiteNoiseP_Ta_Dot(randi([1, numel(s.WhiteNoiseP_Ta_Dot)]));    
    
        
    % ------------ Dynamics of the Low-Speed Shaft ------------ 
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = max( s.y(4) , min(s.OmegaR_op) ) ; 

    who.OmegaR_dot = 'Rotor acceleration, in [rad/s^2].';
    s.OmegaR_dot = ( ( s.Ta - ( s.CC_r*s.OmegaR ) - s.Tls )*(1/s.J_r) ) + s.PNoiseOmegaR_Ddot  ;


    % ------------ Dynamics of High-Speed Shaft -------------   
    who.OmegaG= 'Generator speed, in [rad/s].';
    s.OmegaG = max( s.y(5) , s.eta_gb*min(s.OmegaR_op) ) ;

    who.OmegaG_dot = 'Generator acceleration (drive train dynamics), in [rad/s^2].';
    s.OmegaG_dot = ( (1/s.eta_gb)*s.Tls - ( s.CC_g*s.OmegaG ) - s.Tg  )*(1/s.J_g) + s.PNoiseOmegaG_Ddot ;

    
    % ------ Dynamics of Deformation on the Low Speed ​​Shaft ---------       
    who.Tls= 'Low speed shaft resistance torque, in [N.m].';
    s.Tls = s.y(6);         

    who.Tls_dot = 'Low-Speed Shaft Torque Rate, in [N.m].';
    s.Tls_dot = (s.CC_ls/s.J_r)*s.Ta + ( s.CC_ls/(s.eta_gb*s.J_g) )*s.Tg - ( (s.J_r + (s.eta_gb*s.J_g))/(s.eta_gb^2*s.J_r*s.J_g) )*s.KK_ls*s.Tls + ( ((s.CC_ls*s.CC_g)/(s.eta_gb*s.J_g)) + (s.KK_ls/s.eta_gb) )*s.OmegaG + ( (s.KK_ls - (s.CC_ls*s.CC_r) )/s.J_r )*s.OmegaR + s.PNoiseTa_Dot;
    

    % ---------- Updating the last calculated values ----------
    s.OmegaR_before = s.OmegaR ;
    s.OmegaG_before = s.OmegaG ;
    s.Ta_dot = 0 + s.PNoiseTa_Dot ; % Random Walk Model (for the purpose of analyzing this model)
    s.Ta_RWM = s.y(27) ;
    
    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(4) = s.OmegaR_dot;
    s.dy(5) = s.OmegaG_dot;
    s.dy(6) = s.Tls_dot; 
    s.dy(27) = s.Ta_dot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % POWER GENERATION/ENERGY CONVERTER (ONLINE):    
    % Purpose of this Logical Instance: to simulate the Power Generation
    % system. In this Logical Instance, it is assumed that the dynamics 
    % of the system are based on the dynamics adopted for the Generator
    % Torque, therefore, this function only performs calculations 
    % resulting from the dynamics of the Generator Torque and the Drive Train.


    % ----- Receiving other values ​​from Sensors and wind turbine subsystems ----
    who.Tg = 'Generator Torque, in [N.m]';
    PowerGeneration.Tg(it) = s.Tg;    
    who.OmegaG= 'Generator speed, in [rad/s].';
    PowerGeneration.OmegaG(it) = s.OmegaG;

    
    % ---------- Actual Lost Mechanical Power ----------    
    who.Pmec_loss = 'Actual Lost Mechanical Power, in [W].';
    s.Pmec_loss = s.CCdt*s.OmegaR^2;      

    % ---------- Actual Total Mechanical Power ----------    
    who.Pmec = 'Actual Total Mechanical Power, in [W].';
    s.Pmec = s.Pa - s.Pmec_loss;

    % ---------- Output Electrical Power (steady state) ----------    
    who.Pe_SteadyState= 'Output Electrical Power (steady state), in [W]. Idealized value to be output at the output of the electrical converter, based on electrical efficiency.';
    s.Pe_SteadyState = interp1(s.Vop, s.Pe_op , s.Vews);   
    s.Pe_SteadyState(s.Pe_SteadyState==0) = 0.001;  

    % ---------- Actual Electrical Power (Active power) ----------
    who.Pe = 'Actual electrical power (generator input), in [W].';
    s.Pe = max( (s.Tg / s.eta_gb) * s.OmegaG , 0 ) ;
        % NOTE: Active power is the useful energy that is actually 
        % delivered to the electrical grid for consumption


    % ---------- Actual Reactive Power ----------    
    who.Pfactor = 'Power Factor.';
    s.Pfactor = 1.1/sqrt(2) ; % s.Pfactor > (1/sqrt(2))
    who.Theta_pe = 'Phase angle theta, in [rad].';
    s.Theta_pe = acos(s.Pfactor) ;
    who.Pe_Reactive = 'Actual Reactive Power.';
    s.Pe_Reactive = s.Pe * tan(s.Theta_pe) ; 
        % NOTE: Reactive power represents the energy that does not perform 
        % useful work, but which circulates between the generator and the
        % grid to maintain stable voltage.


    % ---------- Actual Energy Capture Efficiency ----------    
    who.eta_cap = 'Actual Energy Capture Efficiency, in [W].';
    s.Pa(s.Pa == 0) = 0.001;    
    s.eta_cap = s.Pe/s.Pa;


    % ---------- Actual Electrical Efficiency of the Converter/Power Generation ----------    
    who.eta_elect = 'Actual Efficiency of Energy Generation, in [W].';
    s.eta_elect = s.Pe/s.Pe_SteadyState;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'PowerGeneration', PowerGeneration);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_12')    
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % TOWER DYNAMICS (ONLINE):    
    % Purpose of this Logical Instance: to simulate the Tower Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option04f3 = 1), the dynamics of the 
    % Fore-Aft movement of the top of the tower are assumed. This Logical 
    % Instance is for cases considering a vibration problem of an
    % ONSHORE wind turbine.


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseXt_Ddot = 'Process noise of the tower dynamics, in [rad/s^2]';
    s.PNoiseXt_Ddot = s.WhiteNoiseP_Xt_Ddot(randi([1, numel(s.WhiteNoiseP_Xt_Ddot)]));

    % ---------- Tower-Bending Fore–Aft direction (Tower Dynamics) ----------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [rad]';
    s.Xt = s.y(7); 

    who.Xt_dot = 'Tower-top velocity in the Fore–Aft direction, in [rad/s].';
    s.Xt_dot = s.y(8); 
    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [rad/s^2]';
    s.Xt_Ddot = (  (1/s.Jxt)*s.Fa - (s.CCxt/s.Jxt)*s.Xt_dot - (s.KKxt/s.Jxt)*s.Xt + s.PNoiseXt_Ddot  ); 

    
    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(7) = s.Xt_dot;
    s.dy(8) = s.Xt_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'TowerDynamics', TowerDynamics);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_13')    
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % TOWER DYNAMICS (ONLINE):    
    % Purpose of this Logical Instance: to simulate the Tower Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option04f3 = 1), the dynamics of the 
    % Fore-Aft movement of the top of the tower are assumed. This Logical
    % Instance is for cases that considers the relationship between the
    % movements of the platform of an OFFSHORE wind turbine and the movement
    % (fore-aft) of the top of the tower.


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseXt_Ddot = 'Process noise of the tower dynamics, in [rad/s^2]';
    s.PNoiseXt_Ddot = s.WhiteNoiseP_Xt_Ddot(randi([1, numel(s.WhiteNoiseP_Xt_Ddot)]));


    % ---------- Receiving values ​​from the offshore assembly  ----------  
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    TowerDynamics.Surge = s.Surge ; 
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    TowerDynamics.Surge_dot = s.Surge_dot ;   
    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    TowerDynamics.Surge_Ddot = s.Surge_Ddot ;  
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    TowerDynamics.Sway = s.Sway ; 
    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    TowerDynamics.Sway_dot  = s.Sway_dot ;     
    who.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    TowerDynamics.Sway_Ddot = s.Sway_Ddot ;    
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    TowerDynamics.Heave = s.Heave ; 
    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    TowerDynamics.Heave_dot = s.Heave_dot ; 
    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    TowerDynamics.Heave_Ddot = s.Heave_Ddot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    TowerDynamics.RollAngle = s.RollAngle ; 
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    TowerDynamics.RollAngle_dot  = s.RollAngle_dot ; 
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad].';
    TowerDynamics.PitchAngle = s.PitchAngle ; 
    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    TowerDynamics.PitchAngle_dot = s.PitchAngle_dot ;  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    TowerDynamics.YawAngle = s.YawAngle ; 
    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    TowerDynamics.YawAngle_dot  = s.YawAngle_dot ; 

    who.MomentArmPlatform = 'Moment arm applied by the platform at the top of the tower, in [m].';
    TowerDynamics.MomentArmPlatform = s.MomentArmPlatform ;        
    who.C_Hydrostatic = 'The Hydrostatic restoring in DOF considered, in [N.m]';
    TowerDynamics.C_Hydrostatic(it) = OffshoreAssembly.C_Hydrostatic; 
    who.C_Lines = 'The linearized hydrostatic restoring in DOF considered from all mooring lines, in [N.m]';
    TowerDynamics.C_Lines(it) = OffshoreAssembly.C_Lines;   
    who.B_Radiation = 'The damping associated with hydrodynamic radiation in DOF considered, in [N.s.m]';
    TowerDynamics.B_Radiation(it) = OffshoreAssembly.B_Radiation; 
    who.B_Viscous = 'The linearized damping associated with hydrodynamic viscous drag in DOF considered, in [N.s.m]';
    TowerDynamics.B_Viscous(it) = OffshoreAssembly.B_Viscous; 
    who.I_mass = 'The total inertial in all DOF considered and associated with wind turbine and offshore assembly mass, in [kg*m^2]';
    TowerDynamics.I_mass(it) = OffshoreAssembly.I_mass; 
    who.A_Radiation = 'The added inertia (added mass) associated with hydrodynamic radiation in DOF considered, in [kg*m^2]';
    TowerDynamics.A_Radiation(it) = OffshoreAssembly.A_Radiation;       


    % ---------- Parameters Calculation ----------
    who.M_offshore = 'Stiffness coefficient for tower dynamics, in [kg].';
    s.M_offshore = (s.I_mass + s.A_Radiation) / s.MomentArmPlatform^2; 

    who.K_offshore = 'Stiffness coefficient for tower dynamics, in [N/m].';
    s.K_offshore = (s.C_Hydrostatic + s.C_Lines) / s.MomentArmPlatform^2; 

    who.C_offshore = 'Damping coefficient for tower dynamics, in [Ns/m].';
    s.C_offshore = (s.B_Radiation + s.B_Viscous) / s.MomentArmPlatform^2;


    % ---------- Tower-Bending Fore–Aft direction (Tower Dynamics) ----------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.y(7); 

    who.Xt_dot = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot = s.y(8); 

    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = (  (1/s.M_offshore) * s.Fa - (s.C_offshore/s.M_offshore) * s.Xt_dot - (s.K_offshore/s.M_offshore) * s.Xt + s.PNoiseXt_Ddot  );

    
    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(7) = s.Xt_dot;
    s.dy(8) = s.Xt_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput); 
    assignin('base', 'TowerDynamics', TowerDynamics);
    

    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_14')    
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % TOWER DYNAMICS (ONLINE):    
    % Purpose of this Logical Instance: to simulate the Tower Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option04f3 = 2), it does NOT consider the
    % dynamics of the tower (vibration problem and dynamic analysis) and 
    % only the kinematics of the movement of the top of the tower is considered.
    % The movement of the top of the tower is given only by the movement 
    % relationships of the platform.


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseXt_Ddot = 'Process noise of the tower dynamics, in [rad/s^2]';
    s.PNoiseXt_Ddot = s.WhiteNoiseP_Xt_Ddot(randi([1, numel(s.WhiteNoiseP_Xt_Ddot)]));

    
    % ---------- Tower-Bending Fore–Aft direction (Tower Dynamics)  ----------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;
    %

    who.Xt_dot = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot;
    %

    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot;
    %



    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(7) = s.Xt_dot;
    s.dy(8) = s.Xt_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_15')
%==================== LOGICAL INSTANCE 15 ====================
%=============================================================    
    % BLADE DYNAMICS (ONLINE):
    % Purpose of this Logic Instance: to simulate the Blade Dynamics,
    % according to the options chosen in logical instance 01 of this file.
    % In this Logical Instance (s.Option05f3 = 1), only the blade bending 
    % dynamics of the translational displacement of the blade tip are 
    % assumed (the flap-wise blade bending), where the bending stiffness
    % parameters are transformed into equivalent translational stiffness
    % parameters, as presented by Simanni (2015).
   

    % ---------- Blade Dynamics: Blade bending (blade tip displacement) ----------
    who.zetaB = 'Angular displacement out of the plane of rotation, in [rad]';
    s.zetaB = s.y(9) ;

    who.zetaB_dot = 'Angular velocity out of the plane of rotation, in [rad/s]';
    s.zetaB_dot = s.y(10) ;

    who.zetaB_Ddot = 'Angular acceleration out of the plane of rotation, in [rad/s^2]';
    s.zetaB_Ddot = (1/s.JJb)*s.Fa - (s.CCb/s.JJb)*s.zetaB_dot - (s.KKb/s.JJb)*s.zetaB;


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(9) = s.zetaB_dot;
    s.dy(10) = s.zetaB_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to " WindTurbine('logical_instance_06')"  


elseif strcmp(action, 'logical_instance_16')
%==================== LOGICAL INSTANCE 16 ====================
%=============================================================    
    % HUB/ROTOR DYNAMICS (ONLINE):
    % Purpose of this Logic Instance: to simulate the Hub dynamics 
    % (rotor dynamics), generally applied in small wind turbines, 
    % according to the options chosen in logical instance 01 of this file.
    % The dynamics that can be implemented in the future are: 
    % (1) Rotor inclination (Rotor-Teeter);
    % (2) Rotor furling (Rotor-Furl); and
    % (3) Tail inclination.  


    % ---------- Rotor-Teeter Dynamics----------
    who.RotorTeeter = 'Rotor inclination (Rotor-Teeter).';
    s.RotorTeeter = s.y(11);

    who.RotorTeeter_dot = 'Rotor inclination (Rotor-Teeter) velocity/rate.';
    s.RotorTeeter_dot = 0; 



    % ---------- Rotor-Furl Dynamics----------
    who.RotorFurl = 'Rotor inclination (Rotor-Teeter).';      
    s.RotorFurl = s.y(12);

    who.RotorFurl_dot = 'Rotor inclination (Rotor-Teeter) velocity/rate.';
    s.RotorFurl_dot = 0; 


    % ---------- Rotor-Tail Dynamics----------
    who.RotorTail = 'Rotor inclination (Rotor-Teeter).';
    s.RotorTail = s.y(13);

    who.RotorTail_dot = 'Rotor inclination (Rotor-Teeter) velocity/rate.';
    s.RotorTail_dot = 0; 


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(17) = s.RotorTeeter_dot ;
    s.dy(18) = s.RotorFurl_dot ;
    s.dy(19) = s.RotorTail_dot ;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to " WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_17')
%==================== LOGICAL INSTANCE 17 ====================
%=============================================================    
    % NACELLE DYNAMICS (ONLINE):
    % Purpose of this Logical Instance: to simulate the Nacelle dynamics,
    % according to the options chosen in Logical Instance 01 of this file.
    % In this Logical Instance (s.Option07f3 = 1), only the nacelle 
    % dynamics, which rotates the nacelle to align the rotor with the
    % wind directions, are simulated. The option s.Option07f3 = 2 considers 
    % that the rotor is always aligned with the wind direction.


    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseThetaYaw_dot = 'Process standard deviation for the dynamics of Yaw angle (rotation around the tower), in [rad/s^2].';
    s.PNoiseThetaYaw_dot = s.WhiteNoiseP_ThetaYaw_dot(randi([1, numel(s.WhiteNoiseP_ThetaYaw_dot)]));    


    % ---------- Receiving reference from Yaw Controller ----------
    who.ThetaYaw = 'Yaw angle, in [rad].';
    s.ThetaYaw_ref = s.y(14); %  s.ThetaYaw_ref = s.ThetaYaw_d ;


    % ---------- Yaw Dynamics ----------
    who.ThetaYaw = 'Yaw angle, in [rad].';
    s.ThetaYaw = s.y(14);
    
    who.ThetaYaw_dot = 'Yaw Dynamics: Yaw angular velocity, in [rad/s].';
    s.ThetaYaw_dot = (s.ThetaYaw_ref - s.ThetaYaw)/s.tau_Yaw + s.PNoiseThetaYaw_dot;


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(20) = s.ThetaYaw_dot ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to " WindTurbine('logical_instance_06')"     
      
 
elseif strcmp(action, 'logical_instance_18')
%==================== LOGICAL INSTANCE 18 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to save current values, based on 
    % the last integration step taken.

    % Organizing output results


    % ---------- LOGICAL INSTANCE 03  ----------
    if s.Option01f3 == 1
        %   NOT consider the Blade Pitch dynamics, assuming that the 
        % blade pitch as relatively fast (Beta = Beta_d)        
        BladePitchSystem.PNoiseBeta_Dot(it) = s.PNoiseBeta_Dot;  
        BladePitchSystem.Beta(it) = s.Beta; BladePitchSystem.Beta_dot(it) = s.Beta_dot; BladePitchSystem.Beta_Ddot(it) = s.Beta_Ddot; BladePitchSystem.Beta_before(it) = s.Beta_before;
        WindTurbineOutput.Beta(it) = s.Beta; WindTurbineOutput.Beta_dot(it) = s.Beta_dot; WindTurbineOutput.Beta_Ddot(it) = s.Beta_Ddot;
        %
    end


    % ---------- LOGICAL INSTANCE 04  ----------
    if s.Option01f3 == 2
        % Electromechanical Blade Pitch Systems (first-order model - delay behavior)
        BladePitchSystem.PNoiseBeta_Dot(it) = s.PNoiseBeta_Dot;  
        BladePitchSystem.Beta(it) = s.Beta; BladePitchSystem.Beta_dot(it) = s.Beta_dot; BladePitchSystem.Beta_Ddot(it) = s.Beta_Ddot; BladePitchSystem.Beta_before(it) = s.Beta_before;
        WindTurbineOutput.Beta(it) = s.Beta; WindTurbineOutput.Beta_dot(it) = s.Beta_dot; WindTurbineOutput.Beta_Ddot(it) = s.Beta_Ddot;
        %
    end


    % ---------- LOGICAL INSTANCE 05  ----------    
    if s.Option01f3 == 3
        % Hydraulic Blade Pitch Systems (second-order model - oscillatory behavior).
        BladePitchSystem.PNoiseBeta_Dot(it) = s.PNoiseBeta_Dot;
        BladePitchSystem.Beta(it) = s.Beta; BladePitchSystem.Beta_dot(it) = s.Beta_dot; BladePitchSystem.Beta_Ddot(it) = s.Beta_Ddot; BladePitchSystem.Beta_before(it) = s.Beta_before;
        WindTurbineOutput.Beta(it) = s.Beta; WindTurbineOutput.Beta_dot(it) = s.Beta_dot; WindTurbineOutput.Beta_Ddot(it) = s.Beta_Ddot;
        %
    end


    % ---------- LOGICAL INSTANCE 06  ----------
    if s.Option02f3 == 1
        %   NOT consider the Geneerator Torque dynamics, assuming that the 
        % generator torque as relatively fast (Tg = Tg_d)        
        GeneratorTorqueSystem.Tg(it) = s.Tg; GeneratorTorqueSystem.Tg_dot(it) = s.Tg_dot; GeneratorTorqueSystem.PNoiseTg_Dot(it) = s.PNoiseTg_Dot; GeneratorTorqueSystem.Tg_before(it) = s.Tg_before ;
        WindTurbineOutput.Tg(it) = s.Tg; WindTurbineOutput.Tg_dot(it) = s.Tg_dot;
        %
    end


    % ---------- LOGICAL INSTANCE 07  ---------- 
    if s.Option02f3 == 2
        % Generator/Converter Dynamics (first-order model - delay behavior)
        GeneratorTorqueSystem.Tg(it) = s.Tg; GeneratorTorqueSystem.Tg_dot(it) = s.Tg_dot; GeneratorTorqueSystem.PNoiseTg_Dot(it) = s.PNoiseTg_Dot; 
        WindTurbineOutput.Tg(it) = s.Tg; WindTurbineOutput.Tg_dot(it) = s.Tg_dot;
        %
    end



    % ---------- LOGICAL INSTANCE 08  ----------    
    if s.Option03f3 == 1
        % One-Mass Model (Low Speed)
        DriveTrainDynamics.PNoiseOmegaR_Ddot(it) = s.PNoiseOmegaR_Ddot; DriveTrainDynamics.PNoiseOmegaG_Ddot(it) = s.PNoiseOmegaG_Ddot; DriveTrainDynamics.PNoiseTa_Dot(it) = s.PNoiseTa_Dot;  
        DriveTrainDynamics.OmegaR(it) = s.OmegaR; DriveTrainDynamics.OmegaR_dot(it) = s.OmegaR_dot; DriveTrainDynamics.OmegaG(it) = s.OmegaG; DriveTrainDynamics.OmegaG_dot(it) = s.OmegaG_dot; DriveTrainDynamics.Tls(it) = s.Tls; DriveTrainDynamics.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.OmegaR(it) = s.OmegaR; WindTurbineOutput.OmegaR_dot(it) = s.OmegaR_dot; WindTurbineOutput.OmegaG(it) = s.OmegaG; WindTurbineOutput.OmegaG_dot(it) = s.OmegaG_dot; WindTurbineOutput.Tls(it) = s.Tls; WindTurbineOutput.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.Ta_RWM(it) = s.Ta_RWM;        
        %
    end


    % ---------- LOGICAL INSTANCE 09  ----------
    if s.Option03f3 == 2
        % One-Mass Model (High Speed)
        DriveTrainDynamics.PNoiseOmegaR_Ddot(it) = s.PNoiseOmegaR_Ddot; DriveTrainDynamics.PNoiseOmegaG_Ddot(it) = s.PNoiseOmegaG_Ddot; DriveTrainDynamics.PNoiseTa_Dot(it) = s.PNoiseTa_Dot;  
        DriveTrainDynamics.OmegaR(it) = s.OmegaR; DriveTrainDynamics.OmegaR_dot(it) = s.OmegaR_dot; DriveTrainDynamics.OmegaG(it) = s.OmegaG; DriveTrainDynamics.OmegaG_dot(it) = s.OmegaG_dot; DriveTrainDynamics.Tls(it) = s.Tls; DriveTrainDynamics.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.OmegaR(it) = s.OmegaR; WindTurbineOutput.OmegaR_dot(it) = s.OmegaR_dot; WindTurbineOutput.OmegaG(it) = s.OmegaG; WindTurbineOutput.OmegaG_dot(it) = s.OmegaG_dot; WindTurbineOutput.Tls(it) = s.Tls; WindTurbineOutput.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.Ta_RWM(it) = s.Ta_RWM;        
        %
    end


    % ---------- LOGICAL INSTANCE 10  ----------  
    if s.Option03f3 == 3
        % Two-Mass Model (Low and High Speeds shaft)
        DriveTrainDynamics.PNoiseOmegaR_Ddot(it) = s.PNoiseOmegaR_Ddot; DriveTrainDynamics.PNoiseOmegaG_Ddot(it) = s.PNoiseOmegaG_Ddot; DriveTrainDynamics.PNoiseTa_Dot(it) = s.PNoiseTa_Dot;  
        DriveTrainDynamics.OmegaR(it) = s.OmegaR; DriveTrainDynamics.OmegaR_dot(it) = s.OmegaR_dot; DriveTrainDynamics.OmegaG(it) = s.OmegaG; DriveTrainDynamics.OmegaG_dot(it) = s.OmegaG_dot; DriveTrainDynamics.Tls(it) = s.Tls; DriveTrainDynamics.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.OmegaR(it) = s.OmegaR; WindTurbineOutput.OmegaR_dot(it) = s.OmegaR_dot; WindTurbineOutput.OmegaG(it) = s.OmegaG; WindTurbineOutput.OmegaG_dot(it) = s.OmegaG_dot; WindTurbineOutput.Tls(it) = s.Tls; WindTurbineOutput.Tls_dot(it) = s.Tls_dot;
        WindTurbineOutput.Ta_RWM(it) = s.Ta_RWM;
        %
    end



    % ---------- LOGICAL INSTANCE 11  ----------
    PowerGeneration.Pe(it) = s.Pe; PowerGeneration.Pmec_loss(it) = s.Pmec_loss; PowerGeneration.Pmec(it) = s.Pmec; PowerGeneration.eta_elect(it) = s.eta_elect; PowerGeneration.eta_cap(it) = s.eta_cap; PowerGeneration.Pe_SteadyState(it) = s.Pe_SteadyState;
    PowerGeneration.Pfactor = s.Pfactor; PowerGeneration.Theta_pe = s.Theta_pe; PowerGeneration.Pe_Reactive = s.Pe_Reactive;
    %

    

    % ---------- LOGICAL INSTANCE 12  ----------
    if s.Option02f2 == 1 && s.Option04f3 == 1
        % Consider the ONSHORE WIND TURBINE
        TowerDynamics.PNoiseXt_Ddot(it) = s.PNoiseXt_Ddot;
        TowerDynamics.Xt(it) = s.Xt; TowerDynamics.Xt_dot(it) = s.Xt_dot; TowerDynamics.Xt_Ddot(it) = s.Xt_Ddot;
        WindTurbineOutput.Xt(it) = s.Xt; WindTurbineOutput.Xt_dot(it) = s.Xt_dot; WindTurbineOutput.Xt_Ddot(it) = s.Xt_Ddot;
        %
    end


    % ---------- LOGICAL INSTANCE 13  ----------  
    if s.Option02f2 == 2 || s.Option02f2 == 3 || s.Option02f2 == 4 || s.Option02f2 == 5 || s.Option02f2 == 6
        % Consider the OFFSHORE WIND TURBINE
        if s.Option04f3 == 1
            % Tower Dynamics (fore-aft movement)
            TowerDynamics.PNoiseXt_Ddot(it) = s.PNoiseXt_Ddot;
            TowerDynamics.K_offshore(it) = s.K_offshore; 
            TowerDynamics.C_offshore(it) = s.C_offshore; 
            TowerDynamics.Xt(it) = s.Xt; TowerDynamics.Xt_dot(it) = s.Xt_dot; TowerDynamics.Xt_Ddot(it) = s.Xt_Ddot;
            WindTurbineOutput.Xt(it) = s.Xt; WindTurbineOutput.Xt_dot(it) = s.Xt_dot; WindTurbineOutput.Xt_Ddot(it) = s.Xt_Ddot;
            TowerDynamics.M_offshore(it) = s.M_offshore; TowerDynamics.K_offshore(it) = s.K_offshore; TowerDynamics.C_offshore(it) = s.C_offshore;
            %
        end
        %
    end


    % ---------- LOGICAL INSTANCE 14  ----------
    if s.Option02f2 == 2 || s.Option02f2 == 3 || s.Option02f2 == 4 || s.Option02f2 == 5 || s.Option02f2 == 6
        % Consider the OFFSHORE WIND TURBINE
        if s.Option04f3 == 2
            % Only Kinematics of the movement of the top of the tower
            TowerDynamics.PNoiseXt_Ddot(it) = s.PNoiseXt_Ddot;
            TowerDynamics.Xt(it) = s.Xt; TowerDynamics.Xt_dot(it) = s.Xt_dot; TowerDynamics.Xt_Ddot(it) = s.Xt_Ddot;
            WindTurbineOutput.Xt(it) = s.Xt; WindTurbineOutput.Xt_dot(it) = s.Xt_dot; WindTurbineOutput.Xt_Ddot(it) = s.Xt_Ddot;
            TowerDynamics.MomentArmPlatform = s.MomentArmPlatform;
            % TowerDynamics.M_offshore(it) = s.M_offshore; TowerDynamics.K_offshore(it) = s.K_offshore; TowerDynamics.C_offshore(it) = s.C_offshore;
            %
        end
        %
    end


    % ---------- LOGICAL INSTANCE 15  ----------  
    if s.Option05f3 == 1
        % Blade Dynamics (flap-wise blade bending)
        RotorDynamics.zetaB(it) = s.zetaB; RotorDynamics.zetaB_dot(it) = s.zetaB_dot; RotorDynamics.zetaB_Ddot(it) = s.zetaB_Ddot;
        WindTurbineOutput.zetaB(it) = s.zetaB; WindTurbineOutput.zetaB_dot(it) = s.zetaB_dot; WindTurbineOutput.zetaB_Ddot(it) = s.zetaB_Ddot;
        %
    end


    % ---------- LOGICAL INSTANCE 16  ----------
    if s.Option06f3 == 1
        % Hub/Rotor Dynamics (rotor-teeter, rotor-furl, tail inclination, and furling action)
        RotorDynamics.RotorTeeter(it) = s.RotorTeeter; RotorDynamics.RotorTeeter_dot = s.RotorTeeter_dot; 
        RotorDynamics.RotorFurl(it) = s.RotorFurl; RotorDynamics.RotorFurl_dot = s.RotorFurl_dot;
        RotorDynamics.RotorTail(it) = s.RotorTail; RotorDynamics.RotorTail_dot = s.RotorTail_dot; 
        WindTurbineOutput.RotorTeeter(it) = s.RotorTeeter; WindTurbineOutput.RotorTeeter_dot = s.RotorTeeter_dot; 
        WindTurbineOutput.RotorFurl(it) = s.RotorFurl; WindTurbineOutput.RotorFurl_dot = s.RotorFurl_dot;
        WindTurbineOutput.RotorTail(it) = s.RotorTail; WindTurbineOutput.RotorTail_dot = s.RotorTail_dot;
        %
    end


    % ---------- LOGICAL INSTANCE 17  ---------- 
    if s.Option07f3 == 1
        % Nacelle Dynamics (assuming that the nacelle is rotated to align the rotor with the wind direction)
        NacelleDynamics.ThetaYaw(it) = s.ThetaYaw; NacelleDynamics.s.PNoiseThetaYaw_dot(it) = s.PNoiseThetaYaw_dot; 
        WindTurbineOutput.ThetaYaw(it) = s.ThetaYaw; WindTurbineOutput.s.PNoiseThetaYaw_dot(it) = s.PNoiseThetaYaw_dot;
        %
    end


    % Returns to " EnviromentSimulation('logical_instance_03')"     


elseif strcmp(action, 'logical_instance_19')
%==================== LOGICAL INSTANCE 19 ====================
%=============================================================    
    % PLOT MAIN ASSEEMBLY DYNAMICS RESULTS (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % dynamics of main assemble and develop any other calculations, tables and data to 
    % support the analysis of the results.


    % ---------- Plot Actual Effective Wind Speed ----------  
    if s.Option08f3 == 3
        figure()     
        plot(s.Time,s.Vews)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Vews [m/s]', 'Interpreter', 'latex')
        ylim([0.95*min(s.Vews) 1.05*max(s.Vews)])        
        legend('Actual Effective Wind Speed [m/s]', 'Interpreter', 'latex')
        title('Actual Effective Wind Speed over time.')
        %    
    end



    % ---------- Plot Blade Pitch System Dynamics ----------
    betamin_plot = min(s.Beta);
    if betamin_plot == 0
        betamin_plot = -0.5;
    end
    betamax_plot = max(s.Beta);
    if betamax_plot == 0
        betamax_plot = 0.5;
    end    
    figure()     
    plot(s.Time, s.Beta)
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\beta}$ [deg]', 'Interpreter', 'latex') 
    ylim([0.95 * min(betamin_plot) 1.05 * max(betamax_plot)])        
    legend('Actual Blade Pitch ${\beta}$ [deg]', 'Interpreter', 'latex') 
    title('Actual Collective Blade Pitch over time.', 'Interpreter', 'latex') 
    % 

    set(groot, 'defaultTextInterpreter', 'latex')
    figure()     
    plot(s.Time, s.Beta_dot)
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('$\dot{\beta}$ [rad/s]', 'Interpreter', 'latex') 
    ylim([1.1 * min(-s.BetaDot_max) 1.1 * max(s.BetaDot_max)])        
    legend('$\dot{\beta}$ [rad/s]', 'Interpreter', 'latex') 
    title('Actual Rate Collective Blade Pitch over time.', 'Interpreter', 'latex')
    hold on
    yline(s.BetaDot_max, 'k--', 'Upper Limit', 'Interpreter', 'latex'); 
    yline(-s.BetaDot_max, 'k--', 'Lower Limit', 'Interpreter', 'latex');
    hold off
    %


    % ------- Plot Generator Torque System Dynamics----------
    figure()     
    plot(s.Time, s.Tg)
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('$T_{g}$ [N.m]', 'Interpreter', 'latex') 
    ylim([0.95 * min(s.Tg) 1.05 * max(s.Tg)])        
    legend('Actual Generator Torque $T_{g}$ [N.m]', 'Interpreter', 'latex') 
    title('Actual Generator Torque over time.', 'Interpreter', 'latex') 
    % 

    set(groot, 'defaultTextInterpreter', 'latex')
    figure()     
    plot(s.Time, s.Tg_dot)
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\dot{T}}_{g}$ [N.m/s]', 'Interpreter', 'latex') 
    ylim([1.1 * min(-s.TgDot_max*s.eta_gb) 1.1 * max(s.TgDot_max*s.eta_gb)])     
    legend('${\dot{T}}_{g}$ [N.m/s]', 'Interpreter', 'latex') 
    title('Actual Rate Generator Torque over time.', 'Interpreter', 'latex')
    hold on
    yline((s.TgDot_max*s.eta_gb), 'k--', 'Upper Limit', 'Interpreter', 'latex'); 
    yline(-(s.TgDot_max*s.eta_gb), 'k--', 'Lower Limit', 'Interpreter', 'latex');
    hold off
    %

    
    % ----- Plot Generator Power Converter System ----------
    if s.Option08f3 == 3
        figure()     
        plot(s.Time, s.Pe,'r',s.Time, s.Pe_SteadyState,'k',s.Time, s.Pmec,'b')
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('$P_{e}$ [W]', 'Interpreter', 'latex') 
        ylim([0.95 * min([s.Pe s.Pe_SteadyState s.Pmec]) 1.05 * max([s.Pe s.Pe_SteadyState s.Pmec])])        
        legend('Actual Generator Power $P_{e}$ [W]','Generator Power in Steady-State $Pe{op}$ [W]','Mechanical Power $P{mec}$ [W]', 'Interpreter', 'latex') 
        title('Comparison of real and theoretical electrical power with mechanical power in steady state over time.', 'Interpreter', 'latex') 
        %

        figure()     
        plot(s.Time, s.eta_elect,'r')
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('${\eta}_{elec}$', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.eta_elect) 1.05 * max(s.eta_elect)])        
        legend('Actual Electrical efficiency ${\eta}_{elec}$', 'Interpreter', 'latex') 
        title('Comparison of electrical efficiency over time.', 'Interpreter', 'latex') 
        % 

        figure()     
        plot(s.Time, s.eta_cap,'k')
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('${\eta}_{cap}$', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.eta_cap) 1.05 * max(s.eta_cap)])        
        legend('Aerodynamic capture efficiency ${\eta}_{cap}$', 'Interpreter', 'latex') 
        title('Comparison of aerodynamic capture efficiency over time.', 'Interpreter', 'latex') 
        % 
    end

    
    % ---------- Plot Driven-Train Dynamics ----------
    figure()     
    plot(s.Time, s.OmegaR)
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('$\Omega_R$ [rad/s]', 'Interpreter', 'latex') 
    ylim([0.95 * min(s.OmegaR) 1.05 * max(s.OmegaR)])        
    legend('Actual Rotor Speed $\Omega_R$ [rad/s]', 'Interpreter', 'latex') 
    title('Actual Rotor Speed over time.', 'Interpreter', 'latex') 
    % 

    if s.Option08f3 == 3
        figure()     
        plot(s.Time, s.OmegaG)
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('$\Omega_G$ [rad/s]', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.OmegaG) 1.05 * max(s.OmegaG)])        
        legend('Actual Generator Speed $\Omega_R$ [rad/s]', 'Interpreter', 'latex') 
        title('Actual Generator speed over time.', 'Interpreter', 'latex') 
        % 
    end

    if s.Option08f3 == 3
        figure()     
        plot(s.Time, s.Tls)
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('$T_{ls}$ [N.m]', 'Interpreter', 'latex') 
        ylim([0.95 * min([-1 s.Tls]) 1.05 * max(s.Tls)])        
        legend('Actual Low speed shaft resistance torque $T_{ls}$ [N.m]', 'Interpreter', 'latex') 
        title('Actual low speed shaft resistance torque over time.', 'Interpreter', 'latex') 
        % 
    end



    % ---- PSD analysis of drive train dynamics ------  
    if s.Option03f9 == 3
            % Effective Wind Speed
        who.fpVews_sim = 'Estimated Positive Frequency of the Actual Effective Wind Speed used in simulation.';
        who.PSDVews_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Effective Wind Speed used in simulation.';
        [s.PSDVews_sim, s.fpVews_sim] = pwelch( s.Vews, [], [], [], [] );
        s.fpVews_sim = s.fpVews_sim(2:end)';
        s.PSDVews_sim = s.PSDVews_sim(2:end)';
        s.FreqMax_est = max(s.fpVews_sim ) ;
        figure;
        loglog(s.fpVews_sim, s.PSDVews_sim, 'b', 'DisplayName', 'PSD of Actual Effective Wind Speed.');                   
        hold on;                        
        hold off;    
        title('Power Spectrum Density (PSD) Analysis of Actual Effective Wind Speed.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [$(m^s/s^2)*(1/Hz)$]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([0, (s.FreqMax_est)]);
        ylim([0.97*min(s.PSDVews_sim), 1.03*max(s.PSDVews_sim)]); 
        grid on;  
        legend('show');
        %

            % Rotor Speed
        who.fpOmegaR_sim = 'Estimated Positive Frequency of the Actual Rotor Speed used in simulation.';
        who.PSDOmegaR_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Rotor Speed used in simulation.';
        [s.PSDOmegaR_sim, s.fpOmegaR_sim] = pwelch( s.OmegaR, [], [], [], [] );
        s.fpOmegaR_sim = s.fpOmegaR_sim(2:end)';
        s.PSDOmegaR_sim = s.PSDOmegaR_sim(2:end)';
        s.FreqMax_est = max(s.fpOmegaR_sim ) ;
        figure;
        loglog(s.fpOmegaR_sim, s.PSDOmegaR_sim, 'b', 'DisplayName', 'PSD of Actual Rotor Speed.');                   
        hold on;                        
        hold off;    
        title('Power Spectrum Density (PSD) Analysis of Actual Rotor Speed.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [$(m^s/s^2)*(1/Hz)$]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([0, (s.FreqMax_est)]);
        ylim([0.97*min(s.PSDOmegaR_sim), 1.03*max(s.PSDOmegaR_sim)]); 
        grid on;  
        legend('show');
        %

            % Collective Blade Pitch
        who.fpBeta_sim = 'Estimated Positive Frequency of the Actual Collective Blade Pitch used in simulation.';
        who.PSDBeta_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Collective Blade Pitch used in simulation.';
        [s.PSDBeta_sim, s.fpBeta_sim] = pwelch( s.Beta, [], [], [], [] );
        s.fpBeta_sim = s.fpBeta_sim(2:end)';
        s.PSDBeta_sim = s.PSDBeta_sim(2:end)';
        s.FreqMax_est = max(s.fpBeta_sim ) ;
        figure;
        loglog(s.fpBeta_sim, s.PSDBeta_sim, 'b', 'DisplayName', 'PSD of Actual Collective Blade Pitch.');                   
        hold on;                        
        hold off;    
        title('Power Spectrum Density (PSD) Analysis of Actual Collective Blade Pitch.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [$(m^s/s^2)*(1/Hz)$]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([0, (s.FreqMax_est)]);
        ylim([0.97*min(s.PSDBeta_sim), 1.03*max(s.PSDBeta_sim)]); 
        grid on;  
        legend('show');
        % 

            % Generator Torque
        who.fpTg_sim = 'Estimated Positive Frequency of the Actual Generator Torque used in simulation.';
        who.PSDTg_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Generator Torque used in simulation.';
        [s.PSDTg_sim, s.fpTg_sim] = pwelch( s.Tg, [], [], [], [] );
        s.fpTg_sim = s.fpTg_sim(2:end)';
        s.PSDTg_sim = s.PSDTg_sim(2:end)';
        s.FreqMax_est = max(s.fpTg_sim ) ;
        figure;
        loglog(s.fpTg_sim, s.PSDTg_sim, 'b', 'DisplayName', 'PSD of Actual Generator Torque.');                   
        hold on;                        
        hold off;    
        title('Power Spectrum Density (PSD) Analysis of Actual Generator Torque.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [$(m^s/s^2)*(1/Hz)$]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([0, (s.FreqMax_est)]);
        ylim([0.97*min(s.PSDTg_sim), 1.03*max(s.PSDTg_sim)]); 
        grid on;  
        legend('show');
        %

            % Aerodynamic Torque
        who.fpTa_sim = 'Estimated Positive Frequency of the Actual Aerodynamic Torque used in simulation.';
        who.PSDTa_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Aerodynamic Torque used in simulation.';
        [s.PSDTa_sim, s.fpTa_sim] = pwelch( s.Ta, [], [], [], [] );
        s.fpTa_sim = s.fpTa_sim(2:end)';
        s.PSDTa_sim = s.PSDTa_sim(2:end)';
        s.FreqMax_est = max(s.fpTa_sim ) ;
        figure;
        loglog(s.fpTa_sim, s.PSDTa_sim, 'b', 'DisplayName', 'PSD of Actual Aerodynamic Torque.');                   
        hold on;                        
        hold off;    
        title('Power Spectrum Density (PSD) Analysis of Actual Aerodynamic Torque.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [$(m^s/s^2)*(1/Hz)$]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([0, (s.FreqMax_est)]);
        ylim([0.97*min(s.PSDTa_sim), 1.03*max(s.PSDTa_sim)]); 
        grid on;  
        legend('show');
        %          
    end


    % ----- Plot Tower-Bending Fore–Aft direction (Tower Dynamics) -----
    if s.Option04f3 == 1
        % Consider the TOWER DYNAMICS (fore-aft movement).
        figure()     
        plot(s.Time, s.Xt)
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('$X_{t}$ [rad]', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.Xt) 1.05 * max(s.Xt)])        
        legend('Actual tower top movement displacement $X_{t}$ [rad]', 'Interpreter', 'latex') 
        title('Actual tower top movement displacement over time.', 'Interpreter', 'latex') 
        % 

        %
        set(groot, 'defaultTextInterpreter', 'latex')
        figure()     
        plot(s.Time, s.Xt_dot)
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('${\dot{X}}_{t}$ [rad/s]', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.Xt_dot) 1.05 * max(s.Xt_dot)])        
        legend('Actual tower top movement velocity ${\dot{X}}_{t}$ [rad/s]', 'Interpreter', 'latex') 
        title('Actual tower top movement velocity over time.', 'Interpreter', 'latex') 
        % 
        
        set(0, 'DefaultTextInterpreter', 'none')
        figure()     
        plot(s.Time, s.Xt_Ddot )
        xlabel('$t [seg]$', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('${\ddot{X}}_{t}$', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.Xt_Ddot) 1.05 * max(s.Xt_Ddot)])        
        legend('Actual tower top movement acceleration ${\ddot{X}}_{t}$', 'Interpreter', 'latex') 
        title('Actual tower top movement acceleration over time.', 'Interpreter', 'latex')     
        %    
    end


        
    % ----- Plot Negativa Damping problem -----
    if s.Option04f3 == 1
        % Consider the PITCH PLATAFORMA
        s.Pitch = (s.Xt / s.HtowerG )*(180/pi) ;

        figure()     
        plot(s.Time, s.Pitch)
        xlabel('$t$ [seg]', 'Interpreter', 'latex') 
        xlim([0 max(s.Time)])
        ylabel('${\alpha}$ [deg]', 'Interpreter', 'latex') 
        ylim([0.95 * min(s.Pitch) 1.05 * max(s.Pitch)])        
        legend('Movimento do pitch da plataforma, em [deg]', 'Interpreter', 'latex') 
        title('System response with and without a tower-feedback control loop.', 'Interpreter', 'latex') 
        %  
    end


    % ---------- Blade Dynamics: Blade bending (blade tip displacement) ----------
    if s.Option08f3 == 3
        if s.Option05f3 == 1
            % Consider the BLADE DYNAMICS (flap-wise blade bending).
            figure()     
            plot(s.Time, s.zetaB)
            xlabel('$t$ [seg]', 'Interpreter', 'latex') 
            xlim([0 max(s.Time)])
            ylabel('$X_{b}$ [rad]', 'Interpreter', 'latex') 
            ylim([0.95 * min(s.zetaB) 1.05 * max(s.zetaB)])        
            legend('Actual blade tip displacement $X_{b}$ [rad]', 'Interpreter', 'latex') 
            title('Actual blade tip displacement over time.', 'Interpreter', 'latex') 
            % 

            %
            set(groot, 'defaultTextInterpreter', 'latex')
            figure()     
            plot(s.Time, s.zetaB_dot)
            xlabel('$t$ [seg]', 'Interpreter', 'latex') 
            xlim([0 max(s.Time)])
            ylabel('${\dot{X}}_{b}$ [rad/s]', 'Interpreter', 'latex') 
            ylim([0.95 * min(s.zetaB_dot) 1.05 * max(s.zetaB_dot)])        
            legend('Actual blade tip speed ${\dot{X}}_{b}$ [m/s]', 'Interpreter', 'latex') 
            title('Actual blade tip speed over time.', 'Interpreter', 'latex') 
            % 

            figure()     
            plot(s.Time, s.zetaB_Ddot )
            xlabel('$t$ [\mathrm{seg}]$', 'Interpreter', 'latex') 
            xlim([0 max(s.Time)])
            ylabel('${\ddot{X}}_{b}$ [rad/s^2]', 'Interpreter', 'latex') 
            ylim([0.95 * min([-1 s.zetaB_Ddot]) 1.05 * max(s.zetaB_Ddot)])        
            legend('Actual blade tip acceleration ${\ddot{X}}_{b}$ [\mathrm{m/s^2}]', 'Interpreter', 'latex') 
            title('Actual blade tip acceleration over time.', 'Interpreter', 'latex')     
            %          
        end
        %
    end % if s.Option08f3 == 3

    
    
%=============================================================  
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'BladePitchSystem', BladePitchSystem);
assignin('base', 'GeneratorTorqueSystem', GeneratorTorqueSystem);
assignin('base', 'PowerGeneration', PowerGeneration);
assignin('base', 'DriveTrainDynamics', DriveTrainDynamics);
assignin('base', 'TowerDynamics', TowerDynamics);
assignin('base', 'RotorDynamics', RotorDynamics);
assignin('base', 'NacelleDynamics', NacelleDynamics);
assignin('base', 'WindTurbineOutput', WindTurbineOutput);



% #######################################################################
end