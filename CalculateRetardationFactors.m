function [Retard, RetardBAR] = CalculateRetardationFactors(Theta_LL, RHOKG1, Retard, RetardBAR, NL)
% Calculate the retardation factors
% Parameters:
%   Theta_LL - Soil water content (e.g., field capacity), in m³/m³
%   RHOKG1 - Adsorption coefficient (should be in the same units, typically g/cm³)
%   Retard - Matrix of retardation factors, output parameter
%   RetardBAR - Average retardation factors, output parameter
%   NL - Number of soil layers

    for ML = 1:NL   % Loop through each soil layer
        J = ML;  % Link J with ML, where J represents the soil type
        for ND = 1:2   % Handle the two nodes (upper and lower boundary) for each soil element
            % Calculate the retardation factor: ratio of adsorption coefficient to water content + 1
            Retard(ML, ND) = RHOKG1(J) / Theta_LL(ML, ND) + 1;
        end
    end
    
    for ML = 1:NL
        % Calculate the average retardation factor for each soil layer
        RetardBAR(ML) = (Retard(ML, 1) + Retard(ML, 2)) / 2;
    end
end
