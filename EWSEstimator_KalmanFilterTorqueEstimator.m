function EWSEstimator_KalmanFilterTorqueEstimator(action)
% ########## STATE VARIABLE AND PARAMETER ESTIMATION PROBLEMS ##########
% ######################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Oceanic 
% Engineering in 2025. Reviewed and supervised by Professor Dr. Helio 
% Mitio Morishita. Code developed in Matlab 2022b.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains the approach related to the problem 
% of estimating state variables and parameters. The approach adopted is 
% based on the master's thesis of the present author, which uses a 
% Kalman Filter and the estimation of aerodynamic torque as an augmented
% state variable using a random walk model. In addition, a nonlinear 
% function solver is used to calculate the effective wind speed, 
% utilizing the values from the Kalman Filter.


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
    % related to this recursive function "EWSEstimator_KalmanFilterTorqueEstimator.m". 


    % ---------- Option 01: Choose the Generator Torque signal ----------
    who.Option01f9.Option_01 = 'Option 01 of Recursive Function f9';
    who.Option01f9.about = 'Choose the Generator Torque signal (State Observer input)';
    who.Option01f9.choose_01 = 's.Option01f9 == 1 to use the last controller signal (s.Tg_system = s.Tg_d_before) as input to the State Observer.';
    who.Option01f9.choose_02 = 's.Option01f9 == 2 to use the measured and low-pass filtered signal (s.Tg_system = s.Tg_filteredLPF1) as input to the State Observer.';
    who.Option01f9.choose_03 = 's.Option01f9 == 3 to use the measured signal (s.Tg_system = s.Tg_measured) as input to the State Observer.';
        % Choose your option:
    s.Option01f9 = 1; 
    if s.Option01f9 == 1 || s.Option01f9 == 2 || s.Option01f9 == 3
        KalmanFilter.Option01f9 = s.Option01f9;
    else
        error('Invalid option selected for s.Option01f9. Please choose 1 or 2 or 3.');
    end


    % ---------- Option 02: Choose the Blade Pitch signal ----------
    who.Option02f9.Option_02 = 'Option 02 of Recursive Function f9';
    who.Option02f9.about = 'Choose the Blade Pitch signal (State Observer input).';
    who.Option02f9.choose_01 = 'Option02f9 == 1 to use the last controller signal (s.Beta_system = s.Beta_d) as input to the State Observer.';
    who.Option02f9.choose_02 = 'Option02f9 == 2 to use the measured and low-pass filtered signal (s.Beta_system = s.Beta_filteredLPF1) as input to the State Observer.';    
    who.Option02f9.choose_03 = 'Option03f9 == 3 to use the measured signal (s.Beta_system = s.Beta_measured) as input to the State Observer.';
        % Choose your option:
    s.Option02f9 = 2; 
    if s.Option02f9 == 1 || s.Option02f9 == 2 || s.Option02f9 == 3
        KalmanFilter.Option02f9 = s.Option02f9;
    else
        error('Invalid option selected for Option02f9. Please choose 1 or 2 or 3.');
    end    

    % ---------- Option 03: Choosing the Estimation Theory for the State Observer ----------
    who.Option03f9.Option_03 = 'Option 03 of Recursive Function f9';
    who.Option03f9.about = 'Choosing the Method for the Effective Wind Speed ​​Estimator';
    who.Option03f9.choose_01 = 's.Option03f9 == 1 to choose Solver using the "fzero" algorithm available in Matlab, which automatically selects the best interpolation method (bisection, secant and inverse quadratic).';
    who.Option03f9.choose_02 = 's.Option03f9 == 2 to choose Solver using the Newton-Raphson Method.';
        % Choose your option:
    s.Option03f9 = 1; 
    if s.Option03f9 == 1 || s.Option03f9 == 2
        KalmanFilter.Option03f9 = s.Option03f9;
    else
        error('Invalid option selected for s.Option03f9. Please choose 1 or 2.');
    end


    % ---------- Option 04: Initial guess for solving the Aerodynamic Torque Function ----------
    who.Option04f9.Option_04 = 'Option 04 of Recursive Function f9';
    who.Option04f9.about = 'Initial guess for solving the Aerodynamic Torque Function.';
    who.Option04f9.choose_01 = 'Option04f9 == 1 to choose to use the last Estimated Effective Wind Speed.';
    who.Option04f9.choose_02 = 'Option04f9 == 2 to choose to use tabulated values ​​of CP and Observer State values ​​to identify the operating point.';    
        % Choose your option:
    s.Option04f9 = 2; 
    if s.Option04f9 == 1 || s.Option04f9 == 2
        KalmanFilter.Option04f9 = s.Option04f9;
    else
        error('Invalid option selected for Option04f9. Please choose 1 or 2.');
    end       


    % ------ Option 05: Plot figures from the Effective Wind Speed ​​estimation ------
    who.Option05f9.Option_05 = 'Option 05 of Recursive Function f9';
    who.Option05f9.about = 'Option to plot figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';
    who.Option05f9.choose_01 = 'Option05f9 == 1 to choose DO NOT PLOT figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';
    who.Option05f9.choose_02 = 'Option05f9 == 2 to choose PLOT figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';  
    who.Option05f9.choose_03 = 'Option05f9 == 3 to choose PLOT spectrum comparison .';         
        % Choose your option:
    s.Option05f9 = 3; 
    if s.Option05f9 == 1 || s.Option05f9 == 2 || s.Option05f9 == 3
        KalmanFilter.Option05f9 = s.Option05f9;
    else
        error('Invalid option selected for Option05f9. Please choose 1 or 2 or 3.');
    end   


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Return to EnviromentSimulation('logical_instance_01');


elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES BASED ON CHOSEN OPTIONS (OFFLINE):
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f12), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.

    % ---------- Sampling of the Kalman Filter ----------
    who.Sample_Frequency = 'Sampling of the Kalman Filter, in [Hz]';
    s.Sample_Frequency = 1; 

    who.Sample_RateOS = 'Sampling of the Kalman Filter, in [s]';
    s.Sample_RateOS = 1/s.Sample_Frequency;


    % Organizing output results
    KalmanFilter.Sample_Frequency = s.Sample_Frequency; KalmanFilter.Sample_RateOS = s.Sample_RateOS;     


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_03'); 


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================      
    % DEFINITION OF PROCESS COVARIANCES (OFFLINE):   
    % Purpose of this Logical Instance: design the covariance matrix of 
    % the "Q" process, used in Kalman's filter modeling. Also, define the
    % covaries of dynamics that do not enter the Kalman filter, but which 
    % are used in the turbine simulation.


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
            % s.BetaY = s.Betad_op + s.Beta_dDot*s.dt; % plot(s.BetaY)
            % s.tau_BetaY = (1 ./ s.Beta_dDot) .* ( s.Beta_d - s.BetaY ) ; 
            % s.tau_BetaYY = mean(s.tau_BetaY); % s.tau_Beta == 0.2579  [seg]
            % s.TgY = s.Tgd_op + s.Tg_dDot*s.dt; % plot(s.TgY)
            % s.tau_TgY = (1 ./ s.Tg_dDot) .* ( s.Beta_d - s.TgY ) ; 
            % s.tau_TgYY = mean(s.tau_TgY); % s.tau_Tg == 0.1  [seg]  
            
                    % Delay in control system:
            % s.BetaY = s.Betad_op + s.Beta_dDot*s.dt; % plot(s.BetaY)            
            % s.tau_BetaY = (1 ./ s.Beta_dDot) .* ( s.Beta_d - s.BetaY ) ; 
            % s.tau_BetaYY = mean(s.tau_BetaY); % s.tau_Beta == 0.1647 to 0.2806 [seg]   (transition 0.05)
            % s.TgY = s.Tgd_op + s.Tg_dDot*s.dt; % plot(s.TgY)
            % s.tau_TgY = (1 ./ s.Tg_dDot) .* ( s.Tg_d - s.TgY ) ; 
            % s.tau_TgY = s.tau_TgY(~isnan(s.tau_TgY) & ~isinf(s.tau_TgY));         
            % s.tau_TgYY = mean(s.tau_TgY); % s.tau_Tg == 3.2620 to 4.1920 [seg] 


    % ---------- Wind signal covariance analysis ----------
    who.MaximumVar_Vews = 'Maximum variation of the effective wind speed vector, in [deg].';
    s.MaximumVar_Vews = max(abs(diff(s.Uews_full))) ;    
    who.MaximumVar_OmegaR = 'Maximum variation of the Generator Torque vector, in [N.m].';
    s.MaximumVar_OmegaR = max(abs(diff(interp1(s.Vop, s.OmegaR_op, s.Uews_full)))) ;
    who.MaximumVar_Lambda = 'Maximum variation of the Generator Torque vector, in [N.m].';
    s.MaximumVar_Lambda = max(abs(diff(interp1(s.Vop, s.Lambda_op, s.Uews_full)))) ;
    who.MaximumVar_Cp = 'Maximum variation of the Generator Torque vector, in [N.m].';
    s.MaximumVar_Cp = max(abs(diff(interp1(s.Vop, s.CP_op, s.Uews_full)))) ;    
    who.MaximumVar_beta = 'Maximum variation of the Collective Blade Pitch vector, in [deg].';
    s.MaximumVar_beta = max(abs(diff(interp1(s.Vop, s.Beta_op, s.Uews_full)))) ;
    who.MaximumVar_Tg = 'Maximum variation of the Generator Torque vector, in [N.m].';
    s.MaximumVar_Tg = max(abs(diff(interp1(s.Vop, s.Tg_op, s.Uews_full)))) ;
    who.MaximumVar_Ta = 'Maximum variation of the Aerodynamic Torque vector, in [N.m].';
    s.MaximumVar_Ta = max(abs(diff(interp1(s.Vop, s.Ta_op, s.Uews_full)))) ; 
    who.MaximumVar_Pe = 'Maximum variation of the Electrical Power vector, in [W].';
    s.MaximumVar_Pe = max(abs(diff(interp1(s.Vop, s.Pe_op, s.Uews_full)))) ;
    who.MaximumVar_Pa = 'Maximum variation of the Aerodynamic Power vector, in [W].';
    s.MaximumVar_Pa = max(abs(diff(interp1(s.Vop, s.Pa_op, s.Uews_full)))) ;    


    % ---------- Process Covariance (system disturbance) used in State Observers ----------
    who.AveragePP_Tg_Dot = 'Average of generator torque, in [N.m].';
    who.StandardDeviationPP_Tg_Dot = 'Process standard deviation for the dynamics of generator torque, in [N.m].';       
    s.AveragePP_Tg_Dot = 0;    
    s.StandardDeviationPP_Tg_Dot = sqrt(1.1082e+04*0.1) ; % OR ( 0.069*(s.TgDot_max*s.eta_gb) / 3 ) OR ( 0.10*(s.TgDot_max*s.eta_gb) ) / 3 ;
    s.WhiteNoisePP_Tg_Dot = s.StandardDeviationPP_Tg_Dot*randn(1,s.Ns) + s.AveragePP_Tg_Dot*ones(1,s.Ns);
    s.CovariancePP_Tg_Dot = cov(s.WhiteNoisePP_Tg_Dot');

    who.AveragePP_Ta_Dot = 'Average of aerodynamic torque, in [N.m].';
    who.StandardDeviationPP_Ta_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.AveragePP_Ta_Dot = 0;
    s.StandardDeviationPP_Ta_Dot = (1.01*(s.TgDot_max*s.eta_gb)) / 3 ; % OR sqrt(1.1153e+04*1.01) OR (1.2743*(s.TgDot_max*s.eta_gb)) / 3
    s.WhiteNoisePP_Ta_Dot = s.StandardDeviationPP_Ta_Dot*randn(1,s.Ns) + s.AveragePP_Ta_Dot*ones(1,s.Ns);
    s.CovariancePP_Ta_Dot = cov(s.WhiteNoisePP_Ta_Dot');

    who.AveragePP_OmegaR_Ddot = 'Average of rotor speed, in [rad/s^2].';
    who.StandardDeviationPP_OmegaR_Ddot = 'Process standard deviation for the dynamics of rotor speed, in [rad/s^2].';
    s.AveragePP_OmegaR_Ddot = 0;
    s.StandardDeviationPP_OmegaR_Ddot = sqrt(2.2705e-04*0.1)  ; % OR s.StandardDeviationPP_Ta_Dot / s.J_t OR 0.0141 OR 0.001 / 3 ;
    s.WhiteNoisePP_OmegaR_Ddot = s.StandardDeviationPP_OmegaR_Ddot*randn(1,s.Ns) + s.AveragePP_OmegaR_Ddot*ones(1,s.Ns);
    s.CovariancePP_OmegaR_Ddot = cov(s.WhiteNoisePP_OmegaR_Ddot'); % 1e-9 to 1e-8


    % ---------- ## Design Process Covariance Matrix "Q" ## ----------    
    who.Q = 'Process Covariance Matrix (Q) for Kalman Filter Theory, in [rad/s].';
    s.Q = [s.CovariancePP_OmegaR_Ddot 0;0 s.CovariancePP_Ta_Dot];  


    % AND


    % ---------- Other Process Covariance (system disturbance) ----------         
    who.AveragePP_OmegaG_Ddot = 'Average of generator speed, in [rad/s].';
    who.StandardDeviationPP_OmegaG_Ddot = 'Process standard deviation for the dynamics of generator speed, in [rad/s^2].';    
    s.AveragePP_OmegaG_Ddot = 0;    
    s.StandardDeviationPP_OmegaG_Ddot = s.eta_gb*s.StandardDeviationPP_OmegaR_Ddot;
    s.WhiteNoisePP_OmegaG_Ddot = s.StandardDeviationPP_OmegaG_Ddot*randn(1,s.Ns) + s.AveragePP_OmegaG_Ddot*ones(1,s.Ns);
    s.CovariancePP_OmegaG_Ddot = cov(s.WhiteNoisePP_OmegaG_Ddot');

    who.AveragePP_Beta_Dot = 'Average of Blade Pitch, in [deg].';
    who.StandardDeviationPP_Beta_Dot = 'Process standard deviation for the dynamics of Blade Pitch, in [deg].';       
    s.AveragePP_Beta_Dot = 0;    
    s.StandardDeviationPP_Beta_Dot = sqrt(3.4618e-07*0.1) ; % OR (s.BetaDot_max/6)*sqrt(s.dt)
    s.WhiteNoisePP_Beta_Dot = s.StandardDeviationPP_Beta_Dot*randn(1,s.Ns) + s.AveragePP_Beta_Dot*ones(1,s.Ns);
    s.CovariancePP_Beta_Dot = cov(s.WhiteNoisePP_Beta_Dot');


    who.AveragePP_ThetaYaw_dot = 'Average of Yaw angular velocity (rotation around the tower), in [rad/s^2].';
    who.StandardDeviationPP_ThetaYaw_dot = 'Process standard deviation for the dynamics of Yaw angle (rotation around the tower), in [rad/s^2].';       
    s.AveragePP_ThetaYaw_dot = 0;    
    s.StandardDeviationPP_ThetaYaw_dot = 1e-8;
    s.WhiteNoisePP_ThetaYaw_dot = s.StandardDeviationPP_ThetaYaw_dot*randn(1,s.Ns) + s.AveragePP_ThetaYaw_dot*ones(1,s.Ns);
    s.CovariancePP_ThetaYaw_dot = cov(s.WhiteNoisePP_ThetaYaw_dot');     

    who.AveragePP_surge_Ddot = 'Average of surge, in [m/s^2].';
    who.StandardDeviationPP_surge_Ddot = 'Process standard deviation for the dynamics of surge, in [m/s^2].';       
    s.AveragePP_surge_Ddot = 0;    
    s.StandardDeviationPP_surge_Ddot = 0.1/1; 
    s.WhiteNoisePP_surge_Ddot = s.StandardDeviationPP_surge_Ddot*randn(1,s.Ns) + s.AveragePP_surge_Ddot*ones(1,s.Ns);
    s.CovariancePP_surge_Ddot = cov(s.WhiteNoisePP_surge_Ddot');   

    who.AveragePP_sway_Ddot = 'Average of sway_Ddot, in [m/s^2].';
    who.StandardDeviationPP_sway_Ddot = 'Process standard deviation for the dynamics of sway_Ddot, in [m/s^2].';       
    s.AveragePP_sway_Ddot = 0;    
    s.StandardDeviationPP_sway_Ddot = 0.1/1;
    s.WhiteNoisePP_sway_Ddot = s.StandardDeviationPP_sway_Ddot*randn(1,s.Ns) + s.AveragePP_sway_Ddot*ones(1,s.Ns);
    s.CovariancePP_sway_Ddot = cov(s.WhiteNoisePP_sway_Ddot');
    
    who.AveragePP_heave_Ddot = 'Average of heave_Ddot, in [m/s^2].';
    who.StandardDeviationPP_heave_Ddot = 'Process standard deviation for the dynamics of heave_Ddot, in [m/s^2].';       
    s.AveragePP_heave_Ddot = 0;    
    s.StandardDeviationPP_heave_Ddot = 0.1/1;
    s.WhiteNoisePP_heave_Ddot  = s.StandardDeviationPP_heave_Ddot*randn(1,s.Ns) + s.AveragePP_heave_Ddot*ones(1,s.Ns);
    s.CovariancePP_heave_Ddot  = cov(s.WhiteNoisePP_heave_Ddot');    
    
    who.AveragePP_roll_dot = 'Average of roll, in [m].';
    who.StandardDeviationPP_roll_dot = 'Process standard deviation for the dynamics of roll, in [rad/s^2].';    
    s.AveragePP_roll_dot = 0;    
    s.StandardDeviationPP_roll_dot = 1e-6/1; 
    s.WhiteNoisePP_roll_dot = s.StandardDeviationPP_roll_dot*randn(1,s.Ns) + s.AveragePP_roll_dot*ones(1,s.Ns);
    s.CovariancePP_roll_dot = cov(s.WhiteNoisePP_roll_dot'); 
    
    who.AveragePP_pitch_dot = 'Average of pitch, in [m].';
    who.StandardDeviationPP_pitch_dot = 'Process standard deviation for the dynamics of pitch, in [rad/s^2].';       
    s.AveragePP_pitch_dot = 0;    
    s.StandardDeviationPP_pitch_dot = 1e-6/1; 
    s.WhiteNoisePP_pitch_dot = s.StandardDeviationPP_pitch_dot*randn(1,s.Ns) + s.AveragePP_pitch_dot*ones(1,s.Ns);
    s.CovariancePP_pitch_dot = cov(s.WhiteNoisePP_pitch_dot');   
    
    who.AveragePP_yaw_dot = 'Average of yaw, in [m].';
    who.StandardDeviationPP_yaw_dot = 'Process standard deviation for the dynamics of yaw, in [rad/s^2].';     
    s.AveragePP_yaw_dot = 0;    
    s.StandardDeviationPP_yaw_dot = 1e-6/1; 
    s.WhiteNoisePP_yaw_dot = s.StandardDeviationPP_yaw_dot*randn(1,s.Ns) + s.AveragePP_yaw_dot*ones(1,s.Ns);
    s.CovariancePP_yaw_dot = cov(s.WhiteNoisePP_yaw_dot');   

    % Note: in the dynamics add the noise this way, just edit the suffix "_XXXX":
    % s.WhiteNoisePP_XXXX(randi([1, numel(s.WhiteNoisep_XXXX)]))
    
    % Organizing output results
    KalmanFilter.Q = s.Q;
    KalmanFilter.MaximumVar_Vews = s.MaximumVar_Vews; KalmanFilter.MaximumVar_OmegaR = s.MaximumVar_OmegaR; KalmanFilter.MaximumVar_Lambda = s.MaximumVar_Lambda; KalmanFilter.MaximumVar_Cp = s.MaximumVar_Cp; KalmanFilter.MaximumVar_beta = s.MaximumVar_beta; KalmanFilter.MaximumVar_Tg = s.MaximumVar_Tg; KalmanFilter.MaximumVar_Ta = s.MaximumVar_Ta; KalmanFilter.MaximumVar_Pe = s.MaximumVar_Pe; KalmanFilter.MaximumVar_Pa = s.MaximumVar_Pa;
    KalmanFilter.AveragePP_OmegaR_Ddot = s.AveragePP_OmegaR_Ddot; KalmanFilter.StandardDeviationPP_OmegaR_Ddot = s.StandardDeviationPP_OmegaR_Ddot; KalmanFilter.WhiteNoisePP_OmegaR_Ddot = s.WhiteNoisePP_OmegaR_Ddot; KalmanFilter.CovariancePP_OmegaR_Ddot = s.CovariancePP_OmegaR_Ddot;    
    KalmanFilter.AveragePP_Ta_Dot = s.AveragePP_Ta_Dot; KalmanFilter.StandardDeviationPP_Ta_Dot = s.StandardDeviationPP_Ta_Dot; KalmanFilter.WhiteNoisePP_Ta_Dot = s.WhiteNoisePP_Ta_Dot; KalmanFilter.CovariancePP_Ta_Dot = s.CovariancePP_Ta_Dot; 
    KalmanFilter.AveragePP_OmegaG_Ddot = s.AveragePP_OmegaG_Ddot; KalmanFilter.StandardDeviationPP_OmegaG_Ddot = s.StandardDeviationPP_OmegaG_Ddot; KalmanFilter.WhiteNoisePP_OmegaG_Ddot = s.WhiteNoisePP_OmegaG_Ddot; KalmanFilter.CovariancePP_OmegaG_Ddot = s.CovariancePP_OmegaG_Ddot; 

    KalmanFilter.AveragePP_Beta_Dot = s.AveragePP_Beta_Dot; KalmanFilter.StandardDeviationPP_Beta_Dot = s.StandardDeviationPP_Beta_Dot; KalmanFilter.WhiteNoisePP_Beta_Dot = s.WhiteNoisePP_Beta_Dot; KalmanFilter.CovariancePP_Beta_Dot = s.CovariancePP_Beta_Dot;
    KalmanFilter.AveragePP_Tg_Dot = s.AveragePP_Tg_Dot; KalmanFilter.StandardDeviationPP_Tg_Dot = s.StandardDeviationPP_Tg_Dot; KalmanFilter.WhiteNoisePP_Tg_Dot = s.WhiteNoisePP_Tg_Dot; KalmanFilter.CovariancePP_Tg_Dot = s.CovariancePP_Tg_Dot;      
    KalmanFilter.AveragePP_ThetaYaw_dot = s.AveragePP_ThetaYaw_dot; KalmanFilter.StandardDeviationPP_ThetaYaw_dot = s.StandardDeviationPP_ThetaYaw_dot; KalmanFilter.WhiteNoisePP_ThetaYaw_dot = s.WhiteNoisePP_ThetaYaw_dot; KalmanFilter.CovariancePP_ThetaYaw_dot = s.CovariancePP_ThetaYaw_dot;       

    KalmanFilter.AveragePP_surge_Ddot = s.AveragePP_surge_Ddot; KalmanFilter.StandardDeviationPP_surge_Ddot = s.StandardDeviationPP_surge_Ddot; KalmanFilter.WhiteNoisePP_surge_Ddot = s.WhiteNoisePP_surge_Ddot; KalmanFilter.CovariancePP_surge_Ddot = s.CovariancePP_surge_Ddot;    
    KalmanFilter.AveragePP_sway_Ddot = s.AveragePP_sway_Ddot; KalmanFilter.StandardDeviationPP_sway_Ddot = s.StandardDeviationPP_sway_Ddot; KalmanFilter.WhiteNoisePP_sway_Ddot = s.WhiteNoisePP_sway_Ddot; KalmanFilter.CovariancePP_sway_Ddot_Ddot = s.CovariancePP_sway_Ddot;     
    KalmanFilter.AveragePP_heave_Ddot = s.AveragePP_heave_Ddot; KalmanFilter.StandardDeviationPP_heave_Ddot = s.StandardDeviationPP_heave_Ddot; KalmanFilter.WhiteNoisePP_heave_Ddot = s.WhiteNoisePP_heave_Ddot; KalmanFilter.CovariancePP_heave_Ddot = s.CovariancePP_heave_Ddot;    
    KalmanFilter.AveragePP_roll_dot = s.AveragePP_roll_dot; KalmanFilter.StandardDeviationPP_roll_dot = s.StandardDeviationPP_roll_dot; KalmanFilter.WhiteNoisePP_roll_dot = s.WhiteNoisePP_roll_dot; KalmanFilter.CovariancePP_roll_dot = s.CovariancePP_roll_dot;       
    KalmanFilter.AveragePP_pitch_dot = s.AveragePP_pitch_dot; KalmanFilter.StandardDeviationPP_pitch_dot = s.StandardDeviationPP_pitch_dot; KalmanFilter.WhiteNoisePP_pitch_dot = s.WhiteNoisePP_pitch_dot; KalmanFilter.CovariancePP_pitch_dot = s.CovariancePP_pitch_dot; 
    KalmanFilter.AveragePP_yaw_dot = s.AveragePP_yaw_dot; KalmanFilter.StandardDeviationPP_yaw_dot = s.StandardDeviationPP_yaw_dot; KalmanFilter.WhiteNoisePP_yaw_dot = s.WhiteNoisePP_yaw_dot; KalmanFilter.CovariancePP_yaw_dot = s.CovariancePP_yaw_dot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance    
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_04');

%=============================================================
elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % DEFINITION OF MEASUREMENT COVARIANCES (OFFLINE):   
    % Purpose of this Logical Instance: design the measurement covariance 
    % matrix "R", used in the modeling of the Kalman Filter. In addition, 
    % define the covariances of sensor/instrument measurements.

 
    % ---- Measurements Covariance (by Sensors/Instrumentation) used in State Observers ----    
    who.AverageM_Beta = 'Average of blade pitch, in [deg].';
    who.StandardDeviationM_Beta = 'Standard deviation of measurements made from blade pitch, in [deg].';    
    s.AverageM_Beta = 0;    
    s.StandardDeviationM_Beta = sqrt(3.4618e-07*0.05) ; % OR 0.05 / 3 OR (0.01*s.BetaDot_max) / 4 ;
    s.WhiteNoiseM_Beta = s.StandardDeviationM_Beta*randn(1,s.Ns) + s.AverageM_Beta*ones(1,s.Ns);
    s.CovarianceM_Beta = cov(s.WhiteNoiseM_Beta');  

    who.AverageM_Tg = 'Average of generator torque, in [N.m].';
    who.StandardDeviationM_Tg = 'Standard deviation of measurements made from generator torque, in [N.m].';       
    s.AverageM_Tg = 0;    
    s.StandardDeviationM_Tg = sqrt(1.1082e+04*0.05) ; % OR ( 0.355*(s.TgDot_max*s.eta_gb) ) / 3 OR 1e+3 / 3 ;
    s.WhiteNoiseM_Tg = s.StandardDeviationM_Tg*randn(1,s.Ns) + s.AverageM_Tg*ones(1,s.Ns);
    s.CovarianceM_Tg = cov(s.WhiteNoiseM_Tg');

    who.AverageM_omega_r = 'Average of rotor speed, in [rad/s].';
    who.StandardDeviationM_omega_r = 'Standard deviation of measurements made from rotor speed, in [rad/s].';
    s.AverageM_omega_r = 0;
    s.StandardDeviationM_omega_r = sqrt(2.2705e-04*0.05)  ; % OR ((2*pi*0.05)/(60)) / 3 OR s.StandardDeviationM_Tg / s.J_t    
    s.WhiteNoiseM_omega_r = s.StandardDeviationM_omega_r*randn(1,s.Ns) + s.AverageM_omega_r*ones(1,s.Ns);
    s.CovarianceM_omega_r = cov(s.WhiteNoiseM_omega_r');


    % ---------- Other Process Covariance (system disturbance) ----------         
    who.AverageM_omega_g = 'Average of generator speed, in [rad/s].';
    who.StandardDeviationM_omega_g = 'Standard deviation of measurements made from generator speed, in [rad/s].';    
    s.AverageM_omega_g = 0;    
    s.StandardDeviationM_omega_g = s.StandardDeviationM_omega_r * s.eta_gb ;
    s.WhiteNoiseM_omega_g = s.StandardDeviationM_omega_g*randn(1,s.Ns) + s.AverageM_omega_g*ones(1,s.Ns);
    s.CovarianceM_omega_g = cov(s.WhiteNoiseM_omega_g'); 
    
    who.AverageM_Pe = 'Average of electrical power, in [W].';
    who.StandardDeviationM_Pe = 'Standard deviation of measurements made from electrical power, in [W].';       
    s.AverageM_Pe = 0;    
    s.StandardDeviationM_Pe = sqrt(2.3452e+04*0.05) ; % OR ( s.OmegaR_Rated*1e+4 ) / 3 ;
    s.WhiteNoiseM_Pe = s.StandardDeviationM_Pe*randn(1,s.Ns) + s.AverageM_Pe*ones(1,s.Ns);
    s.CovarianceM_Pe = cov(s.WhiteNoiseM_Pe');

    who.AverageM_Vws_hub = 'Average of hub-height wind speed measured by anemometer, in [m/s].';
    who.StandardDeviationM_Vws_hub = 'Standard deviation of measurements made from hub-height wind speed measured by anemometer, in [m/s].';       
    s.AverageM_Vws_hub = 0;    
    s.StandardDeviationM_Vws_hub = sqrt(4.3535) ;
    s.WhiteNoiseM_Vws_hub = s.StandardDeviationM_Vws_hub*randn(1,s.Ns) + s.AverageM_Vws_hub*ones(1,s.Ns);
    s.CovarianceM_Vws_hub = cov(s.WhiteNoiseM_Vws_hub');        

    who.AverageM_surge_Ddot = 'Average of surge, in [m/s^2].';
    who.StandardDeviationM_surge_Ddot = 'Standard deviation of measurements made from surge, in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_surge_Ddot = 0;    
    s.StandardDeviationM_surge_Ddot = 0.00005*200*s.gravity; 
    s.WhiteNoiseM_surge_Ddot = s.StandardDeviationM_surge_Ddot*randn(1,s.Ns) + s.AverageM_surge_Ddot*ones(1,s.Ns);
    s.CovarianceM_surge_Ddot = cov(s.WhiteNoiseM_surge_Ddot');   

    who.AverageM_sway_Ddot = 'Average of sway_Ddot, in [m/s^2].';
    who.StandardDeviationM_sway_Ddot = 'Standard deviation of measurements made from sway_Ddot, in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_sway_Ddot = 0;    
    s.StandardDeviationM_sway_Ddot = 0.00005*200*s.gravity;
    s.WhiteNoiseM_sway_Ddot = s.StandardDeviationM_sway_Ddot*randn(1,s.Ns) + s.AverageM_sway_Ddot*ones(1,s.Ns);
    s.CovarianceM_sway_Ddot = cov(s.WhiteNoiseM_sway_Ddot');
    
    who.AverageM_heave_Ddot = 'Average of heave_Ddot, in [m/s^2].';
    who.StandardDeviationM_heave_Ddot = 'Standard deviation of measurements made from heave_Ddot, in [m/s^2]. Accelerometers: Adopt 0.001% to 0.005% of the full scale (maximum interval that the accelerometer can measure - ±2g to ±200g), where "g" and acceleration of gravity.';       
    s.AverageM_heave_Ddot = 0;    
    s.StandardDeviationM_heave_Ddot = 0.00005*200*s.gravity;
    s.WhiteNoiseM_heave_Ddot  = s.StandardDeviationM_heave_Ddot*randn(1,s.Ns) + s.AverageM_heave_Ddot*ones(1,s.Ns);
    s.CovarianceM_heave_Ddot  = cov(s.WhiteNoiseM_heave_Ddot');    
    
    who.AverageM_roll_dot = 'Average of roll, in [m].';
    who.StandardDeviationM_roll_dot = 'Standard deviation of measurements made from roll, in [rad/s^2]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';    
    s.AverageM_roll_dot = 0;    
    s.StandardDeviationM_roll_dot = 4.85e-7; % Drift Rate == ±0,01 [°/hours] == 4.85e-7 [rad/s]
    s.WhiteNoiseM_roll_dot = s.StandardDeviationM_roll_dot*randn(1,s.Ns) + s.AverageM_roll_dot*ones(1,s.Ns);
    s.CovarianceM_roll_dot = cov(s.WhiteNoiseM_roll_dot'); 
    
    who.AverageM_pitch_dot = 'Average of pitch, in [m].';
    who.StandardDeviationM_pitch_dot = 'Standard deviation of measurements made from pitch, in [rad/s^2]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';       
    s.AverageM_pitch_dot = 0;    
    s.StandardDeviationM_pitch_dot = 4.85e-7; % Drift Rate == ±0,01 [°/hours]
    s.WhiteNoiseM_pitch_dot = s.StandardDeviationM_pitch_dot*randn(1,s.Ns) + s.AverageM_pitch_dot*ones(1,s.Ns);
    s.CovarianceM_pitch_dot = cov(s.WhiteNoiseM_pitch_dot');   
    
    who.AverageM_yaw_dot = 'Average of yaw, in [m].';
    who.StandardDeviationM_yaw_dot = 'Standard deviation of measurements made from yaw, in [rad/s^2]. Gyroscope: Adopt Drift Rate == ±0,01 [degrees/hours].';     
    s.AverageM_yaw_dot = 0;    
    s.StandardDeviationM_yaw_dot = 4.85e-7; % Drift Rate == ±0,01 [°/hours]
    s.WhiteNoiseM_yaw_dot = s.StandardDeviationM_yaw_dot*randn(1,s.Ns) + s.AverageM_yaw_dot*ones(1,s.Ns);
    s.CovarianceM_yaw_dot = cov(s.WhiteNoiseM_yaw_dot');       



    % ---------- ## Design Measurement Covariance Matrix "R" ## ---------- 
    who.R = 'Measurement Covariance Matrix (R) for Kalman Filter Theory, in [rad/s].';
    s.R = s.CovarianceM_omega_r; 


    % Note: in the dynamics add the noise this way, just edit the suffix "_XXXX":
    % s.WhiteNoiseM_XXXX(randi([1, numel(s.WhiteNoiseM_XXXX)]))
    
    % Organizing output results
    KalmanFilter.R = s.R; 
    KalmanFilter.AverageM_omega_r = s.AverageM_omega_r; KalmanFilter.StandardDeviationM_omega_r = s.StandardDeviationM_omega_r; KalmanFilter.WhiteNoiseM_omega_r = s.WhiteNoiseM_omega_r; KalmanFilter.CovarianceM_omega_r = s.CovarianceM_omega_r;   

    KalmanFilter.AverageM_omega_g = s.AverageM_omega_g; KalmanFilter.StandardDeviationM_omega_g = s.StandardDeviationM_omega_g; KalmanFilter.WhiteNoiseM_omega_g = s.WhiteNoiseM_omega_g; KalmanFilter.CovarianceM_omega_g = s.CovarianceM_omega_g;     
    KalmanFilter.AverageM_Beta = s.AverageM_Beta; KalmanFilter.StandardDeviationM_Beta = s.StandardDeviationM_Beta; KalmanFilter.WhiteNoiseM_Beta = s.WhiteNoiseM_Beta; KalmanFilter.CovarianceM_Beta = s.CovarianceM_Beta;     
    KalmanFilter.AverageM_Tg = s.AverageM_Tg; KalmanFilter.StandardDeviationM_Tg = s.StandardDeviationM_Tg; KalmanFilter.WhiteNoiseM_Tg = s.WhiteNoiseM_Tg; KalmanFilter.CovarianceM_Tg = s.CovarianceM_Tg;    
    KalmanFilter.AverageM_Pe = s.AverageM_Pe; KalmanFilter.StandardDeviationM_Pe = s.StandardDeviationM_Pe; KalmanFilter.WhiteNoiseM_Pe = s.WhiteNoiseM_Pe; KalmanFilter.CovarianceM_Pe = s.CovarianceM_Pe;  
    KalmanFilter.AverageM_Vws_hub = s.AverageM_Vws_hub; KalmanFilter.StandardDeviationM_Vws_hub = s.StandardDeviationM_Vws_hub; KalmanFilter.WhiteNoiseM_Vws_hub = s.WhiteNoiseM_Vws_hub; KalmanFilter.CovarianceM_Vws_hub = s.CovarianceM_Vws_hub;  
    KalmanFilter.AverageM_Vws_hub = s.AverageM_Vws_hub; KalmanFilter.StandardDeviationM_Vws_hub = s.StandardDeviationM_Vws_hub; KalmanFilter.WhiteNoiseM_Vws_hub = s.WhiteNoiseM_Vws_hub; KalmanFilter.CovarianceM_Vws_hub = s.CovarianceM_Vws_hub;         
    KalmanFilter.AverageM_surge_Ddot = s.AverageM_surge_Ddot; KalmanFilter.StandardDeviationM_surge_Ddot = s.StandardDeviationM_surge_Ddot; KalmanFilter.WhiteNoiseM_surge_Ddot = s.WhiteNoiseM_surge_Ddot; KalmanFilter.CovarianceM_surge_Ddot = s.CovarianceM_surge_Ddot;    
    KalmanFilter.AverageM_sway_Ddot = s.AverageM_sway_Ddot; KalmanFilter.StandardDeviationM_sway_Ddot = s.StandardDeviationM_sway_Ddot; KalmanFilter.WhiteNoiseM_sway_Ddot = s.WhiteNoiseM_sway_Ddot; KalmanFilter.CovarianceM_sway_Ddot_Ddot = s.CovarianceM_sway_Ddot;     
    KalmanFilter.AverageM_heave_Ddot = s.AverageM_heave_Ddot; KalmanFilter.StandardDeviationM_heave_Ddot = s.StandardDeviationM_heave_Ddot; KalmanFilter.WhiteNoiseM_heave_Ddot = s.WhiteNoiseM_heave_Ddot; KalmanFilter.CovarianceM_heave_Ddot = s.CovarianceM_heave_Ddot;    
    KalmanFilter.AverageM_roll_dot = s.AverageM_roll_dot; KalmanFilter.StandardDeviationM_roll_dot = s.StandardDeviationM_roll_dot; KalmanFilter.WhiteNoiseM_roll_dot = s.WhiteNoiseM_roll_dot; KalmanFilter.CovarianceM_roll_dot = s.CovarianceM_roll_dot;       
    KalmanFilter.AverageM_pitch_dot = s.AverageM_pitch_dot; KalmanFilter.StandardDeviationM_pitch_dot = s.StandardDeviationM_pitch_dot; KalmanFilter.WhiteNoiseM_pitch_dot = s.WhiteNoiseM_pitch_dot; KalmanFilter.CovarianceM_pitch_dot = s.CovarianceM_pitch_dot; 
    KalmanFilter.AverageM_yaw_dot = s.AverageM_yaw_dot; KalmanFilter.StandardDeviationM_yaw_dot = s.StandardDeviationM_yaw_dot; KalmanFilter.WhiteNoiseM_yaw_dot = s.WhiteNoiseM_yaw_dot; KalmanFilter.CovarianceM_yaw_dot = s.CovarianceM_yaw_dot;   


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_05');

elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % DEFINITION OF INITIAL PREDICTION COVARIANCES AND INITIAL STATE (OFFLINE):   
    % Purpose of this Logical Instance: to define initial values ​​(t=0) for 
    % the Prediction Covariance matrix (Pk) and for the state variables (x),
    % used in the Kalman Dilter observation structure.

    % ---------- Initial Prediction Covariance Matrix "Pk(t=0)" ----------
    who.Pk = 'Initial Prediction Covariance Matrix "Pk(t=0)", in [rad/s].';
    s.Pk = [(3*s.CovariancePP_OmegaR_Ddot) 0;0 (3*s.CovariancePP_Ta_Dot)];  

    % ---------- Initial State "X(t=0)" ----------
    who.Initial_State = 'Assumption adopted for the initial conditions for the Kalman Filter Theory.';
    s.Initial_State = 'Assumption adopted: It is assumed that the initial state is consistent with the value of the initial effective wind speed adopted and equal to the values at the operating point in steady state.';

    s.Vews_est = s.V_meanHub_0;
    s.Vews_est_before = s.Vews_est; 

    s.Tg_d_before = s.Tg_d;  
    s.Tg = s.Tg_d; %
    s.Tg_filtered = s.Tg_d;

    s.Beta_d_before = s.Beta_measured; 
    s.Beta = s.Beta_measured; 
    s.Beta_filtered = s.Beta_measured;

    s.OmegaR_est_before = s.OmegaR_measured;     
    s.OmegaR_est = s.OmegaR_est_before; 
    s.OmegaR_filtered = s.OmegaR_measured;

    s.Lambda_est = min(max( ((s.Rrd*s.OmegaR_est)/s.Vews_est) , s.Lambda_min), s.Lambda_max);    
    s.Cp_est = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est, s.Beta);    
    s.Ta_est = 0.5*s.rho*pi*s.Rrd^3*s.Cp_est*(1/s.Lambda_est)*s.Vews_est^2;
    s.Ta_est_before = s.Ta_est;    


    who.xk0 = 'Initial state variable vector, at t=0';
    s.xk0(1) = s.OmegaR_est; 
    s.xk0(2) = s.Ta_est;            
    s.xk = s.xk0';         


    % Organizing output results
    KalmanFilter.Pk = s.Pk; KalmanFilter.V_meanHub_0 = s.V_meanHub_0; KalmanFilter.xk0 = s.xk0; KalmanFilter.xk = s.xk; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance 
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_06');


elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % STATE EQUATION AND STRUCTURE FOR KALMAN FILTER (OFFLINE):    
    % Purpose of this Logical Instance: to define the System Dynamics 
    % matrix (A), Control matrix (B), Observation matrix (C), Direct 
    % Transmission matrix (D) and the disturbances (noise) matrix. These 
    % matrices, for now, are defined for the time domain in the continuous.

    % ---------- Defining the system for the time domain in the continuum. ----------
    who.A = 'System Dynamics Matrix (A) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.A = [-(s.CCdt/s.J_t) (1/s.J_t);0 0];
    who.B = 'Control Matrix (B) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.B = [(-1/s.J_t);0];
    who.C = 'Observation Matrix (C) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.C = [1 0];
    who.D = 'Feedthrough Matrix (D) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.D = 0;
    who.Gama = 'Disturbance Matrix (noise) (Gama) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.Gama = [1 0;0 1];

    % ---------- Number of state variables adopted for estimation ----------
    who.nsis_kf = 'Number of state variables adopted for estimation, in [dimensionless]';
    s.nsis_kf = max(size(s.A));
        
    % Organizing output results    
    KalmanFilter.A = s.A; KalmanFilter.B = s.B; KalmanFilter.C = s.C; KalmanFilter.D = s.D; KalmanFilter.Gama = s.Gama; KalmanFilter.nsis_kf = s.nsis_kf;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance 
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_07');


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % ANALYZING SYSTEM OBSERVABILITY & CONTROLABILITY (OFFLINE): 
    % Purpose of this Logical Instance: to analyze and record whether the
    % system considered in the estimation problem is observable and controllable. 

    % ---------- Defining the system in the estimation problem ----------
    who.sys = 'Defining the System Matrix in the estimation problem.';
    s.sys = ss(s.A,s.B,s.C,s.D); 

    % ---------- Defining the Observability Matrix ----------
    who.OB = 'The Observability Matrix.';
    s.OB = obsv(s.sys);
    s.Rank_OB = rank(s.OB);
    if s.Rank_OB == s.nsis_kf
        s.Observability = 'The System is Observable';
    else
        s.Observability = 'The System is Not Observable';
    end

    % ---------- Defining the Controllability Matrix ----------
    who.CO = 'The Controllability Matrix';
    s.CO = ctrb(s.sys);
    s.Rank_CO = rank(s.CO);
    if s.Rank_CO == s.nsis_kf
        s.Controllability = 'The System is Controllable';
    else
        s.Controllability = 'The System is Not Controllable';
    end     

    % Organizing output results    
    KalmanFilter.sys = s.sys; KalmanFilter.OB = s.OB; KalmanFilter.Rank_OB = s.Rank_OB; KalmanFilter.Observability = s.Observability; KalmanFilter.CO = s.CO; KalmanFilter.Rank_CO = s.Rank_CO; KalmanFilter.Controllability = s.Controllability;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Calling the next logic instance 
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_08');


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % DISCRETIZING THE KALMAN FILTER OBSERVATION SYSTEM (OFFLINE): 
    % Purpose of this Logical Instance:  to convert the continuous system 
    % model into a discrete model using a specified sample rate, suitable 
    % for implementing the Kalman Filter in discrete time. 

    % ---------- Defining the system for the discrete time domain ----------
    who.I = 'Identity Matrix for the Kalman Filter observation structure.';
    s.I = eye(s.nsis_kf);

    who.Ad = 'System Dynamics Matrix (Ad) used in the Kalman Filter Theory, for the discrete time domain.';
    who.Bd = 'Control Matrix (Bd) used in the Kalman Filter Theory, for the discrete time domain.';
    who.Cd = 'Observation Matrix (Cd) used in the Kalman Filter Theory, for the discrete time domain.';
    who.Dd = 'Feedthrough Matrix (Dd) used in the Kalman Filter Theory, for the discrete time domain.';
    [s.Ad,s.Bd,s.Cd,s.Dd] = c2dm(s.A,s.B,s.C,s.D,s.Sample_RateOS);

    who.H = 'Augmented Observation Matrix.';
    s.H = s.Cd;

    who.Gamad = 'Obtaining the matrix that multiplies the process noise.';
    [s.Ad,s.Gamad] = c2d(s.A,s.Gama,s.Sample_RateOS);    
    s.GQ = s.Gamad*s.Q*s.Gamad';

    % Organizing output results    
    KalmanFilter.I = s.I; KalmanFilter.Ad = s.Ad; KalmanFilter.Bd = s.Bd; KalmanFilter.Cd = s.Cd; KalmanFilter.Dd = s.Dd; KalmanFilter.H = s.H; KalmanFilter.Gamad = s.Gamad; KalmanFilter.GQ = s.GQ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


    % Returns to "WindTurbine_data" (WindTurbineData_NREL5MW,
        % WindTurbineData_IEA15MW or WindTurbineData_DTU10MW).


elseif strcmp(action, 'logical_instance_09')
% ==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % KALMAN FILTER STATE PREDICTION (ONLINE): 
    % Purpose of this Logical Instance: to make the prediction 
    % (a priori estimate) of the state and covariance. This logical 
    % instance is executed online (within an interaction loop).
    %
    % The prediction step uses the previous state's estimate to forecast
    % the current state. This forecast, called an a priori estimate, 
    % excludes current observation data.


                %######## System Outputs ########
          %######## Possible State Observer Inputs ########    


    % ---- Choose the Generator Torque signal to use State Observer ----
    who.Tg_system = 'Generator Torque filtered by 1st Order Low-Pass Filter, in [N.m]';
    if s.Option01f9 == 1
        % Use the last controller signal as input to the State Observer.
        s.Tg_system = s.Tg_d_before ; 
        %
    elseif s.Option01f9 == 2
        % Use the measured and low-pass filtered signal as input to the State Observer
        s.Tg_system = s.Tg_filteredLPF1 ; 
        %
    elseif s.Option01f9 == 3
        % Use the measured signal as input to the State Observer   
        s.Tg_system = s.Tg_measured ;
        %
    end

    
    % ---- Choose the Electrical Power signal to use State Observer ----    
    who.Pe_system = 'Electrical Power by 1st Order Low-Pass Filter, in [N.m]';
    s.Pe_system = s.Tg_system * s.OmegaR_est * s.etaElec_op ;


    % ---- Choose the Collective Blade Pitch signal to use State Observer ----       
    who.Beta_system = 'Collective Blade Pitch used in observer state, in [deg].';
    if s.Option02f9 == 1
        % Use the last controller signal as input to the State Observer.
        s.Beta_system = s.Beta_d_before ; 
        %
    elseif (s.Option02f9 == 2) 
        % Use the measured and low-pass filtered signal as input to the State Observer
        s.Beta_system = s.Beta_filteredLPF1 ;
        %
    elseif s.Option02f9 == 3
        % Use the measured signal as input to the State Observer    
        s.Beta_system = s.Beta_measured ;
        %
    end    



    % ---------- State Observer Input ----------
    who.uk = 'Prediction of the State (a priori estimate)';
    s.uk = s.Tg_system ;


    % ---------- State prediction (a priori estimate) ----------
    who.xkm = 'Prediction of the State (a priori estimate)';
    s.xkm = s.Ad*s.xk + s.Bd*s.uk;

    % ---------- Covariance prediction (a priori estimate) ----------   
    who.Pkm = 'Prediction of the Covariance (a priori estimate)';
    s.Pkm = s.Ad*s.Pk*s.Ad' + s.GQ;
  

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_10');


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % UPDATE & CORRECTION OF THE KALMAN FILTER (ONLINE):  
    % Purpose of this Logical Instance: to make the update 
    % (a posteriori estimate) of the current observation combined with 
    % the a priori prediction. This logical instance is executed online.
    %
    % In the update phase, the a priori prediction is combined with the 
    % current observation to refine the state estimate. This refined 
    % estimate is called an a posteriori estimate.

    % ---------- Updating the measurements/observations ----------
    who.zk = 'Updating the measurements/observations';
    s.zk = max(  s.Sensor.OmegaR , min(s.OmegaR_op) );

    % ---------- Measurement residual ----------
    who.yk = 'Measurement residual';    
    s.yk = s.zk - s.H*s.xkm;       

    % ---------- Covariance residual ----------
    who.Sk = 'Covariance residual';    
    s.Sk = s.H*s.Pkm*s.H' + s.R;  

    % ---------- Optimal Kalman gain ----------
    who.Kk = 'Optimal Kalman gain';
    s.Nz = max(size(s.zk));
    if s.Nz == 1
        s.Kk = s.Pkm*s.H' / s.Sk;
    else
        s.Kk = s.Pkm*s.H'*inv(s.Sk);
    end

    
    % ---------- Updated state (a posteriori estimate) ----------
    who.xk = 'Updated state (a posteriori estimate)';
    s.xk = s.xkm + s.Kk*s.yk; 

    % ---------- Estimated covariance (a posteriori estimate) ----------
    who.Pk = 'Estimated covariance (a posteriori estimate)';    
    s.Pk = (s.I - s.Kk*s.H )*s.Pkm;

    % ---------- State Observer Output ----------
    who.OmegaR_est = 'Estimated rotor speed at t=0, in [rad/s].';
    s.OmegaR_est = s.xk(1); 
    who.Ta_est = 'Estimated aerodynamic torque at t=0, in [N.m].';
    s.Ta_est = s.xk(2) ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    if s.Option03f9 == 1
        % Matlab's Solver
        EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_11'); 
    else
        % Newton-Raphson Method
        EWSEstimator_KalmanFilterTorqueEstimator('logical_instance_12'); 
    end


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % EFFECTIVE WIND SPEED ESTIMATOR WITH MATLAB'S SOLVER (ONLINE):
    % Purpose of this Logical Instance: solve the nonlinear equation of the
    % aerodynamic torque to estimate the effective wind speed, from the 
    % values ​​obtained in the state observer. The method used, uses the 
    % "fzero" algorithm available in Matlab, which uses a combination of 
    % bisection, secant and inverse quadratic interpolation methods.


    % --- Relative motion of wind flow (Tower-Top Dynamics Signals) -----
    if s.Option02f2 > 1
        % Offshore Wind Turbine
        if s.PitchAngle_est == 0
            s.Cosseno_PitchAngle_m = 1;
            s.Sine_PitchAngle_m = 0;
        else
            s.Cosseno_PitchAngle_m = sin(pi/2 - s.PitchAngle_est) ;
            s.Sine_PitchAngle_m = - cos(pi/2 - s.PitchAngle_est) ; 
        end    
        who.Rarm_pitch = 'Radius of rotational movement of the platform pitch, in [m]';
        s.Rarm_pitch = s.MomentArmPlatform * s.Cosseno_PitchAngle_m ; 
        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
        s.VCsi_est = s.Surge_dot_est + (s.Rarm_pitch * s.PitchAngle_dot_est) ;
    else
        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
        s.VCsi_est = 0 ;
    end


    % ---- Receiving values ​​from the Controller and the wind turbine -------
    who.VopOpt_est = 'Effective Wind Speed ​​at Optimum Operation, in [m/s].';
    s.VopOpt_est = ((s.Rrd.*s.OmegaR_est)./ s.Lambda_opt) ;  
    who.Tmec_est = 'Estimated Mechanical Torque, in [N.m].';
    s.Tmec_est = s.Ta_est ; % s.Ta_est - (s.CCdt*s.OmegaR_est)   
    who.Pmec_est = 'Estimated Mechanical Power, in [W].';    
    s.Pmec_est = s.Pe_system / s.etaElec_op ; % s.Ta_est*s.OmegaR_est - (s.CCdt*s.OmegaR_est)*s.OmegaR_est - Tg_system*s.OmegaR_est == 0


    % ---------- Initial guess for the solution ----------    
    if s.Option04f9 == 1 
        
        % For initial guess use the last Estimated Effective Wind Speed
        who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';      
        s.Beta_os = s.Beta_system ;        
        who.Xnr0 = 'Initial guess for the solution (Newton-Raphson algorithm).';
        s.Xnr0 = s.Vews_est_before ;

        %        
    elseif s.Option04f9 == 2

        % For initial guess use tabulated values ​​of CP and Observer State
        % values ​​to identify the operating point. Proposed by author.

        if (s.VopOpt_est <= s.Vop(s.Indexop_Region2Region25)) && ( s.Beta_system <= (s.Beta_op(s.Indexop_BetaVar)+0.1) )
            % Region 1 or 1.5 or 2
            who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';                
            s.Beta_os = min( s.Beta_op(1:s.Indexop_Region2Region25) ) ;            
            s.Xnr0 = interp1(s.OmegaR_op(1:s.Indexop_Region2Region25), s.Vop(1:s.Indexop_Region2Region25), s.OmegaR_est);
            %
        elseif (s.Tg_system >= 0) && (s.Beta_system >= 0)
            % Region 2.5 or 3 or 4
            who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';      
            s.Beta_os = s.Beta_system ;
            s.VopAll_est = s.Vop(1:end) ; 
            s.Lambda_os = ((s.Rrd.*s.OmegaR_est)./ s.VopAll_est) ; 
            s.Cp_os = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab',s.Lambda_os,s.Beta_os);
            s.Power_os = 0.5.*s.rho.*pi.*s.Rrd.^2.*s.Cp_os.*s.VopAll_est.^3 ; 
            s.delta_Power = abs( s.Power_os - s.Pmec_est ); 
            [~, s.indexLambda] = min(s.delta_Power);
            who.Xnr0 = 'Initial guess for the solution (Newton-Raphson algorithm).';
            s.Xnr0 = s.VopAll_est(s.indexLambda);
        end
        %
    end 


    % ---------- Settings of the Matlab Algorithm "fzero" ----------    
    who.optionsFsolve = 'Options for using the Matlab "fzero" algorithm';    
    s.optionsFsolve = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);
    

    % ---------- Defining the Aerodynamic Torque Function to be Solved ----------
    Lambda = @(Xnr) min(max(((s.Rrd * s.OmegaR_est) ./ Xnr), s.Lambda_min), s.Lambda_max);    
    % Vrel =  @(Xnr) ( Xnr - s.VCsi_est );
    % Lambda = @(Xnr) min(max(((s.Rrd * s.OmegaR_est) ./ Vrel(Xnr)), s.Lambda_min), s.Lambda_max);
    Cp = @(Xnr) interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', Lambda(Xnr), s.Beta_os);
    fews_e = @(Xnr) (Cp(Xnr) ./ Lambda(Xnr).^3) - ((2 * s.Tmec_est) / (s.rho * pi * s.Rrd^5 * s.OmegaR_est^2)); 
   

    % ---------- ## Matlab Solver Algorithm ("fzero") ## ----------
    who.Xnr = 'Effective Wind Speed ​​Variable.';      
    try
        if it == 1
            s.Xnr = s.Xnr0; 
        else
            s.Xnr = fsolve(fews_e, s.Xnr0, s.optionsFsolve);
            s.Xnr = min(max(abs(real(s.Xnr)), 0), 30); 
        end
    catch
        disp('Erro no fzero. Usando o valor inicial.');
        s.Xnr = s.Xnr0; 
    end


    % ---------- Output of the Effective Wind Speed ​​Estimator ----------
    who.Vews_est = 'Estimated Effective Wind Speed, in [m/s]. This value already contains the relative motion information, since the filtered rotor speed and estimated aerodynamic torque values ​​come from the low speed shaft. Perhaps because of this characteristic, we could also call this value Effective and Relative Wind Speed.';
    s.Vews_est = s.Xnr;        

       % This value already contains the relative motion information, since 
       % the filtered rotor speed (OmegaR_est) and estimated aerodynamic
       % torque (Ta_est) values ​​come from the low speed shaft. 
       % Perhaps because of this characteristic, we could also call this 
       % value "Effective and Relative Wind Speed".
   


    % ---------- Updating estimated values ​​for the next iteration ----------
    s.Vews_est_before = s.Vews_est;
    s.OmegaR_est_before = s.OmegaR_est;
    s.Ta_est_before = s.Ta_est; 
    

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % EFFECTIVE WIND SPEED ESTIMATOR WITH NEWTON-RAPHSON METHOD (ONLINE):
    % Purpose of this Logical Instance: solve the nonlinear equation of the
    % aerodynamic torque to estimate the effective wind speed, from the 
    % values ​​obtained in the state observer. The method used, uses the 
    % "fzero" algorithm available in Matlab, which uses a combination of 
    % bisection, secant and inverse quadratic interpolation methods.


    % --- Relative motion of wind flow (Tower-Top Dynamics Signals) -----
    if s.Option02f2 > 1
        % Offshore Wind Turbine
        if s.PitchAngle_est == 0
            s.Cosseno_PitchAngle_m = 1;
            s.Sine_PitchAngle_m = 0;
        else
            s.Cosseno_PitchAngle_m = sin(pi/2 - s.PitchAngle_est) ;
            s.Sine_PitchAngle_m = - cos(pi/2 - s.PitchAngle_est) ; 
        end    
        who.Rarm_pitch = 'Radius of rotational movement of the platform pitch, in [m]';
        s.Rarm_pitch = s.MomentArmPlatform * s.Cosseno_PitchAngle_m ; 
        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
        s.VCsi_est = s.Surge_dot_est + (s.Rarm_pitch * s.PitchAngle_dot_est) ;
    else
        who.VCsi_est = 'Rotor Assembly Movements that affect Wind Inflow, in [m/s].';
        s.VCsi_est = 0 ;
    end


    % ---- Receiving values ​​from the Controller and the wind turbine -------
    who.VopOpt_est = 'Effective Wind Speed ​​at Optimum Operation, in [m/s].';
    s.VopOpt_est = ((s.Rrd.*s.OmegaR_est)./ s.Lambda_opt) ;  
    who.Tmec_est = 'Estimated Mechanical Torque, in [N.m].';
    s.Tmec_est = s.Ta_est ; % s.Ta_est - (s.CCdt*s.OmegaR_est)   
    who.Pmec_est = 'Estimated Mechanical Power, in [W].';    
    s.Pmec_est = s.Pe_system / s.etaElec_op ; % s.Ta_est*s.OmegaR_est - (s.CCdt*s.OmegaR_est)*s.OmegaR_est - Tg_system*s.OmegaR_est == 0


    % ---------- Initial guess for the solution ----------    
    if s.Option04f9 == 1 
        
        % For initial guess use the last Estimated Effective Wind Speed
        who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';      
        s.Beta_os = s.Beta_system ;        
        who.Xnr0 = 'Initial guess for the solution (Newton-Raphson algorithm).';
        s.Xnr0 = s.Vews_est_before ;

        %        
    elseif s.Option04f9 == 2

        % For initial guess use tabulated values ​​of CP and Observer State
        % values ​​to identify the operating point. Proposed by author.

        if (s.VopOpt_est <= s.Vop(s.Indexop_Region2Region25)) && ( s.Beta_system <= (s.Beta_op(s.Indexop_BetaVar)+0.1) )
            % Region 1 or 1.5 or 2
            who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';                
            s.Beta_os = min( s.Beta_op(1:s.Indexop_Region2Region25) ) ;            
            s.Xnr0 = interp1(s.OmegaR_op(1:s.Indexop_Region2Region25), s.Vop(1:s.Indexop_Region2Region25), s.OmegaR_est);
            %
        elseif (s.Tg_system >= 0) && (s.Beta_system >= 0)
            % Region 2.5 or 3 or 4
            who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';      
            s.Beta_os = s.Beta_system ;
            s.VopAll_est = s.Vop(1:end) ; 
            s.Lambda_os = ((s.Rrd.*s.OmegaR_est)./ s.VopAll_est) ; 
            s.Cp_os = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab',s.Lambda_os,s.Beta_os);
            s.Power_os = 0.5.*s.rho.*pi.*s.Rrd.^2.*s.Cp_os.*s.VopAll_est.^3 ; 
            s.delta_Power = abs( s.Power_os - s.Pmec_est ); 
            [~, s.indexLambda] = min(s.delta_Power);
            who.Xnr0 = 'Initial guess for the solution (Newton-Raphson algorithm).';
            s.Xnr0 = s.VopAll_est(s.indexLambda);
        end
        %
    end 


    % ---------- Newton-Raphson method settings ----------
    who.tol_nr = 'Tolerance for function value convergence (Newton-Raphson algorithm).';    
    s.tol_nr = 1e-12;
    who.tolfpx_n = 'Tolerance for the derivative value (Newton-Raphson algorithm).';      
    s.tolfpx_nr = 1e-10;
    who.dx_nr = 'Step size for numerical differentiation (Newton-Raphson algorithm).';      
    s.dx_nr = 1e-3;
    who.maxit_nr = 'Maximum number of iterations (Newton-Raphson algorithm).';     
    s.maxit_nr = round(3*s.StandardDeviationPP_Vws/s.dx_nr);    
    who.Xnr = 'Effective Wind Speed ​​Variable.';      
    s.Xnr = s.Xnr0;



    % ---------- NEWTON-RAPHSON ITERATIONS ----------
    for itt = 1:s.maxit_nr
        
        % Aerodynamic Torque at point f(x)
        s.Lambda_est1 = min(max( ((s.Rrd*s.OmegaR_est)/s.Xnr) , s.Lambda_min), s.Lambda_max);
        s.Cp_est1 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est1, s.Beta_os);
        s.fx_nr = (s.Cp_est1/s.Lambda_est1^3) - ( (2*s.Tmec_est)/(s.rho*pi*s.Rrd^5*s.OmegaR_est^2) );

        if abs(s.fx_nr) < s.tol_nr
            break;
        end

        % Aerodynamic Torque at point f(x+dx)
        s.Xnr_u = s.Xnr + s.dx_nr;
        s.Lambda_est2 = min(max( ((s.Rrd*s.OmegaR_est)/s.Xnr_u) , s.Lambda_min), s.Lambda_max);
        s.Cp_est2 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est2, s.Beta_os);
        s.fxu = (s.Cp_est2/s.Lambda_est2^3) - ( (2*s.Tmec_est)/(s.rho*pi*s.Rrd^5*s.OmegaR_est^2) );

        % Aerodynamic Torque at point f(x-dx)
        s.Xnr_d = s.Xnr - s.dx_nr;
        s.Lambda_est3 = min(max( ((s.Rrd*s.OmegaR_est)/s.Xnr_d) , s.Lambda_min), s.Lambda_max);
        s.Cp_est3 = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est3, s.Beta_os);
        s.fxd = (s.Cp_est3/s.Lambda_est3^3) - ( (2*s.Tmec_est)/(s.rho*pi*s.Rrd^5*s.OmegaR_est^2) );         

        % Numerical Derivative: df(x)/dx = ( f(x+dx) - f(x-dx) )/(2*dx)
        s.fpx = (s.fxu - s.fxd)/(2*s.dx_nr);       

        if abs(s.fpx) < s.tolfpx_nr
            break;
        end

        s.Xnr_sol = s.Xnr - (s.fx_nr/s.fpx);
        s.Xnr = min(max(abs(real(s.Xnr_sol)), 0), 30);
    end        

    if isnan(s.Xnr)
        disp('A variável contém NaN!');
        who.AlertXnr = 'WARNING: contains numerical error. Estimation adopted equal to the initial guess, to mitigate the error.';
        s.Xnr = s.Xnr0; 
    end

    if it == 1
        s.Xnr = s.Xnr0;
    end

    
    % ---------- Output of the Effective Wind Speed ​​Estimator ----------
    who.Vews_est = 'Estimated Effective Wind Speed, in [m/s]. This value already contains the relative motion information, since the filtered rotor speed and estimated aerodynamic torque values ​​come from the low speed shaft. Perhaps because of this characteristic, we could also call this value Effective and Relative Wind Speed.';
    s.Vews_est = s.Xnr;        

       % This value already contains the relative motion information, since 
       % the filtered rotor speed (OmegaR_est) and estimated aerodynamic
       % torque (Ta_est) values ​​come from the low speed shaft. 
       % Perhaps because of this characteristic, we could also call this 
       % value "Effective and Relative Wind Speed".
   


    % ---------- Updating estimated values ​​for the next iteration ----------
    s.Vews_est_before = s.Vews_est;
    s.OmegaR_est_before = s.OmegaR_est;
    s.Ta_est_before = s.Ta_est; 
    

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to "WindTurbine('logical_instance_06')"


elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves current controller values, 
    % based on the last sampling.

    % Organizing output results


    % ---------- LOGICAL INSTANCE 09  ----------
    KalmanFilter.Pkm = s.Pkm;
    if it == 1
        KalmanFilter.uk = s.uk; KalmanFilter.xkm = s.xkm'; 
        KalmanFilter.Tg_system = s.Tg_system'; KalmanFilter.Pe_system = s.Pe_system; KalmanFilter.Beta_system = s.Beta_system'; 
        KalmanFilter.uk = s.uk; KalmanFilter.xkm = s.xkm';         
    else
        KalmanFilter.uk = [KalmanFilter.uk;s.uk]; KalmanFilter.xkm = [KalmanFilter.xkm;s.xkm'];
        KalmanFilter.Tg_system = [KalmanFilter.Tg_system;s.Tg_system]; KalmanFilter.Pe_system = [KalmanFilter.Pe_system;s.Pe_system']; KalmanFilter.Beta_system = [KalmanFilter.Beta_system;s.Beta_system']; 
    end

    
    % ---------- LOGICAL INSTANCE 10  ----------
    KalmanFilter.yk= s.yk; KalmanFilter.Sk = s.Sk; KalmanFilter.Kk = s.Kk; KalmanFilter.Pk = s.Pk;
    if it == 1
        KalmanFilter.zk = s.zk; KalmanFilter.xk = s.xk'; 
    else
        KalmanFilter.zk = [KalmanFilter.zk;s.zk]; KalmanFilter.xk = [KalmanFilter.xk;s.xk'];
    end



    % ---------- LOGICAL INSTANCE 11 OR 12  ----------
    KalmanFilter.Xnr = s.Xnr; KalmanFilter.Xnr0 = s.Xnr0;
    if s.Option03f9 == 1
        % Matlab's Solver
        KalmanFilter.optionsFsolve = s.optionsFsolve; 
    end


    if it == 1 
        KalmanFilter.Vews_est = s.Vews_est;
        KalmanFilter.OmegaR_est = s.OmegaR_est;
        KalmanFilter.Ta_est= s.Ta_est; 
        KalmanFilter.Pmec_est = s.Pmec_est;
        KalmanFilter.VopOpt_est = s.VopOpt_est;
    else
        KalmanFilter.Vews_est = [KalmanFilter.Vews_est;s.Vews_est];
        KalmanFilter.OmegaR_est = [KalmanFilter.OmegaR_est;s.OmegaR_est];
        KalmanFilter.Ta_est = [KalmanFilter.Ta_est;s.Ta_est]; 
        KalmanFilter.Pmec_est = [KalmanFilter.Pmec_est;s.Pmec_est]; 
        KalmanFilter.VopOpt_est = [KalmanFilter.VopOpt_est;s.VopOpt_est];         
        %
    end
   

    % Assign value to variable in specified workspace   
    

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


elseif strcmp(action, 'logical_instance_14')
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % PLOT ESTIMATION RESULTS (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % estimation problem with state observers and develop any other 
    % calculations, tables, and data to support the analysis of the results.


    % ---- Plot Comparison between actual and estimated Effective Wind Speed ------  
    figure()    
    plot(s.Time, s.Vews, 'b:', 'LineWidth', 0.5, 'Color', [0.4 0.7 0.9]);       
    hold on;
    plot(s.Time, s.Vews_est, 'r-', 'LineWidth', 0.8);                   
    hold off;
    xlabel('$t$ [seg]', 'Interpreter', 'latex')
    xlim([0 max(s.Time)])
    ylabel('$V_{ews}$ [m/s]', 'Interpreter', 'latex') 
    ylim([0.95 * min([s.Vews s.Vews_est]) 1.05 * max([s.Vews s.Vews_est])])
    legend('Actual Effective Wind Speed, $V_{ews}$', 'Estimated Effective Wind Speed, ${\hat{V}}_{ews}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex') 
    title('Comparison between actual and estimated effective wind speed.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex')    
    %  


    % ---- Plot Comparison between actual and estimated Rotor Speed ------   
    figure()  
    plot(s.Time, s.OmegaR, 'b--', 'LineWidth', 0.8);       
    hold on; 
    plot(s.Time, s.OmegaR_est, 'r', 'LineWidth', 1.0);           
    hold off;
    xlabel('$t$ [seg]', 'Interpreter', 'latex')
    xlim([0 max(s.Time)])
    ylabel('$\omega_R$ [rad/s]', 'Interpreter', 'latex') 
    ylim([0.95 * min([s.OmegaR s.OmegaR_est]) 1.05 * max([s.OmegaR s.OmegaR_est])])
    legend('Actual Rotor Speed, ${\omega}_{r}$', 'Estimated Rotor Speed, ${\hat{\omega}}_{r}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex') 
    title('Comparison between actual and estimated rotor speed.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex')
    %  




    % ---- Plot Comparison between actual and estimated Aerodynamic Torque ------   
    figure()     
    plot(s.Time, s.Ta, 'b:', 'LineWidth', 0.5, 'Color', [0.4 0.7 0.9]);       
    hold on;
    plot(s.Time, s.Ta_est, 'r-', 'LineWidth', 0.8);  % s.Ta_RWM               
    hold off;
    xlabel('t [seg]', 'Interpreter', 'latex')
    xlim([0 max(s.Time)])
    ylabel('$T_{a}$ [N.m]', 'Interpreter', 'latex')
    ylim([0.95*min(s.Ta) 1.05*max(s.Ta)])        
    legend('Actual Aerodynamic Torque, $T_{a}$', 'Estimated Aerodynamic Torque, ${\hat{T}}_{a}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex')
    title('Comparison between actual and estimated Aerodynamic Torque over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex')
    %
    if s.Option05f9 == 4 
        figure()     
        plot(s.Time, s.Ta, 'b:', 'LineWidth', 0.5, 'Color', [0.4 0.7 0.9]);       
        hold on;
        plot(s.Time, s.Ta_est, 'r-', 'LineWidth', 0.8);  % s.Ta_RWM 
        plot(s.Time, s.Ta_RWM, 'k--', 'LineWidth', 0.8);   
        hold off;
        xlabel('t [seg]', 'Interpreter', 'latex')
        xlim([0 max(s.Time)])
        ylabel('$T_{a}$ [N.m]', 'Interpreter', 'latex')
        ylim([0.95*min(s.Ta) 1.05*max(s.Ta)])        
        legend('Actual Aerodynamic Torque, $T_{a}$', 'Estimated Aerodynamic Torque, ${\hat{T}}_{a}$', 'Aerodynamic Torque for the Random Walk Model', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex')
        title('Comparison between actual and estimated Aerodynamic Torque over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex')
        %
    end
    %



    % ---- Plot Comparison between actual and estimated PSD ------  
    if s.Option05f9 == 3
        who.fpVews_sim = 'Estimated Positive Frequency of the Actual Effective Wind Speed used in simulation.';
        who.PSDVews_sim = 'Estimated Power Spectrum Density (PSD) of the Actual Effective Wind Speed used in simulation.';
        [s.PSDVews_sim, s.fpVews_sim] = pwelch( s.Vews, [], [], [], [] );
        s.fpVews_sim = s.fpVews_sim(2:end)';
        s.PSDVews_sim = s.PSDVews_sim(2:end)';
        who.fpVews_est_sim = 'Estimated Positive Frequency of the Estimated Effective Wind Speed used in simulation.';
        who.PSDVews_est_sim = 'Estimated Power Spectrum Density (PSD) of the Estimated Effective Wind Speed used in simulation.';
        [s.PSDVews_est_sim, s.fpVews_est_sim] = pwelch( s.Vews_est, [], [], [], [] );
        s.fpVews_est_sim = s.fpVews_est_sim(2:end)';
        s.PSDVews_est_sim = s.PSDVews_est_sim(2:end)';
        s.FreqMax_est = max( [s.fpVews_sim s.fpVews_est_sim] ) ;

        figure;
        loglog(s.fpVews_sim, s.PSDVews_sim, 'Color', [0.4 0.7 0.9], 'LineWidth', 0.8, 'LineStyle', ':', 'DisplayName', 'PSD of Actual Effective Wind Speed');
        hold on;
        loglog(s.fpVews_est_sim, s.PSDVews_est_sim, 'r', 'LineWidth', 0.5, 'DisplayName', 'PSD of Estimated Effective Wind Speed');
        hold off;            
        title('Comparison of PSD: Actual Effective Wind Speed ​​with Estimated Effective Wind Speed.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        xlabel('Frequency (Hz)');
        ylabel('PSD [$\mathrm{(m^2/s^3)}$/Hz]', 'Interpreter', 'latex');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([10^-3, s.FreqMax_est]); 
        ylim([0.97*min([s.PSDVews_sim s.PSDVews_est_sim]), 1.03*max([s.PSDVews_sim s.PSDVews_est_sim])]); 
        xticks(logspace(log10(10^-3), log10(s.FreqMax_est), 12));
        lgd = legend('show');
        set(lgd, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');        
        %
    end    


    % Further processing or end of the recursive calls

%=============================================================  
end
% #######################################################################


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'KalmanFilter', KalmanFilter);


end