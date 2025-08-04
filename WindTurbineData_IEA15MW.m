function WindTurbineData_IEA15MW(action)
% ########## SIMULATED WIND TURBINE DATA ##########
% #################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Ocean 
% Engineering in 2025. Master's dissertation title: Control of wind turbine 
% based on effective wind speed estimation / Silva, Anderson Francisco -- São Paulo, 2025.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains all the wind turbine data. The adopted 
% reference wind turbine is similar to NREL's baseline wind turbine IEA-15MW.


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
    % IEA-15MW MAIN DATA AND CHARACTERISTICS (OFFLINE):
    % Purpose of this Logical Instance: to represent the main characteristics
    % and data of the IEA-15MW wind turbine.

    % ---------- Wind Properties and Statistics for Wind Turbine Design ----------
    who.Notef2_1 = 'Wind Properties and Statistics for Wind Turbine Design.';   
    who.rho = 'Air density in [kg/m^3], under standard conditions at 25ºC and 1 [atm].';
    s.rho = 1.225;

    % Organizing output results   
    WindTurbine_data.Notef2_1 = who.Notef2_1; WindTurbine_data.rho = s.rho; 


    % ---------- Properties Blade Pitch Actuator System ----------  
    who.Notef2_2 = 'Properties Blade Pitch Actuator System.';
    who.MM_Beta = 'Mass of the second-order model, in [N.seg^2/deg].';
    s.MM_Beta = 17740/3; 
    who.CC_Beta = 'Damping coefficient of the second-order model, in [N.seg/deg]. See page 27 Jonkman (2009).';
    s.CC_Beta = 206000;    
    who.KK_Beta = 'Stiffness coefficient of the second-order model, in [N/deg]. See page 27 Jonkman (2009).';
    s.KK_Beta = 971350000;  
    who.FF_Beta = 'External Force, in [N].';
    who.tau_Beta = 'Time constant for first-order model of Blade Pitch actuator system dynamics, in [seg].';
    s.tau_Beta = 0.9375 ; % (0.5*8 = 4) OR (0.9375*8 = 7.5)
    who.BetaDot_max = 'Maximum Rate Blade Pitch, in [deg/seg]. See page 27 Jonkman (2009).';
    s.BetaDot_max = 8;    

    % ---------- Properties the Generator Torque/Conversor System ----------
    who.Notef2_3 = 'Properties the Generator Torque/Conversor System.';
    who.tau_Tg = 'Time constant for first-order model of Generator Torque dynamics actuator system dynamics, in [seg].';
    s.tau_Tg = 0.001; % Values ​​between 0.01 to 0.2 [sec] are suggested, where 0.01 guarantees Tg =~ Tg_d
    who.TgDot_max = 'Maximum Rate Generator Torque, in [N.m/seg]. See page 20 Jonkman (2009).';
    s.TgDot_max = 15000;    
    
    
    % Organizing output results 
    WindTurbine_data.Notef2_2 = who.Notef2_2; WindTurbine_data.MM_Beta = s.MM_Beta; WindTurbine_data.CC_Beta = s.CC_Beta; WindTurbine_data.KK_Beta = s.KK_Beta; WindTurbine_data.FF_Beta = who.FF_Beta; WindTurbine_data.tau_Beta = s.tau_Beta; WindTurbine_data.BetaDot_max = s.BetaDot_max;       
    WindTurbine_data.Notef2_3 = who.Notef2_3; WindTurbine_data.tau_Tg = s.tau_Tg; WindTurbine_data.TgDot_max  = s.TgDot_max;


    % ---------- Properties and General Characteristics  ----------
    who.Notef2_4 = 'General properties and characteristics of the reference wind turbine.';

    who.ReferenceWindTurbine = 'Nameplate Capacity is the intended full-load sustained output of a facility such as a power station, in [MW].';
    s.ReferenceWindTurbine = 'IEA-15MW';
    who.Pe_rated = 'Rated Electrical Power, in [W].';
    s.Pe_rated = 5e+6;

    who.DiameterRotor = 'Rotor diameter, in [m].';
    s.DiameterRotor = 126;
    who.DiameterHub = 'Hub diameter, in [m].';
    s.DiameterHub = 3; 
    who.HubHt = 'Hub height, in [m].';
    s.HubHt = 90;

    who.OmegaGJ_CutIn = 'Transitional generator speed (HSS side), in [rad/s]. According to page 57 of Jonkman, the Cut-In speed of the generator (VS_CtInSp) used in the configuration of two controllers.';
    s.OmegaGJ_CutIn = 70.16224;
    who.RotorSpeed_CutIn = 'Cut-In Rotor Speed, in [RPM].';
    s.RotorSpeed_CutIn = 6.9;
    who.OmegaR_CutIn = 'Cut-In Rotor Speed, in [rad/s].';
    s.OmegaR_CutIn = (2*pi*s.RotorSpeed_CutIn)/(60);
    who.Vtip_min = 'Cut-In Tip Speed, em [m/s].';
    s.Vtip_min = (0.5*s.DiameterRotor)*s.OmegaR_CutIn;
    who.Vws_CutIn = 'Cut-In Wind Speed, em [m/s].';
    s.Vws_CutIn = 3; 


    who.RotorSpeed_Rated = 'Rated Rotor Speed, in [RPM].';
    s.RotorSpeed_Rated = 12.1;
    who.OmegaR_Rated = 'Rated Rotor Speed, in [rad/s].';
    s.OmegaR_Rated = (2*pi*s.RotorSpeed_Rated)/(60);   
    who.Vtip_max = 'Rated Tip Speed, em [m/s].';
    s.Vtip_max = (0.5*s.DiameterRotor)*s.OmegaR_Rated;
    who.Vtip_max = 'Rated Tip Speed, em [m/s].';
    s.Vtip_max = (0.5*s.DiameterRotor)*s.OmegaR_Rated;
    who.Vws_Rated = 'Rated Wind Speed, em [m/s].';
    s.Vws_Rated = 11.4;
    who.Vws_CutOut = 'Cut-Out Wind Speed, em [m/s].';
    s.Vws_CutOut = 25;
    who.RatedTipSpeed = 'Rated Tip Speed, em [m/s].';
    s.RatedTipSpeed = 80;
    
    who.OmegaG_op1_15 = 'Transitional Generator Speed (HSS side), in [rad/s]. According to Jonkman (pg 57, 2009), this is the generator speed (VS_Rgn2Sp) that delimits the end of Region 1.5 and the beginning of Region 2 (Jonkman Strategy).';
    s.OmegaG_op1_15 = 91.21091;
    who.OmegaGJ_Rated = 'Rated generator speed (HSS side), in [rad/s]. According to page 57 of Jonkman, the rated generator speed (VS_RtGnSp) used in controller setup.';
    s.OmegaGJ_Rated = 121.6805;
    who.Slip_Synchronous = 'Rated generator slip percentage in Region 2, in [%]. According to pages 57 and 58 of Jonkman, runoff rate (VS_SlPc) of the synchronous speed of the generator in Region 2.';
    s.Slip_Synchronous = 10;
    who.OmegaR_Synchronous = 'Synchronous speed of generator induction, in [rad/].';
    s.OmegaR_Synchronous = (0.99 .* s.OmegaR_Rated) ./ ( 1 + 0.01*s.Slip_Synchronous );    

    who.Mrotor = 'Rotor mass (hub + blades), in [kg]. According to Table 1.1 on page 2 Jonkman (2009).';
    s.Mrotor = 110000;
    who.JJrotor = 'Rotor Moments of Inertia (hub + blades), in [kg].';
    s.JJrotor = 50.365e+3*(1000) ;

    who.Mhub = 'Hub Mass, em [kg]. According to Table 1.1 on page 2 Jonkman (2009)';
    s.Mhub = 347460;

    who.Mnacelle = 'Nacelle Mass, em [kg]. According to Table 1.1 and Table 4.1, on pg 13 Jonkman (2009)';
    s.Mnacelle = 240000; 
    who.JJnacelle = 'Nacelle Moments of Inertia, in [kg]. According to Table 4.1 on page 13 Jonkman (2009)';
    s.JJnacelle = 2607890;      

    who.Mtower = 'Tower Mass, em [kg]. According to Table 1.1 on pg 2 Jonkman (2009).';
    s.Mtower = 347460;
    who.Mplataform = 'Platform Mass, in [kg]';    
    s.Mplataform = 7368588 ;

    who.JJtower_platf = 'Moments of Inertia of the Structure comprising the Tower and Platform (single rigid body), in [kg].';
    s.JJtower_platf = 9.369e+6*(1000) ;


    % ## Organizing output results      
    WindTurbine_data.Notef2_4 = who.Notef2_4; WindTurbine_data.ReferenceWindTurbine = s.ReferenceWindTurbine; WindTurbine_data.Pe_rated = s.Pe_rated; WindTurbine_data.DiameterRotor = s.DiameterRotor; WindTurbine_data.DiameterHub = s.DiameterHub; WindTurbine_data.HubHt = s.HubHt; WindTurbine_data.RotorSpeed_CutIn = s.RotorSpeed_CutIn; WindTurbine_data.OmegaR_CutIn = s.OmegaR_CutIn; WindTurbine_data.Vtip_min = s.Vtip_min; WindTurbine_data.Vws_CutIn = s.Vws_CutIn; WindTurbine_data.RotorSpeed_Rated = s.RotorSpeed_Rated; WindTurbine_data.OmegaR_Rated = s.OmegaR_Rated; WindTurbine_data.Vtip_max = s.Vtip_max; WindTurbine_data.Vws_Rated = s.Vws_Rated; WindTurbine_data.Vws_CutOut = s.Vws_CutOut;   
    WindTurbine_data.Mrotor = s.Mrotor; WindTurbine_data.JJrotor = s.JJrotor; WindTurbine_data.Mhub  = s.Mhub ;
    WindTurbine_data.Mnacelle = s.Mnacelle; WindTurbine_data.JJnacelle = s.JJnacelle;
    WindTurbine_data.Mtower = s.Mtower; WindTurbine_data.Mplataform = s.Mplataform; WindTurbine_data.JJtower_platf = s.JJtower_platf ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_02');


%=============================================================
elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF BLADE STRUCTURAL PROPERTIES (OFFLINE):
    % Purpose of this Logical Instance: to represent the characteristics 
    % and data of the blades and airfoils used in the studies and analysis
    % of the IEA-15MW wind turbine.


    % ---------- Blade Structural Properties  ----------
    who.Notef2_5 = 'Blade Structural Properties.'; 
    who.Mblades = 'Blade mass (integrated assembly), em [kg].';
    s.Mblades = 17740;
    who.N_blades = 'Number of blades, [dimensionless].';
    s.N_blades = 3;
    who.BladeRoot = 'Blade Root Radius, in [m]. This is the radius of the hub, where the blade assembly is held and there is no contact with the wind flow.';
    s.BladeRoot = (s.DiameterHub / 2); 
    who.BladeLength = 'Length of blades (Root Along Preconed Axis), in [m]. It is the length of blades in contact with wind flow.';
    s.BladeLength = 61.5; 
    who.Rrd = 'Rotor Disk Radius, in [m].';
    s.Rrd = s.BladeRoot + s.BladeLength;
    who.FNba_FY1 = 'Natural frequency of the fist Blade Asymmetric Flapwise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_FY1 = 0.6664;
    who.FNba_FY2 = 'Natural frequency of the second Blade Asymmetric Flapwise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_FY2 = 1.9337; 
    who.FNba_EY1 = 'Natural frequency of the fist Blade Asymmetric Edgewise Yaw, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_EY1 = 1.0898;       
    who.FNba_FP1 = 'Natural frequency of the fist Blade Asymmetric Flapwise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_FP1 = 0.6675;
    who.FNba_FP2 = 'Natural frequency of the second Blade Asymmetric Flapwise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_FP2 = 1.9223; 
    who.FNba_EP1 = 'Natural frequency of the fist Blade Asymmetric Edgewise Pitch, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNba_EP1 = 1.0793;    
    who.FNb_CF1 = 'Natural frequency of the fist Blade Collective Flap, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNb_CF1 = 0.6993;
    who.FNb_CF2 = 'Natural frequency of the second Blade Collective Flap, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNb_CF2 = 2.0205;  

    % ---------- Distributed Blade Structural Properties (Rotor Dynamics)  ----------
    who.BMassDen = 'Blades Mass along the tower, in [kg/m].'; 
    s.BMassDen = [678.935  678.935 773.363  740.550 740.042 592.496 450.275 424.054 400.638 382.062 399.655 426.321  416.820 406.186  381.420 352.822 349.477 346.538 339.333 330.004 321.990 313.820 294.734  287.120 263.343 253.207 241.666  220.638  200.293 179.404 165.094 154.411 138.935 129.555 107.264  98.776  90.248 83.001 72.906  68.772 66.264 59.340  55.914 52.484 49.114 45.818 41.669 11.453 10.319] ;
    who.FlpStff = 'The flapwise stiffness “FlpStff” at each blade section along the blade, in [N*m^2]. Value according Jonkman (2009)';
    s.FlpStff = [18110.00E+6, 18110.00E+6, 19424.90E+6, 17455.90E+6, 15287.40E+6, 10782.40E+6, 7229.72E+6, 6309.54E+6, 5528.36E+6, 4980.06E+6, 4936.84E+6, 4691.66E+6, 3949.46E+6, 3386.52E+6, 2933.74E+6, 2568.96E+6, 2388.65E+6, 2271.99E+6, 2050.05E+6, 1828.25E+6, 1588.71E+6, 1361.93E+6, 1102.38E+6, 875.80E+6, 681.30E+6, 534.72E+6, 408.90E+6, 314.54E+6, 238.63E+6, 175.88E+6, 126.01E+6, 107.26E+6, 90.88E+6, 76.31E+6, 61.05E+6, 49.48E+6, 39.36E+6, 34.67E+6, 30.41E+6, 26.52E+6, 23.84E+6, 19.63E+6, 16.00E+6, 12.83E+6, 10.08E+6, 7.55E+6, 4.60E+6, 0.25E+6, 0.17E+6]; 
    who.Rb_FlpStff = 'Radius discretization for blade structure properties, in [m]';
    s.Rb_FlpStff = [1.5, 1.7, 2.7, 3.7, 4.7, 5.7, 6.7, 7.7, 8.7, 9.7, 10.7, 11.7, 12.7, 13.7, 14.7, 15.7, 16.7, 17.7, 19.7, 21.7, 23.7, 25.7, 27.7, 29.7, 31.7, 33.7, 35.7, 37.7, 39.7, 41.7, 43.7, 45.7, 47.7, 49.7, 51.7, 53.7, 55.7, 56.7, 57.7, 58.7, 59.2, 59.7, 60.2, 60.7, 61.2, 61.7, 62.2, 62.7, 63.0];  
    who.weighted_FlpStff = 'Weighted Average Blade Stiffness, in [N*m]';
    s.weighted_FlpStff = s.FlpStff.*s.Rb_FlpStff;  

    who.MMeq_blades = 'Equivalent Mass of the blades, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.MMeq_blades = trapz(s.Rb_FlpStff, s.BMassDen); % OR s.Mblades  
    s.MMeq_blades = s.Mblades ; % Jonkman considers paint, screws and other masses that make up the system.
    who.IIeq_blades = 'Equivalent Mass of the blades, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.IIeq_blades = trapz(s.Rb_FlpStff, s.BMassDen .* s.Rb_FlpStff.^2); % OR sumplify with: s.MMeq_blades * s.HbladesG^2;
    who.KKeq_blades = 'Equivalent Stiffness of the blades, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.KKeq_blades = trapz(s.Rb_FlpStff, s.FlpStff);  
    who.CC_StrucRatio = 'Structural-Damping Ratio (All Modes), in [decimal].';
    s.CCb_StrucRatio = 4.536/100; % s.CC_StrucRatio = 1%
    who.CCeq_blades = 'Equivalent Damping of the blades, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';    
    s.CCeq_blades = 2 * s.CCb_StrucRatio * sqrt(s.KKeq_blades * s.IIeq_blades);

    who.CCb = 'Damping of the Blade, in [N*m*s]';    
    who.KKb = 'Stiffness of the Blade, in [N*m/rad]'  ;  
    who.JJb = 'Total system inertia in the flawise direction, in [kg.m^2]';     
    if s.Option02f2 == 1
        % ONSHORE WIND TURBINE
        s.JJb = 3*s.IIeq_blades + (s.Mnacelle + s.Mrotor + s.Mhub) *  s.Rrd^2;
        s.MMblades = 3*s.MMeq_blades + s.Mnacelle + s.Mrotor + s.Mhub ;
        s.KKb = s.MMblades*(2*pi*s.FNba_FY1)^2;    
        s.CCb = s.CCb_StrucRatio*2*sqrt( s.KKb*s.JJb ) ;
        %
    else
        % OFFSHORE WIND TURBINE
        s.JJb = 3*s.IIeq_blades + s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMblades = 3*s.MMeq_blades + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKb = s.MMblades*(2*pi*s.FNba_FY1)^2; 
        s.CCb = s.CCb_StrucRatio*2*sqrt( s.KKb*s.JJb ) ;
        %
    end

    
    % ## Organizing output results      
    WindTurbine_data.Notef2_5 = who.Notef2_5; WindTurbine_data.Mblades = s.Mblades; WindTurbine_data.N_blades = s.N_blades; WindTurbine_data.BladeRoot = s.BladeRoot; WindTurbine_data.BladeLength = s.BladeLength; WindTurbine_data.Rrd = s.Rrd; 
    WindTurbine_data.FNba_FY1 = s.FNba_FY1; WindTurbine_data.FNba_FY2 = s.FNba_FY2; WindTurbine_data.FNba_EY1 = s.FNba_EY1; WindTurbine_data.FNba_FP1 = s.FNba_FP1; WindTurbine_data.FNba_FP2 = s.FNba_FP2; WindTurbine_data.FNba_EP1 = s.FNba_EP1; WindTurbine_data.FNb_CF1 = s.FNb_CF1; WindTurbine_data.FNb_CF2 = s.FNb_CF2;    
    WindTurbine_data.BMassDen = s.BMassDen; WindTurbine_data.FlpStff = s.FlpStff; WindTurbine_data.Rb_FlpStff = s.Rb_FlpStff; WindTurbine_data.weighted_FlpStff = s.weighted_FlpStff;
    WindTurbine_data.MMeq_blades = s.MMeq_blades; WindTurbine_data.IIeq_blades = s.IIeq_blades; WindTurbine_data.KKeq_blades = s.KKeq_blades; WindTurbine_data.CCb_StrucRatio = s.CCb_StrucRatio; WindTurbine_data.CCeq_blades = s.CCeq_blades;    
    WindTurbine_data.JJb = s.JJb; WindTurbine_data.KKb = s.KKb; WindTurbine_data.CCb = s.CCb;


    % ---------- Blade Aerodynamic Properties ----------    
    who.Notef2_6 = 'Blade Aerodynamic Properties.';
                % Tabble 3.1 and Appendix A by Jonkman (2009)
    who.RNodes = 'Local Radius of each Blade Element (r), in [m].';
    s.RNodes = [2.86667 5.6 8.3333 11.75 15.85 19.95 24.05 28.15 32.25 36.35 40.45 44.55 48.65 52.75 56.1667 58.9 (s.Rrd - s.BladeRoot)];
    who.mu = 'Standard Blade Radius (r/R), in [m].';
    s.mu = s.RNodes ./ s.Rrd; 
    who.AeroTwst = 'Twist Angle, in [deg].';
    s.AeroTwst = [13.308 13.308 13.308 13.308 11.480 10.162 9.011 7.795 6.544 5.361 4.188 3.125 2.319 1.526 0.863  0.370 0.106];
    who.DRNodes = 'Element length, in [m].';
    s.DRNodes = [2.7333 2.7333 2.7333 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 4.1000 2.7333 2.7333 2.7333];    
    who.Chord = 'Chord length, in [m].';
    s.Chord = [3.542 3.854 4.167 4.557 4.652 4.458 4.249 4.007 3.748 3.502 3.256 3.010 2.764 2.518 2.313 2.086 1.419]; 
    who.Airfoils = 'Blade Element Airfoil.';    
    s.Airfoils = {'Cylinder1', 'Cylinder1', 'Cylinder2', 'DU40_A17', 'DU35_A17', 'DU35_A17', 'DU30_A17', 'DU25_A17', 'DU25_A17', 'DU21_A17', 'DU21_A17', 'NACA64_A17', 'NACA64_A17', 'NACA64_A17', 'NACA64_A17', 'NACA64_A17', 'NACA64_A17'};
    who.BE_Node = 'Blade Element Node, in [dimensionless].';
    s.BE_Node = 1:1:17;
    who.BE_Properties = 'Blade Element Aerodynamic Properties.';
    indexBE = s.BE_Node + 1;
    indexBE = length(indexBE);
    s.BE_Properties = cell(indexBE, 5);  
    s.BE_Properties(:,1) = num2cell(s.BE_Node'); 
    s.BE_Properties(:,2) = num2cell(s.RNodes');    
    s.BE_Properties(:,3) = num2cell(s.AeroTwst');  
    s.BE_Properties(:,4) = num2cell(s.DRNodes');  
    s.BE_Properties(:,5) = num2cell(s.Chord');   
    s.BE_Properties(:,6) = s.Airfoils'; % Table 3.1 Jonkman (2009)  

    % ## Organizing output results      
    WindTurbine_data.Notef2_6 = who.Notef2_6; WindTurbine_data.RNodes = s.RNodes; WindTurbine_data.AeroTwst = s.AeroTwst; WindTurbine_data.DRNodes = s.DRNodes; WindTurbine_data.Chord = s.Chord; WindTurbine_data.mu = s.mu; WindTurbine_data.Airfoils = s.Airfoils; WindTurbine_data.BE_Node = s.BE_Node; WindTurbine_data.BE_Properties = s.BE_Properties;

    % ---------- Airfoils Data - Appendix B by Jonkman (2009)----------
    who.AirfoilData = 'Blade Elements Airfoil Properties and Data. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.'; 
    who.alpha = 'Angle of attack, in [deg]. Value assigned to an Airfoil.';
    who.Cl = 'Lift coefficient (Cl), in [dimensionless]. Value assigned to an Airfoil.';
    who.Cd = 'Drag coefficient (Cd), in [dimensionless]. Value assigned to an Airfoil.';

    who.Airfoil_Cylinder1 = 'Properties and Data for the "Cylinder1" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_Cylinder1.about = who.Airfoil_Cylinder1;
    s.Airfoil_Cylinder1.alpha = [-180.00, 0.00, 180.00];
    s.Airfoil_Cylinder1.Cl = [0.000, 0.000, 0.000];
    s.Airfoil_Cylinder1.Cd = [0.5000, 0.5000, 0.5000];
    s.Airfoil_Cylinder1.Cm = [0.000, 0.000, 0.000];
   
    who.Airfoil_Cylinder2 = 'Properties and Data for the "Cylinder2" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_Cylinder2.about = who.Airfoil_Cylinder2;    
    s.Airfoil_Cylinder2.alpha = [-180.00, 0.00, 180.00];
    s.Airfoil_Cylinder2.Cl = [0.000, 0.000, 0.000];
    s.Airfoil_Cylinder2.Cd = [0.3500, 0.3500, 0.3500];
    s.Airfoil_Cylinder2.Cm = [0.000, 0.000, 0.000];

    who.Airfoil_DU40_A17 = 'Properties and Data for the "DU40_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_DU40_A17.about = who.Airfoil_DU40_A17;       
    s.Airfoil_DU40_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.00, -14.00, -13.00, -12.00, -11.00, -10.00, -8.00, -6.00, -5.50, -5.00, -4.50, -4.00, -3.50, -3.00, -2.50, -2.00, -1.50, -1.00, -0.50, 0.00, 0.50, 1.00, 1.50, 2.00, 2.50, 3.00, 3.50, 4.00, 4.50, 5.00, 5.50, 6.00, 6.50, 7.00, 7.50, 8.00, 8.50, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.50, 15.00, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 19.00, 19.50, 20.50, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_DU40_A17.Cl = [0.000, 0.218, 0.397, 0.642, 0.715, 0.757, 0.772, 0.762, 0.731, 0.680, 0.613, 0.532, 0.439, 0.337, 0.228, 0.114, -0.002, -0.120, -0.236, -0.349, -0.456, -0.557, -0.647, -0.727, -0.792, -0.842, -0.874, -0.886, -0.875, -0.839, -0.777, -0.761, -0.744, -0.725, -0.706, -0.685, -0.662, -0.635, -0.605, -0.571, -0.534, -0.494, -0.452, -0.407, -0.360, -0.311, -0.208, -0.111, -0.090, -0.072, -0.065, -0.054, -0.017, 0.003, 0.014, 0.009, 0.004, 0.036, 0.073, 0.137, 0.213, 0.292, 0.369, 0.444, 0.514, 0.580, 0.645, 0.710, 0.776, 0.841, 0.904, 0.967, 1.027, 1.084, 1.140, 1.193, 1.242, 1.287, 1.333, 1.368, 1.400, 1.425, 1.449, 1.473, 1.494, 1.513, 1.538, 1.587, 1.614, 1.631, 1.649, 1.666, 1.681, 1.699, 1.719, 1.751, 1.767, 1.798, 1.810, 1.830, 1.847, 1.861, 1.872, 1.881, 1.894, 1.904, 1.915, 1.929, 1.903, 1.820, 1.690, 1.522, 1.323, 1.106, 0.880, 0.658, 0.449, 0.267, 0.124, 0.002, -0.118, -0.235, -0.348, -0.453, -0.549, -0.633, -0.702, -0.754, -0.787, -0.797, -0.782, -0.739, -0.664, -0.410, -0.226, 0.000];
    s.Airfoil_DU40_A17.Cd = [0.0602, 0.0699, 0.1107, 0.3045, 0.4179, 0.5355, 0.6535, 0.7685, 0.8777, 0.9788, 10.700, 11.499, 12.174, 12.716, 13.118, 13.378, 13.492, 13.460, 13.283, 12.964, 12.507, 11.918, 11.204, 10.376, 0.9446, 0.8429, 0.7345, 0.6215, 0.5067, 0.3932, 0.2849, 0.2642, 0.2440, 0.2242, 0.2049, 0.1861, 0.1687, 0.1533, 0.1398, 0.1281, 0.1183, 0.1101, 0.1036, 0.0986, 0.0951, 0.0931, 0.0930, 0.0689, 0.0614, 0.0547, 0.0480, 0.0411, 0.0349, 0.0299, 0.0255, 0.0198, 0.0164, 0.0147, 0.0137, 0.0113, 0.0114, 0.0118, 0.0122, 0.0124, 0.0124, 0.0123, 0.0120, 0.0119, 0.0122, 0.0125, 0.0129, 0.0135, 0.0144, 0.0158, 0.0174, 0.0198, 0.0231, 0.0275, 0.0323, 0.0393, 0.0475, 0.0580, 0.0691, 0.0816, 0.0973, 0.1129, 0.1288, 0.1650, 0.1845, 0.2052, 0.2250, 0.2467, 0.2684, 0.2900, 0.3121, 0.3554, 0.3783, 0.4212, 0.4415, 0.4830, 0.5257, 0.5694, 0.6141, 0.6593, 0.7513, 0.8441, 0.9364, 10.722, 12.873, 14.796, 16.401, 17.609, 18.360, 18.614, 18.347, 17.567, 16.334, 14.847, 13.879, 13.912, 13.795, 13.528, 13.114, 12.557, 11.864, 11.041, 10.102, 0.9060, 0.7935, 0.6750, 0.5532, 0.4318, 0.3147, 0.1144, 0.0702, 0.0602];
    s.Airfoil_DU40_A17.Cm = [0.0000, 0.0934, 0.1697, 0.2813, 0.3208, 0.3516, 0.3752, 0.3926, 0.4048, 0.4126, 0.4166, 0.4176, 0.4158, 0.4117, 0.4057, 0.3979, 0.3887, 0.3781, 0.3663, 0.3534, 0.3394, 0.3244, 0.3084, 0.2914, 0.2733, 0.2543, 0.2342, 0.2129, 0.1906, 0.1670, 0.1422, 0.1371, 0.1320, 0.1268, 0.1215, 0.1162, 0.1097, 0.1012, 0.0907, 0.0784, 0.0646, 0.0494, 0.0330, 0.0156, -0.0026, -0.0213, -0.0600, -0.0500, -0.0516, -0.0532, -0.0538, -0.0544, -0.0554, -0.0558, -0.0555, -0.0534, -0.0442, -0.0469, -0.0522, -0.0573, -0.0644, -0.0718, -0.0783, -0.0835, -0.0866, -0.0887, -0.0900, -0.0914, -0.0933, -0.0947, -0.0957, -0.0967, -0.0973, -0.0972, -0.0972, -0.0968, -0.0958, -0.0948, -0.0942, -0.0926, -0.0908, -0.0890, -0.0877, -0.0870, -0.0870, -0.0876, -0.0886, -0.0917, -0.0939, -0.0966, -0.0996, -0.1031, -0.1069, -0.1110, -0.1157, -0.1242, -0.1291, -0.1384, -0.1416, -0.1479, -0.1542, -0.1603, -0.1664, -0.1724, -0.1841, -0.1954, -0.2063, -0.2220, -0.2468, -0.2701, -0.2921, -0.3127, -0.3321, -0.3502, -0.3672, -0.3830, -0.3977, -0.4112, -0.4234, -0.4343, -0.4437, -0.4514, -0.4573, -0.4610, -0.4623, -0.4606, -0.4554, -0.4462, -0.4323, -0.4127, -0.3863, -0.3521, -0.3085, -0.1858, -0.1022, 0.0000];
    
    who.Airfoil_DU35_A17 = 'Properties and Data for the "DU35_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_DU35_A17.about = who.Airfoil_DU35_A17;         
    s.Airfoil_DU35_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.00, -14.00, -13.00, -12.00, -11.00, -10.00, -5.54, -5.04, -4.54, -4.04, -3.54, -3.04, -3.00, -2.50, -2.00, -1.50, -1.00, -0.50, 0.00, 0.50, 1.00, 1.50, 2.00, 2.50, 3.00, 3.50, 4.00, 4.50, 5.00, 5.50, 6.00, 6.50, 7.00, 7.50, 8.00, 8.50, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.00, 14.50, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 19.00, 19.50, 20.00, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_DU35_A17.Cl = [0.000, 0.223, 0.405, 0.658, 0.733, 0.778, 0.795, 0.787, 0.757, 0.708, 0.641, 0.560, 0.467, 0.365, 0.255, 0.139, 0.021, -0.098, -0.216, -0.331, -0.441, -0.544, -0.638, -0.720, -0.788, -0.840, -0.875, -0.889, -0.880, -0.846, -0.784, -0.768, -0.751, -0.733, -0.714, -0.693, -0.671, -0.648, -0.624, -0.601, -0.579, -0.559, -0.539, -0.519, -0.499, -0.480, -0.385, -0.359, -0.360, -0.355, -0.307, -0.246, -0.240, -0.163, -0.091, -0.019, 0.052, 0.121, 0.196, 0.265, 0.335, 0.404, 0.472, 0.540, 0.608, 0.674, 0.742, 0.809, 0.875, 0.941, 1.007, 1.071, 1.134, 1.198, 1.260, 1.318, 1.368, 1.422, 1.475, 1.523, 1.570, 1.609, 1.642, 1.675, 1.700, 1.717, 1.712, 1.703, 1.671, 1.649, 1.621, 1.598, 1.571, 1.549, 1.544, 1.549, 1.565, 1.565, 1.563, 1.558, 1.552, 1.546, 1.539, 1.527, 1.522, 1.529, 1.544, 1.529, 1.471, 1.376, 1.249, 1.097, 0.928, 0.750, 0.570, 0.396, 0.237, 0.101, -0.022, -0.143, -0.261, -0.374, -0.480, -0.575, -0.659, -0.727, -0.778, -0.809, -0.818, -0.800, -0.754, -0.677, -0.417, -0.229, 0.000];
    s.Airfoil_DU35_A17.Cd = [0.0407, 0.0507, 0.1055, 0.2982, 0.4121, 0.5308, 0.6503, 0.7672, 0.8785, 0.9819, 10.756, 11.580, 12.280, 12.847, 13.274, 13.557, 13.692, 13.680, 13.521, 13.218, 12.773, 12.193, 11.486, 10.660, 0.9728, 0.8705, 0.7611, 0.6466, 0.5299, 0.4141, 0.3030, 0.2817, 0.2608, 0.2404, 0.2205, 0.2011, 0.1822, 0.1640, 0.1465, 0.1300, 0.1145, 0.1000, 0.0867, 0.0744, 0.0633, 0.0534, 0.0245, 0.0225, 0.0196, 0.0174, 0.0162, 0.0144, 0.0240, 0.0188, 0.0160, 0.0137, 0.0118, 0.0104, 0.0094, 0.0096, 0.0098, 0.0099, 0.0100, 0.0102, 0.0103, 0.0104, 0.0105, 0.0107, 0.0108, 0.0109, 0.0110, 0.0113, 0.0115, 0.0117, 0.0120, 0.0126, 0.0133, 0.0143, 0.0156, 0.0174, 0.0194, 0.0227, 0.0269, 0.0319, 0.0398, 0.0488, 0.0614, 0.0786, 0.1173, 0.1377, 0.1600, 0.1814, 0.2042, 0.2316, 0.2719, 0.2906, 0.3085, 0.3447, 0.3820, 0.4203, 0.4593, 0.4988, 0.5387, 0.6187, 0.6978, 0.7747, 0.8869, 10.671, 12.319, 13.747, 14.899, 15.728, 16.202, 16.302, 16.031, 15.423, 14.598, 14.041, 14.053, 13.914, 13.625, 13.188, 12.608, 11.891, 11.046, 10.086, 0.9025, 0.7883, 0.6684, 0.5457, 0.4236, 0.3066, 0.1085, 0.0510, 0.0407];
    s.Airfoil_DU35_A17.Cm = [0.0000, 0.0937, 0.1702, 0.2819, 0.3213, 0.3520, 0.3754, 0.3926, 0.4046, 0.4121, 0.4160, 0.4167, 0.4146, 0.4104, 0.4041, 0.3961, 0.3867, 0.3759, 0.3639, 0.3508, 0.3367, 0.3216, 0.3054, 0.2884, 0.2703, 0.2512, 0.2311, 0.2099, 0.1876, 0.1641, 0.1396, 0.1345, 0.1294, 0.1243, 0.1191, 0.1139, 0.1086, 0.1032, 0.0975, 0.0898, 0.0799, 0.0682, 0.0547, 0.0397, 0.0234, 0.0060, -0.0800, -0.0800, -0.0800, -0.0800, -0.0800, -0.0800, -0.0623, -0.0674, -0.0712, -0.0746, -0.0778, -0.0806, -0.0831, -0.0863, -0.0895, -0.0924, -0.0949, -0.0973, -0.0996, -0.1016, -0.1037, -0.1057, -0.1076, -0.1094, -0.1109, -0.1118, -0.1127, -0.1138, -0.1144, -0.1137, -0.1112, -0.1100, -0.1086, -0.1064, -0.1044, -0.1013, -0.0980, -0.0953, -0.0925, -0.0896, -0.0864, -0.0840, -0.0830, -0.0848, -0.0880, -0.0926, -0.0984, -0.1052, -0.1158, -0.1213, -0.1248, -0.1317, -0.1385, -0.1452, -0.1518, -0.1583, -0.1647, -0.1770, -0.1886, -0.1994, -0.2148, -0.2392, -0.2622, -0.2839, -0.3043, -0.3236, -0.3417, -0.3586, -0.3745, -0.3892, -0.4028, -0.4151, -0.4261, -0.4357, -0.4437, -0.4498, -0.4538, -0.4553, -0.4540, -0.4492, -0.4405, -0.4270, -0.4078, -0.3821, -0.3484, -0.3054, -0.1842, -0.1013, 0.0000];
     
    who.Airfoil_DU30_A17 = 'Properties and Data for the "DU30_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_DU30_A17.about = who.Airfoil_DU30_A17;          
    s.Airfoil_DU30_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.25, -14.24, -13.24, -12.22, -11.22, -10.19, -9.70, -9.18, -8.18, -7.19, -6.65, -6.13, -6.00, -5.50, -5.00, -4.50, -4.00, -3.50, -3.00, -2.50, -2.00, -1.50, -1.00, -0.50, 0.00, 0.50, 1.00, 1.50, 2.00, 2.50, 3.00, 3.50, 4.00, 4.50, 5.00, 5.50, 6.00, 6.50, 7.00, 7.50, 8.00, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.00, 14.50, 15.00, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 18.50, 19.00, 19.50, 20.00, 20.50, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_DU30_A17.Cl = [0.000, 0.274, 0.547, 0.685, 0.766, 0.816, 0.836, 0.832, 0.804, 0.756, 0.690, 0.609, 0.515, 0.411, 0.300, 0.182, 0.061, -0.061, -0.183, -0.302, -0.416, -0.523, -0.622, -0.708, -0.781, -0.838, -0.877, -0.895, -0.889, -0.858, -0.832, -0.852, -0.882, -0.919, -0.963, -1.013, -1.067, -1.125, -1.185, -1.245, -1.290, -1.229, -1.148, -1.052, -0.965, -0.867, -0.822, -0.769, -0.756, -0.690, -0.616, -0.542, -0.525, -0.451, -0.382, -0.314, -0.251, -0.189, -0.120, -0.051, 0.017, 0.085, 0.152, 0.219, 0.288, 0.354, 0.421, 0.487, 0.554, 0.619, 0.685, 0.749, 0.815, 0.879, 0.944, 1.008, 1.072, 1.135, 1.197, 1.256, 1.305, 1.390, 1.424, 1.458, 1.488, 1.512, 1.533, 1.549, 1.558, 1.470, 1.398, 1.354, 1.336, 1.333, 1.326, 1.329, 1.326, 1.321, 1.331, 1.333, 1.340, 1.362, 1.382, 1.398, 1.426, 1.437, 1.418, 1.397, 1.376, 1.354, 1.332, 1.293, 1.265, 1.253, 1.264, 1.258, 1.217, 1.146, 1.049, 0.932, 0.799, 0.657, 0.509, 0.362, 0.221, 0.092, -0.030, -0.150, -0.267, -0.379, -0.483, -0.578, -0.660, -0.727, -0.777, -0.807, -0.815, -0.797, -0.750, -0.673, -0.547, -0.274, 0.000];
    s.Airfoil_DU30_A17.Cd = [0.0267, 0.0370, 0.0968, 0.2876, 0.4025, 0.5232, 0.6454, 0.7656, 0.8807, 0.9882, 10.861, 11.730, 12.474, 13.084, 13.552, 13.875, 14.048, 14.070, 13.941, 13.664, 13.240, 12.676, 11.978, 11.156, 10.220, 0.9187, 0.8074, 0.6904, 0.5703, 0.4503, 0.3357, 0.3147, 0.2946, 0.2752, 0.2566, 0.2388, 0.2218, 0.2056, 0.1901, 0.1754, 0.1649, 0.1461, 0.1263, 0.1051, 0.0886, 0.0740, 0.0684, 0.0605, 0.0270, 0.0180, 0.0166, 0.0152, 0.0117, 0.0105, 0.0097, 0.0092, 0.0091, 0.0089, 0.0089, 0.0088, 0.0088, 0.0088, 0.0088, 0.0088, 0.0087, 0.0087, 0.0088, 0.0089, 0.0090, 0.0091, 0.0092, 0.0093, 0.0095, 0.0096, 0.0097, 0.0099, 0.0101, 0.0103, 0.0107, 0.0112, 0.0125, 0.0155, 0.0171, 0.0192, 0.0219, 0.0255, 0.0307, 0.0370, 0.0452, 0.0630, 0.0784, 0.0931, 0.1081, 0.1239, 0.1415, 0.1592, 0.1743, 0.1903, 0.2044, 0.2186, 0.2324, 0.2455, 0.2584, 0.2689, 0.2814, 0.2943, 0.3246, 0.3557, 0.3875, 0.4198, 0.4524, 0.5183, 0.5843, 0.6492, 0.7438, 0.8970, 10.402, 11.686, 12.779, 13.647, 14.267, 14.621, 14.708, 14.544, 14.196, 13.938, 13.943, 13.798, 13.504, 13.063, 12.481, 11.763, 10.919, 0.9962, 0.8906, 0.7771, 0.6581, 0.5364, 0.4157, 0.3000, 0.1051, 0.0388, 0.0267];
    s.Airfoil_DU30_A17.Cm = [0.0000, 0.1379, 0.2778, 0.2740, 0.3118, 0.3411, 0.3631, 0.3791, 0.3899, 0.3965, 0.3994, 0.3992, 0.3964, 0.3915, 0.3846, 0.3761, 0.3663, 0.3551, 0.3428, 0.3295, 0.3153, 0.3001, 0.2841, 0.2672, 0.2494, 0.2308, 0.2113, 0.1909, 0.1696, 0.1475, 0.1224, 0.1156, 0.1081, 0.1000, 0.0914, 0.0823, 0.0728, 0.0631, 0.0531, 0.0430, 0.0353, 0.0240, 0.0100, -0.0090, -0.0230, -0.0336, -0.0375, -0.0440, -0.0578, -0.0590, -0.0633, -0.0674, -0.0732, -0.0766, -0.0797, -0.0825, -0.0853, -0.0884, -0.0914, -0.0942, -0.0969, -0.0994, -0.1018, -0.1041, -0.1062, -0.1086, -0.1107, -0.1129, -0.1149, -0.1168, -0.1185, -0.1201, -0.1218, -0.1233, -0.1248, -0.1260, -0.1270, -0.1280, -0.1287, -0.1289, -0.1270, -0.1207, -0.1158, -0.1116, -0.1073, -0.1029, -0.0983, -0.0949, -0.0921, -0.0899, -0.0885, -0.0885, -0.0902, -0.0928, -0.0963, -0.1006, -0.1042, -0.1084, -0.1125, -0.1169, -0.1215, -0.1263, -0.1313, -0.1352, -0.1406, -0.1462, -0.1516, -0.1570, -0.1623, -0.1676, -0.1728, -0.1832, -0.1935, -0.2039, -0.2193, -0.2440, -0.2672, -0.2891, -0.3097, -0.3290, -0.3471, -0.3641, -0.3799, -0.3946, -0.4081, -0.4204, -0.4313, -0.4408, -0.4486, -0.4546, -0.4584, -0.4597, -0.4582, -0.4532, -0.4441, -0.4303, -0.4109, -0.3848, -0.3508, -0.3074, -0.2786, -0.1380, 0.0000];

    who.Airfoil_DU25_A17 = 'Properties and Data for the "DU25_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_DU25_A17.about = who.Airfoil_DU25_A17;       
    s.Airfoil_DU25_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.00, -14.00, -13.00, -12.01, -11.00, -9.98, -8.98, -8.47, -7.45, -6.42, -5.40, -5.00, -4.50, -4.00, -3.50, -3.00, -2.50, -2.00, -1.50, -1.00, -0.50, 0.00, 0.50, 1.00, 1.50, 2.00, 2.50, 3.00, 3.50, 4.00, 4.50, 5.00, 6.00, 6.50, 7.00, 7.50, 8.00, 8.50, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.00, 14.50, 15.00, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 18.50, 19.00, 19.50, 20.00, 20.50, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_DU25_A17.Cl = [0.000, 0.368, 0.735, 0.695, 0.777, 0.828, 0.850, 0.846, 0.818, 0.771, 0.705, 0.624, 0.530, 0.426, 0.314, 0.195, 0.073, -0.050, -0.173, -0.294, -0.409, -0.518, -0.617, -0.706, -0.780, -0.839, -0.879, -0.898, -0.893, -0.862, -0.803, -0.792, -0.789, -0.792, -0.801, -0.815, -0.833, -0.854, -0.879, -0.905, -0.932, -0.959, -0.985, -0.953, -0.900, -0.827, -0.753, -0.691, -0.555, -0.413, -0.271, -0.220, -0.152, -0.084, -0.018, 0.049, 0.115, 0.181, 0.247, 0.312, 0.377, 0.444, 0.508, 0.573, 0.636, 0.701, 0.765, 0.827, 0.890, 0.952, 1.013, 1.062, 1.161, 1.208, 1.254, 1.301, 1.336, 1.369, 1.400, 1.428, 1.442, 1.427, 1.374, 1.316, 1.277, 1.250, 1.246, 1.247, 1.256, 1.260, 1.271, 1.281, 1.289, 1.294, 1.304, 1.309, 1.315, 1.320, 1.330, 1.343, 1.354, 1.359, 1.360, 1.325, 1.288, 1.251, 1.215, 1.181, 1.120, 1.076, 1.056, 1.066, 1.064, 1.035, 0.980, 0.904, 0.810, 0.702, 0.582, 0.456, 0.326, 0.197, 0.072, -0.050, -0.170, -0.287, -0.399, -0.502, -0.596, -0.677, -0.743, -0.792, -0.821, -0.826, -0.806, -0.758, -0.679, -0.735, -0.368, 0.000];
    s.Airfoil_DU25_A17.Cd = [0.0202, 0.0324, 0.0943, 0.2848, 0.4001, 0.5215, 0.6447, 0.7660, 0.8823, 0.9911, 10.905, 11.787, 12.545, 13.168, 13.650, 13.984, 14.169, 14.201, 14.081, 13.811, 13.394, 12.833, 12.138, 11.315, 10.378, 0.9341, 0.8221, 0.7042, 0.5829, 0.4616, 0.3441, 0.3209, 0.2972, 0.2730, 0.2485, 0.2237, 0.1990, 0.1743, 0.1498, 0.1256, 0.1020, 0.0789, 0.0567, 0.0271, 0.0303, 0.0287, 0.0271, 0.0264, 0.0114, 0.0094, 0.0086, 0.0073, 0.0071, 0.0070, 0.0069, 0.0068, 0.0068, 0.0068, 0.0067, 0.0067, 0.0067, 0.0065, 0.0065, 0.0066, 0.0067, 0.0068, 0.0069, 0.0070, 0.0071, 0.0073, 0.0076, 0.0079, 0.0099, 0.0117, 0.0132, 0.0143, 0.0153, 0.0165, 0.0181, 0.0211, 0.0262, 0.0336, 0.0420, 0.0515, 0.0601, 0.0693, 0.0785, 0.0888, 0.1000, 0.1108, 0.1219, 0.1325, 0.1433, 0.1541, 0.1649, 0.1754, 0.1845, 0.1953, 0.2061, 0.2170, 0.2280, 0.2390, 0.2536, 0.2814, 0.3098, 0.3386, 0.3678, 0.3972, 0.4563, 0.5149, 0.5720, 0.6548, 0.7901, 0.9190, 10.378, 11.434, 12.333, 13.055, 13.587, 13.922, 14.063, 14.042, 13.985, 13.973, 13.810, 13.498, 13.041, 12.442, 11.709, 10.852, 0.9883, 0.8818, 0.7676, 0.6481, 0.5264, 0.4060, 0.2912, 0.0995, 0.0356, 0.0202];
    s.Airfoil_DU25_A17.Cm = [0.0000, 0.1845, 0.3701, 0.2679, 0.3046, 0.3329, 0.3540, 0.3693, 0.3794, 0.3854, 0.3878, 0.3872, 0.3841, 0.3788, 0.3716, 0.3629, 0.3529, 0.3416, 0.3292, 0.3159, 0.3017, 0.2866, 0.2707, 0.2539, 0.2364, 0.2181, 0.1991, 0.1792, 0.1587, 0.1374, 0.1154, 0.1101, 0.1031, 0.0947, 0.0849, 0.0739, 0.0618, 0.0488, 0.0351, 0.0208, 0.0060, -0.0091, -0.0243, -0.0349, -0.0361, -0.0464, -0.0534, -0.0650, -0.0782, -0.0904, -0.1006, -0.1107, -0.1135, -0.1162, -0.1186, -0.1209, -0.1231, -0.1252, -0.1272, -0.1293, -0.1311, -0.1330, -0.1347, -0.1364, -0.1380, -0.1396, -0.1411, -0.1424, -0.1437, -0.1448, -0.1456, -0.1445, -0.1419, -0.1403, -0.1382, -0.1362, -0.1320, -0.1276, -0.1234, -0.1193, -0.1152, -0.1115, -0.1081, -0.1052, -0.1026, -0.1000, -0.0980, -0.0969, -0.0968, -0.0973, -0.0981, -0.0992, -0.1006, -0.1023, -0.1042, -0.1064, -0.1082, -0.1110, -0.1143, -0.1179, -0.1219, -0.1261, -0.1303, -0.1375, -0.1446, -0.1515, -0.1584, -0.1651, -0.1781, -0.1904, -0.2017, -0.2173, -0.2418, -0.2650, -0.2867, -0.3072, -0.3265, -0.3446, -0.3616, -0.3775, -0.3921, -0.4057, -0.4180, -0.4289, -0.4385, -0.4464, -0.4524, -0.4563, -0.4577, -0.4563, -0.4514, -0.4425, -0.4288, -0.4095, -0.3836, -0.3497, -0.3065, -0.3706, -0.1846, 0.0000];

    who.Airfoil_DU21_A17 = 'Properties and Data for the "DU21_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_DU21_A17.about = who.Airfoil_DU21_A17;           
    s.Airfoil_DU21_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.00, -14.50, -12.01, -11.00, -9.98, -8.12, -7.62, -7.11, -6.60, -6.50, -6.00, -5.50, -5.00, -4.50, -4.00, -3.50, -3.00, -2.50, -2.00, -1.50, -1.00, -0.50, 0.00, 0.50, 1.00, 1.50, 2.00, 2.50, 3.00, 3.50, 4.00, 4.50, 5.00, 5.50, 6.00, 6.50, 7.00, 7.50, 8.00, 8.50, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.00, 14.50, 15.00, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 18.50, 19.00, 19.50, 20.00, 20.50, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_DU21_A17.Cl = [0.000, 0.394, 0.788, 0.670, 0.749, 0.797, 0.818, 0.813, 0.786, 0.739, 0.675, 0.596, 0.505, 0.403, 0.294, 0.179, 0.060, -0.060, -0.179, -0.295, -0.407, -0.512, -0.608, -0.693, -0.764, -0.820, -0.857, -0.875, -0.869, -0.838, -0.791, -0.794, -0.805, -0.821, -0.843, -0.869, -0.899, -0.931, -0.964, -0.999, -1.033, -1.050, -0.953, -0.900, -0.827, -0.536, -0.467, -0.393, -0.323, -0.311, -0.245, -0.178, -0.113, -0.048, 0.016, 0.080, 0.145, 0.208, 0.270, 0.333, 0.396, 0.458, 0.521, 0.583, 0.645, 0.706, 0.768, 0.828, 0.888, 0.948, 0.996, 1.046, 1.095, 1.145, 1.192, 1.239, 1.283, 1.324, 1.358, 1.385, 1.403, 1.401, 1.358, 1.313, 1.287, 1.274, 1.272, 1.273, 1.273, 1.273, 1.272, 1.273, 1.275, 1.281, 1.284, 1.296, 1.306, 1.308, 1.308, 1.308, 1.308, 1.307, 1.311, 1.325, 1.324, 1.277, 1.229, 1.182, 1.136, 1.093, 1.017, 0.962, 0.937, 0.947, 0.950, 0.928, 0.884, 0.821, 0.740, 0.646, 0.540, 0.425, 0.304, 0.179, 0.053, -0.073, -0.198, -0.319, -0.434, -0.541, -0.637, -0.720, -0.787, -0.836, -0.864, -0.869, -0.847, -0.795, -0.711, -0.788, -0.394, 0.000];
    s.Airfoil_DU21_A17.Cd = [0.0185, 0.0332, 0.0945, 0.2809, 0.3932, 0.5112, 0.6309, 0.7485, 0.8612, 0.9665, 10.625, 11.476, 12.206, 12.805, 13.265, 13.582, 13.752, 13.774, 13.648, 13.376, 12.962, 12.409, 11.725, 10.919, 10.002, 0.8990, 0.7900, 0.6754, 0.5579, 0.4405, 0.3256, 0.3013, 0.2762, 0.2506, 0.2246, 0.1983, 0.1720, 0.1457, 0.1197, 0.0940, 0.0689, 0.0567, 0.0271, 0.0303, 0.0287, 0.0124, 0.0109, 0.0092, 0.0083, 0.0089, 0.0082, 0.0074, 0.0069, 0.0065, 0.0063, 0.0061, 0.0058, 0.0057, 0.0057, 0.0057, 0.0057, 0.0057, 0.0057, 0.0057, 0.0058, 0.0058, 0.0059, 0.0061, 0.0063, 0.0066, 0.0071, 0.0079, 0.0090, 0.0103, 0.0113, 0.0122, 0.0131, 0.0139, 0.0147, 0.0158, 0.0181, 0.0211, 0.0255, 0.0301, 0.0347, 0.0401, 0.0468, 0.0545, 0.0633, 0.0722, 0.0806, 0.0900, 0.0987, 0.1075, 0.1170, 0.1270, 0.1368, 0.1464, 0.1562, 0.1664, 0.1770, 0.1878, 0.1987, 0.2100, 0.2214, 0.2499, 0.2786, 0.3077, 0.3371, 0.3664, 0.4246, 0.4813, 0.5356, 0.6127, 0.7396, 0.8623, 0.9781, 10.846, 11.796, 12.617, 13.297, 13.827, 14.202, 14.423, 14.512, 14.480, 14.294, 13.954, 13.464, 12.829, 12.057, 11.157, 10.144, 0.9033, 0.7845, 0.6605, 0.5346, 0.4103, 0.2922, 0.0969, 0.0334, 0.0185];
    s.Airfoil_DU21_A17.Cm = [0.0000, 0.1978, 0.3963, 0.2738, 0.3118, 0.3413, 0.3636, 0.3799, 0.3911, 0.3980, 0.4012, 0.4014, 0.3990, 0.3943, 0.3878, 0.3796, 0.3700, 0.3591, 0.3471, 0.3340, 0.3199, 0.3049, 0.2890, 0.2722, 0.2545, 0.2359, 0.2163, 0.1958, 0.1744, 0.1520, 0.1262, 0.1170, 0.1059, 0.0931, 0.0788, 0.0631, 0.0464, 0.0286, 0.0102, -0.0088, -0.0281, -0.0378, -0.0349, -0.0361, -0.0464, -0.0821, -0.0924, -0.1015, -0.1073, -0.1083, -0.1112, -0.1146, -0.1172, -0.1194, -0.1213, -0.1232, -0.1252, -0.1268, -0.1282, -0.1297, -0.1310, -0.1324, -0.1337, -0.1350, -0.1363, -0.1374, -0.1385, -0.1395, -0.1403, -0.1406, -0.1398, -0.1390, -0.1378, -0.1369, -0.1353, -0.1338, -0.1317, -0.1291, -0.1249, -0.1213, -0.1177, -0.1142, -0.1103, -0.1066, -0.1032, -0.1002, -0.0971, -0.0940, -0.0909, -0.0883, -0.0865, -0.0854, -0.0849, -0.0847, -0.0850, -0.0858, -0.0869, -0.0883, -0.0901, -0.0922, -0.0949, -0.0980, -0.1017, -0.1059, -0.1105, -0.1172, -0.1239, -0.1305, -0.1370, -0.1433, -0.1556, -0.1671, -0.1778, -0.1923, -0.2154, -0.2374, -0.2583, -0.2782, -0.2971, -0.3149, -0.3318, -0.3476, -0.3625, -0.3763, -0.3890, -0.4004, -0.4105, -0.4191, -0.4260, -0.4308, -0.4333, -0.4330, -0.4294, -0.4219, -0.4098, -0.3922, -0.3682, -0.3364, -0.2954, -0.3966, -0.1978, 0.0000];

    who.Airfoil_NACA64_A17 = 'Properties and Data for the "NACA64_A17" Airfoil. Values ​​obtained in Appendix B by Jonkman and ROSCO version ROSCO-v.2.9.1 (2024) by Abbas (2022), in NREL-15MW Wind Turbine data.';
    s.Airfoil_NACA64_A17.about = who.Airfoil_NACA64_A17;      
    s.Airfoil_NACA64_A17.alpha = [-180.00, -175.00, -170.00, -160.00, -155.00, -150.00, -145.00, -140.00, -135.00, -130.00, -125.00, -120.00, -115.00, -110.00, -105.00, -100.00, -95.00, -90.00, -85.00, -80.00, -75.00, -70.00, -65.00, -60.00, -55.00, -50.00, -45.00, -40.00, -35.00, -30.00, -25.00, -24.00, -23.00, -22.00, -21.00, -20.00, -19.00, -18.00, -17.00, -16.00, -15.00, -14.00, -13.50, -13.00, -12.00, -11.00, -10.00, -9.00, -8.00, -7.00, -6.00, -5.00, -4.00, -3.00, -2.00, -1.00, 0.00, 1.00, 2.00, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 8.50, 9.00, 9.50, 10.00, 10.50, 11.00, 11.50, 12.00, 12.50, 13.00, 13.50, 14.00, 14.50, 15.00, 15.50, 16.00, 16.50, 17.00, 17.50, 18.00, 18.50, 19.00, 19.50, 20.00, 21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 28.00, 30.00, 32.00, 35.00, 40.00, 45.00, 50.00, 55.00, 60.00, 65.00, 70.00, 75.00, 80.00, 85.00, 90.00, 95.00, 100.00, 105.00, 110.00, 115.00, 120.00, 125.00, 130.00, 135.00, 140.00, 145.00, 150.00, 155.00, 160.00, 170.00, 175.00, 180.00];
    s.Airfoil_NACA64_A17.Cl = [0.000, 0.374, 0.749, 0.659, 0.736, 0.783, 0.803, 0.798, 0.771, 0.724, 0.660, 0.581, 0.491, 0.390, 0.282, 0.169, 0.052, -0.067, -0.184, -0.299, -0.409, -0.512, -0.606, -0.689, -0.759, -0.814, -0.850, -0.866, -0.860, -0.829, -0.853, -0.870, -0.890, -0.911, -0.934, -0.958, -0.982, -1.005, -1.082, -1.113, -1.105, -1.078, -1.053, -1.015, -0.904, -0.807, -0.711, -0.595, -0.478, -0.375, -0.264, -0.151, -0.017, 0.088, 0.213, 0.328, 0.442, 0.556, 0.670, 0.784, 0.898, 1.011, 1.103, 1.181, 1.257, 1.293, 1.326, 1.356, 1.382, 1.400, 1.415, 1.425, 1.434, 1.443, 1.451, 1.453, 1.448, 1.444, 1.445, 1.447, 1.448, 1.444, 1.438, 1.439, 1.448, 1.452, 1.448, 1.438, 1.428, 1.401, 1.359, 1.300, 1.220, 1.168, 1.116, 1.015, 0.926, 0.855, 0.800, 0.804, 0.793, 0.763, 0.717, 0.656, 0.582, 0.495, 0.398, 0.291, 0.176, 0.053, -0.074, -0.199, -0.321, -0.436, -0.543, -0.640, -0.723, -0.790, -0.840, -0.868, -0.872, -0.850, -0.798, -0.714, -0.749, -0.374, 0.000];
    s.Airfoil_NACA64_A17.Cd = [0.0198, 0.0341, 0.0955, 0.2807, 0.3919, 0.5086, 0.6267, 0.7427, 0.8537, 0.9574, 10.519, 11.355, 12.070, 12.656, 13.104, 13.410, 13.572, 13.587, 13.456, 13.181, 12.765, 12.212, 11.532, 10.731, 0.9822, 0.8820, 0.7742, 0.6610, 0.5451, 0.4295, 0.3071, 0.2814, 0.2556, 0.2297, 0.2040, 0.1785, 0.1534, 0.1288, 0.1037, 0.0786, 0.0535, 0.0283, 0.0158, 0.0151, 0.0134, 0.0121, 0.0111, 0.0099, 0.0091, 0.0086, 0.0082, 0.0079, 0.0072, 0.0064, 0.0054, 0.0052, 0.0052, 0.0052, 0.0053, 0.0053, 0.0054, 0.0058, 0.0091, 0.0113, 0.0124, 0.0130, 0.0136, 0.0143, 0.0150, 0.0267, 0.0383, 0.0498, 0.0613, 0.0727, 0.0841, 0.0954, 0.1065, 0.1176, 0.1287, 0.1398, 0.1509, 0.1619, 0.1728, 0.1837, 0.1947, 0.2057, 0.2165, 0.2272, 0.2379, 0.2590, 0.2799, 0.3004, 0.3204, 0.3377, 0.3554, 0.3916, 0.4294, 0.4690, 0.5324, 0.6452, 0.7573, 0.8664, 0.9708, 10.693, 11.606, 12.438, 13.178, 13.809, 14.304, 14.565, 14.533, 14.345, 14.004, 13.512, 12.874, 12.099, 11.196, 10.179, 0.9064, 0.7871, 0.6627, 0.5363, 0.4116, 0.2931, 0.0971, 0.0334, 0.0198];
    s.Airfoil_NACA64_A17.Cm = [0.0000, 0.1880, 0.3770, 0.2747, 0.3130, 0.3428, 0.3654, 0.3820, 0.3935, 0.4007, 0.4042, 0.4047, 0.4025, 0.3981, 0.3918, 0.3838, 0.3743, 0.3636, 0.3517, 0.3388, 0.3248, 0.3099, 0.2940, 0.2772, 0.2595, 0.2409, 0.2212, 0.2006, 0.1789, 0.1563, 0.1156, 0.1040, 0.0916, 0.0785, 0.0649, 0.0508, 0.0364, 0.0218, 0.0129, -0.0028, -0.0251, -0.0419, -0.0521, -0.0610, -0.0707, -0.0722, -0.0734, -0.0772, -0.0807, -0.0825, -0.0832, -0.0841, -0.0869, -0.0912, -0.0946, -0.0971, -0.1014, -0.1076, -0.1126, -0.1157, -0.1199, -0.1240, -0.1234, -0.1184, -0.1163, -0.1163, -0.1160, -0.1154, -0.1149, -0.1145, -0.1143, -0.1147, -0.1158, -0.1165, -0.1153, -0.1131, -0.1112, -0.1101, -0.1103, -0.1109, -0.1114, -0.1111, -0.1097, -0.1079, -0.1080, -0.1090, -0.1086, -0.1077, -0.1099, -0.1169, -0.1190, -0.1235, -0.1393, -0.1440, -0.1486, -0.1577, -0.1668, -0.1759, -0.1897, -0.2126, -0.2344, -0.2553, -0.2751, -0.2939, -0.3117, -0.3285, -0.3444, -0.3593, -0.3731, -0.3858, -0.3973, -0.4075, -0.4162, -0.4231, -0.4280, -0.4306, -0.4304, -0.4270, -0.4196, -0.4077, -0.3903, -0.3665, -0.3349, -0.2942, -0.3771, -0.1879, 0.0000];
    
    % ## Organizing output results      
    WindTurbine_data.AirfoilData = who.AirfoilData; WindTurbine_data.Airfoil_Cylinder1 = s.Airfoil_Cylinder1; WindTurbine_data.Airfoil_Cylinder2 = s.Airfoil_Cylinder2; WindTurbine_data.Airfoil_DU40_A17 = s.Airfoil_DU40_A17; WindTurbine_data.Airfoil_DU35_A17 = s.Airfoil_DU35_A17; WindTurbine_data.Airfoil_DU30_A17 = s.Airfoil_DU30_A17; WindTurbine_data.Airfoil_DU25_A17 = s.Airfoil_DU25_A17; WindTurbine_data.Airfoil_DU21_A17 = s.Airfoil_DU21_A17; WindTurbine_data.Airfoil_NACA64_A17 = s.Airfoil_NACA64_A17;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_03');


%=============================================================
elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF HUB AND NACELLE PROPERTIES (OFFLINE):
    % Purpose of this Logical Instance: to represent the characteristics 
    % and data of the rotor hub and nacelle used in the studies and 
    % analysis of the IEA-15MW wind turbine.


    % ---------- Hub and Nacelle Properties  ----------   
    who.Notef2_7 = 'Hub and Nacelle Properties';
    who.HYawBearing = 'Elevation of Yaw Bearing above Ground, in [m].';
    s.HYawBearing = 87.6;
    who.DxHubTower = 'Distance between the Rotor Center (Hub) in relation to the Center of the Tower diameter Kooijman (2003), in [m].';
    s.DxHubTower = 5;
    who.DzYaw = 'Vertical Distance along from Hub Center to Yaw Axis, in [m].';
    s.DzYaw = 1.96256;
    who.DxYaw = 'Distance along shaft from Hub Center to Yaw Axis, in [m].';
    s.DxYaw = 5.01910;  
    who.DxYawBearing = 'Distance along shaft from Hub Center to Main Bearing, in [m].';
    s.DxYawBearing = 1.912;   
    who.Mhub = 'Hub Mass, em [kg].';
    s.Mhub = 56780; 
    who.J_hub = 'Hub Inertia about Low-Speed Shaft, em [kg.m^2].';
    s.J_hub = 115926;     
    who.Mnacelle = 'Nacelle Mass, em [kg].';
    s.Mnacelle = 240000;
    who.J_nacelle = 'Nacelle Inertia about Yaw Axis, em [kg].';
    s.J_nacelle = 2607890;
    who.DxYaw = 'Nacelle CM Location Downwind of Yaw Axis, in [m].';
    s.DxYaw = 1.9;
    who.DxYawBearing = 'Nacelle CM Location above Yaw Bearing, in [m].';
    s.DxYawBearing = 1.75; 
    who.KKnacelle = 'Equivalent Nacelle-Yaw-Actuator Linear-Sprint Constant, in [N.m/rad].';
    s.KKnacelle = 9028320000;
    who.CCnacelle = 'Equivalent Nacelle-Yaw-Actuator Linear-Damping Constant, in [N.m/(rad/s)].';
    s.CCnacelle = 19160000; 
    who.YawDot_rated = 'Nominal Nacelle-Yaw Rate, in [deg/seg]';
    s.YawDot_rated = 0.3;     
    who.tau_Yaw = 'Time constant for first-order model of yaw dynamics, in [seg].';
    s.tau_Yaw = s.YawDot_rated;   
    

    % ## Organizing output results      
    WindTurbine_data.Notef2_7 = who.Notef2_7; WindTurbine_data.HYawBearing = s.HYawBearing; WindTurbine_data.DzYaw = s.DzYaw; WindTurbine_data.DxYaw = s.DxYaw; WindTurbine_data.DxYawBearing = s.DxYawBearing; WindTurbine_data.Mhub = s.Mhub; WindTurbine_data.J_hub = s.J_hub; WindTurbine_data.Mnacelle = s.Mnacelle; WindTurbine_data.J_nacelle = s.J_nacelle; WindTurbine_data.DxYaw = s.DxYaw; WindTurbine_data.DxYawBearing = s.DxYawBearing; WindTurbine_data.KKnacelle = s.KKnacelle; WindTurbine_data.CCnacelle = s.CCnacelle; WindTurbine_data.YawDot_rated = s.YawDot_rated; WindTurbine_data.tau_Yaw = s.tau_Yaw; WindTurbine_data.DxHubTower = s.DxHubTower;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_04');


%=============================================================
elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF DRIVE TRAIN PROPERTIES (OFFLINE):
    % Purpose of this Logical Instance: to represent the characteristics 
    % and data of the drive train used in the studies and analysis of 
    % the IEA-15MW wind turbine.


    % ---------- Drive Train Properties (Drive Train Dynamics) ---------- 
    who.Notef2_8 = 'Drive Train Properties (Drive Train Dynamics).';
    who.eta_gb = 'Gearbox gear ratio, in [-].'; 
    s.eta_gb = 97; 
    who.tau_brakeDt = 'High-Speed Shaft Brake Time Constant, in [seg].'; 
    s.tau_brakeDt = 0.6;   

    who.FNdt_1 = 'Natural frequency of the fist Drivetrain Torsion, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNdt_1 = 0.6205;

    who.FNdt_1Pmin = 'Minimum rotor rotation frequency (1P), in [Hz].'; 
    s.FNdt_1Pmin = s.RotorSpeed_CutIn/60;
    who.FNdt_1Pmax = 'Maximum rotor rotation frequency (1P), in [Hz].'; 
    s.FNdt_1Pmax = s.RotorSpeed_Rated/60;    
    who.FNdt_3Pmin = 'Minimum 3P (blade passing frequency), in [Hz].'; 
    s.FNdt_3Pmin = s.N_blades*s.FNdt_1Pmin; 
    who.FNdt_3Pmax = 'Maximum 3P (blade passing frequency), in [Hz].';
    s.FNdt_3Pmax = s.N_blades*s.FNdt_1Pmax;   

    who.J_r = 'Rotor disk inertia, in [kg.m^2].'; 
    s.J_r = 3.8677e+07;   

    who.KK_ls = 'Low-speed shaft stiffness constant, in [N.m]. Parameter used in the Two-Mass and Three-Mass models, in the drivetrain dynamics.';
    s.KK_ls = 520582200;  
    who.CC_ls = 'Low-speed shaft damping constant, in [N.m.s]. Parameter used in the Two-Mass and Three-Mass models, in the drivetrain dynamics.';
    s.CC_ls = 3729000;
    who.CC_r = 'Rotor damping constant, in [N.m.s]. Parameter used in the Two-Mass models, in the drivetrain dynamics.';
    s.CC_r = 4.2553e+04;     

    who.J_gb1 = 'Gearbox inertia relative to the low-speed shaft, in [kg.m^2].'; 
    s.J_gb1 = 23206200;      
    who.J_gb1 = 'Gearbox inertia relative to the low-speed shaft, in [kg.m^2].'; 
    s.J_gb1 = 23206200;             

    who.J_g = 'Generator disk inertia, in [kg.m^2]'; 
    s.J_g = 534.116;              
    who.KK_hs = 'High-speed shaft stiffness constant, in [N.m]. Parameter used in the Three-Mass models, in the drivetrain dynamics.';
    s.KK_hs = 347054800;  
    who.CC_hs = 'High-speed shaft damping constant, in [N.m.s]. Parameter used in the Three-Mass models, in the drivetrain dynamics.';
    s.CC_hs = 2486000;
    who.CC_g = 'Generator damping constant, in [N.m.s]. Parameter used in the Two-Mass models, in the drivetrain dynamics.';
    s.CC_g = 3.2990e+04;    

    who.J_t = 'Total inertia for the One-Mass Model, in [kg.m^2]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
    s.J_t = (s.J_r + ((s.eta_gb^2)*s.J_g));  
    who.KKdt = 'Total/Equivalent Drive-Shaft Torsional-Spring Constant for the One-Mass Model, in [N.m]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
    s.KKdt = (s.KK_ls + (s.eta_gb^2*s.KK_hs) );  
    who.CCdt = 'Total/Equivalent Drive-Shaft Torsional-Damping Constant for the One-Mass Model, in [N.m.s]. Parameter used in the One-Mass models, in the drivetrain dynamics.';
    s.CCdt = 3.2847e+04;

    
    % Organizing output results  
    WindTurbine_data.Notef2_8 = who.Notef2_8; WindTurbine_data.eta_gb = s.eta_gb; WindTurbine_data.tau_brakeDt = s.tau_brakeDt;
    WindTurbine_data.FNdt_1 = s.FNdt_1; WindTurbine_data.FNdt_1Pmin = s.FNdt_1Pmin; WindTurbine_data.FNdt_1Pmax = s.FNdt_1Pmax; WindTurbine_data.FNdt_3Pmin = s.FNdt_3Pmin; WindTurbine_data.FNdt_3Pmax = s.FNdt_3Pmax;
    WindTurbine_data.J_r = s.J_r; WindTurbine_data.KK_ls = s.KK_ls; WindTurbine_data.CC_ls = s.CC_ls; WindTurbine_data.CC_r = s.CC_r; 
    WindTurbine_data.J_gb1 = s.J_gb1; WindTurbine_data.J_gb1 = s.J_gb1;
    WindTurbine_data.J_g = s.J_g; WindTurbine_data.KK_hs = s.KK_hs; WindTurbine_data.CC_hs = s.CC_hs; WindTurbine_data.CC_g = s.CC_g; 
    WindTurbine_data.J_t = s.J_t; WindTurbine_data.KKdt = s.KKdt; WindTurbine_data.CCdt = s.CCdt;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_05');


%=============================================================
elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF TOWER PROPERTIES (OFFLINE):
    % Purpose of this Logical Instance: to represent the characteristics 
    % and data of the tower used in the studies and analysis of the 
    % IEA-15MW wind turbine.


    % ---------- Tower Properties ----------
    who.Notef2_9 = 'Tower Properties.';
    who.HtowerG = 'Height above Ground, in [m].';
    s.HtowerG = 87.6;    
    who.CM_tower = 'CM Location with respect to ground along Tower Centerline)';
    s.CM_tower = 38.234;
    who.DiameterTowerTop = 'Tower diameter at the top of the tower, in [m].';
    s.DiameterTowerTop = 3.87;
    who.DiameterTowerBase = 'Tower diameter at the base of the tower, in [m].';
    s.DiameterTowerBase = 6;
    who.ThicknessTower = 'Tower thickness, in [m].';
    s.ThicknessTower = 0.027;     
    who.ElevTower = 'Vertical locations along the tower centerline relative to the tower base, in [m]. See Table 6-1 in Jonkman 2009 and OpenFast.';
    s.ElevTower = [0 8.76 17.52 26.28 35.04 43.80 52.56 61.32 70.08 78.84 87.60];    
    who.HtFract = 'The fractional height along the Tower centerline from the tower base (0.0) to the tower top (1.0)., in [m]. See Table 6-1 in Jonkman 2009 and OpenFast.'; 
    s.HtFract = [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];  
    who.TMassDen = 'Tower Mass along the tower, in [kg/m].'; 
    s.TMassDen = [4667 4345.28 4034.76 3735.44 3447.32 3170.4 2904.69 2650.18 2406.88 2174.77 1953.87];  
    who.TwFAStif = 'Stiffness along the centerline of the tower, in [N/m^2].'; 
    s.TwFAStif = [6.03903e11 5.17644e11 4.40925e11 3.73022e11 3.13236e11 2.60897e11 2.15365e11 1.76028e11 1.42301e11 1.13630e11 8.9488e10]; 
    who.MMtower_overall = 'Overall (integrated) Mass, in [kg].';
    s.MMtower_overall = 347460;
    who.MMeq_tower = 'Equivalent Mass of the tower, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.MMeq_tower = trapz(s.ElevTower, s.TMassDen); % OR s.MMtower_overall    
    % s.MMeq_tower = s.MMtower_overall ; % Jonkman considers paint, screws and other masses that make up the system.
    who.IIeq_tower = 'Equivalent Mass of the tower, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.IIeq_tower = trapz(s.ElevTower, s.TMassDen .* s.ElevTower.^2); % OR sumplify with: s.MMeq_tower * s.HtowerG^2;
    who.KKeq_tower = 'Equivalent Stiffness of the tower, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';
    s.KKeq_tower = trapz(s.ElevTower, s.TwFAStif);  
    who.CC_StrucRatio = 'Structural-Damping Ratio (All Modes), in [decimal].';
    s.CC_StrucRatio = 1/100; % s.CC_StrucRatio = 1%
    who.CCeq_tower = 'Equivalent Damping of the tower, in [kg]. Obtained from the integration of the properties Table 6.1 Jonkman 2009.';    
    s.CCeq_tower = 2 * s.CC_StrucRatio * sqrt(s.KKeq_tower * s.IIeq_tower);
    %s.F_natural = (1 / (2 * pi)) * sqrt(s.KKeq_tower / s.IIeq_tower);


    % ---------- Tower-Bending Properties (Tower Dynamics)  ----------
    who.FNtw_FA1 = 'Natural frequency of the fist Tower Fore-Aft, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNtw_FA1 = 0.3240;
    who.FNtw_FA2 = 'Natural frequency of the second Tower Fore-Aft, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNtw_FA2 = 2.9003;      
    who.FNtw_SS1 = 'Natural frequency of the fist Tower Side-to-Side, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNtw_SS1 = 0.3120;
    who.FNtw_SS2 = 'Natural frequency of the second Tower Side-to-Side, in [Hz]. See page 30 Jonkman (2009).'; 
    s.FNtw_SS2 = 2.9361; 
    who.Jxt = 'Total system inertia in the platform pitching direction, in [kg.m^2]';  
    who.MMxt = 'Total Mass of Rotor/Nacelle/Tower/Platform Structure, in [kg]';
    who.KKxt = 'Total restoring constant, in the platform pitching direction, in [N.m]';
    who.CCxt = 'Total damping constant in the platform pitching direction, in [N.m.s]';    
    if s.Option02f2 == 1
        % ONSHORE WIND TURBINE
        s.Jxt = s.IIeq_tower ; % s.IIeq_tower + (s.Mnacelle + s.Mrotor + s.Mhub) * s.HtowerG^2 ;
        s.MMxt = s.MMeq_tower ; % s.MMeq_tower + s.Mnacelle + s.Mrotor + s.Mhub ;
        s.KKxt = s.MMxt*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.Jxt ) ;
        %
    elseif s.Option02f2 == 2
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012).
        s.Jxt = s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMxt = s.Mtower + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKxt = s.Mtower*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.MMxt ) ;
        %
    elseif s.Option02f2 == 3
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform.
        s.Jxt = s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMxt = s.Mtower + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKxt = s.MMxt*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.Jxt ) ;
        %
    elseif s.Option02f2 == 4
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Submersible Platform.
        s.Jxt = s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMxt = s.Mtower + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKxt = s.MMxt*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.Jxt ) ;
        %
    elseif s.Option02f2 == 5
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Barge Platform.
        s.Jxt = s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMxt = s.Mtower + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKxt = s.MMxt*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.Jxt ) ;
        %
    elseif s.Option02f2 == 6
        % OFFSHORE WIND TURBINE: Fixed-Bottom Offshore Wind Turbine.
        s.Jxt = s.JJrotor + s.JJnacelle + s.JJtower_platf;
        s.MMxt = s.Mtower + s.Mnacelle + s.Mrotor + s.Mhub + s.Mplataform ;
        s.KKxt = s.Mtower*(2*pi*s.FNtw_FA1)^2;    
        s.CCxt = 0.01*2*sqrt( s.KKxt*s.MMxt ) ;         
        %
    end


    % Organizing output results
    WindTurbine_data.Notef2_9 = who.Notef2_9; WindTurbine_data.ElevTower = s.ElevTower; WindTurbine_data.HtowerG = s.HtowerG; WindTurbine_data.MMtower_overall = s.MMtower_overall; WindTurbine_data.CM_tower = s.CM_tower; WindTurbine_data.CC_StrucRatio = s.CC_StrucRatio;
    WindTurbine_data.FNtw_FA1 = s.FNtw_FA1; WindTurbine_data.FNtw_FA2 = s.FNtw_FA2; WindTurbine_data.FNtw_SS1 = s.FNtw_SS1; WindTurbine_data.FNtw_SS2 = s.FNtw_SS2;       
    WindTurbine_data.MMeq_tower = s.MMeq_tower; WindTurbine_data.IIeq_tower = s.IIeq_tower; WindTurbine_data.KKeq_tower = s.KKeq_tower; WindTurbine_data.CC_StrucRatio = s.CC_StrucRatio; WindTurbine_data.CCeq_tower = s.CCeq_tower;    
    WindTurbine_data.Jxt = s.Jxt; WindTurbine_data.CCxt = s.CCxt; WindTurbine_data.KKxt = s.KKxt;
    WindTurbine_data.DiameterTowerTop = s.DiameterTowerTop; WindTurbine_data.DiameterTowerBase = s.DiameterTowerBase; WindTurbine_data.ThicknessTower= s.ThicknessTower;
 

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_06');


%=============================================================
elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF POWER GENERATION PROPERTIES (OFFLINE):
    % Purpose of this Logical Instance: to represent the characteristics
    % and data of the power generation system used in the studies and 
    % analysis of the IEA-15MW wind turbine.


    % ---------- Power Generation Properties ----------
    who.Notef2_10 = 'Power Generation Properties.';
    who.etaElec_op = 'Electrical Generator Efficiency, in [-].'; 
    s.etaElec_op = 0.9440;
    who.Pmec_max = 'Maximum Mechanical Power, in [W]. According to page 57 of Jonkman, the nominal power of the generator (VS_RtPwr).';
    s.Pmec_max = s.Pe_rated/s.etaElec_op;    
    who.Tmec_max = 'Maximum Mechanical Torque, in [W].';
    s.Tmec_max = s.Pmec_max/s.OmegaR_Rated;
    who.Te_max = 'Maximum Electrical Torque, in [W].';
    s.Te_max = s.Pe_rated/( s.OmegaR_Rated*s.eta_gb ); 
    who.Tg_rated = 'Rated Generator Torque, in [W]. See page 19-20 Jonkman (2009).';
    s.Tg_rated = 1.1*s.eta_gb*s.Te_max;       

    % Organizing output results
    WindTurbine_data.Notef2_10 = who.Notef2_10; WindTurbine_data.etaElec_op = s.etaElec_op; WindTurbine_data.Pmec_max = s.Pmec_max; WindTurbine_data.Tmec_max = s.Tmec_max; WindTurbine_data.Te_max = s.Te_max; WindTurbine_data.Tg_rated = s.Tg_rated;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_07');


%=============================================================
elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % IEA-15MW MAIN DATA OF OTHERS PROPERTIES AND PARAMETERS (OFFLINE):
    % Purpose of this Logical Instance: to represent other characteristics
    % and data, not classified or organized here, and used in the studies
    % and analysis of the IEA-15MW wind turbine.

    
    % ---------- Others parameters ----------
    who.Notef2_11 = 'Others parameters.';
    who.gravity = 'Test variable, in [unit in SI]';
    s.gravity = 9.81; 
    who.OveralCM_wt ='Wind Turbine´s Coordinate Location of Overall CM'; 
    s.OveralCM_wt = [-0.2 0 64];  

    % Organizing output results
    WindTurbine_data.Notef2_11 = who.Notef2_11; WindTurbine_data.gravity = s.gravity; 
    WindTurbine_data.OveralCM_wt= s.OveralCM_wt;


    % ---------- All Frequencies considered in the Wind Turbine problem ----------    
    who.Notef2_12 = 'All Frequencies considered in the Wind Turbine problem.';
    who.AllFreqWT = 'Vector with All Frequencies considered in the Wind Turbine problem (onshore or offshore), in [Hz]';
    s.AllFreqWT = [s.FNba_FY1, s.FNba_FY2, s.FNba_EY1, s.FNba_FP1, s.FNba_FP2, s.FNba_EP1, s.FNb_CF1, s.FNb_CF2, s.FNdt_1, s.FNdt_1Pmin, s.FNdt_1Pmax, s.FNdt_3Pmin, s.FNdt_3Pmax, s.FNtw_FA1, s.FNtw_FA2, s.FNtw_SS1, s.FNtw_SS2];

    % Organizing output results    
    WindTurbine_data.AllFreqWT = s.AllFreqWT; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_08');


%=============================================================
elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================     
    % IEA-15MW AERODYNAMIC PERFORMANCE DATA AND CHARACTERISTICS (OFFLINE):
    % Purpose of this Logical Instance: to represent the aerodynamic 
    % performance of the IEA-15MW wind turbine, using the Blade Element
    % Momentum Method or data obtained from OpenFast or ROSCO tools.


    % --- Choose the way to obtain the CP, CT and CQ Coefficients ---
    who.Notef5_1 = 'Aerodynamic performance of the IEA-15MW reference wind turbine.';
    if s.Option01f5 == 1
        % Use the Aerodynamic Coefficients saved 
        who.BETA = 'Blade Pitch, in [deg]. Values ​​obtained by the Classical Blade Element Moment Method, proposed in this code and from values ​​of the IEA-15MW Reference Wind Turbine.';
        s.BETA = [-5.0, -4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0];
        who.LAMBDA = 'Tip-Speed-Ratio, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method, proposed in this code and from values ​​of the IEA-15MW Reference Wind Turbine.';
        s.LAMBDA = [2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 14.0, 14.5];
        who.CP = 'Power coefficient, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method, proposed in this code and from values ​​of the IEA-15MW Reference Wind Turbine.';
        s.CP = [0.007251, 0.009366, 0.011532, 0.013754, 0.016030, 0.018361, 0.020743, 0.023171, 0.025639, 0.028138, 0.030661, 0.033197, 0.035734, 0.038256, 0.040747, 0.043187, 0.045550, 0.047810, 0.049936, 0.051897, 0.053662, 0.055201, 0.056484, 0.057483, 0.058172, 0.058531, 0.058546, 0.058209, 0.057521, 0.056485, 0.055109, 0.053405, 0.051389, 0.049081, 0.046504, 0.043681; 0.019436, 0.023469, 0.027566, 0.031716, 0.035901, 0.040106, 0.044314, 0.048503, 0.052654, 0.056737, 0.060719, 0.064557, 0.068203, 0.071605, 0.074711, 0.077467, 0.079822, 0.081726, 0.083134, 0.084008, 0.084324, 0.084069, 0.083239, 0.081840, 0.079890, 0.077416, 0.074455, 0.071049, 0.067242, 0.063073, 0.058583, 0.053805, 0.048771, 0.043510, 0.038045, 0.032401; 0.040873, 0.047384, 0.053880, 0.060337, 0.066726, 0.073010, 0.079139, 0.085049, 0.090666, 0.095911, 0.100701, 0.104952, 0.108582, 0.111511, 0.113669, 0.115001, 0.115469, 0.115051, 0.113747, 0.111576, 0.108583, 0.104831, 0.100393, 0.095345, 0.089759, 0.083701, 0.077230, 0.070398, 0.063247, 0.055811, 0.048117, 0.040189, 0.032053, 0.023739, 0.015286, 0.006739; 0.071922, 0.081223, 0.090360, 0.099264, 0.107843, 0.115989, 0.123588, 0.130519, 0.136658, 0.141883, 0.146076, 0.149137, 0.150984, 0.151558, 0.150835, 0.148829, 0.145596, 0.141230, 0.135840, 0.129545, 0.122463, 0.114703, 0.106360, 0.097519, 0.088247, 0.078597, 0.068602, 0.058288, 0.047675, 0.036788, 0.025655, 0.014316, 0.002824, -0.008747, -0.020309, -0.031760; 0.112210, 0.124428, 0.136127, 0.147153, 0.157342, 0.166524, 0.174528, 0.181184, 0.186337, 0.189854, 0.191631, 0.191617, 0.189824, 0.186328, 0.181256, 0.174767, 0.167032, 0.158221, 0.148494, 0.137993, 0.126842, 0.115143, 0.102966, 0.090358, 0.077345, 0.063943, 0.050165, 0.036027, 0.021558, 0.006806, -0.008152, -0.023215, -0.038258, -0.053140, -0.067708, -0.081808; 0.160744, 0.175535, 0.189193, 0.201491, 0.212200, 0.221097, 0.227976, 0.232657, 0.235015, 0.235013, 0.232702, 0.228208, 0.221720, 0.213461, 0.203662, 0.192545, 0.180317, 0.167165, 0.153244, 0.138678, 0.123550, 0.107909, 0.091772, 0.075145, 0.058026, 0.040419, 0.022347, 0.003863, -0.014946, -0.033958, -0.053018, -0.071946, -0.090543, -0.108599, -0.125905, -0.142264; 0.215508, 0.232038, 0.246580, 0.258847, 0.268572, 0.275521, 0.279539, 0.280586, 0.278731, 0.274129, 0.267014, 0.257668, 0.246378, 0.233418, 0.219048, 0.203506, 0.186993, 0.169673, 0.151662, 0.133020, 0.113764, 0.093892, 0.073386, 0.052235, 0.030445, 0.008053, -0.014861, -0.038173, -0.061710, -0.085261, -0.108584, -0.131412, -0.153464, -0.174463, -0.194166, -0.212382; 0.273409, 0.290382, 0.304333, 0.314975, 0.322107, 0.325649, 0.325656, 0.322281, 0.315769, 0.306444, 0.294638, 0.280671, 0.264850, 0.247466, 0.228784, 0.209029, 0.188372, 0.166917, 0.144698, 0.121714, 0.097940, 0.073347, 0.047912, 0.021640, -0.005422, -0.033172, -0.061446, -0.090018, -0.118617, -0.146928, -0.174607, -0.201292, -0.226633, -0.250324, -0.272140, -0.291950; 0.329940, 0.345825, 0.357721, 0.365512, 0.369187, 0.368855, 0.364705, 0.357044, 0.346232, 0.332617, 0.316536, 0.298322, 0.278299, 0.256768, 0.233983, 0.210130, 0.185307, 0.159535, 0.132794, 0.105043, 0.076235, 0.046337, 0.015346, -0.016689, -0.049648, -0.083330, -0.117454, -0.151684, -0.185632, -0.218873, -0.250954, -0.281433, -0.309924, -0.336143, -0.359938, -0.381277; 0.378913, 0.392827, 0.402281, 0.407245, 0.407807, 0.404144, 0.396553, 0.385362, 0.370919, 0.353572, 0.333678, 0.311600, 0.287685, 0.262231, 0.235460, 0.207478, 0.178297, 0.147882, 0.116177, 0.083123, 0.048675, 0.012815, -0.024416, -0.062889, -0.102373, -0.142536, -0.182976, -0.223236, -0.262804, -0.301131, -0.337666, -0.371914, -0.403505, -0.432231, -0.458045, -0.481019; 0.414137, 0.426640, 0.434735, 0.438252, 0.437168, 0.431569, 0.421719, 0.407950, 0.390623, 0.370132, 0.346894, 0.321325, 0.293792, 0.264573, 0.233806, 0.201507, 0.167634, 0.132125, 0.094914, 0.055943, 0.015178, -0.027358, -0.071544, -0.117134, -0.163753, -0.210939, -0.258162, -0.304829, -0.350292, -0.393882, -0.434965, -0.473039, -0.507800, -0.539156, -0.567171, -0.592043; 0.433494, 0.445408, 0.453612, 0.457766, 0.457122, 0.451418, 0.440746, 0.425459, 0.406045, 0.383025, 0.356925, 0.328219, 0.297279, 0.264317, 0.229380, 0.192438, 0.153433, 0.112299, 0.068972, 0.023405, -0.024405, -0.074363, -0.126232, -0.179610, -0.233981, -0.288748, -0.343237, -0.396710, -0.448374, -0.497442, -0.543232, -0.585284, -0.623410, -0.657639, -0.688166, -0.715333; 0.436275, 0.449825, 0.460056, 0.466253, 0.467887, 0.463986, 0.454086, 0.438469, 0.417833, 0.392926, 0.364422, 0.332858, 0.298591, 0.261751, 0.222351, 0.180355, 0.135712, 0.088363, 0.038258, -0.014631, -0.070251, -0.128399, -0.188679, -0.250533, -0.313300, -0.376234, -0.438507, -0.499220, -0.557428, -0.612238, -0.662965, -0.709250, -0.751038, -0.788492, -0.821956, -0.851931; 0.424080, 0.440891, 0.454815, 0.465074, 0.470360, 0.469685, 0.462112, 0.447500, 0.426558, 0.400386, 0.369866, 0.335620, 0.297965, 0.257011, 0.212785, 0.165271, 0.114436, 0.060240, 0.002647, -0.058332, -0.122556, -0.189675, -0.259116, -0.330166, -0.402007, -0.473733, -0.544346, -0.612770, -0.677901, -0.738770, -0.794748, -0.845614, -0.891455, -0.932585, -0.969506, -1.002893; 0.403225, 0.422321, 0.440019, 0.455114, 0.465482, 0.469256, 0.465301, 0.452924, 0.432637, 0.405791, 0.373578, 0.336709, 0.295516, 0.250155, 0.200697, 0.147161, 0.089543, 0.027824, -0.038007, -0.107881, -0.181531, -0.258423, -0.337808, -0.418810, -0.500446, -0.581631, -0.661181, -0.737821, -0.810291, -0.877597, -0.939224, -0.995103, -1.045473, -1.090812, -1.131786, -1.169271; 0.378667, 0.400003, 0.419627, 0.438155, 0.453992, 0.463410, 0.463981, 0.454979, 0.436339, 0.409399, 0.375743, 0.336229, 0.291301, 0.241205, 0.186074, 0.125979, 0.060950, -0.009009, -0.083872, -0.163480, -0.247402, -0.334900, -0.425051, -0.516804, -0.608998, -0.700354, -0.789472, -0.874863, -0.955135, -1.029325, -1.097075, -1.158474, -1.213926, -1.264074, -1.309756, -1.352105; 0.350359, 0.374771, 0.396930, 0.417478, 0.437099, 0.452466, 0.458747, 0.453923, 0.437825, 0.411368, 0.376451, 0.334231, 0.285343, 0.230155, 0.168885, 0.101662, 0.028556, -0.050401, -0.135131, -0.225348, -0.320412, -0.419385, -0.521164, -0.624514, -0.728077, -0.830353, -0.929702, -1.024413, -1.112999, -1.194592, -1.269008, -1.336503, -1.397648, -1.453260, -1.504368, -1.552428; 0.318190, 0.346332, 0.371772, 0.394998, 0.416885, 0.437225, 0.449740, 0.449954, 0.437173, 0.411769, 0.375746, 0.330742, 0.277648, 0.216989, 0.149085, 0.074133, -0.007756, -0.096514, -0.191983, -0.293708, -0.400817, -0.512175, -0.626491, -0.742331, -0.858113, -0.972094, -1.082370, -1.187008, -1.284474, -1.374056, -1.455746, -1.529969, -1.597472, -1.659253, -1.716558, -1.771272; 0.282822, 0.314588, 0.343918, 0.370530, 0.395163, 0.418674, 0.437283, 0.443350, 0.434457, 0.410621, 0.373648, 0.325771, 0.268209, 0.201678, 0.126618, 0.043300, -0.048118, -0.147520, -0.254635, -0.368793, -0.488887, -0.613585, -0.741394, -0.870659, -0.999552, -1.126057, -1.247986, -1.363197, -1.470173, -1.568390, -1.658016, -1.739651, -1.814222, -1.882926, -1.947258, -2.009672; 0.244861, 0.280050, 0.313269, 0.343892, 0.371942, 0.398346, 0.421836, 0.434161, 0.429698, 0.407920, 0.370170, 0.319321, 0.257011, 0.184184, 0.101416, 0.009059, -0.092674, -0.203600, -0.323297, -0.450843, -0.584905, -0.723943, -0.866246, -1.009914, -1.152846, -1.292729, -1.427073, -1.553547, -1.670720, -1.778272, -1.876547, -1.966322, -2.048715, -2.125141, -2.197389, -2.268659; 0.204978, 0.243295, 0.280083, 0.314978, 0.347072, 0.376832, 0.404146, 0.422494, 0.422989, 0.403651, 0.365310, 0.311383, 0.244029, 0.164458, 0.073398, -0.028706, -0.141575, -0.264940, -0.398183, -0.540109, -0.689163, -0.843589, -1.001430, -1.160518, -1.318456, -1.472606, -1.620157, -1.758633, -1.886748, -2.004386, -2.112067, -2.210750, -2.301763, -2.386757, -2.467869, -2.549268; 0.164551, 0.204712, 0.244978, 0.283811, 0.320432, 0.354104, 0.384950, 0.408505, 0.414375, 0.397797, 0.359066, 0.301946, 0.229233, 0.142443, 0.042477, -0.070114, -0.194981, -0.331731, -0.479509, -0.636848, -0.801965, -0.972868, -1.147334, -1.322900, -1.496848, -1.666187, -1.827775, -1.979040, -2.118894, -2.247415, -2.365297, -2.473697, -2.574170, -2.668622, -2.759615, -2.852537; 0.123406, 0.165506, 0.208120, 0.250782, 0.291942, 0.330045, 0.364619, 0.392577, 0.403851, 0.390360, 0.351426, 0.290990, 0.212584, 0.118076, 0.008560, -0.115295, -0.253050, -0.404164, -0.567499, -0.741323, -0.923619, -1.112130, -1.304348, -1.497491, -1.688490, -1.873974, -2.050464, -2.215360, -2.367797, -2.508038, -2.636958, -2.755923, -2.866736, -2.971582, -3.073543, -3.179506; 0.081919, 0.125711, 0.170327, 0.216226, 0.261618, 0.304542, 0.343187, 0.375127, 0.391476, 0.381325, 0.342377, 0.278492, 0.194038, 0.091286, -0.028452, -0.164378, -0.315948, -0.482428, -0.662379, -0.853805, -1.054435, -1.261731, -1.472870, -1.684728, -1.893856, -2.096473, -2.288771, -2.468189, -2.634096, -2.786934, -2.927765, -3.058183, -3.180258, -3.296479, -3.410571, -3.531209; 0.041584, 0.085346, 0.132094, 0.180334, 0.229751, 0.277509, 0.320600, 0.356398, 0.377301, 0.370718, 0.331902, 0.264422, 0.173544, 0.061998, -0.068663, -0.217497, -0.383839, -0.566719, -0.764382, -0.974568, -1.194731, -1.422028, -1.653298, -1.885048, -2.113418, -2.334189, -2.543243, -2.738124, -2.918432, -3.084779, -3.238430, -3.381229, -3.515528, -3.644151, -3.771614, -3.908675;0.003397, 0.045453, 0.093229, 0.143805, 0.196595, 0.248906, 0.296781, 0.336522, 0.361457, 0.358550, 0.319976, 0.248745, 0.151048, 0.030135, -0.112176, -0.274788, -0.456888, -0.657231, -0.873742, -1.103887, -1.344823, -1.593379, -1.846033, -2.098890, -2.347652, -2.587633, -2.814435, -3.025765, -3.221441, -3.402247, -3.569666, -3.725808, -3.873334, -4.015434, -4.157593, -4.312929];
        who.CT = 'Thrust coefficient (CT), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method, proposed in this code and from values ​​of the IEA-15MW Reference Wind Turbine.';                
        s.CT = [0.069339, 0.069285, 0.069265, 0.069284, 0.069348, 0.069462, 0.069631, 0.069861, 0.070156, 0.070515, 0.070940, 0.071427, 0.071969, 0.072555, 0.073167, 0.073784, 0.074381, 0.074929, 0.075399, 0.075762, 0.075989, 0.076053, 0.075927, 0.075585, 0.075002, 0.074156, 0.073033, 0.071627, 0.069936, 0.067961, 0.065707, 0.063182, 0.060399, 0.057373, 0.054125, 0.050677; 0.091816, 0.092396, 0.093076, 0.093861, 0.094755, 0.095757, 0.096861, 0.098053, 0.099312, 0.100607, 0.101899, 0.103144, 0.104293, 0.105296, 0.106103, 0.106664, 0.106932, 0.106859, 0.106400, 0.105518, 0.104185, 0.102388, 0.100122, 0.097389, 0.094199, 0.090571, 0.086535, 0.082128, 0.077386, 0.072348, 0.067046, 0.061514, 0.055786, 0.049889, 0.043854, 0.037706; 0.123474, 0.125175, 0.127037, 0.129041, 0.131158, 0.133343, 0.135537, 0.137673, 0.139677, 0.141468, 0.142968, 0.144098, 0.144778, 0.144928, 0.144475, 0.143363, 0.141549, 0.139013, 0.135746, 0.131760, 0.127085, 0.121773, 0.115886, 0.109490, 0.102647, 0.095413, 0.087844, 0.079990, 0.071896, 0.063601, 0.055138, 0.046541, 0.037842, 0.029084, 0.020313, 0.011584;0.165573, 0.168765, 0.172067, 0.175395, 0.178652, 0.181729, 0.184510, 0.186878, 0.188712, 0.189886, 0.190280, 0.189783, 0.188309, 0.185796, 0.182213, 0.177561, 0.171880, 0.165246, 0.157753, 0.149506, 0.140602, 0.131135, 0.121193, 0.110856, 0.100191, 0.089257, 0.078096, 0.066745, 0.055241, 0.043622, 0.031934, 0.020232, 0.008586, -0.002925, -0.014205, -0.025150; 0.218578, 0.223272, 0.227828, 0.232089, 0.235890, 0.239062, 0.241423, 0.242792, 0.242998, 0.241890, 0.239359, 0.235341, 0.229830, 0.222880, 0.214602, 0.205136, 0.194628, 0.183227, 0.171072, 0.158293, 0.145007, 0.131310, 0.117282, 0.102979, 0.088445, 0.073715, 0.058829, 0.043826, 0.028760, 0.013705, -0.001248, -0.015985, -0.030377, -0.044284, -0.057563, -0.070069; 0.282170, 0.287984, 0.293205, 0.297595, 0.300902, 0.302869, 0.303257, 0.301860, 0.298532, 0.293212, 0.285926, 0.276781, 0.265950, 0.253634, 0.240038, 0.225364, 0.209800, 0.193518, 0.176663, 0.159356, 0.141688, 0.123724, 0.105508, 0.087076, 0.068461, 0.049704, 0.030866, 0.012031, -0.006687, -0.025154, -0.043209, -0.060678, -0.077376, -0.093114, -0.107708, -0.120989; 0.355551, 0.361717, 0.366570, 0.369761, 0.370962, 0.369889, 0.366343, 0.360246, 0.351638, 0.340662, 0.327543, 0.312549, 0.295952, 0.278014, 0.258980, 0.239067, 0.218462, 0.197319, 0.175758, 0.153858, 0.131672, 0.109234, 0.086576, 0.063737, 0.040774, 0.017772, -0.005152, -0.027850, -0.050141, -0.071820, -0.092665, -0.112437, -0.130896, -0.147809, -0.162979, -0.176255; 0.437424, 0.442600, 0.445428, 0.445527, 0.442621, 0.436568, 0.427391, 0.415241, 0.400373, 0.383119, 0.363825, 0.342820, 0.320406, 0.296858, 0.272415, 0.247283, 0.221625, 0.195556, 0.169146, 0.142442, 0.115476, 0.088285, 0.060910, 0.033423, 0.005927, -0.021432, -0.048470, -0.074961, -0.100651, -0.125266, -0.148509, -0.170083, -0.189704, -0.207135, -0.222205, -0.234819; 0.525460, 0.527667, 0.526388, 0.521407, 0.512676, 0.500320, 0.484572, 0.465789, 0.444390, 0.420775, 0.395313, 0.368336, 0.340148, 0.311014, 0.281163, 0.250768, 0.219948, 0.188774, 0.157288, 0.125523, 0.093512, 0.061304, 0.028977, -0.003353, -0.035515, -0.067288, -0.098400, -0.128550, -0.157409, -0.184625, -0.209836, -0.232697, -0.252917, -0.270290, -0.284715, -0.296179; 0.615952, 0.613062, 0.605901, 0.594509, 0.579067, 0.559868, 0.537340, 0.511939, 0.484103, 0.454230, 0.422681, 0.389789, 0.355853, 0.321130, 0.285821, 0.250056, 0.213904, 0.177405, 0.140589, 0.103492, 0.066167, 0.028691, -0.008807, -0.046142, -0.083058, -0.119241, -0.154343, -0.187982, -0.219751, -0.249221, -0.275974, -0.299648, -0.319983, -0.336843, -0.350215, -0.360169; 0.704449, 0.694964, 0.681074, 0.662912, 0.640727, 0.614890, 0.585866, 0.554109, 0.520036, 0.484043, 0.446498, 0.407746, 0.368089, 0.327760, 0.286907, 0.245605, 0.203892, 0.161803, 0.119377, 0.076670, 0.033761, -0.009223, -0.052085, -0.094547, -0.136257, -0.176821, -0.215808, -0.252755, -0.287172, -0.318563, -0.346472, -0.370554, -0.390616, -0.406617, -0.418630, -0.426816; 0.788050, 0.771081, 0.750180, 0.725566, 0.697249, 0.665444, 0.630464, 0.592722, 0.552663, 0.510720, 0.467303, 0.422770, 0.377405, 0.331392, 0.284823, 0.237745, 0.190200, 0.142234, 0.093911, 0.045313, -0.003438, -0.052150, -0.100535, -0.148212, -0.194742, -0.239647, -0.282414, -0.322495, -0.359318, -0.392326, -0.421055, -0.445212, -0.464702, -0.479579, -0.490008, -0.496248; 0.865515, 0.840957, 0.813170, 0.782370, 0.748642, 0.711681, 0.671434, 0.628192, 0.582472, 0.534801, 0.485644, 0.435368, 0.384230, 0.332362, 0.279836, 0.226708, 0.173041, 0.118910, 0.064405, 0.009644, -0.045195, -0.099832, -0.153874, -0.206843, -0.258215, -0.307428, -0.353882, -0.396940, -0.435949, -0.470305, -0.499570, -0.523541, -0.542228, -0.555781, -0.564463, -0.568631; 0.936624, 0.904628, 0.870386, 0.834093, 0.795408, 0.753900, 0.709091, 0.660970, 0.609969, 0.556782, 0.501963, 0.445906, 0.388839, 0.330884, 0.272133, 0.212671, 0.152595, 0.092013, 0.031045, -0.030145, -0.091302, -0.152046, -0.211872, -0.270212, -0.326456, -0.379954, -0.430018, -0.475915, -0.516910, -0.552380, -0.581950, -0.605533, -0.623237, -0.635315, -0.642129, -0.644126; 1.003783, 0.963890, 0.923043, 0.881412, 0.838282, 0.792686, 0.743893, 0.691437, 0.635555, 0.577025, 0.516565, 0.454614, 0.391411, 0.327117, 0.261867, 0.195788, 0.129019, 0.061701, -0.006008, -0.073887, -0.141587, -0.208610, -0.274348, -0.338143, -0.399299, -0.457078, -0.510691, -0.559303, -0.602106, -0.638490, -0.668186, -0.691219, -0.707803, -0.718289, -0.723134, -0.722877; 1.069660, 1.021807, 0.973433, 0.925583, 0.877961, 0.828685, 0.776187, 0.719857, 0.659500, 0.595781, 0.529650, 0.461644, 0.392082, 0.321193, 0.249169, 0.176195, 0.102450, 0.028111, -0.046621, -0.121447, -0.195907, -0.269379, -0.341162, -0.410508, -0.476633, -0.538701, -0.595814, -0.647027, -0.691478, -0.728616, -0.758297, -0.780656, -0.796011, -0.804806, -0.807593, -0.805005; 1.135151, 1.079519, 1.023640, 0.968618, 0.915361, 0.862272, 0.806463, 0.746481, 0.681967, 0.613212, 0.541346, 0.467113, 0.390965, 0.313224, 0.234158, 0.154010, 0.073002, -0.008650, -0.090686, -0.172715, -0.254145, -0.334241, -0.412210, -0.487216, -0.558380, -0.624756, -0.685326, -0.739035, -0.785001, -0.822768, -0.852322, -0.873908, -0.887939, -0.894954, -0.895600, -0.890608; 1.200634, 1.137445, 1.074091, 1.011838, 0.951774, 0.894037, 0.834912, 0.771492, 0.703048, 0.629422, 0.551751, 0.471121, 0.388161, 0.303315, 0.216936, 0.129330, 0.040767, -0.048492, -0.138117, -0.227598, -0.316208, -0.403110, -0.487418, -0.568205, -0.644486, -0.715195, -0.779185, -0.835299, -0.882669, -0.920969, -0.950309, -0.971037, -0.983660, -0.988810, -0.987235, -0.979770; 1.265255, 1.195691, 1.124977, 1.055449, 0.988373, 0.924624, 0.861796, 0.795127, 0.722837, 0.644478, 0.560948, 0.473752, 0.383758, 0.291553, 0.197588, 0.102236, 0.005819, -0.091347, -0.188842, -0.286020, -0.382025, -0.475922, -0.566734, -0.653432, -0.734914, -0.809987, -0.877364, -0.935804, -0.984492, -1.023251, -1.052305, -1.072100, -1.083234, -1.086438, -1.082566, -1.072555; 1.328343, 1.253526, 1.176341, 1.099544, 1.025366, 0.954961, 0.887436, 0.817466, 0.741390, 0.658428, 0.569007, 0.475083, 0.377831, 0.278012, 0.176184, 0.072792, -0.031782, -0.137156, -0.242799, -0.347918, -0.451540, -0.552633, -0.650122, -0.742865, -0.829637, -0.909108, -0.979846, -1.040544, -1.090488, -1.129647, -1.158354, -1.177145, -1.186712, -1.187891, -1.181646, -1.169016; 1.389243, 1.310229, 1.227774, 1.144163, 1.062812, 0.985517, 0.912297, 0.838613, 0.758818, 0.671306, 0.575987, 0.475177, 0.370448, 0.262756, 0.152781, 0.041050, -0.071988, -0.185871, -0.299938, -0.413247, -0.524713, -0.633211, -0.737554, -0.836483, -0.928639, -1.012543, -1.086618, -1.149524, -1.200679, -1.240192, -1.268496, -1.286214, -1.294139, -1.293215, -1.284523, -1.269193; 1.446495, 1.365446, 1.278456, 1.189187, 1.100736, 1.016407, 0.936851, 0.858699, 0.775201, 0.683140, 0.581940, 0.474094, 0.361664, 0.245836, 0.127425, 0.007052, -0.114760, -0.237453, -0.360218, -0.481968, -0.601517, -0.717631, -0.829012, -0.934270, -1.031906, -1.120281, -1.197677, -1.262753, -1.315088, -1.354917, -1.382763, -1.399343, -1.405550, -1.402447, -1.391234, -1.373118; 1.500721, 1.417864, 1.328236, 1.234040, 1.139124, 1.047650, 0.961392, 0.877983, 0.790575, 0.693978, 0.586914, 0.471885, 0.351528, 0.227296, 0.100156, -0.029167, -0.160066, -0.291867, -0.423604, -0.554054, -0.681927, -0.805878, -0.924482, -1.036215, -1.139429, -1.232316, -1.313020, -1.380245, -1.433740, -1.473850, -1.501186, -1.516561, -1.520978, -1.515620, -1.501808, -1.480814; 1.551807, 1.467724, 1.376212, 1.278271, 1.177831, 1.079246, 0.986033, 0.896750, 0.805016, 0.703846, 0.590948, 0.468593, 0.340079, 0.207169, 0.071004, -0.067579, -0.207877, -0.349086, -0.490070, -0.629485, -0.765930, -0.897937, -1.023953, -1.142311, -1.251201, -1.348641, -1.432649, -1.502015, -1.556654, -1.597013, -1.623789, -1.637895, -1.640449, -1.632760, -1.616272, -1.592298; 1.598372, 1.515229, 1.421950, 1.321664, 1.216399, 1.111177, 1.010820, 0.915192, 0.818588, 0.712807, 0.594079, 0.464255, 0.327350, 0.185486, 0.039995, -0.108161, -0.258171, -0.409083, -0.559596, -0.708245, -0.853511, -0.993800, -1.127420, -1.252552, -1.367219, -1.469253, -1.556568, -1.628077, -1.683852, -1.724429, -1.750594, -1.763367, -1.763986, -1.753891, -1.734646, -1.707584; 1.639737, 1.559431, 1.465833, 1.363446, 1.254467, 1.143376, 1.035772, 0.933446, 0.831408, 0.720912, 0.596337, 0.458902, 0.313369, 0.162271, 0.007152, -0.150891, -0.310927, -0.471838, -0.632165, -0.790322, -0.944662, -1.093459, -1.234875, -1.366933, -1.487477, -1.594151, -1.684783, -1.758447, -1.815350, -1.856114, -1.881620, -1.892996, -1.891607, -1.879032, -1.856946, -1.826682];
        who.CQ = 'Torque coefficient (CQ), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method, proposed in this code and from values ​​of the IEA-15MW Reference Wind Turbine.';
        s.CQ = [0.003634, 0.004694, 0.005780, 0.006894, 0.008035, 0.009203, 0.010397, 0.011614, 0.012851, 0.014104, 0.015368, 0.016639, 0.017911, 0.019175, 0.020423, 0.021646, 0.022831, 0.023963, 0.025029, 0.026012, 0.026897, 0.027668, 0.028311, 0.028812, 0.029157, 0.029337, 0.029344, 0.029176, 0.028831, 0.028311, 0.027622, 0.026768, 0.025757, 0.024600, 0.023309, 0.021894; 0.007794, 0.009410, 0.011053, 0.012717, 0.014396, 0.016082, 0.017769, 0.019449, 0.021113, 0.022750, 0.024347, 0.025886, 0.027348, 0.028712, 0.029957, 0.031062, 0.032007, 0.032770, 0.033335, 0.033685, 0.033812, 0.033710, 0.033377, 0.032816, 0.032034, 0.031042, 0.029855, 0.028489, 0.026962, 0.025291, 0.023490, 0.021574, 0.019556, 0.017446, 0.015255, 0.012992; 0.013658, 0.015833, 0.018004, 0.020161, 0.022296, 0.024396, 0.026444, 0.028419, 0.030296, 0.032048, 0.033649, 0.035069, 0.036282, 0.037261, 0.037982, 0.038427, 0.038584, 0.038444, 0.038008, 0.037283, 0.036283, 0.035029, 0.033546, 0.031859, 0.029993, 0.027968, 0.025806, 0.023523, 0.021134, 0.018649, 0.016078, 0.013429, 0.010710, 0.007932, 0.005108, 0.002252; 0.020599, 0.023263, 0.025880, 0.028430, 0.030887, 0.033221, 0.035397, 0.037382, 0.039141, 0.040637, 0.041838, 0.042715, 0.043244, 0.043408, 0.043201, 0.042626, 0.041701, 0.040450, 0.038906, 0.037103, 0.035075, 0.032852, 0.030463, 0.027930, 0.025275, 0.022511, 0.019649, 0.016694, 0.013655, 0.010537, 0.007348, 0.004100, 0.000809, -0.002505, -0.005817, -0.009097; 0.028121, 0.031183, 0.034115, 0.036878, 0.039432, 0.041733, 0.043739, 0.045407, 0.046698, 0.047579, 0.048025, 0.048021, 0.047572, 0.046696, 0.045425, 0.043798, 0.041860, 0.039652, 0.037214, 0.034582, 0.031788, 0.028856, 0.025804, 0.022645, 0.019383, 0.016025, 0.012572, 0.009029, 0.005403, 0.001706, -0.002043, -0.005818, -0.009588, -0.013317, -0.016968, -0.020502; 0.035808, 0.039103, 0.042145, 0.044885, 0.047271, 0.049253, 0.050785, 0.051828, 0.052353, 0.052353, 0.051838, 0.050837, 0.049391, 0.047552, 0.045369, 0.042892, 0.040168, 0.037238, 0.034137, 0.030892, 0.027523, 0.024038, 0.020444, 0.016740, 0.012926, 0.009004, 0.004978, 0.000861, -0.003329, -0.007565, -0.011811, -0.016027, -0.020170, -0.024192, -0.028047, -0.031691; 0.043207, 0.046521, 0.049436, 0.051896, 0.053846, 0.055239, 0.056044, 0.056254, 0.055882, 0.054960, 0.053533, 0.051660, 0.049396, 0.046798, 0.043917, 0.040801, 0.037490, 0.034017, 0.030406, 0.026669, 0.022808, 0.018824, 0.014713, 0.010473, 0.006104, 0.001615, -0.002979, -0.007653, -0.012372, -0.017094, -0.021770, -0.026347, -0.030768, -0.034978, -0.038928, -0.042580; 0.049832, 0.052926, 0.055468, 0.057408, 0.058708, 0.059353, 0.059355, 0.058740, 0.057553, 0.055853, 0.053701, 0.051156, 0.048272, 0.045104, 0.041699, 0.038098, 0.034333, 0.030423, 0.026373, 0.022184, 0.017851, 0.013368, 0.008733, 0.003944, -0.000988, -0.006046, -0.011199, -0.016407, -0.021619, -0.026779, -0.031824, -0.036688, -0.041307, -0.045625, -0.049601, -0.053212; 0.055124, 0.057778, 0.059766, 0.061067, 0.061681, 0.061626, 0.060933, 0.059653, 0.057846, 0.055571, 0.052885, 0.049842, 0.046496, 0.042899, 0.039092, 0.035107, 0.030960, 0.026654, 0.022186, 0.017550, 0.012737, 0.007742, 0.002564, -0.002788, -0.008295, -0.013922, -0.019623, -0.025342, -0.031014, -0.036568, -0.041928, -0.047020, -0.051780, -0.056161, -0.060136, -0.063701; 0.058437, 0.060583, 0.062040, 0.062806, 0.062893, 0.062328, 0.061157, 0.059431, 0.057204, 0.054528, 0.051460, 0.048055, 0.044367, 0.040442, 0.036313, 0.031998, 0.027497, 0.022807, 0.017917, 0.012819, 0.007507, 0.001976, -0.003765, -0.009699, -0.015788, -0.021982, -0.028219, -0.034428, -0.040530, -0.046441, -0.052075, -0.057357, -0.062229, -0.066659, -0.070641, -0.074184; 0.059307, 0.061097, 0.062257, 0.062760, 0.062605, 0.061803, 0.060393, 0.058421, 0.055939, 0.053005, 0.049677, 0.046016, 0.042073, 0.037888, 0.033482, 0.028857, 0.024006, 0.018921, 0.013592, 0.008011, 0.002174, -0.003918, -0.010246, -0.016774, -0.023450, -0.030208, -0.036970, -0.043653, -0.050164, -0.056406, -0.062290, -0.067742, -0.072720, -0.077210, -0.081222, -0.084784; 0.057940, 0.059533, 0.060629, 0.061184, 0.061098, 0.060336, 0.058910, 0.056866, 0.054271, 0.051195, 0.047706, 0.043869, 0.039734, 0.035328, 0.030659, 0.025721, 0.020508, 0.015010, 0.009219, 0.003128, -0.003262, -0.009939, -0.016872, -0.024006, -0.031274, -0.038594, -0.045877, -0.053024, -0.059929, -0.066488, -0.072608, -0.078228, -0.083324, -0.087899, -0.091979, -0.095611; 0.054668, 0.056365, 0.057647, 0.058424, 0.058629, 0.058140, 0.056899, 0.054942, 0.052357, 0.049236, 0.045664, 0.041709, 0.037415, 0.032799, 0.027862, 0.022599, 0.017005, 0.011072, 0.004794, -0.001833, -0.008803, -0.016089, -0.023642, -0.031393, -0.039258, -0.047144, -0.054947, -0.062555, -0.069849, -0.076717, -0.083073, -0.088873, -0.094109, -0.098802, -0.102995, -0.106751; 0.050014, 0.051996, 0.053638, 0.054848, 0.055472, 0.055392, 0.054499, 0.052776, 0.050306, 0.047219, 0.043620, 0.039581, 0.035140, 0.030310, 0.025095, 0.019491, 0.013496, 0.007104, 0.000312, -0.006879, -0.014454, -0.022369, -0.030559, -0.038938, -0.047410, -0.055869, -0.064197, -0.072267, -0.079948, -0.087126, -0.093728, -0.099727, -0.105133, -0.109984, -0.114338, -0.118276; 0.044912, 0.047039, 0.049010, 0.050692, 0.051846, 0.052267, 0.051826, 0.050448, 0.048188, 0.045198, 0.041610, 0.037504, 0.032915, 0.027863, 0.022354, 0.016391, 0.009974, 0.003099, -0.004233, -0.012016, -0.020219, -0.028784, -0.037626, -0.046648, -0.055741, -0.064784, -0.073644, -0.082180, -0.090252, -0.097749, -0.104613, -0.110837, -0.116447, -0.121497, -0.126061, -0.130236; 0.039957, 0.042208, 0.044279, 0.046234, 0.047905, 0.048899, 0.048959, 0.048010, 0.046043, 0.043200, 0.039648, 0.035479, 0.030738, 0.025452, 0.019635, 0.013293, 0.006431, -0.000951, -0.008850, -0.017250, -0.026106, -0.035339, -0.044851, -0.054533, -0.064262, -0.073902, -0.083305, -0.092316, -0.100786, -0.108615, -0.115764, -0.122242, -0.128094, -0.133385, -0.138206, -0.142674; 0.035121, 0.037569, 0.039790, 0.041850, 0.043817, 0.045357, 0.045987, 0.045503, 0.043889, 0.041237, 0.037737, 0.033505, 0.028604, 0.023072, 0.016930, 0.010191, 0.002863, -0.005052, -0.013546, -0.022590, -0.032119, -0.042041, -0.052244, -0.062604, -0.072985, -0.083238, -0.093197, -0.102691, -0.111572, -0.119751, -0.127211, -0.133977, -0.140106, -0.145681, -0.150804, -0.155622; 0.030378, 0.033065, 0.035493, 0.037711, 0.039800, 0.041742, 0.042937, 0.042957, 0.041737, 0.039312, 0.035873, 0.031576, 0.026507, 0.020716, 0.014233, 0.007078, -0.000740, -0.009214, -0.018329, -0.028040, -0.038266, -0.048898, -0.059811, -0.070871, -0.081925, -0.092806, -0.103335, -0.113324, -0.122630, -0.131182, -0.138981, -0.146067, -0.152512, -0.158410, -0.163881, -0.169105; 0.025774, 0.028669, 0.031342, 0.033767, 0.036012, 0.038154, 0.039850, 0.040403, 0.039593, 0.037420, 0.034051, 0.029688, 0.024442, 0.018379, 0.011539, 0.003946, -0.004385, -0.013444, -0.023205, -0.033608, -0.044553, -0.055917, -0.067564, -0.079344, -0.091090, -0.102619, -0.113730, -0.124230, -0.133978, -0.142929, -0.151097, -0.158536, -0.165332, -0.171593, -0.177456, -0.183144; 0.021344, 0.024412, 0.027307, 0.029977, 0.032422, 0.034723, 0.036771, 0.037845, 0.037456, 0.035558, 0.032267, 0.027835, 0.022403, 0.016055, 0.008840, 0.000790, -0.008078, -0.017748, -0.028181, -0.039300, -0.050985, -0.063105, -0.075510, -0.088033, -0.100492, -0.112686, -0.124396, -0.135421, -0.145635, -0.155010, -0.163576, -0.171402, -0.178584, -0.185246, -0.191544, -0.197756; 0.017123, 0.020324, 0.023397, 0.026312, 0.028993, 0.031479, 0.033761, 0.035294, 0.035335, 0.033720, 0.030517, 0.026012, 0.020385, 0.013738, 0.006131, -0.002398, -0.011827, -0.022132, -0.033263, -0.045119, -0.057571, -0.070471, -0.083656, -0.096946, -0.110140, -0.123017, -0.135343, -0.146911, -0.157613, -0.167440, -0.176435, -0.184679, -0.192282, -0.199382, -0.206158, -0.212958; 0.013196, 0.016417, 0.019646, 0.022760, 0.025697, 0.028398, 0.030871, 0.032760, 0.033231, 0.031901, 0.028795, 0.024215, 0.018383, 0.011423, 0.003406, -0.005623, -0.015637, -0.026603, -0.038454, -0.051072, -0.064314, -0.078019, -0.092011, -0.106090, -0.120040, -0.133620, -0.146579, -0.158710, -0.169925, -0.180232, -0.189686, -0.198379, -0.206436, -0.214011, -0.221308, -0.228760; 0.009516, 0.012762, 0.016048, 0.019338, 0.022512, 0.025450, 0.028116, 0.030272, 0.031141, 0.030101, 0.027099, 0.022439, 0.016393, 0.009105, 0.000660, -0.008890, -0.019513, -0.031165, -0.043760, -0.057164, -0.071221, -0.085757, -0.100579, -0.115473, -0.130201, -0.144504, -0.158113, -0.170828, -0.182583, -0.193397, -0.203338, -0.212512, -0.221057, -0.229141, -0.237004, -0.245175; 0.006083, 0.009335, 0.012648, 0.016056, 0.019426, 0.022614, 0.025483, 0.027855, 0.029069, 0.028315, 0.025423, 0.020679, 0.014408, 0.006778, -0.002113, -0.012206, -0.023461, -0.035823, -0.049185, -0.063399, -0.078297, -0.093690, -0.109368, -0.125099, -0.140628, -0.155673, -0.169953, -0.183275, -0.195595, -0.206944, -0.217401, -0.227085, -0.236150, -0.244780, -0.253252, -0.262210; 0.002978, 0.006111, 0.009458, 0.012912, 0.016451, 0.019870, 0.022956, 0.025519, 0.027016, 0.026545, 0.023765, 0.018933, 0.012426, 0.004439, -0.004916, -0.015573, -0.027484, -0.040579, -0.054732, -0.069782, -0.085546, -0.101821, -0.118381, -0.134975, -0.151327, -0.167135, -0.182104, -0.196058, -0.208968, -0.220879, -0.231881, -0.242106, -0.251722, -0.260932, -0.270059, -0.279873; 0.000235, 0.003142, 0.006445, 0.009942, 0.013591, 0.017208, 0.020518, 0.023265, 0.024989, 0.024788, 0.022121, 0.017197, 0.010443, 0.002083, -0.007755, -0.018997, -0.031586, -0.045437, -0.060405, -0.076316, -0.092973, -0.110157, -0.127624, -0.145104, -0.162302, -0.178893, -0.194573, -0.209183, -0.222711, -0.235211, -0.246785, -0.257580, -0.267779, -0.277603, -0.287431, -0.298170];          
        %
        % ---------- Span-wise Variation of Power Extraction ----------
            % NOTICE: This solution (s.RCp_Dr) is from NREL5MW wind turbine
        % See step 19 of System_LoadsAerodynamics('logical_instance_03')            
        who.Rrd_local = 'Local Radius of each Blade Element (r), in [m].';
        s.Rrd_local = [126, 63.0000, 60.4000, 57.6667, 54.2500, 50.1500, 46.0500, 41.9500, 37.8500, 33.7500, 29.6500, 25.5500, 21.4500, 17.3500, 13.2500, 9.8333, 7.1000, 4.3667, 1.5000, 0];
        who.Vws = 'Upstream Wind Speed, in [m/s]. Discretized for implementation in BEM Theory.';
        s.Vws = [0, 3.0,  3.1862,  3.2862,  3.3862,  3.4862,  3.5862,  3.6862,  3.7862,  3.8862,  3.9862, 4.0862,  4.1862,  4.2862,  4.3862,  4.4862,  4.5862,  4.6862,  4.7862,  4.8862,  4.9862, 5.0862,  5.1862,  5.2862,  5.3862,  5.4862,  5.5862,  5.6862,  5.7862,  5.8862,  5.9862, 6.0862,  6.1862,  6.2862,  6.3862,  6.4862,  6.5862,  6.6862,  6.7862,  6.8862,  6.9862, 7.0862,  7.1862,  7.2862,  7.3862,  7.4862,  7.5862,  7.6359,  7.6862,  7.7862,  7.8862, 7.9862,  8.0862,  8.1862,  8.2862,  8.3862,  8.4862,  8.5862,  8.6862,  8.7862,  8.8862, 8.9862,  9.0862,  9.1862,  9.2862,  9.3862,  9.4862,  9.5862,  9.6862,  9.7862,  9.8862, 9.9862, 10.0862, 10.1862, 10.2194, 10.2862, 10.3862, 10.4862, 10.5862, 10.6862, 10.7862, 10.8862, 10.9862, 11.0862, 11.1862, 11.2862, 11.3862, 11.4205, 11.4862, 11.5862, 11.6862, 11.7862, 11.8862, 11.9862, 12.0862, 12.1862, 12.2862, 12.3862, 12.4862, 12.5862, 12.6862, 12.7862, 12.8862, 12.9862, 13.0862, 13.1862, 13.2862, 13.3862, 13.4862, 13.5862, 13.6862, 13.7862, 13.8862, 13.9862, 14.0862, 14.1862, 14.2862, 14.3862, 14.4862, 14.5862, 14.6862, 14.7862, 14.8862, 14.9862, 15.0862, 15.1862, 15.2862, 15.3862, 15.4862, 15.5862, 15.6862, 15.7862, 15.8862, 15.9862, 16.0862, 16.1862, 16.2862, 16.3862, 16.4862, 16.5862, 16.6862, 16.7862, 16.8862, 16.9862, 17.0862, 17.1862, 17.2862, 17.3862, 17.4862, 17.5862, 17.6862, 17.7862, 17.8862, 17.9862, 18.0862, 18.1862, 18.2862, 18.3862, 18.4862, 18.5862, 18.6862, 18.7862, 18.8862, 18.9862, 19.0862, 19.1862, 19.2862, 19.3862, 19.4862, 19.5862, 19.6862, 19.7862, 19.8862, 19.9862, 20.0862, 20.1862, 20.2862, 20.3862, 20.4862, 20.5862, 20.6862, 20.7862, 20.8862, 20.9862, 21.0862, 21.1862, 21.2862, 21.3862, 21.4862, 21.5862, 21.6862, 21.7862, 21.8862, 21.9862, 22.0862, 22.1862, 22.2862, 22.3862, 22.4862, 22.5862, 22.6862, 22.7862, 22.8862, 22.9862, 23.0862, 23.1862, 23.2862, 23.3862, 23.4862, 23.5862, 23.6862, 23.7862, 23.8862, 23.9862, 24.0862, 24.1862, 24.2862, 24.3862, 24.4862, 24.5862, 24.6862, 24.7862, 24.8862, 24.9862, 25.0000, 100];    
        who.RCp_Dr = 'Span-wise Variation of Power Extraction R*(dCp/dr). Partial derivative of Cp with respect to the radius differential.';        
        s.RCp_Dr = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;0,1.0313791567685,1.05888805250758,1.01462870218854,0.942258482782469,0.866052626248104,0.789111633273099,0.712030982710554,0.634913361821849,0.557780045332318,0.480629844145823,0.40344618718597,0.326180096205139,0.248683365068221,0.183919193877449,0.131653535990676,0.0763326537484083,0,0,0; 0,1.0245809453135,1.05633622319767,1.01385396099859,0.942070090070388,0.866005440726462,0.789098177228465,0.712026902290539,0.634911826121372,0.557778273318621,0.480625545890543,0.403435852385218,0.326156705992678,0.248630455745924,0.183822799872674,0.131502948443436,0.0761134577446341,0,0,0; 0,1.01771076244619,1.05367767407416,1.01301724613953,0.941859768320694,0.865951444804485,0.789082582463406,0.712022120938336,0.634910000173696,0.557776203352111,0.480620672672178,0.403424365960686,0.326131153118639,0.248573691642257,0.183720594333951,0.131348089652185,0.0759059144795668,0,0,0; 0,1.01077967671214,1.05091861249577,1.01211827712656,0.941626235574878,0.865889975501032,0.789064588982825,0.712016539563666,0.634907836973308,0.557773792279098,0.480615160270797,0.403411626078363,0.326103292735445,0.248512925677117,0.183612631053679,0.131189678360699,0.075708803569513,0,0,0; 0,1.0037976761735,1.04806530064875,1.01115706451725,0.941368264830059,0.865820349258236,0.78904392034881,0.712010049377731,0.634905283556676,0.557770992064237,0.480608939351467,0.403397525844713,0.326072977979212,0.248448022689406,0.183499017127403,0.131028448661161,0.0755211469512128,0,0,0; 0,0.996773754515454,1.04512403834375,1.01013401174985,0.941084742141476,0.865741877068042,0.789020281661319,0.712002530958605,0.63490228052059,0.557767749467388,0.48060193540569,0.403381953592236,0.326040061006629,0.248378861589331,0.183379909316677,0.130865134727319,0.075342131995051,0,0,0; 0,0.989715996444068,1.04210081803579,1.00904984294363,0.940774630496513,0.865653859798105,0.788993364116435,0.711993854314509,0.634898761735256,0.557764005722324,0.48059406864001,0.403364793261651,0.326004394201227,0.248305337645579,0.183255516789766,0.129269783244136,0.075171046536916,0,0,0; 0,0.982631830764943,1.03900166715801,1.00790549151389,0.94043702123312,0.865555604390419,0.78896284215408,0.711983879022978,0.634894653656373,0.557759696365547,0.480585254004382,0.40334592487601,0.325965831355556,0.248227364705642,0.183126097109937,0.128917535426288,0.0750072612084638,0,0,0; 0,0.975527432218509,1.03583235022011,1.00670220076724,0.940071129320971,0.865446428625044,0.788928379912925,0.711972453330437,0.634889875387392,0.557754750791376,0.480575401330635,0.403325225158955,0.325924229085341,0.248144876437947,0.182991946520141,0.128632463394635,0.0748502083797832,0,0,0; 0,0.968408797737039,1.03259840060231,1.00544140573264,0.939676263614932,0.86532565568015,0.788889627542001,0.711959415061508,0.634884337819289,0.5577490923635,0.480564415249445,0.403302567960748,0.325879448184707,0.248057828747471,0.182853405688464,0.128373646744795,0.0746993702687845,0,0,0; 0,0.96128115210106,1.02930510032606,1.00412471963622,0.939251884086735,0.865192641088485,0.78884622930033,0.711944591846409,0.634877944064687,0.557742637856,0.480552195564808,0.403277825214218,0.325831355386997,0.24796620067714,0.182710838105055,0.128130747064222,0.0745542707376324,0,0,0; 0,0.954149172644369,1.02595746789865,1.00275390188701,0.938797580901536,0.865046754893824,0.788797819163031,0.71192779986075,0.634870588451358,0.557735297878974,0.480538637600518,0.403250867855942,0.325779823837514,0.247869996548897,0.182564641370549,0.127899427077115,0.0744144693607455,0,0,0; 0,0.947017045072335,1.02256025266734,1.00133086627121,0.938313034386794,0.864887407009576,0.788744028913391,0.711908846954186,0.634862157381928,0.557726976213914,0.480523631880834,0.403221565870548,0.325724735726951,0.247769243047988,0.182415220567379,0.127677423264689,0.0742795569385243,0,0,0; 0,0.939888513976683,1.0191179343158,0.999857504997873,0.937798076811643,0.864714041002473,0.788684489232328,0.711887530064164,0.634852528218436,0.557717570423117,0.480507065566945,0.403189790226544,0.325665983739264,0.24766399403606,0.182263002513388,0.127463410791063,0.0741491544266544,0,0,0; 0,0.932766928381988,1.01563472633331,0.998335878542368,0.937252646942623,0.864526146820429,0.788618826488948,0.711863638658922,0.634841570336276,0.557706971960264,0.480488821604407,0.403155413840822,0.325603470037959,0.247554329292166,0.182108406979616,0.127256510450132,0.0740229005401773,0,0,0; 0,0.925655282697013,1.0121145824753,0.996768054528307,0.93667679369638,0.86432324102249,0.788546673743366,0.71183695498153,0.63482914518325,0.557695065398655,0.480468780383596,0.403118310667342,0.325537110668264,0.247440348620748,0.181951859456909,0.12705612154969,0.0739004631973141,0,0,0; 0,0.918556253456462,1.00856120540407,0.99515612135771,0.936070686736207,0.864104901563972,0.788467670285644,0.711807252099729,0.634815105279174,0.557681730335986,0.480446820191381,0.403078359279883,0.325466836033733,0.247322178766991,0.181793771033651,0.126861780106503,0.0737815284170354,0,0,0; 0,0.911472232234237,1.00497805684962,0.993502170932504,0.935434541867952,0.86387074969163,0.788381456622777,0.711774299187518,0.634799296414035,0.557666839842073,0.480422816257783,0.40303544336203,0.325392587800886,0.247199967230674,0.181634542022641,0.126673122931615,0.0736658007330732,0,0,0; 0,0.904405355093974,1.001368368761,0.991808283828909,0.934768709262965,0.86362046396446,0.78828768839887,0.711737861292419,0.634781557674146,0.557650262514273,0.480396643643249,0.402989449435689,0.325314325562793,0.247073884284016,0.180010525360003,0.126489848318343,0.0735530047457624,0,0,0; 0,0.897357528920861,0.997735155029306,0.990076516754735,0.93407360358693,0.863353750196554,0.788186031231111,0.711697696588889,0.634761720024542,0.557631862622466,0.480368177398797,0.402940272538102,0.325232025566381,0.246944111176843,0.179715915093468,0.12631169576937,0.0734428721728692,0,0,0; 0,0.890330454953566,0.99408122345597,0.988308892097373,0.933349710332851,0.863070384912633,0.788076167742521,0.711653563732271,0.63473960997599,0.557611499036459,0.480337290851897,0.40288781567893,0.32514567565268,0.246810851014788,0.179455994030743,0.126138428933168,0.0733351571279029,0,0,0; 0,0.883325439774419,0.990409187716733,0.986507389360106,0.932597577464162,0.862770187249281,0.78795778631478,0.71160521935802,0.634715049375236,0.557589028307448,0.480303860025845,0.402831986178052,0.325055283910925,0.246674322665779,0.179213612960761,0.125969845266954,0.073229628531759,0,0,0; 0,0.87634425452714,0.986721479133693,0.984673938283124,0.931817807255401,0.862453024403827,0.787830600742127,0.711552422235776,0.634687853570864,0.557564303876184,0.480267763212828,0.402772703353878,0.324960873411925,0.246534747334906,0.178982581342596,0.125805743517185,0.0731260583466956,0,0,0; 0,0.869387890846488,0.983020358118488,0.982810413451192,0.931011048434098,0.862118810116055,0.787694340132069,0.71149492712694,0.634657836509155,0.55753717814617,0.480228878527632,0.402709896615306,0.324862485678346,0.246392362529879,0.178759936306982,0.12564593869934,0.0730242439596822,0,0,0; 0,0.862457416363521,0.979307925189774,0.980918630199895,0.930177988703941,0.861767514301687,0.78754875264566,0.711432496386102,0.634624809105575,0.557507499649379,0.480187089722093,0.402643500760121,0.32476017079647,0.246247410506917,0.178544040845655,0.125490254988353,0.0729239823854598,0,0,0; 0,0.855553778050334,0.975586131500055,0.979000341645452,0.929319347708021,0.861399116396437,0.78739360633962,0.711364894768374,0.634588582185835,0.557475118815609,0.480142283808192,0.402573465019681,0.324654000032809,0.246100132873823,0.178333884141288,0.125338524119425,0.0728250969692489,0,0,0; 0,0.848677814203995,0.971856788831784,0.977057236677762,0.928435898613396,0.861013667367445,0.787228695800643,0.711291894756443,0.63454896249443,0.557439886887117,0.480094354055287,0.402499748055752,0.324544056759669,0.245950775914267,0.17812880610505,0.125190584302284,0.0727274105924517,0,0,0; 0,0.841830265165838,0.968121579041945,0.975090938771723,0.92752835142302,0.860611245652227,0.787053819619405,0.711213267836326,0.63450576070123,0.557401653286609,0.480043194789336,0.402422319416715,0.324430437484222,0.245799591413139,0.177928368020197,0.125046279481783,0.0726307766130009,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088793,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.835859119216188,0.964847838789301,0.973351642466695,0.926714648369224,0.860245081644458,0.786892405230891,0.71113964186757,0.634464848342723,0.557365600916172,0.479995678213735,0.402351470968477,0.324328031689745,0.245665917088794,0.1777564312474,0.124922806946873,0.0725469264088106,0,0,0; 0,0.833396121251639,0.963493121370465,0.972627677676098,0.926373014001342,0.860089884341122,0.786823352100775,0.711107848923609,0.634447053042193,0.557349962017858,0.479975266244731,0.402321330154802,0.324284900369443,0.24561031012644,0.177686244480532,0.124872497473321,0.0725124300344668,0,0,0; 0,0.829533495171463,0.96136358334366,0.97148477293246,0.925830248433972,0.859841581900917,0.78671210332768,0.711056268116403,0.63441802508111,0.557324502586181,0.479942277476931,0.402272973893627,0.324216212497987,0.245522590920192,0.177577007031725,0.124794310421273,0.0724584210703156,0,0,0; 0,0.825680599284937,0.959233475022394,0.970335721328897,0.925280402041653,0.859587912044984,0.78659749265465,0.711002676116321,0.63438767003499,0.557297940791266,0.479908160562888,0.402223406980668,0.324146441679317,0.245434496440556,0.17746903344394,0.124717167141361,0.0724046474912828,0,0,0; 0,0.821837518388821,0.957103032981049,0.969180778618825,0.924723620752042,0.859328909912929,0.786479498982615,0.710947037318945,0.634355951172161,0.557270251296179,0.479872900905592,0.402172631027046,0.324075612741403,0.24534606583457,0.177362292909911,0.124641042095906,0.0723510859490143,0,0,0; 0,0.818004330705165,0.954972483836636,0.96802019385054,0.924160050363477,0.859064613312269,0.786358103387598,0.710889317204124,0.634322837564604,0.557241409261941,0.479836486895746,0.402120648752042,0.324003750703768,0.245257344113305,0.177256751702834,0.124565910212098,0.0722977334941084,0,0,0; 0,0.81418110824298,0.952842044648086,0.966854209444505,0.92358983633655,0.858795062556964,0.786233289096071,0.710829482378376,0.634288297166635,0.557211392265104,0.479798901428019,0.402067463964509,0.323930882752053,0.245168365222819,0.177152397482051,0.124491746875737,0.0722445734118133,0,0,0; 0,0.810367917138235,0.950711923299414,0.965683061278996,0.923013123600663,0.858520300308598,0.786105041456386,0.710767504457381,0.634252298558915,0.557180173075516,0.479760134297343,0.402013081541549,0.323857035957204,0.243779894780478,0.177049200960421,0.124418527926088,0.0721916048696735,0,0,0; 0,0.806564817973536,0.948582318867273,0.964506978783021,0.922430056375016,0.858240371420649,0.7859733479066,0.710703345087501,0.634214810998502,0.557147730260231,0.47972017420394,0.401957507404627,0.323782238044224,0.243564789878501,0.176947141089039,0.12434622965164,0.0721388328094619,0,0,0; 0,0.802771866078753,0.946453421973402,0.963326185035466,0.921840778003487,0.857955322786263,0.785838197939023,0.710636977979207,0.634175804466697,0.557114041387387,0.479679010713368,0.401900748493326,0.323706517301845,0.243390194314075,0.176846198257656,0.124274828786581,0.0720862551344265,0,0,0; 0,0.798989111813781,0.944325415122519,0.962140896869567,0.921245430802825,0.857665203189854,0.785699583061785,0.710568374602556,0.634135249714572,0.55707908472126,0.479636634268259,0.401842816208576,0.323629906915719,0.243232771819221,0.176746354041539,0.124204302507844,0.0720338763244754,0,0,0; 0,0.795216600834561,0.942198473026153,0.960951324981843,0.920644155923584,0.857370063162827,0.785557505756432,0.710497507715921,0.634093118306052,0.557042839256024,0.479593036197695,0.401783712775924,0.323552427566455,0.243085333163037,0.176647590995727,0.124134632506661,0.0719817173094461,0,0,0; 0,0.793927401185897,0.941470565717219,0.960543114422748,0.920436965841455,0.857267874389018,0.785508062550057,0.710472720837538,0.634078326883172,0.557030130416126,0.479577827780801,0.40176321141696,0.323525707792881,0.243036510120171,0.176614023805337,0.124110970735689,0.0719639113522023,0,0,0; 0,0.791454373024445,0.940072762329984,0.959757673754806,0.920037093082887,0.857069954775676,0.78541194393178,0.710424351372319,0.634049382649263,0.55700528473987,0.479548208716048,0.401723451200374,0.323474111805202,0.242944591568337,0.176549892483138,0.124065788826673,0.0719297876886729,0,0,0; 0,0.772934703981458,0.931351667400718,0.955248934086827,0.917802957363743,0.855968286391134,0.784875789744776,0.710155423664483,0.6338914601141,0.556875384102582,0.47940382237649,0.401545121736249,0.323257998534031,0.242866833322611,0.176406734216854,0.123955595962808,0.0719282673633701,0,0,0; 0,0.75798825059844,0.924132136959559,0.9514460633311,0.915882649926533,0.855001881920903,0.784394789958842,0.709908492818896,0.633744052962584,0.556754664055225,0.479272133724458,0.401385273020284,0.323067008641039,0.242827302616631,0.176275124085488,0.123855134604215,0.071910825172834,0,0,0; 0,0.746057157760544,0.918229241333015,0.948282891964654,0.914259354415295,0.854171171925674,0.783973727247872,0.709688165846818,0.633610657111228,0.55664562565564,0.4791546794793,0.401244300553659,0.322900064375922,0.242873050827748,0.176153438725,0.123763935523875,0.0718843432052958,0,0,0; 0,0.735709284924394,0.913020378218957,0.945455311603029,0.912789610541689,0.853408748897978,0.783581456097789,0.709479701061921,0.633483004578804,0.556541461679254,0.479043707239492,0.401112471933926,0.322745247572823,0.243843956190004,0.176037276056556,0.123678118646555,0.0718543790315296,0,0,0; 0,0.726370371436702,0.908255364164748,0.942841184967072,0.911415844008322,0.852687680696012,0.783205638503997,0.709277257442717,0.633357828345428,0.556439486324782,0.478936145074749,0.400985930023061,0.322597828039156,0.24368833291694,0.175924895811853,0.123596086886019,0.0718228913048101,0,0,0; 0,0.717750141409215,0.903807070917672,0.940378627975616,0.910109270136148,0.851994612563642,0.782840158128271,0.709077999404669,0.633233552377821,0.556338399760977,0.478830488437527,0.40086276596244,0.322455450349142,0.243539142168687,0.175815428860528,0.123517015170539,0.0717907553090496,0,0,0; 0,0.709676576354609,0.899600435159419,0.938031186454381,0.908852794719182,0.851321676442358,0.782481507370217,0.70888028550078,0.633109269708203,0.556237452269191,0.478725868335101,0.400741883629777,0.3223167530725,0.243394833531283,0.175708366128201,0.123440403541268,0.0717584421656798,0,0,0; 0,0.702037507623482,0.89558631119589,0.93577505875976,0.907635589376258,0.850663937046905,0.782127452448156,0.708683092737633,0.632984418944632,0.556136181871627,0.478621750367188,0.4006225846234,0.32218086357912,0.243254425592334,0.175603381401632,0.123365920788138,0.0717262124995842,0,0,0; 0,0.694754156378301,0.89173019670954,0.933593551593514,0.906449842433507,0.850017845021284,0.781776415059738,0.708485719722041,0.632858616348624,0.556034260448992,0.478517751964806,0.400504382281187,0.322047172667617,0.243117223014864,0.17550024498881,0.12329332565958,0.0716942243504979,0,0,0; 0,0.687769119446235,0.88800684946643,0.931474482277898,0.90529002713563,0.849380894212577,0.781427333012184,0.708287668781751,0.63273159131479,0.555931474020845,0.478413612608601,0.400386939065288,0.321915253759316,0.2429827406155,0.175398792626878,0.123222440006667,0.0716625847739217,0,0,0; 0,0.681039841595119,0.884397687647234,0.929408853057554,0.904152069091891,0.84875134975169,0.781079424840919,0.708088602766806,0.632603163953232,0.55582766860607,0.478309151793284,0.40027001721984,0.321784801884383,0.242850618968168,0.175298902980072,0.123153128039044,0.0716313525676303,0,0,0; 0,0.674534017289753,0.880888227152671,0.927389951219753,0.903032965653045,0.84812783725146,0.780732123297084,0.707888277990854,0.632473206540759,0.555722736987844,0.478204238496115,0.400153441543233,0.321655589150221,0.242720583761889,0.175200482212985,0.123085281550003,0.0716005673712905,0,0,0; 0,0.668224594093662,0.87746691086967,0.925412037027992,0.901930140588496,0.847509254950079,0.780384965021515,0.707686487814925,0.632341609371399,0.555616591894499,0.478098762809231,0.400037070947558,0.32152743183645,0.242592424555488,0.175103453227255,0.123018809313272,0.0715702541208699,0,0,0; 0,0.66208935047733,0.874123898852574,0.923470467858775,0.900841521235914,0.846894706053252,0.780037562795852,0.707483089470955,0.632208300833864,0.555509164167929,0.477992648868256,0.399920788904744,0.321400182714814,0.24246595959918,0.175007752198759,0.12295363398772,0.0715404242371898,0,0,0; 0,0.656110825176323,0.87085112977252,0.921561385403122,0.899765393321819,0.846283454656682,0.779689655269297,0.707277955112005,0.63207321466304,0.555400403109474,0.477885829373047,0.399804518040919,0.321273726742222,0.242341047226813,0.174913326381766,0.122889690152155,0.071511091856579,0,0,0; 0,0.650273860942358,0.867642339128626,0.919681851436455,0.898700487478471,0.845674982748847,0.779341002082304,0.707070995983693,0.631936307727672,0.555290267621055,0.477778257315514,0.399688187909046,0.321147968692357,0.242217569158168,0.174820131378861,0.122826921585388,0.0714822557594638,0,0,0; 0,0.644566256047519,0.864491994169959,0.917829242625301,0.897645666761564,0.845068823353616,0.778991440109278,0.706862154184923,0.631797555030712,0.555178745335034,0.477669901431588,0.399571751202779,0.321022849494898,0.24209544279455,0.17472812347253,0.122765280135652,0.0714539146838277,0,0,0; 0,0.638977644138779,0.861395537185869,0.91600142379431,0.896600024901337,0.844464619170784,0.778640842996329,0.706651389244951,0.631656941545833,0.555065817805657,0.477560739663212,0.399455172034769,0.32089830983543,0.241974589091626,0.174637283322805,0.122704719864517,0.0714260649353222,0,0,0; 0,0.63349801929899,0.858348609454816,0.914196325395737,0.895562662155033,0.843862000120031,0.778289068921541,0.706438648027705,0.631514442953908,0.554951464717417,0.477450745246433,0.399338411833209,0.32077429474807,0.241854935083926,0.174547572875108,0.122645206366573,0.0713987012815963,0,0,0; 0,0.628118517151901,0.855346906775229,0.912411856101506,0.894532637014967,0.843260586284394,0.777935945795132,0.706223855961297,0.631370026474197,0.554835659660629,0.477339887300462,0.399221429873046,0.320650749198495,0.241736409679751,0.174458961670383,0.122586696626381,0.0713718172577528,0,0,0; 0,0.622832807930057,0.852388074686812,0.910647004016798,0.89350959003216,0.842660197004625,0.777581478769149,0.70600704121637,0.631223705345851,0.554718412012917,0.477228168253717,0.399104219230511,0.320527652895354,0.241618980209994,0.174371428262542,0.122529161263378,0.07134540504732,0,0,0; 0,0.617634540989543,0.849469136640049,0.908900349868816,0.892492911520296,0.842060682424356,0.777225581682527,0.705788176131967,0.631075469114435,0.554599718903163,0.477115580192414,0.398986763898427,0.320404977794579,0.241502594435857,0.174284949972928,0.122472569976946,0.0713194533692074,0,0,0; 0,0.612518050169534,0.846587577436089,0.907170718773573,0.891482113269312,0.841461828717717,0.776868198328151,0.705567248933183,0.630925332882413,0.554479579849647,0.477002118019357,0.398869051509253,0.320282700468562,0.241387218534267,0.174199505746959,0.12241689465393,0.071293959988854,0,0,0; 0,0.607477986895512,0.843741105173521,0.905457038896534,0.890476750139116,0.840863470449113,0.7765092784717,0.705344249894487,0.63077328957318,0.554357995297449,0.476887778045862,0.398751071837692,0.320160800487758,0.241272818135942,0.17411507569626,0.122362108860369,0.071268912730804,0,0,0; 0,0.60250983007271,0.840927495760947,0.903758257515012,0.889476374663939,0.840265433553284,0.776148763270103,0.70511916261751,0.630619335161045,0.554234962220187,0.476772554060177,0.39863281299613,0.320039256666843,0.241159359024055,0.174031640170386,0.122308186831758,0.0712443025556783,0,0,0; 0,0.597609177780025,0.838144764136019,0.902073420082361,0.888480633137108,0.839667591801162,0.775786618954687,0.704891984712438,0.630463474553145,0.554110484611243,0.476656446499836,0.398514270003927,0.319918055149919,0.241046812594405,0.17394918158143,0.12225510541557,0.0712201203132126,0,0,0; 0,0.592772505674027,0.835391626906764,0.900402004960553,0.887489195061341,0.839069857195033,0.775422831893618,0.704662725167806,0.630305719988296,0.553984572210367,0.476539461163178,0.398395443359823,0.319797187844743,0.240935163175065,0.173867683983521,0.122202843584714,0.0711963568521143,0,0,0; 0,0.587996598919627,0.832666508292491,0.898743258110109,0.886501919089494,0.838472118930558,0.77505739307404,0.704431395061055,0.630146084949775,0.553857235820712,0.476421605017753,0.398276334991318,0.319676648451926,0.240824389568979,0.173787132120003,0.122151381391936,0.0711730030858689,0,0,0; 0,0.583278126634095,0.829968015009904,0.897096535789292,0.885518490731917,0.837874364977908,0.774690267297575,0.704198001027899,0.629984579827373,0.553728483990344,0.476302883298395,0.398156945526571,0.319556429846862,0.240714468624997,0.173707510802449,0.122100699293264,0.0711500500131389,0,0,0; 0,0.578615848367874,0.827295448756006,0.895461574454355,0.884538863506244,0.837276593663386,0.774321551584635,0.703962578826991,0.629821243858019,0.553598347327372,0.476183320385296,0.398037293394705,0.319436541838522,0.240605398286454,0.173628808936397,0.122050782377181,0.0711274888517385,0,0,0; 0,0.574006472086183,0.824647296305537,0.893837720949302,0.883562763625536,0.836678703899479,0.773951195622619,0.703725154664895,0.629656081105656,0.553466829705008,0.476062911638957,0.397917376071945,0.319316974890003,0.240497162650868,0.173551011231221,0.122001611581848,0.0711053108677293,0,0,0; 0,0.569446885306077,0.822022425199632,0.892224199270145,0.882589888148756,0.836080573390885,0.773579156057302,0.703485701009319,0.629489088708669,0.553333922460175,0.475941666551313,0.397797187624607,0.31919771669449,0.240389738585739,0.173474101997557,0.121953167732793,0.0710835073977072,0,0,0; 0,0.564934900572218,0.819419810467285,0.89062081426501,0.881620050500546,0.835482179289356,0.773205448319084,0.70324424141394,0.629320288056164,0.553199657696255,0.475819592327367,0.397676736912647,0.319078768928799,0.240283111299219,0.173398068925807,0.121905435478787,0.0710620700323352,0,0,0; 0,0.560468994102372,0.816838531263094,0.8890270441886,0.880653214859151,0.834883479262414,0.772830074881037,0.703000790958965,0.629149694805708,0.553064040891546,0.475696698699951,0.397556029648376,0.318960130536808,0.24017726942256,0.173322899276583,0.121858399265052,0.0710409905043348,0,0,0; 0,0.55604736985558,0.814277820930035,0.887442619428084,0.879689238636213,0.834284477691669,0.772453065817059,0.702755381878799,0.628977336189856,0.552927093827321,0.47557300292255,0.397435078373155,0.318841806862045,0.240072215711595,0.173248581935332,0.12181204545863,0.0710202608018485,0,0,0; 0,0.551668348078261,0.811737324583012,0.885867191886311,0.878728038622806,0.833685135618609,0.772074446718736,0.702508043430989,0.628803237465626,0.552788836813157,0.475448520989731,0.397313894492443,0.3187238022821,0.239967933092444,0.17317510574072,0.121766360586582,0.0709998730952435,0,0,0; 0,0.547330522370743,0.809216003536459,0.884300586386406,0.877769485433911,0.833085500352618,0.77169422408257,0.702258792527299,0.628627415527078,0.552649283861302,0.475323263622426,0.397192484745397,0.318606117026708,0.239864417629555,0.173102458770816,0.121721330594883,0.0709798171243525,0,0,0; 0,0.543032776266982,0.806713574051244,0.88274233550085,0.876813414841945,0.832485505007723,0.771312381455859,0.702007647767034,0.628449888388108,0.552508449875516,0.47519724234312,0.39707085665087,0.318488752153171,0.239761659818804,0.173030629460835,0.121676941999064,0.070960090569049,0,0,0; 0,0.538771932023815,0.804228441662667,0.881192141661582,0.875859711339675,0.831885053793784,0.770928937681211,0.701754598663766,0.628270642532269,0.552366334815019,0.475070456306773,0.39694900693664,0.31837169913477,0.239659643900546,0.172959604273769,0.121633179491471,0.0709406832086778,0,0,0; 0,0.534547438179738,0.801760318223312,0.879649530331456,0.874908210750118,0.831284157232698,0.77054389432105,0.701499676110746,0.628089727809555,0.552222959933082,0.474942922490328,0.396826948117266,0.318254963796412,0.239558359568196,0.17288937304993,0.121590031412245,0.070921587910061,0,0,0; 0,0.530358076414508,0.799309017901089,0.878114401464043,0.873959000673828,0.830682846406585,0.770157293581213,0.701242918947503,0.62790716407806,0.552078350620144,0.474814661243193,0.396704695591816,0.318138554551289,0.23945780958188,0.172819926360578,0.12154748700053,0.0709027977857559,0,0,0; 0,0.526203331470166,0.796873990713883,0.876586729991407,0.873012094189149,0.830081088165502,0.769769161142438,0.700984355330163,0.627722975849886,0.551932526805019,0.474685688338583,0.396582260699455,0.318022476183299,0.23935798854557,0.172751254120312,0.121505534973031,0.0708843060593288,0,0,0; 0,0.522082172590753,0.794454889541952,0.875066299951713,0.872067194943216,0.829478991278519,0.769379533959688,0.700724020640902,0.627537192616856,0.551785512174029,0.474556022603551,0.396459657380184,0.317906735802828,0.239258891758898,0.172683346913322,0.121464164866116,0.0708661061871148,0,0,0; 0,0.51799410989299,0.792051528715798,0.873553066798824,0.871124456540833,0.828876563010759,0.768988467713881,0.700461943058934,0.627349852278606,0.551637336730222,0.474425687964047,0.396336903877893,0.317791344307937,0.239160522375987,0.172616196312095,0.121423367340129,0.0708481919071058,0,0,0; 0,0.513937979177086,0.789663196801576,0.872046663612542,0.870183870623769,0.828273742131424,0.76859597084573,0.700198179013906,0.627160971692739,0.55148801464837,0.474294695318414,0.396214007143416,0.317676302600134,0.239062869696597,0.172549791819745,0.121383131095173,0.0708305568810468,0,0,0; 0,0.509912198834591,0.787289485490596,0.870546944758542,0.869245213311551,0.827670559495903,0.768202019991046,0.699932704075272,0.626970553228301,0.551337549255436,0.474163046775078,0.396090966661723,0.317561605097099,0.238077219125682,0.17248412165975,0.121343443686948,0.070813194730538,0,0,0; 0,0.505915103693042,0.784929437818886,0.86905340035457,0.868308294947173,0.827066824197589,0.767806554342998,0.699665507035556,0.626778594307263,0.551185940225934,0.474030741604793,0.395967772680086,0.317447244364404,0.237936621576299,0.172419173805639,0.121304292566045,0.0707960991331462,0,0,0; 0,0.501946450828176,0.7825829799791,0.867566039202576,0.867373094805529,0.826462773152032,0.76740969207559,0.699396637594628,0.626585134282622,0.551033218716061,0.473897804671009,0.395844458123965,0.317333232138679,0.237811204294312,0.172354940616854,0.121265669680481,0.070779264459079,0,0,0; 0,0.498005827868943,0.780249949726746,0.866084817638648,0.866439768376237,0.825858211828858,0.767011448870186,0.699126137034142,0.626390206778401,0.55087941155699,0.473764257210571,0.395721031861341,0.317219577273859,0.237693257644394,0.172291413954338,0.121227566570303,0.0707626851735897,0,0,0; 0,0.494092380480795,0.777929956433704,0.86460955849555,0.865508191774973,0.825253277559026,0.766611839061872,0.698854025230315,0.626193830665002,0.55072453451972,0.473630111470418,0.39559750202897,0.317106281929583,0.237580203732996,0.172228584344966,0.121189973546091,0.0707463556893439,0,0,0; 0,0.490205519031062,0.775622742559566,0.863140159403983,0.864578346971479,0.824647896780916,0.766210893079897,0.698580332570346,0.625996032078632,0.550568608815797,0.473495384057506,0.395473880406965,0.316993351442377,0.237470726261288,0.172166443157756,0.121152881847476,0.0707302706639471,0,0,0; 0,0.486344599983314,0.773328020809983,0.861676499048405,0.863650203353706,0.824042184387136,0.765808609895907,0.698305085576291,0.625796834492218,0.550411653658531,0.473360089931135,0.395350177340265,0.316880789902224,0.237364089664716,0.172104981627644,0.121116282669163,0.0707144248578406,0,0,0; 0,0.482509316508446,0.771045674732764,0.860218553336755,0.862723786875776,0.823436140668479,0.765405096224334,0.698028325344899,0.625596271495726,0.550253695807858,0.47322425003762,0.395226408111942,0.316768605645904,0.237259825187936,0.17204419205985,0.121080168339706,0.0706988133259896,0,0,0; 0,0.478699173204715,0.768775489470952,0.858766239844447,0.861799087752,0.822829787532675,0.76500032627062,0.697750083115274,0.625394369871955,0.550094756918501,0.473087881167022,0.395102584451483,0.316656803920337,0.237157596807121,0.171984066216857,0.121044530728336,0.070683431161084,0,0,0; 0,0.474911856643557,0.766516313153952,0.857318930839769,0.860875769330807,0.82222294096889,0.764594234522602,0.697470301024498,0.625191094464913,0.5499348124713,0.472950963404605,0.394978687696736,0.316545363980027,0.237057213112648,0.17192459031174,0.121009356367202,0.0706682725780383,0,0,0; 0,0.471147023599842,0.764268003718992,0.855876581740709,0.859953840846692,0.821615632551482,0.764186908198656,0.697189013096727,0.624986473846284,0.549773885525561,0.472813514814134,0.394854730794741,0.316434292288145,0.236958484591385,0.171865756661132,0.120974637849179,0.0706533329019301,0,0,0; 0,0.467404675267701,0.762030595273464,0.854439249271635,0.859033371350439,0.821007878146733,0.763778270714552,0.696906269484881,0.624780547843632,0.549612007494406,0.472675559987412,0.394730731968534,0.316323599764676,0.236861258153885,0.171807558685519,0.120940368900049,0.0706386057707536,0,0,0; 0,0.463684436965232,0.759803927396231,0.853006876207703,0.858114361024804,0.820399804276285,0.763368449151389,0.696622076350365,0.624573343156588,0.549449199981284,0.472537115652561,0.394606702854983,0.316213291667298,0.236765433110701,0.171749988696636,0.120906542221837,0.070624090846869,0,0,0; 0,0.45998588682945,0.757587814053992,0.851579389285203,0.857196799545305,0.819791380752252,0.762957450770928,0.696336513408653,0.624364884220696,0.54928548288733,0.472398197142029,0.394482653885777,0.316103372216764,0.236670894173074,0.171693038910062,0.120873150481645,0.0706097816816796,0,0,0; 0,0.456308585444415,0.755382058854964,0.850156708065465,0.85628067137359,0.819182621827801,0.762545262188867,0.696049580103536,0.624155194173398,0.549120875133649,0.472258818974951,0.394358594779119,0.315993845024492,0.236577590318973,0.171636701538016,0.120840186400095,0.0705956740127905,0,0,0; 0,0.452652317882116,0.753186580130643,0.848738817949524,0.855365999734329,0.818573565850282,0.762131993558202,0.695761312987252,0.623944303428529,0.548955401026,0.472118999848353,0.394234538599043,0.315884716518991,0.236485431808296,0.171580969533056,0.120807643464792,0.0705817638218796,0,0,0; 0,0.449016812955978,0.751001266208063,0.847325685962402,0.854452796108195,0.817964243365035,0.761717649318889,0.695471745096606,0.623732239953284,0.548789083025106,0.471978756943339,0.394110497100325,0.315775992000805,0.236394387448307,0.171525835727039,0.120775515094418,0.0705680471627258,0,0,0; 0,0.445401886227017,0.748826049335287,0.845917303924782,0.853541086248643,0.817354693627716,0.761302270460328,0.695180913224762,0.623519034344781,0.548621945513775,0.471838108878335,0.393986483130003,0.31566767766988,0.23630438380052,0.171471293270487,0.120743795059346,0.0705545202500473,0,0,0; 0,0.441805988043306,0.746660154059598,0.844513248772816,0.852630644457923,0.81674479523887,0.760885792030863,0.694888782524046,0.623304667041222,0.548453975701906,0.47169704528501,0.393862486139032,0.315559760126068,0.23621542236434,0.171417325145097,0.12071247322944,0.0705411784527709,0,0,0; 0,0.43822837076752,0.744503217828313,0.843113337134122,0.851721388317728,0.816134517026997,0.760468207819334,0.694595357510242,0.623089145934635,0.548285181182825,0.471555571786206,0.393738508585812,0.31545223697596,0.236127456501947,0.171363935059987,0.120681541949932,0.0705280177239904,0,0,0; 0,0.434668741784139,0.7423551125235,0.841717521787319,0.850813316872443,0.815523879237029,0.760049545219542,0.694300665316885,0.622872494724848,0.548115581249417,0.471413703097852,0.393614560233769,0.315345111959023,0.236040451936986,0.171311109895437,0.120650994998608,0.0705150344095915,0,0,0; 0,0.431127003119551,0.740215810178352,0.840325813485322,0.849906463713094,0.81491292388075,0.759629845884693,0.694004742720527,0.622654743866802,0.547945200163438,0.471271457731113,0.393490653824072,0.315238391283983,0.23595436492356,0.171258843302041,0.120620826810992,0.0705022250877859,0,0,0; 0,0.427602916032749,0.738085209203214,0.838938179195919,0.849000835379561,0.814301675392765,0.759209139753305,0.693707591205966,0.622435918235048,0.547774058028961,0.47112885091313,0.393366799402819,0.315132078897106,0.235869191492472,0.171207128557807,0.120591031500851,0.070489586326792,0,0,0; 0,0.424096508409122,0.735963345786476,0.837554666147951,0.84809648666253,0.813690188878599,0.758787476998889,0.69340931169485,0.622216052344322,0.547602182037153,0.47098590327825,0.393243011255278,0.31502618224786,0.235784891631944,0.171155959810875,0.120561604040257,0.0704771149862964,0,0,0; 0,0.420607555269289,0.73385012433311,0.836175243670131,0.84719342459107,0.813078488579479,0.758364887256814,0.693109901718051,0.621995170900705,0.5474295920997,0.470842629774937,0.393119299069558,0.314920704952547,0.235701443099429,0.171105330495681,0.120532538752785,0.0704648078247614,0,0,0; 0,0.417135793345048,0.731745428671547,0.834799868342967,0.846291647889453,0.812466593077008,0.757941353845528,0.692809387162862,0.621773275079644,0.547256306685668,0.470699044198231,0.392995671575143,0.314815649834158,0.235618814101394,0.171055233989179,0.120503829938129,0.070452661649666,0,0,0; 0,0.413680999721867,0.729649162936083,0.833428508044609,0.845391161621183,0.811854524707946,0.757516987295457,0.692507795464792,0.621550432091513,0.547082345025849,0.470555160888004,0.39287213789263,0.314711020041492,0.235537010652521,0.171005663850409,0.120475472097501,0.0704406733763795,0,0,0; 0,0.410242941522519,0.727561225450127,0.832061126623407,0.844491967877001,0.811242303584772,0.757091774043338,0.692205128226378,0.621326643199288,0.546907725706707,0.470410993649023,0.392748706680103,0.314606818344956,0.23545600256849,0.170956613667591,0.120447459787208,0.0704288399865328,0,0,0; 0,0.406821085897787,0.725481357652227,0.830697594817907,0.843594011303369,0.810629912371326,0.756665715344611,0.691901453038552,0.621101919204746,0.546732458305588,0.470266549375127,0.392625381140213,0.314503043045403,0.235375776297995,0.170908076181199,0.12041978679212,0.0704171582777547,0,0,0; 0,0.403414326303291,0.723409001008984,0.82933760551458,0.842697126951258,0.810017262298589,0.756238764330734,0.691596695382035,0.620876247526337,0.546556535209098,0.4701218218816,0.392502154260562,0.314399684118042,0.235296323315911,0.170860042463543,0.120392445358714,0.0704056246014582,0,0,0; 0,0.400022605582808,0.721344142685865,0.827981172526897,0.841801345365764,0.809404390486166,0.75581095804112,0.691290966465462,0.620649655893121,0.546379978453977,0.469976827620662,0.392379036799576,0.314296746156356,0.235217627433389,0.17081250682807,0.120365430812069,0.0703942362485826,0,0,0; 0,0.396645562296583,0.719286610735646,0.826628215263051,0.840906638860046,0.808791296083214,0.755382307949169,0.690984177863663,0.620422159623962,0.546202800928911,0.46983157604192,0.392256034003673,0.314194229247229,0.23513966373197,0.170765462729635,0.120338737691363,0.0703829903127652,0,0,0; 0,0.393283162348031,0.717236403437978,0.825278753156192,0.840013040606614,0.808178017418318,0.754952851673555,0.69067637018598,0.620193786621285,0.54602502473869,0.469686083562296,0.39213315652144,0.314092137899196,0.235062442609334,0.170718904670932,0.120312361539377,0.0703718842410292,0,0,0; 0,0.389935202956143,0.715193430669337,0.823932752987013,0.839120551122357,0.80756457141218,0.754522612357665,0.690367634138042,0.619964557726912,0.545846666772231,0.469540362593394,0.392010411838626,0.313990474041273,0.234985938793991,0.170672826705424,0.120286297495501,0.0703609153965755,0,0,0; 0,0.386601638955116,0.713157684209882,0.822590229554551,0.838229200043835,0.806950993683661,0.754091625612522,0.690057930603531,0.619734499777067,0.545667748283498,0.469394428807626,0.391887809932701,0.313889241635095,0.23491013961013,0.170627223419336,0.120260541215151,0.0703500813511169,0,0,0; 0,0.383282379437494,0.711129131634379,0.82125118297941,0.837339007672968,0.806337313592434,0.753659922751417,0.68974735785174,0.619503637474827,0.545488288926072,0.469248296615288,0.391765359755696,0.313788443808482,0.234835033398036,0.170582089319005,0.120235088294505,0.0703393797000774,0,0,0; 0,0.379977464176966,0.709107808551265,0.819915653346914,0.836450018613654,0.805723576157754,0.753227545571769,0.689435921976093,0.619272000582522,0.545308312020557,0.469101983138125,0.391643072305516,0.313688085347943,0.234760608365422,0.170537419358785,0.120209934762769,0.0703288082281879,0,0,0; 0,0.376686560282921,0.707093555331675,0.818583564671395,0.835562205647894,0.805109779349599,0.752794504002533,0.689123637164221,0.619039603270596,0.545127829441048,0.46895549683509,0.391520951864713,0.313588158848592,0.234686855460952,0.170493207436333,0.120185075677272,0.0703183630447279,0,0,0; 0,0.373409455680244,0.705086275048029,0.817254877646402,0.83467556371991,0.804495935304594,0.752360817373808,0.6888105240105,0.618806464196361,0.544946856324224,0.468808848602912,0.39139900458301,0.313488678731819,0.234613765290948,0.170449447871164,0.120160506504085,0.0703080446075257,0,0,0; 0,0.370146174389065,0.70308599403469,0.815929625738358,0.833790132347226,0.80388208507951,0.751926524472953,0.688496616507261,0.618572611453605,0.544765414673468,0.468662054454538,0.391277240507322,0.313389642272802,0.234541327602887,0.170406135743793,0.120136223431157,0.0702978494259751,0,0,0; 0,0.366896315499231,0.701092515720813,0.81460770970189,0.832905868752295,0.803268215667426,0.751491627344234,0.688181923165275,0.618338055089169,0.544583513276787,0.468515120465478,0.391155662045298,0.31329104737502,0.2344695347825,0.170363264928656,0.120112221535912,0.0702877750665383,0,0,0; 0,0.36365869298224,0.699105231244361,0.813288784589277,0.832022577592275,0.802654213638092,0.751056059609232,0.687866367264355,0.618102771463915,0.544401136339125,0.468368034364768,0.391034257631635,0.313192880758464,0.234398371713709,0.17032082703974,0.120088493809137,0.0702778183163223,0,0,0; 0,0.360433174260844,0.69712408307818,0.811972832365302,0.831140265030473,0.802040097136989,0.750619843864999,0.687550043388329,0.617866780363849,0.544218299771494,0.468220807626323,0.390913033884341,0.313095143823634,0.23432785299563,0.170278816884487,0.120065036225199,0.0702679770635152,0,0,0; 0,0.357219823994547,0.69514911692506,0.810659896121321,0.830258974824116,0.801425908817756,0.750183019278298,0.687232950973252,0.617630109646693,0.544035025335822,0.468073456045505,0.390792000677858,0.31299784059295,0.234257957103483,0.170237229909166,0.120041845360412,0.0702582494552431,0,0,0; 0,0.354018606896998,0.693180325907481,0.80934998745142,0.829378731016793,0.800811678262873,0.749745616066844,0.686915117672581,0.617392782726051,0.54385133151368,0.467925992921385,0.390671165945429,0.312900973536891,0.234188675444608,0.170196061318229,0.120018917574091,0.0702486335884623,0,0,0; 0,0.35082945446966,0.691217685509674,0.808043107192009,0.828499550740024,0.800197430351914,0.749307661160836,0.686596568811181,0.617154821335272,0.543667235527091,0.467778430574921,0.390550536846482,0.312804544517681,0.234119999902905,0.170155306272731,0.119996249192781,0.0702391275745317,0,0,0; 0,0.347652361426222,0.689261204218534,0.806739275593134,0.827621462938393,0.799583197582208,0.748869186596489,0.68627733321936,0.616916249655388,0.543482756343955,0.46763078258302,0.39043012146106,0.312708556145152,0.234051922387496,0.170114960173348,0.119973836772194,0.0702297296420682,0,0,0; 0,0.344487227963796,0.687310840670346,0.805438482947739,0.82674447771881,0.798968999888031,0.748430215753521,0.685957433656599,0.61667708753539,0.543297909744876,0.467483060119413,0.390309926023872,0.312613009569539,0.233984435484419,0.170075018196888,0.119951676667021,0.0702204379631368,0,0,0; 0,0.341333890947723,0.685366519951873,0.804140699247235,0.825868592292473,0.79835484851003,0.747990765961836,0.685636888606913,0.616437351759053,0.543112709252509,0.467335272658351,0.39018995547069,0.31251790492616,0.233917532254379,0.170035475389789,0.119929765117547,0.0702112506809549,0,0,0; 0,0.338192405549312,0.683428281734745,0.802845962601105,0.824993845996967,0.797740782315924,0.747550873331806,0.68531572958653,0.616197068302396,0.542927175036161,0.467187434556548,0.39007021839323,0.312423245277969,0.23385120510784,0.169996327489326,0.119908099009379,0.0702021662266637,0,0,0; 0,0.33506266480441,0.681496080245823,0.801554259899924,0.824120246083975,0.797126818845614,0.74711055930658,0.684993977838178,0.615956255828846,0.542741321917173,0.467039556181116,0.389950720355579,0.312329031295067,0.233785447317512,0.169957569811459,0.119886674843004,0.0701931828918297,0,0,0; 0,0.331944628253012,0.679569904503826,0.800265598566873,0.823247703165676,0.796512983764272,0.746669850789332,0.684671658356108,0.615714935620945,0.542555166585818,0.466891649247466,0.389831467915962,0.312235264456785,0.233720252091613,0.169919197917996,0.119865489351095,0.0701842990841226,0,0,0; 0,0.328837954269828,0.677649584693126,0.798979890807504,0.822376394648203,0.795899263085241,0.746228747389966,0.684348777005642,0.615473115366684,0.54236871584583,0.466743718171206,0.389712462156501,0.312141941926616,0.233655613880794,0.169881206551395,0.119844538512874,0.0701755128960453,0,0,0; 0,0.325742501490844,0.67573505612878,0.797697111335924,0.821506211307427,0.795285668175912,0.745787265949016,0.684025351603379,0.615230811179473,0.542181982590882,0.466595771841531,0.389593707511478,0.312049063556497,0.233591526515744,0.169843591090217,0.119823818900019,0.0701668226836114,0,0,0; 0,0.322657269011163,0.673825800700788,0.796416963143678,0.820636981904103,0.794672097398742,0.745345345540826,0.683701345480594,0.614988000509269,0.541994951701657,0.466447798594978,0.389475193100712,0.31195661713337,0.233527986807833,0.169806344493779,0.119803324851616,0.0701582258009631,0,0,0; 0,0.319582239342906,0.671921818069917,0.795139458568104,0.819768727938832,0.794058576546588,0.744903012513137,0.683376782881881,0.614744703932558,0.541807639294802,0.466299809718436,0.389356925199665,0.311864604054476,0.233464988224173,0.169769462619533,0.119783053389157,0.0701497207903348,0,0,0; 0,0.316517281135889,0.670023047699631,0.793864573698949,0.818901448052768,0.793445116097856,0.744460282596906,0.683051680566609,0.614500936681783,0.541620057587938,0.466151813613519,0.389238907920395,0.31177302403055,0.233402513117117,0.169732941048017,0.119763001280049,0.0701413060919695,0,0,0; 0,0.313462477042476,0.668129541804282,0.792592351982397,0.818035182827685,0.792831754245057,0.74401719049963,0.682726068530501,0.614256723335642,0.541432225525758,0.466003823573615,0.389121148993285,0.311681879644671,0.233340578592203,0.169696776022406,0.119743165905493,0.0701329804427299,0,0,0; 0,0.31041776187346,0.666241274497146,0.791322789909621,0.817169943303347,0.792218509437343,0.743573757269588,0.68239996715428,0.614012081618205,0.54124415706052,0.46585584920659,0.389003653391275,0.311591171325618,0.233279166765356,0.169660963409902,0.119723544300409,0.0701247424347639,0,0,0; 0,0.307383232765343,0.664358305483721,0.790055935136714,0.816305772399916,0.79160542120606,0.743130018401452,0.682073406897594,0.613767036362309,0.541055871244591,0.46570790380888,0.388886428800521,0.311500901654924,0.233218271405084,0.169625499587501,0.119704133971596,0.0701165908973145,0,0,0; 0,0.304358788563554,0.662480589666358,0.78879177230454,0.815442673393324,0.790992502585249,0.742685991051847,0.681746405310326,0.613521603207297,0.540867380455725,0.465559995777022,0.388769479263358,0.311411070370268,0.233157887013006,0.169590380413907,0.119684931947605,0.070108524445761,0,0,0; 0,0.301344245035056,0.660608037859394,0.787530259366594,0.814580632599016,0.790379755144981,0.742241684358243,0.68141897424747,0.613275793712915,0.540678694102585,0.465412131329844,0.388652807211495,0.311321675973834,0.233098008425973,0.169555601561844,0.119665935085448,0.0701005416175413,0,0,0; 0,0.298339626210064,0.658740670768963,0.786271420051689,0.813719677397098,0.789767207668182,0.741797126140534,0.681091138617739,0.61302962865697,0.540489828214834,0.465264321481287,0.388536418607388,0.311232719762226,0.233038629993418,0.169521159341695,0.119647140831256,0.0700926412438043,0,0,0; 0,0.295344932954879,0.656878496772945,0.785015270544329,0.812859830282359,0.789154885567631,0.741352341816594,0.680762921593106,0.612783127546086,0.540300797870366,0.465116576522281,0.388420318864941,0.311144202622999,0.23297974625267,0.169487050042803,0.119628546611469,0.0700848221577451,0,0,0; 0,0.292360179694861,0.655021531331766,0.783761831143071,0.812001116182382,0.788542815764526,0.740907357770058,0.68043434697294,0.612536310292158,0.540111618404504,0.464968906900634,0.388304513499236,0.311056125544441,0.232921351819317,0.169453270036747,0.119610149928028,0.0700770832406624,0,0,0; 0,0.289385194406462,0.653169691136873,0.78251106259381,0.811143522412607,0.787930999926745,0.740462182826055,0.680105426152313,0.612289187967484,0.539922298758374,0.464821318409348,0.388189004601459,0.310968486865163,0.232863441892276,0.169419815217247,0.119591947840407,0.0700694231567289,0,0,0; 0,0.286419998604042,0.651322995142864,0.781262986955852,0.810287074655449,0.787319465210705,0.74001684334899,0.679776182799464,0.61204178031001,0.539732854082661,0.46467382131847,0.388073797542944,0.310881287512499,0.232806011253355,0.169386682066026,0.119573937950438,0.070061840849907,0,0,0; 0,0.283464358554254,0.649481327041031,0.780017544725608,0.809431747085379,0.786708117796154,0.739571341661251,0.679446623603157,0.611794094971757,0.539543290807957,0.46452641957589,0.387958893063579,0.310794524829529,0.232749055407191,0.169353866397384,0.119556117241504,0.0700543349494242,0,0,0; 0,0.280518144275951,0.647644625247286,0.778774709106283,0.808577534239324,0.786097135490342,0.73912568928218,0.679116761652931,0.611546144104698,0.539353618580742,0.464379119446254,0.387844293605641,0.310708197519487,0.232692569657001,0.169321364362741,0.119538483006788,0.070046904242691,0,0,0; 0,0.277580536120396,0.645812462500136,0.777534232778154,0.807724291423136,0.785486345488904,0.73867983278495,0.678786517279543,0.611297907305426,0.539163823653921,0.464231910337237,0.387729989332644,0.310622294773522,0.232636550980363,0.169289170253075,0.11952103081592,0.070039546597844,0,0,0; 0,0.274651519746259,0.643984837846333,0.776296124850308,0.806872035215108,0.7848757681299,0.738233793312727,0.678456002913228,0.611049401329208,0.538973918967139,0.46408480091213,0.38761598448566,0.310536816778862,0.23258099445016,0.169257280646144,0.119503756255187,0.0700322601435057,0,0,0; 0,0.271730981870438,0.642161697784373,0.775060362619699,0.806020761978144,0.784265410082352,0.737787582437448,0.678125185633182,0.610800638067267,0.538783913941068,0.463937797281793,0.387502281443022,0.310451764419951,0.232525895451629,0.1692256918893,0.119486661000946,0.0700250454440288,0,0,0; 0,0.26881863423124,0.640342895851405,0.773826867137794,0.80517043238363,0.783655253923085,0.737341194890957,0.677794066387711,0.610551620900953,0.538593811873476,0.463790901149072,0.387388879385691,0.310367129539329,0.232471249824763,0.16919439989458,0.119469739997527,0.0700179002643814,0,0,0; 0,0.265914728135294,0.638528571641544,0.772595731815338,0.804321115744973,0.783045354997525,0.736894675878677,0.677462681668991,0.610302378386816,0.538403634085467,0.463644127144934,0.387275786883271,0.310282918134839,0.232417052282596,0.169163402097557,0.119452991712256,0.0700108240074426,0,0,0; 0,0.263019498509986,0.636718856149148,0.771367044874753,0.803472878068755,0.782435766400976,0.736448069016622,0.677131066818877,0.61005293822579,0.538213401236832,0.463497489377782,0.387163012097709,0.310199133526768,0.232363297695514,0.169132695920641,0.119436414598222,0.0700038160852746,0,0,0; 0,0.260133039062012,0.63491380546937,0.770140849304144,0.802625756721756,0.781826521940874,0.736001404465734,0.676799247646128,0.609803321316551,0.538023129072435,0.463350998393093,0.387050560588333,0.310115777037424,0.232309981340685,0.169102278434079,0.119420006779834,0.0699968757403748,0,0,0; 0,0.257255031375522,0.633113256814574,0.768917055803509,0.801779705289228,0.781217598999534,0.735554673035356,0.676467222117147,0.609553528769346,0.537832819146682,0.463204654561427,0.386938430553299,0.310032844325676,0.232257099426473,0.169072145627641,0.119403765376324,0.0699900016524474,0,0,0; 0,0.254385429486579,0.631317191873097,0.767695662119381,0.800934732204624,0.780609011677028,0.735107890985846,0.676135006103999,0.609303574357121,0.537642482058455,0.463058464722064,0.38682662487935,0.309950334707884,0.232204647636873,0.169042294275028,0.119387688229727,0.0699831929022207,0,0,0; 0,0.251524343015584,0.629525674916612,0.766476715786755,0.800090877287651,0.78000079509085,0.734661089146572,0.675802625720839,0.609053479078259,0.537452133542853,0.462912439362241,0.386715149081355,0.309868249553759,0.232152621409008,0.169012721607738,0.119371773603434,0.0699764488137812,0,0,0; 0,0.248671791292243,0.627738722225468,0.765260235260916,0.799248161854202,0.779392971824609,0.734214289552255,0.67547010082039,0.608803259450594,0.537261786098256,0.462766586631673,0.386604006979739,0.309786588948405,0.23210101643593,0.168983424648495,0.119356019563738,0.069969768603667,0,0,0; 0,0.24582768290137,0.625956291146727,0.764046203251228,0.798406584451235,0.778785549024209,0.73376750339742,0.675137443538401,0.608552926480131,0.537071448258403,0.462620911835767,0.386493200346342,0.309705351425194,0.232049828688934,0.168954400159797,0.119340423931343,0.0699631513467499,0,0,0; 0,0.242991873596062,0.624178310814475,0.762834585251997,0.797566132558526,0.778178526252208,0.733320736495689,0.674804662145463,0.608302488394024,0.536881126552119,0.462475418843327,0.386382729926934,0.309624534758359,0.23199905428952,0.16892564480248,0.119324984427991,0.0699565960562515,0,0,0; 0,0.240164395351614,0.622404803961773,0.761625403243656,0.796726829316665,0.77757192698966,0.73287401126591,0.674471776599373,0.608051961669615,0.536690833372903,0.46233011568616,0.386272599462972,0.309544139056066,0.231948689072037,0.16889715574629,0.119309699244181,0.0699501020186656,0,0,0; 0,0.237345034296172,0.620635662464451,0.760418599891912,0.795888647430958,0.77696574059682,0.732427326225994,0.674138789892967,0.607801350716594,0.536500572483048,0.462185004246596,0.386162808286848,0.30946416106595,0.231898729386068,0.1688689295438,0.11929456599171,0.0699436681751759,0,0,0; 0,0.234533709075968,0.618870848551124,0.759214160282723,0.795051586349231,0.776359974339692,0.731980692301999,0.673805713737323,0.607550666090317,0.536310352009801,0.462040089505355,0.386053357964221,0.309384599283945,0.231849171373933,0.168840963139592,0.119279582642063,0.0699372936749646,0,0,0; 0,0.231730415510549,0.617110365433207,0.75801209419873,0.79421566106401,0.775754645869179,0.731534127597048,0.673472564869217,0.607299921872278,0.536120182569349,0.461895378197417,0.385944251320846,0.309305453201247,0.231800011086177,0.168813253718564,0.119264747385847,0.0699309777969349,0,0,0; 0,0.228935091614437,0.615354185481912,0.756812392635187,0.793380874519451,0.775149764602057,0.731087644385298,0.673139355846271,0.607049129143816,0.535930072615995,0.461750875510659,0.385835490078272,0.309226721489373,0.231751244729373,0.168785798348035,0.119250058299402,0.069924719749357,0,0,0; 0,0.226147426164794,0.613602148227237,0.755614965944755,0.79254717827701,0.774545305119223,0.730641230491558,0.672806081852778,0.606798286634993,0.535740021795414,0.461606580390162,0.385727071509857,0.309148399443692,0.231702868995422,0.168758593479027,0.119235512878713,0.0699185183788575,0,0,0; 0,0.223367154876812,0.611854117988855,0.754419739299885,0.79171453311546,0.773941248073893,0.730194877877708,0.672472740936296,0.606547395073064,0.535550031167684,0.461462492791956,0.385618993633025,0.309070482967089,0.231654880520813,0.168731635728637,0.119221108768132,0.069912372610331,0,0,0; 0,0.220594292323854,0.610110107500213,0.753226727698494,0.790882956759849,0.773337612493431,0.729748605267235,0.672139350045243,0.606296468548242,0.535360111281068,0.461318619380289,0.385511259261054,0.308992971663985,0.231607263991192,0.168704922480357,0.119206844321773,0.0699062818010258,0,0,0; 0,0.220212639145046,0.609870014924609,0.753062448183922,0.790768410719957,0.77325443693619,0.729687095050784,0.672093390019546,0.606261877057422,0.535333937497216,0.46129880401913,0.385496435494931,0.308982318709688,0.231600731733253,0.168701259182952,0.119204888872025,0.0699054464720341,0,0,0;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        WindTurbine_data.RCp_Dr = s.RCp_Dr; WindTurbine_data.RCp_Dr = s.RCp_Dr;
        % NOTE: For cases where there is no energy production (CP == 0) use "s.Vws == 0 or 100" to set "s.RCp_Dr = 0" & "s.Rrd_local == 126" to set "s.RCp_Dr = 0"
        %
    elseif s.Option01f5 == 2
        % Use Aerodynamic Coefficients saved ROSCO-v.2.9.1.  
        System_LoadsAerodynamics('logical_instance_02');  
        %        
    elseif s.Option01f5 == 3 
        % Run Code of the Classical Blade Element Momentum Method   
        System_LoadsAerodynamics('logical_instance_03');
        %
    end % if s.Option01f5 == 1

    

       %### PARTIAL DERIVATIVES OF THE POWER COEFFICIENT (Grad_CP) ###

  % NOTE: For the first data (from the initial edge), the Forward Finite
  % Difference method was used. For the final or last data (final edge), 
  % the Backward Finite Difference method was used. And for the internal
  % data (which has the previous and the next element), the Centered Finite
  % Difference method was used.

    % ---------- Derivative of CP with respect to Lambda_Tab ----------
    [s.index_Lambda, s.index_Beta] = size(s.CP_Tab);       
    for i = 1:s.index_Beta 
        for j = 1:s.index_Lambda
            
            % Forward Finite Difference (for First data)
            if j == 1 
                s.Grad_CpLambda(j,i) = ( s.CP_Tab((j+1),i) - s.CP_Tab((j),i) )/( s.Lambda_Tab(1,(j+1)) - s.Lambda_Tab(1,(j)) ) ;
               % Backward Finite Difference (for last data)
            elseif j == s.index_Lambda  
                s.Grad_CpLambda(j,i) = ( s.CP_Tab((j-1),i) - s.CP_Tab((j),i) )/( s.Lambda_Tab(1,(j-1)) - s.Lambda_Tab(1,(j)) ) ;
            else
                % Centered Finite Difference (for Internal _data)
            s.Grad_CpLambda(j,i) = ( s.CP_Tab((j+1),i) - s.CP_Tab((j-1),i) )/(2*( s.Lambda_Tab(1,j) - s.Lambda_Tab(1,(j-1)) ) );
            end                                                                   
        end        
    end  

    % ---------- Derivative of CP with respect to Beta_Tab ----------
    [s.index_Lambda, s.index_Beta] = size(s.CP_Tab);
    for i = 1:s.index_Lambda
        for j = 1:s.index_Beta
            
            % Forward Finite Difference (for First data)
            if j == 1 
                s.Grad_CpBeta(i,j) = ( s.CP_Tab(i,(j+1)) - s.CP_Tab(i,j) )/( s.Beta_Tab(1,(j+1)) - s.Beta_Tab(1,(j)) ) ;
                % Backward Finite Difference (for last data)
            elseif j == s.index_Beta % Forward Finite Difference (for First Step)
                s.Grad_CpBeta(i,j) = ( s.CP_Tab(i,(j-1)) - s.CP_Tab(i,j) )/( s.Beta_Tab(1,(j-1)) - s.Beta_Tab(1,(j)) ) ;
            else
                % Centered Finite Difference (for Internal data)
                s.Grad_CpBeta(i,j) = ( s.CP_Tab(i,(j+1)) - s.CP_Tab(i,(j-1)) )/(2*( s.Beta_Tab(1,j) - s.Beta_Tab(1,(j-1)) ) );
            end 
            
        end        
    end
    s.graddP = zeros(size(s.CP_Tab)); % Will be used to plot results



 %###### PARTIAL DERIVATIVES OF THE THRUST COEFFICIENT (Grad_CT) ######%

  % NOTE: For the first data (from the initial edge), the Forward Finite
  % Difference method was used. For the final or last data (final edge), 
  % the Backward Finite Difference method was used. And for the internal
  % data (which has the previous and the next element), the Centered Finite
  % Difference method was used.

    % ---------- Derivative of CT with respect to Lambda_Tab ----------
    [s.index_Lambda, s.index_Beta] = size(s.CT_Tab);       
    for i = 1:s.index_Beta 
        for j = 1:s.index_Lambda
            
            % Forward Finite Difference (for First data)
            if j == 1 
                s.Grad_CtLambda(j,i) = ( s.CT_Tab((j+1),i) - s.CT_Tab((j),i) )/( s.Lambda_Tab(1,(j+1)) - s.Lambda_Tab(1,(j)) ) ;
               % Backward Finite Difference (for last data)
            elseif j == s.index_Lambda  
                s.Grad_CtLambda(j,i) = ( s.CT_Tab((j-1),i) - s.CT_Tab((j),i) )/( s.Lambda_Tab(1,(j-1)) - s.Lambda_Tab(1,(j)) ) ;
            else
                % Centered Finite Difference (for Internal _data)
            s.Grad_CtLambda(j,i) = ( s.CT_Tab((j+1),i) - s.CT_Tab((j-1),i) )/(2*( s.Lambda_Tab(1,j) - s.Lambda_Tab(1,(j-1)) ) );
            end                                                                   
        end        
    end  

    % ---------- Derivative of CT with respect to Beta_Tab ----------
    [s.index_Lambda, s.index_Beta] = size(s.CT_Tab);
    for i = 1:s.index_Lambda
        for j = 1:s.index_Beta
            
            % Forward Finite Difference (for First data)
            if j == 1 
                s.Grad_CtBeta(i,j) = ( s.CT_Tab(i,(j+1)) - s.CT_Tab(i,j) )/( s.Beta_Tab(1,(j+1)) - s.Beta_Tab(1,(j)) ) ;
                % Backward Finite Difference (for last data)
            elseif j == s.index_Beta % Forward Finite Difference (for First Step)
                s.Grad_CtBeta(i,j) = ( s.CT_Tab(i,(j-1)) - s.CT_Tab(i,j) )/( s.Beta_Tab(1,(j-1)) - s.Beta_Tab(1,(j)) ) ;
            else
                % Centered Finite Difference (for Internal data)
                s.Grad_CtBeta(i,j) = ( s.CT_Tab(i,(j+1)) - s.CT_Tab(i,(j-1)) )/(2*( s.Beta_Tab(1,j) - s.Beta_Tab(1,(j-1)) ) );
            end 
            
        end        
    end
    s.graddT = zeros(size(s.CT_Tab)); % Will be used to plot results


    % ---------- Identifying the Limits of Aerodynamic Data ----------
    who.Beta_min = 'Minimum Blade Pitch, in [deg]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.Beta_min = min(s.Beta_Tab); 
    who.Beta_max = 'Maximum Blade Pitch, in [deg]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.Beta_max = max(s.Beta_Tab); 
    who.Lambda_min = 'Minimum Tip-Speed-Ratio, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.Lambda_min = min(s.Lambda_Tab);
    who.Lambda_max = 'Maximum Tip-Speed-Ratio, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.Lambda_max = max(s.Lambda_Tab); 
    who.CP_min = 'Minimum Power coefficient, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CP_min = min(min(s.CP_Tab)); 
    who.CP_max = 'Maximum Power coefficient, in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CP_max = max(max(s.CP_Tab)); 
    who.CQ_min = 'Minimum Torque coefficient (CQ), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CQ_min = min(min(s.CQ_Tab)); 
    who.CQ_max = 'Maximum Torque coefficient (CQ), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CQ_max = max(max(s.CQ_Tab)); 
    who.CT_max = 'Minimum Thrust coefficient (CT), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CT_max = max(max(s.CT_Tab)); 
    who.CT_min = 'Maximum Thrust coefficient (CT), in [dimensionless]. Values ​​obtained by the Classical Blade Element Moment Method.';
    s.CT_min = min(min(s.CT_Tab)); 
    [s.IndexLambdaa_CP, s.IndexBeta_CP] = size(s.CP_Tab);
   

    % ---------- Identifying Optimal Values ---------- 
    who.CP_min = 'Optimal Power coefficient, in [dimensionless].';
    [s.CP_optB, s.IndexBeta_CPopt] = max( max(s.CP_Tab) ); 
    [s.CP_opt, s.IndexLambda_CPopt] = max(s.CP_Tab(:,s.IndexBeta_CPopt)); 
    who.Beta_opt = 'Optimal Blade Pitch, in [deg].';    
    s.Beta_opt = s.Beta_Tab(1,s.IndexBeta_CPopt); 
    who.Lambda_opt = 'Optimal Tip-Speed-Ratio, in [dimensionless].';
    s.Lambda_opt = s.Lambda_Tab(1,s.IndexLambda_CPopt); 
    who.Kopt = 'Aerodynamic constant using the Optimal Torque (OT) algorithm, in [kg.m^2]. Generator torque constant in Region 2 (VS_Rgn2K), used by Jonkman (pg 61,2009).';
    s.Kopt = (0.5*s.rho*pi*(s.Rrd^5)*(1/s.Lambda_opt^3)*s.CP_opt); 


    % ---- Relationship between Power Coefficient and TSR for Region 3 ---- 
    who.Lambda_rated = 'Rated Tip-Speed-Ratio (Start of Operation in Region 3). See page 7, Botasso (2009).';
    s.Lambda_rated = s.RatedTipSpeed/s.Vws_Rated;
    who.Lambda_CutOut = 'Cut-Out Tip-Speed-Ratio (End of Operation in Region 3). See page 7, Botasso (2009).';
    s.Lambda_CutOut = s.RatedTipSpeed/ s.Vws_CutOut;
    who.indexLambdaRated = 'Index for TSR in Region 3.';
    s.indexLambdaRated = find( s.Lambda_Tab <= s.Lambda_rated & s.Lambda_Tab >= s.Lambda_CutOut );
    who.Lambda_Region3 = 'Tip-Speed-Ratio in Region 3. See page 7, Botasso (2009).';
    s.Lambda_Region3 = s.Lambda_Tab(s.indexLambdaRated);

    who.Cp_rated  = 'Rated Power coefficient, Region 3 according to Strategy 2 and in [m/s].See page 7, Botasso (2009).';
    s.Cp_rated = ( (2 .* s.Pmec_max  ) ./ (s.rho .* pi .*(s.Rrd.^2) .* s.RatedTipSpeed.^3 ) ) .* s.Lambda_rated.^3; 
    who.Cp_Region3  = 'Power coefficient in Region 3.See page 7, Botasso (2009).';
    s.Cp_Region3 = s.Cp_rated*( s.Lambda_Region3 ./ s.Lambda_rated ).^3; 
    
    Cp_Tab = s.CP_Tab(s.indexLambdaRated,:);
    Cp_Tab( Cp_Tab < 0) = 100;
    Cp_Tab( Cp_Tab > s.CP_max) = 100;
    for iit = 1:length( s.Cp_Region3 )
        [s.Cp_Tab0, s.indexBetaRegion3] = mink( abs( Cp_Tab(iit,:) - s.Cp_Region3(iit) ) , 5);
        rangMax = max( s.Beta_Tab(s.indexBetaRegion3) );
        rangMin = min( s.Beta_Tab(s.indexBetaRegion3) );
        N_rang = ceil( 10*(rangMax - rangMin) );

        Beta_Region30 = linspace( rangMin , rangMax , N_rang);
        CP_MAP = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_Region3(iit) , Beta_Region30)';
        delta_Pa = abs( s.Pmec_max -  0.5 .* s.rho .* pi .* (s.Rrd.^2) .* s.RatedTipSpeed.^3 .* ( CP_MAP ./ s.Lambda_Region3(iit).^3 )  );         
        s.Beta_Region3(iit) =  Beta_Region30(  delta_Pa  == min(delta_Pa)  ) ;
    end
    s.Cp_Region3 = [s.Cp_rated*( s.Lambda_CutOut ./ s.Lambda_rated ).^3 s.Cp_Region3 s.Cp_rated]; % Update    
    s.Lambda_Region3 = [s.Lambda_CutOut s.Lambda_Region3 s.Lambda_rated]; % Update

    who.Beta_Region3 = 'Blade Pitch in Region 3. See page 7, Botasso (2009).';
    s.Beta_Region3( s.Beta_Region3 < 0 ) = s.Beta_opt;
    s.Beta_Region3 = [s.Beta_Region3 s.Beta_opt];

    Beta_Region40 = linspace( s.Beta_Region3(1) , s.Beta_max , 100);
    CP_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_CutOut , Beta_Region40 )';
    CP_4( CP_4 < 0) = 100;
    CP_4( CP_4 > s.CP_max) = 100;   
    delta_Pa = abs( s.Pmec_max -  0.5 .* s.rho .* pi .* (s.Rrd.^2) .* s.RatedTipSpeed.^3 .* ( CP_4 ./ s.Lambda_CutOut.^3 )  );         
    s.Beta_Region3 = [Beta_Region40(delta_Pa  == min(delta_Pa)) s.Beta_Region3];

    who.Beta_Region4 = 'Blade Pitch in Region 4.';
    s.Beta_Region4 =  Beta_Region40(delta_Pa  == min(delta_Pa)) ;

    who.Vop_Region3_0 = 'Wind Speed ​​at the Operating Point in Region 3.';
    s.Vop_Region3_0 = s.RatedTipSpeed ./ s.Lambda_Region3;
    % See and analyze the figures:
            % plot( s.Vop_Region3_0 , s.Lambda_Region3)
            % plot( s.Vop_Region3_0 , s.Beta_Region3)

    % NOTE: Use interpolation for initial blade pitch values ​​to solve the
    % drive train equation in steady state:
        % s.Beta_op0 = interp1(s.Vop_Region3_0, s.Beta_Region3, s.Vop, 'linear');


    % ------ Wind Speed ​​and TSR in Region 4 ------ 
    who.indexLambdaCutOut = 'Index for TSR in Region 3.';
    s.indexLambdaCutOut = find( s.Lambda_Tab <= s.Lambda_CutOut  & s.Lambda_Tab >= min(s.Lambda_Tab) );
    who.Lambda_Region4 = 'Initial estimate for Tip-Speed-Ratio in Region 4 operation. ';
    s.Lambda_Region4 = [s.Lambda_CutOut flip(s.Lambda_Tab(s.indexLambdaCutOut))];

    who.Vop_Region4 = 'Initial estimate for Wind Speed ​​in Region 4 operation, in [m/s].';  
    s.Vop_Region4 = (s.Vws_CutOut):0.1:40;
    who.Rrd_Vop = 'Wind Speed ​​at the Operating Point in Region 4.';  
    s.Rrd_Vop = s.Rrd ./ s.Vop_Region4  ; % plot( s.Lambda_Region4 , s.Lambda_Rrd)
    who.indexRangeOp_Region4 = 'Index for TSR in Region 3.';
    s.indexRangeOp_Region4 = find( s.Rrd_Vop  >= min(s.Lambda_Tab)  );
    who.Vop_op4 = 'Wind Speed ​​at the Operating Point in Region 4.';  
    s.Vop_op4 = s.Vop_Region4(s.indexRangeOp_Region4);

    who.Lambda_op4 = 'Tip-Speed-Ratio in Region 4. ';
    s.Lambda_op4 = linspace( max(s.Lambda_Region4) , min(s.Lambda_Region4) , length(s.Vop_op4) );

    who.OmegaR_op4 = 'Rotor Speed for Region 4 and in Steady-State. ';
    s.OmegaR_op4 = [s.OmegaR_Rated (( s.Vop_op4(2:end) .* s.Lambda_op4(2:end) ) ./ s.Rrd) ];
    s.OmegaR_op4 = min( max( s.OmegaR_op4 , 0) , s.OmegaR_Rated) ;
    % plot( s.Vop_op4, s.OmegaR_op4 )
        % s.OmegaR_op0 = interp1(s.Vop_op4, s.OmegaR_op4 , s.Vop, 'linear');


    % ---------- Plot Wind Turbine Performance Results ----------
    if s.Option04f5 == 2 
        % Plot CP, CT and CQ coefficients as a function of Lambda_Tab and Beta_Tab.
        % Plot Partial Derivatives of CP and CT coefficients, in relation to variation of Lambda_Tab and Beta_Tab.

        % Assign value to variable in specified workspace
        assignin('base', 's', s);
        assignin('base', 'who', who);
        assignin('base', 'WindTurbine_data', WindTurbine_data);                
         
        System_LoadsAerodynamics('logical_instance_03');
    end


    % ---------- Steady-state wind operating speed ----------
    who.Vop = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s].';
    s.Vop = [0.01 0.1:0.1:s.Vop_op4(end)];


   % Organizing output results   
   WindTurbine_data.Notef5_1 = who.Notef5_1;
   WindTurbine_data.Beta_Tab = s.Beta_Tab; WindTurbine_data.Lambda_Tab = s.Lambda_Tab; WindTurbine_data.CP_Tab = s.CP_Tab; WindTurbine_data.CT_Tab = s.CT_Tab; WindTurbine_data.CQ_Tab = s.CQ_Tab;
   WindTurbine_data.Grad_CpLambda = s.Grad_CpLambda; WindTurbine_data.Grad_CpBeta = s.Grad_CpBeta;
   WindTurbine_data.Grad_CtLambda = s.Grad_CtLambda; WindTurbine_data.Grad_CtBeta = s.Grad_CtBeta;  
   WindTurbine_data.Beta_min = s.Beta_min; WindTurbine_data.Beta_max = s.Beta_max; WindTurbine_data.Lambda_min = s.Lambda_min; WindTurbine_data.Lambda_max = s.Lambda_max; WindTurbine_data.CP_min = s.CP_min;  WindTurbine_data.CP_max = s.CP_max; WindTurbine_data.CQ_min = s.CQ_min;  WindTurbine_data.CQ_max = s.CQ_max; WindTurbine_data.CT_min = s.CT_min;  WindTurbine_data.CT_max = s.CT_max; WindTurbine_data.IndexLambdaa_CP = s.IndexLambdaa_CP; WindTurbine_data.IndexBeta_CP = s.IndexBeta_CP;
   WindTurbine_data.IndexBeta_CPopt = s.IndexBeta_CPopt; WindTurbine_data.IndexLambda_CPopt = s.IndexLambda_CPopt; WindTurbine_data.s.CP_opt = s.CP_opt; WindTurbine_data.Beta_opt = s.Beta_opt; WindTurbine_data.Lambda_opt = s.Lambda_opt; WindTurbine_data.Kopt = s.Kopt;
   WindTurbine_data.Lambda_Region3 = s.Lambda_Region3; WindTurbine_data.Cp_rated  = s.Cp_rated; WindTurbine_data.Cp_Region3 = s.Cp_Region3; WindTurbine_data.Beta_Region3 = s.Beta_Region3; WindTurbine_data.Vop_Region3_0 = s.Vop_Region3_0;
   WindTurbine_data.Lambda_Region4 = s.Lambda_Region4; WindTurbine_data.Vop_op4 = s.Vop_op4; WindTurbine_data.Lambda_op4 = s.Lambda_op4; WindTurbine_data.OmegaR_op4 = s.OmegaR_op4;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance    
   WindTurbineData_IEA15MW('logical_instance_09');


%=============================================================
elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % STEADY-STATE OPERATION WITH STRATEGY 1 BY FIGURE 2 ABBAS 2022 (OFFLINE):
    % Purpose of this Logical Instance: to present the data from the Control
    % Strategy proposed by Abbas (2022), referred to as Strategy 1, for
    % steady-state operation. Figure 2 Abbas (2022) presents a strategy
    % where the TSR is constant and equal to its optimum value, for the 
    % entire operating range below the nominal. The rotor speed is defined
    % as a function of the optimum rotor speed, as well as the blade pitch.
        

    % ---------------- REGION 1 (unproductive region) ----------------
    who.Strategy1_Region1 = 'According to Figure 2a of Abbas (2022), Region 1 is when the wind speed is below the turbine´s Cut-in wind speed.';  
           % Setup: Use wind to accelerate the drive train.    
    who.Vop1_Region1Region15 = 'Effective Wind Speed ​​at the operating point (Strategy 1) where Region 1 ENDS and Region 1.5 START, in [m/s].';
    s.Vop1_Region1Region15 = s.Vws_CutIn;
    who.Vop1_1 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_1 = [0.01 0.1:0.1:s.Vws_CutIn;];
    who.Lambda_op1_1 = 'Tip-Speed-Ratio. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_1 = s.Lambda_opt .* ones(1, length(s.Vop1_1) ); 
    who.OmegaR_op1_1 = 'Rotor speed ​, in [rad/s]. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_1 = (s.Vop1_1 .* s.Lambda_op1_1 ) ./ s.Rrd; 
    who.Beta_op1_1 = 'Blade Pitch, in [deg]. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Beta_op1_1 = s.Beta_opt .* ones(1,length(s.Vop1_1) );       
    who.Tg_op1_1 = 'Generator Torque , in [N.m]. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Tg_op1_1 = 0 .* ones(1,length(s.Vop1_1) );  

           % The Aerodynamic Model at the operating point:
    who.CP_op1_1 = 'Power coefficient. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CP_op1_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_1, s.Beta_op1_1);
    who.CQ_op1_1 = 'Power coefficient. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_1 = s.CP_op1_1 ./ s.Lambda_op1_1;   
    who.CT_op1_1 = 'Power coefficient. Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_1, s.Beta_op1_1);           

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_1 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_1  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_1, s.Beta_op1_1);
    who.GradCpLambda_op1_1 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_1, s.Beta_op1_1);
    
           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"   
    who.GradCtBeta_op1_1 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_1  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_1, s.Beta_op1_1);
    who.GradCtLambda_op1_1 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 1 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_1, s.Beta_op1_1);           

           % Consolidation of Strategy 1 Data, adding Region 1 data 
    s.Vop1 = s.Vop1_1;
    s.Indexop1_Region1Region15 = length(s.Vop1);
    s.OmegaR_op1 = s.OmegaR_op1_1;
    s.Lambda_op1 = s.Lambda_op1_1;
    s.Beta_op1 = s.Beta_op1_1;
    s.Tg_op1 = s.Tg_op1_1;  
    s.CP_op1 = s.CP_op1_1;
    s.CQ_op1 = s.CQ_op1_1;
    s.CT_op1 = s.CT_op1_1;
    s.GradCpBeta_op1 = s.GradCpBeta_op1_1;
    s.GradCpLambda_op1 = s.GradCpLambda_op1_1;
    s.GradCtBeta_op1 = s.GradCtBeta_op1_1;
    s.GradCtLambda_op1 = s.GradCtLambda_op1_1;


   % ---------- REGION 1.5 (Transition between Region 1 and 2)----------    
    who.Strategy1_Region15 = 'According to Figure 2a of Abbas (2022), Region 1.5 is when the wind speed is above the turbine´s Cut-in wind speed, but the turbine cannot operate at its optimal tip speed ratio (TSR).';
           % Setup: Linear transition between Region 1 and 2.     

    who.OmegaRop1_Region15Region2 = 'Rotor speed at the operating point where Region 1.5 ENDS and Region 2 START, in [rad/s].';
    s.OmegaRop1_Region15Region2 = s.OmegaR_CutIn;
    who.Vop1_Region15Region2 = 'Effective Wind Speed ​​at the operating point (Strategy 1) where Region 1.5 ENDS and Region 2 START, in [m/s].';
    s.Vop1_Region15Region2 = ((s.Rrd*s.OmegaRop1_Region15Region2)./s.Lambda_opt);   
    who.Vop1_15 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_15 = [s.Vws_CutIn:0.1:6 s.Vop1_Region15Region2]; % Note: Vop1 = s.Vws_CutIn should be disregarded later
    who.Lambda_op1_15 = 'Tip-Speed-Ratio. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_15 = s.Lambda_opt .* ones(1, length(s.Vop1_15) ); 
    who.OmegaR_op1_15 = 'Rotor speed, in [rad/s]. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_15 = ( s.Vop1_15 .* s.Lambda_op1_15 ) ./ s.Rrd; 
    who.Beta_op1_15 = 'Blade pitch, in [deg]. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Beta_op1_15 = s.Beta_opt .* ones(1,length(s.Vop1_15) ); 

           % The Aerodynamic Model at the operating point:
    who.CP_op1_15 = 'Power coefficient. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';   
    s.CP_op1_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_15, s.Beta_op1_15 );
    who.CQ_op1_15 = 'Power coefficient. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_15 = s.CP_op1_15 ./ s.Lambda_op1_15; 
    who.CT_op1_15 = 'Power coefficient. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_15, s.Beta_op1_15 );

    who.Tg_op1_15 = 'Generator Torque, in [N.m]. Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
        % Driven-Train dynamic in Steady-State: 0 = Ta - CCdt*OmegaR - Tg 
    s.Tg_op1_15 =  ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop1_15.^2 .* s.CP_op1_15 .* (1 ./ s.Lambda_op1_15 ) ) - ( s.CCdt .* s.OmegaR_op1_15 ) ;


           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_15 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_15, s.Beta_op1_15 );
    who.GradCpLambda_op1_15 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_15 , s.Beta_op1_15 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op1_15 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_15, s.Beta_op1_15);
    who.GradCtLambda_op1_15 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 1.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_15, s.Beta_op1_15);

           % Consolidation of Strategy 1 Data, adding Region 1.5 data 
    s.Vop1 = [s.Vop1 s.Vop1_15(2:end)];
    s.Indexop1_Region15Region2 = s.Indexop1_Region1Region15 + length( s.Vop1_15(2:end) );
    s.OmegaR_op1 = [s.OmegaR_op1 s.OmegaR_op1_15(2:end)];
    s.Lambda_op1 = [s.Lambda_op1 s.Lambda_op1_15(2:end)];
    s.Beta_op1 = [s.Beta_op1 s.Beta_op1_15(2:end)];
    s.Tg_op1 = [s.Tg_op1 s.Tg_op1_15(2:end)];  
    s.CP_op1 = [s.CP_op1 s.CP_op1_15(2:end)];
    s.CQ_op1 = [s.CQ_op1 s.CQ_op1_15(2:end)];
    s.CT_op1 = [s.CT_op1  s.CT_op1_15(2:end)];
    s.GradCpBeta_op1 = [s.GradCpBeta_op1 s.GradCpBeta_op1_15(2:end)];
    s.GradCpLambda_op1 = [s.GradCpLambda_op1 s.GradCpLambda_op1_15(2:end)];
    s.GradCtBeta_op1 = [s.GradCtBeta_op1 s.GradCtBeta_op1_15(2:end)];
    s.GradCtLambda_op1 = [s.GradCtLambda_op1 s.GradCtLambda_op1_15(2:end)];


    % ---------- REGION 2 (Energy Capture Optimization)----------      
    who.Strategy1_Region2 = 'According to Figure 2a of Abbas (2022), Region 2 is when the wind speed is large enough that the turbine can operate at its optimal TSR but is still below rated.';
           % Setup: Optimize energy production. 
    who.OmegaRop1_Region2Region25 = 'Rotor speed at the operating point where Region 2 ENDS and Region 2.5 START, in [rad/s].';
    s.OmegaRop1_Region2Region25 = s.OmegaR_Rated;
    who.Vop1_Region2Region25 = 'Effective Wind Speed ​​at the operating point (Strategy 1) where Region 2 ENDS and Region 2.5 START, in [m/s].';
    s.Vop1_Region2Region25 = ((s.Rrd*s.OmegaRop1_Region2Region25)./s.Lambda_opt);
    who.Vop1_2 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_2 = [s.Vop1_Region15Region2 6.2:0.1:10.6 s.Vop1_Region2Region25]; % Note: then you should disregard the point "Vop1 = Vop1_Region15Region2" and consider "Vop1 = Vop1_Region2Region25".
    who.Lambda_op1_2 = 'Tip-Speed-Ratio​​. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_2 = s.Lambda_opt .* ones(1, length(s.Vop1_2) );
    who.OmegaR_op1_2 = 'Rotor speed, in [rad/s]. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_2 = ((s.Lambda_op1_2 .* s.Vop1_2 ) ./ s.Rrd);
    who.Beta_op1_2 = 'Blade pitch, in [deg]. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Beta_op1_2 = s.Beta_opt .* ones(1,length(s.Vop1_2) ); 

           % The Aerodynamic Model at the operating point:
    who.CP_op1_2 = 'Power coefficient. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';   
    s.CP_op1_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_2, s.Beta_op1_2 );
    who.CQ_op1_2 = 'Power coefficient. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_2 = s.CP_op1_2 ./ s.Lambda_op1_2; 
    who.CT_op1_2 = 'Power coefficient. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_2, s.Beta_op1_2 );

    who.Tg_op1_2 = 'Generator Torque, in [N.m]. Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
        % Driven-Train dynamic in Steady-State: 0 = Ta - CCdt*OmegaR - Tg 
    s.Tg_op1_2 =  ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop1_2.^2 .* s.CP_op1_2 .* (1 ./ s.Lambda_op1_2 ) ) - ( s.CCdt .* s.OmegaR_op1_2 ) ;

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_2 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_2, s.Beta_op1_2 );
    who.GradCpLambda_op1_2 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_2 , s.Beta_op1_2 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op1_2 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_2, s.Beta_op1_2);
    who.GradCtLambda_op1_2 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 2 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_2, s.Beta_op1_2);

           % Consolidation of Strategy 1 Data, adding Regions 2 and 2.5 data 
    s.Vop1 = [s.Vop1 s.Vop1_2(2:end)];
    s.Indexop1_Region2Region25 = s.Indexop1_Region15Region2 + length( s.Vop1_2(2:end) ) ;
    s.OmegaR_op1 = [s.OmegaR_op1 s.OmegaR_op1_2(2:end)];
    s.Lambda_op1 = [s.Lambda_op1 s.Lambda_op1_2(2:end)];
    s.Beta_op1 = [s.Beta_op1 s.Beta_op1_2(2:end)];
    s.Tg_op1 = [s.Tg_op1 s.Tg_op1_2(2:end)];  
    s.CP_op1 = [s.CP_op1 s.CP_op1_2(2:end)];
    s.CQ_op1 = [s.CQ_op1 s.CQ_op1_2(2:end)];
    s.CT_op1 = [s.CT_op1  s.CT_op1_2(2:end)];
    s.GradCpBeta_op1 = [s.GradCpBeta_op1 s.GradCpBeta_op1_2(2:end)];
    s.GradCpLambda_op1 = [s.GradCpLambda_op1 s.GradCpLambda_op1_2(2:end)];
    s.GradCtBeta_op1 = [s.GradCtBeta_op1 s.GradCtBeta_op1_2(2:end)];
    s.GradCtLambda_op1 = [s.GradCtLambda_op1 s.GradCtLambda_op1_2(2:end)];


    % ---------- REGION 2.5 (Transition from productive to nominal region)----------            
    who.Strategy1_Region25 = 'According to Figure 2a of Abbas (2022), Region 2.5 is when the wind speed is larger than the wind speed that corresponds with rated rotor speed, but less than the wind speed that corresponds with rated power.';
           % Setup: Linear transition between Region 2 and 3.     
    who.OmegaRop1_Region25Region3 = 'Rotor speed at the operating point where Region 2.5 ENDS and Region 3 START, in [rad/s].';
    s.OmegaRop1_Region25Region3 = s.OmegaR_Rated;
    who.Vop1_Region25Region3 = 'Effective Wind Speed ​​at the operating point (Strategy 1) where Region 2.5 ENDS and Region 3 START, in [m/s].';
    s.Vop1_Region25Region3 = s.Vws_Rated;
    who.Vop1_25 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_25 = [s.Vop1_Region2Region25 10.7:0.1:11.3 s.Vop1_Region25Region3]; % Note: the points "Vop1 = Vop1_Region2Region25" and "Vop1 = Vop1_Region25Region3" must be disregarded.     
    who.OmegaR_op1_25 = 'Rotor speed, in [rad/s]. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_25 = s.OmegaR_Rated .* ones(1, length(s.Vop1_25) ); 
    who.Lambda_op1_25 = 'Tip-Speed-Ratio​. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_25 = (s.Rrd*s.OmegaR_op1_25) ./ s.Vop1_25;
    who.Beta_op1_25 = 'Blade pitch, in [deg]. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Beta_op1_25 = s.Beta_opt .* ones(1,length(s.Vop1_25) );   

           % The Aerodynamic Model at the operating point:
    who.CP_op1_25 = 'Power coefficient. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';   
    s.CP_op1_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_25, s.Beta_op1_25 );
    who.CQ_op1_25 = 'Power coefficient. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_25 = s.CP_op1_25 ./ s.Lambda_op1_25; 
    who.CT_op1_25 = 'Power coefficient. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_25, s.Beta_op1_25 );

    who.Tg_op1_25 = 'Generator Torque​​, in [N.m]. Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
        % Driven-Train dynamic in Steady-State: 0 = Ta - CCdt*OmegaR - Tg     
    s.Tg_op1_25 = ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop1_25.^2 .* s.CP_op1_25 .* (1 ./ s.Lambda_op1_25) ) - ( s.CCdt .* s.OmegaR_op1_25 ) ;

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_25 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_25, s.Beta_op1_25 );
    who.GradCpLambda_op1_25 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_25 , s.Beta_op1_25 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op1_25 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_25, s.Beta_op1_25);
    who.GradCtLambda_op1_25 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 2.5 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_25, s.Beta_op1_25);

           % Consolidation of Strategy 1 Data, adding Regions 2 and 2.5 data 
    s.Vop1 = [s.Vop1 s.Vop1_25(2:end-1)];
    s.Indexop1_Region25Region3 = s.Indexop1_Region2Region25 + length( s.Vop1_25(2:end-1) );
    s.OmegaR_op1 = [s.OmegaR_op1 s.OmegaR_op1_25(2:end-1)];
    s.Lambda_op1 = [s.Lambda_op1 s.Lambda_op1_25(2:end-1)];
    s.Beta_op1 = [s.Beta_op1 s.Beta_op1_25(2:end-1)];
    s.Tg_op1 = [s.Tg_op1 s.Tg_op1_25(2:end-1)];  
    s.CP_op1 = [s.CP_op1 s.CP_op1_25(2:end-1)];
    s.CQ_op1 = [s.CQ_op1 s.CQ_op1_25(2:end-1)];
    s.CT_op1 = [s.CT_op1  s.CT_op1_25(2:end-1)];
    s.GradCpBeta_op1 = [s.GradCpBeta_op1 s.GradCpBeta_op1_25(2:end-1)];
    s.GradCpLambda_op1 = [s.GradCpLambda_op1 s.GradCpLambda_op1_25(2:end-1)];
    s.GradCtBeta_op1 = [s.GradCtBeta_op1 s.GradCtBeta_op1_25(2:end-1)];
    s.GradCtLambda_op1 = [s.GradCtLambda_op1 s.GradCtLambda_op1_25(2:end-1)];
    

    % ---------- REGION 3 (Nominal point operation)----------          
    who.Strategy1_Region3 = 'According to Figure 2a of Abbas (2022), Region 3 is when the wind speed is above rated. The blade pitch controller regulates the rotor speed, and the generator torque is either constant or maintains constant power output.';
           % Setup: Reduce loads and maintain operation at rated values.     
    who.Vop1_Region3Region4 = 'Effective Wind Speed ​​at the operating point (Strategy 1) where Region 3 ENDS and Region 4 START, in [m/s].';
    s.Vop1_Region3Region4 = s.Vws_CutOut;
    who.Vop1_3 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_3 = [s.Vws_Rated 11.5:0.1:24.9 s.Vws_CutOut];
    who.OmegaR_op1_3 = 'Rotor speed, in [rad/s]. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_3  = s.OmegaR_Rated .* ones(1, length(s.Vop1_3) );
    who.Lambda_op1_3 = 'Tip-Speed-Ratio. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_3 = (s.Rrd*s.OmegaR_op1_3 ) ./ s.Vop1_3;   
    who.Tg_op1_3 = 'Generator Torque, in [N.m]. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Tg_op1_3 = (s.Pmec_max / s.OmegaR_Rated ) .* ones(1, length(s.Vop1_3) );
    
    who.Beta_op1_3 = 'Blade pitch, in [deg]. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';  
    TorqueMec = s.Tg_op1_3 + ( s.CCdt .* s.OmegaR_op1_3 ) ;
    Cpws_fun = @(Beta_MAP)  min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_3, Beta_MAP), 0), s.CP_max);  
    Fun = @(Beta_MAP) (TorqueMec - ( 0.5 .* s.rho .* pi .* s.Rrd.^2 .*  Cpws_fun(Beta_MAP) .* (1 ./ s.OmegaR_op1_3) .* s.Vop1_3.^3) );
    optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);    
    beta_op0 = interp1(s.Vop_Region3_0, s.Beta_Region3, s.Vop1_3, 'linear');
    Beta_MAP = fsolve(Fun, beta_op0, optionsFsolve); 
    s.Beta_op1_3 = min( max( Beta_MAP, s.Beta_opt ) , s.Beta_max) ; 
    % plot( s.Vop1_3 , s.Beta_op1_3)


           % The Aerodynamic Model at the operating point:
    who.CP_op1_3 = 'Power coefficient. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';   
    s.CP_op1_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_3, s.Beta_op1_3 );
    who.CQ_op1_3 = 'Power coefficient. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_3 = s.CP_op1_3 ./ s.Lambda_op1_3; 
    who.CT_op1_3 = 'Power coefficient. Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_3, s.Beta_op1_3 );    

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_3 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_3, s.Beta_op1_3 );
    who.GradCpLambda_op1_3 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_3, s.Beta_op1_3 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op1_3 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_3, s.Beta_op1_3);
    who.GradCtLambda_op1_3 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 3 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_3, s.Beta_op1_3);

           % Consolidation of Strategy 1 Data, adding Region 3 data 
    s.Vop1 = [s.Vop1 s.Vop1_3];
    s.Indexop1_Region3Region4 = s.Indexop1_Region25Region3 + length( s.Vop1_3 );
    s.OmegaR_op1 = [s.OmegaR_op1 s.OmegaR_op1_3];
    s.Lambda_op1 = [s.Lambda_op1 s.Lambda_op1_3];
    s.Beta_op1 = [s.Beta_op1 s.Beta_op1_3];
    s.Tg_op1 = [s.Tg_op1 s.Tg_op1_3];  
    s.CP_op1 = [s.CP_op1 s.CP_op1_3];
    s.CQ_op1 = [s.CQ_op1 s.CQ_op1_3];
    s.CT_op1 = [s.CT_op1  s.CT_op1_3];
    s.GradCpBeta_op1 = [s.GradCpBeta_op1 s.GradCpBeta_op1_3];
    s.GradCpLambda_op1 = [s.GradCpLambda_op1 s.GradCpLambda_op1_3];
    s.GradCtBeta_op1 = [s.GradCtBeta_op1 s.GradCtBeta_op1_3];
    s.GradCtLambda_op1 = [s.GradCtLambda_op1 s.GradCtLambda_op1_3];


    % ---------- REGION 4 (unproductive region)----------
    who.Strategy1_Region4 = 'Use the possible Shutdown Strategy for CP, CQ, CT, Lambda_Tab and Beta_Tab data, just to avoid numerical errors in the simulation.';
           % Setup: Shut down or linearly reduce operation (normal operating conditions).      
    who.Vop1_Region3Region4 = 'Effective operating speed at the operating point in Region 4, in [m/s]. This is the operating point where the wind turbine is turned off (maximum point for simulation of this code).';
    s.Vop1_Region4EndOperation  = s.Vop(end);
    who.Vop1_4 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Vop1_4 = [s.Vws_CutOut 25.1:0.1:31.4 s.Vop1_Region4EndOperation]; % Note: then the point "Vop1 = s.Vws_CutOut" disregarded.
    who.OmegaR_op1_4 = 'Rotor speed, in [rad/s]. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.OmegaR_op1_4 = interp1(s.Vop_op4, s.OmegaR_op4, s.Vop1_4 , 'linear');     
    who.Lambda_op1_4 = 'Tip-Speed-Ratio. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Lambda_op1_4 = (s.Rrd .* s.OmegaR_op1_4) ./ s.Vop1_4 ;    
    deltaOmegaTg = abs( s.OmegaR_op1 - s.OmegaR_op1_4(end) );
    Tg_op4 = s.Tg_op1( find( deltaOmegaTg == min(deltaOmegaTg)) );
    who.Tg_op1_3 = 'Generator Torque, in [N.m]. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.Tg_op1_4 = linspace( s.Tg_op1_3(end) , Tg_op4 , length(s.Vop1_4) );

    who.Beta_op1_4 = 'Blade pitch, in [deg]. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';         
    Tmec_op4 = s.Tg_op1_4  + ( s.CCdt .* s.OmegaR_op1_4 ) ; % Ta == Tg - Tperda = 0.5*s.rho*pi*s.Rrd^2*s.Cp*(1/s.OmegaR)*s.Vews_rel^3;  
    s.Beta_op1_4 = max(s.Beta_op1);
    s.Beta04_min = min( max( ( s.Beta_op1_4 - 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);   
    s.Beta04_max = min( max( ( s.Beta_op1_4 + 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);
    beta_op04 = s.Beta_op1_4;
    for iit = 1:length(s.Vop1_4)
        Cpws_fun = @(Beta_MAP)  min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_4(iit) , Beta_MAP), 0), s.CP_max);  
        Fun = @(Beta_MAP) ( Tmec_op4(iit) - (0.5 .* s.rho .* pi .* s.Rrd.^2 .* Cpws_fun(Beta_MAP) .*( 1 ./ s.OmegaR_op1_4(iit) ) .* s.Vop1_4(iit)  .^3) );
        optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);   
        Beta_MAP = fsolve(Fun, beta_op04(iit), optionsFsolve); 
        s.Beta_op1_4(iit+1) = min( max( Beta_MAP, s.Beta04_min(iit) ) , s.Beta04_max(iit) );

        s.Beta04_min(iit+1) = min( max( ( s.Beta_op1_4(iit+1) - 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);   
        s.Beta04_max(iit+1) = min( max( ( s.Beta_op1_4(iit+1) + 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);
        beta_op04(iit+1) = s.Beta_op1_4(iit+1) ;
    end
    s.Beta_op1_4 = s.Beta_op1_4(2:end); % Update.


    if s.Option01f5 == 1 || s.Option01f5 == 2       
        Cpws_op4 = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_4 , s.Beta_op1_4), 0), s.CP_max);  
        Fun_op4 = ( Tmec_op4 - (0.5 .* s.rho .* pi .* s.Rrd.^2 .* Cpws_op4  .*( 1 ./ s.OmegaR_op1_4 ) .* s.Vop1_4 .^3) );
        % Accepted tolerance ± 0.5% of maximum torque
        who.TolerVal_Region4 = 'Tolerance accepted for validation of results in Region 4. Adopted value of ± 0.5% of maximum torque..';
        s.TolerVal_Region4 = 0.005*s.Tg_rated;        
        s.indexVal_Region4 = find( abs(Fun_op4) <= s.TolerVal_Region4 );
        s.Vop1_4Edited = s.Vop1_4(s.indexVal_Region4);
        s.Vop1_4 = s.Vop1_4Edited;

        s.OmegaR_op1_4Edited = s.OmegaR_op1_4(s.indexVal_Region4);
        s.OmegaR_op1_4 = s.OmegaR_op1_4Edited;
        s.Lambda_op1_4Edited = s.Lambda_op1_4(s.indexVal_Region4);
        s.Lambda_op1_4 = s.Lambda_op1_4Edited;
        s.Tg_op1_4Edited = s.Tg_op1_4(s.indexVal_Region4);
        s.Tg_op1_4 = s.Tg_op1_4Edited;
        s.Beta_op1_4Edited = s.Beta_op1_4(s.indexVal_Region4);
        s.Beta_op1_4 = s.Beta_op1_4Edited;
    end

           % The Aerodynamic Model at the operating point:
    who.CP_op1_4 = 'Power coefficient. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';   
    s.CP_op1_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op1_4, s.Beta_op1_4 );
    who.CQ_op1_4 = 'Power coefficient. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CQ_op1_4 = s.CP_op1_4 ./ s.Lambda_op1_4; 
    who.CT_op1_4 = 'Power coefficient. Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.CT_op1_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op1_4, s.Beta_op1_4 );

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op1_4 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpBeta_op1_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op1_4, s.Beta_op1_4 );
    who.GradCpLambda_op1_4 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCpLambda_op1_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op1_4, s.Beta_op1_4 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op1_4 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtBeta_op1_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op1_4, s.Beta_op1_4);
    who.GradCtLambda_op1_4 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 4 according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradCtLambda_op1_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op1_4, s.Beta_op1_4);

           % Consolidation of Strategy 1 Data, adding Region 4 data 
    s.Vop1 = [s.Vop1 s.Vop1_4(2:end)];
    s.Indexop1_Regions4EndOperation = length( s.Vop1 );
    s.Vop1_Region4EndOperation = s.Vop1(end);
    s.OmegaR_op1 = [s.OmegaR_op1 s.OmegaR_op1_4(2:end)];
    s.Lambda_op1 = [s.Lambda_op1 s.Lambda_op1_4(2:end)];
    s.Beta_op1 = [s.Beta_op1 s.Beta_op1_4(2:end)];
    s.Tg_op1 = [s.Tg_op1 s.Tg_op1_4(2:end)];  
    s.CP_op1 = [s.CP_op1 s.CP_op1_4(2:end)];
    s.CQ_op1 = [s.CQ_op1 s.CQ_op1_4(2:end)];
    s.CT_op1 = [s.CT_op1  s.CT_op1_4(2:end)];
    s.GradCpBeta_op1 = [s.GradCpBeta_op1 s.GradCpBeta_op1_4(2:end)];
    s.GradCpLambda_op1 = [s.GradCpLambda_op1 s.GradCpLambda_op1_4(2:end)];
    s.GradCtBeta_op1 = [s.GradCtBeta_op1 s.GradCtBeta_op1_4(2:end)];
    s.GradCtLambda_op1 = [s.GradCtLambda_op1 s.GradCtLambda_op1_4(2:end)];
    s.Indexop1_Region1Region15 = find( s.Vop1 == s.Vop1_Region1Region15 ) ;
    s.Indexop1_Region15Region2 = find( s.Vop1 == s.Vop1_Region15Region2 ) ;
    s.Indexop1_Region2Region25 = find( s.Vop1 == s.Vop1_Region2Region25 ) ;
    s.Indexop1_Region25Region3 = find( s.Vop1 == s.Vop1_Region25Region3 ) ;
    s.Indexop1_Region3Region4 = find( s.Vop1 == s.Vop1_Region3Region4 ) ;
    s.Indexop1_Regions4EndOperation = find( s.Vop1 == s.Vop1_Region4EndOperation ) ;      


      %######## CONSOLIDATION OF OTHER DATA FROM Strategy 1 ########

    % -------- Aerodynamic Model Values ​​in Steady-State -------   
    who.Pa_op1 = 'Aerodynamic power in Steady-State according to Strategy 1 (Figure 2, Abbas 2022), and in [W]';
    s.Pa_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_op1 .* s.Vop1.^3;
    who.Ta_op1 = 'Aerodynamic torque in Steady-State according to Strategy 1 (Figure 2, Abbas 2022), and in [N.m]';
    s.Ta_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_op1 .* (1 ./ s.OmegaR_op1) .* s.Vop1.^3; 
    who.Fa_op1 = 'Aerodynamic thrust in Steady-State according to Strategy 1 (Figure 2, Abbas 2022), and in [N]';
    s.Fa_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CT_op1 .* s.Vop1.^2;

    who.Pe_op1 = 'Generator power in Steady-State according to Strategy 1 (Figure 2, Abbas 2022), and in [W]';
    s.Pe_op1 = ( s.Tg_op1 .* s.OmegaR_op1 ) .* s.etaElec_op;  


    % -------- Partial Derivatives of Aerodynamic Torque -------
    who.GradTaLambda_op1 = 'Partial derivative of the Aerodynamic Torque, in relation to the TSR and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradTaLambda_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop1.^2 .* (1 ./ s.Lambda_op1.^2) .* ( ( s.Lambda_op1 .* s.GradCpLambda_op1 ) - s.CP_op1 );
    who.GradTaOmega_op1 = 'Partial derivative of the Aerodynamic Torque, in relation to the rotor speed and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradTaOmega_op1 = s.GradTaLambda_op1 .* ( s.Rrd ./ s.Vop1 ) ;
    who.GradTaVop_op1 = 'Partial derivative of the Aerodynamic Torque, in relation to the wind speed and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradTaVop_op1 = (- s.GradTaLambda_op1) .* ( ( s.Rrd .* s.OmegaR_op1 ) ./ s.Vop1.^2 ) ;       
    who.GradTaBeta_op1 = 'Partial derivative of the Aerodynamic Torque, in relation to the blade pitch and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradTaBeta_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop1.^2 .* ( 1 ./ s.Lambda_op1.^2) .* ( s.Lambda_op1 .* s.GradCpBeta_op1 );
    s.GradTaBeta_op1( s.GradTaBeta_op1 == 0) = 0.0001;

    who.GradPaBeta_op1 = 'Partial derivative of the Aerodynamic Power, in relation to the blade pitch and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradPaBeta_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop1.^3 .* s.GradCpBeta_op1 ;    
    s.GradPaBeta_op1( s.GradPaBeta_op1 == 0) = 0.001;
          
    who.GradFaLambda_op1 = 'Partial derivative of the Aerodynamic Thrust, in relation to the TSR and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradFaLambda_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop1.^2 .* s.GradCtLambda_op1;
    who.GradFaOmega_op1 = 'Partial derivative of the Aerodynamic Thrust, in relation to the rotor speed and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradFaOmega_op1 = s.GradFaLambda_op1 .* ( s.Rrd ./ s.Vop1 ) ;
    who.GradFaVop_op1 = 'Partial derivative of the Aerodynamic Thrust, in relation to the wind speed and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradFaVop_op1 = (- s.GradFaLambda_op1) .* ( ( s.Rrd .* s.OmegaR_op1 ) ./ s.Vop1.^2 ) ;     
    who.GradFaBeta_op1 = 'Partial derivative of the Aerodynamic Thrust, in relation to the blade pitch and in Steady-State according to Strategy 1 (Figure 2, Abbas 2022).';
    s.GradFaBeta_op1 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop1.^2 .* s.GradCtBeta_op1 ;


    % ---------------- Optimal Wind Turbine Operation ----------------
    who.Strategy1_OptimalOperation = 'Strategy 1 to optimize wind turbine operation is based on the Optimal Torque Control (OTC or OT) algorithm, which uses the squared relationship with rotor speed (Tg = Kopt*OmegaR^2).';
    who.Vop1_opt = 'Effective Wind Speed ​​in Optimal Operation, in [m/s]. Using OTC algorithm.';
    s.Vop1_opt = s.Vop1; 
    who.Lambda_op1_opt = 'Optimal Tip-Speed-Ratio​​.';
    s.Lambda_op1_opt = s.Lambda_opt .* ones(1, length(s.Vop1_opt) );
    who.OmegaR_op1_opt = 'Optimal Rotor speed, in [rad/s].';
    s.OmegaR_op1_opt = ((s.Lambda_op1_opt .* s.Vop1_opt ) ./ s.Rrd); % min(max(  s.OmegaR_op1_opt, s.OmegaR_CutIn ),  s.OmegaR_Rated );
    who.Beta_op1_opt = 'Optimal Blade pitch, in [deg].';
    s.Beta_op1_opt = s.Beta_opt .* ones(1,length(s.Vop1_opt) );    
    who.Ta_op1_opt = 'Optimal Aerodynamic torque, in [N.m]';
    s.Ta_op1_opt = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_max .* (1 ./ s.OmegaR_op1_opt) .* s.Vop1_opt.^3; 
    who.Pa_op1_opt = 'Optimal Aerodynamic power, in [W]';
    s.Pa_op1_opt = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_max .* s.Vop1_opt.^3;

    
    % Organizing output results  
    WindTurbine_data.Vop1 = s.Vop1; WindTurbine_data.OmegaR_op1 = s.OmegaR_op1; WindTurbine_data.Lambda_op1 = s.Lambda_op1; WindTurbine_data.Beta_op1 = s.Beta_op1; WindTurbine_data.Tg_op1 = s.Tg_op1; WindTurbine_data.Pe_op1 = s.Pe_op1;
    WindTurbine_data.CP_op1 = s.CP_op1; WindTurbine_data.Pa_op1 = s.Pa_op1; WindTurbine_data.CQ_op1 = s.CQ_op1; WindTurbine_data.Ta_op1 = s.Ta_op1; WindTurbine_data.CT_op1 = s.CT_op1; WindTurbine_data.Fa_op1 = s.Fa_op1;
    WindTurbine_data.GradCpBeta_op1 = s.GradCpBeta_op1; WindTurbine_data.GradCpLambda_op1 = s.GradCpLambda_op1; WindTurbine_data.GradTaLambda_op1 = s.GradTaLambda_op1; WindTurbine_data.GradTaOmega_op1 = s.GradTaOmega_op1; WindTurbine_data.GradTaVop_op1 = s.GradTaVop_op1; WindTurbine_data.GradTaBeta_op1 = s.GradTaBeta_op1; WindTurbine_data.GradPaBeta_op1 = s.GradPaBeta_op1;
    WindTurbine_data.GradCtBeta_op1 = s.GradCtBeta_op1; WindTurbine_data.GradCtLambda_op1 = s.GradCtLambda_op1; WindTurbine_data.GradFaLambda_op1 = s.GradFaLambda_op1; WindTurbine_data.GradFaOmega_op1 = s.GradFaOmega_op1; WindTurbine_data.GradFaVop_op1 = s.GradFaVop_op1; WindTurbine_data.GradFaBeta_op1 = s.GradFaBeta_op1;    
    WindTurbine_data.Lambda_op1_opt = s.Lambda_op1_opt; WindTurbine_data.OmegaR_op1_opt = s.OmegaR_op1_opt; WindTurbine_data.Beta_op1_opt = s.Beta_op1_opt; WindTurbine_data.Ta_op1_opt = s.Ta_op1_opt; WindTurbine_data.Pa_op1_opt = s.Pa_op1_opt;
    WindTurbine_data.Vop1_Region1Region15 = s.Vop1_Region1Region15 ; WindTurbine_data.Vop1_Region15Region2 = s.Vop1_Region15Region2 ; WindTurbine_data.Vop1_Region2Region25 = s.Vop1_Region2Region25 ; WindTurbine_data.Vop1_Region25Region3 = s.Vop1_Region25Region3 ; WindTurbine_data.Vop1_Region3Region4 = s.Vop1_Region3Region4 ; WindTurbine_data.Vop1_Region4EndOperation = s.Vop1_Region4EndOperation;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance    
   WindTurbineData_IEA15MW('logical_instance_10');


%=============================================================
elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % STEADY-STATE OPERATION WITH STRATEGY 2 (PEAK SHAVING) (OFFLINE):
    % Purpose of this Logical Instance: to present a strategy that aims to reduce 
    % or eliminate the peak thrust or peak loads at the base of the tower. The 
    % strategy is known as "Thrust Limitation" or "Peak Reduction".  Since the
    % objective of this approach is to limit loads, it will be assumed that 
    % this strategy is adopted from the beginning of Region 2.5, up to the 
    % certain operating point "Vop". This final operating value was defined 
    % based on the analysis of the Steady-State Operation of Strategy 2.


    % -------- Operation or Control Strategy Adopted -------- 
    s.Vop2 = s.Vop1;
    s.OmegaR_op2 = s.OmegaR_op1;
    s.Lambda_op2 = s.Lambda_op1;
    s.Beta_op2 = s.Beta_op1;
    s.Tg_op2 = s.Tg_op1;  
    s.CP_op2 = s.CP_op1;
    s.CQ_op2 = s.CQ_op1;
    s.CT_op2 = s.CT_op1;
    s.GradCpBeta_op2 = s.GradCpBeta_op1;
    s.GradCpLambda_op2 = s.GradCpLambda_op1;
    s.GradCtBeta_op2 = s.GradCtBeta_op1;
    s.GradCtLambda_op2 = s.GradCtLambda_op1;
    s.Pa_op2 = s.Pa_op1;
    s.Ta_op2 = s.Ta_op1;
    s.Fa_op2 = s.Fa_op1;
    s.Pe_op2 = s.Pe_op1;
    s.GradTaLambda_op2 = s.GradTaLambda_op1;
    s.GradTaOmega_op2 = s.GradTaOmega_op1;
    s.GradTaVop_op2 = s.GradTaVop_op1;
    s.GradTaBeta_op2 = s.GradTaBeta_op1;
    s.GradPaBeta_op2 = s.GradPaBeta_op1;
    s.GradFaLambda_op2 = s.GradFaLambda_op1;
    s.GradFaOmega_op2 = s.GradFaOmega_op1;
    s.GradFaVop_op2 = s.GradFaVop_op1;
    s.GradFaBeta_op2 = s.GradFaBeta_op1;
    s.Lambda_op2_opt= s.Lambda_op1_opt;
    s.OmegaR_op2_opt = s.OmegaR_op1_opt;
    s.Beta_op2_opt = s.Beta_op1_opt;
    s.Ta_op2_opt = s.Ta_op1_opt;
    s.Pa_op2_opt = s.Pa_op1_opt;
    s.Vop2_Region1Region15 = s.Vop1_Region1Region15 ;
    s.Vop2_Region15Region2 = s.Vop1_Region15Region2 ;
    s.Vop2_Region2Region25 = s.Vop1_Region2Region25 ;    
    s.Vop2_Region25Region3 = s.Vop1_Region25Region3 ;
    s.Vop2_Region3Region4 = s.Vop1_Region3Region4 ;
    s.Vop2_Region4EndOperation = s.Vop1_Region4EndOperation;    
    s.Indexop2_Region1Region15 = s.Indexop1_Region1Region15 ;
    s.Indexop2_Region15Region2 = s.Indexop1_Region15Region2 ;
    s.Indexop2_Region2Region25 = s.Indexop1_Region2Region25 ;
    s.Indexop2_Region25Region3 = s.Indexop1_Region25Region3 ;
    s.Indexop2_Region3Region4 = s.Indexop1_Region3Region4 ;
    s.Indexop2_Regions4EndOperation = s.Indexop1_Regions4EndOperation ;
    s.OmegaRop2_Region25Region3 = s.OmegaRop1_Region25Region3;    
    %


    % -------- Analyzing Thrust Based on an Adopted Operation Strategy --------  
    s.Fa_op1KN = s.Fa_op1 ./ 1e+6;
    if s.Option05f8 == 2              
        NNN = length(s.Vop2); 
        Vline_Regions1Region15 = s.Vop2(s.Indexop2_Region1Region15) .* ones(1,NNN);
        Vline_Regions15Region2 = s.Vop2(s.Indexop2_Region15Region2) .* ones(1,NNN);
        Vline_Regions2Region25 = s.Vop2(s.Indexop2_Region2Region25) .* ones(1,NNN);
        Vline_Regions25Region3 = s.Vop2(s.Indexop2_Region25Region3) .* ones(1,NNN);
        Vline_Regions3Region4 = s.Vop2(s.Indexop2_Region3Region4) .* ones(1,NNN);   
        Vline_Regions4EndOperation = s.Vop2(s.Indexop2_Regions4EndOperation) .* ones(1,NNN);   
        Lineop = [linspace(-0.5,(max(s.Fa_op1KN) + 2),s.Indexop2_Region1Region15) linspace(-0.5,(max(s.Fa_op1KN) + 2),(s.Indexop2_Region15Region2 - s.Indexop2_Region1Region15)) linspace(-0.5,(max(s.Fa_op1KN) + 2),(s.Indexop2_Region2Region25 - s.Indexop2_Region15Region2)) linspace(-0.5,(max(s.Fa_op1KN) + 2),(s.Indexop2_Region25Region3 - s.Indexop2_Region2Region25)) linspace(-0.5,(max(s.Fa_op1KN) + 2),(s.Indexop2_Region3Region4 - s.Indexop2_Region25Region3)) linspace(-0.5,(max(s.Fa_op1KN) + 2),(s.Indexop2_Regions4EndOperation - s.Indexop2_Region3Region4))];

        figure()     
        h = plot(s.Vop2, s.Fa_op1KN, 'm', Vline_Regions1Region15, Lineop, 'k:', Vline_Regions15Region2, Lineop, 'k:', Vline_Regions2Region25, Lineop, 'k:', Vline_Regions25Region3, Lineop, 'k:', Vline_Regions3Region4, Lineop, 'k:', Vline_Regions4EndOperation, Lineop, 'k:');
        set(h(2), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([0 max(s.Vop2)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([0.95*min(s.Fa_op1KN) 1.05*max(s.Fa_op1KN)])        
        legend('Aerodynamic Thrust [KN]', 'Interpreter', 'latex')
        title('Steady-State Aerodynamic Thrust.')
        %
    end


    % -------- Defining Peak Shaving Operating Range. --------
    who.Vop_PeakShaving_0 = 'Effective Wind Speed ​​at the starting point of Peak Shaving operation, in [m/s].';
    s.IndexopPeakShaving_0 = s.Indexop1_Region2Region25;
    s.Vop_PeakShaving_0 = s.Vop2(s.IndexopPeakShaving_0);
    who.Fa_maxPeakShaving = 'Thrust ​​at the ending point of Peak Shaving operation, in [N]].';
    s.Fa_maxPeakShaving = s.Fa_op2(s.IndexopPeakShaving_0);

    who.Vop_PeakShaving_f = 'Effective Wind Speed ​​at the ending point of Peak Shaving operation, in [m/s].';
    s.Vop_PeakShaving_f = interp1(s.Fa_op2(s.Indexop2_Region25Region3:end), s.Vop2(s.Indexop2_Region25Region3:end), s.Fa_maxPeakShaving);
    s.IndexopPeakShaving_f = find( abs( s.Vop2 - s.Vop_PeakShaving_f) == min(abs( s.Vop2 - s.Vop_PeakShaving_f)) ) ;


    % ---- Minimum Collective Blade Pitch for Thrust limiting or Peak Shaving ----------
    who.Beta_PeakShaving = 'Minimum Collective Blade Pitch for Thrust limiting or Peak Shaving.';  
    s.Vop2PS = s.Vop2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f);
    s.Lambda4PS = s.Lambda_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f);
    s.Ct_maxPeakShaving = (2 *s.Fa_maxPeakShaving ) ./ (s.rho .* pi .* s.Rrd.^2 .* s.Vop2PS.^2);
        % plot(s.Vop2PS , s.Ct_maxPeakShaving)

    Ctmax_fun = @(Beta_PeakShaving) (interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda4PS, Beta_PeakShaving));  
    Fun = @(Beta_PeakShaving) ( s.Ct_maxPeakShaving - Ctmax_fun(Beta_PeakShaving)  );
    optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);       
    beta_op0 = s.Beta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f);
    Beta_PeakShaving = fsolve(Fun, beta_op0, optionsFsolve); 
    s.Beta_PeakShaving = min( max( Beta_PeakShaving, s.Beta_op2(s.IndexopPeakShaving_0) ) , s.Beta_op2(s.IndexopPeakShaving_f) ) ; 


    % -------- Steady state solution for Thrust limiting or Peak Shaving --------
    Tg_max = (s.Pmec_max / s.OmegaR_Rated );
    Lost_mec = ( s.CCdt .* s.OmegaR_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) ) ;   
        % Steady-State Equation:   TorqueMec = (s.Pmec_max / s.OmegaR_Rated ) + Lost_mec ;
    for iit = 1:length(s.Beta_PeakShaving)
        Cp4PS = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda4PS(iit), s.Beta_PeakShaving(iit) );
        Tg_4PS = ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS(iit).^2 .* Cp4PS .* (1 ./ s.Lambda4PS(iit) ) ) - ( s.CCdt .* s.OmegaR_op2(s.IndexopPeakShaving_0 + iit) ) ;
        if Tg_4PS > Tg_max
            deltaTmec = Lost_mec(iit) -  abs( Tg_max  - Tg_4PS);
            TorqueMec = Tg_max  +  deltaTmec ;
            Cpws_fun = @(Beta_MAP)  min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda4PS(iit) , Beta_MAP ), 0), s.CP_max);  
            Fun = @(Beta_MAP) (TorqueMec - ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS(iit).^2 .*  Cpws_fun(Beta_MAP) .* (1 ./ s.Lambda4PS(iit) )  ) );
            optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);        
            beta_op00 = s.Beta_PeakShaving(iit) ;
            Beta_MAP = fsolve(Fun, beta_op00 , optionsFsolve);
            s.Beta_PeakShaving(iit) = Beta_MAP;
        end
    end


    % ---------- Recalculating values ​​at operating points in Steady-State ----------
    s.CP_op2_PS = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda4PS, s.Beta_PeakShaving );
    s.CQ_op2_PS = s.CP_op2_PS ./ s.Lambda4PS; 
    s.CT_op2_PS = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda4PS, s.Beta_PeakShaving );  
    s.OmegaR_op2_PS = s.OmegaR_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f);
    s.Tg_op2_PS = ( 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS.^2 .* s.CP_op2_PS .* (1 ./ s.Lambda4PS) ) - ( s.CCdt .* s.OmegaR_op2_PS ) ;
    s.Pe_op2_PS = ( s.Tg_op2_PS .* s.OmegaR_op2_PS ) .* s.etaElec_op;  
    s.Paop2PS = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_op2_PS .* s.Vop2PS.^3;
    s.Taop2PS = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS.^2 .* s.CP_op2_PS .* (1 ./ s.Lambda4PS) ; 
    s.Faop2PS = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CT_op2_PS .* s.Vop2PS.^2;

    s.GradCpBeta_op2PS  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda4PS, s.Beta_PeakShaving );
    s.GradCpLambda_op2PS  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda4PS , s.Beta_PeakShaving );   
    s.GradTaLambda_op2PS = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS.^2 .* (1 ./ s.Lambda4PS.^2) .* ( ( s.Lambda4PS.* s.GradCpLambda_op2PS ) - s.CQ_op2_PS );
    s.GradTaOmega_op2PS = s.GradCpLambda_op2PS .* ( s.Rrd ./ s.OmegaR_op2_PS ) ;
    s.GradTaVop_op2PS = (- s.GradTaLambda_op2PS) .* ( ( s.Rrd .* s.OmegaR_op2_PS ) ./ s.Vop2PS.^2 ) ;       
    s.GradTaBeta_op2PS = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop2PS.^2 .* ( 1 ./ s.Lambda4PS.^2) .* ( s.Lambda4PS.* s.GradCpBeta_op2PS );
    s.GradTaBeta_op2PS( s.GradTaBeta_op2PS == 0) = 0.0001;

    s.GradPaBeta_op2PS = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop2PS.^3 .* s.GradCpBeta_op2PS ;    
    s.GradPaBeta_op2PS( s.GradPaBeta_op2PS == 0) = 0.001;

    s.GradCtBeta_op2PS  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda4PS, s.Beta_PeakShaving);
    s.GradCtLambda_op2PS = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda4PS, s.Beta_PeakShaving);    
    s.GradFaLambda_op2PS = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop2PS.^2 .* s.GradCtLambda_op2PS;
    s.GradFaOmega_op2PS = s.GradFaLambda_op2PS .* ( s.Rrd ./ s.Vop2PS ) ;
    s.GradFaVop_op2PS = (- s.GradFaLambda_op2PS) .* ( ( s.Rrd .* s.OmegaR_op2_PS ) ./ s.Vop2PS.^2 ) ;     
    s.GradFaBeta_op2PS = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop2PS.^2 .* s.GradCtBeta_op2PS ; 



    % ---------- Updating values ​​at operating points ----------
    s.Beta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Beta_PeakShaving;
    s.CP_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.CP_op2_PS;
    s.CQ_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.CQ_op2_PS;
    s.CT_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.CT_op2_PS;    
    s.Tg_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Tg_op2_PS;  
    s.Pe_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Pe_op2_PS;    
    s.Pa_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Paop2PS;
    s.Ta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Taop2PS;
    s.Fa_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.Faop2PS;

    s.GradCpBeta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradCpBeta_op2PS;
    s.GradCpLambda_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradCpLambda_op2PS;
    s.GradTaLambda_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradTaLambda_op2PS;
    s.GradTaOmega_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradTaOmega_op2PS;
    s.GradTaVop_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradTaVop_op2PS;
    s.GradTaBeta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradTaBeta_op2PS;

    s.GradPaBeta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradPaBeta_op2PS;

    s.GradCtBeta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradCtBeta_op2PS;
    s.GradCtLambda_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradCtLambda_op2PS;
    s.GradFaLambda_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradFaLambda_op2PS;
    s.GradFaOmega_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradFaOmega_op2PS;
    s.GradFaVop_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradFaVop_op2PS;
    s.GradFaBeta_op2(s.IndexopPeakShaving_0:s.IndexopPeakShaving_f) = s.GradFaBeta_op2PS;
    %



    % -------- Analyzing Peak Shaving vs. Standard Strategy -------- 
    s.Fa_op2KN = s.Fa_op2 ./ 1e+6; 
    if s.Option05f8 == 2        
        figure()
        h(1) = plot(s.Vop2, s.Fa_op1KN, 'm', 'LineWidth', 2);
        hold on
        h(2) = plot(s.Vop2, s.Fa_op2KN, 'b', 'LineWidth', 1);
        h(3) = plot(Vline_Regions1Region15, Lineop, 'k:');
        h(4) = plot(Vline_Regions15Region2, Lineop, 'k:');
        h(5) = plot(Vline_Regions2Region25, Lineop, 'k:');
        h(6) = plot(Vline_Regions25Region3, Lineop, 'k:');
        h(7) = plot(Vline_Regions3Region4, Lineop, 'k:');
        h(8) = plot(Vline_Regions4EndOperation, Lineop, 'k:');
        set(h(3:4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(5:6), 'Color', [0.8 0.8 0.8], 'LineWidth', 2);
        set(h(7:8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);         
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([0 max(s.Vop2)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([0.95*min(s.Fa_op1KN) 1.05*max(s.Fa_op1KN)])        
        legend('Aerodynamic Thrust [KN]', 'Aerodynamic Thrust with Peak Shaving Operation [KN]', 'Interpreter', 'latex')
        title('Operation with Peak Shaving Strategy vs. Standard Strategy.')
        hold off
        %
    end


    % Organizing output results  
    WindTurbine_data.Vop2 = s.Vop2; WindTurbine_data.OmegaR_op2 = s.OmegaR_op2; WindTurbine_data.Lambda_op2 = s.Lambda_op2; WindTurbine_data.Beta_op2 = s.Beta_op2; WindTurbine_data.Tg_op2 = s.Tg_op2; WindTurbine_data.Pe_op2 = s.Pe_op2;
    WindTurbine_data.CP_op2 = s.CP_op2; WindTurbine_data.Pa_op2 = s.Pa_op2; WindTurbine_data.CQ_op2 = s.CQ_op2; WindTurbine_data.Ta_op2 = s.Ta_op2; WindTurbine_data.CT_op2 = s.CT_op2; WindTurbine_data.Fa_op2 = s.Fa_op2;
    WindTurbine_data.GradCpBeta_op2 = s.GradCpBeta_op2; WindTurbine_data.GradCpLambda_op2 = s.GradCpLambda_op2; WindTurbine_data.GradTaLambda_op2 = s.GradTaLambda_op2; WindTurbine_data.GradTaOmega_op2 = s.GradTaOmega_op2; WindTurbine_data.GradTaVop_op2 = s.GradTaVop_op2; WindTurbine_data.GradTaBeta_op2 = s.GradTaBeta_op2; WindTurbine_data.GradPaBeta_op2 = s.GradPaBeta_op2;
    WindTurbine_data.GradCtBeta_op2 = s.GradCtBeta_op2; WindTurbine_data.GradCtLambda_op2 = s.GradCtLambda_op2; WindTurbine_data.GradFaLambda_op2 = s.GradFaLambda_op2; WindTurbine_data.GradFaOmega_op2 = s.GradFaOmega_op2; WindTurbine_data.GradFaVop_op2 = s.GradFaVop_op2; WindTurbine_data.GradFaBeta_op2 = s.GradFaBeta_op2;    
    WindTurbine_data.Lambda_op2_opt = s.Lambda_op2_opt; WindTurbine_data.OmegaR_op2_opt = s.OmegaR_op2_opt; WindTurbine_data.Beta_op2_opt = s.Beta_op2_opt; WindTurbine_data.Ta_op2_opt = s.Ta_op2_opt; WindTurbine_data.Pa_op2_opt = s.Pa_op2_opt;
    WindTurbine_data.Vop2_Region1Region15 = s.Vop2_Region1Region15 ; WindTurbine_data.Vop2_Region15Region2 = s.Vop2_Region15Region2 ; WindTurbine_data.Vop2_Region2Region25 = s.Vop2_Region2Region25 ; WindTurbine_data.Vop2_Region25Region3 = s.Vop2_Region25Region3 ; WindTurbine_data.Vop2_Region3Region4 = s.Vop2_Region3Region4 ; WindTurbine_data.Vop2_Region4EndOperation = s.Vop2_Region4EndOperation;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance    
   WindTurbineData_IEA15MW('logical_instance_11');


%=============================================================
elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % STEADY-STATE OPERATION WITH STRATEGY 3 BY JONKMAN (OFFLINE):
    % Purpose of this Logical Instance: to present the Control
    % Strategy in steady-state operation proposed by Jonkman (2009), see 
    % figure 7.2. Jonkman presented strategies for 5 operating 
    % regions: Region 1, Region 1.5, Region 2, Region 2.5, and Region 3. 
        

    % ---------------- REGION 1 (unproductive region) ----------------
    who.Strategy3_Region1 = 'According to page 19, 57 and 58 of Jonkman (2009), Region 1 is a control region before wind speed cut-off, where the generator torque is zero and no energy is extracted from the wind; instead, the wind is used to accelerate the rotor for starting.';  
           % Setup: Use wind to accelerate the drive train.    
    who.Vop3_Region1Region15 = 'Effective Wind Speed ​​at the operating point (STRATEGY 3) where Region 1 ENDS and Region 1.5 START, in [m/s].';
    s.Vop3_Region1Region15 = s.Vws_CutIn;
    who.Vop3_1 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_1 = [0.01 0.1:0.1:s.Vws_CutIn;];
    who.OmegaR_op3_1 = 'Rotor speed ​, in [rad/s]. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_1 =  linspace(0.0024,s.OmegaR_CutIn, length(s.Vop3_1) ); 
    who.Lambda_op3_1 = 'Tip-Speed-Ratio. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_1 = (s.Rrd*s.OmegaR_op3_1) ./ s.Vop3_1; 
    s.Lambda_op3_1(1) = s.Lambda_op3_1(2);
    who.Beta_op3_1 = 'Blade Pitch, in [deg]. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.Beta_op3_1 = s.Beta_opt .* ones(1,length(s.Vop3_1) );    
    who.Tg_op3_1 = 'Generator Torque , in [N.m]. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_1 = 0 .* ones(1,length(s.Vop3_1) );  

           % The Aerodynamic Model at the operating point:
    who.CP_op3_1 = 'Power coefficient. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.CP_op3_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_1, s.Beta_op3_1);
    who.CQ_op3_1 = 'Power coefficient. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_1 = s.CP_op3_1 ./ s.Lambda_op3_1;   
    who.CT_op3_1 = 'Power coefficient. Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_1, s.Beta_op3_1);           

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_1 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_1  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_1, s.Beta_op3_1);
    who.GradCpLambda_op3_1 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_1, s.Beta_op3_1);
    
           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"   
    who.GradCtBeta_op3_1 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_1  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_1, s.Beta_op3_1);
    who.GradCtLambda_op3_1 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 1 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_1, s.Beta_op3_1);           

           % Consolidation of Strategy 3 Data, adding Region 1 data 
    s.Vop3 = s.Vop3_1;
    s.Indexop3_Region1Region15 = length(s.Vop3);
    s.OmegaR_op3 = s.OmegaR_op3_1;
    s.Lambda_op3 = s.Lambda_op3_1;
    s.Beta_op3 = s.Beta_op3_1;
    s.Tg_op3 = s.Tg_op3_1;  
    s.CP_op3 = s.CP_op3_1;
    s.CQ_op3 = s.CQ_op3_1;
    s.CT_op3 = s.CT_op3_1;
    s.GradCpBeta_op3 = s.GradCpBeta_op3_1;
    s.GradCpLambda_op3 = s.GradCpLambda_op3_1;
    s.GradCtBeta_op3 = s.GradCtBeta_op3_1;
    s.GradCtLambda_op3 = s.GradCtLambda_op3_1;


   % ---------- REGION 1.5 (Transition between Region 1 and 2)----------    
    who.Strategy3_Region15 = 'According to page 19 of Jonkman (2009), he defined Region 1.5 to span the range of generator speeds between 670 [rpm] (CUT-IN) and 30% above this value (or 871 rpm).';
           % Setup: Linear transition between Region 1 and 2.       
    who.OmegaRop3_Region15Region2 = 'Transitional Rotor Speed (HSS side), in [rad/s]. According to Jonkman (pg 57, 2009), this is the speed of the generator that delimits where Region 1.5 ENDS and Region 2 START.';
    s.OmegaRop3_Region15Region2 = 1.3*s.OmegaR_CutIn;
    who.Vop3_Region15Region2 = 'Effective Wind Speed ​​at the operating point (STRATEGY 3) where Region 1.5 ENDS and Region 2 START, in [m/s].';
    s.Vop3_Region15Region2 = ((s.Rrd*s.OmegaRop3_Region15Region2)./s.Lambda_opt);
    who.Vop3_15 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_15 = [s.Vws_CutIn:0.1:7.8 s.Vop3_Region15Region2]; % Note: Vop3 = s.Vws_CutIn should be disregarded later

    who.OmegaR_op3_15 = 'Rotor speed, in [rad/s]. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_15 = linspace(s.OmegaR_CutIn, s.OmegaRop3_Region15Region2, length(s.Vop3_15));
    who.Lambda_op3_15 = 'Tip-Speed-Ratio. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_15 = (s.Rrd*s.OmegaR_op3_15) ./ s.Vop3_15;
    who.Beta_op3_15 = 'Blade pitch, in [deg]. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.Beta_op3_15 = s.Beta_opt .* ones(1,length(s.Vop3_15) );   
    who.Slope15_op3 = 'Torque/speed slope of region 1.5 cut-in to Region 2. According to page 58 of Jonkman, the inclination or ramp is the function of the transition speed of Region 1.5.';
    s.Slope15_op3 = ( (s.Kopt*s.OmegaRop3_Region15Region2^2 )/(  s.OmegaRop3_Region15Region2 - s.OmegaR_CutIn ) ) .* ones(1,length(s.Vop3_15) );   
    who.Tg_op3_15 = 'Generator Torque, in [N.m]. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_15 = s.Slope15_op3 .* ( s.OmegaR_op3_15 - s.OmegaR_CutIn );

           % The Aerodynamic Model at the operating point:
    who.CP_op3_15 = 'Power coefficient. Region 1.5 according to Strategy 3 (Jonkman, 2009).';   
    s.CP_op3_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_15, s.Beta_op3_15 );
    who.CQ_op3_15 = 'Power coefficient. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_15 = s.CP_op3_15 ./ s.Lambda_op3_15; 
    who.CT_op3_15 = 'Power coefficient. Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_15, s.Beta_op3_15 );

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_15 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_15, s.Beta_op3_15 );
    who.GradCpLambda_op3_15 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_15 , s.Beta_op3_15 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op3_15 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_15  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_15, s.Beta_op3_15);
    who.GradCtLambda_op3_15 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 1.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_15 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_15, s.Beta_op3_15);

           % Consolidation of Strategy 3 Data, adding Region 1.5 data 
    s.Vop3 = [s.Vop3 s.Vop3_15(2:end)];
    s.Indexop3_Region15Region2 = s.Indexop3_Region1Region15 + length( s.Vop3_15(2:end) );
    s.OmegaR_op3 = [s.OmegaR_op3 s.OmegaR_op3_15(2:end)];
    s.Lambda_op3 = [s.Lambda_op3 s.Lambda_op3_15(2:end)];
    s.Beta_op3 = [s.Beta_op3 s.Beta_op3_15(2:end)];
    s.Tg_op3 = [s.Tg_op3 s.Tg_op3_15(2:end)];  
    s.CP_op3 = [s.CP_op3 s.CP_op3_15(2:end)];
    s.CQ_op3 = [s.CQ_op3 s.CQ_op3_15(2:end)];
    s.CT_op3 = [s.CT_op3  s.CT_op3_15(2:end)];
    s.GradCpBeta_op3 = [s.GradCpBeta_op3 s.GradCpBeta_op3_15(2:end)];
    s.GradCpLambda_op3 = [s.GradCpLambda_op3 s.GradCpLambda_op3_15(2:end)];
    s.GradCtBeta_op3 = [s.GradCtBeta_op3 s.GradCtBeta_op3_15(2:end)];
    s.GradCtLambda_op3 = [s.GradCtLambda_op3 s.GradCtLambda_op3_15(2:end)];


    % ---------- REGION 2.5 (Transition from productive to nominal region)----------            
    who.Strategy3_Region25 = 'According to page 19, 57 and 58 of Jonkman (2009), region 2.5 is a linear transition between Regions 2 and 3 with a torque slope corresponding to the slope of an induction machine. Region 2.5 is typically needed (as is the case for my 5-MW turbine) to limit tip speed (and hence noise emissions) at rated power.';  
           % Setup: Linear transition between Region 2 and 3.     
    who.OmegaRop3_Region25Region3 = 'Rated rotor speed (HSS side - Jonkman), in [rad/s]. According to Jonkman (pg 57, 2009), this is the speed of the generator that delimits where Region 2.5 ENDS and Region 3 START.';
    s.OmegaRop3_Region25Region3 = 0.99*s.OmegaR_Rated;
    who.Vop3_Region25Region3 = 'Effective Wind Speed ​​at the operating point (STRATEGY 3) where Region 2.5 ENDS and Region 3 START, in [m/s].';
    s.Vop3_Region25Region3 = s.Vws_Rated;

    who.Slope25_op3 = 'Torque/speed slope of region 2.5 cut-in to Region 3. According to page 58 of Jonkman, the inclination or ramp is the function of the simple induction in Region 2.5.';
    s.Slope25_op3 = ( s.Pmec_max ./ s.OmegaRop3_Region25Region3 ) ./ ( s.OmegaRop3_Region25Region3 - s.OmegaR_Synchronous );
    who.OmegaRop3_Region2Region25 = 'Transitional Rotor Speed (HSS side), in [rad/s]. According to Jonkman (pg 57, 2009), this is the speed of the generator that delimits where Region 2 ENDS and Region 2.5 START.';
    s.OmegaRop3_Region2Region25 = ( s.Slope25_op3 - sqrt( s.Slope25_op3 .* ( s.Slope25_op3 - 4.0 .* s.Kopt .* s.OmegaR_Synchronous ) ) ) ./( 2.0 .* s.Kopt );
    who.Vop3_Region2Region25 = 'Effective Wind Speed ​​at the operating point (STRATEGY 3) where Region 2 ENDS and Region 2.5 START, in [m/s].';
    s.Vop3_Region2Region25 = ((s.Rrd*s.OmegaRop3_Region2Region25)./s.Lambda_opt);

    who.Vop3_25 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_25 = [s.Vop3_Region2Region25 10.4:0.1:11.3 s.Vop3_Region25Region3]; % Note: then the point "Vop3 = Vop3_Region2Region25" should be considered and "Vop3 = Vop3_Region25Region3" disregarded.     
    who.OmegaR_op3_25 = 'Rotor speed, in [rad/s]. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_25 = linspace(s.OmegaRop3_Region2Region25,s.OmegaR_Rated , length(s.Vop3_25) ); % s.OmegaR_op3_25 = linspace(s.OmegaRop3_Region2Region25,s.OmegaRop3_Region25Region3 , length(s.Vop3_25) );
    who.Lambda_op3_25 = 'Tip-Speed-Ratio​. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_25 = (s.Rrd*s.OmegaR_op3_25) ./ s.Vop3_25;
    who.Beta_op3_25 = 'Blade pitch, in [deg]. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.Beta_op3_25 = s.Beta_opt .* ones(1,length(s.Vop3_25) );   
    who.Tg_op3_25 = 'Generator Torque​​, in [N.m]. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_25 = s.Slope25_op3 .* (  s.OmegaR_op3_25 - s.OmegaR_Synchronous );

           % The Aerodynamic Model at the operating point:
    who.CP_op3_25 = 'Power coefficient. Region 2.5 according to Strategy 3 (Jonkman, 2009).';   
    s.CP_op3_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_25, s.Beta_op3_25 );
    who.CQ_op3_25 = 'Power coefficient. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_25 = s.CP_op3_25 ./ s.Lambda_op3_25; 
    who.CT_op3_25 = 'Power coefficient. Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_25, s.Beta_op3_25 );

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_25 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_25, s.Beta_op3_25 );
    who.GradCpLambda_op3_25 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_25 , s.Beta_op3_25 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op3_25 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_25  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_25, s.Beta_op3_25);
    who.GradCtLambda_op3_25 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 2.5 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_25 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_25, s.Beta_op3_25);


    % ---------- REGION 2 (Energy Capture Optimization)----------      
    who.Strategy3_Region2 = 'According to page 19, 57 and 58 of Jonkman (2009), region 2 is a control region to optimize energy capture, where the torque of the generator is proportional to Kopt*OmegaG^2 to maintain a constant (optimal) speed rate.';
           % Setup: Optimize energy production.        
    who.Vop3_2 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_2 = [s.Vop3_Region15Region2 8:0.1:10.2 s.Vop3_Region2Region25]; % Note: then you should disregard the points "Vop3 = Vop3_Region15Region2" and disregard "Vop3 = Vop3_Region2Region25".
    who.Lambda_op3_2 = 'Tip-Speed-Ratio​​. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_2 = s.Lambda_opt .* ones(1, length(s.Vop3_2) );
    who.OmegaR_op3_2 = 'Rotor speed, in [rad/s]. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_2 = ((s.Lambda_op3_2 .* s.Vop3_2 ) ./ s.Rrd);
    who.Beta_op3_2 = 'Blade pitch, in [deg]. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.Beta_op3_2 = s.Beta_opt .* ones(1,length(s.Vop3_2) ); 
    who.Tg_op3_2 = 'Generator Torque, in [N.m]. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_2 = s.Kopt .* (s.OmegaR_op3_2 .^2 );

           % The Aerodynamic Model at the operating point:
    who.CP_op3_2 = 'Power coefficient. Region 2 according to Strategy 3 (Jonkman, 2009).';   
    s.CP_op3_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_2, s.Beta_op3_2 );
    who.CQ_op3_2 = 'Power coefficient. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_2 = s.CP_op3_2 ./ s.Lambda_op3_2; 
    who.CT_op3_2 = 'Power coefficient. Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_2, s.Beta_op3_2 );

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_2 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_2, s.Beta_op3_2 );
    who.GradCpLambda_op3_2 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_2 , s.Beta_op3_2 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op3_2 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_2  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_2, s.Beta_op3_2);
    who.GradCtLambda_op3_2 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 2 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_2, s.Beta_op3_2);

           % Consolidation of Strategy 3 Data, adding Regions 2 and 2.5 data 
    s.Vop3 = [s.Vop3 s.Vop3_2(2:end-1) s.Vop3_25(1:end-1)];
    s.Indexop3_Region2Region25 = s.Indexop3_Region15Region2 + length( s.Vop3_2(2:end-1) ) + 1;
    s.Indexop3_Region25Region3 = s.Indexop3_Region2Region25 + length( s.Vop3_25(1:end-1) );
    s.OmegaR_op3 = [s.OmegaR_op3 s.OmegaR_op3_2(2:end-1) s.OmegaR_op3_25(1:end-1)];
    s.Lambda_op3 = [s.Lambda_op3 s.Lambda_op3_2(2:end-1) s.Lambda_op3_25(1:end-1)];
    s.Beta_op3 = [s.Beta_op3 s.Beta_op3_2(2:end-1) s.Beta_op3_25(1:end-1)];
    s.Tg_op3 = [s.Tg_op3 s.Tg_op3_2(2:end-1) s.Tg_op3_25(1:end-1)];  
    s.CP_op3 = [s.CP_op3 s.CP_op3_2(2:end-1) s.CP_op3_25(1:end-1)];
    s.CQ_op3 = [s.CQ_op3 s.CQ_op3_2(2:end-1) s.CQ_op3_25(1:end-1)];
    s.CT_op3 = [s.CT_op3  s.CT_op3_2(2:end-1) s.CT_op3_25(1:end-1)];
    s.GradCpBeta_op3 = [s.GradCpBeta_op3 s.GradCpBeta_op3_2(2:end-1) s.GradCpBeta_op3_25(1:end-1)];
    s.GradCpLambda_op3 = [s.GradCpLambda_op3 s.GradCpLambda_op3_2(2:end-1) s.GradCpLambda_op3_25(1:end-1)];
    s.GradCtBeta_op3 = [s.GradCtBeta_op3 s.GradCtBeta_op3_2(2:end-1) s.GradCtBeta_op3_25(1:end-1)];
    s.GradCtLambda_op3 = [s.GradCtLambda_op3 s.GradCtLambda_op3_2(2:end-1) s.GradCtLambda_op3_25(1:end-1)];
    

    % ---------- REGION 3 (Nominal point operation)----------          
    who.Strategy3_Region3 = 'According to page 19, 57 and 58 of Jonkman (2009), in the region 3 the generator power is held constant so that the generator torque is inversely proportional to the filtered generator speed.';
           % Setup: Reduce loads and maintain operation at rated values.  
    who.Vop3_Region3Region4 = 'Effective Wind Speed ​​at the operating point (Strategy 3) where Region 3 ENDS and Region 4 START, in [m/s].';
    s.Vop3_Region3Region4 = s.Vws_CutOut;
    who.Vop3_3 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_3 = [s.Vws_Rated 11.5:0.1:24.9 s.Vws_CutOut];
    who.OmegaR_op3_3 = 'Rotor speed, in [rad/s]. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_3  = s.OmegaR_Rated .* ones(1, length(s.Vop3_3) );
    who.Lambda_op3_3 = 'Tip-Speed-Ratio. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_3 = (s.Rrd*s.OmegaR_op3_3 ) ./ s.Vop3_3;   
    who.Tg_op3_3 = 'Generator Torque, in [N.m]. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_3 = (s.Pmec_max / s.OmegaR_Rated ) .* ones(1, length(s.Vop3_3) );
    
    who.Beta_op3_3 = 'Blade pitch, in [deg]. Region 3 according to Strategy 3 (Jonkman, 2009).';  
    TorqueMec = s.Tg_op3_3 + ( s.CCdt .* s.OmegaR_op3_3 ) ;
    Cpws_fun = @(Beta_MAP)  min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_3, Beta_MAP), 0), s.CP_max);  
    Fun = @(Beta_MAP) (TorqueMec - ( 0.5 .* s.rho .* pi .* s.Rrd.^2 .*  Cpws_fun(Beta_MAP) .* (1 ./ s.OmegaR_op3_3) .* s.Vop3_3.^3) );
    optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);    
    beta_op0 = interp1(s.Vop_Region3_0, s.Beta_Region3, s.Vop3_3, 'linear');
    Beta_MAP = fsolve(Fun, beta_op0, optionsFsolve); 
    s.Beta_op3_3 = min( max( Beta_MAP, s.Beta_opt ) , s.Beta_max) ; 
    % plot( s.Vop3_Region3 , s.Beta_op3_3)


           % The Aerodynamic Model at the operating point:
    who.CP_op3_3 = 'Power coefficient. Region 3 according to Strategy 3 (Jonkman, 2009).';   
    s.CP_op3_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_3, s.Beta_op3_3 );
    who.CQ_op3_3 = 'Power coefficient. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_3 = s.CP_op3_3 ./ s.Lambda_op3_3; 
    who.CT_op3_3 = 'Power coefficient. Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_3, s.Beta_op3_3 );
    s.CT_op3_3(1:2) = s.CT_op3_25(end) - abs(s.CT_op3_25(end) - s.CT_op3_25(end-2)) ; 


           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_3 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_3, s.Beta_op3_3 );
    who.GradCpLambda_op3_3 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_3, s.Beta_op3_3 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op3_3 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_3  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_3, s.Beta_op3_3);
    who.GradCtLambda_op3_3 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 3 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_3, s.Beta_op3_3);

           % Consolidation of Strategy 3 Data, adding Region 3 data 
    s.Vop3 = [s.Vop3 s.Vop3_3];
    s.Indexop3_Region3Region4 = s.Indexop3_Region25Region3 - 1 + length( s.Vop3_3 );
    s.OmegaR_op3 = [s.OmegaR_op3 s.OmegaR_op3_3];
    s.Lambda_op3 = [s.Lambda_op3 s.Lambda_op3_3];
    s.Beta_op3 = [s.Beta_op3 s.Beta_op3_3];
    s.Tg_op3 = [s.Tg_op3 s.Tg_op3_3];  
    s.CP_op3 = [s.CP_op3 s.CP_op3_3];
    s.CQ_op3 = [s.CQ_op3 s.CQ_op3_3];
    s.CT_op3 = [s.CT_op3  s.CT_op3_3];
    s.GradCpBeta_op3 = [s.GradCpBeta_op3 s.GradCpBeta_op3_3];
    s.GradCpLambda_op3 = [s.GradCpLambda_op3 s.GradCpLambda_op3_3];
    s.GradCtBeta_op3 = [s.GradCtBeta_op3 s.GradCtBeta_op3_3];
    s.GradCtLambda_op3 = [s.GradCtLambda_op3 s.GradCtLambda_op3_3];


    % ---------- REGION 4 (unproductive region)----------
    who.Strategy3_Region4 = 'No instructions were found on Region 4, therefore, a Cut-Out reduction to zero was adopted, in a range of 25 to 30 [m/s].';
           % Setup: Shut down or linearly reduce operation (normal operating conditions).      
    who.Vop3_Region3Region4 = 'Effective operating speed at the operating point in Region 4, in [m/s]. This is the operating point where the wind turbine is turned off (maximum point for simulation of this code).';
    s.Vop3_Region4EndOperation  = s.Vop(end);
    who.Vop3_4 = 'Effective Wind Speed ​​in Steady-State Operation, in [m/s]. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.Vop3_4 = [s.Vws_CutOut 25.1:0.1:31.4 s.Vop3_Region4EndOperation]; % Note: then the point "Vop3 = s.Vws_CutOut" disregarded.
    who.OmegaR_op3_4 = 'Rotor speed, in [rad/s]. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.OmegaR_op3_4 = interp1(s.Vop_op4, s.OmegaR_op4, s.Vop3_4 , 'linear');     
    who.Lambda_op3_4 = 'Tip-Speed-Ratio. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.Lambda_op3_4 = (s.Rrd .* s.OmegaR_op3_4) ./ s.Vop3_4 ;    
    deltaOmegaTg = abs( s.OmegaR_op3 - s.OmegaR_op3_4(end) );
    Tg_op4 = s.Tg_op3( find( deltaOmegaTg == min(deltaOmegaTg)) );
    who.Tg_op3_3 = 'Generator Torque, in [N.m]. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.Tg_op3_4 = linspace( s.Tg_op3_3(end) , Tg_op4 , length(s.Vop3_4) );

    who.Beta_op3_4 = 'Blade pitch, in [deg]. Region 4 according to Strategy 3 (Jonkman, 2009).';         
    Tmec_op4 = s.Tg_op3_4  + ( s.CCdt .* s.OmegaR_op3_4 ) ; % Ta == Tg - Tperda = 0.5*s.rho*pi*s.Rrd^2*s.Cp*(1/s.OmegaR)*s.Vews_rel^3;  
    s.Beta_op3_4 = max(s.Beta_op3);
    s.Beta04_min = min( max( ( s.Beta_op3_4 - 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);   
    s.Beta04_max = min( max( ( s.Beta_op3_4 + 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);
    beta_op04 = s.Beta_op3_4;
    for iit = 1:length(s.Vop3_4)
        Cpws_fun = @(Beta_MAP)  min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_4(iit) , Beta_MAP), 0), s.CP_max);  
        Fun = @(Beta_MAP) ( Tmec_op4(iit) - (0.5 .* s.rho .* pi .* s.Rrd.^2 .* Cpws_fun(Beta_MAP) .*( 1 ./ s.OmegaR_op3_4(iit) ) .* s.Vop3_4(iit)  .^3) );
        optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);   
        Beta_MAP = fsolve(Fun, beta_op04(iit), optionsFsolve); 
        s.Beta_op3_4(iit+1) = min( max( Beta_MAP, s.Beta04_min(iit) ) , s.Beta04_max(iit) );

        s.Beta04_min(iit+1) = min( max( ( s.Beta_op3_4(iit+1) - 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);   
        s.Beta04_max(iit+1) = min( max( ( s.Beta_op3_4(iit+1) + 0.8750*s.BetaDot_max), s.Beta_min) , s.Beta_max);
        beta_op04(iit+1) = s.Beta_op3_4(iit+1) ;
    end
    s.Beta_op3_4 = s.Beta_op3_4(2:end); % Update.


    if s.Option01f5 == 1 || s.Option01f5 == 2        
        Cpws_op4 = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_4 , s.Beta_op3_4), 0), s.CP_max);  
        Fun_op4 = ( Tmec_op4 - (0.5 .* s.rho .* pi .* s.Rrd.^2 .* Cpws_op4  .*( 1 ./ s.OmegaR_op3_4 ) .* s.Vop3_4 .^3) );
        % Accepted tolerance ± 0.5% of maximum torque
        who.TolerVal_Region4 = 'Tolerance accepted for validation of results in Region 4. Adopted value of ± 0.5% of maximum torque..';
        s.TolerVal_Region4 = 0.005*s.Tg_rated;        
        s.indexVal_Region4 = find( abs(Fun_op4) <= s.TolerVal_Region4 );

        s.Vop3_4Edited = s.Vop3_4(s.indexVal_Region4);
        s.Vop3_4 = s.Vop3_4Edited;
        s.OmegaR_op3_4Edited = s.OmegaR_op3_4(s.indexVal_Region4);
        s.OmegaR_op3_4 = s.OmegaR_op3_4Edited;
        s.Lambda_op3_4Edited = s.Lambda_op3_4(s.indexVal_Region4);
        s.Lambda_op3_4 = s.Lambda_op3_4Edited;
        s.Tg_op3_4Edited = s.Tg_op3_4(s.indexVal_Region4);
        s.Tg_op3_4 = s.Tg_op3_4Edited;
        s.Beta_op3_4Edited = s.Beta_op3_4(s.indexVal_Region4);
        s.Beta_op3_4 = s.Beta_op3_4Edited;
    end

           % The Aerodynamic Model at the operating point:
    who.CP_op3_4 = 'Power coefficient. Region 4 according to Strategy 3 (Jonkman, 2009).';   
    s.CP_op3_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_op3_4, s.Beta_op3_4 );
    who.CQ_op3_4 = 'Power coefficient. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.CQ_op3_4 = s.CP_op3_4 ./ s.Lambda_op3_4; 
    who.CT_op3_4 = 'Power coefficient. Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.CT_op3_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_op3_4, s.Beta_op3_4 );

           % Calculating Partial Derivatives of "CP" with respect to "Beta_Tab" and "Lambda_Tab"
    who.GradCpBeta_op3_4 = 'Partial derivative of the "CP", in relation to the "Beta_Tab". Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpBeta_op3_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpBeta', s.Lambda_op3_4, s.Beta_op3_4 );
    who.GradCpLambda_op3_4 = 'Partial derivative of the "CP", in relation to the "Lambda_Tab". Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.GradCpLambda_op3_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CpLambda', s.Lambda_op3_4, s.Beta_op3_4 );   

           % Calculating Partial Derivatives of "CT" with respect to "Beta_Tab" and "Lambda_Tab"    
    who.GradCtBeta_op3_4 = 'Partial derivative of the "CT", in relation to the "Beta_Tab". Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtBeta_op3_4  = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtBeta', s.Lambda_op3_4, s.Beta_op3_4);
    who.GradCtLambda_op3_4 = 'Partial derivative of the "CT", in relation to the "Lambda_Tab". Region 4 according to Strategy 3 (Jonkman, 2009).';
    s.GradCtLambda_op3_4 = interp2(s.Lambda_Tab, s.Beta_Tab, s.Grad_CtLambda', s.Lambda_op3_4, s.Beta_op3_4);

           % Consolidation of Strategy 3 Data, adding Region 4 data 
    s.Vop3 = [s.Vop3 s.Vop3_4(2:end)];
    s.Indexop3_Regions4EndOperation = length( s.Vop3 );
    s.Vop3_Region4EndOperation  = s.Vop3(end);
    s.OmegaR_op3 = [s.OmegaR_op3 s.OmegaR_op3_4(2:end)];
    s.Lambda_op3 = [s.Lambda_op3 s.Lambda_op3_4(2:end)];
    s.Beta_op3 = [s.Beta_op3 s.Beta_op3_4(2:end)];
    s.Tg_op3 = [s.Tg_op3 s.Tg_op3_4(2:end)];  
    s.CP_op3 = [s.CP_op3 s.CP_op3_4(2:end)];
    s.CQ_op3 = [s.CQ_op3 s.CQ_op3_4(2:end)];
    s.CT_op3 = [s.CT_op3  s.CT_op3_4(2:end)];
    s.GradCpBeta_op3 = [s.GradCpBeta_op3 s.GradCpBeta_op3_4(2:end)];
    s.GradCpLambda_op3 = [s.GradCpLambda_op3 s.GradCpLambda_op3_4(2:end)];
    s.GradCtBeta_op3 = [s.GradCtBeta_op3 s.GradCtBeta_op3_4(2:end)];
    s.GradCtLambda_op3 = [s.GradCtLambda_op3 s.GradCtLambda_op3_4(2:end)];
    s.Indexop3_Region1Region15 = find( s.Vop3 == s.Vop3_Region1Region15 ) ;
    s.Indexop3_Region15Region2 = find( s.Vop3 == s.Vop3_Region15Region2 ) ;
    s.Indexop3_Region2Region25 = find( s.Vop3 == s.Vop3_Region2Region25 ) ;
    s.Indexop3_Region25Region3 = find( s.Vop3 == s.Vop3_Region25Region3 ) ;
    s.Indexop3_Region3Region4 = find( s.Vop3 == s.Vop3_Region3Region4 ) ;
    s.Indexop3_Regions4EndOperation = find( s.Vop3 == s.Vop3_Region4EndOperation ) ; 


      %######## CONSOLIDATION OF OTHER DATA FROM Strategy 3 ########
    

    % -------- Aerodynamic Model Values ​​in Steady-State -------   
    who.Pa_op3 = 'Aerodynamic power in Steady-State according to Strategy 3 (Jonkman, 2009), and in [W]';
    s.Pa_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_op3 .* s.Vop3.^3;
    who.Ta_op3 = 'Aerodynamic torque in Steady-State according to Strategy 3 (Jonkman, 2009), and in [N.m]';
    s.Ta_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_op3 .* (1 ./ s.OmegaR_op3) .* s.Vop3.^3; 
    who.Fa_op3 = 'Aerodynamic thrust in Steady-State according to Strategy 3 (Jonkman, 2009), and in [N]';
    s.Fa_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CT_op3 .* s.Vop3.^2;

    who.Pe_op3 = 'Generator power in Steady-State according to Strategy 3 (Jonkman, 2009), and in [W]';
    s.Pe_op3 = ( s.Tg_op3 .* s.OmegaR_op3 ) .* s.etaElec_op;  


    % -------- Partial Derivatives of Aerodynamic Torque -------
    who.GradTaLambda_op3 = 'Partial derivative of the Aerodynamic Torque, in relation to the TSR and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradTaLambda_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop3.^2 .* (1 ./ s.Lambda_op3.^2) .* ( ( s.Lambda_op3 .* s.GradCpLambda_op3 ) - s.CP_op3 );
    who.GradTaOmega_op3 = 'Partial derivative of the Aerodynamic Torque, in relation to the rotor speed and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradTaOmega_op3 = s.GradTaLambda_op3 .* ( s.Rrd ./ s.Vop3 ) ;
    who.GradTaVop_op3 = 'Partial derivative of the Aerodynamic Torque, in relation to the wind speed and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradTaVop_op3 = (- s.GradTaLambda_op3) .* ( ( s.Rrd .* s.OmegaR_op3 ) ./ s.Vop3.^2 ) ;       
    who.GradTaBeta_op3 = 'Partial derivative of the Aerodynamic Torque, in relation to the blade pitch and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradTaBeta_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^3 .* s.Vop3.^2 .* ( 1 ./ s.Lambda_op3.^2) .* ( s.Lambda_op3 .* s.GradCpBeta_op3 );
    s.GradTaBeta_op3( s.GradTaBeta_op3 == 0) = 0.0001;

    who.GradPaBeta_op3 = 'Partial derivative of the Aerodynamic Power, in relation to the blade pitch and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradPaBeta_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop3.^3 .* s.GradCpBeta_op3 ;    
    s.GradPaBeta_op3( s.GradPaBeta_op3 == 0) = 0.001;
          
    who.GradFaLambda_op3 = 'Partial derivative of the Aerodynamic Thrust, in relation to the TSR and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradFaLambda_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop3.^2 .* s.GradCtLambda_op3;
    who.GradFaOmega_op3 = 'Partial derivative of the Aerodynamic Thrust, in relation to the rotor speed and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradFaOmega_op3 = s.GradFaLambda_op3 .* ( s.Rrd ./ s.Vop3 ) ;
    who.GradFaVop_op3 = 'Partial derivative of the Aerodynamic Thrust, in relation to the wind speed and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradFaVop_op3 = (- s.GradFaLambda_op3) .* ( ( s.Rrd .* s.OmegaR_op3 ) ./ s.Vop3.^2 ) ;     
    who.GradFaBeta_op3 = 'Partial derivative of the Aerodynamic Thrust, in relation to the blade pitch and in Steady-State according to Strategy 3 (Jonkman, 2009).';
    s.GradFaBeta_op3 = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.Vop3.^2 .* s.GradCtBeta_op3 ;


    % ---------------- Optimal Wind Turbine Operation ----------------
    who.Strategy1_OptimalOperation = 'Strategy 3 to optimize wind turbine operation is based on the Optimal Torque Control (OTC or OT) algorithm, which uses the squared relationship with rotor speed (Tg = Kopt*OmegaR^2).';
    who.Vop3_opt = 'Effective Wind Speed ​​in Optimal Operation, in [m/s]. Using OTC algorithm.';
    s.Vop3_opt = s.Vop3; 
    who.Lambda_op3_opt = 'Optimal Tip-Speed-Ratio​​.';
    s.Lambda_op3_opt = s.Lambda_opt .* ones(1, length(s.Vop3_opt) );
    who.OmegaR_op3_opt = 'Optimal Rotor speed, in [rad/s].';
    s.OmegaR_op3_opt = ((s.Lambda_op3_opt .* s.Vop3_opt ) ./ s.Rrd); % min(max(  s.OmegaR_op3_opt, s.OmegaR_CutIn ),  s.OmegaR_Rated );
    who.Beta_op3_opt = 'Optimal Blade pitch, in [deg].';
    s.Beta_op3_opt = s.Beta_opt .* ones(1,length(s.Vop3_opt) );    
    who.Ta_op3_opt = 'Optimal Aerodynamic torque, in [N.m]';
    s.Ta_op3_opt = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_max .* (1 ./ s.OmegaR_op3_opt) .* s.Vop3_opt.^3; 
    who.Pa_op3_opt = 'Optimal Aerodynamic power, in [W]';
    s.Pa_op3_opt = 0.5 .* s.rho .* pi .* s.Rrd.^2 .* s.CP_max .* s.Vop3_opt.^3;

    
    % Organizing output results  
    WindTurbine_data.Vop3 = s.Vop3; WindTurbine_data.OmegaR_op3 = s.OmegaR_op3; WindTurbine_data.Lambda_op3 = s.Lambda_op3; WindTurbine_data.Beta_op3 = s.Beta_op3; WindTurbine_data.Tg_op3 = s.Tg_op3; WindTurbine_data.Pe_op3 = s.Pe_op3;
    WindTurbine_data.CP_op3 = s.CP_op3; WindTurbine_data.Pa_op3 = s.Pa_op3; WindTurbine_data.CQ_op3 = s.CQ_op3; WindTurbine_data.Ta_op3 = s.Ta_op3; WindTurbine_data.CT_op3 = s.CT_op3; WindTurbine_data.Fa_op3 = s.Fa_op3;
    WindTurbine_data.GradCpBeta_op3 = s.GradCpBeta_op3; WindTurbine_data.GradCpLambda_op3 = s.GradCpLambda_op3; WindTurbine_data.GradTaLambda_op3 = s.GradTaLambda_op3; WindTurbine_data.GradTaOmega_op3 = s.GradTaOmega_op3; WindTurbine_data.GradTaVop_op3 = s.GradTaVop_op3; WindTurbine_data.GradTaBeta_op3 = s.GradTaBeta_op3; WindTurbine_data.GradPaBeta_op3 = s.GradPaBeta_op3;
    WindTurbine_data.GradCtBeta_op3 = s.GradCtBeta_op3; WindTurbine_data.GradCtLambda_op3 = s.GradCtLambda_op3; WindTurbine_data.GradFaLambda_op3 = s.GradFaLambda_op3; WindTurbine_data.GradFaOmega_op3 = s.GradFaOmega_op3; WindTurbine_data.GradFaVop_op3 = s.GradFaVop_op3; WindTurbine_data.GradFaBeta_op3 = s.GradFaBeta_op3;    
    WindTurbine_data.Lambda_op3_opt = s.Lambda_op3_opt; WindTurbine_data.OmegaR_op3_opt = s.OmegaR_op3_opt; WindTurbine_data.Beta_op3_opt = s.Beta_op3_opt; WindTurbine_data.Ta_op3_opt = s.Ta_op3_opt; WindTurbine_data.Pa_op3_opt = s.Pa_op3_opt;
    WindTurbine_data.Vop3_Region1Region15 = s.Vop3_Region1Region15 ; WindTurbine_data.Vop3_Region15Region2 = s.Vop3_Region15Region2 ; WindTurbine_data.Vop3_Region2Region25 = s.Vop3_Region2Region25 ; WindTurbine_data.Vop3_Region25Region3 = s.Vop3_Region25Region3 ; WindTurbine_data.Vop3_Region3Region4 = s.Vop3_Region3Region4 ; WindTurbine_data.Vop3_Region4EndOperation = s.Vop3_Region4EndOperation;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance    
   WindTurbineData_IEA15MW('logical_instance_12');


%=============================================================
elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
    % SELECTION OF OPERATIONAL CONTROL STRATEGY (OFFLINE):
    % Purpose of this Logical Instance: to select the Control or Operation
    % Strategy that the wind turbine should follow in permanent operation. 
    % The selection is made according to the choice in the "s.Option01f8" 
    % option, made in the controllers' logical instance..


    % ---------- Control Strategy Selection ----------
    if s.Option01f8 == 1
        who.ControlStrategy = 'The Control Strategy adopted was STRATEGY 1 (Figure 2 from Abbas, 2022).';
        s.Vop = s.Vop1;
        s.OmegaR_op = s.OmegaR_op1;
        s.Lambda_op = s.Lambda_op1;
        s.Beta_op = s.Beta_op1;
        s.Tg_op = s.Tg_op1;  
        s.CP_op = s.CP_op1;
        s.CQ_op = s.CQ_op1;
        s.CT_op = s.CT_op1;
        s.GradCpBeta_op = s.GradCpBeta_op1;
        s.GradCpLambda_op = s.GradCpLambda_op1;
        s.GradCtBeta_op = s.GradCtBeta_op1;
        s.GradCtLambda_op = s.GradCtLambda_op1;
        s.Pa_op = s.Pa_op1;
        s.Ta_op = s.Ta_op1;
        s.Fa_op = s.Fa_op1;
        s.Pe_op = s.Pe_op1;
        s.GradTaLambda_op = s.GradTaLambda_op1;
        s.GradTaOmega_op = s.GradTaOmega_op1;
        s.GradTaVop_op = s.GradTaVop_op1;
        s.GradTaBeta_op = s.GradTaBeta_op1;
        s.GradPaBeta_op = s.GradPaBeta_op1;
        s.GradFaLambda_op = s.GradFaLambda_op1;
        s.GradFaOmega_op = s.GradFaOmega_op1;
        s.GradFaVop_op = s.GradFaVop_op1;
        s.GradFaBeta_op = s.GradFaBeta_op1;
        s.Lambda_op_opt = s.Lambda_op1_opt;
        s.OmegaR_op_opt = s.OmegaR_op1_opt;
        s.Beta_op_opt = s.Beta_op1_opt;
        s.Ta_op_opt = s.Ta_op1_opt;
        s.Pa_op_opt = s.Pa_op1_opt;
        s.Vop_Region1Region15 = s.Vop1_Region1Region15 ;
        s.Vop_Region15Region2 = s.Vop1_Region15Region2 ;
        s.Vop_Region2Region25 = s.Vop1_Region2Region25 ;    
        s.Vop_Region25Region3 = s.Vop1_Region25Region3 ;
        s.Vop_Region3Region4 = s.Vop1_Region3Region4 ;
        s.Vop_Region4EndOperation = s.Vop1_Region4EndOperation;
        s.Indexop_Region1Region15 = s.Indexop1_Region1Region15;
        s.Indexop_Region15Region2 = s.Indexop1_Region15Region2;
        s.Indexop_Region2Region25 = s.Indexop1_Region2Region25;
        s.Indexop_Region25Region3 = s.Indexop1_Region25Region3;
        s.Indexop_BetaVar = s.Indexop_Region25Region3 ;
        s.Indexop_Region3Region4 = s.Indexop1_Region3Region4;
        s.Indexop_Regions4EndOperation = s.Indexop1_Regions4EndOperation; 
        s.OmegaRop_Region25Region3 = s.OmegaRop1_Region25Region3;
        s.Tg_dMax = (s.Pmec_max / s.OmegaR_Rated ) ;         
        s.Vop_BetaVar = s.Vws_Rated ; 
        s.delta_Rated = abs( s.Vop - s.Vop_BetaVar ) ;
        s.Indexop_Rated = find( s.delta_Rated == min(s.delta_Rated) ) ;    
        s.BetaMaxRegion3 = max( s.Beta_op(s.Indexop_Region25Region3:end) ) ; 
        s.BetaMinRegion3 = min( s.Beta_op(s.Indexop_Region25Region3:end) ) ;
        s.BetaMode_Enable = s.BetaMinRegion3 + 0.1 ; % The actual blade pitch position must be at most within this value to activate the controller.
        s.Vop_BetaMode_Enable = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMode_Enable);                 
        s.delta_BetaMode_Enable = abs( s.Vop - s.Vop_BetaMode_Enable ) ;
        s.Indexop_BetaMode_Enable = find( s.delta_BetaMode_Enable == min(s.delta_BetaMode_Enable) ) ;  
        s.BetaMax_nominal = s.Beta_op(s.Indexop_BetaMode_Enable+1) ; % Between the points "Vws_Rated" and "Vws_Rated_end" it is not possible to guarantee a "dBeta" or "du" that guarantees precision. Therefore, for this range, "du = 0" is adopted or at least the integrative term is saturated.
        s.Vop_TgMode_Saturation = s.Vws_Rated ; % It is the speed at which the generator torque can be saturated without affecting the transition between the controllers. 
        s.Vws_Rated_end = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMax_nominal); % Or set (Vws_Rated + 0.2). NOTE: From the nominal speed (Vws_Rated) to this point, it is not possible to guarantee a dBeta or du that guarantees accuracy. Therefore, from Vrated to this point (Vws_Rated_end), "du = dBeta = 0" is adopted, thus: Beta_d = Beta_op + 0".
        s.Vop_RegionTrasition = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaDot_max);                
        s.delta_RegionTrasition = abs( s.Vop - s.Vop_RegionTrasition ) ;
        s.Indexop_RegionTrasition = find( s.delta_RegionTrasition == min(s.delta_RegionTrasition) ) ;
        %        
    elseif s.Option01f8 == 2
        who.ControlStrategy = 'The Control Strategy adopted was STRATEGY 2 (Peak Shaving).';
        s.Vop = s.Vop2;
        s.OmegaR_op = s.OmegaR_op2;
        s.Lambda_op = s.Lambda_op2;
        s.Beta_op = s.Beta_op2;
        s.Tg_op = s.Tg_op2;  
        s.CP_op = s.CP_op2;
        s.CQ_op = s.CQ_op2;
        s.CT_op = s.CT_op2;
        s.GradCpBeta_op = s.GradCpBeta_op2;
        s.GradCpLambda_op = s.GradCpLambda_op2;
        s.GradCtBeta_op = s.GradCtBeta_op2;
        s.GradCtLambda_op = s.GradCtLambda_op2;
        s.Pa_op = s.Pa_op2;
        s.Ta_op = s.Ta_op2;
        s.Fa_op = s.Fa_op2;
        s.Pe_op = s.Pe_op2;
        s.GradTaLambda_op = s.GradTaLambda_op2;
        s.GradTaOmega_op = s.GradTaOmega_op2;
        s.GradTaVop_op = s.GradTaVop_op2;
        s.GradTaBeta_op = s.GradTaBeta_op2;
        s.GradPaBeta_op = s.GradPaBeta_op2;
        s.GradFaLambda_op = s.GradFaLambda_op2;
        s.GradFaOmega_op = s.GradFaOmega_op2;
        s.GradFaVop_op = s.GradFaVop_op2;
        s.GradFaBeta_op = s.GradFaBeta_op2;
        s.Lambda_op_opt = s.Lambda_op2_opt;
        s.OmegaR_op_opt = s.OmegaR_op2_opt;
        s.Beta_op_opt = s.Beta_op2_opt;
        s.Ta_op_opt = s.Ta_op2_opt;
        s.Pa_op_opt = s.Pa_op2_opt;
        s.Vop_Region1Region15 = s.Vop2_Region1Region15 ;
        s.Vop_Region15Region2 = s.Vop2_Region15Region2 ;
        s.Vop_Region2Region25 = s.Vop2_Region2Region25 ;    
        s.Vop_Region25Region3 = s.Vop2_Region25Region3 ;
        s.Vop_Region3Region4 = s.Vop2_Region3Region4 ;
        s.Vop_Region4EndOperation = s.Vop2_Region4EndOperation;
        s.Indexop_Region1Region15 = s.Indexop2_Region1Region15;
        s.Indexop_Region15Region2 = s.Indexop2_Region15Region2;
        s.Indexop_Region2Region25 = s.Indexop2_Region2Region25;
        s.Indexop_Region25Region3 = s.Indexop2_Region25Region3;
        s.Indexop_BetaVar = s.IndexopPeakShaving_0 ; % Starting varying Beta
        s.Indexop_Region3Region4 = s.Indexop2_Region3Region4;
        s.Indexop_Regions4EndOperation = s.Indexop2_Regions4EndOperation;
        s.OmegaRop_Region25Region3 = s.OmegaRop2_Region25Region3;
        s.Tg_dMax = (s.Pmec_max / s.OmegaR_Rated ) ; 
        s.Vop_BetaVar = s.Vws_Rated + 0.4 ; % s.Vws_Rated OR s.Vop(s.Indexop_BetaVar) OR s.Vop_PeakShaving_f 
        s.delta_Rated = abs( s.Vop - s.Vop_BetaVar ) ;
        s.Indexop_Rated = find( s.delta_Rated == min(s.delta_Rated) ) ;         
        s.BetaMaxRegion3 = max( s.Beta_op(s.Indexop_Region25Region3:end) ) ; 
        s.BetaMinRegion3 = s.Beta_op(s.Indexop_Rated) ;
        s.BetaMode_Enable = s.BetaMinRegion3 + 0.1 ; % The actual blade pitch position must be at most within this value to activate the controller.
        s.Vop_BetaMode_Enable = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMode_Enable);                 
        s.delta_BetaMode_Enable = abs( s.Vop - s.Vop_BetaMode_Enable ) ;
        s.Indexop_BetaMode_Enable = find( s.delta_BetaMode_Enable == min(s.delta_BetaMode_Enable) ) ;  
        s.BetaMax_nominal = s.Beta_op(s.Indexop_BetaMode_Enable+1) ; % Between the points "Vws_Rated" and "Vws_Rated_end" it is not possible to guarantee a "dBeta" or "du" that guarantees precision. Therefore, for this range, "du = 0" is adopted or at least the integrative term is saturated.
        s.Vws_Rated_end = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMax_nominal); % Or set (Vws_Rated + 0.2). NOTE: From the nominal speed (Vws_Rated) to this point, it is not possible to guarantee a dBeta or du that guarantees accuracy. Therefore, from Vrated to this point (Vws_Rated_end), "du = dBeta = 0" is adopted, thus: Beta_d = Beta_op + 0".  
        s.Vop_TgMode_Saturation = s.Vws_Rated_end ; % It is the speed at which the generator torque can be saturated without affecting the transition between the controllers.
        s.Vop_RegionTrasition = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaDot_max);          
        s.delta_RegionTrasition = abs( s.Vop - s.Vop_RegionTrasition ) ;
        s.Indexop_RegionTrasition = find( s.delta_RegionTrasition == min(s.delta_RegionTrasition) ) ;            
        %        
    elseif s.Option01f8 == 3
        who.ControlStrategy = 'The Control Strategy adopted was STRATEGY 3 (Figure 7.2 from Jonkman, 2009).';       
        s.Vop = s.Vop3;
        s.OmegaR_op = s.OmegaR_op3;
        s.Lambda_op = s.Lambda_op3;
        s.Beta_op = s.Beta_op3;
        s.Tg_op = s.Tg_op3;  
        s.CP_op = s.CP_op3;
        s.CQ_op = s.CQ_op3;
        s.CT_op = s.CT_op3;
        s.GradCpBeta_op = s.GradCpBeta_op3;
        s.GradCpLambda_op = s.GradCpLambda_op3;
        s.GradCtBeta_op = s.GradCtBeta_op3;
        s.GradCtLambda_op = s.GradCtLambda_op3;
        s.Pa_op = s.Pa_op3;
        s.Ta_op = s.Ta_op3;
        s.Fa_op = s.Fa_op3;
        s.Pe_op = s.Pe_op3;
        s.GradTaLambda_op = s.GradTaLambda_op3;
        s.GradTaOmega_op = s.GradTaOmega_op3;
        s.GradTaVop_op = s.GradTaVop_op3;
        s.GradTaBeta_op = s.GradTaBeta_op3;
        s.GradPaBeta_op = s.GradPaBeta_op3;
        s.GradFaLambda_op = s.GradFaLambda_op3;
        s.GradFaOmega_op = s.GradFaOmega_op3;
        s.GradFaVop_op = s.GradFaVop_op3;
        s.GradFaBeta_op = s.GradFaBeta_op3;
        s.Lambda_op_opt = s.Lambda_op3_opt;
        s.OmegaR_op_opt = s.OmegaR_op3_opt;
        s.Beta_op_opt = s.Beta_op3_opt;
        s.Ta_op_opt = s.Ta_op3_opt;
        s.Pa_op_opt = s.Pa_op3_opt;
        s.Vop_Region1Region15 = s.Vop3_Region1Region15 ;
        s.Vop_Region15Region2 = s.Vop3_Region15Region2 ;
        s.Vop_Region2Region25 = s.Vop3_Region2Region25 ;    
        s.Vop_Region25Region3 = s.Vop3_Region25Region3 ;
        s.Vop_Region3Region4 = s.Vop3_Region3Region4 ;
        s.Vop_Region4EndOperation = s.Vop3_Region4EndOperation;    
        s.Indexop_Region1Region15 = s.Indexop3_Region1Region15;
        s.Indexop_Region15Region2 = s.Indexop3_Region15Region2;
        s.Indexop_Region2Region25 = s.Indexop3_Region2Region25;
        s.Indexop_Region25Region3 = s.Indexop3_Region25Region3;
        s.Indexop_BetaVar = s.Indexop_Region25Region3 ;
        s.Indexop_Region3Region4 = s.Indexop3_Region3Region4;
        s.Indexop_Regions4EndOperation = s.Indexop3_Regions4EndOperation;
        s.OmegaRop_Region25Region3 = s.OmegaRop3_Region25Region3;
        s.Tg_dMax = (s.Pmec_max / s.OmegaR_Rated ) ;         
        s.Vop_BetaVar = s.Vws_Rated ; 
        s.delta_Rated = abs( s.Vop - s.Vop_BetaVar ) ;
        s.Indexop_Rated = find( s.delta_Rated == min(s.delta_Rated) ) ;         
        s.BetaMaxRegion3 = max( s.Beta_op(s.Indexop_Region25Region3:end) ) ; 
        s.BetaMinRegion3 = min( s.Beta_op(s.Indexop_Rated:end) ) ;
        s.BetaMode_Enable = s.BetaMinRegion3 + 0.1 ; % The actual blade pitch position must be at most within this value to activate the controller.
        s.Vop_BetaMode_Enable = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMode_Enable);                 
        s.delta_BetaMode_Enable = abs( s.Vop - s.Vop_BetaMode_Enable ) ;
        s.Indexop_BetaMode_Enable = find( s.delta_BetaMode_Enable == min(s.delta_BetaMode_Enable) ) ;  
        s.BetaMax_nominal = s.Beta_op(s.Indexop_BetaMode_Enable+1) ; % Between the points "Vws_Rated" and "Vws_Rated_end" it is not possible to guarantee a "dBeta" or "du" that guarantees precision. Therefore, for this range, "du = 0" is adopted or at least the integrative term is saturated.
        s.Vws_Rated_end = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaMax_nominal); % Or set (Vws_Rated + 0.2). NOTE: From the nominal speed (Vws_Rated) to this point, it is not possible to guarantee a dBeta or du that guarantees accuracy. Therefore, from Vrated to this point (Vws_Rated_end), "du = dBeta = 0" is adopted, thus: Beta_d = Beta_op + 0".
        s.Vop_TgMode_Saturation = s.Vws_Rated ; % It is the speed at which the generator torque can be saturated without affecting the transition between the controllers.         
        s.Vop_RegionTrasition = interp1(s.Beta_op(s.Indexop_BetaVar:end), s.Vop(s.Indexop_BetaVar:end), s.BetaDot_max);                 
        s.delta_RegionTrasition = abs( s.Vop - s.Vop_RegionTrasition ) ;
        s.Indexop_RegionTrasition = find( s.delta_RegionTrasition == min(s.delta_RegionTrasition) ) ;   
        %            
    end


    % Organizing output results  
    WindTurbine_data.Vop = s.Vop; WindTurbine_data.OmegaR_op = s.OmegaR_op; WindTurbine_data.Lambda_op = s.Lambda_op; WindTurbine_data.Beta_op = s.Beta_op; WindTurbine_data.Tg_op = s.Tg_op; WindTurbine_data.CP_op = s.CP_op; WindTurbine_data.CQ_op = s.CQ_op; WindTurbine_data.CT_op = s.CT_op; WindTurbine_data.GradCpBeta_op = s.GradCpBeta_op; WindTurbine_data.GradCpLambda_op = s.GradCpLambda_op; WindTurbine_data.GradCtBeta_op = s.GradCtBeta_op; WindTurbine_data.GradCtLambda_op = s.GradCtLambda_op; WindTurbine_data.Pa_op = s.Pa_op; WindTurbine_data.Ta_op = s.Ta_op; WindTurbine_data.Fa_op = s.Fa_op; WindTurbine_data.Pe_op = s.Pe_op; WindTurbine_data.GradTaLambda_op = s.GradTaLambda_op; WindTurbine_data.GradTaOmega_op = s.GradTaOmega_op; WindTurbine_data.GradTaVop_op = s.GradTaVop_op; WindTurbine_data.GradTaBeta_op = s.GradTaBeta_op; WindTurbine_data.GradPaBeta_op = s.GradPaBeta_op; WindTurbine_data.GradFaLambda_op = s.GradFaLambda_op; WindTurbine_data.GradFaOmega_op = s.GradFaOmega_op; WindTurbine_data.GradFaVop_op = s.GradFaVop_op; WindTurbine_data.GradFaBeta_op = s.GradFaBeta_op; WindTurbine_data.Lambda_op_opt = s.Lambda_op_opt; WindTurbine_data.OmegaR_op_opt = s.OmegaR_op_opt; WindTurbine_data.Beta_op_opt = s.Beta_op_opt; WindTurbine_data.Ta_op_opt = s.Ta_op_opt; WindTurbine_data.Pa_op_opt = s.Pa_op_opt;
    WindTurbine_data.Vop_Region1Region15 = s.Vop_Region1Region15 ; WindTurbine_data.Vop_Region15Region2 = s.Vop_Region15Region2 ; WindTurbine_data.Vop_Region2Region25 = s.Vop_Region2Region25 ; WindTurbine_data.Vop_Region25Region3 = s.Vop_Region25Region3 ; WindTurbine_data.Vop_Region3Region4 = s.Vop_Region3Region4 ; WindTurbine_data.Vop_Region4EndOperation = s.Vop_Region4EndOperation ; WindTurbine_data.Vop_BetaVar = s.Vop_BetaVar ;
    WindTurbine_data.Tg_dMax = s.Tg_dMax; WindTurbine_data.BetaMaxRegion3 = s.BetaMaxRegion3; WindTurbine_data.BetaMinRegion3 = s.BetaMinRegion3; WindTurbine_data.BetaMode_Enable = s.BetaMode_Enable; WindTurbine_data.Vop_BetaMode_Enable = s.Vop_BetaMode_Enable; WindTurbine_data.Indexop_BetaMode_Enable = s.Indexop_BetaMode_Enable; WindTurbine_data.BetaMax_nominal = s.BetaMax_nominal; WindTurbine_data.Vws_Rated_end = s.Vws_Rated_end; WindTurbine_data.Vop_TgMode_Saturation = s.Vop_TgMode_Saturation;
    WindTurbine_data.Vop_RegionTrasition = s.Vop_RegionTrasition; WindTurbine_data.Indexop_Region1Region15 = s.Indexop_Region1Region15; WindTurbine_data.Indexop_Region15Region2 = s.Indexop_Region15Region2; WindTurbine_data.Indexop_Region2Region25 = s.Indexop_Region2Region25; WindTurbine_data.Indexop_Region25Region3 = s.Indexop_Region25Region3; WindTurbine_data.Indexop_Region3Region4 = s.Indexop_Region3Region4; WindTurbine_data.Indexop_Regions4EndOperation = s.Indexop_RegionTrasition; WindTurbine_data.OmegaRop_Region25Region3 = s.OmegaRop_Region25Region3; WindTurbine_data.Indexop_RegionTrasition = s.Indexop_RegionTrasition ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance
   if s.Option05f8 == 2 || s.Option05f8 == 3   
       WindTurbineData_IEA15MW('logical_instance_13');
   else
       WindTurbineData_IEA15MW('logical_instance_14');
   end


%=============================================================
elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
    % PLOT WIND TURBINE PERFORMANCE IN STEADY-STATE (OFFLINE):   
    % Purpose of this Logical Instance: to present the figures with the
    % results of the operation in steady state, according to the control 
    % or operation strategy adopted in a wind turbine. These values ​​are 
    % based on the solutions obtained for each strategy choice.

    % ---------- Adjusting values ​​for plottinge ----------
    s.NNN = length(s.Vop); 
    s.Vline_Regions1Region15 = s.Vop(s.Indexop_Region1Region15) .* ones(1,s.NNN);
    s.Vline_Regions15Region2 = s.Vop(s.Indexop_Region15Region2) .* ones(1,s.NNN);
    s.Vline_Regions2Region25 = s.Vop(s.Indexop_Region2Region25) .* ones(1,s.NNN);
    s.Vline_Regions25Region3 = s.Vop(s.Indexop_Region25Region3) .* ones(1,s.NNN);
    s.Vline_Regions3Region4 = s.Vop(s.Indexop_Region3Region4) .* ones(1,s.NNN);   
    s.Vline_Regions4EndOperation = s.Vop(s.Indexop_Regions4EndOperation) .* ones(1,s.NNN);   
    s.Lineop = [linspace(-0.5,(max(s.Beta_op) + 2),s.Indexop_Region1Region15) linspace(-0.5,(max(s.Beta_op) + 2),(s.Indexop_Region15Region2 - s.Indexop_Region1Region15)) linspace(-0.5,(max(s.Beta_op) + 2),(s.Indexop_Region2Region25 - s.Indexop_Region15Region2)) linspace(-0.5,(max(s.Beta_op) + 2),(s.Indexop_Region25Region3 - s.Indexop_Region2Region25)) linspace(-0.5,(max(s.Beta_op) + 2),(s.Indexop_Region3Region4 - s.Indexop_Region25Region3)) linspace(-0.5,(max(s.Beta_op) + 2),(s.Indexop_Regions4EndOperation - s.Indexop_Region3Region4))];
    s.LineCoef = [linspace(-0.5,(max(s.CT_op) + 2),s.Indexop_Region1Region15) linspace(-0.5,(max(s.CT_op) + 2),(s.Indexop_Region15Region2 - s.Indexop_Region1Region15)) linspace(-0.5,(max(s.CT_op) + 2),(s.Indexop_Region2Region25 - s.Indexop_Region15Region2)) linspace(-0.5,(max(s.CT_op) + 2),(s.Indexop_Region25Region3 - s.Indexop_Region2Region25)) linspace(-0.5,(max(s.CT_op) + 2),(s.Indexop_Region3Region4 - s.Indexop_Region25Region3)) linspace(-0.5,(max(s.CT_op) + 2),(s.Indexop_Regions4EndOperation - s.Indexop_Region3Region4))];   


    who.OmegaR_op_opt = 'Optimal Rotor speed, in [RPM].';
    s.OmegaR_optrpm = (60 .* s.OmegaR_op_opt) ./ (2*pi); 
    who.Ta_optMN = 'Optimal Aerodynamic torque, in [MN.m]';
    s.Ta_optMN = s.Ta_op_opt ./ 1e+6;
    who.Pa_optMW = 'Optimal Aerodynamic power, in [MW]';
    s.Pa_optMW = s.Pa_op_opt ./ 1e+6;
   
    who.OmegaR_oprpm = 'Rotor speed in steady-state, in [RPM]';
    s.OmegaR_oprpm = (60 .* s.OmegaR_op) ./ (2*pi);         
    who.Tg_opMN = 'Generator Torque ​​in Steady-State, and in [MN.m].';
    s.Tg_opMN = s.Tg_op ./ 1e+6;         
    who.Pe_op = 'Generator power in Steady-State, and in [MW]';
    s.Pe_opMW = s.Pe_op ./ 1e+6;      
    who.Ta_opMN = 'Aerodynamic torque in Steady-State, and in [MN.m].';
    s.Ta_opMN = s.Ta_op ./ 1e+6;          
    who.Pa_op = 'Aerodynamic power in Steady-State, and in [MW]';
    s.Pa_opMW = s.Pa_op ./ 1e+6;    
    who.Fa_op = 'Aerodynamic thrust in Steady-State, and in [x10^5 N]';
    s.Fa_opKW = s.Fa_op ./ 1e+6;           

    % Peak Shaving
    who.Tg_opMN_PS = 'Generator Torque ​​in Steady-State, and in [MN.m].';
    s.Tg_opMN_PS = s.Ta_op2 ./ 1e+6;   
    who.Ta_opMN_PS = 'Aerodynamic torque in Steady-State, and in [MN.m].';
    s.Ta_opMN_PS = s.Tg_op2 ./ 1e+6; 
    who.Pa_op_PS = 'Aerodynamic power in Steady-State, and in [MW]';
    s.Pa_opMW_PS = s.Pa_op2 ./ 1e+6;        
    who.Fa_op_PS = 'Aerodynamic thrust in Steady-State, and in [x10^5 N]';
    s.Fa_opKW_PS = s.Fa_op2 ./ 1e+6;     


    % NOTE: Compare these figures with Figure 2.1 of the work 
    % by Abbas (2022).

      
          %####### PLOT AND ANALYZE AERODYNAMIC COEFFICIENTS #######

    % ---- CT, CP and CQ Coefficients in Steady-State (ALL 5 REGIONS) ----
    if s.Option05f8 == 3
        figure()
        h = plot(s.Vop, s.CP_op, 'b', s.Vop, s.CQ_op, 'r', s.Vop, s.CT_op, 'g', s.Vline_Regions1Region15, s.LineCoef, 'k:', s.Vline_Regions15Region2, s.LineCoef, 'k:', s.Vline_Regions2Region25, s.LineCoef, 'k:', s.Vline_Regions25Region3, s.LineCoef, 'k:', s.Vline_Regions3Region4, s.LineCoef, 'k:', s.Vline_Regions4EndOperation, s.LineCoef, 'k:');
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        set(h(9), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
        xlabel('$V_{wind}$ [m/s]', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')     
        ylim([0 1.05 * max(s.CT_op)])
        legend('Power Coefficient', 'Torque Coefficient', 'Thrust Coefficient', 'FontSize', 12, 'Interpreter', 'latex')
        title('Steady-state operating aerodynamic coefficients', 'FontSize', 12)
        %     
    end

            %  Only production regions
    
    figure()  
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.CP_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'b', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.CQ_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'r', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.CT_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'g', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.LineCoef(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.LineCoef(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.LineCoef(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.LineCoef(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.LineCoef(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5);
    xlabel('$V_{wind}$ [m/s]', 'Interpreter', 'latex')
    xlim([0 26])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0 1.05 * max(s.CT_op)])
    legend('Power Coefficient', 'Torque Coefficient', 'Thrust Coefficient', 'FontSize', 12, 'Interpreter', 'latex')
    title('Steady-state operating aerodynamic coefficients', 'FontSize', 12)
    %

          %####### ANALYZING OPERATION #######


    % ---- TORQUE em Regime Permanente----
    if s.Option05f8 == 3    
        figure()        
        h = plot(s.Vop, s.Ta_opMN, 'm', s.Vop, s.Tg_opMN, 'g', s.Vop, s.Lambda_op, 'r', s.Vop, s.Beta_op, 'k', s.Vop, s.OmegaR_oprpm, 'b', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(9), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(10), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(11), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Beta_op) + 1)])        
        legend('Aerodynamic Torque [MN.m]', 'Generator Torque [MN.m]', 'Tip-Speed-Ratio (${\lambda}$)', 'Pitch Blade (${\beta}$)', 'Rotor Speed [RPM]', 'Interpreter', 'latex')
        title('Steady-state operation strategy for a wind turbine.')
        %
    end

            %  Only production regions
    figure()    
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Ta_opMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'm', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Tg_opMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'g', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lambda_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'r', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Beta_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.OmegaR_oprpm(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'b', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(9), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(10), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([0 26])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([-0.5, (max(s.Beta_op) + 1)])        
    legend('Aerodynamic Torque [MN.m]', 'Generator Torque [MN.m]', 'Tip-Speed-Ratio (${\lambda}$)', 'Pitch Blade (${\beta}$)', 'Rotor Speed [RPM]', 'Interpreter', 'latex')
    title('Steady-state operation strategy for a wind turbine.')
    %

          %####### ANALYZING WIND TURBINE SPEEDS #######


    % ---- Rotor speed and Tip-Speed_Ratio ----
    if s.Option05f8 == 3
        figure()         
        h = plot(s.Vop, s.Lambda_op, 'r', s.Vop, s.OmegaR_oprpm, 'b', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Beta_op) + 1)])        
        legend('Tip-Speed-Ratio (${\lambda}$)', 'Rotor Speed [RPM]', 'Interpreter', 'latex')
        title('Rotor speed and blade Tip-Speed_Ratio in steady state.')
        %
    end


        %  Only production regions
    figure()     
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lambda_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'r', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.OmegaR_oprpm(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'b', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([0 25.1])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0.95 * min([s.Lambda_op s.OmegaR_oprpm]), 1.05 * max([s.Lambda_op s.OmegaR_oprpm])])       
    legend('Tip-Speed-Ratio (${\lambda}$)', 'Rotor Speed [RPM]', 'Interpreter', 'latex')
    title('Rotor speed and blade Tip-Speed-Ratio in steady state.')
    %
    

          %####### ANALYZING BLADE PITCH OPERATION #######


    % ---- Blade pitch operation ----
    if s.Option05f8 == 3
        figure()          
        h = plot(s.Vop, s.Beta_op, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(2), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Beta_op) + 1)])        
        legend('Blade pitch [deg]', 'Interpreter', 'latex')
        title('Steady-state blade pitch.')
        %
    end

            %  Only production regions
    figure() 
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Beta_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(2), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([3 25.1])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([-1, (max(s.Beta_op(s.Indexop_Region1Region15:s.Indexop_Region3Region4)) * 1.05)])        
    legend('Blade pitch [deg]', 'Interpreter', 'latex')
    title('Steady-state blade pitch proposed.')
    %


          %####### PLOT AND ANALYZE TORQUE #######


    % ---- Steady-State Aerodynamic and Generator Torque ----
    if s.Option05f8 == 3
        figure()      
        h = plot(s.Vop, s.Ta_opMN, 'm', s.Vop, s.Tg_opMN, 'g', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([0 max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([0 1.05 * max(s.Ta_opMN)])        
        legend('Aerodynamic Torque [MN.m]', 'Generator Torque [MN.m]', 'Interpreter', 'latex')
        title('Steady-State Aerodynamic and Generator Torque.')
        %
    end

            %  Only production regions    
    figure()           
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Ta_opMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'm', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Tg_opMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'g', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([0 25.1])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0 1.05 * max(s.Ta_opMN)])        
    legend('Aerodynamic Torque [MN.m]', 'Generator Torque [MN.m]', 'Interpreter', 'latex')
    title('Steady-State Aerodynamic and Generator Torque.')
    %


       %  Torque-versus-speed response of the variable-speed controller            
    figure()                
    h = plot(s.OmegaR_optrpm(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Ta_optMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'm', s.OmegaR_oprpm(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Tg_opMN(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'g', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$\omega_{r}$ (RPM)','Interpreter','latex')
    xlim([0 14])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0 1.05.*max(s.Tg_opMN)])        
    legend('Aerodynamic Torque [MN.m]','Generator Torque [MN.m]','Interpreter','latex')
    title('Steady-State Response of Aerodynamic and Generator Torque, as a function of Rotor Speed')
        % NOTE: Compare this figure with Figure 7.2 on page 20 of Jonkman (2009).
    %



          %####### PLOT AND ANALYZE POWER #######


    % ---- Steady-State Aerodynamic and Generator Power ----
    if s.Option05f8 == 3
        figure()      
        h = plot(s.Vop, s.Pa_opMW, 'm', s.Vop, s.Pe_opMW, 'g', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([0 max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([0 1.05 * max(s.Pa_opMW)])        
        legend('Aerodynamic Power [MN.m]', 'Generator Power [MN.m]', 'Interpreter', 'latex')
        title('Steady-State Aerodynamic and Generator Power.')
        %
    end

            %  Only production regions    
    figure()           
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Pa_opMW(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'm', s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Pe_opMW(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'g', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([0 25.1])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0 1.05 * max(s.Pa_opMW)])        
    legend('Aerodynamic Power [MN.m]', 'Generator Power [MN.m]', 'Interpreter', 'latex')
    title('Steady-State Aerodynamic and Generator Power.')
    %

 
          %####### PLOT AND ANALYZE THRUST #######


    % ---- Steady-State Aerodynamic Thrust ----
    if s.Option05f8 == 3
        figure()      
        h = plot(s.Vop, s.Fa_opKW, 'm', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(2), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([0 max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([0 1.05 * max(s.Fa_opKW)])        
        legend('Aerodynamic Thrust [KN]', 'Interpreter', 'latex')
        title('Steady-State Aerodynamic Thrust.')
        %
    end

            %  Only production regions    
    figure()           
    h = plot(s.Vop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Fa_opKW(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'm', s.Vline_Regions1Region15(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions15Region2(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions2Region25(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions25Region3(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:', s.Vline_Regions3Region4(s.Indexop_Region1Region15:s.Indexop_Region3Region4), s.Lineop(s.Indexop_Region1Region15:s.Indexop_Region3Region4), 'k:');
    set(h(2), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
    xlabel('$V_{wind}$', 'Interpreter', 'latex')
    xlim([0 25.1])
    ylabel('Unit', 'Interpreter', 'latex')
    ylim([0 1.05 * max(s.Fa_opKW)])        
    legend('Aerodynamic Thrust [KN]', 'Interpreter', 'latex')
    title('Steady-State Aerodynamic Thrust.')
    %


    if s.Option05f8 == 2  
        % PEAK Shaving
        figure()        
        h = plot(s.Vop, s.Ta_opMN, 'r', s.Vop, s.Ta_opMN_PS, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Ta_opMN) + 1)])        
        legend('Aerodynamic Torque [MN.m]', 'Aerodynamic Torque [MN.m] with Peak Shaving Strategy', 'Interpreter', 'latex')
        title('Comparison of strategies: Peak Shaving VS Power Optimization.')
        %  

        % PEAK Shaving
        figure()        
        h = plot(s.Vop, s.Pa_opMW, 'r', s.Vop, s.Pa_opMW_PS, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Tg_opMN) + 1)])        
        legend('Aerodynamic Power [MW]', 'Aerodynamic Power [MW] with Peak Shaving Strategy', 'Interpreter', 'latex')
        title('Comparison of strategies: Peak Shaving VS Power Optimization.')
        %    

        % PEAK Shaving
        figure()        
        h = plot(s.Vop, s.Beta_op, 'r', s.Vop, s.Beta_op2, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Beta_op) + 1)])        
        legend('Collective Blade Pitch [deg]', 'Collective Blade Pitch [deg] with Peak Shaving Strategy', 'Interpreter', 'latex')
        title('Comparison of strategies: Peak Shaving VS Power Optimization.')
        %     

        % PEAK Shaving
        figure()        
        h = plot(s.Vop, s.Beta_op, 'r', s.Vop, s.Beta_op2, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Beta_op) + 1)])        
        legend('Collective Blade Pitch [deg]', 'Collective Blade Pitch [deg] with Peak Shaving Strategy', 'Interpreter', 'latex')
        title('Comparison of strategies: Peak Shaving VS Power Optimization.')
        %  

        % PEAK Shaving
        figure()        
        h = plot(s.Vop, s.Fa_opKW, 'r', s.Vop, s.Fa_opKW_PS, 'k', s.Vline_Regions1Region15, s.Lineop, 'k:', s.Vline_Regions15Region2, s.Lineop, 'k:', s.Vline_Regions2Region25, s.Lineop, 'k:', s.Vline_Regions25Region3, s.Lineop, 'k:', s.Vline_Regions3Region4, s.Lineop, 'k:', s.Vline_Regions4EndOperation, s.Lineop, 'k:');
        set(h(3), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(4), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(5), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(6), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(7), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        set(h(8), 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); 
        xlabel('$V_{wind}$', 'Interpreter', 'latex')
        xlim([min(s.Vop) max(s.Vop)])
        ylabel('Unit', 'Interpreter', 'latex')
        ylim([-0.5, (max(s.Fa_opKW) + 1)])        
        legend('Aerodynamic Thrust [KN]', 'Aerodynamic Thrust [KN] with Peak Shaving Strategy', 'Interpreter', 'latex')
        title('Comparison of strategies: Peak Shaving VS Power Optimization.')
        %           
    end


    % Organizing output results
    WindTurbine_data.OmegaR_optrpm = s.OmegaR_optrpm; WindTurbine_data.Ta_optMN = s.Ta_optMN; WindTurbine_data.Pa_optMW = s.Pa_optMW;
    WindTurbine_data.OmegaR_optrpm = s.OmegaR_optrpm;    
    WindTurbine_data.Tg_opMN = s.Tg_opMN;
    WindTurbine_data.Pe_opMW = s.Pe_opMW; 
    WindTurbine_data.Ta_opMN = s.Ta_opMN;   
    WindTurbine_data.Pa_opMW = s.Pa_opMW;
    WindTurbine_data.Fa_opKW= s.Fa_opKW;  


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   WindTurbineData_IEA15MW('logical_instance_14');


%=============================================================
elseif strcmp(action, 'logical_instance_14')    
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % IEA-15MW DATA CONTROL DESIGN PARAMETERS (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of the IEA-15MW wind turbine, related to turbulent
    % wind field models and the IEC 61400-1 standard or related standards.


    % ---------- Peak Shaving Design Coefficients and Parameters ----------
    who.a_shaving  = 'Peak Shaving Design Parameter.';
    s.a_shaving = s.Fa_maxPeakShaving / max(s.Fa_op2);

    
    % ---------- Controller Design and Stability Analysis ----------
    if (s.Option02f1 == 1)
        %  State-Observer KALMAN FILTER and estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator
        who.OmegaNTg_Tab  = 'Desired Natural Vibration Frequency for Generator Torque Controller.';
        s.OmegaNTg_Tab = 0.15 * ones(1,length(s.Vop)) ; % 0.2017
        who.DampingCFactorTg_Tab  = 'Desired Critical Damping Factor for Generator Torque Controller.';
        s.DampingCFactorTg_Tab = 0.7 * ones(1,length(s.Vop)) ; % 0.95  

        who.OmegaNBeta_Tab  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
        s.OmegaNBeta_Tab = [0.6*ones(1,length(s.Vop(1:s.Indexop_Region25Region3))) 0.4*ones(1,length(s.Vop(s.Indexop_Region25Region3+1:end)))] ; % 0.75 or 0.6
        who.DampingCFactorBeta_Tab  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
        s.DampingCFactorBeta_Tab = [0.7*ones(1,length(s.Vop(1:s.Indexop_Region25Region3))) 0.4*ones(1,length(s.Vop(s.Indexop_Region25Region3+1:end)))] ; % 0.85 or 0.7
        %
    elseif (s.Option02f1 == 2)
        %  State-Observer EXTENDED KALMAN FILTER and estimate Effective Wind Speed ​​directly or online
        who.OmegaNTg_Tab  = 'Desired Natural Vibration Frequency for Generator Torque Controller.';
        s.OmegaNTg_Tab = 0.2017 * ones(1,length(s.Vop)) ; % 0.2017
        who.DampingCFactorTg_Tab  = 'Desired Critical Damping Factor for Generator Torque Controller.';
        s.DampingCFactorTg_Tab = 0.7 * ones(1,length(s.Vop)) ; % 0.95  

        who.OmegaNBeta_Tab  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
        s.OmegaNBeta_Tab = [0.6*ones(1,length(s.Vop(1:s.Indexop_Region25Region3))) 0.4*ones(1,length(s.Vop(s.Indexop_Region25Region3+1:s.Indexop_RegionTrasition))) 0.4*ones(1,length(s.Vop(s.Indexop_RegionTrasition+1:end)))] ; % 0.75 or 0.6
        who.DampingCFactorBeta_Tab  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
        s.DampingCFactorBeta_Tab = [0.7*ones(1,length(s.Vop(1:s.Indexop_Region25Region3))) 0.4*ones(1,length(s.Vop(s.Indexop_Region25Region3+1:s.Indexop_RegionTrasition))) 0.4*ones(1,length(s.Vop(s.Indexop_RegionTrasition+1:end)))] ; % 0.85 or 0.7
        %      
    end

    % ---------- Set Point Smoother Design Coefficients and Parameters ----------
    who.Kpc  = 'Gain for Set Point Smoothe, Abba (2022).';
    s.Kpc = 0.0001 ; % According to Abbas (2022) sugest s.Kpc = 0.001    
    who.Kvs  = 'Gain for Set Point Smoother, Abba (2022).';
    s.Kvs = 0.0001 ; % According to Abbas (2022) sugest s.Kvs = 1

    

    % ---------- Cutoff Frequencies for Control Signals ----------    
    who.CutFreq_DriveTrain = 'Cutoff frequency for control signals, in [Hz] and used in drive train dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    s.CutFreq_DriveTrain = 0.25;
    who.CutFreq_TowerTop = 'Cutoff frequency for control signals, in [rad/s] and used in tower-top dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    s.CutFreq_TowerTop = 0.01 ;  
    who.CutFreq_OmegaNstructure = 'Cutoff natural Frequency of the Structure, in [Hz].';
    s.CutFreq_OmegaNstructure = max([s.OmegaNTg_Tab s.OmegaNBeta_Tab]); 
    who.CutFreq_TowerForeAft = 'Notch filter cutoff frequency and the the tower fore–af motion, in [rad/s].'; 
    s.CutFreq_TowerForeAft = s.FNtw_FA1 / (2*pi);  


    % Organizing output results  
    WindTurbine_data.Kvs = s.Kvs; WindTurbine_data.Kpc = s.Kpc; WindTurbine_data.a_shaving  = s.a_shaving ;
    WindTurbine_data.OmegaNTg_Tab = s.OmegaNTg_Tab; WindTurbine_data.DampingCFactorTg_Tab = s.DampingCFactorTg_Tab; WindTurbine_data.OmegaNBeta_Tab = s.OmegaNBeta_Tab; WindTurbine_data.DampingCFactorBeta_Tab = s.DampingCFactorBeta_Tab;  
    WindTurbine_data.CutFreq_DriveTrain = s.CutFreq_DriveTrain; WindTurbine_data.CutFreq_TowerTop = s.CutFreq_TowerTop; WindTurbine_data.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure; WindTurbine_data.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


   % Calling the next logic instance    
   WindTurbineData_IEA15MW('logical_instance_15');

 
%=============================================================
elseif strcmp(action, 'logical_instance_15')    
%==================== LOGICAL INSTANCE 15 ====================
%=============================================================    
    % IEA-15MW DATA RELATED TO IEC-61400-1 AND WIND FIELD (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of the IEA-15MW wind turbine, related to turbulent
    % wind field models and the IEC 61400-1 standard or related standards.


    % ------ Defining IEC 61400-3 Reference Values ---------- 
    who.HeightTopTower_MSL = 'Tower Top Height above Mean Sea Level (MSL), in [m].';
    s.HeightTopTower_MSL = 87.6;

    who.RSeaLevelHeight = 'Reference value, above SWL and in [m], for calculating Sea/Water Surface Velocity in the "Wind-Generated Currents, Near the Surface" model.';
    s.RSeaLevelHeight = 10;    


        % NOTE: The greater the number of points, the better the capture of
        % smaller scales of turbulence in the model. The wider and taller
        % the grid, the better the capture of larger scales in the model.
        % To achieve this, it is necessary to distribute as many points as
        % possible along the disk and for the points to exceed the maximum 
        % dimensions of the turbine (tower height plus blade length and 
        % disk diameter in width). However, the more points, the higher the
        % computational cost, sometimes unfeasible. A suggestion for a grid
        % on the disk would be a minimum of 13x13x1 (13 points on the x 
        % and y axes, in a single parallel plane on the disk). An average
        % number of points would be 25x15x1 and a high number, and still
        % computationally viable, would be 39x31x1. In this code, I am only
        % considering 3D turbulent wind (time dimension and 2 spatial 
        % dimensions on the disk plane). The best would be more points, but
        % the simulation can take hours to generate a wind. In a design 
        % phase or simple results demonstrations, the minimum number of
        % points would be the most appropriate. There is an optimized 
        % configuration option, which balances between model accuracy and 
        % computational cost. I also left an average number of points option,
        % to have a more accurate and realistic turbulence resolution that
        % is viable in terms of computational cost. The option with fewer 
        % points works in most cases, but there may be some discontinuities
        % in the turbulent wind signal, which can be observed in considerable
        % acceleration or deceleration at a given point. This "Acceleration
        % or deceleration grid" may not be possible to compensate in the 
        % state controllers and observers, for example, for the adjustment
        % with the Kalman Filter I was successful in 90% of the cases and
        % for that reason I will leave the option with fewer points as the
        % default option.
        %
        % Go to Logical Instance 01 of the file "System_WindFieldIEC614001_1"
        % to choose how to build the grid.


    % ------ Defining Strategic Points on the Grid for Modeling ---------- 
    if s.Option08f6 == 4
        % A configuration with a high number of points (high computational
        % cost and good resolution of the turbulence effect - more
        % realistic).
        s.PointsModeling_Disk = [0 s.RNodes s.Rrd (s.Rrd + 6)]; 
        %
    elseif s.Option08f6 == 3
        % A configuration with a Medium/Reasonable number of points 
        % (medium computational cost and medium resolution of the 
        % turbulence effect).
        s.PointsModeling_Disk = [0 s.RNodes(1) s.RNodes(4) s.RNodes(6) s.RNodes(8) s.RNodes(10) s.RNodes(12) s.RNodes(14:17) s.Rrd (s.Rrd + 8.76)];    
        %
    elseif s.Option08f6 == 2
        % A configuration with the Minimum number of points (lower 
        % computational cost and low resolution in the turbulence effect).

        s.PointsModeling_Disk = [0 s.RNodes(13:end)  s.Rrd];
        %
    else
        % A  Optimized Configuration of points in the disk plane (average
        % computational cost and satisfactory resolution of the turbulence effect).

        s.PointsModeling_Disk = [0 s.RNodes(13:end)  s.Rrd];        
    end
    s.PointsModeling_Disk = sort(unique(s.PointsModeling_Disk));


    if s.Option08f6 == 4
        % A configuration with a high number of points (high computational
        % cost and good resolution of the turbulence effect - more
        % realistic).
        s.PointsModeling_Tower = [s.ElevTower 0 s.HtowerG s.CM_tower]; 
        %
    elseif s.Option08f6 == 3
        % A configuration with a Medium/Reasonable number of points 
        % (medium computational cost and medium resolution of the 
        % turbulence effect).
        s.PointsModeling_Tower = [s.ElevTower(5:11) 0 s.HtowerG s.CM_tower];
        %
    elseif s.Option08f6 == 2
        % A configuration with the Minimum number of points (lower 
        % computational cost and low resolution in the turbulence effect).

        s.PointsModeling_Tower = [0 s.ElevTower(4) s.CM_tower 87.6];
        %
    else
        % A  Optimized Configuration of points in the disk plane (average
        % computational cost and satisfactory resolution of the turbulence effect).

        s.PointsModeling_Tower = [0 s.ElevTower(4) s.CM_tower 87.6];
    end
    s.PointsModeling_Tower = sort(unique(s.PointsModeling_Tower));


    s.PointsModeling_Offshore = [0 s.HubHt s.OveralCM_wt(3) s.RSeaLevelHeight (s.HubHt - s.Rrd)]; % OR s.PointsModeling_Offshore = [0 s.HubHt s.OveralCM_wt(3) s.RSeaLevelHeight (s.HubHt - s.Rrd) (2*s.HubHt)]; 
    s.PointsModeling_Offshore = sort(unique(s.PointsModeling_Offshore));    

        % WARNING: Review the important points above and choose an 
        % odd number% of points for each axis strategically. The grid 
        % should be as close to a square as possible and always leave 
        % some points outside of the desired, to suffer the edge conditions 
        % and not have inaccuracies in the points further to the edge
        % of the grid.    


          %######## GLOBAL COORDINATE SYSTEM ########


    % ------ Defining a GLOBAL COORDINATE SYSTEM ----------  

              %              Z ^
              %                |
              %                |
              %                |
              %  _ _ _ _ _ _ _ CD _ _ _ _ _ _ _ _ _ _ _ > Y
              %                |
              %                |
              % _____ (z=0) _______ |_____________ Ground or MLS
              % 

    % CD == Center of the disk (0,90)  
    % Tower height z = 0 on the bottom of the tower.
    % Offshore height == z = 90 of MLS (reference of center of the disk)

    if s.Option08f6 > 1
        s.PointsModeling_y = [s.PointsModeling_Disk 0 -s.PointsModeling_Disk];       
        s.PointsModeling_z = [s.PointsModeling_Tower s.PointsModeling_Offshore s.HubHt (s.HubHt + s.PointsModeling_Tower) (s.HubHt + s.PointsModeling_Offshore)]; 
        %
    else
        s.PointsModeling_z = [0 10 26.28 27 s.CM_tower 64 87.6 90 98.76 94 168.84 177.60 170 180];
        s.PointsModeling_y = [-63 -58.9 -52.75 -40.45 -28.15 -15.85 0 15.85 28.15 40.45 52.75 56.1667 63];
    end
    s.PointsModeling_y = sort(unique(s.PointsModeling_y));
    s.Ny_grid_desire = length(s.PointsModeling_y);
    s.PointsModeling_z = sort(unique(s.PointsModeling_z));
    s.Nz_grid_desire = length(s.PointsModeling_z);

    
    % ------ Analyzing and Selecting Grid Points ----------  
    s.PointsModeling_z = s.PointsModeling_z;
    s.PointsModeling_y = s.PointsModeling_y;


    % ---------- GENERATING THE GRID IN COORDINATES (Nz,Ny) ----------
    who.Notef6_2 = 'Grid of Points/Nodes circumscribed over Rotor Disc.';   
    who.Ny_grid = 'Number of Points in y (base) on the Grid., in [dimensionless].';
    s.Ny_grid = length(s.PointsModeling_y);
    who.Nz_grid = 'Number of Points in z (base) on the Grid., in [dimensionless].';
    s.Nz_grid = length(s.PointsModeling_z);
    who.Lz_grid = 'Grid Width, in [m].';
    s.Lz_grid = abs(max(s.PointsModeling_z) - min(s.PointsModeling_z));    
    who.Ly_grid = 'Grid Height, in [m].';
    s.Ly_grid = abs(max(s.PointsModeling_y) - min(s.PointsModeling_y));
    who.Nt = 'Total number of grid points, in [dimensionless]. See Main (1998).';
    s.Nt = s.Ny_grid*s.Nz_grid; 

    who.dy_grid = 'Space differential along the Y axis, in [m].';
    s.dy_grid = diff(s.PointsModeling_y);    
    who.dz_grid = 'Space differential along the Z axis, in [m].';
    s.dz_grid = diff(s.PointsModeling_z);  

    % Check if the number of points is even or odd and set the indexes
    if mod(numel(s.PointsModeling_y), 2) == 0
        s.iy = flip([(-numel(s.PointsModeling_y)/2:-1) (1:numel(s.PointsModeling_y)/2)]);
    else
        s.iy = flip(-floor(numel(s.PointsModeling_y)/2):ceil(numel(s.PointsModeling_y)/2-1));
    end
    
    if mod(numel(s.PointsModeling_z), 2) == 0
        s.iz = [(-numel(s.PointsModeling_z)/2:-1) (1:numel(s.PointsModeling_z)/2)];
    else
        s.iz = -floor(numel(s.PointsModeling_z)/2):ceil(numel(s.PointsModeling_z)/2-1);
    end

    [s.Y_grid, s.Z_grid] = ndgrid(s.PointsModeling_y, flip(s.PointsModeling_z));    
    who.Y_grid  = 'Y coordinate (width of the rotor disk plane), in [m].';    
    s.Y_grid = s.Y_grid';   
    who.Z_grid = 'Z coordinate (z = 0, origin at ground or MSL), in [m].';    
    s.Z_grid = s.Z_grid';

    who.idxsMGrid_y = 'Index of the Y coordinate of the grid. Index of the vector "PointsModeling_y" and columns of the matrix "Y_grid".';
    s.idxsMGrid_y = 1:s.Ny_grid; % Use wth "s.PointsModeling_y"

    who.idxsMGrid_z = 'Index of the Z coordinate of the grid. Index of the vector "PointsModeling_z" and columns of the matrix "Z_grid".';
    s.idxsMGrid_z = 1:s.Nz_grid; % Use wth "s.PointsModeling_z" AND wth "s.Z_grid" 

    who.idxsMGrid_OriginY = 'Index of the Y_grid Matrix of the global grid coordinate system.';    
    s.idxsMGrid_OriginY = find( s.PointsModeling_y == 0);
    who.idxsMGrid_OriginZ = 'Index of the Z_grid Matrix of the global grid coordinate system.';    
    s.idxsMGrid_OriginZ = find( s.PointsModeling_z == 90);

    % See how to check the origin point, through the coordinates in
    % the form of a MATRIX.
            % s.Z_grid(s.idxsMGrid_OriginZ,s.idxsMGrid_OriginY)
            % s.Y_grid(s.idxsMGrid_OriginZ,s.idxsMGrid_OriginY)


    % WARNING! To reduce computational cost, benefiting from vector calculations,
    % we will transform the respective indices of the matrices "Y_grid" and "Z_grid"
    % into unique indices for vectors. That is, instead of using (Nz,Ny), 
    % we use (1xNt). Where Nt is Nz x Ny .


    % ---------- GENERATING THE GRID IN COORDINATES (1,Nt) ----------
    who.idxsV_Grid = 'Single Index of the Z coordinate of the grid (origin at the center of the disk). The dimension of this matrix is (1 x Nt).';
    s.idxsV_Grid = 1:s.Nt;


    who.Z_GridV = 'Index of the Z coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
    for iit = 1:s.Nz_grid 
        if iit == 1
            who.Z_GridV = 'Index of the Z coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
            s.Z_GridV = s.Z_grid(iit,:) ;
            who.Y_GridV = 'Index of the Y coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
            s.Y_GridV = s.Y_grid(iit,:) ;              
        else
            who.Z_GridV = 'Index of the Z coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
            s.Z_GridV = [s.Z_GridV  s.Z_grid(iit,:)] ;
            who.Y_GridV = 'Index of the Y coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
            s.Y_GridV = [s.Y_GridV s.Y_grid(iit,:)] ;              
        end   
        %
    end % for iiZ = 1:s.Nz_grid 
   

 
    % ---------- GLOBAL GRID COORDINATE SYSTEM INDEX MATRIX ----------  
    who.idxsM_Grid = 'Matrix indices correlated to the unique index system for vectors.';
    s.idxsM_Grid = zeros(s.Nz_grid, s.Ny_grid);
    iit = 0;
    for iiZ = 1:s.Nz_grid 
        for iiY = 1:s.Ny_grid 
            iit = iit + 1;
            s.idxsM_Grid(iiZ, iiY)  = iit;
            %
        end        
    end

        % NOTE: The indexes "s.idxsV_Grid" and "s.idxsM_Grid" are equivalent.
        %   The index "s.idxsV_Grid" is used for the vectors "s.Y_GridV"
        % and "s.Z_GridV". The index "s.idxsM_Grid" is used for the
        % matrices "s.Y_grid" and "s.Z_grid".

    who.idxsMGrid_Origin = 'Index of the origin of the Grid.';                                           
    s.idxsMGrid_Origin = s.idxsM_Grid(s.idxsMGrid_OriginZ,s.idxsMGrid_OriginY);

    
    % ---------- Index of important points in the Grid ---------           
    who.idxsV_hub = 'Index of the point at the height of the Hub or the center of the Disc, in grid coordinates.';
    s.idxsV_hub = s.idxsMGrid_Origin; 

    who.Width_grid = 'Width of the discretized grid (Y axis), in [m].';
    s.Width_grid = unique(s.Y_grid);  

    who.Height_grid = 'Height of the discretized grid (Z axis), in [m].';
    s.Height_grid = unique(s.Z_grid);  

    who.Zgrid_bottom = 'Height at the bottom of the grid (Z axis), in [m].';
    s.Zgrid_bottom = min(s.Height_grid(:));     

      
    % -------------- Indexs for points on the Tower Line. -----
    who.Height_tower = 'Height of the discretized tower (Z axis), in [m].';
    s.Height_tower =  s.Height_grid(s.Height_grid <= s.HtowerG);

    who.Width_tower = 'Width of the discretized tower (Y axis), in [m].';
    s.Width_tower = zeros(size(s.Height_tower));  

    who.idxsV_Tower = 'Index corresponding to the heights of the tower.';
    for i = 1:length(s.Height_tower)       
         s.idxsV_tower(i) = s.idxsM_Grid( find(s.Z_grid(:,s.idxsMGrid_OriginY) == s.Height_tower(i) ) , s.idxsMGrid_OriginY);
    end
    who.N_TowerLine = 'Number of grid elements located on the tower line (Z axis), in [dimensionless].';    
    s.N_TowerLine = length(s.idxsV_tower);

    who.idxsV_Toptower = 'Index corresponding to the top of the tower.';
    s.idxsV_Toptower = s.idxsV_tower( find( s.Height_tower == s.HtowerG) );
    
    who.idxsV_Bottomtower = 'Index corresponding to the bottom of the tower.';
    s.idxsV_Bottomtower = s.idxsV_tower( find( s.Height_tower == s.Zgrid_bottom ) );

    who.idxsV_CMtower = 'Index corresponding to the center of mass of the tower.';
    if any(s.Height_tower == s.CM_tower)
        s.idxsV_CMtower = s.idxsV_tower(find(s.Height_tower == s.CM_tower));
    else
        warning('O valor %f não está presente em s.Height_tower. Não foi possível definir s.idxsV_CMtower.', s.CM_tower);
        s.idxsV_CMtower = []; 
    end


    if s.Option02f2 > 1 % Offshore Wind Turbine

            % This index is to calculate the average wind speed (1 hour)
            % at this point, for the Current model under normal conditions,
            % according to IEC 61400-1 Standard.

        who.idxsV_Vswl1hour = 'Index corresponding to the overall center of mass of the wind turbine.';
        if any(s.Height_tower == s.RSeaLevelHeight)
            s.idxsV_Vswl1hour = s.idxsV_tower(find(s.Height_tower == s.RSeaLevelHeight ));
        else
            warning('O valor %f não está presente em s.Height_tower. Não foi possível definir s.RSeaLevelHeight.', s.RSeaLevelHeight );
            s.idxsV_Vswl1hour = []; 
        end
    end % if s.Option02f2 > 1

    who.idxsV_OveralCM = 'Index corresponding to the overall center of mass of the wind turbine.';
    if any(s.Height_tower == s.OveralCM_wt(3) )
        s.idxsV_OveralCM = s.idxsV_tower( find( s.Height_tower == s.OveralCM_wt(3) ) );
    else
        warning('O valor %f não está presente em s.Height_tower. Não foi possível definir s.idxsV_OveralCM .', s.OveralCM_wt(3));
        s.idxsV_OveralCM = []; 
    end   


    % ---------- ROTOR DISC POLAR COORDINATE SYSTEM ----------      
    who.LocalRadiusGrid_Mpolar= 'Local Radius on Grid (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (Ny_grid x Nz_grid).';
    s.LocalRadiusGrid_Mpolar = sqrt( ( s.Z_grid - s.HubHt).^2 + (s.Y_grid).^2 );  % Local radius (polar coordinate - origin at center of disk)
    who.MuGrid_Mpolar = 'Standard Blade Radius (r/R), in [m]. The dimension of this vector is (Ny_grid x Nz_grid).';
    s.MuGrid_Mpolar = s.LocalRadiusGrid_Mpolar./s.Rrd;
    who.idxsM_Disk = 'Matrix indices correlated to the unique index system for vectors.';
    s.idxsM_Disk = s.idxsM_Grid; 
    
    who.MuGrid_Vpolar = 'Standard Blade Radius (r/R) of Grid, in [m]. The dimension of this vector is (1 x Nt).';     
    for iit = 1:s.Nz_grid 
              
        % -------- Identifying indices of points circumscribed on the Disk -------
        idxs = find( s.LocalRadiusGrid_Mpolar(iit,:) >= s.BladeRoot & s.LocalRadiusGrid_Mpolar(iit,:) <= s.Rrd );
        if ~isempty(idxs)
            idxsV = s.idxsM_Disk(iit,idxs);
            LocalRadiusGridVV = s.LocalRadiusGrid_Mpolar(iit,idxs);
        else
             idxsV = [];
             LocalRadiusGridVV = [];
        end

        % -------- Index and Coordinates in the Disk Vector System -------
        if iit == 1
            who.idxsV_Disk = 'Index corresponding to the points circumscribed on the rotor disc.';            
            s.idxsV_Disk = idxsV ;
            who.LocalRadiusDisk_Vpolar = 'Local Radius on Disk (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (1 x Nt).';
            s.LocalRadiusDisk_Vpolar = LocalRadiusGridVV;

            who.LocalRadiusGrid_Vpolar = 'Local Radius on Grid (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (1 x Nt).';
            s.LocalRadiusGrid_Vpolar = s.LocalRadiusGrid_Mpolar(iit,:) ;  
        else
            who.idxsV_Disk = 'Index corresponding to the points circumscribed on the rotor disc.';               
            s.idxsV_Disk = [s.idxsV_Disk idxsV];
            who.LocalRadiusDisk_Vpolar = 'Local Radius on Disk (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (1 x Nt).';
            s.LocalRadiusDisk_Vpolar = [s.LocalRadiusGrid_Vpolar LocalRadiusGridVV];

            who.LocalRadiusGrid_Vpolar= 'Local Radius on Grid (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (1 x Nt).';
            s.LocalRadiusGrid_Vpolar = [s.LocalRadiusGrid_Vpolar s.LocalRadiusGrid_Mpolar(iit,:)] ;              
        end   
        %
    end % for iiZ = 1:s.Nz_grid 

    who.Length_Disk = 'Total Points circumscribed in the rotor disk'; 
    s.Length_Disk = length(s.idxsV_Disk);
    who.MuDisk_Vpolar = 'Standard Blade Radius (r/R) of Disk, in [m]. The dimension of this vector is (1 x Nt).';
    s.MuDisk_Vpolar = s.LocalRadiusGrid_Vpolar ./ s.Rrd;
    who.MuGrid_Vpolar = 'Standard Blade Radius (r/R) of Grid, in [m]. The dimension of this vector is (1 x Nt).';
    s.MuGrid_Vpolar = s.LocalRadiusGrid_Vpolar ./ s.Rrd;
    who.idxsV_DiskHub = 'Index of the point at the height of the Hub or the center of the Disc, in grid coordinates.';
    s.idxsV_DiskHub = find( s.LocalRadiusGrid_Vpolar == 0) ;

    who.Z_DiskV = 'Index of the Z coordinate of the DISK Coordinates System. The dimension of this matrix is (1 x Nt) .';
    s.Z_DiskV = s.Z_GridV(s.idxsV_Disk);
    who.Y_GridV = 'Index of the Y coordinate of the DISK Coordinates System. The dimension of this matrix is (1 x Nt) .';
    s.Y_DiskV = s.Y_GridV(s.idxsV_Disk); 



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);




  %###### GENERATING/LOADING THE WIND FIELD AND WIND SPEED ####


    % ###### Call other Recursive Function ######
    System_WindFieldIEC614001_1('logical_instance_02');


    
    % Organizing output results
    WindTurbine_data.Notef6_2 = who.Notef6_2;
    WindTurbine_data.PointsModeling_Disk = s.PointsModeling_Disk; WindTurbine_data.PointsModeling_Tower = s.PointsModeling_Tower; WindTurbine_data.PointsModeling_Offshore = s.PointsModeling_Offshore; WindTurbine_data.PointsModeling_y = s.PointsModeling_y; WindTurbine_data.PointsModeling_z = s.PointsModeling_z;
    WindTurbine_data.Ny_grid = s.Ny_grid; WindTurbine_data.Nz_grid = s.Nz_grid; WindTurbine_data.Nt = s.Nt; WindTurbine_data.Ly_grid = s.Ly_grid; WindTurbine_data.Lz_grid = s.Lz_grid;  
    WindTurbine_data.dy_grid = s.dy_grid; WindTurbine_data.dz_grid = s.dz_grid; WindTurbine_data.Y_grid = s.Y_grid; WindTurbine_data.Z_grid = s.Z_grid;

    WindTurbine_data.idxsMGrid_y  = s.idxsMGrid_y ; WindTurbine_data.idxsMGrid_z = s.idxsMGrid_z; WindTurbine_data.idxsMGrid_OriginY = s.idxsMGrid_OriginY; WindTurbine_data.idxsMGrid_OriginZ = s.idxsMGrid_OriginZ;
    WindTurbine_data.idxsV_Grid = s.idxsV_Grid; WindTurbine_data.Z_GridV =  s.Z_GridV; WindTurbine_data.Y_GridV = s.Y_GridV; WindTurbine_data.idxsM_Grid = s.idxsM_Grid; WindTurbine_data.idxsMGrid_Origin = s.idxsMGrid_Origin;          

    WindTurbine_data.idxsV_hub = s.idxsV_hub; WindTurbine_data.Width_grid = s.Width_grid; WindTurbine_data.Height_grid = s.Height_grid; WindTurbine_data.Zgrid_bottom = s.Zgrid_bottom;
    WindTurbine_data.Z_DiskV = s.Z_DiskV; WindTurbine_data.Y_DiskV = s.Y_DiskV;

    WindTurbine_data.Height_tower = s.Height_tower; WindTurbine_data.Width_tower = s.Width_tower; WindTurbine_data.idxsV_tower = s.idxsV_tower; WindTurbine_data.N_TowerLine = s.N_TowerLine; WindTurbine_data.idxsV_Toptower = s.idxsV_Toptower; WindTurbine_data.idxsV_Bottomtower = s.idxsV_Bottomtower; WindTurbine_data.idxsV_CMtower = s.idxsV_CMtower; WindTurbine_data.idxsV_OveralCM  = s.idxsV_OveralCM ;
    if s.Option02f2 > 1 % Offshore Wind Turbine
        WindTurbine_data.idxsV_Vswl1hour = s.idxsV_Vswl1hour;
    end
    WindTurbine_data.LocalRadiusGrid_Mpolar = s.LocalRadiusGrid_Mpolar; WindTurbine_data.LocalRadiusGrid_Vpolar = s.LocalRadiusGrid_Vpolar;
    WindTurbine_data.MuGrid_Mpolar = s.MuGrid_Mpolar; WindTurbine_data.MuGrid_Vpolar = s.MuGrid_Vpolar; WindTurbine_data.MuDisk_Vpolar = s.MuDisk_Vpolar;
    WindTurbine_data.idxsV_Disk = s.idxsV_Disk; WindTurbine_data.Length_Disk = s.Length_Disk;
    WindTurbine_data.LocalRadiusDisk_Vpolar = s.LocalRadiusDisk_Vpolar; WindTurbine_data.idxsV_DiskHub= s.idxsV_DiskHub;

    WindTurbine_data.Vws_aa = s.Vws_aa; WindTurbine_data.Vws_Ref = s.Vws_Ref; WindTurbine_data.I_ref = s.I_ref; WindTurbine_data.Vws_RefT = s.Vws_RefT; WindTurbine_data.IEC6140011_Classes = s.IEC6140011_Classes;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_16');
        


%=============================================================
elseif strcmp(action, 'logical_instance_16')
%==================== LOGICAL INSTANCE 16 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA SPAR BUOY PLATFORM BY BETTI, 2012 (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of a Spar Buoy floating platform type, assembly on
    % a NREL-5MW reference baseline wind turbine. The modeling of this 
    % structure follows the paper titled "Modeling and Control of a 
    % Floating Wind Turbine with Spar Buoy Platform", 2012, by authors G. 
    % Betti, M. Farina, A. Marzorati and R. Scattolini.


    % ---------- System Discretization for Numerical Simulation ----------
    who.dt = 'Time step for numerical integration, in [sec]. Defined as Wind sampling (s.SampleT_Wind)';
    s.dt = s.SampleT_Wind; 
    who.Ns = 'Sampling Number.';
    s.Ns = ceil(s.tf/s.dt) + 1; 


    % -------- Initial Values of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = 0 ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = 0 ; 
    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot = 0 ;
    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = 0 ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = 0 ;  
    who.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sway_Ddot = 0 ;
    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = 0 ;     
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = 0 ;  
    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot = 0 ;     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = 0 ;     
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = 0 ;
    who.RollAngle_Ddot = 'Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
    s.RollAngle_Ddot = 0 ;
    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = 0 ;        
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad].';
    s.PitchAngle = 0 ;  
    who.PitchAngle_Ddot = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    s.PitchAngle_Ddot = 0 ;  
    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = 0 ; 
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = 0 ; 
    who.YawAngle_Ddot = 'Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
    s.YawAngle_Ddot = 0 ;
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = 0 ;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = 0 ;    
    who.Xt_Ddot = 'Tower-Top Fore-Aft Acceleration (front longitudinal axis), in [m/s^2].'; 
    s.Xt_Ddot = 0 ;
    who.VCsi= 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
    s.VCsi =  0 ;


    % -------- Initial Values ​​of System Disturbances --------
    who.Uews = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
    s.Uews = s.Uews_full(1) ;
    who.Vews = 'Effective Wind Speed ​​with spatial and relative motion effects, in [m/s].';          
    s.Vews = s.Uews - s.VCsi;


    % Calling the next logic instance    
    if s.Option02f2 == 2 
        % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
        WindTurbineData_IEA15MW('logical_instance_17');
        %
    elseif s.Option02f2 == 3
        % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
        WindTurbineData_IEA15MW('logical_instance_18');
        %
    elseif s.Option02f2 == 4 
        % ---------- Floating Wind Turbine with Submersible Platform ----------
        WindTurbineData_IEA15MW('logical_instance_19');
        %
    elseif s.Option02f2 == 5 
        % ---------- Floating Wind Turbine with Barge Platform ----------
        WindTurbineData_IEA15MW('logical_instance_20');
        %
    elseif s.Option02f2 == 6 
        % ---------- Fixed-Bottom Offshore Wind Turbine ----------
        WindTurbineData_IEA15MW('logical_instance_21');
        %  
    else
        % ---------- Onshore Wind Turbine  ----------
        % WindTurbineData_IEA15MW('logical_instance_22');        
    end



    % -------- Receiving actual signals or initial values ​​from sensors --------
    who.OmegaR_measured = 'Rotor Speed Measured at the output of the drive-train, in [rad/s]';
    s.OmegaR_measured = max( interp1(s.Vop, s.OmegaR_op, s.Vews) , min(s.OmegaR_op) ) ;
    who.OmegaG_measured = 'Generator Speed Measured at the output of the drive-train, in [rad/s]';
    s.OmegaG_measured = max( s.OmegaR_measured*s.eta_gb , min(s.OmegaR_op*s.eta_gb) ) ;   
    who.Beta_measured = 'Collective Blade Pitch Measured at the blade pitch actuator system output (control output), in [deg]';
    s.Beta_measured = max( interp1(s.Vop, s.Beta_op, s.Vews) , min(s.Beta_op) ) ; 
    who.Tg_measured = 'Generator Torque Measured at the output of the generator/converter system, in [N.m]';
    s.Tg_measured = max( interp1(s.Vop, s.Tg_op, s.Vews) , min(s.Tg_op) ) ; 
    who.Pe_measured = 'Electrical Power Measured at the output of the Energy Converter, in [W]';
    s.Pe_measured = max( ( (s.Tg_measured/s.eta_gb)*s.OmegaG_measured* s.etaElec_op) , min(s.Pe_op) ) ;
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';
    s.WindSpedd_hub_measured = max(  s.WindSpeed_Hub(1) , 0.1 ) ; 
   
    who.Surge_measured = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge_measured = s.Surge ;     
    who.Surge_dot_measured = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot_measured = s.Surge_dot ;       
    who.Surge_Ddot_measured = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot_measured = s.Surge_Ddot ; 
    who.Sway_measured = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway_measured = s.Sway ; 
    who.Sway_dot_measured = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot_measured = s.Sway_dot ;     
    who.Sway_Ddot_measured = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sway_Ddot_measured = s.Sway_Ddot ;      
    who.Heave_measured = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave_measured = s.Heave ; 
    who.Heave_dot_measured = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot_measured = s.Heave_dot ;     
    who.Heave_Ddot_measured = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot_measured = s.Heave_Ddot ;
    who.RollAngle_measured = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle_measured = s.RollAngle ; 
    who.RollAngle_dot_measured = 'Measurement of Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot_measured = s.RollAngle_dot ; 
    who.RollAngle_Ddot_measured = 'Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
    s.RollAngle_Ddot_measured = s.RollAngle_Ddot ; 
    who.PitchAngle_measured = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad].';
    s.PitchAngle_measured = s.PitchAngle ;     
    who.PitchAngle_dot_measured = 'Measurement of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot_measured = s.PitchAngle_dot ;
    who.PitchAngle_Ddot_measured = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    s.PitchAngle_Ddot_measured = s.PitchAngle_Ddot ;
    who.YawAngle_measured = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle_measured = s.YawAngle ;     
    who.YawAngle_dot_measured = 'Measurement of Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot_measured = s.YawAngle_dot ;
    who.YawAngle_Ddot_measured = 'Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
    s.YawAngle_Ddot_measured = s.YawAngle_Ddot ;

    who.Xt_measured = 'Tower-Top Fore-Aft Position displacement Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_measured = s.Xt ;
    who.Xt_dot_measured = 'Tower-Top Fore-Aft Velocity Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_dot_measured = s.Xt_dot ;    
    who.Xt_Ddot_measured = 'Tower-Top Fore-Aft Acceleration Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_Ddot_measured = s.Xt_Ddot ;


    % -------- Updating Effective Wind Speed Values --------    
    who.VCsi= 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
    s.VCsi =  s.Xt_dot_measured ;    
    who.Vews = 'Effective Wind Speed ​​with spatial and relative motion effects, in [m/s].';          
    s.Vews = s.Uews - s.VCsi;


    % Organizing output results
    Wind_IEC614001_1.dt = s.dt; Wind_IEC614001_1.Ns = s.Ns; 

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % ---##### Offline values (know values) #####-------
    if s.Option01f1 == 1
        % Gain-Scheduling Proportional-Integral (PI) controller and TSR algorithm, by Abbas (2022)
        PIGainScheduledTSR_Abbas2022('logical_instance_02');

        if s.Option02f1 == 1
            % Observer State (Kalman Filter)
            EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_02');
        else
            % Observer State (Extended Kalman Filter)
            ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_02');
        end
        %
    else
        % Gain-Scheduling Proportional-Integral (PI) controller and the OT algorithm, by Jonkman (2009)
        PIGainScheduledOTC_Jonkman2009('logical_instance_02'); 
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


    % Calling the next logic instance    
    WindTurbineData_IEA15MW('logical_instance_22');


%=============================================================
elseif strcmp(action, 'logical_instance_17')
%==================== LOGICAL INSTANCE 17 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA SPAR BUOY PLATFORM BY BETTI, 2012 (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of a Spar Buoy floating platform type, assembly on
    % a NREL-5MW reference baseline wind turbine. The modeling of this 
    % structure follows the paper titled "Modeling and Control of a 
    % Floating Wind Turbine with Spar Buoy Platform", 2012, by authors G. 
    % Betti, M. Farina, A. Marzorati and R. Scattolini.


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_02');
   

    % ############## Ocean Wave Generation Model ################
    System_WavesCurrentsIEC614001_3('logical_instance_02');


    % ################ Wave Kinematics Model ####################    
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_03');


    % -------- Initial conditions for Platform --------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';    
    s.y = zeros(1,26) ;
    who.dy = 'First time derivative of the state variables.';  
    s.dy = zeros(1,26) ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = interp1(s.Vop, s.Beta_op, s.Vews) ;     
    who.Cp = 'Power coefficient at the current operating point';
    s.Cp = interp1(s.Vop, s.CP_op, s.Vews) ;
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Vews) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_04');



    % -------- Update of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.Surge_dot + s.dt*s.Surge_Ddot ;
    s.y(16) = s.Surge_dot ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.Surge + s.dt*s.Surge_dot ; 
    s.y(15) = s.Surge ;

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.Sway_dot + s.dt*s.Sway_Ddot ;
    s.y(18) = s.Sway_dot ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.Sway + s.dt*s.Sway_dot ; 
    s.y(17) = s.Sway ;

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.Heave_dot + s.dt*s.Heave_Ddot ; 
    s.y(20) = s.Heave_dot ;
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.Heave + s.dt*s.Heave_dot ;  
    s.y(19) = s.Heave ;
     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.RollAngle_dot + s.dt*s.RollAngle_Ddot ;  
    s.y(22) = s.RollAngle_dot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.RollAngle + s.dt*s.RollAngle_dot ; 
    s.y(21) = s.RollAngle;
    who.Gama_RollAngle = 'Roll angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Sway) and in [rad].';
    if s.RollAngle == 0
        s.Gama_RollAngle = pi/2 ;
        s.Cosseno_RollAngle = 1;
        s.Sine_RollAngle = 0;
    else
        s.Cosseno_RollAngle = sin(pi/2 - s.RollAngle) ;
        s.Sine_RollAngle = -cos(pi/2 - s.RollAngle) ;
        s.Gama_RollAngle = pi/2 + s.RollAngle ;   
    end

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.PitchAngle_dot + s.dt*s.PitchAngle_Ddot ;
    s.y(24) = s.PitchAngle_dot ;     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';
    s.PitchAngle = s.PitchAngle + s.dt*s.PitchAngle_dot ;
    s.y(23) = s.PitchAngle ;
    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Gama_PitchAngle = pi/2 +  s.PitchAngle ;          
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;          
    end

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.YawAngle_dot + s.dt*s.YawAngle_Ddot ; 
    s.y(26) = s.YawAngle_dot ;
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.YawAngle + s.dt*s.YawAngle_dot ;
    s.y(25) = s.YawAngle ;
    who.Gama_YawAngle = 'Yaw angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Heave) and in [rad].';
    if (s.YawAngle == 0)
        s.Gama_YawAngle = pi/2 ;
        s.Cosseno_YawAngle = 1;
        s.Sine_YawAngle = 0;
    else
        s.Cosseno_YawAngle = sin(pi/2 - s.YawAngle) ;
        s.Sine_YawAngle = -cos(pi/2 - s.YawAngle) ;
        s.Gama_YawAngle = pi/2 + s.YawAngle ;        
    end


    % -------- Update of Platform/Tower Top movement values --------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot ;    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot; 


    % ------ Actual Wind speed at hub height ----------       
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';    
    s.WindSpedd_hub_measured = s.WindSpeed_Hub(1) ;
    s.WindSpedd_hub_measured = s.WindSpedd_hub_measured - s.Xt_dot ;
    s.WindSpedd_hub_measured = max( s.WindSpedd_hub_measured, 0.1 ) ;
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = s.WindSpedd_hub_measured ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


%=============================================================
elseif strcmp(action, 'logical_instance_18')
%==================== LOGICAL INSTANCE 18 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA - SPAR BUOY PLATFORM (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of a Spar Buoy floating platform type, assembly on
    % a NREL-5MW reference baseline wind turbine.
    

    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_02');


    % ############## Ocean Wave Generation Model ################
    System_WavesCurrentsIEC614001_3('logical_instance_02');


    % ################ Wave Kinematics Model ####################    
    WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_03');


    % -------- Initial conditions for Platform --------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';    
    s.y = zeros(1,26) ;
    s.dy = zeros(1,26) ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = interp1(s.Vop, s.Beta_op, s.Vews) ;     
    who.Cp = 'Power coefficient at the current operating point';
    s.Cp = interp1(s.Vop, s.CP_op, s.Vews) ;
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Vews) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_04');


    % -------- Update of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.Surge_dot + s.dt*s.Surge_Ddot ;
    s.y(16) = s.Surge_dot ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.Surge + s.dt*s.Surge_dot ; 
    s.y(15) = s.Surge ;

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.Sway_dot + s.dt*s.Sway_Ddot ;
    s.y(18) = s.Sway_dot ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.Sway + s.dt*s.Sway_dot ; 
    s.y(17) = s.Sway ;

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.Heave_dot + s.dt*s.Heave_Ddot ; 
    s.y(20) = s.Heave_dot ;
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.Heave + s.dt*s.Heave_dot ;  
    s.y(19) = s.Heave ;
     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.RollAngle_dot + s.dt*s.RollAngle_Ddot ;  
    s.y(22) = s.RollAngle_dot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.RollAngle + s.dt*s.RollAngle_dot ; 
    s.y(21) = s.RollAngle;
    who.Gama_RollAngle = 'Roll angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Sway) and in [rad].';
    if s.RollAngle == 0
        s.Gama_RollAngle = pi/2 ;
        s.Cosseno_RollAngle = 1;
        s.Sine_RollAngle = 0;
    else
        s.Cosseno_RollAngle = sin(pi/2 - s.RollAngle) ;
        s.Sine_RollAngle = -cos(pi/2 - s.RollAngle) ;
        s.Gama_RollAngle = pi/2 + s.RollAngle ;   
    end

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.PitchAngle_dot + s.dt*s.PitchAngle_Ddot ;
    s.y(24) = s.PitchAngle_dot ;     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';
    s.PitchAngle = s.PitchAngle + s.dt*s.PitchAngle_dot ;
    s.y(23) = s.PitchAngle ;
    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Gama_PitchAngle = pi/2 +  s.PitchAngle ;          
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;          
    end

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.YawAngle_dot + s.dt*s.YawAngle_Ddot ; 
    s.y(26) = s.YawAngle_dot ;
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.YawAngle + s.dt*s.YawAngle_dot ;
    s.y(25) = s.YawAngle ;
    who.Gama_YawAngle = 'Yaw angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Heave) and in [rad].';
    if (s.YawAngle == 0)
        s.Gama_YawAngle = pi/2 ;
        s.Cosseno_YawAngle = 1;
        s.Sine_YawAngle = 0;
    else
        s.Cosseno_YawAngle = sin(pi/2 - s.YawAngle) ;
        s.Sine_YawAngle = -cos(pi/2 - s.YawAngle) ;
        s.Gama_YawAngle = pi/2 + s.YawAngle ;        
    end


    % -------- Update of Platform/Tower Top movement values --------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot ;    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot; 


    % ------ Actual Wind speed at hub height ----------       
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';    
    s.WindSpedd_hub_measured = s.WindSpeed_Hub(1) ;
    s.WindSpedd_hub_measured = s.WindSpedd_hub_measured - s.Xt_dot ;
    s.WindSpedd_hub_measured = max( s.WindSpedd_hub_measured, 0.1 ) ;
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = s.WindSpedd_hub_measured ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


%=============================================================
elseif strcmp(action, 'logical_instance_19')
%==================== LOGICAL INSTANCE 19 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA - SUBMERSIBLE PLATFORM (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of a Submersible floating platform type, assembly on
    % a NREL-5MW reference baseline wind turbine.
    

    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_Submersible('logical_instance_02');


    % ############## Ocean Wave Generation Model ################
    System_WavesCurrentsIEC614001_3('logical_instance_02');


    % ################ Wave Kinematics Model ####################    
    WindTurbine_OffshoreAssembly_Submersible('logical_instance_03');


    % -------- Initial conditions for Platform --------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';    
    s.y = zeros(1,26) ;
    s.dy = zeros(1,26) ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = interp1(s.Vop, s.Beta_op, s.Vews) ;     
    who.Cp = 'Power coefficient at the current operating point';
    s.Cp = interp1(s.Vop, s.CP_op, s.Vews) ;
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Vews) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_Submersible('logical_instance_04');


    % -------- Update of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.Surge_dot + s.dt*s.Surge_Ddot ;
    s.y(16) = s.Surge_dot ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.Surge + s.dt*s.Surge_dot ; 
    s.y(15) = s.Surge ;

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.Sway_dot + s.dt*s.Sway_Ddot ;
    s.y(18) = s.Sway_dot ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.Sway + s.dt*s.Sway_dot ; 
    s.y(17) = s.Sway ;

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.Heave_dot + s.dt*s.Heave_Ddot ; 
    s.y(20) = s.Heave_dot ;
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.Heave + s.dt*s.Heave_dot ;  
    s.y(19) = s.Heave ;
     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.RollAngle_dot + s.dt*s.RollAngle_Ddot ;  
    s.y(22) = s.RollAngle_dot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.RollAngle + s.dt*s.RollAngle_dot ; 
    s.y(21) = s.RollAngle;
    who.Gama_RollAngle = 'Roll angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Sway) and in [rad].';
    if s.RollAngle == 0
        s.Gama_RollAngle = pi/2 ;
        s.Cosseno_RollAngle = 1;
        s.Sine_RollAngle = 0;
    else
        s.Cosseno_RollAngle = sin(pi/2 - s.RollAngle) ;
        s.Sine_RollAngle = -cos(pi/2 - s.RollAngle) ;
        s.Gama_RollAngle = pi/2 + s.RollAngle ;   
    end

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.PitchAngle_dot + s.dt*s.PitchAngle_Ddot ;
    s.y(24) = s.PitchAngle_dot ;     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';
    s.PitchAngle = s.PitchAngle + s.dt*s.PitchAngle_dot ;
    s.y(23) = s.PitchAngle ;
    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Gama_PitchAngle = pi/2 +  s.PitchAngle ;          
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;          
    end

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.YawAngle_dot + s.dt*s.YawAngle_Ddot ; 
    s.y(26) = s.YawAngle_dot ;
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.YawAngle + s.dt*s.YawAngle_dot ;
    s.y(25) = s.YawAngle ;
    who.Gama_YawAngle = 'Yaw angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Heave) and in [rad].';
    if (s.YawAngle == 0)
        s.Gama_YawAngle = pi/2 ;
        s.Cosseno_YawAngle = 1;
        s.Sine_YawAngle = 0;
    else
        s.Cosseno_YawAngle = sin(pi/2 - s.YawAngle) ;
        s.Sine_YawAngle = -cos(pi/2 - s.YawAngle) ;
        s.Gama_YawAngle = pi/2 + s.YawAngle ;        
    end


    % -------- Update of Platform/Tower Top movement values --------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot ;    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot; 


    % ------ Actual Wind speed at hub height ----------       
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';    
    s.WindSpedd_hub_measured = s.WindSpeed_Hub(1) ;
    s.WindSpedd_hub_measured = s.WindSpedd_hub_measured - s.Xt_dot ;
    s.WindSpedd_hub_measured = max( s.WindSpedd_hub_measured, 0.1 ) ;
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = s.WindSpedd_hub_measured ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


%=============================================================
elseif strcmp(action, 'logical_instance_20')
%==================== LOGICAL INSTANCE 20 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA - BARGE PLATFORM (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of a Barge floating platform type, assembly on
    % a NREL-5MW reference baseline wind turbine.
    

    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_Barge('logical_instance_02');


    % ############## Ocean Wave Generation Model ################
    System_WavesCurrentsIEC614001_3('logical_instance_02');


    % ################ Wave Kinematics Model ####################    
    WindTurbine_OffshoreAssembly_Barge('logical_instance_03');


    % -------- Initial conditions for Platform --------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';    
    s.y = zeros(1,26) ;
    s.dy = zeros(1,26) ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = interp1(s.Vop, s.Beta_op, s.Vews) ;     
    who.Cp = 'Power coefficient at the current operating point';
    s.Cp = interp1(s.Vop, s.CP_op, s.Vews) ;
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Vews) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_Barge('logical_instance_04'); 


    % -------- Update of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.Surge_dot + s.dt*s.Surge_Ddot ;
    s.y(16) = s.Surge_dot ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.Surge + s.dt*s.Surge_dot ; 
    s.y(15) = s.Surge ;

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.Sway_dot + s.dt*s.Sway_Ddot ;
    s.y(18) = s.Sway_dot ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.Sway + s.dt*s.Sway_dot ; 
    s.y(17) = s.Sway ;

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.Heave_dot + s.dt*s.Heave_Ddot ; 
    s.y(20) = s.Heave_dot ;
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.Heave + s.dt*s.Heave_dot ;  
    s.y(19) = s.Heave ;
     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.RollAngle_dot + s.dt*s.RollAngle_Ddot ;  
    s.y(22) = s.RollAngle_dot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.RollAngle + s.dt*s.RollAngle_dot ; 
    s.y(21) = s.RollAngle;
    who.Gama_RollAngle = 'Roll angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Sway) and in [rad].';
    if s.RollAngle == 0
        s.Gama_RollAngle = pi/2 ;
        s.Cosseno_RollAngle = 1;
        s.Sine_RollAngle = 0;
    else
        s.Cosseno_RollAngle = sin(pi/2 - s.RollAngle) ;
        s.Sine_RollAngle = -cos(pi/2 - s.RollAngle) ;
        s.Gama_RollAngle = pi/2 + s.RollAngle ;   
    end

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.PitchAngle_dot + s.dt*s.PitchAngle_Ddot ;
    s.y(24) = s.PitchAngle_dot ;     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';
    s.PitchAngle = s.PitchAngle + s.dt*s.PitchAngle_dot ;
    s.y(23) = s.PitchAngle ;
    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Gama_PitchAngle = pi/2 +  s.PitchAngle ;          
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;          
    end

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.YawAngle_dot + s.dt*s.YawAngle_Ddot ; 
    s.y(26) = s.YawAngle_dot ;
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.YawAngle + s.dt*s.YawAngle_dot ;
    s.y(25) = s.YawAngle ;
    who.Gama_YawAngle = 'Yaw angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Heave) and in [rad].';
    if (s.YawAngle == 0)
        s.Gama_YawAngle = pi/2 ;
        s.Cosseno_YawAngle = 1;
        s.Sine_YawAngle = 0;
    else
        s.Cosseno_YawAngle = sin(pi/2 - s.YawAngle) ;
        s.Sine_YawAngle = -cos(pi/2 - s.YawAngle) ;
        s.Gama_YawAngle = pi/2 + s.YawAngle ;        
    end


    % -------- Update of Platform/Tower Top movement values --------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot ;    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot; 


    % ------ Actual Wind speed at hub height ----------       
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';    
    s.WindSpedd_hub_measured = s.WindSpeed_Hub(1) ;
    s.WindSpedd_hub_measured = s.WindSpedd_hub_measured - s.Xt_dot ;
    s.WindSpedd_hub_measured = max( s.WindSpedd_hub_measured, 0.1 ) ;
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = s.WindSpedd_hub_measured ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);


%=============================================================
elseif strcmp(action, 'logical_instance_21')
%==================== LOGICAL INSTANCE 21 ====================
%=============================================================    
    % IEA-15MW OFFSHORE ASSEMBLY DATA - BOTTOM FIXED WIND TURBINE (OFFLINE):
    % Purpose of this Logical Instance: to represent the data and 
    % characteristics of an offshore Bottom Fixed wind turbine structure,
    % assembly on a NREL-5MW reference baseline wind turbine.
    

    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_02');    


    % ############## Ocean Wave Generation Model ################
    System_WavesCurrentsIEC614001_3('logical_instance_02');


    % ################ Wave Kinematics Model ####################    
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_03');


    % -------- Initial conditions for Platform --------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';    
    s.y = zeros(1,26) ;
    s.dy = zeros(1,26) ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.Beta = interp1(s.Vop, s.Beta_op, s.Vews) ;     
    who.Cp = 'Power coefficient at the current operating point';
    s.Cp = interp1(s.Vop, s.CP_op, s.Vews) ;
    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Vews) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % ###### Offline values ​​of the platform movement model ######    
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_04'); 

    
    % -------- Update of Platform/Tower Top movement values --------
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.Surge_dot + s.dt*s.Surge_Ddot ;
    s.y(16) = s.Surge_dot ;
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.Surge + s.dt*s.Surge_dot ; 
    s.y(15) = s.Surge ;

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.Sway_dot + s.dt*s.Sway_Ddot ;
    s.y(18) = s.Sway_dot ;
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.Sway + s.dt*s.Sway_dot ; 
    s.y(17) = s.Sway ;

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.Heave_dot + s.dt*s.Heave_Ddot ; 
    s.y(20) = s.Heave_dot ;
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.Heave + s.dt*s.Heave_dot ;  
    s.y(19) = s.Heave ;
     
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.RollAngle_dot + s.dt*s.RollAngle_Ddot ;  
    s.y(22) = s.RollAngle_dot ;
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.RollAngle + s.dt*s.RollAngle_dot ; 
    s.y(21) = s.RollAngle;
    who.Gama_RollAngle = 'Roll angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Sway) and in [rad].';
    if s.RollAngle == 0
        s.Gama_RollAngle = pi/2 ;
        s.Cosseno_RollAngle = 1;
        s.Sine_RollAngle = 0;
    else
        s.Cosseno_RollAngle = sin(pi/2 - s.RollAngle) ;
        s.Sine_RollAngle = -cos(pi/2 - s.RollAngle) ;
        s.Gama_RollAngle = pi/2 + s.RollAngle ;   
    end

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.PitchAngle_dot + s.dt*s.PitchAngle_Ddot ;
    s.y(24) = s.PitchAngle_dot ;     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';
    s.PitchAngle = s.PitchAngle + s.dt*s.PitchAngle_dot ;
    s.y(23) = s.PitchAngle ;
    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Gama_PitchAngle = pi/2 +  s.PitchAngle ;          
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;          
    end

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.YawAngle_dot + s.dt*s.YawAngle_Ddot ; 
    s.y(26) = s.YawAngle_dot ;
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.YawAngle + s.dt*s.YawAngle_dot ;
    s.y(25) = s.YawAngle ;
    who.Gama_YawAngle = 'Yaw angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Heave) and in [rad].';
    if (s.YawAngle == 0)
        s.Gama_YawAngle = pi/2 ;
        s.Cosseno_YawAngle = 1;
        s.Sine_YawAngle = 0;
    else
        s.Cosseno_YawAngle = sin(pi/2 - s.YawAngle) ;
        s.Sine_YawAngle = -cos(pi/2 - s.YawAngle) ;
        s.Gama_YawAngle = pi/2 + s.YawAngle ;        
    end


    % -------- Update of Platform/Tower Top movement values --------
    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle;     
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot ;    
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';
    s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot; 


    % ------ Actual Wind speed at hub height ----------       
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';    
    s.WindSpedd_hub_measured = s.WindSpeed_Hub(1) ;
    s.WindSpedd_hub_measured = s.WindSpedd_hub_measured - s.Xt_dot ;
    s.WindSpedd_hub_measured = max( s.WindSpedd_hub_measured, 0.1 ) ;
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = s.WindSpedd_hub_measured ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);
    

%=============================================================
elseif strcmp(action, 'logical_instance_22')
%==================== LOGICAL INSTANCE 22 ====================
%=============================================================    
    % IEA-15MW MAIN ASSEMBLY DATA (OFFLINE):
    % Purpose of this Logical Instance: to obtain the known and initial 
    % values ​​of the dynamics of the wind turbine Main Assemblies components,
    % such as Drive Train, Controller System, Power System, Blades, 
    % Tower, Nacelle, etc.
    

    % ###### Call other Recursive Function ######
    WindTurbine_MainAssembly('logical_instance_02'); 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbine_data', WindTurbine_data);

    
    % Returns to "WindTurbine('logical_instance_02')" when s.Option02f2 == 1.  


%=============================================================  
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'WindTurbine_data', WindTurbine_data);


% #######################################################################
end