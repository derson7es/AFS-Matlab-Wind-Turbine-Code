function WindTurbine_OffshoreAssembly_SparBuoyBetti2012(action)
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
% This recursive function contains simulation environment for the hydrodynamic 
% loads, mooring system applied to the platform and the modeling of the forces
% caused by waves and currents. The modeling follows the proposal of the
% author Betti et al. (2012).


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


    % --- Option 01: Plot Wave Particle Velocity Model results ----
    who.Option01f4.Option_01 = 'Option 01 of Recursive Function f4';
    who.Option01f4.about = 'Plot Wave Particle Velocity Model results';
    who.Option01f4.choose_01 = 'Option01f4 == 1 to choose DO NOT plot Wave Particle Velocity Model results.';
    who.Option01f4.choose_02 = 'Option01f4 == 2 to choose PLOT THE MAIN FIGURES of Wave Particle Velocity Model results.';
    who.Option01f4.choose_03 = 'Option01f4 == 3 to choose Plot ALL FIGURES of Wave Particle Velocity Model results';
        % Choose your option:
    s.Option01f4 = 1; 
    if s.Option01f4 == 1 || s.Option01f4 == 2 || s.Option01f4 == 3
        OffshoreAssembly.Option01f4 = s.Option01f4;
    else
        error('Invalid option selected for s.Option01f4. Please choose 1 or 2 or 3.');
    end


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance     
    System_WavesCurrentsIEC614001_3;


    
elseif strcmp(action, 'logical_instance_02')
%==================== LOGICAL INSTANCE 02 ====================
%=============================================================    
    % SETTING KNOWN VALUES BASED ON CHOSEN OPTIONS (OFFLINE):
    % Purpose of this Logical Instance: based on the choices of options 
    % made in Logical Instances 01 of this Recursive Function (f4), all 
    % known values will be calculated or defined offline. The term "offline" 
    % refers to operations conducted before simulating the system. 
    % See references:
    %
    % [Ref. 1] BETTI, Giulio et al. Modeling and control of a floating wind
    % turbine with spar buoy platform. In: 2012 IEEE international energy 
    % conference and exhibition (ENERGYCON). IEEE, 2012. p. 189-194
    %
    % [Ref. 2] JONKMAN, Jason. Definition of the Floating System for Phase 
    % IV of OC3. National Renewable Energy Lab.(NREL), Golden, CO (United
    % States), 2010.
    %
    % [Ref. 3] KIM, Eungsoo; PLATT, Andrew; JONKMAN, Jason. 2nd-order Wave
    % Kinematics Within HydroDyn. 2014.
    %
    % [Ref. 4] INTERNATIONAL ELECTROTECHNICAL COMMISSION et al. Wind energy 
    % generation systems-Part 1: Design requirements. International 
    % Electrotechnical Commission: Geneva, Switzerland, 2019.
    %
    % [Ref. 5] ISO 19901-1:2015, Petroleum and natural gas industries – 
    % Specific requirements for offshore structures – Part 1: Metocean 
    % design and operating conditions.

    % NOTE 0: The variables or parameters that contain the tag, #Other Ref#, 
    % are because Betti 2012 did not define them directly and another 
    % reference was used, preferably related to the OC3 project cited by Betti 2012.



    % ------ Values ​​related to the calculation of Forces Weights ---------   
    who.Mn_off = 'Nacelle Mass, in [kg]. Value used in the platform movement model.';      
    s.Mn_off = 240000;
    who.Mp_offf = 'Mass of the rotor consisting of the blades and the hub, in [kg]. Value used in the platform movement model.';          
    s.Mp_off = 110000;
    who.Ms_off = 'Mass of the structure consisting of the float and the tower, in [kg]. Value used in the platform movement model.';          
    s.Ms_off = 7716048; % According to Betti (2012) is 7716048 kg.  

    who.Js_off = 'The moments of inertia of systems S, in [N].';       
    s.Js_off = 9.369e+09 ;
    who.Jn_off = 'The moments of inertia of systems N,, in [N].';       
    s.Jn_off = 2607890 ;
    who.Jp_off = 'The moments of inertia of systems P,, in [N].';       
    s.Jp_off = 50.365e+6 ; 

    who.dny_off = 'Distance parallel to the tower (vertical) between the center of mass of the Nacelle (BN) and the structure (S), in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';        
    s.dny_off = 175.6386;
    who.dpy_off = 'Distance parallel to the tower (vertical) between the center of mass of the Rotor, hub and blades, (BP) and the structure (S), in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';       
    s.dpy_off = (120 - 34.3991) + 90 ;

    who.dnx_off = 'Distance perpendicular to the tower (horizontal) between the center of mass of the Nacelle (BN) and the structure (S), in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';       
    s.dnx_off = -1.8;
    who.dpx_off = 'Distance perpendicular to the tower (horizontal) between the center of mass of the Rotor (BP) and the structure (S), in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';       
    s.dpx_off = 5.4305;    

    who.DN_off = 'Total Distances between BS and BN, in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';       
    s.DN_off = sqrt( s.dny_off^2 +  s.dnx_off^2 );    
    who.DP_off = 'Total Distances between BS and BP, in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';       
    s.DP_off = sqrt( s.dpy_off^2 +  s.dpx_off^2 );  
    who.MomentArmPlatform = 'Moment arm applied by the platform at the top of the tower, in [m].';
    s.MomentArmPlatform = s.dpy_off ; 

    % ------ Values ​​related to the calculation of Wind Forces ---------   
    who.dT_off = 'Distance between BS and BT. FA, in [m]. Value used in the platform movement model. See figure 1 presented by Betti (2012).';
    s.dT_off = 129.0009 ;
    who.Hdelta_off = 'Coefficients for calculating the aerodynamic thrust of the platform model'; 
    s.Hdelta_off = [732.63 8980.26;980.26 776.22] ;
    who.Fdelta_off = 'Coefficients for calculating the aerodynamic thrust of the platform model.'; 
    s.Fdelta_off = [-168114.24 -140865.82] ;
    who.Cdelta = 'Coefficients for calculating the aerodynamic thrust of the platform model.'; 
    s.Cdelta = 6353438.95;
    who.Xwind_out = 'Wind speed after the rotor, in [m/s]. Value used in the platform movement model.';     
    s.optionsFsolveOff = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);
    % s.Vwind_in = s.WindSpeed_Hub ;
    % s.Fun_wind = @(Xwind_out) ( Xwind_out^3 + s.Vwind_in*Xwind_out^2 - Xwind_out*s.Vwind_in^2 - ( 1 - 2*s.Cp )*s.Vwind_in^3 );    
    % s.Xwind_out = fsolve(s.Fun_wind, s.Uews_full(1) , s.optionsFsolveOff);
    s.Xwind_out = s.Uews_full; % Signal without relative movement

    who.Cdn_off = 'Drag coefficient of the system/nacelle, (N). Value used in the platform movement model.';    
    s.Cdn_off = 1 ;
    who.An_off = 'Frontal section of system/nacelle, (N), in [m^2]. Value used in the platform movement model.';    
    s.An_off = 9.62 ;
    who.CdT_off = 'Drag coefficient of the system/tower, (T). Value used in the platform movement model.';    
    s.CdT_off = 1 ;
    who.hT_off = 'Tower height, in [m]. Value used in the platform movement model.';    
    s.hT_off = s.HtowerG ;
    who.DTw_off = 'Mean tower diameter, in [m]. Value used in the platform movement model.';    
    s.DTw_off = mean( s.DistributionDiameterTower ) ;



    % ------ Values ​​related to the calculation of Buoyancy ---------   
    who.rho_water = 'Water density in [kg/m^3], under standard conditions at 25ºC and 1 [atm].';
    s.rho_water = 1025 ;    
    who.h_off = 'Water depth, in [m].';   
    s.h_off = 320 ;  


    who.DSbott_off = 'The vertical distance between (BS) and the bottom of the structure, in [m].';        
    s.DSbott_off = 34.3991 ;
    who.rg_off = 'The radius of the floating structure, in [m].';         
    s.rg_off = 4.7 ;
    who.Rtb_off = 'The radius of the lowest part of the tower, in [m].';
    s.Rtb_off = 3.25; 
    who.ht_off = 'The height of the submerged part of the tower in undisplaced conditions, in [m].';       
    s.ht_off = 10 ; % #Other Ref# Values ​​adopted from the OC3-Hywind project - (parte inferior da torre submersa)
    who.htc_off = 'The height of the conic part of the cylinder, in [m].';       
    s.htc_off = 3 ; % #Other Ref# Values ​​adopted from the OC3-Hywind project - cone de transição (entre base e torre)
    who.hc_off = 'The height of the cylinder of the cylinder, in [m].';      
    s.hc_off = 117 ; % #Other Ref# Values ​​adopted from the OC3-Hywind project - cilindro submerso principal   
    who.hpt_off = 'The height of the floating structure, in the equilibrium condition and in [m].';       
    s.hpt_off = s.hc_off + s.htc_off ; % According to Betti 2012: s.hpt_off = 120

    who.Vcy_off = 'The volume of the cylinder, in [m^3]';    
    s.Vcy_off = pi*s.rg_off^2*s.hc_off ; % #Other Ref# Correction made, because the author does not multiply by Pi
    who.Vco_off = 'Part of the conical component of the cylinder volume, in [m^3]';       
    s.Vco_off = pi*(s.htc_off/3) * ( s.rg_off^2 + s.Rtb_off^2 + (s.rg_off*s.Rtb_off) ) ; % #Other Ref# Correction made, because the author does not multiply by Pi
    who.Vbt_0 = 'The submerged part of the tower in undisplaced position of the platform, in [m^3]';       
    s.Vbt_0 = pi*s.Rtb_off^2 *  s.ht_off ;
    who.Vg_0 = 'The submerged volume in undisplaced position of the platform, in [m^3].';    
    s.Vg_0 = s.Vcy_off + s.Vco_off + s.Vbt_0 ; % #Other Ref# Values ​​adopted from the OC3-Hywind project pg 6 [Ref. 2], value is approximated 80708100/(s.gravity*s.rho_water)


    % ------ Values ​​related to the calculation of Moring Lines Forces --------- 
    who.DX_off = 'Radius to Anchors from Platform Centerline, in [m]. The distance between the anchor bolts and the axis of the floater in undisplaced conditions.';
    s.DX_off  = 853.87; % Accordint to Betti (2012) and OC3   
    who.la_off = 'Radius to Fairleads from Platform Centerline, in [m]. The horizontal distance between the axis of the cylindrical floater and the fair leads (Fig. 2 in Betti 2012).';  
    s.la_off = 5.2 ; % Accordint to Betti (2012) and OC3   
    who.dt_off = 'The vertical distance between BS and the point of the floater where the chains are hooked, in [m]. See figure 1 presented by Betti (2012).';
    s.dt_off = - 19.9155 ;
    who.Arm_BS_Fairleads = 'The vertical distance between BS and the point of the floater where the chains are hooked, in [m]. See figure 1 presented by Betti (2012).';
    s.Arm_BS_Fairleads = abs(s.dt_off);    
    who.lambdaMLC_off = 'The weight for unit length of the Front Chains (lines 1 and 2 - subscript f), in [N/m]';    
    s.lambdaMLC_off = 698.094 ; % 77.71 [kg/m]*9,81 [m/s^2] =  762.4 {N/m] in Jonkman 2011 (tabela III)
    who.lambdaMLC_Boff = 'The weight for unit length of the Posterior Chain (lines 3 - aligned in the wind direction - subscript b), in [N/m]';    
    s.lambdaMLC_Boff = s.lambdaMLC_off ; % 77.71 [kg/m]*9,81 [m/s^2] =  762.4 {N/m] in Jonkman 2011 (tabela III)
    who.l0_off = 'The total length of the chains, in [m]';      
    s.l0_off = 904.18 ; % 902.2 in Jonkman 2011 (tabela III)
    who.h_fairlead = 'Fairlead depth, in [m].';      
    s.h_fairlead_Jonkman = -70 ; % According OC3 Spar in OpenFast
    s.h_fairlead = - (s.h_fairlead_Jonkman) ; % Convert to Betti Coordinate System (2012)   
    who.Kml_0 = 'Axial stiffness of chains (axial tension in mooring lines), in [N/m].';    
    s.Kml_0 = 384.243e+06 ; % According OC3 Spar in OpenFast
       

    who.xml0_Betti = 'X0 position of a catenary (lines 1 and 2) written in Betti´s coordinate system, in [m]';     
    s.xml0_Betti = s.la_off ; % #Other Ref#    
    who.yml0_Betti = 'Y0 position of a catenary (lines 1 and 2) written in Betti´s coordinate system, in [m]';     
    s.yml0_Betti = ( s.hpt_off - s.DSbott_off + s.dt_off ) ; % #Other Ref#  
    who.xml0B_Betti = 'X0 position of a catenary (line 3) written in Betti´s coordinate system, in [m]';     
    s.xml0B_Betti = - s.la_off ; % #Other Ref#    
    who.yml0B_Betti = 'Y0 position of a catenary (line 3) written in Betti´s coordinate system, in [m]';     
    s.yml0B_Betti = s.yml0_Betti ; % #Other Ref#

    who.xml0_off = 'X0 position of a catenary (lines 1 and 2), in [m]';     
    s.xml0_off = s.DX_off - s.xml0_Betti ; % #Other Ref#    
    who.yml0_off = 'Y0 position of a catenary (lines 1 and 2), in [m]';     
    s.yml0_off = s.h_off - s.yml0_Betti ; % #Other Ref# 
    who.xm12_0 = 'Position X0 at Fairlead attachment point (lines 1 and 2), in [m]';     
    s.xm12_0 = s.xml0_Betti ; % #Other Ref#     
    who.ym12_0 = 'Position Y0 at Fairlead attachment point (lines 1 and 2), in [m]';     
    s.ym12_0 = s.yml0_Betti ; % #Other Ref# 
    who.Theta_m_Chains12 = 'The angle between the chain and the horizontal (lines 1 and 2), in [rad]';  
    s.Theta_m_Chains12 = atan2(s.yml0_off, s.xml0_off);    
    who.CatenaryShape_a12 = 'Parameter that shapes the Catenary (lines 1 and 2), according Behroozi (2018).';         
    s.CatenaryShape_a12 = s.l0_off / tan(s.Theta_m_Chains12) ; % s.Fcatenary_0 / s.lambdaMLC_off ; 
    who.lmean_off = 'Mean length of overhead catenary for lines 1 and 2, in [m]';         
    s.lmean_off = s.CatenaryShape_a12 * tan(s.Theta_m_Chains12) ;       
    who.F_chain12_0 = 'Total chain tension (in equilibrium), written in the XY plane of the plane of Lines 1 and 2 and in [N].';
    s.F_chain12_0 = (s.lambdaMLC_off * s.CatenaryShape_a12) / cos(s.Theta_m_Chains12); % #Other Ref#
    who.Fmlx_off_0 = 'Mooring line strength in the horizontal direction (x), in equilibrium, written in the Betti XY plane and in [N].';
    s.Fmlx_off_0 = s.F_chain12_0 * cos(s.Theta_m_Chains12) * cosd(60) ;
    who.Fmly_off_0 = 'Mooring line strength in the verticall direction (y), in equilibrium, written in the Betti XY plane and in [N].';       
    s.Fmly_off_0 = s.F_chain12_0 * sin(s.Theta_m_Chains12) * cosd(60) ;

    who.xml0_Boff = 'X0 position of a catenary (line 3), in [m]';     
    s.xml0_Boff = s.DX_off + s.xml0B_Betti ; % #Other Ref#   
    who.yml0_Boff = 'Y0 position of a catenary (line 3), in [m]';     
    s.yml0_Boff = s.h_off - s.yml0B_Betti ; % #Other Ref# 
    who.xm3_0 = 'Position X0 at Fairlead attachment point (line 3), in [m]';     
    s.xm3_0 = s.xml0B_Betti ; % #Other Ref#     
    who.ym3_0 = 'Position Y0 at Fairlead attachment point (line 3), in [m]';     
    s.ym3_0 = s.yml0B_Betti ; % #Other Ref#   
    who.Theta_m_Chains3 = 'The angle between the chain and the horizontal (line 3), in [rad]';  
    s.Theta_m_Chains3 = atan2(s.yml0_Boff, s.xml0_Boff);
    who.CatenaryShape_a3 = 'Parameter that shapes the Catenary (line 3), according Behroozi (2018).';         
    s.CatenaryShape_a3 =  s.l0_off / tan(s.Theta_m_Chains3) ; % s.Fcatenary_0 / s.lambdaMLC_off ;
    who.lmean_Boff = 'Mean length of overhead catenary for line 3, in [m]';         
    s.lmean_Boff = s.CatenaryShape_a3 * tan(s.Theta_m_Chains3) ;
    who.F_chain3_0 = 'Total chain tension (line 3), in [N].';
    s.F_chain3_0 = ( (s.lambdaMLC_Boff * s.CatenaryShape_a3) / cos(s.Theta_m_Chains3) ) ;
    who.Fmlx_Boff_0 = 'Mooring line strength in the horizontal direction (x), in [N].';      
    s.Fmlx_Boff_0 = s.F_chain3_0 * cos(s.Theta_m_Chains3) ;
    who.Fmly_Boff_0 = 'Mooring line strength in the verticall direction (y), in [N].';       
    s.Fmly_Boff_0 = s.F_chain3_0 * sin(s.Theta_m_Chains3) ; 


    who.Nml = 'Number of points evaluated in the lines';
    s.Nml = 100 ;       
    who.x0_catenary12 = 'Horizontal position of the front catenary (lines 1 and 2). According to Behroozi (2018).';         
    s.x0_catenary12 = linspace(0, s.xml0_off, s.Nml) ;      
    who.y0_catenary12 = 'Vertical position of the front catenary (lines 1 and 2). According to Behroozi (2018).';         
    s.y0_catenary12 = s.CatenaryShape_a12 .* cosh( s.x0_catenary12 ./ s.CatenaryShape_a12 ) - s.CatenaryShape_a12 ; 
    who.x0_catenary3 = 'Horizontal position of the posterior catenary (line 3). According to Behroozi (2018).';         
    s.x0_catenary3 = linspace(0, s.xml0_Boff, s.Nml) ;      
    who.y0_catenary3 = 'Vertical position of the posterior catenary (line 3). According to Behroozi (2018).';         
    s.y0_catenary3 = s.CatenaryShape_a3 .* cosh( s.x0_catenary3 ./ s.CatenaryShape_a3 ) - s.CatenaryShape_a3 ;   
    s.x0Betti_catenary12 = s.DX_off - s.x0_catenary12 ;
    s.y0Betti_catenary12 = s.h_off - s.y0_catenary12 ;
    s.x0Betti_catenary3 = s.x0_catenary3 - s.DX_off ;
    s.y0Betti_catenary3 = s.h_off - s.y0_catenary3 ;    
    if (s.Option01f4 == 3)  
        % Plot Graphs of the catenary equation
        ymin = min([s.y0Betti_catenary12, s.y0Betti_catenary3]);
        ymax = max([s.y0Betti_catenary12, s.y0Betti_catenary3]);
        dy = ymax - ymin;
        if dy < 1
            dy = 1;
        end
        x12 = cosd(60)*s.x0Betti_catenary12;
        ymin_plot = ymin - 0.05 * dy;
        ymax_plot = ymax + 0.1 * dy;       
        figure;
        plot(x12, s.y0Betti_catenary12, 'b', 'LineWidth', 2);
        hold on;
        plot(s.x0Betti_catenary3, s.y0Betti_catenary3, 'r', 'LineWidth', 2);
        grid off;
        xlabel('Horizontal Position [m]');
        ylabel('Vertical Position [m]');
        title('Profile of Front Catenary (Lines 1 and 2) and Posterior Catenary (Line 3)');
        legend('Front Catenary (Lines 1 and 2)', 'Posterior Catenary (Line 3)', 'Location', 'best');
        xlim([-s.DX_off, s.DX_off]);
        ylim([ymin_plot, ymax_plot]);
        set(gca, 'YDir', 'reverse');
        set(gca, 'XDir', 'reverse');
        %
    end


    % ------ Values ​​related to the calculation of Wave and Drag Forces ---------       
    who.ndg_off = 'Number of drums or cylinders on the platform.';    
    s.ndg_off = 2; % Accoding to Betti (2012), but in this work a greater number of points will be adopted. 
    who.Cdg_perpendicular_OC3 = 'Drag coefficients, in the direction Perpendicular to the axis of the cylinder.';
    s.Cdg_perpendicular_OC3 = 0.6 ; % Accoding to Jonkman (2010, pf 13).    
    who.Cdg_perpendicular_Betti = 'Drag coefficients, in the direction Perpendicular to the axis of the cylinder.';
    s.Cdg_perpendicular_Betti = 1 ; % Accoding to Betti (2012).
    who.Cdg_parallel_Betti = 'Drag coefficients, in the direction Parallel to the axis of the cylinder.';
    s.Cdg_parallel_Betti = 0.006 ; % Accoding to Betti (2012).   
    who.Cdgb_Betti = 'The Drag coefficient of a flat plate Perpendicular to the flow';
    s.Cdgb_Betti = 1.9 ; % Accoding to Betti (2012).    
    who.mx_off = 'The added mass of the floating structure in direction Perpendicular to its axes , in [kg].';
    s.mx_off = 7759100;
    who.my_off = 'The added mass of the floating structure in direction Parallel to its axes , in [kg].';
    s.my_off = 241250000; 



    % Organizing output results    
    OffshoreAssembly.Mn_off = s.Mn_off; OffshoreAssembly.Mp_off = s.Mp_off; OffshoreAssembly.Ms_off = s.Ms_off; OffshoreAssembly.Js_off = s.Js_off; OffshoreAssembly.Jn_off = s.Jn_off; OffshoreAssembly.Jp_off = s.Jp_off;
    OffshoreAssembly.dny_off = s.dny_off; OffshoreAssembly.dpy_off = s.dpy_off;
    OffshoreAssembly.dnx_off = s.dnx_off; OffshoreAssembly.dpx_off = s.dpx_off;
    OffshoreAssembly.DN_off = s.DN_off; OffshoreAssembly.DP_off = s.DP_off; OffshoreAssembly.MomentArmPlatform  = s.MomentArmPlatform ;    
    OffshoreAssembly.dT_off = s.dT_off; OffshoreAssembly.Hdelta_off = s.Hdelta_off; OffshoreAssembly.Fdelta_off = s.Fdelta_off; OffshoreAssembly.Cdelta = s.Cdelta;
    OffshoreAssembly.Cdn_off = s.Cdn_off; OffshoreAssembly.An_off = s.An_off; OffshoreAssembly.CdT_off = s.CdT_off; OffshoreAssembly.hT_off = s.hT_off; OffshoreAssembly.DTw_off = s.DTw_off;
    OffshoreAssembly.rho_water = s.rho_water; OffshoreAssembly.h_off = s.h_off; OffshoreAssembly.DSbott_off = s.DSbott_off;
    OffshoreAssembly.rho_water = s.rho_water ; OffshoreAssembly.h_off = s.h_off ;
    OffshoreAssembly.hpt_off = s.hpt_off; OffshoreAssembly.rg_off = s.rg_off; OffshoreAssembly.Vcy_off = s.Vcy_off; OffshoreAssembly.Vco_off = s.Vco_off; OffshoreAssembly.Vbt_0 = s.Vbt_0; OffshoreAssembly.Vg_0 = s.Vg_0; OffshoreAssembly.Rtb_off = s.Rtb_off; OffshoreAssembly.ht_off = s.ht_off; OffshoreAssembly.htc_off = s.htc_off; OffshoreAssembly.hc_off = s.hc_off;
    OffshoreAssembly.DX_off = s.DX_off; OffshoreAssembly.dt_off = s.dt_off; OffshoreAssembly.lambdaMLC_off = s.lambdaMLC_off; OffshoreAssembly.lambdaMLC_Boff = s.lambdaMLC_Boff; OffshoreAssembly.la_off = s.la_off; OffshoreAssembly.l0_off = s.l0_off; OffshoreAssembly.h_fairlead_Jonkman = s.h_fairlead_Jonkman; OffshoreAssembly.h_fairlead = s.h_fairlead; OffshoreAssembly.Kml_0 = s.Kml_0; OffshoreAssembly.xm12_0 = s.xm12_0; OffshoreAssembly.ym12_0 = s.ym12_0; OffshoreAssembly.F_chain12_0 = s.F_chain12_0; OffshoreAssembly.Fmlx_off_0 = s.Fmlx_off_0; OffshoreAssembly.Fmly_off_0 = s.Fmly_off_0; OffshoreAssembly.xm3_0 = s.xm3_0; OffshoreAssembly.ym3_0 = s.ym3_0 ; OffshoreAssembly.F_chain3_0 = s.F_chain3_0; OffshoreAssembly.Fmlx_Boff_0 = s.Fmlx_Boff_0; OffshoreAssembly.Fmly_Boff_0 = s.Fmly_Boff_0; OffshoreAssembly.x0_catenary12 = s.x0_catenary12; OffshoreAssembly.y0_catenary12 = s.y0_catenary12; OffshoreAssembly.x0_catenary3 = s.x0_catenary3; OffshoreAssembly.y0_catenary3 = s.y0_catenary3;
    OffshoreAssembly.ndg_off = s.ndg_off; OffshoreAssembly.Cdg_perpendicular_OC3 = s.Cdg_perpendicular_OC3; OffshoreAssembly.Cdg_perpendicular_Betti = s.Cdg_perpendicular_Betti; OffshoreAssembly.Cdg_parallel_Betti = s.Cdg_parallel_Betti; OffshoreAssembly.mx_off = s.mx_off; OffshoreAssembly.my_off = s.my_off; OffshoreAssembly.Cdgb_Betti = s.Cdgb_Betti;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to the Logical Instance of "WindTurbineData_NREL5MW('logical_instance_17')".


