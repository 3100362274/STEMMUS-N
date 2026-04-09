function [An, Wcol, psnParams] = Photofun_vec(pft_name, species, Nefc, PlantModel, Vcmax25, KT, TopPg, PAR, Tl, Ci, dms_string, decl, betaL, FN, LAI, Tao, LAIsun, LAIshade)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%      C3/C4 photosynthesis model      %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Gordon B. Bonan et al 2010 C3 photosynthesis model 
% CLM4 C4 photosynthesis model
% doi:10.1029/2010JG001593
%
% (Eller et al., 2020, 2018)
%  https://doi.org/10.1111/nph.16419, http://dx.doi.org/10.1098/rstb.2017.0315
%
% Inputs:    
%   Tl:is the canopy temperature (C), assumed to be equal to Ta
%   PAR - photosynthesis active radation [W.m-2]
%   Ci  - intercellular CO2 partial pressure [Pa]
%   dms_string- Latitude [deg]
%   decl      - Solar declination [rad]
%   betaL     - Soil water limitation factor (0–1)  与土壤联系起来还未定义
%   FN       - soil Nitrogen limitation factor (0–1) 与土壤联系起来还未定义
%   TopPg     - Air pressure (10pa)
%   species   - C3 or C4
%   Nefc     - consider Soil Nitrogen transport 
%   PlantModel - consider Plant grow model
%   Vcmax25   - = 1 Use real-time values or = 0 table values 
%   'PFT'           - plant functional types 
%   'FullName'      - Full descriptive name 
%   'PFT', {'NET Temperate','NET Boreal','NDT Boreal', ...
%             'BET Tropical','BET temperate','BDT tropical','BDT temperate','BDT boreal', ...
%             'BES temperate','BDS temperate','BDS boreal', ...
%             'C3 arctic grass','C3 grass','C4 grass','Crop1','Crop2'}, ...
%   'FullName', {'Needleleaf evergreen tree – temperate','Needleleaf evergreen tree – boreal', ...
%                  'Needleleaf deciduous tree – boreal','Broadleaf evergreen tree – tropical', ...
%                  'Broadleaf evergreen tree – temperate','Broadleaf deciduous tree – tropical', ...
%                  'Broadleaf deciduous tree – temperate','Broadleaf deciduous tree – boreal', ...
%                  'Broadleaf evergreen shrub – temperate','Broadleaf deciduous shrub – temperate', ...
%                  'Broadleaf deciduous shrub – boreal','C₃ arctic grass','C₃ grass','C₄ grass', ...
%                  'Crop type 1','Crop type 2'}

% Vcmax temperature response
%Q10leaf = 2;
%Vcmax = vcmax25 .* (Q10leaf .^ (0.1 * (Tl - 25))) ./ ((1 + exp(0.3 * (Tl - Tup))) .* (1 + exp(0.3 * (Tlw - Tl))));
% GAM: the CO2 compensation point of assimilation in the presence of dark respiration. (Bonan et al., 2011)
% R = 0.008314; %% gas constant,[kJ  K-1 mol-1] Gas Constant
% Ts_k = Tl + 273.15; %%[K]
% Tref = 25 + 273.15; %% [K] Reference Temperature
% Ha = 37.83;   %% [kJ/mol] Activation Energy
% kT= exp(Ha.*(Ts_k-Tref)./(Tref*R.*Ts_k));
% GAM25 = 42.75; % [umol / mol]
% GAM25 = GAM25*10^-6.*PA; %%[kPa];
% GAM = GAM25.*kT; % [kPa] Michaelis-Menten Constant for C0_2
% Kc & Ko
% Q10Kc = 2.1;
% Kc = 30 * (Q10Kc .^ (0.1 * (Tl - 25))) .* 10^(-3);  % [kPa]
% Q10Ko = 1.2;
% Ko = 30000 * (Q10Ko .^ (0.1 * (Tl - 25))) .* 10^(-3);  % [kPa]

psnParams = CalculateEvapotranspiration.PhotosynthesisTemperatureEffects(Tl, pft_name, species, dms_string, Nefc, PlantModel, decl, betaL, Vcmax25, KT, LAI, Tao, LAIsun, LAIshade, FN); 
PA(KT) = TopPg(KT)./10; % 10pa -> pa
Oa(KT) = 20.91/100 .* PA(KT); % [Pa]


switch species
    case 3 % C3 species
        % ========== J  ==========
        % Inputs
        % PAR            % - average absorbed PAR for sunlit or shaed leaf [1 W m⁻² = 4.6 μmol photons m⁻² s⁻¹]，例如 phi_sun 或 phi_sha
        f = 0.15;        % - fraction of PAR absorbed by nonphotosyntheticmaterials（unitless）
        Jmax =  psnParams.Jmax(KT);   % - maximum electron transport rate [μmol e m⁻² s⁻¹]
        Theta_PSII = 0.7;% - fraction of PAR absorbed by nonphotosyntheticmaterials（unitless）
        % Light absorbed by photosystem II
        I_PSII = 0.5 * (1 - f) .* (4.6 .* PAR(KT));   % [μmol e⁻ m⁻² s⁻¹] PAR PAR_sun PAR_sha
        % Electron transport rate
        J(KT) = arrayfun(@(I, Jm)min(roots([Theta_PSII, -(I + Jm), I * Jm])), I_PSII, Jmax);
        % ==========  J  ==========

        Ac(KT) = psnParams.Vcmax(KT) .* ((Ci(KT) -  psnParams.Gamma_star(KT)) ./ (Ci(KT) + psnParams.Kc(KT) .* (1 + Oa(KT) ./ psnParams.Ko(KT))));
        Al(KT) = (J(KT) / 4) * (Ci(KT) - psnParams.Gamma_star(KT)) / (Ci(KT) + 2 * psnParams.Gamma_star(KT));
        Ae(KT) = 3 * psnParams.TPU(KT);
        % Ae = 0.5 * Vcmax;
        % Al = alfa .* (1 - wPAR) .* PAR .* ((Ci(KT) - GAM) ./ (Ci(KT) + 2 * GAM));
 
    case 4 % C4 species
        alfa = CalculateEvapotranspiration.getPFTValue(pft_name, 'alpha');
        Ac(KT) = psnParams.Vcmax(KT);
        Al(KT) = alfa .* 4.6 .* PAR(KT);
        Ae(KT) = psnParams.ke(KT) .* Ci(KT) ./ PA(KT);

        % curvature factor for photosynthesis colimitation
        beta1 = 0.80;
        beta2 = 0.95;

end


% Co-limitation
Acol1 = arrayfun(@(al, ac) min(roots([beta1, -(al+ac), al*ac])), Al, Ac);
Acol2 = arrayfun(@(a1, ae) min(roots([beta2, -(a1+ae), a1*ae])), Acol1, Ae);


% Output
A(KT) = Acol2;

% leaf  dark respiration [μmol CO2 m-2 s-1], From T&C model techinical
% reference or Farquhar(1980)
switch species
    case 3 % C3 species
        R_dc(KT) = psnParams.Rd;
        % calculate Wcol use to calculate the col-limitation ci_col
        Wcol(KT) = arrayfun(@(ae, al) min(roots([beta1, -(al+ae), al*ae])), Al, Ae);

    case 4 % C4 species
        R_dc(KT) = psnParams.Rd;
        % calculate Wcol use to calculate the col-limitation ci_col
        Wcol(KT) = arrayfun(@(ac, al) min(roots([beta1, -(al+ac), al*ac])), Ac, Al);
end

An(KT) = A(KT) - R_dc(KT);

end
