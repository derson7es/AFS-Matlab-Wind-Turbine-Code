function EnviromentSimulation(action)
% ########## SIMULATION ENVIRONMENT ##########
% #############################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Oceanic 
% Engineering in 2025. Reviewed and supervised by Professor Dr. Helio 
% Mitio Morishita. Code developed in Matlab 2022b.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of July 2025.
% Last edition of this function of this Matlab file: 04 of July 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION:
% This recursive function contains all functions of the simulation environment of a wind turbine.


% ---------- Global Variables and Structures Array ----------
global s who t it it_c it_OS SimulationEnvironment WindTurbine_data Sensor WindTurbineOutput MeasurementCovariances ProcessCovariances BladePitchSystem GeneratorTorqueSystem PowerGeneration DriveTrainDynamics TowerDynamics RotorDynamics NacelleDynamics OffshoreAssembly AerodynamicModels BEM_Theory Wind_IEC614001_1 Waves_IEC614001_3 Currents_IEC614001_3 Controllers GeneratorTorqueController BladePitchController PIGainScheduledOTC PIGainScheduledTSR StateObserver KalmanFilter ExtendedKalmanFilter p q


who.VersionCode = 'Version 04082025: version updated and saved on August 04, 2025.';
s.VersionCode = who.VersionCode;
who.AboutCode = 'Code developed by Anderson Francisco Silva and reviewed by Dr. Helio Mitio Morishita. Developed in Matlab 2024b.';
s.AboutCode = who.AboutCode;


% ---------- Calling Logical Instance 01 of this function ----------
if nargin == 0
    t = 0;
    SimulationEnvironment.VersionCode = s.VersionCode; SimulationEnvironment.AboutCode = s.AboutCode;
    WindTurbine_data.VersionCode = s.VersionCode; WindTurbine_data.AboutCode = s.AboutCode;
    Sensor.VersionCode = s.VersionCode; Sensor.AboutCode = s.AboutCode;
    WindTurbineOutput.VersionCode = s.VersionCode; WindTurbineOutput.AboutCode = s.AboutCode;
    MeasurementCovariances.VersionCode = s.VersionCode; MeasurementCovariances.AboutCode = s.AboutCode;
    ProcessCovariances.VersionCode = s.VersionCode; ProcessCovariances.AboutCode = s.AboutCode;
    BladePitchSystem.VersionCode = s.VersionCode; BladePitchSystem.AboutCode = s.AboutCode;
    GeneratorTorqueSystem.VersionCode = s.VersionCode; GeneratorTorqueSystem.AboutCode = s.AboutCode;
    PowerGeneration.VersionCode = s.VersionCode; PowerGeneration.AboutCode = s.AboutCode;
    DriveTrainDynamics.VersionCode = s.VersionCode; DriveTrainDynamics.AboutCode = s.AboutCode;
    TowerDynamics.VersionCode = s.VersionCode; TowerDynamics.AboutCode = s.AboutCode;
    RotorDynamics.VersionCode = s.VersionCode; RotorDynamics.AboutCode = s.AboutCode;
    NacelleDynamics.VersionCode = s.VersionCode; NacelleDynamics.AboutCode = s.AboutCode;
    OffshoreAssembly.VersionCode = s.VersionCode; OffshoreAssembly.AboutCode = s.AboutCode;
    AerodynamicModels.VersionCode = s.VersionCode; AerodynamicModels.AboutCode = s.AboutCode;
    BEM_Theory.VersionCode = s.VersionCode; BEM_Theory.AboutCode = s.AboutCode;
    Wind_IEC614001_1.VersionCode = s.VersionCode; Wind_IEC614001_1.AboutCode = s.AboutCode;
    Waves_IEC614001_3.VersionCode = s.VersionCode; Waves_IEC614001_3.AboutCode = s.AboutCode;
    Currents_IEC614001_3.VersionCode = s.VersionCode; Currents_IEC614001_3.AboutCode = s.AboutCode;
    GeneratorTorqueController.VersionCode = s.VersionCode; GeneratorTorqueController.AboutCode = s.AboutCode;
    BladePitchController.VersionCode = s.VersionCode; BladePitchController.AboutCode = s.AboutCode;
    PIGainScheduledOTC.VersionCode = s.VersionCode; PIGainScheduledOTC.AboutCode = s.AboutCode;
    PIGainScheduledTSR.VersionCode = s.VersionCode; PIGainScheduledTSR.AboutCode = s.AboutCode;
    KalmanFilter.VersionCode = s.VersionCode; KalmanFilter.AboutCode = s.AboutCode;
    ExtendedKalmanFilter.VersionCode = s.VersionCode; ExtendedKalmanFilter.AboutCode = s.AboutCode;
    %
    action = 'logical_instance_01';
end


if strcmp(action, 'logical_instance_01')
%==================== LOGICAL INSTANCE 01 ====================
%=============================================================
    % DESIGN CHOICES, HYPOTHESES AND THEIR OPTIONS (OFFLINE):
    % Purpose of this Logical Instance: to define the option choices
    % related to this recursive function "EnviromentSimulation.m".


    % ---------- Option 01: Approach to Control and Actuators ----------
    who.Option01f1.Option_01 = 'Option 01 of Recursive Function f1';
    who.Option01f1.about = 'Approach to Control and Actuators';
    who.Option01f1.choose_01 = 's.Option01f1 == 1 to choose approach Gain-Scheduling Proportional-Integral (PI) controller and TSR algorithm, by Abbas (2022).';
    who.Option01f1.choose_02 = 's.Option01f1 == 2 to choose approach Gain-Scheduling Proportional-Integral (PI) controller and the OT algorithm, by Jonkman (2009).';
        % Choose your option:
    s.Option01f1 = 1;
    if s.Option01f1 == 1 || s.Option01f1 == 2
        s.Option01f1 = s.Option01f1; SimulationEnvironment.s.Option01f1 = s.Option01f1;
    else
        error('Invalid option selected for s.Option01f1. Please choose 1 or 2.');
    end


    % ---------- Option 02: Approach adopted for Estimation of Effective Wind Speed ----------
    who.Option02f1.Option_02 = 'Option 02 of Recursive Function f1';
    who.Option02f1.about = 'Approach adopted for Estimation of Effective Wind Speed';
    who.Option02f1.choose_01 = 's.Option02f1 == 1 to choose to State-Observer KALMAN FILTER and estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator.';
    who.Option02f1.choose_02 = 's.Option02f1 == 2 to choose to State-Observer EXTENDED KALMAN FILTER and estimate Effective Wind Speed ​​directly or online.';
        % Choose your option:
    s.Option02f1 = 1;
    if s.Option02f1 == 1 || s.Option02f1 == 2
        SimulationEnvironment.s.Option02f1 = s.Option02f1;
    else
        error('Invalid option selected for s.Option02f1. Please choose 1 or 2.');
    end


    % ---------- Initial Average Wind Speed at the height of the hub (last 10 minutes) ----------
    who.V_meanHub_0 = 'Initial Average Wind Speed at the height of the hub, in [m/s]';
    s.V_meanHub_0 = 15;


    % ---------- Option 03: Defining Wind Signal for Simulation ----------
    who.Option03f1.Option_03 = 'Option 03 of Recursive Function f1';
    who.Option03f1.about = 'Defining Wind Signal for Simulation, choosing random signals through the Turbulent Wind approach (Veers´s Methods or Transfer Functions Method) and deterministic signals.';
    who.Option03f1.choose_01 = 'option03f1 == 1 to choose Stochastic Signal, LOADING URBULENT WINDS, based on this code or other Wind Generator, for example TurbuSim (OpenFAST).';
    who.Option03f1.choose_02 = 'option03f1 == 2 to choose Stochastic Signal, GENERATING TURBULENT WINDS, based on Veers´s Methods and van der Hoven Spectrum Theory (1957), Kaimal spectrum and IEC 614001-1 Standard.';
    who.Option03f1.choose_03 = 'option03f1 == 3 to choose Stochastic Signal, GENERATING TURBULENT WINDS, based on Transfer Functions and van der Hoven Spectrum Theory (1957), Kaimal spectrum and IEC 614001-1 Standard.';
    who.Option03f1.choose_04 = 'option03f1 == 4 to choose Deterministic Signal, generating CONSTANT WIND Signal, V_meanHub_0 == constant.';
    who.Option03f1.choose_05 = 'option03f1 == 5 to choose Deterministic Signal, generating LINEAR INCREASING WIND Signal from V_meanHub_0.';
    who.Option03f1.choose_06 = 'option03f1 == 6 to choose Deterministic Signal, generating LINEAR DECREASING WIND Signal from V_meanHub_0.';
    who.Option03f1.choose_07 = 'option03f1 == 7 to choose Deterministic Signal, generating a CUSTOM WIND PROFILE Signal.';
        % Choose your option:
    s.Option03f1 = 2;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3 || s.Option03f1 == 4 || s.Option03f1 == 5 || s.Option03f1 == 6 || s.Option03f1 == 7               
        SimulationEnvironment.Option03f1 = s.Option03f1;
        
        if s.Option03f1 == 5          
            s.Vews_initial = 3;
            s.Vews_final = 25;   
            s.V_meanHub_0 = s.Vews_initial;
            SimulationEnvironment.Vews_initial = s.Vews_initial; SimulationEnvironment.Vews_final = s.Vews_final;
        elseif s.Option03f1 == 6         
            s.Vw_linear = 2;
            s.Vews_initial = 25;
            s.Vews_final = 3;   
            s.V_meanHub_0 = s.Vews_initial;
            SimulationEnvironment.Vews_initial = s.Vews_initial; SimulationEnvironment.Vews_final = s.Vews_final;            
        end
        SimulationEnvironment.V_meanHub_0 = s.V_meanHub_0 ;
        %
    else
        error('Invalid option selected for option03f1. Please choose 1 or 2 or 3 or 4 or 5 or 6 or 7.');
    end



    % ---------- Option 04: Defining Wave Signal for Simulation ----------
    who.Option04f1.Option_04 = 'Option 04 of Recursive Function f1';
    who.Option04f1.about = 'Defining Wave Signal for Simulation that will be generated from spectrum in file "System_WavesCurrentsIEC614001_3" or loaded from a file with a desired signal..';
    who.Option04f1.choose_01 = 's.Option04f1 == 1 to choose to Generate a Wave signal the spectrum (JONSWAP or Pierson-Moskowitz) and in accordance with the IEC 61400-3 standard.';
    who.Option04f1.choose_02 = 's.Option04f1 == 2 to choose to Load a desired Wave signal from a file.';
        % Choose your option:
    s.Option04f1 = 2;
    if s.Option04f1 == 1 || s.Option04f1 == 2
        SimulationEnvironment.s.Option04f1 = s.Option04f1;
    else
        error('Invalid option selected for s.Option04f1. Please choose 1 or 2.');
    end


    % ---------- Option 05: Comparison Test Option ----------
    who.Option05f1.Option_05 = 'Option 05 of Recursive Function f1';
    who.Option05f1.about = 'Comparison Test Option: simulate operation with the same wind, wave and system disturbance (noise) signals.';
    who.Option05f1.choose_01 = 's.Option05f1 == 1 to choose to Use THE SAME SIGNALS (wind, wave, noise) to perform comparisons between simulations.';
    who.Option05f1.choose_02 = 's.Option05f1 == 2 to choose to NOT use the same signals (wind, wave, noise) to perform comparisons between simulations.';
        % Choose your option:
    s.Option05f1 = 2;
    if s.Option05f1 == 1 || s.Option05f1 == 2
        SimulationEnvironment.s.Option05f1 = s.Option05f1;
    else
        error('Invalid option selected for s.Option05f1. Please choose 1 or 2.');
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % ---------- Know the others design choices, hypotheses and their options ----------
    WindTurbine;



    if s.Option01f1 == 1
        % Gain-Scheduling PI controller and TSR algorithm, by Abbas (2022)
        PIGainScheduledTSR_Abbas2022;

    elseif s.Option01f1 == 2
        % Gain-Scheduling PI controller and the OT algorithm, by Jonkman (2009)
        PIGainScheduledOTC_Jonkman2009;
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % Calling the next logic instance
    EnviromentSimulation('logical_instance_02');


elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================
    % SETTING KNOWN VALUES (OFFLINE) BASED ON CHOSEN OPTIONS:
    % Purpose of this Logical Instance: based on the choices of options
    % made in Logical Instances 01 of each Recursive Function (fi), all
    % known values will be calculated or defined offline. The term "offline"
    % refers to operations conducted before simulating the system.


    % ------------- Compararisson tests -----------
    if (s.Option05f1 == 1)
        % load('SameWind_FullSignal_6');
        load('SameWind_FullSignal_15_offshore');    
        s.V_meanHub_0 = V_meanHub_0;
        s.Vw_10SWL_comp = Vw_10SWL_comp;
        s.WindSpeed_Hub_comp = WindSpeed_Hub_comp;
        s.Uews_comp = Uews_comp;
        s.Uews_ref_comp = Uews_ref_comp;        
        s.PNoiseBeta_Dot_comp = PNoiseBeta_Dot_comp; 
        s.PNoiseOmegaR_Ddot_comp = PNoiseOmegaR_Ddot_comp;
        s.PNoiseTg_Dot_comp = PNoiseTg_Dot_comp;    
    end   


    % ---------- Total simulation time ----------
    who.tf = 'Total simulation time, in [s]';
    s.tf = 600;
    who.t = 'Simulation time, in [s]';
    t = 0;
    who.it = 'Current simulation interaction, in [dimensionless]';
    it = 1;
    it_c = 1;
    it_OS = 1;


    % ---##### Calculating and Obtaining Values ​​Offline #####-------
    WindTurbine('logical_instance_02');


    % ----------------- Initial System State --------------------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';

    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    s.y(1) = s.Beta_measured ;
    who.Beta_dot = 'Collective Blade Pitch Rate, in [deg/seg].';
    s.y(2) = s.Beta_dot_before ;

    who.Tg = 'Generator Torque, in [N.m]';
    s.y(3) = s.Tg_measured ;

    who.OmegaR= 'Rotor speed, in [rad/s].';
    s.y(4) = s.OmegaR_measured ;
    who.OmegaG= 'Generator speed, in [rad/s].';
    s.y(5) = s.OmegaG_measured ;
    who.Tls = 'Low speed shaft resistance torque, in [N.m].';
    s.y(6) = 0;

    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.y(7) = s.Xt_measured ; % s.Xt
    who.Xt_dot = 'Tower-top velocity in the Fore–Aft direction, in [m/s].';
    s.y(8) = s.Xt_dot_measured ; % s.Xt_dot

    who.zetaB = 'Angular Displacement out of the plane of rotation, in [rad]';
    s.y(9) = 0; % s.zetaB
    who.zetaB_dot = 'Angular Velocity out of the plane of rotation, in [rad/s]';
    s.y(10) = 0; % s.zetaB_dot


    who.RotorTeeter = 'Rotor inclination (Rotor-Teeter).';
    s.y(11) = 0; % s.RotorTeeter
    who.RotorFurl = 'Rotor inclination (Rotor-Teeter).';
    s.y(12) = 0; % s.RotorFurl
    who.RotorTail = 'Rotor inclination (Rotor-Teeter).';
    s.y(13) = 0; % s.RotorFurl
    who.ThetaYaw = 'Yaw angle, in [rad].';
    s.y(14) = 0; % s.ThetaYaw


    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.y(15) = s.Surge_measured ; % s.Surge
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.y(16) = s.Surge_dot_measured ; % s.Surge_dot

    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.y(17) = s.Sway_measured ; % s.Sway
    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.y(18) = s.Sway_dot_measured ; % s.Sway_dot

    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.y(19) = s.Heave_measured ; % s.Heave
    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.y(20) = s.Heave_dot_measured ; % s.Heave_dot

    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.y(21) = s.RollAngle_measured ; % s.RollAngle
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.y(22) = s.RollAngle_dot_measured ; % s.RollAngle_dot

    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad].';
    s.y(23) = s.PitchAngle_measured ; % s.PitchAngle
    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.y(24) = s.PitchAngle_dot_measured ; % s.PitchAngle_dot

    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.y(25) = s.YawAngle_measured ; % s.YawAngle
    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.y(26) = s.YawAngle_dot_measured ; % s.YawAngle_dot

    who.Ta_dot = 'Dynamics of Aerodynamic Torque for the Random Walk Model, in [N.m/s].';
    s.y(27) = interp1(s.Vop, s.Ta_op, s.Uews_full(1)); % s.Ta_dot    


    who.Nsyst = 'Number of state variables (dimension of the system of differential equations).';
    s.Nsyst = length(s.y) ;


        % Note: assuming a steady state at the initial instant.
    who.dy = 'First time derivative of the state variables.';
    s.dy = zeros(1, s.Nsyst);
    s.dy(7) = s.Xt_dot_measured;    
    s.dy(8) = s.Xt_Ddot_measured;    
    s.dy(15) = s.Surge_dot_measured ;
    s.dy(16) = s.Surge_Ddot_measured ;  
    s.dy(17) = s.Sway_dot_measured ;
    s.dy(18) = s.Sway_Ddot_measured ;    
    s.dy(19) = s.Heave_dot_measured ;
    s.dy(20) = s.Heave_Ddot_measured ; 
    s.dy(21) = s.RollAngle_dot_measured ;
    s.dy(22) = s.RollAngle_Ddot_measured ;    
    s.dy(23) = s.PitchAngle_dot_measured ;
    s.dy(24) = s.PitchAngle_Ddot_measured ; 
    s.dy(25) = s.YawAngle_dot_measured ;
    s.dy(26) = s.YawAngle_Ddot_measured ; 



    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';
           %      1           2         3          4             5          6          7       8          9            10            11                  12              13            14           15          16           17           18         19          20            21               22              23                24                25              26
    % s.dy = [s.Beta_dot s.Beta_Ddot s.Tg_dot s.OmegaR_dot s.OmegaG_dot s.Tls_dot s.Xt_dot s.Xt_Ddot s.zetaB_dot s.zetaB_Ddot s.RotorTeeter_dot s.RotorFurl_dot s.RotorTail_dot s.ThetaYaw_dot s.Surge_dot s.Surge_Ddot s.Sway_dot s.Sway_Ddot s.Heave_dot s.Heave_Ddot s.RollAngle_dot  s.RollAngle_Ddot s.PitchAngle_dot s.PitchAngle_Ddot s.YawAngle_dot s.YawAngle_Ddot];
    %

    % ---------- System Discretization for Numerical Simulation ----------
    who.dt = 'Time step for numerical integration, in [sec]. Defined as Wind sampling (s.SampleT_Wind), see WindTurbine_data_XXXXX.m file (after gerenting wind field).';
    SimulationEnvironment.dt = s.dt; % s.dt = s.SampleT_Wind
    who.Ns = 'Sampling Number. Defined as Wind sampling (s.SampleT_Wind), see WindTurbine_data_XXXXX.m file (after gerenting wind field).';
    SimulationEnvironment.Ns = s.Ns; % s.Ns = ceil(s.tf/s.dt) + 1

    who.Time = 'Time vector, in [sec]. Used in the simulation environment.';
    s.Time = 0:s.dt:s.tf;

    who.Counter_Integrator = 'Sampling counter of the Global Integrator Rk4, in [integers]. Used to call the Recursive Function of the Numerical Integrator.';
    s.Counter_Integrator = 0;


    % ---------- Receiving Samples Rate from Controllers and State Observer ----------
    who.Sample_RateOS = 'Sample Rate of the State Observer (Kalman Filter or Extended Kalman Filter , etc), in [s]';
    SimulationEnvironment.Sample_RateOS = s.Sample_RateOS;
    who.Sample_Rate_c = 'Sample Rate the Controllers, in [s]';
    SimulationEnvironment.Sample_Rate_c = s.Sample_Rate_c;

    who.Time_c = 'Control system sampling time vector, in [sec]. Used for sampling controllers.';
    s.Time_c = 0:s.Sample_Rate_c:s.tf;
    who.Counter_Controllers = 'Sampling counter of the Controllers, in [integers]. Used to call the Recursive Function of the Controllers.';
    for itt = 1:length(s.Time_c)
        s.Counter_Controllers(itt) = find( s.Time == s.Time_c(itt) ) ;
    end
    s.Counter_Controllers = s.Counter_Controllers(2:end);

    who.Time_OS = 'State Observer sampling time vector, in [sec]. Used for sampling controllers.';
    s.Time_OS = s.Time_c;
    who.Counter_StateObs = 'Sampling counter of the State Observer, in [integers]. Used to call the Recursive Function of the State Observer.';
    s.Counter_StateObs = [1 s.Counter_Controllers];

    s.nf = s.Nsyst;
    s.ntamos = 0;
    s.ntamos_c = 0;
    s.tamos = s.Sample_RateOS;
    s.ii = 0;
    s.ct = 0;
    s.ctmax = round(s.tamos/s.dt);
    s.tamos_c = s.Sample_Rate_c; 
    % if (s.Option01f1 == 2)
    %     s.tamos_c = s.Sample_Rate_c; % See VS_DT and PC_Dt Jonkman (2009)
    % else
    %     s.tamos_c = s.Sample_Rate_c; 
    % end
    s.ct_c = 0;
    s.ctmax_c = round(s.tamos_c/s.dt);
    s.ts_tamos = 0:s.Sample_RateOS:(s.Nsyst + s.dt);



    % Organizing output results
    SimulationEnvironment.tf = s.tf; SimulationEnvironment.it = it; SimulationEnvironment.it_c = it_c; SimulationEnvironment.t = t; SimulationEnvironment.Time = s.Time; SimulationEnvironment.Counter_Integrator = s.Counter_Integrator;
    SimulationEnvironment.Time_c = s.Time_c; SimulationEnvironment.Counter_Controllers = s.Counter_Controllers;
    SimulationEnvironment.Time_OS = s.Time_OS; SimulationEnvironment.Counter_StateObs = s.Counter_StateObs;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % Calling the next logic instance
    EnviromentSimulation('logical_instance_03');


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================
    % SIMULATION ENVIRONMENT AND PROCESS CENTER (ONLINE):
    % Purpose of this Logical Instance:manage the flow of logic instances,
    % supervise recursive function calls and flows, and facilitate the
    % simulation of the system's interactions with control systems and
    % state observers. This environment acts as the central hub where
    % these interactions are orchestrated through the flow between
    % Matlab functions.


    % --------- Simulation Loop/Flow ----------
    for it = 1:s.Ns
        tic % ii = it;


        % ---------- Calling Numerical Integrator "SIRK4th"  ----------
        EnviromentSimulation('logical_instance_04');


        % ------ Saving Controller and State Observer values (Output) -------
        if s.Option01f1 == 1
            % Gain-Scheduling Proportional Integrative with Tip-Speed-Ratio algorithm.
            PIGainScheduledTSR_Abbas2022('logical_instance_14');

            % ------ Selecting Effective Wind Speed ​​Estimation Approach -----
            if s.Option02f1 == 1
                % State-Observer KALMAN FILTER and estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator
                EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_13');
                %

            elseif s.Option02f1 == 2
                % State-Observer EXTENDED KALMAN FILTER and estimate Effective Wind Speed ​​directly or online
                ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_12');
            end
            %
        elseif s.Option01f1 == 2
            % Gain-Scheduling Proportional Integrative with Optimal-Torque-Control algorithm.
            PIGainScheduledOTC_Jonkman2009('logical_instance_12');
            %
        end


        % ------ Saving System values (Output) -------
        WindTurbine_MainAssembly('logical_instance_18');
        System_LoadsAerodynamics('logical_instance_07');
        if (s.Option02f2 > 1)
            % OFFSHORE WIND TURBINE
            WindTurbine('logical_instance_09');
        end

        %
        toc
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % Calling the next logic instance
    EnviromentSimulation('logical_instance_05');


