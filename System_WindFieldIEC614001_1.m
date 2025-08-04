function System_WindFieldIEC614001_1(action)
% ########## EXTERNAL CONDITIONS: GENERATION OF TURBULENT WIND AND EFFECTIVE WIND SPEED (EWS). ##########
% #######################################################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Ocean 
% Engineering in 2025. Master's dissertation title: Control of wind turbine 
% based on effective wind speed estimation / Silva, Anderson Francisco -- São Paulo, 2025. 

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function represents the simulation environment that generates
% the wind signal chosen, through the "Option03f1" option, which can be a 
% deterministic or stochastic signal. Deterministic wind signals are constant
% winds, linearly increasing and decreasing, series steps and sinusoidal. 
% The stochastic signal, on the other hand, is a turbulent wind signal 
% generated from the Veers method or by Transfer Functions, to later obtain
% the effective wind speed from this signal. Also for stochastic signals,
% it is also possible to add the rotation effect to the wind signal to 
% include the frequencies related to the blades passing through a fixed point.


% ---------- Global Variables and Structures Array ----------
global iim s who t it SimulationEnvironment WindTurbine_data Sensor WindTurbineOutput MeasurementCovariances ProcessCovariances BladePitchSystem GeneratorTorqueSystem PowerGeneration DriveTrainDynamics TowerDynamics RotorDynamics NacelleDynamics OffshoreAssembly AerodynamicModels BEM_Theory Wind_IEC614001_1 Waves_IEC614001_3 Currents_IEC614001_3 GeneratorTorqueController BladePitchController PIGainScheduledOTC PIGainScheduledTSR KalmanFilter ExtendedKalmanFilter



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
    % related to this recursive function "System_WindFieldIEC614001_1.m". The choices will be
    % stored following a pattern of "option_f6_(it)" where "(it)" is the option number. 
    

    % ---------- Option 01: Wind Turbine Class (I, II, III, S) according to IEC-614001-1 Standard (2019) ----------
    who.Option01f6.Option_01 = 'Option 01 of Recursive Function f6';
    who.Option01f6.about = 'Wind Turbine Class (I, II, III, S) according to IEC-614001-1 Standard (2019), in Table 1. Choose the Annual Average Wind Speed and reference wind speed to extreme conditions.';
    who.Option01f6.choose_01 = 'Option01f6 == 1 to choose Wind Turbine Class I (Vws_aa = 10 [m/s], Vws_Ref = 50 [m/s], and Vws_RefT = 57 [m/s]).';
    who.Option01f6.choose_02 = 'Option01f6 == 2 to choose Wind Turbine Class II (Vws_aa = 10 [m/s], Vws_Ref = 50 [m/s], and Vws_RefT = 57 [m/s]).';
    who.Option01f6.choose_03 = 'Option01f6 == 3 to choose Wind Turbine Class III (Vws_aa = 10 [m/s], Vws_Ref = 50 [m/s], and Vws_RefT = 57 [m/s]).';
    who.Option01f6.choose_04 = 'Option01f6 == 4 to choose Wind Turbine Class S (desire Vws_aa, Vws_Ref, and Vws_RefT).';    
        % Choose your option:
    s.Option01f6 = 1; 
    if s.Option01f6 == 1 || s.Option01f6 == 2 || s.Option01f6 == 3 || s.Option01f6 == 4
        Wind_IEC614001_1.Option01f6 = s.Option01f6;  
    elseif s.Option01f6 == 4
        Wind_IEC614001_1.Option01f6 = s.Option01f6;
           % Defining the desire values:
        who.Vws_aa = 'Annual Averave Wind Speed, in [m/s].';
        s.Vws_aa = 11;
        who.Vws_Ref = 'Reference Wind Speed Average over 10 minutes, in [m/s].';
        s.Vws_Ref = 42.5;
        who.Vws_RefT = 'Reference Wind Speed Average over 10 minutes applicable for areas subject to Tropical Cyclones, in [m/s].';
        s.Vws_RefT = 57;       
    else
        error('Invalid option selected for Option01f6. Please choose 1 or 2 or3 or 4.');
    end  


    % ---------- Option 02: Wind Turbine Class (A+, A, B, C) according to IEC-614001-1 Standard (2019) ----------
    who.Option02f6.Option_02 = 'Option 02 of Recursive Function f6';
    who.Option02f6.about = 'Wind Turbine Class (A+, A, B, C) according to IEC-614001-1 Standard (2019), in Table 1. Choose the Turbulence Intensity.';
    who.Option02f6.choose_01 = 'Option02f6 == 1 to choose Wind Turbine Class A+ (I_ref = 0.18).';
    who.Option02f6.choose_02 = 'Option02f6 == 2 to choose Wind Turbine Class A (I_ref = 0.16).';
    who.Option02f6.choose_03 = 'Option02f6 == 3 to choose Wind Turbine Class B (I_ref = 0.14).';
    who.Option02f6.choose_04 = 'Option02f6 == 4 to choose Wind Turbine Class C (I_ref = 0.12).';   
        % Choose your option:
    s.Option02f6 = 1; 
    if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 || s.Option02f6 == 4
        Wind_IEC614001_1.Option02f6 = s.Option02f6;
    else
        error('Invalid option selected for Option02f6 Please choose 1 or 2 or 3 or 4.');
    end  

    % -- Option 03: External Wind Conditions according to IEC 61400-1 ---
    who.Option03f6.Option_03 = 'Option 03 of Recursive Function f6';
    who.Option03f6.about = 'External Wind Conditions according to IEC 61400-1 (extreme or normal conditions).';
    who.Option03f6.choose_01 = 'Option03f6 == 1 to choose Normal Wind Conditions, described in section 6.3.2 of IEC 61400-1 Standard.';
    who.Option03f6.choose_02 = 'Option03f6 == 2 to choose Extreme Wind Speed ​​Model (EWM), described in section 6.3.3.2 of IEC 61400-1 Standard.';
    who.Option03f6.choose_03 = 'Option03f6 == 3 to choose Extreme Operating Gust (EOG), described in section 6.3.3.3 of IEC 61400-1 Standard.';
    who.Option03f6.choose_04 = 'Option03f6 == 4 to choose Extreme Turbulence Model (ETM), described in section 6.3.3.4 of IEC 61400-1 Standard.';    
    who.Option03f6.choose_05 = 'Option03f6 == 5 to choose Extreme Direction Change (EDC), described in section 6.3.3.5 of IEC 61400-1 Standard.';
    who.Option03f6.choose_06 = 'Option03f6 == 6 to choose Extreme Coherent Gust with Direction Change (ECD), described in section 6.3.3.6 of IEC 61400-1 Standard.';    
    who.Option03f6.choose_07 = 'Option03f6 == 7 to choose Extreme Wind Shear (EWS), described in section 6.3.3.7 of IEC 61400-1).';     
        % Choose your option:
    s.Option03f6 = 1;
    if s.Option03f6 == 1 || s.Option03f6 == 2
        Wind_IEC614001_1.Option03f6 = s.Option03f6;
    else
        error('Invalid option selected for Option03f6. Please choose 1 or 2.');
    end

    
    % ------ Option 04: Add Tower Shadow Effect to Effective Wind Speed ​​Model -----
    who.Option04f6.Option_04 = 'Option 04 of Recursive Function f6';
    who.Option04f6.about = 'Add Tower Shadow Effect to Effective Wind Speed ​​Model.';
    who.Option04f6.choose_01 = 'Option04f6 == 1 to choose ADD TOWER SHADONW effect to Effective Wind Speed Model.';       
    who.Option04f6.choose_02 = 'Option04f6 == 2 to choose DO NOT Add Tower Shadow Effect to Effective Wind Speed ​​Model.'; 
        % Choose your option:
    s.Option04f6 = 1; 
    if s.Option04f6 == 1 || s.Option04f6 == 2
        Wind_IEC614001_1.Option04f6 = s.Option04f6;
    else
        error('Invalid option selected for Option04f6. Please choose 1 or 2.');
    end


    % ---------- Option 05: Effective Wind Speed ​​Calculation Approach ----------
    who.Option05f6.Option_05 = 'Option 05 of Recursive Function f6';
    who.Option05f6.about = 'comentários sobre do que se trata';
    who.Option05f6.choose_01 = 'Option05f6 == 1 to choose use the Simple Average calculation, based on the Held (2018/2019)approach or others.';       
    who.Option05f6.choose_02 = 'Option05f6 == 2 to choose use the Weighted Average calculation, based on the Schlipf/Knudsen (2013) approach.';
    who.Option05f6.choose_03 = 'Option05f6 == 3 to choose use the Transfer Function (spatial filter), based on the Gavriluta (2002) approach or others.';
    who.Option05f6.choose_04 = 'Option05f6 == 4 to choose to compare different approaches for Effective Wind Speed ​​and choose the calculation of Weighted Average for NREL5MW wind turbine and Simple Average for IEC15MW or DTU10MW wind turbine.';       
    who.Option05f6.choose_05 = 'Option05f6 == 5 to choose use the von Karman and Transfer Function (spatial filter), based on the Gavriluta (2002) approach or others.';    
        % Choose your option:
    s.Option05f6 = 4; 
    if s.Option05f6 == 1 || s.Option05f6 == 2 || s.Option05f6 == 3  || s.Option05f6 == 4  || s.Option05f6 == 5
        Wind_IEC614001_1.Option05f6 = s.Option05f6;
    else
        error('Invalid option selected for Option05f6. Please choose 1 or 2 or 3 or 4 or 5.');
    end


    % ---------- Option 06: Add Effect of Rotational Sampling ----------
    who.Option06f6.Option_06 = 'Option 06 of Recursive Function f6';
    who.Option06f6.about = 'Add Effect of Rotational Sampling on the Wind Speed.';
    who.Option06f6.choose_01 = 'Option06f6 == 1 to choose Add rotational effect to Effective Wind Speed.';
    who.Option06f6.choose_02 = 'Option06f6 == 2 to choose DO NOT add rotational effect to Effective Wind Speed.'; 
        % Choose your option:
    s.Option06f6 = 2;
    if s.Option06f6 == 1 || s.Option06f6 == 2
        Wind_IEC614001_1.Option06f6 = s.Option06f6;
    else
        error('Invalid option selected for Option06f6. Please choose 1 or 2.');
    end 


    % -- Option 07: Add the effect of blade vibration on the effective wind speed ---
    who.Option07f6.Option_07 = 'Option 07 of Recursive Function f6';
    who.Option07f6.about = 'Add the effect of blade vibration on the effective wind speed.';
    who.Option07f6.choose_01 = 'Option07f6 == 1 to choose Add the effect of blade vibration on the effective wind speed.';
    who.Option07f6.choose_02 = 'Option07f6 == 2  to choose DO NOT add the effect of blade vibration on the effective wind speed.';
        % Choose your option:
    s.Option07f6 = 2;
    if s.Option07f6 == 1 || s.Option07f6 == 2
        Wind_IEC614001_1.Option07f6 = s.Option07f6;
    else
        error('Invalid option selected for option07f6. Please choose 1 or 2.');
    end     


    % ---------- Option 08: Grid Construction Options ----------
    who.Option08f6.Option_08 = 'Option 08 of Recursive Function f6';
    who.Option08f6.about = 'Options for constructing the Grid in front of the rotor disc.';
    who.Option08f6.choose_01 = 'Option08f6 == 1 to choose the Optimized Configuration of points in the disk plane (average computational cost and satisfactory resolution of the turbulence effect).';    
    who.Option08f6.choose_02 = 'Option08f6 == 2 to choose the configuration with the Minimum number of points (lower computational cost and low resolution in the turbulence effect).';
    who.Option08f6.choose_03 = 'Option08f6 == 3 to choose the configuration with a Medium/Reasonable number of points (medium computational cost and medium resolution of the turbulence effect).';
    who.Option08f6.choose_04 = 'Option08f6 == 4 to choose the configuration with a high number of points (high computational cost and good resolution of the turbulence effect - more realistic).';    
        % Choose your option:
    s.Option08f6 = 1;
    if s.Option08f6 == 1 || s.Option08f6 == 2 || s.Option08f6 == 3 || s.Option08f6 == 4
        Wind_IEC614001_1.Option08f6 = s.Option08f6;
    else
        error('Invalid option selected for option08f6. Please choose 1 or 2 or 3 or 4.');
    end    
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
        % Go to Logical Instance 15 (data related to TO IEC-61400-1 and
        % wind field) to check how the points will be distributed.


    % ---------- Option 09: Plot Wind Model Figures ----------
    who.Option09f6.Option_09 = 'Option 09 of Recursive Function f6';
    who.Option09f6.about = 'Plot Wind Model Figures.';
    who.Option09f6.choose_01 = 'Option09f6 == 1 to choose NOT to Plot Figures.';
    who.Option09f6.choose_02 = 'Option09f6 == 2 to choose Plot Figures.';
        % Choose your option:
    s.Option09f6 = 1;
    if s.Option09f6 == 1 || s.Option09f6 == 2
        Wind_IEC614001_1.Option09f6 = s.Option09f6;
    else
        error('Invalid option selected for Option09f6. Please choose 1 or 2.');
    end     



   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Return to EnviromentSimulation('logical_instance_01');
 

elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%============================================================= 
    % WIND SAMPLING AND GENERATION CIRCUMSCRIBED GRID 2D ON THE ROTOR DISC (OFFLINE): 
    % Purpose of this Logical Instance: to sample the wind, considering the
    % Van der Hoven spectrum analysis (1957) and generate a Grid 2D of fixed
    % points, circumscribed on the rotor disk and positioned in front of
    % the wind turbine. Through this grid, a wind speed profile can be 
    % adopted and used in modeling the loads applied to the tower, 
    % platform and rotor.


    % ---------- Total simulation time ----------   
    who.tf = 'Total simulation time, in [s].'; 
     Wind_IEC614001_1.tf = s.tf; 


    % ---------- Wind Properties and Statistics for Wind Turbine Design ----------
    who.rho = 'Air density in [kg/m^3], under standard conditions at 25ºC and 1 [atm].';
    Wind_IEC614001_1.rho = s.rho;       
    

    % ---------- Grid of Points/Nodes circumscribed over Rotor Disc ----------
    who.DiskRotor = 'Rotor Disc Diameter, in [m].';
    Wind_IEC614001_1.DiskRotor = s.DiameterRotor;    
    who.Ny_grid = 'Number of Points in y (base) on the Grid., in [dimensionless].';
    Wind_IEC614001_1.Ny_grid = s.Ny_grid;
    who.Nz_grid = 'Number of Points in z (base) on the Grid., in [dimensionless].';
    Wind_IEC614001_1.Nz_grid = s.Nz_grid;
    who.Nt = 'Total number of grid points, in [dimensionless]. See Main (1998).';
    Wind_IEC614001_1.Nt = s.Nt;     
    who.Ly_grid = 'Grid Width, in [m].';
    Wind_IEC614001_1.Ly_grid = s.Ly_grid;
    who.Lz_grid = 'Grid Width, in [m].';
    Wind_IEC614001_1.Lz_grid = s.Lz_grid;  


    % ---------- Defining Grid Coordinates ----------
    who.dy_grid = 'Space differential along the Y axis, in [m].';
    Wind_IEC614001_1.dy_grid = s.dy_grid;
    who.dz_grid = 'Space differential along the Z axis, in [m].';
    Wind_IEC614001_1.dz_grid = s.dz_grid;    
    who.Y_grid  = 'Y coordinate (width of the rotor disk plane), in [m].';    
    Wind_IEC614001_1.Y_grid = s.Y_grid;
    who.Z_grid = 'Z coordinate (height of the rotor disk plane), in [m].';    
    Wind_IEC614001_1.Z_grid = s.Z_grid;
    
    who.idxsMGrid_y = 'Index of the Y coordinate of the grid (origin at the center of the disk). Index of the vector "PointsModeling_y" and columns of the matrix "Y_grid".';
    Wind_IEC614001_1.idxsMGrid_y  = s.idxsMGrid_y;
    who.idxsMGrid_z = 'Index of the Z coordinate of the grid. Index of the vector "PointsModeling_z" and columns of the matrix "Z_grid".';
    Wind_IEC614001_1.idxsMGrid_z = s.idxsMGrid_z; 
    who.idxsMGrid_OriginY = 'Index of the Y_grid Matrix of the global grid coordinate system.';    
    Wind_IEC614001_1.idxsMGrid_OriginY = s.idxsMGrid_OriginY;
    who.idxsMGrid_OriginZ = 'Index of the Z_grid Matrix of the global grid coordinate system.'; 
    Wind_IEC614001_1.idxsMGrid_OriginZ = s.idxsMGrid_OriginZ;
    who.idxsV_Grid = 'Single Index of the Z coordinate of the grid (origin at the center of the disk). The dimension of this matrix is (1 x Nt).';
    Wind_IEC614001_1.idxsV_Grid = s.idxsV_Grid;
    who.idxsM_Grid = 'Matrix indices correlated to the unique index system for vectors.';
    Wind_IEC614001_1.idxsM_Grid = s.idxsM_Grid;
    who.idxsMGrid_Origin = 'Index of the origin of the Grid.';
    Wind_IEC614001_1.idxsMGrid_Origin = s.idxsMGrid_Origin;
    who.Z_GridV = 'Index of the Z coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
    Wind_IEC614001_1.Z_GridV =  s.Z_GridV;
    who.Y_GridV = 'Index of the Y coordinate of the Grid Coordinates System. The dimension of this matrix is (1 x Nt) .';
    Wind_IEC614001_1.Y_GridV = s.Y_GridV;

    who.idxsV_hub = 'Index of the point at the height of the Hub or the center of the Disc, in grid coordinates.';
    Wind_IEC614001_1.idxsV_hub = s.idxsV_hub;     
    who.Width_grid = 'Width of the discretized grid (Y axis), in [m].';
    Wind_IEC614001_1.Width_grid = s.Width_grid ;  
    who.Height_grid = 'Height of the discretized grid (Z axis), in [m].';
    Wind_IEC614001_1.Height_grid = s.Height_grid; 
    who.Zgrid_bottom = 'Height at the bottom of the grid (Z axis), in [m].';    
    Wind_IEC614001_1.Zgrid_bottom = s.Zgrid_bottom;


    % ----- Indexing points of Tower -----    
    who.Height_tower = 'Height of the discretized tower (Z axis), in [m].';
    Wind_IEC614001_1.Height_tower = s.Height_tower;     
    who.Width_tower = 'Width of the discretized tower (Y axis), in [m].';
    Wind_IEC614001_1.Width_tower = s.Width_tower; 
    who.idxsV_Tower = 'Index corresponding to the heights of the tower.';
    Wind_IEC614001_1.idxsV_tower = s.idxsV_tower;       
    who.N_TowerLine = 'Number of grid elements located on the tower line (Z axis), in [dimensionless].';    
    Wind_IEC614001_1.N_TowerLine = s.N_TowerLine;  
    who.idxsV_Toptower = 'Index corresponding to the top of the tower.';    
    Wind_IEC614001_1.idxsV_Toptower = s.idxsV_Toptower;
    who.idxsV_Bottomtower = 'Index corresponding to the bottom of the tower.';    
    Wind_IEC614001_1.idxsV_Bottomtower = s.idxsV_Bottomtower;
    who.idxsV_CMtower = 'Index corresponding to the center of mass of the tower.';    
    Wind_IEC614001_1.idxsV_CMtower = s.idxsV_CMtower;    
    who.idxsV_Vswl1hour = 'Index corresponding to the overall center of mass of the wind turbine.';
    Wind_IEC614001_1.idxsV_Vswl1hour = s.idxsV_Vswl1hour;
    % if s.Option02f2 > 1 % Offshore Wind Turbine
    %     Wind_IEC614001_1.idxsV_Vswl1hour = s.idxsV_Vswl1hour;
    % end
    who.idxsV_OveralCM = 'Index corresponding to the overall center of mass of the wind turbine.';
    Wind_IEC614001_1.idxsV_OveralCM = s.idxsV_OveralCM;

      
    % ----- Indexing points of Disk -----    
    who.LocalRadiusGrid_Mpolar= 'Local Radius on Grid (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (Ny_grid x Nz_grid).';
    Wind_IEC614001_1.LocalRadiusGrid_Mpolar = s.LocalRadiusGrid_Mpolar;  
    who.LocalRadiusGrid_Vpolar = 'Local Radius on Grid (Polar Coordinate and origin at center of disk), in [m]. The dimension of this vector is (1 x Nt).';
    Wind_IEC614001_1.LocalRadiusDisk_Vpolar = s.LocalRadiusDisk_Vpolar;
    who.MuGrid_Mpolar = 'Standard Blade Radius (r/R), in [m]. The dimension of this vector is (Ny_grid x Nz_grid).';
    Wind_IEC614001_1.MuGrid_Mpolar = s.MuGrid_Mpolar;
    who.MuGrid_Vpolar = 'Standard Blade Radius (r/R) of Grid, in [m]. The dimension of this vector is (1 x Nt).';
    Wind_IEC614001_1.MuGrid_Vpolar = s.MuGrid_Vpolar;

    who.idxsV_Disk = 'Index corresponding to the points circumscribed on the rotor disc.';    
    Wind_IEC614001_1.idxsV_Disk = s.idxsV_Disk;
    who.Length_Disk = 'Total Points circumscribed in the rotor disk'; 
    Wind_IEC614001_1.Length_Disk = s.Length_Disk;
    who.LocalRadiusDisk_Vpolar = 'Local Radius on Disk (Polar Coordinate), in [m].';    
    Wind_IEC614001_1.LocalRadiusDisk_Vpolar = s.LocalRadiusDisk_Vpolar;    
    who.idxsV_DiskHub = 'Index of the point at the height of the Hub or the center of the Disc, in grid coordinates.';
    Wind_IEC614001_1.idxsV_DiskHub = s.idxsV_DiskHub;

    who.Z_DiskV = 'Index of the Z coordinate of the DISK Coordinates System. The dimension of this matrix is (1 x Nt) .';
    Wind_IEC614001_1.Z_DiskV = s.Z_DiskV;
    who.Y_GridV = 'Index of the Y coordinate of the DISK Coordinates System. The dimension of this matrix is (1 x Nt) .';
    Wind_IEC614001_1.Y_DiskV = s.Y_DiskV;      


    % ---------- Tower Shadow Model Parameters  ----------  
    if s.Option04f6 == 1
        % ADD TOWER SHADONW effect to Effective Wind Speed Model
        who.DxHubTower = 'Distance between the Rotor Center (Hub) in relation to the Center of the Tower diameter Kooijman (2003), in [m].';
        Wind_IEC614001_1.DxHubTower = s.DxHubTower;
        who.DiameterTowerTop = 'Tower diameter at the top of the tower, in [m].';
        Wind_IEC614001_1.DiameterTowerTop = s.DiameterTowerTop;
        who.DiameterTowerBase = 'Tower diameter at the base of the tower, in [m].';
        Wind_IEC614001_1.DiameterTowerBase = s.DiameterTowerBase;
        who.indexTowerShadow = 'Index of the, in [m].';
        s.indexTowerShadow = s.idxsV_Disk(find( s.Z_GridV(s.idxsV_Disk) <= s.HtowerG )) ;
        who.DistributionDiameterTower = 'Tower diameter adopted, in [m].';
        s.DistributionDiameterTower = linspace( s.DiameterTowerBase , s.DiameterTowerTop, length(s.indexTowerShadow) );
        
        Wind_IEC614001_1.indexTowerShadow = s.indexTowerShadow; Wind_IEC614001_1.DistributionDiameterTower = s.DistributionDiameterTower;
    end

 
    % ----- Calculating Euclidean distances between all grid points -----  
    who.EuclideanDistanceYZ = 'Matrix of Euclidean Distances between All Grid Points, in [m]. The full expression calculates the square root of the sum of the squares minus twice the inner product, resulting in the Euclidean Euclidean Distance YZ between all points.';  
    s.EuclideanDistanceYZ = abs(sqrt(bsxfun(@plus,sum([s.Y_grid(:) s.Z_grid(:)].^2,2),sum([s.Y_grid(:) s.Z_grid(:)].^2,2)') - 2*([s.Y_grid(:) s.Z_grid(:)]*[s.Y_grid(:) s.Z_grid(:)]')));   
    s.Nr_ed = length(s.EuclideanDistanceYZ);


    % ---------- Wind Speed Sampling ----------
    who.SampleT_Vm = 'Sampling of the Long-Medium-Duration Component (Vm), in [seg]. Adopted according to the analysis of the van der Hoven spectrum (1957) and according to IEC-614001-1 Standard.';
    s.SampleT_Vm = 600;   
    who.SampleF_Vm = 'Sampling of the Long-Medium-Duration Component (Vm), in [Hz]. Adopted according to the analysis of the van der Hoven spectrum (1957) and according to IEC-614001-1 Standard.';
    s.SampleF_Vm = 1/s.SampleT_Vm; 
    who.Tws_0 = 'Minimum Simulation Time to Generate Wind, in [seg].';
    if s.Option02f2 == 1
        % Onshore Wind Turbine
        s.Tws_0 = max(s.tf, s.SampleT_Vm) + (s.Ly_grid / s.V_meanHub_0);
    else
        % Offshore Wind Turbine
        s.Tws_0 = max(s.tf, 6*s.SampleT_Vm ) + (s.Ly_grid / s.V_meanHub_0);
            % NOTE: It is necessary to measure the average wind speed at
            % a height of 10 meters SWL, with a time of 1 hour.
    end


    who.NyquistFreq_wind = 'Maximum Cut-off Frequency for Wind Speed ​​(Nyquist Frequency), in [Hz].';
    s.NyquistFreq_wind = 2*max(s.AllFreqWT);  % Where AllFrequencies was defined in Wind Turbine data
    who.SampleF_Wind = 'Maximum Cut-off Frequency for Wind Speed ​​(Nyquist Frequency), in [Hz].';
    s.SampleF_Wind = 20; 
    who.SampleT_Wind = 'Maximum Cut-off Frequency for Wind Speed ​​(Nyquist Frequency), in [seg].';    
    if s.SampleF_Wind >= s.NyquistFreq_wind
        s.SampleT_Wind = 1/s.SampleF_Wind;
    else
        s.SampleT_Wind = ceil(s.NyquistFreq_wind);
    end

    who.AllFreqDist = 'Vector with All Disturbance Frequencies considered in the Wind Turbine problem (onshore or offshore), in [Hz].';    
    s.AllFreqDist = [s.SampleF_Vm, s.SampleF_Wind];  
      % Note: According to Soltani and Knudsen (2013), when selecting the 
      % model structure, it is appropriate to include the dynamics of 
      % the low-frequency end up to some limiting frequency. The effective
      % wind speed is typically used for gain programming in single turbine 
      % control or for estimating available power in wind farm control. 
      % For these applications, a sampling rate below 10 Hz is sufficient.
      % In OpenFast is used 20 [Hz], here we adoted 20 [Hz].

   

    % Organizing output results    
    Wind_IEC614001_1.EuclideanDistanceYZ = s.EuclideanDistanceYZ; Wind_IEC614001_1.Nr_ed = s.Nr_ed;
    Wind_IEC614001_1.SampleT_Vm = s.SampleT_Vm; Wind_IEC614001_1.SampleF_Vm = s.SampleF_Vm; Wind_IEC614001_1.Tws_0 = s.Tws_0; 
    Wind_IEC614001_1.NyquistFreq_wind = s.NyquistFreq_wind; Wind_IEC614001_1.SampleF_Wind = s.SampleF_Wind; Wind_IEC614001_1.SampleT_Wind = s.SampleT_Wind; Wind_IEC614001_1.AllFreqDist = s.AllFreqDist;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    System_WindFieldIEC614001_1('logical_instance_03'); 


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % SELECTING WIND SIGNAL TYPE (OFFLINE):
    % Purpose of this Logical Instance: to identify which wind signal was 
    % chosen for the simulation. This choice is intrinsically related to 
    % the objective of what is to be studied and analyzed.
    

    % ---------- Identifying which Wind Signal was chosen ----------

    if s.Option03f1 == 1 % Stochastic Signal: loading Wind Fild  

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_10');   

    elseif s.Option03f1 == 2 % Stochastic Signal: generate Wind Fild (Veers Methods)

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_04');   
        
    elseif s.Option03f1 == 3 % Stochastic Signal: generate Wind Fild (Transfer Function Methods)

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_09'); 

    elseif s.Option03f1 == 4 % Deterministic Signal: Constant Wind

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_11'); 

    elseif s.Option03f1 == 5 % Deterministic Signal: Linear Increasing Wind Signal from V_meanHub_0

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_12');   

    elseif s.Option03f1 == 6 % Deterministic Signal: Linear Decreasing Wind Signal from V_meanHub_0

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_13'); 

    elseif s.Option03f1 == 7 % Deterministic Signal: Custom Wind Profile

        % Calling the next logic instance  
        System_WindFieldIEC614001_1('logical_instance_14'); 

    end


elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================  
    % DISCRETIZATION BASED ON VAN DER HOVEN SPECTRUM ANALYSIS (OFFILINE):
    % Purpose of this Logical Instance: to start implementing turbulent 
    % wind generation with the discretization of the Medium-Duration (Vm)
    % and Short-Duration (Vt) components based on the van der Hoven 
    % Spectrum analysis (1957). The discretization is done for the Wind 
    % Speed ​​at the Height of the Hub and will later be adequately 
    % distributed among the points on the Grid.
    %
    % ## Theoretical References used in this logical instance:
    % # Title: "Power spectrum of horizontal wind speed in the frequency range 
    % from 0.0007 to 900 cycles per hour." by Isaac Van der Hoven. 1957.
    % # Title: "Large Band Simulation of the Wind Speed for Real Time Wind 
    % Turbine Simulators." by Cristian Nichita, Dragos Luca, Brayima Dakyo,
    % and Emil Ceanga. 2002.
    % # Title: "Complete methodology on generating realistic wind speed 
    % profiles based on measurements." by C. Gavriluta, S. Spataru, 
    % I. Mosincat, C. Citro, I. Candela, P. Rodriguez. 2012.
    % # Title: "Wind Turbine Control Systems" by Fernando D. Bianchi, Hernán 
    % De Battista and Ricardo J. Mantz. Chapter 2 and Section 7 of Chapter
    % 3 (section 3.7). 2006.


    % ---------- Sampling of the Turbulent Component (short duration) ----------
    in = 1:50;
    Nii = 2.^in;
    TwsOptions = Nii./s.SampleF_Wind;
    indexNws = max(find(TwsOptions >= s.tf, 1, 'first'), 1);
    who.Nws = 'Number of elements of the Final Time Series obtained, in [dimensionless].';
    s.Nws = Nii(indexNws);  
    who.Tws = 'Selected Simulation Time to Generate Wind, in [seg].';
    s.Tws = s.Nws/s.SampleF_Wind;
    who.dt_ws = 'Wind file time step, in [seg].';
    s.dt_ws = s.Tws/s.Nws;    
    who.Time_ws = 'Simulation time for the final wind field generation model, in [seg].';    
    s.Time_ws = 0:s.dt_ws:(s.Tws) ;% linspace(s.dt_ws,s.Tws,);
    who.df = 'Frequency sample, in [Hz].';
    s.df_ws = s.SampleF_Wind/s.Nws;
    who.fp = 'Positive Frequency vector, in [Hz].';    
    s.fp = s.df_ws:s.df_ws:(0.5*s.SampleF_Wind);
    who.Nfp = 'Number of elements of Positive Frequency, in [dimensionless].';
    s.Nfp = s.Nws/2;


    % ---------- Sampling of the Medium-Long-Term Component ----------
    who.N_Vm = 'Number of elements of the Mean Wind Speed ​​Model (Vm).'; 
    s.N_Vm = ceil(s.Tws/s.SampleT_Vm);    
    who.Time_wsm = 'Simulation time vector for mean wind generation, in [seg].';
    s.Time_wsm = 0:s.SampleT_Vm:(s.SampleT_Vm*s.N_Vm);
    who.df_m = 'Sampled frequency of the Mean Wind Speed ​​Model (Vm), in [Hz].';    
    s.df_wsm = s.SampleF_Vm/s.N_Vm; 
    who.fp_m = 'Frequencies of the Mean Wind Speed ​​model, in [Hz].';     
    s.fp_m = s.df_wsm:s.df_wsm:s.SampleF_Vm;


    % ---------- Sampling for simulation of Wind Field Generation Models ---------- 
    who.Nws_10min = 'Number of elements of the time vector with a 10-minute window, in [dimensionless].';
    s.Nws_10min = max(find(s.Time_ws >= s.SampleT_Vm, 1, 'first'), 1);
    who.idxFFT = 'Index of the time vector for 10 minute windows, in [dimensionless].';
    for iit = 1:s.N_Vm        
        s.idxFFT(iit) = max(find(s.Time_ws >= s.Time_wsm(iit), 1, 'first'), 1); % Check s.Time_ws(s.idxFFT_f)      
    end
    who.idxFFT_f = 'End index of the time vector for 10 minute windows, in [dimensionless].';
    s.idxFFT_f = [s.idxFFT(2:end) s.Nws];
    who.idxFFT_0 = 'Start index of the time vector for 10 minute windows, in [dimensionless].';
    s.idxFFT_0 = [1 (s.idxFFT(2:end)+1)]; %
    who.idxFFT_Midpoint = 'Midpoint index of the time vector for 10 minute windows, in [dimensionless].';
    s.idxFFT_Midpoint = round( ( s.idxFFT_f - s.idxFFT_0 )./2 ) +  s.idxFFT_0;
    who.dt_wsp = 'Time step for simulation to half the desired frequency, in [seg].';
    s.dt_wsp = s.Tws/s.Nfp;    
    who.Time_p = 'Time vector for simulation at half the desired frequency, in [seg].';    
    s.Time_p = 0:s.dt_wsp:(s.Tws);
    who.Nws_10minP = 'Number of elements of the time vector with a 10-minute window, in [dimensionless].';
    s.Nws_10minP = max(find(s.Time_p >= s.SampleT_Vm, 1, 'first'), 1);
    who.idxPSD = 'Index of the time vector for 10 minute windows, in [dimensionless].';
    for iit = 1:s.N_Vm        
        s.idxPSD(iit) = max(find(s.Time_p >= s.Time_wsm(iit), 1, 'first'), 1); % Check s.Time_p(s.idxPSD)      
    end
    who.idxPSD_f = 'End index of the time vector for 10 minute windows, in [dimensionless].';
    s.idxPSD_f = [s.idxPSD(2:end) s.Nfp];
    who.idxPSD_0 = 'Start index of the time vector for 10 minute windows, in [dimensionless].';
    s.idxPSD_0 = [1 (s.idxPSD(2:end)+1)];

    for iit = 1:s.N_Vm   
        if iit == 1
            s.Nws_pm(iit) = s.idxPSD_f(iit);
            s.Npsd_vm = ones(1,s.Nws_pm(iit));
            
            s.Nws_tm(iit) = s.idxFFT_f(iit);
            s.Nfft_vm = ones(1,s.Nws_tm(iit));            
        else
            s.Nws_pm(iit) = s.idxPSD_f(iit) - s.idxPSD_f(iit-1);            
            s.Npsd_vm = [s.Npsd_vm ones(1, s.Nws_pm(iit))];

            s.Nws_tm(iit) = s.idxFFT_f(iit) - s.idxFFT_f(iit-1);
            s.Nfft_vm = [s.Nfft_vm ones(1,s.Nws_tm(iit))];            
        end      
    end 


    % Organizing output results     
    Wind_IEC614001_1.Nws = s.Nws; Wind_IEC614001_1.Tws = s.Tws; Wind_IEC614001_1.dt_ws = s.dt_ws; Wind_IEC614001_1.Time_wsm = s.Time_wsm; Wind_IEC614001_1.df = s.df_ws; Wind_IEC614001_1.fp = s.fp; Wind_IEC614001_1.Nfp = s.Nfp;
    Wind_IEC614001_1.N_Vm = s.N_Vm; Wind_IEC614001_1.Time_wsm = s.Time_wsm; Wind_IEC614001_1.df_m = s.df_wsm; Wind_IEC614001_1.fp_m = s.fp_m;
    Wind_IEC614001_1.Nws_10min = s.Nws_10min; Wind_IEC614001_1.idxFFT = s.idxFFT; Wind_IEC614001_1.idxFFT_f = s.idxFFT_f; Wind_IEC614001_1.idxFFT_0 = s.idxFFT_0; Wind_IEC614001_1.idxFFT_Midpoint = s.idxFFT_Midpoint;
    Wind_IEC614001_1.dt_wsp = s.dt_wsp; Wind_IEC614001_1.Time_p = s.Time_p; Wind_IEC614001_1.Nws_10minP = s.Nws_10minP; Wind_IEC614001_1.idxPSD = s.idxPSD; Wind_IEC614001_1.idxPSD_f = s.idxPSD_f; Wind_IEC614001_1.idxPSD_0 = s.idxPSD_0;
    Wind_IEC614001_1.Nws_pm = s.Nws_pm; Wind_IEC614001_1.Npsd_vm = s.Npsd_vm; Wind_IEC614001_1.Nws_tm = s.Nws_tm; Wind_IEC614001_1.Nfft_vm = s.Nfft_vm;    


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option03f1 == 2
        System_WindFieldIEC614001_1('logical_instance_05'); 
    end


elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================
    % MEAN WIND SPEED MODEL (OFFLINE):
    % Purpose of this Logical Instance: to generate the mean-long term 
    % component of wind speed, based on based on the power spectrum of the
    % horizontal wind speed and an adequate discretization made previously.
    %   Theoretical Description of this step is that the Medium-Long 
    % Duration component will then be modeled based on the average speed 
    % at the hub height and for each generated value,  according to Nichita
    % (2002) approach. The parameters used in the Kaimal or von Karman 
    % spectra are defined according to IEC 61400-1.
    %
    % ## Theoretical References used in this logical instance:
    % # Title: "Large Band Simulation of the Wind Speed for Real Time Wind 
    % Turbine Simulators." by Cristian Nichita, Dragos Luca, Brayima Dakyo,
    % and Emil Ceanga. 2002.
    % # Title: "Complete methodology on generating realistic wind speed 
    % profiles based on measurements." by C. Gavriluta, S. Spataru, 
    % I. Mosincat, C. Citro, I. Candela, P. Rodriguez. 2012.
    % # Title: "Power spectrum of horizontal wind speed in the frequency range 
    % from 0.0007 to 900 cycles per hour." by Isaac Van der Hoven. 1957.
    % # Title: "Wind Turbine Control Systems" by Fernando D. Bianchi, Hernán 
    % De Battista and Ricardo J. Mantz. Chapter 2 and Section 7 of Chapter
    % 3 (section 3.7). 2006.

    who.fp_mm = 'Frequencies of the Mean Wind Speed ​​model, in [Hz].';     
    s.fp_mm = [0 s.fp_m];

    who.phase_m = 'Discretizing Phase Angle , in [rad].'; 
    s.phase_m = [0 ( (( pi - (-pi) ).*rand(1,s.N_Vm) ) + (-pi) )]; 

    who.omega_fp = 'Discrete Angular Velocity, in [rad/s].'; 
    s.omega_fp = (2*pi*s.fp_mm);

    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';
    s.Vws_meanHub = s.V_meanHub_0;

    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
            s.AA0 = s.Vws_meanHub; % Long-Term by Vand der Hoven spectrum
            s.AA(iim) = s.AA0;
            s.SS(iim) = (s.AA(iim)*cos( s.omega_fp(iim)*s.Time_wsm(iim) + s.phase_m(iim) )); % Numerical value to integrate
            s.Vm(iim) = s.SS(iim);   
            s.PSD_vv = ((4.*s.sigma_1(iim).^2.*(s.L1(iim)./s.Vws_meanHub))./( (1 + (6.*s.fp_mm.*(s.L1(iim)./s.Vws_meanHub)) ).^(5/3)));
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
            s.PSD_vv = ((4.*s.sigma_1(iim).^2.*(s.L1(iim)./s.Vws_meanHub))./( (1 + (6.*s.fp_mm.*(s.L1(iim)./s.Vws_meanHub)) ).^(5/3))); % PSD( vector omega_fp ) or/and PSD( vector fp_mm) to Kaimal spectrum
            s.AA(iim) = ( (2/pi)*sqrt( ( 0.5*( s.PSD_vv(iim) +  s.PSD_vv(iim+1) )*( s.omega_fp(iim+1) - s.omega_fp(iim) )  ) )  );
            s.SS(iim) = (s.AA(iim)*cos( s.omega_fp(iim)*s.Time_wsm(iim) + s.phase_m(iim) )); % Numerical value to integrate
            s.Vm(iim) = ( sum(s.SS) );
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % Organizing output results    
    who.AA0 = 'Long-Term by Vand der Hoven spectrum or Mean Wind Speed, calculated on a time horizon greater than the largest period in Van der Hoven´s characteristic (i.e, T = 2*pi/omega1), according to Nichita et. all (2002).';
    Wind_IEC614001_1.AA0 = s.AA0;
    Wind_IEC614001_1.Notef6_10 = 'Modelling of Mean Wind Speed.';      
    who.PSD_vv = 'Medium-Long Duration component, representing the average speed, in [m/s].';
    Wind_IEC614001_1.PSD_vv = s.PSD_vv;
    who.AA = 'Medium-Long Duration component, representing the average speed, in [m/s].';
    Wind_IEC614001_1.AA = s.AA;
    who.Vm = 'Medium-Long Duration component, representing the average speed, in [m/s].';
    Wind_IEC614001_1.Vm = s.Vm;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option03f1 == 2
        System_WindFieldIEC614001_1('logical_instance_07'); 
    end      


%=============================================================
elseif strcmp(action, 'logical_instance_06') 
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================
    % NORMAL WIND CONDITIONS ACCORDING TO IEC 61400-1 STANDARD (OFFLINE):
    % Purpose of this Logical Instance: to calculate the parameters used
    % in the von Karman or Kaimal Spectra for External Wind Conditions 
    % (Normal or Extreme), according to the IEC 61400-1 (2019) standard 
    % and from the average speed obtained at the hub height and sampled 
    % every 10 minutes. In addition, the parameters, characteristics and
    % design choices of the wind turbine and its environment or installation
    % site are defined, as defined in the Wind Turbine Classes. 
    %
    %   The models considered are:
    % >> Normal Wind Conditions: Normal Turbulence Model (NTM) and Normal Wind Profile Model (NWP)
    % >> Extreme Wind Conditions: Extreme Wind Speed ​​Model (EWM)
    % >> Extreme Wind Conditions: Extreme Operating Gust (EOG)
    % >> Extreme Wind Conditions: Extreme Turbulence Model (ETM)
    % >> Extreme Wind Conditions: Extreme Direction Change (EDC)
    % >> Extreme Wind Conditions: Extreme Coherent Gust with Direction Change (ECD)
    % >> Extreme Wind Conditions: Normal Extreme Wind Shear (EWS)
    %
    % ## Theoretical References used in this logical instance:
    % # Title: IEC 61400-1: Wind energy generation systems - Part 1: 
    % Design requirements. Edition 2019-02. International Electrotechnical 
    % Commission (IEC).


    % ---------- Wind Turbine Classes (General) ----------
    if iim == 1
    % Wind turbines are designed for specific conditions where they will
    % be installed. Turbine classes are determined by three parameters:
    % (i) the annual mean wind speed;
    % (ii) 50-year extreme gust; and
    % (iii) turbulence intensity.
        who.Vws_aa = 'Annual Averave Wind Speed, in [m/s].';
        if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C
            s.Vws_aaAll = [10, 8.5, 7.5];
            s.Vws_aa = s.Vws_aaAll(s.Option01f6);
        else % Wind Turbine Class S (choose the desired value)
            s.Vws_aa = 10;
        end

        who.Vws_Ref = 'Reference Wind Speed Average over 10 minutes, in [m/s].';
        if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C
            s.Vws_RefAll = [50, 42.5, 37.5];
            s.Vws_Ref = s.Vws_RefAll(s.Option01f6);
        else % Wind Turbine Class S (choose the desired value)
            s.Vws_Ref = 50;
        end  

        who.Vws_RefT = 'Reference Wind Speed Average over 10 minutes applicable for areas subject to Tropical Cyclones, in [m/s].';
        if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C
            s.Vws_RefT = 57;

        else % Wind Turbine Class S (choose the desired value)
            s.Vws_RefT = 56.999;
        end

        who.I_ref = 'Reference value of the Turbulence Intensity (Normal Turbulence Model - NTM), in [dimensionless].';
        if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C
            s.I_refAll = [0.18, 0.16, 0.14, 0.12];
            s.I_ref = s.I_refAll(s.Option02f6);
        else % Wind Turbine Class S (choose the desired value)
            s.I_ref = 0.16; % Classe S conforme Ishihara (2012)
        end   

         who.IEC6140011_Classes = 'Wind Turbine Class according to IEC-614001-1 Standard.';
         if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C        
             s.WTClassesType = ["Class I", "Class II", "Class III", "Class S"];
             s.WTClassesTurbIntensity = ["A+", "A", "B", "C"];
             s.IEC6140011_Classes = strcat(s.WTClassesType(s.Option01f6), " ", s.WTClassesTurbIntensity(s.Option02f6) );                     
         else % Wind Turbine Class S (choose the desired value)
             s.IEC6140011_Classes = "Class I S";
         end

         % Organizing output results 
         Wind_IEC614001_1.Vws_aa = s.Vws_aa; Wind_IEC614001_1.Vws_Ref = s.Vws_Ref; Wind_IEC614001_1.Vws_RefT = s.Vws_RefT; Wind_IEC614001_1.I_ref = s.I_ref; Wind_IEC614001_1.IEC6140011_Classes = s.IEC6140011_Classes;

    end % if iim == 1


    who.Notef6_9 = 'Turbulence Spectral Parameters for the Kaimal Model'; 


    % ----------  Longitudinal Turbulence Scale Parameter (General) ----------
    if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C

        % See section 6.3
        if s.HubHt <= 60
            s.Lambda_1(iim) = 0.7*s.HubHt;
        else
            s.Lambda_1(iim) = 42;
        end

    else % Wind Turbine Class S (choose the desired value)

        % See section 6.3
        s.Lambda_1(iim) = 42;
    end

    % Organizing output results      
    Wind_IEC614001_1.Lambda_1 = s.Lambda_1; 


    % ---------- Turbulence Length (According Table C.1 - Anexx C)----------
    if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C       

        s.L1(iim) = 8.10*s.Lambda_1(iim); % See Annex C.3 (Table C.1)
        s.L2(iim) = 2.7*s.Lambda_1(iim); % See Annex C.3 (Table C.1)
        s.L3(iim) = 0.66*s.Lambda_1(iim); % See Annex C.3 (Table C.1)
        s.Lc(iim) = 8.10*s.Lambda_1(iim); % See Annex C.3 (equation C.16)             

    else % Wind Turbine Class S (choose the desired value)

        s.L1(iim) = 8.11*s.Lambda_1(iim); 
        s.L2(iim) = 2.701*s.Lambda_1(iim); 
        s.L3(iim) = 0.659*s.Lambda_1(iim); 
        s.Lc(iim) = 8.11*s.Lambda_1(iim);   
    end   

    % Organizing output results
    Wind_IEC614001_1.L1 = s.L1; Wind_IEC614001_1.L2 = s.L2; Wind_IEC614001_1.L3 = s.L3; Wind_IEC614001_1.Lc = s.Lc;

    
    % ---- Turbulence Parameters based on the Wind Turbine Class ----
    if s.Option02f6 == 1 || s.Option02f6 == 2 || s.Option02f6 == 3 % Wind Turbine Class A+ A, B and C            

        % Assuming a log-normal distribution, compare with the paper "A Study of the Normal Turbulence Model in IEC 61400-1" by Takeshi Ishihara, Atsushi Yamaguchi and Muhammad Waheed Sarwar.
        s.parameter_a = 0.75; 
        s.parameter_b = 3.8; 
        s.parameter_alfa = 0; 
        s.parameter_beta = 1.4; 
        who.sigma_mean_kaimal = 'Standard Deviation of the estimated turbulence, in [m/s].';
        s.sigma_mean_kaimal(iim) = s.I_ref*( s.parameter_a*s.Vws_meanHub + s.parameter_b ) ;
        who.sigma_sig_kaimal = 'Standard Deviation of "sigma_mean_kaimal", in [m/s].';
        s.sigma_sig_kaimal(iim) = s.I_ref*( s.parameter_alfa*s.Vws_meanHub + s.parameter_beta ) ; 
        who.sigma_90_kaimal = 'Standard Deviation given by 90% quantile of "sigma_u", which is calculated by Hub height wind speed, in [m/s].';
%         s.sigma_90_kaimal = ( s.sigma_mean_kaimal + (1.28*s.sigma_sig_kaimal) );
        % See section 6.3.2.3 (equation 10)  
        s.parameter_b_IEC61400 = 1.28*s.parameter_beta + s.parameter_b;        
        s.sigma_90_kaimal(iim) = s.I_ref*( s.parameter_a*s.Vws_meanHub + s.parameter_b_IEC61400 );

        % ---------- Turbulence Intensity ----------  
        who.IntensTurbul_WindTurbineClass = 'Turbulence Intensity according to IEC614001-1 based on Wind Turbine Class, in [decimal].';
        s.IntensTurbul_WindTurbineClass(iim) = (s.sigma_90_kaimal(iim)/s.Vws_meanHub); % See section 6.3 and Annex C.3

        % ---------- Turbulence Standard Deviation ----------
        who.sigmaWindTurbineClass = 'Longitudinal Turbulence Standard Deviation based on Wind Turbine Class, in [m/s].';
        s.sigmaWindTurbineClass(iim) = s.sigma_90_kaimal(iim); % See section 6.3       

    else % Wind Turbine Class S (choose the desired value)     

        % Assuming a log-normal distribution
        s.parameter_a = 0.75; % Classe S conforme Ishihara (2012)
        s.parameter_b = 3.8; % Classe S conforme Ishihara (2012)
        s.parameter_alfa = 0.27; % Classe S conforme Ishihara (2012)
        s.parameter_beta = 2.7; % Classe S conforme Ishihara (2012)  
        who.sigma_mean_kaimal = 'Standard Deviation of the estimated turbulence, in [m/s].';
        s.sigma_mean_kaimal(iim) = s.I_ref*( s.parameter_a*s.Vws_meanHub + s.parameter_b ) ;
        who.sigma_sig_kaimal = 'Standard Deviation of "sigma_mean_kaimal", in [m/s].';
        s.sigma_sig_kaimal(iim) = s.I_ref*( s.parameter_alfa*s.Vws_meanHub + s.parameter_beta ) ; 
        who.sigma_90_kaimal = 'Standard Deviation given by 90% quantile of "sigma_u", which is calculated by Hub height wind speed, in [m/s].';
        s.sigma_90_kaimal(iim) = ( s.sigma_mean_kaimal + (1.28*s.sigma_sig_kaimal) );

        % Compare with the section 6.3.2.3 (equation 10) of IEC 61400-1 (2019)   
