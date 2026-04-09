function psnParams = PhotosynthesisTemperatureEffects(Tl, pft_name, species, dms_string, Nefc, PlantModel, decl, betaL, Vcmax25, KT, LAI, Tao, LAIsun, LAIshade, FN)
% PhotosynthesisTemperatureEffects
% Computes temperature-dependent biochemical parameters for the 
% Farquhar photosynthesis model, based on enzyme kinetics and 
% thermal inhibition functions.
%  
% Inputs:
%   Vcmax25   - = 1 Use real-time values or = 0 table values 
%   Tl        - Leaf temperature in Celsius (scalar or vector)
%   betaL     - soil water limitation factor (0–1)
%   species   - C3 , C4
%   pft_name  - PFT name string (e.g. 'BET Tropical')
%   dms_string- Latitude [deg]
%   decl      - Solar declination [rad]
%   betaL     - Soil water limitation factor (0–1)  与土壤联系起来还未定义
%   Nefc     - consider Soil Nitrogen transport 
%   PlantModel - consider Plant grow model
%   
% Output:
%   psnParams - Struct containing temperature-adjusted parameter values:
%       Vcmax         - Maximum carboxylation rate [μmol m⁻² s⁻¹]
%       Jmax          - Maximum electron transport rate [μmol electron m⁻² s⁻¹]
%       TPU           - Triose phosphate utilization rate [μmol m⁻² s⁻¹]
%       Rd            - leaf "dark," or "day," respiration rate [μmol CO2 m⁻² s⁻¹]
%       Kc, Ko        - Michaelis-Menten constants at 1,013.25 hPa [Pa] 
%       Gamma_star    - CO₂ compensation point [Pa]
%
% Reference:
% Bonan, G. B., et al. (2011), Improving canopy processes in the 
% Community Land Model version 4 (CLM4) using global flux fields 
% empirically inferred from FLUXNET data, J. Geophys. Res., 116, 
% G02014, doi:10.1029/2010JG001593

% === Convert Tl from Celsius to Kelvin ===
Tl = Tl + 273.15;

% === Load PFT table and extract selected ===
PFTValue.CN_L = CalculateEvapotranspiration.getPFTValue(pft_name, 'CN_L');
PFTValue.FLNR = CalculateEvapotranspiration.getPFTValue(pft_name, 'FLNR');
PFTValue.SLA0 = CalculateEvapotranspiration.getPFTValue(pft_name, 'SLA0');
PFTValue.fN   = CalculateEvapotranspiration.getPFTValue(pft_name, 'fN');
PFTValue.SLAm = CalculateEvapotranspiration.getPFTValue(pft_name, 'SLAm');
PFTValue.Vcmax25 = CalculateEvapotranspiration.getPFTValue(pft_name, 'Vcmax25');
PFTValue.Vcmax25_fN = CalculateEvapotranspiration.getPFTValue(pft_name, 'Vcmax25_fN');


% === Universal constants ===
Rgas = 8.314;                    % Ideal gas constant [J mol⁻¹ K⁻¹]

% === Compute Vcmax25_opt ===
[SLA_leaf, SLA_sun, SLA_shade] = CalculateEvapotranspiration.computeSLA(PFTValue, LAI, Tao, LAIsun, LAIshade, KT);
if Vcmax25 == 1
    Vcmax_25(KT) = CalculateEvapotranspiration.generate_Vcmax_fromPFT(PFTValue, dms_string, decl, SLA_leaf, SLA_sun, SLA_shade, Nefc, PlantModel, KT, FN);   % Vcmax at 25°C [μmol m⁻² s⁻¹]
else
    Vcmax_25(KT) = PFTValue.Vcmax25_fN;
end


