function WindTurbine_OffshoreAssembly_FixedBottom(action)
% ########## EXTERNAL SEA AND CURRENT CONDITIONS AND THE APPLICATION OF HYDRODYNAMIC LOADS ##########
% ###################################################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Oceanic 
% Engineering in 2025. Reviewed and supervised by Professor Dr. Helio 
% Mitio Morishita. Code developed in Matlab 2022b.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains all the functions of the simulation 
% environment for the hydrodynamic loads caused by waves and currents, 
% applied to the floating wind turbine OffshoreAssembly.

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
    % related to this recursive function "WindTurbine_SparBuoyBetti2012n.m". 


    % ---------- Option 01: Xxxxxxxxxxxxxxxxxxxxxxxxxx ----------
    who.Option01f4.Option_01 = 'Option 01 of Recursive Function f4';
    who.Option01f4.about = 'comentários sobre do que se trata';
    who.Option01f4.choose_01 = 'Option01f4 == 1 to choose xxxxxx';
    who.Option01f4.choose_02 = 'Option01f4 == 2 to choose xxxxxx';
    who.Option01f4.choose_03 = 'Option01f4 == 3 to choose xxxxxx';
    who.Option01f4.choose_04 = 'Option01f4 == 4 to choose xxxxxx';    
        % Choose your option:
    s.Option01f4 = 1; 
    if s.Option01f4 == 1 || s.Option01f4 == 2 || s.Option01f4 == 3 || s.Option01f4 == 4
        OffshoreAssembly.Option01f4 = s.Option01f4;
    else
        error('Invalid option selected for s.Option01f4. Please choose 1 or 2 or 3 or 4.');
    end

    % ---------- Option 02: Xxxxxxxxxxxxxxxxxxxxxxxxxx ----------
    who.Option02f4.Option_02 = 'Option 02 of Recursive Function f4';
    who.Option02f4.about = 'comentários sobre do que se trata';
    who.Option02f4.choose_01 = 'Option02f4 == 1 to choose xxxxxx';
    who.Option02f4.choose_02 = 'Option02f4 == 2 to choose xxxxxx';
    who.Option02f4.choose_03 = 'Option02f4 == 3 to choose xxxxxx';
    who.Option02f4.choose_04 = 'Option02f4 == 4 to choose xxxxxx';    
        % Choose your option:
    s.Option02f4 = 1; 
    if s.Option02f4 == 1 || s.Option02f4 == 2 || s.Option02f4 == 3 || s.Option02f4 == 4
        OffshoreAssembly.Option02f4 = s.Option02f4;
    else
        error('Invalid option selected for s.Option02f4. Please choose 1 or 2.');
    end    

    % ---------- Option 03: Xxxxxxxxxxxxxxxxxxxxxxxxxx ----------
    who.Option03f4.Option_03 = 'Option 03 of Recursive Function f4';
    who.Option03f4.about = 'comentários sobre do que se trata';
    who.Option03f4.choose_01 = 'Option03f4 == 1 to choose xxxxxx';
    who.Option03f4.choose_02 = 'Option03f4 == 2 to choose xxxxxx';
    who.Option03f4.choose_03 = 'Option03f4 == 3 to choose xxxxxx';
    who.Option03f4.choose_04 = 'Option03f4 == 4 to choose xxxxxx';    
        % Choose your option:
    s.Option03f4 = 1; 
    if s.Option03f4 == 1 || s.Option03f4 == 2 || s.Option03f4 == 3 || s.Option03f4 == 4
        OffshoreAssembly.Option03f4 = s.Option03f4;
    else
        error('Invalid option selected for s.Option03f4. Please choose 1 or 2.');
    end

    % ---------- Option 04: Xxxxxxxxxxxxxxxxxxxxxxxxxx ----------
    who.Option04f4.Option_04 = 'Option 04 of Recursive Function f4';
    who.Option04f4.about = 'comentários sobre do que se trata';
    who.Option04f4.choose_01 = 'Option04f4 == 1 to choose xxxxxx';
    who.Option04f4.choose_02 = 'Option04f4 == 2 to choose xxxxxx';
    who.Option04f4.choose_03 = 'Option04f4 == 3 to choose xxxxxx';
    who.Option04f4.choose_04 = 'Option04f4 == 4 to choose xxxxxx';    
        % Choose your option:
    s.Option04f4 = 1; 
    if s.Option04f4 == 1 || s.Option04f4 == 2 || s.Option04f4 == 3 || s.Option04f4 == 4
        OffshoreAssembly.Option04f4 = s.Option04f4;
    else
        error('Invalid option selected for s.Option04f4. Please choose 1 or 2.');
    end

    % ---------- Option 05: Xxxxxxxxxxxxxxxxxxxxxxxxxx ----------
    who.Option05f4.Option_05 = 'Option 05 of Recursive Function f4';
    who.Option05f4.about = 'comentários sobre do que se trata';
    who.Option05f4.choose_01 = 'Option05f4 == 1 to choose xxxxxx';
    who.Option05f4.choose_02 = 'Option05f4 == 2 to choose xxxxxx';
    who.Option05f4.choose_03 = 'Option05f4 == 3 to choose xxxxxx';
    who.Option05f4.choose_04 = 'Option05f4 == 4 to choose xxxxxx';    
        % Choose your option:
    s.Option05f4 = 1; 
    if s.Option05f4 == 1 || s.Option05f4 == 2 || s.Option05f4 == 3 || s.Option05f4 == 4
        OffshoreAssembly.Option05f4 = s.Option05f4;
    else
        error('Invalid option selected for s.Option05f4. Please choose 1 or 2.');
    end 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance     
    System_WavesCurrentsIEC614001_3;


    
elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES (OFFLINE) BASED ON CHOSEN OPTIONS:
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f4), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.

    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 

    
    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Return to the Logical Instance of "WindTurbineData_xxxx".


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % SURGE DYNAMICS (ONLINE):     
    % Purpose of this Logical Instance: to represent the Longitudinal Linear
    % Motion (forward/backward or fore/aft) influenced by environmental
    % conditions, such as head seas or following seas, or by accelerations
    % imparted by the aerodynamic thrust force on the wind turbine rotor.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseSurge_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoiseSurge_Ddot = s.WhiteNoiseP_Surge_Ddot(randi([1, numel(s.WhiteNoiseP_Surge_Ddot)]));


    % ---------------- Surge Dynamics --------------------
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.y(15); 

    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.y(16); 

    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot = 0 + s.PNoiseSurge_Ddot ;       


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(15) = s.Surge_dot ;
    s.dy(16) = s.Surge_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;

    OffshoreAssembly.PNoiseSurge_Ddot(it) = s.PNoiseSurge_Ddot;
    OffshoreAssembly.Surge(it) = s.Surge; WindTurbineOutput.Surge(it) = s.Surge;
    OffshoreAssembly.Surge_dot(it) = s.Surge_dot; WindTurbineOutput.Surge_dot(it) = s.Surge_dot;
    OffshoreAssembly.Surge_Ddot(it) = s.Surge_Ddot; WindTurbineOutput.Surge_Ddot(it) = s.Surge_Ddot;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_04');
    

%=============================================================
elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % SWAY DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Lateral Linear 
    % Motion (side-to-side or port/starboard) caused by lateral forces 
    % from crosswinds, wave-induced motion, or other environmental factors
    % acting perpendicular to the turbine's longitudinal axis.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseSway_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoiseSway_Ddot = s.WhiteNoiseP_Sway_Ddot(randi([1, numel(s.WhiteNoiseP_Sway_Ddot)]));

    % ---------------- Sway Dynamics --------------------
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.y(17); 

    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot = s.y(18); 

    who.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sway_Ddot = 0 + s.PNoiseSway_Ddot ;        


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(17) = s.Sway_dot ;
    s.dy(18) = s.Sway_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;
    
    OffshoreAssembly.PNoiseSway_Ddot(it) = s.PNoiseSway_Ddot;
    OffshoreAssembly.Sway(it) = s.Sway; WindTurbineOutput.Sway(it) = s.Sway;
    OffshoreAssembly.Sway_dot(it) = s.Sway_dot; WindTurbineOutput.Sway_dot(it) = s.Sway_dot;
    OffshoreAssembly.Sway_Ddot(it) = s.Sway_Ddot; WindTurbineOutput.Sway_Ddot(it) = s.Sway_Ddot;  


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_05'); 


elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % HEAVE DYNAMICS (ONLINE):  
    % Purpose of this Logical Instance: to represent the Vertical Linear 
    % Motion (up and down) induced by wave elevations, buoyant forces, or
    % vertical aerodynamic pressures acting on the wind turbine structure.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseHeave_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoiseHeave_Ddot = s.WhiteNoiseP_Heave_Ddot(randi([1, numel(s.WhiteNoiseP_Heave_Ddot)]));

    % ---------------- Heave Dynamics --------------------
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.y(19); 

    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.y(20); 

    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot = 0 + s.PNoiseHeave_Ddot ;       


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(19) = s.Heave_dot ;
    s.dy(20) = s.Heave_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;
    
    OffshoreAssembly.PNoiseHeave_Ddot(it) = s.PNoiseHeave_Ddot;
    OffshoreAssembly.Heave(it) = s.Heave; WindTurbineOutput.Heave(it) = s.Heave;  
    OffshoreAssembly.Heave_dot(it) = s.Heave_dot; WindTurbineOutput.Heave_dot(it) = s.Heave_dot;
    OffshoreAssembly.Heave_Ddot(it) = s.Heave_Ddot; WindTurbineOutput.Heave_Ddot(it) = s.Heave_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_06');


elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % ROLL DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Rotational Motion 
    % about the longitudinal axis (tilting to the left/right, or 
    % port/starboard rolling) caused by uneven wave forces, asymmetric
    % aerodynamic loads, or dynamic coupling with sway and heave.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseRollAngle_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoiseRollAngle_Ddot = s.WhiteNoiseP_RollAngle_Ddot(randi([1, numel(s.WhiteNoiseP_RollAngle_Ddot)]));

    % ---------------- Roll Dynamics --------------------
    who.RollAngle = 'Roll angle or pitch rotation of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad].';
    s.RollAngle = s.y(21) ;  

    who.RollAngle_dot = 'Roll angular velocity or pitch rotation angular velocity of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s].';
    s.RollAngle_dot = s.y(22);

    who.RollAngle_Ddot = 'Roll angular acceleration or pitch rotation angular acceleration of the offshore wind turbine structure around its longitudinal/X axis (front-back or bow-stern), in [rad/s^2].';
    s.RollAngle_Ddot = 0 + s.PNoiseRollAngle_Ddot ;  

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


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(21) = s.RollAngle_dot ;
    s.dy(22) = s.RollAngle_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;
    
    OffshoreAssembly.PNoiseRollAngle_Ddot(it) = s.PNoiseRollAngle_Ddot;
    OffshoreAssembly.Gama_RollAngle(it) = s.Gama_RollAngle; WindTurbineOutput.Gama_RollAngle(it) = s.Gama_RollAngle;    
    OffshoreAssembly.RollAngle(it) = s.RollAngle; WindTurbineOutput.RollAngle(it) = s.RollAngle;
    OffshoreAssembly.RollAngle_dot(it) = s.RollAngle_dot; WindTurbineOutput.RollAngle_dot(it) = s.RollAngle_dot;
    OffshoreAssembly.RollAngle_Ddot(it) = s.RollAngle_Ddot; WindTurbineOutput.RollAngle_Ddot(it) = s.RollAngle_Ddot;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_07');


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % PITCH DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Rotational Motion 
    % about the lateral axis (tilting forward/backward, or bow/stern 
    % pitching) resulting from wave action, varying aerodynamic thrust on
    % the rotor, or changes in the center of mass due to operational loads.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoisePitchAngle_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoisePitchAngle_Ddot = s.WhiteNoiseP_PitchAngle_Ddot(randi([1, numel(s.WhiteNoiseP_PitchAngle_Ddot)]));

    % ---------------- Pitch Dynamics --------------------
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';   
    s.PitchAngle = s.y(23) ; 

    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.y(24); 

    who.PitchAngle_Ddot = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    s.PitchAngle_Ddot = 0 + s.PNoisePitchAngle_Ddot ; 

    who.Gama_PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the horizontal axis (Surge) and in [rad].';    
    if (s.PitchAngle == 0)
        s.Gama_PitchAngle = pi/2 ;
        s.Cosseno_PitchAngle = 1;
        s.Sine_PitchAngle = 0;
    else
        s.Cosseno_PitchAngle = sin(pi/2 - s.PitchAngle) ;
        s.Sine_PitchAngle = -cos(pi/2 - s.PitchAngle) ;
        s.Gama_PitchAngle = pi/2 + s.PitchAngle ;        
    end     


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(23) = s.PitchAngle_dot ;
    s.dy(24) = s.PitchAngle_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;
    
    OffshoreAssembly.PNoisePitchAngle_Ddot(it) = s.PNoisePitchAngle_Ddot;
    OffshoreAssembly.Gama_PitchAngle(it) = s.Gama_PitchAngle; WindTurbineOutput.Gama_PitchAngle(it) = s.Gama_PitchAngle;
    OffshoreAssembly.PitchAngle(it) = s.PitchAngle; WindTurbineOutput.PitchAngle(it) = s.PitchAngle; 
    OffshoreAssembly.PitchAngle_dot(it) = s.PitchAngle_dot; WindTurbineOutput.PitchAngle_dot(it) = s.PitchAngle_dot; 
    OffshoreAssembly.PitchAngle_Ddot(it) = s.PitchAngle_Ddot; WindTurbineOutput.PitchAngle_Ddot(it) = s.PitchAngle_Ddot; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_FixedBottom('logical_instance_08');


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % YAW DYNAMICS (ONLINE):   
    % Purpose of this Logical Instance: to represent the Rotational Motion
    % about the vertical axis (rotation to change the turbine's heading) 
    % caused by wind direction shifts, aerodynamic torques, or operational
    % adjustments made by the control system to align the rotor with the wind.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Process covariance (system disturbance) ----------
    who.PNoiseYawAngle_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    s.PNoiseYawAngle_Ddot = s.WhiteNoiseP_YawAngle_Ddot(randi([1, numel(s.WhiteNoiseP_YawAngle_Ddot)]));

    % ---------------- Yaw Dynamics --------------------
    who.YawAngle = 'Yaw angle or rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad].';
    s.YawAngle = s.y(25) ;

    who.YawAngle_dot = 'Yaw angular velocity or angular velocity of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s].';
    s.YawAngle_dot = s.y(26); 

    who.YawAngle_Ddot = 'Yaw angular acceleration or angular acceleration of the rotation of the offshore wind turbine structure around its vertical/Z axis, in [rad/s^2].';
    s.YawAngle_Ddot = 0 + s.PNoiseYawAngle_Ddot ;   

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


    % ----- Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.';             
    s.dy(25) = s.YawAngle_dot ;
    s.dy(26) = s.YawAngle_Ddot ;    


    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;
    
    OffshoreAssembly.PNoiseYawAngle_Ddot(it) = s.PNoiseYawAngle_Ddot;
    OffshoreAssembly.Gama_YawAngle(it) = s.Gama_YawAngle; WindTurbineOutput.Gama_YawAngle(it) = s.Gama_YawAngle;
    OffshoreAssembly.YawAngle(it) = s.YawAngle; WindTurbineOutput.YawAngle(it) = s.YawAngle;    
    OffshoreAssembly.YawAngle_dot(it) = s.YawAngle_dot; WindTurbineOutput.YawAngle_dot(it) = s.YawAngle_dot;
    OffshoreAssembly.YawAngle_Ddot(it) = s.YawAngle_Ddot; WindTurbineOutput.YawAngle_Ddot(it) = s.YawAngle_Ddot; 
    

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Return to the Logical Instance of "WindTurbineData_xxxx".


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % PLOT OFFSHORE ASSEMBLY MOTIONS RESULTS (OFFLINE): 
    % Purpose of this Logical Instance: to plot the results obtained by
    % simulating the movement of an offshore wind turbine.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025; 



    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025;     




    % Organizing output results    
    OffshoreAssembly.testvariable = s.testvariable;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Further processing or end of the recursive calls

%=============================================================  
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'WindTurbineOutput', WindTurbineOutput);
assignin('base', 'OffshoreAssembly', OffshoreAssembly);


% #######################################################################
end