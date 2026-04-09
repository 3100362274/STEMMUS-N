% function StartInit
% Preset the measured depth to get the initial T, h by interpolation method.
    global InitND1 InitND2 InitND3 InitND4 InitND5 InitND6 InitND7 BtmT BtmX Btmh
    global InitT0 InitT1 InitT2 InitT3 InitT4 InitT5 InitT6 InitT7 Dmark
    global T MN ML NL NN DeltZ Elmn_Lnth Tot_Depth InitLnth
    global InitX0 InitX1 InitX2 InitX3 InitX4 InitX5 InitX6 InitX7   Inith0 Inith1 Inith2 Inith3 Inith4 Inith5 Inith6 Inith7 
    global InitN0 InitN1 InitN2 InitN3 InitN4 InitN5 InitN6 InitN7
    global InitNurea0 InitNurea1 InitNurea2 InitNurea3 InitNurea4 InitNurea5 InitNurea6 InitNurea7 BtmNurea
    global InitNo30 InitNo31 InitNo32 InitNo33 InitNo34 InitNo35 InitNo36 InitNo37 BtmNo3
    global h Theta_s Theta_r m n Alpha Theta_L Theta_LL hh TT P_g P_gg Ks Theta_f 
    global XOLD XWRE NS J POR Thmrlefc IH IS Eqlspace FACc
    global porosity SaturatedMC ResidualMC SaturatedK Coefficient_n Coefficient_Alpha fieldMC
    global NBCh NBCT NBCP NBChB NBCTB NBCPB BChB BCTB BCPB BCh BCT BCP BtmPg 
    global NBCN NBCNB Nefc BCN BCNB BtmN  N Nn No3 Nno3 Ts_msr cTop cBot
    global DSTOR DSTOR0 RS NBChh DSTMAX IRPT1 IRPT2 Soilairefc XK XWILT 
    global HCAP TCON SF TCA GA1 GA2 GB1 GB2 S1 S2 HCD TARG1 TARG2 GRAT VPER 
    global TERM ZETA0 CON0 PS1 PS2 i KLT_Switch DVT_Switch KaT_Switch
    global Kaa_Switch DVa_Switch KLa_Switch 
    global COR CORh Theta_V Theta_g Se KL_h DTheta_LLh hThmrl Tr Hystrs KIT  MSOC FOS FOC FOSL Theta_qtz XSOC
    global nS DIF111 DISP11 DISP1 DIF1111 RHOKG RHOKG1 PH PH1 Nurea Nnurea
    global Km1 Km KC1 KC Kurea1 Kurea K11 K1 K21 K2 K3 K31  Vol_qtz VPERSOC P_g0 

