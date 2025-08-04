function WindTurbine(action)
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
% Represent the wind turbine (system), organize the sub functions that will
% represent the wind turbine components, the disturbances applied to the 
% system, its response (simulation integrator output), the sensors, the data
% and characteristics of the dynamics related to the efforts and interactions
% involving the wind turbine.


% ---------- Global Variables and Structures Array ----------
global s who t it it_c SimulationEnvironment WindTurbine_data Sensor WindTurbineOutput MeasurementCovariances ProcessCovariances BladePitchSystem GeneratorTorqueSystem PowerGeneration DriveTrainDynamics TowerDynamics RotorDynamics NacelleDynamics OffshoreAssembly AerodynamicModels BEM_Theory Wind_IEC614001_1 Waves_IEC614001_3 Currents_IEC614001_3 GeneratorTorqueController BladePitchController PIGainScheduledOTC PIGainScheduledTSR KalmanFilter ExtendedKalmanFilter


% ---------- Calling Logical Instance 01 of this function ----------
if nargin == 0
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 't', t);
    assignin('base', 'it', it);     
    assignin('base', 'it_c', it_c);    
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
    % DESIGN CHOICES, HYPOTHESES AND THEIR OPTIONS (OFFLINE):  
    % Purpose of this Logical Instance: to define the option choices 
    % related to this recursive function "EnviromentSimulation.m". 


    % ---------- Option 01: Wind Turbine baseline adopted/inspired (NREL-5MW or IEA-15MW) ----------
    who.Option01f2.Option_01 = 'Option 01 of Recursive Function f1';
    who.Option01f2.about = 'Baseline Wind Turbine Adopted (NREL-5MW or IEA-15MW)';
    who.Option01f2.choose_01 = 's.Option01f2 == 1 to choose the NREL-5MW baseline wind turbine';
    who.Option01f2.choose_02 = 's.Option01f2 == 2 to choose the IEA-15MW baseline wind turbine';
    who.Option01f2.choose_03 = 's.Option01f2 == 3 to choose the DUT-10MW baseline wind turbine';  
        % Choose your option:
    s.Option01f2 = 1; 
    if s.Option01f2 == 1 || s.Option01f2 == 2  || s.Option01f2 == 3
        SimulationEnvironment.Option01f2 = s.Option01f2;
    else
        error('Invalid option selected for s.Option01f2. Please choose 1 or 2 or 3.');
    end   


    % ---------- Option 02: Wind Turbine Type ----------
    who.Option02f2.Option_02 = 'Option 02 of Recursive Function f1';
    who.Option02f2.about = 'The type of wind turbine, choosing offshore or onshore assembly.';
    who.Option02f2.choose_01 = 's.Option02f2 == 1 to choose ONSHORE WIND TURBINE.';
    who.Option02f2.choose_02 = 's.Option02f2 == 2 to choose OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012).'; 
    who.Option02f2.choose_03 = 's.Option02f2 == 3 to choose OFFSHORE WIND TURBINE: Floating Wind Turbine with Spar Buoy Platform.'; 
    who.Option02f2.choose_04 = 's.Option02f2 == 4 to choose OFFSHORE WIND TURBINE: Floating Wind Turbine with Submersible Platform.'; 
    who.Option02f2.choose_05 = 's.Option02f2 == 5 to choose OFFSHORE WIND TURBINE: Floating Wind Turbine with Barge Platform.'; 
    who.Option02f2.choose_06 = 's.Option02f2 == 6 to choose OFFSHORE WIND TURBINE: Fixed-Bottom Offshore Wind Turbine.';     
        % Choose your option:
    s.Option02f2 = 2; 
    if s.Option02f2 == 1 || s.Option02f2 == 2 || s.Option02f2 == 3 || s.Option02f2 == 4 || s.Option02f2 == 5 || s.Option02f2 == 6
        SimulationEnvironment.Option02f2 = s.Option02f2;
    else
        error('Invalid option selected for s.Option01f2. Please choose 1 or 2 or 3 or 4 or 5 or 6.');
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);


    % Calling the next logic instance 
    WindTurbine_MainAssembly;


elseif strcmp(action, 'logical_instance_02')    
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SELECTING A REFERENCE WIND TURBINE (OFFLINE):
    % Purpose of this Logical Instance: based on the choice made by the 
    % "Option01f1" option, a reference wind turbine was defined, where
    % the values ​​presented here are the same adopted in the work of 
    % Jonkman (2009) and in the OpenFast/ROSCO tool by the author Abbas
    % (2022) and NREL. In this code, we leave two reference wind turbine
    % options, NREL-5MW and IEA-15MW.

    
    % ---------- Selecting Baseline Wind Turbine  ----------

    if s.Option01f2 == 1 
        % NREL-5MW
        WindTurbineData_NREL5MW;
        %
    elseif s.Option01f2 == 2
        % IEA-15MW
        WindTurbineData_IEA15MW;
        %
    elseif s.Option01f2 == 3 
        % DUT-10MW
        WindTurbineData_DTU10MW;
        %
    end  
    

    % Calling the next logic instance   
    WindTurbine('logical_instance_03');  

    

elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================       
    % SYSTEM DISTURBANCES (OFFLINE):
    % Purpose of this Logical Instance: to represent system disturbances 
    % that occur in processes and measurements/sensors. The disturbances 
    % are generated by white noise with process covariances defined in 
    % this Logical Instance. Measurement covariances are based on 
    % "Standard Deviation" data from instruments/sensors or as recommended 
    % in the literature. Process covariances are adopted considering values
    % ​​calculated from wind speed, considering an error of 2 [m/s] or 
    % considering a fraction of the maximum limits of the wind turbine.


    % ---------- Unperturbed process covariance analysis ----------
    p.WindSpeed_Hub = s.WindSpeed_Hub;
    p.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Uews_full); % plot(p.OmegaR)
    p.StandardDeviationP_OmegaR = std(p.OmegaR) ; % Partial Load Operation is 0.0015 and Full Load Operation is 0.0015
    p.Beta = interp1(s.Vop, s.Beta_op, s.Uews_full); % plot(p.Beta) % Vews = 15 m/s
    p.StandardDeviationP_Beta = std(p.Beta) ; % Partial Load Operation is 0 and Full Load Operation is 3.1712
    p.Beta_dot = gradient(p.Beta, s.Time_ws(end-1)); % plot(p.Beta_dot)
    p.Tg = interp1(s.Vop, s.Tg_op, s.Uews_full); % plot(p.Tg) % Vews = 8 m/s
    p.StandardDeviationP_Tg = std(p.Tg) ; % Partial Load Operation is 2.6982e+04 and Full Load Operation is 2.6982e+04
    p.Tg_dot = gradient(p.Tg, s.Time_ws(end-1)); % plot(p.Tg_dot)
    p.Pe = interp1(s.Vop, s.Pe_op, s.Uews_full); % plot(p.Pe)
    p.Pe_dot = gradient(p.Pe, s.Time_ws(end-1)); % plot(p.Pe_dot)
    p.Ta = interp1(s.Vop, s.Ta_op, s.Uews_full); % plot(p.Ta) 
    p.Ta_dot = gradient(p.Ta, s.Time_ws(end-1)); % plot(p.Ta_dot) % Vews = 8 m/s
    p.OmegaR_dot = ( p.Ta - ( s.CCdt*p.OmegaR ) - 0 )*(1/s.J_t) + 0 ; % plot(p.OmegaR_dot) 
    p.CovarianceP_OmegaR_Ddot = cov(p.OmegaR_dot); % Covariance of drive train dynamics is 2.2705e-04
    p.CovarianceP_Tg_Dot = cov(p.Tg_dot); % Covariance of the dynamics of the generator torque control system is 1.1082e+04
    p.CovarianceP_Pe_Dot = cov(p.Pe_dot); % Covariance of the dynamics of the electrical power is 2.3452e+04
    p.CovarianceP_Beta_Dot = cov(p.Beta_dot); % Covariance of the dynamics of the generator torque control system is 3.4618e-07
    p.CovarianceP_Ta_Dot = cov(p.Ta_dot); % Covariance of the dynamics of the generator torque control system is 1.1153e+04
    p.CovarianceP_WindSpeed_Hub = cov(p.WindSpeed_Hub); % % Covariance of the Wind Speed at the height of the hub is 4.3535
    p.CovarianceP_Uews = cov(s.Uews_full); % % Covariance of the Wind Speed at the height of the hub is 1.5852  

        % NOTE: From the analysis of the covariance of the process without
        % disturbance, we obtain the natural variation of the system under 
        % turbulent wind conditions. Therefore, we must adopt a value that
        % is a fraction of this natural variation of the system and never
        % greater or an exaggerated value (otherwise there will be problems 
        % with the accuracy of the integrator and stability). For process 
        % covariance, I will adopt that the maximum variation assumes 10%
        % of this natural variation and for measurement covariance it will 
        % be 5%. Consequently, the standard deviation of this variation 
        % considering a normal distribution and that 99.74% of the values 
        % ​​will be within this range (3*devP). The only exception is the 
        % dynamics of the aerodynamic torque, which is actually the Random
        % Walk Model, which must consider all the variation. Therefore, the
        % adopted standard deviations are:
            % s.StandardDeviationP_OmegaR_Ddot = sqrt(2.2705e-04*0.1)
            % s.StandardDeviationP_Beta_Dot = sqrt(3.4618e-07*0.1) 
            % s.StandardDeviationP_Tg_Dot = sqrt(1.1082e+04*0.1)
            % s.StandardDeviationP_Pe_Dot = sqrt(2.3452e+04*0.1)
            % s.StandardDeviationP_Ta_Dot = sqrt(1.1153e+04) 
            % s.StandardDeviationM_Vws_hub = sqrt(4.3535)
            % s.CovarianceP_Uews = sqrt(1.5852)                          


                    % ##### Process Disturbance #####

    % ---------- Process Covariance (system disturbance) ----------
    who.AverageP_Beta_Dot = 'Process Average of Blade Pitch, in [N.m].';
    who.StandardDeviationP_Beta_Dot = 'Process standard deviation for the dynamics of Blade Pitch, in [deg].';       
    s.AverageP_Beta_Dot = 0;    
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:
        s.StandardDeviationP_Beta_Dot = sqrt(3.4618e-07*0.1) ; % OR (0.0063*s.BetaDot_max) / 3  
    else
        s.StandardDeviationP_Beta_Dot = sqrt(3.4618e-07*0.0033)  ;     
    end    
    s.WhiteNoiseP_Beta_Dot = s.StandardDeviationP_Beta_Dot*randn(1,s.Ns) + s.AverageP_Beta_Dot*ones(1,s.Ns);
    s.CovarianceP_Beta_Dot = cov(s.WhiteNoiseP_Beta_Dot');


    who.AverageP_Tg_Dot = 'Process Average of generator torque, in [N.m].';
    who.StandardDeviationP_Tg_Dot = 'Process standard deviation for the dynamics of generator torque, in [N.m].';       
    s.AverageP_Tg_Dot = 0;    
    s.StandardDeviationP_Tg_Dot = ( 0.003*(s.TgDot_max*s.eta_gb) ) / 3 ; % 1e+3 / 3  ; % (s.TgDot_max*s.eta_gb)
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:  
        s.StandardDeviationP_Tg_Dot = sqrt(1.1082e+04*0.1) ; % OR 1e+3 / 3 OR ( 0.00034*(s.TgDot_max*s.eta_gb) / 6
    else
        s.StandardDeviationP_Tg_Dot = sqrt(1.1082e+04*0.0033)  ;
    end     
    s.WhiteNoiseP_Tg_Dot = s.StandardDeviationP_Tg_Dot*randn(1,s.Ns) + s.AverageP_Tg_Dot*ones(1,s.Ns);
    s.CovarianceP_Tg_Dot = cov(s.WhiteNoiseP_Tg_Dot');


    who.AverageP_Ta_Dot = 'Average of aerodynamic torque, in [N.m].';
    who.StandardDeviationP_Ta_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.AverageP_Ta_Dot = 0;
    s.StandardDeviationP_Ta_Dot = sqrt(1.1153e+04) ;  % OR sqrt(1.1153e+04)       
    s.WhiteNoiseP_Ta_Dot = s.StandardDeviationP_Ta_Dot*randn(1,s.Ns) + s.AverageP_Ta_Dot*ones(1,s.Ns);
    s.CovarianceP_Ta_Dot = cov(s.WhiteNoiseP_Ta_Dot');         


    %
    who.AverageP_OmegaR_Ddot = 'Process Average of rotor acceleration, in [rad/s^2].';
    who.StandardDeviationP_OmegaR_Ddot = 'Process standard deviation for the dynamics of rotor acceleration, in [rad/s^2].';
    s.AverageP_OmegaR_Ddot = 0;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:
        s.StandardDeviationP_OmegaR_Ddot = sqrt(2.2705e-04*0.1)  ; % OR s.StandardDeviationP_Ta_Dot / s.J_t OR 1e-5 / 3
    else
        s.StandardDeviationP_OmegaR_Ddot = sqrt(2.2705e-04*0.0033)  ;     
    end           
    s.WhiteNoiseP_OmegaR_Ddot = s.StandardDeviationP_OmegaR_Ddot*randn(1,s.Ns) + s.AverageP_OmegaR_Ddot*ones(1,s.Ns);
    s.CovarianceP_OmegaR_Ddot = cov(s.WhiteNoiseP_OmegaR_Ddot');
    

    who.AverageP_OmegaG_Ddot = 'Process Average of generator acceleration, in [rad/s^2].';
    who.StandardDeviationP_OmegaG_Ddot = 'Process standard deviation for the dynamics of generator acceleration, in [rad/s^2].';    
    s.AverageP_OmegaG_Ddot = 0;    
    s.StandardDeviationP_OmegaG_Ddot = s.eta_gb*s.StandardDeviationP_OmegaR_Ddot;
    s.WhiteNoiseP_OmegaG_Ddot = s.StandardDeviationP_OmegaG_Ddot*randn(1,s.Ns) + s.AverageP_OmegaG_Ddot*ones(1,s.Ns);
    s.CovarianceP_OmegaG_Ddot = cov(s.WhiteNoiseP_OmegaG_Ddot');


    %
    who.AverageP_ThetaYawDot = 'Process Average of Yaw angular velocity (rotation around the tower), in [rad/s^2].';
    who.StandardDeviationP_ThetaYawDot = 'Process standard deviation for the dynamics of Yaw angle (rotation around the tower), in [rad/s^2].';       
    s.AverageP_ThetaYawDot = 0;    
    s.StandardDeviationP_ThetaYawDot = (3e-8 / 3) ;
    s.WhiteNoiseP_ThetaYawDot = s.StandardDeviationP_ThetaYawDot*randn(1,s.Ns) + s.AverageP_ThetaYawDot*ones(1,s.Ns);
    s.CovarianceP_ThetaYawDot = cov(s.WhiteNoiseP_ThetaYawDot');        

    who.AverageP_Surge_Ddot = 'Process Average of Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    who.StandardDeviationP_Surge_Ddot = 'Process standard deviation of Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';       
    s.AverageP_Surge_Ddot = 0;    
    s.StandardDeviationP_Surge_Ddot = (1e-6 / 3) ; % Consider that (1e-6) is approximately 1% error in acceleration in Surge, according to analyzed data.
    s.WhiteNoiseP_Surge_Ddot = s.StandardDeviationP_Surge_Ddot*randn(1,s.Ns) + s.AverageP_Surge_Ddot*ones(1,s.Ns);
    s.CovarianceP_Surge_Ddot = cov(s.WhiteNoiseP_Surge_Ddot');   

    who.AverageP_Sway_Ddot = 'Process Average of Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    who.StandardDeviationP_Sway_Ddot = 'Process standard deviation of Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';       
    s.AverageP_Sway_Ddot = 0;    
    s.StandardDeviationP_Sway_Ddot =  (1e-6 / 3) ; 
    s.WhiteNoiseP_Sway_Ddot = s.StandardDeviationP_Sway_Ddot*randn(1,s.Ns) + s.AverageP_Sway_Ddot*ones(1,s.Ns);
    s.CovarianceP_Sway_Ddot = cov(s.WhiteNoiseP_Sway_Ddot');
    
    who.AverageP_Heave_Ddot = 'Process Average of Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    who.StandardDeviationP_Heave_Ddot = 'Process standard deviation of Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';       
    s.AverageP_Heave_Ddot = 0;    
    s.StandardDeviationP_Heave_Ddot = (1e-6 / 3) ; % Consider that (1e-6) is approximately 1% error in acceleration in Heave, according to analyzed data.
    s.WhiteNoiseP_Heave_Ddot  = s.StandardDeviationP_Heave_Ddot*randn(1,s.Ns) + s.AverageP_Heave_Ddot*ones(1,s.Ns);
    s.CovarianceP_Heave_Ddot  = cov(s.WhiteNoiseP_Heave_Ddot');    
    
    who.AverageP_RollAngle_Ddot = 'Process Average of Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
    who.StandardDeviationP_RollAngle_Ddot = 'Process standard deviation of Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';    
    s.AverageP_RollAngle_Ddot = 0;    
    s.StandardDeviationP_RollAngle_Ddot = (1e-6 / 3) ; 
    s.WhiteNoiseP_RollAngle_Ddot = s.StandardDeviationP_RollAngle_Ddot*randn(1,s.Ns) + s.AverageP_RollAngle_Ddot*ones(1,s.Ns);
    s.CovarianceP_RollAngle_Ddot = cov(s.WhiteNoiseP_RollAngle_Ddot'); 
    
    who.AverageP_PitchAngle_Ddot = 'Process Average of Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    who.StandardDeviationP_PitchAngle_Ddot = 'Process standard deviation of Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';       
    s.AverageP_PitchAngle_Ddot = 0;    
    s.StandardDeviationP_PitchAngle_Ddot = (1e-6 / 3) ;  % Consider that (1e-6) is approximately 1% error in acceleration in Heave, according to analyzed data.
    s.WhiteNoiseP_PitchAngle_Ddot = s.StandardDeviationP_PitchAngle_Ddot*randn(1,s.Ns) + s.AverageP_PitchAngle_Ddot*ones(1,s.Ns);
    s.CovarianceP_PitchAngle_Ddot = cov(s.WhiteNoiseP_PitchAngle_Ddot');  
       
    who.AverageP_YawAngle_Ddot = 'Process Average of Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
    who.StandardDeviationP_YawAngle_Ddot = 'Process standard deviation of Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';     
    s.AverageP_YawAngle_Ddot = 0;    
    s.StandardDeviationP_YawAngle_Ddot = (1e-6 / 3) ; 
    s.WhiteNoiseP_YawAngle_Ddot = s.StandardDeviationP_YawAngle_Ddot*randn(1,s.Ns) + s.AverageP_YawAngle_Ddot*ones(1,s.Ns);
    s.CovarianceP_YawAngle_Ddot = cov(s.WhiteNoiseP_YawAngle_Ddot');


    %
    who.AverageP_Xt_Ddot = 'Average of tower dynamics, in [m/s^2].';
    who.StandardDeviationP_Xt_Ddot = 'Process standard deviation for the tower dynamics, in [m/s^2].';       
    s.AverageP_Xt_Ddot = 0;    
    s.StandardDeviationP_Xt_Ddot = 1e-3 / 3;  % Consider that (1e-6) is approximately 1% error in acceleration in X_tower, according to analyzed data.  
    s.WhiteNoiseP_Xt_Ddot = s.StandardDeviationP_Xt_Ddot*randn(1,s.Ns) + s.AverageP_Xt_Ddot*ones(1,s.Ns);
    s.CovarianceP_Xt_Ddot = cov(s.WhiteNoiseP_Xt_Ddot');  


    % Note: in the dynamics add the noise this way, just edit the suffix "_XXXX":
    % s.WhiteNoiseP_XXXX(randi([1, numel(s.WhiteNoisep_XXXX)]))

    % Organizing output results
    ProcessCovariances.AverageP_OmegaR_Ddot = s.AverageP_OmegaR_Ddot; ProcessCovariances.StandardDeviationP_OmegaR_Ddot = s.StandardDeviationP_OmegaR_Ddot; ProcessCovariances.WhiteNoiseP_OmegaR_Ddot = s.WhiteNoiseP_OmegaR_Ddot; ProcessCovariances.CovarianceP_OmegaR_Ddot = s.CovarianceP_OmegaR_Ddot;    
    ProcessCovariances.AverageP_OmegaG_Ddot = s.AverageP_OmegaG_Ddot; ProcessCovariances.StandardDeviationP_OmegaG_Ddot = s.StandardDeviationP_OmegaG_Ddot; ProcessCovariances.WhiteNoiseP_OmegaG_Ddot = s.WhiteNoiseP_OmegaG_Ddot; ProcessCovariances.CovarianceP_OmegaG_Ddot = s.CovarianceP_OmegaG_Ddot;     

    ProcessCovariances.AverageP_Beta_Dot = s.AverageP_Beta_Dot; ProcessCovariances.StandardDeviationP_Beta_Dot = s.StandardDeviationP_Beta_Dot; ProcessCovariances.WhiteNoiseP_Beta_Dot = s.WhiteNoiseP_Beta_Dot; ProcessCovariances.CovarianceP_Beta_Dot = s.CovarianceP_Beta_Dot;    
    ProcessCovariances.AverageP_Tg_Dot = s.AverageP_Tg_Dot; ProcessCovariances.StandardDeviationP_Tg_Dot = s.StandardDeviationP_Tg_Dot; ProcessCovariances.WhiteNoiseP_Tg_Dot = s.WhiteNoiseP_Tg_Dot; ProcessCovariances.CovarianceP_Tg_Dot = s.CovarianceP_Tg_Dot;    

    ProcessCovariances.AverageP_ThetaYawDot = s.AverageP_ThetaYawDot; ProcessCovariances.StandardDeviationP_ThetaYawDot = s.StandardDeviationP_ThetaYawDot; ProcessCovariances.WhiteNoiseP_ThetaYawDot = s.WhiteNoiseP_ThetaYawDot; ProcessCovariances.CovarianceP_ThetaYawDot = s.CovarianceP_ThetaYawDot;       
    ProcessCovariances.AverageP_Xt_Ddot = s.AverageP_Xt_Ddot; ProcessCovariances.StandardDeviationP_Xt_Ddot = s.StandardDeviationP_Xt_Ddot; ProcessCovariances.WhiteNoiseP_Xt_Ddot = s.WhiteNoiseP_Xt_Ddot; ProcessCovariances.CovarianceP_Xt_Ddot = s.CovarianceP_Xt_Ddot;    

    ProcessCovariances.AverageP_Surge_Ddot = s.AverageP_Surge_Ddot; ProcessCovariances.StandardDeviationP_Surge_Ddot = s.StandardDeviationP_Surge_Ddot; ProcessCovariances.WhiteNoiseP_Surge_Ddot = s.WhiteNoiseP_Surge_Ddot; ProcessCovariances.CovarianceP_Surge_Ddot = s.CovarianceP_Surge_Ddot;    
    ProcessCovariances.AverageP_Sway_Ddot = s.AverageP_Sway_Ddot; ProcessCovariances.StandardDeviationP_Sway_Ddot = s.StandardDeviationP_Sway_Ddot; ProcessCovariances.WhiteNoiseP_Sway_Ddot = s.WhiteNoiseP_Sway_Ddot; ProcessCovariances.CovarianceP_Sway_Ddot_Ddot = s.CovarianceP_Sway_Ddot;     
    ProcessCovariances.AverageP_Heave_Ddot = s.AverageP_Heave_Ddot; ProcessCovariances.StandardDeviationP_Heave_Ddot = s.StandardDeviationP_Heave_Ddot; ProcessCovariances.WhiteNoiseP_Heave_Ddot = s.WhiteNoiseP_Heave_Ddot; ProcessCovariances.CovarianceP_Heave_Ddot = s.CovarianceP_Heave_Ddot;    
    ProcessCovariances.AverageP_RollAngle_Ddot = s.AverageP_RollAngle_Ddot; ProcessCovariances.StandardDeviationP_RollAngle_Ddot = s.StandardDeviationP_RollAngle_Ddot; ProcessCovariances.WhiteNoiseP_RollAngle_Ddot = s.WhiteNoiseP_RollAngle_Ddot; ProcessCovariances.CovarianceP_RollAngle_Ddot = s.CovarianceP_RollAngle_Ddot;       
    ProcessCovariances.AverageP_PitchAngle_Ddot = s.AverageP_PitchAngle_Ddot; ProcessCovariances.StandardDeviationP_PitchAngle_Ddot = s.StandardDeviationP_PitchAngle_Ddot; ProcessCovariances.WhiteNoiseP_PitchAngle_Ddot = s.WhiteNoiseP_PitchAngle_Ddot; ProcessCovariances.CovarianceP_PitchAngle_Ddot = s.CovarianceP_PitchAngle_Ddot; 
    ProcessCovariances.AverageP_YawAngle_Ddot = s.AverageP_YawAngle_Ddot; ProcessCovariances.StandardDeviationP_YawAngle_Ddot = s.StandardDeviationP_YawAngle_Ddot; ProcessCovariances.WhiteNoiseP_YawAngle_Ddot = s.WhiteNoiseP_YawAngle_Ddot; ProcessCovariances.CovarianceP_YawAngle_Ddot = s.CovarianceP_YawAngle_Ddot;
    %

                    % ##### Disturbance in Measurements or Sensors #####


    % ---------- Measurement Covariance (sensor disturbance) ---------- 
    who.AverageM_Beta = 'Measurement Average of blade pitch, in [deg].';
    who.StandardDeviationM_Beta = 'Measurement Standard deviation of the blade pitch, in [deg].';    
    s.AverageM_Beta = 0;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:
        s.StandardDeviationM_Beta = sqrt(3.4618e-07*0.05) ; % OR 0.05 / 3 
    else
        s.StandardDeviationM_Beta = sqrt(3.4618e-07*0.0017) ;     
    end 
    s.WhiteNoiseM_Beta = s.StandardDeviationM_Beta*randn(1,s.Ns) + s.AverageM_Beta*ones(1,s.Ns);
    s.CovarianceM_Beta = cov(s.WhiteNoiseM_Beta');


    who.AverageM_Tg = 'Measurement Average of generator torque, in [N.m].';
    who.StandardDeviationM_Tg = 'Measurement Standard deviation of the generator torque, in [N.m].';       
    s.AverageM_Tg = 0;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:  
        s.StandardDeviationM_Tg = sqrt(1.1082e+04*0.05) ; % OR 1e+3 / 3
    else
        s.StandardDeviationM_Tg = sqrt(1.1082e+04*0.0017)  ;
    end      
    s.WhiteNoiseM_Tg = s.StandardDeviationM_Tg*randn(1,s.Ns) + s.AverageM_Tg*ones(1,s.Ns);
    s.CovarianceM_Tg = cov(s.WhiteNoiseM_Tg');
    

    who.AverageM_OmegaR = 'Measurement Average of rotor speed, in [rad/s].';
    who.StandardDeviationM_OmegaR = 'Measurement Standard deviation of the rotor speed, in [rad/s].';
    s.AverageM_OmegaR = 0;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:
        s.StandardDeviationM_OmegaR = sqrt(2.2705e-04*0.05)  ; % OR ((2*pi*0.01)/(60)) / 3
    else
        s.StandardDeviationM_OmegaR = sqrt(2.2705e-04*0.0017)  ;     
    end
    s.WhiteNoiseM_OmegaR = s.StandardDeviationM_OmegaR*randn(1,s.Ns) + s.AverageM_OmegaR*ones(1,s.Ns);
    s.CovarianceM_OmegaR = cov(s.WhiteNoiseM_OmegaR');


    who.AverageM_OmegaG = 'Measurement Average of generator speed, in [rad/s].';
    who.StandardDeviationM_OmegaG = 'Measurement Standard deviation of the generator speed, in [rad/s].';    
    s.AverageM_OmegaG = 0;    
    s.StandardDeviationM_OmegaG = s.eta_gb*s.StandardDeviationM_OmegaR;
    s.WhiteNoiseM_OmegaG = s.StandardDeviationM_OmegaG*randn(1,s.Ns) + s.AverageM_OmegaG*ones(1,s.Ns);
    s.CovarianceM_OmegaG = cov(s.WhiteNoiseM_OmegaG'); 


    who.AverageM_Pe = 'Measurement Average of electrical power, in [W].';
    who.StandardDeviationM_Pe = 'Measurement Standard deviation of the electrical power, in [W].';       
    s.AverageM_Pe = 0;
    if s.Option03f1 == 1 || s.Option03f1 == 2 || s.Option03f1 == 3
        % Wind turbulent: the maximum variation observed was:  
        s.StandardDeviationM_Pe = sqrt(2.3452e+04*0.05) ; % OR ( s.OmegaR_Rated*5e+3 ) / 3
    else
        s.StandardDeviationM_Pe = sqrt(2.3452e+04*0.0017) ;
    end  
    s.WhiteNoiseM_Pe = s.StandardDeviationM_Pe*randn(1,s.Ns) + s.AverageM_Pe*ones(1,s.Ns);
    s.CovarianceM_Pe = cov(s.WhiteNoiseM_Pe');


    who.AverageM_Vws_hub = 'Measurement Average of wind speed measured by anemometerand at hub-height, in [m/s].';
    who.StandardDeviationM_Vws_hub = 'Standard deviation of wind speed measured by anemometerand at hub-height, in [m/s].';       
    s.AverageM_Vws_hub = 0;    
    s.StandardDeviationM_Vws_hub = sqrt(4.3535) ;
    s.WhiteNoiseM_Vws_hub = s.StandardDeviationM_Vws_hub*randn(1,s.Ns) + s.AverageM_Vws_hub*ones(1,s.Ns);
    s.CovarianceM_Vws_hub = cov(s.WhiteNoiseM_Vws_hub');        


    who.AverageM_Surge_Ddot = 'Measurement Average of Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    who.StandardDeviationM_Surge_Ddot = 'Measurement Standard deviation of Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_Surge_Ddot = 0;    
    s.StandardDeviationM_Surge_Ddot = 1e-6 / 4 ; % Accelerometer instrumentation catalogs indicate a range of (0.001%–0.005%), I will adopt the most conservative value.  
    s.WhiteNoiseM_Surge_Ddot = s.StandardDeviationM_Surge_Ddot*randn(1,s.Ns) + s.AverageM_Surge_Ddot*ones(1,s.Ns);
    s.CovarianceM_Surge_Ddot = cov(s.WhiteNoiseM_Surge_Ddot');   


    who.AverageM_Sway_Ddot = 'Measurement Average of Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    who.StandardDeviationM_Sway_Ddot = 'Measurement Standard deviation of Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_Sway_Ddot = 0;    
    s.StandardDeviationM_Sway_Ddot = 1e-6 / 4 ; % Accelerometer instrumentation catalogs indicate a range of (0.001%–0.005% of 200*s.gravity), I will adopt the most conservative value.
    s.WhiteNoiseM_Sway_Ddot = s.StandardDeviationM_Sway_Ddot*randn(1,s.Ns) + s.AverageM_Sway_Ddot*ones(1,s.Ns);
    s.CovarianceM_Sway_Ddot = cov(s.WhiteNoiseM_Sway_Ddot');
    

    who.AverageM_Heave_Ddot = 'Measurement Average of Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    who.StandardDeviationM_Heave_Ddot = 'Measurement Standard deviation of Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_Heave_Ddot = 0;    
    s.StandardDeviationM_Heave_Ddot = 1e-6 / 4 ; % Accelerometer instrumentation catalogs indicate a range of (0.001%–0.005%), I will adopt the most conservative value.
    s.WhiteNoiseM_Heave_Ddot  = s.StandardDeviationM_Heave_Ddot*randn(1,s.Ns) + s.AverageM_Heave_Ddot*ones(1,s.Ns);
    s.CovarianceM_Heave_Ddot  = cov(s.WhiteNoiseM_Heave_Ddot');    
    
    
    who.AverageM_RollAngle_dot = 'Measurement Average of Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    who.StandardDeviationM_RollAngle_dot = 'Measurement Standard deviation of Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';    
    s.AverageM_RollAngle_dot = 0;    
    s.StandardDeviationM_RollAngle_dot = 1e-7 / 4  ; % Drift Rate == ±0,01 [°/hours] == 4.85e-7 [rad/s]
    s.WhiteNoiseM_RollAngle_dot = s.StandardDeviationM_RollAngle_dot*randn(1,s.Ns) + s.AverageM_RollAngle_dot*ones(1,s.Ns);
    s.CovarianceM_RollAngle_dot = cov(s.WhiteNoiseM_RollAngle_dot'); 
    

    who.AverageM_PitchAngle_dot = 'Measurement Average of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    who.StandardDeviationM_PitchAngle_dot = 'Measurement Standard deviation of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';       
    s.AverageM_PitchAngle_dot = 0;    
    s.StandardDeviationM_PitchAngle_dot = 1e-7 / 4 ; % Drift Rate == ±0,01 [°/hours]
    s.WhiteNoiseM_PitchAngle_dot = s.StandardDeviationM_PitchAngle_dot*randn(1,s.Ns) + s.AverageM_PitchAngle_dot*ones(1,s.Ns);
    s.CovarianceM_PitchAngle_dot = cov(s.WhiteNoiseM_PitchAngle_dot'); 

    who.AverageM_PitchAngle_dot = 'Measurement Average of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    who.StandardDeviationM_PitchAngle_dot = 'Measurement Standard deviation of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';       
    s.AverageM_PitchAngle_dot = 0;    
    s.StandardDeviationM_PitchAngle_dot = 1e-7 / 4 ; % Drift Rate == ±0,01 [°/hours]
    s.WhiteNoiseM_PitchAngle_dot = s.StandardDeviationM_PitchAngle_dot*randn(1,s.Ns) + s.AverageM_PitchAngle_dot*ones(1,s.Ns);
    s.CovarianceM_PitchAngle_dot = cov(s.WhiteNoiseM_PitchAngle_dot');

    who.AverageM_YawAngle_dot = 'Measurement Average of Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    who.StandardDeviationM_YawAngle_dot = 'Measurement Standard deviation of Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';     
    s.AverageM_YawAngle_dot = 0;    
    s.StandardDeviationM_YawAngle_dot = 1e-7 / 4 ; % Drift Rate == ±0,01 [°/hours]
    s.WhiteNoiseM_YawAngle_dot = s.StandardDeviationM_YawAngle_dot*randn(1,s.Ns) + s.AverageM_YawAngle_dot*ones(1,s.Ns);
    s.CovarianceM_YawAngle_dot = cov(s.WhiteNoiseM_YawAngle_dot');  


    who.AverageM_Xt_Ddot = 'Measurement Average of Acceleration of the Tower-top (Tower-top dynamics), in [m/s^2].';
    who.StandardDeviationM_Xt_Ddot = 'Measurement standard deviation of Acceleration of the Tower-top (Tower-top dynamics), in [m/s^2].';       
    s.AverageM_Xt_Ddot = 0;    
    s.StandardDeviationM_Xt_Ddot = 1e-3 / 4 ; 
    s.WhiteNoiseM_Xt_Ddot = s.StandardDeviationM_Xt_Ddot*randn(1,s.Ns) + s.AverageM_Xt_Ddot*ones(1,s.Ns);
    s.CovarianceM_Xt_Ddot = cov(s.WhiteNoiseM_Xt_Ddot');  


    % Note: in the dynamics add the noise this way, just edit the suffix "_XXXX":
    % s.WhiteNoiseM_XXXX(randi([1, numel(s.WhiteNoiseM_XXXX)]))
    
    % Organizing output results
    MeasurementCovariances.AverageM_OmegaR = s.AverageM_OmegaR; MeasurementCovariances.StandardDeviationM_OmegaR = s.StandardDeviationM_OmegaR; MeasurementCovariances.WhiteNoiseM_OmegaR = s.WhiteNoiseM_OmegaR; MeasurementCovariances.CovarianceM_OmegaR = s.CovarianceM_OmegaR;    
    MeasurementCovariances.AverageM_OmegaG = s.AverageM_OmegaG; MeasurementCovariances.StandardDeviationM_OmegaG = s.StandardDeviationM_OmegaG; MeasurementCovariances.WhiteNoiseM_OmegaG = s.WhiteNoiseM_OmegaG; MeasurementCovariances.CovarianceM_OmegaG = s.CovarianceM_OmegaG;     

    MeasurementCovariances.AverageM_Beta = s.AverageM_Beta; MeasurementCovariances.StandardDeviationM_Beta = s.StandardDeviationM_Beta; MeasurementCovariances.WhiteNoiseM_Beta = s.WhiteNoiseM_Beta; MeasurementCovariances.CovarianceM_Beta = s.CovarianceM_Beta;     
    MeasurementCovariances.AverageM_Tg = s.AverageM_Tg; MeasurementCovariances.StandardDeviationM_Tg = s.StandardDeviationM_Tg; MeasurementCovariances.WhiteNoiseM_Tg = s.WhiteNoiseM_Tg; MeasurementCovariances.CovarianceM_Tg = s.CovarianceM_Tg;    
    MeasurementCovariances.AverageM_Pe = s.AverageM_Pe; MeasurementCovariances.StandardDeviationM_Pe = s.StandardDeviationM_Pe; MeasurementCovariances.WhiteNoiseM_Pe = s.WhiteNoiseM_Pe; MeasurementCovariances.CovarianceM_Pe = s.CovarianceM_Pe;  

    MeasurementCovariances.AverageM_Xt_Ddot = s.AverageM_Xt_Ddot; MeasurementCovariances.StandardDeviationM_Xt_Ddot = s.StandardDeviationM_Xt_Ddot; MeasurementCovariances.WhiteNoiseM_Xt_Ddot = s.WhiteNoiseM_Xt_Ddot; MeasurementCovariances.CovarianceM_Xt_Ddot = s.CovarianceM_Xt_Ddot; 
    MeasurementCovariances.AverageM_Vws_hub = s.AverageM_Vws_hub; MeasurementCovariances.StandardDeviationM_Vws_hub = s.StandardDeviationM_Vws_hub; MeasurementCovariances.WhiteNoiseM_Vws_hub = s.WhiteNoiseM_Vws_hub; MeasurementCovariances.CovarianceM_Vws_hub = s.CovarianceM_Vws_hub;        

    MeasurementCovariances.AverageM_Surge_Ddot = s.AverageM_Surge_Ddot; MeasurementCovariances.StandardDeviationM_Surge_Ddot = s.StandardDeviationM_Surge_Ddot; MeasurementCovariances.WhiteNoiseM_Surge_Ddot = s.WhiteNoiseM_Surge_Ddot; MeasurementCovariances.CovarianceM_Surge_Ddot = s.CovarianceM_Surge_Ddot;    
    MeasurementCovariances.AverageM_Sway_Ddot = s.AverageM_Sway_Ddot; MeasurementCovariances.StandardDeviationM_Sway_Ddot = s.StandardDeviationM_Sway_Ddot; MeasurementCovariances.WhiteNoiseM_Sway_Ddot = s.WhiteNoiseM_Sway_Ddot; MeasurementCovariances.CovarianceM_Sway_Ddot_Ddot = s.CovarianceM_Sway_Ddot;     
    MeasurementCovariances.AverageM_Heave_Ddot = s.AverageM_Heave_Ddot; MeasurementCovariances.StandardDeviationM_Heave_Ddot = s.StandardDeviationM_Heave_Ddot; MeasurementCovariances.WhiteNoiseM_Heave_Ddot = s.WhiteNoiseM_Heave_Ddot; MeasurementCovariances.CovarianceM_Heave_Ddot = s.CovarianceM_Heave_Ddot;    
    MeasurementCovariances.AverageM_RollAngle_dot = s.AverageM_RollAngle_dot; MeasurementCovariances.StandardDeviationM_RollAngle_dot = s.StandardDeviationM_RollAngle_dot; MeasurementCovariances.WhiteNoiseM_RollAngle_dot = s.WhiteNoiseM_RollAngle_dot; MeasurementCovariances.CovarianceM_RollAngle_dot = s.CovarianceM_RollAngle_dot;       
    MeasurementCovariances.AverageM_PitchAngle_dot = s.AverageM_PitchAngle_dot; MeasurementCovariances.StandardDeviationM_PitchAngle_dot = s.StandardDeviationM_PitchAngle_dot; MeasurementCovariances.WhiteNoiseM_PitchAngle_dot = s.WhiteNoiseM_PitchAngle_dot; MeasurementCovariances.CovarianceM_PitchAngle_dot = s.CovarianceM_PitchAngle_dot; 
    MeasurementCovariances.AverageM_YawAngle_dot = s.AverageM_YawAngle_dot; MeasurementCovariances.StandardDeviationM_YawAngle_dot = s.StandardDeviationM_YawAngle_dot; MeasurementCovariances.WhiteNoiseM_YawAngle_dot = s.WhiteNoiseM_YawAngle_dot; MeasurementCovariances.CovarianceM_YawAngle_dot = s.CovarianceM_YawAngle_dot;    
    % 

  
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'MeasurementCovariances', MeasurementCovariances);
    assignin('base', 'ProcessCovariances', ProcessCovariances);


    % Return to EnviromentSimulation('logical_instance_02');


elseif strcmp(action, 'logical_instance_04')
% ==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % SYSTEM OUTPUT (ONLINE):
    % Purpose of this Logical Instance: to represent the system output
    % is all the state variables  considered to represent a set of 
    % adopted characteristics.
    

                    % #### System Output #### 

    % ------ Output of the System Simulation Numerical Integrator (SIRK4th) ------
    who.y = 'System State Variable (Wind Turbine and its subsystems).';

    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    who.Beta_dot = 'Collective Blade Pitch Rate, in [deg/seg].'; 
    if it == 1
        s.Beta = interp1(s.Vop, s.Beta_op, s.Uews_full(1));
        %
    else
        if s.Option01f3 == 1
            % NOT consider the Blade Pitch dynamics
            s.Beta =  s.Beta_d ;
        elseif s.Option01f3 == 2
            % Electromechanical Blade Pitch Systems (first-order model - delay behavior)
            s.Beta = s.y(1) ;  
        elseif s.Option01f3 == 3
            % Hydraulic Blade Pitch Systems (second-order model - oscillatory behavior)
            s.Beta = s.y(1) ;
        end
        %
    end


    who.Tg = 'Generator Torque, in [N.m]';
    who.Tg_dot = 'Generator Torque Rate (first time derivative), in [N.m/seg].';
    if it == 1
        s.Tg = interp1(s.Vop, s.Tg_op, s.Uews_full(1));
        %
    else
        if s.Option02f3 == 1
            % NOT consider the Generator/Converter Dynamics
            s.Tg = s.Tg_d ; 
        else
            % Consider the Generator/Converter Dynamics (first-order model - delay behavior)
            s.Tg = s.y(3) ; 
        end
        %
    end


    who.OmegaR= 'Rotor speed, in [rad/s].';
    who.OmegaG= 'Generator speed, in [rad/s].';    
    if it == 1       
        s.OmegaR = interp1(s.Vop, s.OmegaR_op, s.Uews_full(1));
        s.OmegaG = s.eta_gb*s.OmegaR ; 
        %
    else
        who.OmegaR= 'Rotor speed, in [rad/s].';
        s.OmegaR = s.y(4) ; 
        who.OmegaG= 'Generator speed, in [rad/s].';
        s.OmegaG = s.y(5) ; 
    end
    who.Tls = 'Low speed shaft resistance torque, in [N.m].';
    s.Tls = s.y(6) ; 
    
    who.zetaB = 'Angular Displacement out of the plane of rotation, in [rad]';
    s.zetaB = s.y(9) ;
    who.zetaB_dot = 'Angular Velocity out of the plane of rotation, in [rad/s]';
    s.zetaB_dot = s.y(10) ;

    who.RotorTeeter = 'Rotor inclination (Rotor-Teeter).';
    s.RotorTeeter = s.y(11) ; 
    who.RotorFurl = 'Rotor inclination (Rotor-Teeter).';
    s.RotorFurl = s.y(12) ; 
    who.RotorTail = 'Rotor inclination (Rotor-Teeter).';
    s.RotorFurl = s.y(13) ; 
    who.ThetaYaw = 'Yaw angle, in [rad].';
    s.ThetaYaw = s.y(14) ; 

           %      1           2         3          4             5          6          7       8          9            10            11                  12              13            14           15          16           17           18         19          20            21               22              23                24                25              26 
    % s.dy = [s.Beta_dot s.Beta_Ddot s.Tg_dot s.OmegaR_dot s.OmegaG_dot s.Tls_dot s.Xt_dot s.Xt_Ddot s.zetaB_dot s.zetaB_Ddot s.RotorTeeter_dot s.RotorFurl_dot s.RotorTail_dot s.ThetaYaw_dot s.Surge_dot s.Surge_Ddot s.Sway_dot s.Sway_Ddot s.Heave_dot s.Heave_Ddot s.RollAngle_dot  s.RollAngle_Ddot s.PitchAngle_dot s.PitchAngle_Ddot s.YawAngle_dot s.YawAngle_Ddot];
    %

    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.y(15) ; 
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.y(16) ;   
    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot = s.dy(16) ;  

    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.y(17) ; 
    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot  = s.y(18) ;     
    who.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sway_Ddot = s.dy(18) ;    

    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.y(19) ; 
    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.y(20) ; 
    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot = s.dy(20) ;


    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.y(21) ;  
    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot  = s.y(22) ; 
    who.RollAngle_Ddot = 'Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
    s.RollAngle_Ddot = s.dy(22) ; 
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


    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';   
    s.PitchAngle = s.y(23) ;
    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.y(24); 
    who.PitchAngle_Ddot = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    s.PitchAngle_Ddot = s.dy(24) ;
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

  
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.y(25) ; 
    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot  = s.y(26) ;   
    who.YawAngle_Ddot = 'Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
    s.YawAngle_Ddot = s.dy(26) ;    
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

    who.Xt = 'Tower-top position in the Fore–Aft direction, in [m]';
    s.Xt = s.y(7);
    who.Xt_dot  = 'Tower-top velocity in the Fore–Aft direction, in [m/s]';
    s.Xt_dot  = s.y(8);
    who.Xt_Ddot = 'Tower-top acceleration in the Fore–Aft direction, in [m/s²]';    
    if (s.Option04f3 == 2) && (s.Option02f2 > 1)
        % Tower Kinematics (Xt computed from platform motion)
        s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot;
        %
    else
        s.Xt_Ddot = s.dy(8);
    end
   
    who.Ta_RWM = 'Aerodynamic Torque for the Random Walk Model, in [N.m].';
    s.Ta_RWM = s.y(27) ; % s.Ta_dot 

    
    % ------ Actual Wind speed at hub height ----------      
    who.WindSped_hubWT = 'Wind speed at hub height, with interaction with the wind turbine, in [m/s].';
    s.WindSped_hubWT = interp1(s.Time_ws(1:end-1), s.WindSpeed_Hub, t) ;
    s.WindSped_hubWT = s.WindSped_hubWT - s.Xt_dot ;
    s.WindSped_hubWT = max( s.WindSped_hubWT, 0.1 ) ;

    
    % ---------- Other values ​​related to system output ----------    
    who.Pe = 'Actual electrical power (generator input), in [W].';
    s.Pe = (s.Tg / s.eta_gb) * s.OmegaG * s.etaElec_op ;


    % Organizing output results 
    WindTurbineOutput.y(it,:) = s.y ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);



    % Calling the next logic instance 
    WindTurbine('logical_instance_05');


elseif strcmp(action, 'logical_instance_05')
% ==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % SENSORS (ONLINE):
    % Purpose of this Logical Instance: to represent the measurement of 
    % system variables or sensorsof a wind turbine. The measurements are
    % for control, estimation or data analysis purposes. 

                    % #### Sensors #### 

    % ---------- Measurement noise ----------
    who.Sensor.MNoiseOmegaR = 'Rotor Speed measurement noise, in [rad/s]';
    s.Sensor.MNoiseOmegaR = s.WhiteNoiseM_OmegaR(randi([1, numel(s.WhiteNoiseM_OmegaR)]));
    who.Sensor.MNoiseOmegaG = 'Generator Speed measurement noise, in [rad/s]';
    s.Sensor.MNoiseOmegaG = s.WhiteNoiseM_OmegaG(randi([1, numel(s.WhiteNoiseM_OmegaG)]));
    who.Sensor.MNoiseBeta = 'Collective Blade Pitch measurement noise, in [deg]';
    s.Sensor.MNoiseBeta = s.WhiteNoiseM_Beta(randi([1, numel(s.WhiteNoiseM_Beta)]));       
    who.Sensor.MNoiseTg = 'Generator Torque measurement noise, in [N.m]';
    s.Sensor.MNoiseTg = s.WhiteNoiseM_Tg(randi([1, numel(s.WhiteNoiseM_Tg)]));
    who.Sensor.MNoisePe = 'Electrical Power measurement noise, in [W]';
    s.Sensor.MNoisePe = s.WhiteNoiseM_Pe(randi([1, numel(s.WhiteNoiseM_Pe)]));

    who.Sensor.MNoiseVws_hub = 'Wind speed measurement noise (anemometer), in [m/s]';
    s.Sensor.MNoiseVws_hub = s.WhiteNoiseM_Vws_hub(randi([1, numel(s.WhiteNoiseM_Vws_hub)]));
    who.Sensor.MNoiseXt_Ddot = 'Fore-aft tower-top acceleration measurement noise, in [m/s^2].';
    s.Sensor.MNoiseXt_Ddot = s.WhiteNoiseM_Xt_Ddot(randi([1, numel(s.WhiteNoiseM_Xt_Ddot)])); 

    who.Sensor.MNoiseSurgeDdot = 'Linear longitudinal Acceleration measurement noise, in [m/s^2].';
    s.Sensor.MNoiseSurgeDdot = s.WhiteNoiseM_Surge_Ddot(randi([1, numel(s.WhiteNoiseM_Surge_Ddot)]));
    who.Sensor.MNoiseSwayDDot = 'Linear transverse (side-to-side or port-starboard) Acceleration measurement noise , in [m/s^2].';
    s.Sensor.MNoiseSwayDDot = s.WhiteNoiseM_Sway_Ddot(randi([1, numel(s.WhiteNoiseM_Sway_Ddot)]));
    who.Sensor.MNoiseHeaveDDot = 'Linear vertical (up/down) Acceleration measurement noise, in [m/s^2].';
    s.Sensor.MNoiseHeaveDDot = s.WhiteNoiseM_Heave_Ddot(randi([1, numel(s.WhiteNoiseM_Heave_Ddot)]));    
    who.Sensor.MNoiseRollDot = 'Measurement noise of the tilting rotation of a vessel about its longitudinal/X (front-back or bow-stern) axis, in [rad/s].';
    s.Sensor.MNoiseRollDot = s.WhiteNoiseM_RollAngle_dot(randi([1, numel(s.WhiteNoiseM_RollAngle_dot)]));
    who.Sensor.MNoisePitchDot = 'Measurement noise of the up/down rotation of a vessel about its transverse/Y (side-to-side or port-starboard) axis, in [rad/s].';
    s.Sensor.MNoisePitchDot = s.WhiteNoiseM_PitchAngle_dot(randi([1, numel(s.WhiteNoiseM_PitchAngle_dot)]));
    who.Sensor.MNoiseYawDot = 'Measurement noise of the turning rotation of a vessel about its vertical/Z axis, in [rad/s].';
    s.Sensor.MNoiseYawDot = s.WhiteNoiseM_YawAngle_dot(randi([1, numel(s.WhiteNoiseM_YawAngle_dot)]));   
  

    % ---------- Sensor 01: collective blade pitch measurement----------
    who.Sensor.Beta = 'Collective Blade Pitch Measured at the blade pitch actuator system output (control output), in [deg]';
    s.Sensor.Beta = s.Beta + s.Sensor.MNoiseBeta;

    % ---------- Sensor 02: generator torque measurement ----------
    who.Sensor.Tg = 'Generator Torque Measured at the output of the generator/converter system, in [N.m]';
    s.Sensor.Tg = s.Tg + s.Sensor.MNoiseTg;

    % ---------- Sensor 03: rotor speed measurement ----------
    who.Sensor.OmegaR = 'Rotor Speed Measured at the output of the drive-train, in [rad/s]';
    s.Sensor.OmegaR = s.OmegaR + s.Sensor.MNoiseOmegaR;    

    % ---------- Sensor 04: generator speed measurement ----------
    who.Sensor.OmegaG = 'Generator Speed Measured at the output of the drive-train, in [rad/s]';
    s.Sensor.OmegaG = s.OmegaG + s.Sensor.MNoiseOmegaG;   

    % ---------- Sensor 05: electrical power measurement ----------
    who.Sensor.Pe = 'Electrical Power Measured at the output of the Energy Converter, in [W]';
    s.Sensor.Pe = s.Pe + s.Sensor.MNoisePe; % ( s.y(3)*s.y(5) ) + s.Sensor.MNoisePe
   
    % ---------- Sensor 06: wind speed measurement ----------
    who.Sensor.WindSped_hubWT = 'Wind speed Measured by anemometerand at hub-height, in [m/s]';
    s.Sensor.WindSped_hubWT = max( s.WindSped_hubWT + s.Sensor.MNoiseVws_hub, 0.1);


    % ---------- Sensor 07: position displacement measurement in "ForTower-Top" ----------
    who.Sensor.Xt = 'Tower-Top Fore-Aft Position displacement Measurement (front longitudinal axis), in [m/s^2].';
    s.Sensor.Xt = s.Xt ; % s.dy(8) + s.Sensor.MNoiseXt

    % ---------- Sensor 08: acceleration measurement in "ForTower-Top" ----------
    who.Sensor.Xt_dot = 'Tower-Top Fore-Aft Acceleration Measurement (front longitudinal axis), in [m/s^2].';
    s.Sensor.Xt_dot = s.Xt_dot ; % s.dy(8) + s.Sensor.MNoiseXt_dot

    % ---------- Sensor 09: acceleration measurement in "ForTower-Top" (accelerometers) ----------
    who.Sensor.Xt_Ddot = 'Tower-Top Fore-Aft Acceleration Measurement (front longitudinal axis), in [m/s^2].';
    s.Sensor.Xt_Ddot = s.Xt_Ddot + s.Sensor.MNoiseXt_Ddot; % s.dy(8) + s.Sensor.MNoiseXt_Ddot

    
    % ---------- Sensor 10: position displacement in measurement in "Surge" ----------
    who.Sensor.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Sensor.Surge = s.Surge ;  % s.y(15) + s.Sensor.MNoiseSurgedot

    % ---------- Sensor 11: velocity measurement in "Surge" ----------
    who.Sensor.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Sensor.Surge_dot = s.Surge_dot ;  % s.y(16) + s.Sensor.MNoiseSurgedot

    % ---------- Sensor 12: acceleration measurement in "Surge" (accelerometers) ----------
    who.Sensor.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Sensor.Surge_Ddot = s.Surge_Ddot + s.Sensor.MNoiseSurgeDdot;  % s.dy(16) + s.Sensor.MNoiseSurgeDdot



    % ---------- Sensor 13: position displacement measurement in "Sway" ----------
    who.Sensor.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Sway = s.Sway ; % s.y(17) + s.Sensor.MNoiseSway;  

    % ---------- Sensor 14: velocity in measurement in "Sway" ----------
    who.Sensor.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Sway_dot = s.Sway_dot ; % s.y(18) + s.Sensor.MNoiseSwayDot;  

    % ---------- Sensor 15: acceleration measurement in "Sway_Ddot" (accelerometers) ----------
    who.Sensor.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Sway_Ddot = s.Sway_Ddot ; % s.dy(18) + s.Sensor.MNoiseSwayDDot;      



    % ---------- Sensor 16: position displacement measurement in "Heave" ----------
    who.Sensor.Heave = 'Position displacement in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Heave = s.Heave ; % s.y(19) + s.Sensor.MNoiseHeave;

    % ---------- Sensor 17: velocity in measurement in "Heave" ----------
    who.Sensor.Heave_dot = 'Velocity Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Heave_dot = s.Heave_dot ; % s.y(20) + s.Sensor.MNoiseHeaveDot;

    % ---------- Sensor 18: acceleration measurement in "Heave" (accelerometers) ----------
    who.Sensor.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Sensor.Heave_Ddot = s.Heave_Ddot + s.Sensor.MNoiseHeaveDDot; % s.dy(20) + s.Sensor.MNoiseHeaveDDot;



    % ---------- Sensor 19: angle measurement in "RollAngle "----------
    who.Sensor.RollAngle = 'Measurement of Roll angle or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.Sensor.RollAngle = s.RollAngle ; % s.y(21) + s.Sensor.MNoiseRollAngle

    % ---------- Sensor 20: angular velocity measurement in "Roll_Ddot" (gyroscopes) ----------
    who.Sensor.RollAngle_dot = 'Measurement of Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.Sensor.RollAngle_dot = s.RollAngle_dot + s.Sensor.MNoiseRollDot; % s.y(22) + s.Sensor.MNoiseRollDot
   
    % ---------- Sensor 21: angular acceleration measurement in "RollAngle_Ddot" ----------
    who.Sensor.RollAngle_Ddot = 'Measurement of Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.Sensor.RollAngle_Ddot = s.RollAngle_Ddot ; % s.dy(22) + s.Sensor.MNoiseRollDDot



    % ---------- Sensor 22: angle measurement in "PitchAngle" ----------
    who.Sensor.PitchAngle = 'Measurement of Pitch angle or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.Sensor.PitchAngle = s.PitchAngle ; % s.y(23) + s.Sensor.MNoisePitchAngle

    % ---------- Sensor 23: angular velocity measurement in "Pitch_Ddot" (gyroscopes) ----------
    who.Sensor.PitchAngle_dot = 'Measurement of Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.Sensor.PitchAngle_dot = s.PitchAngle_dot + s.Sensor.MNoisePitchDot; % s.y(24) + s.Sensor.MNoisePitchDot

    % ---------- Sensor 24: angular acceleration measurement in "PitchAngle_Ddot" ----------
    who.Sensor.PitchAngle_Ddot = 'Measurement of Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.Sensor.PitchAngle_Ddot = s.PitchAngle_Ddot ; % s.dy(24) + s.Sensor.MNoisePitchDDot


    % ---------- Sensor 25: angle measurement in "YawAngle" ----------
    who.Sensor.YawAngle = 'Measurement of Yaw angle or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.Sensor.YawAngle = s.YawAngle ; % s.y(25) + s.Sensor.MNoiseYawAngle

    % ---------- Sensor 26: angular velocity measurement in "Yaw_Ddot" (gyroscopes) ----------
    who.Sensor.YawAngle_dot = 'Measurement of Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.Sensor.YawAngle_dot = s.YawAngle_dot + s.Sensor.MNoiseYawDot; % s.y(26) + s.Sensor.MNoiseYawDot 

    % ---------- Sensor 27: angular acceleration measurement in "YawAngle_Ddot" ----------
    who.Sensor.YawAngle_Ddot = 'Measurement of Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.Sensor.YawAngle_Ddot = s.YawAngle_Ddot ; % s.dy(26) + s.Sensor.MNoiseYawDDot  
      

    % Organizing output results
    Sensor.OmegaR(it) = s.Sensor.OmegaR; Sensor.OmegaG(it) = s.Sensor.OmegaG;
    Sensor.Beta(it) = s.Sensor.Beta; Sensor.Tg(it) = s.Sensor.Tg; Sensor.Pe(it) = s.Sensor.Pe;
    Sensor.WindSped_hubWT(it) = s.Sensor.WindSped_hubWT; 
    Sensor.Xt(it) = s.Sensor.Xt; Sensor.Xt_dot(it) = s.Sensor.Xt_dot; Sensor.Xt_Ddot(it) = s.Sensor.Xt_Ddot;
    Sensor.Surge(it) = s.Sensor.Surge; Sensor.Surge_dot(it) = s.Sensor.Surge_dot; Sensor.Surge_Ddot(it) = s.Sensor.Surge_Ddot;
    Sensor.Sway(it) = s.Sensor.Sway; Sensor.Sway_dot(it) = s.Sensor.Sway_dot ; Sensor.Sway_Ddot(it) = s.Sensor.Sway_Ddot ;
    Sensor.Heave(it) = s.Sensor.Heave; Sensor.Heave_dot(it) = s.Sensor.Heave_dot; Sensor.Heave_Ddot(it) = s.Sensor.Heave_Ddot;    
    Sensor.RollAngle(it) = s.Sensor.RollAngle; Sensor.RollAngle_dot(it) = s.Sensor.RollAngle_dot; Sensor.RollAngle_Ddot(it) = s.Sensor.RollAngle_Ddot;
    Sensor.PitchAngle(it) = s.Sensor.PitchAngle; Sensor.PitchAngle_dot(it) = s.Sensor.PitchAngle_dot; Sensor.PitchAngle_Ddot(it) = s.Sensor.PitchAngle_Ddot;
    Sensor.YawAngle(it) = s.Sensor.YawAngle; Sensor.YawAngle_dot(it) = s.Sensor.YawAngle_dot; Sensor.YawAngle_Ddot(it) = s.Sensor.YawAngle_Ddot;    
    Sensor.MNoiseOmegaR(it) = s.Sensor.MNoiseOmegaR; Sensor.MNoiseOmegaG(it) = s.Sensor.MNoiseOmegaG; Sensor.MNoiseBeta(it) = s.Sensor.MNoiseBeta; Sensor.MNoiseTg(it) = s.Sensor.MNoiseTg; Sensor.MNoisePe(it) = s.Sensor.MNoisePe; Sensor.MNoiseVws_hub(it) = s.Sensor.MNoiseVws_hub;  
    Sensor.MNoiseSurgeDdot(it) = s.Sensor.MNoiseSurgeDdot; Sensor.MNoiseSwayDDot(it) = s.Sensor.MNoiseSwayDDot; Sensor.MNoiseHeaveDDot(it) = s.Sensor.MNoiseHeaveDDot; Sensor.MNoiseRollDot(it) = s.Sensor.MNoiseRollDot; Sensor.MNoisePitchDot(it) = s.Sensor.MNoisePitchDot; Sensor.MNoiseYawDot(it) = s.Sensor.MNoiseYawDot;
        

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Sensor', Sensor);
    assignin('base', 'SimulationEnvironment', SimulationEnvironment);

    
    % Calling the next logic instance 
    WindTurbine('logical_instance_06');



elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % SELECTING THE APPROACH FOR CONTROL AND STATE OBSERVER (ONLINE): 
    % Purpose of this Logical Instance: to select the control approach that
    % will be used, according to the choice made in Option 03 of the 
    % recursive function f1 (s.Option01f1). And within each control 
    % approach, there will be a Logical Instance that, according to 
    % Option 04 of the recursive function f1 (s.option04f1), selects 
    % the approach for estimating the effective wind speed and the 
    % state observer.


        %###### FILTERING SIGNALS FROM SENSORS ###### 

    % ---------- FILTERS ----------   
    if(s.newdt_c == 1)
        if (s.ct_c==0)  

            % ---- Filtering sensor signals for drive train dynamics ---- 
            if s.Option01f1 == 1
                % Gain-Scheduling Proportional Integrative with Tip-Speed-Ratio algorithm.                
                PIGainScheduledTSR_Abbas2022('logical_instance_03'); 
                %
           elseif s.Option01f1 == 2
               % Gain-Scheduling Proportional Integrative with Optimal-Torque-Control algorithm.
               PIGainScheduledOTC_Jonkman2009('logical_instance_03');
               %
            end


            % ---- Filtering sensor signals for tower top dynamics -----             
            if (s.Option02f2 > 1) || (s.Option04f3 == 1) 
                if (s.Option01f1 == 1) && (s.Option04f8 < 3)
                    % Gain-Scheduling Proportional Integrative with Tip-Speed-Ratio algorithm.                
                    PIGainScheduledTSR_Abbas2022('logical_instance_05'); 
                    %
                elseif (s.Option01f1 == 2) && (s.Option04f8 < 3)
                    % Gain-Scheduling Proportional Integrative with Optimal-Torque-Control algorithm.
                    PIGainScheduledOTC_Jonkman2009('logical_instance_05');
                    %
                end
                %
            end % if (s.Option02f2 > 1) || (s.Option04f3 == 1) || (s.Option04f8 < 3)   
            %
        end % if (s.ct_c==0)
    end % if(s.newdt_c == 1)




          %###### STATE OBSERVER ###### 

    % ---------- STATE OBSERVER ----------   
    if(s.newdt == 1)
        if (s.ct == 0)

            % % ------ Receiving and filtering signals from sensors ----- 
            % PIGainScheduledTSR_Abbas2022('logical_instance_03');


            % ------ Selecting Effective Wind Speed ​​Estimation Approach -----          
            if s.Option02f1 == 1 && s.Option01f1 == 1

                % State-Observer KALMAN FILTER and estimate 
                % Effective Wind Speed ​​with Nonlinear Wind Speed ​​Estimator                 
                EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_09');
                
                %
            elseif s.Option02f1 == 2 && s.Option01f1 == 1

                % State-Observer EXTENDED KALMAN FILTER and estimate 
                % Effective Wind Speed ​​directly or online 
                ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_07');

                %
            end            
            
            s.ntamos = s.ntamos + 1;
            %
        end % if (ct==0) --  Terminando o Contador do Filtro de Kalman

        s.ct = s.ct + 1;
        if (s.ct == s.ctmax)
            s.ct = 0;        
        end % Fim do loop do contador do Filtro de Kalman
        %
    end % if(s.newdt == 1) --- % SAÍDA DO CONTADOR DE AMOSTRAGEM FILTRO KALMAN
    



             %###### CONTROLLERS ###### 

    % ---------- CONTROLLERS ----------   
    if(s.newdt_c == 1)
        if (s.ct_c==0)  

            % ---------- Selecting the Control Approach ---------- 
            if s.Option01f1 == 1

                % Gain-Scheduling Proportional Integrative with Tip-Speed-Ratio algorithm.                
                PIGainScheduledTSR_Abbas2022('logical_instance_07'); 

                %
           elseif s.Option01f1 == 2

               % Gain-Scheduling Proportional Integrative with Optimal-Torque-Control algorithm.
               PIGainScheduledOTC_Jonkman2009('logical_instance_06');

               %
            end
            s.ntamos_c = s.ntamos_c + 1;


        end % if (s.ct_c==0)  -----  Terminando o Contador do Filtro de Kalman " if (ct_c==0)" 

        s.ct_c = s.ct_c + 1;
        if (s.ct_c == s.ctmax_c)
            s.ct_c = 0;        
        end % Fim do loop do contador dos controladores.
         
    end % if(s.newdt_c == 1) ---  SAÍDA DO CONTADOR DE AMOSTRAGEM CONTROLADORES


    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance   
    WindTurbine('logical_instance_07');


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
%=============================================================    
    % THE MAIN WIND TURBINE ASSEMBLY (ON-LINE):  
    % Purpose of this Logical Instance: to select which dynamics of the 
    % main wind turbine assembly will be considered in the simulation.
    % The components of the wind turbine main assembly are: the rotor 
    % (blades and hub), nacelle, drive train, tower, control actuators, 
    % converter/generator and power generation system. The selection is 
    % made according to the options of Logic Instance 01.


    % ----- INTERACTION BETWEEN WIND AND WAVE WITH WIND TURBINE ----- 
        % Interaction between Wind and Wind Turbine
    System_LoadsAerodynamics('logical_instance_05');

        % Aerodnyamic Model    
    System_LoadsAerodynamics('logical_instance_06');

        % Offshore Wind Turbine Assembly
    if s.Option02f2 > 1
            % Offshore Wind Turbine Assembly
        WindTurbine('logical_instance_08');
    end 



    % ---- BLADE PITCH ACTUATOR SYSTEM (Blade Pitch Dynamics) ----
    if s.Option01f3 == 1
        %   NOT consider the Blade Pitch dynamics, assuming that the 
        % blade pitch as relatively fast (Beta = Beta_d)
        WindTurbine_MainAssembly('logical_instance_03');
        %
    elseif s.Option01f3 == 2
        % Electromechanical Blade Pitch Systems (first-order model - delay behavior)
        WindTurbine_MainAssembly('logical_instance_04');
        %
    elseif s.Option01f3 == 3
        % Hydraulic Blade Pitch Systems (second-order model - oscillatory behavior).
        WindTurbine_MainAssembly('logical_instance_05');
        %
    end 
     


    % ---- GENERATOR/CONVERTER SYSTEM (Generator Torque Dynamics) ----
    if s.Option02f3 == 1
        %   NOT consider the Geneerator Torque dynamics, assuming that the 
        % generator torque as relatively fast (Tg = Tg_d)
        WindTurbine_MainAssembly('logical_instance_06');
        %
    else
        % Generator/Converter Dynamics (first-order model - delay behavior)
        WindTurbine_MainAssembly('logical_instance_07');
        %
    end 
             
    
    % ------------ DRIVE TRAIN DYNAMICS -----------    
    if s.Option03f3 == 1
        % One-Mass Model (Low Speed)
        WindTurbine_MainAssembly('logical_instance_08');
        %
    elseif s.Option03f3 == 2
        % One-Mass Model (High Speed)
        WindTurbine_MainAssembly('logical_instance_09');
        %
    elseif s.Option03f3 == 3
        % Two-Mass Model (Low and High Speeds shaft)
        WindTurbine_MainAssembly('logical_instance_10');
        %
    end
     


    % ------- POWER GENERATION/ENERGY CONVERTER ---------    
    WindTurbine_MainAssembly('logical_instance_11');



    % -------------- TOWER DYNAMICS --------------  
    if (s.Option02f2 > 1)
        % Consider the OFFSHORE WIND TURBINE
        if s.Option04f3 == 1
            % Tower Dynamics (fore-aft movement)
            WindTurbine_MainAssembly('logical_instance_13');
        else
            % Only Kinematics of the movement of the top of the tower
            WindTurbine_MainAssembly('logical_instance_14');            
        end
        %
    else
        % Consider the ONSHORE WIND TURBINE
        if s.Option04f3 == 1
            % Tower Dynamics (fore-aft movement)
            WindTurbine_MainAssembly('logical_instance_12');            
        end
        %
    end

         

    % -------- BLADE DYNAMICS (rotor dynamics - part 1) ------------   
    if s.Option05f3 == 1
        % Blade Dynamics (flap-wise blade bending)
        WindTurbine_MainAssembly('logical_instance_15');
    end

     

    % ----- HUB/ROTOR DYNAMICS (rotor inclinations - rotor dynamics part 2) -----   
    if s.Option06f3 == 1
        % Hub/Rotor Dynamics (rotor-teeter, rotor-furl, tail inclination, and furling action)
        WindTurbine_MainAssembly('logical_instance_16');
    end

     
    
    % -------------- NACELLE DYNAMICS --------------   
    if s.Option07f3 == 1
        % Nacelle Dynamics (assuming that the nacelle is rotated to align the rotor with the wind direction)
        WindTurbine_MainAssembly('logical_instance_17');

        % NOTE: The option s.Option07f3 = 2 considers that the rotor is always aligned with the wind direction.
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "EnviromentSimulation('logical_instance_04')"
    


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================       
    % THE OFFSHORE WIND TURBINE ASSEMBLY (ON-LINE):    
    % Purpose of this Logical Instance: to select the offshore wind turbine
    % assembly, optionally choosing between floating wind turbines and 
    % fixed bottom wind turbines. The respective dynamics and models are 
    % detailed and implemented in the respective Recursive Function (fi). 
    % In Option 02 of the recursive function 1 (s.Option02f2), some 
    % offshore assembly approaches for the wind turbine are presented.   


    % Calling the next logic instance
    if s.Option02f2 == 2 
        % OFFSHORE WIND TURBINE

        % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
        WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_04');

    elseif s.Option02f2 == 3
        % OFFSHORE WIND TURBINE        

        % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
        WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_04');

    elseif s.Option02f2 == 4 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Submersible Platform ----------
        WindTurbine_OffshoreAssembly_Submersible('logical_instance_04');

    elseif s.Option02f2 == 5 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Barge Platform ----------
        WindTurbine_OffshoreAssembly_Barge('logical_instance_04');

    elseif s.Option02f2 == 6 
        % OFFSHORE WIND TURBINE

        % ---------- Fixed-Bottom Offshore Wind Turbine ----------
        WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_04');
        %  
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================       
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to save current values, based on 
    % the last integration step taken.  


    % Calling the next logic instance
    if s.Option02f2 == 2 
        % OFFSHORE WIND TURBINE

        % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
        WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_13');

    elseif s.Option02f2 == 3
        % OFFSHORE WIND TURBINE        

        % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
        WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_13');

    elseif s.Option02f2 == 4 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Submersible Platform ----------
        WindTurbine_OffshoreAssembly_Submersible('logical_instance_13');

    elseif s.Option02f2 == 5 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Barge Platform ----------
        WindTurbine_OffshoreAssembly_Barge('logical_instance_13');

    elseif s.Option02f2 == 6 
        % OFFSHORE WIND TURBINE

        % ---------- Fixed-Bottom Offshore Wind Turbine ----------
        WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_13');
        %  
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================       
    % PLOT OFFSHORE ASSEMBLY DYNAMICS RESULTS (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % dynamics of Offshore Assembly and develop any other calculations,
    % tables and data to support the analysis of the results.

    
    % Calling the next logic instance
    if s.Option02f2 == 2 
        % OFFSHORE WIND TURBINE

        % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
        WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_14');

    elseif s.Option02f2 == 3
        % OFFSHORE WIND TURBINE        

        % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
        WindTurbine_OffshoreAssembly_SparBuoy('logical_instance_14');

    elseif s.Option02f2 == 4 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Submersible Platform ----------
        WindTurbine_OffshoreAssembly_Submersible('logical_instance_13');

    elseif s.Option02f2 == 5 
        % OFFSHORE WIND TURBINE

        % ---------- Floating Wind Turbine with Barge Platform ----------
        WindTurbine_OffshoreAssembly_Barge('logical_instance_14');

    elseif s.Option02f2 == 6 
        % OFFSHORE WIND TURBINE

        % ---------- Fixed-Bottom Offshore Wind Turbine ----------
        WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_14');
        %  
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    
%=============================================================  
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'Sensor', Sensor);
assignin('base', 'MeasurementCovariances', MeasurementCovariances);
assignin('base', 'ProcessCovariances', ProcessCovariances);
assignin('base', 'WindTurbineOutput', WindTurbineOutput);
assignin('base', 'SimulationEnvironment', SimulationEnvironment);


% #######################################################################
end