%         s.parameter_b_IEC61400 = 1.28*s.parameter_beta + s.parameter_b;        
%         s.sigma_90_kaimal(iim) = s.I_ref*( s.parameter_a*s.Vws_meanHub + s.parameter_b_IEC61400 );

        % ---------- Turbulence Intensity ----------  
        who.IntensTurbul_WindTurbineClass = 'Turbulence Intensity according to IEC614001-1 based on Wind Turbine Class, in [decimal].';
        s.IntensTurbul_WindTurbineClass(iim) = (s.sigma_90_kaimal(iim)/s.Vws_meanHub);

        % ---------- Turbulence Standard Deviation ----------
        who.sigmaWindTurbineClass = 'Longitudinal Turbulence Standard Deviation based on Wind Turbine Class, in [m/s].';
        s.sigmaWindTurbineClass(iim) = s.sigma_90_kaimal(iim);

    end        
  

    % ---- NORMAL WIND CONDITIONS: Normal Turbulence Model (NTM) and Normal Wind Profile Model (NWP) ---- 
    if s.Option03f6 == 1 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end   
    

    % ---- EXTREME WIND CONDITIONS: Extreme Wind Speed Model (EWM) ---- 
    if s.Option03f6 == 2 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end   
  

    % ---- EXTREME WIND CONDITIONS: Extreme Operating Gust (EOG) ---- 
    if s.Option03f6 == 3 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end       


    % ---- EXTREME WIND CONDITIONS: Extreme Turbulence Model (ETM) ---- 
    if s.Option03f6 == 4 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end        


    % ---- EXTREME WIND CONDITIONS: Extreme Direction Change (EDC) ---- 
    if s.Option03f6 == 5 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end        


    % ---- EXTREME WIND CONDITIONS: Extreme Coherent Gust with Direction Change (ECD) ---- 
    if s.Option03f6 == 6 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end     


    % ---- EXTREME WIND CONDITIONS: Extreme Wind Shear (EWS) ---- 
    if s.Option03f6 == 7 
        who.Alfa_WindShear = 'Power Law Exponent or Vertical Wind Shear Exponent, in [unit in SI]. See section 6.3.2.2 Normal wind profile model (NWP) and equation (9) of IEC 614001-1 (2019).';
        s.Alfa_WindShear = 0.2; 
        who.IntensTurbul_WindContidions = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
        s.IntensTurbul_WindContidions = s.IntensTurbul_WindTurbineClass(iim);
        who.sigma_WindContidions = 'Longitudinal Turbulence Standard Deviation adopted, in [m/s].';
        s.sigma_WindContidions = s.sigmaWindTurbineClass; 
        who.WindProfileGrid_WindContidions = 'Wind Profile Power at the Grid, in [m/s]. Normal Wind Profile Model (NWP). The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
        PowerLaw = s.Vws_meanHub.*((s.Z_GridV./s.HubHt).^s.Alfa_WindShear);  
        s.WindProfileGrid_WindContidions = PowerLaw';
    end      
   

    % --- Wind Profile at the Grid amd at the Tower ---
    who.WindProfile_grid = 'Wind Profile at the Grid, in [m/s]. The dimension (Nz_grid*Ny_grid) x Nws, where the rows represent the heights at each point in the grid and the columns the time values.';
    if iim == 1
        s.WindProfile_grid = s.WindProfileGrid_WindContidions; 
    else
        s.WindProfile_grid = [s.WindProfile_grid s.WindProfileGrid_WindContidions];         
    end

    
    % --- Wind Profile at the Grid amd at the Tower ---
    who.IntensTurbul_IEC = 'Turbulence Intensity according to IEC614001-1 adopted, in [decimal].';
    s.IntensTurbul_IEC(iim) = s.IntensTurbul_WindContidions;


    % --- Turbulence Standard Deviation (According Table C.1 - Anexx C) ---
    who.sigma_1 = 'Longitudinal Turbulence Standard Deviation, in [m/s].';  
    s.sigma_1(iim) = s.sigma_WindContidions(iim);
    who.sigma_2 = 'Lateral Turbulence Standard Deviation, in [m/s].';
    s.sigma_2(iim) = 0.8*s.sigma_1(iim);
    who.sigma_3 = 'Upward Turbulence Standard Deviation, in [m/s].';  
    s.sigma_3(iim) = 0.5*s.sigma_1(iim);


    % Organizing output results     
    Wind_IEC614001_1.WindProfile_grid = s.WindProfile_grid; Wind_IEC614001_1.WindProfileGrid_WindContidions = s.WindProfileGrid_WindContidions;
    Wind_IEC614001_1.IntensTurbul_WindContidions = s.IntensTurbul_WindContidions; Wind_IEC614001_1.sigma_WindContidions = s.sigma_WindContidions;
    Wind_IEC614001_1.IntensTurbul_IEC = s.IntensTurbul_IEC; Wind_IEC614001_1.sigma_1 = s.sigma_1; Wind_IEC614001_1.sigma_2 = s.sigma_2; Wind_IEC614001_1.sigma_3 = s.sigma_3; Wind_IEC614001_1.WindProfile_grid = s.WindProfile_grid;
    Wind_IEC614001_1.sigmaWindTurbineClass = s.sigmaWindTurbineClass; Wind_IEC614001_1.IntensTurbul_WindTurbineClass = s.IntensTurbul_WindTurbineClass; Wind_IEC614001_1.sigma_mean_kaimal = s.sigma_mean_kaimal; Wind_IEC614001_1.sigma_sig_kaimal = s.sigma_sig_kaimal; Wind_IEC614001_1.sigma_90_kaimal = s.sigma_90_kaimal;        


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);