elseif strcmp(action, 'logical_instance_03')
%==================== LOGICAL INSTANCE 03 ====================
%=============================================================    
    % WAVE KINEMATICS (OFFLINE):     
    % Purpose of this Logical Instance: to represent the kinematics of 
    % waves through the first-order model, described by Jonkman (2014) 
    % and according to HydroDyn. According to "2nd-order Wave Kinematics
    % Within HydroDyn" by Eungsoo Kim, Andrew Platt, and Jason Jonkman (2014)

        % NOTE 1: I will use the coordinate system of the author Jonkman 
        % (2014), to keep the kinematic equations the same as those 
        % implemented by the author, then I make the necessary adaptations
        % to integrate this Wave Kinematics Model into the modeling done
        % in Betti (2012). Jonkman (2014), adopted:


    % ------ Defining COORDINATE SYSTEM KINEMATICS EQUATIONS  (JONKMAN)------  

%   wind      %              Z ^
%   ---->     %                |
              %                |
%    / \      %                |
%   /   \     %  _ _ _ _ _ _ _ SWL (z=0) _ _ _ _ _ _ _ _ _ _ _ > X
%    wave     %                |
              %                |
              % _______________|_______ (The bottom of the ocean or sea , z= - s.h_off) 
              % 

    % SWL == Still Water Line – SWL (origin)
    % z-axis: positive upwards (i.e. depths have negative values);
    % x and y axes: horizontal, oriented according to wave/wind alignment (usually with x against the wind).
    % The assumption is that the wave is aligned with the wind.


    % ------ Values ​​related to the calculation of Wave and Drag Forces --------- 
    if s.Option04f7 == 1 
        who.vf_WaveSpectrum = 'Vector of discrete wave frequencies [Hz] used to define the JONSWAP spectrum. Each element represents a frequency component for spectral synthesis of irregular waves.';
        s.vf_WaveSpectrum = s.vf_Jonswap;
        who.vk_WaveSpectrum = 'Wavenumber calculated by linear dispersion ω² = g·k·tanh(k·h)'; 
        s.vk_WaveSpectrum = s.vk_Jonswap; % Use simplification to generate a single surface wave: k_n = omega_n.^2 / g; % To generate s.vk_Jonswap          
        who.S_WaveSpectrum = 'Spectral energy density vector [m²/Hz] for each frequency component in the JONSWAP spectrum. Represents the distribution of wave energy across discrete frequency bands.';
        s.S_WaveSpectrum = s.S_Jonswap;
        who.eta_WaveSpectrum = 'Water elevation at x1 (origin), summation of waves.';
        s.eta_WaveSpectrum = s.eta_Jonswap ;        
        who.eta_WaveSpectrum_x1 = 'Water elevation at x1 (origin), summation of waves.';
        s.eta_WaveSpectrum_x1 = s.eta_Jonswap ;
        who.eta_WaveSpectrum_x2 = 'Water elevation at x2 (+s.rg_off), summation of waves.';
        s.eta_WaveSpectrum_x2 = s.eta_Jonswap_x2 ;
        who.eta_WaveSpectrum_x3 = 'Water elevation at x3 (-s.rg_off), summation of waves.';
        s.eta_WaveSpectrum_x3 = s.eta_Jonswap_x3;
        who.eta_WaveSpectrum = 'Water elevation mean, summation of waves.';
        s.eta_WaveSpectrum = mean([s.eta_WaveSpectrum_x1 s.eta_WaveSpectrum_x2 s.eta_WaveSpectrum_x3]) ;              
        %
    else
        who.vf_WaveSpectrum = 'Vector of discrete wave frequencies [Hz] used to define the JONSWAP spectrum. Each element represents a frequency component for spectral synthesis of irregular waves.';
        s.vf_WaveSpectrum = s.vf_PMoskowitz;
        who.vk_WaveSpectrum = 'Wavenumber calculated by linear dispersion ω² = g·k·tanh(k·h)'; 
        s.vk_WaveSpectrum = s.vk_PMoskowitz; % Use simplification to generate a single surface wave: k_n = omega_n.^2 / g; % To generate s.vk_Jonswap             
        who.S_WaveSpectrum = 'Spectral energy density vector [m²/Hz] for each frequency component in the JONSWAP spectrum. Represents the distribution of wave energy across discrete frequency bands.';
        s.S_WaveSpectrum = s.S_PMoskowitz;
        who.eta_WaveSpectrum = 'Water elevation at x1 (origin), summation of waves.';
        s.eta_WaveSpectrum = s.eta_PMoskowitz ;
        who.eta_WaveSpectrum_x1 = 'Water elevation at x1 (origin), summation of waves.';
        s.eta_WaveSpectrum_x1 = s.eta_PMoskowitz ;
        who.eta_WaveSpectrum_x2 = 'Water elevation at x2 (+s.rg_off), summation of waves.';
        s.eta_WaveSpectrum_x2 = s.eta_PMoskowitz_x2 ;
        who.eta_x3_WaveSpectrum = 'Water elevation at x3 (-s.rg_off), summation of waves.';
        s.eta_WaveSpectrum_x3 = s.eta_PMoskowitz_x3; 
        who.eta_WaveSpectrum = 'Water elevation mean, summation of waves.';
        s.eta_WaveSpectrum = mean([s.eta_WaveSpectrum_x1 s.eta_WaveSpectrum_x2 s.eta_WaveSpectrum_x3]) ;        
        %
    end
    who.Hs_wave = 'Time vector for wave time series simulation, in [seg].';
    s.Hs_wave = s.Hs_ws ;
    who.Tp_wave = 'Time vector for wave time series simulation, in [seg].';
    s.Tp_wave = s.Tp_ws ;
    who.df_wave = 'The smallst frequency, in [Hz].'; 
    s.df_wave = s.df_sw;  
    who.vt_wave = 'Time vector for wave time series simulation, in [seg].';
    s.vt_wave = s.vt_sw ;% Time vector [s]  


    % ------ Values of the Wave Kinematics Model ----------
    who.Xwa_i = 'Longitudinal position in the domain where the wave will be evaluated, in [m]';
    s.Xwa_i = 0;
    who.WaterDepthVector_i = 'Water depth vector, in [m]';
    s.WaterDepthVector_i = [0:-0.5:-130 -135:-5:-s.h_off]; % From the surface to the bottom (Jonkman system, 2014)

    
    % ---------- Wave model parameters ----------
    who.OmegaWa_n = 'Angular frequency, in [rad/s]';
    s.OmegaWa_n = 2 * pi * s.vf_WaveSpectrum;
    who.Kwa_n = 'Linear dispersion (deep water), in [rad^2/m]';   
    for i = 1:length(s.OmegaWa_n)
        omega_i = s.OmegaWa_n(i);
        eq = @(k) omega_i^2 - s.gravity * k * tanh(k * s.h_off);
        s.Kwa_n(i) = fzero(eq, [1e-6, 100]);  % valor físico para uso em Fcosh e Fsinh        
    end


    who.Phi_wa_n = 'Random phases between 0 and 2pi for each spectral component.';   
    s.Phi_wa_n = rand(1, length(s.vf_WaveSpectrum)) * 2 * pi;

    who.Theta_wa_n = 'Angle of wave propagation in relation to the x-axis, in [rad/s]';
    s.Theta_wa_n = zeros(1, length(s.vf_WaveSpectrum));


    % ---------- Wave Kinematics Model Over Time ---------- 
    who.Nzz = 'Number of points in water depth.';
    s.Nzz = length(s.WaterDepthVector_i);
    who.Ntt = 'Number of time increments.';
    s.Ntt = length(s.Time_ws);
    who.Nzvf = 'Number of discrete wave frequencies increments.';    
    s.Nzvf = length(s.vf_WaveSpectrum);

    who.Vwa_iu_matrix = 'Longitudinal linear velocity matrix (u_x , in the direction of the wave), [m/s]';
    s.Vwa_iu_matrix = zeros(s.Nzz, s.Ntt);    
    who.Vwa_iv_matrix = 'Transversal linear velocity matrix (u_y , perpendicular to the wave propagation), [m/s]';
    s.Vwa_iv_matrix = zeros(s.Nzz, s.Ntt);
    who.Vwa_iw_matrix = 'Vertical linear velocity matrix (u_z , up-down motion of water), [m/s]';
    s.Vwa_iw_matrix = zeros(s.Nzz, s.Ntt);    
    who.Awa_iu_matrix = 'Longitudinal linear acceleration matrix (u_x dot , in the direction of the wave), [m/s]';
    s.Awa_iu_matrix = zeros(s.Nzz, s.Ntt);    
    who.Awa_iv_matrix = 'Transversal linear acceleration matrix (u_y dot , perpendicular to the wave propagation), [m/s]';
    s.Awa_iv_matrix = zeros(s.Nzz, s.Ntt);   
    who.Awa_iw_matrix = 'Vertical linear acceleration matrix (u_z dot , up-down motion of water), [m/s]';
    s.Awa_iw_matrix = zeros(s.Nzz, s.Ntt);  

    who.An_wa = 'Spectral amplitude';  
    s.An_wa = sqrt(2 * s.S_WaveSpectrum * s.df_wave) ;
    who.phase_wa = 'Complete phase';
    s.phase_wa = zeros(s.Nzz, s.Ntt); 

    Z = s.WaterDepthVector_i(:);
    h = s.h_off;
   
    for iz = 1:s.Nzz

        z = Z(iz);

        for n = 1:s.Nzvf
            kn = abs(s.Kwa_n(n));
            omega_n = s.OmegaWa_n(n);
            Phi_n = s.Phi_wa_n(n);
            theta_n = s.Theta_wa_n(n);
            A_n = s.An_wa(n);
            A_n = A_n * exp(-kn * abs(z));  % aplicação suave por profundidade
            phase_t = (omega_n * s.Time_ws) - (kn * s.Xwa_i + Phi_n);
            s.phase_wa(n,:) = phase_t;

            % Zero amplitude protection
            if A_n < 1e-6
                continue;
            end

            % Protection against too small divider
            denom_sinh = sinh(kn * h);
            if denom_sinh < 1e-10 || ~isfinite(denom_sinh)
                continue;
            end

            % Common terms in equations
            Fcosh = cosh(kn * (h + z)) / denom_sinh;
            Fsinh = sinh(kn * (h + z)) / denom_sinh;
           
            DepthDamping = exp(-kn * abs(z));  % ou usar tanh para suavizar
            Fcosh = Fcosh * DepthDamping;
            Fsinh = Fsinh * DepthDamping;

            % Phase components
            cos_ph = cos(phase_t);
            sin_ph = sin(phase_t);

            % Wave Velocity Components
            s.Vwa_iu_matrix(iz,:) = s.Vwa_iu_matrix(iz,:) + A_n * omega_n * Fcosh * cos_ph;
            s.Vwa_iv_matrix(iz,:) = s.Vwa_iv_matrix(iz,:) + A_n * omega_n * Fcosh * cos_ph * sin(theta_n);
            s.Vwa_iw_matrix(iz,:) = s.Vwa_iw_matrix(iz,:) + A_n * omega_n * Fsinh * sin_ph;
            
            % Components of Wave Acceleration
            s.Awa_iu_matrix(iz,:) = s.Awa_iu_matrix(iz,:) - A_n * omega_n^2 * Fcosh * sin_ph;
            s.Awa_iv_matrix(iz,:) = s.Awa_iv_matrix(iz,:) - A_n * omega_n^2 * Fcosh * sin_ph * sin(theta_n);
            s.Awa_iw_matrix(iz,:) = s.Awa_iw_matrix(iz,:) - A_n * omega_n^2 * Fsinh * cos_ph;

        end % for n = 1:s.Nzvf
    end % iz = 1:s.Nzz



    % ---------- Plot Wave Particle Velocity Model results ---------- 
    if (s.Option01f4 == 3)  
        % Plot Velocity and Acceleration at point BS over time
        z_query = 0 ; % -85.6009 OR 0
        t_query = s.Time_ws ;
        Vwa_iu_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Vwa_iu_matrix, t_query, z_query);
        Vwa_iv_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Vwa_iv_matrix, t_query, z_query);
        Vwa_iw_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Vwa_iw_matrix, t_query, z_query);
        
        Awa_iu_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Awa_iu_matrix, t_query, z_query);
        Awa_iv_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Awa_iv_matrix, t_query, z_query);
        Awa_iw_BS_t = interp2(s.Time_ws, s.WaterDepthVector_i, s.Awa_iw_matrix, t_query, z_query);

        figure;
        subplot(1,2,1)
        plot(s.Time_ws, Vwa_iu_BS_t, 'b', ...
            s.Time_ws, Vwa_iv_BS_t, 'g', ...
            s.Time_ws, Vwa_iw_BS_t, 'r')
        grid on
        xlabel('Time [s]')
        ylabel('Velocity [m/s]')
        title('Wave Particle Velocity at point BS over time')
        legend('u_x (longitudinal)','u_y (transversal)','u_z (vertical)','Location','best')
        
        subplot(1,2,2)
        plot(s.Time_ws, Awa_iu_BS_t, 'b', ...
            s.Time_ws, Awa_iv_BS_t, 'g', ...
            s.Time_ws, Awa_iw_BS_t, 'r')
        grid on
        xlabel('Time [s]')
        ylabel('Acceleration [m/s²]')
        title('Wave Particle Acceleration at point BS over time')
        legend('a_x (longitudinal)','a_y (transversal)','a_z (vertical)','Location','best')
        %
    end


    % ------- Plot wave elevation (generated spectrum time series) ---------- 
    if (s.Option02f2 == 2) && (s.Option06f7 == 3)
        % BETTI (2012)
        figure;
        plot( s.vt_wave, s.eta_Jonswap,   'b',  ... % ξ (centro)
              s.vt_wave, s.eta_Jonswap_x2, 'r',  ... % ξ + rg
              s.vt_wave, s.eta_Jonswap_x3, 'g' );    % ξ – rg
        grid off;
        box on;
        xlabel('t [s]');
        ylabel('Water elevation [m]');
        title('Wave Elevation at ξ, ξ+rg and ξ–rg');
        legend('η(ξ)','η(ξ+rg)','η(ξ–rg)','Location','best');
        %
    end


    % NOTE: The values ​​that will be used in other models and that need to 
    % be converted from the Jonkman coordinate system to the adopted one
    % are:
    %
    % s.eta_WaveSpectrum
    % s.eta_WaveSpectrum_x2
    % s.eta_WaveSpectrum_x3
    % s.WaterDepthVector_i
    % s.Vwa_iu
    % s.Vwa_iv
    % s.Vwa_iw
    % s.Awa_iu
    % s.Awa_iv
    % s.Awa_iw    
    
    
    % ------ Defining COORDINATE SYSTEM KINEMATICS EQUATIONS  (BETTI)------  

%   wind      %               
%   ---->     %                |
              %                |
