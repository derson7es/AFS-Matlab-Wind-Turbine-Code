function System_WavesCurrentsIEC614001_3(action)
% ########## EXTERNAL SEA AND CURRENT CONDITIONS AND THE APPLICATION OF HYDRODYNAMIC LOADS ##########
% ###################################################################################################

% ABOUT AUTHOR:
% Code developed by Anderson Francisco Silva, a student at the University 
% of São Paulo, in defense of his master's degree in Naval and Ocean 
% Engineering in 2025. Master's dissertation title: Control of wind turbine 
% based on effective wind speed estimation / Silva, Anderson Francisco -- São Paulo, 2025.

% ABOUT UPDATES AND VERSIONS:
% Code Version: This code is in version 04 of August 2025.
% Last edition of this function of this Matlab file: 04 of August 2025.

% PURPOSE OF THIS RECURSIVE FUNCTION: 
% This recursive function contains all the functions of the simulation
% environment to generate the effects of sea waves and currents, according
% to the modeling of the IEC 61400-1-3 standard.


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
    % related to this recursive function "System_WavesCurrentsIEC614001_3.m". 


    % ---- Option 01: Design Situation and Load Case Options ----
    s.Option01f7.Option_01 = 'Option 01 of Recursive Function f7';
    s.Option01f7.about = 'Design Situation and Load Case Options according to IEC 61400-3.';
    s.Option01f7.choose_01 = 'Option01f7 == 1 to choose Design situation case (DLC 1.1) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_02 = 'Option01f7 == 2 to choose Design situation case (DLC 1.2) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_03 = 'Option01f7 == 3 to choose Design situation case (DLC 1.3) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_04 = 'Option01f7 == 4 to choose Design situation case (DLC 1.4) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_05 = 'Option01f7 == 5 to choose Design situation case (DLC 1.5) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_06 = 'Option01f7 == 6 to choose Design situation case (DLC 1.6) Power production of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_07 = 'Option01f7 == 7 to choose Design situation case (DLC 2.1) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_08 = 'Option01f7 == 8 to choose Design situation case (DLC 2.2) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_09 = 'Option01f7 == 9 to choose Design situation case (DLC 2.3) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_10 = 'Option01f7 == 10 to choose Design situation case (DLC 2.4) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_11 = 'Option01f7 == 11 to choose Design situation case (DLC 2.5) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_12 = 'Option01f7 == 12 to choose Design situation case (DLC 3.1) Start up of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_13 = 'Option01f7 == 13 to choose Design situation case (DLC 3.2) Start up of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_14 = 'Option01f7 == 14 to choose Design situation case (DLC 3.3) Start up of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_15 = 'Option01f7 == 15 to choose Design situation case (DLC 4.1) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_16 = 'Option01f7 == 16 to choose Design situation case (DLC 4.2) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_17 = 'Option01f7 == 17 to choose Design situation case (DLC 5.1) Emergency Stop of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_18 = 'Option01f7 == 18 to choose Design situation case (DLC 6.1) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.';    
    s.Option01f7.choose_19 = 'Option01f7 == 19 to choose Design situation case (DLC 6.2) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_20 = 'Option01f7 == 20 to choose Design situation case (DLC 6.3) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.'; 
    s.Option01f7.choose_21 = 'Option01f7 == 21 to choose Design situation case (DLC 6.4) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_22 = 'Option01f7 == 22 to choose Design situation case (DLC 7.1) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.';    
    s.Option01f7.choose_23 = 'Option01f7 == 23 to choose Design situation case (DLC 7.2) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.';
    s.Option01f7.choose_24 = 'Option01f7 == 24 to choose Design situation case (DLC 8.1) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.';    
    s.Option01f7.choose_25 = 'Option01f7 == 25 to choose Design situation case (DLC 8.2) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_26 = 'Option01f7 == 26 to choose Design situation case (DLC 8.3) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.';   
    s.Option01f7.choose_27 = 'Option01f7 == 27 to choose Design situation case (DLC 8.4) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.';  
    s.Option01f7.choose_28 = 'Option01f7 == 28 to choose Other strategies chosen by me (Custom Design situation case).';
    who.Option01f7 = s.Option01f7;
        % Choose your option:
    s.Option01f7 = 1; 
    if (s.Option01f7 >= 1) || (s.Option01f7 <= 28)
        Waves_IEC614001_3.Option01f7 = s.Option01f7;
        Currents_IEC614001_3.Option01f7 = s.Option01f7;
    else
        error('Invalid option selected for option01f7. Please choose 1 to 40 options.');
    end


    % ---- Option 02: Marine Conditions (Sea currents) according to IEC 61400-3 -----
    s.Option02f7.Option_02 = 'Option 02 of Recursive Function f7';
    s.Option02f7.about = 'Marine Conditions (Waves) according to IEC 61400-3 (extreme or severe or normal conditions).';
    s.Option02f7.choose_01 = 'Option02f7 == 1 to choose Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.';
    s.Option02f7.choose_02 = 'Option02f7 == 2 to choose Severe Sea State (SSS), described in section 6.3.3.2.3 of IEC 61400-3 Standard.';
    s.Option02f7.choose_03 = 'Option02f7 == 3 to choose Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.';
    s.Option02f7.choose_04 = 'Option02f7 == 4 to choose Breaking Waves, described in section 6.3.3.2.5 of IEC 61400-3 Standard.';   
    who.Option02f7 = s.Option02f7;
        % Choose your option:
    s.Option02f7 = 1; 
    if s.Option02f7 == 1 || s.Option02f7 == 2 || s.Option02f7 == 3 || s.Option02f7 == 4
        Waves_IEC614001_3.Option02f7 = s.Option02f7;
        Currents_IEC614001_3.Option02f7 = s.Option02f7;
    else
        error('Invalid option selected for Option02f7. Please choose 1 or 2 or 3 or 4.');
    end



    % ---- Option 03: Marine Conditions (Sea currents) according to IEC 61400-3 -----
    s.Option03f7.Option_03 = 'Option 03 of Recursive Function f7';
    s.Option03f7.about = 'Marine Conditions (Sea currents) according to IEC 61400-3 (extreme or normal conditions).';
    s.Option03f7.choose_01 = 'Option02f7 == 1 to choose Sub-Surface Currents (SSC), described in section 6.3.3.3.2 of IEC 61400-3 Standard.';
    s.Option03f7.choose_02 = 'Option02f7 == 2 to choose Wind-generated, Near-Surface Currents (WG NSC), described in section 6.3.3.3.3 of IEC 61400-3 Standard.';
    s.Option03f7.choose_03 = 'Option02f7 == 3 to choose Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.';
    s.Option03f7.choose_04 = 'Option02f7 == 4 to choose Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.';   
    who.Option03f7 = s.Option03f7;
        % Choose your option:
    s.Option03f7 = 1; 
    if s.Option03f7 == 1 || s.Option03f7 == 2 || s.Option03f7 == 3 || s.Option03f7 == 4
        Waves_IEC614001_3.Option03f7 = s.Option03f7;
        Currents_IEC614001_3.Option03f7 = s.Option03f7;        
    else
        error('Invalid option selected for option03f7. Please choose 1 or 2.');
    end

    % ---------- Option 04: Stochastic Wave Model Options ----------
    s.Option04f7.Option_04 = 'Option 04 of Recursive Function f7';
    s.Option04f7.about = 'Stochastic wave model options: the Jonswap and Pierson-Moskowitz spectra.';
    s.Option04f7.choose_01 = 'Option04f7 == 1 to choose the Jonswap spectrum.';
    s.Option04f7.choose_02 = 'Option04f7 == 2 to choose the Pierson-Moskowitz spectrum.';
    who.Option04f7 = s.Option04f7;
        % Choose your option:
    s.Option04f7 = 1; 
    if s.Option04f7 == 1 || s.Option04f7 == 2
        Waves_IEC614001_3.Option04f7 = s.Option04f7;
        Currents_IEC614001_3.Option04f7 = s.Option04f7;        
    else
        error('Invalid option selected for option04f7. Please choose 1 or 2.');
    end

    
    % ---------- Option 05: Wave modelling option ----------
    s.Option05f7.Option_05 = 'Option 05 of Recursive Function f7';
    s.Option05f7.about = 'Wave modelling option: to combine ocean current model with wave model ("Wave plus Current").';
    s.Option05f7.choose_01 = 'Option05f7 == 1 to choose add Current Model in Wave model (Wave plus current).';
    s.Option05f7.choose_02 = 'Option05f7 == 2 to choose NOT add Current Model';  
    who.Option05f7 = s.Option05f7;
        % Choose your option:
    s.Option05f7 = 2; 
    if s.Option05f7 == 1 || s.Option05f7 == 2
        Waves_IEC614001_3.Option05f7 = s.Option05f7;
        Currents_IEC614001_3.Option05f7 = s.Option05f7;        
    else
        error('Invalid option selected for option05f7. Please choose 1 or 2.');
    end 


    % ---------- Option 06: Plot wind turbine results ----------
    who.Option06f7.Option_08 = 'Option 06 of Recursive Function f7';
    who.Option06f7.about = 'Plot wind turbine results of simulation.';
    who.Option06f7.choose_01 = 'Option06f7 == 1 to choose DO NOT plot wind turbine results (simulation).';
    who.Option06f7.choose_02 = 'Option06f7 == 2 to choose PLOT THE MAIN FIGURES of wind turbine results (simulation).';
    who.Option06f7.choose_03 = 'Option06f7 == 3 to choose Plot ALL FIGURES of wind turbine results (simulation).';    
        % Choose your option:
    s.Option06f7 = 2; 
    if s.Option06f7 == 1 || s.Option06f7 == 2 || s.Option06f7 == 3
        RotorDynamics.Option06f7 = s.Option06f7;
    else
        error('Invalid option selected for Option06f7. Please choose 1 or 2 or 3.');
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);
    assignin('base', 'Currents_IEC614001_3', Currents_IEC614001_3);


    % Calling the next logic instance 
    System_LoadsAerodynamics;
    
    

elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES (OFFLINE) BASED ON CHOSEN OPTIONS:
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f7), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system.


    % ------ Wind Speed ​​for Offshore Structure Assembly Model ----------  
    who.Vw_10SWL = 'Wind speed at 10 m height above SWL, in [m/s].';
    Waves_IEC614001_3.Vw_10SWL = s.Vw_10SWL ;
    Currents_IEC614001_3.Vw_10SWL = s.Vw_10SWL ;
    s.Nvw1h = 3600 / s.dt ;
    s.Nvw = length(s.Vw_10SWL) ;
    if s.tf <= 3600
        s.Nvw_1h = 1 ;
    else
        s.Nvw_1h = ceil( s.tf / 3600 ) ;
    end


    
    % -- Values of "Normal Current Model (NCM)" & "Wind-generated, Near-Surface Currents" -- 
    if (s.Option03f7 == 2) || (s.Option03f7 == 3)
        who.WaterDepth = 'The water depth (z), in [m].';
        s.WaterDepth = 0:0.1:20;
        %
    end


    % ---------- Other Parameters ----------        
    who.rho_water = 'Water density in [kg/m^3], under standard conditions at 25ºC and 1 [atm].';
    Waves_IEC614001_3.rho_water = s.rho_water ;
    who.h_off = 'Water depth, in [m].';    
    Waves_IEC614001_3.h_off = s.h_off ;    
    who.rg_off = 'The radius of the floating structure, in [m].';         
    Waves_IEC614001_3.rg_off = s.rg_off ;


    % Organizing output results 
    Waves_IEC614001_3.Vw_10SWL = s.Vw_10SWL;
    Currents_IEC614001_3.Vw_10SWL = s.Vw_10SWL;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);
    assignin('base', 'Currents_IEC614001_3', Currents_IEC614001_3);


    % Calling the next logic instance  
    System_WavesCurrentsIEC614001_3('logical_instance_03'); 



elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % THE WAVE MODEL (OFFILINE):     
    % Purpose of this Logical Instance: to represents the sea state as the
    % superposition of many small individual frequency components, each of
    % which is a periodic wave with its own amplitude, frequency and 
    % direction of propagation; the components have random phase relationships 
    % to each other. A design sea state shall be described by a wave 
    % spectrum, Sη , together with the significant wave height, Hs, a peak
    % spectral period, Tp, and a mean wave direction, θ wm. where appropriate,
    % the wave spectrum may be supplemented with a directional spreading function. 
    % Standard wave spectrum formulations are provided in ISO 19901-1.


    % ------------------- The Wave model ----------------
    if s.Option04f1 == 2
        % LOAD A DESIRED WAVE SIGNAL FROM A FILE 

        load('SameWave_JONSWAP_Height6_Period10');    
        s.vf_Jonswap = vf_Jonswap;
        s.vk_Jonswap = vk_Jonswap; 
        s.S_Jonswap = S_Jonswap;
        s.eta_Jonswap = eta_Jonswap ;        
        s.eta_Jonswap_x2 = eta_Jonswap_x2 ;
        s.eta_Jonswap_x3 = eta_Jonswap_x3;
        s.vt_sw = vt_sw ;
        s.Hs_ws = Hs_ws ;
        s.Tp_ws = Tp_ws ; 
        s.df_sw = df_sw ;
        s.fraw_eta = fraw_eta ;
        s.Sraw_eta = Sraw_eta  ;
        s.fBin_eta = fBin_eta ;
        s.SBin_eta = SBin_eta ;        
        s.PNoiseSurge_Ddot = PNoiseSurge_Ddot;  
        s.PNoiseSway_Ddot = PNoiseSway_Ddot;
        s.PNoiseHeave_Ddot = PNoiseHeave_Ddot;
        s.PNoiseRollAngle_Ddot = PNoiseRollAngle_Ddot;
        s.PNoisePitchAngle_Ddot = PNoisePitchAngle_Ddot; 
        s.PNoiseYawAngle_Ddot = PNoiseYawAngle_Ddot;
        %
    else
        % GENERATE A WAVE FROM THE SPECTRUM  (JONSWAP or Pierson-Moskowitz)

        if (s.Option01f7 == 1) 
            % Design situation case (DLC 1.1) Power production of "Table Design load cases" in IEC 61400-3 Standard.
      
            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 2) 
            % Design situation case (DLC 1.2) Power production of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 3) 
            % Design situation case (DLC 1.3) Power production of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 4) 
            % Design situation case (DLC 1.4) Power production of "Table Design load cases" in IEC 61400-3 Standard.';

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');


            elseif (s.Option01f7 == 5) 
            % Design situation case (DLC 1.5) Power production of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 6) 
            % Design situation case (DLC 1.6) Power production of "Table Design load cases" in IEC 61400-3 Standard.

            % Severe Sea State (SSS), described in section 6.3.3.2.3 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_05');

            elseif (s.Option01f7 == 7) 
            % Design situation case (DLC 2.1) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 8) 
            % Design situation case (DLC 2.2) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.'

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 9) 
            % Design situation case (DLC 2.3) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 10) 
            % Design situation case (DLC 2.4) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 11) 
            % Design situation case (DLC 2.5) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 12) 
            % Design situation case (DLC 3.1) Start up of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 13) 
            % Design situation case (DLC 3.2) Start up of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 14) 
            % Design situation case (DLC 3.3) Start up of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 15) 
            % Design situation case (DLC 4.1) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 16) 
            % Design situation case (DLC 4.2) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 17) 
            % Design situation case (DLC 5.1) Emergency Stop of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 18) 
            % Design situation case (DLC 6.1) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.
 
            % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_06');

            elseif (s.Option01f7 == 19) 
            % Design situation case (DLC 6.2) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

            % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_06');

            elseif (s.Option01f7 == 20) 
            % Design situation case (DLC 6.3) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

            % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_06');

            elseif (s.Option01f7 == 21) 
            % Design situation case (DLC 6.4) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 22) 
            % Design situation case (DLC 7.1) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.

            % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_06');

            elseif (s.Option01f7 == 23) 
            % Design situation case (DLC 7.2) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 24) 
            % Design situation case (DLC 8.1) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 25) 
            % Design situation case (DLC 8.2) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

            % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_06');

            elseif (s.Option01f7 == 26) 
            % Design situation case (DLC 8.3) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 27) 
            % Design situation case (DLC 8.4) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

            % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_04');

            elseif (s.Option01f7 == 28) 
            % Other strategies chosen by me (Custom Design situation case)

             if s.Option02f7 == 1
                 % Normal Sea State (NSS), described in section 6.3.3.2.2 of IEC 61400-3 Standard.
                 System_WavesCurrentsIEC614001_3('logical_instance_04');
                 elseif s.Option02f7 == 2
                 % Severe Sea State (SSS), described in section 6.3.3.2.3 of IEC 61400-3 Standard.
                 System_WavesCurrentsIEC614001_3('logical_instance_05');
                 %
                 elseif s.Option02f7 == 3
                 % Extreme Sea State (ESS), described in section 6.3.3.2.4 of IEC 61400-3 Standard.
                 System_WavesCurrentsIEC614001_3('logical_instance_06');
                 %
                 elseif s.Option02f7 == 4
                 % Breaking Waves, described in section 6.3.3.2.5 of IEC 61400-3 Standard.
                 System_WavesCurrentsIEC614001_3('logical_instance_07');
                 %
             end % if s.Option02f7 == 1   
             %
        end % if (s.Option01f7 == 1)
        %
    end % if s.Option04f1 == 1
    


   
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);

    % Return to the Logical Instance that called this function.