%=============================================================
elseif strcmp(action, 'logical_instance_07') 
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================
    % VEERS METHOD: TURBULENT WIND MODEL (OFFLINE):
    % Purpose of this Logical Instance: generate the short-term component
    % of the wind speed (Vt, Turbulent Wind Speed), based on the Kaimal 
    % Spectrum of the horizontal wind speed at the height of the rotor hub,
    % using the parameters calculated according to the IEC 61400-1 standard.
    % Obtain the time series of the wind fields at each point of a 2D Grid 
    % and for a line parallel to the tower.
    %
    % ## Theoretical References used in this logical instance:
    % # Title: "4D wind field generation for the aeroelastic simulation of wind
    % turbines with lidars" by Yiyin Chen, Feng Guo, David Schlipf, and Po
    % Wen Cheng1. See section 2.1 and annex A.
    % # Title: PEF (2025). "3D Turbulent Wind Generation, MATLAB Central File Exchange.
    % Retrieved January 14, 2025. Page: https://www.mathworks.com/matlabcentral/fileexchange/54491-3d-turbulent-wind-generation
    % # Title: "TurbSim User´s Guide by B.J. Jonkman and M.L. Buhl Jr. NREL-2006.  
    % # Title: "Wind field simulation" by Jakob Mann (1998).  
    % # Title: "Spectral characteristics of surface-layer turbulence" by 
    % J.C Kaimal, J.C Wyngaard, Y. Izumi and O.R. Coté. 1972.  
    % Title: IEC 61400-1: Wind energy generation systems - Part 1: Design
    % requirements. Edition 2019-02. International Electrotechnical Commission (IEC).


    % ---------- Wind Conditions for Turbulent Wind Model ---------- 
    who.sigma_x = 'Standard Deviation of Longitudinal Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x N_fp).';
    s.sigma_x = s.Npsd_vm; 
    who.var_x = 'Variance of Longitudinal Turbulent Wind Speed ​​at Hub Height, in [m^2/sm^2]. The dimension of this vector is (1 x N_fp).';
    s.var_x = s.Npsd_vm;
    who.sigma_y = 'Standard Deviation of Lateral Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x N_fp).';
    s.sigma_y = s.Npsd_vm;
    who.var_y = 'Variance of Lateral Turbulent Wind Speed ​​at Hub Height, in [m^2/sm^2]. The dimension of this vector is (1 x N_fp).';            
    s.var_y = s.Npsd_vm;
    who.sigma_z = 'Standard Deviation of Upward Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x N_fp).';
    s.sigma_z = s.Npsd_vm;
    who.var_z = 'Variance of Upward Turbulent Wind Speed ​​at Hub Height, in [m^2/sm^2]. The dimension of this vector is (1 x N_fp).';
    s.var_z = s.Npsd_vm;                  
    who.L1_x = 'Length Longitudinal Turbulent Scale ​​at Hub Height, in [m]. The dimension of this vector is (1 x N_fp).';
    s.L1_x = s.Npsd_vm;
    who.L2_y = 'Length Lateral Turbulent Scale ​​at Hub Height, in [m]. The dimension of this vector is (1 x N_fp).';
    s.L2_y = s.Npsd_vm;
    who.L3_z = 'Length Upward Turbulent Scale ​​at Hub Height, in [m]. The dimension of this vector is (1 x N_fp).';
    s.L3_z = s.Npsd_vm;
    who.Lcc = 'Coherence Length Scale, in [m]. The dimension of this vector is (1 x N_fp).';
    s.Lcc = s.Npsd_vm;
    who.Vws_AverageHub = 'Average Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x N_fp).';
    s.Vws_AverageHub = s.Npsd_vm;

    who.sigmaSF1 = 'Standard Deviation of Longitudinal Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x Nws).';
    s.sigmaSF1 = s.Nfft_vm;
    who.sigmaSF2 = 'Standard Deviation of Lateral Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x Nws).'; 
    s.sigmaSF2 = s.Nfft_vm;
    who.sigmaSF3 = 'Standard Deviation of Upward Turbulent Wind Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x Nws).'; 
    s.sigmaSF3 = s.Nfft_vm;
    who.Vws_averageHub = 'Average Speed ​​at Hub Height, in [m/s]. The dimension of this vector is (1 x Nws).';
    s.Vws_averageHub = s.Nfft_vm; 
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm; 
    
    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.var_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = (s.sigma_1(iit)^2)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.var_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = (s.sigma_2(iit)^2)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.var_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = (s.sigma_3(iit)^2)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                  
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));

        s.sigmaSF1(s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigma_1(iit)*s.Nfft_vm(s.idxFFT_0(iit):s.idxFFT_f(iit));
        s.sigmaSF2(s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigma_2(iit)*s.Nfft_vm(s.idxFFT_0(iit):s.idxFFT_f(iit));
        s.sigmaSF3(s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigma_3(iit)*s.Nfft_vm(s.idxFFT_0(iit):s.idxFFT_f(iit));

        s.Vws_averageHub(s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Vm(iit)*s.Nfft_vm(s.idxFFT_0(iit):s.idxFFT_f(iit));    
        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));        
        %
    end


    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));
    who.S2 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Lateral Velocity Component (Sy), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S2 = ((4.*s.sigma_y.^2.*(s.L2_y./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L2_y./s.Vws_AverageHub)) ).^(5/3)));  
    who.S3 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Upward Velocity Component (Sy), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S3 = ((4.*s.sigma_z.^2.*(s.L3_z./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L3_z./s.Vws_AverageHub)) ).^(5/3)));
    

    % ------- Two-Sided Fourier Coefficient or Amplitude Spectrum of the Velocity Components ----------   
    who.AAu = 'Two-Sided Fourier Coefficient or Amplitude Spectrum of the Longitudinal Velocity Component, in [m/s]. The dimension of this vector is (1 x N_fp) for each value of Vm.';
    s.AAu = sqrt(s.S1*s.Nws*s.SampleF_Wind);          
    who.AAv = 'Two-Sided Fourier Coefficient or Amplitude Spectrum of the Lateral Velocity Component, in [m/s]. The dimension of this vector is (1 x N_fp) for each value of Vm.';
    s.AAv = sqrt(s.S2*s.Nws*s.SampleF_Wind); 
    who.AAw = 'Two-Sided Fourier Coefficient or Amplitude Spectrum of the Vertical Velocity Component, in [m/s]. The dimension of this vector is (1 x N_fp) for each value of Vm.';  
    s.AAw = sqrt(s.S3*s.Nws*s.SampleF_Wind);  


    % ---------- Calculation of FFT Terms ----------   
    who.XXu = 'Longitudinal Random phases which are uniformly distributed between 0 and 2*pi, in [-]. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    XXu = exp(1i*2*pi*rand(s.Nt,numel(s.fp))); 
    who.XXv = 'Lateral Random phases which are uniformly distributed between 0 and 2*pi, in [-]. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    XXv = exp(1i*2*pi*rand(s.Nt,numel(s.fp)));
    who.XXw = 'Upward Random phases which are uniformly distributed between 0 and 2*pi, in [-]. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    XXw = exp(1i*2*pi*rand(s.Nt,numel(s.fp))); 

    who.Uzy_fft = 'Complex Fourier Coefficients (CFC) vector of the U component for 3D wind fields. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    s.Uzy_fft = zeros(s.Nt,s.Nfp);
    who.Vzy_fft = 'Complex Fourier Coefficients (CFC) vector of the V component for 3D wind fields. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    s.Vzy_fft = zeros(s.Nt,s.Nfp);
    who.Wzy_fft = 'Complex Fourier Coefficients (CFC) vector of the W component for 3D wind fields. The dimension of this vector is (1 x N_fp) for each value of Vm and applied to a single point on the Grid. Applied to all points on the Grid it becomes (N_t x N_fp) for each value of Vm.';
    s.Wzy_fft = zeros(s.Nt,s.Nfp);


    % ---  Exponential Coherence Model: See equation C.16 of Annex C.3 of IEC 61400-1) --- 
    who.CoherenceDecay = 'Coherence decay, in [-].';
    s.CoherenceDecay = 12;     
    who.GamaU_zy = 'Coherence Function Coh(EuclideanDistanceYZ,f) or Gama(r,f) is the coherence funcion defined by the complex magnitude of the cross-spectral density of the longitudinal wind velocity components at two spatially separeted points divided by the autospectrum funcion. In other words, the coherence function mentioned in the IEC 61400-1 standard is used to model the spatial distribution of wind turbulence.';
    s.GamaU_zy = @(idx_chol) exp(-s.CoherenceDecay.*s.EuclideanDistanceYZ.*sqrt( ((s.fp(idx_chol)./s.Vws_AverageHub(idx_chol) ).^2) + ((s.CoherenceDecay./s.Lcc(idx_chol)).^2) ) );  

    % --- Modelling the Spatial Distribution of Wind Turbulence with Exponential Coherence Model ---
    for idx_chol = 1:numel(s.fp)

        % Coherence Matrix using the Coherence Function apply on grid points       
        who.CC_uzy = 'Coherence Matrix. The dimension of this matrix is ​​(Nt x Nt), where Nt = (​​Nyz_grid x Nz_grid).';
        s.CC_uzy = s.GamaU_zy(idx_chol);

        who.Hu_zy = 'Cholesky Factor, which satisfies GamaU_zy square matrix. he dimension of this matrix is ​​(Nt x Nt), where Nt = (​​Nyz_grid x Nz_grid).';
        s.Hu_zy = chol(s.CC_uzy,'lower'); 

        % Complex Fourier Coefficients (CFC) of the components in frequency domain
        s.Uzy_fft(:,idx_chol) = (s.Hu_zy*s.AAu(idx_chol))*XXu(:,idx_chol); 
        s.Vzy_fft(:,idx_chol) = (s.Hu_zy*s.AAv(idx_chol))*XXv(:,idx_chol); 
        s.Wzy_fft(:,idx_chol) = (s.Hu_zy*s.AAw(idx_chol))*XXw(:,idx_chol); 
    end


    % ---------- Mirror Fourier Transform Coefficients/Terms for Each Time Series ----------
    who.MidpointFFT = 'Nyquist Component Point or midpoint of the Fourier transform series for each block (associated with each Vm).';
    s.MidpointFFT = 0.5*s.Nws + 1;   % s.idxFFT_Midpoint;      
    who.FFT_U = 'Fourier Transform Coefficients of the Longitudinal Component Mirrored About the Frequency Axis.';    
    s.FFT_U = [zeros(s.Nt,1) s.Uzy_fft fliplr(conj(s.Uzy_fft(:, 1:end-1)))];
    who.FFT_V = 'Fourier Transform Coefficients of the Lateral Component Mirrored About the Frequency Axis.';    
    s.FFT_V = [zeros(s.Nt,1) s.Vzy_fft fliplr(conj(s.Vzy_fft(:, 1:end-1)))];
    who.FFT_W = 'Fourier Transform Coefficients of the Upward Component Mirrored About the Frequency Axis.';    
    s.FFT_W = [zeros(s.Nt,1) s.Wzy_fft fliplr(conj(s.Wzy_fft(:, 1:end-1)))];
    s.FFT_U(:,s.MidpointFFT) = real(s.FFT_U(:,s.MidpointFFT));
    s.FFT_V(:,s.MidpointFFT) = real(s.FFT_V(:,s.MidpointFFT));
    s.FFT_W(:,s.MidpointFFT) = real(s.FFT_W(:,s.MidpointFFT));  


    % ---- Generate Time Series (IFFT - Inverse Fourier Transform) ----
    who.Ucomp = 'Longitudinal Component Time Series, in [unit in SI].';
    s.Ucomp = real(ifft(s.FFT_U, [], 2, 'symmetric'));
    who.Vcomp = 'Lateral Component Time Series, in [unit in SI].';
    s.Vcomp = real(ifft(s.FFT_V, [], 2, 'symmetric'));
    who.Wcomp = 'Upward Component Time Series, in [unit in SI].';
    s.Wcomp = real(ifft(s.FFT_W, [], 2, 'symmetric'));   


    % --- Calculating Standard Deviation and Mean with a 10-minute window for all Grid points --- 
    who.stdU = 'Standard Deviation of the Longitudinal Components for each grid point, in [m/s].';
    s.stdU = zeros(s.Nt, s.N_Vm);    
    who.stdV = 'Standard Deviation of the Lateral Components for each grid point, in [m/s].';
    s.stdV = zeros(s.Nt, s.N_Vm);    
    who.stdW = 'Standard Deviation of the Upward Components for each grid point, in [m/s].';
    s.stdW = zeros(s.Nt, s.N_Vm);   

    who.meanU = 'Mean of the Longitudinal Components for each grid point, in [m/s].';
    s.meanUU = zeros(s.Nt, s.N_Vm);
    s.meanU = zeros(s.Nt, s.N_Vm);    
    who.meanV = 'Mean of the Lateral Components for each grid point, in [m/s].';
    s.meanV = zeros(s.Nt, s.N_Vm);
    s.meanV = zeros(s.Nt, s.N_Vm);    
    who.meanW = 'Mean of the Upward Components for each grid point, in [m/s].';
    s.meanWW = zeros(s.Nt, s.N_Vm);    
    s.meanW = zeros(s.Nt, s.N_Vm);  

    for iit = 1:s.N_Vm   
        % Calculate standard deviation of the obtained signal with high precision
        s.stdU(:, iit) = std( s.Ucomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 0, 2);
        s.stdV(:, iit) = std( s.Vcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 0, 2);
        s.stdW(:, iit) = std( s.Wcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 0, 2);   

        % Calculate average of the obtained signal
        s.meanUU(:, iit) = mean( s.Ucomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);
        s.meanVV(:, iit) = mean( s.Vcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);
        s.meanWW(:, iit) = mean( s.Wcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);

        % Normalizing to Zero Mean for all grid points
        s.Ucomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Ucomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.meanUU(:, iit);
        s.Vcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Vcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.meanVV(:, iit);
        s.Wcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Wcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.meanWW(:, iit);     

        s.meanU(:, iit) = mean( s.Ucomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);
        s.meanV(:, iit) = mean( s.Vcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);
        s.meanW(:, iit) = mean( s.Wcomp(:, s.idxFFT_0(iit):s.idxFFT_f(iit)) , 2);    
        %
    end

    % ---- Normalizing Turbulence Standard Deviation for all grid points ----  
    who.SF_1 = 'Normalized Longitudinal Turbulence Standard Deviation, in [m/s]. The dimension of this vector is (1 x Nws).';
    s.SF_1 = zeros(1,s.Nws); 
    who.SF_2 = 'Normalized Lateral Turbulence Standard Deviation, in [m/s]. The dimension of this vector is (1 x Nws).';
    s.SF_2 = zeros(1,s.Nws); 
    who.SF_3 = 'Normalized Upward Turbulence Standard Deviation, in [m/s]. The dimension of this vector is (1 x Nws).';
    s.SF_3 = zeros(1,s.Nws);     
    who.Vt_u = 'Longitudinal Turbulent Component (normalized), in the time domain and in [m/s]. The dimension of this vector is (Nt x Nws).';   
    s.Vt_u = zeros(s.Nt,max(s.idxFFT_f));
    who.Vt_v = 'Lateral Turbulent Component (normalized), in the time domain and in [m/s]. The dimension of this vector is (Nt x Nws).';
    s.Vt_v = zeros(s.Nt,max(s.idxFFT_f));
    who.Vt_w = 'Upward Turbulent Component (normalized), in the time domain and in [m/s]. The dimension of this vector is (Nt x Nws).';
    s.Vt_w = zeros(s.Nt,max(s.idxFFT_f));

        % NOTE: Normalization is an important process to ensure that wind 
        % turbulence is within expected limits and that consistency between
        % points is maintained. Thus, normalization is adjusting the time 
        % series to ensure that the standard deviation conforms to the 
        % expected value.

    for iit = 1:(s.N_Vm)  
        % Normalizing Turbulence Standard Deviation
        s.SF_1(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigmaSF1(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) ./ s.stdU(s.idxsV_hub, iit); 
        s.SF_2(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigmaSF2(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) ./ s.stdV(s.idxsV_hub, iit); 
        s.SF_3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.sigmaSF3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) ./ s.stdW(s.idxsV_hub, iit);  
        
        % Time Series 3D of Longitudinal, Lateral and Upward components
        s.Vt_u(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Ucomp(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) .* s.SF_1(:,s.idxFFT_0(iit):s.idxFFT_f(iit));
        s.Vt_v(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Vcomp(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) .* s.SF_2(:,s.idxFFT_0(iit):s.idxFFT_f(iit));
        s.Vt_w(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Wcomp(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) .* s.SF_3(:,s.idxFFT_0(iit):s.idxFFT_f(iit));    
    end


    % --- Recalculating Standard Deviation and Mean with a 10-minute window for all Grid points --- 
    who.stdVt_u = 'Standard Deviation of the Longitudinal Components for each grid point, in [m/s].';
    s.stdVt_u = zeros(s.Nt,s.N_Vm);
    who.stdVt_v = 'Standard Deviation of the Lateral Components for each grid point, in [m/s].';
    s.stdVt_v = zeros(s.Nt,s.N_Vm);
    who.stdVt_w = 'Standard Deviation of the Upward Components for each grid point, in [m/s].';
    s.stdVt_w = zeros(s.Nt,s.N_Vm);    
    who.meanVt_u = 'Mean of the Longitudinal Components for each grid point, in [m/s].';
    s.meanVt_u = zeros(s.Nt,s.N_Vm);
    who.meanVt_v = 'Mean of the Lateral Components for each grid point, in [m/s].';
    s.meanVt_v = zeros(s.Nt,s.N_Vm);
    who.meandVt_w = 'Mean of the Upward Components for each grid point, in [m/s].';
    s.meanVt_w = zeros(s.Nt,s.N_Vm);            
    for iit = 1:s.N_Vm   
        s.stdVt_u(:,iit) = std(s.Vt_u(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
        s.stdVt_v(:,iit) = std(s.Vt_v(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
        s.stdVt_w(:,iit) = std(s.Vt_w(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
        s.meanVt_u(:,iit) = mean(s.Vt_u(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),2);
        s.meanVt_v(:,iit) = mean(s.Vt_v(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),2);
        s.meanVt_w(:,iit) = mean(s.Vt_w(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),2);             
    end   
   

    % ---------- FREQUENCY DOMAIN SIGNALS OF TURBULENT VELOCITY COMPONENT ----------
    who.Vt_u = 'Longitudinal Turbulent Component (normalized), in the frequency domain.';    
    s.Vt_u_p = fft(s.Vt_u,s.Nfp,2);
    who.Vt_v = 'Lateral Turbulent Component (normalized), in the frequency domain.';
    s.Vt_v_p = fft(s.Vt_v,s.Nfp,2);
    who.Vt_w = 'Upward Turbulent Component (normalized), in the frequency domain.';
    s.Vt_w_p = fft(s.Vt_w,s.Nfp,2);


    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,3); 
    s.WindField_Grid(:,:,1) = s.Vt_u + s.Vm_Ugrid;   
    s.WindField_Grid(:,:,2) = s.Vt_v + s.Vm_Ugrid;
    s.WindField_Grid(:,:,3) = s.Vt_w + s.Vm_Ugrid;
    who.WindField_Grid_p = 'Actual Wind Field circumscribed in the rotor Disk, in frequency domain.';
    s.WindField_Grid_p = []; 
    s.WindField_Grid_p(:,:,1) = fft( s.WindField_Grid(:,:,1) , s.Nfp, 2);
    s.WindField_Grid_p(:,:,2) = fft( s.WindField_Grid(:,:,2) , s.Nfp, 2);
    s.WindField_Grid_p(:,:,3) = fft( s.WindField_Grid(:,:,3) , s.Nfp, 2);

    who.fpwGrid_u = 'Estimated positive frequency of the wind field at fixed grid points.';
    s.fpwGrid_u = zeros(s.Nt,s.Nfp+1);
    who.PSDpwGrid_u = 'Estimated Power Spectrum Density (PSD) of the wind field at fixed grid points.';
    s.PSDpwGrid_u = zeros(s.Nt,s.Nfp+1);
    for iit = 1:s.Nt
        [PSDpwGrid_u, fpwGrid_u] = pwelch( s.WindField_Grid(iit,:,1), [], [], s.Nws, s.SampleF_Wind);
        s.PSDpwGrid_u(iit,:) = PSDpwGrid_u';
        s.fpwGrid_u(iit,:) = fpwGrid_u';
    end


     % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and without interaction with the wind turbine, in time domain and  in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3); 
    who.WindField_Disk_p = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and without interaction with the wind turbine, in frequency domain.';
    s.WindField_Disk_p = []; 
    s.WindField_Disk_p(:,:,1) = fft( s.WindField_Disk(:,:,1) , s.Nfp, 2);
    s.WindField_Disk_p(:,:,2) = fft( s.WindField_Disk(:,:,2) , s.Nfp, 2);
    s.WindField_Disk_p(:,:,3) = fft( s.WindField_Disk(:,:,3) , s.Nfp, 2);   


    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1); % s.WindField_Disk(s.idxsV_DiskHub,:,1);  

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2);
    [s.PSDpw_WSHub, s.fpw_WSHub] = pwelch(s.WindSpeed_Hub, [], [], s.Nws, s.SampleF_Wind);

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);  

 
    
    % Organizing output results 
    Wind_IEC614001_1.Alfa_WindShear = s.Alfa_WindShear; Wind_IEC614001_1.fpp = s.fp; Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.var_x = s.var_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.var_y = s.var_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.var_z = s.var_z;
    Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; Wind_IEC614001_1.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub;       
    Wind_IEC614001_1.sigmaSF1 = s.sigmaSF1; Wind_IEC614001_1.sigmaSF2 = s.sigmaSF2; Wind_IEC614001_1.sigmaSF3 = s.sigmaSF3; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; 
    Wind_IEC614001_1.S1 = s.S1; Wind_IEC614001_1.S2 = s.S2; Wind_IEC614001_1.S3 = s.S3;
    Wind_IEC614001_1.Sx = s.AAu; Wind_IEC614001_1.Sy = s.AAv; Wind_IEC614001_1.Sz = s.AAw;
    Wind_IEC614001_1.Uzy_fft = s.Uzy_fft; Wind_IEC614001_1.Vzy_fft = s.Vzy_fft; Wind_IEC614001_1.Wzy_fft = s.Wzy_fft; Wind_IEC614001_1.CoherenceDecay = s.CoherenceDecay; Wind_IEC614001_1.CC_uzy = s.CC_uzy;
    Wind_IEC614001_1.FFT_U = s.FFT_U; Wind_IEC614001_1.FFT_V = s.FFT_V; Wind_IEC614001_1.FFT_W = s.FFT_W;
    Wind_IEC614001_1.Ucomp = s.Ucomp; Wind_IEC614001_1.Vcomp = s.Vcomp; Wind_IEC614001_1.Wcomp = s.Wcomp;
    Wind_IEC614001_1.stdU = s.stdU; Wind_IEC614001_1.stdV = s.stdV; Wind_IEC614001_1.stdW = s.stdW; Wind_IEC614001_1.meanU = s.meanU; Wind_IEC614001_1.meanV = s.meanV; Wind_IEC614001_1.meanW = s.meanW; 
    Wind_IEC614001_1.stdVt_u = s.stdVt_u; Wind_IEC614001_1.stdVt_v = s.stdVt_v; Wind_IEC614001_1.stdVt_w = s.stdVt_w; Wind_IEC614001_1.meanVt_u = s.meanVt_u; Wind_IEC614001_1.meanVt_v = s.meanVt_v; Wind_IEC614001_1.meanVt_w = s.meanVt_w; 
    Wind_IEC614001_1.SF_1 = s.SF_1; Wind_IEC614001_1.SF_2 = s.SF_2; Wind_IEC614001_1.SF_3 = s.SF_3;

    Wind_IEC614001_1.Vt_u = s.Vt_u; Wind_IEC614001_1.Vt_v = s.Vt_v; Wind_IEC614001_1.Vt_w = s.Vt_w; Wind_IEC614001_1.Vt_u_p = s.Vt_u_p; Wind_IEC614001_1.Vt_v_p = s.Vt_v_p; Wind_IEC614001_1.Vt_w_p = s.Vt_w_p;
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.WindField_Grid_p = s.WindField_Grid_p;    
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk; Wind_IEC614001_1.WindField_Disk_p = s.WindField_Disk_p;     
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub;
   


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option03f1 == 2
        System_WindFieldIEC614001_1('logical_instance_08'); 
    end   
     


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================
    % EFFECTIVE WIND SPEED MODEL (OFFLINE):
    % Purpose of this Logical Instance: calculate the effective wind speed
    % from the simple and/or weighted average of the generated wind field.
    % The weighted average is calculated based on the blade tip loss, as
    % proposed by Soltani et al. (2013). The simple average is the standard
    % method generally adopted, for example as done by Held et al. (2018).
    % There are other ways to generate the effective wind speed, such as 
    % the approach taken by Bianchi (2002) and Gavriluta (2012), through 
    % combinations of spatial filters and amplifiers (transfer functions)
    % developed in Logical Instance 09.
    %
    % ## Theoretical References used in this logical instance:

    % # Title: "Complete methodology on generating realistic wind speed profiles
    % based on measurements." by C. Gavriluta, S. Spataru,  I. Mosincat, 
    % C. Citro, I. Candela, P. Rodriguez. 2012.       
    % # Title: "Wind Turbine Control Systems" by Fernando D. Bianchi, Hernán 
    % De Battista and Ricardo J. Mantz. Section 3.7.3. 2006.    
    % # Title: "Modeling of Wind Turbines for Power System Studies" by 
    % Tomas Gavriluta and Torbjörn Thiringer, (2002).

    % # Title: "Nonlinear model predictive control of wind turbines using 
    % LIDAR" by David Schlipf, Dominik Johannes Schlipf and Martin Kühn
    % (2012).
    % # Title: "Estimation of Rotor Effective Wind Speed: A Comparison" by
    % Mohsen Nourbakhsh Soltani, Torben Knudsen, Mikael Svenstrup, Rafael
    % Wisniewski, Per Brath, Romeo Ortega, Fellow, IEEE, and Kathryn
    % Johnson. 2013

    % # Title: "Wind turbine rotor-effective wind speed estimated by 
    % nacelle-mounted Doppler wind lidars" by Held, Dominique Philipp;
    % Mann, Jakob. 2018



     % ##############################################################
                     % ##### WIND SHEAR EFFECT #####  

     % NOTE! The turbulent wind field generated in the "s.WindField_Grid" 
     % Grid and consequently distributed in the Rotor Disk "s.WindFieldDisk",
     % has already considered a Wind Profile with Wind Shear, according to 
     % the IEC 61400-1 Standard, through the calculations of "s.Vm_Ugrid"
     % and "s.WindProfile_grid". Therefore, this signal already contains 
     % the Wind Shear effect at each point of the grid and disk.


    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


     % ##############################################################
                     % ##### TOWER SHADOW EFFECT #####  

      % See equations (3.18), (3.19) and (3.20) of the paper "Dynamic Influences
      % of Wind Power on The Power System" by Rosas, Pedro Andrè Carvalho.

    % ---------------- Add Tower Shadow effect --------------------   
    if s.Option04f6 == 1
        % ADD TOWER SHADONW effect to Effective Wind Speed Model

        for iit = 1:length(s.idxsV_Disk)            
            who.Uh  = 'Longitudinal Wind Speed ​​without wind turbine interaction or Ambient wind speed, in [m/s].';            
            s.Uh = s.WindField_Grid(s.idxsV_Disk(iit),:,1);           

            idxs = find( s.indexTowerShadow == s.idxsV_Disk(iit), 1 );
            if ~isempty(idxs)
                % From the Ground to the Center of the Disk (Lower Half-Plane of the Disk)
                       % For 0 <= rotor azimuth position angle < pi
                who.DiameterTowerAdopted = 'Tower diameter adopted, in [m].';
                s.DiameterTowerAdopted = mean(s.DistributionDiameterTower) .* ones(1, length(s.Uh) ) ; % Assumption: considering the tower as a cylinder, with a mean diameter.
                who.Dts_ws_x = 'Distance from the tower centre to the blade section, in longidutinal direction (X) and in [m].';                   
                s.Dts_ws_x = ( s.DxHubTower - 0.5*s.DiameterTowerTop) + 0.5*s.DiameterTowerAdopted;     
                who.Dts_ws_y = 'Distance from the tower centre to the blade section, in lateral direction (Y) and in [m].';    
                s.Dts_ws_y = abs( s.Y_GridV(s.indexTowerShadow(idxs)) ) .* ones(1, length(s.Uh) ) ;                 
                who.Dts_ws = 'Distance from the tower centre to the blade section, in [m].';    
                s.Dts_ws = sqrt( s.Dts_ws_x.^2 + s.Dts_ws_y.^2 ) ;

                s.RatioDist = ( (0.5*s.DiameterTowerAdopted).^2 ./ s.Dts_ws.^2 );

                who.WS_SimpleSpatialAverage = 'Effective Wind Speed, calculated from the simple average of the wind field, according to Held (2018/2019), in time domain and in [m/s].';
                s.WS_SimpleSpatialAverage = mean(s.WindField_Grid_WT(:,:,1), 1);                 
                who.Beta_opWs = 'Collective Blade Pitch desired by the controller, in [deg].';
                s.Beta_opWs = min( max( interp1(s.Vop, s.Beta_op, s.WS_SimpleSpatialAverage ), min(s.Beta_op) ) , max(s.Beta_op) );

                who.Uh_ws  = 'Longitudinal Wind Flow Speed, in [m/s].';                
                s.Uh_ws = s.Uh .* ( 1 - (s.RatioDist .* cos( 2 .* s.Beta_opWs .* (pi ./ 180) )) ) ;               
                who.Vh_ws  = 'Lateral Wind Flow Speed, in [m/s].';            
                s.Vh_ws = s.Uh .* s.RatioDist .* sin( 2 .* s.Beta_opWs .* (pi ./ 180) ) ;                   
            else
                % Above the Center of the Disk (Upper Half-Plane of the Disk)
                         % For pi <= rotor azimuth position angle <= 2pi
                who.Uhx  = 'Longitudinal Wind Flow Speed, in [m/s].';            
                s.Uhx = s.Uh;
                who.Uhy  = 'Lateral Wind Flow Speed, in [m/s].';            
                s.Uhy = s.WindField_Grid(s.idxsV_Disk(iit),:,2);
            end           
            
            % Updating the Wind Field Disk
            who.WindField_Disk_WT = 'Wind Speed ​​interacting with the wind turbine with Tower Shadow effect, in [m/s].';
            s.WindField_Grid_WT(s.idxsV_Disk(iit),:,1) = s.Uhx;
            s.WindField_Grid_WT(s.idxsV_Disk(iit),:,2) = s.Uhy;
        end
        Wind_IEC614001_1.DiameterTowerAdopted =  s.DiameterTowerAdopted; Wind_IEC614001_1.Dts_ws_x = s.Dts_ws_x; Wind_IEC614001_1.Dts_ws_y = s.Dts_ws_y; Wind_IEC614001_1.Dts_ws = s.Dts_ws;        
    end   


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3);     

    who.WindField_Disk_WT_p = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and without interaction with the wind turbine, in frequency domain.';
    s.WindField_Disk_WT_p = []; 
    s.WindField_Disk_WT_p(:,:,1) = fft( s.WindField_Disk_WT(:,:,1) , s.Nfp, 2);
    s.WindField_Disk_WT_p(:,:,2) = fft( s.WindField_Disk_WT(:,:,2) , s.Nfp, 2);
    s.WindField_Disk_WT_p(:,:,3) = fft( s.WindField_Disk_WT(:,:,3) , s.Nfp, 2); 


     % ##############################################################
                    % ##### SPATIAL EFFECT #####  

    % ----- Standart Method: Effective Wind Speed ​​(Uews) calculated from the Simple Average ----------    
    who.Uews_sp1 = 'Effective Wind Speed, calculated from the simple average of the wind field, according to Held (2018/2019), in time domain and in [m/s].';
    s.Uews_sp1 = sum( s.WindField_Disk_WT(:,:,1) ,1) ./ s.Length_Disk; % OR mean(s.WindField_Disk(:,:,1), 1);
    who.Uews_sp1_p = 'Effective Wind Speed, calculated from the simple average of the wind field, according to Held (2018/2019), in frequency domain.';
    s.Uews_sp1_p = fft(s.Uews_sp1, s.Nfp, 2);
 
    who.fppwUews_sp1 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect (simple average of the wind field).';
    who.PSDpwUews_sp1 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect (simple average of the wind field).';
    [s.PSDpwUews_sp1, s.fppwUews_sp1] = pwelch( s.Uews_sp1, [], [], s.Nws, s.SampleF_Wind);

    who.Vt_Uews_sp1 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
    s.Vt_Uews_sp1 = zeros(1,s.Nws);
    who.Vm_Uews_sp1 = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
    s.Vm_Uews_sp1 = zeros(1,s.Nws);
    who.std_Uews_sp1 = 'Standard Deviation of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
    s.std_Uews_sp1 = zeros(1,s.N_Vm); 
    who.mean_Uews_sp1 = 'Mean of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
    s.mean_Uews_sp1 = zeros(1,s.N_Vm);
    for iit = 1:s.N_Vm   
        s.std_Uews_sp1(iit) = std(s.Uews_sp1(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
        s.mean_Uews_sp1(iit) = mean(s.Uews_sp1(:,s.idxFFT_0(iit):s.idxFFT_f(iit)), 2);
        s.Vm_Uews_sp1(1, s.idxFFT_0(iit):s.idxFFT_f(iit)) = repmat(s.mean_Uews_sp1(iit), 1, s.idxFFT_f(iit) - s.idxFFT_0(iit) + 1);
        s.Vt_Uews_sp1(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Uews_sp1(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.Vm_Uews_sp1(1, s.idxFFT_0(iit):s.idxFFT_f(iit));
    end   

    who.Vt_Uews_sp1_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';
    s.Vt_Uews_sp1_p = fft(s.Vt_Uews_sp1, s.Nfp, 2); 
    who.Vm_Uews_sp1_p = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';   
    s.Vm_Uews_sp1_p = fft(s.Vm_Uews_sp1, s.Nfp, 2);    


    
    % ---------- Effective Wind Speed ​​(Uews) calculated from the Weighted Average ---------- 
    if s.Option05f6 == 2 || s.Option05f6 == 4
        who.RCp_Dr = 'Span-wise Variation of Power Extraction R*(dCp/dr). Partial derivative of Cp with respect to the radius differential.';
        Wind_IEC614001_1.RCp_Dr = s.RCp_Dr;       
        s.SpanWiseVariation = zeros(s.Nws,s.Nz_grid,s.Ny_grid);
        who.Rrd_local = 'Local Radius of each Blade Element (r), in [m].';
        Wind_IEC614001_1.Rrd_local = s.Rrd_local; 
        who.Vws = 'Upstream Wind Speed, in [m/s]. Discretized for implementation in BEM Theory.';
        Wind_IEC614001_1.Vws = s.Vws;
        delta_r = (s.Rrd - 0)/(s.Length_Disk); 
        delta_theta = (2*pi - 0)/(s.Length_Disk); 
        WindField_Ddisk = s.WindField_Disk_WT(:,:,1);

        % ----------- Spanwise Variation -----------
        WindField_Ddisk(WindField_Ddisk < s.Vws_CutIn) = 0; % This value ​​is only to select the zero value in RCp_Dr, in the interpolation.
        WindField_Ddisk(WindField_Ddisk > s.Vws_CutOut) = 100; % This value ​​is only to select the zero value in RCp_Dr, in the interpolation.
        U_long_cubic = WindField_Ddisk.^3;

        s.SpanWiseVariation = zeros(s.Length_Disk,s.Nws);
        s.Numerator_WeightedAver = zeros(s.Length_Disk,s.Nws);
        s.Denominator_WeightedAver = zeros(s.Length_Disk,s.Nws);
        for iit = 1:s.Length_Disk
            s.SpanWiseVariation(iit,:) = interp2(s.Vws, s.Rrd_local, s.RCp_Dr', WindField_Ddisk(iit,:), s.LocalRadiusDisk_Vpolar(iit) .* ones(1, s.Nws));            
            s.Numerator_WeightedAver(iit,:) = U_long_cubic(iit,:).*s.SpanWiseVariation(iit,:)*s.LocalRadiusDisk_Vpolar(iit)*delta_r*delta_theta; % Term of the integral of the Numerator.
            s.Denominator_WeightedAver(iit,:) = s.SpanWiseVariation(iit,:).*s.LocalRadiusDisk_Vpolar(iit)*delta_r*delta_theta; % Term of the integral of the Denominato
        end
        s.Total_Numerator = sum(s.Numerator_WeightedAver(:,:),1);
        s.Total_Denominator = sum(s.Denominator_WeightedAver(:,:),1);  

        who.Uews_sp2 = 'Effective Wind Speed, calculated from the weighted average of the wind field, according to Schlipf (2018/2019), in time domain and in [m/s].';
        s.Uews_sp2 = ( (s.Total_Numerator./s.Total_Denominator).^(1/3) ); 

        who.Uews_sp2_p = 'Effective Wind Speed, calculated from the weighted average of the wind field, according to Schlipf (2018/2019), in frequency domain.';
        s.Uews_sp2_p = fft(s.Uews_sp2, s.Nfp, 2);

        who.fppwUews_sp2 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect (weighted average of the wind field).';
        who.PSDpwUews_sp2 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect (weighted average of the wind field).';
        [s.PSDpwUews_sp2, s.fppwUews_sp2] = pwelch( s.Uews_sp2, [], [], s.Nws, s.SampleF_Wind);

        who.Vt_Uews_sp2 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Weighted Average of the wind field), in time domain and in [m/s].';   
        s.Vt_Uews_sp2 = zeros(1,s.Nws);
        who.Vm_Uews_sp2 = 'Mean Component of Effective Wind Speed ​​with spatial effect (Weighted Average of the wind field), in time domain and in [m/s].';   
        s.Vm_Uews_sp2 = zeros(1,s.Nws);
        who.mean_Uews_sp2 = 'Mean of the Effective Wind Speed, calculated from the weighted average of the wind field, in [m/s].';
        s.mean_Uews_sp2 = zeros(1,s.N_Vm);
         who.std_Uews_sp2= 'Standard Deviation of the Effective Wind Speed, calculated from the weighted average of the wind field, in [m/s].';
         s.std_Uews_sp2 = zeros(1,s.N_Vm); 
         
        for iit = 1:s.N_Vm   
            s.std_Uews_sp2(iit) = std(s.Uews_sp2(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
            s.mean_Uews_sp2(iit) = mean(s.Uews_sp2(:,s.idxFFT_0(iit):s.idxFFT_f(iit)), 2);
            s.Vm_Uews_sp2(1, s.idxFFT_0(iit):s.idxFFT_f(iit)) = repmat(s.mean_Uews_sp2(iit), 1, s.idxFFT_f(iit) - s.idxFFT_0(iit) + 1);
            s.Vt_Uews_sp2(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Uews_sp2(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.Vm_Uews_sp2(1, s.idxFFT_0(iit):s.idxFFT_f(iit));
        end   
        who.Vt_Uews_sp2_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';
        s.Vt_Uews_sp2_p = fft(s.Vt_Uews_sp2, s.Nfp, 2); 
        who.Vm_Uews_sp2_p = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';   
        s.Vm_Uews_sp2_p = fft(s.Vm_Uews_sp2, s.Nfp, 2);    

        % Organizing output results 
        Wind_IEC614001_1.Uews_sp2 = s.Uews_sp2; Wind_IEC614001_1.Uews_sp2_p = s.Uews_sp2_p; Wind_IEC614001_1.PSDpwUews_sp2 = s.PSDpwUews_sp2; Wind_IEC614001_1.fppwUews_sp2 = s.fppwUews_sp2;       
        Wind_IEC614001_1.mean_Uews_sp2 = s.mean_Uews_sp2; Wind_IEC614001_1.std_Uews_sp2 = s.std_Uews_sp2; Wind_IEC614001_1.Vt_Uews_sp2 = s.Vt_Uews_sp2; Wind_IEC614001_1.Vt_Uews_sp2_p = s.Vt_Uews_sp2_p; Wind_IEC614001_1.Vm_Uews_sp2 = s.Vm_Uews_sp2; Wind_IEC614001_1.Vm_Uews_sp2_p = s.Vm_Uews_sp2_p;     
        %
    end



    % ---------- Spatial Filter (Averaging Effect of the Field) ----------
    if s.Option05f6 == 3  || s.Option05f6 == 4

        % Calculating the transfer function as a function of the mean component     
        who.fp_sp3 = 'Discretized Frequencies for Turbulent Wind Speed, in [m/s].'; 
        s.fp_sp3 = s.fp; % s.fp  OR s.fpwGrid_u(s.idxsV_hub,2:end)

        who.OmegaRws_WindSpeed_Hub = 'Rotor speed with dimensão (1 x Nws), in time domain and in [m/s].'; 
        WindSpeed_Hub_tp = interp1(s.Time_ws(1:s.Nws), s.WindSpeed_Hub, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_WindSpeed_Hub = max( min( ((s.Lambda_opt/s.Rrd).*WindSpeed_Hub_tp), (s.OmegaR_Rated * 1.2) ), 0); 
     
        Vt_hub_p = fft( s.Vt_u(s.idxsV_hub,:), s.Nfp, 2); % Vt_hub = WindSpeed_Hub - Vm_hub; % WindSpeed_Hub = Vt_hub + Vm_hub;

        Vm_hub =  interp1(s.Time_ws(1:s.Nws), s.Vm_Ugrid(s.idxsV_hub,:), s.Time_p(1:s.Nfp), 'linear');               
        Vm_hub(Vm_hub == 0) = 1e-10;   
        s.bsf = 0.15*(s.Rrd ./Vm_hub);
        s.asf = 0.55;
        s.fws_Cut = 1 .* s.OmegaRws_WindSpeed_Hub ./ (2*pi);         
        who.Hsf_f = 'Spatial Filter Function (Transfer Function) in the frequency domain.';     
        s_f = 1i .*2 .*pi .*s.fp_sp3;
%         s.Hsf_f = ( sqrt(2) + (s.bsf .* s_f) ) ./ ( (sqrt(2) + (s.bsf .* sqrt(s.asf) .* s_f )) .* (1 + (s.bsf ./ sqrt(s.asf)) .* s_f) );
%         s.Hsf_f = 1 ./ ( s_f .* s.bsf + 1); 
        s.Hsf_f = 1./ ((s_f./2*pi.*s.fws_Cut) + 1);
        

        % Applying the wind speed at the fixed point to the Spatial Filter  
        who.Vt_Uews_sp3_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Spatial Filter or Transfer Function), in frequency domain.';
        s.Vt_Uews_sp3_p = Vt_hub_p.* s.Hsf_f;        

        who.Vt_Uews_sp3 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Spatial Filter or Transfer Function), in time domain and in [m/s].';
        s.MidpointFFT = 0.5 * s.Nws + 1;    
        s.Vt_Uews_sp3_fft = [zeros(1,1) s.Vt_Uews_sp3_p fliplr(conj(s.Vt_Uews_sp3_p))]; 
        s.Vt_Uews_sp3_fft(1,s.MidpointFFT) = real(s.Vt_Uews_sp3_fft(1,s.MidpointFFT));
        s.Vt_Uews_sp3 = real(ifft(s.Vt_Uews_sp3_fft, 'symmetric')); 
        s.Vt_Uews_sp3 = s.Vt_Uews_sp3(1,1:end-1);

        who.Uews_sp3 = 'Effective Wind Speed, calculated from the Spatial Filter or Transfer Function, according to Schlipf (2018/2019), in time domain and in [m/s].';
        s.Uews_sp3 = s.Vt_Uews_sp3 + s.Vm_hub;        
        who.Uews_sp3_p = 'Effective Wind Speed, calculated from the Spatial Filter or Transfer Function, according to Schlipf (2018/2019), in frequency domain.';
        s.Uews_sp3_p = fft(s.Uews_sp3, s.Nfp, 2);

        who.fppwUews_sp3 = 'Estimated Positive Frequency of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
        who.PSDpwUews_sp3 = 'Estimated Power Spectrum Density (PSD) of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
        [s.PSDpwUews_sp3, s.fppwUews_sp3] = pwelch( s.Uews_sp3, [], [], s.Nws, s.SampleF_Wind);


        who.Vt_Uews_sp3 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
        s.Vt_Uews_sp3 = zeros(1,s.Nws);
        who.Vm_Uews_sp3 = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
        s.Vm_Uews_sp3 = zeros(1,s.Nws);
        who.std_Uews_sp3 = 'Standard Deviation of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
        s.std_Uews_sp3 = zeros(1,s.N_Vm); 
        who.mean_Uews_sp3 = 'Mean of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
        s.mean_Uews_sp3 = zeros(1,s.N_Vm);
        for iit = 1:s.N_Vm   
                s.std_Uews_sp3(iit) = std(s.Uews_sp3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
                s.mean_Uews_sp3(iit) = mean(s.Uews_sp3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)), 2);
                s.Vm_Uews_sp3(1, s.idxFFT_0(iit):s.idxFFT_f(iit)) = repmat(s.mean_Uews_sp3(iit), 1, s.idxFFT_f(iit) - s.idxFFT_0(iit) + 1);
                s.Vt_Uews_sp3(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Uews_sp3(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.Vm_Uews_sp3(1, s.idxFFT_0(iit):s.idxFFT_f(iit));
        end   

        who.Vt_Uews_sp3_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';
        s.Vt_Uews_sp3_p = fft(s.Vt_Uews_sp3, s.Nfp, 2); 
        who.Vm_Uews_sp3_p = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';   
        s.Vm_Uews_sp3_p = fft(s.Vm_Uews_sp3, s.Nfp, 2);        


        % Organizing output results 
        Wind_IEC614001_1.bsf = s.bsf; Wind_IEC614001_1.Hsf_f = s.Hsf_f; Wind_IEC614001_1.Ue_sp3 = s.Uews_sp3; Wind_IEC614001_1.Ue_sp3_p = s.Uews_sp3_p; Wind_IEC614001_1.PSDpwUews_sp3 = s.PSDpwUews_sp3; Wind_IEC614001_1.fppwUews_sp3 = s.fppwUews_sp3;      
        Wind_IEC614001_1.std_Uews_sp3 = s.std_Uews_sp3; Wind_IEC614001_1.mean_Uews_sp3 = s.mean_Uews_sp3; Wind_IEC614001_1.Vt_Uews_sp3 = s.Vt_Uews_sp3; Wind_IEC614001_1.Vm_Uews_sp3 = s.Vm_Uews_sp3; Wind_IEC614001_1.Vt_Uews_sp3_p = s.Vt_Uews_sp3_p; Wind_IEC614001_1.Vm_Uews_sp3_p = s.Vm_Uews_sp3_p; 
        %
    end



              
    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----  
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect, in the time domain and in [m/s].';
    who.Uews_sp_p = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect, in the time domain and in [m/s].';
    if s.Option05f6 == 1
        % Simple Average of the Wind Field
        s.Uews_sp = s.Uews_sp1; 
        s.Uews_sp_p = s.Uews_sp1_p; 
    elseif s.Option05f6 == 2
        % Weighted Average of the Wind Field        
        s.Uews_sp = s.Uews_sp2;        
        s.Uews_sp_p = s.Uews_sp2_p;
    elseif s.Option05f6 == 3
        % Transfer Function (spatial filter)
        s.Uews_sp = s.Uews_sp3; 
        s.Uews_sp_p = s.Uews_sp3_p;
    elseif s.Option05f6 == 4

        if s.Option01f2 == 1
            % NREL-5MW baseline wind turbine
            s.Uews_sp = s.Uews_sp2; 
            s.Uews_sp_p = s.Uews_sp2_p;      
        else
            % IEA-15MW or DUT-10MW baseline wind turbine
            s.Uews_sp = s.Uews_sp1; 
            s.Uews_sp_p = s.Uews_sp1_p;

        end % if s.Option01f2 == 1
        %
    end % if s.Option05f6 == 1
    who.fpwUews_sp = 'Estimated Positive Frequency of the Effective Wind Speed ​​with Spatial Effect.';
    who.PSDpwUews_sp = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with Spatial Effect.';
    [s.PSDpwUews_sp, s.fpwUews_sp] = pwelch( s.Uews_sp, [], [], s.Nws, s.SampleF_Wind);


    
     % ##############################################################
                    % ##### ROTATIONAL EFFECT ##### 
            
    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------   
    s.epsonws = 0.01; 
    s.tau_rsws = (s.FNdt_1Pmax - s.FNdt_1Pmin)*0.5 + s.FNdt_1Pmin; % (s.FNdt_1Pmax - s.FNdt_1Pmin)*0.5 + s.FNdt_1Pmin
  
    if s.Option05f6 == 1
                % ##### SPATIAL EFFECT WITH SIMPLE AVERAGE ##### 

        % ---------- Positive Frequency ------------
        who.fpHRSF_sp1 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp1 = s.fppwUews_sp1(2:end)' ; % OR s.fp

        % ---------- Rotor speed  with spatial effect (s.Uews_sp1) ------------
        who.OmegaRws_sp1 = 'Rotor speed, in time domain and in [rad/s].'; 
        Ue_sp1_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp1, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp1 = max( min( ((s.Lambda_opt/s.Rrd).*Ue_sp1_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp1;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp1 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp1 = s.Output_HSF - s.Vm_Uews_sp1;         

        who.InputHRSF_sp1_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp1_p = fft(s.InputHRSF_sp1, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp1 = s.epsonws; 
        s.tau_wssp1 = s.tau_rsws; 

        who.OutputHRSF_sp1_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp1;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp1 + s.epson_wssp1) .* (s_rf - s.N_blades .* s.OmegaRws_sp1 - s.epson_wssp1));
        denominador = ((s_rf + s.tau_wssp1) .^ 2 + (s.N_blades .* s.OmegaRws_sp1) .^ 2);
        s.HRSF_sp1 = numerador ./ denominador;

        s.OutputHRSF_sp1_p = s.InputHRSF_sp1_p .* s.HRSF_sp1;
      
  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp1 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp1 = length(s.OutputHRSF_sp1_p) + 1; 
        s.OutputHRSF_sp1_fft = [s.OutputHRSF_sp1_p fliplr(conj(s.OutputHRSF_sp1_p))]; 
        s.OutputHRSF_sp1_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp1_fft(1,s.MidpointFFT_HRSF_sp1));
        s.OutputHRSF_sp1 = real(ifft(s.OutputHRSF_sp1_fft, 'symmetric'));         

        who.Uews_rt1 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt1 = s.OutputHRSF_sp1  + s.Uews_sp1 ; % s.OutputHRSF_sp1  + s.Vm_Uews_sp1                          

        who.Uews_rt1_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt1_p = fft(s.Uews_rt1, s.Nfp, 2);

        who.fpwUews_rt1 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
        who.PSDwUews_rt1 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
        [s.PSDwUews_rt1, s.fpwUews_rt1] = pwelch( s.Uews_rt1, [], [], s.Nws, s.SampleF_Wind);         


        % ---- Effective Wind Speed ​​signal with spatial and rotational effects ----        
        who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt = s.Uews_rt1; 
        who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt_p = s.Uews_rt1_p; 
        
        % Organizing output results 
        Wind_IEC614001_1.fpHRSF_sp1 = s.fpHRSF_sp1; Wind_IEC614001_1.tau_wssp1 = s.tau_wssp1; Wind_IEC614001_1.epson_wssp1 = s.epson_wssp1; Wind_IEC614001_1.OmegaRws_sp1 = s.OmegaRws_sp1;        
        Wind_IEC614001_1.InputHRSF_sp1 = s.InputHRSF_sp1; Wind_IEC614001_1.InputHRSF_sp1_p = s.InputHRSF_sp1_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp1 = s.OutputHRSF_sp1; Wind_IEC614001_1.OutputHRSF_sp1_p = s.OutputHRSF_sp1_p;
        Wind_IEC614001_1.HRSF_sp1 = s.HRSF_sp1; Wind_IEC614001_1.Uews_rt1 = s.Uews_rt1; Wind_IEC614001_1.Uews_rt1_p= s.Uews_rt1_p; Wind_IEC614001_1.PSDwUews_rt1 = s.PSDwUews_rt1; Wind_IEC614001_1.fpwUews_rt1 = s.fpwUews_rt1;
        %
    elseif s.Option05f6 == 2        
                % ##### SPATIAL EFFECT WITH WEIGHTED AVERAGE ##### 


        % ---------- Positive Frequency ------------
        who.fpHRSF_sp2 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp2 = s.fppwUews_sp2(2:end)';  % s.fppwUews_sp2(2:end)' OR s.fp

        % ---------- Rotor speed  with spatial effect (s.Uews_sp2) ------------
        who.OmegaRws_sp2 = 'Rotor speed, in time domain and in [rad/s].'; 
        Uews_sp2_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp2, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp2 = max( min( ((s.Lambda_opt/s.Rrd).*Uews_sp2_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp2;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp2 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp2 = s.Output_HSF - s.Vm_Uews_sp2;

        who.InputHRSF_sp2_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp2_p = fft(s.InputHRSF_sp2, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp2 = s.epsonws;
        s.tau_wssp2 = s.tau_rsws; 

        who.OutputHRSF_sp2_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp2;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp2 + s.epson_wssp2) .* (s_rf - s.N_blades .* s.OmegaRws_sp2 - s.epson_wssp2));
        denominador = ((s_rf + s.tau_wssp2) .^ 2 + (s.N_blades .* s.OmegaRws_sp2) .^ 2);
        s.HRSF_sp2 = numerador ./ denominador;

        s.OutputHRSF_sp2_p = s.InputHRSF_sp2_p .* s.HRSF_sp2;        

  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp2 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp2 = length(s.OutputHRSF_sp2_p) + 1;
        s.OutputHRSF_sp2_fft = [s.OutputHRSF_sp2_p fliplr(conj(s.OutputHRSF_sp2_p))]; 
        s.OutputHRSF_sp2_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp2_fft(1,s.MidpointFFT_HRSF_sp2));
        s.OutputHRSF_sp2 = real(ifft(s.OutputHRSF_sp2_fft, 'symmetric'));         

        who.Uews_rt2 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt2 = s.OutputHRSF_sp2 + s.Uews_sp2 ; % Instead of s.OutputHRSF_sp2 + s.Vm_Uews_sp2

        who.Uews_rt2_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt2_p = fft(s.Uews_rt2, s.Nfp, 2);

        who.fpwUews_rt2 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
        who.PSDwUews_rt2 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
        [s.PSDwUews_rt2, s.fpwUews_rt2] = pwelch( s.Uews_rt2, [], [], s.Nws, s.SampleF_Wind);     


        % ---- Effective Wind Speed ​​signal with spatial and rotational effects ----        
        who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt = s.Uews_rt2; 
        who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt_p = s.Uews_rt2_p; 
        
        % Organizing output results 
        Wind_IEC614001_1.fpHRSF_sp2 = s.fpHRSF_sp2; Wind_IEC614001_1.tau_wssp2 = s.tau_wssp2; Wind_IEC614001_1.epson_wssp2 = s.epson_wssp2; Wind_IEC614001_1.OmegaRws_sp2 = s.OmegaRws_sp2;        
        Wind_IEC614001_1.InputHRSF_sp2 = s.InputHRSF_sp2; Wind_IEC614001_1.InputHRSF_sp2_p = s.InputHRSF_sp2_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp2 = s.OutputHRSF_sp2; Wind_IEC614001_1.OutputHRSF_sp2_p = s.OutputHRSF_sp2_p;
        Wind_IEC614001_1.HRSF_sp2 = s.HRSF_sp2; Wind_IEC614001_1.Uews_rt2 = s.Uews_rt2; Wind_IEC614001_1.Uews_rt2_p= s.Uews_rt2_p; Wind_IEC614001_1.PSDwUews_rt2 = s.PSDwUews_rt2; Wind_IEC614001_1.fpwUews_rt2 = s.fpwUews_rt2;
        %
    elseif s.Option05f6 == 3
                % ##### SPATIAL EFFECT WITH SPATIAL FILTER ##### 

        % ---------- Positive Frequency ------------
        who.fpHRSF_sp3 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp3 = s.fppwUews_sp3(2:end)'; % OR s.fp  

        % ---------- Rotor speed  with spatial effect (s.Uews_sp3) ------------
        who.OmegaRws_sp3 = 'Rotor speed, in time domain and in [rad/s].'; 
        Ue_sp3_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp3, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp3 = max( min( ((s.Lambda_opt/s.Rrd).*Ue_sp3_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp3;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp3 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp3 = s.Output_HSF - s.Vm_Uews_sp3;

        who.InputHRSF_sp3_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp3_p = fft(s.InputHRSF_sp3, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp3 = s.epsonws; 
        s.tau_wssp3 = s.tau_rsws;

        who.OutputHRSF_sp3_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp3;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp3 + s.epson_wssp3) .* (s_rf - s.N_blades .* s.OmegaRws_sp3 - s.epson_wssp3));
        denominador = ((s_rf + s.tau_wssp3) .^ 2 + (s.N_blades .* s.OmegaRws_sp3) .^ 2);
        s.HRSF_sp3 = numerador ./ denominador;

        s.OutputHRSF_sp3_p = s.InputHRSF_sp3_p .* s.HRSF_sp3;

  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp3 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp3 = length(s.OutputHRSF_sp3_p) + 1; 
        s.OutputHRSF_sp3_fft = [s.OutputHRSF_sp3_p fliplr(conj(s.OutputHRSF_sp3_p))]; 
        s.OutputHRSF_sp3_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp3_fft(1,s.MidpointFFT_HRSF_sp3));
        s.OutputHRSF_sp3 = real(ifft(s.OutputHRSF_sp3_fft, 'symmetric'));         

        who.Uews_rt3 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt3 = s.OutputHRSF_sp3  + s.Uews_sp3 ; %  s.OutputHRSF_sp3 + s.Vm_Uews_sp3

        who.Uews_rt3_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt3_p = fft(s.Uews_rt3, s.Nfp, 2);

        who.fpwUews_rt3 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
        who.PSDwUews_rt3 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
        [s.PSDwUews_rt3, s.fpwUews_rt3] = pwelch( s.Uews_rt3, [], [], s.Nws, s.SampleF_Wind); 


        % ---- Effective Wind Speed ​​signal with spatial and rotational effects ----        
        who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt = s.Uews_rt3; 
        who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt_p = s.Uews_rt3_p; 
        
        % Organizing output results 
        Wind_IEC614001_1.fpHRSF_sp3 = s.fpHRSF_sp3; Wind_IEC614001_1.tau_wssp3 = s.tau_wssp3; Wind_IEC614001_1.epson_wssp3 = s.epson_wssp3; Wind_IEC614001_1.OmegaRws_sp3 = s.OmegaRws_sp3;        
        Wind_IEC614001_1.InputHRSF_sp3 = s.InputHRSF_sp3; Wind_IEC614001_1.InputHRSF_sp3_p = s.InputHRSF_sp3_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp3 = s.OutputHRSF_sp3; Wind_IEC614001_1.OutputHRSF_sp3_p = s.OutputHRSF_sp3_p;
        Wind_IEC614001_1.HRSF_sp3 = s.HRSF_sp3; Wind_IEC614001_1.Uews_rt3 = s.Uews_rt3; Wind_IEC614001_1.Uews_rt3_p= s.Uews_rt3_p; Wind_IEC614001_1.PSDwUews_rt3 = s.PSDwUews_rt3; Wind_IEC614001_1.fpwUews_rt3 = s.fpwUews_rt3;
        %
    elseif s.Option05f6 == 4
        % Compare the spatial effect methods on effective wind speed

                % ##### SPATIAL EFFECT WITH SIMPLE AVERAGE ##### 

        % ---------- Positive Frequency ------------
        who.fpHRSF_sp1 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp1 = s.fppwUews_sp1(2:end)' ; % OR s.fp

        % ---------- Rotor speed  with spatial effect (s.Uews_sp1) ------------
        who.OmegaRws_sp1 = 'Rotor speed, in time domain and in [rad/s].'; 
        Ue_sp1_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp1, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp1 = max( min( ((s.Lambda_opt/s.Rrd).*Ue_sp1_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp1;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp1 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp1 = s.Output_HSF - s.Vm_Uews_sp1;         

        who.InputHRSF_sp1_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp1_p = fft(s.InputHRSF_sp1, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp1 = s.epsonws; 
        s.tau_wssp1 = s.tau_rsws; 

        who.OutputHRSF_sp1_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp1;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp1 + s.epson_wssp1) .* (s_rf - s.N_blades .* s.OmegaRws_sp1 - s.epson_wssp1));
        denominador = ((s_rf + s.tau_wssp1) .^ 2 + (s.N_blades .* s.OmegaRws_sp1) .^ 2);
        s.HRSF_sp1 = numerador ./ denominador;

        s.OutputHRSF_sp1_p = s.InputHRSF_sp1_p .* s.HRSF_sp1;
      
  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp1 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp1 = length(s.OutputHRSF_sp1_p) + 1;
%         s.OutputHRSF_sp1_fft = [zeros(1,1) s.OutputHRSF_sp1_p fliplr(conj(s.OutputHRSF_sp1_p))]; 
        s.OutputHRSF_sp1_fft = [s.OutputHRSF_sp1_p fliplr(conj(s.OutputHRSF_sp1_p))]; 
        s.OutputHRSF_sp1_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp1_fft(1,s.MidpointFFT_HRSF_sp1));
        s.OutputHRSF_sp1 = real(ifft(s.OutputHRSF_sp1_fft, 'symmetric'));         
%         s.OutputHRSF_sp1  = s.OutputHRSF_sp1(1,1:end-1);

        who.Uews_rt1 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt1 = s.OutputHRSF_sp1  + s.Uews_sp1 ; % s.OutputHRSF_sp1  + s.Vm_Uews_sp1;                       

        who.Uews_rt1_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt1_p = fft(s.Uews_rt1, s.Nfp, 2);

        who.fpwUews_rt1 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
        who.PSDwUews_rt1 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
        [s.PSDwUews_rt1, s.fpwUews_rt1] = pwelch( s.Uews_rt1, [], [], s.Nws, s.SampleF_Wind);       


                % ##### SPATIAL EFFECT WITH WEIGHTED AVERAGE ##### 


        % ---------- Positive Frequency ------------
        who.fpHRSF_sp2 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp2 = s.fppwUews_sp2(2:end)';  % s.fppwUews_sp2(2:end)' OR s.fp

        % ---------- Rotor speed  with spatial effect (s.Uews_sp2) ------------
        who.OmegaRws_sp2 = 'Rotor speed, in time domain and in [rad/s].'; 
        Uews_sp2_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp2, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp2 = max( min( ((s.Lambda_opt/s.Rrd).*Uews_sp2_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp2;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp2 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp2 = s.Output_HSF - s.Vm_Uews_sp2;

        who.InputHRSF_sp2_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp2_p = fft(s.InputHRSF_sp2, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp2 = s.epsonws;
        s.tau_wssp2 = s.tau_rsws; 

        who.OutputHRSF_sp2_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp2;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp2 + s.epson_wssp2) .* (s_rf - s.N_blades .* s.OmegaRws_sp2 - s.epson_wssp2));
        denominador = ((s_rf + s.tau_wssp2) .^ 2 + (s.N_blades .* s.OmegaRws_sp2) .^ 2);
        s.HRSF_sp2 = numerador ./ denominador;

        s.OutputHRSF_sp2_p = s.InputHRSF_sp2_p .* s.HRSF_sp2;        

  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp2 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp2 = length(s.OutputHRSF_sp2_p) + 1;
%         s.OutputHRSF_sp2_fft = [zeros(1,1) s.OutputHRSF_sp2_p fliplr(conj(s.OutputHRSF_sp2_p))];
        s.OutputHRSF_sp2_fft = [s.OutputHRSF_sp2_p fliplr(conj(s.OutputHRSF_sp2_p))]; 
        s.OutputHRSF_sp2_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp2_fft(1,s.MidpointFFT_HRSF_sp2));
        s.OutputHRSF_sp2 = real(ifft(s.OutputHRSF_sp2_fft, 'symmetric'));         
%         s.OutputHRSF_sp2  = s.OutputHRSF_sp2(1,1:end-1);

        who.Uews_rt2 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt2 = s.OutputHRSF_sp2 + s.Uews_sp2; % s.OutputHRSF_sp2 + s.Vm_Uews_sp2;

        who.Uews_rt2_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt2_p = fft(s.Uews_rt2, s.Nfp, 2);

        who.fpwUews_rt2 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
        who.PSDwUews_rt2 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
        [s.PSDwUews_rt2, s.fpwUews_rt2] = pwelch( s.Uews_rt2, [], [], s.Nws, s.SampleF_Wind);     


                % ##### SPATIAL EFFECT WITH SPATIAL FILTER ##### 

        % ---------- Positive Frequency ------------
        who.fpHRSF_sp3 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
        s.fpHRSF_sp3 = s.fppwUews_sp3(2:end)'; % OR s.fp  

        % ---------- Rotor speed  with spatial effect (s.Uews_sp3) ------------
        who.OmegaRws_sp3 = 'Rotor speed, in time domain and in [rad/s].'; 
        Ue_sp3_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp3, s.Time_p(1:s.Nfp), 'linear');
        s.OmegaRws_sp3 = max( min( ((s.Lambda_opt/s.Rrd).*Ue_sp3_tp), (s.OmegaR_Rated * 1.2) ), 0);

        % ---------- Sign with spatial effect adopted ------------        
        who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
        s.Output_HSF = s.Uews_sp3;

        who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
        s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

        % ---------- Rotational Filter Input (signal preparation) ------------         
        who.InputHRSF_sp3 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
        s.InputHRSF_sp3 = s.Output_HSF - s.Vm_Uews_sp3;

        who.InputHRSF_sp3_p = 'Rotational Filter Input Signal, in frequency domain.';
        s.InputHRSF_sp3_p = fft(s.InputHRSF_sp3, s.Nfp, 2);  


        % ---------- Rotational Filter (Transfer Function adopted) ------------  
        s.epson_wssp3 = s.epsonws; 
        s.tau_wssp3 = s.tau_rsws;

        who.OutputHRSF_sp3_p = 'Rotational Filter Output Signal, in frequency domain.';  
        s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp3;
        numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp3 + s.epson_wssp3) .* (s_rf - s.N_blades .* s.OmegaRws_sp3 - s.epson_wssp3));
        denominador = ((s_rf + s.tau_wssp3) .^ 2 + (s.N_blades .* s.OmegaRws_sp3) .^ 2);
        s.HRSF_sp3 = numerador ./ denominador;

        s.OutputHRSF_sp3_p = s.InputHRSF_sp3_p .* s.HRSF_sp3;

  
        % ---------- Rotational Filter Output (signal reconstruction) ------------         
        who.OutputHRSF_sp3 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
        s.MidpointFFT_HRSF_sp3 = length(s.OutputHRSF_sp3_p) + 1;
%         s.OutputHRSF_sp3_fft = [zeros(1,1) s.OutputHRSF_sp3_p fliplr(conj(s.OutputHRSF_sp3_p))]; 
        s.OutputHRSF_sp3_fft = [s.OutputHRSF_sp3_p fliplr(conj(s.OutputHRSF_sp3_p))]; 
        s.OutputHRSF_sp3_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp3_fft(1,s.MidpointFFT_HRSF_sp3));
        s.OutputHRSF_sp3 = real(ifft(s.OutputHRSF_sp3_fft, 'symmetric'));         
%         s.OutputHRSF_sp3  = s.OutputHRSF_sp3(1,1:end-1);

        who.Uews_rt3 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
        s.Uews_rt3 = s.OutputHRSF_sp3  + s.Uews_sp3 ; % s.OutputHRSF_sp3  + s.Vm_Uews_sp3    

        who.Uews_rt3_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
        s.Uews_rt3_p = fft(s.Uews_rt3, s.Nfp, 2);

        who.fpwUews_rt3 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
        who.PSDwUews_rt3 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
        [s.PSDwUews_rt3, s.fpwUews_rt3] = pwelch( s.Uews_rt3, [], [], s.Nws, s.SampleF_Wind);      
       
        
        % Effective Wind Speed ​​signal with spatial and rotational effects adopted.
        who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';        
        who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';        
        if s.Option01f2 == 1
            % NREL-5MW baseline wind turbine
            s.Uews_rt = s.Uews_rt2;
            s.Uews_rt_p = s.Uews_rt2_p;
        else
            % IEA-15MW or DUT-10MW baseline wind turbine                
            s.Uews_rt = s.Uews_rt1;
            s.Uews_rt_p = s.Uews_rt1_p;
        end
                

        % Organizing output results 
        Wind_IEC614001_1.fpHRSF_sp1 = s.fpHRSF_sp1; Wind_IEC614001_1.tau_wssp1 = s.tau_wssp1; Wind_IEC614001_1.epson_wssp1 = s.epson_wssp1; Wind_IEC614001_1.OmegaRws_sp1 = s.OmegaRws_sp1;        
        Wind_IEC614001_1.InputHRSF_sp1 = s.InputHRSF_sp1; Wind_IEC614001_1.InputHRSF_sp1_p = s.InputHRSF_sp1_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp1 = s.OutputHRSF_sp1; Wind_IEC614001_1.OutputHRSF_sp1_p = s.OutputHRSF_sp1_p;
        Wind_IEC614001_1.HRSF_sp1 = s.HRSF_sp1; Wind_IEC614001_1.Uews_rt1 = s.Uews_rt1; Wind_IEC614001_1.Uews_rt1_p= s.Uews_rt1_p; Wind_IEC614001_1.PSDwUews_rt1 = s.PSDwUews_rt1; Wind_IEC614001_1.fpwUews_rt1 = s.fpwUews_rt1;

        Wind_IEC614001_1.fpHRSF_sp2 = s.fpHRSF_sp2; Wind_IEC614001_1.tau_wssp2 = s.tau_wssp2; Wind_IEC614001_1.epson_wssp2 = s.epson_wssp2; Wind_IEC614001_1.OmegaRws_sp2 = s.OmegaRws_sp2;        
        Wind_IEC614001_1.InputHRSF_sp2 = s.InputHRSF_sp2; Wind_IEC614001_1.InputHRSF_sp2_p = s.InputHRSF_sp2_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp2 = s.OutputHRSF_sp2; Wind_IEC614001_1.OutputHRSF_sp2_p = s.OutputHRSF_sp2_p;
        Wind_IEC614001_1.HRSF_sp2 = s.HRSF_sp2; Wind_IEC614001_1.Uews_rt2 = s.Uews_rt2; Wind_IEC614001_1.Uews_rt2_p= s.Uews_rt2_p; Wind_IEC614001_1.PSDwUews_rt2 = s.PSDwUews_rt2; Wind_IEC614001_1.fpwUews_rt2 = s.fpwUews_rt2;

        Wind_IEC614001_1.fpHRSF_sp3 = s.fpHRSF_sp3; Wind_IEC614001_1.tau_wssp3 = s.tau_wssp3; Wind_IEC614001_1.epson_wssp3 = s.epson_wssp3; Wind_IEC614001_1.OmegaRws_sp3 = s.OmegaRws_sp3;        
        Wind_IEC614001_1.InputHRSF_sp3 = s.InputHRSF_sp3; Wind_IEC614001_1.InputHRSF_sp3_p = s.InputHRSF_sp3_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp3 = s.OutputHRSF_sp3; Wind_IEC614001_1.OutputHRSF_sp3_p = s.OutputHRSF_sp3_p;
        Wind_IEC614001_1.HRSF_sp3 = s.HRSF_sp3; Wind_IEC614001_1.Uews_rt3 = s.Uews_rt3; Wind_IEC614001_1.Uews_rt3_p= s.Uews_rt3_p; Wind_IEC614001_1.PSDwUews_rt3 = s.PSDwUews_rt3; Wind_IEC614001_1.fpwUews_rt3 = s.fpwUews_rt3;
        %
    else
        % DO NOT add rotational effect to Effective Wind Speed
        s.Uews_rt = s.Uews_sp; 
    end    

    who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
    s.Uews_rt_p = fft(s.Uews_rt, s.Nfp, 2);
    
    who.fpwUews_rt = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial and rotational effects.';
    who.PSDwUews_rt = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial and rotational effects.';
    [s.PSDwUews_rt, s.fpwUews_rt] = pwelch( s.Uews_rt, [], [], s.Nws, s.SampleF_Wind);
      

    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end


    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;



    % Organizing output results          
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT; Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT; Wind_IEC614001_1.WindField_Disk_WT_p = s.WindField_Disk_WT_p;
    Wind_IEC614001_1.Ue_sp1 = s.Uews_sp1; Wind_IEC614001_1.Ue_sp1_p = s.Uews_sp1_p; Wind_IEC614001_1.PSDpwUews_sp1 = s.PSDpwUews_sp1; Wind_IEC614001_1.fppwUews_sp1 = s.fppwUews_sp1;
    Wind_IEC614001_1.std_Uews_sp1 = s.std_Uews_sp1; Wind_IEC614001_1.mean_Uews_sp1 = s.mean_Uews_sp1; Wind_IEC614001_1.Vt_Uews_sp1 = s.Vt_Uews_sp1; Wind_IEC614001_1.Vm_Uews_sp1 = s.Vm_Uews_sp1; Wind_IEC614001_1.Vt_Uews_sp1_p = s.Vt_Uews_sp1_p; Wind_IEC614001_1.Vm_Uews_sp1_p = s.Vm_Uews_sp1_p;
    Wind_IEC614001_1.epsonws = s.epsonws; Wind_IEC614001_1.tau_rsws = s.tau_rsws; 
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_sp_p = s.Uews_sp_p; Wind_IEC614001_1.PSDpwUews_sp = s.PSDpwUews_sp; Wind_IEC614001_1.fpwUews_sp = s.fpwUews_sp;
    Wind_IEC614001_1.Uews_rt_p = s.Uews_rt_p; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.PSDwUews_rt = s.PSDwUews_rt; Wind_IEC614001_1.fpwUews_rt = s.fpwUews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;
    

   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6  == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%============================================================= 
    % TRANSFER FUNCTION METHOD FOR TURBULENT WIND MODEL (OFFLINE):
    % Purpose of this Logical Instance: to generate turbulent wind speed 
    % using Transfer Functions, adjusting from the Kaimal or von Karman 
    % spectrum and parameters calculated according to the IEC 61400-1 
    % standard. 
    %    
    % ## Theoretical References used in this logical instance:
    % # Title: "Complete methodology on generating realistic wind speed profiles
    % based on measurements." by C. Gavriluta, S. Spataru,  I. Mosincat, 
    % C. Citro, I. Candela, P. Rodriguez. 2012.   
    %
    % # Title: "Wind Turbine Control Systems" by Fernando D. Bianchi, Hernán 
    % De Battista and Ricardo J. Mantz. Section 3.7.3. 2006. 
    % # Title: "Rotationally sampled spectrum approach for simulation of wind 
    % speed turbulence in large wind turbines" by A. Burlibasa, E. Ceanga. 2013.
    % # Title: “Dynamic Influences of Wind Power on The Power System” by 
    % Pedro André Carvalho Rosas. DTU 2004.
    % # Title: "Modeling of Wind Turbines for Power System Studies" by 
    % Tomas Gavriluta and Torbjörn Thiringer, (2002).



    % ---------- Discretization of the system and sample ---------- 
    s.Option05f6 = 5; % Must be option 5
    System_WindFieldIEC614001_1('logical_instance_04'); 

    % ---- Model of Average Speed ​​and Wind Conditions (IEC 61400-1) ---- 
    System_WindFieldIEC614001_1('logical_instance_05'); 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm; 


    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));  
        
        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));        
    end 


    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));

    who.S1_Karman = 'Power Spectra (von Karman Spectrum).'; 
    s.S1_Karman = ((4 .* s.sigma_x.^2 .* (s.L1_x ./ s.Vws_AverageHub)) ./ ((1 + 70.8 .* (s.fp .* (s.L1_x ./ s.Vws_AverageHub)).^2).^(5/6)));
    

    % ---------- Frequencies for Turbulent Wind Speed ----------  
    who.fpp = 'Discretized Frequencies for Turbulent Wind Speed, in [m/s].';        
    s.fpp = s.fp; 
    s.MidpointFFT = 0.5 * s.Nws + 1;    

                     % #### WIND SPEED AT FIXED POINT % ####    

    % ---------- White Noise ----------  
    who.WhiteNoiseNws = 'White noise with dimension (1 x Nws), in time domain or based on value in [m/s].';  
    s.WhiteNoiseNws = zeros(1,s.Nfp);
    for iit = 1:(s.N_Vm)
        s.WhiteNoiseNws(:,s.idxPSD_0(iit):s.idxPSD_f(iit)) = ( s.sigma_1(iit) )*randn(1, s.Nws_pm(iit)) + 0*ones(1,s.Nws_pm(iit));
    end
    who.WhiteNoiseNws_p = 'White noise with dimension (1 x Nws), in time domain.';
    s.WhiteNoiseNws_p = fft(s.WhiteNoiseNws);


    % ---------- Turbulence Wind Speed Model: von Karman Spectrum (Transfer Function) ---------- 
    s.Kf_Vws = 0:50;
    s.Kf_KarmanTable = [10*s.Kf_Vws(1:8) 9*s.Kf_Vws(9) s.Kf_Vws(10:30) 0.5*s.Kf_Vws(31:40) 0.25*s.Kf_Vws(41:end)];     
    s.Kf_Karman = interp1(s.Kf_Vws, s.Kf_KarmanTable, min(mean(s.Vws_AverageHub),s.Kf_Vws(end)) , 'linear');
    s.Tf_Karman = s.Lcc/s.Vws_AverageHub;

    s_f = 1i .*2 .*pi .*s.fpp;
    s.Hf_Karman = s.Kf_Karman.*((0.4.*s.Tf_Karman*s_f + 1) ./ ( (s.Tf_Karman.*s_f + 1).*(0.25.*s.Tf_Karman.*s_f + 1) ) );
    who.Vt_Karman_p = 'Turbulent Wind Speed ​​passing a fixed point at the hub height, in frequency domain .';
    s.Vt_Karman_p = s.WhiteNoiseNws_p  .* s.Hf_Karman;

    who.Vt_Karman = 'Turbulent Wind Speed ​​passing a fixed point at the hub height, in time domain and in [m/s].';
    s.Vt_Karman_fft = [s.Vt_Karman_p zeros(1,1) fliplr(conj(s.Vt_Karman_p))]; 
    s.Vt_Karman_fft(1,s.MidpointFFT) = real(s.Vt_Karman_fft(1,s.MidpointFFT));
    s.Vt_Karman = real(ifft(s.Vt_Karman_fft, 'symmetric')); 
    s.Vt_Karman = s.Vt_Karman(1,1:end-1);
    s.Vt_Karman = s.Vt_Karman - mean(s.Vt_Karman);

    % ---------- WIND SPEED AT FIXED POINT.----------
    who.Vm_GridHub = 'Mean component of Wind Speedd at the rotor hub height, in time domain and in [m/s].';
    s.Vm_GridHub = s.Vm_Ugrid(s.idxsV_hub,:);
    who.Vt_GridHub  = 'Turbulent component of Wind Speed at the rotor hub height, in time domain and in [m/s].';
    s.Vt_GridHub = s.Vt_Karman ;

    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = max( s.Vt_Karman  + s.Vm_Ugrid(s.idxsV_hub,:) , 0);    

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2);   

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:); 


    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,1);        
    s.WindField_Grid(:,:,1) = repmat(s.WindSpeed_Hub, s.Nt, 1);
    s.WindField_Grid(:,:,2) = repmat(s.WindSpeed_Hub, s.Nt, 1);
    s.WindField_Grid(:,:,3) = repmat(s.WindSpeed_Hub, s.Nt, 1);

    who.fpwGrid_u = 'Estimated positive frequency of the wind field at fixed grid points.';
    s.fpwGrid_u = zeros(s.Nt,s.Nfp+1);
    who.PSDpwGrid_u = 'Estimated Power Spectrum Density (PSD) of the wind field at fixed grid points.';
    s.PSDpwGrid_u = zeros(s.Nt,s.Nfp+1);
    for iit = 1:s.Nt
        [PSDpwGrid_u, fpwGrid_u] = pwelch( s.WindField_Grid(iit,:,1), [], [], s.Nws, s.SampleF_Wind);
        s.PSDpwGrid_u(iit,:) = PSDpwGrid_u';
        s.fpwGrid_u(iit,:) = fpwGrid_u';
    end

        
    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);

    who.WindField_Disk_p = 'Actual Wind Field circumscribed in the rotor Disk, in frequency domain.';
    s.WindField_Disk_p = []; 
    s.WindField_Disk_p(:,:,1) = fft( s.WindField_Disk(:,:,1) , s.Nfp, 2);
    s.WindField_Disk_p(:,:,2) = fft( s.WindField_Disk(:,:,2) , s.Nfp, 2);
    s.WindField_Disk_p(:,:,3) = fft( s.WindField_Disk(:,:,3) , s.Nfp, 2); 


    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3);   

    who.WindField_Disk_WT_p = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and without interaction with the wind turbine, in frequency domain.';
    s.WindField_Disk_WT_p = []; 
    s.WindField_Disk_WT_p(:,:,1) = fft( s.WindField_Disk_WT(:,:,1) , s.Nfp, 2);
    s.WindField_Disk_WT_p(:,:,2) = fft( s.WindField_Disk_WT(:,:,2) , s.Nfp, 2);
    s.WindField_Disk_WT_p(:,:,3) = fft( s.WindField_Disk_WT(:,:,3) , s.Nfp, 2); 


                     % #### SPATIAL EFFECT % ####   

    % Calculating the transfer function as a function of the mean component     
    who.fp_sp3 = 'Discretized Frequencies for Turbulent Wind Speed, in [m/s].'; 
    s.fp_sp3 = s.fp; % s.fp  OR s.fpwGrid_u(s.idxsV_hub,2:end)

    who.OmegaRws_WindSpeed_Hub = 'Rotor speed with dimensão (1 x Nws), in time domain and in [m/s].'; 
    WindSpeed_Hub_tp = interp1(s.Time_ws(1:s.Nws), s.WindSpeed_Hub, s.Time_p(1:s.Nfp), 'linear');
    s.OmegaRws_WindSpeed_Hub = max( min( ((s.Lambda_opt/s.Rrd).*WindSpeed_Hub_tp), (s.OmegaR_Rated * 1.2) ), 0); 
     
    Vt_hub_p = fft( s.Vt_GridHub , s.Nfp, 2); % Vt_hub = WindSpeed_Hub - Vm_hub; % WindSpeed_Hub = Vt_hub + Vm_hub;

    Vm_hub =  interp1(s.Time_ws(1:s.Nws), s.Vm_GridHub, s.Time_p(1:s.Nfp), 'linear');           
    Vm_hub(Vm_hub == 0) = 1e-10;   
    s.bsf = 0.15*(s.Rrd ./Vm_hub);
    s.asf = 0.55;
    s.fws_Cut = 1 .* s.OmegaRws_WindSpeed_Hub ./ (2*pi);     
    who.Hsf_f = 'Spatial Filter Function (Transfer Function) in the frequency domain.';     
    s_f = 1i .*2 .*pi .*s.fp_sp3;
%     s.Hsf_f = ( sqrt(2) + (s.bsf .* s_f) ) ./ ( (sqrt(2) + (s.bsf .* sqrt(s.asf) .* s_f )) .* (1 + (s.bsf ./ sqrt(s.asf)) .* s_f) );
%     s.Hsf_f = 1 ./ ( s_f .* s.bsf + 1); 
    s.Hsf_f = 1./ ((s_f./2*pi.*s.fws_Cut) + 1);
    
    % Applying the wind speed at the fixed point to the Spatial Filter  
    who.Vt_Uews_sp3_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Spatial Filter or Transfer Function), in frequency domain.';
    s.Vt_Uews_sp3_p = Vt_hub_p.* s.Hsf_f;    

    who.Vt_Uews_sp3 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Spatial Filter or Transfer Function), in time domain and in [m/s].';
    s.MidpointFFT = 0.5 * s.Nws + 1;    
    s.Vt_Uews_sp3_fft = [zeros(1,1) s.Vt_Uews_sp3_p fliplr(conj(s.Vt_Uews_sp3_p))]; 
    s.Vt_Uews_sp3_fft(1,s.MidpointFFT) = real(s.Vt_Uews_sp3_fft(1,s.MidpointFFT));
    s.Vt_Uews_sp3 = real(ifft(s.Vt_Uews_sp3_fft, 'symmetric')); 
    s.Vt_Uews_sp3 = s.Vt_Uews_sp3(1,1:end-1);

    who.Uews_sp3 = 'Effective Wind Speed, calculated from the Spatial Filter or Transfer Function, according to Schlipf (2018/2019), in time domain and in [m/s].';
    s.Uews_sp3 = s.Vt_Uews_sp3 + s.Vm_hub;    
    who.Uews_sp3_p = 'Effective Wind Speed, calculated from the Spatial Filter or Transfer Function, according to Schlipf (2018/2019), in frequency domain.';
    s.Uews_sp3_p = fft(s.Uews_sp3, s.Nfp, 2);

    who.fppwUews_sp3 = 'Estimated Positive Frequency of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
    who.PSDpwUews_sp3 = 'Estimated Power Spectrum Density (PSD) of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
    [s.PSDpwUews_sp3, s.fppwUews_sp3] = pwelch( s.Uews_sp3, [], [], s.Nws, s.SampleF_Wind);


    who.Vt_Uews_sp3 = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
    s.Vt_Uews_sp3 = zeros(1,s.Nws);
    who.Vm_Uews_sp3 = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in time domain and in [m/s].';   
    s.Vm_Uews_sp3 = zeros(1,s.Nws);
    who.std_Uews_sp3 = 'Standard Deviation of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
    s.std_Uews_sp3 = zeros(1,s.N_Vm); 
    who.mean_Uews_sp3 = 'Mean of the Effective Wind Speed, calculated from the simple average of the wind field, in [m/s].';
    s.mean_Uews_sp3 = zeros(1,s.N_Vm);
    for iit = 1:s.N_Vm   
        s.std_Uews_sp3(iit) = std(s.Uews_sp3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)),0,2);
        s.mean_Uews_sp3(iit) = mean(s.Uews_sp3(:,s.idxFFT_0(iit):s.idxFFT_f(iit)), 2);
        s.Vm_Uews_sp3(1, s.idxFFT_0(iit):s.idxFFT_f(iit)) = repmat(s.mean_Uews_sp3(iit), 1, s.idxFFT_f(iit) - s.idxFFT_0(iit) + 1);
        s.Vt_Uews_sp3(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.Uews_sp3(1,s.idxFFT_0(iit):s.idxFFT_f(iit)) - s.Vm_Uews_sp3(1, s.idxFFT_0(iit):s.idxFFT_f(iit));
    end   

    who.Vt_Uews_sp3_p = 'Turbulent Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';
    s.Vt_Uews_sp3_p = fft(s.Vt_Uews_sp3, s.Nfp, 2); 
    who.Vm_Uews_sp3_p = 'Mean Component of Effective Wind Speed ​​with spatial effect (Simple Average of the wind field), in frequency domain.';   
    s.Vm_Uews_sp3_p = fft(s.Vm_Uews_sp3, s.Nfp, 2);    


    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----  
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect, in the time domain and in [m/s].';
    s.Uews_sp = s.Uews_sp3; 
    who.Uews_sp_p = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect, in the time domain and in [m/s].';
    s.Uews_sp_p = s.Uews_sp3_p;
    who.fpwUews_sp = 'Estimated Positive Frequency of the Effective Wind Speed ​​with Spatial Effect.';
    who.PSDpwUews_sp = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with Spatial Effect.';
    [s.PSDpwUews_sp, s.fpwUews_sp] = pwelch( s.Uews_sp, [], [], s.Nws, s.SampleF_Wind);



                         % #### ROTATIONAL EFFECT % ####   
            
    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------   
    s.epsonws = 0; % From Gabriluta (2012).
    s.tau_rsws = 1; % From Gabriluta (2012).

            % Adjustment in the Transfer Function
    % ---------- Positive Frequency ------------
    who.fpHRSF_sp3 = 'Estimated Positive Frequencies of the Effective Wind Speed ​​with spatial effect, in [Hz].';   
    s.fpHRSF_sp3 = s.fppwUews_sp3(2:end)'; % OR s.fppwUews_sp3(2:end)' OR  s.fp

    % ---------- Rotor speed  with spatial effect (s.Uews_sp3) ------------
    who.OmegaRws_sp3 = 'Rotor speed, in time domain and in [rad/s].'; 
    Ue_sp3_tp = interp1(s.Time_ws(1:s.Nws), s.Uews_sp3, s.Time_p(1:s.Nfp), 'linear');
    s.OmegaRws_sp3 = max( min( ((s.Lambda_opt/s.Rrd).*Ue_sp3_tp), (s.OmegaR_Rated * 1.2) ), 0);

    % ---------- Sign with spatial effect adopted ------------        
    who.Output_HSF = 'Spatial Filter Output Signal or Sign with Spatial Effect, in the time domain and in [m/s].';
    s.Output_HSF = s.Uews_sp3;

    who.Output_HSF_p = 'Spatial Filter Output Signal in the frequency domain.';
    s.Output_HSF_p = fft(s.Output_HSF, s.Nfp, 2); 

    % ---------- Rotational Filter Input (signal preparation) ------------         
    who.InputHRSF_sp3 = 'Rotational Filter Input Signal, in time domain and in [m/s].';
    s.InputHRSF_sp3 = s.Output_HSF - s.Vm_Uews_sp3;

    who.InputHRSF_sp3_p = 'Rotational Filter Input Signal, in frequency domain.';
    s.InputHRSF_sp3_p = fft(s.InputHRSF_sp3, s.Nfp, 2);  

    % ---------- Rotational Filter (Transfer Function adopted) ------------  
    s.epson_wssp3 = s.epsonws; 
    s.tau_wssp3 = s.tau_rsws;

    who.OutputHRSF_sp3_p = 'Rotational Filter Output Signal, in frequency domain.';  
    s_rf = 1i .* 2 .* pi .* s.fpHRSF_sp3;
    numerador = ((s_rf + s.N_blades .* s.OmegaRws_sp3 + s.epson_wssp3) .* (s_rf - s.N_blades .* s.OmegaRws_sp3 - s.epson_wssp3));
    denominador = ((s_rf + s.tau_wssp3) .^ 2 + (s.N_blades .* s.OmegaRws_sp3) .^ 2);
    s.HRSF_sp3 = numerador ./ denominador;
    
    s.OutputHRSF_sp3_p = s.InputHRSF_sp3_p .* s.HRSF_sp3;

    % ---------- Rotational Filter Output (signal reconstruction) ------------         
    who.OutputHRSF_sp3 = 'Rotational Filter Output Signal, in time domain and in [m/s].';
    s.MidpointFFT_HRSF_sp3 = length(s.OutputHRSF_sp3_p) + 1;
    s.OutputHRSF_sp3_fft = [zeros(1,1) s.OutputHRSF_sp3_p fliplr(conj(s.OutputHRSF_sp3_p))]; 
    s.OutputHRSF_sp3_fft(1,s.MidpointFFT) = real(s.OutputHRSF_sp3_fft(1,s.MidpointFFT_HRSF_sp3));
    s.OutputHRSF_sp3 = real(ifft(s.OutputHRSF_sp3_fft, 'symmetric'));         
    s.OutputHRSF_sp3  = s.OutputHRSF_sp3(1,1:end-1);

    who.Uews_rt3 = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
    s.Uews_rt3 = s.OutputHRSF_sp3  + s.Uews_sp3 ; % s.Vm_Uews_sp3;     

    who.Uews_rt3_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
    s.Uews_rt3_p = fft(s.Uews_rt3, s.Nfp, 2);

    who.fpwUews_rt3 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
    who.PSDwUews_rt3 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Spatial Filter) and rotational effects.';
    [s.PSDwUews_rt3, s.fpwUews_rt3] = pwelch( s.Uews_rt3, [], [], s.Nws, s.SampleF_Wind);      

    % ---- Effective Wind Speed ​​signal with spatial and rotational effects ----        
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in time domain and in [m/s].';
    s.Uews_rt = s.Uews_rt3; 
    who.Uews_rt_p = 'Effective Wind Speed ​​with spatial and rotational effect, in frequency domain.';
    s.Uews_rt_p = s.Uews_rt3_p; 
    
    who.fpwUews_rt = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial and rotational effects.';
    who.PSDwUews_rt = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial and rotational effects.';
    [s.PSDwUews_rt, s.fpwUews_rt] = pwelch( s.Uews_rt, [], [], s.Nws, s.SampleF_Wind);



    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end


    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;


                         % #### WIND FIELD AND WIND SPEEDS % ####      

    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;           
    Wind_IEC614001_1.S1_Karman = s.S1_Karman; s.WhiteNoiseNws = s.WhiteNoiseNws; s.WhiteNoiseNws_p = s.WhiteNoiseNws_p; s.Kf_Vws = s.Kf_Vws; s.Kf_KarmanTable = s.Kf_KarmanTable; s.Kf_Karman = s.Kf_Karman; s.Tf_Karman = s.Tf_Karman; s.Hf_Karman = s.Hf_Karman;
    Wind_IEC614001_1.Vt_Karman = s.Vt_Karman; Wind_IEC614001_1.Vt_Karman_p = s.Vt_Karman_p; Wind_IEC614001_1.Vt_GridHub = s.Vt_GridHub; Wind_IEC614001_1.Vm_GridHub = s.Vm_GridHub; Wind_IEC614001_1.Vm_hub = s.Vm_hub;
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; 
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT;
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk; Wind_IEC614001_1.WindField_Disk_p = s.WindField_Disk_p;
    Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT; Wind_IEC614001_1.WindField_Disk_WT_p = s.WindField_Disk_WT_p;    
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub;

    Wind_IEC614001_1.bsf = s.bsf; Wind_IEC614001_1.Hsf_f = s.Hsf_f; Wind_IEC614001_1.Ue_sp3 = s.Uews_sp3; Wind_IEC614001_1.Ue_sp3_p = s.Uews_sp3_p; Wind_IEC614001_1.PSDpwUews_sp3 = s.PSDpwUews_sp3; Wind_IEC614001_1.fppwUews_sp3 = s.fppwUews_sp3;      
    Wind_IEC614001_1.std_Uews_sp3 = s.std_Uews_sp3; Wind_IEC614001_1.mean_Uews_sp3 = s.mean_Uews_sp3; Wind_IEC614001_1.Vt_Uews_sp3 = s.Vt_Uews_sp3; Wind_IEC614001_1.Vm_Uews_sp3 = s.Vm_Uews_sp3; Wind_IEC614001_1.Vt_Uews_sp3_p = s.Vt_Uews_sp3_p; Wind_IEC614001_1.Vm_Uews_sp3_p = s.Vm_Uews_sp3_p;    
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_sp_p = s.Uews_sp_p; Wind_IEC614001_1.Uews_rt_p = s.Uews_rt_p; Wind_IEC614001_1.fpwUews_sp = s.fpwUews_sp; Wind_IEC614001_1.PSDpwUews_sp = s.PSDpwUews_sp; Wind_IEC614001_1.fpwUews_rt = s.fpwUews_rt; Wind_IEC614001_1.PSDwUews_rt = s.PSDwUews_rt;
    
    Wind_IEC614001_1.fpHRSF_sp3 = s.fpHRSF_sp3; Wind_IEC614001_1.tau_wssp3 = s.tau_wssp3; Wind_IEC614001_1.epson_wssp3 = s.epson_wssp3; Wind_IEC614001_1.OmegaRws_sp3 = s.OmegaRws_sp3;        
    Wind_IEC614001_1.InputHRSF_sp3 = s.InputHRSF_sp3; Wind_IEC614001_1.InputHRSF_sp3_p = s.InputHRSF_sp3_p; s.Output_HSF = s.Output_HSF; s.Output_HSF_p  = s.Output_HSF_p; Wind_IEC614001_1.OutputHRSF_sp3 = s.OutputHRSF_sp3; Wind_IEC614001_1.OutputHRSF_sp3_p = s.OutputHRSF_sp3_p;
    Wind_IEC614001_1.HRSF_sp3 = s.HRSF_sp3; Wind_IEC614001_1.Uews_rt3 = s.Uews_rt3; Wind_IEC614001_1.Uews_rt3_p= s.Uews_rt3_p; Wind_IEC614001_1.PSDwUews_rt3 = s.PSDwUews_rt3; Wind_IEC614001_1.fpwUews_rt3 = s.fpwUews_rt3; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;    
    %


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % UPLOAD FILE WITH DESIRED WIND FIELD (OFFLINE): 
    % Purpose of this Logical Instance: to load a file "file.mat", with 
    % information about the wind field and velocities at some points. 
    % In this instance, you can standardize the information in this code 
    % and use it as a Disturbance Input to the system. For example, you
    % can save a wind field obtained from OpenFast's TurbSim or specify
    % different values ​​that are most commonly used, to save time computing
    % instead of generating turbulent winds.


    % ---------- Discretization of the system and sample ---------- 
    s.Option05f6 = 3; % Must be option 3
    System_WindFieldIEC614001_1('logical_instance_04'); 
    System_WindFieldIEC614001_1('logical_instance_05');
    
        % WARNING! It is mandatory to specify the abaove variables, in
        % these dimensions and according to the discretization made 
        % in Logical Instance 04 or reset everything, when load your data:    


    % Read the file in the workspace
    if s.V_meanHub_0 == 6
        load('System_WindLoadDesire_6.mat');
        %
    elseif s.V_meanHub_0 == 8
        load('System_WindLoadDesire_8.mat');        
        %
    elseif s.V_meanHub_0 == 11
        load('System_WindLoadDesire_11.mat');        
        %
    elseif s.V_meanHub_0 == 15
        load('System_WindLoadDesire_15.mat');        
        %
    elseif s.V_meanHub_0 == 20
        load('System_WindLoadDesire_20.mat');        
        %
    else
        load('System_WindLoadDesire.mat');         
    end
    

    % ---------- WIND CONDITIONS ACCORDING IEC-61400-1 ----------                 
    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';                             
    s.Vm = Vm;
