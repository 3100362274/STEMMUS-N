function [SLA_leaf, SLA_sun, SLA_shade] = computeSLA(PFTValue, LAI, Tao, LAIsun, LAIshade, KT)
% computeSLA - Calculate SLA at leaf and canopy levelsIsun
%
% Inputs:
%   PFTValue - structure containing SLA0 and SLAm (from PFT dataset)
%   LAI      - Exposed leaf area index (m² m⁻²)
%   Tao      - Light extinction coefficient (unitless)
%   LAIsun   - Sunlit leaf area index (m² m⁻²)
%   LAIshade - Shaded leaf area index (m² m⁻²)
%
% Outputs:
%   SLA_leaf  - SLA at the top of the canopy (m² g⁻¹ C)
%   SLA_sun   - Mean SLA for sunlit leaves (m² g⁻¹ C)
%   SLA_shade - Mean SLA for shaded leaves (m² g⁻¹ C)
%
% Reference:
% Thornton & Zimmermann (2007); Equation 8.10–8.12 in documentation
CUM_LAI(KT) = 0;
% === Top-leaf SLA ===
CUM_LAI(KT) = CUM_LAI(KT) + LAI(KT);
SLA_leaf(KT) = PFTValue.SLA0 + PFTValue.SLAm * CUM_LAI(KT);

% === Precompute exponential attenuation ===
c = exp(-Tao * LAI(KT));

% === SLA for sunlit leaves (Eq. 8.11) ===
numer_sun(KT) = - (c * PFTValue.SLAm * Tao * LAI(KT) + PFTValue.SLAm * c + PFTValue.SLA0 * c * Tao - PFTValue.SLAm - PFTValue.SLA0 * Tao);
SLA_sun(KT) = numer_sun(KT) / (Tao^2 * LAIsun);

% === SLA for shaded leaves (Eq. 8.12) ===
numer_shade(KT) = PFTValue.SLA0 + PFTValue.SLAm * LAI(KT) / 2;
SLA_shade(KT) = numer_shade / LAIshade - SLA_sun(KT) * LAIsun / LAIshade;

end

