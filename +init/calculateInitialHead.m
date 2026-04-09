function head = calculateInitialHead(InitX, Theta_s, Theta_r, Alpha, n, m)
   %{Calculate soil water potential (initH) using van Genuchten model.}
   %{     
        van Genuchten, M.T. (1980), A Closed-form Equation for Predicting the
        Hydraulic Conductivity of Unsaturated Soils. Soil Science Society of
        America Journal, 44: 892-898.
        https://doi.org/10.2136/sssaj1980.03615995004400050002x
   %} 
    
   head = -(((Theta_s - Theta_r) / (InitX - Theta_r))^(1/m) - 1)^(1/n) / Alpha;
end