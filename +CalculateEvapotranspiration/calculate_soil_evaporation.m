function [E, r_a_s] = calculate_soil_evaporation(Rn, CropHeight, LAI, Theta_LL_sur, ...
    Wind_ms, WindHeight, TempHeight, Altitude, TAver, TMax, TMin, Ea_TMax, Ea_TMin, EaDew)
% Units: E in cm/s, resistances in s/m, radiation in MJ/m^2/day
% Based on historical conversation parameters

% Constants
k = 0.41; % von Karman constant
n = 2.5; % Turbulence decay coefficient
z_0s = 0.01; % Soil roughness length (m)
rho_a = 1.2; % Air density (kg/m^3)
c_p = 1013; % Specific heat of air (J/kg/°C)
k_ext = 0.6; % Extinction coefficient for radiation

% Step 1: Calculate aerodynamic parameters
d_0 = 0.667 * CropHeight; % Zero-plane displacement height (m)
z_om = 0.123 * CropHeight; % Momentum roughness length (m)
z_oh = 0.0123 * CropHeight; % Heat roughness length (m)
if CropHeight == 0 % Bare soil
    z_om = 0.001; % From historical conversation
    z_oh = 0.0001;
    d_0 = 0;
end

% Wind speed at canopy height (u_hc)
if CropHeight > 0
    u_hc = Wind_ms * log((CropHeight - d_0) / z_om) / log((WindHeight - d_0) / z_om);
else
    u_hc = Wind_ms; % No canopy for bare soil
end

% Step 2: Calculate r_a_s (soil surface to canopy bottom resistance)
if CropHeight > 0
    r_a_s = (CropHeight * exp(n)) / (n * k^2 * u_hc) * ...
        (exp(-n * z_0s / CropHeight) - exp(-n * (d_0 + z_om) / CropHeight));
else
    r_a_s = 0; % No canopy for bare soil
end

% Step 3: Calculate r_a_a (canopy top to reference height resistance)
if WindHeight <= d_0 || TempHeight <= d_0
    error('Error: Displacement height exceeds measurement height');
end
AerDynRes = log((WindHeight - d_0) / z_om) * log((TempHeight - d_0) / z_oh) / (k^2);
r_a_a = AerDynRes / Wind_ms;

% Step 4: Calculate radiation partitioning
R_n_c = Rn * (1 - exp(-k_ext * LAI)); % Canopy net radiation (MJ/m^2/day)
R_n_s = Rn - R_n_c; % Soil net radiation (MJ/m^2/day)

% Step 5: Calculate soil surface resistance (r_s_s)
if Theta_LL_sur > 0.25
    r_s_s = 10; % s/m
else
    r_s_s = 10 * exp(35.63 * (0.25 - Theta_LL_sur));
end
% Adjust for canopy shading in maize (optional, from historical conversation)
if CropHeight > 0
    r_s_s = r_s_s * (1 + LAI);
end

% Step 6: Calculate meteorological parameters
% Latent heat (MJ/kg)
lambda = 2.501 - 0.002361 * TAver;

% Atmospheric pressure (kPa)
P_Atm = 101.3 * ((293 - 0.0065 * Altitude) / 293)^5.253;

% Psychrometric constant (kPa/°C)
gamma = 0.0016286 * P_Atm / lambda;

% Saturation vapor pressure slope (kPa/°C)
Delta = (2049 * Ea_TMax / (TMax + 237.3)^2) + (2049 * Ea_TMin / (TMin + 237.3)^2);

% Vapor pressure deficit (kPa)
e_s = (Ea_TMax + Ea_TMin) / 2;
e_a = EaDew;
VPD = e_s - e_a;

% Step 7: Calculate soil evaporation (E) in cm/s
numerator = Delta * (R_n_s / 86400) + ...
    (rho_a * c_p * VPD - Delta * r_a_s * (R_n_c / 86400)) / (r_a_a + r_a_s);
denominator = lambda * 1e6 * (Delta + gamma * (1 + r_s_s / (r_a_a + r_a_s)));
E = (numerator / denominator) / 10; % Convert mm/day to cm/s

end

% Example usage for summer maize (mid-season)
Rn = 8.64; % Net radiation (MJ/m^2/day)
CropHeight = 1.5; % Crop height (m)
LAI = 3; % Leaf area index
Theta_LL_sur = 0.3; % Surface soil moisture (m^3/m^3)
Wind_ms = 2; % Wind speed at 2 m (m/s)
WindHeight = 2; % Wind measurement height (m)
TempHeight = 2; % Temperature measurement height (m)
Altitude = 0; % Altitude (m)
TAver = 25; % Average temperature (°C)
TMax = 30; % Maximum temperature (°C)
TMin = 20; % Minimum temperature (°C)
Ea_TMax = 4.24; % Saturation vapor pressure at TMax (kPa)
Ea_TMin = 2.34; % Saturation vapor pressure at TMin (kPa)
EaDew = 2.0; % Actual vapor pressure at dew point (kPa)

[E, r_a_s] = calculate_soil_evaporation(Rn, CropHeight, LAI, Theta_LL_sur, ...
    Wind_ms, WindHeight, TempHeight, Altitude, TAver, TMax, TMin, Ea_TMax, Ea_TMin, EaDew);

fprintf('Soil evaporation (E): %.2e cm/s\n', E);
fprintf('Soil-to-canopy resistance (r_a_s): %.2f s/m\n', r_a_s);