%    / \      %                |
%   /   \     %  _ _ _ _ _ _ _ SWL (z=0) _ _ _ _ _ _ _ _ _ _ _ > X
%    wave     %                |
              %                |
              %            Z   V              
              % _______________|_______ (The bottom of the ocean or sea , z= - s.h_off) 
              % 

    % SWL == Still Water Line – SWL (origin)
    % z-axis: positive downward (i.e. depths have positive values);
    % x and y axes: horizontal, oriented according to wave/wind alignment (usually with x against the wind).
    % The assumption is that the wave is aligned with the wind.


    % Organizing output results    
    OffshoreAssembly.vf_WaveSpectrum = s.vf_WaveSpectrum;
    OffshoreAssembly.S_WaveSpectrum = s.S_WaveSpectrum;
    OffshoreAssembly.eta_WaveSpectrum = s.eta_WaveSpectrum;
    OffshoreAssembly.eta_WaveSpectrum_x1 = s.eta_WaveSpectrum_x2;    
    OffshoreAssembly.eta_WaveSpectrum_x2 = s.eta_WaveSpectrum_x2;
    OffshoreAssembly.eta_WaveSpectrum_x3 = s.eta_WaveSpectrum_x3; 
    OffshoreAssembly.Hs_wave = s.Hs_wave;
    OffshoreAssembly.Tp_wave = s.Tp_wave;   

    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Return to the Logical Instance of "WindTurbineData_NREL5MW('logical_instance_17')".


elseif strcmp(action, 'logical_instance_04')
%==================== LOGICAL INSTANCE 04 ====================
%=============================================================    
    % FLOATING WIND TURBINE INTERACTION WITH THE WIND (ONLINE):     
    % Purpose of this Logical Instance: to represent the interaction of the 
    % offshore assembly or platform with external wind conditions.
    % The values ​​of the wind models are received.


    % -------------Receiving values ​​from the Wind Model ---------
    if it == 1
        who.WindSpeed_Hub = 'Actual Wind speed at the rotor hub height, in [m/s].';
        OffshoreAssembly.WindSpeed_Hub = s.WindSpeed_Hub;

        who.WindSpeed_Toptower = 'Actual Wind speed at the top of the tower, in [m/s].';
        s.WindSpeed_Toptower = zeros(1, s.Nws);
        s.WindSpeed_Toptower = s.WindField_Grid(s.idxsV_Toptower,:,1);   
        OffshoreAssembly.WindSpeed_Toptower = s.WindSpeed_Toptower;  

        who.WindSpeed_CMtower = 'Actual Wind speed at the center of mass of the tower, in [m/s].';
        s.WindSpeed_CMtower = zeros(1, s.Nws);
        s.WindSpeed_CMtower = s.WindField_Grid(s.idxsV_CMtower,:,1);   
        OffshoreAssembly.WindSpeed_CMtower = s.WindSpeed_CMtower;        
    end


    % ------ Values ​​related to the calculation of Forces Wind ---------   
    who.WindSpeed_BP = 'Wind speed at fixed point in BP, in [m/s].';
    s.WindSpeed_BP = interp1(s.Time_ws(1:end-1), s.WindSpeed_Hub , t) ;

    who.WindSpeed_BN = 'Wind speed at fixed point in BN, in [m/s].';
    s.WindSpeed_BN = interp1(s.Time_ws(1:end-1), s.WindSpeed_Toptower , t) ;

    who.WindSpeed_BT = 'Wind speed at fixed point in BT, in [m/s].';
    s.WindSpeed_BT = interp1(s.Time_ws(1:end-1), s.WindSpeed_CMtower , t) ;    
    
   

    % ---------- Receiving values ​​from interaction with the wind turbine ----------
    who.Uews = 'Effective Wind Speed without relative motion effects, in [m/s].'; 
    OffshoreAssembly.Uews(it) = s.Uews;
    who.Vews = 'Effective Wind Speed ​​with spatial, rotational and relative motion effects, in [m/s].';        
    OffshoreAssembly.Vews(it) = s.Vews ;
    who.Cp = 'Power coefficient at the current operating point';    
    OffshoreAssembly.Cp(it) = s.Cp ;
    who.Beta = 'Collective Blade Pitch of the Wind Turbine, in [deg].';
    OffshoreAssembly.Beta(it) = s.Beta ;


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_05');



elseif strcmp(action, 'logical_instance_05')
%==================== LOGICAL INSTANCE 05 ====================
%=============================================================    
    % WAVE KINEMATICS (ONLINE):     
    % Purpose of this Logical Instance: to represent the kinematics of 
    % waves through the first-order model, described by Jonkman (2014) 
    % and according to HydroDyn. According to "2nd-order Wave Kinematics
    % Within HydroDyn" by Eungsoo Kim, Andrew Platt, and Jason Jonkman (2014)

        % NOTE 1: I will use the coordinate system of the author Jonkman 
        % (2014), to keep the kinematic equations the same as those 
        % implemented by the author, then I make the necessary adaptations
        % to integrate this Wave Kinematics Model into the modeling done
        % in Betti (2012). Jonkman (2014), adopted:


    % ------ Defining COORDINATE SYSTEM KINEMATICS EQUATIONS  (JONKMAN)------  

%   wind      %              Z ^
%   ---->     %                |
              %                |
