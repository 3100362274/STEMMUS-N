function Vcmax = generate_Vcmax_fromPFT(PFTValue, dms_string, decl, SLA_leaf, SLA_sun, SLA_shade, Nefc, PlantModel, KT, FN)
% Compute Vcmax without temperature effect, using preloaded PFT parameter set
%
% Inputs:
%   pfts     - struct array from getPFTParameterSet()
%   pft_name - string, PFT name (e.g., 'C3 grass')
%   dms_string      - latitude [°]
%   decl     - solar declination [rad]

%   FN       - soil Nitrogen limitation factor (0–1)
%   SLA_leaf - specific leaf area (m2 leaf area g-1 C)
%   SLA_sun  - specific sun leaf area (m2 leaf area g-1 C)
%   SLA_shade- specific shade leaf area (m2 leaf area g-1 C)
%
%   Nefc     - consider Soil Nitrogen transport 
%   PlantModel - consider Plant grow model
% Output:
%   Vcmax    - μmol m⁻² s⁻¹ (adjusted by fN, fDYL, betaL only)



% === Constants ===
FNR = 7.16;     % the mass ratio of total Rubisco molecular mass to nitrogen in Rubisco (g Rubisco g-1 N in Rubisco)
aR25 = 60;      % Specific activity [μmol CO2 / g Rubisco / s]

% === Vcmax25_opt from leaf N ===
Na_sun = 1 / (PFTValue.CN_L * SLA_sun(KT));  % g N / m²leaf area
Na_shade = 1 / (PFTValue.CN_L * SLA_shade(KT));  % g N / m²leaf area
Na = 1 / (PFTValue.CN_L * SLA_leaf(KT));  % g N / m²leaf area
Vcmax25(KT) = Na * PFTValue.FLNR * FNR * aR25;

% === Determine DYLmax based on hemisphere
    if dms_string >= 0
        decl_ref = 0.409571;     % +23.45° in radians (Northern summer)
    else
        decl_ref = -0.409571;    % -23.45° in radians (Southern summer)
    end

% === Daylength factor ===
DYL = 2 * 13750.9871 * acos( ...
    -sin(deg2rad(dms_string)) * sin(decl) / ...
     cos(deg2rad(dms_string)) / cos(decl));
DYLmax = 2 * 13750.9871 * acos( ...
    -sin(deg2rad(dms_string)) * sin(decl_ref) / ...
     cos(deg2rad(dms_string)) / cos(decl_ref));
fDYL = (DYL / DYLmax)^2;
fDYL = max(min(fDYL, 1), 0.01);

% === Final computation ===
if  Nefc == 1 && PlantModel == 1
    Vcmax(KT) = Vcmax25(KT) * fDYL * FN(KT);
else
    fN = PFTValue.fN;
    Vcmax(KT) = Vcmax25(KT) * fDYL * fN;
end
end