% === Other temperature-independent parameters ===
Jmax_25     = 1.97 * Vcmax_25(KT);   % Electron transport capacity at 25°C
TPU_25      = 0.06 * Jmax_25;    % Triose phosphate utilization at 25°C
Rd_25       = 0.015 * Vcmax_25(KT);  % Day respiration rate at 25°C
Kc_25       = 41;                % Michaelis constant for CO₂= 404.9 [μmol mol⁻¹]
Ko_25       = 28209;             % Michaelis constant for O₂ = 278.4 * 1000 [μmol mol⁻¹]
Gamma_25    = 4.3;               % CO₂ compensation point at 25°C = 42.75 [μmol mol⁻¹]
ke_25       = 20000 * Vcmax_25(KT);  % initial slope of C4 CO2 response curve [μmol m−2s−1]
% === Activation energies ΔHa [J mol⁻¹] ===
DeltaHa_Vc    = 65330;
DeltaHa_J     = 43540;
DeltaHa_TPU   = 53100;
DeltaHa_Rd    = 46390;
DeltaHa_Kc    = 79430;
DeltaHa_Ko    = 36380;
DeltaHa_Gamma = 37830;

% === Deactivation energies ΔHd [J mol⁻¹] ===
DeltaHd_Vc    = 149250;
DeltaHd_J     = 152040;
DeltaHd_TPU   = 150650;
DeltaHd_Rd    = 150650;

% === Entropy terms ΔS [J mol⁻¹ K⁻¹] ===
DeltaS_Vc     = 485;
DeltaS_J      = 495;
DeltaS_TPU    = 490;
DeltaS_Rd     = 490;

% === Temperature response functions ===
f_Tl = @(DeltaHa) exp((DeltaHa / (298.15 * Rgas)) * (1 - 298.15 ./ Tl));
fH   = @(DeltaHd, DeltaS) ...
    (1 + exp((298.15 * DeltaS - DeltaHd) / (298.15 * Rgas))) ./ ...
    (1 + exp((DeltaS .* Tl - DeltaHd) ./ (Rgas .* Tl)));

switch species
    case 3 % C3 species
        % === Final temperature-corrected parameters ===
        psnParams.Vcmax(KT)       = Vcmax_25(KT) * f_Tl(DeltaHa_Vc)    .* fH(DeltaHd_Vc, DeltaS_Vc)  .* betaL(KT);
        psnParams.Jmax(KT)        = Jmax_25  * f_Tl(DeltaHa_J)     .* fH(DeltaHd_J, DeltaS_J);
        psnParams.TPU(KT)         = TPU_25   * f_Tl(DeltaHa_TPU)   .* fH(DeltaHd_TPU, DeltaS_TPU);
        psnParams.Rd(KT)          = Rd_25    * f_Tl(DeltaHa_Rd)    .* fH(DeltaHd_Rd, DeltaS_Rd)    * betaL(KT);
        psnParams.Kc(KT)          = Kc_25    * f_Tl(DeltaHa_Kc);
        psnParams.Ko(KT)          = Ko_25    * f_Tl(DeltaHa_Ko);
        psnParams.Gamma_star(KT)  = Gamma_25 * f_Tl(DeltaHa_Gamma);
    case 4 % C4 species
        s1 = 0.3; % K-1
        s2 = 313.15; % K  s1, s2 Oleson et al. [2010]
        s3 = 0.2; % K-1
        s4 = 288.15; % K  s3, s4 Oleson et al. [2010]
        s5 = 1.3;  % K-1
        s6 = 328.15;  % K  s5, s6 Oleson et al. [2010]
        Q10leaf = 2;  % Q10 temperature parameter
        psnParams.Vcmax(KT)       = Vcmax_25(KT) .* (Q10leaf .^ (0.1 * (Tl - 298.15))) ./ ((1 + exp(s1 * (Tl - s2))) .* (1 + exp(s3 * (s4 - Tl)))) .* betaL(KT);
        psnParams.ke(KT)          = ke_25 .* (Q10leaf .^ (0.1 * (Tl - 298.15))) ;
        %psnParams.ke(KT)          = 4000 * Vcmax_25(KT);  % from CLM4
        psnParams.Rd(KT)          = 0.025 .* Vcmax_25(KT).* (Q10leaf .^ (0.1 * (Tl - 298.15))) ./ (1 + exp(s5 * (Tl - s6))) .* betaL(KT);
end

% === Optional metadata ===
psnParams.Vcmax_25(KT) = Vcmax_25(KT);       % Uncorrected Vcmax at 25°C



end
