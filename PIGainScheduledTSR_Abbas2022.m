function PIGainScheduledTSR_Abbas2022(action)
% ########## CONTROL SYSTEM AND ITS ACTUATORS - ABBAS-2022 APPROACH ##########
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
% system and its actuators, presented in the paper by the author
% Abbas, published (2022).



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
    % DESIGN CHOICES, HYPOTHESES AND THEIR OPTIONS:    
    % Purpose of this Logical Instance: to define the option choices 
    % related to this recursive function "PIGainScheduledTSR_Abbas2022.m". The choices will be
    % stored following a pattern of "option_f8_(it)" where "(it)" is the option number.


    % ---------- Option 01: Steady-State Operation Strategy Selection ----------
    who.Option01f8.Option_01 = 'Option 01 of Recursive Function f8';
    who.Option01f8.about = 'Steady-State Operation Strategy Selection.';
    who.Option01f8.choose_01 = 'Option01f8 == 1 to choose STRATEGY 1 (Figure 2 from Abbas, 2022).';
    who.Option01f8.choose_02 = 'Option01f8 == 2 to choose STRATEGY 2 (Peak Shaving).';
    who.Option01f8.choose_03 = 'Option01f8 == 3 to choose STRATEGY 3 (Figure 7.2 from Jonkman, 2009).';      
        % Choose your option:
    s.Option01f8 = 1;
    if s.Option01f8 == 1 || s.Option01f8 == 2 || s.Option01f8 == 3
        GeneratorTorqueController.Option01f8 = s.Option01f8;
        BladePitchController.Option01f8 = s.Option01f8;   
        PIGainScheduledTSR.Option01f8 = s.Option01f8;           
    else
        error('Invalid option selected for s.Option01f8. Please choose 1 or 2 or 3.');
    end
    %


    % ---------- Option 02: Selection of Drivetrain Dynamics Signals ----------
    who.Option02f8.Option_02 = 'Option 02 of Recursive Function f8';
    who.Option02f8.about = 'Selection of Drivetrain Dynamics Signals (OmegaR, OmegaG, Beta, Tg).';
    who.Option02f8.choose_01 = 'Option02f8 == 1 to choose use All Signals (OmegaR, OmegaF, Beta, Tg) from the 1st Order Low Pass Filter (LPF1).'; 
    who.Option02f8.choose_02 = 'Option02f8 == 2 to choose use "Vews_est" and "OmegaR_est" by the State Observer and the other signals from the 1st Order Low Pass Filter (LPF1).';            
        % Choose your option:
    s.Option02f8 = 2; 
    if s.Option02f8 == 1 || s.Option02f8 == 2
        GeneratorTorqueController.Option02f8 = s.Option02f8;
        BladePitchController.Option02f8 = s.Option02f8;    
        PIGainScheduledTSR.Option02f8 = s.Option02f8;          
    else
        error('Invalid option selected for s.Option02f8. Please choose 1 or 2.');
    end
  % 


    % ------- Option 03: Selection of Tower-Top Dynamics Signals ----------
    who.Option03f8.Option_03 = 'Option 03 of Recursive Function f8';
    who.Option03f8.about = 'Selection of Tower-Top Dynamics Signals (Xt_Ddot and Surge_Ddot, Sway_Ddot, Heave_Ddot, RollAngle_dot, PitchAngle_dot, YawAngle_dot, etc).';
    who.Option03f8.choose_01 = 'Option03f8 == 1 to choose use the filtered signals as Abbas (2022) suggests: by 2nd Order Low Pass Filter, by 1st Order High Pass Filter and Notch Filter.';
    who.Option03f8.choose_02 = 'Option03f8 == 2 to choose use only a 2nd Order Low Pass Filter.';  
        % Choose your option:
    s.Option03f8 = 1; 
    if s.Option03f8 == 1 || s.Option03f8 == 2
        PIGainScheduledTSR.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';
        BladePitchController.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';        
        % WARNING!!! For onshore wind turbine, this option only makes sense if the option
         % "s.Option04f3 == 1" is selected in the Matlab file
         % "WindTurbine('logical_instance_01');"

        GeneratorTorqueController.Option03f8 = s.Option03f8;
        BladePitchController.Option03f8 = s.Option03f8;             
        PIGainScheduledTSR.Option03f8 = s.Option03f8;          
    else
        error('Invalid option selected for s.Option03f8. Please choose 1 or 2.');
    end  


    % ------ Option 04: Compensation Strategy Options ----------
    who.Option04f8.Option_04 = 'Option 04 of Recursive Function f8';
    who.Option04f8.about = 'Compensation Strategy to Avoid Negative Damping or Active Tower Damping Options';
    who.Option04f8.choose_01 = 'Option04f8 == 1 to choose Consider Active Tower Damping with a Tower Top feedback compensation strategy (K*X_dot_filtered) in the Collective Blade Pitch controller.';
    who.Option04f8.choose_02 = 'Option04f8 == 2 to choose Consider Active Platform Pitch Damping  as feedback compensation strategy (K*Pitch_dot_filtered) in the Collective Blade Pitch controller.';
    who.Option04f8.choose_03 = 'Option04f8 == 3 to choose DO NOT consider Active Tower Damping';    
        % Choose your option:
    s.Option04f8 = 2; 
    if s.Option04f8 == 1 || s.Option04f8 == 2 || s.Option04f8 == 3
        PIGainScheduledTSR.Warning_TowerTopDynamics = 'WARNING!!! This option only makes sense if the option "s.Option04f3 == 1" is selected in the Matlab file "WindTurbine(logical_instance_01)';
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
        PIGainScheduledTSR.Option04f8 = s.Option04f8;          
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
        PIGainScheduledTSR.Option05f8 = s.Option05f8;            
    else
        error('Invalid option selected for s.Option05f8. Please choose 1 or 2 or 3.');
    end
  % 

    % ----- Option 06: Software Architecture (Controller Algorithm) -----
    who.Option06f8.Option_06 = 'Option 06 of Recursive Function f8';
    who.Option06f8.about = 'Architecture options or controller algorithm structure.';
    who.Option06f8.choose_01 = 'Option06f8 == 1 to choose SWITCH BETWEEN CONTROLLERS. Only one controller uses integrative Proportional control law while the other controller is in saturated mode.';
    who.Option06f8.choose_02 = 'Option06f8 == 2 to choose SET POINT SMOOTHING (by Abbas 2022). The set point is based on equations 48 and 49 of Abbas (2022) which does not require switching between controllers and the transition between them is done smoothly, without conflicts and at all times using PI controllers.';
        % Choose your option:
    s.Option06f8 = 1;
    if s.Option06f8 == 1 || s.Option06f8 == 2
        GeneratorTorqueController.Option06f8= s.Option06f8;
        BladePitchController.Option06f8 = s.Option06f8;  
        PIGainScheduledTSR.Option06f8 = s.Option06f8;          
    else
        error('Invalid option selected for s.Option06f8. Please choose 1 or 2.');
    end  


    % ---------- Option 07: Offset to the rotor speed set point  Options ----------
    who.Option07f8.Option_05 = 'Option 07 of Recursive Function f8';
    who.Option07f8.about = 'Offset to the rotor speed set point  Options';
    who.Option07f8.choose_01 = 'Option07f8 == 1 to choose compute Delta_Omega (Set point Smooth) with Equation 48 Abbas (2022). Uses the Generator Torque demand (Tg_d).';
    who.Option07f8.choose_02 = 'Option07f8 == 2 to choose compute Delta_Omega (Set point Smooth) with ROSCo tools. Uses the Generator Power demand (Pe_d).';
        % Choose your option:
    s.Option07f8 = 1; 
    if s.Option07f8 == 1 || s.Option07f8 == 2
        GeneratorTorqueController.Option07f8= s.Option07f8;
        BladePitchController.Option07f8 = s.Option07f8;  
        PIGainScheduledTSR.Option07f8 = s.Option07f8;          
    else
        error('Invalid option selected for s.Option07f8. Please choose 1 or 2.');
    end  


    % --- Option 08: Selection of "DeltaOmega" Signals (Set Point Smoothing) ---
    who.Option08f8.Option_08 = 'Option 08 of Recursive Function f8';
    who.Option08f8.about = 'Selection of "DeltaOmega" Signals (Set Point Smoothing).';
    who.Option08f8.choose_01 = 'Option08f8 == 1 to choose use the FILTERED "DeltaOmega" to set point smoothing, according Abbas (2022).';
    who.Option08f8.choose_02 = 'Option08f8 == 2 to choose use the UNFILTERED "DeltaOmega"';  
        % Choose your option:
    s.Option08f8 = 1; 
    if s.Option08f8 == 1 || s.Option08f8 == 2
        GeneratorTorqueController.Option08f8= s.Option08f8;
        BladePitchController.Option08f8 = s.Option08f8;  
        PIGainScheduledTSR.Option08f8 = s.Option08f8;          
    else
        error('Invalid option selected for s.Option08f8. Please choose 1 or 2.');
    end 
    %


    % ---------- Option 09: Shutdown Strategy Options ----------
    who.Option09f8.Option_09 = 'Option 09 of Recursive Function f8';
    who.Option09f8.about = 'Shutdown Strategy Options';
    who.Option09f8.choose_01 = 'Option09f8 == 1 to choose use the Shutdown Strategy proposed by Abbas (2022).';
    who.Option09f8.choose_02 = 'Option09f8 == 2 to choose use the possible Shutdown Strategy for CP, CQ, CT, Lambda and Beta data, just to avoid numerical errors in the simulation.';
        % Choose your option:
    s.Option09f8 = 2; 
    if s.Option09f8 == 1 || s.Option09f8 == 2
        GeneratorTorqueController.Option09f8= s.Option09f8;
        BladePitchController.Option09f8 = s.Option09f8;  
        PIGainScheduledTSR.Option09f8 = s.Option09f8;          
    else
        error('Invalid option selected for s.Option09f8. Please choose 1 or 2.');
    end 
    %    

    % ---------- Option 10: Plot control results ----------
    who.Option10f8.Option_10 = 'Option 10 of Recursive Function f8';
    who.Option10f8.about = 'Plot control results';
    who.Option10f8.choose_01 = 'Option10f8 == 1 choose DO NOT plot control results (simulation).';
    who.Option10f8.choose_02 = 'Option10f8 == 2 choose PLOT THE MAIN FIGURES of control results (simulation).';
    who.Option10f8.choose_03 = 'Option10f8 == 3 to choose Plot ALL FIGURES of control results (simulation).';    
        % Choose your option:
    s.Option10f8 = 2; 
    if s.Option10f8 == 1 || s.Option10f8 == 2 || s.Option10f8 == 3
        GeneratorTorqueController.Option10f8= s.Option10f8;
        BladePitchController.Option10f8 = s.Option10f8;  
        PIGainScheduledTSR.Option10f8 = s.Option10f8;          
    else
        error('Invalid option selected for s.Option10f8. Please choose 1 or 2 or 3.');
    end 




    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);


    % Calling the next logic instance 
    if s.Option02f1 == 1 
        % Estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator using Kalman Filter signals
        EWSEstimator_KalmanFilterTorqueEstimator;
    elseif s.Option02f1 == 2 
        % Estimate Effective Wind Speed ​​directly or online using Extended Kalman Filter
        ExtendedKalmanFilterOnlineEWSEstimator;
    end   


    
elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES BASED ON CHOSEN OPTIONS (OFFLINE):
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f8), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.



            %####### Controller Modules #######

    % ---------------- Controller Modules ------------------------------  
    who.Mode_GeneratorController = 'Generator Torque Controller Module.';    
    who.Mode_BladePitchController = 'Blade Pitch Controller Module.'; 
    s.Mode_GeneratorController = [1 1];
    s.Mode_GeneratorController_before = [1 1];   
    s.Mode_BladePitchController = [1 1]; 
    s.Mode_GeneratorController_before = 1; 


            %####### General Design Parameters #######

    % ---------- Sampling the Controllers ----------
    who.Sample_Frequency_c = 'Sampling the Controllers, in [Hz]';
    s.Sample_Frequency_c = 1; 

    who.Sample_Rate_c = 'Sampling the Controllers, in [s]';
    s.Sample_Rate_c = 1/s.Sample_Frequency_c; 
    

            %####### Design Peak Shaving Straegy #######

    % ---------- Peak Shaving Design Coefficients and Parameters ----------
    who.a_shaving  = 'Peak Shaving Design Parameter.';
    PIGainScheduledTSR.a_shaving = s.a_shaving; 
   

            %####### Design Controllers #######

    % ---------- Set Point Smoother Design Coefficients and Parameters ----------
    who.Kvs  = 'Gain for Set Point Smoother, Abba (2022).';
    PIGainScheduledTSR.Kvs = s.Kvs; 
    who.Kpc  = 'Gain for Set Point Smoothe, Abba (2022).';
    PIGainScheduledTSR.Kpc = s.Kpc;  
      

    % ---------- Controller Design and Stability Analysis ----------
    who.OmegaN_Tg  = 'Desired Natural Vibration Frequency for Generator Torque Controller.';
    PIGainScheduledTSR.OmegaNTg_Tab = s.OmegaNTg_Tab;
    who.DampingCFactor_Tg  = 'Desired Critical Damping Factor for Generator Torque Controller.';
    PIGainScheduledTSR.DampingCFactorTg_Tab = s.DampingCFactorTg_Tab;   
    who.OmegaN_Beta  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
    PIGainScheduledTSR.OmegaNBeta_Tab = s.OmegaNBeta_Tab;     
    who.DampingCFactor_Beta  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
    PIGainScheduledTSR.DampingCFactorBeta_Tab = s.DampingCFactorBeta_Tab;     
    who.Tg_dMax  = 'Maximum Generator Torque, in [N.m].';
    PIGainScheduledTSR.Tg_dMax = s.Tg_dMax ;
    who.BetaMinRegion3  = 'Minimum Collective Blade Pitch in Region 3, and in [deg].';
    PIGainScheduledTSR.BetaMinRegion3 = s.BetaMinRegion3;     

    
    % ---------- Cutoff Frequencies for Control Signals ----------    
    who.CutFreq_DriveTrain = 'Cutoff frequency for control signals, in [Hz] and used in drive train dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    PIGainScheduledTSR.CutFreq_DriveTrain = s.CutFreq_DriveTrain ;
    who.CutFreq_TowerTop = 'Cutoff frequency for control signals, in [rad/s] and used in tower-top dynamics. These signals will be filtered by a Low Pass Filter (LPF).';
    PIGainScheduledTSR.CutFreq_TowerTop = s.CutFreq_TowerTop ;  
    who.CutFreq_OmegaNstructure = 'Cutoff natural Frequency of the Structure, in [Hz].';
    PIGainScheduledTSR.CutFreq_OmegaNstructure = max([s.OmegaNTg_Tab s.OmegaNBeta_Tab]); 
    who.CutFreq_TowerForeAft = 'Notch filter cutoff frequency and the the tower fore–af motion, in [rad/s].'; 
    PIGainScheduledTSR.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft;  


    
            %####### Conntrol Strategies #######

    % ---------- Wind Turbine Control and Operation Strategy ----------
    PIGainScheduledTSR.Vop = s.Vop;
    PIGainScheduledTSR.OmegaR_op = s.OmegaR_op;
    PIGainScheduledTSR.Lambda_op = s.Lambda_op;
    PIGainScheduledTSR.Beta_op = s.Beta_op;
    PIGainScheduledTSR.Tg_op = s.Tg_op;  
    PIGainScheduledTSR.CP_op = s.CP_op;
    PIGainScheduledTSR.CQ_op = s.CQ_op;
    PIGainScheduledTSR.CT_op = s.CT_op;
    PIGainScheduledTSR.GradCpBeta_op = s.GradCpBeta_op;
    PIGainScheduledTSR.GradCpLambda_op = s.GradCpLambda_op;
    PIGainScheduledTSR.GradCtBeta_op = s.GradCtBeta_op;
    PIGainScheduledTSR.GradCtLambda_op = s.GradCtLambda_op;    
    PIGainScheduledTSR.Pa_op = s.Pa_op;   
    PIGainScheduledTSR.Ta_op = s.Ta_op;
    PIGainScheduledTSR.Fa_op = s.Fa_op;
    PIGainScheduledTSR.Pe_op = s.Pe_op;
    PIGainScheduledTSR.GradTaLambda_op = s.GradTaLambda_op;
    PIGainScheduledTSR.GradTaOmega_op = s.GradTaOmega_op;
    PIGainScheduledTSR.GradTaVop_op = s.GradTaVop_op;
    PIGainScheduledTSR.GradTaBeta_op = s.GradTaBeta_op;
    PIGainScheduledTSR.GradPaBeta_op = s.GradPaBeta_op;
    PIGainScheduledTSR.GradFaLambda_op = s.GradFaLambda_op;
    PIGainScheduledTSR.GradFaOmega_op = s.GradFaOmega_op;
    PIGainScheduledTSR.GradFaVop_op = s.GradFaVop_op;
    PIGainScheduledTSR.GradFaBeta_op = s.GradFaBeta_op;
    PIGainScheduledTSR.Lambda_op_opt = s.Lambda_op_opt;
    PIGainScheduledTSR.OmegaR_op_opt = s.OmegaR_op_opt;
    PIGainScheduledTSR.Beta_op_opt = s.Beta_op_opt;
    PIGainScheduledTSR.Ta_op_opt = s.Ta_op_opt;
    PIGainScheduledTSR.Pa_op_opt = s.Pa_op_opt;
    PIGainScheduledTSR.Indexop_Region1Region15 = s.Indexop_Region1Region15;
    PIGainScheduledTSR.Indexop_Region15Region2 = s.Indexop_Region15Region2;
    PIGainScheduledTSR.Indexop_Region2Region25 = s.Indexop_Region2Region25;
    PIGainScheduledTSR.Indexop_Region25Region3 = s.Indexop_Region25Region3;
    PIGainScheduledTSR.Indexop_Region3Region4 = s.Indexop_Region3Region4;
    PIGainScheduledTSR.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; 
    PIGainScheduledTSR.OmegaRop_Region25Region3 = s.OmegaRop_Region25Region3;
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
    s.OutputsLPF2B_filtered(2)  = 0;
    s.OutputsLPF2B_filtered(3)  = 0;    
    if s.Option02f2 > 1 
        % Offshore wind turbine
        s.OutputsLPF2B_filtered(4) = 0; % Surge   
        s.OutputsLPF2B_filtered(5) = 0; % Surge_dot
        s.OutputsLPF2B_filtered(6) = 0; % Surge_Ddot 
        s.OutputsLPF2B_filtered(7) = 0; % Sway 
        s.OutputsLPF2B_filtered(8) = 0; % Sway_dot   
        s.OutputsLPF2B_filtered(9) = 0; % Sway_Ddot    
        s.OutputsLPF2B_filtered(10) = 0; % Heave 
        s.OutputsLPF2B_filtered(11) = 0; % Heave_dot   
        s.OutputsLPF2B_filtered(12) = 0; % Heave_Ddot
        s.OutputsLPF2B_filtered(13) = 0; % RollAngle 
        s.OutputsLPF2B_filtered(14) = 0; % RollAngle_dot   
        s.OutputsLPF2B_filtered(15) = 0; % RollAngle_Ddot 
        s.OutputsLPF2B_filtered(16) = 0; % PitchAngle 
        s.OutputsLPF2B_filtered(17) = 0; % PitchAngle_dot   
        s.OutputsLPF2B_filtered(18) = 0; % PitchAngle_Ddot   
        s.OutputsLPF2B_filtered(19) = 0; % YawAngle 
        s.OutputsLPF2B_filtered(20) = 0; % YawAngle_dot   
        s.OutputsLPF2B_filtered(21) = 0; % YawAngle_Ddot         
    end        
    s.OutputsLPF2B_last = s.OutputsLPF2B_filtered;
    s.OutputsLPF2B_secondLast = s.OutputsLPF2B_last;
    s.OutputsHPF1_filtered = s.OutputsLPF2B_filtered;   
    s.OutputsHPF1_filtered_last = s.OutputsHPF1_filtered;

    s.Outputs_notched = s.OutputsLPF2B_filtered;
    s.Outputs_notched_Last = s.Outputs_notched;
    s.Outputs_notched_secondLast = s.Outputs_notched_Last;

    if s.Option08f8 == 1
        s.OutputsLPF3_filtered = 0;
        s.OutputsLPF3_filtered_last = 0;
    end
    %



    % ---------- Initial values ​​for the implementation of the Controllers  ----------    
    s.IntegTermPI_Tg = 0;
    s.IntegTermPI_Beta = 0; 
    s.Beta_d = interp1(s.Vop, s.Beta_op, s.V_meanHub_0) ;    
    s.Beta_d_before = s.Beta_d ;
    s.Beta_filtered_before = s.Beta_d ;
    s.Tg_d = interp1(s.Vop, s.Tg_op, s.V_meanHub_0) ;    
    s.Tg_d_before = s.Tg_d ;
    s.Tg_filtered_before = s.Tg_d ;    
    s.Pe_d_before = interp1(s.Vop, s.Pe_op, s.V_meanHub_0) ; 
    s.Pe_filtered_before = s.Pe_d_before ;
    s.Xf_dot_Lastfiltered = 0;

    

    % Organizing output results    
    PIGainScheduledTSR.Mode_GeneratorController = s.Mode_GeneratorController; GeneratorTorqueController.Mode_GeneratorController = s.Mode_GeneratorController;
    PIGainScheduledTSR.Mode_BladePitchController = s.Mode_BladePitchController; BladePitchController.Mode_BladePitchController = s.Mode_BladePitchController;
    PIGainScheduledTSR.Sample_Frequency_c = s.Sample_Frequency_c; PIGainScheduledTSR.Sample_Rate_c = s.Sample_Rate_c;
    GeneratorTorqueController.Sample_Frequency_c = s.Sample_Frequency_c; GeneratorTorqueController.Sample_Rate_c = s.Sample_Rate_c;
    BladePitchController.Sample_Frequency_c = s.Sample_Frequency_c; BladePitchController.Sample_Rate_c = s.Sample_Rate_c;   
    GeneratorTorqueController.Kvs = s.Kvs; BladePitchController.Kvs = s.Kvs;
    GeneratorTorqueController.Kpc = s.Kpc; BladePitchController.Kpc = s.Kpc;
    GeneratorTorqueController.a_shaving = s.a_shaving; BladePitchController.a_shaving = s.a_shaving; 

    BladePitchController.OmegaNBeta_Tab = s.OmegaNBeta_Tab;
    BladePitchController.DampingCFactorBeta_Tab = s.DampingCFactorBeta_Tab;
    GeneratorTorqueController.OmegaNTg_Tab = s.OmegaNTg_Tab;
    GeneratorTorqueController.DampingCFactorTg_Tab = s.DampingCFactorTg_Tab;

    GeneratorTorqueController.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure; BladePitchController.CutFreq_OmegaNstructure = s.CutFreq_OmegaNstructure;
    GeneratorTorqueController.CutFreq_DriveTrain = s.CutFreq_DriveTrain; BladePitchController.CutFreq_DriveTrain = s.CutFreq_DriveTrain;
    GeneratorTorqueController.CutFreq_TowerTop = s.CutFreq_TowerTop; BladePitchController.CutFreq_TowerTop = s.CutFreq_TowerTop; 
    GeneratorTorqueController.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft; BladePitchController.CutFreq_TowerForeAft = s.CutFreq_TowerForeAft;
    
    GeneratorTorqueController.Vop = s.Vop; GeneratorTorqueController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; GeneratorTorqueController.OmegaR_op = s.OmegaR_op; GeneratorTorqueController.Lambda_op = s.Lambda_op; GeneratorTorqueController.Beta_op = s.Beta_op; GeneratorTorqueController.Tg_op = s.Tg_op; GeneratorTorqueController.CP_op = s.CP_op; GeneratorTorqueController.CQ_op = s.CQ_op; GeneratorTorqueController.CT_op = s.CT_op; GeneratorTorqueController.GradCpBeta_op = s.GradCpBeta_op; GeneratorTorqueController.GradCpLambda_op = s.GradCpLambda_op; GeneratorTorqueController.GradCtBeta_op = s.GradCtBeta_op; GeneratorTorqueController.GradCtLambda_op = s.GradCtLambda_op; GeneratorTorqueController.Pa_op = s.Pa_op; GeneratorTorqueController.Ta_op = s.Ta_op; GeneratorTorqueController.Fa_op = s.Fa_op; GeneratorTorqueController.Pe_op = s.Pe_op; GeneratorTorqueController.GradTaLambda_op = s.GradTaLambda_op; GeneratorTorqueController.GradTaOmega_op = s.GradTaOmega_op; GeneratorTorqueController.GradTaVop_op = s.GradTaVop_op; GeneratorTorqueController.GradTaBeta_op = s.GradTaBeta_op; GeneratorTorqueController.GradPaBeta_op = s.GradPaBeta_op; GeneratorTorqueController.GradFaLambda_op = s.GradFaLambda_op; GeneratorTorqueController.GradFaOmega_op = s.GradFaOmega_op; GeneratorTorqueController.GradFaVop_op = s.GradFaVop_op; GeneratorTorqueController.GradFaBeta_op = s.GradFaBeta_op; GeneratorTorqueController.Lambda_op_opt = s.Lambda_op_opt; GeneratorTorqueController.OmegaR_op_opt = s.OmegaR_op_opt; GeneratorTorqueController.Beta_op_opt = s.Beta_op_opt; GeneratorTorqueController.Ta_op_opt = s.Ta_op_opt; GeneratorTorqueController.Pa_op_opt = s.Pa_op_opt; GeneratorTorqueController.Indexop_Region1Region15 = s.Indexop_Region1Region15; GeneratorTorqueController.Indexop_Region15Region2 = s.Indexop_Region15Region2; GeneratorTorqueController.Indexop_Region2Region25 = s.Indexop_Region2Region25; GeneratorTorqueController.Indexop_Region25Region3 = s.Indexop_Region25Region3; GeneratorTorqueController.Indexop_Region3Region4 = s.Indexop_Region3Region4;  GeneratorTorqueController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation;    
    BladePitchController.Vop = s.Vop; BladePitchController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation; BladePitchController.OmegaR_op = s.OmegaR_op; BladePitchController.Lambda_op = s.Lambda_op; BladePitchController.Beta_op = s.Beta_op; BladePitchController.Tg_op = s.Tg_op; BladePitchController.CP_op = s.CP_op; BladePitchController.CQ_op = s.CQ_op; BladePitchController.CT_op = s.CT_op; BladePitchController.GradCpBeta_op = s.GradCpBeta_op; BladePitchController.GradCpLambda_op = s.GradCpLambda_op; BladePitchController.GradCtBeta_op = s.GradCtBeta_op; BladePitchController.GradCtLambda_op = s.GradCtLambda_op; BladePitchController.Pa_op = s.Pa_op; BladePitchController.Ta_op = s.Ta_op; BladePitchController.Fa_op = s.Fa_op; BladePitchController.Pe_op = s.Pe_op; BladePitchController.GradTaLambda_op = s.GradTaLambda_op; BladePitchController.GradTaOmega_op = s.GradTaOmega_op; BladePitchController.GradTaVop_op = s.GradTaVop_op; BladePitchController.GradTaBeta_op = s.GradTaBeta_op; BladePitchController.GradPaBeta_op = s.GradPaBeta_op; BladePitchController.GradFaLambda_op = s.GradFaLambda_op; BladePitchController.GradFaOmega_op = s.GradFaOmega_op; BladePitchController.GradFaVop_op = s.GradFaVop_op; BladePitchController.GradFaBeta_op = s.GradFaBeta_op; BladePitchController.Lambda_op_opt = s.Lambda_op_opt; BladePitchController.OmegaR_op_opt = s.OmegaR_op_opt; BladePitchController.Beta_op_opt = s.Beta_op_opt; BladePitchController.Ta_op_opt = s.Ta_op_opt; BladePitchController.Pa_op_opt = s.Pa_op_opt; BladePitchController.Indexop_Region1Region15 = s.Indexop_Region1Region15; BladePitchController.Indexop_Region15Region2 = s.Indexop_Region15Region2; BladePitchController.Indexop_Region2Region25 = s.Indexop_Region2Region25; BladePitchController.Indexop_Region25Region3 = s.Indexop_Region25Region3; BladePitchController.Indexop_Region3Region4 = s.Indexop_Region3Region4;  BladePitchController.Indexop_Regions4EndOperation = s.Indexop_Regions4EndOperation;
    %
   


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);


    % Returns to "WindTurbine_data" at Logical Instance in WindTurbineData_NREL5MW,
        % or WindTurbineData_IEA15MW or WindTurbineData_DTU10MW).


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
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
    s.Xt_measured = s.Sensor.Xt ;
    who.Xt_dot_measured = 'Tower-Top Fore-Aft Velocity Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_dot_measured = s.Sensor.Xt_dot ; 
    who.Xt_Ddot_measured = 'Tower-Top Fore-Aft Acceleration Measurement (front longitudinal axis), in [m/s^2].';
    s.Xt_Ddot_measured = s.Sensor.Xt_Ddot ; 
      
    if s.Option02f2 > 1
        % Offshore wind turbine   
        who.Surge_measured = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
        s.Surge_measured = s.Sensor.Surge ;           
        who.Surge_dot_measured = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
        s.Surge_dot_measured = s.Sensor.Surge_dot ; 
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



    if (s.Option04f8 == 3)
        % DO NOT consider Active Tower Damping
        s.Xt_est = s.Xt_measured ;
        s.Xt_dot_est = s.Xt_dot_measured ;
        s.Xt_Ddot_est = s.Xt_Ddot_measured ;
        if s.Option02f2 > 1
            % Offshore wind turbine 
            s.Surge_est = s.Surge_measured;
            s.Surge_dot_est = s.Surge_dot_measured;            
            s.Surge_Ddot_est = s.Surge_Ddot_measured; 
            s.Sway_est = s.Sway_measured;  
            s.Sway_dot_est = s.Sway_dot_measured; 
            s.Sway_Ddot_est = s.Sway_Ddot_measured;    
            s.Heave_est = s.Heave_measured;
            s.Heave_dot_est = s.Heave_dot_measured;
            s.Heave_Ddot_est = s.Heave_Ddot_measured;  
            s.RollAngle_est = s.RollAngle_measured;  
            s.RollAngle_dot_est = s.RollAngle_dot_measured;              
            s.RollAngle_Ddot_est = s.RollAngle_Ddot_measured;  
            s.PitchAngle_est = s.PitchAngle_measured;   
            s.PitchAngle_dot_est = s.PitchAngle_dot_measured;  
            s.PitchAngle_Ddot_est = s.PitchAngle_Ddot_measured; 
            s.YawAngle_est = s.YawAngle_measured; 
            s.YawAngle_dot_est = s.YawAngle_dot_measured; 
            s.YawAngle_Ddot_est = s.YawAngle_Ddot_measured;    
            %
        end % if s.Option02f2 > 1
    end % if (s.Option04f8 == 3)



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledTSR_Abbas2022('logical_instance_04');



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
    who.CutFreq_LPF1 = 'Low-pass filter (LPF) cutoff frequency, in [Hz].';
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
    s.InputsLPF2B_unfiltered(1,1) = s.Xt_measured ;
    s.InputsLPF2B_unfiltered(1,2) = s.Xt_dot_measured ;
    s.InputsLPF2B_unfiltered(1,3) = s.Xt_Ddot_measured ;

    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.InputsLPF2B_unfiltered(1,4) = s.Surge_measured;
        s.InputsLPF2B_unfiltered(1,5) = s.Surge_dot_measured;            
        s.InputsLPF2B_unfiltered(1,6) = s.Surge_Ddot_measured;            
        s.InputsLPF2B_unfiltered(1,7) = s.Sway_measured;  
        s.InputsLPF2B_unfiltered(1,8) = s.Sway_dot_measured; 
        s.InputsLPF2B_unfiltered(1,9) = s.Sway_Ddot_measured;             
        s.InputsLPF2B_unfiltered(1,10) = s.Heave_measured;
        s.InputsLPF2B_unfiltered(1,11) = s.Heave_dot_measured;
        s.InputsLPF2B_unfiltered(1,12) = s.Heave_Ddot_measured;            
        s.InputsLPF2B_unfiltered(1,13) = s.RollAngle_measured;  
        s.InputsLPF2B_unfiltered(1,14) = s.RollAngle_dot_measured;              
        s.InputsLPF2B_unfiltered(1,15) = s.RollAngle_Ddot_measured;              
        s.InputsLPF2B_unfiltered(1,16) = s.PitchAngle_measured;   
        s.InputsLPF2B_unfiltered(1,17) = s.PitchAngle_dot_measured;  
        s.InputsLPF2B_unfiltered(1,18) = s.PitchAngle_Ddot_measured;              
        s.InputsLPF2B_unfiltered(1,19) = s.YawAngle_measured; 
        s.InputsLPF2B_unfiltered(1,20) = s.YawAngle_dot_measured; 
        s.InputsLPF2B_unfiltered(1,21) = s.YawAngle_Ddot_measured;    
        %
    end % if s.Option02f2 > 1


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
        s.Xt_LPF2Bfiltered = a0_LPF2B * s.Xt_measured;
        s.Xt_dot_LPF2Bfiltered = a0_LPF2B * s.Xt_dot_measured;
        s.Xt_Ddot_LPF2Bfiltered = a0_LPF2B * s.Xt_Ddot_measured;

        if s.Option02f2 > 1
            s.Surge_LPF2Bfiltered = a0_LPF2B * s.Surge_measured;
            s.Surge_dot_LPF2Bfiltered = a0_LPF2B * s.Surge_dot_measured;
            s.Surge_Ddot_LPF2Bfiltered = a0_LPF2B * s.Surge_Ddot_measured;
            s.Sway_LPF2Bfiltered = a0_LPF2B * s.Sway_measured;
            s.Sway_dot_LPF2Bfiltered = a0_LPF2B * s.Sway_dot_measured;
            s.Sway_Ddot_LPF2Bfiltered = a0_LPF2B * s.Sway_Ddot_measured;
            s.Heave_LPF2Bfiltered = a0_LPF2B * s.Heave_measured;
            s.Heave_dot_LPF2Bfiltered = a0_LPF2B * s.Heave_dot_measured;            
            s.Heave_Ddot_LPF2Bfiltered = a0_LPF2B * s.Heave_Ddot_measured;
            s.RollAngle_LPF2Bfiltered = a0_LPF2B * s.RollAngle_measured;
            s.RollAngle_dot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_dot_measured;
            s.RollAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_Ddot_measured;
            s.PitchAngle_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_measured;
            s.PitchAngle_dot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_dot_measured;
            s.PitchAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_Ddot_measured;
            s.YawAngle_LPF2Bfiltered = a0_LPF2B * s.YawAngle_measured;
            s.YawAngle_dot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_dot_measured;            
            s.YawAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_Ddot_measured;
            y_filteredLPF2B = [s.Xt_LPF2Bfiltered, s.Xt_dot_LPF2Bfiltered, s.Xt_Ddot_LPF2Bfiltered, s.Surge_LPF2Bfiltered, s.Surge_dot_LPF2Bfiltered, s.Surge_Ddot_LPF2Bfiltered, s.Sway_LPF2Bfiltered, s.Sway_dot_LPF2Bfiltered, s.Sway_Ddot_LPF2Bfiltered, s.Heave_LPF2Bfiltered, s.Heave_dot_LPF2Bfiltered, s.Heave_Ddot_LPF2Bfiltered, s.RollAngle_LPF2Bfiltered, s.RollAngle_dot_LPF2Bfiltered, s.RollAngle_Ddot_LPF2Bfiltered, s.PitchAngle_LPF2Bfiltered, s.PitchAngle_dot_LPF2Bfiltered, s.PitchAngle_Ddot_LPF2Bfiltered, s.YawAngle_LPF2Bfiltered, s.YawAngle_dot_LPF2Bfiltered, s.YawAngle_Ddot_LPF2Bfiltered];
            %
        else
            y_filteredLPF2B = [s.Xt_LPF2Bfiltered, s.Xt_dot_LPF2Bfiltered, s.Xt_Ddot_LPF2Bfiltered] ;
        end
        %
    else
        s.Xt_LPF2Bfiltered = a0_LPF2B * s.Xt_measured + a1_LPF2B * s.OutputsLPF2B_last(1) + a2_LPF2B * s.OutputsLPF2B_secondLast(1) - b1_LPF2B * s.OutputsLPF2B_last(1) - b2_LPF2B * s.OutputsLPF2B_secondLast(1);
        s.Xt_dot_LPF2Bfiltered = a0_LPF2B * s.Xt_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(2) + a2_LPF2B * s.OutputsLPF2B_secondLast(2) - b1_LPF2B * s.OutputsLPF2B_last(2) - b2_LPF2B * s.OutputsLPF2B_secondLast(2);
        s.Xt_Ddot_LPF2Bfiltered = a0_LPF2B * s.Xt_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(3) + a2_LPF2B * s.OutputsLPF2B_secondLast(3) - b1_LPF2B * s.OutputsLPF2B_last(3) - b2_LPF2B * s.OutputsLPF2B_secondLast(3);
        if s.Option02f2 > 1
            s.Surge_LPF2Bfiltered = a0_LPF2B * s.Surge_measured + a1_LPF2B * s.OutputsLPF2B_last(4) + a2_LPF2B * s.OutputsLPF2B_secondLast(4) - b1_LPF2B * s.OutputsLPF2B_last(4) - b2_LPF2B * s.OutputsLPF2B_secondLast(4);
            s.Surge_dot_LPF2Bfiltered = a0_LPF2B * s.Surge_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(5) + a2_LPF2B * s.OutputsLPF2B_secondLast(5) - b1_LPF2B * s.OutputsLPF2B_last(5) - b2_LPF2B * s.OutputsLPF2B_secondLast(5);            
            s.Surge_Ddot_LPF2Bfiltered = a0_LPF2B * s.Surge_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(6) + a2_LPF2B * s.OutputsLPF2B_secondLast(6) - b1_LPF2B * s.OutputsLPF2B_last(6) - b2_LPF2B * s.OutputsLPF2B_secondLast(6);
            s.Sway_LPF2Bfiltered = a0_LPF2B * s.Sway_measured + a1_LPF2B * s.OutputsLPF2B_last(7) + a2_LPF2B * s.OutputsLPF2B_secondLast(7) - b1_LPF2B * s.OutputsLPF2B_last(7) - b2_LPF2B * s.OutputsLPF2B_secondLast(7);
            s.Sway_dot_LPF2Bfiltered = a0_LPF2B * s.Sway_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(8) + a2_LPF2B * s.OutputsLPF2B_secondLast(8) - b1_LPF2B * s.OutputsLPF2B_last(8) - b2_LPF2B * s.OutputsLPF2B_secondLast(8);            
            s.Sway_Ddot_LPF2Bfiltered = a0_LPF2B * s.Sway_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(9) + a2_LPF2B * s.OutputsLPF2B_secondLast(9) - b1_LPF2B * s.OutputsLPF2B_last(9) - b2_LPF2B * s.OutputsLPF2B_secondLast(9);
            s.Heave_LPF2Bfiltered = a0_LPF2B * s.Heave_measured + a1_LPF2B * s.OutputsLPF2B_last(10) + a2_LPF2B * s.OutputsLPF2B_secondLast(10) - b1_LPF2B * s.OutputsLPF2B_last(10) - b2_LPF2B * s.OutputsLPF2B_secondLast(10);
            s.Heave_dot_LPF2Bfiltered = a0_LPF2B * s.Heave_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(11) + a2_LPF2B * s.OutputsLPF2B_secondLast(11) - b1_LPF2B * s.OutputsLPF2B_last(11) - b2_LPF2B * s.OutputsLPF2B_secondLast(11);            
            s.Heave_Ddot_LPF2Bfiltered = a0_LPF2B * s.Heave_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(12) + a2_LPF2B * s.OutputsLPF2B_secondLast(12) - b1_LPF2B * s.OutputsLPF2B_last(12) - b2_LPF2B * s.OutputsLPF2B_secondLast(12);
            s.RollAngle_LPF2Bfiltered = a0_LPF2B * s.RollAngle_measured + a1_LPF2B * s.OutputsLPF2B_last(13) + a2_LPF2B * s.OutputsLPF2B_secondLast(13) - b1_LPF2B * s.OutputsLPF2B_last(13) - b2_LPF2B * s.OutputsLPF2B_secondLast(13);
            s.RollAngle_dot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(14) + a2_LPF2B * s.OutputsLPF2B_secondLast(14) - b1_LPF2B * s.OutputsLPF2B_last(14) - b2_LPF2B * s.OutputsLPF2B_secondLast(14);            
            s.RollAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.RollAngle_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(15) + a2_LPF2B * s.OutputsLPF2B_secondLast(15) - b1_LPF2B * s.OutputsLPF2B_last(15) - b2_LPF2B * s.OutputsLPF2B_secondLast(15);
            s.PitchAngle_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_measured + a1_LPF2B * s.OutputsLPF2B_last(16) + a2_LPF2B * s.OutputsLPF2B_secondLast(16) - b1_LPF2B * s.OutputsLPF2B_last(16) - b2_LPF2B * s.OutputsLPF2B_secondLast(16);
            s.PitchAngle_dot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(17) + a2_LPF2B * s.OutputsLPF2B_secondLast(17) - b1_LPF2B * s.OutputsLPF2B_last(17) - b2_LPF2B * s.OutputsLPF2B_secondLast(17);            
            s.PitchAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.PitchAngle_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(18) + a2_LPF2B * s.OutputsLPF2B_secondLast(18) - b1_LPF2B * s.OutputsLPF2B_last(18) - b2_LPF2B * s.OutputsLPF2B_secondLast(18);
            s.YawAngle_LPF2Bfiltered = a0_LPF2B * s.YawAngle_measured + a1_LPF2B * s.OutputsLPF2B_last(19) + a2_LPF2B * s.OutputsLPF2B_secondLast(19) - b1_LPF2B * s.OutputsLPF2B_last(19) - b2_LPF2B * s.OutputsLPF2B_secondLast(19);
            s.YawAngle_dot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_dot_measured + a1_LPF2B * s.OutputsLPF2B_last(20) + a2_LPF2B * s.OutputsLPF2B_secondLast(20) - b1_LPF2B * s.OutputsLPF2B_last(20) - b2_LPF2B * s.OutputsLPF2B_secondLast(20);            
            s.YawAngle_Ddot_LPF2Bfiltered = a0_LPF2B * s.YawAngle_Ddot_measured + a1_LPF2B * s.OutputsLPF2B_last(21) + a2_LPF2B * s.OutputsLPF2B_secondLast(21) - b1_LPF2B * s.OutputsLPF2B_last(21) - b2_LPF2B * s.OutputsLPF2B_secondLast(21);
            y_filteredLPF2B = [s.Xt_LPF2Bfiltered, s.Xt_dot_LPF2Bfiltered, s.Xt_Ddot_LPF2Bfiltered, s.Surge_LPF2Bfiltered, s.Surge_dot_LPF2Bfiltered, s.Surge_Ddot_LPF2Bfiltered, s.Sway_LPF2Bfiltered, s.Sway_dot_LPF2Bfiltered, s.Sway_Ddot_LPF2Bfiltered, s.Heave_LPF2Bfiltered, s.Heave_dot_LPF2Bfiltered, s.Heave_Ddot_LPF2Bfiltered, s.RollAngle_LPF2Bfiltered, s.RollAngle_dot_LPF2Bfiltered, s.RollAngle_Ddot_LPF2Bfiltered, s.PitchAngle_LPF2Bfiltered, s.PitchAngle_dot_LPF2Bfiltered, s.PitchAngle_Ddot_LPF2Bfiltered, s.YawAngle_LPF2Bfiltered, s.YawAngle_dot_LPF2Bfiltered, s.YawAngle_Ddot_LPF2Bfiltered];
            %
        else
            y_filteredLPF2B = [s.Xt_LPF2Bfiltered, s.Xt_dot_LPF2Bfiltered, s.Xt_Ddot_LPF2Bfiltered] ;
        end
        %
    end
    

    % ---------- Low-Pass Filter Outputs ----------    
    who.OutputsLPF2B_filtered = 'Filtered signals at the output of the LPF.';
    s.OutputsLPF2B_filtered = y_filteredLPF2B;  
    s.OutputsLPF2B_secondLast = s.OutputsLPF2B_last; % Update the second-to-last value.    
    s.OutputsLPF2B_last = y_filteredLPF2B; % Update the last value.



    % Assigning outputs to their respective variables
    s.Xt_LPF2Bfiltered = s.OutputsLPF2B_filtered(1);
    s.Xt_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(2);
    s.Xt_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(3);

    if s.Option02f2 > 1
        s.Surge_LPF2Bfiltered = s.OutputsLPF2B_filtered(4);
        s.Surge_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(5);
        s.Surge_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(6);        
        s.Sway_LPF2Bfiltered = s.OutputsLPF2B_filtered(7);
        s.Sway_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(8);        
        s.Sway_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(9);
        s.Heave_LPF2Bfiltered = s.OutputsLPF2B_filtered(10);
        s.Heave_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(11);
        s.Heave_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(12);
        s.RollAngle_LPF2Bfiltered = s.OutputsLPF2B_filtered(13);
        s.RollAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(14);        
        s.RollAngle_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(15);
        s.PitchAngle_LPF2Bfiltered = s.OutputsLPF2B_filtered(16);
        s.PitchAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(17);        
        s.PitchAngle_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(18);
        s.YawAngle_LPF2Bfiltered = s.OutputsLPF2B_filtered(19);
        s.YawAngle_dot_LPF2Bfiltered = s.OutputsLPF2B_filtered(20);        
        s.YawAngle_Ddot_LPF2Bfiltered = s.OutputsLPF2B_filtered(21);
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

    s.Xt_filteredHPF1 = s.OutputsHPF1_filtered(1);    
    s.Xt_dot_filteredHPF1 = s.OutputsHPF1_filtered(2);  
    s.Xt_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(3);      
    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.Surge_filteredHPF1 = s.OutputsHPF1_filtered(4);
        s.Surge_dot_filteredHPF1 = s.OutputsHPF1_filtered(5);
        s.Surge_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(6);
        s.Sway_filteredHPF1 = s.OutputsHPF1_filtered(7); 
        s.Sway_dot_filteredHPF1 = s.OutputsHPF1_filtered(8); 
        s.Sway_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(9); 
        s.Heave_filteredHPF1 = s.OutputsHPF1_filtered(10);
        s.Heave_dot_filteredHPF1 = s.OutputsHPF1_filtered(11);
        s.Heave_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(12);
        s.RollAngle_filteredHPF1 = s.OutputsHPF1_filtered(13);  
        s.RollAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(14);  
        s.RollAngle_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(15);  
        s.PitchAngle_filteredHPF1 = s.OutputsHPF1_filtered(16); 
        s.PitchAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(17); 
        s.PitchAngle_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(18); 
        s.YawAngle_filteredHPF1 = s.OutputsHPF1_filtered(19); 
        s.YawAngle_dot_filteredHPF1 = s.OutputsHPF1_filtered(20);
        s.YawAngle_Ddot_filteredHPF1 = s.OutputsHPF1_filtered(21);         
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

    s.Xt_filteredNF = s.Outputs_notched(1); 
    s.Xt_dot_filteredNF = s.Outputs_notched(2); 
    s.Xt_Ddot_filteredNF = s.Outputs_notched(3);     
    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.Surge_filteredNF = s.Outputs_notched(4);
        s.Surge_dot_filteredNF = s.Outputs_notched(5);
        s.Surge_Ddot_filteredNF = s.Outputs_notched(6);
        s.Sway_filteredNF = s.Outputs_notched(7);  
        s.Sway_dot_filteredNF = s.Outputs_notched(8);   
        s.Sway_Ddot_filteredNF = s.Outputs_notched(9);  
        s.Heave_filteredNF = s.Outputs_notched(10);
        s.Heave_dot_filteredNF = s.Outputs_notched(11);
        s.Heave_Ddot_filteredNF = s.Outputs_notched(12);
        s.RollAngle_filteredNF = s.Outputs_notched(13); 
        s.RollAngle_dot_filteredNF = s.Outputs_notched(14);         
        s.RollAngle_Ddot_filteredNF = s.Outputs_notched(15);  
        s.PitchAngle_filteredNF = s.Outputs_notched(16); 
        s.PitchAngle_dot_filteredNF = s.Outputs_notched(17);         
        s.PitchAngle_Ddot_filteredNF = s.Outputs_notched(18); 
        s.YawAngle_filteredNF = s.Outputs_notched(19);  
        s.YawAngle_dot_filteredNF = s.Outputs_notched(20);          
        s.YawAngle_Ddot_filteredNF = s.Outputs_notched(21);   
    end



    % ------- Selection of Tower-Top Dynamics Signals ----------
    if (s.Option03f8 == 1) && (s.Option04f8 < 3)
        % Filtered signals according to Abbas (2022)
        s.Xt_est = s.Xt_filteredNF;
        s.Xt_dot_est = s.Xt_dot_filteredNF;
        s.Xt_Ddot_est = s.Xt_Ddot_filteredNF;
        if s.Option02f2 > 1
            % Offshore wind turbine 
            s.Surge_est = s.Surge_filteredNF;
            s.Surge_dot_est = s.Surge_dot_filteredNF;
            s.Surge_Ddot_est = s.Surge_Ddot_filteredNF;
            s.Sway_est = s.Sway_filteredNF;    
            s.Sway_dot_est = s.Sway_dot_filteredNF;    
            s.Sway_Ddot_est = s.Sway_Ddot_filteredNF;    
            s.Heave_est = s.Heave_filteredNF;
            s.Heave_dot_est = s.Heave_dot_filteredNF;
            s.Heave_Ddot_est = s.Heave_Ddot_filteredNF;
            s.RollAngle_est = s.RollAngle_filteredNF;  
            s.RollAngle_dot_est = s.RollAngle_dot_filteredNF;              
            s.RollAngle_Ddot_est = s.RollAngle_Ddot_filteredNF;
            s.PitchAngle_est = s.PitchAngle_filteredNF;  
            s.PitchAngle_dot_est = s.PitchAngle_dot_filteredNF;              
            s.PitchAngle_Ddot_est = s.PitchAngle_Ddot_filteredNF;  
            s.YawAngle_est = s.YawAngle_filteredNF; 
            s.YawAngle_dot_est = s.YawAngle_dot_filteredNF;             
            s.YawAngle_Ddot_est = s.YawAngle_Ddot_filteredNF;   
        end
        %
    elseif (s.Option03f8 == 2) && (s.Option04f8 < 3)
        % Filtered signals only with a 2nd Order Low Pass Filter
        s.Xt_est = s.Xt_LPF2Bfiltered;
        s.Xt_dot_est = s.Xt_dot_LPF2Bfiltered;
        s.Xt_Ddot_est = s.Xt_Ddot_LPF2Bfiltered;
        if s.Option02f2 > 1
            % Offshore wind turbine 
            s.Surge_est = s.Surge_LPF2Bfiltered;
            s.Surge_dot_est = s.Surge_dot_LPF2Bfiltered;
            s.Surge_Ddot_est = s.Surge_Ddot_LPF2Bfiltered;
            s.Sway_est = s.Sway_LPF2Bfiltered;    
            s.Sway_dot_est = s.Sway_dot_LPF2Bfiltered;    
            s.Sway_Ddot_est = s.Sway_Ddot_LPF2Bfiltered;    
            s.Heave_est = s.Heave_LPF2Bfiltered;
            s.Heave_dot_est = s.Heave_dot_LPF2Bfiltered;
            s.Heave_Ddot_est = s.Heave_Ddot_LPF2Bfiltered;
            s.RollAngle_est = s.RollAngle_LPF2Bfiltered;  
            s.RollAngle_dot_est = s.RollAngle_dot_LPF2Bfiltered;              
            s.RollAngle_Ddot_est = s.RollAngle_Ddot_LPF2Bfiltered;
            s.PitchAngle_est = s.PitchAngle_LPF2Bfiltered;  
            s.PitchAngle_dot_est = s.PitchAngle_dot_LPF2Bfiltered;              
            s.PitchAngle_Ddot_est = s.PitchAngle_Ddot_LPF2Bfiltered;  
            s.YawAngle_est = s.YawAngle_LPF2Bfiltered; 
            s.YawAngle_dot_est = s.YawAngle_dot_LPF2Bfiltered;             
            s.YawAngle_Ddot_est = s.YawAngle_Ddot_LPF2Bfiltered;   
        end
        %
    end % if (s.Option03f8 == 1) && (s.Option04f8 < 3)


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % FILTERING OTHERS SIGNALS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Low Pass Filters
    % (LPF) for the signals that will be used by the controllers in drive
    % train dynamics model.


             %###### LOW-PASS FILTER 1ª ORDER (LPF3) ###### 


    % ---------- Low Pass Filter (LPF3) Inputs ----------
    who.InputsLPF3_unfiltered = 'Unfiltered signals or signals at the input of the LPF3 filter.';
    s.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered_set; % Set before calling this Logical Instance

    who.InputsLPF3_filtered = 'Last filtered signals or filtered signals used as input to the LPF3 filter.';
    s.InputsLPF3_filtered = s.InputsLPF3_filtered_set; % Set before calling this Logical Instance


    % ---------- LOW-PASS FILTER (LPF3) ----------
    who.CutFreq_LPF3 = 'Low-pass filter (LPF) cutoff frequency, in [Hz]..';
    s.CutFreq_LPF3 = s.CutFreq_LPF3_set; % Set before calling this Logical Instance
    who.Ts_LPF3 = 'Low-pass filter (LPF) discrete time step or system sampling rate, in [s].';
    s.Ts_LPF3 = s.Ts_LPF3_set; % Set before calling this Logical Instance

    s.alfa_LPF3 = exp(- 2*pi*s.CutFreq_LPF3*s.Ts_LPF3);
    s.Ad_LPF3 = s.alfa_LPF3;
    s.Bd_LPF3 = (1 - s.alfa_LPF3);
    s.Cd_LPF3 = s.alfa_LPF3;
    s.Dd_LPF3 = (1 - s.alfa_LPF3);
    y_filteredLPF3 = (s.Cd_LPF3 .* s.InputsLPF3_filtered) + (s.Dd_LPF3 .* s.InputsLPF3_unfiltered);    

    % ---------- Low Pass Filter (LPF) Outputs ----------    
    who.OutputsLPF3_filtered = 'Filtered signals or signals at the output of the LPF3 filter.';
    s.OutputsLPF3_filtered = y_filteredLPF3;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to the location that called this Logical Instance


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
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
    who.OmegaG_filtered = 'Generator Speed ​​filtered by 1st Order Low-Pass Filter, in [rad/s].';    
    s.OmegaG_filtered = max(  s.OmegaG_filteredLPF1 , min(s.OmegaR_op*s.eta_gb) );
    who.Beta_filtered = 'Collective Blade Pitch filtered by 1st Order Low-Pass Filter, in [deg]';
    s.Beta_filtered = max(  s.Beta_filteredLPF1 , min(s.Beta_op) ); 
    who.Tg_filtered = 'Generator Torque filtered by 1st Order Low-Pass Filter, in [N.m]';
    s.Tg_filtered = max(  s.Tg_filteredLPF1 , min(s.Tg_op) ); 
    who.Pe_filtered = 'Electrical power filtered by 1st Order Low-Pass Filter, in [W]';
    s.Pe_filtered = max(  s.Pe_filteredLPF1 , min(s.Tg_op) );     
    who.WindSpedd_hub_filtered = 'Wind speed measured by anemometer and filtered by low pass filter, in [m/s]';
    s.WindSpedd_hub_filtered = max(  s.WindSpedd_hub_filteredLPF1 , 0.01 ); 

    if s.Option02f8 == 2 % Uses signals from State Observer
        who.OmegaR_filtered = 'Rotor Speed ​​filtered by a State Observer, in [rad/s].';
        s.OmegaR_filtered = max(  s.OmegaR_est , min(s.OmegaR_op) );
        who.Vews_op = 'Effective Wind Speed ​​at the operating point estimated by a State Observer, in [m/s].';
        s.Vews_op = max( s.Vews_est , min(s.Vop) );
        %         
    else % Uses signals from LPF1 and LPF3
        who.OmegaR_filtered = 'Rotor Speed ​​filtered by 1st Order Low-Pass Filter, in [rad/s].'; 
        s.OmegaR_filtered = max(  s.OmegaR_filteredLPF1 , min(s.OmegaR_op) ) ;

        who.Vews_op = 'Effective Wind Speed ​​at the operating point estimated by a State Observer and filtered by a 1st Order Low-Pass Filter, in [m/s].';
        if it == 0
            s.InputsLPF3_filtered_set = s.V_meanHub_0 ;
        end
        s.CutFreq_LPF3_set = s.CutFreq_DriveTrain ;
        s.Ts_LPF3_set = s.Sample_Rate_c ;
        s.InputsLPF3_unfiltered_set = s.Vews_est ;
        PIGainScheduledTSR_Abbas2022('logical_instance_06');
        %
        if any(isnan(s.OutputsLPF3_filtered), 'all') || any(isinf(s.OutputsLPF3_filtered), 'all')
            s.OutputsLPF3_filtered = max( s.Vews_est , min(s.Vop) ) ;
        end
        %        
        s.InputsLPF3_filtered_set = s.OutputsLPF3_filtered ;
        s.Vews_est_filteredLPF3 = s.OutputsLPF3_filtered ;
        s.Vews_op = max(  s.Vews_est_filteredLPF3 , min(s.Vop) ) ;
        %
    end
    s.OmegaR_filtered = s.OmegaR;



    %####### Tower-Top and Plataforms Dynamics Signals #######   

    % ------- Selection of Tower-Top Dynamics Signals ----------
    s.Xt_filtered = s.Xt_est ;
    s.Xt_dot_filtered = s.Xt_dot_est ;
    s.Xt_Ddot_filtered = s.Xt_Ddot_est ;

    if s.Option02f2 > 1
        % Offshore wind turbine 
        s.Surge_filtered = s.Surge_est ;
        s.Surge_dot_filtered = s.Surge_dot_est ;            
        s.Surge_Ddot_filtered = s.Surge_Ddot_est ;    
        s.Sway_filtered = s.Sway_est ;  
        s.Sway_dot_filtered = s.Sway_dot_est ; 
        s.Sway_Ddot_filtered = s.Sway_Ddot_est ;    
        s.Heave_filtered = s.Heave_est ;
        s.Heave_dot_filtered = s.Heave_dot_est ;
        s.Heave_Ddot_filtered = s.Heave_Ddot_est ;   
        s.RollAngle_filtered = s.RollAngle_est ;  
        s.RollAngle_dot_filtered = s.RollAngle_dot_est ;              
        s.RollAngle_Ddot_filtered = s.RollAngle_Ddot_est ;  
        s.PitchAngle_filtered = s.PitchAngle_est ;   
        s.PitchAngle_dot_filtered = s.PitchAngle_dot_est ;  
        s.PitchAngle_Ddot_filtered = s.PitchAngle_Ddot_est ;   
        s.YawAngle_filtered = s.YawAngle_est ; 
        s.YawAngle_dot_filtered = s.YawAngle_dot_est ; 
        s.YawAngle_Ddot_filtered = s.YawAngle_Ddot_est ;    
        %
    end



    % ------------- Controller Modules ------------
    if ( s.Beta_filtered > s.BetaMode_Enable ) 
        % Enable Blade Pitch Controller
        s.Mode_GeneratorController(2) = 0;
        s.Mode_BladePitchController(2) = 1; 
        %
    else
        if (s.Vews_op >= s.Vws_Rated )
            % Enable Blade Pitch Controller
            s.Mode_GeneratorController(2) = 0;
            s.Mode_BladePitchController(2) = 1;
        else
            s.Mode_GeneratorController(2) = 1;
            s.Mode_BladePitchController(2) = 0; 
        end
    end


    % ----- Partial Derivatives of Fa and Ta at the Operating Point ----- 
    s.GradTaVop_dop = interp1(s.Vop, s.GradTaVop_op, s.Vews_op);
    s.GradTaOmega_dopRated = interp1(s.Vop, s.GradTaOmega_op, s.Vws_Rated);       
    s.GradTaOmega_dop = interp1(s.Vop, s.GradTaOmega_op, s.Vews_op);
    s.GradTaBeta_dop = interp1(s.Vop, s.GradTaBeta_op, s.Vews_op) ;
    s.GradTaBeta_dop( s.GradTaBeta_dop == 0) = -0.0001;
    s.GradPaBeta_dop = interp1(s.Vop, s.GradPaBeta_op, s.Vews_op);
    s.GradFaOmega_dop = interp1(s.Vop, s.GradFaOmega_op, s.Vews_op);
    s.GradFaVop_dop = interp1(s.Vop, s.GradFaVop_op, s.Vews_op);
    s.GradFaBeta_dop = interp1(s.Vop, s.GradFaBeta_op, s.Vews_op); 


    % ----- Stability Analysis and Gain Adjustments at Current Operating Point ----
    who.OmegaN_Tg  = 'Desired Natural Vibration Frequency for Generator Torque Controller.';
    s.OmegaN_Tg = interp1(s.Vop, s.OmegaNTg_Tab, s.Vews_op);
    who.DampingCFactor_Tg  = 'Desired Critical Damping Factor for Generator Torque Controller.';
    s.DampingCFactor_Tg = interp1(s.Vop, s.DampingCFactorTg_Tab, s.Vews_op);  

    who.OmegaN_Beta  = 'Desired Natural Vibration Frequency for Collective Blade Pitch Controller.';
    s.OmegaN_Beta = interp1(s.Vop, s.OmegaNBeta_Tab, s.Vews_op);  
    who.DampingCFactor_Beta  = 'Desired Critical Damping Factor for Collective Blade Pitch Controller.';
    s.DampingCFactor_Beta = interp1(s.Vop, s.DampingCFactorBeta_Tab, s.Vews_op);


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
    PIGainScheduledTSR_Abbas2022('logical_instance_08');


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
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
    PIGainScheduledTSR_Abbas2022('logical_instance_09');   

    

elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
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
    if s.Option01f8 == 1
        % STRATEGY 1 (Figure 2 from Abbas, 2022)
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
    if s.Option01f8 == 1
        % STRATEGY 1 (Figure 2 from Abbas, 2022)
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
    PIGainScheduledTSR_Abbas2022('logical_instance_10');


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % WIND TURBINE REFERENCE SPEED DEFINITION (ONLINE):    
    % Purpose of this Logical Instance: set the reference speeds for the
    % generator torque and collective blade pitch controllers.


    % ----- Optimum Rotor Speed, in [rad/s] -----
    who.OmegaR_opt = 'Generator Torque Controller Reference Speed, in [rad/s]';
    s.OmegaR_opt = ((s.Lambda_opt .* s.Vews_op)./s.Rrd) ;


    % ----- Set Generator Torque Controller Reference Speed -----
    who.OmegaRef_Tg = 'Generator Torque Controller Reference Speed, in [rad/s]';
    if s.Option06f8 == 1
        % SWITCH BETWEEN CONTROLLERS
        s.OmegaRef_Tg = interp1(s.Vop, s.OmegaR_op , s.Vews_op);
    else
        % SET POINT SMOOTHING (by Abbas 2022)
        s.OmegaRef_Tg = min( max( s.OmegaR_opt ,  min(s.OmegaR_op) ), max(s.OmegaR_op) ) ;
    end


    % ----- Set Collective Blade Pitch Controller Reference Speed -----
    who.OmegaRef_Beta = 'Collective Blade Pitch Controller Reference Speed, in [rad/s]';
    if s.Option06f8 == 1
        % SWITCH BETWEEN CONTROLLERS
        s.OmegaRef_Beta = interp1(s.Vop, s.OmegaR_op , s.Vews_op);
    else
        % SET POINT SMOOTHING (by Abbas 2022)
        s.OmegaRef_Beta = s.OmegaR_Rated ;
    end


    % ----- Set Controller Tracking Reference Speed -----
    who.OmegaRef = 'Controller Tracking Reference Speed, in [rad/s]';
    if (s.Mode_BladePitchController(2) == 1)
        % Collective Blade Pitch Controller is active
        s.OmegaRef = s.OmegaRef_Beta ;
    else
        % Generator Torque Controller is active
        s.OmegaRef = s.OmegaRef_Tg ;        
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    if s.Option06f8 == 2
        % SET POINT SMOOTHING (by Abbas 2022)
        PIGainScheduledTSR_Abbas2022('logical_instance_11');   
    else
        % SWITCH BETWEEN CONTROLLERS
        PIGainScheduledTSR_Abbas2022('logical_instance_12'); 
    end

    
elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % SET POINT SMOOTHING (ONLINE):    
    % Purpose of this Logical Instance: set the reference speeds for the 
    % generator torque and collective blade pitch controllers, with a 
    % Smooth Approach.


    % ---------- Normalized Blade Pitch variation (DeltaBeta) ----------
    who.BetaSmoother_max = 'Maximum Collective Blade Pitch set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
    s.BetaSmoother_max = interp1(s.Vop, s.Beta_op, s.Vws_CutOut); % s.Beta_max *(pi/180)
    who.BetaSmoother_min  = 'Minimum Collective Blade Pitch set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
    s.BetaSmoother_min = s.BetaMin_setup ; % s.BetaMin_setup *(pi/180) OR s.BetaMin_setup
    who.Beta_Smoother = 'Collective Blade Pitch set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';  
    s.Beta_Smoother = s.Beta_d_before ; % s.Beta_d_before *(pi/180) OR .Beta_d_before
    who.DeltaBeta_Smoother = 'Normalized Blade Pitch variation. Value used in equation 48 Abbas (2022).';
    s.DeltaBeta_Smoother = ( s.Beta_Smoother - s.BetaSmoother_min ) / s.BetaSmoother_max ;


    % ---------- Normalized Generator Torque variation (DeltaTg) ----------
    who.TgSmoother_max = 'Maximum Generator Torque set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
    s.TgSmoother_max = s.TgMax_setup ; % OR s.Tg_dMax
    who.Tg_Smoother = 'Generator Torque set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
    s.Tg_Smoother = s.Tg_d_before; %  s.Tg_d_before OR s.Tg_measured
    who.DeltaTg_Smoother  = 'Normalized Generator Torque variation. Value used in equation 48 Abbas (2022).';
    s.DeltaTg_Smoother = ( s.TgSmoother_max - s.Tg_Smoother ) / s.TgSmoother_max ;



    % ---------- Normalized Generator Power variation (DeltaPe) ----------
    if s.Option07f8 == 2
                % Compute Delta_Omega (Set point Smooth) with ROSCO tools. Uses the Generator Power demand (Pe_d)
        who.PeSmoother_max = 'Maximum Generator Power set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
        s.PeSmoother_max = (s.TgMax_setup*s.OmegaR_Rated) * s.etaElec_op ;
        who.Pe_Smoother = 'Generator Power set point smoothing, in [rad]. Value used in equation 48 Abbas (2022).';
        s.Pe_Smoother = s.Pe_d_before; % s.Pe_d_before OR s.Pe_measured
        who.DeltaPe_Smoother  = 'Normalized Generator Power variation. Value used in equation 48 Abbas (2022).';
        s.DeltaPe_Smoother = ( s.PeSmoother_max - s.Pe_Smoother ) / s.PeSmoother_max ; 
        %
    end


    % ----------- Offset to the Rotor Speed Set Point -----------
    who.Delta_Omega = 'Offset to the rotor speed set point or Variation of the Rotor Reference Speed, used in Set Point Smoothing strategy.';
    if s.Option07f8 == 2
            % Compute Delta_Omega (Set point Smooth) with ROSCO tools. Uses the Generator Power demand (Pe_d)
        s.Delta_Omega = s.DeltaBeta_Smoother*s.Kvs - s.DeltaPe_Smoother*s.Kpc;
    else
            % Compute Delta_Omega (Set point Smooth) with Equation 48 Abbas (2022). Uses the Generator Torque demand (Tg_d).
        s.Delta_Omega = s.DeltaBeta_Smoother*s.Kvs - s.DeltaTg_Smoother*s.Kpc;
    end
    s.Delta_Omega = s.Delta_Omega*s.OmegaR_Rated ;



             %###### LOW-PASS FILTER 1ª ORDER (LPF3) ###### 

    if (s.Option08f8 == 1)

        % ------- Low-Pass Filter 1ª Ordem (LPF3) -------
        if it == 1
            s.InputsLPF3_filtered_set = 0 ;
            s.CutFreq_LPF3_set = s.CutFreq_DriveTrain ;
            s.Ts_LPF3_set = s.Sample_Rate_c ;   
        end        
        s.InputsLPF3_unfiltered_set = s.Delta_Omega ; 
        PIGainScheduledTSR_Abbas2022('logical_instance_06');
        %
        if any(isnan(s.OutputsLPF3_filtered), 'all') || any(isinf(s.OutputsLPF3_filtered), 'all')
            s.OutputsLPF3_filtered = s.Delta_Omega ;
        end
        s.InputsLPF3_filtered_set = s.OutputsLPF3_filtered ;
        s.Delta_Omega_filteredLPF3 = s.OutputsLPF3_filtered ;
        %
    end
    
    % Use the UNFILTERED "DeltaOmega" IF
    if (s.Delta_Omega == 0)
        s.Delta_Omega_filteredLPF3 = s.Delta_Omega ;
    end



             %###### SET POINT SMOOTHING OUTPUT ###### 

    % ----------------- Set Point Smoothing  ----------------------
    if s.Delta_Omega_filteredLPF3 >= 0
        s.OmegaRef_Tg = s.OmegaRef_Tg - s.Delta_Omega_filteredLPF3 ;
        s.OmegaRef_Beta = s.OmegaRef_Beta;
    else
        s.OmegaRef_Tg = s.OmegaRef_Tg;
        s.OmegaRef_Beta = s.OmegaRef_Beta - s.Delta_Omega_filteredLPF3 ;
    end


    % ----- Update Set Controller Tracking Reference Speed -----
    who.OmegaRef = 'Controller Tracking Reference Speed, in [rad/s]';
    if (s.Mode_BladePitchController(2) == 1)
        % Collective Blade Pitch Controller is active
        s.OmegaRef = s.OmegaRef_Beta ;
    else
        % Generator Torque Controller is active
        s.OmegaRef = s.OmegaRef_Tg ;        
    end

    % -------------- Shutdown Strategy --------------
    if s.Vews_op >= s.Vws_CutOut
        s.OmegaRef_Tg = interp1(s.Vop, s.OmegaR_op, s.Vews_op);
        s.OmegaRef_Beta = interp1(s.Vop, s.OmegaR_op, s.Vews_op);
        %
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    PIGainScheduledTSR_Abbas2022('logical_instance_12');   


elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
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

    if (s.Option06f8 == 1) && (s.Mode_BladePitchController(2) == 0) 
        % SWITCH BETWEEN CONTROLLERS
        s.dBeta_max = 0 ;
        s.dBeta_min = 0 ;
    end


    % ------- Collective Blade Pitch Controller Tracking Error  ----------
    who.ErroTracking_Betad = 'Collective Blade Pitch Controller Tracking Error.';
    s.ErroTracking_Betad = ( s.OmegaRef_Beta  - s.OmegaR_filtered );  


    % ------- Collective Blade Pitch Controller Gains  ----------
    s.AA_Beta = ( (s.GradTaOmega_dop - s.CCdt)/s.J_t);
    s.BB_Beta = (s.GradTaBeta_dop/s.J_t);     
    who.Kp_piBeta = 'Collective Blade Pitch Controller Proportional (PI) Gain';
    s.Kp_piBeta = ((2*s.DampingCFactor_Beta*s.OmegaN_Beta + s.AA_Beta)/s.BB_Beta);  
    who.Ki_piBeta = 'Collective Blade Pitch Controller (PI) Integrative Gain.';
    s.Ki_piBeta = (s.OmegaN_Beta^2/s.BB_Beta);      
     

    % ----- Proportional–Integral (PI) Collective Blade Pitch Controller -----
    who.PropTermPI_Beta = 'Collective Blade Pitch Controller (PI) proportional term.';
    s.PropTermPI_Beta = s.Kp_piBeta * s.ErroTracking_Betad ;

    who.IntegTermPI_Beta = 'Collective Blade Pitch Controller (PI) integrative term..';    
    s.IntegTermPI_Beta = s.IntegTermPI_Beta + s.ErroTracking_Betad*s.Sample_Rate_c ; 


    % --- Strategy to improve the operation near the nominal point ---    
    if (s.Option06f8 == 1) || any(isnan(s.IntegTermPI_Beta), 'all') || any(isinf(s.IntegTermPI_Beta), 'all')
        % SWITCH BETWEEN CONTROLLERS  
        s.IntegTermPI_Beta = min(max(  s.IntegTermPI_Beta , (s.dBeta_min/abs(s.Ki_piBeta)) ) ,  (s.dBeta_max/abs(s.Ki_piBeta)) );     
        %
    end
    
    if  (s.Mode_BladePitchController(1) == 1) && (s.Mode_BladePitchController(2) == 0)
        % The controller has changed (it was previously in Active Mode and is now in Saturated Mode).
        s.IntegTermPI_Beta =  0 ;
        %
    end   

    if ( s.Vews_op >= s.Vop_BetaVar ) && ( s.Vews_op <= s.Vws_Rated_end ) && (s.Beta_filtered <= (s.BetaMax_nominal + 0.3408)  ) 
        s.IntegTermPI_Beta =  0 ;
        s.PropTermPI_Beta = 0 ;  
        %     
    end

     
    % ----- Current variation of the Collective Blade Pitch at the Operating Point -----
    who.dBeta = 'Collective Blade Pitch Variation at Operating Point, in [N.m].';   
    s.dBeta = s.PropTermPI_Beta + s.Ki_piBeta*s.IntegTermPI_Beta + s.PropTerm_CS_Feedback ;    

    if (s.Option06f8 == 1) 
        % SWITCH BETWEEN CONTROLLERS
        s.dBeta  = min(max(  s.dBeta , s.dBeta_min ),  s.dBeta_max  );
    end    


    % ------- Collective Blade Pitch based on PI control law  ----------    
    who.Beta_d = 'Desired Collective Blade Pitch, in [N.m].';
    s.Beta_d = s.Betad_op + s.dBeta ;    

    % ------- Amplitude Saturation atresult = [s.Vews_op;s.Delta_Omega;s.dBeta] the Controller Output  ----------   
    who.Beta_d = 'Desired Collective Blade Pitch, in [N.m].';  
    s.Beta_d = min(max(  s.Beta_d , s.BetaMin_setup ),  s.BetaMax_setup );  


    % ---------------- Shutdown --------------------- 
    if s.Vews_op >= s.Vws_CutOut 
        if s.Option09f8 == 2
            s.Beta_d = min( (s.Beta_d_before + s.BetaDot_max ), max(s.Betad_op) ) ; 
        else
            s.Beta_d = s.Betad_op ;
        end
    end  


    % ------------ Starting----------------------------
    if s.Vews_op < s.Vws_CutIn
        s.Beta_d = s.BetaMin_setup ;
    end


    % ------- Rate Saturation at the Controller Output  ---------- 
    who.Beta_d = 'Desired Collective Blade Pitch, in [N.m].';    
    s.Beta_dDot = min(max(  ((s.Beta_d - s.Beta_d_before)/s.Sample_Rate_c) , (- s.Beta_d_RateLimit) ),  (s.Beta_d_RateLimit) );
    s.Beta_d = s.Beta_d_before + (s.Beta_dDot*s.Sample_Rate_c);

    % if (s.Option01f3 == 2) || (s.Option01f3 == 3)
    %     % Consider the Blade Pitch dynamics
    %     s.Beta_dDot = min(max(  ((s.Beta_d - s.Beta_filtered)/s.tau_Beta) , (- s.Beta_d_RateLimit) ),  (s.Beta_d_RateLimit) );
    %     s.Beta_d = s.Beta_filtered + (s.Beta_dDot*s.tau_Beta);    
    % end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance  
    PIGainScheduledTSR_Abbas2022('logical_instance_13');   



elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
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
 
    if (s.Option06f8 == 1) && (s.Mode_GeneratorController(2) == 0) 
        % SWITCH BETWEEN CONTROLLERS
        s.dTg_max = 0 ;
        s.dTg_min = 0 ;
    end


    % ------- Generator Torque Controller Tracking Error  ----------
    who.ErroTracking_Tgd = 'Generator Torque Controller Tracking Error.';
    s.ErroTracking_Tgd = ( s.OmegaRef_Tg - s.OmegaR_filtered );    


    % ------- Generator Torque Controller Gains  ----------
    s.AA_Tg = ( (s.GradTaOmega_dop - s.CCdt)/s.J_t); 
    s.BB_Tg = - (1/s.J_t);      
    who.Kp_piTg = 'Generator Torque Controller Proportional (PI) Gain';
    s.Kp_piTg = ((2*s.DampingCFactor_Tg*s.OmegaN_Tg + s.AA_Tg)/s.BB_Tg);  
    who.Ki_piTg = 'Generator Torque Controller (PI) Integrative Gain.';
    s.Ki_piTg = (s.OmegaN_Tg^2/s.BB_Tg);      
    

    % ----- Proportional–Integral (PI) Generator Torque Controller -----
    who.PropTermPI_Tg = 'Generator Torque Controller (PI) proportional term.';
    s.PropTermPI_Tg = s.Kp_piTg * s.ErroTracking_Tgd ; 

    who.IntegTermPI_Tg = 'Generator Torque Controller (PI) integrative term..';
    s.IntegTermPI_Tg = s.IntegTermPI_Tg + s.ErroTracking_Tgd*s.Sample_Rate_c ;
     

    % --- Strategy to improve the operation near the nominal point ---    
    if s.Option06f8 == 1 || any(isnan(s.IntegTermPI_Tg), 'all') || any(isinf(s.IntegTermPI_Tg), 'all')
        % SWITCH BETWEEN CONTROLLERS
        s.IntegTermPI_Tg = min(max(  s.IntegTermPI_Tg , (s.dTg_min/abs(s.Ki_piTg)) ) ,  (s.dTg_max/abs(s.Ki_piTg)) );  
        %
    end

    if (s.Mode_GeneratorController(1) == 1) && (s.Mode_GeneratorController(2) == 0)
        % The controller has changed (it was previously in Active Mode and is now in Saturated Mode).
        s.IntegTermPI_Beta =  0 ;
        %
    end  

    if ( s.Mode_GeneratorController(2) == 0 ) && ( s.Vews_op >= s.Vop_TgMode_Saturation )
        % Note: Strategy to mitigate conflict between controllers and
        % ensure saturation of the generator torque controller, according
        % to sections "8.3.2 Control of variable-speed pitch-regulated
        % turbines" and "8.3.4 Switching between torque and pitch control"
        % of the book Wind Energy Handbook by Burton, Sharpe, Jenkins and 
        % Bossanyi (2001). This strategy is applied any control strategy, 
        % STRATEGY 1 (Figure 2 of Abbas, 2022) or in STRATEGY 2 (Peak Shaving).

        s.Tgd_New_op = 1.6*s.Tgd_op ;
        %
    else
        s.Tgd_New_op = s.Tgd_op ;              
    end


    % ----- Current variation of the Generator Torque at the Operating Point -----
    who.dTg = 'Generator Torque Variation at Operating Point, in [N.m].'; 
    s.dTg = s.PropTermPI_Tg + s.Ki_piTg*s.IntegTermPI_Tg ; 
     
    if (s.Option06f8 == 1) 
        % SWITCH BETWEEN CONTROLLERS
        s.dTg  = min(max(  s.dTg , s.dTg_min ),  s.dTg_max );
    end


    % ------- Generator Torque based on PI control law  ----------    
    who.Tg_d = 'Desired Generator Torque, in [N.m].'; 
    s.Tg_d = s.Tgd_New_op + s.dTg ;


    % ------- Amplitude Saturation at the Controller Output  ----------  
    who.Tg_d = 'Desired Generator Torque, in [N.m].';       
    s.Tg_d = min(max(  s.Tg_d , s.TgMin_setup ),  s.TgMax_setup );     


    % ------------ Shutdown and Starting----------------------------
    if s.Vews_op >= s.Vws_CutOut || s.Vews_op < s.Vws_CutIn
        s.Tg_d = s.Tgd_op;
    end


    % ------- Rate Saturation at the Controller Output  ----------  
    who.Tg_d = 'Desired Generator Torque, in [N.m].';
    s.Tg_dDot = min(max(  ((s.Tg_d - s.Tg_d_before)/s.Sample_Rate_c) , -s.Tg_d_RateLimit ),  s.Tg_d_RateLimit );
    s.Tg_d = s.Tg_d_before + (s.Tg_dDot*s.Sample_Rate_c);


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_14')
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves current controller values, 
    % based on the last sampling.

    % Organizing output results


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
        s.Tg_filtered_before = s.Tg_filtered ;
    end
    s.Pe_d_before = (s.Tg_d / s.eta_gb) * s.OmegaG_filtered * s.etaElec_op;
    s.Pe_filtered_before = s.Pe_filtered ;



    % ---------- LOGICAL INSTANCE 03  ----------
    if it == 1
        GeneratorTorqueController.OmegaR_measured = s.OmegaR_measured; GeneratorTorqueController.OmegaG_measured = s.OmegaG_measured; GeneratorTorqueController.Beta_measured = s.Beta_measured; GeneratorTorqueController.Tg_measured = s.Tg_measured; GeneratorTorqueController.Pe_measured = s.Pe_measured; GeneratorTorqueController.WindSpedd_hub_measured = s.WindSpedd_hub_measured;
        BladePitchController.OmegaR_measured = s.OmegaR_measured; BladePitchController.OmegaG_measured = s.OmegaG_measured; BladePitchController.Beta_measured = s.Beta_measured; BladePitchController.Tg_measured = s.Tg_measured; BladePitchController.Pe_measured = s.Pe_measured; BladePitchController.WindSpedd_hub_measured = s.WindSpedd_hub_measured;    
        PIGainScheduledTSR.OmegaR_measured = s.OmegaR_measured; PIGainScheduledTSR.OmegaG_measured = s.OmegaG_measured; PIGainScheduledTSR.Beta_measured = s.Beta_measured; PIGainScheduledTSR.Tg_measured = s.Tg_measured; PIGainScheduledTSR.Pe_measured = s.Pe_measured; PIGainScheduledTSR.WindSpedd_hub_measured = s.WindSpedd_hub_measured;    
        PIGainScheduledTSR.Xt_measured = s.Xt_measured; GeneratorTorqueController.Xt_measured = s.Xt_measured; BladePitchController.Xt_measured = s.Xt_measured; 
        PIGainScheduledTSR.Xt_dot_measured = s.Xt_dot_measured; GeneratorTorqueController.Xt_dot_measured = s.Xt_dot_measured; BladePitchController.Xt_dot_measured = s.Xt_dot_measured;        
        PIGainScheduledTSR.Xt_Ddot_measured = s.Xt_Ddot_measured; GeneratorTorqueController.Xt_Ddot_measured = s.Xt_Ddot_measured; BladePitchController.Xt_Ddot_measured = s.Xt_Ddot_measured;
        if s.Option02f2 > 1
            % Offshore wind turbine
            GeneratorTorqueController.Surge_measured = s.Surge_measured; BladePitchController.Surge_measured = s.Surge_measured; PIGainScheduledTSR.Surge_measured = s.Surge_measured;            
            GeneratorTorqueController.Surge_dot_measured = s.Surge_dot_measured; BladePitchController.Surge_dot_measured = s.Surge_dot_measured; PIGainScheduledTSR.Surge_dot_measured = s.Surge_dot_measured;
            GeneratorTorqueController.Surge_Ddot_measured = s.Surge_Ddot_measured; BladePitchController.Surge_Ddot_measured = s.Surge_Ddot_measured; PIGainScheduledTSR.Surge_Ddot_measured = s.Surge_Ddot_measured;            
            GeneratorTorqueController.Sway_measured = s.Sway_measured; BladePitchController.Sway_measured = s.Sway_measured; PIGainScheduledTSR.Sway_measured = s.Sway_measured;  
            GeneratorTorqueController.Sway_dot_measured = s.Sway_dot_measured; BladePitchController.Sway_dot_measured = s.Sway_dot_measured; PIGainScheduledTSR.Sway_dot_measured = s.Sway_dot_measured;              
            GeneratorTorqueController.Sway_Ddot_measured = s.Sway_Ddot_measured; BladePitchController.Sway_Ddot_measured = s.Sway_Ddot_measured; PIGainScheduledTSR.Sway_Ddot_measured = s.Sway_Ddot_measured;      
            GeneratorTorqueController.Heave_measured = s.Heave_measured; BladePitchController.Heave_measured = s.Heave_measured; PIGainScheduledTSR.Heave_measured = s.Heave_measured;
            GeneratorTorqueController.Heave_dot_measured = s.Heave_dot_measured; BladePitchController.Heave_dot_measured = s.Heave_dot_measured; PIGainScheduledTSR.Heave_dot_measured = s.Heave_dot_measured;            
            GeneratorTorqueController.Heave_Ddot_measured = s.Heave_Ddot_measured; BladePitchController.Heave_Ddot_measured = s.Heave_Ddot_measured; PIGainScheduledTSR.Heave_Ddot_measured = s.Heave_Ddot_measured;
            GeneratorTorqueController.RollAngle_measured = s.RollAngle_measured; BladePitchController.RollAngle_measured = s.RollAngle_measured; PIGainScheduledTSR.RollAngle_measured = s.RollAngle_measured;           
            GeneratorTorqueController.RollAngle_dot_measured = s.RollAngle_dot_measured; BladePitchController.RollAngle_dot_measured = s.RollAngle_dot_measured; PIGainScheduledTSR.RollAngle_dot_measured = s.RollAngle_dot_measured; 
            GeneratorTorqueController.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured; BladePitchController.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured; PIGainScheduledTSR.RollAngle_Ddot_measured = s.RollAngle_Ddot_measured;    
            GeneratorTorqueController.PitchAngle_measured = s.PitchAngle_measured; BladePitchController.PitchAngle_measured = s.PitchAngle_measured; PIGainScheduledTSR.PitchAngle_measured = s.PitchAngle_measured;
            GeneratorTorqueController.PitchAngle_dot_measured = s.PitchAngle_dot_measured; BladePitchController.PitchAngle_dot_measured = s.PitchAngle_dot_measured; PIGainScheduledTSR.PitchAngle_dot_measured = s.PitchAngle_dot_measured;
            GeneratorTorqueController.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured; BladePitchController.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured; PIGainScheduledTSR.PitchAngle_Ddot_measured = s.PitchAngle_Ddot_measured;            
            GeneratorTorqueController.YawAngle_measured = s.YawAngle_measured; BladePitchController.YawAngle_measured = s.YawAngle_measured; PIGainScheduledTSR.YawAngle_measured = s.YawAngle_measured;        
            GeneratorTorqueController.YawAngle_dot_measured = s.YawAngle_dot_measured; BladePitchController.YawAngle_dot_measured = s.YawAngle_dot_measured; PIGainScheduledTSR.YawAngle_dot_measured = s.YawAngle_dot_measured;            
            GeneratorTorqueController.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured; BladePitchController.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured; PIGainScheduledTSR.YawAngle_Ddot_measured = s.YawAngle_Ddot_measured;

        end
        %
    else
        GeneratorTorqueController.OmegaR_measured = [GeneratorTorqueController.OmegaR_measured;s.OmegaR_measured]; GeneratorTorqueController.OmegaG_measured = [GeneratorTorqueController.OmegaG_measured;s.OmegaG_measured]; GeneratorTorqueController.Beta_measured = [GeneratorTorqueController.Beta_measured;s.Beta_measured]; GeneratorTorqueController.Tg_measured = [GeneratorTorqueController.Tg_measured;s.Tg_measured]; GeneratorTorqueController.Pe_measured = [GeneratorTorqueController.Pe_measured;s.Pe_measured]; GeneratorTorqueController.WindSpedd_hub_measured = [GeneratorTorqueController.WindSpedd_hub_measured;s.WindSpedd_hub_measured];
        BladePitchController.OmegaR_measured = [BladePitchController.OmegaR_measured;s.OmegaR_measured]; BladePitchController.OmegaG_measured = [BladePitchController.OmegaG_measured;s.OmegaG_measured]; BladePitchController.Beta_measured = [BladePitchController.Beta_measured;s.Beta_measured]; BladePitchController.Tg_measured = [BladePitchController.Tg_measured;s.Tg_measured]; BladePitchController.Pe_measured = [BladePitchController.Pe_measured;s.Pe_measured]; BladePitchController.WindSpedd_hub_measured = [BladePitchController.WindSpedd_hub_measured;s.WindSpedd_hub_measured];    
        PIGainScheduledTSR.OmegaR_measured = [PIGainScheduledTSR.OmegaR_measured;s.OmegaR_measured]; PIGainScheduledTSR.OmegaG_measured = [PIGainScheduledTSR.OmegaG_measured;s.OmegaG_measured]; PIGainScheduledTSR.Beta_measured = [PIGainScheduledTSR.Beta_measured;s.Beta_measured]; PIGainScheduledTSR.Tg_measured = [PIGainScheduledTSR.Tg_measured;s.Tg_measured]; PIGainScheduledTSR.Pe_measured = [PIGainScheduledTSR.Pe_measured;s.Pe_measured]; PIGainScheduledTSR.WindSpedd_hub_measured = [PIGainScheduledTSR.WindSpedd_hub_measured;s.WindSpedd_hub_measured];    
        PIGainScheduledTSR.Xt_measured = [PIGainScheduledTSR.Xt_measured;s.Xt_measured]; GeneratorTorqueController.Xt_measured = [GeneratorTorqueController.Xt_measured;s.Xt_measured]; BladePitchController.Xt_measured = [BladePitchController.Xt_measured;s.Xt_measured];
        PIGainScheduledTSR.Xt_dot_measured = [PIGainScheduledTSR.Xt_dot_measured;s.Xt_dot_measured]; GeneratorTorqueController.Xt_dot_measured = [GeneratorTorqueController.Xt_dot_measured;s.Xt_dot_measured]; BladePitchController.Xt_dot_measured = [BladePitchController.Xt_dot_measured;s.Xt_dot_measured];        
        PIGainScheduledTSR.Xt_Ddot_measured = [PIGainScheduledTSR.Xt_Ddot_measured;s.Xt_Ddot_measured]; GeneratorTorqueController.Xt_Ddot_measured = [GeneratorTorqueController.Xt_Ddot_measured;s.Xt_Ddot_measured]; BladePitchController.Xt_Ddot_measured = [BladePitchController.Xt_Ddot_measured;s.Xt_Ddot_measured];
        if s.Option02f2 > 1
            % Offshore wind turbine  
            GeneratorTorqueController.Surge_measured = [GeneratorTorqueController.Surge_measured;s.Surge_measured]; BladePitchController.Surge_measured = [BladePitchController.Surge_measured;s.Surge_measured]; PIGainScheduledTSR.Surge_measured = [PIGainScheduledTSR.Surge_measured;s.Surge_measured];
            GeneratorTorqueController.Surge_dot_measured = [GeneratorTorqueController.Surge_dot_measured;s.Surge_dot_measured]; BladePitchController.Surge_dot_measured = [BladePitchController.Surge_dot_measured;s.Surge_dot_measured]; PIGainScheduledTSR.Surge_dot_measured = [PIGainScheduledTSR.Surge_dot_measured;s.Surge_dot_measured];
            GeneratorTorqueController.Surge_Ddot_measured = [GeneratorTorqueController.Surge_Ddot_measured;s.Surge_Ddot_measured]; BladePitchController.Surge_Ddot_measured = [BladePitchController.Surge_Ddot_measured;s.Surge_Ddot_measured]; PIGainScheduledTSR.Surge_Ddot_measured = [PIGainScheduledTSR.Surge_Ddot_measured;s.Surge_Ddot_measured];
            GeneratorTorqueController.Sway_measured = [GeneratorTorqueController.Sway_measured;s.Sway_measured]; BladePitchController.Sway_measured = [BladePitchController.Sway_measured;s.Sway_measured]; PIGainScheduledTSR.Sway_measured = [PIGainScheduledTSR.Sway_measured;s.Sway_measured];
            GeneratorTorqueController.Sway_dot_measured = [GeneratorTorqueController.Sway_dot_measured;s.Sway_dot_measured]; BladePitchController.Sway_dot_measured = [BladePitchController.Sway_dot_measured;s.Sway_dot_measured]; PIGainScheduledTSR.Sway_dot_measured = [PIGainScheduledTSR.Sway_dot_measured;s.Sway_dot_measured];
            GeneratorTorqueController.Sway_Ddot_measured = [GeneratorTorqueController.Sway_Ddot_measured;s.Sway_Ddot_measured]; BladePitchController.Sway_Ddot_measured = [BladePitchController.Sway_Ddot_measured;s.Sway_Ddot_measured]; PIGainScheduledTSR.Sway_Ddot_measured = [PIGainScheduledTSR.Sway_Ddot_measured;s.Sway_Ddot_measured];
            GeneratorTorqueController.Heave_measured = [GeneratorTorqueController.Heave_measured;s.Heave_measured]; BladePitchController.Heave_measured = [BladePitchController.Heave_measured;s.Heave_measured]; PIGainScheduledTSR.Heave_measured = [PIGainScheduledTSR.Heave_measured;s.Heave_measured];
            GeneratorTorqueController.Heave_dot_measured = [GeneratorTorqueController.Heave_dot_measured;s.Heave_dot_measured]; BladePitchController.Heave_dot_measured = [BladePitchController.Heave_dot_measured;s.Heave_dot_measured]; PIGainScheduledTSR.Heave_dot_measured = [PIGainScheduledTSR.Heave_dot_measured;s.Heave_dot_measured];
            GeneratorTorqueController.Heave_Ddot_measured = [GeneratorTorqueController.Heave_Ddot_measured;s.Heave_Ddot_measured]; BladePitchController.Heave_Ddot_measured = [BladePitchController.Heave_Ddot_measured;s.Heave_Ddot_measured]; PIGainScheduledTSR.Heave_Ddot_measured = [PIGainScheduledTSR.Heave_Ddot_measured;s.Heave_Ddot_measured];
            GeneratorTorqueController.RollAngle_measured = [GeneratorTorqueController.RollAngle_measured;s.RollAngle_measured]; BladePitchController.RollAngle_measured = [BladePitchController.RollAngle_measured;s.RollAngle_measured]; PIGainScheduledTSR.RollAngle_measured = [PIGainScheduledTSR.RollAngle_measured;s.RollAngle_measured];
            GeneratorTorqueController.RollAngle_dot_measured = [GeneratorTorqueController.RollAngle_dot_measured;s.RollAngle_dot_measured]; BladePitchController.RollAngle_dot_measured = [BladePitchController.RollAngle_dot_measured;s.RollAngle_dot_measured]; PIGainScheduledTSR.RollAngle_dot_measured = [PIGainScheduledTSR.RollAngle_dot_measured;s.RollAngle_dot_measured];
            GeneratorTorqueController.RollAngle_Ddot_measured = [GeneratorTorqueController.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured]; BladePitchController.RollAngle_Ddot_measured = [BladePitchController.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured]; PIGainScheduledTSR.RollAngle_Ddot_measured = [PIGainScheduledTSR.RollAngle_Ddot_measured;s.RollAngle_Ddot_measured];
            GeneratorTorqueController.PitchAngle_measured = [GeneratorTorqueController.PitchAngle_measured;s.PitchAngle_measured]; BladePitchController.PitchAngle_measured = [BladePitchController.PitchAngle_measured;s.PitchAngle_measured]; PIGainScheduledTSR.PitchAngle_measured = [PIGainScheduledTSR.PitchAngle_measured;s.PitchAngle_measured];
            GeneratorTorqueController.PitchAngle_dot_measured = [GeneratorTorqueController.PitchAngle_dot_measured;s.PitchAngle_dot_measured]; BladePitchController.PitchAngle_dot_measured = [BladePitchController.PitchAngle_dot_measured;s.PitchAngle_dot_measured]; PIGainScheduledTSR.PitchAngle_dot_measured = [PIGainScheduledTSR.PitchAngle_dot_measured;s.PitchAngle_dot_measured];
            GeneratorTorqueController.PitchAngle_Ddot_measured = [GeneratorTorqueController.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured]; BladePitchController.PitchAngle_Ddot_measured = [BladePitchController.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured]; PIGainScheduledTSR.PitchAngle_Ddot_measured = [PIGainScheduledTSR.PitchAngle_Ddot_measured;s.PitchAngle_Ddot_measured];            
            GeneratorTorqueController.YawAngle_measured = [GeneratorTorqueController.YawAngle_measured;s.YawAngle_measured];  BladePitchController.YawAngle_measured = [BladePitchController.YawAngle_measured;s.YawAngle_measured]; PIGainScheduledTSR.YawAngle_measured = [PIGainScheduledTSR.YawAngle_measured;s.YawAngle_measured];  
            GeneratorTorqueController.YawAngle_dot_measured = [GeneratorTorqueController.YawAngle_dot_measured;s.YawAngle_dot_measured];  BladePitchController.YawAngle_dot_measured = [BladePitchController.YawAngle_dot_measured;s.YawAngle_dot_measured]; PIGainScheduledTSR.YawAngle_dot_measured = [PIGainScheduledTSR.YawAngle_dot_measured;s.YawAngle_dot_measured];   
            GeneratorTorqueController.YawAngle_Ddot_measured = [GeneratorTorqueController.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured];  BladePitchController.YawAngle_Ddot_measured = [BladePitchController.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured]; PIGainScheduledTSR.YawAngle_Ddot_measured = [PIGainScheduledTSR.YawAngle_Ddot_measured;s.YawAngle_Ddot_measured];             
        end
        %        
    end


    % ---------- LOGICAL INSTANCE 04  ----------
    PIGainScheduledTSR.InputsLPF1_unfiltered = s.InputsLPF1_unfiltered; PIGainScheduledTSR.InputsLPF1_unfiltered = s.InputsLPF1_unfiltered; PIGainScheduledTSR.CutFreq_LPF1 = s.CutFreq_LPF1; PIGainScheduledTSR.Ts_LPF1 = s.Ts_LPF1; PIGainScheduledTSR.alfa_LPF1 = s.alfa_LPF1; PIGainScheduledTSR.Ad_LPF1 = s.Ad_LPF1; PIGainScheduledTSR.Cd_LPF1 = s.Cd_LPF1; PIGainScheduledTSR.Dd_LPF1 = s.Dd_LPF1; PIGainScheduledTSR.OutputsLPF1_filtered = s.OutputsLPF1_filtered;

    if it == 1
        GeneratorTorqueController.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; BladePitchController.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; PIGainScheduledTSR.OmegaR_filteredLPF1 = s.OmegaR_filteredLPF1; 
        GeneratorTorqueController.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1; BladePitchController.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1; PIGainScheduledTSR.OmegaG_filteredLPF1 = s.OmegaG_filteredLPF1;     
        GeneratorTorqueController.Beta_filteredLPF1 = s.Beta_filteredLPF1; BladePitchController.Beta_filteredLPF1 = s.Beta_filteredLPF1; PIGainScheduledTSR.Beta_filteredLPF1 = s.Beta_filteredLPF1; 
        GeneratorTorqueController.Tg_filteredLPF1 = s.Tg_filteredLPF1; BladePitchController.Tg_filteredLPF1 = s.Tg_filteredLPF1; PIGainScheduledTSR.Tg_filteredLPF1 = s.Tg_filteredLPF1; 
        GeneratorTorqueController.Pe_filteredLPF1 = s.Pe_filteredLPF1; BladePitchController.Pe_filteredLPF1 = s.Pe_filteredLPF1; PIGainScheduledTSR.Pe_filteredLPF1 = s.Pe_filteredLPF1; 
        GeneratorTorqueController.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1; BladePitchController.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1; PIGainScheduledTSR.WindSpedd_hub_filteredLPF1 = s.WindSpedd_hub_filteredLPF1;        
        % GeneratorTorqueController.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3; BladePitchController.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3; PIGainScheduledTSR.Vews_est_filteredLPF1 = s.Vews_est_filteredLPF3;            
        %
    else
        GeneratorTorqueController.OmegaR_filteredLPF1 = [GeneratorTorqueController.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; BladePitchController.OmegaR_filteredLPF1 = [BladePitchController.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; PIGainScheduledTSR.OmegaR_filteredLPF1 = [PIGainScheduledTSR.OmegaR_filteredLPF1;s.OmegaR_filteredLPF1]; 
        GeneratorTorqueController.OmegaG_filteredLPF1 = [GeneratorTorqueController.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1]; BladePitchController.OmegaG_filteredLPF1 = [BladePitchController.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1]; PIGainScheduledTSR.OmegaG_filteredLPF1 = [PIGainScheduledTSR.OmegaG_filteredLPF1;s.OmegaG_filteredLPF1];     
        GeneratorTorqueController.Beta_filteredLPF1 = [GeneratorTorqueController.Beta_filteredLPF1;s.Beta_filteredLPF1]; BladePitchController.Beta_filteredLPF1 = [BladePitchController.Beta_filteredLPF1;s.Beta_filteredLPF1]; PIGainScheduledTSR.Beta_filteredLPF1 = [PIGainScheduledTSR.Beta_filteredLPF1;s.Beta_filteredLPF1]; 
        GeneratorTorqueController.Tg_filteredLPF1 = [GeneratorTorqueController.Tg_filteredLPF1;s.Tg_filteredLPF1]; BladePitchController.Tg_filteredLPF1 = [BladePitchController.Tg_filteredLPF1;s.Tg_filteredLPF1]; PIGainScheduledTSR.Tg_filteredLPF1 = [PIGainScheduledTSR.Tg_filteredLPF1;s.Tg_filteredLPF1]; 
        GeneratorTorqueController.Pe_filteredLPF1 = [GeneratorTorqueController.Pe_filteredLPF1;s.Pe_filteredLPF1]; BladePitchController.Pe_filteredLPF1 = [BladePitchController.Pe_filteredLPF1;s.Pe_filteredLPF1]; PIGainScheduledTSR.Pe_filteredLPF1 = [PIGainScheduledTSR.Pe_filteredLPF1;s.Pe_filteredLPF1];
        GeneratorTorqueController.WindSpedd_hub_filteredLPF1 = [GeneratorTorqueController.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1]; BladePitchController.WindSpedd_hub_filteredLPF1 = [BladePitchController.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1]; PIGainScheduledTSR.WindSpedd_hub_filteredLPF1 = [PIGainScheduledTSR.WindSpedd_hub_filteredLPF1;s.WindSpedd_hub_filteredLPF1];              
        % GeneratorTorqueController.Vews_est_filteredLPF1 = [GeneratorTorqueController.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; BladePitchController.Vews_est_filteredLPF1 = [BladePitchController.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; PIGainScheduledTSR.Vews_est_filteredLPF1 = [PIGainScheduledTSR.Vews_est_filteredLPF1;s.Vews_est_filteredLPF3]; 
        %
    end


    % ---------- LOGICAL INSTANCE 05  ----------
    if (s.Option02f2 > 1) || (s.Option04f3 == 1) 
        if (s.Option04f8 < 3)
            PIGainScheduledTSR.CutFreq_HighPass = s.CutFreq_HighPass; PIGainScheduledTSR.omega0_HighPass = s.omega0_HighPass; PIGainScheduledTSR.CutFreq_HighPass = s.K_HighPass; PIGainScheduledTSR.CutFreq_HighPass = s.alpha_HighPass; PIGainScheduledTSR.CutFreq_HighPass = s.a0_HighPass; PIGainScheduledTSR.a1_HighPass = s.a1_HighPass; PIGainScheduledTSR.b1_HighPass = s.b1_HighPass;    
            PIGainScheduledTSR.CutFreq_Notch = s.CutFreq_Notch; PIGainScheduledTSR.Damp_Notch = s.Damp_Notch; PIGainScheduledTSR.omega0_Notch = s.omega0_Notch; PIGainScheduledTSR.b2_Notch = s.b2_Notch; PIGainScheduledTSR.b0_Notch = s.b0_Notch; PIGainScheduledTSR.a2_Notch = s.a2_Notch; PIGainScheduledTSR.a1_Notch = s.a1_Notch; PIGainScheduledTSR.a0_Notch = s.a0_Notch;       

            if it == 1
                PIGainScheduledTSR.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered; GeneratorTorqueController.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered; BladePitchController.OutputsLPF2B_filtered = s.OutputsLPF2B_filtered;        
                PIGainScheduledTSR.InputsHPF1_filtered = s.InputsHPF1_filtered; PIGainScheduledTSR.InputsHPF1_unfiltered = s.InputsHPF1_unfiltered; PIGainScheduledTSR.OutputsHPF1_filtered = s.OutputsHPF1_filtered;
                PIGainScheduledTSR.Outputs_notched = s.Outputs_notched;            
                GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; BladePitchController.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; PIGainScheduledTSR.Xt_Ddot_LPF2Bfiltered = s.Xt_Ddot_LPF2Bfiltered; GeneratorTorqueController.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; BladePitchController.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; PIGainScheduledTSR.Xt_Ddot_filteredHPF1 = s.Xt_Ddot_filteredHPF1; GeneratorTorqueController.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; BladePitchController.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; PIGainScheduledTSR.Xt_Ddot_filteredNF = s.Xt_Ddot_filteredNF; 
                if s.Option02f2 > 1
                    % Offshore wind turbine 
                    GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; BladePitchController.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; PIGainScheduledTSR.Surge_Ddot_LPF2Bfiltered = s.Surge_Ddot_LPF2Bfiltered; GeneratorTorqueController.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; BladePitchController.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; PIGainScheduledTSR.Surge_Ddot_filteredHPF1 = s.Surge_Ddot_filteredHPF1; GeneratorTorqueController.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF; BladePitchController.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF; PIGainScheduledTSR.Surge_Ddot_filteredNF = s.Surge_Ddot_filteredNF;                        
                    GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; BladePitchController.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; PIGainScheduledTSR.Sway_Ddot_LPF2Bfiltered = s.Sway_Ddot_LPF2Bfiltered; GeneratorTorqueController.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; BladePitchController.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; PIGainScheduledTSR.Sway_Ddot_filteredHPF1 = s.Sway_Ddot_filteredHPF1; GeneratorTorqueController.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF; BladePitchController.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF; PIGainScheduledTSR.Sway_Ddot_filteredNF = s.Sway_Ddot_filteredNF;             
                    GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; BladePitchController.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; PIGainScheduledTSR.Heave_Ddot_LPF2Bfiltered = s.Heave_Ddot_LPF2Bfiltered; GeneratorTorqueController.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; BladePitchController.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; PIGainScheduledTSR.Heave_Ddot_filteredHPF1 = s.Heave_Ddot_filteredHPF1; GeneratorTorqueController.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF; BladePitchController.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF; PIGainScheduledTSR.Heave_Ddot_filteredNF = s.Heave_Ddot_filteredNF;                        
                    GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; BladePitchController.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; PIGainScheduledTSR.RollAngle_dot_LPF2Bfiltered = s.RollAngle_dot_LPF2Bfiltered; GeneratorTorqueController.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; BladePitchController.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; PIGainScheduledTSR.RollAngle_dot_filteredHPF1 = s.RollAngle_dot_filteredHPF1; GeneratorTorqueController.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF; BladePitchController.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF; PIGainScheduledTSR.RollAngle_dot_filteredNF = s.RollAngle_dot_filteredNF;                        
                    GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; BladePitchController.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; PIGainScheduledTSR.PitchAngle_dot_LPF2Bfiltered = s.PitchAngle_dot_LPF2Bfiltered; GeneratorTorqueController.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; BladePitchController.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; PIGainScheduledTSR.PitchAngle_dot_filteredHPF1 = s.PitchAngle_dot_filteredHPF1; GeneratorTorqueController.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF; BladePitchController.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF; PIGainScheduledTSR.PitchAngle_dot_filteredNF = s.PitchAngle_dot_filteredNF;            
                    GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; BladePitchController.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; PIGainScheduledTSR.YawAngle_dot_LPF2Bfiltered = s.YawAngle_dot_LPF2Bfiltered; GeneratorTorqueController.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; BladePitchController.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; PIGainScheduledTSR.YawAngle_dot_filteredHPF1 = s.YawAngle_dot_filteredHPF1; GeneratorTorqueController.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF; BladePitchController.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF; PIGainScheduledTSR.YawAngle_dot_filteredNF = s.YawAngle_dot_filteredNF;     
                end
                %
            else
                PIGainScheduledTSR.OutputsLPF2B_filtered = [PIGainScheduledTSR.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered]; GeneratorTorqueController.OutputsLPF2B_filtered = [GeneratorTorqueController.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered]; BladePitchController.OutputsLPF2B_filtered = [BladePitchController.OutputsLPF2B_filtered;s.OutputsLPF2B_filtered];
                PIGainScheduledTSR.InputsHPF1_filtered = [PIGainScheduledTSR.InputsHPF1_filtered;s.InputsHPF1_filtered]; PIGainScheduledTSR.InputsHPF1_unfiltered = [PIGainScheduledTSR.InputsHPF1_unfiltered;s.InputsHPF1_unfiltered]; PIGainScheduledTSR.OutputsHPF1_filtered = [PIGainScheduledTSR.OutputsHPF1_filtered;s.OutputsHPF1_filtered]; 
                PIGainScheduledTSR.Outputs_notched = [PIGainScheduledTSR.Outputs_notched;s.Outputs_notched];
                
                GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; BladePitchController.Xt_Ddot_LPF2Bfiltered = [BladePitchController.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; PIGainScheduledTSR.Xt_Ddot_LPF2Bfiltered = [PIGainScheduledTSR.Xt_Ddot_LPF2Bfiltered;s.Xt_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Xt_Ddot_filteredHPF1 = [GeneratorTorqueController.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; BladePitchController.Xt_Ddot_filteredHPF1 = [BladePitchController.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; PIGainScheduledTSR.Xt_Ddot_filteredHPF1 = [PIGainScheduledTSR.Xt_Ddot_filteredHPF1;s.Xt_Ddot_filteredHPF1]; GeneratorTorqueController.Xt_Ddot_filteredNF = [GeneratorTorqueController.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF]; BladePitchController.Xt_Ddot_filteredNF = [BladePitchController.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF]; PIGainScheduledTSR.Xt_Ddot_filteredNF = [PIGainScheduledTSR.Xt_Ddot_filteredNF;s.Xt_Ddot_filteredNF];         
                if s.Option02f2 > 1
                    % Offshore wind turbine 
                    GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; BladePitchController.Surge_Ddot_LPF2Bfiltered = [BladePitchController.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; PIGainScheduledTSR.Surge_Ddot_LPF2Bfiltered = [PIGainScheduledTSR.Surge_Ddot_LPF2Bfiltered;s.Surge_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Surge_Ddot_filteredHPF1 = [GeneratorTorqueController.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; BladePitchController.Surge_Ddot_filteredHPF1 = [BladePitchController.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; PIGainScheduledTSR.Surge_Ddot_filteredHPF1 = [PIGainScheduledTSR.Surge_Ddot_filteredHPF1;s.Surge_Ddot_filteredHPF1]; GeneratorTorqueController.Surge_Ddot_filteredNF = [GeneratorTorqueController.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF]; BladePitchController.Surge_Ddot_filteredNF = [BladePitchController.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF]; PIGainScheduledTSR.Surge_Ddot_filteredNF = [PIGainScheduledTSR.Surge_Ddot_filteredNF;s.Surge_Ddot_filteredNF];
                    GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; BladePitchController.Sway_Ddot_LPF2Bfiltered = [BladePitchController.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; PIGainScheduledTSR.Sway_Ddot_LPF2Bfiltered = [PIGainScheduledTSR.Sway_Ddot_LPF2Bfiltered;s.Sway_Ddot_LPF2Bfiltered]; GeneratorTorqueController.Sway_Ddot_filteredHPF1 = [GeneratorTorqueController.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; BladePitchController.Sway_Ddot_filteredHPF1 = [BladePitchController.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; PIGainScheduledTSR.Sway_Ddot_filteredHPF1 = [PIGainScheduledTSR.Sway_Ddot_filteredHPF1;s.Sway_Ddot_filteredHPF1]; GeneratorTorqueController.Sway_Ddot_filteredNF = [GeneratorTorqueController.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF]; BladePitchController.Sway_Ddot_filteredNF = [BladePitchController.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF]; PIGainScheduledTSR.Sway_Ddot_filteredNF = [PIGainScheduledTSR.Sway_Ddot_filteredNF;s.Sway_Ddot_filteredNF];             
                    GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered = [GeneratorTorqueController.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered]; BladePitchController.Heave_Ddot_LPF2Bfiltered = [BladePitchController.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered]; PIGainScheduledTSR.Heave_Ddot_LPF2Bfiltered = [PIGainScheduledTSR.Heave_Ddot_LPF2Bfiltered;s.Heave_Ddot_LPF2Bfiltered];
                    GeneratorTorqueController.Heave_Ddot_filteredHPF1 = [GeneratorTorqueController.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; BladePitchController.Heave_Ddot_filteredHPF1 = [BladePitchController.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; PIGainScheduledTSR.Heave_Ddot_filteredHPF1 = [PIGainScheduledTSR.Heave_Ddot_filteredHPF1;s.Heave_Ddot_filteredHPF1]; GeneratorTorqueController.Heave_Ddot_filteredNF = [GeneratorTorqueController.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF]; BladePitchController.Heave_Ddot_filteredNF = [BladePitchController.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF]; PIGainScheduledTSR.Heave_Ddot_filteredNF = [PIGainScheduledTSR.Heave_Ddot_filteredNF;s.Heave_Ddot_filteredNF];
                    GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered]; BladePitchController.RollAngle_dot_LPF2Bfiltered = [BladePitchController.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered]; PIGainScheduledTSR.RollAngle_dot_LPF2Bfiltered = [PIGainScheduledTSR.RollAngle_dot_LPF2Bfiltered;s.RollAngle_dot_LPF2Bfiltered];  GeneratorTorqueController.RollAngle_dot_filteredHPF1 = [GeneratorTorqueController.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1]; BladePitchController.RollAngle_dot_filteredHPF1 = [BladePitchController.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1];  PIGainScheduledTSR.RollAngle_dot_filteredHPF1 = [PIGainScheduledTSR.RollAngle_dot_filteredHPF1;s.RollAngle_dot_filteredHPF1]; GeneratorTorqueController.RollAngle_dot_filteredNF = [GeneratorTorqueController.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF]; BladePitchController.RollAngle_dot_filteredNF = [BladePitchController.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF]; PIGainScheduledTSR.RollAngle_dot_filteredNF = [PIGainScheduledTSR.RollAngle_dot_filteredNF;s.RollAngle_dot_filteredNF];                        
                    GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; BladePitchController.PitchAngle_dot_LPF2Bfiltered = [BladePitchController.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; PIGainScheduledTSR.PitchAngle_dot_LPF2Bfiltered = [PIGainScheduledTSR.PitchAngle_dot_LPF2Bfiltered;s.PitchAngle_dot_LPF2Bfiltered]; GeneratorTorqueController.PitchAngle_dot_filteredHPF1 = [GeneratorTorqueController.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; BladePitchController.PitchAngle_dot_filteredHPF1 = [BladePitchController.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; PIGainScheduledTSR.PitchAngle_dot_filteredHPF1 = [PIGainScheduledTSR.PitchAngle_dot_filteredHPF1;s.PitchAngle_dot_filteredHPF1]; GeneratorTorqueController.PitchAngle_dot_filteredNF = [GeneratorTorqueController.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF]; BladePitchController.PitchAngle_dot_filteredNF = [BladePitchController.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF]; PIGainScheduledTSR.PitchAngle_dot_filteredNF = [PIGainScheduledTSR.PitchAngle_dot_filteredNF;s.PitchAngle_dot_filteredNF];            
                    GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered = [GeneratorTorqueController.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; BladePitchController.YawAngle_dot_LPF2Bfiltered = [BladePitchController.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; PIGainScheduledTSR.YawAngle_dot_LPF2Bfiltered = [PIGainScheduledTSR.YawAngle_dot_LPF2Bfiltered;s.YawAngle_dot_LPF2Bfiltered]; GeneratorTorqueController.YawAngle_dot_filteredHPF1 = [GeneratorTorqueController.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; BladePitchController.YawAngle_dot_filteredHPF1 = [BladePitchController.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; PIGainScheduledTSR.YawAngle_dot_filteredHPF1 = [PIGainScheduledTSR.YawAngle_dot_filteredHPF1;s.YawAngle_dot_filteredHPF1]; GeneratorTorqueController.YawAngle_dot_filteredNF = [GeneratorTorqueController.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF]; BladePitchController.YawAngle_dot_filteredNF = [BladePitchController.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF]; PIGainScheduledTSR.YawAngle_dot_filteredNF = [PIGainScheduledTSR.YawAngle_dot_filteredNF;s.YawAngle_dot_filteredNF];
                end
                %
            end % if it == 1
            %
        end % if (s.Option04f8 < 3)
    end % if (s.Option02f2 > 1) || (s.Option04f3 == 1) 


    % ---------- LOGICAL INSTANCE 06  ----------
    if (s.Option08f8 == 1) && (s.Option06f8 == 2)
        PIGainScheduledTSR.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; PIGainScheduledTSR.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; PIGainScheduledTSR.CutFreq_LPF3 = s.CutFreq_LPF3; PIGainScheduledTSR.Ts_LPF3 = s.Ts_LPF3; PIGainScheduledTSR.alfa_LPF3 = s.alfa_LPF3; PIGainScheduledTSR.Ad_LPF3 = s.Ad_LPF3; PIGainScheduledTSR.Cd_LPF3 = s.Cd_LPF3; PIGainScheduledTSR.Dd_LPF3 = s.Dd_LPF3; PIGainScheduledTSR.OutputsLPF3_filtered = s.OutputsLPF3_filtered;
    elseif (s.Option02f8 == 1)
        PIGainScheduledTSR.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; PIGainScheduledTSR.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; PIGainScheduledTSR.CutFreq_LPF3 = s.CutFreq_LPF3; PIGainScheduledTSR.Ts_LPF3 = s.Ts_LPF3; PIGainScheduledTSR.alfa_LPF3 = s.alfa_LPF3; PIGainScheduledTSR.Ad_LPF3 = s.Ad_LPF3; PIGainScheduledTSR.Cd_LPF3 = s.Cd_LPF3; PIGainScheduledTSR.Dd_LPF3 = s.Dd_LPF3; PIGainScheduledTSR.OutputsLPF3_filtered = s.OutputsLPF3_filtered;        
    end    



    % ---------- LOGICAL INSTANCE 07  ----------    
    if it == 1
        GeneratorTorqueController.OmegaR_filtered = s.OmegaR_filtered; BladePitchController.OmegaR_filtered = s.OmegaR_filtered; PIGainScheduledTSR.OmegaR_filtered = s.OmegaR_filtered;
        GeneratorTorqueController.OmegaG_filtered = s.OmegaG_filtered; BladePitchController.OmegaG_filtered = s.OmegaG_filtered; PIGainScheduledTSR.OmegaG_filtered = s.OmegaG_filtered;
        GeneratorTorqueController.Beta_filtered = s.Beta_filtered; BladePitchController.Beta_filtered = s.Beta_filtered; PIGainScheduledTSR.Beta_filtered = s.Beta_filtered;
        GeneratorTorqueController.Tg_filtered = s.Tg_filtered; BladePitchController.Tg_filtered = s.Tg_filtered; PIGainScheduledTSR.Tg_filtered = s.Tg_filtered;      
        GeneratorTorqueController.Pe_filtered = s.Pe_filtered; BladePitchController.Pe_filtered = s.Pe_filtered; PIGainScheduledTSR.Pe_filtered = s.Pe_filtered;
        GeneratorTorqueController.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered; BladePitchController.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered; PIGainScheduledTSR.WindSpedd_hub_filtered = s.WindSpedd_hub_filtered;

        GeneratorTorqueController.Vews_op = s.Vews_op; BladePitchController.Vews_op = s.Vews_op; PIGainScheduledTSR.Vews_op = s.Vews_op;
        PIGainScheduledTSR.GradTaBeta_dop = s.GradTaBeta_dop; BladePitchController.GradTaBeta_dop = s.GradTaBeta_dop; GeneratorTorqueController.GradTaBeta_dop = s.GradTaBeta_dop;
        PIGainScheduledTSR.GradTaOmega_dop = s.GradTaOmega_dop; GeneratorTorqueController.GradTaOmega_dop = s.GradTaOmega_dop; BladePitchController.GradTaOmega_dop = s.GradTaOmega_dop;
        PIGainScheduledTSR.GradTaVop_dop = s.GradTaVop_dop; GeneratorTorqueController.GradTaVop_dop = s.GradTaVop_dop; BladePitchController.GradTaVop_dop = s.GradTaVop_dop;       
        PIGainScheduledTSR.GradFaOmega_dop = s.GradFaOmega_dop; BladePitchController.GradFaOmega_dop = s.GradFaOmega_dop; GeneratorTorqueController.GradFaOmega_dop = s.GradFaOmega_dop;
        PIGainScheduledTSR.GradFaVop_dop = s.GradFaVop_dop; BladePitchController.GradFaVop_dop = s.GradFaVop_dop; GeneratorTorqueController.GradFaVop_dop = s.GradFaVop_dop;
        PIGainScheduledTSR.GradFaBeta_dop = s.GradFaBeta_dop; BladePitchController.GradFaBeta_dop = s.GradFaBeta_dop; GeneratorTorqueController.GradFaBeta_dop = s.GradFaBeta_dop;            
        PIGainScheduledTSR.Betad_op = s.Betad_op; BladePitchController.Betad_op = s.Betad_op;
        PIGainScheduledTSR.Tgd_op = s.Tgd_op; GeneratorTorqueController.Tgd_op = s.Tgd_op;
        PIGainScheduledTSR.OmegaRd_op = s.OmegaRd_op; GeneratorTorqueController.OmegaRd_op = s.OmegaRd_op;        
        
        GeneratorTorqueController.Xt_Ddot_filtered = s.Xt_Ddot_filtered; BladePitchController.Xt_Ddot_filtered = s.Xt_Ddot_filtered; PIGainScheduledTSR.Xt_Ddot_filtered = s.Xt_Ddot_filtered;        
        if (s.Option04f8 < 3)            
            if s.Option02f2 >= 2
                GeneratorTorqueController.Surge_Ddot_filtered = s.Surge_Ddot_filtered; BladePitchController.Surge_Ddot_filtered = s.Surge_Ddot_filtered; PIGainScheduledTSR.Surge_Ddot_filtered = s.Surge_Ddot_filtered;            
                GeneratorTorqueController.Sway_Ddot_filtered = s.Sway_Ddot_filtered; BladePitchController.Sway_Ddot_filtered = s.Sway_Ddot_filtered; PIGainScheduledTSR.Sway_Ddot_filtered = s.Sway_Ddot_filtered;            
                GeneratorTorqueController.Heave_Ddot_filtered = s.Heave_Ddot_filtered; BladePitchController.Heave_Ddot_filtered = s.Heave_Ddot_filtered; PIGainScheduledTSR.Heave_Ddot_filtered = s.Heave_Ddot_filtered;             
                GeneratorTorqueController.RollAngle_dot_filtered = s.RollAngle_dot_filtered; BladePitchController.RollAngle_dot_filtered = s.RollAngle_dot_filtered; PIGainScheduledTSR.RollAngle_dot_filtered = s.RollAngle_dot_filtered;            
                GeneratorTorqueController.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered; BladePitchController.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered; PIGainScheduledTSR.PitchAngle_dot_filtered = s.PitchAngle_dot_filtered;          
                GeneratorTorqueController.YawAngle_dot_filtered = s.YawAngle_dot_filtered; BladePitchController.YawAngle_dot_filtered = s.YawAngle_dot_filtered; PIGainScheduledTSR.YawAngle_dot_filtered = s.YawAngle_dot_filtered;
            end
        end
        %
    else
        GeneratorTorqueController.OmegaR_filtered = [GeneratorTorqueController.OmegaR_filtered;s.OmegaR_filtered]; BladePitchController.OmegaR_filtered = [BladePitchController.OmegaR_filtered;s.OmegaR_filtered]; PIGainScheduledTSR.OmegaR_filtered = [PIGainScheduledTSR.OmegaR_filtered;s.OmegaR_filtered];        
        GeneratorTorqueController.OmegaG_filtered = [GeneratorTorqueController.OmegaG_filtered;s.OmegaG_filtered]; BladePitchController.OmegaG_filtered = [BladePitchController.OmegaG_filtered;s.OmegaG_filtered]; PIGainScheduledTSR.OmegaG_filtered = [PIGainScheduledTSR.OmegaG_filtered;s.OmegaG_filtered];
        GeneratorTorqueController.Beta_filtered = [GeneratorTorqueController.Beta_filtered;s.Beta_filtered]; BladePitchController.Beta_filtered = [BladePitchController.Beta_filtered;s.Beta_filtered]; PIGainScheduledTSR.Beta_filtered = [PIGainScheduledTSR.Beta_filtered;s.Beta_filtered];
        GeneratorTorqueController.Tg_filtered = [GeneratorTorqueController.Tg_filtered;s.Tg_filtered]; BladePitchController.Tg_filtered = [BladePitchController.Tg_filtered;s.Tg_filtered]; PIGainScheduledTSR.Tg_filtered = [PIGainScheduledTSR.Tg_filtered;s.Tg_filtered];        
        GeneratorTorqueController.Pe_filtered = [GeneratorTorqueController.Pe_filtered;s.Pe_filtered]; BladePitchController.Pe_filtered = [BladePitchController.Pe_filtered;s.Pe_filtered]; PIGainScheduledTSR.Pe_filtered = [PIGainScheduledTSR.Pe_filtered;s.Pe_filtered];   
        GeneratorTorqueController.WindSpedd_hub_filtered = [GeneratorTorqueController.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered]; BladePitchController.WindSpedd_hub_filtered = [BladePitchController.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered]; PIGainScheduledTSR.WindSpedd_hub_filtered = [PIGainScheduledTSR.WindSpedd_hub_filtered;s.WindSpedd_hub_filtered];        
        
        GeneratorTorqueController.Vews_op = [GeneratorTorqueController.Vews_op;s.Vews_op]; BladePitchController.Vews_op = [BladePitchController.Vews_op;s.Vews_op]; PIGainScheduledTSR.Vews_op = [PIGainScheduledTSR.Vews_op;s.Vews_op];                    
        PIGainScheduledTSR.GradTaBeta_dop = [PIGainScheduledTSR.GradTaBeta_dop;s.GradTaBeta_dop]; BladePitchController.GradTaBeta_dop = [BladePitchController.GradTaBeta_dop;s.GradTaBeta_dop]; GeneratorTorqueController.GradTaBeta_dop = [GeneratorTorqueController.GradTaBeta_dop;s.GradTaBeta_dop];
        PIGainScheduledTSR.GradTaOmega_dop = [PIGainScheduledTSR.GradTaOmega_dop;s.GradTaOmega_dop]; GeneratorTorqueController.GradTaOmega_dop = [GeneratorTorqueController.GradTaOmega_dop;s.GradTaOmega_dop]; BladePitchController.GradTaOmega_dop = [BladePitchController.GradTaOmega_dop;s.GradTaOmega_dop];
        PIGainScheduledTSR.GradTaVop_dop = [PIGainScheduledTSR.GradTaVop_dop;s.GradTaVop_dop]; GeneratorTorqueController.GradTaVop_dop = [GeneratorTorqueController.GradTaVop_dop;s.GradTaVop_dop]; BladePitchController.GradTaVop_dop = [BladePitchController.GradTaVop_dop;s.GradTaVop_dop];        
        PIGainScheduledTSR.GradFaOmega_dop = [PIGainScheduledTSR.GradFaOmega_dop;s.GradFaOmega_dop]; BladePitchController.GradFaOmega_dop = [BladePitchController.GradFaOmega_dop;s.GradFaOmega_dop]; GeneratorTorqueController.GradFaOmega_dop = [GeneratorTorqueController.GradFaOmega_dop;s.GradFaOmega_dop];
        PIGainScheduledTSR.GradFaVop_dop = [PIGainScheduledTSR.GradFaVop_dop;s.GradFaVop_dop]; BladePitchController.GradFaVop_dop = [BladePitchController.GradFaVop_dop;s.GradFaVop_dop]; GeneratorTorqueController.GradFaVop_dop = [GeneratorTorqueController.GradFaVop_dop;s.GradFaVop_dop];
        PIGainScheduledTSR.GradFaBeta_dop = [PIGainScheduledTSR.GradFaBeta_dop;s.GradFaBeta_dop]; BladePitchController.GradFaBeta_dop = [BladePitchController.GradFaBeta_dop;s.GradFaBeta_dop]; GeneratorTorqueController.GradFaBeta_dop = [GeneratorTorqueController.GradFaBeta_dop;s.GradFaBeta_dop];            
        PIGainScheduledTSR.Betad_op = [PIGainScheduledTSR.Betad_op;s.Betad_op]; BladePitchController.Betad_op = [BladePitchController.Betad_op;s.Betad_op];
        PIGainScheduledTSR.Tgd_op = [PIGainScheduledTSR.Tgd_op;s.Tgd_op]; GeneratorTorqueController.Tgd_op = [GeneratorTorqueController.Tgd_op;s.Tgd_op];
        PIGainScheduledTSR.OmegaRd_op = [PIGainScheduledTSR.OmegaRd_op;s.OmegaRd_op]; GeneratorTorqueController.OmegaRd_op = [GeneratorTorqueController.OmegaRd_op;s.OmegaRd_op];        

        GeneratorTorqueController.Xt_Ddot_filtered = [GeneratorTorqueController.Xt_Ddot_filtered;s.Xt_Ddot_filtered]; BladePitchController.Xt_Ddot_filtered = [BladePitchController.Xt_Ddot_filtered;s.Xt_Ddot_filtered]; PIGainScheduledTSR.Xt_Ddot_filtered = [PIGainScheduledTSR.Xt_Ddot_filtered;s.Xt_Ddot_filtered];
        if (s.Option04f8 < 3)            
            if s.Option02f2 >= 2
                GeneratorTorqueController.Surge_Ddot_filtered = [GeneratorTorqueController.Surge_Ddot_filtered;s.Surge_Ddot_filtered]; BladePitchController.Surge_Ddot_filtered = [BladePitchController.Surge_Ddot_filtered;s.Surge_Ddot_filtered]; PIGainScheduledTSR.Surge_Ddot_filtered = [PIGainScheduledTSR.Surge_Ddot_filtered;s.Surge_Ddot_filtered];            
                GeneratorTorqueController.Sway_Ddot_filtered = [GeneratorTorqueController.Sway_Ddot_filtered;s.Sway_Ddot_filtered]; BladePitchController.Sway_Ddot_filtered = [BladePitchController.Sway_Ddot_filtered;s.Sway_Ddot_filtered]; PIGainScheduledTSR.Sway_Ddot_filtered = [PIGainScheduledTSR.Sway_Ddot_filtered;s.Sway_Ddot_filtered];            
                GeneratorTorqueController.Heave_Ddot_filtered = [GeneratorTorqueController.Heave_Ddot_filtered;s.Heave_Ddot_filtered]; BladePitchController.Heave_Ddot_filtered = [BladePitchController.Heave_Ddot_filtered;s.Heave_Ddot_filtered]; PIGainScheduledTSR.Heave_Ddot_filtered = [PIGainScheduledTSR.Heave_Ddot_filtered;s.Heave_Ddot_filtered];            
                GeneratorTorqueController.RollAngle_dot_filtered = [GeneratorTorqueController.RollAngle_dot_filtered;s.RollAngle_dot_filtered]; BladePitchController.RollAngle_dot_filtered = [BladePitchController.RollAngle_dot_filtered;s.RollAngle_dot_filtered]; PIGainScheduledTSR.RollAngle_dot_filtered = [PIGainScheduledTSR.RollAngle_dot_filtered;s.RollAngle_dot_filtered];            
                GeneratorTorqueController.PitchAngle_dot_filtered = [GeneratorTorqueController.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered]; BladePitchController.PitchAngle_dot_filtered = [BladePitchController.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered]; PIGainScheduledTSR.PitchAngle_dot_filtered = [PIGainScheduledTSR.PitchAngle_dot_filtered;s.PitchAngle_dot_filtered];             
                GeneratorTorqueController.YawAngle_dot_filtered = [GeneratorTorqueController.YawAngle_dot_filtered;s.YawAngle_dot_filtered]; BladePitchController.YawAngle_dot_filtered = [BladePitchController.YawAngle_dot_filtered;s.YawAngle_dot_filtered]; PIGainScheduledTSR.YawAngle_dot_filtered = [PIGainScheduledTSR.YawAngle_dot_filtered;s.YawAngle_dot_filtered];
            end
            %
        end
    end



    % ---------- LOGICAL INSTANCE 08  ----------
    if it == 1
        if s.Option04f8 == 1
            PIGainScheduledTSR.dt_contr  = s.dt_contr;  
            PIGainScheduledTSR.Rarm_pitch = s.Rarm_pitch;
        end
        PIGainScheduledTSR.Xf_dot_filtered = s.Xf_dot_filtered; PIGainScheduledTSR.Kp_CS_Feedback = s.Kp_CS_Feedback; PIGainScheduledTSR.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        BladePitchController.Xf_dot_filtered = s.Xf_dot_filtered; BladePitchController.Kp_CS_Feedback = s.Kp_CS_Feedback; BladePitchController.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        GeneratorTorqueController.Xf_dot_filtered = s.Xf_dot_filtered; GeneratorTorqueController.Kp_CS_Feedback = s.Kp_CS_Feedback; GeneratorTorqueController.PropTerm_CS_Feedback = s.PropTerm_CS_Feedback;
        GeneratorTorqueController.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m; BladePitchController.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m; PIGainScheduledTSR.Cosseno_PitchAngle_m = s.Cosseno_PitchAngle_m;        
        GeneratorTorqueController.VCsi_est = s.VCsi_est; BladePitchController.VCsi_est = s.VCsi_est; PIGainScheduledTSR.VCsi_est = s.VCsi_est;
    else
        PIGainScheduledTSR.Xf_dot_filtered = [PIGainScheduledTSR.Xf_dot_filtered;s.Xf_dot_filtered]; PIGainScheduledTSR.Kp_CS_Feedback = [PIGainScheduledTSR.Kp_CS_Feedback;s.Kp_CS_Feedback]; PIGainScheduledTSR.PropTerm_CS_Feedback = [PIGainScheduledTSR.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        BladePitchController.Xf_dot_filtered = [BladePitchController.Xf_dot_filtered;s.Xf_dot_filtered]; BladePitchController.Kp_CS_Feedback = [BladePitchController.Kp_CS_Feedback;s.Kp_CS_Feedback]; BladePitchController.PropTerm_CS_Feedback = [BladePitchController.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        GeneratorTorqueController.Xf_dot_filtered = [GeneratorTorqueController.Xf_dot_filtered;s.Xf_dot_filtered]; GeneratorTorqueController.Kp_CS_Feedback = [GeneratorTorqueController.Kp_CS_Feedback;s.Kp_CS_Feedback]; GeneratorTorqueController.PropTerm_CS_Feedback = [GeneratorTorqueController.PropTerm_CS_Feedback;s.PropTerm_CS_Feedback];
        PIGainScheduledTSR.Cosseno_PitchAngle_m = [PIGainScheduledTSR.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m]; GeneratorTorqueController.Cosseno_PitchAngle_m = [GeneratorTorqueController.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m]; BladePitchController.Cosseno_PitchAngle_m = [BladePitchController.Cosseno_PitchAngle_m;s.Cosseno_PitchAngle_m];
        PIGainScheduledTSR.VCsi_est = [PIGainScheduledTSR.VCsi_est;s.VCsi_est]; GeneratorTorqueController.VCsi_est = [GeneratorTorqueController.VCsi_est;s.VCsi_est]; BladePitchController.VCsi_est = [BladePitchController.VCsi_est;s.VCsi_est];
        %
    end
    

    % ---------- LOGICAL INSTANCE 09  ----------
    if it == 1
        PIGainScheduledTSR.BetaMin_setup = s.BetaMin_setup; BladePitchController.BetaMin_setup = s.BetaMin_setup; GeneratorTorqueController.BetaMin_setup = s.BetaMin_setup;
        PIGainScheduledTSR.BetaMax_setup = s.BetaMax_setup; BladePitchController.BetaMax_setup = s.BetaMax_setup; GeneratorTorqueController.BetaMax_setup = s.BetaMax_setup;          
        PIGainScheduledTSR.TgMin_setup = s.TgMin_setup; BladePitchController.TgMin_setup = s.TgMin_setup; GeneratorTorqueController.TgMin_setup = s.TgMin_setup;
        PIGainScheduledTSR.TgMax_setup  = s.TgMax_setup ; BladePitchController.TgMax_setup  = s.TgMax_setup ; GeneratorTorqueController.TgMax_setup  = s.TgMax_setup ;            
    else
        PIGainScheduledTSR.BetaMin_setup = [PIGainScheduledTSR.BetaMin_setup;s.BetaMin_setup]; BladePitchController.BetaMin_setup = [BladePitchController.BetaMin_setup;s.BetaMin_setup]; GeneratorTorqueController.BetaMin_setup = [GeneratorTorqueController.BetaMin_setup;s.BetaMin_setup];
        PIGainScheduledTSR.BetaMax_setup = [PIGainScheduledTSR.BetaMax_setup;s.BetaMax_setup]; BladePitchController.BetaMax_setup = [BladePitchController.BetaMax_setup;s.BetaMax_setup]; GeneratorTorqueController.BetaMax_setup = [GeneratorTorqueController.BetaMax_setup;s.BetaMax_setup];        
        PIGainScheduledTSR.TgMin_setup = [PIGainScheduledTSR.TgMin_setup;s.TgMin_setup]; BladePitchController.TgMin_setup = [BladePitchController.TgMin_setup;s.TgMin_setup]; GeneratorTorqueController.TgMin_setup = [GeneratorTorqueController.TgMin_setup;s.TgMin_setup];
        PIGainScheduledTSR.TgMax_setup  = [PIGainScheduledTSR.TgMax_setup ;s.TgMax_setup ]; BladePitchController.TgMax_setup  = [BladePitchController.TgMax_setup ;s.TgMax_setup ]; GeneratorTorqueController.TgMax_setup  = [GeneratorTorqueController.TgMax_setup ;s.TgMax_setup ];          
    end



    % ---------- LOGICAL INSTANCE 10  ----------
    if it == 1         
        GeneratorTorqueController.OmegaRef_Tg = s.OmegaRef_Tg; BladePitchController.OmegaRef_Tg = s.OmegaRef_Tg; PIGainScheduledTSR.OmegaRef_Tg = s.OmegaRef_Tg; 
        GeneratorTorqueController.OmegaRef_Beta = s.OmegaRef_Beta; BladePitchController.OmegaRef_Beta = s.OmegaRef_Beta; PIGainScheduledTSR.OmegaRef_Beta = s.OmegaRef_Beta;     
        GeneratorTorqueController.OmegaRef = s.OmegaRef; BladePitchController.OmegaRef = s.OmegaRef; PIGainScheduledTSR.OmegaRef = s.OmegaRef;         
    else
        GeneratorTorqueController.OmegaRef_Tg = [GeneratorTorqueController.OmegaRef_Tg;s.OmegaRef_Tg]; BladePitchController.OmegaRef_Tg = [BladePitchController.OmegaRef_Tg;s.OmegaRef_Tg]; PIGainScheduledTSR.OmegaRef_Tg = [PIGainScheduledTSR.OmegaRef_Tg;s.OmegaRef_Tg]; 
        GeneratorTorqueController.OmegaRef_Beta = [GeneratorTorqueController.OmegaRef_Beta;s.OmegaRef_Beta]; BladePitchController.OmegaRef_Beta = [BladePitchController.OmegaRef_Beta;s.OmegaRef_Beta]; PIGainScheduledTSR.OmegaRef_Beta = [PIGainScheduledTSR.OmegaRef_Beta;s.OmegaRef_Beta];    
        GeneratorTorqueController.OmegaRef = [GeneratorTorqueController.OmegaRef;s.OmegaRef]; BladePitchController.OmegaRef = [BladePitchController.OmegaRef;s.OmegaRef]; PIGainScheduledTSR.OmegaRef = [PIGainScheduledTSR.OmegaRef;s.OmegaRef];         
        %
    end


    % ---------- LOGICAL INSTANCE 11  ----------
    if s.Option06f8 == 2
        % SET POINT SMOOTHING (by Abbas 2022)
        GeneratorTorqueController.BetaSmoother_max = s.BetaSmoother_max; BladePitchController.BetaSmoother_max = s.BetaSmoother_max; PIGainScheduledTSR.BetaSmoother_max = s.BetaSmoother_max;
        GeneratorTorqueController.TgSmoother_max = s.TgSmoother_max; BladePitchController.TgSmoother_max  = s.TgSmoother_max; PIGainScheduledTSR.TgSmoother_max = s.TgSmoother_max;
        if s.Option07f8 == 2
            GeneratorTorqueController.PeSmoother_max = s.PeSmoother_max; BladePitchController.PeSmoother_max = s.PeSmoother_max; PIGainScheduledTSR.PeSmoother_max = s.PeSmoother_max;
        end
        
        if it ==1 
            GeneratorTorqueController.OmegaRef_Tg = s.OmegaRef_Tg; BladePitchController.OmegaRef_Tg = s.OmegaRef_Tg; PIGainScheduledTSR.OmegaRef_Tg = s.OmegaRef_Tg; 
            GeneratorTorqueController.OmegaRef_Beta = s.OmegaRef_Beta; BladePitchController.OmegaRef_Beta = s.OmegaRef_Beta; PIGainScheduledTSR.OmegaRef_Beta = s.OmegaRef_Beta;     
            GeneratorTorqueController.BetaSmoother_min = s.BetaSmoother_min; BladePitchController.BetaSmoother_min = s.BetaSmoother_min; PIGainScheduledTSR.BetaSmoother_min = s.BetaSmoother_min;
            GeneratorTorqueController.Beta_Smoother = s.Beta_Smoother; BladePitchController.Beta_Smoother = s.Beta_Smoother; PIGainScheduledTSR.Beta_Smoother = s.Beta_Smoother;
            GeneratorTorqueController.DeltaBeta_Smoother = s.DeltaBeta_Smoother; BladePitchController.DeltaBeta_Smoother = s.DeltaBeta_Smoother; PIGainScheduledTSR.DeltaBeta_Smoother = s.DeltaBeta_Smoother;
            GeneratorTorqueController.Tg_Smoother = s.Tg_Smoother; BladePitchController.Tg_Smoother = s.Tg_Smoother; PIGainScheduledTSR.Tg_Smoother = s.Tg_Smoother;
            GeneratorTorqueController.DeltaTg_Smoother = s.DeltaTg_Smoother; BladePitchController.DeltaTg_Smoother = s.DeltaTg_Smoother; PIGainScheduledTSR.DeltaTg_Smoother = s.DeltaTg_Smoother;
            GeneratorTorqueController.Delta_Omega = s.Delta_Omega; BladePitchController.Delta_Omega = s.Delta_Omega; PIGainScheduledTSR.Delta_Omega = s.Delta_Omega;   
            GeneratorTorqueController.Delta_Omega_filteredLPF3 = s.Delta_Omega_filteredLPF3; BladePitchController.Delta_Omega_filteredLPF3 = s.Delta_Omega_filteredLPF3; PIGainScheduledTSR.Delta_Omega_filteredLPF3 = s.Delta_Omega_filteredLPF3;             
            if s.Option08f8 == 1
                PIGainScheduledTSR.CutFreq_LPF3 = s.CutFreq_LPF3; 
                PIGainScheduledTSR.Ts_LPF3 = s.Ts_LPF3;
                PIGainScheduledTSR.alfa_LPF3 = s.alfa_LPF3;
                PIGainScheduledTSR.Ad_LPF3 = s.Ad_LPF3;
                PIGainScheduledTSR.Cd_LPF3 = s.Cd_LPF3;
                PIGainScheduledTSR.Dd_LPF3 = s.Dd_LPF3;

                BladePitchController.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; GeneratorTorqueController.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered; PIGainScheduledTSR.InputsLPF3_unfiltered = s.InputsLPF3_unfiltered;                
                BladePitchController.OutputsLPF3_filtered = s.OutputsLPF3_filtered; GeneratorTorqueController.OutputsLPF3_filtered = s.OutputsLPF3_filtered; PIGainScheduledTSR.OutputsLPF3_filtered = s.OutputsLPF3_filtered;  
                %              
            end            
            if s.Option07f8 == 2
                GeneratorTorqueController.Pe_Smoother = s.Pe_Smoother; BladePitchController.Pe_Smoother = s.Pe_Smoother; PIGainScheduledTSR.Pe_Smoother = s.Pe_Smoother;
                GeneratorTorqueController.DeltaPe_Smoother = s.DeltaPe_Smoother; BladePitchController.DeltaPe_Smoother = s.DeltaPe_Smoother; PIGainScheduledTSR.DeltaPe_Smoother = s.DeltaPe_Smoother;
                %
            end
            %
        else
            GeneratorTorqueController.OmegaRef_Tg = [GeneratorTorqueController.OmegaRef_Tg;s.OmegaRef_Tg]; BladePitchController.OmegaRef_Tg = [BladePitchController.OmegaRef_Tg;s.OmegaRef_Tg]; PIGainScheduledTSR.OmegaRef_Tg = [PIGainScheduledTSR.OmegaRef_Tg;s.OmegaRef_Tg]; 
            GeneratorTorqueController.OmegaRef_Beta = [GeneratorTorqueController.OmegaRef_Beta;s.OmegaRef_Beta]; BladePitchController.OmegaRef_Beta = [BladePitchController.OmegaRef_Beta;s.OmegaRef_Beta]; PIGainScheduledTSR.OmegaRef_Beta = [PIGainScheduledTSR.OmegaRef_Beta;s.OmegaRef_Beta];      
            GeneratorTorqueController.BetaSmoother_min = [GeneratorTorqueController.BetaSmoother_min;s.BetaSmoother_min]; BladePitchController.BetaSmoother_min = [BladePitchController.BetaSmoother_min;s.BetaSmoother_min]; PIGainScheduledTSR.BetaSmoother_min = [PIGainScheduledTSR.BetaSmoother_min;s.BetaSmoother_min];
            GeneratorTorqueController.Beta_Smoother = [GeneratorTorqueController.Beta_Smoother;s.Beta_Smoother]; BladePitchController.Beta_Smoother = [BladePitchController.Beta_Smoother;s.Beta_Smoother]; PIGainScheduledTSR.Beta_Smoother = [PIGainScheduledTSR.Beta_Smoother;s.Beta_Smoother];
            GeneratorTorqueController.DeltaBeta_Smoother = [GeneratorTorqueController.DeltaBeta_Smoother;s.DeltaBeta_Smoother]; BladePitchController.DeltaBeta_Smoother = [BladePitchController.DeltaBeta_Smoother;s.DeltaBeta_Smoother]; PIGainScheduledTSR.DeltaBeta_Smoother = [PIGainScheduledTSR.DeltaBeta_Smoother;s.DeltaBeta_Smoother];
            GeneratorTorqueController.Tg_Smoother = [GeneratorTorqueController.Tg_Smoother;s.Tg_Smoother]; BladePitchController.Tg_Smoother = [BladePitchController.Tg_Smoother;s.Tg_Smoother]; PIGainScheduledTSR.Tg_Smoother = [PIGainScheduledTSR.Tg_Smoother;s.Tg_Smoother];
            GeneratorTorqueController.DeltaTg_Smoother = [GeneratorTorqueController.DeltaTg_Smoother;s.DeltaTg_Smoother]; BladePitchController.DeltaTg_Smoother = [BladePitchController.DeltaTg_Smoother;s.DeltaTg_Smoother]; PIGainScheduledTSR.DeltaTg_Smoother = [PIGainScheduledTSR.DeltaTg_Smoother;s.DeltaTg_Smoother];
            GeneratorTorqueController.Delta_Omega = [GeneratorTorqueController.Delta_Omega;s.Delta_Omega]; BladePitchController.Delta_Omega = [BladePitchController.Delta_Omega;s.Delta_Omega]; PIGainScheduledTSR.Delta_Omega = [PIGainScheduledTSR.Delta_Omega;s.Delta_Omega];   
            GeneratorTorqueController.Delta_Omega_filteredLPF3 = [GeneratorTorqueController.Delta_Omega_filteredLPF3;s.Delta_Omega_filteredLPF3]; BladePitchController.Delta_Omega_filteredLPF3 = [BladePitchController.Delta_Omega_filteredLPF3;s.Delta_Omega_filteredLPF3]; PIGainScheduledTSR.Delta_Omega_filteredLPF3 = [PIGainScheduledTSR.Delta_Omega_filteredLPF3;s.Delta_Omega_filteredLPF3]; 
            
            if s.Option08f8 == 1
                BladePitchController.InputsLPF3_unfiltered = [BladePitchController.InputsLPF3_unfiltered;s.InputsLPF3_unfiltered]; GeneratorTorqueController.InputsLPF3_unfiltered = [GeneratorTorqueController.InputsLPF3_unfiltered;s.InputsLPF3_unfiltered]; PIGainScheduledTSR.InputsLPF3_unfiltered = [PIGainScheduledTSR.InputsLPF3_unfiltered;s.InputsLPF3_unfiltered];                
                BladePitchController.OutputsLPF3_filtered = [BladePitchController.OutputsLPF3_filtered;s.OutputsLPF3_filtered]; GeneratorTorqueController.OutputsLPF3_filtered = [GeneratorTorqueController.OutputsLPF3_filtered;s.OutputsLPF3_filtered]; PIGainScheduledTSR.OutputsLPF3_filtered = [PIGainScheduledTSR.OutputsLPF3_filtered;s.OutputsLPF3_filtered];
                %
            end
            
            if s.Option07f8 == 2
                GeneratorTorqueController.Pe_Smoother = [GeneratorTorqueController.Pe_Smoother;s.Pe_Smoother]; BladePitchController.Pe_Smoother = [BladePitchController.Pe_Smoother;s.Pe_Smoother]; PIGainScheduledTSR.Pe_Smoother = [PIGainScheduledTSR.Pe_Smoother;s.Pe_Smoother];
                GeneratorTorqueController.DeltaPe_Smoother = [GeneratorTorqueController.DeltaPe_Smoother;s.DeltaPe_Smoother]; BladePitchController.DeltaPe_Smoother = [BladePitchController.DeltaPe_Smoother;s.DeltaPe_Smoother]; PIGainScheduledTSR.DeltaPe_Smoother = [PIGainScheduledTSR.DeltaPe_Smoother;s.DeltaPe_Smoother];
                %
            end
            %            
        end
    end


    
    % ---------- LOGICAL INSTANCE 12  ----------
    if it == 1
        BladePitchController.Beta_d = s.Beta_d;  BladePitchController.Beta_dDot = s.Beta_dDot;
        PIGainScheduledTSR.Beta_d = s.Beta_d;  PIGainScheduledTSR.Beta_dDot = s.Beta_dDot;
        PIGainScheduledTSR.Beta_d_before = s.Beta_d_before; BladePitchController.Beta_d_before = s.Beta_d_before;
        PIGainScheduledTSR.Beta_filtered_before = s.Beta_filtered_before; BladePitchController.Beta_filtered_before = s.Beta_filtered_before;
        BladePitchController.dBeta_max = s.dBeta_max; BladePitchController.dBeta_min = s.dBeta_min; BladePitchController.ErroTracking_Betad = s.ErroTracking_Betad; BladePitchController.Kp_piBeta = s.Kp_piBeta; BladePitchController.Ki_piBeta = s.Ki_piBeta; BladePitchController.PropTermPI_Beta = s.PropTermPI_Beta; BladePitchController.IntegTermPI_Beta = s.IntegTermPI_Beta; BladePitchController.dBeta = s.dBeta;
        PIGainScheduledTSR.dBeta_max = s.dBeta_max; PIGainScheduledTSR.dBeta_min = s.dBeta_min; PIGainScheduledTSR.ErroTracking_Betad = s.ErroTracking_Betad; PIGainScheduledTSR.Kp_piBeta = s.Kp_piBeta; PIGainScheduledTSR.Ki_piBeta = s.Ki_piBeta; PIGainScheduledTSR.PropTermPI_Beta = s.PropTermPI_Beta; PIGainScheduledTSR.IntegTermPI_Beta = s.IntegTermPI_Beta; PIGainScheduledTSR.dBeta = s.dBeta;
    else
        BladePitchController.Beta_d = [BladePitchController.Beta_d ;s.Beta_d];  BladePitchController.Beta_dDot = [BladePitchController.Beta_dDot;s.Beta_dDot];
        PIGainScheduledTSR.Beta_d = [PIGainScheduledTSR.Beta_d;s.Beta_d];  PIGainScheduledTSR.Beta_dDot = [PIGainScheduledTSR.Beta_dDot;s.Beta_dDot];
        PIGainScheduledTSR.Beta_d_before = [PIGainScheduledTSR.Beta_d_before;s.Beta_d_before]; BladePitchController.Beta_d_before = [BladePitchController.Beta_d_before;s.Beta_d_before];
        PIGainScheduledTSR.Beta_filtered_before = [PIGainScheduledTSR.Beta_filtered_before;s.Beta_filtered_before]; BladePitchController.Beta_filtered_before = [BladePitchController.Beta_filtered_before;s.Beta_filtered_before];
        BladePitchController.dBeta_max = [BladePitchController.dBeta_max;s.dBeta_max]; BladePitchController.dBeta_min = [BladePitchController.dBeta_min;s.dBeta_min]; BladePitchController.ErroTracking_Betad = [BladePitchController.ErroTracking_Betad;s.ErroTracking_Betad]; BladePitchController.Kp_piBeta = [BladePitchController.Kp_piBeta;s.Kp_piBeta]; BladePitchController.Ki_piBeta = [BladePitchController.Ki_piBeta;s.Ki_piBeta]; BladePitchController.PropTermPI_Beta = [BladePitchController.PropTermPI_Beta;s.PropTermPI_Beta]; BladePitchController.IntegTermPI_Beta = [BladePitchController.IntegTermPI_Beta;s.IntegTermPI_Beta]; BladePitchController.dBeta = [BladePitchController.dBeta;s.dBeta];
        PIGainScheduledTSR.dBeta_max = [PIGainScheduledTSR.dBeta_max;s.dBeta_max]; PIGainScheduledTSR.dBeta_min = [PIGainScheduledTSR.dBeta_min;s.dBeta_min]; PIGainScheduledTSR.ErroTracking_Betad = [PIGainScheduledTSR.ErroTracking_Betad;s.ErroTracking_Betad]; PIGainScheduledTSR.Kp_piBeta = [PIGainScheduledTSR.Kp_piBeta;s.Kp_piBeta]; PIGainScheduledTSR.Ki_piBeta = [PIGainScheduledTSR.Ki_piBeta;s.Ki_piBeta]; PIGainScheduledTSR.PropTermPI_Beta = [PIGainScheduledTSR.PropTermPI_Beta;s.PropTermPI_Beta]; PIGainScheduledTSR.IntegTermPI_Beta = [PIGainScheduledTSR.IntegTermPI_Beta;s.IntegTermPI_Beta]; PIGainScheduledTSR.dBeta = [PIGainScheduledTSR.dBeta;s.dBeta];
        %
    end


    % ---------- LOGICAL INSTANCE 13  ----------
    if it == 1
        GeneratorTorqueController.Tg_d = s.Tg_d; GeneratorTorqueController.Tg_dDot = s.Tg_dDot;
        PIGainScheduledTSR.Tg_d = s.Tg_d;  PIGainScheduledTSR.Tg_dDot = s.Tg_dDot;
        GeneratorTorqueController.Tg_d_before = s.Tg_d_before; PIGainScheduledTSR.Tg_d_before = s.Tg_d_before;
        GeneratorTorqueController.Tg_filtered_before = s.Tg_filtered_before; PIGainScheduledTSR.Tg_filtered_before = s.Tg_filtered_before;        
        GeneratorTorqueController.Pe_d_before = s.Pe_d_before; PIGainScheduledTSR.Pe_d_before = s.Pe_d_before; 
        GeneratorTorqueController.Pe_filtered_before = s.Pe_filtered_before; PIGainScheduledTSR.Pe_filtered_before = s.Pe_filtered_before;        

        GeneratorTorqueController.dTg_max = s.dTg_max; GeneratorTorqueController.dTg_min = s.dTg_min; GeneratorTorqueController.ErroTracking_Tgd = s.ErroTracking_Tgd; GeneratorTorqueController.Kp_piTg = s.Kp_piTg; GeneratorTorqueController.Ki_piTg = s.Ki_piTg; GeneratorTorqueController.PropTermPI_Tg = s.PropTermPI_Tg; GeneratorTorqueController.IntegTermPI_Tg = s.IntegTermPI_Tg; GeneratorTorqueController.dTg = s.dTg;
        PIGainScheduledTSR.dTg_max = s.dTg_max; PIGainScheduledTSR.dTg_min = s.dTg_min; PIGainScheduledTSR.ErroTracking_Tgd = s.ErroTracking_Tgd; PIGainScheduledTSR.Kp_piTg = s.Kp_piTg; PIGainScheduledTSR.Ki_piTg = s.Ki_piTg; PIGainScheduledTSR.PropTermPI_Tg = s.PropTermPI_Tg; PIGainScheduledTSR.IntegTermPI_Tg = s.IntegTermPI_Tg; PIGainScheduledTSR.dTg = s.dTg;
    else
        GeneratorTorqueController.Tg_d = [GeneratorTorqueController.Tg_d;s.Tg_d]; GeneratorTorqueController.Tg_dDot = [GeneratorTorqueController.Tg_dDot;s.Tg_dDot];
        PIGainScheduledTSR.Tg_d = [PIGainScheduledTSR.Tg_d;s.Tg_d];  PIGainScheduledTSR.Tg_dDot = [PIGainScheduledTSR.Tg_dDot;s.Tg_dDot];
        GeneratorTorqueController.Tg_d_before = [GeneratorTorqueController.Tg_d_before;s.Tg_d_before]; PIGainScheduledTSR.Tg_d_before = [PIGainScheduledTSR.Tg_d_before;s.Tg_d_before];
        GeneratorTorqueController.Tg_filtered_before = [GeneratorTorqueController.Tg_filtered_before;s.Tg_filtered_before]; PIGainScheduledTSR.Tg_filtered_before = [PIGainScheduledTSR.Tg_filtered_before;s.Tg_filtered_before];        
        GeneratorTorqueController.Pe_d_before = [GeneratorTorqueController.Pe_d_before;s.Pe_d_before]; PIGainScheduledTSR.Pe_d_before = [PIGainScheduledTSR.Pe_d_before;s.Pe_d_before];
        GeneratorTorqueController.Pe_filtered_before = [GeneratorTorqueController.Pe_filtered_before;s.Pe_filtered_before]; PIGainScheduledTSR.Pe_filtered_before = [PIGainScheduledTSR.Pe_filtered_before;s.Pe_filtered_before];        
        GeneratorTorqueController.dTg_max = [GeneratorTorqueController.dTg_max ;s.dTg_max]; GeneratorTorqueController.dTg_min = [GeneratorTorqueController.dTg_min;s.dTg_min]; GeneratorTorqueController.ErroTracking_Tgd = [GeneratorTorqueController.ErroTracking_Tgd;s.ErroTracking_Tgd]; GeneratorTorqueController.Kp_piTg = [GeneratorTorqueController.Kp_piTg;s.Kp_piTg]; GeneratorTorqueController.Ki_piTg = [GeneratorTorqueController.Ki_piTg;s.Ki_piTg]; GeneratorTorqueController.PropTermPI_Tg = [GeneratorTorqueController.PropTermPI_Tg;s.PropTermPI_Tg]; GeneratorTorqueController.IntegTermPI_Tg = [GeneratorTorqueController.IntegTermPI_Tg;s.IntegTermPI_Tg]; GeneratorTorqueController.dTg = [GeneratorTorqueController.dTg;s.dTg];
        PIGainScheduledTSR.dTg_max = [PIGainScheduledTSR.dTg_max;s.dTg_max]; PIGainScheduledTSR.dTg_min = [PIGainScheduledTSR.dTg_min;s.dTg_min]; PIGainScheduledTSR.ErroTracking_Tgd = [PIGainScheduledTSR.ErroTracking_Tgd;s.ErroTracking_Tgd]; PIGainScheduledTSR.Kp_piTg = [PIGainScheduledTSR.Kp_piTg;s.Kp_piTg]; PIGainScheduledTSR.Ki_piTg = [PIGainScheduledTSR.Ki_piTg;s.Ki_piTg]; PIGainScheduledTSR.PropTermPI_Tg = [PIGainScheduledTSR.PropTermPI_Tg;s.PropTermPI_Tg]; PIGainScheduledTSR.IntegTermPI_Tg = [PIGainScheduledTSR.IntegTermPI_Tg;s.IntegTermPI_Tg]; PIGainScheduledTSR.dTg = [PIGainScheduledTSR.dTg;s.dTg];
        %
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);
    assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
    assignin('base', 'BladePitchController', BladePitchController);



elseif strcmp(action, 'logical_instance_15')
%==================== LOGICAL INSTANCE 15 ====================
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
    plot(s.Time, s.Beta_measured, 'b:', 'LineWidth', 1.5);         
    plot(s.Time, s.Betad_op, 'k--', 'LineWidth', 0.5);   
    plot(s.Time, s.Beta_d, 'r', 'LineWidth', 0.8);     
    hold off; 
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\beta}_{d}$ [deg]', 'Interpreter', 'latex') 
    ylim([0.95*beta_minplot 1.05*beta_maxplot])  
    legend('Measured Blade Pitch ${\beta}$','Collective Blade Pitch at operating point ${\hat{\beta}}_{op}$', 'Collective Blade Pitch demanded by the controller ${\beta}_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Collective Blade Pitch demanded by the controller over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex'); 
    % 


        % Rate of Blade Pitch
    figure();
    hold on;     
    plot(s.Time, s.Beta_dot, 'b--', 'LineWidth', 0.5);       
    plot(s.Time, s.Beta_dDot, 'r', 'LineWidth', 0.5);
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
    plot(s.Time, s.Tg_measured, 'b:', 'LineWidth', 1.5);               
    plot(s.Time, s.Tgd_op, 'k--', 'LineWidth', 0.5);   
    plot(s.Time, s.Tg_d, 'r', 'LineWidth', 0.8);     
    hold off;
    xlabel('$t$ [seg]', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);
    ylabel('$Tg_{d}$ [N.m]', 'Interpreter', 'latex'); 
    ylim([0.95 * min([s.Tg_d s.Tg_measured s.Tgd_op]) 1.05 * max([s.Tg_d s.Tg_measured s.Tgd_op])]);     
    legend('Measured Generator Torque ${Tg}$', 'Generator torque at operating point ${\hat{Tg}}_{op}$', 'Generator Torque demanded by the controller $Tg_{d}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Generator Torque demanded by the controller over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Rate of Generator Torque
    figure();
    hold on;      
    plot(s.Time, s.Tg_dot, 'b--', 'LineWidth', 0.5);      
    plot(s.Time, s.Tg_dDot, 'r', 'LineWidth', 0.5);
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
    plot(s.Time, s.OmegaR_measured, 'b:', 'LineWidth', 1.5);             
    plot(s.Time, s.OmegaRef, 'k--', 'LineWidth', 0.5);   
    plot(s.Time, s.OmegaR_filtered, 'r', 'LineWidth', 0.8);     
    hold off; 
    xlabel('$t$ [seg]', 'Interpreter', 'latex') 
    xlim([0 max(s.Time)])
    ylabel('${\omega}$ [rad/s]', 'Interpreter', 'latex') 
    ylim([0.95 * min([s.OmegaRef s.OmegaR_filtered s.OmegaR_measured]) 1.05 * max([s.OmegaRef s.OmegaR_filtered s.OmegaR_measured])]) 
    legend('Measured Rotor Speed ${\omega}_{r}$', 'Controller Tracking Reference Speed ${\hat{\omega}}_{ref}$', 'Filtered Rotor Speed (${\hat{\omega}}_{r}$)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
    title('Comparison of measured and filtered rotor speed with tracked reference rotor speed over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    


    % ---- Plot Blade Collective Pitch Controller Design Parameters ----  
    if s.Option10f8 == 3
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


    % ---- Plot Generator Torque Controller Design Parameters ----  
    if s.Option10f8 == 3
        set(groot, 'defaultTextInterpreter', 'latex')
        figure()     
        plot(s.Time,s.ErroTracking_Tgd)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Tracking Error', 'Interpreter', 'latex')
        ylim([0.95*min(s.ErroTracking_Tgd) 1.05*max(s.ErroTracking_Tgd)])        
        legend('Generator Torque Controller Reference Speed Tracking Error', 'Interpreter', 'latex')
        title('Generator Torque Controller Reference Speed Tracking Error over time.', 'Interpreter', 'latex');
        %

        set(groot, 'defaultTextInterpreter', 'latex')        
        figure()     
        plot(s.Time,s.Kp_piTg)        
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Gain ($KI$)', 'Interpreter', 'latex');
        ylim([0.95*min(s.Kp_piTg) 1.05*max(s.Kp_piTg)])         
        legend('Generator Torque Controller Integrative Gain ($KI$)', 'Interpreter', 'latex')
        title('Generator Torque Controller Integrative Gain over time.')
        %

        set(groot, 'defaultTextInterpreter', 'latex')        
        figure()     
        plot(s.Time,s.PropTermPI_Tg)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Term (Kp*erro)', 'Interpreter', 'latex')
        ylim([0.95*min(s.PropTermPI_Tg) 1.05*max(s.PropTermPI_Tg)])        
        legend('Generator Torque Controller Proportional Term (Kp*erro)', 'Interpreter', 'latex')
        title('Generator Torque Controller Proportional Term over time.')           
        %   
        
        %#############
        figure()     
        plot(s.Time,s.Ki_piTg)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('​​Gain (KI)', 'Interpreter', 'latex')
        ylim([min(- abs(s.Ki_piTg) ) (max( abs(s.Ki_piTg) )+1e+5)]) 
        legend('Generator Torque Controller Integrative Gain (KI)', 'Interpreter', 'latex')
        title('Generator Torque Controller Integrative Gain over time.')
        %

        figure()     
        plot(s.Time,s.PropTermPI_Tg)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('Term (KI*IntegratedError)', 'Interpreter', 'latex')
        ylim([0.95*min(s.PropTermPI_Tg) 1.05*max(s.PropTermPI_Tg)])        
        legend('Generator Torque Controller Integrative Term (KI*IntegratedError)', 'Interpreter', 'latex')
        title('Generator Torque Controller Integrative Term over time.')  
        %
    end



    % ---- Plot Active Damping Tower Top Design Parameters ----
    if s.Option04f8 < 3

        % Consider Active Tower Damping with a Tower Top feedback compensation strategy
        figure()     
        plot(s.Time,s.Xf_dot_filtered)
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        if s.Option04f8 == 1
            ylabel('${\dot{X}}_{t}$ [rad/s]', 'Interpreter', 'latex')
        else
            ylabel('${\dot{X}}_{p}$ [rad/s]', 'Interpreter', 'latex')
        end
        ylim([0.95*min(s.Xf_dot_filtered) 1.05*max(s.Xf_dot_filtered)])
        if s.Option04f8 == 1
            legend('Velocity (filtered and integrated) of tower top movement (${\dot{X}}_{t}$) [rad/s]', 'Interpreter', 'latex')
            title('Velocity (filtered and integrated) of tower top movement over time.') 
        else
            legend('Velocity (filtered and integrated) of platform pitch movement (${\dot{X}}_{p}$) [rad/s]', 'Interpreter', 'latex')
            title('Velocity (filtered and integrated) of platform pitch movement over time.') 
        end                        
        %    

        if s.Option10f8 == 3
            figure()     
            plot(s.Time,s.Kp_CS_Feedback)
            xlabel('t [seg]', 'Interpreter', 'latex')
            xlim([0 max(s.Time)])
            ylabel('​​Gain ($K_{TowerFeedback}$)', 'Interpreter', 'latex')
            ylim([0.95*min(s.Kp_CS_Feedback) 1.05*max(s.Kp_CS_Feedback)])        
            legend('Gain proportional to tower feedback ($K_{TowerFeedback}$)', 'Interpreter', 'latex')
            title('Gain proportional to tower feedback over time.') 
            %
            
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
        plot(s.Time, s.Fa_estPS, 'r-', 'LineWidth', 0.8);  % s.Fa_estPS
        hold off;     
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('$Fa$ [N]', 'Interpreter', 'latex')
        ylim([0.95*min([s.Fa s.Fa_estPS]) 1.05*max([s.Fa s.Fa_estPS])])        
        legend('Actual Aerodynamic Thrust, $Fa$', 'Estimated Aerodynamic Thrust, ${\hat{F}}_{a}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        title('Peak shaving analysis of estimated aerodynamic thrust over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex'); 
        %    
    end % if s.Option01f8 == 2


    % Further processing or end of the recursive calls
%=============================================================     
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'PIGainScheduledTSR', PIGainScheduledTSR);
assignin('base', 'GeneratorTorqueController', GeneratorTorqueController);
assignin('base', 'BladePitchController', BladePitchController);



% #######################################################################
end