%    / \      %                |
%   /   \     %  _ _ _ _ _ _ _ SWL (z=0) _ _ _ _ _ _ _ _ _ _ _ > X
%    wave     %                |
              %                |
              % _______________|_______ (The bottom of the ocean or sea , z= - s.h_off) 
              % 

    % SWL == Still Water Line – SWL (origin)
    % z-axis: positive upwards (i.e. depths have negative values);
    % x and y axes: horizontal, oriented according to wave/wind alignment (usually with x against the wind).
    % The assumption is that the wave is aligned with the wind.



    % ------ Instantaneous Velocities and Accelerations of Water ----------
    who.Vwa_iu = 'Longitudinal linear velocity (u_x , in the direction of the wave), [m/s]';
    s.Vwa_iu = interp1(s.Time_ws, s.Vwa_iu_matrix.', t, 'linear', 0) ;

    who.Vwa_iv = 'Transversal linear velocity (u_y , perpendicular to the wave propagation), [m/s]';
    s.Vwa_iv = interp1(s.Time_ws, s.Vwa_iv_matrix.', t, 'linear', 0);
    
    who.Vwa_iw = 'Vertical linear velocity (u_z , up-down motion of water), [m/s]';
    s.Vwa_iw = interp1(s.Time_ws, s.Vwa_iw_matrix.', t, 'linear', 0);
    
    who.Awa_iu = 'Longitudinal linear acceleration (u_x dot , in the direction of the wave), [m/s]';
    s.Awa_iu = interp1(s.Time_ws, s.Awa_iu_matrix.', t, 'linear', 0);

    who.Awa_iv = 'Transversal linear acceleration (u_y dot , perpendicular to the wave propagation), [m/s]';
    s.Awa_iv = interp1(s.Time_ws, s.Awa_iv_matrix.', t, 'linear', 0);
    
    who.Awa_iw = 'Vertical linear acceleration (u_z dot , up-down motion of water), [m/s]';
    s.Awa_iw = interp1(s.Time_ws, s.Awa_iw_matrix.', t, 'linear', 0);
    
 
    % ---------- Plot Wave Particle Velocity Model results ---------- 
    if (s.Option01f4 == 3)
        % Plot Velocity and Acceleration Profile over Depth        
        figure;
        subplot(1,2,1)
        plot(s.Vwa_iu, s.WaterDepthVector_i, 'b', ...
            s.Vwa_iv, s.WaterDepthVector_i, 'g', ...
            s.Vwa_iw, s.WaterDepthVector_i, 'r')
        grid off
        xlabel('Velocity [m/s]')
        ylabel('Depth [m]')
        title('Wave Particle Velocity Profile over Depth')
        legend('u (long.)','v (transv.)','w (vert.)','Location','best')
        subplot(1,2,2)
        plot(s.Awa_iu, s.WaterDepthVector_i, 'b', ...
            s.Awa_iv, s.WaterDepthVector_i, 'g', ...
            s.Awa_iw, s.WaterDepthVector_i, 'r')
        grid off
        xlabel('Acceleration [m/s²]')
        ylabel('Depth [m]')
        title('Wave Particle Acceleration Profile over Depth')
        legend('a_u','a_v','a_w','Location','best')
        %
    end

    
    % NOTE: The values ​​that will be used in other models and that need to 
    % be converted from the Jonkman coordinate system to the adopted one
    % are:
    %
    % s.eta_WaveSpectrum
    % s.eta_WaveSpectrum_x2
    % s.eta_WaveSpectrum_x3
    % s.WaterDepthVector_i
    % s.Vwa_iu
    % s.Vwa_iv
    % s.Vwa_iw
    % s.Awa_iu
    % s.Awa_iv
    % s.Awa_iw    
    
    
    % ------ Defining COORDINATE SYSTEM KINEMATICS EQUATIONS  (BETTI)------  

%   wind      %               
%   ---->     %                |
              %                |
%    / \      %                |
%   /   \     %  _ _ _ _ _ _ _ SWL (z=0) _ _ _ _ _ _ _ _ _ _ _ > X
%    wave     %                |
              %                |
              %            Z   V              
              % _______________|_______ (The bottom of the ocean or sea , z= - s.h_off) 
              % 

    % SWL == Still Water Line – SWL (origin)
    % z-axis: positive downward (i.e. depths have positive values);
    % x and y axes: horizontal, oriented according to wave/wind alignment (usually with x against the wind).
    % The assumption is that the wave is aligned with the wind.


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);



    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_06');



elseif strcmp(action, 'logical_instance_06')
%==================== LOGICAL INSTANCE 06 ====================
%=============================================================    
    % PLATFORM INTERACTION WITH WIND TURBINE (ONLINE):     
    % Purpose of this Logical Instance: to represent the interaction of the
    % offshore assembly or platform with the wind turbine, i.e. receiving
    % the movement values ​​of the platform and other parameters necessary
    % for the platform model.



    % ---------------- SURGE DYNAMICS --------------------    
          % Surge Dynamics represent the Longitudinal Linear
        % Motion (forward/backward or fore/aft) influenced by environmental
        % conditions, such as head seas or following seas, or by accelerations
        % imparted by the aerodynamic thrust force on the wind turbine rotor.
    who.PNoiseSurge_Ddot = 'Process noise of dynamics of surge, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests        
        s.PNoiseSurge_Ddot = s.PNoiseSurge_Ddot_comp(it);    
    else
        if it == 1
            s.PNoiseSurge_Ddot = 0 ;
        else
            s.PNoiseSurge_Ddot = s.WhiteNoiseP_Surge_Ddot(randi([1, numel(s.WhiteNoiseP_Surge_Ddot)]));       
        end
    end
    who.Surge = 'Position displacement in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m].';
    s.Surge = s.y(15); 
    who.Surge_dot = 'Velocity in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s].';
    s.Surge_dot = s.y(16); 
    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot = 0 + s.PNoiseSurge_Ddot ; % This value will be updated (with noise included)    
  

    % ---------------- SWAY DYNAMICS --------------------
          % Sway Dynamics: to represent the Lateral Linear 
        % Motion (side-to-side or port/starboard) caused by lateral forces 
        % from crosswinds, wave-induced motion, or other environmental factors
        % acting perpendicular to the turbine's longitudinal axis.
    who.PNoiseSway_Ddot = 'Process noise of dynamics of sway, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests
        s.PNoiseSway_Ddot = s.PNoiseSway_Ddot_comp(it);    
    else
        if it == 1
            s.PNoiseSway_Ddot = 0 ;
        else
            s.PNoiseSway_Ddot = s.WhiteNoiseP_Sway_Ddot(randi([1, numel(s.WhiteNoiseP_Sway_Ddot)]));       
        end 
    end       
    who.Sway = 'Position displacement in Sway or Linear Transverse Motion (side to side or port-starboard), in [m].';
    s.Sway = s.y(17); 
    who.Sway_dot = 'Velocity in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s].';
    s.Sway_dot = s.y(18); 
    who.Sway_Ddot = 'Acceleration in Sway or Linear Transverse Motion (side to side or port-starboard), in [m/s^2].';
    s.Sway_Ddot = 0 + s.PNoiseSway_Ddot ;  


    % ---------------- HEAVE DYNAMICS --------------------
            % Heave Dynamics to represent the Vertical Linear 
        % Motion (up and down) induced by wave elevations, buoyant forces, or
        % vertical aerodynamic pressures acting on the wind turbine structure.
    who.PNoiseHeave_Ddot = 'Process noise of dynamics of heave, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests        
        s.PNoiseHeave_Ddot = s.PNoiseHeave_Ddot_comp(it);    
    else
        if it == 1
            s.PNoiseHeave_Ddot = 0 ;
        else
            s.PNoiseHeave_Ddot = s.WhiteNoiseP_Heave_Ddot(randi([1, numel(s.WhiteNoiseP_Heave_Ddot)]));          
        end  
    end          
    who.Heave = 'Position displacement in Heave or Linear Vertical Movement (up/down), in [m].';
    s.Heave = s.y(19); 
    who.Heave_dot = 'Velocity in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s].';
    s.Heave_dot = s.y(20); 
    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot = 0 + s.PNoiseHeave_Ddot ; % This value will be updated (with noise included)


    % ---------------- ROLL DYNAMICS --------------------
            % Roll Dynamics: to represent the Rotational Motion 
        % about the longitudinal axis (tilting to the left/right, or 
        % port/starboard rolling) caused by uneven wave forces, asymmetric
        % aerodynamic loads, or dynamic coupling with sway and heave.
    who.PNoiseRollAngle_Ddot = 'Process noise of dynamics of roll, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests        
        s.PNoiseRollAngle_Ddot = s.PNoiseRollAngle_Ddot_comp(it);    
    else
        if it == 1
            s.PNoiseRollAngle_Ddot = 0 ;
        else
            s.PNoiseRollAngle_Ddot = s.WhiteNoiseP_RollAngle_Ddot(randi([1, numel(s.WhiteNoiseP_RollAngle_Ddot)])); 
        end         
    end              
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



    % ---------------- PITCH DYNAMICS --------------------
            % Pitch Dynamics: to represent the Rotational Motion 
        % about the lateral axis (tilting forward/backward, or bow/stern 
        % pitching) resulting from wave action, varying aerodynamic thrust on
        % the rotor, or changes in the center of mass due to operational loads.
    who.PNoisePitchAngle_Ddot = 'Process noise of dynamics of pitch, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests        
        s.PNoisePitchAngle_Ddot = s.PNoisePitchAngle_Ddot_comp(it);    
    else
        if it == 1
            s.PNoisePitchAngle_Ddot = 0 ;
        else
            s.PNoisePitchAngle_Ddot = s.WhiteNoiseP_PitchAngle_Ddot(randi([1, numel(s.WhiteNoiseP_PitchAngle_Ddot)]));
        end         
    end     
    who.PitchAngle = 'Pitch angle or up/down rotation of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), measured relative to the vertical axis and in [rad].';   
    s.PitchAngle = s.y(23) ; 
    who.PitchAngle_dot = 'Pitch angular velocity or up/down rotation angular velocity of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s].';
    s.PitchAngle_dot = s.y(24); 
    who.PitchAngle_Ddot = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';
    s.PitchAngle_Ddot = 0 + s.PNoisePitchAngle_Ddot ; % This value will be updated (with noise included)      
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


    % ---------------- YAW DYNAMICS --------------------
            % Yaw Dynamics: to represent the Rotational Motion
        % about the vertical axis (rotation to change the turbine's heading) 
        % caused by wind direction shifts, aerodynamic torques, or operational
        % adjustments made by the control system to align the rotor with the wind.
    who.PNoiseYawAngle_Ddot = 'Process noise of dynamics of yaw, in [rad/s^2]';
    if (s.Option04f1 == 1) 
        % Comparison tests        
        s.PNoiseYawAngle_Ddot = s.PNoisePitchAngle_Ddot_comp(it);    
    else
        if it == 1
            s.PNoiseYawAngle_Ddot = 0 ;
        else
            s.PNoiseYawAngle_Ddot = s.WhiteNoiseP_YawAngle_Ddot(randi([1, numel(s.WhiteNoiseP_YawAngle_Ddot)]));
        end        
    end                    
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
    s.dy(15) = s.Surge_dot ;
    s.dy(16) = s.Surge_Ddot ;               
    s.dy(17) = s.Sway_dot ;
    s.dy(18) = s.Sway_Ddot ;              
    s.dy(19) = s.Heave_dot ;
    s.dy(20) = s.Heave_Ddot ; 
    s.dy(21) = s.RollAngle_dot ;
    s.dy(22) = s.RollAngle_Ddot ;    
    s.dy(23) = s.PitchAngle_dot ;
    s.dy(24) = s.PitchAngle_Ddot ;   
    s.dy(25) = s.YawAngle_dot ;
    s.dy(26) = s.YawAngle_Ddot ; 


    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_07');


elseif strcmp(action, 'logical_instance_07')
%==================== LOGICAL INSTANCE 07 ====================
%=============================================================    
    % WEIGHT FORCES (ONLINE):     
    % Purpose of this Logical Instance: presents the force weights of the
    % three components of the general system, applied to their centers of
    % mass, representing three forces aligned with the y-axis


    % ------ Weight force at the center of gravity of each component ---------
    who.Qwe_surge = 'Weight force in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qwe_surge = 0;

    who.Qwe_heave = 'Weight force in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qwe_heave = (s.Mn_off + s.Mp_off + s.Ms_off)*s.gravity;

    who.Qwe_pitch = 'Weight force in the direction of the Degree of Freedom in Pitch, in [N]';    
    s.Qwe_pitch = s.Mn_off*s.gravity*s.dny_off*s.Sine_PitchAngle ...
                  + s.Mp_off*s.gravity*s.dpy_off*s.Sine_PitchAngle ... 
                  + s.Mn_off*s.gravity*s.dnx_off*s.Cosseno_PitchAngle ... 
                  + s.Mp_off*s.gravity*s.dpx_off*s.Cosseno_PitchAngle ;

    % OR
    % s.Qwe_pitch = s.Mn_off*s.dny_off*s.Sine_PitchAngle*s.gravity + s.Mp_off*s.dpy_off*s.Sine_PitchAngle*s.gravity + s.Mn_off*s.dnx_off*s.Cosseno_PitchAngle*s.gravity + s.Mp_off*s.dpx_off*s.Cosseno_PitchAngle*s.gravity ;

    % TESTE
    % s.Qwe_heave = 0 ;  
    % s.Qwe_pitch = 0 ;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_08');
   

%=============================================================
elseif strcmp(action, 'logical_instance_08')
%==================== LOGICAL INSTANCE 08 ====================
%=============================================================    
    % BUOYANCY FORCES (ONLINE):     
    % Purpose of this Logical Instance: to represent the buoyancy force is 
    % aligned with the y-axis, it is an upward force applied at the
    % buoyancy center CS (see Figure 1 in Betti 2012).


    % ------ The submerged volume of the Float ---------  
    who.eta_x1_WaveSpectrum = 'Water elevation at point x3, summation of waves.';       
    s.eta_x1_WaveSpectrum = interp1(s.vt_wave, s.eta_WaveSpectrum_x1, t) ; %  
    who.eta_x2_WaveSpectrum = 'Water elevation at point x3, summation of waves.';       
    s.eta_x2_WaveSpectrum = interp1(s.vt_wave, s.eta_WaveSpectrum_x2, t); % 
    who.eta_x3_WaveSpectrum = 'Water elevation at point x3, summation of waves.';       
    s.eta_x3_WaveSpectrum = interp1(s.vt_wave, s.eta_WaveSpectrum_x3, t) ; %
        % NOTE: The water elevation at the three points: s.eta_x1_WaveSpectrum,
        % s.eta_x2_WaveSpectrum and s.eta_x3_WaveSpectrum are in the Jonkman
        % 2014 coordinate system and need to be converted to the Betti 2012
        % coordinate system.
    who.hw_x1 = 'Instantaneous Water Depth at point x1 , in [m].'; 
    s.hw_x1 = - s.eta_x1_WaveSpectrum ; % – η
    who.hw_x2 = 'Instantaneous Water Depth at point x2 , in [m].'; 
    s.hw_x2 = - s.eta_x2_WaveSpectrum ; % – η
    who.hw_x3 = 'Instantaneous Water Depth at point x3 , in [m].'; 
    s.hw_x3 = - s.eta_x3_WaveSpectrum ; % – η    
    who.h_off = 'Average water depth, assessed between 3 points, in [m].';         
    s.hw_off = mean([s.hw_x1 s.hw_x2 s.hw_x3]) + s.h_off ;    


    who.DeltaHsub_off = 'The increment in the height of the submerged part with respect to the undisplaced configuration, in [m].';    
    s.DeltaHsub_off = (s.hw_off - s.h_off) + s.Heave ;   
    % According to Betti (2012):
    % s.DeltaHsub_off = s.hw_off - s.h_off + s.Heave + s.DSbott_off - s.hpt_off ;


    who.Vg_off = 'The submerged volume of the floater, in [m^3]';
    s.Vg_off = s.Vg_0 + s.DeltaHsub_off*pi*s.Rtb_off^2 ; 
    who.hsub_off = 'The total submerged height, in [m].';        
    s.hsub_off = s.hpt_off + s.DeltaHsub_off ;    
  

    % ------ Cylinder Volumes and Float Components ---------      
    who.Vbt_off = 'The submergedpart of the tower, in [m^3]';       
    s.Vbt_off = pi * s.Rtb_off^2 * ( s.ht_off + s.DeltaHsub_off ) ;

    
    % ------ The submerged volume of the floate ---------       
    who.DSbott_CSoff= 'The distance between CS and the bottom of the floater, in [m].';  
    s.DSbott_CSoff_num = s.Vcy_off*(s.hc_off/2) + ...
        s.Vco_off*( s.hc_off + (s.htc_off/2) ) + ...
        s.Vbt_off*( s.hc_off + s.htc_off + ((s.ht_off + s.DeltaHsub_off)/2) ) ;
    s.DSbott_CSoff = s.DSbott_CSoff_num / ( s.Vcy_off + s.Vco_off + s.Vbt_off )  ; % Equation 17 in Betti (2012)

    who.DG_off = 'The parameter DG';    
    s.DG_off = s.DSbott_CSoff - s.DSbott_off ;


    % ------ Buoyancy force at the center of gravity of each component ---------
    who.Qb_surge = 'Buoyancy force in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qb_surge = 0 ;

    who.Qb_heave = 'Buoyancy force in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qb_heave = - ( s.rho_water * s.Vg_off * s.gravity ) ;

    who.Qb_pitch = 'Buoyancy force in the direction of the Degree of Freedom in Pitch, in [N]';
    s.Qb_pitch = ( s.rho_water * s.Vg_off * s.gravity * s.DG_off * s.Sine_PitchAngle ); 
    %
         

    % TESTE 
    % s.Qb_heave = 0 ;
    % s.Qb_pitch = 0 ; 
    %

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_09'); 


elseif strcmp(action, 'logical_instance_09')
%==================== LOGICAL INSTANCE 09 ====================
%=============================================================    
    % WIND FORCES (ONLINE):     
    % Purpose of this Logical Instance: to represent the wind forces acting
    % on the structure of the floating wind turbine. According to the
    % author Betti (2012), since the structure can move, the wind speed
    % perceived by the blades, "s.Vwind_in, is different from the absolute
    % wind speed "s.Vwind_BP" at point BP, where the thrust on the blades
    % due to the wind is assumed to be applied. Thus, for the system 
    % (floating wind turbine) this approach of Betti (2012) is adopted to
    % calculate the aerodynamic thrust, used in this model, specifically.


    % ---------- Wind Speed ​​before passing through the rotor ----------
    who.Vwind_in = 'Wind speed experienced by the blades, in [m/s].';
    s.Vwind_in = s.WindSpeed_BP + s.Surge_dot + s.MomentArmPlatform*s.PitchAngle_dot*s.Cosseno_PitchAngle ;  


    % ---------- Wind speed after passing the rotor ----------
    who.Xwind_out = 'Wind speed after the rotor, in [m/s]. Value used in the platform movement model.';     
    s.Vwind_out = s.Uews + s.Surge_dot + s.DP_off*s.PitchAngle_dot*s.Cosseno_PitchAngle ; % Adopted by the author of this code 
            % In this code, a different approach to wind was adopted
            % (wind speed model and effective wind speed model).
    % According to Betti (2012):
    % s.optionsFsolveOff = optimoptions(@fsolve,'display','off','tolx',1e-12,'tolfun',1e-12);
    % s.Fun_wind = @(Xwind_out) ( Xwind_out^3 + s.Vwind_in*Xwind_out^2 - Xwind_out*s.Vwind_in^2 - ( 1 - 2*s.Cp )*s.Vwind_in^3 );    
    % try
    %     s.Xwind_out = fsolve(s.Fun_wind, s.Uews , s.optionsFsolveOff);
    %     s.Xwind_out = min(max(abs(real(s.Xwind_out)), 0), 30);
    % catch
    %     disp('Erro no fzero (Offshore). Usando o valor inicial.');
    %     s.Xwind_out = s.Uews; 
    % end
    % s.Vwind_out = s.Xwind_out ;


    % The wind thrust has been modelled with three horizontal point forces
    % (FA, FAN and FAT) applied in BP, BN and BT (see Figure 2 in Betti 2012), respectively.


    % ---------- Aerodynamic Thrust at point (BP)  ----------       
    who.Delta_FAoff = 'Additive thrust correction term. Value used in the platform movement model.';
    s.Delta_FAoff = 0 ;  
            % Note: This value is too large "s.Delta_FAoff"  
    % According to Betti (2012):            
    % s.Beta_DeltaFaoff = s.Beta*(pi/180) ; 
    % vbeta = [ s.Vwind_in,  s.Beta_DeltaFaoff ]; % 1×2       
    % term1  = vbeta * s.Hdelta_off * vbeta.'; % 1×2 * 2×2 * 2×1 → escalar               
    % term2  = s.Fdelta_off * vbeta.'; % 1×2 * 2×1 → escalar                 
    % s.Delta_FAoff = term1 + term2 + s.Cdelta;    
     
    who.Lambda_BP = 'Tip-speed ratio (TSR) at BP point';
    s.Lambda_BP = min(max(((s.Rrd*s.OmegaR)/s.Vwind_out), s.Lambda_min), s.Lambda_max); 
    who.Ct_BP = 'Thrust coefficient at BP point';
    s.Ct_BP = min(max(interp2(s.Lambda_Tab, s.Beta_Tab, s.CT_Tab', s.Lambda_BP, s.Beta), 0), s.CT_max); 
    
    who.FA_off= 'Aerodynamic Thrust at point (BP), in [N].';    
    s.FA_off = 0.5*s.rho*pi*s.Rrd^2*s.Ct_BP*s.Vwind_out^2 ; % Adopted by the author of this code 
    % According to Betti (2012):
    % s.FA_off = 0.5*s.rho*pi*s.Rrd^2*( s.Vwind_in^2 - s.Vwind_out^2 ) + s.Delta_FAoff ;



    % ---------- Aerodynamic Thrust at point (BN)  ----------    
    who.FAN = 'Aerodynamic Thrust at point (BS), in [N].';       
    s.FAN = 0.5*s.rho*s.Cdn_off*s.An_off*s.Cosseno_PitchAngle*( s.WindSpeed_BN + s.Surge_dot + s.DN_off*s.PitchAngle_dot*s.Cosseno_PitchAngle )^2 ;

    % ---------- Aerodynamic Thrust at point (BT)  ----------      
    who.FAT = 'Wind Speed ​​Relative to the Tower Center of Mass (BT) Point, in [N].';       
    s.FAT = 0.5*s.rho*s.CdT_off*s.hT_off*s.DTw_off*s.Cosseno_PitchAngle*( s.WindSpeed_BT + s.Surge_dot + s.dT_off*s.PitchAngle_dot*s.Cosseno_PitchAngle )^2 ;


    % ------ Wind force at the center of gravity of each component ---------
    who.Qwi_surge = 'Wind force in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qwi_surge = - s.FA_off ;
    % According to Betti (2012):
    % s.Qwi_surge = - ( s.FA_off + s.FAN + s.FAT ); % According to Betti (2012):
    
    who.Qwi_heave = 'Wind force in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qwi_heave = 0;

    who.Qwi_pitch = 'Wind force in the direction of the Degree of Freedom in Pitch, in [N]';    
    s.Qwi_pitch = + s.FA_off * s.dpx_off * s.Sine_PitchAngle ...
                  - s.FA_off * s.dpy_off * s.Cosseno_PitchAngle ; % Adoped in this code.
    %
    % According to Betti (2012):
    % s.Qwi_pitch = - s.FA_off * ( ss.dpy_off*s.Cosseno_PitchAngle - s.dpx_off*s.Sine_PitchAngle ) ...
    %               - s.FAN * ( s.dny_off*s.Cosseno_PitchAngle - s.dnx_off*s.Sine_PitchAngle ) ...
    %               - s.FAT*s.dT_off*s.Cosseno_PitchAngle ;    


    % TESTE
    % s.Qwi_surge = 0 ;
    % s.Qwi_pitch = 0 ;

    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_10');


elseif strcmp(action, 'logical_instance_10')
%==================== LOGICAL INSTANCE 10 ====================
%=============================================================    
    % WAVE AND DRAG FORCES (ONLINE):     
    % Purpose of this Logical Instance: to represent the wave and drag forces.
    % The waves are modeled according to the Pierson-Moskowitz spectrum.
    % The hydrodynamic forces are calculated by means of the Morison 
    % equations, using the kinematics of the undisturbed water particles 
    % evaluated at the geometric center of the cylinder. Subsequently, the 
    % sum of these forces is taken to compose the total force acting on the 
    % floating structure. Veer Betti 2012 and Branlard 2010.

    
    % --- Discretization of the points analyzed on the platform -----
    who.Zi_betti = 'Depth of section "i" along the Spar Buoy platform, in the Betti (2012) coordinate system, in [m].';    
    s.ndg_off = 200 ; % s.WaterDepthVector_i    
    s.Zi_betti_0 = 0 ;
    s.Zi_betti_f = s.hsub_off  ;
    % s.Zi_betti = linspace(s.Zi_betti_0,10,0.05*s.ndg_off) ;
    s.Zi_betti = linspace(s.Zi_betti_0,(s.hpt_off - s.DSbott_off),0.70*s.ndg_off) ;
    s.Zi_betti = [s.Zi_betti linspace((s.hpt_off - s.DSbott_off + 0.5),100,0.25*s.ndg_off)] ;
    s.Zi_betti = [s.Zi_betti linspace(110.5,s.Zi_betti_f,(s.ndg_off-0.95*s.ndg_off))] ;    
    % According to Betti (2012):
    % s.ndg_off = 2 ; % s.WaterDepthVector_i
    % for itt = 1:s.ndg_off
    %     s.Zi_betti(itt) = ( itt - 0.5) * (s.hsub_off/s.ndg_off);
    % end


    % -- Wave velocities and accelerations around the structure (in equilibrium) ---
    who.Zi_jonkman = 'Depth coordinate of subcylinder "i" relative to the water surface (Jonkman''s system), in [m]. Positive values are above the surface, negative values are below.';
    s.Zi_jonkman = - s.Zi_betti ;
    s.Zi_jonkman = max(min(s.Zi_jonkman, max(s.WaterDepthVector_i) ), min(s.WaterDepthVector_i) ) ;    

    who.Vwater_x = 'Velocity of the undisturbed water particles evaluated at the geometric center in subcylinder 1, in the X direction and in [m/s].';
    s.Vwater_x = interp1(s.WaterDepthVector_i, s.Vwa_iu, s.Zi_jonkman ) ; % #Other Ref#
    s.Vwater_x = s.Vwater_x ; % Converting the coordinate system from the Jonkman system to the Betti system
    who.VwaterDot_x = 'Acceleration of the undisturbed water particles evaluated at the geometric center in subcylinder 1, in the X direction and in [m/s].';
    s.VwaterDot_x = interp1(s.WaterDepthVector_i, s.Awa_iu, s.Zi_jonkman ) ; % #Other Ref#
    s.VwaterDot_x = s.VwaterDot_x ; % Converting the coordinate system from the Jonkman system to the Betti system
    
    who.Vwater_y = 'Velocity of the undisturbed water particles evaluated at the geometric center in subcylinder 1, in the Y direction and in [m/s].';
    s.Vwater_y = interp1(s.WaterDepthVector_i, s.Vwa_iw, s.Zi_jonkman ) ; % #Other Ref#
    s.Vwater_y = - s.Vwater_y ; % Converting the coordinate system from the Jonkman system to the Betti system
    who.VwaterDot_y = 'Acceleration of the undisturbed water particles evaluated at the geometric center in subcylinder 1, in the Y direction and in [m/s].';
    s.VwaterDot_y = interp1(s.WaterDepthVector_i, s.Awa_iw, s.Zi_jonkman ) ; % #Other Ref#
    s.VwaterDot_y = - s.VwaterDot_y ; % Converting the coordinate system from the Jonkman system to the Betti system

    who.Vwater_Vbottomfloater_x = 'Velocity of the undisturbed water particles at the water surface (z = 0), in the X direction and in [m/s].';    
    s.Vwater_Vbottomfloater_x = s.Vwater_x(1)  ; % #Other Ref# s.Vwater_x(1) OR  s.Vwa_iu(1)
    who.Vwater_Vbottomfloater_y = 'Velocity of the undisturbed water particles at the water surface (z = 0), in the Y direction and in [m/s].';
    s.Vwater_Vbottomfloater_y = s.Vwater_y(1) ; % #Other Ref# s.Vwa_iw(1) OR s.Vwater_y(1)
    %


    if s.Option01f4 == 3
        % Plotting with Betti values
        figure;
        figure('Name','Wave Profile - Betti','NumberTitle','off');
        subplot(1,2,1)
        plot(s.Vwater_x, s.Zi_betti, 'b', s.Vwater_y, s.Zi_betti, 'r')
        set(gca, 'YDir','reverse')
        grid on
        xlabel('Velocity [m/s]')
        ylabel('Depth [m]')
        title('Wave Particle Velocity Profile (Betti)')
        legend('u (long.)','w (vert.)','Location','best')
        subplot(1,2,2)
        plot(s.VwaterDot_x, s.Zi_betti, 'b', s.VwaterDot_y, s.Zi_betti, 'r')
        set(gca, 'YDir','reverse')
        grid on
        xlabel('Acceleration [m/s²]')
        ylabel('Depth [m]')
        title('Wave Particle Acceleration Profile (Betti)')
        legend('a_u','a_w','Location','best')    
        %
    end


    if s.Option01f4 == 3
        % Plotting with Jonkman values
        figure;    
        subplot(1,2,1)
        plot(s.Vwa_iu, s.WaterDepthVector_i, 'b', s.Vwa_iv, s.WaterDepthVector_i, 'g', s.Vwa_iw, s.WaterDepthVector_i, 'r')
        grid on
        xlabel('Velocity [m/s]')
        ylabel('Depth [m]')
        title('Wave Particle Velocity Profile')
        legend('u (long.)','v (transv.)','w (vert.)','Location','best')
        subplot(1,2,2)
        plot(s.Awa_iu, s.WaterDepthVector_i, 'b', s.Awa_iv, s.WaterDepthVector_i, 'g', s.Awa_iw, s.WaterDepthVector_i, 'r')
        grid on
        xlabel('Acceleration [m/s²]')
        ylabel('Depth [m]')
        title('Wave Particle Acceleration Profile')
        legend('a_u','a_v','a_w','Location','best')    
        %
    end


    % ----- Defining the moment arm applied at point BS ---------
    who.hi_op_off = 'The distance of the geometric centre of the 1-th cylinder from the bottom of the floater, in [m]';    
    s.hi_op_off = s.hsub_off - s.Zi_betti  ; % - s.hpt_off -  s.Zi_betti ;
    who.Arm_BS_i = 'The distance between BS and the point where the forces are applied, in [m]';    
    s.Arm_BS_i = ( s.hi_op_off - s.DSbott_off ) ; % ( s.hi_op_off - s.DSbott_off  OR ---- s.Zi_betti - ( s.hpt_off - s.DSbott_off )    


    % ------ Local Velocities and Accelerations of the Structure (in Motion) --------- 
    who.V_parallel = 'Relative velocity between the water and the body immersed in each subcylinder, in the direction Parallel to the axis of the float, in [m/s]';
    s.V_parallel = (s.Surge_dot.*s.Cosseno_PitchAngle) + (s.Arm_BS_i.*s.Cosseno_PitchAngle.*s.Cosseno_PitchAngle.*s.PitchAngle_dot) - (s.Vwater_x.*s.Cosseno_PitchAngle) ...
                   + (s.Heave_dot.*s.Sine_PitchAngle) + (s.Arm_BS_i.*s.Sine_PitchAngle.*s.Sine_PitchAngle.*s.PitchAngle_dot) - (s.Vwater_y.*s.Sine_PitchAngle) ;
    % According to Betti (2012):
    % s.V_parallel = ( s.Surge_dot + s.Arm_BS_i.*s.PitchAngle_dot.*s.Cosseno_PitchAngle - s.Vwater_x ).*s.Cosseno_PitchAngle ...
    %                + ( s.Heave_dot + s.Arm_BS_i.*s.PitchAngle_dot.*s.Sine_PitchAngle - s.Vwater_y ).*s.Sine_PitchAngle ;
    % plot(s.V_parallel)


    who.V_perpendicular = 'Relative velocity between the water and the body immersed in each subcylinder, in the direction Perpendicular to the axis of the float, in [m/s]';
    s.V_perpendicular = - (s.Surge_dot*s.Sine_PitchAngle) - (s.Arm_BS_i.*s.Cosseno_PitchAngle.*s.Sine_PitchAngle.*s.PitchAngle_dot) + (s.Vwater_x.*s.Sine_PitchAngle) ...
                        + (s.Heave_dot.*s.Cosseno_PitchAngle) + (s.Arm_BS_i.*s.Sine_PitchAngle.*s.Cosseno_PitchAngle.*s.PitchAngle_dot) - (s.Vwater_y.*s.Cosseno_PitchAngle) ;
    % According to Betti (2012):
    % s.V_perpendicular = ( s.Surge_dot + s.Arm_BS_i.*s.PitchAngle_dot.*s.Cosseno_PitchAngle - s.Vwater_x ).*(-s.Sine_PitchAngle) ...
    %                     + ( s.Heave_dot + s.Arm_BS_i.*s.PitchAngle_dot.*s.Sine_PitchAngle - s.Vwater_y ).*s.Cosseno_PitchAngle ; % sin(-s.PitchAngle) = - sin(s.PitchAngle)
    % plot(s.V_perpendicular)

    who.Vdot_perpendicular = 'Relative acceleration between the water and the body immersed in each subcylinder, in the direction Perpendicular to the axis of the float, in [m/s^2]';    
    s.Vdot_perpendicular = s.VwaterDot_x.*s.Cosseno_PitchAngle + s.VwaterDot_y.*s.Sine_PitchAngle ;
    % plot(s.Vdot_perpendicular)

    who.Vbottomfloater_perpendicular = 'Relative velocity between the water surface and the body immersed at the surface, in the direction Perpendicular to the axis of the float, in [m/s]';
    s.Vbottomfloater_perpendicular = - (s.Surge_dot*s.Sine_PitchAngle) - (s.Arm_BS_i(end).*s.Cosseno_PitchAngle.*s.Sine_PitchAngle.*s.PitchAngle_dot) + (s.Vwater_Vbottomfloater_x.*s.Sine_PitchAngle) ...
                                     + (s.Heave_dot.*s.Cosseno_PitchAngle) + (s.Arm_BS_i(end).*s.Sine_PitchAngle.*s.Cosseno_PitchAngle.*s.PitchAngle_dot) - (s.Vwater_Vbottomfloater_y.*s.Cosseno_PitchAngle) ;
    % plot(s.Vbottomfloater_perpendicular)


                    %###### Hydraulic drag force ###### 

    % ------ Hydrodynamic Drag Coefficients ---------      
    who.Cdg_perpendicular = 'Drag coefficients, in the direction Perpendicular to the axis of the cylinder.';
    s.Cdg_perpendicular = s.Cdg_perpendicular_OC3 * ones(size(s.hi_op_off)) ;
    who.Cdg_parallel = 'Drag coefficients, in the direction Parallel to the axis of the cylinder.';
    s.Cdg_parallel = s.Cdg_parallel_Betti * ones(size(s.hi_op_off)) ; 


    % ------ Hydraulic drag force on each cylinder ---------  
    who.Qh_surge_i = 'Hydraulic drag in the X direction (Surge) acting on subcylinders i, in [N].';
    s.Qh_surge_i = - 0.5 .* s.Cdg_perpendicular .* s.rho_water .* (2 .* s.rg_off) .* (s.hsub_off ./ s.ndg_off) .* abs(s.V_perpendicular) .* s.V_perpendicular .* s.Cosseno_PitchAngle ...
                   - 0.5 .* s.Cdg_parallel .* s.rho_water .* pi .* (2 .* s.rg_off) .* (s.hsub_off ./ s.ndg_off) .* abs(s.V_parallel) .* s.V_parallel .* s.Sine_PitchAngle;

    who.Qh_heave_i = 'Hydraulic drag in the Y direction (Heave) acting on subcylinders i, in [N].';
    s.Qh_heave_i = - 0.5 .* s.Cdg_perpendicular .* s.rho_water .* (2 .* s.rg_off) .* (s.hsub_off ./ s.ndg_off) .* abs(s.V_perpendicular) .* s.V_perpendicular .* s.Sine_PitchAngle ...
                   - 0.5 .* s.Cdg_parallel .* s.rho_water .* pi .* (2 .* s.rg_off) .* (s.hsub_off ./ s.ndg_off) .* abs(s.V_parallel) .* s.V_parallel .* s.Cosseno_PitchAngle;


    % ------ The Drag forces at the center of gravity of each component ---------
    who.Qh_surge = 'The Drag Forces in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qh_surge = sum(s.Qh_surge_i, 'omitnan') - 0.5 * s.Cdgb_Betti * s.rho_water * pi * s.rg_off^2 * abs(s.Vbottomfloater_perpendicular) * s.Vbottomfloater_perpendicular * s.Sine_PitchAngle ;

    who.Qh_heave = 'The Drag Forces in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qh_heave = sum(s.Qh_heave_i, 'omitnan') - 0.5 * s.Cdgb_Betti * s.rho_water * pi * s.rg_off^2 * abs(s.Vbottomfloater_perpendicular) * s.Vbottomfloater_perpendicular * s.Cosseno_PitchAngle ;

    who.Qh_pitch = 'The Drag Forces in the direction of the Degree of Freedom in Pitch, in [N]';
    s.Qh_pitch = sum( s.Qh_surge_i .* s.Arm_BS_i .* s.Cosseno_PitchAngle + s.Qh_heave_i .* s.Arm_BS_i .* s.Sine_PitchAngle, 'omitnan' );
    


                    %###### The Wave Thrust force ###### 
                    
    % ------ The Wave Thrust force on cylinders --------- 
    who.Qwa_surge_i = 'The wave thrust applied at each subcylinder center and aligned with the X-axis (Surge), in [N]';
    s.Qwa_surge_i = (s.rho_water * s.Vg_off + s.mx_off) .* s.Vdot_perpendicular .* s.Cosseno_PitchAngle .* (1 / s.ndg_off);
    
    who.Qwa_heave_i = 'The wave thrust applied at each subcylinder center and aligned with the Y-axis (Heave), in [N]';
    s.Qwa_heave_i = (s.rho_water * s.Vg_off + s.mx_off) .* s.Vdot_perpendicular .* s.Sine_PitchAngle .* (1 / s.ndg_off);
    

    % ------ The Wave forces at the center of gravity of each component ---------
    who.Qwa_surge = 'The Wave Drag Forces in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qwa_surge = sum(s.Qwa_surge_i, 'omitnan') ;

    who.Qwa_heave = 'The Wave Drag Forces in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qwa_heave = sum(s.Qwa_heave_i, 'omitnan') ;

    who.Qwa_pitch = 'The Wave Forces in the direction of the Degree of Freedom in Pitch, in [N]';
    s.Qwa_pitch = sum( s.Qwa_surge_i .* s.Arm_BS_i .* s.Cosseno_PitchAngle ...
                  + s.Qwa_heave_i .* s.Arm_BS_i .* s.Sine_PitchAngle , 'omitnan') ;



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_11');


elseif strcmp(action, 'logical_instance_11')
%==================== LOGICAL INSTANCE 11 ====================
%=============================================================    
    % MOORING LINES FORCES (ONLINE):     
    % Purpose of this Logical Instance: to represent the real mooring system
    % described in Jonkman (2011) and Betti (2012), which is composed of 
    % three catenary mooring lines distributed uniformly around the platform,
    % thus being separated by an angle of 120º in the non-displaced configuration.
    % To describe it in two dimensions, the same conditions adopted and
    % described in Betti (2012).


    % --- Instantaneous positions of the vertex of the frontal lines -----
    who.xml0_Betti = 'X0 position of a catenary (lines 1 and 2) written in Betti´s coordinate system, in [m]';     
    s.xml0_Betti = s.la_off + s.Surge ; % #Other Ref#            
    who.yml0_Betti = 'Y0 position of a catenary (lines 1 and 2) written in Betti´s coordinate system, in [m]';     
    s.yml0_Betti = ( s.hpt_off - s.DSbott_off + s.dt_off )  + s.Heave ; % #Other Ref#    

    who.xml0B_Betti = 'X0 position of a catenary (line 3) written in Betti´s coordinate system, in [m]';             
    s.xml0B_Betti = s.Surge - s.la_off ; % #Other Ref#        
    who.yml0B_Betti = 'Y0 position of a catenary (line 3) written in Betti´s coordinate system, in [m]';     
    s.yml0B_Betti = ( s.hpt_off - s.DSbott_off + s.dt_off ) + s.Heave ; % #Other Ref#  
        % Note: these coordinates are in the plane of the Betti (2012) 
        % model, adopted in this code.


    % --- Effect of how the lines must restore the platform's movement -----
    % who.Qs_surge = 'Force acting on the structure (except mooring lines) , in the Surge direction and in [N].';    
    % s.Qs_surge = s.Qwe_surge + s.Qwi_surge + s.Qb_surge + s.Qwa_surge + s.Qh_surge ;
    % who.Qs_heave = 'Force acting on the structure (except mooring lines), in the Heave direction and in [N].';    
    % s.Qs_heave = s.Qwe_heave + s.Qwi_heave + s.Qb_heave + s.Qwa_heave + s.Qh_heave ;


           %##### Front Mooring Line (Lines 1 and 2)#####


    % ---- Projection of the Betti Plane onto the Plane of Lines 1 and 2 -------
    who.RotationMatrix_m = 'Angle between the Betti plane and the plane of lines 1 and 2, in [rad].';
    s.Gama_m = deg2rad(60) ;
        % NOTE: The Betti system consists of the XY axes (longitudinal and
        % vertical, respectively) in the model plane (2D Betti plane) and
        % the z-axis (transverse) perpendicular to both axes. Therefore, we
        % want to rotate the 3D axes 60 degrees around the origin and 
        % around the vertical axis. Therefore, we use the Rotation Matrix:
        %
            % x: longitudinal axis (frontal, "forward and backward")
            % y: vertical axis (height, "up and down")
            % z: transverse axis (lateral, "left and right").  
        %     
        % The Rotation Matrix around the vertical axis is:
    who.RotationMatrix_m = 'Rotation matrix from the Betti plane to the plane of lines 1 and 2 at 60°.';
    s.RotationMatrix_m = [cosd(s.Gama_m)    0    sind(s.Gama_m);
                               0         1         0;
                         -sind(s.Gama_m)    0    cosd(s.Gama_m)];
     who.proj2D_BettiPlane = 'Projection vector of the Betti plane onto the plane of lines 1 and 2.';
    s.proj2D_BettiPlane = s.RotationMatrix_m * [s.xml0_Betti;s.yml0_Betti;0] ;


    % ---- Ideal Catenary Model (lines 1 and 2) -------
    who.xml0_off = 'Position X0 of a catenary (lines 1 and 2) written on the line axis (at 60 degrees to the Betti plane), in [m]';     
    s.xml0_off = s.DX_off - s.proj2D_BettiPlane(1) ; % #Other Ref#    
    who.yml0_off = 'Position Y0 of a catenary (lines 1 and 2) written on the line axis (at 60 degrees to the Betti plane), in [m]';     
    s.yml0_off = s.h_off - s.proj2D_BettiPlane(2) ; % #Other Ref#    
    who.Theta_m_Chains12 = 'The angle between the chain and the horizontal (lines 1 and 2), in [rad]';  
    s.Theta_m_Chains12 = atan2(s.yml0_off, s.xml0_off) ; % #Other Ref#
    who.CatenaryShape_a12 = 'Parameter that shapes the Catenary (lines 1 and 2), according Behroozi (2018).';         
    if tan(s.Theta_m_Chains12) == 0
        s.CatenaryShape_a12 =  0 ; 
    else
        s.CatenaryShape_a12 =  sqrt(s.xml0_off^2 + s.yml0_off^2) / tan(s.Theta_m_Chains12) ; 
    end
    who.lmean_off = 'Mean length of overhead catenary for lines 1 and 2, in [m]';        
    s.lmean_off = s.CatenaryShape_a12 * tan(s.Theta_m_Chains12) ; % #Other Ref#

    who.x_catenary12 = 'Horizontal position of the front catenary (lines 1 and 2). According to Behroozi (2018).';         
    s.x_catenary12 = linspace(0, s.xml0_off,  s.Nml) ;      
    who.y_catenary12 = 'Vertical position of the front catenary (lines 1 and 2). According to Behroozi (2018).';  
    if s.CatenaryShape_a12 == 0
        s.y_catenary12 = 0 ;
    else
        s.y_catenary12 = s.CatenaryShape_a12 .* cosh( s.x_catenary12 ./ s.CatenaryShape_a12 ) - s.CatenaryShape_a12 ;     
    end


    % ---- Forces of the Two Front Chains (lines 1 and 2 - subscript f)-------
    who.Delta_Lchain12 = 'Length of chain that has been displaced (lines 1 and 2), in [m]';     
    s.Delta_Lchain12 = s.lmean_off - s.l0_off ; % #Other Ref#     
    if s.lmean_off > s.l0_off
        % Warning! The value (s.lmean_off > s.l0_off) indicates that the
        % chain has stretched, therefore, the Ideal Catenary hypothesis
        % is no longer valid, calculate axial force.          
        %   The Axial force (chain has stretched) is:
        who.F_chain12 = 'Total chain tension, written in the XY plane of the plane of Lines 1 and 2 and in [N].';
        s.F_chain12 = s.Kml_0 * s.Delta_Lchain12 ;
    else
        % Ideal Catenary Assumption
        if (s.yml0_off ~= 0) && (cos(s.Theta_m_Chains12) == 0)
            % Acoording to Betti (2012):
            who.Fmlx_off = 'Mooring line strength in the horizontal direction (x), written in the Betti XY plane and in [N].';
            s.Fmlx_off = s.lambdaMLC_off * s.lmean_off * cosd(60) ;
            who.Fmly_off = 'Mooring line strength in the verticall direction (y), written in the Betti XY plane and in [N].';       
            s.Fmly_off = s.lambdaMLC_off * ( (s.lmean_off^2 - s.yml0_off^2) ...
                          / (2 * s.yml0_off) ) * cosd(60) ;            
            who.F_chain12 = 'Total chain tension, written in the XY plane of the plane of Lines 1 and 2 and in [N].';
            s.F_chain12 = sqrt( s.Fmlx_off^2 + s.Fmly_off^2 );
            %
        elseif (cos(s.Theta_m_Chains12) ~= 0)
            % Acoording to Behroozi (2018):
            who.F_chain12 = 'Total chain tension, written in the XY plane of the plane of Lines 1 and 2 and in [N].';
            s.F_chain12 = (s.lambdaMLC_off * s.CatenaryShape_a12) / cos(s.Theta_m_Chains12) ;
            who.Fmlx_off = 'Mooring line strength in the horizontal direction (x), written in the Betti XY plane and in [N].';
            s.Fmlx_off = s.F_chain12 * cos(s.Theta_m_Chains12) * cosd(60) ;
            who.Fmly_off = 'Mooring line strength in the verticall direction (y), written in the Betti XY plane and in [N].';       
            s.Fmly_off = s.F_chain12 * sin(s.Theta_m_Chains12) * cosd(60) ;
        else
            who.F_chain12 = 'Total chain tension, written in the XY plane of the plane of Lines 1 and 2 and in [N].';
            s.F_chain12 = s.F_chain12_0 ;
            who.Fmlx_off = 'Mooring line strength in the horizontal direction (x), written in the Betti XY plane and in [N].';
            s.Fmlx_off = s.Fmlx_off_0  ;
            who.Fmly_off = 'Mooring line strength in the verticall direction (y), written in the Betti XY plane and in [N].';       
            s.Fmly_off = s.Fmly_off_0 ;            
        end
    end % if s.lmean_off > s.l0_off
  
    who.Qfm_surge = 'Moring Lines Forces in the direction of the Degree of Freedom in Surge (lines 1 and 2), in [N]';    
    s.Qfm_surge = + 2 * s.Fmlx_off ; % It considers both lines.
    who.Qfm_heave = 'Moring Lines Forces in the direction of the Degree of Freedom in Heave (lines 1 and 2), in [N]';    
    s.Qfm_heave = + 2 * s.Fmly_off ; % It considers both lines.
    who.proj2D_Qfm_surge = 'The operator "proj2D_Qfm_surge" the force in the plane considered for the two-dimensional model (lines 1 and 2), in [N]';    
    s.proj2D_Qfm_surge = s.Qfm_surge ;
    % According to Betti (2012):
    % s.proj2D_Qfm_surge = 2*s.Qfm_surge*cosd(60) ; 
    % But the projection of "s.Fmlx_off" is already included within the
    % directorial component in Surge..



       %##### Posterior Mooring Line (Line 3) #####   
         
    % ---- Ideal Catenary Model (line 3) -------
    who.xml0_Boff = 'X0 position of a catenary (line 3), in [m]';     
    s.xml0_Boff = s.DX_off + s.xml0B_Betti ; % #Other Ref#    
    who.yml0_Boff = 'Y0 position of a catenary (line 3), in [m]';       
    s.yml0_Boff = s.h_off - s.yml0B_Betti ; % #Other Ref# 
    who.Theta_m_Chains3 = 'The angle between the chain and the horizontal (line 3), in [rad]';  
    s.Theta_m_Chains3 = atan2(s.yml0_Boff,s.xml0_Boff) ;
    who.CatenaryShape_a3 = 'Parameter that shapes the Catenary (line 3), according Behroozi (2018).';         
    s.CatenaryShape_a3 =  sqrt(s.xml0_Boff^2 + s.yml0_Boff^2) / tan(s.Theta_m_Chains3) ; % s.Fcatenary_0 / s.lambdaMLC_off ;
    who.lmean_Boff = 'Mean length of overhead catenary for line 3, in [m]';         
    s.lmean_Boff = s.CatenaryShape_a3 * tan(s.Theta_m_Chains3) ; % #Other Ref# (no lateral offset (la_off) since line is centered)

    who.x_catenary3 = 'Horizontal position of the posterior catenary (line 3). According to Behroozi (2018).';         
    s.x_catenary3 = linspace(0, s.xml0_Boff,  s.Nml) ;      
    who.y_catenary3 = 'Vertical position of the posterior catenary (line 3). According to Behroozi (2018).';         
    s.y_catenary3 = s.CatenaryShape_a3 .* cosh( s.x_catenary3 ./ s.CatenaryShape_a3 ) - s.CatenaryShape_a3 ;


    % ---- Forces of the Posterior Chain (lines 3 - aligned in the wind direction - subscript b)-------
    who.Delta_Lchain3 = 'Length of chain that has been displaced (line 3), in [m]';     
    s.Delta_Lchain3 = s.lmean_Boff - s.l0_off ; % #Other Ref# 
    if s.lmean_Boff > s.l0_off
        % Warning! The value (s.lmean_Boff > s.l0_off) indicates that the
        % chain has stretched, therefore, the Ideal Catenary hypothesis
        % is no longer valid, calculate axial force.          
        %   The Axial force (chain has stretched) is:
        who.F_chain3 = 'Total chain tension (line 3), in [N].';
        s.F_chain3 = s.Kml_0 * s.Delta_Lchain3 ;
    else
        % Ideal Catenary Assumption
        if (s.yml0_Boff ~= 0) && (cos(s.Theta_m_Chains3) == 0)
            % Acoording to Betti (2012):
            who.Fmlx_Boff = 'Mooring line strength in the horizontal direction (x), in [N].';      
            s.Fmlx_Boff = s.lambdaMLC_Boff*s.lmean_Boff ;
            who.Fmly_Boff = 'Mooring line strength in the verticall direction (y), in [N].';       
            s.Fmly_Boff = s.lambdaMLC_Boff * (( s.lmean_Boff^2 - s.yml0_Boff^2 )/(2*s.yml0_Boff)) ; 
            who.F_chain3 = 'Total chain tension (line 3), in [N].';
            s.F_chain3 = sqrt( s.Fmlx_Boff^2 + s.Fmly_Boff^2 );
            %
        elseif (cos(s.Theta_m_Chains3) ~= 0)
            % Acoording to Behroozi (2018):
            who.F_chain3 = 'Total chain tension (line 3), in [N].';
            s.F_chain3 = ( (s.lambdaMLC_Boff * s.CatenaryShape_a3) / cos(s.Theta_m_Chains3) ) ;
            who.Fmlx_Boff = 'Mooring line strength in the horizontal direction (x), in [N].';      
            s.Fmlx_Boff = s.F_chain3 * cos(s.Theta_m_Chains3) ;
            who.Fmly_Boff = 'Mooring line strength in the verticall direction (y), in [N].';       
            s.Fmly_Boff = s.F_chain3 * sin(s.Theta_m_Chains3) ; 
        else
            who.F_chain3 = 'Total chain tension (line 3), in [N].';
            s.F_chain3 = s.F_chain3_0 ;
            who.Fmlx_Boff = 'Mooring line strength in the horizontal direction (x), in [N].';      
            s.Fmlx_Boff = s.Fmlx_Boff_0 ;
            who.Fmly_Boff = 'Mooring line strength in the verticall direction (y), in [N].';       
            s.Fmly_Boff = s.Fmly_Boff_0 ;             
        end
    end % if s.lmean_off > s.l0_off

    who.Qbm_surge = 'Moring Lines Forces in the direction of the Degree of Freedom in Surge (line 3), in [N]';    
    s.Qbm_surge = s.Fmlx_Boff;
    who.Qbm_heave = 'Moring Lines Forces in the direction of the Degree of Freedom in Heave (line 3), in [N]';    
    s.Qbm_heave = s.Fmly_Boff;


    % ------ Buoyancy force at the center of gravity of each component ---------
    who.Qm_surge = 'Moring Lines Forces in the direction of the Degree of Freedom in Surge, in [N]';    
    s.Qm_surge = s.proj2D_Qfm_surge - s.Qbm_surge ;
        % WARNING! The term "s.proj2D_Qfm_surge" already includes the 
        % projection onto the Betti plane and the contribution of the 
        % two lines. Therefore, I can directly use the force "s.Qm_surge"
        % times an arm written on the Betti plane for the Moment applied
        % to a point written on the Betti plane.

    who.Qm_heave = 'Moring Lines Forces in the direction of the Degree of Freedom in Heave, in [N]';    
    s.Qm_heave = s.Qbm_heave + s.Qfm_heave ;
    % According to Betti (2012):
    % s.Qm_heave = s.Qbm_heave + 2*s.Qfm_heave ;

    who.Qm_pitch = 'Moring Lines Forces in the direction of the Degree of Freedom in Pitch, in [N]';
    s.Qm_pitch = + s.Qfm_surge * s.Arm_BS_Fairleads*s.Cosseno_PitchAngle ...
                 + s.Qfm_surge * s.la_off*s.Sine_PitchAngle ...
                 + s.Qfm_heave * s.Arm_BS_Fairleads*s.Sine_PitchAngle ...                 
                 + s.Qfm_heave * s.la_off*s.Cosseno_PitchAngle ...
                 - s.Qbm_surge * s.Arm_BS_Fairleads*s.Cosseno_PitchAngle ...
                 - s.Qbm_surge * s.la_off*s.Sine_PitchAngle ...
                 - s.Qbm_heave * s.Arm_BS_Fairleads*s.Sine_PitchAngle ...
                 - s.Qbm_heave * s.la_off*s.Cosseno_PitchAngle ;
    % According to Betti (2012):
    % s.Qm_pitch = + 2 * s.Qfm_heave * ( s.dt_off*s.Sine_PitchAngle + s.la_off*s.Cosseno_PitchAngle*cosd(120) ) ... 
    %              + s.Qbm_heave * ( s.dt_off*s.Sine_PitchAngle - s.la_off*s.Cosseno_PitchAngle ) ... 
    %              - s.Qbm_surge * ( s.dt_off*s.Cosseno_PitchAngle + s.la_off*s.Sine_PitchAngle ) ... 
    %              + 2 * s.proj2D_Qfm_surge * ( s.dt_off*s.Cosseno_PitchAngle - s.la_off*s.Sine_PitchAngle*cosd(120) );
    %
    %   NOTE: The last term is incorrectly multiplied, but it is in accordance
    %   with the Betti paper (2012). Analyzing physically, the term is actually
    %   the sum of two contributions and this matches the dimensional analysis 
    %   or the unit of force. I believe it is a spelling error when writing the
    %   equation, so the correction must be made, otherwise the value will be 
    %   disproportionate and will cause numerical errors.


    if (s.Option01f4 == 3)  
        % Plot Graphs of the catenary equation
        s.x0Betti_catenary12 = s.DX_off - s.x0_catenary12 ;
        s.y0Betti_catenary12 = s.h_off - s.y0_catenary12 ;
        s.x0Betti_catenary3 = s.x0_catenary3 - s.DX_off ;
        s.y0Betti_catenary3 = s.h_off - s.y0_catenary3 ;

        s.xBetti_catenary12 = s.DX_off - s.x_catenary12 ;
        s.yBetti_catenary12 = s.h_off - s.y_catenary12 ;
        s.xBetti_catenary3 = s.x_catenary3 - s.DX_off ;
        s.yBetti_catenary3 = s.h_off - s.y_catenary3 ;

        ymin = min([s.y0Betti_catenary12, s.y0Betti_catenary3, s.yBetti_catenary12, s.yBetti_catenary3]);
        ymax = max([s.y0Betti_catenary12, s.y0Betti_catenary3, s.yBetti_catenary12, s.yBetti_catenary3]);
        dy = ymax - ymin;
        if dy < 1
            dy = 1;
        end
        ymin_plot = ymin - 0.05 * dy;
        ymax_plot = ymax + 0.1 * dy;
        
        figure;
        plot(s.x0Betti_catenary12, s.y0Betti_catenary12, 'b', 'LineWidth', 0.5);
        hold on;
        plot(s.xBetti_catenary12, s.yBetti_catenary12, 'b--', 'LineWidth', 2);
        plot(s.x0Betti_catenary3, s.y0Betti_catenary3, 'r', 'LineWidth', 0.5);
        plot(s.xBetti_catenary3, s.yBetti_catenary3, 'r--', 'LineWidth', 2);
        grid on;
        xlabel('Horizontal Position [m]');
        ylabel('Vertical Position [m]');
        title('Profile of Front and Posterior Catenaries — Equilibrium vs Current');
        legend('Front Catenary (Lines 1 and 2) - Equilibrium', ...
            'Front Catenary (Lines 1 and 2) - Current', ...
            'Posterior Catenary (Line 3) - Equilibrium', ...
            'Posterior Catenary (Line 3) - Current', ...
            'Location', 'best');
        xlim([-s.DX_off, s.DX_off]);
        ylim([ymin_plot, ymax_plot]);
        set(gca, 'YDir', 'reverse');
        set(gca, 'XDir', 'reverse');
        %
    end



    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Calling the next logic instance
    WindTurbine_OffshoreAssembly_SparBuoyBetti2012('logical_instance_12');


elseif strcmp(action, 'logical_instance_12')
%==================== LOGICAL INSTANCE 12 ====================
%=============================================================    
    % DYNAMICS OF PLATFORM MOVEMENT (ONLINE):   
    % Purpose of this Logical Instance: presents the equations for the 
    % general structure, considering the 3 DOFs (Surge, Heave and Pitch
    % angle) of the platform movement of a spar buoy.


    % --- Platform Coupled System Parameters -----
    who.MX = 'Equivalent Mass of the System, in the Surge direction, in [kg].';       
    s.MX = s.Ms_off + s.mx_off + s.Mn_off + s.Mp_off ;
    who.MY = 'Equivalent Mass of the System, in the Heave direction, in [kg].';       
    s.MY = s.Ms_off + s.my_off + s.Mn_off + s.Mp_off ;
    who.Md = 'Equivalent Mass of the System, in the Pitch direction, in [kg].';    
    s.Md = s.Mn_off*s.DN_off + s.Mp_off*s.DP_off ;    
    who.JJtot = 'The moments of inertia of systems S, N and P, in [N].';       
    s.JJtot = s.Js_off + s.Jn_off + s.Jp_off + s.Mn_off*s.DN_off^2 + s.Mp_off*s.DP_off^2 ;       



    % --- The overall forces acting on the structure (SP) -----
    who.Q_surge = 'Total Force applied to the structure (SP), in the Surge direction and in [N].';    
    s.Q_surge = s.Qwe_surge + s.Qwi_surge + s.Qb_surge + s.Qm_surge + s.Qwa_surge + s.Qh_surge ;

    who.Q_heave = 'Total Force applied to the structure (SP), in the Heave direction and in [N].';    
    s.Q_heave = s.Qwe_heave + s.Qwi_heave + s.Qb_heave + s.Qm_heave + s.Qwa_heave + s.Qh_heave ;

    who.Q_pitch = 'Total Force applied to the structure (SP), in the Pitch direction and in [N].';
    s.Q_pitch = s.Qwe_pitch + s.Qwi_pitch + s.Qb_pitch + s.Qm_pitch + s.Qwa_pitch + s.Qh_pitch ;

    
    % ---------------- PITCH DYNAMICS -------------------- 
    who.PitchAngle_Ddot = 'Pitch angular acceleration or up/down rotation angular acceleration of the offshore wind turbine structure about its transverse/Y axis (side-to-side or port-starboard), in [rad/s^2].';    
    s.PitchAngle_Ddot = ( s.Q_pitch - (s.Md / s.MX) * s.Cosseno_PitchAngle * s.Q_surge ...
                         - (s.Md / s.MY) * s.Sine_PitchAngle * s.Q_heave ...
                         + ( (1/s.MY) - (1/s.MX) ) * s.Md * s.Sine_PitchAngle * s.Cosseno_PitchAngle * s.PitchAngle_dot^2) ...
                         / ( s.JJtot ...
                             - ( ((s.Md * s.Cosseno_PitchAngle)^2) / s.MX) ...
                             - ( ((s.Md * s.Sine_PitchAngle)^2) / s.MY)  ) ...
                         + s.PNoisePitchAngle_Ddot ;



    % ---------------- SURGE DYNAMICS -------------------- 
    who.Surge_Ddot = 'Acceleration in Surge or Linear Longitudinal Movement (front/back or bow/stern), in [m/s^2].';
    s.Surge_Ddot = (1/s.MX) * ( s.Q_surge + s.Md * s.Sine_PitchAngle * s.PitchAngle_dot^2 - s.Md * s.Cosseno_PitchAngle * s.PitchAngle_Ddot ) + s.PNoiseSurge_Ddot ;


    % ---------------- HEAVE DYNAMICS --------------------
    who.Heave_Ddot = 'Acceleration in Heave or Linear Transverse Movement (side to side or port-starboard), in [m/s^2].';
    s.Heave_Ddot = (1/s.MY) * ( s.Q_heave - s.Md * s.Cosseno_PitchAngle * s.PitchAngle_dot^2 - s.Md * s.Sine_PitchAngle * s.PitchAngle_Ddot ) + s.PNoiseHeave_Ddot ;


    % ----- Updating and Packaging values ​​for the Simulation Integrator Input ------
    who.dy = 'First time derivative of the state variables.'; 
    s.dy(15) = s.Surge_dot ; % Updating
    s.dy(16) = s.Surge_Ddot ; % Updating 
    s.dy(19) = s.Heave_dot ; % Updating
    s.dy(20) = s.Heave_Ddot ; % Updating   
    s.dy(23) = s.PitchAngle_dot ; % Updating 
    s.dy(24) = s.PitchAngle_Ddot ; % Updating 

    if s.Option04f3 == 2
        % Tower Kinematics (Xt computed from platform motion)
        s.Xt_dot  = s.Surge_dot + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_dot;
        s.Xt_Ddot = s.Surge_Ddot ...
                    - s.MomentArmPlatform * s.Sine_PitchAngle * s.PitchAngle_dot^2 ...
                    + s.MomentArmPlatform * s.Cosseno_PitchAngle * s.PitchAngle_Ddot;
        % s.Xt = s.Surge + s.MomentArmPlatform * s.Sine_PitchAngle ;        
        s.dy(7) = s.Xt_dot;    
        s.dy(8) = s.Xt_Ddot;   
        %
    end

        %##### ADJUSTING TO THE TOWER DYNAMICS MODEL #####
        % Note: Note: Adjust these parameters for use in the dynamics 
        % of the tower top movement, according to the models by Jonkman 
        % (2008) and Abbas (2022). I have assigned any values for now, 
        % as this will be future work and will be adjusted and validated
        % in future versions (if any).

        
    % --- INERTIA AND COUPLED MASS ---
    who.I_mass = 'The total inertial in all DOF considered and associated with wind turbine and offshore assembly mass, in [kg·m²]';
    s.I_mass = s.JJtot;

    who.A_Radiation = 'The added inertia (added mass) associated with hydrodynamic radiation in DOF considered, in [kg·m²]';
    s.A_Radiation = 0.70 * s.I_mass ; % According to OC3 or Adopting 5% of the rotational inertia value  


    % --- HYDROSTATIC RIGIDITY ---
    who.C_Hydrostatic = 'The hydrostatic restoring in DOF considered, in [N·m]';
    s.C_Hydrostatic = s.rho_water * s.Vg_off * s.gravity * s.DG_off; % OR 2*(s.rho_water * s.Vg_off * s.gravity * s.DG_off)

    
    % --- MOORING LINES RIGIDITY (linearized by Pitch) ---
    who.C_Lines = 'The linearized hydrostatic restoring from mooring lines in DOF considered, in [N·m]';
    theta_max = deg2rad(10);
    theta_min = deg2rad(0.01);
    angle_reg = min( max(abs(s.PitchAngle), theta_min), theta_max) ;
    if (it == 1) || ( angle_reg == 0)
        s.C_Lines = 1.05e+10 ; 
    else
        s.C_Lines = 0.10 * ( abs(s.Qm_pitch) / angle_reg) ;
    end


    % --- HYDRODYNAMIC RADIATION DAMPING ---
    who.B_Radiation = 'The damping associated with hydrodynamic radiation in DOF considered, in [N·s·m]';
    xi_r = 0.07;  % 5% critical damping
    Keff = max(min(s.C_Hydrostatic + s.C_Lines, 1e11), 1e2);  % Avoid too small or too large Keff   
    s.B_Radiation = 2 * xi_r * sqrt(s.I_mass * Keff) ;


    % --- LINEARIZED VISCOUS DAMPING ---
    who.B_Viscous = 'The linearized viscous drag damping in DOF considered, in [N·s·m]';
    if abs(s.PitchAngle_dot) > 1e-6
        s.B_Viscous = abs(s.Qh_pitch / s.PitchAngle_dot);
    else
        s.B_Viscous = 0.0066 * sqrt(s.I_mass * Keff);  % Conservative (safe) value
    end

    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);


    % Returns to "WindTurbine('logical_instance_07')" 


elseif strcmp(action, 'logical_instance_13')
%==================== LOGICAL INSTANCE 13 ====================
%=============================================================    
    % SAVE CURRENT VALUE (ONLINE):   
    % Purpose of this Logical Instance: to saves current floating wind turbine
    % values, based on the last sampling.

    % Organizing output results


    % ---------- LOGICAL INSTANCE 04  ----------   
    OffshoreAssembly.WindSpeed_BP(it) = s.WindSpeed_BP;
    OffshoreAssembly.WindSpeed_BN(it) = s.WindSpeed_BN;
    OffshoreAssembly.WindSpeed_BT(it) = s.WindSpeed_BT;


    % ---------- LOGICAL INSTANCE 05  ----------        
    OffshoreAssembly.h_off  = s.h_off;
    OffshoreAssembly.Xwa_i = s.Xwa_i;
    OffshoreAssembly.WaterDepthVector_i = s.WaterDepthVector_i;
    OffshoreAssembly.OmegaWa_n = s.OmegaWa_n;
    OffshoreAssembly.Kwa_n = s.Kwa_n;
    OffshoreAssembly.Phi_wa_n = s.Phi_wa_n;
    OffshoreAssembly.Vwa_iu(:,it) = s.Vwa_iu;
    OffshoreAssembly.Vwa_iv(:,it) = s.Vwa_iv;
    OffshoreAssembly.Vwa_iw(:,it) = s.Vwa_iw;    
    OffshoreAssembly.Awa_iu(:,it) = s.Awa_iu;
    OffshoreAssembly.Awa_iv(:,it) = s.Awa_iv;
    OffshoreAssembly.Awa_iw(:,it) = s.Awa_iw; 


    % ---------- LOGICAL INSTANCE 06  ----------  
    OffshoreAssembly.PNoiseSurge_Ddot(it) = s.PNoiseSurge_Ddot;
    OffshoreAssembly.Surge(it) = s.Surge; WindTurbineOutput.Surge(it) = s.Surge;
    % OffshoreAssembly.Surge_dot(it) = s.Surge_dot; WindTurbineOutput.Surge_dot(it) = s.Surge_dot;
    % OffshoreAssembly.Surge_Ddot(it) = s.Surge_Ddot; WindTurbineOutput.Surge_Ddot(it) = s.Surge_Ddot;
    OffshoreAssembly.PNoiseSway_Ddot(it) = s.PNoiseSway_Ddot;
    OffshoreAssembly.Sway(it) = s.Sway; WindTurbineOutput.Sway(it) = s.Sway;
    % OffshoreAssembly.Sway_dot(it) = s.Sway_dot; WindTurbineOutput.Sway_dot(it) = s.Sway_dot;
    % OffshoreAssembly.Sway_Ddot(it) = s.Sway_Ddot; WindTurbineOutput.Sway_Ddot(it) = s.Sway_Ddot;      
    OffshoreAssembly.PNoiseHeave_Ddot(it) = s.PNoiseHeave_Ddot;
    OffshoreAssembly.Heave(it) = s.Heave; WindTurbineOutput.Heave(it) = s.Heave;  
    % OffshoreAssembly.Heave_dot(it) = s.Heave_dot; WindTurbineOutput.Heave_dot(it) = s.Heave_dot;
    % OffshoreAssembly.Heave_Ddot(it) = s.Heave_Ddot; WindTurbineOutput.Heave_Ddot(it) = s.Heave_Ddot;
    OffshoreAssembly.PNoiseRollAngle_Ddot(it) = s.PNoiseRollAngle_Ddot;
    OffshoreAssembly.Gama_RollAngle(it) = s.Gama_RollAngle; WindTurbineOutput.Gama_RollAngle(it) = s.Gama_RollAngle;    
    OffshoreAssembly.RollAngle(it) = s.RollAngle; WindTurbineOutput.RollAngle(it) = s.RollAngle;
    % OffshoreAssembly.RollAngle_dot(it) = s.RollAngle_dot; WindTurbineOutput.RollAngle_dot(it) = s.RollAngle_dot;
    % OffshoreAssembly.RollAngle_Ddot(it) = s.RollAngle_Ddot; WindTurbineOutput.RollAngle_Ddot(it) = s.RollAngle_Ddot;
    OffshoreAssembly.PNoisePitchAngle_Ddot(it) = s.PNoisePitchAngle_Ddot;
    OffshoreAssembly.Gama_PitchAngle(it) = s.Gama_PitchAngle; WindTurbineOutput.Gama_PitchAngle(it) = s.Gama_PitchAngle;
    OffshoreAssembly.PitchAngle(it) = s.PitchAngle; WindTurbineOutput.PitchAngle(it) = s.PitchAngle; 
    % OffshoreAssembly.PitchAngle_dot(it) = s.PitchAngle_dot; WindTurbineOutput.PitchAngle_dot(it) = s.PitchAngle_dot; 
    % OffshoreAssembly.PitchAngle_Ddot(it) = s.PitchAngle_Ddot; WindTurbineOutput.PitchAngle_Ddot(it) = s.PitchAngle_Ddot; 
    OffshoreAssembly.PNoiseYawAngle_Ddot(it) = s.PNoiseYawAngle_Ddot;
    OffshoreAssembly.Gama_YawAngle(it) = s.Gama_YawAngle; WindTurbineOutput.Gama_YawAngle(it) = s.Gama_YawAngle;
    OffshoreAssembly.YawAngle(it) = s.YawAngle; WindTurbineOutput.YawAngle(it) = s.YawAngle;    
    % OffshoreAssembly.YawAngle_dot(it) = s.YawAngle_dot; WindTurbineOutput.YawAngle_dot(it) = s.YawAngle_dot;
    % OffshoreAssembly.YawAngle_Ddot(it) = s.YawAngle_Ddot; WindTurbineOutput.YawAngle_Ddot(it) = s.YawAngle_Ddot; 
    
      

    % ---------- LOGICAL INSTANCE 07  ----------   
    OffshoreAssembly.Qwe_surge(it) = s.Qwe_surge; OffshoreAssembly.Qwe_heave(it) = s.Qwe_heave; OffshoreAssembly.Qwe_pitch(it) = s.Qwe_pitch;    


    % ---------- LOGICAL INSTANCE 08  ----------  
    % Organizing output results    
    OffshoreAssembly.hw_off(it) = s.hw_off; OffshoreAssembly.DeltaHsub_off(it) = s.DeltaHsub_off; OffshoreAssembly.Vg_off(it) = s.Vg_off; OffshoreAssembly.hsub_off(it) = s.hsub_off ;
    OffshoreAssembly.Vbt_off(it) = s.Vbt_off;
    OffshoreAssembly.hpt_off(it) = s.hpt_off;
    OffshoreAssembly.DSbott_CSoff(it) = s.DSbott_CSoff; OffshoreAssembly.DG_off(it) = s.DG_off; 
    OffshoreAssembly.Qb_surge(it) = s.Qb_surge; OffshoreAssembly.Qb_heave(it) = s.Qb_heave; OffshoreAssembly.Qb_pitch(it) = s.Qb_pitch;  


    % ---------- LOGICAL INSTANCE 09  ----------   
    OffshoreAssembly.Vwind_in(it) = s.Vwind_in; OffshoreAssembly.Vwind_out(it) = s.Vwind_out; OffshoreAssembly.Delta_FAoff(it) = s.Delta_FAoff;    
    OffshoreAssembly.FA_off(it) = s.FA_off; OffshoreAssembly.FAN(it) = s.FAN; OffshoreAssembly.FAT(it) = s.FAT;
    OffshoreAssembly.Qwi_surge(it) = s.Qwi_surge; OffshoreAssembly.Qwi_heave(it) = s.Qwi_heave; OffshoreAssembly.Qwi_pitch(it) = s.Qwi_pitch;
    

    % ---------- LOGICAL INSTANCE 10  ----------     
    OffshoreAssembly.hi_op_off(it,:) = s.hi_op_off ;
    OffshoreAssembly.Vwater_x(it,:)  = s.Vwater_x;
    OffshoreAssembly.VwaterDot_x(it,:) = s.VwaterDot_x;
    OffshoreAssembly.Vwater_y(it,:)  = s.Vwater_y;
    OffshoreAssembly.VwaterDot_y(it,:)  = s.VwaterDot_y;
    OffshoreAssembly.Vwater_Vbottomfloater_x(it) = s.Vwater_Vbottomfloater_x; 
    OffshoreAssembly.Vwater_Vbottomfloater_y(it) = s.Vwater_Vbottomfloater_y; 
    OffshoreAssembly.V_parallel(it,:) = s.V_parallel;
    OffshoreAssembly.V_perpendicular(it,:) = s.V_perpendicular;
    OffshoreAssembly.Vdot_perpendicular(it,:) = s.Vdot_perpendicular;
    OffshoreAssembly.Vbottomfloater_perpendicular(it,:)= s.Vbottomfloater_perpendicular ;
    OffshoreAssembly.Cdg_perpendicular = s.Cdg_perpendicular;    
    OffshoreAssembly.Cdg_parallel = s.Cdg_parallel;
    OffshoreAssembly.Qh_surge_i(it,:) = s.Qh_surge_i ;
    OffshoreAssembly.Qh_heave_i(it,:) = s.Qh_heave_i ;
    OffshoreAssembly.Qh_surge(it) = s.Qh_surge ;
    OffshoreAssembly.Qh_heave(it) = s.Qh_heave ;
    OffshoreAssembly.Qh_pitch(it) = s.Qh_pitch ;
    OffshoreAssembly.Qwa_surge_i(it,:) = s.Qwa_surge_i ;
    OffshoreAssembly.Qwa_heave_i(it,:) = s.Qwa_heave_i ;
    OffshoreAssembly.Qwa_surge(it) = s.Qwa_surge ;
    OffshoreAssembly.Qwa_heave(it) = s.Qwa_heave ;
    OffshoreAssembly.Qwa_pitch(it) = s.Qwa_pitch ;


    % ---------- LOGICAL INSTANCE 11  ---------- 
    OffshoreAssembly.xml0_Betti(it) = s.xml0_Betti; OffshoreAssembly.yml0_Betti(it) = s.yml0_Betti; OffshoreAssembly.xml0B_Betti(it) = s.xml0B_Betti; OffshoreAssembly.yml0B_Betti(it) = s.yml0B_Betti;
    OffshoreAssembly.xml0_off(it) = s.xml0_off; OffshoreAssembly.yml0_off(it) = s.yml0_off; OffshoreAssembly.Theta_m_Chains12(it) = s.Theta_m_Chains12; OffshoreAssembly.CatenaryShape_a12(it) = s.CatenaryShape_a12; OffshoreAssembly.lmean_off(it) = s.lmean_off; OffshoreAssembly.Delta_Lchain12(it) = s.Delta_Lchain12; OffshoreAssembly.x_catenary12(it,:) = s.x_catenary12; OffshoreAssembly.y_catenary12(it,:) = s.y_catenary12; OffshoreAssembly.F_chain12(it) = s.F_chain12; OffshoreAssembly.Fmlx_off(it) = s.Fmlx_off; OffshoreAssembly.Fmly_off(it) = s.Fmly_off; OffshoreAssembly.Qfm_surge(it) = s.Qfm_surge; OffshoreAssembly.Qfm_heave(it) = s.Qfm_heave;  
    OffshoreAssembly.xml0_Boff(it) = s.xml0_Boff; OffshoreAssembly.yml0_Boff(it) = s.yml0_Boff; OffshoreAssembly.Theta_m_Chains3(it) = s.Theta_m_Chains3; OffshoreAssembly.CatenaryShape_a3(it) = s.CatenaryShape_a3; OffshoreAssembly.lmean_Boff(it) = s.lmean_Boff; OffshoreAssembly.Delta_Lchain3(it) = s.Delta_Lchain3; OffshoreAssembly.x_catenary3(it,:) = s.x_catenary3; OffshoreAssembly.y_catenary3(it,:) = s.y_catenary3; OffshoreAssembly.F_chain3(it) = s.F_chain3; OffshoreAssembly.Fmlx_Boff(it) = s.Fmlx_Boff; OffshoreAssembly.Fmly_Boff(it) = s.Fmly_Boff; OffshoreAssembly.Qbm_surge(it) = s.Qbm_surge; OffshoreAssembly.Qbm_heave(it) = s.Qbm_heave;    
    OffshoreAssembly.Qm_surge(it) = s.Qm_surge; OffshoreAssembly.Qm_heave(it) = s.Qm_heave; OffshoreAssembly.Qm_pitch(it) = s.Qm_pitch;



    % ---------- LOGICAL INSTANCE 12  ----------  
    OffshoreAssembly.MX(it) = s.MX; OffshoreAssembly.MY(it) = s.MY; OffshoreAssembly.Md(it) = s.Md; OffshoreAssembly.JJtot(it) = s.JJtot;
    OffshoreAssembly.Q_surge(it) = s.Q_surge; OffshoreAssembly.Q_heave(it) = s.Q_heave; OffshoreAssembly.Q_pitch(it) = s.Q_pitch;    

    OffshoreAssembly.Surge_dot(it) = s.Surge_dot; WindTurbineOutput.Surge_dot(it) = s.Surge_dot;
    OffshoreAssembly.Surge_Ddot(it) = s.Surge_Ddot; WindTurbineOutput.Surge_Ddot(it) = s.Surge_Ddot;
    OffshoreAssembly.Sway_dot(it) = s.Sway_dot; WindTurbineOutput.Sway_dot(it) = s.Sway_dot;
    OffshoreAssembly.Sway_Ddot(it) = s.Sway_Ddot; WindTurbineOutput.Sway_Ddot(it) = s.Sway_Ddot;       
    OffshoreAssembly.Heave_dot(it) = s.Heave_dot; WindTurbineOutput.Heave_dot(it) = s.Heave_dot;
    OffshoreAssembly.Heave_Ddot(it) = s.Heave_Ddot; WindTurbineOutput.Heave_Ddot(it) = s.Heave_Ddot;
    OffshoreAssembly.RollAngle_dot(it) = s.RollAngle_dot; WindTurbineOutput.RollAngle_dot(it) = s.RollAngle_dot;
    OffshoreAssembly.RollAngle_Ddot(it) = s.RollAngle_Ddot; WindTurbineOutput.RollAngle_Ddot(it) = s.RollAngle_Ddot;    
    OffshoreAssembly.PitchAngle_dot(it) = s.PitchAngle_dot; WindTurbineOutput.PitchAngle_dot(it) = s.PitchAngle_dot; 
    OffshoreAssembly.PitchAngle_Ddot(it) = s.PitchAngle_Ddot; WindTurbineOutput.PitchAngle_Ddot(it) = s.PitchAngle_Ddot;  
    OffshoreAssembly.YawAngle_dot(it) = s.YawAngle_dot; WindTurbineOutput.YawAngle_dot(it) = s.YawAngle_dot;
    OffshoreAssembly.YawAngle_Ddot(it) = s.YawAngle_Ddot; WindTurbineOutput.YawAngle_Ddot(it) = s.YawAngle_Ddot; 

    OffshoreAssembly.C_Hydrostatic(it) = s.C_Hydrostatic; WindTurbineOutput.C_Hydrostatic(it) = s.C_Hydrostatic; 
    OffshoreAssembly.C_Lines(it) = s.C_Lines; WindTurbineOutput.C_Lines(it) = s.C_Lines; 
    OffshoreAssembly.B_Radiation(it) = s.B_Radiation; WindTurbineOutput.B_Radiation(it) = s.B_Radiation; 
    OffshoreAssembly.B_Viscous(it) = s.B_Viscous; WindTurbineOutput.B_Viscous(it) = s.B_Viscous;
    OffshoreAssembly.I_mass(it) = s.I_mass; WindTurbineOutput.I_mass(it) = s.I_mass; 
    OffshoreAssembly.A_Radiation(it) = s.A_Radiation; WindTurbineOutput.A_Radiation(it) = s.A_Radiation;  

    
    % Assign value to variable in specified workspace
    assignin('base', 's', s);
    assignin('base', 'who', who);
    assignin('base', 'WindTurbineOutput', WindTurbineOutput);    
    assignin('base', 'OffshoreAssembly', OffshoreAssembly);


    % Further processing or end of the recursive calls


elseif strcmp(action, 'logical_instance_14')
%==================== LOGICAL INSTANCE 14 ====================
%=============================================================    
    % PLOT OFFSHORE ASSEMBLY MOTIONS RESULTS (OFFLINE): 
    % Purpose of this Logical Instance: to plot the results obtained by
    % simulating the movement of an offshore wind turbine.



      %########## TIME SERIES AND WAVE SPECTRUM ##########

    % ---------- Plot TIME SERIES AND WAVE SPECTRUM ---------- 
    if (s.Option01f4 == 3)
        % Plot Wave Elevation (Time Series)
        s.Index_Depth_point = 1; % s.WaterDepthVector_i(s.Index_Depth_point )
        figure;
        plot(s.vt_wave, s.eta_Jonswap, 'Color', [0 0 0.7]);
        box on;
        grid off;
        title('Wave Time Series', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        xlabel('t [s]');
        ylabel('Water elevation [m]');
        %

        % Plot Spectra of Stochastic Time Series
        s.fraw_eta_wave = s.fraw_eta;
        s.Sraw_eta_wave = s.Sraw_eta;
        s.fBin_eta_wave = s.fBin_eta;
        s.SBin_eta_wave = s.SBin_eta;
        figure;
        Ikp = s.S_Jonswap > 10^(-5);
        loglog(s.fraw_eta_wave, s.Sraw_eta_wave, '-', 'Color', [0.66 0.66 0.66]);
        hold on;
        % loglog(fWelch, SWelch, '-', 'Color', [0.35 0.35 0.35]); % Uncomment if needed
        loglog(s.vf_Jonswap(Ikp), s.S_Jonswap(Ikp), 'k', 'LineWidth', 2);
        loglog(s.fBin_eta_wave, s.SBin_eta_wave, 'r-');
        title('Generated Time Series Jonswap Spectrum', 'Interpreter', 'latex', 'FontSize', 14);
        xlabel('Frequency [Hz]');
        ylabel('PSD of eta [m^2 s]');
        grid off;
        lg = legend('Raw spectrum', 'Jonswap spectrum', 'Bin-average spectrum', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        set(lg, 'Location', 'southwest'); % Axis tight        
        %

        % Integration of the spectrum
        Area = trapz(s.vf_Jonswap, s.S_Jonswap);
        normalization_factor = (s.Hs_ws / 4)^2 / Area;
        S_Jonswap_ = normalization_factor * s.S_Jonswap;
        Area_ = trapz(s.vf_Jonswap, S_Jonswap_);
        figure(222);
        plot(s.vf_Jonswap, s.S_Jonswap, 'k-');
        hold on;
        plot(s.vf_Jonswap, S_Jonswap_, 'b.');
        grid off;
        xlim([0 0.3]);
        title('Jonswap Spectrum Comparison.', 'Interpreter', 'latex', 'FontSize', 14);
        legend('Theoretical Jonswap spectrum (calculated with the function)', 'Generated and normalized Jonswap spectrum', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        xlabel('Frequencies [Hz]');
        ylabel('Spectral Density S $[m^{2}.s]$', 'Interpreter', 'latex');
        %
    end


            %########## WAVE PARTICLE KINEMATICS ##########

    % ---------- Plot Wave Particle Velocity Model results ---------- 
    if (s.Option01f4 == 3)
        % Plot Velocity and Acceleration Profile over Depth
        s.Index_Depth_point = 1; % s.WaterDepthVector_i(s.Index_Depth_point )
        figure;
        subplot(1,2,1)
        plot(s.Time, s.Vwa_iu(s.Index_Depth_point,:), 'b', ...
            s.Time, s.Vwa_iv(s.Index_Depth_point,:), 'g:', ...
            s.Time, s.Vwa_iw(s.Index_Depth_point,:), 'r--')
        grid off
        xlabel('time [seg]')
        ylabel('Velocity [m/s]')
        title('Velocity of a wave particle over time at an evaluated depth')
        legend('u (long.)','v (transv.)','w (vert.)','Location','best', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        subplot(1,2,2)
        plot(s.Time, s.Awa_iu(s.Index_Depth_point,:), 'b', ...
            s.Time, s.Awa_iv(s.Index_Depth_point,:), 'g:', ...
            s.Time, s.Awa_iw(s.Index_Depth_point,:), 'r--')
        grid off
        xlabel('time [seg]')
        ylabel('Velocity [m/s]')
        title('Acceleration of a wave particle over time at Selected Depth')
        legend('a_u','a_v','a_w','Location','best')
        %

        % Plot Parallel Wave Particle Velocity 
        s.Index_Depth_SparBuoyPoint = 1; % s.Zi_betti(s.Index_Depth_SparBuoyPoint)
        figure();
        plot(s.Time, s.V_parallel(:,s.Index_Depth_SparBuoyPoint), 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('$v_{\parallel}$ [m/s]', 'Interpreter', 'latex');
        title('Parallel Velocity over Time at Selected Depth', 'Interpreter', 'latex', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.V_parallel(:,s.Index_Depth_SparBuoyPoint)), 1.10*max(s.V_parallel(:,s.Index_Depth_SparBuoyPoint))]);
        legend('$v_{\parallel}$', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Plot Perpendicular Wave Particle Velocity 
        figure();
        plot(s.Time, s.V_perpendicular(:,s.Index_Depth_SparBuoyPoint), 'g', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('$v_{\perp}$ [m/s]', 'Interpreter', 'latex');
        title('Perpendicular Velocity over Time at Selected Depth', 'Interpreter', 'latex', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.V_perpendicular(:,s.Index_Depth_SparBuoyPoint)), 1.10*max(s.V_perpendicular(:,s.Index_Depth_SparBuoyPoint))]);
        legend('$v_{\perp}$', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
        
        % Plot Perpendicular Wave Particle Acceleration 
        figure();
        plot(s.Time, s.Vdot_perpendicular(:,s.Index_Depth_SparBuoyPoint), 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('$a_{\perp}$ [m/s$^2$]', 'Interpreter', 'latex');
        title('Perpendicular Acceleration over Time at Selected Depth', 'Interpreter', 'latex', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.Vdot_perpendicular(:,s.Index_Depth_SparBuoyPoint)), 1.10*max(s.Vdot_perpendicular(:,s.Index_Depth_SparBuoyPoint))]);
        legend('$a_{\perp}$', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %        
    end


       %########## WEIGHT FORCES ##########

    % ------- Plot WEIGHT FORCES ----------
    if (s.Option01f4 == 3)
        % Weight Moment (Pitch)
        s.Qwe_pitch_MNm = s.Qwe_pitch / 1e6;
        figure();
        plot(s.Time, s.Qwe_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{we}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.10*min(s.Qwe_pitch_MNm), 1.10*max(s.Qwe_pitch_MNm)]);    
        legend('$Q_{we}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Weight Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
    end


       %########## BUOYANCY FORCES ##########

    % ------- Plot BUOYANCY FORCES ----------
    if (s.Option01f4 == 2)
        % Buoyancy and Weight Moments (Heave and Pitch)
        s.Qb_heave_MNm = s.Qb_heave / 1e6;
        s.Qb_pitch_MNm = s.Qb_pitch / 1e6;
        s.Qwe_pitch_MNm = s.Qwe_pitch / 1e6;
        
        figure();
        grid on;
        % Buoyancy Force - Heave
        subplot(3,1,1);
        plot(s.Time, s.Qb_heave_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q_{b}^{\eta}$ [MN]', 'Interpreter', 'latex');
        title('Buoyancy Force in Heave over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.02*min(s.Qb_heave_MNm), 0.98*max(s.Qb_heave_MNm)]);
        % Buoyancy Moment - Pitch
        subplot(3,1,2);
        plot(s.Time, s.Qb_pitch_MNm, 'r', 'LineWidth', 1.5);
        ylabel('$Q_{b}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Buoyancy Moment in Pitch over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.Qb_pitch_MNm), 1.10*max(s.Qb_pitch_MNm)]);
        % Weight Moment - Pitch
        subplot(3,1,3);
        plot(s.Time, s.Qwe_pitch_MNm, 'g', 'LineWidth', 1.5);
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('$Q_{we}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Weight Moment in Pitch over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.Qwe_pitch_MNm), 1.10*max(s.Qwe_pitch_MNm)]);
        %

        % Buoyancy Force (Heave)
        s.Qb_heave_MNm = s.Qb_heave / 1e6;
        figure();
        plot(s.Time, s.Qb_heave_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{b}^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.02*min(s.Qb_heave_MNm), 0.98*max(s.Qb_heave_MNm)]);
        legend('$Q_{b}^{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Buoyancy Force in Heave over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Buoyancy Moment (Pitch)
        s.Qb_pitch_MNm = s.Qb_pitch / 1e6;
        figure();
        plot(s.Time, s.Qb_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{b}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.10*min(s.Qb_pitch_MNm), 1.10*max(s.Qb_pitch_MNm)]);    
        legend('$Q_{b}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Buoyancy Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
    end


       %########## WIND FORCES ##########

    % ------- Plot WIND FORCES ----------
    if (s.Option01f4 == 3)
        % Wind Forces and Moments (Surge and Pitch)
        s.Qwi_surge_MNm = s.Qwi_surge / 1e6;
        s.Qwi_pitch_MNm = s.Qwi_pitch / 1e6;
        figure();
        grid on;
        % Wind Force - Surge
        subplot(2,1,1);
        plot(s.Time, s.Qwi_surge_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q_{wi}^{\xi}$ [MN]', 'Interpreter', 'latex');
        title('Wind Force in Surge over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qwi_surge_MNm), 0.1]);
        % Wind Moment - Pitch        
        subplot(2,1,2);
        plot(s.Time, s.Qwi_pitch_MNm, 'r', 'LineWidth', 1.5);
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('$Q_{wi}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Wind Moment in Pitch over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.02*min(s.Qwi_pitch_MNm), 5]);
        %

        % Wind Force (Surge)
        s.Qwi_surge_MNm = s.Qwi_surge / 1e6;
        figure();
        plot(s.Time, s.Qwi_surge_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{wi}^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.05*min(s.Qwi_surge_MNm), 0.1]); 
        legend('$Q_{wi}^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Wind Force in Surge over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Wind Moment (Pitch)
        s.Qwi_pitch_MNm = s.Qwi_pitch / 1e6;
        figure();
        plot(s.Time, s.Qwi_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{wi}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.02*min(s.Qwi_pitch_MNm), 5]);    
        legend('$Q_{wi}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Wind Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
    end



       %########## HYDRODYNAMIC DRAG FORCES ##########

    % ------- Plot HYDRODYNAMIC DRAG FORCES----------
    if (s.Option01f4 == 3)
        % Hydrodynamic Drag Forces and Moment (Surge, Heave, Pitch) in One Figure
        s.Qh_surge_MNm = s.Qh_surge / 1e6;
        s.Qh_heave_MNm = s.Qh_heave / 1e6;
        s.Qh_pitch_MNm = s.Qh_pitch / 1e6;
        figure();
        grid on;
        % Drag Force - Surge
        subplot(3,1,1);
        plot(s.Time, s.Qh_surge_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q_{h}^{\xi}$ [MN]', 'Interpreter', 'latex');
        title('Hydrodynamic Drag Force in Surge over Time', ...
        'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qh_surge_MNm), 1.05*max(s.Qh_surge_MNm)]);
        % Drag Force - Heave
        subplot(3,1,2);
        plot(s.Time, s.Qh_heave_MNm, 'r', 'LineWidth', 1.5);
        ylabel('$Q_{h}^{\eta}$ [MN]', 'Interpreter', 'latex');
        title('Hydrodynamic Drag Force in Heave over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qh_heave_MNm), 1.05*max(s.Qh_heave_MNm)]);
        % Drag Moment - Pitch
        subplot(3,1,3);
        plot(s.Time, s.Qh_pitch_MNm, 'g', 'LineWidth', 1.5);
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('$Q_{h}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Hydrodynamic Drag Moment in Pitch over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qh_pitch_MNm), 1.05*max(s.Qh_pitch_MNm)]);
        %


        % Drag Hydrodynamic Force (Surge)
        s.Qh_surge_MNm = s.Qh_surge / 1e6;
        figure();
        plot(s.Time, s.Qh_surge_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{h}^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.05*min(s.Qh_surge_MNm), 1.05*max(s.Qh_surge_MNm)]);
        legend('$Q_{h}^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Hydrodynamic Drag Force in Surge over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Hydrodynamic Drag Force (Heave)
        s.Qh_heave_MNm = s.Qh_heave / 1e6;
        figure();
        plot(s.Time, s.Qh_heave_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{h}^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.02*min(s.Qh_heave_MNm), 1.05*max(s.Qh_heave_MNm)]);
        legend('$Q_{h}^{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Hydrodynamic Drag Force in Heave over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Hydrodynamic Drag Moment (Pitch)
        s.Qh_pitch_MNm = s.Qh_pitch / 1e6;
        figure();
        plot(s.Time, s.Qh_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{h}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.10*min(s.Qh_pitch_MNm), 1.10*max(s.Qh_pitch_MNm)]);    
        legend('$Q_{h}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Hydrodynamic Drag Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
    end


             %########## WAVE FORCES ##########

    % ------- Plot WAVE FORCES----------
    if (s.Option01f4 == 3)
        % Wave Forces and Moment (Surge, Heave, Pitch) in One Figure          
        s.Qwa_surge_MNm = s.Qwa_surge / 1e6;
        s.Qwa_heave_MNm = s.Qwa_heave / 1e6;
        s.Qwa_pitch_MNm = s.Qwa_pitch / 1e6;
        figure();
        grid on;       
        subplot(3,1,1); % Surge subplot
        plot(s.Time, s.Qwa_surge_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q_{wa}^{\xi}$ [MN]', 'Interpreter', 'latex');
        title('Wave Force in Surge over Time', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qwa_surge_MNm), 1.05*max(s.Qwa_surge_MNm)]);        
        subplot(3,1,2); % Heave subplot
        plot(s.Time, s.Qwa_heave_MNm, 'r', 'LineWidth', 1.5);
        ylabel('$Q_{wa}^{\eta}$ [MN]', 'Interpreter', 'latex');
        title('Wave Force in Heave over Time', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qwa_heave_MNm), 1.05*max(s.Qwa_heave_MNm)]);
        % Pitch subplot
        subplot(3,1,3);
        plot(s.Time, s.Qwa_pitch_MNm, 'g', 'LineWidth', 1.5);
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('$Q_{wa}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Wave Moment in Pitch over Time', 'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qwa_pitch_MNm), 1.05*max(s.Qwa_pitch_MNm)]);
        %


        % Wave Force (Surge)
        s.Qwa_surge_MNm = s.Qwa_surge / 1e6;
        figure();
        plot(s.Time, s.Qwa_surge_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{wa}^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.05*min(s.Qwa_surge_MNm), 1.05*max(s.Qwa_surge_MNm)]);
        legend('$Q_{wa}^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Wave Force in Surge over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Wave Force (Heave)
        s.Qwa_heave_MNm = s.Qwa_heave / 1e6;
        figure();
        plot(s.Time, s.Qwa_heave_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{wa}^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.02*min(s.Qwa_heave_MNm), 1.05*max(s.Qwa_heave_MNm)]);
        legend('$Q_{wa}^{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Wave Force in Heave over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Wave Moment (Pitch)
        s.Qwa_pitch_MNm = s.Qwa_pitch / 1e6;
        figure();
        plot(s.Time, s.Qwa_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{wa}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.10*min(s.Qwa_pitch_MNm), 1.10*max(s.Qwa_pitch_MNm)]);    
        legend('$Q_{wa}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Wave Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %
    end


      %########## MOORING LINES FORCES ##########

    % ------- Plot MOORING LINES FORCES----------
    if (s.Option01f4 == 3)
        % Mooring Lines Forces and Moment (Surge, Heave, Pitch) in One Figure
        s.Qm_surge_MNm = s.Qm_surge / 1e6;
        s.Qm_heave_MNm = s.Qm_heave / 1e6;
        s.Qm_pitch_MNm = s.Qm_pitch / 1e6;
        figure();
        grid on;
        % Surge
        subplot(3,1,1);
        plot(s.Time, s.Qm_surge_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q_{m}^{\xi}$ [MN]', 'Interpreter', 'latex');
        title('Mooring Lines Force in Surge over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.05*min(s.Qm_surge_MNm), 1.05*max(s.Qm_surge_MNm)]);
        % Heave
        subplot(3,1,2);
        plot(s.Time, s.Qm_heave_MNm, 'r', 'LineWidth', 1.5);
        ylabel('$Q_{m}^{\eta}$ [MN]', 'Interpreter', 'latex');
        title('Mooring Lines Force in Heave over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([0.99*min(s.Qm_heave_MNm), 1.01*max(s.Qm_heave_MNm)]);
        % Pitch
        subplot(3,1,3);
        plot(s.Time, s.Qm_pitch_MNm, 'g', 'LineWidth', 1.5);
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('$Q_{m}^{\alpha}$ [MN$\cdot$m]', 'Interpreter', 'latex');
        title('Mooring Lines Moment in Pitch over Time', ...
            'Interpreter', 'latex', 'FontName', 'Arial', 'FontSize', 14);
        xlim([0 max(s.Time)]);
        ylim([1.10*min(s.Qm_pitch_MNm), 1.10*max(s.Qm_pitch_MNm)]);
        %


        % Mooring Lines Forces (Surge)
        s.Qm_surge_MNm = s.Qm_surge / 1e6;
        figure();
        plot(s.Time, s.Qm_surge_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{m}^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([1.05*min(s.Qm_surge_MNm), 1.05*max(s.Qm_surge_MNm)]);
        legend('$Q_{m}^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Mooring Lines Force in Surge over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Mooring Lines Forces (Heave)
        s.Qm_heave_MNm = s.Qm_heave / 1e6;
        figure();
        plot(s.Time, s.Qm_heave_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{m}^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
        ylim([0.99*min(s.Qm_heave_MNm), 1.01*max(s.Qm_heave_MNm)]);
        legend('$Q_{m}^{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Mooring Lines Force in Heave over Time (MN)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Mooring Lines Moments (Pitch)
        s.Qm_pitch_MNm = s.Qm_pitch / 1e6;
        figure();
        plot(s.Time, s.Qm_pitch_MNm, 'b', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
        xlim([0 max(s.Time)]);       
        ylabel('$Q_{m}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        ylim([1.10*min(s.Qm_pitch_MNm), 1.10*max(s.Qm_pitch_MNm)]);    
        legend('$Q_{m}^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
        title('Mooring Lines Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
        %

        % Displacement of the front lines (line 1 and 2) in [m]
        figure();
        hold on;
        plot(s.Time, s.xml0_off, 'r', 'LineWidth', 2); % componente X
        plot(s.Time, s.yml0_off, 'b', 'LineWidth', 2); % componente Y
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('Vertex Position $[$m$]$', 'Interpreter', 'latex');
        legend({'$X_0$ (linha 1 e 2)', '$Y_0$ (linha 1 e 2)'}, 'Interpreter', 'latex', ...
            'FontSize', 12, 'Location', 'best');
        title('Displacement of the Front Mooring Lines (line 1 and 2)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        grid on;
        xlim([min(s.Time), max(s.Time)]);
        %

        % Displacement of the Posterior lines (line 3) in [m]
        figure();
        hold on;
        plot(s.Time, s.xml0_Boff, 'r', 'LineWidth', 2); % componente X
        plot(s.Time, s.yml0_Boff, 'b', 'LineWidth', 2); % componente Y
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('Vertex Position $[$m$]$', 'Interpreter', 'latex');
        legend({'$X_0$ (linha 1 e 2)', '$Y_0$ (linha 1 e 2)'}, 'Interpreter', 'latex', ...
            'FontSize', 12, 'Location', 'best');
        title('Displacement of the Posterior Mooring Line (line 3)', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        grid on;
        xlim([min(s.Time), max(s.Time)]);
        %       

        % Horizontal Displacement Comparison (X components of front and posterior lines)
        figure();
        hold on;
        plot(s.Time, s.xml0_off, 'r', 'LineWidth', 2);     % Front lines (1 and 2) - X
        plot(s.Time, s.xml0_Boff, 'k', 'LineWidth', 2);    % Posterior line (3) - X
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('Horizontal Vertex Position $[$m$]$', 'Interpreter', 'latex');
        legend({'$X_0$ (line 1 and 2)', '$X_0$ (line 3)'}, 'Interpreter', 'latex', ...
            'FontSize', 12, 'Location', 'best');
        title('Horizontal Displacement of Mooring Lines', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        grid on;
        xlim([min(s.Time), max(s.Time)]);
        

        % Vertical Displacement Comparison (Y components of front and posterior lines)
        figure();
        hold on;
        plot(s.Time, s.yml0_off, 'b', 'LineWidth', 2);     % Front lines (1 and 2) - Y
        plot(s.Time, s.yml0_Boff, 'm', 'LineWidth', 2);    % Posterior line (3) - Y
        xlabel('$t$ [s]', 'Interpreter', 'latex');
        ylabel('Vertical Vertex Position $[$m$]$', 'Interpreter', 'latex');
        legend({'$Y_0$ (line 1 and 2)', '$Y_0$ (line 3)'}, 'Interpreter', 'latex', ...
            'FontSize', 12, 'Location', 'best');
        title('Vertical Displacement of Mooring Lines', 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'normal', 'Interpreter', 'latex');
        grid on;
        xlim([min(s.Time), max(s.Time)]);
        %        
    end



      %########## TOTAL FORCE AND MOMENTS ##########

    % ------- Plot General Analysis----------  
    s.Q_surge_MNm = s.Q_surge / 1e6;
    s.Q_heave_MNm = s.Q_heave / 1e6;    
    s.Q_pitch_MNm = s.Q_pitch / 1e6;    
    if (s.Option01f4 == 3)
        figure();
        subplot(3,1,1);
        plot(s.Time, s.Q_surge_MNm, 'b', 'LineWidth', 1.5);
        ylabel('$Q^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
        title('Total Excitation Force in Surge over Time ($[$MN$]$)', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,2);
        plot(s.Time, s.Q_heave_MNm, 'g', 'LineWidth', 1.5);
        ylabel('$Q^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
        title('Total Excitation Force in Heave over Time ($[$MN$]$)', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,3);
        plot(s.Time, s.Q_pitch_MNm, 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('$Q_{m}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
        title('Total Excitation Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        %
    end

    % ------- Plot Surge Force in MN ----------    
    figure();
    plot(s.Time, s.Q_surge_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\xi}$ $[$MN$]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Q_surge_MNm), 1.05*max(s.Q_surge_MNm)]);
    legend('$Q^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Total Excitation Force in Surge over Time ($[$MN$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % ------- Plot Heave Force in MN ---------- 
    figure();
    plot(s.Time, s.Q_heave_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\eta}$ $[$MN$]$', 'Interpreter', 'latex');
    ylim([0.99*min(s.Q_heave_MNm), 1.01*max(s.Q_heave_MNm)]);
    legend('$Q^{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Total Excitation Force in Heave over Time ($[$MN$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');  
    %
    

    % ------- Plot Pitch Moment in MN·m ----------  
    figure();
    plot(s.Time, s.Q_pitch_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q_{m}^{\alpha}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
    ylim([1.10*min(s.Q_pitch_MNm), 1.10*max(s.Q_pitch_MNm)]);    
    legend('$Q^{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Total Excitation Moment in Pitch over Time ($[$MN$\cdot$m$]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %



      %########## SURGE MOTIONS ##########

    % ------- Plot Surge Motions  ----------
    if (s.Option01f4 == 3)
        figure();
        subplot(3,1,1);
        plot(s.Time, s.Surge, 'b', 'LineWidth', 1.5);
        ylabel('${\xi}$ $[m]$', 'Interpreter', 'latex');
        title('Surge Displacement over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,2);
        plot(s.Time, s.Surge_dot, 'g', 'LineWidth', 1.5);
        ylabel('$V_{\xi}$ $[m/s]$', 'Interpreter', 'latex');
        title('Surge Velocity over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,3);
        plot(s.Time, s.Surge_Ddot, 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('${\dot{V}}_{\xi}$ $m/s^{2}$', 'Interpreter', 'latex');
        title('Surge Acceleration over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        %
    end

    % Surge Displacement in [m]
    figure();
    plot(s.Time, s.Surge, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\xi}$ $[m]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Surge), 1.05*max(s.Surge)]);
    legend('${\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Surge Displacement over Time (m)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Surge Velocity in [m/s]
    figure();
    plot(s.Time, s.Surge_dot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$V_{\xi}$ $[m/s]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Surge_dot), 1.05*max(s.Surge_dot)]);
    legend('$V_{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Surge Velocity over Time ($[m/s]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    

    % Surge Acceleration in [m/s^2]
    figure();
    plot(s.Time, s.Surge_Ddot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\dot{V}}_{\xi}$ $m/s^{2}$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Surge_Ddot), 1.05*max(s.Surge_Ddot)]);
    legend('${\dot{V}}_{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Surge Acceleration over Time ($m/s^{2}$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    



      %########## HEAVE MOTIONS ##########

    % ------- Plot Heave Force in MN ----------
    if (s.Option01f4 == 3)  
        figure();
        subplot(3,1,1);
        plot(s.Time, s.Heave, 'b', 'LineWidth', 1.5);
        ylabel('${\eta}$ $[m]$', 'Interpreter', 'latex');
        title('Heave Displacement over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,2);
        plot(s.Time, s.Heave_dot, 'g', 'LineWidth', 1.5);
        ylabel('$V_{\eta}$ $[m/s]$', 'Interpreter', 'latex');
        title('Heave Velocity over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,3);
        plot(s.Time, s.Heave_Ddot, 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('${\dot{V}}_{\eta}$ $m/s^{2}$', 'Interpreter', 'latex');
        title('Heave Acceleration over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        %
    end

    % Heave Displacement in [m]
    figure();
    plot(s.Time, s.Heave, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\eta}$ $[m]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Heave), 1.05*max(s.Heave)]);
    legend('${\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Heave Displacement over Time (m)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Heave Velocity in [m/s]
    figure();
    plot(s.Time, s.Heave_dot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$V_{\eta}$ $[m/s]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Heave_dot), 1.05*max(s.Heave_dot)]);
    legend('$V_{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Heave Velocity over Time ($[m/s]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    

    % Heave Acceleration in [m/s^2]
    figure();
    plot(s.Time, s.Heave_Ddot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\dot{V}}_{\eta}$ $m/s^{2}$', 'Interpreter', 'latex');
    ylim([1.05*min(s.Heave_Ddot), 1.05*max(s.Heave_Ddot)]);
    legend('${\dot{V}}_{\eta}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Heave Acceleration over Time ($m/s^{2}$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %        


      %########## PITCH MOTIONS ##########

    % ------- Plot Pitch Motions ----------
    s.PitchAngle_deg = s.PitchAngle * (180/pi);
    s.PitchAngle_dot_deg = s.PitchAngle_dot * (180/pi);
    s.PitchAngle_Ddot_deg = s.PitchAngle_Ddot * (180/pi);    
    if (s.Option01f4 == 3)  
        % In Radians
        figure();
        subplot(3,1,1);
        plot(s.Time, s.PitchAngle, 'b', 'LineWidth', 1.5);
        ylabel('${\alpha}$ $[rad]$', 'Interpreter', 'latex');
        title('Pitch Angle over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,2);
        plot(s.Time, s.PitchAngle_dot, 'g', 'LineWidth', 1.5);
        ylabel('$V_{\alpha}$ $[rad/s]$', 'Interpreter', 'latex');
        title('Pitch Angular Velocity over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        subplot(3,1,3);
        plot(s.Time, s.PitchAngle_Ddot, 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('${\dot{V}}_{\alpha}$ $rad/s^{2}$', 'Interpreter', 'latex');
        title('Pitch Angular Acceleration over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        %

        % In Degress
        figure();
        subplot(3,1,1);
        plot(s.Time, s.PitchAngle_deg, 'b', 'LineWidth', 1.5);
        ylabel('${\alpha}$ $[deg]$', 'Interpreter', 'latex');
        title('Pitch Angle over Time (Degrees)', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);    
        subplot(3,1,2);
        plot(s.Time, s.PitchAngle_dot_deg, 'g', 'LineWidth', 1.5);
        ylabel('$V_{\alpha}$ $[deg/s]$', 'Interpreter', 'latex');
        title('Pitch Angular Velocity over Time (Degrees/s)', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);    
        subplot(3,1,3);
        plot(s.Time, s.PitchAngle_Ddot_deg, 'r', 'LineWidth', 1.5);
        xlabel('$t$ $[s]$', 'Interpreter', 'latex');
        ylabel('${\dot{V}}_{\alpha}$ $deg/s^{2}$', 'Interpreter', 'latex');
        title('Pitch Angular Acceleration over Time', 'FontName', 'Arial', 'FontSize', 14, 'Interpreter', 'latex');
        xlim([0 max(s.Time)]);
        %        
    end

    % Pitch Angular Displacement in [deg]
    figure();
    plot(s.Time, s.PitchAngle_deg, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\alpha}$ $[deg]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.PitchAngle_deg), 1.05*max(s.PitchAngle_deg)]);
    legend('${\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Pitch Angular Displacement over Time ($[deg]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Pitch Angular Displacement in [rad]
    figure();
    plot(s.Time, s.PitchAngle, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\alpha}$ $[rad]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.PitchAngle), 1.05*max(s.PitchAngle)]);
    legend('${\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Pitch Angular Displacement over Time ($[rad]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % Pitch Angular Velocity in [rad/s]
    figure();
    plot(s.Time, s.PitchAngle_dot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$V_{\alpha}$ $[rad/s]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.PitchAngle_dot), 1.05*max(s.PitchAngle_dot)]);
    legend('$V_{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Pitch Angular Velocity over Time ($[rad/s]$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    

    % Pitch Angular Acceleration in [rad/s^2]
    figure();
    plot(s.Time, s.PitchAngle_Ddot, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('${\dot{V}}_{\alpha}$ $rad/s^{2}$', 'Interpreter', 'latex');
    ylim([1.05*min(s.PitchAngle_Ddot), 1.05*max(s.PitchAngle_Ddot)]);
    legend('${\dot{V}}_{\alpha}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('Pitch Angular Acceleration over Time ($rad/s^{2}$)', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %       



      %########## SYSTEM MATRIX ##########

    % ------- Plot The added inertia (added mass) ---------- 
    s.A_Radiation_Mtonm2 = s.A_Radiation / 1e9;
    figure();
    plot(s.Time, s.A_Radiation_Mtonm2, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$A_{Radiation}$ $Mton/m^{2}$', 'Interpreter', 'latex');
    ylim([0, 1.05*max(s.A_Radiation_Mtonm2)]);
    legend('$A_{Radiation}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('The added inertia (added mass) associated with hydrodynamic radiation in DOF considered', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %

    % ------- Plot The hydrostatic restoring  ---------- 
    s.C_Hydrostatic_MNm = s.C_Hydrostatic / 1e6;
    figure();
    plot(s.Time, s.C_Hydrostatic_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\xi}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
    ylim([0.98*min(s.C_Hydrostatic_MNm), 1.02*max(s.C_Hydrostatic_MNm)]);
    legend('$Q^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('The hydrostatic restoring in DOF considered', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %    
    

    % ------- Plot The linearized hydrostatic restoring  ---------- 
    s.C_Lines_MNm = s.C_Lines / 1e6;
    figure();
    plot(s.Time, s.C_Lines_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\xi}$ $[$MN$\cdot$m$]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.C_Lines_MNm), 1.05*max(s.C_Lines_MNm)]);
    legend('$Q^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('The linearized hydrostatic restoring from mooring lines in DOF considered', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %  


    % ------- Plot The damping associated with hydrodynamic  ---------- 
    s.B_Radiation_MNm = s.B_Radiation / 1e6;
    figure();
    plot(s.Time, s.B_Radiation_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\xi}$ $[$N$\cdot$s$\cdot$m$]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.B_Radiation_MNm), 1.05*max(s.B_Radiation_MNm)]);
    legend('$Q^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('The damping associated with hydrodynamic radiation in DOF considered', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    %      


    % ------- Plot The linearized viscous drag damping---------- 
    s.B_Viscous_MNm = s.B_Viscous / 1e6;
    figure();
    plot(s.Time, s.B_Viscous_MNm, 'b', 'LineWidth', 1.5);
    xlabel('$t$ $[s]$', 'Interpreter', 'latex'); 
    xlim([0 max(s.Time)]);       
    ylabel('$Q^{\xi}$ $[$N$\cdot$s$\cdot$m$]$', 'Interpreter', 'latex');
    ylim([1.05*min(s.B_Viscous_MNm), 1.05*max(s.B_Viscous_MNm)]);
    legend('$Q^{\xi}$', 'FontName', 'Arial', 'FontSize', 12,  'FontWeight', 'normal', 'Interpreter', 'latex');    
    title('The linearized viscous drag damping in DOF considered', 'FontName', 'Arial', 'FontSize', 14, 'FontWeight', 'normal', 'Interpreter', 'latex');
    % 



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