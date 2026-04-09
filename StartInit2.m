function Copy_of_StartInit
    
    % Preset the measured depth to get the initial T, h by interpolation method.
    global InitND1 InitND2 InitND3 InitND4 InitND5 BtmT BtmX Btmh
    global InitT0 InitT1 InitT2 InitT3 InitT4 InitT5 Dmark
    global T MN ML NL NN DeltZ Elmn_Lnth Tot_Depth InitLnth
    global InitX0 InitX1 InitX2 InitX3 InitX4 InitX5 Inith0 Inith1 Inith2 Inith3 Inith4 Inith5
    global InitN0 InitN1 InitN2 InitN3 InitN4 InitN5
    global h Theta_s Theta_r m n Alpha Theta_L Theta_LL hh TT P_g P_gg Ks Theta_f
    global XOLD XWRE NS J POR Thmrlefc IH IS Eqlspace FACc
    global porosity SaturatedMC ResidualMC SaturatedK Coefficient_n Coefficient_Alpha fieldMC
    global NBCh NBCT NBCP NBChB NBCTB NBCPB BChB BCTB BCPB BCh BCT BCP BtmPg
    global NBCN NBCNB Nefc BCN BCNB BtmN  N Ts_msr
    global DSTOR DSTOR0 RS NBChh DSTMAX IRPT1 IRPT2 Soilairefc XK XWILT
    global HCAP TCON SF TCA GA1 GA2 GB1 GB2 S1 S2 HCD TARG1 TARG2 GRAT VPER
    global TERM ZETA0 CON0 PS1 PS2 i KLT_Switch DVT_Switch KaT_Switch
    global Kaa_Switch DVa_Switch KLa_Switch
    global COR CORh Theta_V Theta_g Se KL_h DTheta_LLh hThmrl Tr Hystrs KIT CKTN MSOC FOS FOC FOSL Theta_qtz XSOC
    global nS DISP111 DIF111 initX initT initH initND InitialValues output
    
    %% 1. Define constants
    initX = InitialValues.initX;
    initND = InitialValues.initND;
    
    % Get soil constants for StartInit
    SoilConstants = io.getSoilConstants();
    
    Vol_qtz = FOS;                                        % fraction of quartz
    VPERSOC = MSOC .* 2700 ./ ((MSOC .* 2700) + (1 - MSOC) .* 1300);  % fraction of soil organic matter
    FOSL = 1 - FOC - FOS - VPERSOC;                       % fraction of silt
    
    for J = 1:NS
        POR(J) = porosity(J);
        Theta_s(J) = SaturatedMC(J);
        Theta_r(J) = ResidualMC(J);
        Theta_f(J) = fieldMC(J);
        n(J) = Coefficient_n(J);
        Ks(J) = SaturatedK(J);
        Alpha(J) = Coefficient_Alpha(J);
        m(J) = 1 - 1/n(J);
        XK(J) = Theta_r(J) - 0.01;  % This is for silt loam; For sand XK=0.025
        VPERS(J) = FOS(J) * (1 - POR(J));  % Define volume sand content
        VPERSL(J) = FOSL(J) * (1 - POR(J));  % Define volume silt content
        VPERC(J) = FOC(J) * (1 - POR(J));  % Define volume clay content
        % XWILT(J) = calculateWiltingPoint(Theta_r(J), Theta_s(J), Alpha(J), n(J), m(J));
    end
    
    
    if ~Eqlspace
        j = NS;
        for i = 1:length(initX)
            InitialValues.initH(i) = init.calculateInitialHead(initX(i),Theta_s(j), Theta_r(j), Alpha(j) , n(j), m(j));
        end
    
        %% 2. Considering soil hetero effect
        % Loop over all depth layers
        Dmark=[];
        for ML = 1:NL
            SoilConstants.Elmn_Lnth = SoilConstants.Elmn_Lnth + DeltZ(ML);
            InitLnth(ML) = Tot_Depth - SoilConstants.Elmn_Lnth;
            for subRoutine = 5:-1:1
                if abs(InitLnth(ML) - initND(subRoutine)) < 1e-10
                    initX = InitialValues.initX;
                    initT = InitialValues.initT;
                    initH = InitialValues.initH;
    
                    switch subRoutine
                        case 0
                            from_id = Dmark;
                            to_id = NL + 1;
                            indexOfSoilType = 1; % Index of soil type
                            indexOfInit = 1; % index of initH and initT
                        case 1
                            from_id = Dmark;
                            to_id = ML + 1;
                            indexOfSoilType = 1; % Index of soil type
                            indexOfInit = 2; % index of initH and initT
                        case 2
                            from_id = Dmark;
                            to_id = ML + 1;
                            indexOfSoilType = 2; % Index of soil type
                            indexOfInit = 3; % index of initH and initT
                        case 3
                            from_id = Dmark;
                            to_id = ML + 1;
                            indexOfSoilType = 3; % Index of soil type
                            indexOfInit = 4; % index of initH and initT
                        case 4
                            from_id = Dmark;
                            to_id = ML + 1;
                            indexOfSoilType = 4; % Index of soil type
                            indexOfInit = 5; % index of initH and initT
                        case 5
                            from_id = 1;
                            to_id = ML + 1;
                            indexOfSoilType = 5; % Index of soil type
                            indexOfInit = 6; % index of initH and initT
                    end
    
                    for MN = from_id:to_id
                        if subRoutine == 5
                            j = MN;
                        else
                            j = MN - 1;
                        end
    
                        IS(MN) = indexOfSoilType;
                        if subRoutine == 4
                            IS(5:8) = 5;
                        end
                        J = IS(MN);
                        % Get soil constants for StartInit
                        POR(j) = porosity(J);
                        Ks(j) = SaturatedK(J);
                        Theta_qtz(j) = Vol_qtz(J);
                        VPER(j, 1) = VPERS(J);
                        VPER(j, 2) = VPERSL(J);
                        VPER(j, 3) = VPERC(J);
                        XSOC(j) = VPERSOC(J);
                        XK(j) = XK(J);
    
                        % get model settings
                        Theta_s(j) = SaturatedMC(J);
                        Theta_r(j) = ResidualMC(J);
                        Theta_f(j) = fieldMC(J);
                        Alpha(j) = Coefficient_Alpha(J);
                        n(j) = Coefficient_n(J);
                        m(j) = 1 - 1 ./ n(j);
                        XK(j) = ResidualMC(J) + 0.02;
                        XWILT(j) = equations.van_genuchten(Theta_s(j), Theta_r(j), Alpha(j), -1.5e4, n(j),m(j));

                        if subRoutine == 5
                            Btmh = init.calculateInitialHead(BtmX ,Theta_s(MN), Theta_r(MN), Alpha(MN) , n(MN), m(MN));
                            T(MN) = BtmT + (MN - 1) * (initT(indexOfInit) - BtmT) / ML;
                            h(MN) = Btmh + (MN - 1) * (initH(indexOfInit) - Btmh) / ML;
                            IH(MN) = 1;   % Index of wetting history of soil which would be assumed as dry at the first with the value of 1
                        else
                            delta = ML + 2 - Dmark;
                            domainZ = MN - Dmark + 1;
                            T(MN) = init.calcSoilTemp(initT(indexOfInit), initT(indexOfInit + 1), delta, domainZ);
                            h(MN) = init.calcSoilMatricHead(initH(indexOfInit), initH(indexOfInit + 1), delta, domainZ);
                            IH(j) = 1;
                        end
                        J = IS(MN);
                    % Get soil constants for StartInit
                    POR(j) = porosity(J);
                    Ks(j) = SaturatedK(J);
                    Theta_qtz(j) = Vol_qtz(J);
                    VPER(j, 1) = VPERS(J);
                    VPER(j, 2) = VPERSL(J);
                    VPER(j, 3) = VPERC(J);
                    XSOC(j) = VPERSOC(J);
                    XK(j) = XK(J);
    
                    % get model settings
                    Theta_s(j) = SaturatedMC(J);
                    Theta_r(j) = ResidualMC(J);
                    Theta_f(j) = fieldMC(J);
                    Alpha(j) = Coefficient_Alpha(J);
                    n(j) = Coefficient_n(J);
                    m(j) = 1 - 1 ./ n(j);
                    XK(j) = ResidualMC(J) + 0.02;
                    XWILT(j) = equations.van_genuchten(Theta_s(j), Theta_r(j), Alpha(j), -1.5e4, n(j),m(j));
    
                    end
    
                    InitialValues.initH = initH;
                    Dmark = i + 2;
                end
            end
            if abs(InitLnth(ML)) < 1e-10
                subRoutine = 0;
                initX = InitialValues.initX;
                initT = InitialValues.initT;
                initH = InitialValues.initH;
                switch subRoutine
                    case 0
                        from_id = Dmark;
                        to_id = NL + 1;
                        indexOfSoilType = 1; % Index of soil type
                        indexOfInit = 1; % index of initH and initT
                    case 1
                        from_id = Dmark;
                        to_id = ML + 1;
                        indexOfSoilType = 2; % Index of soil type
                        indexOfInit = 2; % index of initH and initT
                    case 2
                        from_id = Dmark;
                        to_id = ML + 1;
                        indexOfSoilType = 3; % Index of soil type
                        indexOfInit = 3; % index of initH and initT
                    case 3
                        from_id = Dmark;
                        to_id = ML + 1;
                        indexOfSoilType = 4; % Index of soil type
                        indexOfInit = 4; % index of initH and initT
                    case 4
                        from_id = Dmark;
                        to_id = ML + 1;
                        indexOfSoilType = 4; % Index of soil type
                        indexOfInit = 5; % index of initH and initT
                    case 5
                        from_id = 1;
                        to_id = ML + 1;
                        indexOfSoilType = 6; % Index of soil type
                        indexOfInit = 6; % index of initH and initT
                end
    
                for MN = from_id:to_id
                    if subRoutine == 5
                        j = MN;
                    else
                        j = MN - 1;
                    end
    
                    IS(MN) = indexOfSoilType;
                    if subRoutine == 4
                        IS(5:8) = 5;
                    end
                    J = IS(MN);
                    % Get soil constants for StartInit
                    POR(j) = porosity(J);
                    Ks(j) = SaturatedK(J);
                    Theta_qtz(j) = Vol_qtz(J);
                    VPER(j, 1) = VPERS(J);
                    VPER(j, 2) = VPERSL(J);
                    VPER(j, 3) = VPERC(J);
                    XSOC(j) = VPERSOC(J);
                    XK(j) = XK(J);
    
                    % get model settings
                    Theta_s(j) = SaturatedMC(J);
                    Theta_r(j) = ResidualMC(J);
                    Theta_f(j) = fieldMC(J);
                    Alpha(j) = Coefficient_Alpha(J);
                    n(j) = Coefficient_n(J);
                    m(j) = 1 - 1 ./ n(j);
                    XK(j) = ResidualMC(J) + 0.02;
                    XWILT(j) = equations.van_genuchten(Theta_s(j), Theta_r(j), Alpha(j), -1.5e4, n(j),m(j));
    
                    if subRoutine == 5
                        Btmh = init.calcInitH(BtmX ,Theta_s(MN), Theta_r(MN), Alpha(MN) , n(MN), m(MN));
                        T(MN) = BtmT + (MN - 1) * (initT(indexOfInit) - BtmT) / ML;
                        h(MN) = Btmh + (MN - 1) * (initH(indexOfInit) - Btmh) / ML;
                        IH(MN) = 1;   % Index of wetting history of soil which would be assumed as dry at the first with the value of 1
                    else
                        delta = ML + 2 - Dmark;
                        domainZ = MN - Dmark + 1;
                        T(MN) = init.calcSoilTemp(initT(indexOfInit), initT(indexOfInit + 1), delta, domainZ);
                        h(MN) = init.calcSoilMatricHead(initH(indexOfInit), initH(indexOfInit + 1), delta, domainZ);
                        IH(j) = 1;
                    end
                end
                InitialValues.initH = initH;
    
            end
        end
    
    else
        for i = 1:ModelSettings.NN
            h(i) = -95;
            T(i) = 22;
            TT(i) = T(i);
            IS(i) = 1;
            IH(i) = 1;
        end
    end

assignin('base', 'T', T);
assignin('base', 'h', h);
assignin('base', 'XWILT', XWILT);