%=============================================================
elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % NORMAL SEA STATE (NSS) - WAVES MODEL (ONLINE):   
    % Purpose of this Logical Instance: to represent the waves calculated 
    % according to IEC61400-3 standard. Model "Normal sea state (NSS)".
    % is presented. Depending on the offshore wind turbine assembly chosen,
    % the modeling follows the strategy preferred by the designer or user.
    % Therefore, for each assembly, choose how it will be modeled and
    % integrated into the wave kinematics and load calculations.

    % NOTE: As of 06/06/2025, only the Betti platform model (2012) has
    % been implemented. The rest I left only the structure and should be 
    % edited and implemented in the future.

           %#### MODELING OPTION (include sea current) ####


    % ------- Add Current Model in Wave model --------
    if s.Option05f7 == 1 
        % Add Current Model in Wave model (Wave plus current)
        System_WavesCurrentsIEC614001_3('logical_instance_08');        
    end 



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 1 ####

    % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
    if s.Option02f2 == 2 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

            TomodelandoAqui = 0;
            
                 % Jonswap for 50-year sea state (Extreme Conditions)
            % System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');         
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 2 ####


    % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
    if s.Option02f2 == 3

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');
            %
        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');           
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 3 ####

    % ---------- Floating Wind Turbine with Submersible Platform ----------
    if s.Option02f2 == 4 
        
        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');
            %
        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');           
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 4 ####


    % ---------- Floating Wind Turbine with Barge Platform ----------
    if s.Option02f2 == 5 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');
            %
        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');           
            %
        end               
        %
    end




           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 5 ####


    % ---------- Fixed-Bottom Offshore Wind Turbine ----------
    if s.Option02f2 == 6 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');
            %
        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');           
            %
        end               
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Return to Logical Instance 03


%=============================================================
elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % SEVERE SEA STATE (SSS) - WAVES MODEL (ONLINE):   
    % Purpose of this Logical Instance: to represent the waves calculated 
    % according to IEC61400-3 standard. Model "Severe sea state (SSS)" is
    % presented. Depending on the offshore wind turbine assembly chosen,
    % the modeling follows the strategy preferred by the designer or user.
    % Therefore, for each assembly, choose how it will be modeled and
    % integrated into the wave kinematics and load calculations.

    % NOTE: As of 06/06/2025, only the Betti platform model (2012) has
    % been implemented. The rest I left only the structure and should be 
    % edited and implemented in the future.


           %#### MODELING OPTION (include sea current) ####


    % ------- Add Current Model in Wave model --------
    if s.Option05f7 == 1 
        % Add Current Model in Wave model (Wave plus current)
        System_WavesCurrentsIEC614001_3('logical_instance_08');        
    end 



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 1 ####

    % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
    if s.Option02f2 == 2 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 2 ####


    % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
    if s.Option02f2 == 3

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 3 ####

    % ---------- Floating Wind Turbine with Submersible Platform ----------
    if s.Option02f2 == 4 
        
        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 4 ####


    % ---------- Floating Wind Turbine with Barge Platform ----------
    if s.Option02f2 == 5 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end




           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 5 ####


    % ---------- Fixed-Bottom Offshore Wind Turbine ----------
    if s.Option02f2 == 6 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Return to Logical Instance 03


%=============================================================
elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % EXTREME SEA STATE (ESS) - WAVES MODEL (ONLINE):   
    % Purpose of this Logical Instance: to represent the waves calculated 
    % according to IEC61400-3 standard. Model "Extreme sea state (ESS)"
    % is presented. Depending on the offshore wind turbine assembly chosen,
    % the modeling follows the strategy preferred by the designer or user.
    % Therefore, for each assembly, choose how it will be modeled and
    % integrated into the wave kinematics and load calculations.

    % NOTE: As of 06/06/2025, only the Betti platform model (2012) has
    % been implemented. The rest I left only the structure and should be 
    % edited and implemented in the future.



           %#### MODELING OPTION (include sea current) ####


    % ------- Add Current Model in Wave model --------
    if s.Option05f7 == 1 
        % Add Current Model in Wave model (Wave plus current)
        System_WavesCurrentsIEC614001_3('logical_instance_08');        
    end 



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 1 ####

    % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
    if s.Option02f2 == 2 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 2 ####


    % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
    if s.Option02f2 == 3

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 3 ####

    % ---------- Floating Wind Turbine with Submersible Platform ----------
    if s.Option02f2 == 4 
        
        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 4 ####


    % ---------- Floating Wind Turbine with Barge Platform ----------
    if s.Option02f2 == 5 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end




           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 5 ####


    % ---------- Fixed-Bottom Offshore Wind Turbine ----------
    if s.Option02f2 == 6 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Return to Logical Instance 03