%% 1.Defin constants
    Elmn_Lnth=0;
    Dmark=0;
    FOSL=1-FOC-FOS;                             %fraction of silt
    Vol_qtz=FOS;                                        % fraction of quartz
    %Retun volumetric fraction of soil organic carbon using mass fraction of
    %soil organic carbon (MSOC). Density of organic matter is 1300 kg m-3,
    %and the particle density of mineral material is 2700 kg m-3.
    VPERSOC=MSOC.*2700./((MSOC.*2700)+(1-MSOC).*1300);  % fraction of soil organic matter 2700 kg/m³ 是有机质的密度。1300 kg/m³ 是矿物质的密度。


    for J=1:NS
        POR(J)=porosity(J);
        Theta_s(J)=SaturatedMC(J);
        Theta_r(J)=ResidualMC(J);
        Theta_f(J)=fieldMC(J);
        n(J)=Coefficient_n(J);
        Ks(J)=SaturatedK(J);
        Alpha(J)=Coefficient_Alpha(J);
        m(J)=1-1/n(J);
        XK(J)=Theta_r(J) - 0.01; % 0.11 This is for silt loam; For sand XK=0.025    %Defined as thetaL continuous failure value (wilt point)
        PH1(J)=PH(J);
        XWILT(J) = equations.van_genuchten(Theta_s(J), Theta_r(J), Alpha(J), -1.5e4, n(J),m(J)); % = XK
        VPERS(J)=FOS(J)*(1-POR(J));                   %Define volume sand content
        VPERSL(J)=FOSL(J)*(1-POR(J));                 %Define volume silt content
        VPERC(J)=FOC(J)*(1-POR(J));                   %Define volume clay content
    end
    if ~Eqlspace
        Inith0=-(((Theta_s(J)-Theta_r(J))/(InitX0-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith1=-(((Theta_s(J)-Theta_r(J))/(InitX1-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith2=-(((Theta_s(J)-Theta_r(J))/(InitX2-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith3=-(((Theta_s(J)-Theta_r(J))/(InitX3-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith4=-(((Theta_s(J)-Theta_r(J))/(InitX4-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith5=-(((Theta_s(J)-Theta_r(J))/(InitX5-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith6=-(((Theta_s(J)-Theta_r(J))/(InitX6-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Inith7=-(((Theta_s(J)-Theta_r(J))/(InitX7-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        Btmh=-(((Theta_s(J)-Theta_r(J))/(BtmX-Theta_r(J)))^(1/m(J))-1)^(1/n(J))/Alpha(J);
        if Btmh==-inf
            Btmh=-1e6;
        end
        
%%  2.Considering soil hetero effect
        % Loop over all depth layers

        Ndata = readmatrix('InNitrogenConcentration - 2.xlsx'); % 读取数据文件
        x_data = Ndata(:, 1);
        Nh4_data = Ndata(:, 2);
        No3_data = Ndata(:, 3);
        theta = Ndata(:, 4); 
        tem =  Ndata(:, 5); 
        pressure = Ndata(:, 6).*10000; 
        RHO_b  = Ndata(:, 7); 
        RHO_bulk = mean(RHO_b);
        [Intheta] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, theta);

        % theta = flip(Intheta(:,3));
        for i = 1 : length(x_data)
            if x_data(i) <= 20
                J =1;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            elseif x_data(i) <= 40
                J =2;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            elseif x_data(i) <= 80
                J =3;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            elseif x_data(i) <= 200
                J =4;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            elseif x_data(i) <= 300
                J =5;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            elseif x_data(i) <= 500
                J =6;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));

            elseif x_data(i) <= 700
                J =7;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            else
                J =7;
                Inith(i) = equations.calculate_h(Theta_s(J), Theta_r(J), theta(i), m(J),n(J), Alpha(J));
            end
        end
        [Inithh] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, Inith);
        Inithhh = flip(Inithh(:,2));
        for ML=1:NL
    
            % Accumulate the length of the current element from the bottom
            % depth to the current element  
            Elmn_Lnth=Elmn_Lnth+DeltZ(ML);            
           
            % Calculate the initial length from the top depth to the current element
            InitLnth(ML)=Tot_Depth-Elmn_Lnth; 
            
            % Check if the initial length matches a specific depth threshold 
            % if abs(InitLnth(ML)-1020)<1e-10
            %     for MN=1:(ML+1)
            %         if Nefc == 1
            %             N(MN)=0;
            %             No3(MN)=0;
            %             Nurea(MN)=0;
            %         end
            %     end
            %     DD = ML+2;
            % end
            % 
            % 
            % if abs(InitLnth(ML)-InitND7)<1e-10
            %     for MN=DD:(ML+1)
            %         if Nefc == 1
            %             N(MN)=BtmN+(MN-DD)*(InitN7-BtmN)/(ML+1-DD);
            %             No3(MN)=BtmNo3+(MN-DD)*(InitNo37-BtmNo3)/(ML+1-DD);
            %             Nurea(MN)=BtmNurea+(MN-DD)*(InitNurea7-BtmNurea)/(ML+1-DD);
            %         end
            %     end
            % end
            
            if abs(InitLnth(ML)-InitND7)<1e-10
    
                % Loop through all elements up to the current depth
                for MN=1:(ML+1)
                    IS(MN)=7;   %%%%%% Index of soil type %%%%%%%
    
                    % Assign soil properties based on the soil type index
                    J=IS(MN);
                    POR(MN)=porosity(J);
                    Ks(MN)=SaturatedK(J);
                    Theta_qtz(MN)=Vol_qtz(J);
                    Theta_s(MN)=SaturatedMC(J);
                    Theta_r(MN)=ResidualMC(J);
                    Theta_f(MN)=fieldMC(J);
                    VPER(MN,1)=VPERS(J);
                    VPER(MN,2)=VPERSL(J);
                    VPER(MN,3)=VPERC(J);
                    XSOC(MN)=VPERSOC(J);
                    XK(MN)=Theta_r(J)-0.01;
                    n(MN)=Coefficient_n(J);
                    m(MN)=1-1/n(MN);
                    Alpha(MN)=Coefficient_Alpha(J);
                    PH1(MN)=PH(J);
    
                    % Assign dispersion and diffusion coefficients
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN)=DISP1(J);
                            DIF1111(1,MN,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN)=RHOKG(J);
                        Km1(MN)=Km(J);
                        KC1(MN)=KC(J);
                        Kurea1(MN)=Kurea(J);
                        K11(MN)=K1(J);
                        K21(MN)=K2(J);
                        K31(MN)=K3(J);
                    end

                    % Calculate wilting point, initial and bottom head pressures, and other properties
                    XWILT(MN)=Theta_r(MN)+(Theta_s(MN)-Theta_r(MN))/(1+abs(Alpha(MN)*(-1.5e4))^n(MN))^m(MN);
                    Inith7=-(((Theta_s(MN)-Theta_r(MN))/(InitX7-Theta_r(MN)))^(1/m(MN))-1)^(1/n(MN))/Alpha(MN);
                    Btmh=-(((Theta_s(MN)-Theta_r(MN))/(BtmX-Theta_r(MN)))^(1/m(MN))-1)^(1/n(MN))/Alpha(MN);
                    T(MN)=BtmT+(MN-1)*(InitT7-BtmT)/ML;
                    h(MN)=Btmh+(MN-1)*(Inith7-Btmh)/ML;
                    if Nefc == 1
                        N(MN)=BtmN+(MN-1)*(InitN7-BtmN)/ML;
                        No3(MN)=BtmNo3+(MN-1)*(InitNo37-BtmNo3)/ML;
                        Nurea(MN)=BtmNurea+(MN-1)*(InitNurea7-BtmNurea)/ML;
                    end
                    IH(MN)=2;   %%%%%% Index of wetting history of soil which would be assumed as dry at the first with the value of 1 %%%%%%%  
                end
                Dmark=ML+2;
            end

            if abs(InitLnth(ML)-InitND6)<1e-10
    
                for MN=Dmark:(ML+1)
                    IS(MN-1)=6;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    % XWILT(MN-1)=Theta_r(MN-1)+(Theta_s(MN-1)-Theta_r(MN-1))/(1+abs(Alpha(MN-1)*(-1.5e4))^n(MN-1))^m(MN-1);
                    Inith6=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX6-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT7+(MN-Dmark+1)*(InitT6-InitT7)/(ML+2-Dmark);
                    h(MN)=(Inith7+(MN-Dmark+1)*(Inith6-Inith7)/(ML+2-Dmark));
                 
                    if Nefc == 1
                        N(MN)=(InitN7+(MN-Dmark+1)*(InitN6-InitN7)/(ML+2-Dmark));
                        No3(MN)=(InitNo37+(MN-Dmark+1)*(InitNo36-InitNo37)/(ML+2-Dmark));
                        Nurea(MN)=(InitNurea7+(MN-Dmark+1)*(InitNurea6-InitNurea7)/(ML+2-Dmark));
                    end
                    IH(MN-1)=1;
                end
                Dmark=ML+2;
            end

            if abs(InitLnth(ML)-InitND5)<1e-10
    
                for MN=Dmark:(ML+1)
                    IS(MN-1)=5;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    % XWILT(MN-1)=Theta_r(MN-1)+(Theta_s(MN-1)-Theta_r(MN-1))/(1+abs(Alpha(MN-1)*(-1.5e4))^n(MN-1))^m(MN-1);
                    Inith5=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX5-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT6+(MN-Dmark+1)*(InitT5-InitT6)/(ML+2-Dmark);
                    h(MN)=(Inith6+(MN-Dmark+1)*(Inith5-Inith6)/(ML+2-Dmark));
                   
                    if Nefc == 1
                        N(MN)=(InitN6+(MN-Dmark+1)*(InitN5-InitN6)/(ML+2-Dmark));
                        No3(MN)=(InitNo36+(MN-Dmark+1)*(InitNo35-InitNo36)/(ML+2-Dmark));
                        Nurea(MN)=(InitNurea6+(MN-Dmark+1)*(InitNurea5-InitNurea6)/(ML+2-Dmark));
                    end
                    IH(MN-1)=2;
                end
                Dmark=ML+2;
            end
    
            % Repeat similar blocks for different depth thresholds (InitND4, InitND3, InitND2, InitND1, InitND0)
            if abs(InitLnth(ML)-InitND4)<1e-10
                for MN=Dmark:(ML+1)
                    IS(MN-1)=4;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    % XWILT(MN-1)=Theta_r(MN-1)+(Theta_s(MN-1)-Theta_r(MN-1))/(1+abs(Alpha(MN-1)*(-1.5e4))^n(MN-1))^m(MN-1);
                    Inith4=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX4-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT5+(MN-Dmark+1)*(InitT4-InitT5)/(ML+2-Dmark);
                    h(MN)=(Inith5+(MN-Dmark+1)*(Inith4-Inith5)/(ML+2-Dmark));
                   
                    if Nefc == 1
                    N(MN)=(InitN5+(MN-Dmark+1)*(InitN4-InitN5)/(ML+2-Dmark));
                    No3(MN)=(InitNo35+(MN-Dmark+1)*(InitNo34-InitNo35)/(ML+2-Dmark));
                    Nurea(MN)=(InitNurea5+(MN-Dmark+1)*(InitNurea4-InitNurea5)/(ML+2-Dmark));
                    end
                    IH(MN-1)=1;
                end
                Dmark=ML+2;
            end
            if abs(InitLnth(ML)-InitND3)<1e-10
                for MN=Dmark:(ML+1)
                    IS(MN-1)=3;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    Inith3=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX3-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT4+(MN-Dmark+1)*(InitT3-InitT4)/(ML+2-Dmark);
                    h(MN)=(Inith4+(MN-Dmark+1)*(Inith3-Inith4)/(ML+2-Dmark));
                    
                    if Nefc == 1
                    N(MN)=(InitN4+(MN-Dmark+1)*(InitN3-InitN4)/(ML+2-Dmark));
                    No3(MN)=(InitNo34+(MN-Dmark+1)*(InitNo33-InitNo34)/(ML+2-Dmark));
                    Nurea(MN)=(InitNurea4+(MN-Dmark+1)*(InitNurea3-InitNurea4)/(ML+2-Dmark));
                    end
                    IH(MN-1)=1;
                end
                Dmark=ML+2;
            end
            if abs(InitLnth(ML)-InitND2)<1e-10
                for MN=Dmark:(ML+1)
                    IS(MN-1)=2;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    Inith2=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX2-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT3+(MN-Dmark+1)*(InitT2-InitT3)/(ML+2-Dmark);
                    h(MN)=(Inith3+(MN-Dmark+1)*(Inith2-Inith3)/(ML+2-Dmark));
                    
                    if Nefc == 1
                    N(MN)=(InitN3+(MN-Dmark+1)*(InitN2-InitN3)/(ML+2-Dmark));
                    No3(MN)=(InitNo33+(MN-Dmark+1)*(InitNo32-InitNo33)/(ML+2-Dmark));
                    Nurea(MN)=(InitNurea3+(MN-Dmark+1)*(InitNurea2-InitNurea3)/(ML+2-Dmark));
                    end
                    IH(MN-1)=2;
                end
                Dmark=ML+2;
            end
            if abs(InitLnth(ML)-InitND1)<1e-10
                for MN=Dmark:(ML+1)
                    IS(MN-1)=1;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    Inith1=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX1-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT2+(MN-Dmark+1)*(InitT1-InitT2)/(ML+2-Dmark);
                    h(MN)=(Inith2+(MN-Dmark+1)*(Inith1-Inith2)/(ML+2-Dmark));
                     
                    if Nefc == 1
                    N(MN)=(InitN2+(MN-Dmark+1)*(InitN1-InitN2)/(ML+2-Dmark));
                    No3(MN)=(InitNo32+(MN-Dmark+1)*(InitNo31-InitNo32)/(ML+2-Dmark));
                    Nurea(MN)=(InitNurea2+(MN-Dmark+1)*(InitNurea1-InitNurea2)/(ML+2-Dmark));
                    end
                    IH(MN-1)=2;
                end
                Dmark=ML+2;
            end
            if abs(InitLnth(ML))<1e-10
                for MN=Dmark:(NL+1)
                    IS(MN-1)=1;
                    J=IS(MN-1);
                    POR(MN-1)=porosity(J);
                    Ks(MN-1)=SaturatedK(J);
                    Theta_qtz(MN-1)=Vol_qtz(J);
                    VPER(MN-1,1)=VPERS(J);
                    VPER(MN-1,2)=VPERSL(J);
                    VPER(MN-1,3)=VPERC(J);
                    XSOC(MN-1)=VPERSOC(J);
                    Theta_s(MN-1)=SaturatedMC(J);
                    Theta_r(MN-1)=ResidualMC(J);
                    Theta_f(MN-1)=fieldMC(J);
                    XK(MN-1)=Theta_r(MN-1)-0.01;
                    n(MN-1)=Coefficient_n(J);
                    m(MN-1)=1-1/n(MN-1);
                    Alpha(MN-1)=Coefficient_Alpha(J);
                    PH1(MN-1)=PH(J);
                    if Nefc == 1
                        for js=1:nS
                            DISP11(MN-1)=DISP1(J);
                            DIF1111(1,MN-1,js)=DIF111(1,J,js);
                        end
                        RHOKG1(MN-1)=RHOKG(J);
                        Km1(MN-1)=Km(J);
                        KC1(MN-1)=KC(J);
                        Kurea1(MN-1)=Kurea(J);
                        K11(MN-1)=K1(J);
                        K21(MN-1)=K2(J);
                        K31(MN-1)=K3(J);
                    end
                    XWILT(MN-1) = equations.van_genuchten(Theta_s(MN-1), Theta_r(MN-1), Alpha(MN-1), -1.5e4, n(MN-1),m(MN-1));
                    Inith0=-(((Theta_s(MN-1)-Theta_r(MN-1))/(InitX0-Theta_r(MN-1)))^(1/m(MN-1))-1)^(1/n(MN-1))/Alpha(MN-1);
                    T(MN)=InitT1+(MN-Dmark+1)*(InitT0-InitT1)/(NL+2-Dmark);
                    h(MN)=(Inith1+(MN-Dmark+1)*(Inith0-Inith1)/(NL+2-Dmark));
                    
                    if Nefc == 1
                    N(MN)=(InitN1+(MN-Dmark+1)*(InitN0-InitN1)/(NL+2-Dmark));
                    No3(MN)=(InitNo31+(MN-Dmark+1)*(InitNo30-InitNo31)/(NL+2-Dmark));
                    Nurea(MN)=(InitNurea1+(MN-Dmark+1)*(InitNurea0-InitNurea1)/(NL+2-Dmark));
                    end
                    IH(MN-1)=2;
                end
            end
        end
    else
        for MN=1:NN
            h(MN)=-95;
            T(MN)=22;
            TT(MN)=T(MN);
            N(MN)=22;  %N的浓度
            No3(MN)=12;
            Nurea(MN)=1; %尿素含量
            IS(MN)=1;
            IH(MN)=2;
        end
    end

%% 3.Define initial variable
[InNh4] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, Nh4_data);
[InNo3] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, No3_data);
N = flip(InNh4(:,3));  % -2 liner -3 Pchip
No3 = flip(InNo3(:,3));
[Intem] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, tem);
[Inpressure] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, pressure); 
T= flip(Intem(:,3));
P_g =  flip(Inpressure (:,3)) ;
RHO_b = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, RHO_b);
RHO_bb =  flip(RHO_b (:,3)) ;
     for MN=1:NN
        hh(MN)=Inithhh(MN);
        if Thmrlefc==1
            TT(MN)=T(MN);
        end
        if Soilairefc==1
            %P_g(MN)=P_g0;
            P_gg(MN)=P_g(MN);
        end
        if Nefc==1
            Nn(MN)=N(MN);
            Nno3(MN)=No3(MN);     
        end
        if MN<NN
            XWRE(MN,1)=0;
            XWRE(MN,2)=0;
        end
    end

%% 4.Perform initial thermal calculations for each soil type. initial thermal calculations for each soil type
HCAP(1)=0.998*4.182;HCAP(2)=0.0003*4.182;HCAP(3)=0.46*4.182;HCAP(4)=0.46*4.182;HCAP(5)=0.6*4.182;% J cm^-3 Cels^-1  /  g.cm-3---> J g-1 Cels-1; 
TCON(1)=1.37e-3*4.182;TCON(2)=6e-5*4.182;TCON(3)= 2.1e-2 * 4.182;TCON(4)=7e-3 * 4.182;TCON(5)=6e-4 * 4.182;% thermal conductivity ZENG origial TCON(3)=2.1e-2*4.182;TCON(4)=7e-3*4.182;TCON(5)=6e-4*4.182; % J cm^-1 s^-1 Cels^-1; 
SF(1)=0;SF(2)=0;SF(3)=0.125;SF(4)=0.125;SF(5)=0.5;% form factor                             
TCA=6e-5*4.182;% =TCON(2)=6e-5*4.182; Thermal conductivity of dry air
GA1=0.035;GA2=0.013; % Calculate the dry gas shape factor                                                                                                   
% VPER(1)=0.16;VPER(2)=0.33;VPER(3)=0.05; % for sand VPER(1)=0.65;VPER(2)=0;VPER(3)=0;   %  For Silt Loam; % VPER(1)=0.16;VPER(2)=0.33;VPER(3)=0.05; %VPER(1)=0.181;VPER(2)=0.307;VPER(3)=0.079;
                                                                                                                                                                                                                              
for J=1:NL          %--------------> Sum over all phases of dry porous media to find the dry heat capacity                                             
    S1=POR(J)*TCA;  %-------> and the sums in the dry thermal conductivity;                                                                     
    S2=POR(J);                                                                                                                                  %
    HCD(J)=0;
    VPERCD(J,1)=VPER(J,1)*(1-XSOC(J));
    VPERCD(J,2)=(VPER(J,2)+VPER(J,3))*(1-XSOC(J));
    VPERCD(J,3)=XSOC(J)*(1-POR(J));

    for i=3:5                                                                                                                                   %
        TARG1=TCON(i)/TCA-1;                                                                                                                    %
        GRAT=0.667/(1+TARG1*SF(i))+0.333/(1+TARG1*(1-2*SF(i)));                                                                                 %
        S1=S1+GRAT*TCON(i)*VPERCD(J,i-2);                                                                                                           %
        S2=S2+GRAT*VPERCD(J,i-2);                                                                                                                   %
        HCD(J)=HCD(J)+HCAP(i)*VPERCD(J,i-2);                                                                                                        %
    end                                                                                                                                         %
    ZETA0(J)=1/S2;                                                                                                                              %
    CON0(J)=1.25*S1/S2;                                                                                                                         %
    PS1(J)=0;                                                                                                                                   %
    PS2(J)=0;                                                                                                                                   %
    for i=3:5                                                                                                                                   %
        TARG2=TCON(i)/TCON(1)-1;                                                                                                                %
        GRAT=0.667/(1+TARG2*SF(i))+0.333/(1+TARG2*(1-2*SF(i)));                                                                                 %
        TERM=GRAT*VPERCD(J,i-2);                                                                                                                    %
        PS1(J)=PS1(J)+TERM*TCON(i);                                                                                                             %
        PS2(J)=PS2(J)+TERM;                                                                                                                     %
    end                                                                                                                                         %
    GB1(J)=0.298/POR(J);                                                                                                                        %
    GB2(J)=(GA1-GA2)/XWILT(J)+GB1(J);                                                                                                           %
end                                                                                                                                             %

%% 5.According to hh value get the Theta_LL
[hh,COR,CORh,Theta_V,Theta_g,Se,KL_h,Theta_LL,DTheta_LLh]=SOIL2(hh,COR,CORh,hThmrl,NN,NL,TT,Tr,Hystrs, ...
                                                                  XWRE,Theta_s,IH,KIT,Theta_r,Alpha,n,m,Ks ...
                                                                  ,Theta_L,h,Thmrlefc,POR);  % For calculating Theta_LL,used in first Balance calculation.

for ML=1:NL
        Theta_L(ML,1)=Theta_LL(ML,1);
        Theta_L(ML,2)=Theta_LL(ML,2);
        XOLD(ML)=(Theta_L(ML,1)+Theta_L(ML,2))/2;
end
%总浓度转溶解态浓度使用
if Nefc==1 && Ntotal == 1
    [InNh4] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, Nh4_data);
    [InNo3] = InNitrogenConcentrationDistribute([0 ; SUMDELTZ], x_data, No3_data);
    NH44 = flip(InNh4(:,3));  % -2 liner -3 Pchip
    NO33 = flip(InNo3(:,3));
    for ML = 1: NL
        for ND = 1:2
            MN = ML + ND -1;
            N(MN) = NH44(MN) / (Theta_LL(ML,ND)+RHOKG1(ML));
            No3(MN) = NO33(MN) / (Theta_LL(ML,ND));

        end
    end

    for MN=1:NN
        Nn(MN)=N(MN);
        Nno3(MN)=No3(MN);
        Nnurea(MN,1)=Nurea(MN);
    end
end

% Using the initial condition to get the initial balance
% information---Initial heat storage and initial moisture storage.
KLT_Switch=1;
DVT_Switch=1;
if Soilairefc
    KaT_Switch=1;
    Kaa_Switch=1;
    DVa_Switch=1;
    KLa_Switch=1;
else
    KaT_Switch=0;
    Kaa_Switch=0;
    DVa_Switch=0;
    KLa_Switch=0;
end

%% 6.The boundary condition information settings.
% BoundaryCondition = init.setBoundaryCondition(Soilairefc,Thmrlefc,Ts_msr,Nefc);
IRPT1=0;
IRPT2=0;
NBCh=3;      % Moisture Surface B.C.: 1 --> Specified matric head(BCh); 2 --> Specified flux(BCh); 3 --> Atmospheric forcing;
BCh=-0.5;
NBChB=3;    % Moisture Bottom B.C.: 1 --> Specified matric head (BChB); 2 --> Specified flux(BChB); 3 --> Zero matric head gradient (Gravitiy drainage);
BChB=-929.387280081274; 
if Thmrlefc==1
    NBCT=1;  % Energy Surface B.C.: 1 --> Specified temperature (BCT); 2 --> Specified heat flux (BCT); 3 --> Atmospheric forcing;
    BCT=Ts_msr(1);   %;  % surface temperature
    NBCTB=1;% Energy Bottom B.C.: 1 --> Specified temperature (BCTB); 2 --> Specified heat flux (BCTB); 3 --> Zero temperature gradient;
    BCTB=BtmT;
end
if Soilairefc==1
    NBCP=3; % Soil air pressure B.C.: 1 --> Ponded infiltration caused a specified pressure value; 
                % 2 --> The soil air pressure is allowed to escape after beyond the threshold value;
                % 3 --> The atmospheric forcing;
    BCP=0;  
    NBCPB=2;  % Soil air Bottom B.C.: 1 --> Bounded bottom with specified air pressure; 2 --> Soil air is allowed to escape from bottom;
    BCPB=0;  
end

if NBCh~=1
    NBChh=2;                    % Assume the NBChh=2 firstly;
end

if Nefc==1
    NBCN=2;
    %Indicator for type of surface boundary condition on N equation to be applied;
    %>        "1"--Specified N concentration;
    %>        "2"--Specified N flux;
    for js=1:nS
        BCN=1;  %cTop(KT,js);
    end
    NBCNB=3;
    %Type of boundary condition on N at bottom of column;
    %>        "1"--Specified concentration of BCNB at bottom;
    %>        "2"--Specified N flux of BCNB;
    %>        "3"--Zero matric N gradient at bottom(Gravity drainage);
    for js=1:nS
        BCNB=1;  %cBot(KT,js);
    end
end

FACc=0;                         % Used in MeteoDataCHG for check is FAC changed?
BtmPg=P_g0;                     % Atmospheric pressure at the bottom (Pa), set fixed with the value of mean atmospheric pressure;
DSTOR=0;                        % Depth of depression storage at end of current time step，洼地量;
DSTOR0=DSTOR;                   % Dept of depression storage at start of current time step;
RS=0;                           % Rate of surface runoff;
DSTMAX=0;                       % Depression storage capacity;