%=============================================================
elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================
    % SIRK4th: SYSTEM SIMULATION NUMERICAL INTEGRATOR (ONLINE):
    % Purpose of this Logical Instance: This instance implements the numerical
    % integration of nonlinear differential equations using the 4th Order
    % Runge-Kutta method. The system equations represent the dynamics of a
    % wind turbine, including its subsystems, assemblies, and interactions
    % with external conditions such as wind speed, sea waves, and currents.
    % The integrator is used to simulate the real-time behavior of the system
    % and supports adaptive updates for control and state observation
    % during simulation.


    % --- Sampling of State Controllers and Observers -----
    s.newdt = 1; % Enter Kalman Filter and EWS Estimator.
    s.newdt_c = 1; % Enter the Controllers.


    % ---------- Wind Turbine System  ----------
    WindTurbine('logical_instance_04'); % Calculating the initial derivative


    % --- Sampling of State Controllers and Observers -----
   s.newdt = 0; % Do Not Enter the Kalman Filter
   s.newdt_c = 0; % Do Not Enter Controllers


   % --- Integration process 1 -----
   s.h = s.dt / 2;

   for j=1:s.Nsyst
      	s.Sy(j) = s.y(j) ;
        s.y0(j)= s.dy(j) ;
        s.y(j) = s.h * s.dy(j) + s.y(j);
   end

   t = t + s.h;


   % ---------- Wind Turbine System  ----------
   WindTurbine('logical_instance_04'); % Updating derivatives according to the system


   % --- Integration process 2 -----
   for j = 1:s.Nsyst
       s.y1(j) = s.dy(j) ;
       s.y(j) = s.Sy(j) + s.h * s.dy(j) ;
   end


   % ---------- Wind Turbine System  ----------
   WindTurbine('logical_instance_04'); % Updating derivatives according to the system


   % --- Integration process 3 -----
   for j=1:s.Nsyst
   	s.y2(j) = s.dy(j) ;
    s.y(j) = s.Sy(j) + s.dt * s.dy(j) ;
   end

   t = t + s.h;


   % ---------- Wind Turbine System  ----------
   WindTurbine('logical_instance_04');


   % --- Integration process 4 -----
   s.h = s.h/3;

   for j=1:s.Nsyst
       s.prt1 = 2*( s.y1(j) + s.y2(j) ) ;
       s.prt2 = s.y0(j) + s.dy(j) ;
       s.y(j) = s.Sy(j) + (s.h * s.prt1) + (s.h * s.prt2) ;
   end


    % Organizing output results
    SimulationEnvironment.y(it,:) = s.y; SimulationEnvironment.dy(it,:) = s.dy;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % Return to "EnviromentSimulation('logical_instance_03')"


elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================
    % DATA POST-PROCESSING (OFFLINE):
    % Purpose of this Logical Instance: to select the values ​​that will be
    % used to analyze the results and prepare them for other purposes
    % such as exporting, saving, etc.

    % ---- Receive saved values ​​from file "System_LoadsAerodynamics" ----
    s.VCsi_tower = AerodynamicModels.VCsi_tower;
    s.VCsi_blades = AerodynamicModels.VCsi_blades;
    s.VCsi_offshore = AerodynamicModels.VCsi_offshore;
    s.VCsi = AerodynamicModels.VCsi;
    s.Vews = AerodynamicModels.Vews;
    s.Uews = AerodynamicModels.Uews;
    s.Uews_ref = AerodynamicModels.Uews_ref;
    s.Lambda = AerodynamicModels.Lambda;
    s.Cp = AerodynamicModels.Cp;
    s.Ta = AerodynamicModels.Ta;
    s.Pa = AerodynamicModels.Pa;
    s.Ct = AerodynamicModels.Ct;
    s.Fa = AerodynamicModels.Fa;

    s.Time = linspace(0, s.tf , length(s.Vews) );


    % ---- Receive saved values ​​from file "WindTurbine_MainAssembly" ----
    s.Beta = BladePitchSystem.Beta;
    s.Beta_dot = BladePitchSystem.Beta_dot;
    s.Beta_Ddot = BladePitchSystem.Beta_Ddot;
    s.Tg = GeneratorTorqueSystem.Tg;
    s.Tg_dot = GeneratorTorqueSystem.Tg_dot;
    s.Pe = PowerGeneration.Pe;
    s.Pmec_loss = PowerGeneration.Pmec_loss;
    s.Pmec = PowerGeneration.Pmec;
    s.eta_elect = PowerGeneration.eta_elect;
    s.eta_cap = PowerGeneration.eta_cap;
    s.OmegaR = DriveTrainDynamics.OmegaR;
    s.OmegaR_dot = DriveTrainDynamics.OmegaR_dot;
    s.OmegaG = DriveTrainDynamics.OmegaG;
    s.OmegaG_dot = DriveTrainDynamics.OmegaG_dot;
    s.Tls = DriveTrainDynamics.Tls;
    s.Tls_dot = DriveTrainDynamics.Tls_dot;
    s.Ta_RWM = WindTurbineOutput.Ta_RWM;
    if s.Option04f3 == 1
        % Consider the TOWER DYNAMICS (fore-aft movement).
        s.Xt = TowerDynamics.Xt;
        s.Xt_dot = TowerDynamics.Xt_dot;
        s.Xt_Ddot = TowerDynamics.Xt_Ddot;
        %
    end
    if s.Option05f3 == 1
        % Consider the BLADE DYNAMICS (flap-wise blade bending).
        s.zetaB = RotorDynamics.zetaB;
        s.zetaB_dot = RotorDynamics.zetaB_dot;
        s.zetaB_Ddot = RotorDynamics.zetaB_Ddot;
        %
    end

    % ---- Receive saved values ​​from file "PIGainScheduledTSR_Abbas2022" or "PIGainScheduledOTC_Jonkman2009----
    if s.Option01f1 == 1
        % Gain-Scheduling Proportional-Integral (PI) controller and TSR algorithm, by Abbas (2022)
        Controllers = PIGainScheduledTSR;
    else
        % Gain-Scheduling Proportional-Integral (PI) controller and the OT algorithm, by Jonkman (2009)
        Controllers = PIGainScheduledOTC;
    end
    s.OmegaR_measured = Controllers.OmegaR_measured' ;
    s.OmegaG_measured = Controllers.OmegaG_measured' ;
    s.Beta_measured = Controllers.Beta_measured' ;
    s.Tg_measured = Controllers.Tg_measured' ;
    s.Pe_measured = Controllers.Pe_measured' ;
    s.WindSpedd_hub_measured = Controllers.WindSpedd_hub_measured' ;
    s.Xt_Ddot_measured = Controllers.Xt_Ddot_measured' ;
    if s.Option02f2 > 1
        % Offshore wind turbine
        s.Surge_Ddot_measured = Controllers.Surge_Ddot_measured' ;
        s.Sway_Ddot_measured = Controllers.Sway_Ddot_measured' ;
        s.Heave_Ddot_measured = Controllers.Heave_Ddot_measured' ;
        s.RollAngle_dot_measured = Controllers.RollAngle_dot_measured' ;
        s.PitchAngle_dot_measured = Controllers.PitchAngle_dot_measured' ;
        s.YawAngle_dot_measured = Controllers.YawAngle_dot_measured' ;
    end

    s.OmegaR_filtered = Controllers.OmegaR_filtered' ;
    s.OmegaG_filtered = Controllers.OmegaG_filtered' ;
    s.Beta_filtered = Controllers.Beta_filtered' ;
    s.Tg_filtered = Controllers.Tg_filtered' ;
    s.Vews_op = Controllers.Vews_op' ;

    s.Xt_Ddot_filtered = Controllers.Xt_Ddot_filtered' ;
    if (s.Option04f8 < 3)        
        if s.Option02f2 > 1
            s.Surge_Ddot_filtered = Controllers.Surge_Ddot_filtered' ;
            s.Sway_Ddot_filtered = Controllers.Sway_Ddot_filtered' ;
            s.Heave_Ddot_filtered = Controllers.Heave_Ddot_filtered' ;
            s.RollAngle_dot_filtered = Controllers.RollAngle_dot_filtered' ;
            s.PitchAngle_dot_filtered = Controllers.PitchAngle_dot_filtered' ;
            s.YawAngle_dot_filtered = Controllers.YawAngle_dot_filtered' ;
        end
    end

    s.GradTaBeta_dop = Controllers.GradTaBeta_dop' ;
    s.GradTaOmega_dop = Controllers.GradTaOmega_dop' ;
    s.GradTaVop_dop = Controllers.GradTaVop_dop' ;
    s.GradFaOmega_dop = Controllers.GradFaOmega_dop' ;
    s.GradFaVop_dop = Controllers.GradFaVop_dop' ;
    s.GradFaBeta_dop = Controllers.GradFaBeta_dop' ;
    s.Betad_op = Controllers.Betad_op' ;
    s.Tgd_op = Controllers.Tgd_op' ;
    s.OmegaRd_op = Controllers.OmegaRd_op' ;

    s.BetaMin_setup = BladePitchController.BetaMin_setup' ;
    s.OmegaRef_Tg = GeneratorTorqueController.OmegaRef_Tg' ;
    s.OmegaRef_Beta = BladePitchController.OmegaRef_Beta' ;
    s.OmegaRef = Controllers.OmegaRef' ;
    if s.Option06f8 == 2
        % SET POINT SMOOTHING (by Abbas 2022)
        s.Delta_Omega_filteredLPF3 = Controllers.Delta_Omega_filteredLPF3' ;
    end

    s.Xf_dot_filtered = Controllers.Xf_dot_filtered' ;
    s.Kp_CS_Feedback = Controllers.Kp_CS_Feedback' ;
    s.PropTerm_CS_Feedback = Controllers.PropTerm_CS_Feedback' ;

    s.Tg_d = GeneratorTorqueController.Tg_d' ;
    s.Tg_dDot = GeneratorTorqueController.Tg_dDot' ;
    s.Pe_d = GeneratorTorqueController.Pe_d_before' ;

    if s.Option01f1 == 1
        % Gain-Scheduling Proportional-Integral (PI) controller and TSR algorithm, by Abbas (2022)
        s.ErroTracking_Tgd = GeneratorTorqueController.ErroTracking_Tgd' ;
        s.Kp_piTg = GeneratorTorqueController.Kp_piTg' ;
        s.Ki_piTg = GeneratorTorqueController.Ki_piTg' ;
        s.PropTermPI_Tg = GeneratorTorqueController.PropTermPI_Tg' ;
    end

    s.Beta_d = BladePitchController.Beta_d' ;
    s.Beta_dDot = BladePitchController.Beta_dDot' ;
    s.ErroTracking_Betad = BladePitchController.ErroTracking_Betad' ;
    s.Kp_piBeta = BladePitchController.Kp_piBeta' ;
    s.Ki_piBeta = BladePitchController.Ki_piBeta' ;
    s.PropTermPI_Beta = BladePitchController.PropTermPI_Beta' ;


    % ---- Receive saved values ​​from file "PIGainScheduledTSR_Abbas2022" or "PIGainScheduledOTC_Jonkman2009----
    if s.Option01f1 == 1
        % Gain-Scheduling Proportional-Integral (PI) controller and TSR algorithm, by Abbas (2022)
        if s.Option02f1 == 1 && s.Option01f1 == 1
            % State-Observer KALMAN FILTER and estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator
            StateObserver = KalmanFilter;
        else
            % State-Observer EXTENDED KALMAN FILTER and estimate Effective Wind Speed ​​directly or online
            StateObserver = ExtendedKalmanFilter;
            s.Vt_est = ExtendedKalmanFilter.Vt_est' ;
            s.Vm_est = ExtendedKalmanFilter.Vm_est' ;
        end
        %
        s.Ta_est = StateObserver.Ta_est' ;
        s.Vews_est = StateObserver.Vews_est' ;       
        s.OmegaR_est = StateObserver.OmegaR_est' ;
    else
        s.Vews_op = Controllers.Vews_op' ;
        s.Vews_est = Controllers.Vews_op' ;
        s.OmegaR_est = Controllers.OmegaR_filtered' ;
    end


    s.Lambda_est = min(max( ((s.Rrd .* s.OmegaR_filtered) ./ s.Vews_est), s.Lambda_min), s.Lambda_max);
    s.Ct_est = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_est, s.Beta_d), 0), s.CT_max);
    s.Cp_est = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est, s.Beta_d), 0), s.CP_max);
    s.Ta_estC = 0.5.* s.rho .* pi .* s.Rrd.^2 .* s.Cp_est .* (1./s.OmegaR_filtered) .* s.Vews_est.^3;
    s.Pa_est = 0.5.*  s.rho .* pi .* s.Rrd.^2 .* s.Cp_est .* s.Vews_est.^3;
    s.Fa_est = 0.5.* s.rho .* pi .* s.Rrd.^2 .* s.Ct_est .* s.Vews_est.^2;

    if s.Option01f8 == 2
        % STRATEGY 2 (Peak Shaving)
        s.Ct_estPS = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_est, s.BetaMin_setup), 0), s.CT_max);
        s.Fa_estPS = 0.5.* s.rho .* pi .* s.Rrd.^2 .* s.Ct_estPS .* s.Vews_est.^2;
        %
    else
        s.Ct_estPS = s.Ct_est;
        s.Fa_estPS = s.Fa_est;
    end


    if s.Option02f2 == 2
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012)
        s.WindSpeed_BP = OffshoreAssembly.WindSpeed_BP;
        s.WindSpeed_BN = OffshoreAssembly.WindSpeed_BN;
        s.WindSpeed_BT = OffshoreAssembly.WindSpeed_BT;

        s.h_off = OffshoreAssembly.h_off;
        s.Xwa_i = OffshoreAssembly.Xwa_i;
        s.WaterDepthVector_i = OffshoreAssembly.WaterDepthVector_i;
        s.OmegaWa_n = OffshoreAssembly.OmegaWa_n;
        s.Kwa_n = OffshoreAssembly.Kwa_n;
        s.Phi_wa_n = OffshoreAssembly.Phi_wa_n;
        s.Vwa_iu = OffshoreAssembly.Vwa_iu;
        s.Vwa_iv = OffshoreAssembly.Vwa_iv;
        s.Vwa_iw = OffshoreAssembly.Vwa_iw;    
        s.Awa_iu = OffshoreAssembly.Awa_iu;
        s.Awa_iv = OffshoreAssembly.Awa_iv;
        s.Awa_iw = OffshoreAssembly.Awa_iw; 

        s.Qwe_surge = OffshoreAssembly.Qwe_surge;
        s.Qwe_heave = OffshoreAssembly.Qwe_heave;
        s.Qwe_pitch = OffshoreAssembly.Qwe_pitch;    
    
        s.hw_off = OffshoreAssembly.hw_off;
        s.DeltaHsub_off = OffshoreAssembly.DeltaHsub_off;
        s.Vg_off = OffshoreAssembly.Vg_off;
        s.hsub_off = OffshoreAssembly.hsub_off ;
        s.Vbt_off = OffshoreAssembly.Vbt_off;
        s.hpt_off = OffshoreAssembly.hpt_off;
        s.DSbott_CSoff = OffshoreAssembly.DSbott_CSoff;
        s.DG_off = OffshoreAssembly.DG_off; 
        s.Qb_surge = OffshoreAssembly.Qb_surge;
        s.Qb_heave = OffshoreAssembly.Qb_heave;
        s.Qb_pitch = OffshoreAssembly.Qb_pitch;  
  
        s.Vwind_in = OffshoreAssembly.Vwind_in;
        s.Vwind_out = OffshoreAssembly.Vwind_out;
        s.Delta_FAoff = OffshoreAssembly.Delta_FAoff; 
        s.FA_off = OffshoreAssembly.FA_off;
        s.FAN = OffshoreAssembly.FAN;
        s.FAT = OffshoreAssembly.FAT;
        s.Qwi_surge = OffshoreAssembly.Qwi_surge;
        s.Qwi_heave = OffshoreAssembly.Qwi_heave;
        s.Qwi_pitch = OffshoreAssembly.Qwi_pitch;
   
        s.hi_op_off = OffshoreAssembly.hi_op_off ;
        s.Vwater_x = OffshoreAssembly.Vwater_x;
        s.VwaterDot_x = OffshoreAssembly.VwaterDot_x;
        s.Vwater_y = OffshoreAssembly.Vwater_y;
        s.VwaterDot_y = OffshoreAssembly.VwaterDot_y;
        s.Vwater_Vbottomfloater_x = OffshoreAssembly.Vwater_Vbottomfloater_x; 
        s.Vwater_Vbottomfloater_y = OffshoreAssembly.Vwater_Vbottomfloater_y; 
        s.V_parallel = OffshoreAssembly.V_parallel;
        s.V_perpendicular = OffshoreAssembly.V_perpendicular;
        s.Vdot_perpendicular = OffshoreAssembly.Vdot_perpendicular;
        s.Vbottomfloater_perpendicular = OffshoreAssembly.Vbottomfloater_perpendicular ;
        s.Cdg_perpendicular = OffshoreAssembly.Cdg_perpendicular;    
        s.Cdg_parallel = OffshoreAssembly.Cdg_parallel;
        s.Qh_surge_i = OffshoreAssembly.Qh_surge_i ;
        s.Qh_heave_i = OffshoreAssembly.Qh_heave_i ;
        s.Qh_surge = OffshoreAssembly.Qh_surge ;
        s.Qh_heave = OffshoreAssembly.Qh_heave ;
        s.Qh_pitch = OffshoreAssembly.Qh_pitch ;
        s.Qwa_surge_i = OffshoreAssembly.Qwa_surge_i ;
        s.Qwa_heave_i = OffshoreAssembly.Qwa_heave_i ;
        s.Qwa_surge = OffshoreAssembly.Qwa_surge ;
        s.Qwa_heave = OffshoreAssembly.Qwa_heave ;
        s.Qwa_pitch = OffshoreAssembly.Qwa_pitch ;

        s.xml0_Betti = OffshoreAssembly.xml0_Betti;
        s.yml0_Betti = OffshoreAssembly.yml0_Betti;
        s.xml0B_Betti = OffshoreAssembly.xml0B_Betti;
        s.yml0B_Betti = OffshoreAssembly.yml0B_Betti;
        s.xml0_off = OffshoreAssembly.xml0_off;
        s.yml0_off = OffshoreAssembly.yml0_off;
        s.Theta_m_Chains12 = OffshoreAssembly.Theta_m_Chains12;
        s.CatenaryShape_a12 = OffshoreAssembly.CatenaryShape_a12;
        s.lmean_off = OffshoreAssembly.lmean_off;
        s.Delta_Lchain12 = OffshoreAssembly.Delta_Lchain12;
        s.x_catenary12 = OffshoreAssembly.x_catenary12;
        s.y_catenary12 = OffshoreAssembly.y_catenary12;
        s.F_chain12 = OffshoreAssembly.F_chain12;
        s.Fmlx_off = OffshoreAssembly.Fmlx_off;
        s.Fmly_off = OffshoreAssembly.Fmly_off;
        s.Qfm_surge = OffshoreAssembly.Qfm_surge;
        s.Qfm_heave = OffshoreAssembly.Qfm_heave;  
        s.xml0_Boff = OffshoreAssembly.xml0_Boff;
        s.yml0_Boff = OffshoreAssembly.yml0_Boff;
        s.Theta_m_Chains3 = OffshoreAssembly.Theta_m_Chains3;
        s.CatenaryShape_a3 = OffshoreAssembly.CatenaryShape_a3;
        s.lmean_Boff = OffshoreAssembly.lmean_Boff;
        s.Delta_Lchain3 = OffshoreAssembly.Delta_Lchain3;
        s.x_catenary3 = OffshoreAssembly.x_catenary3;
        s.y_catenary3 = OffshoreAssembly.y_catenary3;
        s.F_chain3 = OffshoreAssembly.F_chain3;
        s.Fmlx_Boff = OffshoreAssembly.Fmlx_Boff;
        s.Fmly_Boff = OffshoreAssembly.Fmly_Boff;
        s.Qbm_surge = OffshoreAssembly.Qbm_surge;
        s.Qbm_heave = OffshoreAssembly.Qbm_heave;         
        s.Qm_surge = OffshoreAssembly.Qm_surge;
        s.Qm_heave = OffshoreAssembly.Qm_heave;
        s.Qm_pitch = OffshoreAssembly.Qm_pitch;

        s.MX = OffshoreAssembly.MX;
        s.MY = OffshoreAssembly.MY;
        s.Md = OffshoreAssembly.Md;
        s.JJtot = OffshoreAssembly.JJtot;
        s.Q_surge = OffshoreAssembly.Q_surge;
        s.Q_heave = OffshoreAssembly.Q_heave;
        s.Q_pitch = OffshoreAssembly.Q_pitch;   

        s.PNoiseSurge_Ddot = OffshoreAssembly.PNoiseSurge_Ddot;  
        s.Surge = OffshoreAssembly.Surge;
        s.Surge_dot = OffshoreAssembly.Surge_dot;    
        s.Surge_Ddot = OffshoreAssembly.Surge_Ddot;

        s.PNoiseSway_Ddot = OffshoreAssembly.PNoiseSway_Ddot;
        s.Sway = OffshoreAssembly.Sway; 
        s.Sway_dot = OffshoreAssembly.Sway_dot; 
        s.Sway_Ddot = OffshoreAssembly.Sway_Ddot;

        s.PNoiseHeave_Ddot = OffshoreAssembly.PNoiseHeave_Ddot;
        s.Heave = OffshoreAssembly.Heave;  
        s.Heave_dot = OffshoreAssembly.Heave_dot; 
        s.Heave_Ddot = OffshoreAssembly.Heave_Ddot; 

        s.PNoiseRollAngle_Ddot = OffshoreAssembly.PNoiseRollAngle_Ddot;
        s.Gama_RollAngle = OffshoreAssembly.Gama_RollAngle;
        s.RollAngle = OffshoreAssembly.RollAngle; 
        s.RollAngle_dot = OffshoreAssembly.RollAngle_dot; 
        s.RollAngle_Ddot = OffshoreAssembly.RollAngle_Ddot;

        s.PNoisePitchAngle_Ddot = OffshoreAssembly.PNoisePitchAngle_Ddot;
        s.Gama_PitchAngle = OffshoreAssembly.Gama_PitchAngle; 
        s.PitchAngle = OffshoreAssembly.PitchAngle; 
        s.PitchAngle_dot= OffshoreAssembly.PitchAngle_dot;
        s.PitchAngle_Ddot = OffshoreAssembly.PitchAngle_Ddot;

        s.PNoiseYawAngle_Ddot = OffshoreAssembly.PNoiseYawAngle_Ddot;
        s.Gama_YawAngle = OffshoreAssembly.Gama_YawAngle;
        s.YawAngle = OffshoreAssembly.YawAngle; 
        s.YawAngle_dot = OffshoreAssembly.YawAngle_dot; 
        s.YawAngle_Ddot = OffshoreAssembly.YawAngle_Ddot; 

        s.C_Hydrostatic = OffshoreAssembly.C_Hydrostatic;
        s.C_Lines = OffshoreAssembly.C_Lines;
        s.B_Radiation = OffshoreAssembly.B_Radiation;
        s.B_Viscous = OffshoreAssembly.B_Viscous; 
        s.I_mass = OffshoreAssembly.I_mass; 
        s.A_Radiation = OffshoreAssembly.A_Radiation;      
        s.Option01f4 = 3; % PLot    
        %
    end


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

    % Calling the next logic instance
    EnviromentSimulation('logical_instance_06');


elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================
    % ANALYSIS OF THE RESULTS (OFFLINE):
    % Purpose of this Logical Instance: to analyses the results.

    % ---- Statistical analysis of EWS estimation ----     
    who.Erro_TimeEst = 'Estimation Error.';
    s.Erro_TimeEst = s.Vews  - s.Vews_est ;    
    who.mean_TimeEst = 'Mean Estimation Error (MEE).';
    s.mean_TimeEst = mean(s.Erro_TimeEst );
    who.mean_abs_err_TimeEst = 'Mean Absolute Error (MAE).';
    s.mean_abs_err_TimeEst = mean(abs(s.Erro_TimeEst)); 
    who.RMSE_TimeEst = 'Mean Square of the Error (Mean Square of the Error - RMSE).';
    s.RMSE_TimeEst = sqrt(mean(s.Erro_TimeEst.^2));  
    who.std_err_TimeEst = 'Standard Deviation of Error.';
    s.std_err_TimeEst = std(s.Erro_TimeEst); 
     

    % ---- Energy production analysis ----     
    who.E_aerodinamica_Wh = 'Power integration for aerodynamic energy, in [Wh].';
    s.E_aerodinamica_Wh = sum(s.Pa) * s.dt; 
    who.E_aerodinamica_Wh = 'Aerodynamic Power, in [MWh].';  
    s.E_aerodinamica_MWh = s.E_aerodinamica_Wh * (1e-6 / 3600) ;

    who.E_eletrica_Wh = 'Power integration for measured electrical energy, in [Wh].';
    s.E_eletrica_Wh = sum(s.Pe_measured) * s.dt; 
    who.E_aerodinamica_Wh = 'Electrical Power, in [MWh].';  
    s.E_eletrica_MWh = s.E_eletrica_Wh * (1e-6 / 3600) ;
    
    who.efficiency = 'Energy production efficiency, in [%].';    
    s.efficiency = ( s.E_eletrica_MWh / s.E_aerodinamica_MWh ) * 100 ;


    %#############################
    % ---- Salving values in Matlab file ----   
    Time_ws = s.Time_ws;
    Uews_rt = s.Uews_rt;
    Time = s.Time;
    V_meanHub_0 = s.V_meanHub_0;
    Vews = s.Vews;
    Uews = s.Uews;
    VCsi = s.VCsi;
    WindSpeed_Hub = s.WindSpeed_Hub;
    Vw_10SWL = s.Vw_10SWL;
    Uews_full = s.Uews_full;
    Uews_ref = s.Uews_ref;
    Vews_est = s.Vews_est;
    Beta = s.Beta;
    Beta_dot = s.Beta_dot;
    Tg = s.Tg;
    Tg_dot = s.Tg_dot ;
    OmegaR = s.OmegaR;
    Lambda = s.Lambda;
    Cp = s.Cp;
    Ta = s.Ta ;
    Pa = s.Pa;
    Ct = s.Ct;
    Fa = s.Fa;
    Beta_measured = s.Beta_measured ;
    Betad_op = s.Betad_op;
    Beta_d = s.Beta_d ;
    Beta_filtered = s.Beta_filtered ;
    Ta_est = s.Ta_est;
    OmegaR_est = s.OmegaR_est ;
    Tg_filtered = s.Tg_filtered ;
    Tg_measured = s.Tg_measured;
    Tgd_op = s.Tgd_op  ;    
    Tg_d = s.Tg_d ;
    Beta_dDot = s.Beta_dDot;  
    Pe_measured = s.Pe_measured ;
    eta_elect = s.eta_elect ;
    eta_cap = s.eta_cap ;   
    Fa_est = s.Fa_est ;
    Erro_TimeEst = s.Erro_TimeEst;
    mean_TimeEst = s.mean_TimeEst;
    mean_abs_err_TimeEst = s.mean_abs_err_TimeEst;
    RMSE_TimeEst = s.RMSE_TimeEst;
    std_err_TimeEst = s.std_err_TimeEst;
    if s.Option06f6 == 1
        Uews_comp = s.Uews_rt ;
    else
        Uews_comp = s.Uews_sp ;
    end    
    if s.Option01f8 == 2
        Fa_estPS = s.Fa_estPS ; % Peak Shaving
    else
        Fa_estPS = s.Fa_est;    
    end
    OmegaR_measured = s.OmegaR_measured;
    OmegaR_filtered = s.OmegaR_filtered;
    OmegaRd_op = s.OmegaRd_op;
    E_aerodinamica_MWh = s.E_aerodinamica_MWh;
    E_eletrica_MWh = s.E_eletrica_MWh;
    efficiency = s.efficiency;    
    E_aerodinamica_Wh = s.E_aerodinamica_Wh;
    E_aerodinamica_MWh = s.E_aerodinamica_MWh;
    E_eletrica_Wh = s.E_eletrica_Wh;
    E_eletrica_MWh = s.E_eletrica_MWh;
    efficiency = s.efficiency;
    BetaDot_max = s.BetaDot_max; 
    TgDot_max = s.TgDot_max;  
    eta_gb = s.eta_gb;
    Tg_dDot = s.Tg_dDot;
    OmegaRef = s.OmegaRef;
    Kp_piBeta = s.Kp_piBeta;
    Ki_piBeta = s.Ki_piBeta;
    AA_Beta = s.AA_Beta;
    BB_Beta = s.BB_Beta;
    tau_Beta = s.tau_Beta;

    save('TesteOffshore_FSKF15_Comp.mat','Time_ws','Time','V_meanHub_0','Vews', 'Uews','Uews_ref','VCsi','WindSpeed_Hub','Vw_10SWL','Vews_est', 'Beta', 'Beta_dot', 'Tg', 'Tg_dot', 'OmegaR', 'Lambda','Cp', 'Ta', 'Pa', 'Ct', 'Fa', 'Beta_measured', 'Betad_op','Beta_d', 'Beta_filtered', 'Ta_est', 'OmegaR_est','Tg_filtered','Tg_measured','Tgd_op','Tg_d','Beta_dDot','Pe_measured','eta_elect','eta_cap','Fa_est','Uews_rt','Uews_full','Erro_TimeEst','mean_TimeEst','mean_abs_err_TimeEst','RMSE_TimeEst','std_err_TimeEst','Uews_comp','Fa_estPS','OmegaR_measured','OmegaR_filtered','OmegaRd_op','mean_TimeEst','std_err_TimeEst','E_aerodinamica_Wh','E_aerodinamica_MWh','E_eletrica_Wh','E_eletrica_MWh','efficiency','BetaDot_max','TgDot_max','eta_gb','Tg_dDot','OmegaRef','Kp_piBeta','Ki_piBeta','AA_Beta','BB_Beta','tau_Beta');
        % clc; close all; clear all; clear global;    

        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012)
        WindSpeed_BP = s.WindSpeed_BP;
        WindSpeed_BN = s.WindSpeed_BN;
        WindSpeed_BT = s.WindSpeed_BT;

        h_off = s.h_off;
        Xwa_i = s.Xwa_i;
        WaterDepthVector_i = s.WaterDepthVector_i;
        OmegaWa_n = s.OmegaWa_n;
        Kwa_n = s.Kwa_n;
        Phi_wa_n = s.Phi_wa_n;
        Vwa_iu = s.Vwa_iu;
        Vwa_iv = s.Vwa_iv;
        Vwa_iw = s.Vwa_iw;    
        Awa_iu = s.Awa_iu;
        Awa_iv = s.Awa_iv;
        Awa_iw = s.Awa_iw; 

        Qwe_surge = s.Qwe_surge;
        Qwe_heave = s.Qwe_heave;
        Qwe_pitch = s.Qwe_pitch;    

        hw_off = s.hw_off;
        DeltaHsub_off = s.DeltaHsub_off;
        Vg_off = s.Vg_off;
        hsub_off = s.hsub_off ;
        Vbt_off = s.Vbt_off;
        hpt_off = s.hpt_off;
        DSbott_CSoff = s.DSbott_CSoff;
        DG_off = s.DG_off; 
        Qb_surge = s.Qb_surge;
        Qb_heave = s.Qb_heave;
        Qb_pitch = s.Qb_pitch;  

        Vwind_in = s.Vwind_in;
        Vwind_out = s.Vwind_out;
        Delta_FAoff = s.Delta_FAoff; 
        FA_off = s.FA_off;
        FAN = s.FAN;
        FAT = s.FAT;
        Qwi_surge = s.Qwi_surge;
        Qwi_heave = s.Qwi_heave;
        Qwi_pitch = s.Qwi_pitch;

        hi_op_off = s.hi_op_off ;
        Vwater_x = s.Vwater_x;
        VwaterDot_x = s.VwaterDot_x;
        Vwater_y = s.Vwater_y;
        VwaterDot_y = s.VwaterDot_y;
        Vwater_Vbottomfloater_x = s.Vwater_Vbottomfloater_x; 
        Vwater_Vbottomfloater_y = s.Vwater_Vbottomfloater_y; 
        V_parallel = s.V_parallel;
        V_perpendicular = s.V_perpendicular;
        Vdot_perpendicular = s.Vdot_perpendicular;
        Vbottomfloater_perpendicular = s.Vbottomfloater_perpendicular ;
        Cdg_perpendicular = s.Cdg_perpendicular;    
        Cdg_parallel = s.Cdg_parallel;
        Qh_surge_i = s.Qh_surge_i ;
        Qh_heave_i = s.Qh_heave_i ;
        Qh_surge = s.Qh_surge ;
        Qh_heave = s.Qh_heave ;
        Qh_pitch = s.Qh_pitch ;
        Qwa_surge_i = s.Qwa_surge_i ;
        Qwa_heave_i = s.Qwa_heave_i ;
        Qwa_surge = s.Qwa_surge ;
        Qwa_heave = s.Qwa_heave ;
        Qwa_pitch = s.Qwa_pitch ;

        xml0_Betti = s.xml0_Betti;
        yml0_Betti = s.yml0_Betti;
        xml0B_Betti = s.xml0B_Betti;
        yml0B_Betti = s.yml0B_Betti;
        xml0_off = s.xml0_off;
        yml0_off = s.yml0_off;
        Theta_m_Chains12 = s.Theta_m_Chains12;
        CatenaryShape_a12 = s.CatenaryShape_a12;
        lmean_off = s.lmean_off;
        Delta_Lchain12 = s.Delta_Lchain12;
        x_catenary12 = s.x_catenary12;
        y_catenary12 = s.y_catenary12;
        F_chain12 = s.F_chain12;
        Fmlx_off = s.Fmlx_off;
        Fmly_off = s.Fmly_off;
        Qfm_surge = s.Qfm_surge;
        Qfm_heave = s.Qfm_heave;  
        xml0_Boff = s.xml0_Boff;
        yml0_Boff = s.yml0_Boff;
        Theta_m_Chains3 = s.Theta_m_Chains3;
        CatenaryShape_a3 = s.CatenaryShape_a3;
        lmean_Boff = s.lmean_Boff;
        Delta_Lchain3 = s.Delta_Lchain3;
        x_catenary3 = s.x_catenary3;
        y_catenary3 = s.y_catenary3;
        F_chain3 = s.F_chain3;
        Fmlx_Boff = s.Fmlx_Boff;
        Fmly_Boff = s.Fmly_Boff;
        Qbm_surge = s.Qbm_surge;
        Qbm_heave = s.Qbm_heave;         
        Qm_surge = s.Qm_surge;
        Qm_heave = s.Qm_heave;
        Qm_pitch = s.Qm_pitch;

        MX = s.MX;
        MY = s.MY;
        Md = s.Md;
        JJtot = s.JJtot;
        Q_surge = s.Q_surge;
        Q_heave = s.Q_heave;
        Q_pitch = s.Q_pitch; 

        PNoiseSurge_Ddot = s.PNoiseSurge_Ddot;  
        Surge = s.Surge;
        Surge_dot = s.Surge_dot;    
        Surge_Ddot = s.Surge_Ddot;

        PNoiseSway_Ddot = s.PNoiseSway_Ddot;
        Sway = s.Sway; 
        Sway_dot = s.Sway_dot; 
        Sway_Ddot = s.Sway_Ddot;

        PNoiseHeave_Ddot = s.PNoiseHeave_Ddot;
        Heave = s.Heave;  
        Heave_dot = s.Heave_dot; 
        Heave_Ddot = s.Heave_Ddot; 

        PNoiseRollAngle_Ddot = s.PNoiseRollAngle_Ddot;
        Gama_RollAngle = s.Gama_RollAngle;
        RollAngle = s.RollAngle; 
        RollAngle_dot = s.RollAngle_dot; 
        RollAngle_Ddot = s.RollAngle_Ddot;

        PNoisePitchAngle_Ddot = s.PNoisePitchAngle_Ddot;
        Gama_PitchAngle = s.Gama_PitchAngle; 
        PitchAngle = s.PitchAngle; 
        PitchAngle_dot= s.PitchAngle_dot;
        PitchAngle_Ddot = s.PitchAngle_Ddot;

        PNoiseYawAngle_Ddot = s.PNoiseYawAngle_Ddot;
        Gama_YawAngle = s.Gama_YawAngle;
        YawAngle = s.YawAngle; 
        YawAngle_dot = s.YawAngle_dot; 
        YawAngle_Ddot = s.YawAngle_Ddot;

        C_Hydrostatic = s.C_Hydrostatic;
        C_Lines = s.C_Lines;
        B_Radiation = s.B_Radiation;
        B_Viscous = s.B_Viscous; 
        I_mass = s.I_mass; 
        A_Radiation = s.A_Radiation;      
        Option01f4 = 3; %  Plot  
        %
        save('TesteOffshore15_Comp.mat','WindSpeed_BP','WindSpeed_BN','WindSpeed_BT','h_off','Xwa_i','WaterDepthVector_i','OmegaWa_n','Kwa_n','Phi_wa_n','Vwa_iu','Vwa_iv','Vwa_iw','Awa_iu','Awa_iv','Awa_iw','PNoiseSurge_Ddot','Surge','PNoiseSway_Ddot','Sway','Sway_dot','Sway_Ddot','PNoiseHeave_Ddot','Heave','PNoiseRollAngle_Ddot','RollAngle','RollAngle_dot','RollAngle_Ddot','PNoisePitchAngle_Ddot','PitchAngle','PNoiseYawAngle_Ddot','YawAngle','YawAngle_dot','YawAngle_Ddot','Qwe_surge','Qwe_heave','Qwe_pitch','hw_off','DeltaHsub_off','Vg_off','hsub_off','Vbt_off','hpt_off','DSbott_CSoff','DG_off','Qb_surge','Qb_heave','Qb_pitch','Vwind_in','Vwind_out','Delta_FAoff','FA_off','FAN','FAT','Qwi_surge','Qwi_heave','Qwi_pitch','hi_op_off','Vwater_x','VwaterDot_x','Vwater_y','VwaterDot_y','Vwater_Vbottomfloater_x','Vwater_Vbottomfloater_y','V_parallel','V_perpendicular','Vdot_perpendicular','Vbottomfloater_perpendicular','Cdg_perpendicular','Cdg_parallel','Qh_surge_i','Qh_heave_i','Qh_surge','Qh_heave','Qh_pitch','Qwa_surge_i','Qwa_heave_i','Qwa_surge','Qwa_heave','Qwa_pitch','xml0_Betti','yml0_Betti','xml0B_Betti','yml0B_Betti','xml0_off','yml0_off','Theta_m_Chains12','CatenaryShape_a12','lmean_off','Delta_Lchain12','x_catenary12','y_catenary12','F_chain12','Fmlx_off','Fmly_off','Qfm_surge','Qfm_heave','xml0_Boff','yml0_Boff','Theta_m_Chains3','CatenaryShape_a3','lmean_Boff','Delta_Lchain3','x_catenary3','y_catenary3','F_chain3','Fmlx_Boff','Fmly_Boff','Qbm_surge','Qbm_heave','Qm_surge','Qm_heave','Qm_pitch','MX','MY','Md','JJtot','Q_surge','Q_heave','Q_pitch','Surge_dot','Surge_Ddot','Heave_dot','Heave_Ddot','PitchAngle_dot','PitchAngle_Ddot','C_Hydrostatic','C_Lines','B_Radiation','B_Viscous','I_mass','A_Radiation','Option01f4');
        %  



    disp('Simulation complete! Use Logical Instance 07 to plot results.')    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================
    % DATA PROCESSING: EXPORT OR IMPORT FILES (OFFLINE):
    % Purpose of this Logical Instance: to analyses the results.


    % ---- Salving values in Matlab file ----   
    Time_ws = s.Time_ws;
    Uews_rt = s.Uews_rt;
    Time = s.Time;
    V_meanHub_0 = s.V_meanHub_0;
    Vews = s.Vews;
    Uews = s.Uews;
    VCsi = s.VCsi;
    WindSpeed_Hub = s.WindSpeed_Hub;
    Vw_10SWL = s.Vw_10SWL;
    Uews_full = s.Uews_full;
    Uews_ref = s.Uews_ref;
    Vews_est = s.Vews_est;
    Beta = s.Beta;
    Beta_dot = s.Beta_dot;
    Tg = s.Tg;
    Tg_dot = s.Tg_dot ;
    OmegaR = s.OmegaR;
    Lambda = s.Lambda;
    Cp = s.Cp;
    Ta = s.Ta ;
    Pa = s.Pa;
    Ct = s.Ct;
    Fa = s.Fa;
    Beta_measured = s.Beta_measured ;
    Betad_op = s.Betad_op;
    Beta_d = s.Beta_d ;
    Beta_filtered = s.Beta_filtered ;
    Ta_est = s.Ta_est;
    OmegaR_est = s.OmegaR_est ;
    Tg_filtered = s.Tg_filtered ;
    Tg_measured = s.Tg_measured;
    Tgd_op = s.Tgd_op  ;    
    Tg_d = s.Tg_d ;
    Beta_dDot = s.Beta_dDot;  
    Pe_measured = s.Pe_measured ;
    eta_elect = s.eta_elect ;
    eta_cap = s.eta_cap ;   
    Fa_est = s.Fa_est ;
    Erro_TimeEst = s.Erro_TimeEst;
    mean_TimeEst = s.mean_TimeEst;
    mean_abs_err_TimeEst = s.mean_abs_err_TimeEst;
    RMSE_TimeEst = s.RMSE_TimeEst;
    std_err_TimeEst = s.std_err_TimeEst;
    if s.Option06f6 == 1
        Uews_comp = s.Uews_rt ;
    else
        Uews_comp = s.Uews_sp ;
    end    
    if s.Option01f8 == 2
        Fa_estPS = s.Fa_estPS ; % Peak Shaving
    else
        Fa_estPS = s.Fa_est;    
    end
    OmegaR_measured = s.OmegaR_measured;
    OmegaR_filtered = s.OmegaR_filtered;
    OmegaRd_op = s.OmegaRd_op;
    E_aerodinamica_MWh = s.E_aerodinamica_MWh;
    E_eletrica_MWh = s.E_eletrica_MWh;
    efficiency = s.efficiency;    
    E_aerodinamica_Wh = s.E_aerodinamica_Wh;
    E_aerodinamica_MWh = s.E_aerodinamica_MWh;
    E_eletrica_Wh = s.E_eletrica_Wh;
    E_eletrica_MWh = s.E_eletrica_MWh;
    efficiency = s.efficiency;
    BetaDot_max = s.BetaDot_max; 
    TgDot_max = s.TgDot_max;  
    eta_gb = s.eta_gb;
    Tg_dDot = s.Tg_dDot;
    OmegaRef = s.OmegaRef;
    Kp_piBeta = s.Kp_piBeta;
    Ki_piBeta = s.Ki_piBeta;
    AA_Beta = s.AA_Beta;
    BB_Beta = s.BB_Beta;
    tau_Beta = s.tau_Beta;

    save('TesteOffshore_FSKF15_Comp.mat','Time_ws','Time','V_meanHub_0','Vews', 'Uews','Uews_ref','VCsi','WindSpeed_Hub','Vw_10SWL','Vews_est', 'Beta', 'Beta_dot', 'Tg', 'Tg_dot', 'OmegaR', 'Lambda','Cp', 'Ta', 'Pa', 'Ct', 'Fa', 'Beta_measured', 'Betad_op','Beta_d', 'Beta_filtered', 'Ta_est', 'OmegaR_est','Tg_filtered','Tg_measured','Tgd_op','Tg_d','Beta_dDot','Pe_measured','eta_elect','eta_cap','Fa_est','Uews_rt','Uews_full','Erro_TimeEst','mean_TimeEst','mean_abs_err_TimeEst','RMSE_TimeEst','std_err_TimeEst','Uews_comp','Fa_estPS','OmegaR_measured','OmegaR_filtered','OmegaRd_op','mean_TimeEst','std_err_TimeEst','E_aerodinamica_Wh','E_aerodinamica_MWh','E_eletrica_Wh','E_eletrica_MWh','efficiency','BetaDot_max','TgDot_max','eta_gb','Tg_dDot','OmegaRef','Kp_piBeta','Ki_piBeta','AA_Beta','BB_Beta','tau_Beta');
        % clc; close all; clear all; clear global;


    % Comparison tests
    if (s.Option05f1 == 1)        
        V_meanHub_0 = s.V_meanHub_0;
        Uews_ref_comp = s.Uews_ref;
        Vw_10SWL_comp = s.Vw_10SWL;
        WindSpeed_Hub_comp = s.WindSpeed_Hub;
        if s.Option06f6 == 1
            Uews_comp = s.Uews_rt ;
        else
            Uews_comp = s.Uews_sp ;
        end
        PNoiseTg_Dot_comp = GeneratorTorqueSystem.PNoiseTg_Dot;        
        PNoiseBeta_Dot_comp = BladePitchSystem.PNoiseBeta_Dot; 
        PNoiseOmegaR_Ddot_comp = DriveTrainDynamics.PNoiseOmegaR_Ddot;
        save('SameWind_WindDecreasingLinearly.mat','Time_ws','Time','V_meanHub_0','Uews_ref_comp','Vw_10SWL_comp','WindSpeed_Hub_comp','Uews_comp','PNoiseTg_Dot_comp','PNoiseBeta_Dot_comp','PNoiseOmegaR_Ddot_comp')
        %
    end


    % Save generated wind
    if (s.Option05f1 == 1) 
        WindField_Grid = s.WindField_Grid;        
        Vm = s.Vm;
        Vm_Ugrid = s.Vm_Ugrid;        
        V_meanHub_0 = s.V_meanHub_0;
        Uews_sp = s.Uews_sp;    
        Uews_rt = s.Uews_rt;  
        save('SameWind_FullSignal_15_offshore.mat','Time_ws','Time','WindField_Grid','Vm','Vm_Ugrid','V_meanHub_0','Uews_sp','Uews_rt')
        %
    end    


    if s.Option02f2 > 1
        % Offshore
        vf_Jonswap = s.vf_Jonswap;
        vk_Jonswap = s.vk_Jonswap; 
        S_Jonswap = s.S_Jonswap;
        eta_Jonswap = s.eta_Jonswap ;        
        eta_Jonswap_x2 = s.eta_Jonswap_x2 ;
        eta_Jonswap_x3 = s.eta_Jonswap_x3;
        vt_sw = s.vt_sw;
        Hs_ws = s.Hs_ws ;
        Tp_ws = s.Tp_ws ;
        df_sw = s.df_sw ;
        fraw_eta = s.fraw_eta ;
        Sraw_eta = s.Sraw_eta  ;
        fBin_eta = s.fBin_eta ;
        SBin_eta = s.SBin_eta ;        
        PNoiseSurge_Ddot = s.PNoiseSurge_Ddot;  
        PNoiseSway_Ddot = s.PNoiseSway_Ddot;
        PNoiseHeave_Ddot = s.PNoiseHeave_Ddot;
        PNoiseRollAngle_Ddot = s.PNoiseRollAngle_Ddot;
        PNoisePitchAngle_Ddot = s.PNoisePitchAngle_Ddot; 
        PNoiseYawAngle_Ddot = s.PNoiseYawAngle_Ddot;

        save('SameWave_JONSWAP_Height6_Period10.mat','vf_Jonswap','vk_Jonswap','S_Jonswap','eta_Jonswap','eta_Jonswap_x2','eta_Jonswap_x3','Hs_ws','Tp_ws','df_sw','vt_sw','fraw_eta','Sraw_eta','fBin_eta','SBin_eta','PNoiseSurge_Ddot','PNoiseSway_Ddot','PNoiseHeave_Ddot','PNoiseRollAngle_Ddot','PNoisePitchAngle_Ddot','PNoiseYawAngle_Ddot');
        %
    end


    if s.Option02f2 == 2
        % OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012)
        WindSpeed_BP = s.WindSpeed_BP;
        WindSpeed_BN = s.WindSpeed_BN;
        WindSpeed_BT = s.WindSpeed_BT;

        h_off = s.h_off;
        Xwa_i = s.Xwa_i;
        WaterDepthVector_i = s.WaterDepthVector_i;
        OmegaWa_n = s.OmegaWa_n;
        Kwa_n = s.Kwa_n;
        Phi_wa_n = s.Phi_wa_n;
        Vwa_iu = s.Vwa_iu;
        Vwa_iv = s.Vwa_iv;
        Vwa_iw = s.Vwa_iw;    
        Awa_iu = s.Awa_iu;
        Awa_iv = s.Awa_iv;
        Awa_iw = s.Awa_iw; 

        Qwe_surge = s.Qwe_surge;
        Qwe_heave = s.Qwe_heave;
        Qwe_pitch = s.Qwe_pitch;    

        hw_off = s.hw_off;
        DeltaHsub_off = s.DeltaHsub_off;
        Vg_off = s.Vg_off;
        hsub_off = s.hsub_off ;
        Vbt_off = s.Vbt_off;
        hpt_off = s.hpt_off;
        DSbott_CSoff = s.DSbott_CSoff;
        DG_off = s.DG_off; 
        Qb_surge = s.Qb_surge;
        Qb_heave = s.Qb_heave;
        Qb_pitch = s.Qb_pitch;  

        Vwind_in = s.Vwind_in;
        Vwind_out = s.Vwind_out;
        Delta_FAoff = s.Delta_FAoff; 
        FA_off = s.FA_off;
        FAN = s.FAN;
        FAT = s.FAT;
        Qwi_surge = s.Qwi_surge;
        Qwi_heave = s.Qwi_heave;
        Qwi_pitch = s.Qwi_pitch;

        hi_op_off = s.hi_op_off ;
        Vwater_x = s.Vwater_x;
        VwaterDot_x = s.VwaterDot_x;
        Vwater_y = s.Vwater_y;
        VwaterDot_y = s.VwaterDot_y;
        Vwater_Vbottomfloater_x = s.Vwater_Vbottomfloater_x; 
        Vwater_Vbottomfloater_y = s.Vwater_Vbottomfloater_y; 
        V_parallel = s.V_parallel;
        V_perpendicular = s.V_perpendicular;
        Vdot_perpendicular = s.Vdot_perpendicular;
        Vbottomfloater_perpendicular = s.Vbottomfloater_perpendicular ;
        Cdg_perpendicular = s.Cdg_perpendicular;    
        Cdg_parallel = s.Cdg_parallel;
        Qh_surge_i = s.Qh_surge_i ;
        Qh_heave_i = s.Qh_heave_i ;
        Qh_surge = s.Qh_surge ;
        Qh_heave = s.Qh_heave ;
        Qh_pitch = s.Qh_pitch ;
        Qwa_surge_i = s.Qwa_surge_i ;
        Qwa_heave_i = s.Qwa_heave_i ;
        Qwa_surge = s.Qwa_surge ;
        Qwa_heave = s.Qwa_heave ;
        Qwa_pitch = s.Qwa_pitch ;

        xml0_Betti = s.xml0_Betti;
        yml0_Betti = s.yml0_Betti;
        xml0B_Betti = s.xml0B_Betti;
        yml0B_Betti = s.yml0B_Betti;
        xml0_off = s.xml0_off;
        yml0_off = s.yml0_off;
        Theta_m_Chains12 = s.Theta_m_Chains12;
        CatenaryShape_a12 = s.CatenaryShape_a12;
        lmean_off = s.lmean_off;
        Delta_Lchain12 = s.Delta_Lchain12;
        x_catenary12 = s.x_catenary12;
        y_catenary12 = s.y_catenary12;
        F_chain12 = s.F_chain12;
        Fmlx_off = s.Fmlx_off;
        Fmly_off = s.Fmly_off;
        Qfm_surge = s.Qfm_surge;
        Qfm_heave = s.Qfm_heave;  
        xml0_Boff = s.xml0_Boff;
        yml0_Boff = s.yml0_Boff;
        Theta_m_Chains3 = s.Theta_m_Chains3;
        CatenaryShape_a3 = s.CatenaryShape_a3;
        lmean_Boff = s.lmean_Boff;
        Delta_Lchain3 = s.Delta_Lchain3;
        x_catenary3 = s.x_catenary3;
        y_catenary3 = s.y_catenary3;
        F_chain3 = s.F_chain3;
        Fmlx_Boff = s.Fmlx_Boff;
        Fmly_Boff = s.Fmly_Boff;
        Qbm_surge = s.Qbm_surge;
        Qbm_heave = s.Qbm_heave;         
        Qm_surge = s.Qm_surge;
        Qm_heave = s.Qm_heave;
        Qm_pitch = s.Qm_pitch;

        MX = s.MX;
        MY = s.MY;
        Md = s.Md;
        JJtot = s.JJtot;
        Q_surge = s.Q_surge;
        Q_heave = s.Q_heave;
        Q_pitch = s.Q_pitch; 

        PNoiseSurge_Ddot = s.PNoiseSurge_Ddot;  
        Surge = s.Surge;
        Surge_dot = s.Surge_dot;    
        Surge_Ddot = s.Surge_Ddot;

        PNoiseSway_Ddot = s.PNoiseSway_Ddot;
        Sway = s.Sway; 
        Sway_dot = s.Sway_dot; 
        Sway_Ddot = s.Sway_Ddot;

        PNoiseHeave_Ddot = s.PNoiseHeave_Ddot;
        Heave = s.Heave;  
        Heave_dot = s.Heave_dot; 
        Heave_Ddot = s.Heave_Ddot; 

        PNoiseRollAngle_Ddot = s.PNoiseRollAngle_Ddot;
        Gama_RollAngle = s.Gama_RollAngle;
        RollAngle = s.RollAngle; 
        RollAngle_dot = s.RollAngle_dot; 
        RollAngle_Ddot = s.RollAngle_Ddot;

        PNoisePitchAngle_Ddot = s.PNoisePitchAngle_Ddot;
        Gama_PitchAngle = s.Gama_PitchAngle; 
        PitchAngle = s.PitchAngle; 
        PitchAngle_dot= s.PitchAngle_dot;
        PitchAngle_Ddot = s.PitchAngle_Ddot;

        PNoiseYawAngle_Ddot = s.PNoiseYawAngle_Ddot;
        Gama_YawAngle = s.Gama_YawAngle;
        YawAngle = s.YawAngle; 
        YawAngle_dot = s.YawAngle_dot; 
        YawAngle_Ddot = s.YawAngle_Ddot;

        C_Hydrostatic = s.C_Hydrostatic;
        C_Lines = s.C_Lines;
        B_Radiation = s.B_Radiation;
        B_Viscous = s.B_Viscous; 
        I_mass = s.I_mass; 
        A_Radiation = s.A_Radiation;      
        Option01f4 = 3; %  Plot  
        %
        save('TesteOffshore15_Comp.mat','WindSpeed_BP','WindSpeed_BN','WindSpeed_BT','h_off','Xwa_i','WaterDepthVector_i','OmegaWa_n','Kwa_n','Phi_wa_n','Vwa_iu','Vwa_iv','Vwa_iw','Awa_iu','Awa_iv','Awa_iw','PNoiseSurge_Ddot','Surge','PNoiseSway_Ddot','Sway','Sway_dot','Sway_Ddot','PNoiseHeave_Ddot','Heave','PNoiseRollAngle_Ddot','RollAngle','RollAngle_dot','RollAngle_Ddot','PNoisePitchAngle_Ddot','PitchAngle','PNoiseYawAngle_Ddot','YawAngle','YawAngle_dot','YawAngle_Ddot','Qwe_surge','Qwe_heave','Qwe_pitch','hw_off','DeltaHsub_off','Vg_off','hsub_off','Vbt_off','hpt_off','DSbott_CSoff','DG_off','Qb_surge','Qb_heave','Qb_pitch','Vwind_in','Vwind_out','Delta_FAoff','FA_off','FAN','FAT','Qwi_surge','Qwi_heave','Qwi_pitch','hi_op_off','Vwater_x','VwaterDot_x','Vwater_y','VwaterDot_y','Vwater_Vbottomfloater_x','Vwater_Vbottomfloater_y','V_parallel','V_perpendicular','Vdot_perpendicular','Vbottomfloater_perpendicular','Cdg_perpendicular','Cdg_parallel','Qh_surge_i','Qh_heave_i','Qh_surge','Qh_heave','Qh_pitch','Qwa_surge_i','Qwa_heave_i','Qwa_surge','Qwa_heave','Qwa_pitch','xml0_Betti','yml0_Betti','xml0B_Betti','yml0B_Betti','xml0_off','yml0_off','Theta_m_Chains12','CatenaryShape_a12','lmean_off','Delta_Lchain12','x_catenary12','y_catenary12','F_chain12','Fmlx_off','Fmly_off','Qfm_surge','Qfm_heave','xml0_Boff','yml0_Boff','Theta_m_Chains3','CatenaryShape_a3','lmean_Boff','Delta_Lchain3','x_catenary3','y_catenary3','F_chain3','Fmlx_Boff','Fmly_Boff','Qbm_surge','Qbm_heave','Qm_surge','Qm_heave','Qm_pitch','MX','MY','Md','JJtot','Q_surge','Q_heave','Q_pitch','Surge_dot','Surge_Ddot','Heave_dot','Heave_Ddot','PitchAngle_dot','PitchAngle_Ddot','C_Hydrostatic','C_Lines','B_Radiation','B_Viscous','I_mass','A_Radiation','Option01f4');
        %    
        % TesteOffshoreFS15_Controle
        % TesteOffshore15_SemC
    end


                       % ######### %

    % ---- Receving values from upload file ----  
    load('TesteOnshore_FullSignal_KF_8');      
    s.Loadd = 4;
    if s.Loadd == 1
        q.Time_ws = Time_ws;
        q.Uews_rt = Uews_rt;        
        q.Time = Time;     
        q.V_meanHub_0 = V_meanHub_0;
        q.Vews = Vews;
        q.Uews = Uews;
        q.Uews_ref = Uews_ref;          
        q.VCsi = VCsi;
        q.WindSpeed_Hub = WindSpeed_Hub;
        q.Vw_10SWL = Vw_10SWL;
        q.Uews_full = Uews_full;
        q.Vews_est = Vews_est;
        q.Beta = Beta;
        q.Beta_dot = Beta_dot;
        q.Tg = Tg;
        q.Tg_dot = Tg_dot ;
        q.OmegaR = OmegaR;
        q.Lambda = Lambda;
        q.Cp = Cp;
        q.Ta = Ta ;
        q.Pa = Pa;
        q.Ct = Ct;
        q.Fa = Fa;
        q.Beta_measured = Beta_measured ;
        q.Betad_op = Betad_op;
        q.Beta_d = Beta_d ;
        q.Beta_filtered = Beta_filtered ;
        q.Ta_est = Ta_est;
        q.OmegaR_est = OmegaR_est ;
        q.Tg_filtered = Tg_filtered ;
        q.Tg_measured = Tg_measured;
        q.Tgd_op = Tgd_op  ;    
        q.Tg_d = Tg_d ;
        q.Beta_dDot = Beta_dDot;  
        q.Pe_measured = Pe_measured ;
        q.eta_elect = eta_elect ;
        q.eta_cap = eta_cap ;   
        q.Fa_est = Fa_est ;
        q.mean_TimeEst = mean_TimeEst ;
        q.std_err_TimeEst = std_err_TimeEst; 
        q.Uews_comp = Uews_comp;
        q.Fa_estPS = Fa_estPS;  
        q.OmegaR_measured = OmegaR_measured;
        q.OmegaR_filtered = OmegaR_filtered;
        q.OmegaRd_op = OmegaRd_op;
        q.Erro_TimeEst = Erro_TimeEst;
        q.mean_TimeEst = mean_TimeEst;
        q.mean_abs_err_TimeEst = mean_abs_err_TimeEst;
        q.RMSE_TimeEst = RMSE_TimeEst;
        q.std_err_TimeEst = std_err_TimeEst;
        q.E_aerodinamica_Wh = E_aerodinamica_Wh;
        q.E_aerodinamica_MWh = E_aerodinamica_MWh;
        q.E_eletrica_Wh = E_eletrica_Wh;
        q.E_eletrica_MWh = E_eletrica_MWh;
        q.efficiency = efficiency;
        q.BetaDot_max = BetaDot_max; 
        q.TgDot_max = TgDot_max;  
        q.eta_gb = eta_gb;
        q.Tg_dDot = Tg_dDot;
        q.OmegaRef = OmegaRef; 
        q.Kp_piBeta = Kp_piBeta;
        q.Ki_piBeta = Ki_piBeta;
        q.AA_Beta = AA_Beta;   
        q.BB_Beta = BB_Beta;
        q.tau_Beta = tau_Beta;        
        %
    elseif s.Loadd == 2
        p.Time_ws = Time_ws;
        p.Uews_rt = Uews_rt;        
        p.Time = Time;     
        p.V_meanHub_0 = V_meanHub_0;
        p.Vews = Vews;
        p.Uews = Uews;
        p.Uews_ref = Uews_ref;          
        p.VCsi = VCsi;
        p.WindSpeed_Hub = WindSpeed_Hub;
        p.Vw_10SWL = Vw_10SWL;
        p.Uews_full = Uews_full;
        p.Vews_est = Vews_est;
        p.Beta = Beta;
        p.Beta_dot = Beta_dot;
        p.Tg = Tg;
        p.Tg_dot = Tg_dot ;
        p.OmegaR = OmegaR;
        p.Lambda = Lambda;
        p.Cp = Cp;
        p.Ta = Ta ;
        p.Pa = Pa;
        p.Ct = Ct;
        p.Fa = Fa;
        p.Beta_measured = Beta_measured ;
        p.Betad_op = Betad_op;
        p.Beta_d = Beta_d ;
        p.Beta_filtered = Beta_filtered ;
        p.Ta_est = Ta_est;
        p.OmegaR_est = OmegaR_est ;
        p.Tg_filtered = Tg_filtered ;
        p.Tg_measured = Tg_measured;
        p.Tgd_op = Tgd_op  ;    
        p.Tg_d = Tg_d ;
        p.Beta_dDot = Beta_dDot;  
        p.Pe_measured = Pe_measured ;
        p.eta_elect = eta_elect ;
        p.eta_cap = eta_cap ;   
        p.Fa_est = Fa_est ;
        p.mean_TimeEst = mean_TimeEst ;
        p.std_err_TimeEst = std_err_TimeEst; 
        p.Uews_comp = Uews_comp;
        p.Fa_estPS = Fa_estPS;  
        p.OmegaR_measured = OmegaR_measured;
        p.OmegaR_filtered = OmegaR_filtered;
        p.OmegaRd_op = OmegaRd_op;
        p.Erro_TimeEst = Erro_TimeEst;
        p.mean_TimeEst = mean_TimeEst;
        p.mean_abs_err_TimeEst = mean_abs_err_TimeEst;
        p.RMSE_TimeEst = RMSE_TimeEst;
        p.std_err_TimeEst = std_err_TimeEst;
        p.E_aerodinamica_Wh = E_aerodinamica_Wh;
        p.E_aerodinamica_MWh = E_aerodinamica_MWh;
        p.E_eletrica_Wh = E_eletrica_Wh;
        p.E_eletrica_MWh = E_eletrica_MWh;
        p.efficiency = efficiency;
        p.BetaDot_max = BetaDot_max; 
        p.TgDot_max = TgDot_max;  
        p.eta_gb = eta_gb;
        p.Tg_dDot = Tg_dDot;
        p.OmegaRef = OmegaRef; 
        p.Kp_piBeta = Kp_piBeta;
        p.Ki_piBeta = Ki_piBeta;
        p.AA_Beta = AA_Beta;   
        p.BB_Beta = BB_Beta;
        p.tau_Beta = tau_Beta;          
        %
    elseif s.Loadd == 3
        s.Time_ws = Time_ws;
        s.Uews_rt = Uews_rt;        
        s.Time = Time;     
        s.V_meanHub_0 = V_meanHub_0;
        s.Vews = Vews;
        s.Uews = Uews;
        s.Uews_ref = Uews_ref;          
        s.VCsi = VCsi;
        s.WindSpeed_Hub = WindSpeed_Hub;
        s.Vw_10SWL = Vw_10SWL;
        s.Uews_full = Uews_full;
        s.Vews_est = Vews_est;
        s.Beta = Beta;
        s.Beta_dot = Beta_dot;
        s.Tg = Tg;
        s.Tg_dot = Tg_dot ;
        s.OmegaR = OmegaR;
        s.Lambda = Lambda;
        s.Cp = Cp;
        s.Ta = Ta ;
        s.Pa = Pa;
        s.Ct = Ct;
        s.Fa = Fa;
        s.Beta_measured = Beta_measured ;
        s.Betad_op = Betad_op;
        s.Beta_d = Beta_d ;
        s.Beta_filtered = Beta_filtered ;
        s.Ta_est = Ta_est;
        s.OmegaR_est = OmegaR_est ;
        s.Tg_filtered = Tg_filtered ;
        s.Tg_measured = Tg_measured;
        s.Tgd_op = Tgd_op  ;    
        s.Tg_d = Tg_d ;
        s.Beta_dDot = Beta_dDot;  
        s.Pe_measured = Pe_measured ;
        s.eta_elect = eta_elect ;
        s.eta_cap = eta_cap ;   
        s.Fa_est = Fa_est ;
        s.mean_TimeEst = mean_TimeEst ;
        s.std_err_TimeEst = std_err_TimeEst; 
        s.Uews_comp = Uews_comp;
        s.Fa_estPS = Fa_estPS;  
        s.OmegaR_measured = OmegaR_measured;
        s.OmegaR_filtered = OmegaR_filtered;
        s.OmegaRd_op = OmegaRd_op;
        s.Erro_TimeEst = Erro_TimeEst;
        s.mean_TimeEst = mean_TimeEst;
        s.mean_abs_err_TimeEst = mean_abs_err_TimeEst;
        s.RMSE_TimeEst = RMSE_TimeEst;
        s.std_err_TimeEst = std_err_TimeEst;
        s.E_aerodinamica_Wh = E_aerodinamica_Wh;
        s.E_aerodinamica_MWh = E_aerodinamica_MWh;
        s.E_eletrica_Wh = E_eletrica_Wh;
        s.E_eletrica_MWh = E_eletrica_MWh;
        s.efficiency = efficiency;
        s.BetaDot_max = BetaDot_max; 
        s.TgDot_max = TgDot_max;  
        s.eta_gb = eta_gb;
        s.Tg_dDot = Tg_dDot;
        s.OmegaRef = OmegaRef; 
        s.Kp_piBeta = Kp_piBeta;
        s.Ki_piBeta = Ki_piBeta;
        s.AA_Beta = AA_Beta;   
        s.BB_Beta = BB_Beta;
        s.tau_Beta = tau_Beta;
        %        
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'p', p);    
    assignin('base', 'q', q);     



elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================
    % PLOT RESULTS (OFFLINE):
    % Purpose of this Logical Instance: to select the results that will
    % be plotted. By default, the respective figures constructed in the
    % code are in their respective function file (m.file), but eventually
    % any figure can be plotted in this logical instance as well. Feel
    % free to set up your analysis.
    
 
    % clc; close all; clear all; clear global;

    % ---- Plot results of  "WindTurbine_MainAssembly" ----
    WindTurbine_MainAssembly('logical_instance_19');


    % ---- Plot results of  "System_LoadsAerodynamics" ----
    System_LoadsAerodynamics('logical_instance_08');
    
    if (s.Option02f2 > 1)
        % OFFSHORE WIND TURBINE
        WindTurbine('logical_instance_10');
    end


    % ---- Plot results of "Control" ----
    if s.Option01f1 == 1
        % Gain-Scheduling Proportional Integrative with Tip-Speed-Ratio algorithm.
        PIGainScheduledTSR_Abbas2022('logical_instance_15');
        %
    elseif s.Option01f1 == 2
        % Gain-Scheduling Proportional Integrative with Optimal-Torque-Control algorithm.
        PIGainScheduledOTC_Jonkman2009('logical_instance_13');
        %
    end


    % ---- Plot results of "Observer State" ----
    if s.Option02f1 == 1 && s.Option01f1 == 1
        % State-Observer KALMAN FILTER and estimate Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator
        EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_14');
        %
    elseif s.Option02f1 == 2 && s.Option01f1 == 1
        % State-Observer EXTENDED KALMAN FILTER and estimate Effective Wind Speed ​​directly or online
        ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_13');
        %
    end


    disp('To export data, use Logical Instance 07.') 
    % EnviromentSimulation('logical_instance_07');

    disp('To clear all, use the bellow comand.') 
    % clc; close all; clear all; clear global;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    

    % Further processing or end of the recursive calls

%=============================================================
end

    % clc; close all; clear all; clear global;

% #######################################################################
end