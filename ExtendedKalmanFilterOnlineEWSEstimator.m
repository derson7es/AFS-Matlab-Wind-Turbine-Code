function ExtendedKalmanFilterOnlineEWSEstimator(action)
% ########## STATE VARIABLE AND PARAMETER ESTIMATION PROBLEMS ##########
% ######################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Ocean 
% Engineering in 2025. Master's dissertation title: Control of wind turbine 
% based on effective wind speed estimation / Silva, Anderson Francisco -- São Paulo, 2025.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains the approach related to the problem 
% of estimating state variables and parameters. The approach adopted is 
% based on the work of Abbas (2022) inspired by Knudsen (2011), which uses a 
% continuous-discrete Extended Kalman Filter for the estimation of the 
% turbulent and mean components of the wind speed. As the models used 
% refer to the dynamics of the drive train, this estimated wind speed is
% actually the effective wind speed that can be used for control 
% purposes, for example.


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
    % related to this recursive function "ExtendedKalmanFilterOnlineExtendedKalmanFilter.m". 


        % ---------- Option 01: Choose the Generator Torque signal ----------
    who.Option01f9.Option_01 = 'Option 01 of Recursive Function f9';
    who.Option01f9.about = 'Choose the Generator Torque signal (State Observer input).';
    who.Option01f9.choose_01 = 'Option01f9 == 1 to use the last controller signal (s.Tg_system = s.Tg_d_before) as input to the State Observer.';
    who.Option01f9.choose_02 = 'Option01f9 == 2 to use the measured and low-pass filtered signal (s.Tg_system = s.Tg_filteredLPF1) as input to the State Observer.';
    who.Option01f9.choose_03 = 'Option01f9 == 3 to use the measured signal (s.Tg_system = s.Tg_measured) as input to the State Observer.';
        % Choose your option:
    s.Option01f9 = 1; 
    if s.Option01f9 == 1 || s.Option01f9 == 2 || s.Option01f9 == 2
        ExtendedKalmanFilter.s.Option01f9 = s.Option01f9;
    else
        error('Invalid option selected for s.Option01f9. Please choose 1 or 2.');
    end


    % ------ Option 02: Choose the Blade Pitch signal ------
    who.Option02f9.Option_02 = 'Option 02 of Recursive Function f9';
    who.Option02f9.about = 'Choose the Blade Pitch signal (State Observer input).';
    who.Option02f9.choose_01 = 'Option02f9 == 1 to use the last controller signal (s.Beta_system = s.Beta_d) as input to the State Observer.';
    who.Option02f9.choose_02 = 'Option02f9 == 2 to use the measured and low-pass filtered signal (s.Beta_system = s.Beta_filteredLPF1) as input to the State Observer.';
    who.Option02f9.choose_03 = 'Option02f9 == 3 to use the measured signal (s.Beta_system = s.Beta_measured) as input to the State Observer.';     
        % Choose your option:
    s.Option02f9 = 2; 
    if s.Option02f9 == 1 || s.Option02f9 == 2 || s.Option02f9 == 3
        ExtendedKalmanFilter.Option02f9 = s.Option02f9;
    else
        error('Invalid option selected for Option02f9. Please choose 1 or 2 or 3.');
    end 


    % ---- Option 03: Choose the Effective Wind Speed ​​Sign for Solving Nonlinear Equations ----------
    who.Option03f9.Option_03 = 'Option 03 of Recursive Function f9';
    who.Option03f9.about = 'Choose the Effective Wind Speed ​​Sign for Solving Nonlinear Equations.';
    who.Option03f9.choose_01 = 'Option03f9 == 1 to use the last Estimated Effective Wind Speed in solving the nonlinear equations.';
    who.Option03f9.choose_02 = 'Option03f9 == 2 to use Effective Wind Speed ​​based on tabulated values ​​of CP and Observer State in solving nonlinear equations.';
        % Choose your option:
    s.Option03f9 = 1; 
    if s.Option03f9 == 1 || s.Option03f9 == 2
        ExtendedKalmanFilter.s.Option03f9 = s.Option03f9;
    else
        error('Invalid option selected for s.Option03f9. Please choose 1 or 2.');
    end



    % -- Option 04: Choose the EWS ​​Sign updating the matrix of a Time-Varying System ------
    who.Option04f9.Option_04 = 'Option 04 of Recursive Function f9';
    who.Option04f9.about = 'Choose the Effective Wind Speed (EWS) ​​Sign for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
    who.Option04f9.choose_01 = 'Option04f9 == 1 to use the last Estimated Effective Wind Speed for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
    who.Option04f9.choose_02 = 'Option04f9 == 2 to use Effective Wind Speed ​​based on tabulated values ​​of CP and Observer State for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
    who.Option04f9.choose_03 = 'Option04f9 == 3 to use the current Effective Wind Speed ​​(solution of the nonlinear equation) for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
        % Choose your option:
    s.Option04f9 = 1; 
    if s.Option04f9 == 1 || s.Option04f9 == 2 || s.Option04f9 == 3
        ExtendedKalmanFilter.Option04f9 = s.Option04f9;
    else
        error('Invalid option selected for Option04f9. Please choose 1 or 2 or 3.');
    end 


    % ------ Option 05: Integration Methods of Differential Equations ------
    who.Option05f9.Option_05 = 'Option 05 of Recursive Function f9';
    who.Option05f9.about = 'Options of integration methods of differential equations.';
    who.Option05f9.choose_01 = 'Option05f9 == 1 to choose to use the Forward Euler integration method according to Abbas (2021/2022).';
    who.Option05f9.choose_02 = 'Option05f9 == 2 to choose to use the 4th order Runge-Kutta integration method proposed by this work.';     
        % Choose your option:
    s.Option05f9 = 2; 
    if s.Option05f9 == 1 || s.Option05f9 == 2
        ExtendedKalmanFilter.Option05f9 = s.Option05f9;
    else
        error('Invalid option selected for Option05f9. Please choose 1 or 2.');
    end 



    % ------ Option 06: Plot figures from the Effective Wind Speed ​​estimation ------
    who.Option06f9.Option_06 = 'Option 06 of Recursive Function f9';
    who.Option06f9.about = 'Option to plot figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';
    who.Option06f9.choose_01 = 'Option06f9 == 1 to choose DO NOT PLOT figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';
    who.Option06f9.choose_02 = 'Option06f9 == 2 to choose PLOT figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';  
    who.Option06f9.choose_03 = 'Option06f9 == 3 to choose PLOT figures from the Effective Wind Speed ​​estimation or state observer estimation problem.';     
        % Choose your option:
    s.Option06f9 = 3; 
    if s.Option06f9 == 1 || s.Option06f9 == 2 || s.Option06f9 == 3
        ExtendedKalmanFilter.Option06f9 = s.Option06f9;
    else
        error('Invalid option selected for Option06f9. Please choose 1 or 2 or 3.');
    end     



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);


    % Return to EnviromentSimulation('logical_instance_01');



elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES (OFFLINE) BASED ON CHOSEN OPTIONS:
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f12), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.

    % ---------- Sampling of the Kalman Filter ----------
    who.Sample_Frequency = 'Sampling of the Kalman Filter, in [Hz].';
    s.Sample_Frequency = 1; 

    who.Sample_Rate = 'Sampling of the Kalman Filter, in [s].';
    s.Sample_RateOS = 1/s.Sample_Frequency;


    % ---------- Wind Speed Sampling ----------
    who.SampleF_Wind = 'Maximum Cut-off Frequency for Wind Speed ​​(Nyquist Frequency), in [Hz].';
    ExtendedKalmanFilter.SampleF_Wind = s.SampleF_Wind;     
    who.SampleT_Vm = 'Sampling of the Long-Medium-Duration Component (Vm), in [seg]. Adopted according to the analysis of the van der Hoven spectrum (1957) and according to IEC-614001-1 Standard.';
    ExtendedKalmanFilter.SampleT_Vm = s.SampleT_Vm;   


    % Organizing output results
    ExtendedKalmanFilter.Sample_Frequency = s.Sample_Frequency; ExtendedKalmanFilter.Sample_RateOS = s.Sample_RateOS;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);


    % Calling the next logic instance
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_03'); 


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================      
    % DEFINITION OF PROCESS COVARIANCES (OFFLINE):   
    % Purpose of this Logical Instance: design the covariance matrix of 
    % the "Q" process, used in Kalman's filter modeling. 


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
    s.StandardDeviationPP_Tg_Dot = ( 0.069*(s.TgDot_max*s.eta_gb) / 3 ) ; 
    s.WhiteNoisePP_Tg_Dot = s.StandardDeviationPP_Tg_Dot*randn(1,s.Ns) + s.AveragePP_Tg_Dot*ones(1,s.Ns);
    s.CovariancePP_Tg_Dot = cov(s.WhiteNoisePP_Tg_Dot');

    who.AveragePP_Ta_Dot = 'Average of aerodynamic torque, in [N.m].';
    who.StandardDeviationPP_Ta_Dot = 'Process standard deviation for the dynamics of aerodynamic torque, in [N.m/s].';
    s.AveragePP_Ta_Dot = 0;
    s.StandardDeviationPP_Ta_Dot = (1.2743*(s.TgDot_max*s.eta_gb)) / 3  ; 
    s.WhiteNoisePP_Ta_Dot = s.StandardDeviationPP_Ta_Dot*randn(1,s.Ns) + s.AveragePP_Ta_Dot*ones(1,s.Ns);
    s.CovariancePP_Ta_Dot = cov(s.WhiteNoisePP_Ta_Dot');

    who.AveragePP_OmegaR_Ddot = 'Average of rotor speed, in [rad/s^2].';
    who.StandardDeviationPP_OmegaR_Ddot = 'Process standard deviation for the dynamics of rotor speed, in [rad/s^2].';
    s.AveragePP_OmegaR_Ddot = 0 ; 
    s.StandardDeviationPP_OmegaR_Ddot = s.StandardDeviationPP_Ta_Dot / s.J_t  ; 
    s.WhiteNoisePP_OmegaR_Ddot = s.StandardDeviationPP_OmegaR_Ddot*randn(1,s.Ns) + s.AveragePP_OmegaR_Ddot*ones(1,s.Ns);
    s.CovariancePP_OmegaR_Ddot = cov(s.WhiteNoisePP_OmegaR_Ddot'); % Aproximated == 1e-4 OR 1e-5
    s.CovariancePP_OmegaR_Ddot = 2e-4 ; 

    % NOTE: To ensure the stability of the EKF Filter, the process 
    % covariance matrix must be a value in the range 1e-9 to 9e-2 ( I sugest
    % 1e-4) with measurements Covariance s.CovarianceM_omega_r = 0.02.
    % This is because, in the Prediction stage, the Q matrix would have a large or
    % reasonable value that could change the value of the term (s.A*s.Pkm + s.Pkm*s.A).

    % NOTE: Decreasing the covariance smoothes the EWS signal, power
    % production efficiency drops and achieves reduction of transient loads.


    who.L_ScaleTurb = 'Turbulence Length-Scale Parameter., in [m].';    
    s.L_ScaleTurb = 3*(2*s.Rrd);
    who.IntensTurbul = 'Turbulence Internsity., in [decimal].';
    s.IntensTurbul = 0.18;
    who.StandardDeviationPP_Vws = 'Standard deviation of wind speed, in [m/s].';
    s.StandardDeviationPP_Vws = 2;
  
    who.AveragePP_Vt_NoiseDot = 'Average of the Short-Duration (Turbulent)  Wind Component Rate, in [m/s].';
    who.StandardDeviationPP_Vt_NoiseDot = 'Standard deviation of the Short-Duration (Turbulent) Wind Component Rate, in [m/s].';       
    s.indexV0mean = ceil( (10/s.dt) );    
    s.V_meanHub_global = mean( s.Uews_full(1:s.indexV0mean) ) ;  
    s.CovariancePP_Vt_NoiseDot = ((pi*(s.V_meanHub_global^3)*(s.IntensTurbul^2))/s.L_ScaleTurb) ;  
    s.AveragePP_Vt_NoiseDot = 0;    
    s.StandardDeviationPP_Vt_NoiseDot = sqrt( s.CovariancePP_Vt_NoiseDot   );
    s.WhiteNoisePP_Vt_NoiseDot = s.StandardDeviationPP_Vt_NoiseDot*randn(1,s.Ns) + s.AveragePP_Vt_NoiseDot*ones(1,s.Ns);
  
    who.AveragePP_Vm_NoiseDot = 'Average of the Medium-Term (Average) Wind Component Rate, in [m/s].';
    who.StandardDeviationPP_Vm_NoiseDot = 'Standard deviation of the Medium-Term (Average) Wind Component Rate, in [m/s].';       
    s.CovariancePP_Vm_NoiseDot = ((s.StandardDeviationPP_Vws^2)/s.SampleT_Vm) ; 
    s.AveragePP_Vm_NoiseDot = 0;    
    s.StandardDeviationPP_Vm_NoiseDot = sqrt( s.CovariancePP_Vm_NoiseDot );
    s.WhiteNoisePP_Vm_NoiseDot = s.StandardDeviationPP_Vm_NoiseDot*randn(1,s.Ns) + s.AveragePP_Vm_NoiseDot*ones(1,s.Ns);


    % ---------- ## Design Process Covariance Matrix "Q" ## ----------    
    who.Q = 'Process Covariance Matrix (Q) for Kalman Filter Theory, in [rad/s].';
    s.Q = [s.CovariancePP_OmegaR_Ddot 0 0;0 s.CovariancePP_Vt_NoiseDot 0;0 0 s.CovariancePP_Vm_NoiseDot];   

    
    % Organizing output results
    ExtendedKalmanFilter.Q = s.Q;   
    ExtendedKalmanFilter.MaximumVar_Vews = s.MaximumVar_Vews; ExtendedKalmanFilter.MaximumVar_OmegaR = s.MaximumVar_OmegaR; ExtendedKalmanFilter.MaximumVar_Lambda = s.MaximumVar_Lambda; ExtendedKalmanFilter.MaximumVar_Cp = s.MaximumVar_Cp; ExtendedKalmanFilter.MaximumVar_beta = s.MaximumVar_beta; ExtendedKalmanFilter.MaximumVar_Tg = s.MaximumVar_Tg; ExtendedKalmanFilter.MaximumVar_Ta = s.MaximumVar_Ta; ExtendedKalmanFilter.MaximumVar_Pe = s.MaximumVar_Pe; ExtendedKalmanFilter.MaximumVar_Pa = s.MaximumVar_Pa;
    ExtendedKalmanFilter.AveragePP_Tg_Dot = s.AveragePP_Tg_Dot; ExtendedKalmanFilter.StandardDeviationPP_Tg_Dot = s.StandardDeviationPP_Tg_Dot; ExtendedKalmanFilter.WhiteNoisePP_Tg_Dot = s.WhiteNoisePP_Tg_Dot; ExtendedKalmanFilter.CovariancePP_Tg_Dot = s.CovariancePP_Tg_Dot;   
    ExtendedKalmanFilter.AveragePP_Ta_Dot = s.AveragePP_Ta_Dot; ExtendedKalmanFilter.StandardDeviationPP_Ta_Dot = s.StandardDeviationPP_Ta_Dot; ExtendedKalmanFilter.WhiteNoisePP_Ta_Dot = s.WhiteNoisePP_Ta_Dot; ExtendedKalmanFilter.CovariancePP_Ta_Dot = s.CovariancePP_Ta_Dot; 
    ExtendedKalmanFilter.AveragePP_OmegaR_Ddot = s.AveragePP_OmegaR_Ddot; ExtendedKalmanFilter.StandardDeviationPP_OmegaR_Ddot = s.StandardDeviationPP_OmegaR_Ddot; ExtendedKalmanFilter.WhiteNoisePP_OmegaR_Ddot = s.WhiteNoisePP_OmegaR_Ddot; ExtendedKalmanFilter.CovariancePP_OmegaR_Ddot = s.CovariancePP_OmegaR_Ddot;   
    ExtendedKalmanFilter.L_ScaleTurb = s.L_ScaleTurb; ExtendedKalmanFilter.IntensTurbul = s.IntensTurbul;     ExtendedKalmanFilter.StandardDeviationPP_Vws = s.StandardDeviationPP_Vws;
    ExtendedKalmanFilter.AveragePP_Vt_NoiseDot = s.AveragePP_Vt_NoiseDot; ExtendedKalmanFilter.StandardDeviationPP_Vt_NoiseDot = s.StandardDeviationPP_Vt_NoiseDot; ExtendedKalmanFilter.WhiteNoisePP_Vt_NoiseDot = s.WhiteNoisePP_Vt_NoiseDot; ExtendedKalmanFilter.CovariancePP_Vt_NoiseDot = s.CovariancePP_Vt_NoiseDot;                              
    ExtendedKalmanFilter.AveragePP_Vm_NoiseDot = s.AveragePP_OmegaR_Ddot; ExtendedKalmanFilter.StandardDeviationPP_Vt_NoiseDot = s.StandardDeviationPP_Vt_NoiseDot; ExtendedKalmanFilter.WhiteNoisePP_Vm_NoiseDot = s.WhiteNoisePP_Vm_NoiseDot; ExtendedKalmanFilter.CovariancePP_Vm_NoiseDot = s.CovariancePP_Vm_NoiseDot;   


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);


    % Calling the next logic instance     
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_04');


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
    s.StandardDeviationM_Beta = (0.01*s.BetaDot_max) / 4 ;
    s.WhiteNoiseM_Beta = s.StandardDeviationM_Beta*randn(1,s.Ns) + s.AverageM_Beta*ones(1,s.Ns);
    s.CovarianceM_Beta = cov(s.WhiteNoiseM_Beta');  

    who.AverageM_Tg = 'Average of generator torque, in [N.m].';
    who.StandardDeviationM_Tg = 'Standard deviation of measurements made from generator torque, in [N.m].';       
    s.AverageM_Tg = 0;    
    s.StandardDeviationM_Tg = ( 0.355*(s.TgDot_max*s.eta_gb) ) / 3 ; % ( 1*(s.TgDot_max*s.eta_gb) ) / 3 OR (( 0.1262*(s.TgDot_max*s.eta_gb) ) / 3 ) OR (( 0.2884*(s.TgDot_max*s.eta_gb) ) / 3 ) OR (( 0.9011*(s.TgDot_max*s.eta_gb) ) / 3 )
    s.WhiteNoiseM_Tg = s.StandardDeviationM_Tg*randn(1,s.Ns) + s.AverageM_Tg*ones(1,s.Ns);
    s.CovarianceM_Tg = cov(s.WhiteNoiseM_Tg');

    who.AverageM_omega_r = 'Average of rotor speed, in [rad/s].';
    who.StandardDeviationM_omega_r = 'Standard deviation of measurements made from rotor speed, in [rad/s].';
    s.AverageM_omega_r = 0;
    s.StandardDeviationM_omega_r = s.StandardDeviationM_Tg / s.J_t  ;    
    s.WhiteNoiseM_omega_r = s.StandardDeviationM_omega_r*randn(1,s.Ns) + s.AverageM_omega_r*ones(1,s.Ns);
    s.CovarianceM_omega_r = cov(s.WhiteNoiseM_omega_r'); % Aproximated == 2e-5 OR 1e-4
    s.CovarianceM_omega_r = 2e-05 ; % 1.5949e-04 (for all operation) OR 1.5949e-05
 

    % ---------- ## Design Measurement Covariance Matrix "R" ## ---------- 
    who.R = 'Measurement Covariance Matrix (R) for Kalman Filter Theory, in [rad/s].';
    s.R = s.CovarianceM_omega_r;
    
    % NOTE: To ensure the stability of the EKF Filter, the measurement 
    % covariance matrix must be a value in the range of 2e-2 to 2.5e-5 (I
    % sugest 1e-4) with process Covariance s.CovariancePP_OmegaR_Ddot = 9.4019e-07.
    % This is because, in the Prediction stage, the average  velocity "Vm"
    % is not updated and in the Correction stage the turbulent velocity is 
    % corrected and greatly influenced by the R matrix.

    
    % Organizing output results
    ExtendedKalmanFilter.R = s.R;
    ExtendedKalmanFilter.AverageM_Beta = s.AverageM_Beta; ExtendedKalmanFilter.StandardDeviationM_Beta = s.StandardDeviationM_Beta; ExtendedKalmanFilter.WhiteNoiseM_Beta = s.WhiteNoiseM_Beta; ExtendedKalmanFilter.CovarianceM_Beta = s.CovarianceM_Beta;     
    ExtendedKalmanFilter.AverageM_Tg = s.AverageM_Tg; ExtendedKalmanFilter.StandardDeviationM_Tg = s.StandardDeviationM_Tg; ExtendedKalmanFilter.WhiteNoiseM_Tg = s.WhiteNoiseM_Tg; ExtendedKalmanFilter.CovarianceM_Tg = s.CovarianceM_Tg;       
    ExtendedKalmanFilter.AverageM_omega_r = s.AverageM_omega_r; ExtendedKalmanFilter.StandardDeviationM_omega_r = s.StandardDeviationM_omega_r; ExtendedKalmanFilter.WhiteNoiseM_omega_r = s.WhiteNoiseM_omega_r; ExtendedKalmanFilter.CovarianceM_omega_r = s.CovarianceM_omega_r;     


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);


    % Calling the next logic instance
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_05');


elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % INITIAL PREDICTION COVARIANCES AND INITIAL STATE (OFFLINE):   
    % Purpose of this Logical Instance: to define initial values ​​(t=0) for 
    % the Prediction Covariance matrix (Pk) and for the state variables (x),
    % used in the Kalman Dilter observation structure.

    % ---------- Initial Prediction Covariance Matrix "Pk(t=0)" ----------
    who.Pk = 'Initial Prediction Covariance Matrix "Pk(t=0)", in [rad/s].';
    s.Pk = [(3*s.CovariancePP_OmegaR_Ddot) 0 0; 0 (3*s.CovariancePP_Vt_NoiseDot) 0;0 0 (3*s.CovariancePP_Vm_NoiseDot)];
    s.dPkm = s.Pk;    
    s.Pkm = s.Pk;


    % ---------- Initial conditions according to initial Wind Speed ----------
    who.Initial_State = 'Assumption adopted for the initial conditions for the Kalman Filter Theory.';
    s.Initial_State = 'Assumption adopted: It is assumed that the initial state is consistent with the value of the initial effective wind speed adopted and equal to the values at the operating point in steady state.';
    
    s.Vt_est = 0;    
    s.Vt_est_before = s.Vt_est;
    s.Vt_est_op = s.Vt_est;
    s.xkm_solver(2) = s.Vt_est;

    s.Vm_est = s.V_meanHub_0;
    s.Vm_est_before = s.V_meanHub_0; % Updating Control Input   
    s.Vm_est_op = s.Vm_est ;
    s.xkm_solver(3) = s.Vm_est ;
    s.VHub_MeasuredStored = s.V_meanHub_0;

    s.Vews_est = s. Vt_est + s.Vm_est;
    s.Vews_est_before = s.Vews_est; % Updating Control Input
    s.Vews_est_store = s.Vews_est;
    s.Vews_est_op = s.Vm_est_op +  s.Vt_est_op  ; 

    s.OmegaR_est_before = s.OmegaR_measured;     
    s.OmegaR_est = s.OmegaR_est_before; 
    s.OmegaR_filtered = s.OmegaR_measured;

    s.Tg_d_before = s.Tg_d;  
    s.Tg = s.Tg_d; %
    s.Tg_filtered = s.Tg_d;

    s.Beta_d_before = s.Beta_measured; 
    s.Beta = s.Beta_measured; 
    s.Beta_filtered = s.Beta_measured;

    s.Lambda_est = min(max( ((s.Rrd*s.OmegaR_est)/s.Vews_est) , s.Lambda_min), s.Lambda_max);    
    s.Cp_est = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est, s.Beta);    
    s.Ta_est = 0.5*s.rho*pi*s.Rrd^3*s.Cp_est*(1/s.Lambda_est)*s.Vews_est^2;
    s.Ta_est_before = s.Ta_est;  


    % ---------- Initial State "X(t=0)" ----------
    who.xk0 = 'Initial state variable vector, at t=0';
    s.xk0(1) = s.OmegaR_est; % omega_r == s.omega_r_op, Rotor Speed.    
    s.xk0(2) = s.Vt_est; % Vt_est == 0, Turbulent Wind Component or Short-Duration Component of the wind spectrum.
    s.xk0(3) = s.Vm_est; % Vm_est = s.V_meanHub_0, Average Wind Component or Medium-Duration Component of the wind spectrum 
    s.xk = s.xk0';
    s.xkm = s.xk;
    s.dXk = [0;0;0];    


    % --- Defining the system in continuos and in the estimation problem ----
    who.sys = 'Defining the System Matrix in continuos and in the estimation problem.';
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_09');    
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

    % ---------- Number of state variables adopted for estimation ----------
    who.nsis_kf = 'Number of state variables adopted for estimation, in [dimensionless].';
    s.nsis_kf = max(size(s.A));    


    % --- Defining the system in discrete and in the estimation problem ----
    who.sys_dis = 'Defining the System Matrix in discrete and in the estimation problem.';
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_06');  


    % ---------- Initial Covariance residual ----------
    who.Sk = 'Covariance residual';    
    s.Sk = s.H*s.Pkm*s.H' + s.R;  

    % ---------- Initial Optimal Kalman gain ----------
    who.Kk = 'Optimal Kalman gain';
    s.Kk = s.Pkm*s.H'*inv(s.Sk); % s.Pkm*s.H'*inv(s.Sk);



    % Organizing output results
    ExtendedKalmanFilter.Pk = s.Pk; ExtendedKalmanFilter.Pk = s.Pk; ExtendedKalmanFilter.V_meanHub_0 = s.V_meanHub_0; ExtendedKalmanFilter.xk0 = s.xk0; ExtendedKalmanFilter.xk= s.xk; ExtendedKalmanFilter.nsis_kf = s.nsis_kf;
    ExtendedKalmanFilter.sys = s.sys; ExtendedKalmanFilter.OB = s.OB; ExtendedKalmanFilter.Rank_OB = s.Rank_OB; ExtendedKalmanFilter.Observability = s.Observability; ExtendedKalmanFilter.CO = s.CO; ExtendedKalmanFilter.Rank_CO = s.Rank_CO; ExtendedKalmanFilter.Controllability = s.Controllability;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);



    % Return to the Logical Instance that called this Logical Instance
                                    % OR
    % Returns to "WindTurbine_data" (WindTurbineData_NREL5MW, WindTurbineData_IEA15MW or WindTurbineData_DTU10MW).

    

elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % DISCRETIZING THE KALMAN FILTER OBSERVATION SYSTEM (OFFLINE/ONLINE): 
    % Purpose of this Logical Instance:  to convert the continuous system 
    % model into a discrete model using a specified sample rate, suitable 
    % for implementing the Kalman Filter in discrete time. 


    % ---------- Defining the system for the discrete time domain ----------
    who.I = 'Identity Matrix for the Kalman Filter observation structure.';
    s.I = eye(s.nsis_kf);

    % ---------- Defining the system for the discrete time domain ----------
    s.hh = 1/s.Sample_RateOS;
    % [s.Ad,s.Bd,s.Cd,s.Dd] = c2dm(s.A,s.B,s.C,s.D,s.Sample_RateOS);      

    who.Ad = 'System Dynamics Matrix (Ad) used in the Kalman Filter Theory, for the discrete time domain.';  
    if any(isnan(s.A), 'all') || any(isinf(s.A), 'all')
        s.A = s.A_stable ; % Replace with stable matrix
    else
        s.A_stable = s.A ; % Preserves the matrix as the last stable
    end       
    s.Ad = s.I + s.hh*s.A;

    who.Bd = 'Control Matrix (Bd) used in the Kalman Filter Theory, for the discrete time domain.';    
    s.Bd = s.hh*s.B;    
    who.Cd = 'Observation Matrix (Cd) used in the Kalman Filter Theory, for the discrete time domain.';    
    s.Cd = s.C;
    who.Dd = 'Feedthrough Matrix (Dd) used in the Kalman Filter Theory, for the discrete time domain.';    
    s.Dd = s.D;
 
    who.H = 'Augmented Observation Matrix.';
    s.H = s.Cd;
    % [s.Ad,s.Gamad] = c2d(s.A,s.Gama,s.Sample_RateOS);     
    who.Expm_Ah = 'Obtaining the matrix that multiplies the process noise.';        
    s.Expm_Ah = expm(s.A * s.hh);
    who.Gamad = 'Obtaining the matrix that multiplies the process noise.';    
    s.Gamad =  s.Expm_Ah * s.Gama * s.hh;


    who.GQ = 'Process Noise Covariance Matrix used for Kalman Filter prediction.';
    s.GQ = s.Gamad*s.Q*s.Gamad';

    % Organizing output results    
    ExtendedKalmanFilter.I = s.I; ExtendedKalmanFilter.Ad = s.Ad; ExtendedKalmanFilter.Bd = s.Bd; ExtendedKalmanFilter.Cd = s.Cd; ExtendedKalmanFilter.Dd = s.Dd; ExtendedKalmanFilter.H = s.H; ExtendedKalmanFilter.Gamad = s.Gamad; ExtendedKalmanFilter.GQ = s.GQ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);    


    % Return to the Logical Instance that called this Logical Instance


elseif strcmp(action, 'logical_instance_07')    
% ==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % RECEIVING AND SELECTING CONTROL SIGNALS (ONLINE):   
    % Purpose of this Logical Instance: to represent the reception and 
    % selection of control signals from sensors, Low-Pass filters and State
    % Observer, etc. The "s.Option01f9" option allows selecting the input 
    % signal that will be used for the generator torque, while the 
    % "s.Option02f9" option allows selecting the input signal that will be
    % used for the blade pitch. The "s.Option03f9" option allows selecting
    % the effective wind speed and state signals that will be used in the 
    % solution of the nonlinear differential equation. And finally, the
    % "s.Option04f9" option allows selecting the effective speed and state 
    % signal that will update the matrices A, B, C, D and Gamma, in the 
    % continuous domain, in addition to the process covariance matrix Q.


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



    % ---- Average Effective Wind Speed ​​and Wind Speed ​​at Hub Height ------
    who.VHub_MeasuredStored = 'Stored Wind speed measured at cube height, in [m/s].'; 
    s.VHub_MeasuredStored = [s.VHub_MeasuredStored s.Sensor.WindSped_hubWT] ; 

    if t <= 600         
        who.Vm_HubMeasured = 'Average Wind Speed ​​at Hub Height Measured, in [m/s].'; 
        s.Vm_HubMeasured = mean( s.VHub_MeasuredStored ) ;  
        s.Vews_est_mean = mean( s.Vews_est_store ) ;         
    else       
        s.Vm_HubMeasured = mean( s.VHub_measured(end-600:end) ) ; 
        s.Vews_est_mean = mean( s.Vews_est_store(end-600:end) ) ;           
    end



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

    
    % ---- Choose the Effective Wind Speed signal to Solving Nonlinear Equations ----    
    if s.Option03f9 == 1 
            % Use the last Estimated Effective Wind Speed in solving the nonlinear equations.             
        who.Vt_est_system = 'Turbulent Component of Effective Wind Speed, in [m/s].';   
        s.Vt_est_system = s.Vt_est_before ;       
        who.Vm_est_system = 'Mean Component of Effective Wind Speed, in [m/s].';   
        s.Vm_est_system = s.Vm_est_before ;
        who.Vews_est_system = 'Estimated Effective Wind Speed, in [m/s].';
        s.Vews_est_system = s.Vt_est_system + s.Vm_est_system ; 
        %        
    elseif s.Option03f9 == 2        
            % Use Effective Wind Speed ​​based on tabulated values ​​of CP and Observer State in solving nonlinear equations.
        who.VopOpt_est = 'Effective Wind Speed ​​at Optimum Operation, in [m/s].';
        s.VopOpt_est = ((s.Rrd.*s.OmegaR_est)./ s.Lambda_opt) ;
        s.VopOpt_est = ((s.Rrd.*s.OmegaR_est)./ s.Lambda_opt) ;
        who.Pmec_est = 'Estimated Mechanical Power, in [W].';    
        s.Pmec_est = s.Pe_system / s.etaElec_op ; % s.Ta_est*s.OmegaR_est - (s.CCdt*s.OmegaR_est)*s.OmegaR_est - Tg_system*s.OmegaR_est == 0

        who.Vews_est_system = 'Estimated Effective Wind Speed, in [m/s].';
        if (s.VopOpt_est <= s.Vop(s.Indexop_Region2Region25)) && ( s.Beta_system <= (s.Beta_op(s.Indexop_BetaVar)+0.1) )
            % Region 1 or 1.5 or 2          
            s.Vews_est_system = interp1(s.OmegaR_op(1:s.Indexop_Region2Region25), s.Vop(1:s.Indexop_Region2Region25), s.OmegaR_est);
            %
        elseif (s.Tg_system >= 0) && (s.Beta_system >= 0)
            % Region 2.5 or 3 or 4
            who.Beta_os = 'Collective Blade Pitch used in observer state, in [deg].';      
            s.Beta_os = s.Beta_system ;
            s.VopAll_est = s.Vop(1:end) ; 
            s.Lambda_os = ((s.Rrd.*s.OmegaR_est)./ s.VopAll_est) ; 
            s.Cp_os = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab',s.Lambda_os,s.Beta_os);
            s.Power_os = 0.5.*s.rho.*pi.*s.Rrd.^2.*s.VopAll_est.^3.*s.Cp_os;
            s.delta_Power = abs( s.Power_os - s.Pmec_est ); 
            [~, s.indexLambda] = min(s.delta_Power);
            s.Vews_est_system = s.VopAll_est(s.indexLambda);
        end
        who.Vm_est_system = 'Mean Component of Effective Wind Speed, in [m/s].';   
        s.Vm_est_system = s.Vews_est_mean ;
        who.Vt_est_system = 'Turbulent Component of Effective Wind Speed, in [m/s].';   
        s.Vt_est_system = s.Vews_est_system - s.Vm_est_system ;        
        %
    end 




      %####### Defining HOW to update time-varying system #######

    if s.Option04f9 == 1 
            % Use the last Estimated Effective Wind Speed for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
        who.Vt_est_op = 'Turbulent Component of Effective Wind Speed, in [m/s].';   
        s.Vt_est_op = s.Vt_est_before ;       
        who.Vm_est_op = 'Mean Component of Effective Wind Speed, in [m/s].';   
        s.Vm_est_op = s.Vm_est_before ;        
        who.Vews_est_op = 'Estimated Effective Wind Speed, in [m/s].';
        s.Vews_est_op = s.Vt_est_op + s.Vm_est_op ; 
        %        
    elseif s.Option04f9 == 2        
            % Use Effective Wind Speed ​​based on tabulated values ​​of CP and Observer State for updating the matrix of a Time-Varying System (A, B, C, D, Q).';
        who.Vt_est_op = 'Turbulent Component of Effective Wind Speed, in [m/s].';   
        s.Vt_est_op = s.Vt_est_system ;       
        who.Vm_est_op = 'Mean Component of Effective Wind Speed, in [m/s].';   
        s.Vm_est_op = s.Vm_est_system ;        
        who.Vews_est_op = 'Estimated Effective Wind Speed, in [m/s].';
        s.Vews_est_op = s.Vm_est_op +  s.Vt_est_op  ; 
        %          
    end 


    % Calling the next logic instance      
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_08');


elseif strcmp(action, 'logical_instance_08')    
% ==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % NONLINEAR SYSTEM DYNAMICS (ONLINE):
    % Purpose of this Logical Instance: to calculate the dynamics of the 
    % system, using the nonlinear equations to send to the 4th Order Runge 
    % Kutta integrator solved in the continuum.    


    % ---------- Aerodynamic Model Equations ----------
    who.Lambda_est = 'Estimated Aerodynamic Torque, in [N.m].';    
    s.Lambda_est = min(max( ((s.Rrd*s.OmegaR_est)/s.Vews_est_system) , s.Lambda_min), s.Lambda_max);    
    who.Ta_est = 'Estimated Aerodynamic Torque, in [N.m].';    
    s.Cp_est = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est, s.Beta_system);    
    who.Ta_est = 'Estimated Aerodynamic Torque, in [N.m].';
    s.Ta_est = 0.5*s.rho*pi*s.Rrd^3*s.Cp_est*(1/s.Lambda_est)*s.Vews_est_system^2;
  
    
    % ---------- Nonlinear Differential Equations (Nonlinear Dynamics) ----------    
    who.omega_est_Dot = 'Driven-Train Dynamics, in [rad/s^2].';
    s.omega_est_Dot = (1/s.J_t)*( s.Ta_est - ( s.CCdt*s.OmegaR_est ) - s.Tg_system )  ;

    who.Vt_dot = 'Short-Duration (Turbulent) Component Dynamics, in [m/s^2].';
    s.Vt_dot = -((pi*s.Vm_est_system)/(2*s.L_ScaleTurb))*s.Vt_est_system ; 

    who.Vm_dot = 'Medium-Term (Average) Component Dynamics., in [m/s^2].';
    s.Vm_dot = 0 ;
        

    % ---------- Defining the dynamics function of the system to be solved ----------
    s.xkm_dot = [s.omega_est_Dot;s.Vt_dot;s.Vm_dot]; 


    % -------- Forward Euler integration method of Differential Equations ----------
    if s.Option05f9 == 1   
        who.dt_ekf = 'Integration step, in [s].';
        s.dt_ekf =  s.Sample_RateOS ;
        who.xkm_solver = 'Solution of nonlinear differential equation.'; 
        s.xkm_solver = [s.OmegaR_est;s.Vt_est_system;s.Vm_est_system] + (s.dt_ekf * s.xkm_dot) ;
        %      
    end



    % ---- 4th Order Runge-Kutta Integration Methods of Differential Equations ------
    if s.Option05f9 == 2         
        who.dt_ekf = 'Integration step, in [s].';
        s.dt_ekf = s.Sample_RateOS ; 

        % Initial state and system dynamics function
        s.yrk = [s.OmegaR_est; s.Vt_est; s.Vm_est]; % Initial solution
        s.dy_rk = @(y_rk) [(1/s.J_t)*(s.Ta_est - (s.CCdt * y_rk(1)) - s.Tg_system); 
                           -((pi * y_rk(3)) / (2 * s.L_ScaleTurb)) * y_rk(2); 
                           0];


        % Calculation of 4th order Runge-Kutta coefficients
        s.krk1 = s.dy_rk(s.yrk); % s.krk1 = dy = dy1 = f(y)
        s.krk2 = s.dy_rk(s.yrk + 0.5 * s.dt_ekf * s.krk1); % s.krk2 = dy2 = f(y+dt*s.krk1)
        s.krk3 = s.dy_rk(s.yrk + 0.5 * s.dt_ekf * s.krk2); % s.krk3 = dy3 = f(y+dt*s.krk2)
        s.krk4 = s.dy_rk(s.yrk + s.dt_ekf * s.krk3); % s.krk4 = dy4 = f(y+dt*s.krk3)


        % Updating the state with the integration result
        s.yrk = s.yrk + (s.dt_ekf / 6) * (s.krk1 + 2 * s.krk2 + 2 * s.krk3 + s.krk4);
        

        % Updating final values in the system
        s.xkm_solver = [s.yrk(1);s.yrk(2);s.yrk(3)];
    end


    % ---- Forward Euler Integration Methods of Differential Equations ------  
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_09');


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_10');
      

elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % STATE EQUATION AND STRUCTURE FOR KALMAN FILTER (ONLINE):    
    % Purpose of this Logical Instance: to define the System Dynamics 
    % matrix (A), Control matrix (B), Observation matrix (C), Direct 
    % Transmission matrix (D) and the disturbances (noise) matrix. These 
    % matrices, for now, are defined for the time domain in the continuous.


      %####### Defining HOW to update time-varying system #######

    % ---- Choose the EWS signal for updating the matrix of a Time-Varying System ----
    if (s.Option04f9 == 3)
            % Use the current Effective Wind Speed ​​(solution of the nonlinear equation) for updating the matrix of a Time-Varying System (A, B, C, D, Q).';             
        who.Vt_est_op = 'Turbulent Component of Effective Wind Speed, in [m/s].';   
        s.Vt_est_op = s.xkm_solver(2) ;
        who.Vm_est_op = 'Mean Component of Effective Wind Speed, in [m/s].';   
        s.Vm_est_op = s.xkm_solver(3) ;        
        who.Vews_est_op = 'Estimated Effective Wind Speed, in [m/s].';
        s.Vews_est_op = s.Vt_est_op + s.Vm_est_op ;         
        %          
    end     



      %####### Defining matrices A, B, C and D of the system #######

    % ---------- Jacobin Matrix (linearization of the system) ----------             
    s.GradTaBeta =  interp1(s.Vop, s.GradTaBeta_op, s.Vews_est_op  ) ;  
    s.GradTaOmega = interp1(s.Vop, s.GradTaOmega_op, s.Vews_est_op  ) ;    
    s.GradTaVop = interp1(s.Vop, s.GradTaVop_op, s.Vews_est_op ) ;
    s.A11 = ((1/s.J_t)*(s.GradTaOmega - s.CCdt));                
    if s.A11 > 0
        s.A11 = - s.A11; % Stable Pole.
    end
    s.A12 = (1/s.J_t)*s.GradTaVop; 
    s.A13 = s.A12;


    % ---------- Defining the system for the time domain in the continuum. ----------
    who.A = 'System Dynamics Matrix (A) used in the Kalman Filter Theory, for the time domain in the continuum.'; 
    s.A = [s.A11 s.A12 s.A13;0 (-(pi*s.Vm_est_op)/(2*s.L_ScaleTurb)) (-(pi*s.Vt_est_op)/(2*s.L_ScaleTurb));0 0 0];

    who.B = 'Control Matrix (B) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.B = [(-1/s.J_t) (s.GradTaBeta/s.J_t);0 0;0 0];

    who.C = 'Observation Matrix (C) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.C = [1 0 0];

    who.D = 'Feedthrough Matrix (D) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.D = [0 0];

    who.Gama = 'Disturbance Matrix (noise) (Gama) used in the Kalman Filter Theory, for the time domain in the continuum.';
    s.Gama = [1 0 0;0 1 0;0 0 1]; 


    % ---------- Number of state variables adopted for estimation ----------
    who.nsis_kf = 'Number of state variables adopted for estimation, in [dimensionless].';
    s.nsis_kf = max(size(s.A));    


      %####### Update the process covariance matrix Q #######

    who.Q = 'Updating Process Covariance Matrix (Q) for Kalman Filter Theory, in [rad/s].'; 
    s.CovariancePP_Vt = ((pi*(s.Vm_est_op^3)*(s.IntensTurbul^2))/s.L_ScaleTurb) ;  
    s.Q = [s.CovariancePP_OmegaR_Ddot 0 0;0 s.CovariancePP_Vt 0;0 0 s.CovariancePP_Vm_NoiseDot];        


      %####### Update the measurement covariance matrix R #######
    % if (s.Vews_est_op <= s.Vws_Rated)
    %     s.CovarianceM_omega_r = 1.5949e-05 ;
    % else
    %     s.CovarianceM_omega_r = 1.5949e-04 ;
    % end
    % who.R = 'Measurement Covariance Matrix (R) for Kalman Filter Theory, in [rad/s].';
    % s.R = s.CovarianceM_omega_r;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to the Logical Instance that called this Logical Instance



elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % KALMAN FILTER STATE PREDICTION (ONLINE): 
    % Purpose of this Logical Instance: to make the prediction 
    % (a priori estimate) of the state and covariance. This logical 
    % instance is executed online (within an interaction loop).
    %
    % The prediction step uses the previous state's estimate to forecast
    % the current state. This forecast, called an a priori estimate, 
    % excludes current observation data.

    % ---------- State Observer Input ----------
    who.uk = 'Prediction of the State (a priori estimate)';
    s.uk = s.Tg_system ; % = u(k-1)


    % ---------- State prediction (a priori estimate) ----------
    who.xkm = 'Prediction of the State (a priori estimate)';
    s.xkm = s.xkm_solver;     



      %####### Solver equation of Covariance Prediction #######    

    % ---------- Covariance differential equation  ----------
    who.dPkm = 'Time derivative of covariance (prediction)';
    s.dPkm =  s.A*s.Pkm + s.Pkm*s.A' + s.Q - s.Kk*s.R*s.Kk'; % EKF Continuous-Discrete
        % NOTE: For EKF Discrete-Discrete use: s.Ad*s.Pk + s.Pk*s.Ad' + s.GQ - s.Kk*s.R*s.Kk'; 
        

    % -------- Forward Euler integration method of Differential Equations ----------        
    if s.Option05f9 == 1 
        % ---------- Forward Euler integration method ----------  
        who.dt_ekf = 'Integration step, in [s].';
        s.dt_ekf =  s.Sample_RateOS ;
        who.Pkm_solver = 'Solution of Covariance Prediction equation.'; 
        s.Pkm_solver = s.Pkm + s.dt_ekf*s.dPkm ;
        %       
    end


    % ---- 4th Order Runge-Kutta Integration Methods of Differential Equations ------
    if s.Option05f9 == 2  
        who.dt_ekf = 'Integration step, in [s].';
        s.dt_ekf = s.Sample_RateOS ; 

        % Dynamic function for the covariance matrix P
        s.dy_P = @(P) s.A * P + P * s.A' + s.Q - s.Kk * s.R * s.Kk';

        % Calculation of 4th order Runge-Kutta coefficients
        s.kP1 = s.dy_P(s.Pkm); % kP1 = dy = dy1 = f(y)
        s.kP2 = s.dy_P(s.Pkm + 0.5 * s.dt_ekf * s.kP1); % kP2 = dy2 = f(y+dt*kP1)
        s.kP3 = s.dy_P(s.Pkm + 0.5 * s.dt_ekf * s.kP2); % kP3 = dy3 = f(y+dt*kP2)
        s.kP4 = s.dy_P(s.Pkm + s.dt_ekf * s.kP3); % kP4 = dy4 = f(y+dt*kP3)

        % Updating final values in the system
        s.Pkm_solver = s.Pkm + (s.dt_ekf / 6) * (s.kP1 + 2 * s.kP2 + 2 * s.kP3 + s.kP4);
    end



    % ---------- Covariance prediction (a priori estimate) ----------       
    who.Pkm = 'Prediction of the Covariance (a priori estimate)';
    s.Pkm = s.Pkm_solver; % s.Pkm(k-1) = s.Pk(k-1) ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance 
    ExtendedKalmanFilterOnlineEWSEstimator('logical_instance_11');


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
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
    s.zk = s.OmegaR_measured;

    % ---------- Measurement residual ----------
    who.yk = 'Measurement residual';    
    s.yk = s.zk - s.H*s.xkm;       

    % ---------- Covariance residual ----------
    who.Sk = 'Covariance residual';    
    s.Sk = s.H*s.Pkm*s.H' + s.R; % It must be a value in the range of 1e-4 to 1e-5.


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
    s.OmegaR_est = max( s.xk(1) , 0.01 ) ;    
  
    who.Vt_est = 'Turbulent Component of Effective Wind Speed, in [m/s].';    
    s.Vt_est = s.xk(2) ;

    who.Vm_est = 'Mean Component of Effective Wind Speed, in [m/s].';    
    s.Vm_est = max( s.xk(3) , 0.1) ;

    who.Vews_est = 'Estimated Effective Wind Speed, in [m/s].';
    s.Vews_est = s. Vt_est + s.Vm_est ; 
    s.Vews_est = max( abs(s.Vews_est) , 0.1 ) ; 
  

    % ---------- Updating estimated values ​​for the next iteration ----------
    s.Pkm = s.Pk;
    s.OmegaR_est_before = s.OmegaR_est;
    s.Vt_est_before = s.Vt_est;
    s.Vm_est_before = s.Vm_est;
    s.Vews_est_before = s.Vews_est ;
    s.Vews_est_store = [s.Vews_est_store s.Vews_est] ;
   
    s.Lambda_est = min(max( ((s.Rrd*s.OmegaR_est)/s.Vews_est) , s.Lambda_min), s.Lambda_max);      
    s.Cp_est = interp2(s.Lambda_Tab, s.Beta_Tab, s.CP_Tab', s.Lambda_est, s.Beta_system);    
    s.Ta_est = 0.5*s.rho*pi*s.Rrd^3*s.Cp_est*(1/s.Lambda_est)*s.Vews_est^2;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to EnviromentSimulation('logical_instance_02');

    
elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves current controller values, 
    % based on the last sampling.

    % Organizing output results


    % ---------- LOGICAL INSTANCE 07  ----------       
    if it == 1
        ExtendedKalmanFilter.Tg_system = s.Tg_system';
        ExtendedKalmanFilter.Pe_system = s.Pe_system;
        ExtendedKalmanFilter.Beta_system = s.Beta_system';       
        ExtendedKalmanFilter.Vm_HubMeasured = s.Vm_HubMeasured;
        ExtendedKalmanFilter.Vews_est_mean = s.Vews_est_mean; 
        ExtendedKalmanFilter.Vt_est_system = s.Vt_est_system;
        ExtendedKalmanFilter.Vm_est_system = s.Vm_est_system ;
        ExtendedKalmanFilter.Vews_est_system = s.Vews_est_system; 
        if (s.Option04f9 == 1) || (s.Option04f9 == 2)
        ExtendedKalmanFilter.Vm_est_op = s.Vm_est_op; 
        ExtendedKalmanFilter.Vt_est_op = s.Vt_est_op; 
        ExtendedKalmanFilter.Vews_est_op = s.Vews_est_op; 
        end    
    else
        ExtendedKalmanFilter.Tg_system = [ExtendedKalmanFilter.Tg_system;s.Tg_system];
        ExtendedKalmanFilter.Pe_system = [ExtendedKalmanFilter.Pe_system;s.Pe_system'];
        ExtendedKalmanFilter.Beta_system = [ExtendedKalmanFilter.Beta_system;s.Beta_system']; 
        ExtendedKalmanFilter.Vm_HubMeasured = [ExtendedKalmanFilter.Vm_HubMeasured;s.Vm_HubMeasured];
        ExtendedKalmanFilter.Vews_est_mean = [ExtendedKalmanFilter.Vews_est_mean;s.Vews_est_mean]; 
        ExtendedKalmanFilter.Vt_est_system = [ExtendedKalmanFilter.Vt_est_system;s.Vt_est_system];
        ExtendedKalmanFilter.Vm_est_system = [ExtendedKalmanFilter.Vm_est_system;s.Vm_est_system];
        ExtendedKalmanFilter.Vews_est_system = [ExtendedKalmanFilter.Vews_est_system;s.Vews_est_system]; 
        if (s.Option04f9 == 1) || (s.Option04f9 == 2)
            ExtendedKalmanFilter.Vm_est_op = [ExtendedKalmanFilter.Vm_est_op;s.Vm_est_op];
            ExtendedKalmanFilter.Vt_est_op = [ExtendedKalmanFilter.Vt_est_op;s.Vt_est_op];
            ExtendedKalmanFilter.Vews_est_op = [ExtendedKalmanFilter.Vews_est_op;s.Vews_est_op]; 
        end      
    end



    % ---------- LOGICAL INSTANCE 08  ----------
    if it == 1
        if (s.Option04f9 == 1) || (s.Option04f9 == 2)
            ExtendedKalmanFilter.dt_ekf = s.dt_ekf;
        end        
        ExtendedKalmanFilter.omega_est_Dot = s.omega_est_Dot;
        ExtendedKalmanFilter.Vt_dot = s.Vt_dot;
        ExtendedKalmanFilter.Vm_dot = s.Vm_dot;
        ExtendedKalmanFilter.xkm_dot = s.xkm_dot';        
    else 
        ExtendedKalmanFilter.omega_est_Dot = [ExtendedKalmanFilter.omega_est_Dot;s.omega_est_Dot];
        ExtendedKalmanFilter.Vt_dot = [ExtendedKalmanFilter.Vt_dot;s.Vt_dot];
        ExtendedKalmanFilter.Vm_dot = [ExtendedKalmanFilter.Vm_dot;s.Vm_dot];
        ExtendedKalmanFilter.xkm_dot = [ExtendedKalmanFilter.xkm_dot;s.xkm_dot'];        
    end


    
    % ---------- LOGICAL INSTANCE 09  ----------
    ExtendedKalmanFilter.A = s.A; ExtendedKalmanFilter.B = s.B; ExtendedKalmanFilter.C = s.C; ExtendedKalmanFilter.D = s.D; ExtendedKalmanFilter.Gama = s.Gama; ExtendedKalmanFilter.Q = s.Q; ExtendedKalmanFilter.nsis_kf = s.nsis_kf;
    if it == 1
        if s.Option04f9 == 3
            ExtendedKalmanFilter.dt_ekf = s.dt_ekf;
        end
        ExtendedKalmanFilter.Vm_est_op = s.Vm_est_op; 
        ExtendedKalmanFilter.Vt_est_op = s.Vt_est_op; 
        ExtendedKalmanFilter.Vews_est_op = s.Vews_est_op;         
    else
        ExtendedKalmanFilter.Vm_est_op = [ExtendedKalmanFilter.Vm_est_op;s.Vm_est_op];
        ExtendedKalmanFilter.Vt_est_op = [ExtendedKalmanFilter.Vt_est_op;s.Vt_est_op];
        ExtendedKalmanFilter.Vews_est_op = [ExtendedKalmanFilter.Vews_est_op;s.Vews_est_op];        
    end


    % ---------- LOGICAL INSTANCE 10  ----------
    ExtendedKalmanFilter.Pkm = s.Pkm;
    if it == 1
        ExtendedKalmanFilter.uk = s.uk; ExtendedKalmanFilter.xkm = s.xkm'; 
    else 
        ExtendedKalmanFilter.uk = [ExtendedKalmanFilter.uk;s.uk]; ExtendedKalmanFilter.xkm = [ExtendedKalmanFilter.xkm;s.xkm'];
    end
    

    % ---------- LOGICAL INSTANCE 11  ----------
    ExtendedKalmanFilter.yk = s.yk; ExtendedKalmanFilter.Sk = s.Sk; ExtendedKalmanFilter.Kk = s.Kk; ExtendedKalmanFilter.Pk = s.Pk;   
    ExtendedKalmanFilter.Vews_est_store = s.Vews_est_store;
    if it == 1
        ExtendedKalmanFilter.zk = s.zk; 
        ExtendedKalmanFilter.OmegaR_est = s.OmegaR_est;
        ExtendedKalmanFilter.Vews_est = s.Vews_est;
        ExtendedKalmanFilter.Vt_est = s.Vt_est;
        ExtendedKalmanFilter.Vm_est = s.Vm_est;
        ExtendedKalmanFilter.xk = s.xk';  
        ExtendedKalmanFilter.Lambda_est = s.Lambda_est;
        ExtendedKalmanFilter.Cp_est = s.Cp_est;
        ExtendedKalmanFilter.Ta_est = s.Ta_est;         
    else
        ExtendedKalmanFilter.zk = [ExtendedKalmanFilter.zk;s.zk]; 
        ExtendedKalmanFilter.OmegaR_est = [ExtendedKalmanFilter.OmegaR_est;s.OmegaR_est];
        ExtendedKalmanFilter.Vews_est = [ExtendedKalmanFilter.Vews_est;s.Vews_est];
        ExtendedKalmanFilter.Vt_est = [ExtendedKalmanFilter.Vt_est;s.Vt_est];
        ExtendedKalmanFilter.Vm_est = [ExtendedKalmanFilter.Vm_est;s.Vm_est];
        ExtendedKalmanFilter.xk = [ExtendedKalmanFilter.xk;s.xk'];  
        ExtendedKalmanFilter.Lambda_est = [ExtendedKalmanFilter.Lambda_est;s.Lambda_est];
        ExtendedKalmanFilter.Cp_est = [ExtendedKalmanFilter.Cp_est;s.Cp_est];
        ExtendedKalmanFilter.Ta_est = [ExtendedKalmanFilter.Ta_est;s.Ta_est];        
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'ExtendedKalmanFilter', ExtendedKalmanFilter);



elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % PLOT ESTIMATION RESULTS (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % estimation problem with state observers and develop any other 
    % calculations, tables, and data to support the analysis of the results.


    % ---- Plot Comparison between actual and estimated Effective Wind Speed ------  
    figure()    
    plot(s.Time, s.Vews, 'b:', 'LineWidth', 0.5, 'Color', [0.4 0.7 0.9]);       
    % plot(s.Time, s.Vews, 'Color', [0.6 0.8 1], 'LineWidth', 0.5);  
    hold on;
    plot(s.Time, s.Vews_est, 'r-', 'LineWidth', 0.8);        
    % plot(s.Time, s.Vews_est, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 2.0);            
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
    % plot(s.Time, s.OmegaR, 'Color', [0.4 0.7 0.9], 'LineStyle', '--', 'LineWidth', 0.8);        
    % plot(s.Time, s.OmegaR, 'Color', [0.6 0.8 1], 'LineWidth', 3.0); 
    % plot(s.Time, s.OmegaR, 'b-o', 'LineWidth', 2.0, 'MarkerSize', 2);
    hold on; 
    plot(s.Time, s.OmegaR_est, 'r', 'LineWidth', 1.0);        
    % plot(s.Time, s.OmegaR_est, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 2.0);         
    % plot(s.Time, s.OmegaR_est, 'r', 'LineWidth', 2.0, 'Color', [1 0 0 0.7]);    
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
    % plot(s.Time, s.Ta, 'Color', [0.6 0.8 1], 'LineWidth', 0.5);  
    hold on;
    plot(s.Time, s.Ta_est, 'r-', 'LineWidth', 0.8);        
    % plot(s.Time, s.Ta_est, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 2.0);            
    hold off;
    xlabel('t [seg]', 'Interpreter', 'latex')
    xlim([0 max(s.Time)])
    ylabel('$T_{a}$ [N.m]', 'Interpreter', 'latex')
    ylim([0.95*min(s.Ta) 1.05*max(s.Ta)])        
    legend('Actual Aerodynamic Torque, $T_{a}$', 'Estimated Aerodynamic Torque, ${\hat{T}}_{a}$', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex')
    title('Comparison between actual and estimated Aerodynamic Torque over time.', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex')
    %


% plot(s.Time, s.Ta, 'Color', [0.6 0.8 1 0.5], 'LineWidth', 0.5); % Azul bem leve
% plot(s.Time, s.Ta_est, 'Color', [1 0 0 0.7], 'LineWidth', 1.5); % Vermelho semi-translúcido
% plot(s.Time, s.Ta_alt, 'Color', [0 1 0 0.9], 'LineWidth', 2.0); % Verde menos translúcido


    % ---- Plot Comparison between actual and estimated PSD ------  
    if s.Option06f9 == 3
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
end