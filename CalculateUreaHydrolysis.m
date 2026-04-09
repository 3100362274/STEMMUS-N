function [Shys, Vpore, WFPS, DeltaUrea] = CalculateUreaHydrolysis(Kurea1, NL, Nurea, Vpore, WFPS, Theta_g, Theta_LL, Shys, Delt_t, TT)
    % Calculate the urea hydrolysis rate μg/(cm³·d) and the amount hydrolyzed in the step (μg/cm³)
    % Based on Liang Hao's article and image formula: S_hys = N_urea * (1 - exp(-5.0 × WFPS · K_urea))
    % This function uses "explicit" processing, parameter Nurea_old is the known urea concentration from previous time step (n)
    %
    % Input parameters:
    %   Kurea1    - Urea hydrolysis base rate constant (1/day), can be layered or nodal
    %   NL        - Number of layers
    %   Nurea_old - Urea concentration from previous time step (n) (μg/cm³), known value
    %   Vpore     - Pore volume
    %   WFPS      - Water-Filled Pore Space ratio
    %   Theta_g   - Gas phase water content
    %   Theta_LL  - Liquid phase water content (new time step)
    %   Shys      - Urea hydrolysis rate array (pre-allocated)
    %   Delt_t    - Time step length (day) !!!Must be provided for dimensional conversion!!!
    %   TT        - Temperature (°C), new time step value, array dimension should match nodes
    %
    % Output parameters:
    %   Shys      - Urea hydrolysis rate calculated based on n-step concentration (μg/(cm³·d))
    %   Vpore     - Pore volume
    %   WFPS      - Water-Filled Pore Space ratio
    %   DeltaUrea - Change in urea concentration during this time step (hydrolysis amount, μg/cm³) [New output]
    
    % Temperature correction parameters[6](@ref)
    Q10 = 2.5;
    T_ref = 20;
    
    % Initialize new output variable DeltaUrea (change amount for each node MN)
    % Assuming Nurea_old is a vector with length equal to number of nodes
    DeltaUrea = zeros(size(Nurea)); 

    for ML = 1:NL
        for ND = 1:2
            MN = ML + ND - 1;
    
            % 1. Calculate pore volume and WFPS
            Vpore(ML, ND) = Theta_g(ML, ND) + Theta_LL(ML, ND);
            WFPS(ML, ND) = Theta_LL(ML, ND) ./ Vpore(ML, ND);
    
            % 2. Temperature correction: Adjust urea hydrolysis rate constant
            % ​Lloyd, J., & Taylor, J. A. (1994). On the temperature dependence of soil respiration. Functional Ecology, 8(3), 315-323.​​
            K_urea_temp = Kurea1(ML) * Q10^((TT(MN) - T_ref)/10);
    
            % 3. Calculate instantaneous hydrolysis rate Shys (μg/(cm³·d)) - Strictly following image formula
            % S_hys = N_urea * (1 - exp(-5.0 × WFPS · K_urea))
            Shys(ML, ND) = Nurea(MN) * (1 - exp(-5.0 * WFPS(ML, ND) * K_urea_temp));
            
            % 4. Calculate change in urea concentration during this time step (μg/cm³)
            % Key: Rate * Time step = Urea hydrolyzed during this step
            DeltaUrea(MN) = Shys(ML, ND) * Delt_t; 
            
        end
    end
    % Note: Urea concentration Nurea update should be done in main program:  Nnurea = Nurea - DeltaUrea;
end