%         System_WindFieldIEC614001_1('logical_instance_05');                    
    % Using "logical_instance_05" OR set a Vm(1, s.N_Vm) and calculate the wind conditions as below:
    s.Vws_meanHub = s.Vm(1);
    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm; 
            
    % WARNING! Discretization below according to Logical Instance 04,
    % other discretization, redefine the variables.

    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));            
        
        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));         
    end 

    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));      

    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = WindField_Grid;        
        % NOTE: This variable was redefined according to its "file.m".
%     s.WindField_Grid(:,:,1) = zeros(s.Nt, s.Nws,1); 
%     s.WindField_Grid(:,:,2) = zeros(s.Nt, s.Nws,1); 
%     s.WindField_Grid(:,:,3) = ones(s.Nt, s.Nws,1); 

        
    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);

        
    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3);


    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1);   

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2);   

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);       


    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect and in the time domain, in [m/s].';
    s.Uews_sp = Uews_sp;    
        % NOTE: This variable was redefined according to its "file.m".        
%     s.Uews = sum(s.WindField_Disk(:,:,1),1) ./ s.Length_Disk;

    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in [m/s].';
    s.Uews_rt = Uews_rt;        
     % NOTE: This variable was redefined according to its "file.m".        
%     s.Vews = s.Uews;


    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end


    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;

    
    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;        
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid;  
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT; 
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk;      Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT;  
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub; 
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end   


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % DETERMINISTIC SIGNAL: CONSTANT WIND (OFFLINE): 
    % Purpose of this Logical Instance: to generate a deterministic signal
    % of the effective wind speed, considering that the wind field is 
    % uniform and of the same value. The signal is a constant wind profile.  


    % Calling the next logic instance
    System_WindFieldIEC614001_1('logical_instance_04');

    % ---------- Desired deterministic signal  ----------   
    s.WS_Hub = s.V_meanHub_0*ones(1, s.Nws);
    for iit = 1: s.N_Vm
        s.Vm(iit) = mean(s.WS_Hub(1,s.idxFFT_0(iit):s.idxFFT_f(iit)));     
    end


    % ---------- WIND CONDITIONS ACCORDING IEC-61400-1 ----------                 
    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';                                               
    s.Vws_meanHub = s.Vm(1);
    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid  = ones(s.Nt,1)*s.Nfft_vm; 

    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));            

        s.Vm_Ugrid (:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));          
    end 

    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));

    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,3); 
    s.WindField_Grid(:,:,1) = 0 + s.Vm_Ugrid ; 
    s.WindField_Grid(:,:,2) = 0 + s.Vm_Ugrid ; 
    s.WindField_Grid(:,:,3) = 0 + s.Vm_Ugrid ; 

    s.WindField_Grid( s.idxsV_hub ,:,1) = s.WS_Hub;      


    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);

    
    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3);  


    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1);  

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2); 

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);


    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect and in the time domain, in [m/s].';    
    s.Uews_sp = s.V_meanHub_0*ones(1, s.Nws); 
        % NOTE: Disregard that the EWS is the average of the wind field.


    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in [m/s].';    
    s.Uews_rt = s.Uews_sp;
        % NOTE: Disregard that the EWS is the average of the wind field  and rotational effects.


    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end


    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;


    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;           
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid;   
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT;    
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk; Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT;
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub;
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end



elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % DETERMINISTIC SIGNAL: LINEAR INCREASING WIND (OFFLINE): 
    % Purpose of this Logical Instance: to generate a deterministic signal
    % of the effective wind speed, considering that the wind field is 
    % uniform and of the same value. The signal is a linear increasing 
    % wind profile of V_meanHub_0.  

   
    % Calling the next logic instance
    System_WindFieldIEC614001_1('logical_instance_04');

    % ---------- Desired deterministic signal  ----------   
    s.WS_Hub = linspace(s.Vews_initial ,s.Vews_final,s.Nws);
    for iit = 1: s.N_Vm
        s.Vm(iit) = mean(s.WS_Hub(1,s.idxFFT_0(iit):s.idxFFT_f(iit)));     
    end


    % ---------- WIND CONDITIONS ACCORDING IEC-61400-1 ----------                 
    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';                                               
    s.Vws_meanHub = s.Vm(1);
    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm; 

    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));            

        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));         
    end 

    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));

    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,3); 
    s.WindField_Grid(:,:,1) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,2) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,3) = 0 + s.Vm_Ugrid; 

    s.WindField_Grid( s.idxsV_hub ,:,1) = s.WS_Hub;    


    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);
  

    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3); 

    
    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1);  

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2); 

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);


    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect and in the time domain, in [m/s].';    
    s.Uews_sp = s.WS_Hub; 
        % NOTE: Disregard that the EWS is the average of the wind field.


    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in [m/s].';    
    s.Uews_rt  = s.Uews_sp;
        % NOTE: Disregard that the EWS is the average of the wind field  and rotational effects.



    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end

    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;


    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;           
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid;
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT;    
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk;  Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT;   
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub;
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end


elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % DETERMINISTIC SIGNAL: LINEAR DECREASING WIND (OFFLINE): 
    % Purpose of this Logical Instance: to generate a deterministic signal
    % of the effective wind speed, considering that the wind field is 
    % uniform and of the same value. The signal is a linear decreasing 
    % wind profile of V_meanHub_0.  


    % Calling the next logic instance
    System_WindFieldIEC614001_1('logical_instance_04');


    % ---------- Desired deterministic signal  ----------   
    s.WS_Hub = linspace(s.Vews_initial,s.Vews_final ,s.Nws);
    for iit = 1: s.N_Vm
        s.Vm(iit) = mean(s.WS_Hub(1,s.idxFFT_0(iit):s.idxFFT_f(iit)));     
    end

    % ---------- WIND CONDITIONS ACCORDING IEC-61400-1 ----------                 
    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';                                               
    s.Vws_meanHub = s.Vm(1);
    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm; 

    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));            

        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));       
    end 

    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));

    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,3); 
    s.WindField_Grid(:,:,1) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,2) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,3) = 0 + s.Vm_Ugrid; 

    s.WindField_Grid( s.idxsV_hub ,:,1) = s.WS_Hub;       


    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);

    
    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3); 


    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1);  

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2); 

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);

    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect and in the time domain, in [m/s].';    
    s.Uews_sp = s.WS_Hub; 
        % NOTE: Disregard that the EWS is the average of the wind field.


    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in [m/s].';    
    s.Uews_rt = s.Uews_sp;
        % NOTE: Disregard that the EWS is the average of the wind field  and rotational effects.


    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end

    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;


    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;           
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid;   
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT;    
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk; Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT;
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub; 
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end