%=============================================================
elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % BREAKING WAVES (BW) - WAVES MODEL (ONLINE):   
    % Purpose of this Logical Instance: to represent the waves calculated 
    % according to IEC61400-3 standard. Model "Breaking waves" is presented.
    % Depending on the offshore wind turbine assembly chosen, the modeling 
    % follows the strategy preferred by the designer or user. Therefore, 
    % for each assembly, choose how it will be modeled and integrated into
    % the wave kinematics and load calculations.

    % NOTE: As of 06/06/2025, only the Betti platform model (2012) has
    % been implemented. The rest I left only the structure and should be 
    % edited and implemented in the future.




           %#### MODELING OPTION (include sea current) ####


    % ------- Add Current Model in Wave model --------
    if s.Option05f7 == 1 
        % Add Current Model in Wave model (Wave plus current)
        System_WavesCurrentsIEC614001_3('logical_instance_08');        
    end 



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 1 ####

    % ---- Floating Wind Turbine with Spar Buoy Platform by Modelling Betti (2012) ----
    if s.Option02f2 == 2 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 2 ####


    % ---------- Floating Wind Turbine with Spar Buoy Platform ----------
    if s.Option02f2 == 3

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 3 ####

    % ---------- Floating Wind Turbine with Submersible Platform ----------
    if s.Option02f2 == 4 
        
        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 4 ####


    % ---------- Floating Wind Turbine with Barge Platform ----------
    if s.Option02f2 == 5 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end




           %#### THE OFFSHORE WIND TURBINE ASSEMBLY 5 ####


    % ---------- Fixed-Bottom Offshore Wind Turbine ----------
    if s.Option02f2 == 6 

        % ---- The stochastic wave model ------
        if s.Option04f7 == 1 
            % THE JONSWAP SPECTRUM
                 % Jonswap spectrum (Normal Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_12');

                 % Jonswap for 50-year sea state (Extreme Conditions)
            System_WavesCurrentsIEC614001_3('logical_instance_19');

        elseif (s.Option04f7 == 2)
            % THE PIERSON-MOSKOWITZ SPECTRUM       
            System_WavesCurrentsIEC614001_3('logical_instance_20');
            %
        end               
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Return to Logical Instance 03


elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % THE SEA CURRENTS MODEL (ONLINE):     
    % Purpose of this Logical Instance: to represent the sea current calculated 
    % according to IEC61400-3 standard. Model "Sub-surface currents" is 
    % presented:


    % ------------------- The Sea Currents model ----------------
    if (s.Option01f7 == 1) 
       % Design situation case (DLC 1.1) Power production of "Table Design load cases" in IEC 61400-3 Standard.
      
       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 2) 
       % Design situation case (DLC 1.2) Power production of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 3) 
       % Design situation case (DLC 1.3) Power production of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 4) 
       % Design situation case (DLC 1.4) Power production of "Table Design load cases" in IEC 61400-3 Standard.';

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 5) 
       % Design situation case (DLC 1.5) Power production of "Table Design load cases" in IEC 61400-3 Standard.

        % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 6) 
       % Design situation case (DLC 1.6) Power production of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 7) 
       % Design situation case (DLC 2.1) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

        % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 8) 
       % Design situation case (DLC 2.2) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.'

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 9) 
       % Design situation case (DLC 2.3) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 10) 
       % Design situation case (DLC 2.4) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 11) 
       % Design situation case (DLC 2.5) Power production plus occurrence of fault of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 12) 
       % Design situation case (DLC 3.1) Start up of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 13) 
       % Design situation case (DLC 3.2) Start up of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 14) 
       % Design situation case (DLC 3.3) Start up of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 15) 
       % Design situation case (DLC 4.1) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');

    elseif (s.Option01f7 == 16) 
       % Design situation case (DLC 4.2) Normal Shut Down of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 17) 
       % Design situation case (DLC 5.1) Emergency Stop of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');      


    elseif (s.Option01f7 == 18) 
       % Design situation case (DLC 6.1) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

       % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_11');

    elseif (s.Option01f7 == 19) 
       % Design situation case (DLC 6.2) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

        % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_11');

    elseif (s.Option01f7 == 20) 
       % Design situation case (DLC 6.3) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

       % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_11');

    elseif (s.Option01f7 == 21) 
       % Design situation case (DLC 6.4) Parked (standing still or idling) of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 22) 
       % Design situation case (DLC 7.1) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.

       % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_11');  

    elseif (s.Option01f7 == 23) 
       % Design situation case (DLC 7.2) Parked and fault conditions of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 24) 
       % Design situation case (DLC 8.1) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');   

    elseif (s.Option01f7 == 25) 
       % Design situation case (DLC 8.2) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

       % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_11');

    elseif (s.Option01f7 == 26) 
       % Design situation case (DLC 8.3) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

       % NO CURRENTS

    elseif (s.Option01f7 == 27) 
       % Design situation case (DLC 8.4) Transport, assembly, maintenance and repair of "Table Design load cases" in IEC 61400-3 Standard.

       % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
       System_WavesCurrentsIEC614001_3('logical_instance_10');   

    elseif (s.Option01f7 == 28) 
       % Other strategies chosen by me (Custom Design situation case)

        if s.Option03f7 == 1
            % Sub-Surface Currents (SSC), described in section 6.3.3.3.2 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_09');
            %
        elseif s.Option03f7 == 2
            % Wind-generated, Near-Surface Currents (WG NSC), described in section 6.3.3.3.3 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_10');
            %
        elseif s.Option03f7 == 3
            % Normal Current Model (NCM), described in section 6.3.3.3.4 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_10');
            %
        elseif s.Option03f7 == 4
            % Extreme Current Model (ECM), described in section 6.3.3.3.5 of IEC 61400-3 Standard.
            System_WavesCurrentsIEC614001_3('logical_instance_11'); 
            %
        end   
        %
    end    
   

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to the Logical Instance that called this function.


    
elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % SUB-SURFACE CURRENTS - SEA CURRENTS MODEL (ONLINE):     
    % Purpose of this Logical Instance: to represent the sea current calculated 
    % according to IEC61400-3 standard. Model "Sub-surface currents" is 
    % presented:


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025;
    

    % ------ Values ​​related to the calculation of Wave and Drag Forces --------- 
    who.SeaWaterCurrent_Vx = 'Velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx = 0 ; 
    who.SeaWaterCurrent_Vx_dot = 'Acceleration of the undisturbed water particles in the sea current, in the X direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vx_dot = 0 ;
    who.SeaWaterCurrent_Depth = 'Water depth of the sea current model, in [m]. Calculated according to IEC 61400-3.';
    s.SeaWaterCurrent_Depth = 0 ;
    who.SeaWaterCurrent_Vy = 'Velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy = 0 ; 
    who.SeaWaterCurrent_Vy_dot = 'Acceleration of the undisturbed water particles in the sea current, in the Y direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy_dot = 0 ;
    who.SeaWaterCurrent_Vx_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx_surface = 0 ; 
    who.SeaWaterCurrent_Vy_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vy_surface = 0 ; 



    % Organizing output results 
    Currents_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Currents_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Waves_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;       


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to Logical Instance 08


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % NORMAL CURRENT MODEL (NCM) & WIND-GENERATED, NEAR SURFACE CURRENTS MODEL (ONLINE):     
    % Purpose of this Logical Instance: to represent the sea current calculated 
    % according to IEC61400-3 standard. Model "Wind-generated, near-surface
    % currents" and "Normal current model (NCM)" are presented:


    % --- The 1-hour mean value of wind speed at 10 m height above SWL ---
    who.Vw_mean1h = 'Wind speed at 10 m height above SWL, in [m/s].';
    if (s.tf < 3600)
        who.Vw_mean1h = 'Wind speed at 10 m height above SWL, in [m/s].';
        s.Vw_mean1h = mean( s.Vw_10SWL ) ;
        %
    else
        s.index1h_0 = 1 ;
        s.index1h_f = s.Nvw1h ;
        for iiit = 1:s.Nvw_1h
            who.Vw_mean1h = 'Wind speed at 10 m height above SWL, in [m/s].';
            s.Vw_mean1h(iiit) = mean( s.Vw_10SWL(s.index1h_0:s.index1h_f) ) ;
            s.index1h_0 = s.index1h_0 + s.Nvw1h ;
            s.index1h_f = min( (s.index1h_f + s.Nvw1h) , s.Nvw ) ; 
            %
        end
    end        


   
    % --- The Surface Velocity Uw(0)  ---
    who.Vw_mean1h = 'Wind speed at 10 m height above SWL, in [m/s].';
    if (s.tf < 3600)
        who.Uw_zero = 'The Surface Velocity Uw(0), in [m/s].';
        s.Uw_zero = 0.01*s.Vw_mean1h ;
    else
        s.index1h_0 = 1 ;
        s.index1h_f = s.Nvw1h ;
        for iiit = 1:s.Nvw_1h
            who.Uw_zero = 'The Surface Velocity Uw(0), in [m/s].';
            s.Uw_zero(iiit) = 0.01*s.Vw_mean1h(iiit) ;
            s.index1h_0 = s.index1h_0 + s.Nvw1h ;
            s.index1h_f = min( (s.index1h_f + s.Nvw1h) , s.Nvw ) ; 
            %
        end
    end      


    % --- Wind-generated, near-surface currents   Uw(z)  ---       
    if (s.tf < 3600)
        who.Uw_current = 'The Surface Velocity Uw(0), in [m/s].';
        s.Uw_current = s.Uw_zero .* ( 1 + (s.WaterDepth ./ 20) ) ;
    else
        s.index1h_0 = 1 ;
        s.index1h_f = s.Nvw1h ;
        for iiit = 1:s.Nvw_1h
            who.Uw_current = 'The Surface Velocity Uw(0), in [m/s].';
            if iiit == 1
                s.Uw_current = s.Uw_zero(iiit) .* ( 1 + (s.WaterDepth ./ 20) ) ;
            else
                s.Uw_current_i = s.Uw_zero(iiit) .* ( 1 + (s.WaterDepth ./ 20) ) ;
                s.Uw_current = [s.Uw_current s.Uw_current_i];
            end           
            s.index1h_0 = s.index1h_0 + s.Nvw1h ;
            s.index1h_f = min( (s.index1h_f + s.Nvw1h) , s.Nvw ) ; 
            %
        end
    end      

    
    % ------ Values ​​related to the calculation of Wave and Drag Forces --------- 
    who.SeaWaterCurrent_Vx = 'Velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx = s.Uw_current ; 
    who.SeaWaterCurrent_Vx_dot = 'Acceleration of the undisturbed water particles in the sea current, in the X direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vx_dot = s.Uw_current ;
    who.SeaWaterCurrent_Depth = 'Water depth of the sea current model, in [m]. Calculated according to IEC 61400-3.';
    s.SeaWaterCurrent_Depth = s.Uw_current ;
    who.SeaWaterCurrent_Vy = 'Velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy = s.Uw_current ; 
    who.SeaWaterCurrent_Vy_dot = 'Acceleration of the undisturbed water particles in the sea current, in the Y direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy_dot = s.Uw_current ;
    who.SeaWaterCurrent_Vx_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx_surface = s.Uw_current ; 
    who.SeaWaterCurrent_Vy_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vy_surface = s.Uw_current ; 



    % Organizing output results 
    Currents_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Currents_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Waves_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;     


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to Logical Instance 08


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % EXTREME CURRENT MODEL (ECM) - SEA CURRENTS MODEL (ONLINE):     
    % Purpose of this Logical Instance: to represent the sea current calculated 
    % according to IEC61400-3 standard. Model "Extreme Current Model (ECM)" 
    % is presented:


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025;
    

    % ------ Values ​​related to the calculation of Wave and Drag Forces --------- 
    who.SeaWaterCurrent_Vx = 'Velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx = 0 ; 
    who.SeaWaterCurrent_Vx_dot = 'Acceleration of the undisturbed water particles in the sea current, in the X direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vx_dot = 0 ;
    who.SeaWaterCurrent_Depth = 'Water depth of the sea current model, in [m]. Calculated according to IEC 61400-3.';
    s.SeaWaterCurrent_Depth = 0 ;
    who.SeaWaterCurrent_Vy = 'Velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy = 0 ; 
    who.SeaWaterCurrent_Vy_dot = 'Acceleration of the undisturbed water particles in the sea current, in the Y direction and in [m/s^2]. Calculated according to IEC 61400-3 Standard.';    
    s.SeaWaterCurrent_Vy_dot = 0 ;
    who.SeaWaterCurrent_Vx_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the X direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vx_surface = 0 ; 
    who.SeaWaterCurrent_Vy_surface = 'Surface velocity of the undisturbed water particles in the sea current, in the Y direction and in [m/s]. Calculated according to IEC 61400-3 Standard.';
    s.SeaWaterCurrent_Vy_surface = 0 ; 



    % Organizing output results 
    Currents_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Currents_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Currents_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Currents_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.SeaWaterCurrent_Vx = s.SeaWaterCurrent_Vx;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_dot = s.SeaWaterCurrent_Vx_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Depth = s.SeaWaterCurrent_Depth;
    Waves_IEC614001_3.SeaWaterCurrent_Vy = s.SeaWaterCurrent_Vy;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_dot = s.SeaWaterCurrent_Vy_dot;
    Waves_IEC614001_3.SeaWaterCurrent_Vx_surface = s.SeaWaterCurrent_Vx_surface;
    Waves_IEC614001_3.SeaWaterCurrent_Vy_surface = s.SeaWaterCurrent_Vy_surface; 

    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Return to Logical Instance 08


elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL- Normal conditions (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.

 
    % ---------- Discretization ----------  
    who.dt_sw = 'Time step for wave time series simulation, in [seg].';
    s.dt_sw = 0.1 ; % should be 1/(2*df )
    
    who.vt_sw = 'Time vector for wave time series simulation, in [seg].';
    s.vt_sw = 0:s.dt_sw:600 ;
    

             %####### WAVE SPECTRA (JONSWAP SPECTRUM) #######

    % ---------- WAVE SPECTRA (JONSWAP SPECTRUM) ----------        
    who.Hs_ws = 'Time vector for wave time series simulation, in [seg].';
    s.Hs_ws = 6 ;
    who.Tp_ws = 'Time vector for wave time series simulation, in [seg].';
    s.Tp_ws = 10 ;
    who.SigmaApprox_ws = 'Time vector for wave time series simulation, in [seg].';
    s.SigmaApprox_ws = s.Hs_ws/4 ;

    % NOTE1: According to Branlard (2010), the frequencies was prescribed
    % indepenbdently of time vector. It's best to declare time vector 
    % first and use a Nyquist Curt-off. It's likely that there will be 
    % periodicity it the time vector is longer.

    who.df_sw = 'The smallst frequency, in [Hz].';    
    s.df_sw = 0.005; % smallst frequency
    who.fHighCut = 'The Nyquist cutoff frequency for wave spectrum, in [Hz].';
    s.fHighCut = 0.2 ;


    % Organizing output results 
    Waves_IEC614001_3.dt_sw = s.dt_sw;
    Waves_IEC614001_3.vt_sw = s.vt_sw;
    Waves_IEC614001_3.SigmaApprox_ws = s.SigmaApprox_ws;
    Waves_IEC614001_3.Hs_ws = s.Hs_ws;
    Waves_IEC614001_3.Tp_ws = s.Tp_ws;
    Waves_IEC614001_3.df_sw = s.df_sw;    
    Waves_IEC614001_3.fHighCut = s.fHighCut;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);   



    % Returdf_swns vectos of wave frequencies and amplitudes
    System_WavesCurrentsIEC614001_3('logical_instance_13'); % [s.vf_Jonswap,s.S_Jonswap] = fJonswap(Hs,Tp,df,fHighCut) 


    who.N_sw = 'Number of component for the sum that will be used to compute e ta(t) see slides 02 page 10 Branland 2010.';
    s.N_sw = length(s.vf_Jonswap) ; % number of component for the sum that will be used to compute e ta(t) see slides 02 page 10

    s.vphases_Jonswap = rand(1,s.N_sw)*2*pi ; % random phases between [02*pi]
    s.vA_Jonswap = sqrt( 2*s.S_Jonswap*s.df_sw ) ; % scaled amplitudes according to Jonswap spectrum
    s.h_water = s.h_off;    


    % Organizing output results 
    Waves_IEC614001_3.N_sw = s.N_sw;
    Waves_IEC614001_3.vA_Jonswap = s.vA_Jonswap;  
    Waves_IEC614001_3.h_water= s.h_water;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);   


    % ------ Dispersion for all frequencies (only useful if x!=0) ------    
    System_WavesCurrentsIEC614001_3('logical_instance_14'); %  [vk] = fgetDispersion(vf_Jonswap, h, g);    


    % ----------- Stochastic Time series ---------
    who.x_wave_1 = 'Position Water, in [m].';    
    s.x_wave_1 = 0;
    
    who.eta_Jonswap = 'Water elevation at point x1, summation of waves.';
    s.eta_Jonswap = zeros(1,length(s.vt_sw) ) ;

    if s.Option02f2 == 2
         % Spar Buoy according to Betti (2012)
         who.x_wave_2 = 'Position Water at point x2, in [m].';    
         s.x_wave_2 = s.rg_off;
         who.x_wave_3 = 'Position Water at point x3, in [m].';    
         s.x_wave_3 = - s.rg_off;
            % NOTE: o approximate the depth of water, the surface elevation
            % is valuated at three points: x = ξ , x = ξ +rg and ξ − rg,
            % where rg is the radius of the floating structure. Then, it 
            % is assumed the water surface where the structure is located
            % to be flat and horizontal, with a dept hw equal to the average
            % of these three points. 
         who.eta_Jonswap_x2 = 'Water elevation at x2, summation of waves.';
         s.eta_Jonswap_x2 = zeros(1,length(s.vt_sw) ) ;
         who.x_wave_3 = 'Position Water at point x3, in [m].';
         s.eta_Jonswap_x3 = zeros(1,length(s.vt_sw) ) ;         
    end




    % Assign variables
    % vf = s.vf_Jonswap; % Frequency vector
    % vphases = s.vphases_Jonswap; % Random phases
    % vA = s.vA_Jonswap;
    % vk = s.vk_Jonswap;



    for itt =1:length(s.vt_sw)

        who.eta_Jonswap = 'Water elevation, summation of waves.';
        s.eta_Jonswap(itt) = sum(s.vA_Jonswap .* cos( (2*pi*s.vf_Jonswap)*s.vt_sw(itt) - s.vk_Jonswap*s.x_wave_1 + s.vphases_Jonswap ) ) ; % Water elevation at x3, summation of waves

        if s.Option02f2 == 2
            % BETTI (2012)
                % I am calculating the elevation at 3 points x (x1, x2 and
                % x3) to calculate the average depth for use in modeling 
                % buoyancy loads and displaced volume.
            who.eta_Jonswap_x2 = 'Water elevation at x2, summation of waves.';
            s.eta_Jonswap_x2(itt) = sum(s.vA_Jonswap .* cos( (2*pi*s.vf_Jonswap)*s.vt_sw(itt) - s.vk_Jonswap*s.x_wave_2 + s.vphases_Jonswap ) ) ; % Water elevation at x2, summation of waves

            who.eta_Jonswap_x3 = 'Water elevation at x2, summation of waves.';
            s.eta_Jonswap_x3(itt) = sum(s.vA_Jonswap .* cos( (2*pi*s.vf_Jonswap)*s.vt_sw(itt) - s.vk_Jonswap*s.x_wave_3 + s.vphases_Jonswap ) ) ; % Water elevation at x3, summation of waves        
        end
    end


    % Plot wave time series
    figure;
    plot(s.vt_sw, s.eta_Jonswap, 'Color', [0 0 0.7]);
    box on;
    grid off;
    title('Wave Time Series');
    xlabel('t [s]');
    ylabel('Water elevation [m]');


        if (s.Option02f2 == 2) && (s.Option06f7 == 3)
            % BETTI (2012)
            figure;
            plot( s.vt_sw, s.eta_Jonswap,   'b',  ... % ξ (centro)
            s.vt_sw, s.eta_Jonswap_x2, 'r',  ... % ξ + rg
            s.vt_sw, s.eta_Jonswap_x3, 'g' );    % ξ – rg
            grid off;
            box on;
            xlabel('t [s]');
            ylabel('Water elevation [m]');
            title('Wave Elevation at ξ, ξ+rg and ξ–rg');
            legend('η(ξ)','η(ξ+rg)','η(ξ–rg)','Location','best');
            %
        end

    s.bPlot = 0;

    % Organizing output results 
    Waves_IEC614001_3.x_wave_1 = s.x_wave_1;
    Waves_IEC614001_3.x_wave_2 = s.x_wave_2;
    Waves_IEC614001_3.x_wave_3 = s.x_wave_3;    
    Waves_IEC614001_3.eta_Jonswap = s.eta_Jonswap;
    Waves_IEC614001_3.eta_Jonswap_x2 = s.eta_Jonswap_x2;
    Waves_IEC614001_3.eta_Jonswap_x3 = s.eta_Jonswap_x3;    
    Waves_IEC614001_3.gravity = s.gravity;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3); 

       

    % Compute spectrum from the generated time series
    System_WavesCurrentsIEC614001_3('logical_instance_16'); %  [SBin_eta, fBin_eta, Sraw_eta, fraw_eta] = fSpectrum(vt, eta_Jonswap, 0);


    % ---------- Spectra of Stochastic Time Series ----------
    figure;
    Ikp = s.S_Jonswap > 10^(-5);
    loglog(s.fraw_eta, s.Sraw_eta, '-', 'Color', [0.66 0.66 0.66]);
    hold on;
    % loglog(fWelch, SWelch, '-', 'Color', [0.35 0.35 0.35]); % Uncomment if needed
    loglog(s.vf_Jonswap(Ikp), s.S_Jonswap(Ikp), 'k', 'LineWidth', 2);
    loglog(s.fBin_eta, s.SBin_eta, 'r-');
    title('Generated Time Series Jonswap Spectrum');
    xlabel('Frequency [Hz]');
    ylabel('PSD of eta [m^2 s]');
    grid off;
    lg = legend('Raw spectrum', 'Jonswap spectrum', 'Bin-average spectrum');
    set(lg, 'Location', 'southwest'); % Axis tight

   
   % Organizing output results 
    s.testvariable = 0;
    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;       


    % Integration of the spectrum
    Area = trapz(s.vf_Jonswap, s.S_Jonswap);
    normalization_factor = (s.Hs_ws / 4)^2 / Area;
    S_Jonswap_ = normalization_factor * s.S_Jonswap;
    Area_ = trapz(s.vf_Jonswap, S_Jonswap_);
    figure(222);
    plot(s.vf_Jonswap, s.S_Jonswap, 'k-');
    hold on;
    plot(s.vf_Jonswap, S_Jonswap_, 'b.');
    grid on;
    xlim([0 0.3]);
    title('Jonswap Spectrum Comparison.');
    legend('Theoretical Jonswap spectrum (calculated with the function)', 'Generated and normalized Jonswap spectrum');
    xlabel('Frequencies [Hz]');
    ylabel('JONSWAP Spectral Density S [m^2 s]');



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3); 

 
    % Return to previus Logical Instance 03 
     % (where you are modeling according to your offshore assembly)


elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (fJonswap) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

    % Returns the Jonswap spectrum

    % ---------- Inputs ----------
% Hs : Significant wave height
% Tp : Peak period
% df : Frequency resolution
% fHighCut : Highest frequency

    % ---------- Outputs ----------
% f : Frequencies
% S : Spectrum
% a : Scaled amplitudes for cosine Fourier Series of the form a .* cos(omega * t + phi)
    % 
    fp = 1 / s.Tp_ws; % Peak frequency

    % Get gamma value according to standards
    if (s.Tp_ws / sqrt(s.Hs_ws) <= 3.6)
        gamm = 5;
    elseif (s.Tp_ws / sqrt(s.Hs_ws) > 3.6) && (s.Tp_ws / sqrt(s.Hs_ws) <= 5)
        gamm = exp(5.75 - 1.15 * (s.Tp_ws / sqrt(s.Hs_ws)));
    elseif (s.Tp_ws / sqrt(s.Hs_ws) > 5)
        gamm = 1;
    else
        disp('Something is wrong with your inputs, model not valid')
    end

    % Alternatively, prescribe gamma manually
    % gamm = 3.3;

    % Define sigma values
    vFreq = s.df_sw:s.df_sw:s.fHighCut;
    S = zeros(size(vFreq)); % Initialize spectrum array

    for iFreq = 1:length(vFreq)
        freq = vFreq(iFreq);
        
        if (freq <= fp)
            sigma = 0.07;
        else
            sigma = 0.09;
        end

        S(iFreq) = 0.3125 * s.Hs_ws^2 * s.Tp_ws * (freq / fp)^(-5) * exp(-1.25 * (freq / fp)^(-4)) ...
               * (1 - 0.287 * log(gamm)) * gamm^(exp(-0.5 * (((freq / fp) - 1) * (1 / sigma))^2));
    end

    % ---------- Outputs ----------
    f = vFreq;
    a = sqrt(2 * S * s.df_sw); % Scaled amplitudes according to Jonswap spectrum
    

    who.vf_Jonswap = 'Vector of Wave Frequencies, in [Hz]';
    s.vf_Jonswap = f; 
    who.S_Jonswap = 'The vector of Wave Scaled amplitudes according to Jonswap spectrum';
    s.S_Jonswap = S;  
    who.Amplitude_Jonswap = 'The vector of Wave Scaled amplitudes according to Jonswap spectrum';
    s.Amplitude_Jonswap = a;     


    % [f, S, a] = fJonswap(Hs, Tp, df, fHighCut)


    % Organizing output results 
    Waves_IEC614001_3.vf_Jonswap  = s.vf_Jonswap ;
    Waves_IEC614001_3.S_Jonswap = s.S_Jonswap;   
    Waves_IEC614001_3.Amplitude_Jonswap = s.Amplitude_Jonswap;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    

    % Return to Logical Instance 12


elseif strcmp(action, 'logical_instance_14')
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (fgetDispersion) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

% Solves for the dispersion relation once and for all
% h : Water depth > 0
% g : Gravity acceleration (9.81 m/s²)

    vf = s.vf_Jonswap;
    vk = zeros(size(vf)); % Preallocate vk vector

    for ip = 1:length(vf) % Loop over frequencies
        if s.h_water < 100
            s.vfSolver = vf(ip);
            assignin('base', 's', s);
            System_WavesCurrentsIEC614001_3('logical_instance_15'); %    vk(ip) = fkSolve(vf(ip), h, g);
            vk(ip) = s.vk_solver ;
        else
            % Not solving the dispersion relation since we are in deep water
            vOmega = 2 * pi * vf;
            vk = vOmega.^2 / s.gravity;
        end
    end


    who.vk_sw = 'Frequency of each component, in [Hz]';
    s.vk_sw = vk;
    who.vk_sw = 'Wavenumber calculated by linear dispersion ω² = g·k·tanh(k·h)';    
    s.vk_Jonswap = vk;


    % Organizing output results 
    Waves_IEC614001_3.vk_sw = s.vk_sw;
    Waves_IEC614001_3.vk_Jonswap = s.vk_Jonswap;    
 

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    


    % Return to Logical Instance 12


elseif strcmp(action, 'logical_instance_15')
%==================== LOGICAL INSTANCE 15 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (fkSolve) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

    % Solves for the wave number k using fzero

    warning off;

    f = s.vfSolver ;

    omega = 2 * pi * f;
    eq = @(k) -omega^2 + s.gravity * k .* tanh(k * s.h_water);

    % Using fzero for root solving (faster approach)
    k = fzero(eq, [0 100]);


    s.vk_solver = k ;
    warning on;    



    % Organizing output results 
    Waves_IEC614001_3.vk_solver = s.vk_solver;
    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    


    % Return to Logical Instance 12


elseif strcmp(action, 'logical_instance_16')
%==================== LOGICAL INSTANCE 16 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (fSpectrum) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

% returns the spectrum of a time series
% This function needs a lot of clean up

   bPlot = s.bPlot;
    if s.vt_sw(1) ~= 0
        s.vt_sw = s.vt_sw - s.vt_sw(1);
    end

    N_samples = length(s.eta_Jonswap);  % number of samples
    dt = s.vt_sw(end);            % time increment (10 minutes, i.e., 600 secs)
    s.Fs_ws = N_samples / dt;    % frequency

    % for the annual pattern
    s.Kws = 1;                  % splitting factor
    s.omega_wave = 2*pi*s.Fs_ws;


    s.q = s.eta_Jonswap;

    % Organizing output results 
    Waves_IEC614001_3.Fs_ws = s.Fs_ws;  
    Waves_IEC614001_3.Kws = s.Kws;
    Waves_IEC614001_3.omega_wave = s.omega_wave;
    Waves_IEC614001_3.q = s.q;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3); 


    System_WavesCurrentsIEC614001_3('logical_instance_17'); % [S_, F_] = spectrum(q, Fs, K, omega);
    s.S_ = s.Swave; 
    s.F_ = s.F1wave;  
    s.NN_waveS = length(s.S_);


    % Organizing output results 
    Waves_IEC614001_3.S_ = s.S_;
    Waves_IEC614001_3.F_ = s.F_; 
    Waves_IEC614001_3.NN_waveS = s.NN_waveS;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3); 



    % binning the spectrum
    xTop = 0;
    System_WavesCurrentsIEC614001_3('logical_instance_18'); % [S, f] = spectrum_average(S_(2:floor(NN/2)), F_(2:floor(NN/2)));
    % f = s.F1wave_average;
    % S = s.Swave_average;


    %
    if bPlot == 1
        figure()
        loglog(s.F_(2:floor(s.NN_waveS/2)), 2*pi*2*s.S_(2:floor(s.NN_waveS/2)), '-', 'Color', [0.66 0.66 0.66])
        hold on
        loglog(s.F1wave_average, 2*pi*2*s.Swave_average, 'k-', 'LineWidth', 2)
        xlabel('Frequency [Hz]')
        grid on
        legend('Raw PSD', 'Average PSD')
    end

    % Outputs
    SBin = 2*pi*2*s.Swave_average;
    fBin = s.F1wave_average;
    Sraw = 2*pi*2*s.S_(2:floor(s.NN_waveS/2));
    fraw = s.F_(2:floor(s.NN_waveS/2));

    s.SBin_eta = SBin;
    s.fBin_eta = fBin;
    s.Sraw_eta = Sraw;
    s.fraw_eta = fraw;


    % Organizing output results 
    Waves_IEC614001_3.Fs_ws = s.Fs_ws; 
    Waves_IEC614001_3.Kws = s.Kws;
    Waves_IEC614001_3.SBin_eta = s.SBin_eta;
    Waves_IEC614001_3.fBin_eta = s.fBin_eta;
    Waves_IEC614001_3.Sraw_eta = s.Sraw_eta;
    Waves_IEC614001_3.fraw_eta= s.fraw_eta;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    

    
    % Return to Logical Instance 12



