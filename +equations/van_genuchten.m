function volumetricWaterContent = van_genuchten(Theta_s, Theta_r, alpha, hParameter, nParameter, mParameter)
    %{
        van Genuchten model Van Genuchten MTh, Leij FJ, Yates SR (1991) The RETC code
        for quantifying the hydraulic functions of unsaturated soils.
        EPA/600/2-91/065. In: Kerr RS (ed) Environmental Research Laboratory. US
        Environmental Protection Agency, Ada, OK, p 83

    %}

    if hParameter>=-1e-6
        volumetricWaterContent=Theta_s;
    elseif hParameter<=-1e5
        volumetricWaterContent=Theta_r;
    else
        volumetricWaterContent = Theta_r + (Theta_s - Theta_r) ./ (1 + abs(alpha .* hParameter).^nParameter).^mParameter;
    end
