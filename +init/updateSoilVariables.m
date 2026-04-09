function [SoilVariables, VanGenuchten] = updateSoilVariables(SoilVariables, VanGenuchten, porosity,SaturatedK,Vol_qtz,VPERS,VPERC,VPERSL,VPERSOC,XK,,,,, i, j)

    % Get soil constants for StartInit
    SoilConstants = io.getSoilConstants();

    SoilVariables.POR(i) = porosity(j);
    SoilVariables.Ks(i) = SaturatedK(j);
    SoilVariables.Theta_qtz(i) = Vol_qtz(j);
    SoilVariables.VPER(i, 1) = VPERS(j);
    SoilVariables.VPER(i, 2) = VPERSL(j);
    SoilVariables.VPER(i, 3) = VPERC(j);
    SoilVariables.XSOC(i) = VPERSOC(j);
    SoilVariables.XK(i) = XK;

    % get model settings
    ModelSettings = io.getModelSettings();

    
    VanGenuchten.Theta_s(i) = SaturatedMC(j);
    VanGenuchten.Theta_r(i) = ResidualMC(j);
    VanGenuchten.Theta_f(i) = fieldMC(j);
    VanGenuchten.Alpha(i) = Coefficient_Alpha(j);
    VanGenuchten.n(i) = Coefficient_n(j);
    VanGenuchten.m(i) = 1 - 1 ./ n(i);

    SoilVariables.XK(i) = ResidualMC(j) + 0.02;
    SoilVariables.XWILT(i) = equations.van_genuchten(VanGenuchten.Theta_s(i), VanGenuchten.Theta_r(i), VanGenuchten.Alpha(i), -1.5e4, VanGenuchten.n(i), VanGenuchten.m(i));
    SoilVariables.XCAP(i) = equations.van_genuchten(VanGenuchten.Theta_s(i), VanGenuchten.Theta_r(i), VanGenuchten.Alpha(i), -336, VanGenuchten.n(i), VanGenuchten.m(i));