elseif strcmp(action, 'logical_instance_17')
%==================== LOGICAL INSTANCE 17 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (spectrum) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

    % [S, F1] = spectrum(u, fs, K, omega)
    % [S_, F_] = spectrum(q, Fs, K, omega);
    u = s.q;    
    fs = s.Fs_ws;  
    K = s.Kws;
    omega = s.omega_wave;

    %  spectrum(q, Fs, K, omega)
    % spectrum(u, fs, K, omega)

    
    n = floor(length(u)/K); % compute the size of the sample
    j = 1;
    F1 = [0:(n-1)] / n * fs; % Nyquist frequency

    %---------------- Splitting the time series -------------------
    for i = 1:K
        x(1:length(u(j:j+n-1)), i) = u(j:j+n-1)';
        j = j + n;
    end

    %---------------- Calculating the spectrum --------------------
    for i = 1:length(x(1,:))
        X1(1:length(x(:,i)), i) = (abs(fft(x(:,i))').^2) / (omega * length(x(:,1)));
    end

    %----------------- mean of X1 -------------------------------
    for i = 2:length(x(:,1))
        S(i) = nanmean(X1(i,:));
    end

    
    % ---------- Defining test variable ----------
    who.F1wave = 'Test variable, in [unit in SI]';
    s.F1wave = F1;    
    who.Swave = 'Test variable, in [unit in SI]';
    s.Swave = S;


    % Organizing output results 
    Waves_IEC614001_3.F1wave = s.F1wave;
    Waves_IEC614001_3.Swave = s.Swave;       


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    


    % Return to Logical Instance 16


elseif strcmp(action, 'logical_instance_18')
%==================== LOGICAL INSTANCE 18 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL (spectrum_average) (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    %###### Code proposed by Brandland (2010) DTU University ######

% Average neighboring frequency bins.
% INPUTS: Power spectrum and Nyquist frequency.
% OUTPUTS: Power spectrum and Nyquist frequency after averaging neighboring frequency bins.


    % [S, f] = spectrum_average(S_(2:floor(NN/2)), F_(2:floor(NN/2)));
    % [S_average, f_average] = spectrum_average(S, F1)
    % Inputs
    S = s.S_(2:floor(s.NN_waveS/2));
    F1 = s.F_(2:floor(s.NN_waveS/2));


    bins = 15; % typically between 10 and 20
    a = 10^(1/bins); % distance between neighbors

    x_x = log10(F1(2));
    f_o = 10^(floor(x_x)); % detection of the lowest bound of the range
    F_Lower = F1(1);
    F_Higher = a * f_o; % higher limit of the first bin
    j = 0;
    while (F_Lower < F1(end))
        f_i = F1((F1 >= F_Lower) & (F1 < F_Higher));
        Si = S((F1 >= F_Lower) & (F1 < F_Higher));
        if (~isempty(Si))
            j = j + 1;
            S_average(j) = mean(Si);
            f_average(j) = mean(f_i);
        end
        F_Lower = F_Higher;
        F_Higher = a * F_Lower;
    end


    % ---------- Defining test variable ----------
    who.Swave_average = 'Test variable, in [unit in SI]';
    s.Swave_average = S_average;
    who.F1wave_average = 'Test variable, in [unit in SI]';
    s.F1wave_average = f_average;   

    % Organizing output results 
    Waves_IEC614001_3.Swave_average = s.Swave_average;
    Waves_IEC614001_3.F1wave_average = s.F1wave_average;      


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);    


    % Return to Logical Instance 16


elseif strcmp(action, 'logical_instance_19')
%==================== LOGICAL INSTANCE 19 ====================
%=============================================================    
    % JONSWAP SPECTRUM MODEL- Extreme conditions (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.

 
  
    %####### WAVE SPECTRA (JONSWAP SPECTRUM FOR 50 YEARS) #######

    % ---------- WAVE SPECTRA (JONSWAP SPECTRUM) ----------        
    who.Hs_ws = 'Time vector for wave time series simulation, in [seg].';
    s.Hs_ws = 8.1 ;
    who.Tp_ws = 'Time vector for wave time series simulation, in [seg].';
    s.Tp_ws = 12.7 ;
    who.SigmaApprox_ws = 'Time vector for wave time series simulation, in [seg].';
    s.SigmaApprox_ws = s.Hs_ws/4 ;

    % NOTE1: According to Branlard (2010), the frequencies was prescribed
    % indepenbdently of time vector. It's best to declare time vector 
    % first and use a Nyquist Curt-off. It's likely that there will be 
    % periodicity it the time vector is longer.


    % ---------- Discretization ----------      
    s.nt_sw = 3601;
    who.vt_sw = 'Time vector for wave time series simulation, in [seg].';
    s.vt_sw = linspace(0, 3600, s.nt_sw) ;% Time vector [s]
    who.T_sw = 'Sample time of wave spectrum, in [seg].';    
    s.T_sw = s.vt_sw(2) - s.vt_sw(1); % Sample time
    who.Fs_sw = 'Sample freqeuncy of wave spectrum, in [hz].';      
    s.Fs_sw = 1 / s.T_sw; % Sampling frequency [Hz]

    who.dt_sw = 'Smallest frequency step for wave time series simulation, in [seg].';
    s.dt_sw = 1 / max(s.vt_sw) ; % should be 1/(2*df )

    who.df_sw = 'The smallst frequency, in [Hz].';    
    s.df_sw = 1 / max(s.vt_sw); % smallst frequency
    who.fHighCut = 'The Nyquist cutoff frequency for wave spectrum, in [Hz].';
    s.fHighCut = s.Fs_sw / 2 ; % Nyquist cutoff


    % Organizing output results 
    Waves_IEC614001_3.nt_sw = s.nt_sw;
    Waves_IEC614001_3.T_sw = s.T_sw;
    Waves_IEC614001_3.dt_sw = s.dt_sw;
    Waves_IEC614001_3.vt_sw = s.vt_sw;
    Waves_IEC614001_3.Fs_sw = s.Fs_sw;
    Waves_IEC614001_3.Hs_ws = s.Hs_ws;
    Waves_IEC614001_3.Tp_ws = s.Tp_ws;
    Waves_IEC614001_3.df_sw = s.df_sw;    
    Waves_IEC614001_3.fHighCut = s.fHighCut;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);   

    
    % Returns vectos of wave frequencies and amplitudes
    System_WavesCurrentsIEC614001_3('logical_instance_13'); % [s.vf_Jonswap,s.S_Jonswap] = fJonswap(Hs,Tp,df,fHighCut) 

   
    % Integration of the spectrum
    Area = trapz(s.vf_Jonswap, s.S_Jonswap);
    normalization_factor = (s.Hs_ws / 4)^2 / Area;
    S_Jonswap_ = normalization_factor * s.S_Jonswap;
    Area_ = trapz(s.vf_Jonswap, S_Jonswap_);
    figure(222);
    plot(s.vf_Jonswap, s.S_Jonswap, 'k-');
    hold on;
    plot(s.vf_Jonswap, S_Jonswap_, 'b.');
    grid on;
    xlim([0 0.3]);
    title('Jonswap Spectrum Comparison.');
    legend('Theoretical Jonswap spectrum (calculated with the function)', 'Generated and normalized Jonswap spectrum');
    xlabel('Frequencies [Hz]');
    ylabel('JONSWAP Spectral Density S [m^2 s]');

    % Summation of various wave components using Jonswap spectrum
    who.N_sw = 'Number of component for the sum that will be used to compute e ta(t) see slides 02 page 10 Branland 2010.';
    s.N_sw = length(s.vf_Jonswap) ; % number of component for the sum that will be used to compute e ta(t) see slides 02 page 10    
    s.vphases_Jonswap = rand(1,s.N_sw)*2*pi ; % random phases between [02*pi]
    s.vA_Jonswap = sqrt( 2*s.S_Jonswap*s.df_sw ) ; % scaled amplitudes according to Jonswap spectrum
    s.h_water = s.h_off;   


    % Organizing output results 
    Waves_IEC614001_3.N_sw = s.N_sw;
    Waves_IEC614001_3.vA_Jonswap = s.vA_Jonswap;  
    Waves_IEC614001_3.h_water= s.h_water;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);   


    % ------ Dispersion for all frequencies  ------ 
    System_WavesCurrentsIEC614001_3('logical_instance_14'); %  [vk] = fgetDispersion(vf_Jonswap, h, g);    


    % Assign variables
    vf = s.vf_Jonswap; % Frequency vector
    vphases = s.vphases_Jonswap; % Random phases
    vA = s.vA_Jonswap;
    vk = s.vk_Jonswap;
    vf_Jonswap = s.vf_Jonswap;
    S_Jonswap = s.S_Jonswap;


    % Hydrodynamic calculations
    nz = 10;
    % ESSA FUNÇÃO AQUI PODE SER CONSTRUÍDA PARA CALCULAR AS FORÇAS HIDRODINÂMICAS
    % [eta, Ftot, Mtot, Fdrag, Finertia, vz, Stored_u, Stored_dudt, dFtot, dMtot, dFdrag, dFinertia] = fHydroCalcFinal(vt, q, vf, vk, vA, vphases, g, rhow, h, zBot, D, Cm, CD, nz, bWheeler, bFloating, bVzTo0);

    % Substituição para gerar apenas a série temporal eta:
    for itt =1:length(s.vt_sw)

        who.eta_Jonswap = 'Water elevation, summation of waves.';
        s.eta_Jonswap(itt) = sum(s.vA_Jonswap .* cos( (2*pi*s.vf_Jonswap)*s.vt_sw(itt) - s.vk_Jonswap*s.x_wave + s.vphases_Jonswap ) ) ; % Water elevation, summation of waves
    end


    % Verification of spectra
    eta = s.eta_Jonswap;
    nt = s.nt_sw;
    vt = s.vt_sw;
    Fs = 1 / s.T_sw; % Sampling frequency [Hz]
    df = 1 / max(vt); % Smallest frequency step
    fHighCut = Fs / 2; % Nyquist cutoff
    
    % MATLAB method
    nt = length(vt); % Length of signal
    NFFT = 2^nextpow2(nt); % Next power of 2 from length of y
    Y = fft(eta, NFFT) / nt;
    Ab = 2 * abs(Y(1:NFFT/2+1)); % Single-sided amplitude spectrum
    fb = Fs / 2 * linspace(0, 1, NFFT/2+1);
    psb = Ab.^2 / (2 * df);

    % Double-sided spectrum
    fB2 = (1:nt) * df - df;
    aB2 = abs(fft(eta)) / nt; % Double-sided amplitude spectrum
    psEtaB2 = aB2.^2 / df;
    psEtaB2(1) = 0;

    % Plot verification
    figure;
    hold on;
    plot(fb, psb);
    plot(fB2, psEtaB2 * 2);
    plot(vf_Jonswap, S_Jonswap, 'k');
    legend('MATLAB', 'PSD*2', 'Jonswap S');
    xlim([0 0.3]);
    ylabel('PSD of \eta [m^2/Hz]');
    xlabel('Frequency [Hz]');

    %
    % Plot single-sided amplitude spectrum
    % figure;
    % grid on;
    % hold on;
    % box on;
    % plot(fb, Ab);
    % plot(fB2, aB2 * 2);
    % plot(vf_Jonswap, vA_Jonswap, 'k', 'LineWidth', 2);
    % xlim([0 0.5]);
    % ylabel('Single-Sided Amplitude Spectrum of eta(t) - a');
    % xlabel('Frequency (Hz)');
    % legend('From Time Series', 'From JONSWAP Spectrum');
    % title('Spectrum Comparison');

    figure;
    grid on;
    hold on;
    box on;
    h1 = plot(fb, Ab, 'b:', 'LineWidth', 1.5); % Plota a amplitude single-sided extraída da FFT da série temporal
    h2 = plot(fB2, aB2 * 2, 'r', 'LineWidth', 1.5); % Plota a amplitude obtida a partir da FFT double-sided, escalada por 2
    h3 = plot(vf_Jonswap, vA_Jonswap, 'k', 'LineWidth', 2); % Plota a amplitude teórica calculada a partir do espectro JONSWAP
    xlim([0 0.5]);
    ylabel('Single-Sided Amplitude Spectrum of \eta(t) (a)');
    xlabel('Frequency (Hz)');
    legend([h1, h2, h3], {'From Time Series (FFT single-sided)', 'From Time Series (FFT double-sided \times 2)', 'From JONSWAP Spectrum'}, 'Location', 'best');
    title('Spectrum Comparison');


    % Organizing output results 
    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;       


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);

