function value = getPFTValue(pft_name, fieldname)
% getPFTValue
% Retrieves a specific photosynthetic parameter from a given PFT.
%
% This utility accesses the internal PFT parameter table and extracts 
% a single field value for a specified PFT name.
%
% Inputs:
%   pft_name  - string, e.g. 'C3 grass', 'BET Tropical', etc.
%   fieldname - string, one of the field names listed below.
%
% Output:
%   value     - scalar value from the selected PFT and field.
%
% Example:
%   SLA = getPFTValue('C3 grass', 'SLA0');
%
% -------------------------------------------------------------------------
% Supported fields (all drawn from Tables 8.1 & 8.2):
%
%   'PFT'           - PFT short name (text)
%   'FullName'      - Full descriptive name (text)
%
%   'm'             - Ball–Berry stomatal slope [unitless]
%   'alpha'         - Quantum yield of electron transport [mol e⁻ mol⁻¹ photon]
%   'CN_L'          - Leaf carbon-to-nitrogen ratio [g C g⁻¹ N]
%   'FLNR'          - Fraction of leaf N in Rubisco [g N Rubisco g⁻¹ N]
%   'fN'            - Nitrogen limitation scalar [unitless]
%
%   'SLA0'          - Specific leaf area at canopy top (x = 0) [m² leaf g⁻¹ C]
%   'SLAm'          - Linear slope of SLA with cumulative LAI [m² leaf g⁻¹ C]
%
%   'psi_o'         - Leaf water-potential threshold [mm]
%   'psi_c'         - Critical water-potential drop-off [mm]
%
%   'Vcmax25'       - Vcmax at 25 °C for top-leaf (no N-limit) [µmol CO₂ m⁻² s⁻¹]
%   'Vcmax25_fN'    - Vcmax at 25 °C scaled by f(N) [µmol CO₂ m⁻² s⁻¹]
% -------------------------------------------------------------------------

     % Load parameter set
    PFTs = CalculateEvapotranspiration.getPFTParameterSet();

    % Find the index of the specified PFT
    idx = find(strcmpi({PFTs.PFT}, pft_name), 1);
    if isempty(idx)
        error('PFT "%s" not found.', pft_name);
    end

    % Extract the structure for the specified PFT
    pft = PFTs(idx);

    % Check whether the field exists
    if ~isfield(pft, fieldname)
        error('Field "%s" not found in PFT structure.', fieldname);
    end

    % Return the specific value
    value = pft.(fieldname);
end