elseif strcmp(action, 'logical_instance_14')
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % DETERMINISTIC SIGNAL: CUSTOM WIND PROFILE (OFFLINE): 
    % Purpose of this Logical Instance: to generate a deterministic 
    % signal of the effective wind speed, considering any desired 
    % wind field. The signal is customized and can use the initial value
    % of the wind speed at the height of the V_meanHub_0 hub.


    % Calling the next logic instance
    System_WindFieldIEC614001_1('logical_instance_04');


    % ---------- Desired deterministic signal  ----------   
    n_steps = 5;
    step_size = floor(s.Nws / (2 * n_steps)); 
    s.WS_Hub = zeros(s.Nws, 1);
    step_increment = (s.Vws_CutOut - s.Vws_CutIn) / n_steps;
  
    for i = 1:n_steps
        start_idx = (i-1) * 2 * step_size + 1;
        mid_idx = start_idx + step_size - 1;
        end_idx = start_idx + 2 * step_size - 1;

        % Linear Increment
        s.WS_Hub (start_idx:mid_idx) = linspace(s.Vws_CutIn + (i-1) * step_increment, s.Vws_CutIn + i * step_increment, step_size);

        % Constant Step
        if end_idx <= s.Nws
            s.WS_Hub(mid_idx+1:end_idx) = s.Vws_CutIn + i * step_increment;
        else
            s.WS_Hub(mid_idx+1:end) = s.Vws_CutIn + i * step_increment;
        end
    end
    s.WS_Hub = s.WS_Hub';

    for iit = 1: s.N_Vm
        s.Vm(iit) = mean(s.WS_Hub(1,s.idxFFT_0(iit):s.idxFFT_f(iit)));     
    end


    % ---------- WIND CONDITIONS ACCORDING IEC-61400-1 ----------                 
    who.Vws_meanHub = 'Average Wind Speed ​​at the height of the Cube, in [m/s]. This value is used to calculate the parameters of the Kaimal Spectrum and the IEC 614001-1 Standard.';                                               
    s.Vws_meanHub = s.Vm(1);
    for iim = 1:(s.N_Vm)  
        if iim == 1                
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        else
            s.Vws_meanHub = s.Vm(iim-1);  
            System_WindFieldIEC614001_1('logical_instance_06'); % WIND CONDITIONS
        end % if iim == 1
    end % for iim = 1:(s.N_Vm) 


    % ---------- THE WIND PROFILE IN CERTAIN WIND CONDITIONS ----------          
    who.Vm_Ugrid = 'Wind Profile of the Medium-Long Duration component (Mean Wind Speed) at the Grid, in [m/s]. The dimension of this vector is ((Nz_grid*Ny_grid) x Nws) or (Nt x Nws).';
    s.Vm_Ugrid = ones(s.Nt,1)*s.Nfft_vm;  

    for iit = 1:(s.N_Vm) 
        s.sigma_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit)); 
        s.sigma_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));    
        s.sigma_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.sigma_3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));                 
        s.L1_x(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L1(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L2_y(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L2(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.L3_z(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.L3(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Lcc(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Lc(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));
        s.Vws_AverageHub(s.idxPSD_0(iit):s.idxPSD_f(iit)) = s.Vm(iit)*s.Npsd_vm(s.idxPSD_0(iit):s.idxPSD_f(iit));            
        s.Vm_Ugrid(:,s.idxFFT_0(iit):s.idxFFT_f(iit)) = s.WindProfile_grid(:,iit)*ones(1,s.Nws_tm(iit));      
    end 

    % ---- Power Spectra (Kaimal Spectrum, See equation C.14 of Annex C.3 of IEC 61400-1) ----------
    who.S1 = 'The Single-Sided Spectrum (Auto-Spectrum) or Positive Amplitude Spectrum Longitudinal Velocity Component (Sx), in [m^2/s^3]. The dimension of this vector is (1 x N_fp) for each value of Vm.'; 
    s.S1 = ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)));

    % ---------- WIND FIELD DISTRIBUTED ON THE GRID ----------    
    who.WindField_Grid = 'Actual Wind Field distributed on the Grid, in time domain and in [m/s].';
    s.WindField_Grid = zeros(s.Nt, s.Nws,3); 
    s.WindField_Grid(:,:,1) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,2) = 0 + s.Vm_Ugrid; 
    s.WindField_Grid(:,:,3) = 0 + s.Vm_Ugrid; 

    s.WindField_Grid( s.idxsV_hub ,:,1) = s.WS_Hub;    


    % ---------- WIND FIELD CIRCUMSCRIBED IN THE ROTOR DISK ----------  
    who.WindField_Disk = 'Actual Wind Field circumscribed in the rotor Disk, in [m/s].';
    s.WindField_Disk = zeros(s.Length_Disk, s.Nws,3); 
    s.WindField_Disk(:,:,1) = s.WindField_Grid(s.idxsV_Disk,:,1);   
    s.WindField_Disk(:,:,2) = s.WindField_Grid(s.idxsV_Disk,:,2); 
    s.WindField_Disk(:,:,3) = s.WindField_Grid(s.idxsV_Disk,:,3);
    

    % ----- Starting analysis of the interaction between wind and wind turbine -----
    who.WindField_Grid_WT = 'Actual Wind Speed on the Grid and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Grid_WT = s.WindField_Grid;


    % ---------------- Update Wind Field on the Disc --------------------   
    who.WindField_Disk_WT = 'Actual Wind Speed ​​circumscribed within the Rotor Disc and with interaction with the wind turbine, in time domain and  in [m/s].';        
    s.WindField_Disk_WT(:,:,1) = s.WindField_Grid_WT(s.idxsV_Disk,:,1);   
    s.WindField_Disk_WT(:,:,2) = s.WindField_Grid_WT(s.idxsV_Disk,:,2); 
    s.WindField_Disk_WT(:,:,3) = s.WindField_Grid_WT(s.idxsV_Disk,:,3);   


    % ---------- WIND SPEED AT HUB HEIGHT.----------
    who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
    s.WindSpeed_Hub = zeros(1, s.Nws);
    s.WindSpeed_Hub = s.WindField_Grid(s.idxsV_DiskHub,:,1);  

    who.WindSpeed_Hub_p = 'Actual Wind speed at the rotor hub height, in frequency domain.';
    s.WindSpeed_Hub_p = fft( s.WindSpeed_Hub , s.Nfp, 2); 

    who.Vm_hub = 'Mean Wind speed at the rotor hub height, in [m/s].';
    s.Vm_hub = s.Vm_Ugrid(s.idxsV_hub,:);


    % ----- Effective Wind Speed ​​with spatial effect and without rotational effect -----
    who.Uews_sp = 'Actual Effective Wind Speed ​​with spatial effect, without rotational effect and in the time domain, in [m/s].';    
    s.Uews_sp = s.WS_Hub; 
        % NOTE: Disregard that the EWS is the average of the wind field.


    % ---------- Effective Wind Speed ​​with spatial and rotational effect ----------
    who.Uews_rt = 'Effective Wind Speed ​​with spatial and rotational effect, in [m/s].';    
    s.Uews_rt = s.Uews_sp;
        % NOTE: Disregard that the EWS is the average of the wind field  and rotational effects.



    % ------ Effective Wind Speed (full signal considered) ----------   
    if s.Option06f6 == 1
        who.Uews_full = 'Effective Wind Speed ​​with spatial, rotational and without relative motion effects, in [m/s].';
        s.Uews_full = s.Uews_rt ;
        %
    else
        who.Uews_full = 'Effective Wind Speed ​​with only spatial effect and without relative motion effects, in [m/s].';        
        s.Uews_full = s.Uews_sp ;
        %
    end

    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    s.Vw_10SWL = s.WindField_Grid(s.idxsV_Vswl1hour,:,1) ;


    % Organizing output results 
    Wind_IEC614001_1.sigma_x = s.sigma_x; Wind_IEC614001_1.sigma_y = s.sigma_y; Wind_IEC614001_1.sigma_z = s.sigma_z; Wind_IEC614001_1.L1_x = s.L1_x; Wind_IEC614001_1.L2_y = s.L2_y; Wind_IEC614001_1.L3_z = s.L3_z; s.Lcc = s.Lcc; Wind_IEC614001_1.Vws_AverageHub = s.Vws_AverageHub; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; Wind_IEC614001_1.S1 = s.S1;           
    Wind_IEC614001_1.WindField_Grid = s.WindField_Grid; Wind_IEC614001_1.Vm_Ugrid = s.Vm_Ugrid; 
    Wind_IEC614001_1.WindField_Grid_WT = s.WindField_Grid_WT;    
    Wind_IEC614001_1.WindField_Disk = s.WindField_Disk; Wind_IEC614001_1.WindField_Disk_WT = s.WindField_Disk_WT;    
    Wind_IEC614001_1.WindSpeed_Hub = s.WindSpeed_Hub; Wind_IEC614001_1.WindSpeed_Hub_p = s.WindSpeed_Hub_p; Wind_IEC614001_1.Vm_hub = s.Vm_hub;
    Wind_IEC614001_1.Uews_sp = s.Uews_sp; Wind_IEC614001_1.Uews_rt = s.Uews_rt; Wind_IEC614001_1.Uews_full = s.Uews_full;
    Wind_IEC614001_1.Vw_10SWL = s.Vw_10SWL;


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);



    % Calling the next logic instance  
    if s.Option09f6 == 2 % Plot Figures
        System_WindFieldIEC614001_1('logical_instance_15'); 
    end



elseif strcmp(action, 'logical_instance_15')
%==================== LOGICAL INSTANCE 15 ====================
%=============================================================    
    % PLOT FIXED POINT WIND SPEED RESULTS (OFFLINE): 
    % Purpose of this Logical Instance: plot results related to values 
    % ​​developed and studied in this recursive function file. In addition,
    % you can perform data analysis and export values.


                     % #### WIND SPEED AT FIXED POINT % ####       

    % ------- Wind Speed at desire fixed Point ------  
    s.Timews_plot = s.Time_ws(1,1:s.Nws);    
    s.indexFixedPoint = s.idxsV_hub; % Use the chosen grid point for the plot

    if s.Option03f1 == 2           
        s.WindSpeed_FixedPoint = s.WindField_Grid(s.indexFixedPoint, :,1);
        s.WindSpeed_FixedPoint_p = s.WindField_Grid_p(s.indexFixedPoint, :,1);        
    else
        s.WindSpeed_FixedPoint  = s.WindSpeed_Hub;  
        s.WindSpeed_FixedPoint_p  = s.WindSpeed_Hub_p;          
    end


    % ------- The Power Spectral Density  (PSD)------    
    who.fpw_WSFixedPoint = 'Estimated positive frequency of the wind field at fixed grid points.';
    who.PSDpw_WSFixedPoint = 'Estimated Power Spectrum Density (PSD) of the wind field at fixed grid points.';
    [s.PSDpw_WSFixedPoint, s.fpw_WSFixedPoint] = pwelch( s.WindSpeed_FixedPoint, [], [], s.Nws, s.SampleF_Wind);
    s.PSDpw_WSFixedPoint = s.PSDpw_WSFixedPoint(2:end)';
    s.fpw_WSFixedPoint = s.fpw_WSFixedPoint(2:end)';

    who.KaimalSpectrum = 'The Kaimal spectrum with the power law adopting exponent (-5/3) at high frequencies.';
    s.KaimalSpectrum = s.S1; % s.S1 == ((4.*s.sigma_x.^2.*(s.L1_x./s.Vws_AverageHub))./( (1 + (6.*s.fp.*(s.L1_x./s.Vws_AverageHub)) ).^(5/3)))

    if s.Option03f1 == 3
        who.vonKarmanSpectrum = 'The von Karman spectrum with the power law adopting exponent (-5/6) at high frequencies..';
        s.vonKarmanSpectrum = s.S1_Karman; % s.S1_Karman = ((4 .* s.sigma_x.^2 .* (s.L1_x ./ s.Vws_AverageHub)) ./ ((1 + 70.8 .* (s.fp .* (s.L1_x ./ s.Vws_AverageHub)).^2).^(5/6)));
    end


    % ------- Plot Turbulent Wind Spectra at fixed point ------ 
    if s.Option03f1 == 3
        figure;
        loglog(s.fp, s.vonKarmanSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of von Karman Theoretical Spectrum of the longitudinal component.'); 
        hold on;
        loglog(s.fp, s.KaimalSpectrum, 'y', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');        
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point.');         
        hold off;    
        title('Comparison of the Power Spectrum Density (PSD) of the theoretical von Karman spectrum and the wind speed ​​signal at a fixed point.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint]), 1.03*max([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint])]); 
        grid on;  
        legend('show');     
    else
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.'); 
        hold on;
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point.'); 
        hold off;    
        title('Comparison of the Power Spectrum Density (PSD) of the theoretical Kaimal spectrum and the wind speed ​​signal at a fixed point.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint])]); 
        grid on;  
        legend('show');     
    end


    % ------- Plot Turbulent Wind Speed at fixed point ------  
    figure;
    plot(s.Timews_plot , s.WindSpeed_FixedPoint, 'b');
    title('Wind speed at a fixed point on the grid and without interaction with the wind turbine.');        
    xlabel('Time (s)');
    ylabel('Velocity (m/s^2)');
    xlim([0, max(s.Timews_plot)]);
    ylim([min(s.WindSpeed_FixedPoint )*0.97, max(s.WindSpeed_FixedPoint )*1.03]); 
    grid on; 



    % ------Plot Effective Wind Speed adopted ------  
    if s.Option03f1 == 1 || s.Option03f1 == 4 || s.Option03f1 == 5 || s.Option03f1 == 6 || s.Option03f1 == 7
        figure;
        plot(s.Timews_plot , s.Uews_rt, 'b');
        title('Effective Wind Speed ​​used in the simulation..');        
        xlabel('Time (s)');
        ylabel('Velocity (m/s^2)');
        xlim([0, max(s.Timews_plot)]);
        ylim([min(s.Uews_rt)*0.97, max( s.Uews_rt)*1.03]); 
        grid on;   
    end % if s.Option03f1 == 1 || s.Option03f1 == 4 || s.Option03f1 == 5 || s.Option03f1 == 6 || s.Option03f1 == 7


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Calling the next logic instance    
    if s.Option03f1 == 2 || s.Option03f1 == 3
        System_WindFieldIEC614001_1('logical_instance_16'); 
    end


elseif strcmp(action, 'logical_instance_16')
%==================== LOGICAL INSTANCE 16 ====================
%=============================================================    
    % PLOTTING EFFECTIVE WIND SPEED RESULTS WITH SPATIAL EFFECT (OFFLINE): 
    % Purpose of this Logical Instance: plot results related to values 
    % ​​developed and studied in this recursive function file. In addition,
    % you can perform data analysis and export values.


                         % #### SPATIAL EFFECT % ####       


    % ------- The Power Spectral Density  (PSD)------         
    if s.Option03f1 == 2 || s.Option03f1 == 3 

        % Spatial effect with simple average
        if s.Option05f6 == 1 || s.Option05f6 == 4 
            who.fppwUews_sp1 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect (simple average of the wind field).';
            who.PSDpwUews_sp1 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect (simple average of the wind field).';
            [s.PSDpwUews_sp1, s.fppwUews_sp1] = pwelch( s.Uews_sp1, [], [], s.Nws, s.SampleF_Wind);
            s.fppwUews_sp1 = s.fppwUews_sp1(2:end)';
            s.PSDpwUews_sp1 = s.PSDpwUews_sp1(2:end)';
        end

        % Spatial effect with weighted average
        if s.Option05f6 == 2 || s.Option05f6 == 4 
            who.fppwUews_sp2 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect (weighted average of the wind field).';
            who.PSDpwUews_sp2 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect (weighted average of the wind field).';
            [s.PSDpwUews_sp2, s.fppwUews_sp2] = pwelch( s.Uews_sp2, [], [], s.Nws, s.SampleF_Wind);   
            s.fppwUews_sp2 = s.fppwUews_sp2(2:end)';      
            s.PSDpwUews_sp2 = s.PSDpwUews_sp2(2:end)';
        end

        % Spatial effect with spatial filter (transfer function)        
        if s.Option05f6 == 3 || s.Option05f6 == 4  || s.Option05f6 == 5 
            who.fppwUews_sp3 = 'Estimated Positive Frequency of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
            who.PSDpwUews_sp3 = 'Estimated Power Spectrum Density (PSD) of Effective Wind Speed ​​with spatial effect of Spatial Filter.';
            [s.PSDpwUews_sp3, s.fppwUews_sp3] = pwelch( s.Uews_sp3, [], [], s.Nws, s.SampleF_Wind);      
            s.fppwUews_sp3 = s.fppwUews_sp3(2:end)';
            s.PSDpwUews_sp3 = s.PSDpwUews_sp3(2:end)';  
        end

        who.fpwUews_sp = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect.';
        who.PSDpwUews_sp = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect.';
        [s.PSDpwUews_sp, s.fpwUews_sp] = pwelch( s.Uews_sp, [], [], s.Nws, s.SampleF_Wind);
        s.fpwUews_sp = s.fpwUews_sp(2:end)'; 
        s.PSDpwUews_sp = s.PSDpwUews_sp(2:end)';
    else
        who.fpwUews_sp = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial effect.';
        who.PSDpwUews_sp = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial effect.';
        [s.PSDpwUews_sp, s.fpwUews_sp] = pwelch( s.Uews_sp, [], [], s.Nws, s.SampleF_Wind);
        s.fpwUews_sp = s.fpwUews_sp(2:end)'; 
        s.PSDpwUews_sp = s.PSDpwUews_sp(2:end)';        
    end % if s.Option03f1 == 2 || s.Option03f1 == 3


    % ------Plot individual PSD Time Series Effective Wind Speed with spatial effect​ adopted ------  
    if s.Option03f1 == 1 || s.Option03f1 == 4 || s.Option03f1 == 5 || s.Option03f1 == 6 || s.Option03f1 == 7
        % Plot PSD analysis         
        figure;
        loglog(s.fpwUews_sp, s.PSDpwUews_sp, 'm', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect.');  
        title('The Power Spectrum Density (PSD) of the Effective Wind Speed with spatial effect​.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min(s.PSDpwUews_sp), 1.03*max(s.PSDpwUews_sp)]); 
        grid on;  
        legend('show');      
    end % if s.Option03f1 == 2 || s.Option03f1 == 3


    % ----- Analysis 1: Effective Wind Speed ​​with spatial effect (Simple Average) -----    
    if s.Option05f6 == 1 
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fppwUews_sp1, s.PSDpwUews_sp1, 'r', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (simple average of the wind field).');               
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed with spatial effect.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1])]); 
        grid on;  
        legend('show');

        % Plot Time series  
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_sp1, 'r', 'DisplayName', 'Effective Wind Speed with spatial effect (simple average of the wind field)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (simple average of the wind field).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show'); 
    end % if s.Option05f6 == 1 || s.Option05f6 == 4 



    % ----- Analysis 2: Effective Wind Speed ​​with spatial effect (Weighted Average) -----        
    if s.Option05f6 == 2
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fppwUews_sp2, s.PSDpwUews_sp2, 'g', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (weighted average of the wind field).');               
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, Fixed Point Wind Speed, and Effective Wind Speed with spatial effect.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp2]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp2])]); 
        grid on;  
        legend('show');

        % Plot Time series  
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_sp2, 'g', 'DisplayName', 'Effective Wind Speed with spatial effect (Weighted Average of the wind field)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (weighted average of the wind field).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.02*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');  

        figure; 
        plot(s.Timews_plot, s.Uews_sp1, 'r', 'DisplayName', 'Effective Wind Speed with spatial effect (simple average of the wind field)'); 
        hold on; 
        plot(s.Timews_plot, s.Uews_sp2, 'g', 'DisplayName', 'Effective Wind Speed with spatial effect (Weighted Average of the wind field)');
        hold off; 
        title('Comparison of Effective Wind Speeds (simple and weighted average).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.Uews_sp1 s.Uews_sp2]), 1.03*max([s.Uews_sp1 s.Uews_sp2])]); 
        grid on;
        legend('show');   
    end % if s.Option05f6 == 2 || s.Option05f6 == 4   


    % ----- Analysis 3: Effective Wind Speed ​​with spatial effect (spatial filter) -----     
    if s.Option05f6 == 3  
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fppwUews_sp3, s.PSDpwUews_sp3, 'm', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (spatial filter).');               
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed with spatial effect.');   
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3])]); 
        grid on;  
        legend('show');

        % Plot Time series        
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');
        hold on; 
        plot(s.Timews_plot, s.Uews_sp3, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect (spatial filter)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (spatial filter).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');  

        figure; 
        plot(s.Timews_plot, s.Uews_sp1, 'r', 'DisplayName', 'Effective Wind Speed with spatial effect (simple average of the wind field)'); 
        hold on; 
        plot(s.Timews_plot, s.Uews_sp3, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect (spatial filter)');
        hold off; 
        title('Comparison of Effective Wind Speeds (simple average and Transfer Function).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.Uews_sp1 s.Uews_sp3]), 1.03*max([s.Uews_sp1 s.Uews_sp3])]); 
        grid on;
        legend('show');   

    end % if s.Option05f6 == 3 || s.Option05f6 == 4 


    % ----- Analysis 4: Comparison of Effective Wind Speeds with different spatial effect -----     
    if s.Option05f6 == 4  
        % Plot PSD analysis          
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point.');   
        loglog(s.fpwUews_sp, s.PSDpwUews_sp, 'm', 'DisplayName', 'PSD of Effective Wind Speed adopted.');               
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal and the Wind Speed ​​at a fixed point and Effective Wind Speed adopted.');        
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp])]); 
        grid on;  
        legend('show');

        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');  
        loglog(s.fppwUews_sp1, s.PSDpwUews_sp1, 'r', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (simple average of the wind field).');            
        loglog(s.fppwUews_sp2, s.PSDpwUews_sp2, 'g', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (weighted average of the wind field).');          
        loglog(s.fppwUews_sp3, s.PSDpwUews_sp3, 'm', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (spatial filter).');                      
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speeds with different spatial effects.');   
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1 s.PSDpwUews_sp2 s.PSDpwUews_sp3]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1 s.PSDpwUews_sp2 s.PSDpwUews_sp3])]); 
        grid on;  
        legend('show');

        % Plot Time series 
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_sp, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect.');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed with spatial effect.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show'); 


        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_sp1, 'r', 'DisplayName', 'Effective Wind Speed with spatial effect (simple average of the wind field)');         
        plot(s.Timews_plot, s.Uews_sp2, 'g', 'DisplayName', 'Effective Wind Speed with spatial effect (Weighted Average of the wind field)');
        plot(s.Timews_plot, s.Uews_sp3, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect (spatial filter)');            
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and different methods to obtain Effective Wind Speed ​​with spatial effect.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.WindSpeed_FixedPoint s.Uews_sp1 s.Uews_sp3 s.Uews_sp2]), 1.03*max([s.WindSpeed_FixedPoint s.Uews_sp1 s.Uews_sp3 s.Uews_sp2])]);
        grid on;
        legend('show');  

        figure; 
        plot(s.Timews_plot, s.Uews_sp3, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect (spatial filter)'); 
        hold on; 
        plot(s.Timews_plot, s.Uews_sp2, 'g', 'DisplayName', 'Effective Wind Speed with spatial effect (Weighted Average of the wind field)');
        plot(s.Timews_plot, s.Uews_sp1, 'r', 'DisplayName', 'Effective Wind Speed with spatial effect (simple average of the wind field)');        
        hold off; 
        title('Comparison of different methods to obtain Effective Wind Speed ​​with spatial effect.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.Uews_sp1 s.Uews_sp3 s.Uews_sp2]), 1.03*max([s.Uews_sp1 s.Uews_sp3 s.Uews_sp2])]); 
        grid on;
        legend('show');   
      
    end % if s.Option05f6 == 4 
                


    % ----- Analysis 3 or 5: Effective Wind Speed ​​with spatial effect (spatial filter + von Karman) -----     
    if s.Option05f6 == 5 
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.vonKarmanSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of von Karman Theoretical Spectrum of the longitudinal component.');                 
        hold on; 
        loglog(s.fp, s.KaimalSpectrum, 'y', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');        
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fp, s.PSDpwUews_sp3, 'm', 'DisplayName', 'PSD of Effective Wind Speed with spatial effect (spatial filter).');               
        hold off;    
        title('Comparison of PSD: Theoretical von Karman, Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed with spatial effect.');   
        xlabel('Frequency (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3]), 1.03*max([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3])]); 
        grid on;  
        legend('show');

        % Plot Time series        
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');
        hold on; 
        plot(s.Timews_plot, s.Uews_sp3, 'm', 'DisplayName', 'Effective Wind Speed with spatial effect (spatial filter)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (spatial filter).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');   
       
    end % if s.Option05f6 == 3 || s.Option05f6 == 4 


            
   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


   
    % Calling the next logic instance   
    if s.Option09f6 == 2
        System_WindFieldIEC614001_1('logical_instance_17'); 
    end


elseif strcmp(action, 'logical_instance_17')
%==================== LOGICAL INSTANCE 17 ====================
%=============================================================    
    % PLOT EFFECTIVE WIND SPEED RESULTS WITH SPATIAL AND ROTATIONAL EFFECTS (OFFLINE): 
    % Purpose of this Logical Instance: plot results related to values 
    % ​​developed and studied in this recursive function file. In addition,
    % you can perform data analysis and export values.


                         % #### ROTATIONAL EFFECT % ####      


    % ------- The Power Spectral Density  (PSD)------         
    if s.Option03f1 == 2 || s.Option03f1 == 3   

        % Spatial effect with simple average
        if s.Option05f6 == 1 || s.Option05f6 == 4 
            who.fppwUews_sp1 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
            who.PSDwUews_rt1 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Simple Average) and rotational effects.';
            [s.PSDwUews_rt1, s.fpwUews_rt1] = pwelch( s.Uews_rt1, [], [], s.Nws, s.SampleF_Wind);
            s.fpwUews_rt1 = s.fpwUews_rt1(2:end)';
            s.PSDwUews_rt1 = s.PSDwUews_rt1(2:end)';
        end

        % Spatial effect with weighted average
        if s.Option05f6 == 2 || s.Option05f6 == 4 
            who.fpwUews_rt2 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
            who.PSDwUews_rt2 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (Weighted Average) and rotational effects.';
            % s.PSDwUews_rt2 = (abs(s.Uews_rt2_p).^2) / (s.SampleF_Wind * s.Nws);            
            [s.PSDwUews_rt2, s.fpwUews_rt2] = pwelch( s.Uews_rt2, [], [], s.Nws, s.SampleF_Wind);  
            s.fpwUews_rt2 = s.fpwUews_rt2(2:end)';      
            s.PSDwUews_rt2 = s.PSDwUews_rt2(2:end)';             
        end
        


        % Spatial effect with spatial filter (transfer function)    
        if s.Option05f6 == 3 || s.Option05f6 == 4  || s.Option05f6 == 5 
            who.fpwUews_rt3 = 'Estimated Positive Frequency of the Effective Wind Speed ​​with spatial (spatial filter) and rotational effects.';
            who.PSDwUews_rt3 = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with spatial (spatial filter) and rotational effects.';
            [s.PSDwUews_rt3, s.fpwUews_rt3] = pwelch( s.Uews_rt3, [], [], s.Nws, s.SampleF_Wind);  
            s.fpwUews_rt3 = s.fpwUews_rt3(2:end)';
            s.PSDwUews_rt3 = s.PSDwUews_rt3(2:end)';  
        end

        who.fpwUews_rt = 'Estimated Positive FreqVewsncy of the Effective Wind Speed ​​with rotational and spatial effect.';
        who.PSDwUews_rt = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with rotational and spatial effect.';
        [s.PSDwUews_rt, s.fpwUews_rt] = pwelch( s.Uews_rt, [], [], s.Nws, s.SampleF_Wind);
        s.fpwUews_rt = s.fpwUews_rt(2:end)'; 
        s.PSDwUews_rt = s.PSDwUews_rt(2:end)';
    else
        who.fpwUews_rt = 'Estimated Positive FreqVewsncy of the Effective Wind Speed ​​with rotational and spatial effect.';
        who.PSDwUews_rt = 'Estimated Power Spectrum Density (PSD) of the Effective Wind Speed ​​with rotational and spatial effect.';
        [s.PSDwUews_rt, s.fpwUews_rt] = pwelch( s.Uews_rt, [], [], s.Nws, s.SampleF_Wind);
        s.fpwUews_rt = s.fpwUews_rt(2:end)'; 
        s.PSDwUews_rt = s.PSDwUews_rt(2:end)';
    end % if s.Option03f1 == 2 || s.Option03f1 == 3 



    % ------Plot individual PSD Time Series Effective Wind Speed adopted ------  
    if s.Option03f1 == 1 || s.Option03f1 == 4 || s.Option03f1 == 5 || s.Option03f1 == 6 || s.Option03f1 == 7
        % Plot PSD analysis         
        figure;
        loglog(s.fpwUews_rt, s.PSDwUews_rt, 'm', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects.');  
        title('The Power Spectrum Density (PSD) of the wind speed ​​signal at a fixed point.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min(s.PSDwUews_rt), 1.03*max(s.PSDwUews_rt)]); 
        grid on;  
        legend('show');     
    end 


    % ----- Analysis 1: Effective Wind Speed with rotational and spatial effects (Simple Average) -----    
    if s.Option05f6 == 1
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fpwUews_rt1, s.PSDwUews_rt1, 'r', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (simple average of the wind field).');               
        loglog(s.fppwUews_sp1, s.PSDpwUews_sp1, 'c', 'DisplayName', 'PSD of Effective Wind Speed with only spatial effect (simple average of the wind field).');            
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed ​​with rotational and spatial effects.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1 s.PSDwUews_rt1]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp1 s.PSDwUews_rt1])]); 
        grid on;  
        legend('show');

        % Plot Time series  
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt1, 'r', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (simple average of the wind field)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show'); 

        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt1, 'r', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (simple average of the wind field)');
        plot(s.Timews_plot, s.Uews_sp1, 'c', 'DisplayName', 'Effective Wind Speed with only spatial effect (simple average of the wind field)');        
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');         
    end % if s.Option05f6 == 1 || s.Option05f6 == 4 



    % ----- Analysis 2: Effective Wind Speed with rotational and spatial effects (Weighted Average) -----        
    if s.Option05f6 == 2 
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fpwUews_rt2(1:end-1), s.PSDwUews_rt2, 'g', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (weighted average of the wind field).');               
        loglog(s.fpwUews_rt2(1:end-1), s.PSDpwUews_sp2, 'r', 'DisplayName', 'PSD of Effective Wind Speed with only spatial effect (weighted average of the wind field).');          
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, Fixed Point Wind Speed, and Effective Wind Speed ​​with rotational and spatial effects.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp2 s.PSDwUews_rt2]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp2 s.PSDwUews_rt2])]); 
        grid on;  
        legend('show');

        % Plot Time series  
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt2, 'g', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (Weighted Average of the wind field)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.02*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');  
        
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt2, 'g', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (Weighted Average of the wind field)');
        plot(s.Timews_plot, s.Uews_sp2, 'r', 'DisplayName', 'Effective Wind Speed with only spatial effect (Weighted Average of the wind field)');      
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');
     
    end % if s.Option05f6 == 2 || s.Option05f6 == 4     


    % ----- Analysis 3: Effective Wind Speed with rotational and spatial effects (spatial filter) -----     
    if s.Option05f6 == 3 
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fpwUews_rt3, s.PSDwUews_rt3, 'm', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (spatial filter).');               
        loglog(s.fppwUews_sp3, s.PSDpwUews_sp3, 'c', 'DisplayName', 'PSD of Effective Wind Speed with only spatial effect (spatial filter).');          
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed ​​with rotational and spatial effects.');   
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3 s.PSDwUews_rt3]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3 s.PSDwUews_rt3])]); 
        grid on;  
        legend('show');

        % Plot Time series        
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');
        hold on; 
        plot(s.Timews_plot, s.Uews_rt3, 'm', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (spatial filter)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (spatial filter).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show'); 

        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');
        hold on; 
        plot(s.Timews_plot, s.Uews_rt3, 'm', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (spatial filter)');        
        plot(s.Timews_plot, s.Uews_sp3, 'c', 'DisplayName', 'Effective Wind Speed with only spatial effect (Spatial Filter)');            
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');     
    end % if s.Option05f6 == 3



    % ----- Analysis 4: Comparison of Effective Wind Speeds with different spatial effect -----     
    if s.Option05f6 == 4  
        % Plot PSD analysis 
        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point.');   
        loglog(s.fpwUews_rt, s.PSDwUews_rt, 'm', 'DisplayName', 'PSD of Effective Wind Speed adopted ​​with rotational and spatial effects.');  
        loglog(s.fpwUews_sp, s.PSDpwUews_sp, 'c', 'DisplayName', 'PSD of Effective Wind Speed  with only spatial effect.');         
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, the Wind Speed ​​at a fixed point and ​​Effective Wind Speed with rotational and spatial effects.');        
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp s.PSDwUews_rt]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp s.PSDwUews_rt])]); 
        grid on;  
        legend('show');

        figure;
        loglog(s.fp, s.KaimalSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');                 
        hold on;      
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');  
        loglog(s.fpwUews_rt1, s.PSDwUews_rt1, 'r', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (simple average of the wind field).');            
        loglog(s.fpwUews_rt2, s.PSDwUews_rt2, 'g', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (weighted average of the wind field).');          
        loglog(s.fpwUews_rt3, s.PSDwUews_rt3, 'm', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (spatial filter).');                      
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speeds with rotational effect and different spatial effects.');   
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDwUews_rt1 s.PSDwUews_rt2 s.PSDwUews_rt3]), 1.03*max([s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDwUews_rt1 s.PSDwUews_rt2 s.PSDwUews_rt3])]); 
        grid on;  
        legend('show');
    

        % Plot Time series  
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt , 'm', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects.');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');   

        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');       
        hold on; 
        plot(s.Timews_plot, s.Uews_rt1, 'r', 'DisplayName', 'Effective Wind Speed with rotational and spatial effect (simple average of the wind field)');         
        plot(s.Timews_plot, s.Uews_rt2, 'g', 'DisplayName', 'Effective Wind Speed with rotational and spatial effect (Weighted Average of the wind field)');
        plot(s.Timews_plot, s.Uews_rt3, 'm', 'DisplayName', 'Effective Wind Speed with rotational and spatial effect (Spatial Filter)');            
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point and different methods to obtain Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.WindSpeed_FixedPoint s.Uews_rt1 s.Uews_rt3 s.Uews_rt2]), 1.03*max([s.WindSpeed_FixedPoint s.Uews_rt1 s.Uews_rt3 s.Uews_rt2])]);
        grid on;
        legend('show');


        figure; 
        plot(s.Timews_plot, s.Uews_rt3, 'm', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (spatial filter)');          
        hold on;      
        plot(s.Timews_plot, s.Uews_rt2, 'g', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (Weighted Average of the wind field)');        
        plot(s.Timews_plot, s.Uews_rt1, 'r', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (simple average of the wind field)');          
        hold off; 
        title('Comparison of Effective Wind Speeds different methods to obtain Effective Wind Speed ​​with rotational and spatial effects.');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);  
        ylim([0.97*min([s.Uews_rt1 s.Uews_rt3 s.Uews_rt2]), 1.03*max([s.Uews_rt1 s.Uews_rt3 s.Uews_rt2])]); 
        grid on;
        legend('show');   
    end % if s.Option05f6 == 4 
   

    % ----- Analysis 3 or 5: Effective Wind Speed with rotational and spatial effects (spatial filter + von Karman) -----     
    if s.Option05f6 == 5
        % Plot PSD analysis         
        figure;
        loglog(s.fp, s.vonKarmanSpectrum, 'k', 'linewidth', 3, 'DisplayName', 'PSD of von Karman Theoretical Spectrum of the longitudinal component.');                 
        hold on;   
        loglog(s.fp, s.KaimalSpectrum, 'y', 'linewidth', 3, 'DisplayName', 'PSD of Kaimal Theoretical Spectrum of the longitudinal component.');           
        loglog(s.fpw_WSFixedPoint, s.PSDpw_WSFixedPoint, 'b', 'DisplayName', 'PSD of Wind Speed at fixed point without turbine interaction');   
        loglog(s.fpwUews_rt3, s.PSDwUews_rt3, 'm', 'DisplayName', 'PSD of Effective Wind Speed ​​with rotational and spatial effects (spatial filter).');               
        loglog(s.fppwUews_sp3, s.PSDpwUews_sp3, 'c', 'DisplayName', 'PSD of Effective Wind Speed with only spatial effect (spatial filter).');          
        hold off;    
        title('Comparison of PSD: Theoretical Kaimal, fixed point Wind Speed, and Effective Wind Speed ​​with rotational and spatial effects.');   
        xlabel('FreqVewsncy (Hz)');
        ylabel('PSD [(m^s/s^2)*(1/Hz)]');
        set(gca, 'XScale', 'log');
        set(gca, 'YScale', 'log');
        xlim([s.df_ws, (s.SampleF_Wind*0.5)]);
        ylim([0.97*min([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3 s.PSDwUews_rt3]), 1.03*max([s.vonKarmanSpectrum s.KaimalSpectrum s.PSDpw_WSFixedPoint s.PSDpwUews_sp3 s.PSDwUews_rt3])]); 
        grid on;  
        legend('show');

        % Plot Time series        
        figure; 
        plot(s.Timews_plot, s.WindSpeed_FixedPoint, 'b', 'DisplayName', 'Wind Speed of a fixed point on the grid');
        hold on; 
        plot(s.Timews_plot, s.Uews_rt3, 'm', 'DisplayName', 'Effective Wind Speed ​​with rotational and spatial effects (spatial filter)');
        hold off; 
        title('Comparison between Wind Speed at a Fixed Point on the Grid and Effective Wind Speed (spatial filter).');
        xlabel('time [seg]');
        ylabel('EWS (m/s^2)');
        xlim([(min(s.Timews_plot)), max(s.Timews_plot)]);
        ylim([0.97*min(s.WindSpeed_FixedPoint), 1.03*max(s.WindSpeed_FixedPoint)]); 
        grid on;
        legend('show');   
   
    end % if s.Option05f6 == 5


   % Assign value to variable in specified workspace
   assignin('base', 's', s);
   assignin('base', 'who', who);
   assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);


    % Further processing or end of the recursive calls


%=============================================================  
end % if strcmp(action, 'logical_instance_01')



% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'Wind_IEC614001_1', Wind_IEC614001_1);



% #######################################################################
end