elseif strcmp(action, 'logical_instance_20')
%==================== LOGICAL INSTANCE 20 ====================
%=============================================================    
    % PIERSON-MOSKOWITZ SPECTRUM MODEL (ONLINE):     
    % Purpose of this Logical Instance: to generate the waves from the
    % Jonswap spectrum, according to IEC 61400-3 and ISO19901-1.


    % ---------- Defining test variable ----------
    who.testvariable = 'Test variable, in [unit in SI]';
    s.testvariable = 2025;
    

    % Organizing output results 
    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;       



    % Organizing output results 
    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    if (s.Option06f7 == 2) || (s.Option06f7 == 3)
        % Plot
        System_WavesCurrentsIEC614001_3('logical_instance_22');
        %
    end


    % Return to Logical Instance 03


elseif strcmp(action, 'logical_instance_21')
%==================== LOGICAL INSTANCE 21 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves actual waves and currents
    % values, based on the last time.

    % Organizing output results


    % ---------- LOGICAL INSTANCE 04  ----------
    

    % ---------- LOGICAL INSTANCE 05  ----------


    % ---------- LOGICAL INSTANCE 06  ----------


    % ---------- LOGICAL INSTANCE 07  ----------


    % ---------- LOGICAL INSTANCE 08  ----------
    

    % ---------- LOGICAL INSTANCE 09  ----------


    % ---------- LOGICAL INSTANCE 10  ----------


    % ---------- LOGICAL INSTANCE 11  ----------


    % ---------- LOGICAL INSTANCE 12  ----------



    % Organizing output results 
    Waves_IEC614001_3.testvariable = s.testvariable;
    Currents_IEC614001_3.testvariable = s.testvariable;    


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);
    assignin('base', 'Currents_IEC614001_3', Currents_IEC614001_3);


    % Return to Logical Instance 03


elseif strcmp(action, 'logical_instance_22')
%==================== LOGICAL INSTANCE 22 ====================
%=============================================================    
    % PLOT SEA STATE (OFFLINE):   
    % Purpose of this Logical Instance: to plot the results related to the
    % sea state and develop any other calculations, tables and data to 
    % support the analysis of the results.


    % ---------- Plot Jonswap spectrum ----------  
    if s.Option04f7 == 1 
        %
    end



    % ---------- Plot Pierson-Moskowitz spectrum ----------  
    if s.Option04f7 == 2 
        % figure()     
        % plot(s.Time,s.Vews)
        % xlabel('t [seg]', 'Interpreter', 'latex')
        % xlim([0 max(s.Time)])
        % ylabel('Vews [m/s]', 'Interpreter', 'latex')
        % ylim([0.95*min(s.Vews) 1.05*max(s.Vews)])        
        % legend('Actual Effective Wind Speed [m/s]', 'Interpreter', 'latex')
        % title('Actual Effective Wind Speed over time.')
        %        
    end





    % ---------- Plot XXXXXXXXXX ----------  
    % figure()     
    % plot(s.Time,s.Vews)
    % xlabel('t [seg]', 'Interpreter', 'latex')
    % xlim([0 max(s.Time)])
    % ylabel('Vews [m/s]', 'Interpreter', 'latex')
    % ylim([0.95*min(s.Vews) 1.05*max(s.Vews)])        
    % legend('Actual Effective Wind Speed [m/s]', 'Interpreter', 'latex')
    % title('Actual Effective Wind Speed over time.')
    %   

    if s.Option06f7 == 3
        % figure()     
        % plot(s.Time,s.Vews)
        % xlabel('t [seg]', 'Interpreter', 'latex')
        % xlim([0 max(s.Time)])
        % ylabel('Vews [m/s]', 'Interpreter', 'latex')
        % ylim([0.95*min(s.Vews) 1.05*max(s.Vews)])        
        % legend('Actual Effective Wind Speed [m/s]', 'Interpreter', 'latex')
        % title('Actual Effective Wind Speed over time.')
        % 
    end


    % Further processing or end of the recursive calls

    
%=============================================================  
end


% Assign value to variable in specified workspace
assignin('base', 's', s);
assignin('base', 'who', who);
assignin('base', 'Waves_IEC614001_3', Waves_IEC614001_3);
assignin('base', 'Currents_IEC614001_3', Currents_IEC614001_3);


% #######################################################################
end