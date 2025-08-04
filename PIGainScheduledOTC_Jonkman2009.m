function PIGainScheduledOTC_Jonkman2009(action)
% ########## CONTROL SYSTEM AND ITS ACTUATORS - JONKMAN-2009 APPROACH ##########
% ##############################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Oceanic 
% Engineering in 2025. Reviewed and supervised by Professor Dr. Helio 
% Mitio Morishita. Code developed in Matlab 2022b.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains the approach related to the control
% system and its actuators, presented in the author Jonkman's thesis, published (2009).




% ---------- Global Variables and Structures Array ----------
global s who t it SimulationEnvironment WindTurbine_data Sensor WindTurbineOutput MeasurementCovariances ProcessCovariances BladePitchSystem GeneratorTorqueSystem PowerGeneration DriveTrainDynamics TowerDynamics RotorDynamics NacelleDynamics OffshoreAssembly AerodynamicModels BEM_Theory Wind_IEC614001_1 Waves_IEC614001_3 Currents_IEC614001_3 GeneratorTorqueController BladePitchController PIGainScheduledOTC PIGainScheduledOTC KalmanFilter ExtendedKalmanFilter



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
    assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);  
    assignin('base', 'KalmanFilter', KalmanFilter);  
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);  
    %   
    action = 'logical_instance_01';
end



if strcmp(action, 'logical_instance_01')
%==================== LOGICAL INSTANCE 01 ====================
%=============================================================
    % DESIGN CHOICES, HYPOTHESES AND THEIR OPTIONS:    
    % Purpose of this Logical Instance: to define the option choices 
    % related to this recursive function "PIGainScheduledOTC_Jonkman2009.m". 
    

    % ---------- Option 01: Steady-State Operation Strategy Selection ----------
    who.Option01f8.Option_01 = 'Option 01 of Recursive Function f8';
    who.Option01f8.about = 'Steady-State Operation Strategy Selection.';
    who.Option01f8.choose_01 = 'Option01f8 == 1 to choose STRATEGY 1 (Figure 2 from Abbas, 2022).';
    who.Option01f8.choose_02 = 'Option01f8 == 2 to choose STRATEGY 2 (Peak Shaving).';
    who.Option01f8.choose_03 = 'Option01f8 == 3 to choose STRATEGY 3 (Figure 7.2 from Jonkman, 2009).';      
        % Choose your option:
    s.Option01f8 = 3; 
    if s.Option01f8 == 1 || s.Option01f8 == 2 || s.Option01f8 == 3
        GeneratorTorqueController.Option01f8 = s.Option01f8;
        BladePitchController.Option01f8 = s.Option01f8;   
        PIGainScheduledOTC.Option01f8 = s.Option01f8;           
    else
        error('Invalid option selected for s.Option01f8. Please choose 1 or 2 or 3.');
    end


    % ---------- Option 02: Selection of Drivetrain Dynamics Signals ----------
    who.Option02f8.Option_02 = 'Option 02 of Recursive Function f8';
    who.Option02f8.about = 'Selection of Drivetrain Dynamics Signals (OmegaR, OmegaG, Beta, Tg).';
    who.Option02f8.choose_01 = 'Option02f8 == 1 to choose use All Signals (OmegaR, OmegaF, Beta, Tg) from the 1st Order Low Pass Filter (LPF1).'; 
    who.Option02f8.choose_02 = 'Option02f8 == 2 to choose use "Vews_est" and "OmegaR_est" by the State Observer and the other signals from the 1st Order Low Pass Filter (LPF1).';            
        % Choose your option:
    s.Option02f8 = 1; 
    if s.Option02f8 == 1 || s.Option02f8 == 2  || s.Option02f8 == 3
        GeneratorTorqueController.Option02f8 = s.Option02f8;
        BladePitchController.Option02f8 = s.Option02f8;    
        PIGainScheduledOTC.Option02f8 = s.Option02f8;          
    else
        error('Invalid option selected for s.Option02f8. Please choose 1 or 2 or 3.');
    end
  % 


    % ------- Option 03: Selection of Tower-Top Dynamics Signals ----------
    who.Option03f8.Option_03 = 'Option 03 of Recursive Function f8';
    who.Option03f8.about = 'Selection of Tower-Top Dynamics Signals (Xt_Ddot and SurgeDDot, SwayDDot, HeaveDDot, RollDot, PitchDot, YawDot, etc).';
    who.Option03f8.choose_01 = 'Option03f8 == 1 to choose use the filtered signals as Abbas (2022) suggests: by 2nd Order Low Pass Filter, by 1st Order High Pass Filter and Notch Filter.';
    who.Option03f8.choose_02 = 'Option03f8 == 2 to choose use only a 2nd Order Low Pass Filter.';  
        % Choose your option:
    s.Option03f8 = 1; 
    if s.Option03f8 == 1 || s.Option03f8 == 2
        PIGainScheduledOTC.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';
        BladePitchController.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';        
        % WARNING!!! For onshore wind turbine, this option only makes sense if the option
         % "s.Option04f3 == 1" is selected in the Matlab file
         % "WindTurbine('logical_instance_01');"

        GeneratorTorqueController.Option03f8 = s.Option03f8;
        BladePitchController.Option03f8 = s.Option03f8;             
        PIGainScheduledOTC.Option03f8 = s.Option03f8;          
    else
        error('Invalid option selected for s.Option03f8. Please choose 1 or 2.');
    end  


    % ------ Option 04: Compensation Strategy Options ----------
    who.Option04f8.Option_04 = 'Option 04 of Recursive Function f8';
    who.Option04f8.about = 'Compensation Strategy to Avoid Negative Damping or Active Tower Damping Options';
    who.Option04f8.choose_01 = 'Option04f8 == 1 to choose Consider Active Tower Damping with a Tower Top feedback compensation strategy (K*X_dot_filtered) in the Collective Blade Pitch controller.';
    who.Option04f8.choose_02 = 'Option04f8 == 2 to choose Consider Pitch Plataform feedback compensation strategy (K*Pitch_dot_filtered) in the Collective Blade Pitch controller.';
    who.Option04f8.choose_03 = 'Option04f8 == 3 to choose DO NOT consider Active Tower Damping';    
        % Choose your option:
    s.Option04f8 = 1; 
    if s.Option04f8 == 1 || s.Option04f8 == 2 || s.Option04f8 == 3
        PIGainScheduledOTC.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';
        BladePitchController.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';        
        % WARNING!!! This option only makes sense if the option
         % "s.Option04f3 == 1" is selected in the Matlab file
         % "WindTurbine('logical_instance_01');"
        
         if s.Option02f2 == 1
             % ONSHORE WIND TURBINE
             if s.Option04f3 == 2
                 % NOT consider the Tower Dynamic
                 s.Option04f8 = 3;
             end
         else
             % OFFSHORE WIND TURBINE 
             if s.Option04f8 == 1
                 s.Option04f8 = 3;
             end
         end
        GeneratorTorqueController.Option04f8= s.Option04f8;
        BladePitchController.Option04f8 = s.Option04f8;  
        PIGainScheduledOTC.Option04f8 = s.Option04f8;          
    else
        error('Invalid option selected for s.Option04f8. Please choose 1 or 2.');
    end   


    % ---------- Option 05: Plot wind turbine performance in Steady-State ----------
    who.Option05f8.Option_05 = 'Option 05 of Recursive Function f8';
    who.Option05f8.about = 'Plot wind turbine performance results, in steady state and according to a control or operating strategy.';
    who.Option05f8.choose_01 = 'Option05f8 == 1 to choose DO NOT plot wind turbine performance figures in steady-state operation.';
    who.Option05f8.choose_02 = 'Option05f8 == 2 to choose PLOT THE MAIN FIGURES of wind turbine performance in steady state operation.';
    who.Option05f8.choose_03 = 'Option05f8 == 3 to choose Plot ALL FIGURES of wind turbine performance in steady state operation.';
        % Choose your option:
    s.Option05f8 = 1; 
    if s.Option05f8 == 1 || s.Option05f8 == 2 || s.Option05f8 == 3
        GeneratorTorqueController.Option05f8 = s.Option05f8;
        BladePitchController.Option05f8 = s.Option05f8;        
        PIGainScheduledOTC.Option05f8 = s.Option05f8;            
    else
        error('Invalid option selected for s.Option05f8. Please choose 1 or 2 or 3.');
    end
  % 


    % ----- Option 06: Option for Gain Scheduling Correction Factor ----------
    who.Option06f8.Option_06 = 'Option 06 of Recursive Function f8';
    who.Option06f8.about = 'Gain Scheduling Correction Factor. According to Jonkman (page 57), it is the Blade Pitch angle corresponding to twice the Pitch Sensitivity calculated at the nominal point.';
    who.Option06f8.choose_01 = 'Option06f8 == 1 to choose use the Blade Pitch calculated in this code.';
    who.Option06f8.choose_02 = 'Option06f8 == 2 to choose use the value suggested by Jonkman/FAST (0.1099965 [rad]).';   
        % Choose your option:
    s.Option06f8 = 1; 
    if s.Option06f8 == 1 || s.Option06f8 == 2 
        GeneratorTorqueController.Option06f8= s.Option06f8;
        BladePitchController.Option06f8 = s.Option06f8;  
        PIGainScheduledOTC.Option06f8 = s.Option06f8;          
    else
        error('Invalid option selected for s.Option06f8. Please choose 1 or 2.');
    end 
    %


     % ---------- Option 07: Plot control results ----------
    who.Option07f8.Option_07 = 'Option 07 of Recursive Function f8';
    who.Option07f8.about = 'Consider a dynamic in the delay or not for Blade Step, in rate saturation.';
    who.Option07f8.choose_01 = 'Option07f8 == 1 choose to NOT consider the Blade Pitch dynamics, assuming that the blade pitch as relatively fast (Beta = Beta_d) in Rate Saturation.';
    who.Option07f8.choose_02 = 'Option07f8 == 2 choose Electromechanical Blade Pitch Systems (first-order model - delay behavior).';
        % Choose your option:
    s.Option07f8 = 1; 
    if s.Option07f8 == 1 || s.Option07f8 == 2
        if s.Option01f3 == 2 || s.Option01f3 == 3
            % Consider the Blade Pitch dynamics in system (wind turbine)
            s.Option10f8 = 2;
        end        
        GeneratorTorqueController.Option07f8= s.Option07f8;
        BladePitchController.Option07f8 = s.Option07f8;  
        PIGainScheduledOTC.Option07f8 = s.Option07f8;          
    else
        error('Invalid option selected for s.Option07f8. Please choose 1 or 2.');
    end 
    % 


    % ---------- Option 08: Plot control results ----------
    who.Option08f8.Option_08 = 'Option 08 of Recursive Function f8';
    who.Option08f8.about = 'Plot control results';
    who.Option08f8.choose_01 = 'Option08f8 == 1 choose DO NOT plot control results (simulation).';
    who.Option08f8.choose_02 = 'Option08f8 == 2 choose PLOT THE MAIN FIGURES of control results (simulation).';
    who.Option08f8.choose_03 = 'Option08f8 == 3 to choose Plot ALL FIGURES of control results (simulation).';    
        % Choose your option:
    s.Option08f8 = 2; 
    if s.Option08f8 == 1 || s.Option08f8 == 2 || s.Option08f8 == 3
        GeneratorTorqueController.Option08f8= s.Option08f8;
        BladePitchController.Option08f8 = s.Option08f8;  
        PIGainScheduledOTC.Option08f8 = s.Option08f8;          
    else
        error('Invalid option selected for s.Option08f8. Please choose 1 or 2 or 3.');
    end 
    % 



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);


    % Return to EnviromentSimulation('logical_instance_01');

    
elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES (OFFLINE) BASED ON CHOSEN OPTIONS:
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f8), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.



            %####### Controller Modules #######

    % ---------------- Controller Modules ------------------------------  
    who.Mode_GeneratorController = 'Generator Torque Controller Module.';    
    who.Mode_BladePitchController = 'Blade Pitch Controller Module.';    
    if (s.V_meanHub_0 >= s.Vws_Rated)
        s.Mode_GeneratorController = 0;
        s.Mode_GeneratorController_before = 0;
        s.Mode_BladePitchController = 1; 
        s.Mode_GeneratorController_before = 1;   
    else
        s.Mode_GeneratorController = 1;
        s.Mode_GeneratorController_before = 1;
        s.Mode_BladePitchController = 0; 
        s.Mode_GeneratorController_before = 0;        
    end



            %####### General Design Parameters #######

    % ---------- Sampling the Controllers ----------
    who.Sample_Frequency_c = 'Sampling the Controllers, in [Hz]';
    s.Sample_Frequency_c = 1; 

    who.Sample_Rate_c = 'Sampling the Controllers, in [s]';
    s.Sample_Rate_c = 1/s.Sample_Frequency_c; 
    

    % -- Sampling of the State Observer or Low-Pass, High-Pass Filters and others ----
    who.Sample_Frequency = 'Sampling for State Observer or Low-Pass, High-Pass Filters and in-between measurements, in [Hz].';
    s.Sample_Frequency = 1; 
    who.Sample_RateOS = 'Sampling for State Observer or Low-Pass, High-Pass Filters and in-between measurements, in [s]';
    s.Sample_RateOS = 1/s.Sample_Frequency;



    % ---------- Controller Design and Stability Analysis ----------
    who.OmegaNTg_Tab  = 'Desired Natural Vibration Frequency for Generator Torque Controller.';
    PIGainScheduledOTC.OmegaNTg_Tab = s.OmegaNTg_Tab;
    who.DampingCFactorTg_Tab  = 'Desired Critical Damping Factor for Generator Torque Controller.';
    PIGainScheduledOTC.DampingCFactorTg_Tab = s.DampingCFactorTg_Tab;   
    who.OmegaN_Beta  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
    PIGainScheduledOTC.OmegaN_Beta = s.OmegaNBeta_Tab;     
    who.DampingCFactor_Beta  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
    PIGainScheduledOTC.DampingCFactorBeta_Tab = s.DampingCFactorBeta_Tab; 



    % ---------- Cutoff Frequencies for Control Signals ----------      
    who.CutFreq_DriveTrain = 'Cutoff frequency for control signals, in [Hz] and used in drive train dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    PIGainScheduledOTC.CutFreq_DriveTrain = s.CutFreq_DriveTrain;
    who.CutFreq_TowerTop = 'Cutoff frequency for control signals, in [rad/s] and used in tower-top dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    PIGainScheduledOTC.CutFreq_TowerTop = s.CutFreq_TowerTop ;  
    who.CutFreq_OmegaNstructure = 'Cutoff natural Frequency of the Structure, in [Hz].';
    PIGainScheduledOTC.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure ; 
    who.CutFreq_TowerForeAft = 'Notch filter cutoff frequency and the the tower fore–af motion, in [rad/s].'; 
    PIGainScheduledOTC.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft ;  



            %####### Conntrol Strategies #######

    % ---------- Wind Turbine Control and Operation Strategy ----------
    PIGainScheduledOTC.Vop = s.Vop;
    PIGainScheduledOTC.OmegaR_op = s.OmegaR_op;
    PIGainScheduledOTC.Lambda_op = s.Lambda_op;
    PIGainScheduledOTC.Beta_op = s.Beta_op;
    PIGainScheduledOTC.Tg_op = s.Tg_op;  
    PIGainScheduledOTC.CP_op = s.CP_op;
    PIGainScheduledOTC.CQ_op = s.CQ_op;
    PIGainScheduledOTC.CT_op = s.CT_op;
    PIGainScheduledOTC.GradCpBeta_op = s.GradCpBeta_op;
    PIGainScheduledOTC.GradCpLambda_op = s.GradCpLambda_op;
    PIGainScheduledOTC.GradCtBeta_op = s.GradCtBeta_op;
    PIGainScheduledOTC.GradCtLambda_op = s.GradCtLambda_op;    
    PIGainScheduledOTC.Pa_op = s.Pa_op;   
    PIGainScheduledOTC.Ta_op = s.Ta_op;
    PIGainScheduledOTC.Fa_op = s.Fa_op;
    PIGainScheduledOTC.Pe_op = s.Pe_op;
    PIGainScheduledOTC.GradTaLambda_op = s.GradTaLambda_op;
    PIGainScheduledOTC.GradTaOmega_op = s.GradTaOmega_op;
    PIGainScheduledOTC.GradTaVop_op = s.GradTaVop_op;
    PIGainScheduledOTC.GradTaBeta_op = s.GradTaBeta_op;
    PIGainScheduledOTC.GradPaBeta_op = s.GradPaBeta_op;
    PIGainScheduledOTC.GradFaLambda_op = s.GradFaLambda_op;
    PIGainScheduledOTC.GradFaOmega_op = s.GradFaOmega_op;
    PIGainScheduledOTC.GradFaVop_op = s.GradFaVop_op;
    PIGainScheduledOTC.GradFaBeta_op = s.GradFaBeta_op;
    PIGainScheduledOTC.Lambda_op_opt = s.Lambda_op_opt;
    PIGainScheduledOTC.OmegaR_op_opt = s.OmegaR_op_opt;
    PIGainScheduledOTC.Beta_op_opt = s.Beta_op_opt;
    PIGainScheduledOTC.Ta_op_opt = s.Ta_op_opt;
    PIGainScheduledOTC.Pa_op_opt = s.Pa_op_opt;
    PIGainScheduledOTC.Indexop_Region1Region15 = s.Indexop_Region1Region15;
    PIGainScheduledOTC.Indexop_Region15Region2 = s.Indexop_Region15Region2;
    PIGainScheduledOTC.Indexop_Region2Region25 = s.Indexop_Region2Region25;
    PIGainScheduledOTC.Indexop_Region25Region3 = s.Indexop_Region25Region3;
    PIGainScheduledOTC.Indexop_Region3Region4 = s.Indexop_Region3Region4;
    PIGainScheduledOTC.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; 
    PIGainScheduledOTC.OmegaRop_Region25Region3 = s.OmegaRop_Region25Region3;
    %


            %####### Design Filters (LPF1, LPF2, HPF and NF) #######

    % ---------- Initial values ​​for LPF, HPF and NF Filters ----------    
    s.OutputsLPF1_filtered(1) = interp1(s.Vop, s.OmegaR_op, s.V_meanHub_0);
    s.OutputsLPF1_filtered(2) = s.OutputsLPF1_filtered(1,1) .* s.eta_gb ;   
    s.OutputsLPF1_filtered(3) = interp1(s.Vop, s.Beta_op, s.V_meanHub_0);
    s.OutputsLPF1_filtered(4) = interp1(s.Vop, s.Tg_op, s.V_meanHub_0);
    s.OutputsLPF1_filtered(5) = interp1(s.Vop, s.Pe_op, s.V_meanHub_0);
    s.OutputsLPF1_filtered(6) = s.V_meanHub_0;       
    s.OutputsLPF1_filtered_last = s.OutputsLPF1_filtered;


    s.OutputsLPF2B_filtered(1)  = 0;
    if s.Option02f2 > 1 
        % Offshore wind turbine
        s.OutputsLPF2B_filtered(2) = 0;   
        s.OutputsLPF2B_filtered(3) = 0;
        s.OutputsLPF2B_filtered(4) = 0;  
        s.OutputsLPF2B_filtered(5) = 0;   
        s.OutputsLPF2B_filtered(6) = 0;   
        s.OutputsLPF2B_filtered(7) = 0;             
    end        
    s.OutputsLPF2B_last = s.OutputsLPF2B_filtered;
    s.OutputsLPF2B_secondLast = s.OutputsLPF2B_last;
    s.OutputsHPF1_filtered = s.OutputsLPF2B_filtered;   
    s.OutputsHPF1_filtered_last = s.OutputsHPF1_filtered;

    s.Outputs_notched = s.OutputsLPF2B_filtered;
    s.Outputs_notched_Last = s.Outputs_notched;
    s.Outputs_notched_secondLast = s.Outputs_notched_Last;


    % ---------- Initial values ​​for the implementation of the Controllers  ----------    
    s.IntegTermPI_Tg = 0;
    s.IntegTermPI_Beta = 0;  
    s.Beta_d_before = interp1(s.Vop, s.Beta_op, s.V_meanHub_0) ;  
    s.Tg_d_before = interp1(s.Vop, s.Beta_op, s.V_meanHub_0) ;
    s.Pe_d_before = interp1(s.Vop, s.Pe_op, s.V_meanHub_0) ; 
    s.Xt_dot_Lastfiltered = 0;



    % ---------- Initial values ​​for the implementation of the Controllers  ----------    
    s.IntegTermPI_Tg = 0;
    s.IntegTermPI_Beta = 0;  
    s.Beta_d = interp1(s.Vop, s.Beta_op, s.V_meanHub_0) ;    
    s.Beta_d_before = s.Beta_d ; 
    s.Tg_d = interp1(s.Vop, s.Tg_op, s.V_meanHub_0) ;    
    s.Tg_d_before = s.Tg_d ;
    s.Pe_d_before = interp1(s.Vop, s.Pe_op, s.V_meanHub_0) ; 
    s.Xt_dot_Lastfiltered = 0;


    % Organizing output results   
    PIGainScheduledOTC.Mode_GeneratorController = s.Mode_GeneratorController; GeneratorTorqueController.Mode_GeneratorController = s.Mode_GeneratorController;
    PIGainScheduledOTC.Mode_BladePitchController = s.Mode_BladePitchController; BladePitchController.Mode_BladePitchController = s.Mode_BladePitchController;    
    PIGainScheduledOTC.Sample_Frequency_c = s.Sample_Frequency_c; PIGainScheduledOTC.Sample_Rate_c = s.Sample_Rate_c;     PIGainScheduledOTC.Sample_Frequency = s.Sample_Frequency; PIGainScheduledOTC.Sample_RateOS = s.Sample_RateOS;
    GeneratorTorqueController.Sample_Frequency_c = s.Sample_Frequency_c; GeneratorTorqueController.Sample_Rate_c = s.Sample_Rate_c;
    BladePitchController.Sample_Frequency_c = s.Sample_Frequency_c; BladePitchController.Sample_Rate_c = s.Sample_Rate_c;   

    BladePitchController.OmegaNBeta_Tab = s.OmegaNBeta_Tab;
    BladePitchController.DampingCFactorBeta_Tab = s.DampingCFactorBeta_Tab;
    GeneratorTorqueController.OmegaNTg_Tab = s.OmegaNTg_Tab;
    GeneratorTorqueController.DampingCFactorTg_Tab = s.DampingCFactorTg_Tab;

    GeneratorTorqueController.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure; BladePitchController.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure;
    GeneratorTorqueController.CutFreq_DriveTrain = s.CutFreq_DriveTrain; BladePitchController.CutFreq_DriveTrain = s.CutFreq_DriveTrain;
    GeneratorTorqueController.CutFreq_TowerTop = s.CutFreq_TowerTop; BladePitchController.CutFreq_TowerTop = s.CutFreq_TowerTop; 
    GeneratorTorqueController.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft; BladePitchController.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft;
    
    GeneratorTorqueController.Vop = s.Vop; GeneratorTorqueController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; GeneratorTorqueController.OmegaR_op = s.OmegaR_op; GeneratorTorqueController.Lambda_op = s.Lambda_op; GeneratorTorqueController.Beta_op = s.Beta_op; GeneratorTorqueController.Tg_op = s.Tg_op; GeneratorTorqueController.CP_op = s.CP_op; GeneratorTorqueController.CQ_op = s.CQ_op; GeneratorTorqueController.CT_op = s.CT_op; GeneratorTorqueController.GradCpBeta_op = s.GradCpBeta_op; GeneratorTorqueController.GradCpLambda_op = s.GradCpLambda_op; GeneratorTorqueController.GradCtBeta_op = s.GradCtBeta_op; GeneratorTorqueController.GradCtLambda_op = s.GradCtLambda_op; GeneratorTorqueController.Pa_op = s.Pa_op; GeneratorTorqueController.Ta_op = s.Ta_op; GeneratorTorqueController.Fa_op = s.Fa_op; GeneratorTorqueController.Pe_op = s.Pe_op; GeneratorTorqueController.GradTaLambda_op = s.GradTaLambda_op; GeneratorTorqueController.GradTaOmega_op = s.GradTaOmega_op; GeneratorTorqueController.GradTaVop_op = s.GradTaVop_op; GeneratorTorqueController.GradTaBeta_op = s.GradTaBeta_op; GeneratorTorqueController.GradPaBeta_op = s.GradPaBeta_op; GeneratorTorqueController.GradFaLambda_op = s.GradFaLambda_op; GeneratorTorqueController.GradFaOmega_op = s.GradFaOmega_op; GeneratorTorqueController.GradFaVop_op = s.GradFaVop_op; GeneratorTorqueController.GradFaBeta_op = s.GradFaBeta_op; GeneratorTorqueController.Lambda_op_opt = s.Lambda_op_opt; GeneratorTorqueController.OmegaR_op_opt = s.OmegaR_op_opt; GeneratorTorqueController.Beta_op_opt = s.Beta_op_opt; GeneratorTorqueController.Ta_op_opt = s.Ta_op_opt; GeneratorTorqueController.Pa_op_opt = s.Pa_op_opt; GeneratorTorqueController.Indexop_Region1Region15 = s.Indexop_Region1Region15; GeneratorTorqueController.Indexop_Region15Region2 = s.Indexop_Region15Region2; GeneratorTorqueController.Indexop_Region2Region25 = s.Indexop_Region2Region25; GeneratorTorqueController.Indexop_Region25Region3 = s.Indexop_Region25Region3; GeneratorTorqueController.Indexop_Region3Region4 = s.Indexop_Region3Region4; GeneratorTorqueController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; GeneratorTorqueController.OmegaRop_Region25Region3 = s.OmegaRop_Region25Region3;    
    BladePitchController.Vop = s.Vop; BladePitchController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; BladePitchController.OmegaR_op = s.OmegaR_op; BladePitchController.Lambda_op = s.Lambda_op; BladePitchController.Beta_op = s.Beta_op; BladePitchController.Tg_op = s.Tg_op; BladePitchController.CP_op = s.CP_op; BladePitchController.CQ_op = s.CQ_op; BladePitchController.CT_op = s.CT_op; BladePitchController.GradCpBeta_op = s.GradCpBeta_op; BladePitchController.GradCpLambda_op = s.GradCpLambda_op; BladePitchController.GradCtBeta_op = s.GradCtBeta_op; BladePitchController.GradCtLambda_op = s.GradCtLambda_op; BladePitchController.Pa_op = s.Pa_op; BladePitchController.Ta_op = s.Ta_op; BladePitchController.Fa_op = s.Fa_op; BladePitchController.Pe_op = s.Pe_op; BladePitchController.GradTaLambda_op = s.GradTaLambda_op; BladePitchController.GradTaOmega_op = s.GradTaOmega_op; BladePitchController.GradTaVop_op = s.GradTaVop_op; BladePitchController.GradTaBeta_op = s.GradTaBeta_op; BladePitchController.GradPaBeta_op = s.GradPaBeta_op; BladePitchController.GradFaLambda_op = s.GradFaLambda_op; BladePitchController.GradFaOmega_op = s.GradFaOmega_op; BladePitchController.GradFaVop_op = s.GradFaVop_op; BladePitchController.GradFaBeta_op = s.GradFaBeta_op; BladePitchController.Lambda_op_opt = s.Lambda_op_opt; BladePitchController.OmegaR_op_opt = s.OmegaR_op_opt; BladePitchController.Beta_op_opt = s.Beta_op_opt; BladePitchController.Ta_op_opt = s.Ta_op_opt; BladePitchController.Pa_op_opt = s.Pa_op_opt; BladePitchController.Indexop_Region1Region15 = s.Indexop_Region1Region15; BladePitchController.Indexop_Region15Region2 = s.Indexop_Region15Region2; BladePitchController.Indexop_Region2Region25 = s.Indexop_Region2Region25; BladePitchController.Indexop_Region25Region3 = s.Indexop_Region25Region3; BladePitchController.Indexop_Region3Region4 = s.Indexop_Region3Region4;  BladePitchController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; BladePitchController.OmegaRop_Region25Region3 = s.OmegaRop_Region25Region3;
    %
   

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to "WindTurbine_data" at Logical Instance in WindTurbineData_NREL5MW,
        % or WindTurbineData_IEA15MW or WindTurbineData_DTU10MW).
    
    
elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % MEASUREMENT OF CONTROL SIGNALS (ONLINE):   
    % Purpose of this Logical Instance: to represent the measurement of 
    % the signals used by the controllers, through the wind turbine sensors.

    % MEASUREMENT OF CONTROL SIGNALS (ONLINE):   
    % Purpose of this Logical Instance: to represent the measurement of 
    % the signals used by the controllers, through the wind turbine sensors.

    % ---------- Receiving signals from Sensors ----------
    who.OmegaR_measured = 'Rotor Speed Measured at the output of the drive-train, in [rad/s]';
    s.OmegaR_measured = max( s.Sensor.OmegaR , min(s.OmegaR_op) ) ;
    who.OmegaG_measured = 'Generator Speed Measured at the output of the drive-train, in [rad/s]';
    s.OmegaG_measured = max( s.Sensor.OmegaG , min(s.OmegaR_op*s.eta_gb) ) ;   
    who.Beta_measured = 'Collective Blade Pitch Measured at the blade pitch actuator system output (control output), in [deg]';
    s.Beta_measured = max( s.Sensor.Beta , min(s.Beta_op) ) ; 
    who.Tg_measured = 'Generator Torque Measured at the output of the generator/converter system, in [N.m]';
    s.Tg_measured = max( s.Sensor.Tg , min(s.Tg_op) ) ; 
    who.Pe_measured = 'Electrical Power Measured at the output of the Energy Converter, in [W]';
    s.Pe_measured = max( s.Sensor.Pe , min(s.Pe_op) ) ;
    who.WindSpedd_hub_measured = 'Wind speed Measured at the height of the hub (anemometer), in [m/s]';
    s.WindSpedd_hub_measured = max(  s.Sensor.WindSped_hubWT , 0.1 ) ;  

    who.Xt_measured = 'Tower-Top Fore-Aft Position displacement Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_measured = max( s.Sensor.Xt , 0.001 ) ;
    who.Xt_dot_measured = 'Tower-Top Fore-Aft Velocity Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_dot_measured = max( s.Sensor.Xt_dot , 0.001 ) ;    
    who.Xt_Ddot_measured = 'Tower-Top Fore-Aft Acceleration Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_Ddot_measured = max( s.Sensor.Xt_Ddot , 0.001 ) ;

    if s.Option02f2 > 1
        % Offshore wind turbine    
        who.Surge_dot_measured = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
        s.Surge_dot_measured = s.Sensor.Surge ;
        who.Surge_measured = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
        s.Surge_measured = s.Sensor.Surge_dot ;         
        who.Surge_Ddot_measured = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
        s.Surge_Ddot_measured = s.Sensor.Surge_Ddot ;   

        who.Sway_measured = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
        s.Sway_measured = s.Sensor.Sway ; 
        who.Sway_dot_measured = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
        s.Sway_dot_measured = s.Sensor.Sway_dot ;        
        who.Sway_Ddot_measured = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
        s.Sway_Ddot_measured = s.Sensor.Sway_Ddot ;      

        who.Heave_measured = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
        s.Heave_measured = s.Sensor.Heave ; 
        who.Heave_dot_measured = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
        s.Heave_dot_measured = s.Sensor.Heave_dot ;        
        who.Heave_Ddot_measured_measured = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
        s.Heave_Ddot_measured = s.Sensor.Heave_Ddot ;

        who.RollAngle_measured = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
        s.RollAngle_measured = s.Sensor.RollAngle ;          
        who.RollAngle_dot_measured = 'Measurement of Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
        s.RollAngle_dot_measured = s.Sensor.RollAngle_dot ; 
        who.RollAngle_Ddot_measured = 'Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
        s.RollAngle_Ddot_measured = s.Sensor.RollAngle_Ddot ;   

        who.PitchAngle_measured = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad].';
        s.PitchAngle_measured = s.Sensor.PitchAngle ;         
        who.PitchAngle_dot_measured = 'Measurement of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
        s.PitchAngle_dot_measured = s.Sensor.PitchAngle_dot ;
        who.PitchAngle_Ddot_measured = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
        s.PitchAngle_Ddot_measured = s.Sensor.PitchAngle_Ddot ;        
        
        who.YawAngle_measured = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
        s.YawAngle_measured = s.Sensor.YawAngle ; 
        who.YawAngle_dot_measured = 'Measurement of Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
        s.YawAngle_dot_measured = s.Sensor.YawAngle_dot ;  
        who.YawAngle_Ddot_measured = 'Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
        s.YawAngle_Ddot_measured = s.Sensor.YawAngle_Ddot ;
        %
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    

    % Calling the next logic instance 
    PIGainScheduledOTC_Jonkman2009('logical_instance_04');



elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % FILTERING DRIVE TRAIN SIGNALS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Low Pass Filters
    % (LPF) for the signals that will be used by the controllers in drive
    % train dynamics model.

             %###### LOW-PASS FILTER 1ª ORDER (LPF) ###### 

    % ---------- Low Pass Filter (LPF) Inputs ----------
    who.InputsLPF1_unfiltered = 'Unfiltered signals or signals at the input of the LPF filter.';
    s.InputsLPF1_unfiltered(1,1) = s.OmegaR_measured;
    s.InputsLPF1_unfiltered(1,2) = s.OmegaG_measured;    
    s.InputsLPF1_unfiltered(1,3) = s.Beta_measured;
    s.InputsLPF1_unfiltered(1,4) = s.Tg_measured;
    s.InputsLPF1_unfiltered(1,5) = s.Pe_measured;
    s.InputsLPF1_unfiltered(1,6) = s.WindSpedd_hub_measured;

    who.InputsLPF1_filtered = 'Last filtered signals or filtered signals used as input to the LPF filter.';
    s.InputsLPF1_filtered = s.OutputsLPF1_filtered_last;
     

    % ---------- LOW-PASS FILTER (LPF) ----------
    who.CutFreq_LPF1 = 'Low-pass filter (LPF) cutoff frequency, in [Hz]..';
    s.CutFreq_LPF1 = s.CutFreq_DriveTrain;
    who.Ts_LPF1 = 'Low-pass filter (LPF) discrete time step or system sampling rate, in [s].';
    s.Ts_LPF1 = s.Sample_Rate_c;    
    
    s.alfa_LPF1 = exp(- 2*pi*s.CutFreq_LPF1*s.Ts_LPF1);
    s.Ad_LPF1 = s.alfa_LPF1;
    s.Bd_LPF1 = (1 - s.alfa_LPF1);
    s.Cd_LPF1 = s.alfa_LPF1;
    s.Dd_LPF1 = (1 - s.alfa_LPF1);
    y_filtered = (s.Cd_LPF1 .* s.InputsLPF1_filtered) + (s.Dd_LPF1 .* s.InputsLPF1_unfiltered);


    % ---------- Low Pass Filter (LPF) Outputs ----------    
    who.OutputsLPF1_filtered = 'Filtered signals or signals at the output of the LPF filter.';
    s.OutputsLPF1_filtered = y_filtered;
    s.OutputsLPF1_filtered_last = y_filtered; % Update value

    s.OmegaR_filteredLPF1 = s.OutputsLPF1_filtered(1);
    s.OmegaG_filteredLPF1 = s.OutputsLPF1_filtered(2);   
    s.Beta_filteredLPF1 = s.OutputsLPF1_filtered(3);
    s.Tg_filteredLPF1 = s.OutputsLPF1_filtered(4);
    s.Pe_filteredLPF1 = s.OutputsLPF1_filtered(5);
    s.WindSpedd_hub_filteredLPF1 = s.OutputsLPF1_filtered(6);


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % FILTERING SIGNALS FROM THE MOTION OF THE TOWER-TOP/PLATAFORM (ONLINE):   
    % Purpose of this Logical Instance: to represent the High-Pass Filters
    % (HPF) combined with a second-order Low-Pass Filter (LPF) or/and
    % a Notch Filter (NF) is used to remove the tower fore–aft frequency
    % component of the feedback signal for the floating wind turbine 
    % controllers.
    

      %###### BUTTERWORTH LOW-PASS FILTER 2ª ORDER (LPF2B) ###### 

    % ---------- Low-Pass Filter Inputs ----------
    who.InputsLPF2B_unfiltered = 'Unfiltered signals related to structure dynamics at the input of the LPF.';
    s.InputsLPF2B_unfiltered(1,1) = s.Xt_Ddot_measured; 

    % Offshore wind turbine motion signals
    if s.Option02f2 > 1
        s.InputsLPF2B_unfiltered(1,2) = s.Surge_Ddot_measured; 
        s.InputsLPF2B_unfiltered(1,3) = s.Sway_Ddot_measured; 
        s.InputsLPF2B_unfiltered(1,4) = s.Heave_Ddot_measured; 
        s.InputsLPF2B_unfiltered(1,5) = s.RollAngle_dot_measured; 
        s.InputsLPF2B_unfiltered(1,6) = s.PitchAngle_dot_measured; 
        s.InputsLPF2B_unfiltered(1,7) = s.YawAngle_dot_measured; 
    end

    % Previous filtered signals
    who.InputsLPF2B_filtered = 'Filtered signals from the previous timestep used in the LPF.';
    s.InputsLPF2B_filtered = s.OutputsLPF2B_last; 
    s.InputsLPF2B_filtered_last = s.OutputsLPF2B_secondLast; 


    % ---------- Low-Pass Filter (LPF2B) Design Parameters ----------
    who.CutFreq_LPF2B = 'Low-pass filter (LPF) cutoff frequency, in [Hz].';
    s.CutFreq_LPF2B = s.CutFreq_TowerTop; 
    who.Ts_LPF2B = 'Low-pass filter (LPF) sampling time, in [s].';
    s.Ts_LPF2B = s.Sample_Rate_c; 

    % Butterworth filter coefficients
    omega_c = 2 * pi * s.CutFreq_LPF2B; % Angular cutoff frequency
    omega_d = tan(omega_c * s.Ts_LPF2B / 2); % Digital angular frequency
    norm = 1 + sqrt(2) * omega_d + omega_d^2;

    a0_LPF2B = omega_d^2 / norm;
    a1_LPF2B = 2 * omega_d^2 / norm;
    a2_LPF2B = omega_d^2 / norm;
    b1_LPF2B = 2 * (omega_d^2 - 1) / norm;
    b2_LPF2B = (1 - sqrt(2) * omega_d + omega_d^2) / norm;


    % ---------- Low-Pass Filter Implementation ----------
    y_filteredLPF2B = zeros(1, length(s.InputsLPF2B_unfiltered) ); % Initialize filtered signals

    if it == 1
        s.Xt_Ddot_LPF2Bfiltered = a0_LPF2B * s.Xt_Ddot_measured;

        if s.Option02f2 > 1
            s.Surge_Ddot_LPF2Bfiltered = a0_LPF2B * s.Surge_Ddot_measured;
            s.Sway_Ddot_LPF2Bfiltered = a0_LPF2B * s.Sway_Ddot_measured;
            s.Heave_Ddot_LPF2Bfiltered = a0_LPF2B * s.Heave_Ddot_measured;
            s.RollAngle_dot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_dot_measured;
            s.PitchAngle_dot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_dot_measured;
            s.YawAngle_dot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_dot_measured;
            y_filteredLPF2B = [s.Xt_Ddot_LPF2Bfiltered, s.Surge_Ddot_LPF2Bfiltered, s.Sway_Ddot_LPF2Bfiltered, s.Heave_Ddot_LPF2Bfiltered, s.RollAngle_dot_LPF2Bfiltered, s.PitchAngle_dot_LPF2Bfiltered, s.YawAngle_dot_LPF2Bfiltered];
        else
            y_filteredLPF2B = s.Xt_Ddot_LPF2Bfiltered ;
        end
        %
    else
        s.Xt_Ddot_LPF2Bfiltered = a0_LPF2B * s.Xt_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(1) + a2_LPF2B * s.OutputsLPF2B_secondLast(1) - b1_LPF2B * s.OutputsLPF2B_last(1) - b2_LPF2B * s.OutputsLPF2B_secondLast(1);
        if s.Option02f2 > 1
            s.Surge_Ddot_LPF2Bfiltered = a0_LPF2B * s.Surge_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(2) + a2_LPF2B * s.OutputsLPF2B_secondLast(2) - b1_LPF2B * s.OutputsLPF2B_last(2) - b2_LPF2B * s.OutputsLPF2B_secondLast(2);
            s.Sway_Ddot_LPF2Bfiltered = a0_LPF2B * s.Sway_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(3) + a2_LPF2B * s.OutputsLPF2B_secondLast(3) - b1_LPF2B * s.OutputsLPF2B_last(3) - b2_LPF2B * s.OutputsLPF2B_secondLast(3);
            s.Heave_Ddot_LPF2Bfiltered = a0_LPF2B * s.Heave_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(4) + a2_LPF2B * s.OutputsLPF2B_secondLast(4) - b1_LPF2B * s.OutputsLPF2B_last(4) - b2_LPF2B * s.OutputsLPF2B_secondLast(4);
            s.RollAngle_dot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(5) + a2_LPF2B * s.OutputsLPF2B_secondLast(5) - b1_LPF2B * s.OutputsLPF2B_last(5) - b2_LPF2B * s.OutputsLPF2B_secondLast(5);
            s.PitchAngle_dot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(6) + a2_LPF2B * s.OutputsLPF2B_secondLast(6) - b1_LPF2B * s.OutputsLPF2B_last(6) - b2_LPF2B * s.OutputsLPF2B_secondLast(6);
            s.YawAngle_dot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(7) + a2_LPF2B * s.OutputsLPF2B_secondLast(7) - b1_LPF2B * s.OutputsLPF2B_last(7) - b2_LPF2B * s.OutputsLPF2B_secondLast(7);

            y_filteredLPF2B = [s.Xt_Ddot_LPF2Bfiltered, s.Surge_Ddot_LPF2Bfiltered, s.Sway_Ddot_LPF2Bfiltered, s.Heave_Ddot_LPF2Bfiltered, s.RollAngle_dot_LPF2Bfiltered, s.PitchAngle_dot_LPF2Bfiltered, s.YawAngle_dot_LPF2Bfiltered];            
        else
            y_filteredLPF2B = s.Xt_Ddot_LPF2Bfiltered;
        end
        %
    end
    

    % ---------- Low-Pass Filter Outputs ----------    
    who.OutputsLPF2B_filtered = 'Filtered signals at the output of the LPF.';
    s.OutputsLPF2B_filtered = y_filteredLPF2B;  
    s.OutputsLPF2B_secondLast = s.OutputsLPF2B_last; % Update the second-to-last value.    
    s.OutputsLPF2B_last = y_filteredLPF2B; % Update the last value.



    % Assigning outputs to their respective variables
    s.Xt_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(1);

    if s.Option02f2 > 1
        s.Surge_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(2);
        s.Sway_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(3);
        s.Heave_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(4);
        s.RollAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(5);
        s.PitchAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(6);
        s.YawAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(7);
    end



                %###### HIGH-PASS FILTER (HPF1) ###### 

    % ---------- High-Pass Filter (HPF) Inputs ----------
    who.InputsHPF1_unfiltered = 'Unfiltered signals by the HPF or Filtered signals at the output of the Low Pass Filter.';
    s.InputsHPF1_unfiltered = s.OutputsLPF2B_filtered;

    who.InputsHPF1_filtered = 'Last filtered signals by the HPF or filtered signals used as input to the HPF filter.';
    s.InputsHPF1_unfiltered_last = s.OutputsLPF2B_secondLast; % Use LPF output        
    s.InputsHPF1_filtered = s.OutputsHPF1_filtered_last; % Use HPF output   


    % ---------- HIGH-PASS FILTER  (HPF)----------
    who.CutFreq_HighPass = 'High-pass filter cutoff frequency, in [rad/s].';
    s.CutFreq_HighPass = s.CutFreq_TowerForeAft; % Example cutoff frequency

    % Parameters for the High-Pass filter
    s.omega0_HighPass = 2 * pi * s.CutFreq_HighPass; % Convert frequency to angular frequency

    % Calculate coefficients
    s.K_HighPass = 2.0 / s.Ts_LPF1;
    s.alpha_HighPass = s.omega0_HighPass / (s.omega0_HighPass + s.K_HighPass);
    s.a0_HighPass = s.alpha_HighPass;
    s.a1_HighPass = -s.alpha_HighPass;
    s.b1_HighPass = (s.omega0_HighPass - s.K_HighPass) / (s.omega0_HighPass + s.K_HighPass);

    % Apply High-Pass filter
    y_highpass = s.a0_HighPass * s.InputsHPF1_unfiltered + s.a1_HighPass * s.InputsHPF1_unfiltered_last - s.b1_HighPass * s.InputsHPF1_filtered;


    % ---------- High Pass Filter Outputs ----------
    who.OutputsHPF1_filtered = 'Filtered signals at the output of the High-Pass filter.';
    s.OutputsHPF1_filtered = y_highpass;
    s.OutputsHPF1_filtered_secondLast = s.OutputsHPF1_filtered_last; % Update the second-to-last value.    
    s.OutputsHPF1_filtered_last = y_highpass; % Update the last value.


    s.Xt_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(1);    
    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.Surge_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(2);
        s.Sway_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(3);   
        s.Heave_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(4);
        s.RollAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(5);  
        s.PitchAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(6);   
        s.YawAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(7);   
    end



                  %###### NOTCH FILTER (NF) ######     

    % ---------- Notch Filter Inputs ----------
    who.InputsNF_unfiltered = 'Signals from High Pass Filter output';
    s.InputsNF_unfiltered = s.OutputsHPF1_filtered;
    s.InputsNF_unfiltered_last = s.OutputsHPF1_filtered_secondLast;

    s.InputsNF_filtered = s.Outputs_notched_Last;
    s.InputsNF_filtered_last = s.Outputs_notched_secondLast;


    % ---------- NOTCH FILTER ----------
    who.CutFreq_Notch = 'Notch filter cutoff frequency, in [rad/s].';
    s.CutFreq_Notch = s.CutFreq_TowerForeAft;

    who.Damp_Notch = 'Notch filter damping constant.';
    s.Damp_Notch = 0.01; % Damping constant

    % Parameters for the Notch filter
    s.omega0_Notch = 2 * pi * s.CutFreq_Notch; % Convert frequency to angular frequency

    % Calculate coefficients
    s.b2_Notch = (2 * s.Ts_LPF1 * s.CutFreq_Notch);
    s.b0_Notch = -s.b2_Notch;
    s.a2_Notch = s.Damp_Notch * (s.Ts_LPF1^2) * (s.CutFreq_Notch^2) + 2 * s.Ts_LPF1 * s.CutFreq_Notch + 4 * s.Damp_Notch;
    s.a1_Notch = 2 * s.Damp_Notch * (s.Ts_LPF1^2) * (s.CutFreq_Notch^2) - 8 * s.Damp_Notch;
    s.a0_Notch = s.Damp_Notch * (s.Ts_LPF1^2) * (s.CutFreq_Notch^2) - 2 * s.Ts_LPF1 * s.CutFreq_Notch + 4 * s.Damp_Notch;

    % Apply Notch filter
    y_notched = (s.b2_Notch * s.InputsNF_unfiltered + s.b0_Notch * s.InputsNF_unfiltered_last - s.a1_Notch * s.InputsNF_filtered - s.a0_Notch * s.InputsNF_filtered_last) / s.a2_Notch;

    % ---------- Notch Filter Outputs ----------
    who.Outputs_notched = 'Filtered signals at the output of the Notch filter.';
    s.Outputs_notched = y_notched;
    s.Outputs_notched_secondLast = s.Outputs_notched_Last;
    s.Outputs_notched_Last = y_notched;    

    s.Xt_Ddot_filteredNF = s.Outputs_notched(1); 

    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.Surge_Ddot_filteredNF = s.Outputs_notched(2);
        s.Sway_Ddot_filteredNF = s.Outputs_notched(3);   
        s.Heave_Ddot_filteredNF = s.Outputs_notched(4);
        s.RollAngle_dot_filteredNF = s.Outputs_notched(5);  
        s.PitchAngle_dot_filteredNF = s.Outputs_notched(6);   
        s.YawAngle_dot_filteredNF = s.Outputs_notched(7);   
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"

    
elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % RECEIVING AND SELECTING CONTROL SIGNALS (ONLINE):    
    % Purpose of this Logical Instance: o represent the reception and
    % selection of control signals from Low Pass, High Pass, Notch, 
    % State Observer filters, etc. The "s.Option02f8" option allows
    % you to select the strategy of which signals will be used by the 
    % controllers, thus making it possible to study the system performance,
    % since some filters can introduce a phase delay and affect the
    % stability of the system.


          %####### Driventrain Dynamics Signals #######

    % ---------- Selection of Drivetrain Dynamics Signals ----------
    who.OmegaR_filtered = 'Rotor Speed ​​filtered by 1st Order Low-Pass Filter, in [rad/s].';
    s.OmegaR_filtered = min(max(  s.OmegaR_filteredLPF1 , min(s.OmegaR_op) ),  1.1*max(s.OmegaR_op) );   

    who.OmegaG_filtered = 'Generator Speed ​​filtered by 1st Order Low-Pass Filter, in [rad/s].';    
    s.OmegaG_filtered = min(max(  s.OmegaG_filteredLPF1 , min(s.OmegaR_op*s.eta_gb) ),  1.1*max(s.OmegaR_op*s.eta_gb) );
    who.Beta_filtered = 'Collective Blade Pitch filtered by 1st Order Low-Pass Filter, in [deg]';
    s.Beta_filtered = min(max(  s.Beta_filteredLPF1 , min(s.Beta_op) ),  1.1*max(s.Beta_op) ); 
    who.Tg_filtered = 'Generator Torque filtered by 1st Order Low-Pass Filter, in [N.m]';
    s.Tg_filtered = min(max(  s.Tg_filteredLPF1 , min(s.Tg_op) ),  1.1*max(s.Tg_op) );  
    who.Pe_filtered = 'Electrical power filtered by 1st Order Low-Pass Filter, in [W]';
    s.Pe_filtered = max(  s.Pe_filteredLPF1 , min(s.Tg_op) );     
    who.WindSpedd_hub_filtered = 'Wind speed measured by anemometer and filtered by low pass filter, in [m/s]';
    s.WindSpedd_hub_filtered = max(  s.WindSpedd_hub_filteredLPF1 , 0.0 ); 


    %####### Tower-Top and Plataforms Dynamics Signals #######   

    % ------- Selection of Tower-Top Dynamics Signals ----------
    if (s.Option03f8 == 1) && (s.Option04f8 < 3)
        % Filtered signals according to Abbas (2022)
        s.Xt_Ddot_filtered = s.Xt_Ddot_filteredNF;
        if s.Option02f2 > 1
            % Offshore wind turbine 
            s.Surge_Ddot_filtered = s.Surge_Ddot_filteredNF;
            s.Sway_Ddot_filtered = s.Sway_Ddot_filteredNF;              
            s.Heave_Ddot_filtered = s.Heave_Ddot_filteredNF;
            s.RollAngle_dot_filtered = s.Heave_Ddot_filteredNF;  
            s.PitchAngle_dot_filtered = s.PitchAngle_dot_filteredNF;   
            s.YawAngle_dot_filtered = s.PitchAngle_dot_filteredNF;   
        end
        %
    elseif (s.Option03f8 == 2) && (s.Option04f8 < 3)
        % Filtered signals only with a 2nd Order Low Pass Filter
        s.Xt_Ddot_filtered = s.Xt_Ddot_LPF2Bfiltered;
        if s.Option02f2 > 1
            % Offshore wind turbine 
            s.Surge_Ddot_filtered = s.Surge_Ddot_LPF2Bfiltered;
            s.Sway_Ddot_filtered = s.Sway_Ddot_LPF2Bfiltered;              
            s.Heave_Ddot_filtered = s.Heave_Ddot_LPF2Bfiltered;
            s.RollAngle_dot_filtered = s.Heave_Ddot_LPF2Bfiltered;  
            s.PitchAngle_dot_filtered = s.PitchAngle_dot_LPF2Bfiltered;   
            s.YawAngle_dot_filtered = s.PitchAngle_dot_LPF2Bfiltered;   
        end
        %
    else
        s.Xt_Ddot_filtered = s.Xt_Ddot_measured ;
        %        
    end


    % ----------------- Identifying Point of Operation ----------------------------   
    if (s.OmegaR_filtered < s.OmegaR_Rated) || ( s.Tg_filtered < min(s.Tg_op3_25) )
        % Partial Load Operation (Regions 1, 1.5, 2)
        who.Vews_op = 'Effective Wind Speed ​​at the operating point estimated by a State Observer and filtered by a 1st Order Low-Pass Filter, in [m/s].';
        s.Vews_op = interp1(s.OmegaR_op(1:s.Indexop_Region2Region25), s.Vop(1:s.Indexop_Region2Region25), s.OmegaR_filtered);
    else
        if ( s.Tg_filtered < max(s.Tg_op3_3) ) || ( s.Beta_filtered <= min(s.Beta_op3_3) )
            % Partial Load Operation (Region 2.5) 
            who.Vews_op = 'Effective Wind Speed ​​at the operating point estimated by a State Observer and filtered by a 1st Order Low-Pass Filter, in [m/s].';
            s.Vews_op = interp1(s.Tg_op(s.Indexop_Region1Region15:s.Indexop_Region25Region3), s.Vop(s.Indexop_Region1Region15:s.Indexop_Region25Region3), s.Tg_filtered);
        else
            % Full Load Operation (Regions 3 and 4)
            who.Vews_op = 'Effective Wind Speed ​​at the operating point estimated by a State Observer and filtered by a 1st Order Low-Pass Filter, in [m/s].';
            s.Vews_op = interp1(s.Beta_op(s.Indexop_Region25Region3+1:s.Indexop_Regions4EndOperation), s.Vop(s.Indexop_Region25Region3+1:s.Indexop_Regions4EndOperation), s.Beta_filtered);
        end
    end


    % ------------- Controller Modules ------------
    if ( s.Beta_filtered > ( s.BetaMinRegion3 + 0.1 ) ) 
        % Enable Blade Pitch Controller
        s.Mode_GeneratorController(2) = 0;
        s.Mode_BladePitchController(2) = 1; 
        %
    else
        if (s.Vews_op >= s.Vws_Rated)
            s.Mode_GeneratorController(2) = 0;
            s.Mode_BladePitchController(2) = 1;
        else
            s.Mode_GeneratorController(2) = 1;
            s.Mode_BladePitchController(2) = 0; 
        end
    end


    % ----- Partial Derivatives of Fa and Ta at the Operating Point -----    
    s.GradTaOmega_dop = interp1(s.Vop, s.GradTaOmega_op, s.Vews_op);
    s.GradTaVop_dop = interp1(s.Vop, s.GradTaVop_op, s.Vews_op);
    s.GradTaBeta_dop = interp1(s.Vop, s.GradTaBeta_op, s.Vews_op);
    s.GradTaBeta_dop( s.GradTaBeta_dop == 0) = 0.0001;
    s.GradPaBeta_dop = interp1(s.Vop, s.GradPaBeta_op, s.Vews_op);
    s.GradFaOmega_dop = interp1(s.Vop, s.GradFaOmega_op, s.Vews_op);
    s.GradFaVop_dop = interp1(s.Vop, s.GradFaVop_op, s.Vews_op);
    s.GradFaBeta_dop = interp1(s.Vop, s.GradFaBeta_op, s.Vews_op);    



    % ----- Stability Analysis and Gain Adjustments at Current Operating Point ----
    who.OmegaN_Beta  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
    s.OmegaN_Beta = 0.6;  
    who.DampingCFactor_Beta  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
    s.DampingCFactor_Beta = 0.7;



    % ------- Collective Blade Pitch at Operating Point  ----------    
    who.Betad_op = 'Desired Collective Blade Pitch at Operating Point, in [N.m].';    
    s.Betad_op = interp1(s.Vop, s.Beta_op, s.Vews_op);   

    % ------- Generator Torque at Operating Point  ----------    
    who.Tgd_op = 'Desired Generator Torque at Operating Point, in [N.m].';    
    s.Tgd_op = interp1(s.Vop, s.Tg_op, s.Vews_op);


    % ------- Rotor Speed at Operating Point  ----------    
    who.OmegaRd_op = 'Desired Rotor Speed at Operating Point, in [rad/s].';    
    s.OmegaRd_op = interp1(s.Vop, s.OmegaR_op, s.Vews_op);  


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledOTC_Jonkman2009('logical_instance_07');


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % COMPESATION STRATEGIES TOWER/PLATAFORM FEEDBACK (ONLINE):   
    % Purpose of this Logical Instance: to represent the module that 
    % handles active tower damping using the Collective Blade Pitch 
    % controller. The controller uses the forward and backward acceleration,
    % which is fed back to the collective pitch angle using an 
    % appropriate filter. Consequently, a counteracting thrust
    % force in the rotor plane dampens the tower vibration. This 
    % strategy is used to handle relative motions of the tower top,
    % whether caused by vibration or movements of offshore platforms 
    % or structures or avoid negative damping. Therefore, this strategy is
    % implemented for both onshore and offshore wind turbines. See the work
    % of Abbas (2022) on section "Floating offshore wind turbine feedback".


    % ------------ Relative motion of wind flow ----------------
    if s.Option04f8 == 1
        % Consider Active Tower Damping with a Tower Top feedback compensation strategy

        % ----- Active Tower Damping with a Tower Top feedback -----
        who.dt_contr = 'Defining integration step, in [s].';
        s.dt_contr = s.dt/10; % s.dt/10

        who.Xf_dot_filtered = 'Wind turbine compensation feedback signal speed. Active Tower Damping with a Tower Top feedback.';
        s.Xf_dot_filtered = s.Xf_dot_Lastfiltered + s.dt_contr * s.Xt_Ddot_filtered; % Forward Euler Integration Method

        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';        
        s.VCsi_est = s.Xf_dot_filtered ;
        s.Xf_dot_Lastfiltered = s.Xf_dot_filtered;
        %
    else
        % Feedback compensation strategy using platform pitch angular speed.

        who.Xf_dot_filtered = 'Wind turbine compensation feedback signal speed. Active Tower Damping with a Tower Top feedback.';
        s.Xf_dot_filtered = s.Xt_dot_filtered ; % Forward Euler Integration Method
        s.Xf_dot_Lastfiltered = s.Xf_dot_filtered;

        who.Cosseno_PitchAngle_m = 'Cosine of the platform pitch angle measured, measured from the vertical axis, in [rad]. Using trigonometric identity.';
        if s.PitchAngle == 0
            s.Cosseno_PitchAngle_m = 1 ; 
        else
            s.Cosseno_PitchAngle_m = sin( pi/2 - s.PitchAngle_measured ) ;
        end        
        who.Rarm_pitch = 'Radius of rotational movement of the platform pitch, in [m]';
        s.Rarm_pitch = s.MomentArmPlatform * s.Cosseno_PitchAngle_m ; 
        
        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
        s.VCsi_est = s.Surge_dot_measured + (s.Rarm_pitch * s.PitchAngle_dot_measured) ;
        %
    end


    % ------------ Compensation/Feedback Term Gain -----------------------
    who.Kp_CS_Feedback = 'Gain proportional to tower feedback.';
    s.Kp_CS_Feedback = (s.GradTaVop_dop/s.GradTaBeta_dop);

    who.PropTerm_CS_Feedback = 'Collective Blade Pitch Controller (PI) proportional term.';    
    if (s.Option04f8 == 1) || (s.Option04f8 == 2)
        % Consider Active Tower Damping
        s.PropTerm_CS_Feedback = s.Kp_CS_Feedback * s.VCsi_est ;
        %
    else
        % DO NOT consider Active Tower Damping or Pitch Plataform feedback
        s.PropTerm_CS_Feedback = 0;
        %
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledOTC_Jonkman2009('logical_instance_08');   



elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % CONTROLLER SATURATION STRATEGIES (ONLINE):    
    % Purpose of this Logical Instance: to define the strategies for 
    % saturating the collective blade pitch and generator torque. The 
    % strategies "STRATEGY 1 (Figure 2 from Abbas, 2022)" and "STRATEGY 2
    % (Peak Shaving or Thrust limiting strategies)" have different minimum 
    % values ​​for the collective blade pitch and different maximum values 
    % ​​for the generator torque. In this logic instance, the saturation of
    % the controllers is adjusted according to the control strategy 
    % (STRATEGY 1 or STRATEGY 2) chosen for steady-state operation.


    % ----- Blade Pitch Setup or Saturation Strategies -----
    who.BetaMax_setup = 'Maximum collective blade pitch setting in controllers, in [deg].';
    if (s.Option01f8 == 1) || (s.Option01f8 == 3)
        % STRATEGY 1 (Figure 2 from Abbas, 2022)
        % STRATEGY 3 (Jonkman, 2009)        
        s.BetaMax_setup = s.BetaMaxRegion3 ;
        %
    elseif s.Option01f8 == 2
        % STRATEGY 2 (Peak Shaving)
        if (s.Vews_op >= s.Vws_Rated)
            s.BetaMax_setup = s.BetaMaxRegion3 ;
        else
            s.BetaMax_setup = interp1(s.Vop, s.Beta_op, s.Vews_op);
        end
    end 


    who.BetaMin_setup = 'Minimum collective blade pitch setting in controllers, in [deg].';
    if (s.Option01f8 == 1) || (s.Option01f8 == 3)
        % STRATEGY 1 (Figure 2 from Abbas, 2022)
        % STRATEGY 3 (Jonkman, 2009)
        s.BetaMin_setup = s.BetaMinRegion3 ;
    elseif s.Option01f8 == 2
        % STRATEGY 2 (Peak Shaving)
        s.BetaMin_setup = interp1(s.Vop, s.Beta_op, s.Vews_op);
    end

    % NOTE: The strategies "STRATEGY 1 (Figure 2 from Abbas, 2022)" and
    % "STRATEGY 2 (Peak Shaving or Thrust limiting strategies)" have new 
    % "Beta_op" values ​​inserted. The difference is that the minimum value,
    % in steady state (operational), will be different according to the
    % STRATEGY 2 project.

    
    % ----- Generator Torque Setup or Saturation Strategies -----
    who.TgMin_setup = 'Minimum generator torque setting in controllers, in [deg].';
    s.TgMin_setup = min(s.Tg_op) ;

    who.TgMax_setup = 'Minimum collective blade pitch setting in controllers, in [deg].';
    s.TgMax_setup = max(s.Tg_op) ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledOTC_Jonkman2009('logical_instance_09');


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % WIND TURBINE REFERENCE SPEED DEFINITION (ONLINE):    
    % Purpose of this Logical Instance: to represent the Low Pass Filters
    % for the signals that will be used by the controllers.


    % ----- Set Collective Blade Pitch Controller Reference Speed -----
    who.OmegaRef_Beta = 'Collective Blade Pitch Controller Reference Speed, in [deg]';
    s.OmegaRef_Beta = s.OmegaR_Rated;    


    % ----- Set Generator Torque Controller Reference Speed -----
    who.OmegaRef_Tg = 'Generator Torque Controller Reference Speed, in [rad/s]';
    if s.OmegaR_filtered >= s.OmegaR_Rated || s.Beta_filtered > s.Beta_op(118) || s.Vews_op >= s.Vws_Rated
        s.OmegaRef_Tg = s.OmegaR_Rated; 
    else
        s.OmegaRef_Tg = s.OmegaR_filtered; 
    end


    % ----- Set Controller Tracking Reference Speed -----
    who.OmegaRef = 'Controller Tracking Reference Speed, in [rad/s]';
    s.OmegaRef = interp1(s.Vop, s.OmegaR_op , s.Vews_op);



    % -------------- Shutdown Strategy --------------
    if s.Vews_op >= s.Vws_CutOut || s.Beta_filtered >= s.Beta_op(s.Indexop1_Region3Region4) 
              % Use the possible Shutdown Strategy just to avoid numerical errors in the simulation.  
        s.OmegaRef_Tg = interp1(s.Vop, s.OmegaR_op, s.Vews_op);
        s.OmegaRef_Beta = interp1(s.Vop, s.OmegaR_op, s.Vews_op);
    end

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledOTC_Jonkman2009('logical_instance_10');   


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % COLLECTIVE BLADE PITCH CONTROLLER (ONLINE):   
    % Purpose of this Logical Instance: to represent the Collective Blade
    % Pitch Controller. The controller follows the control approach 
    % adopted in this code and its options, according to a chosen strategy.
    % The controller presented here is a Gain-Scheduled Proportional-Integral
    % (PI) controller, Jonkman (2009).
         

    % ------- Maximum rate of change  ----------  
    s.Beta_d_RateLimit = s.BetaDot_max * s.Sample_Rate_c ;


    % ------- The maximum variation around the operating point  ---------- 
    s.dBeta_max = s.BetaMax_setup - s.Betad_op ;
    s.dBeta_min = s.BetaMin_setup - s.Betad_op ;


    % ------- Proportional–Integral (PI) Controller  ---------- 
    who.ErroTracking_Betad = 'Collective Blade Pitch Controller (PI) proportional term.';
    s.ErroTracking_Betad = ( s.OmegaR_filtered - s.OmegaRef_Beta );  


    % ------- Gain Scheduling Correction Factor  ----------
    who.PC_KK = 'Blade Pitch where the Partial Derivative at the nominal point is double, in [deg].';
    s.deltaGGk = abs( s.GradPaBeta_op1(s.Indexop1_Region25Region3:end) -  2*s.GradPaBeta_op1(s.Indexop1_Region25Region3) );
    s.indexGK = find ( s.deltaGGk == min(s.deltaGGk) ) + s.Indexop1_Region25Region3 ;
    s.PC_KK = s.Beta_op(s.indexGK); % s.GradPaBeta_dop  
    if s.Option06f8 == 2 
        % According to page 57 Jonkman(2009), PC_KK == 0.1099965 [rad] = 0.1099965 *(180/pi) == 6.3 [deg]. 
        s.PC_KK = 0.1099965 * (180/pi) ;        
    end             

    who.GK = 'Gain Scheduling Correction Factor. See equation (7.20) in page 25 Jonkman (2009).';
    s.Beta_GK = s.Beta_d_before * (pi/180) ;
    s.GK = 1.0/( 1.0 + s.Beta_GK / s.PC_KK ) ; 


    % ------- Gain Controller (PI)  ----------    
    who.Kp_piBeta = 'Collective Blade Pitch Controller Proportional (PI) Gain';
    who.Ki_piBeta = 'Collective Blade Pitch Controller (PI) Integrative Gain.';
    if s.Option06f8 == 2 
        % Suggested in Figura 7.3 Jonkman
        s.GradPaBeta_dop  = 25.52e+6*(pi/180); 
        s.Kp_piBeta = 0.01882681*(pi/180);
        s.Ki_piBeta = 0.008068634*(pi/180);
    else
        s.GradPaBeta_rated = s.GradPaBeta_op(s.Indexop1_Region25Region3);
        s.Kp_piBeta =((2*s.J_t*s.OmegaR_Rated*s.DampingCFactor_Beta*s.OmegaN_Beta)/(-s.GradPaBeta_rated)) * s.GK ;    
        s.Ki_piBeta = ((s.J_t*s.OmegaR_Rated*s.OmegaN_Beta^2)/(-s.GradPaBeta_rated)) * s.GK;
    end
     


    % ----- Proportional–Integral (PI) Collective Blade Pitch Controller -----
    who.PropTermPI_Beta = 'Collective Blade Pitch Controller (PI) proportional term.';
    s.PropTermPI_Beta = s.Kp_piBeta * s.ErroTracking_Betad ;
    who.IntegTermPI_Beta = 'Collective Blade Pitch Controller (PI) integrative term..';
    if s.Vews_op >= s.Vws_Rated
        s.IntegTermPI_Beta = min(max(  (s.IntegTermPI_Beta + s.ErroTracking_Betad*s.Sample_Rate_c) , (s.dBeta_min/abs(s.Ki_piBeta)) ) ,  (s.dBeta_max/abs(s.Ki_piBeta)) ); 
    else
        s.IntegTermPI_Beta = 0;
    end
        
    
    % ----- Current variation of the Collective Blade Pitch at the Operating Point -----
    who.dBeta = 'Collective Blade Pitch Variation at Operating Point, in [N.m].'; 
    if s.Vews_op >= s.Vws_Rated
        % Full Load Operation
        s.dBeta = s.PropTermPI_Beta + s.Ki_piBeta*s.IntegTermPI_Beta + s.PropTerm_CS_Feedback;
    else
        % Partial Load Operation
        s.dBeta = 0 ;
    end


    % ------- Amplitude Saturation at the Controller Output  ----------  
    s.dBeta  = min(max(  s.dBeta , s.dBeta_min ),  s.dBeta_max ); 
    who.Beta_d = 'Desired Collective Blade Pitch, in [N.m].'; 
    s.Beta_d = s.Betad_op + s.dBeta ;    
    s.Beta_d = min(max(  s.Beta_d , s.BetaMin_setup ),  s.BetaMax_setup );


    % ------------------------ Shutdown -------------------------------
    if s.Vews_op >= s.Vws_CutOut 
        % Use the possible Shutdown Strategy just to avoid numerical errors in the simulation. 
        s.Beta_d = s.Betad_op ;
    end  

    % ------------ Starting----------------------------
    if s.Vews_op < s.Vws_CutIn
        s.Beta_d = s.BetaMin_setup ;
    end 



    % ------- Rate Saturation at the Controller Output  ----------  
    who.Beta_d = 'Desired Collective Blade Pitch, in [N.m].'; 
    s.Beta_dDot = min(max(  ((s.Beta_d - s.Beta_d_before)/s.Sample_Rate_c) , (- s.Beta_d_RateLimit) ),  (s.Beta_d_RateLimit) );
    s.Beta_d = s.Beta_d_before + (s.Beta_dDot*s.Sample_Rate_c);

    if (s.Option01f3 == 2) || (s.Option01f3 == 3)
        % Consider the Blade Pitch dynamics
        s.Beta_dDot = min(max(  ((s.Beta_d - s.Beta_filtered)/s.tau_Beta) , (- s.Beta_d_RateLimit) ),  (s.Beta_d_RateLimit) );
        s.Beta_d = s.Beta_filtered + (s.Beta_dDot*s.tau_Beta);    
    end       
  
    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance  
    PIGainScheduledOTC_Jonkman2009('logical_instance_11');   


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % GENERATOR CONTROLLER (ONLINE):   
    % Purpose of this Logical Instance: to represent the Generator
    % Controller. The controller follows the control approach 
    % adopted in this code and its options, according to a chosen strategy.
    % The controller presented here is a Gain-Scheduled Proportional-Integral
    % (PI) controller, Jonkman (2009).       


    % ------- Maximum rate of change  ----------   
    s.Tg_d_RateLimit = min(max( (1*(s.TgDot_max*s.eta_gb) * s.Sample_Rate_c) , (-s.TgDot_max*s.eta_gb) ) , (s.TgDot_max*s.eta_gb) ) ;    


    % ------- The maximum variation around the operating point  ----------     
    s.dTg_max = s.TgMax_setup - s.Tgd_op ;
    s.dTg_min = s.TgMin_setup - s.Tgd_op ;       


    % ------- Set Generator Torque according Controle Region  ----------
    who.Tg_d = 'Desired Generator Torque, in [N.m].';
    if s.OmegaR_filtered >= s.OmegaRop_Region25Region3  || s.Beta_filtered > s.Beta_op(118) || s.Vews_op >= s.Vws_Rated
        % Region 3
        s.Tg_d = (s.Pmec_max / s.OmegaR_Rated );
        %          
    elseif s.OmegaR_filtered <= s.OmegaR_CutIn
        % Region 1
        s.Tg_d = 0;
        %        
    elseif (s.OmegaR_filtered < s.OmegaR_op(s.Indexop_Region15Region2)) && (s.OmegaR_filtered > s.OmegaR_CutIn)
        % Region 1.5        
        s.Slope15 = ( (s.Kopt*s.OmegaR_op(s.Indexop_Region15Region2)^2) / ( s.OmegaR_op(s.Indexop_Region15Region2) - s.OmegaR_CutIn ) ) ; 
        s.Tg_d = s.Slope15 .* ( s.OmegaR_filtered - s.OmegaR_CutIn );
        %
    elseif (s.OmegaR_filtered < s.OmegaR_op(s.Indexop_Region2Region25)) && (s.OmegaR_filtered >= s.OmegaR_op(s.Indexop_Region15Region2))
        % Region 2
        s.Tg_d = s.Kopt*s.OmegaR_filtered^2;
        %
    else
        % Region 2.5
        s.Slope25 = ( s.Pmec_max ./ s.OmegaRop_Region25Region3  ) / ( s.OmegaRop_Region25Region3  - s.OmegaR_Synchronous );        
        s.Tg_d = s.Slope25 .* ( s.OmegaR_filtered - s.OmegaR_Synchronous );
        %
    end
          

    % ----- Current variation of the Generator Torque at the Operating Point -----
    who.dTg = 'Generator Torque Variation at Operating Point, in [N.m].';    
    s.dTg = min(max(  (s.Tg_d - s.Tgd_op) , s.dTg_min ),  s.dTg_max ); 


    % ------- Amplitude Saturation at the Controller Output  ----------  
    who.Tg_d = 'Desired Generator Torque, in [N.m].';      
    s.Tg_d = min(max(  s.Tg_d , s.TgMin_setup ),  s.TgMax_setup  ); 
 

    % -------------- Shutdown Strategy --------------
    if s.Vews_op >= s.Vws_CutOut || s.Beta_filtered >= s.Beta_op(s.Indexop1_Region3Region4) 
        % Use the possible Shutdown Strategy just to avoid numerical errors in the simulation. 
        s.Tg_d = interp1(s.Vop, s.Tg_op, s.Vews_op);
    end


    % ------- Rate Saturation at the Controller Output  ----------  
    who.Tg_d = 'Desired Generator Torque, in [N.m].';
    s.Tg_dDot = min(max(  ((s.Tg_d - s.Tg_d_before)/s.Sample_Rate_c) , -s.Tg_d_RateLimit ),  s.Tg_d_RateLimit );
    s.Tg_d = s.Tg_d_before + (s.Tg_dDot*s.Sample_Rate_c);


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves current controller values, 
    % based on the last sampling.


    % ------- Update and Save Collective Blade Pitch ----------  
    s.Beta_d_before = s.Beta_d; 
    s.Beta_filtered_before = s.Beta_filtered ;
    s.Mode_BladePitchController(1) = s.Mode_BladePitchController(2);


    % ------- Update and Save Generator Torque and Power ----------  
    s.Mode_GeneratorController(1) = s.Mode_GeneratorController(2);    
    s.Tg_d_before = s.Tg_d ;
    if (s.Option02f3 == 1)
        s.Tg_filtered_before = (s.Pe_filteredLPF1/s.etaElec_op)*(1/s.OmegaR_filtered) ;
    else
        s.Tg_filtered_before = s.Pe_filtered ;
    end
    s.Pe_d_before = (s.Tg_d / s.eta_gb) * s.OmegaG_filtered * s.etaElec_op;
    s.Pe_filtered_before = s.Pe_filtered ;


    % ---------- LOGICAL INSTANCE 03  ----------
    if it == 1
        GeneratorTorqueController.OmegaR_measured = s.OmegaR_measured; GeneratorTorqueController.OmegaG_measured = s.OmegaG_measured; GeneratorTorqueController.Beta_measured = s.Beta_measured; GeneratorTorqueController.Tg_measured = s.Tg_measured; GeneratorTorqueController.Pe_measured = s.Pe_measured; GeneratorTorqueController.WindSpedd_hub_measured = s.WindSpedd_hub_measured;
        BladePitchController.OmegaR_measured = s.OmegaR_measured; BladePitchController.OmegaG_measured = s.OmegaG_measured; BladePitchController.Beta_measured = s.Beta_measured; BladePitchController.Tg_measured = s.Tg_measured; BladePitchController.Pe_measured = s.Pe_measured; BladePitchController.WindSpedd_hub_measured = s.WindSpedd_hub_measured;    
        PIGainScheduledOTC.OmegaR_measured = s.OmegaR_measured; PIGainScheduledOTC.OmegaG_measured = s.OmegaG_measured; PIGainScheduledOTC.Beta_measured = s.Beta_measured; PIGainScheduledOTC.Tg_measured = s.Tg_measured; PIGainScheduledOTC.Pe_measured = s.Pe_measured; PIGainScheduledOTC.WindSpedd_hub_measured = s.WindSpedd_hub_measured;    
        PIGainScheduledOTC.Xt_measured = s.Xt_measured; GeneratorTorqueController.Xt_measured = s.Xt_measured; BladePitchController.Xt_measured = s.Xt_measured; 
        PIGainScheduledOTC.Xt_dot_measured = s.Xt_dot_measured; GeneratorTorqueController.Xt_dot_measured = s.Xt_dot_measured; BladePitchController.Xt_dot_measured = s.Xt_dot_measured;        
        PIGainScheduledOTC.Xt_Ddot_measured = s.Xt_Ddot_measured; GeneratorTorqueController.Xt_Ddot_measured = s.Xt_Ddot_measured; BladePitchController.Xt_Ddot_measured = s.Xt_Ddot_measured;
        if s.Option02f2 > 1
            % Offshore wind turbine
            GeneratorTorqueController.Surge_measured = s.Surge_measured; BladePitchController.Surge_measured = s.Surge_measured; PIGainScheduledOTC.Surge_measured = s.Surge_measured;            
            GeneratorTorqueController.Surge_dot_measured = s.Surge_dot_measured; BladePitchController.Surge_dot_measured = s.Surge_dot_measured; PIGainScheduledOTC.Surge_dot_measured = s.Surge_dot_measured;
            GeneratorTorqueController.Surge_Ddot_measured = s.Surge_Ddot_measured; BladePitchController.Surge_Ddot_measured = s.Surge_Ddot_measured; PIGainScheduledOTC.Surge_Ddot_measured = s.Surge_Ddot_measured;            
            GeneratorTorqueController.Sway_measured = s.Sway_measured; BladePitchController.Sway_measured = s.Sway_measured; PIGainScheduledOTC.Sway_measured = s.Sway_measured;  
            GeneratorTorqueController.Sway_dot_measured = s.Sway_dot_measured; BladePitchController.Sway_dot_measured = s.Sway_dot_measured; PIGainScheduledOTC.Sway_dot_measured = s.Sway_dot_measured;              
            GeneratorTorqueController.Sway_Ddot_measured = s.Sway_Ddot_measured; BladePitchController.Sway_Ddot_measured = s.Sway_Ddot_measured; PIGainScheduledOTC.Sway_Ddot_measured = s.Sway_Ddot_measured;      
            GeneratorTorqueController.Heave_measured = s.Heave_measured; BladePitchController.Heave_measured = s.Heave_measured; PIGainScheduledOTC.Heave_measured = s.Heave_measured;
            GeneratorTorqueController.Heave_dot_measured = s.Heave_dot_measured; BladePitchController.Heave_dot_measured = s.Heave_dot_measured; PIGainScheduledOTC.Heave_dot_measured = s.Heave_dot_measured;            
            GeneratorTorqueController.Heave_Ddot_measured = s.Heave_Ddot_measured; BladePitchController.Heave_Ddot_measured = s.Heave_Ddot_measured; PIGainScheduledOTC.Heave_Ddot_measured = s.Heave_Ddot_measured;
            GeneratorTorqueController.RollAngle_measured = s.RollAngle_measured; BladePitchController.RollAngle_measured = s.RollAngle_measured; PIGainScheduledOTC.RollAngle_measured = s.RollAngle_measured;           
            GeneratorTorqueController.RollAngle_dot_measured = s.RollAngle_dot_measured; BladePitchController.RollAngle_dot_measured = s.RollAngle_dot_measured; PIGainScheduledOTC.RollAngle_dot_measured = s.RollAngle_dot_measured; 
            GeneratorTorqueController.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured; BladePitchController.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured; PIGainScheduledOTC.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured;    
            GeneratorTorqueController.PitchAngle_measured = s.PitchAngle_measured; BladePitchController.PitchAngle_measured = s.PitchAngle_measured; PIGainScheduledOTC.PitchAngle_measured = s.PitchAngle_measured;
            GeneratorTorqueController.PitchAngle_dot_measured = s.PitchAngle_dot_measured; BladePitchController.PitchAngle_dot_measured = s.PitchAngle_dot_measured; PIGainScheduledOTC.PitchAngle_dot_measured = s.PitchAngle_dot_measured;
            GeneratorTorqueController.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured; BladePitchController.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured; PIGainScheduledOTC.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured;            
            GeneratorTorqueController.YawAngle_measured = s.YawAngle_measured; BladePitchController.YawAngle_measured = s.YawAngle_measured; PIGainScheduledOTC.YawAngle_measured = s.YawAngle_measured;        
            GeneratorTorqueController.YawAngle_dot_measured = s.YawAngle_dot_measured; BladePitchController.YawAngle_dot_measured = s.YawAngle_dot_measured; PIGainScheduledOTC.YawAngle_dot_measured = s.YawAngle_dot_measured;            
            GeneratorTorqueController.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured; BladePitchController.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured; PIGainScheduledOTC.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured;

        end
        %
    else
        GeneratorTorqueController.OmegaR_measured = [GeneratorTorqueController.OmegaR_measured;s.OmegaR_measured]; GeneratorTorqueController.OmegaG_measured = [GeneratorTorqueController.OmegaG_measured;s.OmegaG_measured]; GeneratorTorqueController.Beta_measured = [GeneratorTorqueController.Beta_measured;s.Beta_measured]; GeneratorTorqueController.Tg_measured = [GeneratorTorqueController.Tg_measured;s.Tg_measured]; GeneratorTorqueController.Pe_measured = [GeneratorTorqueController.Pe_measured;s.Pe_measured]; GeneratorTorqueController.WindSpedd_hub_measured = [GeneratorTorqueController.WindSpedd_hub_measured;s.WindSpedd_hub_measured];
        BladePitchController.OmegaR_measured = [BladePitchController.OmegaR_measured;s.OmegaR_measured]; BladePitchController.OmegaG_measured = [BladePitchController.OmegaG_measured;s.OmegaG_measured]; BladePitchController.Beta_measured = [BladePitchController.Beta_measured;s.Beta_measured]; BladePitchController.Tg_measured = [BladePitchController.Tg_measured;s.Tg_measured]; BladePitchController.Pe_measured = [BladePitchController.Pe_measured;s.Pe_measured]; BladePitchController.WindSpedd_hub_measured = [BladePitchController.WindSpedd_hub_measured;s.WindSpedd_hub_measured];    
        PIGainScheduledOTC.OmegaR_measured = [PIGainScheduledOTC.OmegaR_measured;s.OmegaR_measured]; PIGainScheduledOTC.OmegaG_measured = [PIGainScheduledOTC.OmegaG_measured;s.OmegaG_measured]; PIGainScheduledOTC.Beta_measured = [PIGainScheduledOTC.Beta_measured;s.Beta_measured]; PIGainScheduledOTC.Tg_measured = [PIGainScheduledOTC.Tg_measured;s.Tg_measured]; PIGainScheduledOTC.Pe_measured = [PIGainScheduledOTC.Pe_measured;s.Pe_measured]; PIGainScheduledOTC.WindSpedd_hub_measured = [PIGainScheduledOTC.WindSpedd_hub_measured;s.WindSpedd_hub_measured];    
        PIGainScheduledOTC.Xt_measured = [PIGainScheduledOTC.Xt_measured;s.Xt_measured]; GeneratorTorqueController.Xt_measured = [GeneratorTorqueController.Xt_measured;s.Xt_measured]; BladePitchController.Xt_measured = [BladePitchController.Xt_measured;s.Xt_measured];
        PIGainScheduledOTC.Xt_dot_measured = [PIGainScheduledOTC.Xt_dot_measured;s.Xt_dot_measured]; GeneratorTorqueController.Xt_dot_measured = [GeneratorTorqueController.Xt_dot_measured;s.Xt_dot_measured]; BladePitchController.Xt_dot_measured = [BladePitchController.Xt_dot_measured;s.Xt_dot_measured];        
        PIGainScheduledOTC.Xt_Ddot_measured = [PIGainScheduledOTC.Xt_Ddot_measured;s.Xt_Ddot_measured]; GeneratorTorqueController.Xt_Ddot_measured = [GeneratorTorqueController.Xt_Ddot_measured;s.Xt_Ddot_measured]; BladePitchController.Xt_Ddot_measured = [BladePitchController.Xt_Ddot_measured;s.Xt_Ddot_measured];
        if s.Option02f2 > 1
            % Offshore wind turbine  
            GeneratorTorqueController.Surge_measured = [GeneratorTorqueController.Surge_measured;s.Surge_measured]; BladePitchController.Surge_measured = [BladePitchController.Surge_measured;s.Surge_measured]; PIGainScheduledOTC.Surge_measured = [PIGainScheduledOTC.Surge_measured;s.Surge_measured];
            GeneratorTorqueController.Surge_dot_measured = [GeneratorTorqueController.Surge_dot_measured;s.Surge_dot_measured]; BladePitchController.Surge_dot_measured = [BladePitchController.Surge_dot_measured;s.Surge_dot_measured]; PIGainScheduledOTC.Surge_dot_measured = [PIGainScheduledOTC.Surge_dot_measured;s.Surge_dot_measured];
            GeneratorTorqueController.Surge_Ddot_measured = [GeneratorTorqueController.Surge_Ddot_measured;s.Surge_Ddot_measured]; BladePitchController.Surge_Ddot_measured = [BladePitchController.Surge_Ddot_measured;s.Surge_Ddot_measured]; PIGainScheduledOTC.Surge_Ddot_measured = [PIGainScheduledOTC.Surge_Ddot_measured;s.Surge_Ddot_measured];
            GeneratorTorqueController.Sway_measured = [GeneratorTorqueController.Sway_measured;s.Sway_measured]; BladePitchController.Sway_measured = [BladePitchController.Sway_measured;s.Sway_measured]; PIGainScheduledOTC.Sway_measured = [PIGainScheduledOTC.Sway_measured;s.Sway_measured];
            GeneratorTorqueController.Sway_dot_measured = [GeneratorTorqueController.Sway_dot_measured;s.Sway_dot_measured]; BladePitchController.Sway_dot_measured = [BladePitchController.Sway_dot_measured;s.Sway_dot_measured]; PIGainScheduledOTC.Sway_dot_measured = [PIGainScheduledOTC.Sway_dot_measured;s.Sway_dot_measured];
            GeneratorTorqueController.Sway_Ddot_measured = [GeneratorTorqueController.Sway_Ddot_measured;s.Sway_Ddot_measured]; BladePitchController.Sway_Ddot_measured = [BladePitchController.Sway_Ddot_measured;s.Sway_Ddot_measured]; PIGainScheduledOTC.Sway_Ddot_measured = [PIGainScheduledOTC.Sway_Ddot_measured;s.Sway_Ddot_measured];
            GeneratorTorqueController.Heave_measured = [GeneratorTorqueController.Heave_measured;s.Heave_measured]; BladePitchController.Heave_measured = [BladePitchController.Heave_measured;s.Heave_measured]; PIGainScheduledOTC.Heave_measured = [PIGainScheduledOTC.Heave_measured;s.Heave_measured];
            GeneratorTorqueController.Heave_dot_measured = [GeneratorTorqueController.Heave_dot_measured;s.Heave_dot_measured]; BladePitchController.Heave_dot_measured = [BladePitchController.Heave_dot_measured;s.Heave_dot_measured]; PIGainScheduledOTC.Heave_dot_measured = [PIGainScheduledOTC.Heave_dot_measured;s.Heave_dot_measured];
            GeneratorTorqueController.Heave_Ddot_measured = [GeneratorTorqueController.Heave_Ddot_measured;s.Heave_Ddot_measured]; BladePitchController.Heave_Ddot_measured = [BladePitchController.Heave_Ddot_measured;s.Heave_Ddot_measured]; PIGainScheduledOTC.Heave_Ddot_measured = [PIGainScheduledOTC.Heave_Ddot_measured;s.Heave_Ddot_measured];
            GeneratorTorqueController.RollAngle_measured = [GeneratorTorqueController.RollAngle_measured;s.RollAngle_measured]; BladePitchController.RollAngle_measured = [BladePitchController.RollAngle_measured;s.RollAngle_measured]; PIGainScheduledOTC.RollAngle_measured = [PIGainScheduledOTC.RollAngle_measured;s.RollAngle_measured];
            GeneratorTorqueController.RollAngle_dot_measured = [GeneratorTorqueController.RollAngle_dot_measured;s.RollAngle_dot_measured]; BladePitchController.RollAngle_dot_measured = [BladePitchController.RollAngle_dot_measured;s.RollAngle_dot_measured]; PIGainScheduledOTC.RollAngle_dot_measured = [PIGainScheduledOTC.RollAngle_dot_measured;s.RollAngle_dot_measured];
            GeneratorTorqueController.RollAngle_Ddot_measured = [GeneratorTorqueController.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured]; BladePitchController.RollAngle_Ddot_measured = [BladePitchController.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured]; PIGainScheduledOTC.RollAngle_Ddot_measured = [PIGainScheduledOTC.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured];
            GeneratorTorqueController.PitchAngle_measured = [GeneratorTorqueController.PitchAngle_measured;s.PitchAngle_measured]; BladePitchController.PitchAngle_measured = [BladePitchController.PitchAngle_measured;s.PitchAngle_measured]; PIGainScheduledOTC.PitchAngle_measured = [PIGainScheduledOTC.PitchAngle_measured;s.PitchAngle_measured];
            GeneratorTorqueController.PitchAngle_dot_measured = [GeneratorTorqueController.PitchAngle_dot_measured;s.PitchAngle_dot_measured]; BladePitchController.PitchAngle_dot_measured = [BladePitchController.PitchAngle_dot_measured;s.PitchAngle_dot_measured]; PIGainScheduledOTC.PitchAngle_dot_measured = [PIGainScheduledOTC.PitchAngle_dot_measured;s.PitchAngle_dot_measured];
            GeneratorTorqueController.PitchAngle_Ddot_measured = [GeneratorTorqueController.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured]; BladePitchController.PitchAngle_Ddot_measured = [BladePitchController.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured]; PIGainScheduledOTC.PitchAngle_Ddot_measured = [PIGainScheduledOTC.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured];            
            GeneratorTorqueController.YawAngle_measured = [GeneratorTorqueController.YawAngle_measured;s.YawAngle_measured];  BladePitchController.YawAngle_measured = [BladePitchController.YawAngle_measured;s.YawAngle_measured]; PIGainScheduledOTC.YawAngle_measured = [PIGainScheduledOTC.YawAngle_measured;s.YawAngle_measured];  
            GeneratorTorqueController.YawAngle_dot_measured = [GeneratorTorqueController.YawAngle_dot_measured;s.YawAngle_dot_measured];  BladePitchController.YawAngle_dot_measured = [BladePitchController.YawAngle_dot_measured;s.YawAngle_dot_measured]; PIGainScheduledOTC.YawAngle_dot_measured = [PIGainScheduledOTC.YawAngle_dot_measured;s.YawAngle_dot_measured];   
            GeneratorTorqueController.YawAngle_Ddot_measured = [GeneratorTorqueController.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured];  BladePitchController.YawAngle_Ddot_measured = [BladePitchController.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured]; PIGainScheduledOTC.YawAngle_Ddot_measured = [PIGainScheduledOTC.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured];             
        end
        %        
    end


    % ---------- LOGICAL INSTANCE 04  ----------
    PIGainScheduledOTC.InputsLPF1_unfiltered = s.InputsLPF1_unfiltered; PIGainScheduledOTC.InputsLPF1_unfiltered = s.InputsLPF1_unfiltered; PIGainScheduledOTC.CutFreq_LPF1 = s.CutFreq_LPF1; PIGainScheduledOTC.Ts_LPF1 = s.Ts_LPF1; PIGainScheduledOTC.alfa_LPF1 = s.alfa_LPF1; PIGainScheduledOTC.Ad_LPF1 = s.Ad_LPF1; PIGainScheduledOTC.Cd_LPF1 = s.Cd_LPF1; PIGainScheduledOTC.Dd_LPF1 = s.Dd_LPF1; PIGainScheduledOTC.OutputsLPF1_filtered = s.OutputsLPF1_filtered;
    if it == 1
        GeneratorTorqueController.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; BladePitchController.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; PIGainScheduledOTC.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; 
        GeneratorTorqueController.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1; BladePitchController.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1; PIGainScheduledOTC.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1;     
        GeneratorTorqueController.Beta_filteredLPF1 = s.Beta_filteredLPF1; BladePitchController.Beta_filteredLPF1 = s.Beta_filteredLPF1; PIGainScheduledOTC.Beta_filteredLPF1 = s.Beta_filteredLPF1; 
        GeneratorTorqueController.Tg_filteredLPF1 = s.Tg_filteredLPF1; BladePitchController.Tg_filteredLPF1 = s.Tg_filteredLPF1; PIGainScheduledOTC.Tg_filteredLPF1 = s.Tg_filteredLPF1; 
        GeneratorTorqueController.Pe_filteredLPF1 = s.Pe_filteredLPF1; BladePitchController.Pe_filteredLPF1 = s.Pe_filteredLPF1; PIGainScheduledOTC.Pe_filteredLPF1 = s.Pe_filteredLPF1; 
        GeneratorTorqueController.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1; BladePitchController.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1; PIGainScheduledOTC.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1;        
        % GeneratorTorqueController.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3; BladePitchController.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3; PIGainScheduledOTC.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3;            
        %
    else
        GeneratorTorqueController.OmegaR_filteredLPF1 = [GeneratorTorqueController.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; BladePitchController.OmegaR_filteredLPF1 = [BladePitchController.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; PIGainScheduledOTC.OmegaR_filteredLPF1 = [PIGainScheduledOTC.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; 
        GeneratorTorqueController.OmegaG_filteredLPF1 = [GeneratorTorqueController.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1]; BladePitchController.OmegaG_filteredLPF1 = [BladePitchController.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1]; PIGainScheduledOTC.OmegaG_filteredLPF1 = [PIGainScheduledOTC.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1];     
        GeneratorTorqueController.Beta_filteredLPF1 = [GeneratorTorqueController.Beta_filteredLPF1;s.Beta_filteredLPF1]; BladePitchController.Beta_filteredLPF1 = [BladePitchController.Beta_filteredLPF1;s.Beta_filteredLPF1]; PIGainScheduledOTC.Beta_filteredLPF1 = [PIGainScheduledOTC.Beta_filteredLPF1;s.Beta_filteredLPF1]; 
        GeneratorTorqueController.Tg_filteredLPF1 = [GeneratorTorqueController.Tg_filteredLPF1;s.Tg_filteredLPF1]; BladePitchController.Tg_filteredLPF1 = [BladePitchController.Tg_filteredLPF1;s.Tg_filteredLPF1]; PIGainScheduledOTC.Tg_filteredLPF1 = [PIGainScheduledOTC.Tg_filteredLPF1;s.Tg_filteredLPF1]; 
        GeneratorTorqueController.Pe_filteredLPF1 = [GeneratorTorqueController.Pe_filteredLPF1;s.Pe_filteredLPF1]; BladePitchController.Pe_filteredLPF1 = [BladePitchController.Pe_filteredLPF1;s.Pe_filteredLPF1]; PIGainScheduledOTC.Pe_filteredLPF1 = [PIGainScheduledOTC.Pe_filteredLPF1;s.Pe_filteredLPF1];
        GeneratorTorqueController.WindSpedd_hub_filteredLPF1 = [GeneratorTorqueController.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1]; BladePitchController.WindSpedd_hub_filteredLPF1 = [BladePitchController.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1]; PIGainScheduledOTC.WindSpedd_hub_filteredLPF1 = [PIGainScheduledOTC.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1];              
        % GeneratorTorqueController.Vews_est_filteredLPF1 = [GeneratorTorqueController.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; BladePitchController.Vews_est_filteredLPF1 = [BladePitchController.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; PIGainScheduledOTC.Vews_est_filteredLPF1 = [PIGainScheduledOTC.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; 
        %
    end


    % ---------- LOGICAL INSTANCE 05  ----------
    if (s.Option02f2 > 1) || (s.Option04f3 == 1) 
        if (s.Option04f8 < 3)
            PIGainScheduledOTC.CutFreq_HighPass = s.CutFreq_HighPass; PIGainScheduledOTC.omega0_HighPass = s.omega0_HighPass; PIGainScheduledOTC.CutFreq_HighPass = s.K_HighPass; PIGainScheduledOTC.CutFreq_HighPass = s.alpha_HighPass; PIGainScheduledOTC.CutFreq_HighPass = s.a0_HighPass; PIGainScheduledOTC.a1_HighPass = s.a1_HighPass; PIGainScheduledOTC.b1_HighPass = s.b1_HighPass;    
            PIGainScheduledOTC.CutFreq_Notch = s.CutFreq_Notch; PIGainScheduledOTC.Damp_Notch = s.Damp_Notch; PIGainScheduledOTC.omega0_Notch = s.omega0_Notch; PIGainScheduledOTC.b2_Notch = s.b2_Notch; PIGainScheduledOTC.b0_Notch = s.b0_Notch; PIGainScheduledOTC.a2_Notch = s.a2_Notch; PIGainScheduledOTC.a1_Notch = s.a1_Notch; PIGainScheduledOTC.a0_Notch = s.a0_Notch;       

            if it == 1
                PIGainScheduledOTC.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered; GeneratorTorqueController.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered; BladePitchController.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered;        
                PIGainScheduledOTC.InputsHPF1_filtered = s.InputsHPF1_filtered; PIGainScheduledOTC.InputsHPF1_unfiltered = s.InputsHPF1_unfiltered; PIGainScheduledOTC.OutputsHPF1_filtered = s.OutputsHPF1_filtered;
                PIGainScheduledOTC.Outputs_notched = s.Outputs_notched;            
                GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; BladePitchController.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; PIGainScheduledOTC.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; GeneratorTorqueController.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; BladePitchController.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; PIGainScheduledOTC.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; GeneratorTorqueController.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; BladePitchController.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; PIGainScheduledOTC.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; 
                if s.Option02f2 > 1
                    % Offshore wind turbine 
                    GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; BladePitchController.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; PIGainScheduledOTC.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; GeneratorTorqueController.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; BladePitchController.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; PIGainScheduledOTC.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; GeneratorTorqueController.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF; BladePitchController.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF; PIGainScheduledOTC.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF;                        
                    GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; BladePitchController.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; PIGainScheduledOTC.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; GeneratorTorqueController.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; BladePitchController.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; PIGainScheduledOTC.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; GeneratorTorqueController.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF; BladePitchController.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF; PIGainScheduledOTC.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF;             
                    GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; BladePitchController.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; PIGainScheduledOTC.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; GeneratorTorqueController.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; BladePitchController.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; PIGainScheduledOTC.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; GeneratorTorqueController.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF; BladePitchController.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF; PIGainScheduledOTC.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF;                        
                    GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; BladePitchController.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; PIGainScheduledOTC.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; GeneratorTorqueController.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; BladePitchController.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; PIGainScheduledOTC.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; GeneratorTorqueController.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF; BladePitchController.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF; PIGainScheduledOTC.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF;                        
                    GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; BladePitchController.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; PIGainScheduledOTC.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; GeneratorTorqueController.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; BladePitchController.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; PIGainScheduledOTC.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; GeneratorTorqueController.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF; BladePitchController.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF; PIGainScheduledOTC.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF;            
                    GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; BladePitchController.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; PIGainScheduledOTC.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; GeneratorTorqueController.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; BladePitchController.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; PIGainScheduledOTC.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; GeneratorTorqueController.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF; BladePitchController.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF; PIGainScheduledOTC.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF;     
                end
                %
            else
                PIGainScheduledOTC.OutputsLPF2B_filtered = [PIGainScheduledOTC.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered]; GeneratorTorqueController.OutputsLPF2B_filtered = [GeneratorTorqueController.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered]; BladePitchController.OutputsLPF2B_filtered = [BladePitchController.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered];
                PIGainScheduledOTC.InputsHPF1_filtered = [PIGainScheduledOTC.InputsHPF1_filtered;s.InputsHPF1_filtered]; PIGainScheduledOTC.InputsHPF1_unfiltered = [PIGainScheduledOTC.InputsHPF1_unfiltered;s.InputsHPF1_unfiltered]; PIGainScheduledOTC.OutputsHPF1_filtered = [PIGainScheduledOTC.OutputsHPF1_filtered;s.OutputsHPF1_filtered]; 
                PIGainScheduledOTC.Outputs_notched = [PIGainScheduledOTC.Outputs_notched;s.Outputs_notched];
                
                GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; BladePitchController.Xt_Ddot_LPF2Bfiltered = [BladePitchController.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; PIGainScheduledOTC.Xt_Ddot_LPF2Bfiltered = [PIGainScheduledOTC.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Xt_Ddot_filteredHPF1 = [GeneratorTorqueController.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; BladePitchController.Xt_Ddot_filteredHPF1 = [BladePitchController.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; PIGainScheduledOTC.Xt_Ddot_filteredHPF1 = [PIGainScheduledOTC.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; GeneratorTorqueController.Xt_Ddot_filteredNF = [GeneratorTorqueController.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF]; BladePitchController.Xt_Ddot_filteredNF = [BladePitchController.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF]; PIGainScheduledOTC.Xt_Ddot_filteredNF = [PIGainScheduledOTC.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF];         
                if s.Option02f2 > 1
                    % Offshore wind turbine 
                    GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; BladePitchController.Surge_Ddot_LPF2Bfiltered = [BladePitchController.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; PIGainScheduledOTC.Surge_Ddot_LPF2Bfiltered = [PIGainScheduledOTC.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Surge_Ddot_filteredHPF1 = [GeneratorTorqueController.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; BladePitchController.Surge_Ddot_filteredHPF1 = [BladePitchController.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; PIGainScheduledOTC.Surge_Ddot_filteredHPF1 = [PIGainScheduledOTC.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; GeneratorTorqueController.Surge_Ddot_filteredNF = [GeneratorTorqueController.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF]; BladePitchController.Surge_Ddot_filteredNF = [BladePitchController.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF]; PIGainScheduledOTC.Surge_Ddot_filteredNF = [PIGainScheduledOTC.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF];
                    GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; BladePitchController.Sway_Ddot_LPF2Bfiltered = [BladePitchController.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; PIGainScheduledOTC.Sway_Ddot_LPF2Bfiltered = [PIGainScheduledOTC.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Sway_Ddot_filteredHPF1 = [GeneratorTorqueController.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; BladePitchController.Sway_Ddot_filteredHPF1 = [BladePitchController.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; PIGainScheduledOTC.Sway_Ddot_filteredHPF1 = [PIGainScheduledOTC.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; GeneratorTorqueController.Sway_Ddot_filteredNF = [GeneratorTorqueController.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF]; BladePitchController.Sway_Ddot_filteredNF = [BladePitchController.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF]; PIGainScheduledOTC.Sway_Ddot_filteredNF = [PIGainScheduledOTC.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF];             
                    GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered]; BladePitchController.Heave_Ddot_LPF2Bfiltered = [BladePitchController.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered]; PIGainScheduledOTC.Heave_Ddot_LPF2Bfiltered = [PIGainScheduledOTC.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered];
                    GeneratorTorqueController.Heave_Ddot_filteredHPF1 = [GeneratorTorqueController.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; BladePitchController.Heave_Ddot_filteredHPF1 = [BladePitchController.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; PIGainScheduledOTC.Heave_Ddot_filteredHPF1 = [PIGainScheduledOTC.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; GeneratorTorqueController.Heave_Ddot_filteredNF = [GeneratorTorqueController.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF]; BladePitchController.Heave_Ddot_filteredNF = [BladePitchController.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF]; PIGainScheduledOTC.Heave_Ddot_filteredNF = [PIGainScheduledOTC.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF];
                    GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered]; BladePitchController.RollAngle_dot_LPF2Bfiltered = [BladePitchController.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered]; PIGainScheduledOTC.RollAngle_dot_LPF2Bfiltered = [PIGainScheduledOTC.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered];  GeneratorTorqueController.RollAngle_dot_filteredHPF1 = [GeneratorTorqueController.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1]; BladePitchController.RollAngle_dot_filteredHPF1 = [BladePitchController.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1];  PIGainScheduledOTC.RollAngle_dot_filteredHPF1 = [PIGainScheduledOTC.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1]; GeneratorTorqueController.RollAngle_dot_filteredNF = [GeneratorTorqueController.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF]; BladePitchController.RollAngle_dot_filteredNF = [BladePitchController.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF]; PIGainScheduledOTC.RollAngle_dot_filteredNF = [PIGainScheduledOTC.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF];                        
                    GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; BladePitchController.PitchAngle_dot_LPF2Bfiltered = [BladePitchController.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; PIGainScheduledOTC.PitchAngle_dot_LPF2Bfiltered = [PIGainScheduledOTC.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; GeneratorTorqueController.PitchAngle_dot_filteredHPF1 = [GeneratorTorqueController.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; BladePitchController.PitchAngle_dot_filteredHPF1 = [BladePitchController.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; PIGainScheduledOTC.PitchAngle_dot_filteredHPF1 = [PIGainScheduledOTC.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; GeneratorTorqueController.PitchAngle_dot_filteredNF = [GeneratorTorqueController.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF]; BladePitchController.PitchAngle_dot_filteredNF = [BladePitchController.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF]; PIGainScheduledOTC.PitchAngle_dot_filteredNF = [PIGainScheduledOTC.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF];            
                    GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; BladePitchController.YawAngle_dot_LPF2Bfiltered = [BladePitchController.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; PIGainScheduledOTC.YawAngle_dot_LPF2Bfiltered = [PIGainScheduledOTC.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; GeneratorTorqueController.YawAngle_dot_filteredHPF1 = [GeneratorTorqueController.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; BladePitchController.YawAngle_dot_filteredHPF1 = [BladePitchController.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; PIGainScheduledOTC.YawAngle_dot_filteredHPF1 = [PIGainScheduledOTC.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; GeneratorTorqueController.YawAngle_dot_filteredNF = [GeneratorTorqueController.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF]; BladePitchController.YawAngle_dot_filteredNF = [BladePitchController.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF]; PIGainScheduledOTC.YawAngle_dot_filteredNF = [PIGainScheduledOTC.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF];
                end
                %
            end % if it == 1
            %
        end % if (s.Option04f8 < 3)
    end % if (s.Option02f2 > 1) || (s.Option04f3 == 1) 



    % ---------- LOGICAL INSTANCE 06  ----------
    if it == 1
        GeneratorTorqueController.OmegaR_filtered = s.OmegaR_filtered; BladePitchController.OmegaR_filtered = s.OmegaR_filtered; PIGainScheduledOTC.OmegaR_filtered = s.OmegaR_filtered;
        GeneratorTorqueController.OmegaG_filtered = s.OmegaG_filtered; BladePitchController.OmegaG_filtered = s.OmegaG_filtered; PIGainScheduledOTC.OmegaG_filtered = s.OmegaG_filtered;
        GeneratorTorqueController.Beta_filtered = s.Beta_filtered; BladePitchController.Beta_filtered = s.Beta_filtered; PIGainScheduledOTC.Beta_filtered = s.Beta_filtered;
        GeneratorTorqueController.Tg_filtered = s.Tg_filtered; BladePitchController.Tg_filtered = s.Tg_filtered; PIGainScheduledOTC.Tg_filtered = s.Tg_filtered;      
        GeneratorTorqueController.Pe_filtered = s.Pe_filtered; BladePitchController.Pe_filtered = s.Pe_filtered; PIGainScheduledOTC.Pe_filtered = s.Pe_filtered;
        GeneratorTorqueController.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered; BladePitchController.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered; PIGainScheduledOTC.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered;

        GeneratorTorqueController.Vews_op = s.Vews_op; BladePitchController.Vews_op = s.Vews_op; PIGainScheduledOTC.Vews_op = s.Vews_op;
        PIGainScheduledOTC.GradTaBeta_dop = s.GradTaBeta_dop; BladePitchController.GradTaBeta_dop = s.GradTaBeta_dop; GeneratorTorqueController.GradTaBeta_dop = s.GradTaBeta_dop;
        PIGainScheduledOTC.GradTaOmega_dop = s.GradTaOmega_dop; GeneratorTorqueController.GradTaOmega_dop = s.GradTaOmega_dop; BladePitchController.GradTaOmega_dop = s.GradTaOmega_dop;
        PIGainScheduledOTC.GradTaVop_dop = s.GradTaVop_dop; GeneratorTorqueController.GradTaVop_dop = s.GradTaVop_dop; BladePitchController.GradTaVop_dop = s.GradTaVop_dop;       
        PIGainScheduledOTC.GradFaOmega_dop = s.GradFaOmega_dop; BladePitchController.GradFaOmega_dop = s.GradFaOmega_dop; GeneratorTorqueController.GradFaOmega_dop = s.GradFaOmega_dop;
        PIGainScheduledOTC.GradFaVop_dop = s.GradFaVop_dop; BladePitchController.GradFaVop_dop = s.GradFaVop_dop; GeneratorTorqueController.GradFaVop_dop = s.GradFaVop_dop;
        PIGainScheduledOTC.GradFaBeta_dop = s.GradFaBeta_dop; BladePitchController.GradFaBeta_dop = s.GradFaBeta_dop; GeneratorTorqueController.GradFaBeta_dop = s.GradFaBeta_dop;            
        PIGainScheduledOTC.Betad_op = s.Betad_op; BladePitchController.Betad_op = s.Betad_op;
        PIGainScheduledOTC.Tgd_op = s.Tgd_op; GeneratorTorqueController.Tgd_op = s.Tgd_op;
        PIGainScheduledOTC.OmegaRd_op = s.OmegaRd_op; GeneratorTorqueController.OmegaRd_op = s.OmegaRd_op;        
        
        GeneratorTorqueController.Xt_Ddot_filtered = s.Xt_Ddot_filtered; BladePitchController.Xt_Ddot_filtered = s.Xt_Ddot_filtered; PIGainScheduledOTC.Xt_Ddot_filtered = s.Xt_Ddot_filtered;        
        if (s.Option04f8 < 3)            
            if s.Option02f2 >= 2
                GeneratorTorqueController.Surge_Ddot_filtered = s.Surge_Ddot_filtered; BladePitchController.Surge_Ddot_filtered = s.Surge_Ddot_filtered; PIGainScheduledOTC.Surge_Ddot_filtered = s.Surge_Ddot_filtered;            
                GeneratorTorqueController.Sway_Ddot_filtered = s.Sway_Ddot_filtered; BladePitchController.Sway_Ddot_filtered = s.Sway_Ddot_filtered; PIGainScheduledOTC.Sway_Ddot_filtered = s.Sway_Ddot_filtered;            
                GeneratorTorqueController.Heave_Ddot_filtered = s.Heave_Ddot_filtered; BladePitchController.Heave_Ddot_filtered = s.Heave_Ddot_filtered; PIGainScheduledOTC.Heave_Ddot_filtered = s.Heave_Ddot_filtered;             
                GeneratorTorqueController.RollAngle_dot_filtered = s.RollAngle_dot_filtered; BladePitchController.RollAngle_dot_filtered = s.RollAngle_dot_filtered; PIGainScheduledOTC.RollAngle_dot_filtered = s.RollAngle_dot_filtered;            
                GeneratorTorqueController.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered; BladePitchController.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered; PIGainScheduledOTC.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered;          
                GeneratorTorqueController.YawAngle_dot_filtered = s.YawAngle_dot_filtered; BladePitchController.YawAngle_dot_filtered = s.YawAngle_dot_filtered; PIGainScheduledOTC.YawAngle_dot_filtered = s.YawAngle_dot_filtered;
            end
        end
        %
    else
        GeneratorTorqueController.OmegaR_filtered = [GeneratorTorqueController.OmegaR_filtered;s.OmegaR_filtered]; BladePitchController.OmegaR_filtered = [BladePitchController.OmegaR_filtered;s.OmegaR_filtered]; PIGainScheduledOTC.OmegaR_filtered = [PIGainScheduledOTC.OmegaR_filtered;s.OmegaR_filtered];        
        GeneratorTorqueController.OmegaG_filtered = [GeneratorTorqueController.OmegaG_filtered;s.OmegaG_filtered]; BladePitchController.OmegaG_filtered = [BladePitchController.OmegaG_filtered;s.OmegaG_filtered]; PIGainScheduledOTC.OmegaG_filtered = [PIGainScheduledOTC.OmegaG_filtered;s.OmegaG_filtered];
        GeneratorTorqueController.Beta_filtered = [GeneratorTorqueController.Beta_filtered;s.Beta_filtered]; BladePitchController.Beta_filtered = [BladePitchController.Beta_filtered;s.Beta_filtered]; PIGainScheduledOTC.Beta_filtered = [PIGainScheduledOTC.Beta_filtered;s.Beta_filtered];
        GeneratorTorqueController.Tg_filtered = [GeneratorTorqueController.Tg_filtered;s.Tg_filtered]; BladePitchController.Tg_filtered = [BladePitchController.Tg_filtered;s.Tg_filtered]; PIGainScheduledOTC.Tg_filtered = [PIGainScheduledOTC.Tg_filtered;s.Tg_filtered];        
        GeneratorTorqueController.Pe_filtered = [GeneratorTorqueController.Pe_filtered;s.Pe_filtered]; BladePitchController.Pe_filtered = [BladePitchController.Pe_filtered;s.Pe_filtered]; PIGainScheduledOTC.Pe_filtered = [PIGainScheduledOTC.Pe_filtered;s.Pe_filtered];   
        GeneratorTorqueController.WindSpedd_hub_filtered = [GeneratorTorqueController.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered]; BladePitchController.WindSpedd_hub_filtered = [BladePitchController.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered]; PIGainScheduledOTC.WindSpedd_hub_filtered = [PIGainScheduledOTC.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered];        
        
        GeneratorTorqueController.Vews_op = [GeneratorTorqueController.Vews_op;s.Vews_op]; BladePitchController.Vews_op = [BladePitchController.Vews_op;s.Vews_op]; PIGainScheduledOTC.Vews_op = [PIGainScheduledOTC.Vews_op;s.Vews_op];                    
        PIGainScheduledOTC.GradTaBeta_dop = [PIGainScheduledOTC.GradTaBeta_dop;s.GradTaBeta_dop]; BladePitchController.GradTaBeta_dop = [BladePitchController.GradTaBeta_dop;s.GradTaBeta_dop]; GeneratorTorqueController.GradTaBeta_dop = [GeneratorTorqueController.GradTaBeta_dop;s.GradTaBeta_dop];
        PIGainScheduledOTC.GradTaOmega_dop = [PIGainScheduledOTC.GradTaOmega_dop;s.GradTaOmega_dop]; GeneratorTorqueController.GradTaOmega_dop = [GeneratorTorqueController.GradTaOmega_dop;s.GradTaOmega_dop]; BladePitchController.GradTaOmega_dop = [BladePitchController.GradTaOmega_dop;s.GradTaOmega_dop];
        PIGainScheduledOTC.GradTaVop_dop = [PIGainScheduledOTC.GradTaVop_dop;s.GradTaVop_dop]; GeneratorTorqueController.GradTaVop_dop = [GeneratorTorqueController.GradTaVop_dop;s.GradTaVop_dop]; BladePitchController.GradTaVop_dop = [BladePitchController.GradTaVop_dop;s.GradTaVop_dop];        
        PIGainScheduledOTC.GradFaOmega_dop = [PIGainScheduledOTC.GradFaOmega_dop;s.GradFaOmega_dop]; BladePitchController.GradFaOmega_dop = [BladePitchController.GradFaOmega_dop;s.GradFaOmega_dop]; GeneratorTorqueController.GradFaOmega_dop = [GeneratorTorqueController.GradFaOmega_dop;s.GradFaOmega_dop];
        PIGainScheduledOTC.GradFaVop_dop = [PIGainScheduledOTC.GradFaVop_dop;s.GradFaVop_dop]; BladePitchController.GradFaVop_dop = [BladePitchController.GradFaVop_dop;s.GradFaVop_dop]; GeneratorTorqueController.GradFaVop_dop = [GeneratorTorqueController.GradFaVop_dop;s.GradFaVop_dop];
        PIGainScheduledOTC.GradFaBeta_dop = [PIGainScheduledOTC.GradFaBeta_dop;s.GradFaBeta_dop]; BladePitchController.GradFaBeta_dop = [BladePitchController.GradFaBeta_dop;s.GradFaBeta_dop]; GeneratorTorqueController.GradFaBeta_dop = [GeneratorTorqueController.GradFaBeta_dop;s.GradFaBeta_dop];            
        PIGainScheduledOTC.Betad_op = [PIGainScheduledOTC.Betad_op;s.Betad_op]; BladePitchController.Betad_op = [BladePitchController.Betad_op;s.Betad_op];
        PIGainScheduledOTC.Tgd_op = [PIGainScheduledOTC.Tgd_op;s.Tgd_op]; GeneratorTorqueController.Tgd_op = [GeneratorTorqueController.Tgd_op;s.Tgd_op];
        PIGainScheduledOTC.OmegaRd_op = [PIGainScheduledOTC.OmegaRd_op;s.OmegaRd_op]; GeneratorTorqueController.OmegaRd_op = [GeneratorTorqueController.OmegaRd_op;s.OmegaRd_op];        

        GeneratorTorqueController.Xt_Ddot_filtered = [GeneratorTorqueController.Xt_Ddot_filtered;s.Xt_Ddot_filtered]; BladePitchController.Xt_Ddot_filtered = [BladePitchController.Xt_Ddot_filtered;s.Xt_Ddot_filtered]; PIGainScheduledOTC.Xt_Ddot_filtered = [PIGainScheduledOTC.Xt_Ddot_filtered;s.Xt_Ddot_filtered];
        if (s.Option04f8 < 3)            
            if s.Option02f2 >= 2
                GeneratorTorqueController.Surge_Ddot_filtered = [GeneratorTorqueController.Surge_Ddot_filtered;s.Surge_Ddot_filtered]; BladePitchController.Surge_Ddot_filtered = [BladePitchController.Surge_Ddot_filtered;s.Surge_Ddot_filtered]; PIGainScheduledOTC.Surge_Ddot_filtered = [PIGainScheduledOTC.Surge_Ddot_filtered;s.Surge_Ddot_filtered];            
                GeneratorTorqueController.Sway_Ddot_filtered = [GeneratorTorqueController.Sway_Ddot_filtered;s.Sway_Ddot_filtered]; BladePitchController.Sway_Ddot_filtered = [BladePitchController.Sway_Ddot_filtered;s.Sway_Ddot_filtered]; PIGainScheduledOTC.Sway_Ddot_filtered = [PIGainScheduledOTC.Sway_Ddot_filtered;s.Sway_Ddot_filtered];            
                GeneratorTorqueController.Heave_Ddot_filtered = [GeneratorTorqueController.Heave_Ddot_filtered;s.Heave_Ddot_filtered]; BladePitchController.Heave_Ddot_filtered = [BladePitchController.Heave_Ddot_filtered;s.Heave_Ddot_filtered]; PIGainScheduledOTC.Heave_Ddot_filtered = [PIGainScheduledOTC.Heave_Ddot_filtered;s.Heave_Ddot_filtered];            
                GeneratorTorqueController.RollAngle_dot_filtered = [GeneratorTorqueController.RollAngle_dot_filtered;s.RollAngle_dot_filtered]; BladePitchController.RollAngle_dot_filtered = [BladePitchController.RollAngle_dot_filtered;s.RollAngle_dot_filtered]; PIGainScheduledOTC.RollAngle_dot_filtered = [PIGainScheduledOTC.RollAngle_dot_filtered;s.RollAngle_dot_filtered];            
                GeneratorTorqueController.PitchAngle_dot_filtered = [GeneratorTorqueController.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered]; BladePitchController.PitchAngle_dot_filtered = [BladePitchController.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered]; PIGainScheduledOTC.PitchAngle_dot_filtered = [PIGainScheduledOTC.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered];             
                GeneratorTorqueController.YawAngle_dot_filtered = [GeneratorTorqueController.YawAngle_dot_filtered;s.YawAngle_dot_filtered]; BladePitchController.YawAngle_dot_filtered = [BladePitchController.YawAngle_dot_filtered;s.YawAngle_dot_filtered]; PIGainScheduledOTC.YawAngle_dot_filtered = [PIGainScheduledOTC.YawAngle_dot_filtered;s.YawAngle_dot_filtered];
            end
            %
        end
    end



    % ---------- LOGICAL INSTANCE 07  ----------
    if it == 1
        if s.Option04f8 == 1
            PIGainScheduledOTC.dt_contr  = s.dt_contr;  
            PIGainScheduledOTC.Rarm_pitch = s.Rarm_pitch;
        end
        PIGainScheduledOTC.Xf_dot_filtered = s.Xf_dot_filtered; PIGainScheduledOTC.Kp_CS_Feedback = s.Kp_CS_Feedback; PIGainScheduledOTC.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        BladePitchController.Xf_dot_filtered = s.Xf_dot_filtered; BladePitchController.Kp_CS_Feedback = s.Kp_CS_Feedback; BladePitchController.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        GeneratorTorqueController.Xf_dot_filtered = s.Xf_dot_filtered; GeneratorTorqueController.Kp_CS_Feedback = s.Kp_CS_Feedback; GeneratorTorqueController.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        GeneratorTorqueController.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m; BladePitchController.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m; PIGainScheduledOTC.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m;        
        GeneratorTorqueController.VCsi_est = s.VCsi_est; BladePitchController.VCsi_est = s.VCsi_est; PIGainScheduledOTC.VCsi_est = s.VCsi_est;        
    else
        PIGainScheduledOTC.Xf_dot_filtered = [PIGainScheduledOTC.Xf_dot_filtered;s.Xf_dot_filtered]; PIGainScheduledOTC.Kp_CS_Feedback = [PIGainScheduledOTC.Kp_CS_Feedback;s.Kp_CS_Feedback]; PIGainScheduledOTC.PropTerm_CS_Feedback = [PIGainScheduledOTC.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        BladePitchController.Xf_dot_filtered = [BladePitchController.Xf_dot_filtered;s.Xf_dot_filtered]; BladePitchController.Kp_CS_Feedback = [BladePitchController.Kp_CS_Feedback;s.Kp_CS_Feedback]; BladePitchController.PropTerm_CS_Feedback = [BladePitchController.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        GeneratorTorqueController.Xf_dot_filtered = [GeneratorTorqueController.Xf_dot_filtered;s.Xf_dot_filtered]; GeneratorTorqueController.Kp_CS_Feedback = [GeneratorTorqueController.Kp_CS_Feedback;s.Kp_CS_Feedback]; GeneratorTorqueController.PropTerm_CS_Feedback = [GeneratorTorqueController.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        PIGainScheduledOTC.Cosseno_PitchAngle_m = [PIGainScheduledOTC.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m]; GeneratorTorqueController.Cosseno_PitchAngle_m = [GeneratorTorqueController.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m]; BladePitchController.Cosseno_PitchAngle_m = [BladePitchController.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m];
        PIGainScheduledOTC.VCsi_est = [PIGainScheduledOTC.VCsi_est;s.VCsi_est]; GeneratorTorqueController.VCsi_est = [GeneratorTorqueController.VCsi_est;s.VCsi_est]; BladePitchController.VCsi_est = [BladePitchController.VCsi_est;s.VCsi_est];        
        %
    end



    % ---------- LOGICAL INSTANCE 08  ----------
    if it == 1
        PIGainScheduledOTC.BetaMin_setup = s.BetaMin_setup; BladePitchController.BetaMin_setup = s.BetaMin_setup; GeneratorTorqueController.BetaMin_setup = s.BetaMin_setup;
        PIGainScheduledOTC.BetaMax_setup = s.BetaMax_setup; BladePitchController.BetaMax_setup = s.BetaMax_setup; GeneratorTorqueController.BetaMax_setup = s.BetaMax_setup;          
        PIGainScheduledOTC.TgMin_setup = s.TgMin_setup; BladePitchController.TgMin_setup = s.TgMin_setup; GeneratorTorqueController.TgMin_setup = s.TgMin_setup;
        PIGainScheduledOTC.TgMax_setup  = s.TgMax_setup ; BladePitchController.TgMax_setup  = s.TgMax_setup ; GeneratorTorqueController.TgMax_setup  = s.TgMax_setup ;            
    else
        PIGainScheduledOTC.BetaMin_setup = [PIGainScheduledOTC.BetaMin_setup;s.BetaMin_setup]; BladePitchController.BetaMin_setup = [BladePitchController.BetaMin_setup;s.BetaMin_setup]; GeneratorTorqueController.BetaMin_setup = [GeneratorTorqueController.BetaMin_setup;s.BetaMin_setup];
        PIGainScheduledOTC.BetaMax_setup = [PIGainScheduledOTC.BetaMax_setup;s.BetaMax_setup]; BladePitchController.BetaMax_setup = [BladePitchController.BetaMax_setup;s.BetaMax_setup]; GeneratorTorqueController.BetaMax_setup = [GeneratorTorqueController.BetaMax_setup;s.BetaMax_setup];        
        PIGainScheduledOTC.TgMin_setup = [PIGainScheduledOTC.TgMin_setup;s.TgMin_setup]; BladePitchController.TgMin_setup = [BladePitchController.TgMin_setup;s.TgMin_setup]; GeneratorTorqueController.TgMin_setup = [GeneratorTorqueController.TgMin_setup;s.TgMin_setup];
        PIGainScheduledOTC.TgMax_setup  = [PIGainScheduledOTC.TgMax_setup ;s.TgMax_setup ]; BladePitchController.TgMax_setup  = [BladePitchController.TgMax_setup ;s.TgMax_setup ]; GeneratorTorqueController.TgMax_setup  = [GeneratorTorqueController.TgMax_setup ;s.TgMax_setup ];          
    end




    % ---------- LOGICAL INSTANCE 09  ----------
    if it ==1 
        GeneratorTorqueController.OmegaRef_Tg = s.OmegaRef_Tg; BladePitchController.OmegaRef_Tg = s.OmegaRef_Tg; PIGainScheduledOTC.OmegaRef_Tg = s.OmegaRef_Tg; 
        GeneratorTorqueController.OmegaRef_Beta = s.OmegaRef_Beta; BladePitchController.OmegaRef_Beta = s.OmegaRef_Beta; PIGainScheduledOTC.OmegaRef_Beta = s.OmegaRef_Beta;     
        GeneratorTorqueController.OmegaRef = s.OmegaRef; BladePitchController.OmegaRef = s.OmegaRef; PIGainScheduledOTC.OmegaRef = s.OmegaRef;         
    else
        GeneratorTorqueController.OmegaRef_Tg = [GeneratorTorqueController.OmegaRef_Tg;s.OmegaRef_Tg]; BladePitchController.OmegaRef_Tg = [BladePitchController.OmegaRef_Tg;s.OmegaRef_Tg]; PIGainScheduledOTC.OmegaRef_Tg = [PIGainScheduledOTC.OmegaRef_Tg;s.OmegaRef_Tg]; 
        GeneratorTorqueController.OmegaRef_Beta = [GeneratorTorqueController.OmegaRef_Beta;s.OmegaRef_Beta]; BladePitchController.OmegaRef_Beta = [BladePitchController.OmegaRef_Beta;s.OmegaRef_Beta]; PIGainScheduledOTC.OmegaRef_Beta = [PIGainScheduledOTC.OmegaRef_Beta;s.OmegaRef_Beta];    
        GeneratorTorqueController.OmegaRef = [GeneratorTorqueController.OmegaRef;s.OmegaRef]; BladePitchController.OmegaRef = [BladePitchController.OmegaRef;s.OmegaRef]; PIGainScheduledOTC.OmegaRef = [PIGainScheduledOTC.OmegaRef;s.OmegaRef];         
        %
    end



    % ---------- LOGICAL INSTANCE 10  ----------
    if it == 1
        BladePitchController.Beta_d = s.Beta_d;  BladePitchController.Beta_dDot = s.Beta_dDot;
        PIGainScheduledOTC.Beta_d = s.Beta_d;  PIGainScheduledOTC.Beta_dDot = s.Beta_dDot;
        PIGainScheduledOTC.Beta_d_before = s.Beta_d_before; BladePitchController.Beta_d_before = s.Beta_d_before;
        PIGainScheduledOTC.Beta_filtered_before = s.Beta_filtered_before; BladePitchController.Beta_filtered_before = s.Beta_filtered_before;
        BladePitchController.dBeta_max = s.dBeta_max; BladePitchController.dBeta_min = s.dBeta_min; BladePitchController.ErroTracking_Betad = s.ErroTracking_Betad; BladePitchController.Kp_piBeta = s.Kp_piBeta; BladePitchController.Ki_piBeta = s.Ki_piBeta; BladePitchController.PropTermPI_Beta = s.PropTermPI_Beta; BladePitchController.IntegTermPI_Beta = s.IntegTermPI_Beta; BladePitchController.dBeta = s.dBeta;
        PIGainScheduledOTC.dBeta_max = s.dBeta_max; PIGainScheduledOTC.dBeta_min = s.dBeta_min; PIGainScheduledOTC.ErroTracking_Betad = s.ErroTracking_Betad; PIGainScheduledOTC.Kp_piBeta = s.Kp_piBeta; PIGainScheduledOTC.Ki_piBeta = s.Ki_piBeta; PIGainScheduledOTC.PropTermPI_Beta = s.PropTermPI_Beta; PIGainScheduledOTC.IntegTermPI_Beta = s.IntegTermPI_Beta; PIGainScheduledOTC.dBeta = s.dBeta;

        PIGainScheduledOTC.PC_KK = s.PC_KK; BladePitchController.PC_KK = s.PC_KK; PIGainScheduledOTC.Beta_GK = s.Beta_GK;
        PIGainScheduledOTC.GK = s.GK; BladePitchController.GK = s.GK; BladePitchController.Beta_GK = s.Beta_GK;        
    else
        BladePitchController.Beta_d = [BladePitchController.Beta_d ;s.Beta_d];  BladePitchController.Beta_dDot = [BladePitchController.Beta_dDot;s.Beta_dDot];
        PIGainScheduledOTC.Beta_d = [PIGainScheduledOTC.Beta_d;s.Beta_d];  PIGainScheduledOTC.Beta_dDot = [PIGainScheduledOTC.Beta_dDot;s.Beta_dDot];
        PIGainScheduledOTC.Beta_d_before = [PIGainScheduledOTC.Beta_d_before;s.Beta_d_before]; BladePitchController.Beta_d_before = [BladePitchController.Beta_d_before;s.Beta_d_before];
        PIGainScheduledOTC.Beta_filtered_before = [PIGainScheduledOTC.Beta_filtered_before;s.Beta_filtered_before]; BladePitchController.Beta_filtered_before = [BladePitchController.Beta_filtered_before;s.Beta_filtered_before];        
        BladePitchController.dBeta_max = [BladePitchController.dBeta_max;s.dBeta_max]; BladePitchController.dBeta_min = [BladePitchController.dBeta_min;s.dBeta_min]; BladePitchController.ErroTracking_Betad = [BladePitchController.ErroTracking_Betad;s.ErroTracking_Betad]; BladePitchController.Kp_piBeta = [BladePitchController.Kp_piBeta;s.Kp_piBeta]; BladePitchController.Ki_piBeta = [BladePitchController.Ki_piBeta;s.Ki_piBeta]; BladePitchController.PropTermPI_Beta = [BladePitchController.PropTermPI_Beta;s.PropTermPI_Beta]; BladePitchController.IntegTermPI_Beta = [BladePitchController.IntegTermPI_Beta;s.IntegTermPI_Beta]; BladePitchController.dBeta = [BladePitchController.dBeta;s.dBeta];
        PIGainScheduledOTC.dBeta_max = [PIGainScheduledOTC.dBeta_max;s.dBeta_max]; PIGainScheduledOTC.dBeta_min = [PIGainScheduledOTC.dBeta_min;s.dBeta_min]; PIGainScheduledOTC.ErroTracking_Betad = [PIGainScheduledOTC.ErroTracking_Betad;s.ErroTracking_Betad]; PIGainScheduledOTC.Kp_piBeta = [PIGainScheduledOTC.Kp_piBeta;s.Kp_piBeta]; PIGainScheduledOTC.Ki_piBeta = [PIGainScheduledOTC.Ki_piBeta;s.Ki_piBeta]; PIGainScheduledOTC.PropTermPI_Beta = [PIGainScheduledOTC.PropTermPI_Beta;s.PropTermPI_Beta]; PIGainScheduledOTC.IntegTermPI_Beta = [PIGainScheduledOTC.IntegTermPI_Beta;s.IntegTermPI_Beta]; PIGainScheduledOTC.dBeta = [PIGainScheduledOTC.dBeta;s.dBeta];

        PIGainScheduledOTC.PC_KK = [PIGainScheduledOTC.PC_KK;s.PC_KK]; BladePitchController.PC_KK = [BladePitchController.PC_KK;s.PC_KK]; PIGainScheduledOTC.Beta_GK = [PIGainScheduledOTC.Beta_GK;s.Beta_GK];
        PIGainScheduledOTC.GK = [PIGainScheduledOTC.GK;s.GK]; BladePitchController.GK = [BladePitchController.GK;s.GK]; BladePitchController.Beta_GK = [BladePitchController.Beta_GK;s.Beta_GK];        
        %
    end


    % ---------- LOGICAL INSTANCE 11  ----------
    if it == 1
        GeneratorTorqueController.Tg_d = s.Tg_d; GeneratorTorqueController.Tg_dDot = s.Tg_dDot;
        PIGainScheduledOTC.Tg_d = s.Tg_d;  PIGainScheduledOTC.Tg_dDot = s.Tg_dDot;        
        GeneratorTorqueController.Tg_d_before = s.Tg_d_before; PIGainScheduledOTC.Tg_d_before = s.Tg_d_before;        
        GeneratorTorqueController.Tg_filtered_before = s.Tg_filtered_before; PIGainScheduledOTC.Tg_filtered_before = s.Tg_filtered_before;           
        GeneratorTorqueController.Pe_d_before = s.Pe_d_before; PIGainScheduledOTC.Pe_d_before = s.Pe_d_before;          
        GeneratorTorqueController.Pe_filtered_before = s.Pe_filtered_before; PIGainScheduledOTC.Pe_filtered_before = s.Pe_filtered_before;         
        GeneratorTorqueController.dTg_max = s.dTg_max; GeneratorTorqueController.dTg_min = s.dTg_min;
        PIGainScheduledOTC.dTg_max = s.dTg_max; PIGainScheduledOTC.dTg_min = s.dTg_min;
        
    else
        GeneratorTorqueController.Tg_d = [GeneratorTorqueController.Tg_d;s.Tg_d]; GeneratorTorqueController.Tg_dDot = [GeneratorTorqueController.Tg_dDot;s.Tg_dDot];
        PIGainScheduledOTC.Tg_d = [PIGainScheduledOTC.Tg_d;s.Tg_d];  PIGainScheduledOTC.Tg_dDot = [PIGainScheduledOTC.Tg_dDot;s.Tg_dDot];
        GeneratorTorqueController.Tg_d_before = [GeneratorTorqueController.Tg_d_before;s.Tg_d_before]; PIGainScheduledOTC.Tg_d_before = [PIGainScheduledOTC.Tg_d_before;s.Tg_d_before];
        GeneratorTorqueController.Tg_filtered_before = [GeneratorTorqueController.Tg_filtered_before;s.Tg_filtered_before]; PIGainScheduledOTC.Tg_filtered_before = [PIGainScheduledOTC.Tg_filtered_before;s.Tg_filtered_before];         
        GeneratorTorqueController.Pe_d_before = [GeneratorTorqueController.Pe_d_before;s.Pe_d_before]; PIGainScheduledOTC.Pe_d_before = [PIGainScheduledOTC.Pe_d_before;s.Pe_d_before];        
        GeneratorTorqueController.Pe_filtered_before = [GeneratorTorqueController.Pe_filtered_before;s.Pe_filtered_before]; PIGainScheduledOTC.Pe_filtered_before = [PIGainScheduledOTC.Pe_filtered_before;s.Pe_filtered_before];         
        GeneratorTorqueController.dTg_max = [GeneratorTorqueController.dTg_max ;s.dTg_max]; GeneratorTorqueController.dTg_min = [GeneratorTorqueController.dTg_min;s.dTg_min];
        PIGainScheduledOTC.dTg_max = [PIGainScheduledOTC.dTg_max;s.dTg_max]; PIGainScheduledOTC.dTg_min = [PIGainScheduledOTC.dTg_min;s.dTg_min];
        %
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);


elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % PLOT CONTROL RESULTS (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % control and develop any other calculations, tables and data to 
    % support the analysis of the results.


    % ---------- Plot Effective Wind Speed ----------  
    if s.Option10f8 == 3
        figure()     
        plot(s.Time,s.Vews_op)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('$V_{ews}$ [m/s]', 'Interpreter', 'latex')
        ylim([0.95*min(s.Vews_op) 1.05*max(s.Vews_op)])        
        legend('Effective Wind Speed $V_{ews}$ [m/s]', 'Interpreter', 'latex')
        title('Effective Wind Speed signal adopted by controllers over time.', 'Interpreter', 'latex');
        %    
    end


    % ---------- Plot Blade Pitch ----------
    beta_minplot = min([s.Beta_measured s.Betad_op s.Beta_d]);
    beta_maxplot = max([s.Beta_measured s.Betad_op s.Beta_d]);   
    delta_betaplot = beta_maxplot - beta_minplot;
    if delta_betaplot < 0.5
        beta_minplot = beta_minplot - 0.5;
        beta_maxplot = beta_maxplot + 0.5;
    end

        % Collective Blade Pitch
    figure()   
    hold on;     
    plot(s.Time, s.Beta_measured, 'Color', [0.4 0.7 0.9], 'LineWidth', 0.5);         
    plot(s.Time, s.Betad_op, 'k:', 'LineWidth', 0.8);   
    plot(s.Time, s.Beta_d, 'r--', 'LineWidth', 1.0);     
    hold off; 
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\beta}_{d}$ [deg]', 'Interpreter', 'latex') 
    ylim([0.95*beta_minplot 1.05*beta_maxplot])  
    legend('Measured Blade Pitch ${\beta}$','Operational Blade Pitch demanded ${\hat{\beta}}_{op}$', 'Collective Blade Pitch demanded by the controller ${\beta}_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Collective Blade Pitch demanded by the controller over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex'); 
    % 


        % Rate of Blade Pitch
    figure();
    hold on; 
    plot(s.Time, s.Beta_dot, 'Color', [0.4 0.7 0.9], 'LineWidth', 0.5);
    plot(s.Time, s.Beta_dDot, 'r--', 'LineWidth', 0.5);
    hold off; xlabel('$t$ [seg]', 'Interpreter', 'latex');
    xlim([0 max(s.Time)]);
    ylabel('$\dot{\beta}$ [deg/s]', 'Interpreter', 'latex');
    ylim([1.1 * min(-s.BetaDot_max) 1.1 * max(s.BetaDot_max)]); 
    legend('Actual Rate Collective Blade Pitch ${\dot{\beta}}$', 'Rate Collective Blade Pitch demanded ${\dot{\beta}}_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Comparison of actual and controller-demanded collective blade pitch rate over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    hold on;
    yline(s.BetaDot_max, 'k--', 'Label', 'Upper Limit', 'Interpreter', 'latex', 'HandleVisibility', 'off');
    yline(-s.BetaDot_max, 'k--', 'Label', 'Lower Limit', 'Interpreter', 'latex', 'HandleVisibility', 'off');
    hold off; 
    %



    % ------- Plot Generator Torque ----------
    figure();
    hold on;
    plot(s.Time, s.Tg_measured, 'Color', [0.4 0.7 0.9], 'LineWidth', 0.5);         
    plot(s.Time, s.Tgd_op, 'k:', 'LineWidth', 0.8);   
    plot(s.Time, s.Tg_d, 'r--', 'LineWidth', 1.0);     
    hold off;
    xlabel('$t$ [seg]', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);
    ylabel('$Tg_{d}$ [N.m]', 'Interpreter', 'latex'); 
    ylim([0.95 * min([s.Tg_d s.Tg_measured s.Tgd_op]) 1.05 * max([s.Tg_d s.Tg_measured s.Tgd_op])]);     
    legend('Measured Generator Torque ${Tg}$', 'Operational Generator Torque demanded ${\hat{Tg}}_{op}$', 'Generator Torque demanded by the controller $Tg_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Generator Torque demanded by the controller over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Rate of Generator Torque
    figure();
    hold on;
    plot(s.Time, s.Tg_dot, 'Color', [0.4 0.7 0.9], 'LineWidth', 0.5);
    plot(s.Time, s.Tg_dDot, 'r--', 'LineWidth', 0.5);
    hold off; 
    xlabel('$t$ [seg]', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);
    ylabel('${\dot{T}}g$ [N.m/s]', 'Interpreter', 'latex'); 
    ylim([1.1 * min(-s.TgDot_max * s.eta_gb) 1.1 * max(s.TgDot_max * s.eta_gb)]);     
    legend('Actual Generator Torque Rate ${\dot{T}}g$', 'Generator Torque Rate demanded ${\dot{T}}g_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Comparison of actual and controller-demanded Generator Torque Rate over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    hold on;
    yline((s.TgDot_max * s.eta_gb), 'k--', 'Label', 'Upper Limit', 'Interpreter', 'latex', 'HandleVisibility', 'off'); 
    yline(-(s.TgDot_max * s.eta_gb), 'k--', 'Label', 'Lower Limit', 'Interpreter', 'latex', 'HandleVisibility', 'off'); 
    hold off;
    %


    % ------- Plot Rotor Speed and Controller Tracking Reference Speed ----------
    figure()   
    hold on;
    plot(s.Time, s.OmegaR_measured, 'b', 'LineWidth', 1.5);     
    % plot(s.Time, s.OmegaR_measured, 'Color', [0.4 0.7 0.9], 'LineWidth', 1.5);         
    plot(s.Time, s.OmegaRef, 'k:', 'LineWidth', 1.0);   
    plot(s.Time, s.OmegaR_filtered, 'r--', 'LineWidth', 2.0);     
    hold off; 
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\omega}$ [rad/s]', 'Interpreter', 'latex') 
    ylim([0.95 * min([s.OmegaRef s.OmegaR_filtered s.OmegaR_measured]) 1.05 * max([s.OmegaRef s.OmegaR_filtered s.OmegaR_measured])]) 
    legend('Measured Rotor Speed ${\omega}_{r}$', 'Controller Tracking Reference Speed ${\hat{\omega}}_{ref}$', 'Filtered Rotor Speed (${\hat{\omega}}_{r}$)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Comparison of measured and filtered rotor speed with tracked reference rotor speed over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %   


    % ---- Plot Blade Collective Pitch Controller Design Parameters ----  
    if s.Option07f8 == 3
        set(groot, 'defaultTextInterpreter', 'latex')
        figure()     
        plot(s.Time, s.ErroTracking_Betad)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Tracking Error', 'Interpreter', 'latex')
        ylim([0.95*min(s.ErroTracking_Betad) 1.05*max(s.ErroTracking_Betad)])        
        legend('Blade Pitch Controller Reference Speed Tracking Error', 'Interpreter', 'latex')
        title('Blade Pitch Controller Reference Speed Tracking Error over time.', 'Interpreter', 'latex');
        %

        set(groot, 'defaultTextInterpreter', 'latex')
        figure()     
        plot(s.Time,s.Kp_piBeta)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('​​Gain (Kp)', 'Interpreter', 'latex')
        ylim([0.95*min(s.Kp_piBeta) 1.05*max(s.Kp_piBeta)])        
        legend('Blade Pitch Controller Proportional Gain (Kp)', 'Interpreter', 'latex')
        title('Blade Pitch Controller Proportional Gain over time.') 
        %

        set(groot, 'defaultTextInterpreter', 'latex')        
        figure()     
        plot(s.Time,s.PropTermPI_Beta)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Term (Kp*erro)', 'Interpreter', 'latex')
        ylim([0.95*min(s.PropTermPI_Beta) 1.05*max(s.PropTermPI_Beta)])        
        legend('Blade Pitch Controller Proportional Term (Kp*erro)', 'Interpreter', 'latex')
        title('Blade Pitch Controller Proportional Term over time.')           
        %   

        set(groot, 'defaultTextInterpreter', 'latex')        
        figure()     
        plot(s.Time,s.Ki_piBeta)        
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Gain ($KI$)', 'Interpreter', 'latex');
        ylim([0.95*min(s.PropTermPI_Beta) 1.05*max(s.PropTermPI_Beta)])         
        legend('Blade Pitch Controller Integrative Gain ($KI$)', 'Interpreter', 'latex')
        title('Blade Pitch Controller Integrative Gain over time.')
        %

        set(groot, 'defaultTextInterpreter', 'latex')
        figure()     
        plot(s.Time,s.PropTermPI_Beta)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Term (KI*IntegratedError)', 'Interpreter', 'latex')
        ylim([0.95*min(s.PropTermPI_Beta) 1.05*max(s.PropTermPI_Beta)])        
        legend('Blade Pitch Controller Integrative Term (KI*IntegratedError)', 'Interpreter', 'latex')
        title('Blade Pitch Controller Integrative Term over time.')  
        %
    end


    % ---- Plot Active Damping Tower Top Design Parameters ----
    if s.Option04f8 == 1
        % Consider Active Tower Damping with a Tower Top feedback compensation strategy
        figure()     
        plot(s.Time,s.Xt_dot_filtered)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('${\dot{X}}_{t}$ [m/s]', 'Interpreter', 'latex')
        ylim([0.95*min(s.Xt_dot_filtered) 1.05*max(s.Xt_dot_filtered)])        
        legend('Velocity (filtered and integrated) of tower top movement (${\dot{X}}_{t}$) [m/s]', 'Interpreter', 'latex')
        title('Velocity (filtered and integrated) of tower top movement over time.') 
        %    

        if s.Option07f8 == 3
            figure()     
            plot(s.Time,s.Kp_CS_Feedback)
            xlabel('t [seg]', 'Interpreter', 'latex')
            xlim([0 max(s.Time)])
            ylabel('​​Gain ($K_{TowerFeedback}$)', 'Interpreter', 'latex')
            ylim([0.95*min(s.Kp_CS_Feedback) 1.05*max(s.Kp_CS_Feedback)])        
            legend('Gain proportional to tower feedback ($K_{TowerFeedback}$)', 'Interpreter', 'latex')
            title('Gain proportional to tower feedback over time.') 
            
            figure()     
            plot(s.Time,s.PropTerm_CS_Feedback)
            xlabel('t [seg]', 'Interpreter', 'latex')
            xlim([0 max(s.Time)])
            ylabel('Term (Kp*${\dot{X}}_{t}$)', 'Interpreter', 'latex')
            ylim([0.95*min(s.PropTerm_CS_Feedback) 1.05*max(s.PropTerm_CS_Feedback)])        
            legend('Tower Feedback Proportional Term (Kp*${\dot{X}}_{t}$)', 'Interpreter', 'latex')
            title('Tower Feedback Proportional Term over time.')  
            %
        end
        %
    end % if s.Option04f8 == 1




    % ---- Plot Peak Shaving Design Parameters ----
    if s.Option01f8 == 2
        % STRATEGY 2 (Peak Shaving)
        figure()  
        plot(s.Time, s.Fa, 'b:', 'LineWidth', 0.5, 'Color', [0.4 0.7 0.9]);       
        hold on;
        plot(s.Time, s.Fa_estPS, 'r-', 'LineWidth', 0.8);  
        % plot(s.Time,s.Fa_estPS) 
        hold off;     
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('$Fa$ [N]', 'Interpreter', 'latex')
        ylim([0.95*min([s.Fa s.Fa_estPS]) 1.05*max([s.Fa s.Fa_estPS])])        
        legend('Actual Aerodynamic Thrust, $Fa$', 'Estimated Aerodynamic Thrust, ${\hat{F}}_{a}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        title('Analysis of the Aerodynamic Thrust Peak shaving Strategy.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex'); 
        %      

        if s.Option07f8 == 3
            figure()     
            plot(s.Time,s.Fa_estPS,'k',s.Time,s.Fa_est,'r')
            xlabel('t [seg]', 'Interpreter', 'latex')
            xlim([0 max(s.Time)])
            ylabel('$Fa$ [N]', 'Interpreter', 'latex')
            ylim([0.95*min(s.Fa_estPS) 1.05*max(s.Fa_estPS)])        
            legend('Estimated aerodynamic thrust in steady state $Fa_{op}$ [N]', 'Estimated aerodynamic thrust ($Fa$) [N]', 'Interpreter', 'latex');
            title('Peak shaving analysis of estimated aerodynamic thrust over time.')            
            %    
        end
        %
    end % if s.Option01f8 == 2


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);

    
    % Further processing or end of the recursive calls
%=============================================================         
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);

assignin('base', 'PIGainScheduledOTC', PIGainScheduledOTC);
assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
assignin('base', 'BladePitchController', BladePitchController);



% #######################################################################
end