    %% function MainLoop
    clc;
    clear;
    clear global;
    close all;
    tic;
    run Constants               % input soil parameters

    %% 0.Globals
    global i tS KT Delt_t TEND TIME current_year  current_day current_hour  MN NN NL ML ND hOLD TOLD h hh T TT P_gOLD P_g P_gg Delt_t0 
    global KIT NIT NITT TimeStep Processing 
    global SUMTIME Daytime hhh TTT P_ggg  DSTOR Thmrlefc CHK CHKWATER CHK2 CHK3 Theta_LL Theta_L
    global NBCh NBChB AVAIL DSTOR0 EXCESS QMT RS BCh hSAVE NBChh DSTMAX Soilairefc Trap 
    global TSAVE IRPT1 IRPT2 AVAIL0 TIMEOLD TIMELAST SRT ALPHA BX alpha_h bx Srt L lSat
    global QL QL_h QL_T QL_A QV Qa  G KL_h  QV_h QV_T QVA DhDZ DTDZ 
    global cvSnit cvSmin cvSden cvSvol cvSinkS cvSinkS1 QNH4 QNO3
    global Nefc N Nn  Nnurea NNurea NNN NOLD NSAVE NSAVE2 No3OLD No3 Nno3 NNno3 nS 
    global D_Vg Theta_g Sa V_A k_g MU_a DeltZ Alpha_Lg
    global J Beta_g KaT_Switch Theta_s
    global D_V D_A fc Eta nD POR Se 
    global ThmrlCondCap ZETA XK DVT_Switch lExtrap VInfil
    global m g MU_W Ks RHOL
    global Lambda1 Lambda2 Lambda3 c_unsat Lambda_eff RHO_bulk
    global HCAP SF TCA GA1 GA2 GB1 GB2 HCD ZETA0 CON0 PS1 PS2 XWILT TCON
    global RHODA RHOV c_a c_V c_L
    global ETCON EHCAP
    global Xaa XaT Xah RDA Rv KL_T
    global DRHOVT DRHOVh DRHODAt DRHODAz
    global hThmrl Tr COR CORh Hystrs XWRE
    global Theta_V DTheta_LLh IH 
    global W WW D_Ta SSUR  NoTime DayHour
    global W_Chg DPgDZ QMT QMB cvBot cvTop cvBot1 cvTop1 QET QEB
    global KLT_Switch Theta_r Alpha n PH1 FT FZ Svol SVvol BNF Kurea1 Nurea Shys
    global Retard RetardBAR RHOKG1 Dsh DIF1111 mL DISP11 Smin K31 Theta_f R eT eTheta ePH Theta_LLBAR Snit SVnit K11 Sden SVden K21 lBNF
    global fw DIF2 DIF2BAR DISP2 Dsh_h Dsh_T Dsh_A Cvnit_N2o  Cvdenit_N2o Cvdenit_N2 Peclet1 Peclet2  cvnh4OLD cvno3OLD cvnh4 cvno3
    global  KLhBAR KLTBAR DTDBAR Ta  Tbh Tsh TopPg QLN 
    global SHRL_all_days DRDS_list RDS_list LAI_daily VPD  EVAP Tp_t TP_t Resis_a r_s_SOIL  r_s_VEG r_a_VEG  HR_a U Ts
    global g rwuef Tm Tmax Tmin JN n_act h_v rl_min Z dms_string Lm WSI RG evfi Nmsrmn Tot_Depth rsuef Throughfall Infiltration Infiltration_act TopFlux_potential
    global QNH4_h QNH4_T QNH4_A QNH4_convection QNH4_convection_h QNH4_convection_T QNH4_convection_A QNH4_dispersion ...  
          QNH4_dispersion_h QNH4_dispersion_T QNH4_dispersion_A QNO3_h ...
          QNO3_T  QNO3_A QNO3_convection QNO3_convection_h QNO3_convection_T ...
          QNO3_convection_A QNO3_dispersion QNO3_dispersion_h QNO3_dispersion_T QNO3_dispersion_A

  
%% 1.Initial state setting
    % run Copy_of_StartInit    
    run StartInit;   % Initialize Temperature, Matrix potential and soil air pressure.
    
    % for soil moisture and temperature outputs
    monitorDepthTemperature = NN:-1:1;
    monitorDepthSoilMoisture = NN:-1:1;
    monitorDepthPressure = NN:-1:1;
    monitorDepthNitrogen = NN:-1:1;
    Sim_Theta = [];
    Sim_Temp = [];
    Sim_NH4 = [];
    Sim_NO3 = [];
%% 2.Run the model
    fprintf('\nThe calculations start now\n')
    TIMEOLD=0;
    TIMELAST=0;
    while TIME < TEND                     % Notice here: In this code, the 'i' is strictly used for TimeStep loop and the arrases index of meteorological forcing data.                       
        KT=KT+1;                          % Counting Number of timesteps
        fprintf('\nThe calculations processing now KT: %d\n', KT')
        if KT>1 && Delt_t>(TEND-TIME)
            Delt_t=TEND-TIME;             % If Delt_t is changed due to excessive change of state variables, the judgement of the last time step is excuted.
        end
        TIME=TIME+Delt_t;                 % The time elapsed since start of simulation
        TimeStep(KT,1)=Delt_t;
        SUMTIME(KT,1)=TIME;
        NoTime(KT)=fix(SUMTIME(KT)/3600/24);
        DayHour(KT) = mod(SUMTIME(KT) / 3600 / 24 , 1) ;
        Processing=TIME/TEND;
        fprintf('\nThe  processing : %d\n', Processing')
        % 更新当前日期和检查年份变化
        current_date(KT) = start_time + seconds(TIME);
        if month(current_date(KT)) == 1 && day(current_date(KT)) == 1 && KT > 1
            current_year = year(current_date(KT)); % 打印年份变更信息
            current_day = day(current_date(KT)) ;
            current_hour = hour(current_date(KT)) ;
        end

        run Forcing_PARM
        %  Updating the state variables.If there is a heavy rainstorm, etc., the infiltration rate will exceed the infiltration rate. 
            NBChh = 2; % 继续通量边界，未超过入渗能力


        if IRPT1==0 && IRPT2==0
            hh_extrap  = zeros(NN,1);
            TT_extrap  = zeros(NN,1);
            iBot = 1;
            if NBChB == 1 || NBChh == 1,iBot=2;end
            iTop = NN;
            if NBCh == 1 || NBChh == 1, iTop=NN-1;end
            for MN = iBot : iTop
                if KT > 1 && lExtrap == 1 && all(hh < 0) && all(h < 0)
                    alpha1 = Delt_t / Delt_old;
                    hh_extrap(MN) = hh(MN) + alpha1*(hh(MN) - h(MN));
                    TT_extrap(MN)=TT(MN)+(TT(MN)-T(MN))*alpha1;
                else
                    hh_extrap(MN) = hh(MN);
                    TT_extrap(MN)=TT(MN);
                end
            end

            if Nefc == 1
                [should_apply, F_conc] = fert_controller(current_date(KT));
                DEPTHSTART = 40;
                DEPTHEND = 45;  % fertdepth cm
                DepthStart = find(abs(SUMDELTZ - DEPTHSTART) < 1e-6, 1);
                DEPTHNL = find(abs(SUMDELTZ - DEPTHEND) < 1e-6, 1);
                V_control = zeros(NN,1);
                if should_apply
                    V_control(NN) = 0; %DeltZ(NL)/2;
                    V_control(NL-DEPTHNL+1) =  1; %DeltZ(NL-DEPTHNL+1)/2;
                    for  i = NL-DepthStart+1  : -1 :NL-DEPTHNL+2  %Theta_LL(NL,2)
                        V_control(i) = (DeltZ(i) +  DeltZ(i-1) )/2;
                        V_control(i) = 1;
                    end
                    V_sumcontrol = sum(V_control);
                    vfert=V_control';%V_control./V_sumcontrol
                    F_concnode =  F_conc * vfert;%* vfert
                    %h_concnode =  -0.5 * vfert;
                    F_NH4liquidconcnode = zeros(NN,1);
                    F_NO3liquidconcnode = zeros(NN,1);
                    for ML=1:ML
                        for ND = 1:2
                            MN = ML +ND -1;
                            F_NH4liquidconcnode(MN,1) =  F_concnode(MN) ;%/ (Theta_LL(ML,ND)+RHOKG1(ML)); %  NH4+
                            F_NO3liquidconcnode(MN,1) =  F_concnode(MN); %/ (Theta_LL(ML,ND)); % NO3-
                            F_Nurealiquidconcnode(MN,1) =F_concnode(MN);
                        end
                    end
                    % Nn = F_NH4liquidconcnode + Nn;
                    Nnurea = F_Nurealiquidconcnode + Nnurea;
                    
                    %hh(157:end)=     h_NO3liquidconcnode(157:end);
                end
            end


            for ML=1:NL % hhh TTT P_ggg NNno3 NNN from stratnit to end ALPHA1 SRT from stratnit to end - 1
                for ND = 1:2
                    MN = ML +ND -1;
                    hOLD(MN)=h(MN);  %上一时间步长
                    h(MN)=hh(MN);    %当前时间步长，hh下一时间步长预估值
                    hhh(MN,KT)=hh(MN);

                    if Thmrlefc==1
                        TOLD(MN)=T(MN);
                        T(MN)=TT(MN);
                        TTT(MN,KT)=TT(MN);
                        node_temperatures = TT;
                        layer_temperatures = zeros(1, NL);   % 初始化每层的温度值数组
                        for ML = 1:NL
                            layer_temperatures(ML) = mean([node_temperatures(ML), node_temperatures(ML+1)]);  % 每层的平均温度
                            layer_temperatures1(ML,KT) = layer_temperatures(ML);
                        end
                    end

                    if Soilairefc==1
                        P_gOLD(MN)=P_g(MN);
                        P_g(MN)=P_gg(MN);
                        P_ggg(MN,KT)=P_gg(MN);
                        node_pressures = P_gg;
                        layer_pressures = zeros(1, NL);   % 初始化每层的温度值数组
                        for ML = 1:NL
                            layer_pressures(ML) = mean([node_pressures(ML), node_pressures(ML+1)]);  % 每层的平均温度
                            layer_pressures1(ML,KT) = layer_pressures(ML);
                        end
                    end

                    if Nefc==1
                        NOLD(MN)=N(MN);     % NH4+
                        N(MN)=Nn(MN);
                        NNN(MN,KT)=Nn(MN);
                        No3OLD(MN)=No3(MN); % NO3-
                        No3(MN)=Nno3(MN);
                        NNno3(MN,KT)=Nno3(MN);
                        No3OLD(MN)=Nurea(MN); % Nurea
                        Nurea(MN)=Nnurea(MN);
                        NNurea(MN,KT)=Nnurea(MN);
                    end

                    if rwuef==1
                        SRT(MN,KT)=Srt(MN,1);
                        ALPHA1(MN,KT)=ALPHA(MN);
                        % BX(MN,KT)=bx(MN,1);
                    end
                end
            end
            if Ntotal == 1
                for ML=1:NL % hhh TTT P_ggg NNno3 NNN from stratnit to end ALPHA1 SRT from stratnit to end - 1
                    for ND = 1:2
                        MN = ML +ND -1;
                        NNN_TOTAL(MN,KT)=Nn(MN)*(Theta_LL(ML,ND)+RHOKG1(ML));  %溶解态浓度转总浓度使用
                        NNno3_TOTAL(MN,KT)=Nno3(MN)*(Theta_LL(ML,ND));
                        PH1(ML) = 0.374 * exp(-(NNno3_TOTAL(MN,KT)./RHO_bb(MN))/2.530) + 0.202 * exp(-(NNno3_TOTAL(MN,KT)./RHO_bb(MN))/165.591) + 0.208 * exp(-(NNno3_TOTAL(MN,KT)./RHO_bb(MN))/165.562) + 7.872;
                    end
                end
            end

            % 2025/3/13加入外推法和饱和不饱和过度
            if KT > 1 && lExtrap == 1
                hh = hh_extrap;
                TT = TT_extrap;
            end
            
            % 2025/3/13 加入
            lSat = 1;
            if hh(1:NN) < 0 , lSat = 0;end
            if lSat == 1 
                if NBCh == 1 || NBCh == 3
                    if NBChh == 1,NBChh = 2;end
                    h(NN)=-0.5;
                    hh(NN)=-0.5;
                end
            end

            DSTOR0=DSTOR;

            if KT>1
                run SOIL1
            end
        end

        if Delt_t~=Delt_old
            for MN=1:NN
                hh(MN)=h(MN)+(h(MN)-hOLD(MN))*Delt_t/Delt_old;
                TT(MN)=T(MN)+(T(MN)-TOLD(MN))*Delt_t/Delt_old;
                if Nefc ==1
                    Nn(MN)=N(MN)+(N(MN)-NOLD(MN))*Delt_t/Delt_old;
                    Nno3(MN)=No3(MN)+(No3(MN)-No3OLD(MN))*Delt_t/Delt_old;
                end
            end
        end

        hSAVE=hh(NN);
        TSAVE=TT(NN);
        NSAVE=Nn(MN);
        NSAVE2=Nno3(NN);

        if DSTMAX && DSTOR0 > 0
            if(hh(NN) > 0)
                NBChh = 1;
                hN=hsaturation;
            end
        end

        if NBCh==1
            hN=BCh;
            hh(NN)=hN;
            hSAVE=hN;
        elseif NBCh==2
            if NBChh~=2
                if BCh<0
                    hN=DSTOR0;
                    hh(NN)=hN;
                    hSAVE=hN;
                else
                    hN=-1e6;
                    hh(NN)=hN;
                    hSAVE=hN;
                end
            end
        else
            if NBChh~=2
                    hN=hsaturation;
                hh(NN)=hN;
                hSAVE=hN;
            end
        end

        % Start the iteration procedure in a time step.
        for KIT=1:NIT   
            [hh,COR,CORh,Theta_V,Theta_g,Se,KL_h,Theta_LL,DTheta_LLh]=SOIL2(hh,COR,CORh,hThmrl,NN,NL,TT,Tr,Hystrs,XWRE,Theta_s,IH,KIT,Theta_r,Alpha,n,m,Ks,Theta_L,h,Thmrlefc,POR);
            [KL_T]=CondL_T(NL,KLT_Switch,hh,GWT,TT,Gamma0,KL_h);
            [RHOV,DRHOVh,DRHOVT]=Density_V(TT,hh,g,Rv,NN);
            [W,WW,MU_W,D_Ta]=CondL_Tdisp(POR,Theta_LL,Theta_L,SSUR,RHO_bulk,RHOL,TT,Theta_s,h,hh,W_Chg,NL,nD,Delt_t,Theta_g,KLT_Switch);
            [L]= Latent(TT,NN);
            [Xaa,XaT,Xah,DRHODAt,DRHODAz,RHODA]=Density_DA(T,RDA,P_g,Rv,DeltZ,h,hh,TT,P_gg,Delt_t,NL,NN,DRHOVT,DRHOVh,RHOV);
            [c_unsat,Lambda_eff,ZETA,ETCON,EHCAP]=CondT_coeff(Theta_LL,Lambda1,Lambda2,Lambda3,RHO_bulk,Theta_g,RHODA,RHOV,c_a,c_V,c_L,NL,nD,ThmrlCondCap, ...
                HCAP,SF,TCA,GA1,GA2,GB1,GB2,HCD,ZETA0,CON0,PS1,PS2,XWILT,XK,TT,POR,DRHOVT,L,D_A,Theta_V, ...
                c_unsat,Lambda_eff,ETCON,EHCAP,ZETA,TCON);
            [Sa,k_g]=Condg_k_g(POR,NL,J,m,Theta_g,g,MU_W,Ks,RHOL,Se);
            [D_V,Eta,D_A]=CondV_DE(Theta_LL,TT,fc,Theta_s,NL,nD,J,Theta_g,POR,ThmrlCondCap,ZETA,XK,DVT_Switch);
            [D_Vg,V_A,Beta_g]=CondV_DVg(P_gg,Theta_g,Sa,V_A,k_g,MU_a,DeltZ,Alpha_Lg,KaT_Switch,Theta_s,Se,NL,J);
             % [CHU_record,HUI_record,HU,SHRL_all_days,DRDS_list, RDS_list, HUF, dHUF,  LAI_daily,LAI,Resis_a,r_s_SOIL,r_s_VEG,r_a_VEG,f_min]= Evap_Cal_Pentext(DeltZ,TIME,RHOV,Ta,HR_a,U,Theta_LL,Ts, ...
             %    g,NL,NN,KT,hh,Tm,Tmax, Tmin,Theta_f, Theta_s,JN,n_act,h_v, ...
             %     rl_min,Z,dms_string,Lm,NoTime,Tao);

            run Evap_Cal_FAO.m
             
           [Tsh,Tbh,Ts1] = CalculateTemperatureBoundary(Tav,At,Tm,Tao,LAI,Tot_Depth,Lambda_eff,c_unsat, ...
    start_time,end_time,Lambda_effBAR,c_unsatBAR,BCT,current_year,NL,KT,Ts1,Tb,SUMTIME);

            run h_sub;

            if NBCh==1
                DSTOR=0;
                RS=0;
            elseif NBCh==2
                AVAIL=-BCh;
                EXCESS=(AVAIL-QMT(KT))*Delt_t;
                if abs(EXCESS/Delt_t)<=1e-10 && EXCESS >0,EXCESS=0;end
                DSTOR=min(EXCESS,DSTMAX);
                RS=(EXCESS-DSTOR)/Delt_t;
            else
                EXCESS=(TopFlux_potential(KT)-QMT(KT))*Delt_t;
                if abs(EXCESS/Delt_t)<=1e-10 && EXCESS >0,EXCESS=0;end
                DSTOR=min(EXCESS,DSTMAX);
                RS(KT)=(EXCESS-DSTOR)/Delt_t;
            end

            if Soilairefc==1
                run Air_sub;
            end

            if Thmrlefc==1
                run Enrgy_sub;
            end

            if  (max(CHK) <0.1  ) || KIT == NIT 
                [hh,COR,CORh,Theta_V,Theta_g,Se,KL_h,Theta_LL,DTheta_LLh]=SOIL2(hh,COR,CORh,hThmrl,NN,NL,TT,Tr,Hystrs,XWRE,Theta_s,IH,KIT,Theta_r,Alpha,n,m,Ks,Theta_L,h,Thmrlefc,POR);
                if Nefc == 1
                    % 定义阈值和容差参数（可配置到全局参数中）
                    error_thresholds = [10, 200];      % [mg/L]
                    error_tolerances = [0.1, 0.1, 0.1];    % 对应容差
                    max_iter = 100;  % 提升可配置性
                    tolerance_factor = 1;  % 动态松弛因子
                    cvnh4OLD(KT) = 0;
                    cvno3OLD(KT) = 0;
                    for ML = 1 : NL
                        cvnh4OLD(KT) = cvnh4OLD(KT) + DeltZ(ML) * ((Theta_L(ML,1)+RHOKG1(ML))*N(ML)+(Theta_L(ML,2)+RHOKG1(ML))*N(ML+1))/2;
                    end
                    for ML = 1 : NL
                        cvno3OLD(KT) = cvno3OLD(KT)+ DeltZ(ML) * (Theta_L(ML,1)*No3(ML)+Theta_L(ML,2)*No3(ML+1))/2;
                    end
                    
                    for j = 1 : max_iter
                        [Retard,RetardBAR]=CalculateRetardationFactors(Theta_LL,RHOKG1,Retard,RetardBAR,NL);
                        [Dsh, DIF2, DISP2,Dsh_h,Dsh_T,Dsh_A] = CalculateSoluteDispersion(DIF1111, nS, NL, Theta_LL, Theta_s, QL,QL_h,QL_T ,QL_A, DISP11, NN, DeltZ, R, Tr, TT, eT, Delt_t, Srt, Theta_L, lArtD, lUpW, RHOKG1, PeCr, Retard);
                        [Smin]=CalculateMineralizationorginal(TT,K31,Theta_LL,Theta_f,NL,Tr,R,eT,eTheta,RHOKG1,Smin,PH1,ePH);
                        [Svol]=CalculateAmmoniumVolatilization(TT,N,NL,PH1,KT,Svol,Tm,u_2,NN,NoTime);
                        [Snit,SVnit,Cvnit_N2o]=CalculateNitrificationorginal(TT,N,NL,Theta_LL,Theta_f,Theta_s,RHOKG1,K11,eT,eTheta,Snit,R,Tr,ePH,Cvnit_N2o,PH1,SVnit,KT,DeltZ);
                        [Sden,SVden,Cvdenit_N2o,Cvdenit_N2]=CalculateDenitrificationorginal(TT,K21,Theta_LL,Theta_s,Nno3,NL,eT,eTheta,Sden,R,Tr,Cvdenit_N2o,Cvdenit_N2,SVden,KT,DeltZ,Km1,KC1);
                        [Shys, Vpore, WFPS, DeltaUrea] = CalculateUreaHydrolysis(Kurea1, NL, Nurea, Vpore, WFPS, Theta_g, Theta_LL, Shys, Delt_t, TT);
                        run Evap_Cal_FAO.m
                        if lBNF == 1
                            [BNF]=CalculateBiologicalNfixation(DeltZ,NL);
                        else
                            BNF=0;
                        end

                        
                        run N_sub;
                        Nnurea  = Nurea  - DeltaUrea ;
                        Nnurea(Nnurea <= 1e-6) = 0;
                        % 在需要计算容差处调用
                        error_toleranceNno3 = calculate_error_tolerance(Nno3(1:NN), error_thresholds, error_tolerances);
                        error_toleranceNn = calculate_error_tolerance(Nn(1:NN), error_thresholds, error_tolerances);
 
                        if all(CHK3 < tolerance_factor*error_toleranceNno3) && ...
                                all(CHK2 < tolerance_factor*error_toleranceNn)
                            cvnh4(KT) = 0;
                            cvno3(KT) = 0;
                            for ML = 1 : NL
                                cvnh4(KT) =   cvnh4(KT) + DeltZ(ML) * ((Theta_LL(ML,1)+RHOKG1(ML))*Nn(ML)+(Theta_LL(ML,2)+RHOKG1(ML))*Nn(ML+1))/2;
                            end
                            for ML = 1 : NL
                                cvno3(KT) =   cvno3(KT) + DeltZ(ML) * (Theta_LL(ML,1)*Nno3(ML)+Theta_LL(ML,2)*Nno3(ML+1))/2;
                            end
                            Massbalance_absolute_error_nh4(KT) = (cvnh4(KT) - cvnh4OLD(KT))/Delt_t - (cvTop(KT) + cvBot(KT) - cvSnit(KT) + cvSmin(KT) - cvSinkS(KT) - cvSvol(KT) -Cvnit_N2o(KT));
                            Massbalance_relative_error_nh4(KT) = 100*abs(Massbalance_absolute_error_nh4(KT)) / max(abs((cvnh4(KT) - cvnh4OLD(KT)))/Delt_t, abs(cvTop(KT))+abs(cvBot(KT))+abs(cvSnit(KT))+abs(cvSmin(KT))+abs(cvSinkS1(KT))+abs(cvSvol(KT))+abs(Cvnit_N2o(KT)));
                            Massbalance_absolute_error_no3(KT) = (cvno3(KT) - cvno3OLD(KT))/Delt_t  - (cvTop1(KT) + cvBot1(KT) - cvSinkS1(KT)- cvSden(KT) + cvSnit(KT));
                            Massbalance_relative_error_no3(KT) = 100*abs(Massbalance_absolute_error_no3(KT)) / max(abs((cvno3(KT) - cvno3OLD(KT))/Delt_t),(abs(cvTop1(KT))+abs(cvBot1(KT))+abs(cvSinkS1(KT)))+abs(cvSden(KT))+abs(cvSnit(KT)));
                            break       
                        end
                    end
                    NITTT(KT,1)=j; % 迭代次数
                end
                break
            end

            hSAVE=hh(NN);
            TSAVE=TT(NN);
            if Nefc == 1
                NSAVE=Nn(NN);
                NSAVE2=Nno3(NN);
            end

        end
        
        % End the iteration procedure in a time step.
        if KIT == 100
            fprintf('未能在规定的迭代次数内收敛，KT的值为: %d\n', KT);
        end  
        NITT(KT,1)=KIT;
        TIMEOLD=KT;
        [hh,COR,CORh,Theta_V,Theta_g,Se,KL_h,Theta_LL,DTheta_LLh]=SOIL2(hh,COR,CORh,hThmrl,NN,NL,TT,Tr,Hystrs,XWRE,Theta_s,IH,KIT,Theta_r,Alpha,n,m,Ks,Theta_L,h,Thmrlefc,POR);
        [KT,TIME,Delt_t,tS,NBChh,IRPT1,IRPT2,Delt_old, hh, TT, P_gg, Nn, Nno3, Nnurea, Nurea]=TimestepCHK(NBCh,BCh,NBChh,DSTOR,DSTOR0,EXCESS,QMT,Precip,EVAP,hh,IRPT1,NN,TT,T,h, P_gg, P_g, Nn, N, Nno3, No3, Nnurea, Nurea, xERR, hERR, TERR, PERR, Theta_LL,Theta_L,KT,TIME,Delt_t,NL,Thmrlefc, Soilairefc, Nefc, NBChB,NBCT,NBCTB,tS, KIT, NIT);
        
        KIT=0;
       
 
       
       % Output : post-process 
         if IRPT1==0 && IRPT2==0
            if KT        % In case last time step is not convergent and needs to be repeated.
                Theta_LLl(NN) = Theta_LL(NL,2);
                for ML = 1 : NL
                    Theta_LLl(ML) = Theta_LL(ML,1);
                end
                for ML=1:NL
                    for ND=1:2  
                        MN = ML + ND - 1;
                        Theta_LLL(MN,KT)=Theta_LLl(MN);
                        Theta_L(ML,ND)=Theta_LL(ML,ND);
                        if Nefc == 1
                            Vporee(ML,ND,KT)=Vpore(ML,ND);
                        end
                    end
                end
               
                
                % replace run ObservationPoints, see issue 101
                % Soil state monitoring
                Sim_output.SoilMoisture(KT, 1:length(monitorDepthSoilMoisture)) = Theta_LLL(monitorDepthSoilMoisture, KT);
                % Plant water uptake 2025/6/4
                Sim_output.WaterUptake(1:NL,KT) = ((Srt(NL:-1:1,1) + Srt(NL:-1:1,2))/2) .* Delt_t * 10;
                % Sim_output.WaterUptakeTopdepth(KT, 1) = Trap(KT) ;
                % Temperature module outputs
                if Thmrlefc == 1
                    Sim_output.SoilTemperature(KT, 1:length(monitorDepthTemperature)) = TTT(monitorDepthTemperature, KT);
                    Sim_output.SurfaceTemperature(KT) = Tsh (KT);
                    Sim_output.BottomTemperature(KT) = Tbh (KT);
                    Sim_output.SurfaceHeatFlux(KT,1) = QET(KT);
                    Sim_output.BottomHeatFlux(KT,1) = QEB(KT);
                end

                % Gas pressure output
                if Soilairefc == 1
                    Sim_output.AirPressure(KT, 1:length(monitorDepthPressure)) = P_ggg(monitorDepthPressure, KT)/10000;
                end

                % Hydrological processes
                Sim_output.Evaporation(KT,1) = EVAP(KT);
                % Sim_output.ActualET(KT,1) = ETa(KT)*10;
                % Sim_output.CropCoefficient(KT,1) = Kc(KT);
                Sim_output.LeafAreaIndex(KT) = LAI(KT);
                if  NoTime(KT) <= 0
                    Sim_output.VaporPressureDeficit(KT,1) = VPD(1);
                else
                    Sim_output.VaporPressureDeficit(KT,1) = VPD(NoTime(KT) );
                end
                Sim_output.Transpiration(KT,1) = Tp_t(KT);

                % Precipitation-runoff processes
                if rwuef==1
                    Sim_output.Throughfall(KT,1) = Throughfall(KT);
                end
                Sim_output.Precipitation(KT,1) = Precip(KT);
                Sim_output.InfiltrationPotential(KT,1) = Infiltration(KT);
                Sim_output.ActualInfiltration(KT,1) = Infiltration_act(KT);

                % Resistance parameters
                % Sim_output.AerodynamicResistance(KT,1) = Resis_a(KT);
                % Sim_output.SoilResistance(KT,1) = r_s_SOIL(KT);
                % Sim_output.VegetationResistance(KT,1)= r_s_VEG(KT);
                % Sim_output.VegAeroResistance(KT,1) = r_a_VEG(KT);

                % Canopy processes
                Sim_output.SoilCoverFraction(KT,1) = Scf(KT);
                %Sim_output.CanopyInterception(KT,1) = CanopyInterception(KT);

                % Boundary fluxes
                Sim_output.TopBoundaryFlux(KT,1) = TopFlux_potential(KT);
                Sim_output.InfiltrationRate(KT,1) = VInfil(KT);
                Sim_output.SurfaceRunoff(KT,1) = RS(KT);
                Sim_output.TopMassFlux(KT,1) = QMT(KT);
                Sim_output.BottomMassFlux(KT,1) = QMB(KT);

                % Nitrogen cycle module
                if Nefc == 1
                    % Concentration fields
                    Sim_output.AmmoniumConc(KT, 1:length(monitorDepthNitrogen)) = NNN(monitorDepthNitrogen, KT);
                    Sim_output.NitrateConc(KT, 1:length(monitorDepthNitrogen)) =  NNno3(monitorDepthNitrogen, KT);
                    Sim_output.UreaConc(KT, 1:length(monitorDepthNitrogen)) =  NNurea(monitorDepthNitrogen, KT);     
                    if Ntotal == 1
                        Sim_output.AmmoniumTotalConc(KT, 1:length(monitorDepthNitrogen)) = NNN_TOTAL(monitorDepthNitrogen, KT)./RHO_bb(monitorDepthNitrogen);
                        Sim_output.NitrateTotalConc(KT, 1:length(monitorDepthNitrogen)) = NNno3_TOTAL(monitorDepthNitrogen, KT)./RHO_bb(monitorDepthNitrogen);
                    end

                    % Nitrogen boundary fluxes
                    Sim_output.CumulativeBottomAmmonium(KT,1) = cvBot(KT);
                    Sim_output.CumulativeTopAmmonium(KT,1) = cvTop(KT);
                    Sim_output.CumulativeBottomNitrate(KT,1) = cvBot1(KT);
                    Sim_output.CumulativeTopNitrate(KT,1) = cvTop1(KT);

                    % Concentration gradients
                    Sim_output.AmmoniumGradient(1:NL,KT) = DNH4DZ(NL:-1:1);
                    Sim_output.NitrateGradient(1:NL,KT) = DNO3DZ(NL:-1:1);

                    % Process accumulations
                    Sim_output.Nitrification(KT,1)=cvSnit(KT);
                    Sim_output.Mineralization(KT,1)=cvSmin(KT);
                    Sim_output.Denitrification(KT,1)=cvSden(KT);

                    % Nitrogen uptake
                    Sim_output.AmmoniumUptake(KT,1) = cvSinkS(KT);
                    Sim_output.NitrateUptake(KT,1) = cvSinkS1(KT);
                    total_uptake = cvSinkS(KT) + cvSinkS1(KT);
                    Sim_output.TotalNitrogenUptake(KT,1) = total_uptake;
                    if total_uptake > 0
                        Sim_output.AmmoniumFraction(KT,1) = cvSinkS(KT) / total_uptake;
                        Sim_output.NitrateFraction(KT,1) = cvSinkS1(KT) / total_uptake;
                    end

                    % Greenhouse gas emissions
                    Sim_output.N2O_Nitrification(KT,1)=Cvnit_N2o(KT);
                    Sim_output.N2O_Denitrification(KT,1)=Cvdenit_N2o(KT);
                    Sim_output.N2_Denitrification(KT,1)=Cvdenit_N2(KT);

                    % Transport characteristics
                    Sim_output.AmmoniumPeclet(1:NL,KT) = Peclet1(NL:-1:1);
                    Sim_output.AmmoniumPeclet(1:NL,KT) = Peclet2(NL:-1:1);
                end
            end
            %%%%%%%%%%%%%%%%%%%Flux acquisition%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if KT > 0
                % Liquid water fluxes
                flux_vars.QLiquid(1:NL,KT)    = QL(NL:-1:1);
                flux_vars.QLiquid_h(1:NL,KT)  = QL_h(NL:-1:1);
                flux_vars.QLiquid_T(1:NL,KT)  = QL_T(NL:-1:1);
                flux_vars.QLiquid_A(1:NL,KT)  = QL_A(NL:-1:1);

                % Water vapor fluxes
                flux_vars.QVapor(1:NL,KT)     = QV(NL:-1:1);
                flux_vars.QVapor_h(1:NL,KT)   = QV_h(NL:-1:1);
                flux_vars.QVapor_T(1:NL,KT)   = QV_T(NL:-1:1);
                flux_vars.QVapor_A(1:NL,KT)   = QVA(NL:-1:1);

                % Air flux conditional output
                if Soilairefc == 1
                    flux_vars.QAir(1:NL,KT)   = Qa(NL:-1:1);
                end
                if Thmrlefc == 1  %2025/6/4加入
                    flux_vars.QG(1:NL,KT)   = G(NL:-1:1);
                end

                % Gradient-related quantities
                flux_vars.GradPg(1:NL,KT)     = DPgDZ(NL:-1:1);
                flux_vars.Grad_h(1:NL,KT)     = DhDZ(NL:-1:1);
                flux_vars.Grad_T(1:NL,KT)     = DTDZ(NL:-1:1);

                % Average conductivity coefficients
                flux_vars.CondHydraulicAvg(1:NL,KT) = KLhBAR(NL:-1:1);
                flux_vars.CondThermalAvg(1:NL,KT)   = KLTBAR(NL:-1:1);
                flux_vars.CondVaporAvg(1:NL,KT)     = DTDBAR(NL:-1:1);

                % Saturation states
                flux_vars.SatWater(1:NL,KT)   = Se(NL:-1:1,1);
                flux_vars.SatAir(1:NL,KT)     = Sa(NL:-1:1,1);

                if Nefc==1
                    % Nitrogen flux variables
                    flux_vars.QNH44(1:NL,KT) = QNH4(NL:-1:1);
                    flux_vars.QNO33(1:NL,KT) = QNO3(NL:-1:1);

                    % Ammonium flux components
                    flux_vars.QNH4_h(1:NL,KT) = QNH4_h(NL:-1:1);
                    flux_vars.QNH4_T(1:NL,KT) = QNH4_T(NL:-1:1);
                    flux_vars.QNH4_A(1:NL,KT) = QNH4_A(NL:-1:1);
                    flux_vars.QNH4_conv(1:NL,KT) = QNH4_convection(NL:-1:1);
                    flux_vars.QNH4_conv_h(1:NL,KT) = QNH4_convection_h(NL:-1:1);
                    flux_vars.QNH4_conv_T(1:NL,KT) = QNH4_convection_T(NL:-1:1);
                    flux_vars.QNH4_conv_A(1:NL,KT) = QNH4_convection_A(NL:-1:1);
                    flux_vars.QNH4_disp(1:NL,KT) = QNH4_dispersion(NL:-1:1);
                    flux_vars.QNH4_disp_h(1:NL,KT) = QNH4_dispersion_h(NL:-1:1);
                    flux_vars.QNH4_disp_T(1:NL,KT) = QNH4_dispersion_T(NL:-1:1);
                    flux_vars.QNH4_disp_A(1:NL,KT) = QNH4_dispersion_A(NL:-1:1);

                    % Nitrate flux components
                    flux_vars.QNO3_h(1:NL,KT) = QNO3_h(NL:-1:1);
                    flux_vars.QNO3_T(1:NL,KT) = QNO3_T(NL:-1:1);
                    flux_vars.QNO3_A(1:NL,KT) = QNO3_A(NL:-1:1);
                    flux_vars.QNO3_conv(1:NL,KT) = QNO3_convection(NL:-1:1);
                    flux_vars.QNO3_conv_h(1:NL,KT) = QNO3_convection_h(NL:-1:1);
                    flux_vars.QNO3_conv_T(1:NL,KT) = QNO3_convection_T(NL:-1:1);
                    flux_vars.QNO3_conv_A(1:NL,KT) = QNO3_convection_A(NL:-1:1);
                    flux_vars.QNO3_disp(1:NL,KT) = QNO3_dispersion(NL:-1:1);
                    flux_vars.QNO3_disp_h(1:NL,KT) = QNO3_dispersion_h(NL:-1:1);
                    flux_vars.QNO3_disp_T(1:NL,KT) = QNO3_dispersion_T(NL:-1:1);
                    flux_vars.QNO3_disp_A(1:NL,KT) = QNO3_dispersion_A(NL:-1:1);
                end
            end
            if (TEND-TIME)<1E-3
                 %溶解态浓度转总浓度
                 if Ntotal == 1
                     for ML=1:NL
                        for ND=1:2
                            MN = ML + ND - 1;
                            NNN_TOTAL(MN,KT+1)=Nn(MN)*(Theta_LL(ML,ND)+RHOKG1(ML));
                            NNno3_TOTAL(MN,KT+1)=Nno3(MN)*(Theta_LL(ML,ND));
                        end
                    end
                 end
                for MN=1:NN
                    hOLD(MN)=h(MN);
                    h(MN)=hh(MN);
                    hhh(MN,KT+1)=hh(MN);
                    if Thmrlefc==1
                        TOLD(MN)=T(MN);
                        T(MN)=TT(MN);
                        TTT(MN,KT+1)=TT(MN);
                    end
                    if Soilairefc==1
                        P_gOLD(MN)=P_g(MN);
                        P_g(MN)=P_gg(MN);
                        P_ggg(MN,KT+1)=P_gg(MN);
                    end
                    if Nefc==1
                        NOLD(MN)=N(MN);     % NH4+
                        N(MN)=Nn(MN);
                        NNN(MN,KT+1)=Nn(MN);
                        No3OLD(MN)=No3(MN); % NO3-
                        No3(MN)=Nno3(MN);
                        NNno3(MN,KT+1)=Nno3(MN);
                    end
                end
                 if Thmrlefc == 1
                    Sim_output.SoilTemperature(KT+1, 1:length(monitorDepthTemperature)) = TTT(monitorDepthTemperature, KT+1);
                end
                if Soilairefc == 1
                    Sim_output.AirPressure(KT+1, 1:length(monitorDepthPressure)) = P_ggg(monitorDepthTemperature, KT+1)/10000;%Mpa
                end
                 if Nefc == 1
                     Sim_output.AmmoniumConc(KT+1, 1:length(monitorDepthNitrogen)) = NNN(monitorDepthNitrogen, KT+1);
                     Sim_output.NitrateConc(KT+1, 1:length(monitorDepthNitrogen)) = NNno3(monitorDepthNitrogen, KT+1);
                     if Ntotal == 1
                         Sim_output.AmmoniumTotalConc(KT+1, 1:length(monitorDepthNitrogen)) = NNN_TOTAL(monitorDepthNitrogen, KT+1)./RHO_bb(monitorDepthNitrogen);
                         Sim_output.NitrateTotalConc(KT+1, 1:length(monitorDepthNitrogen)) = NNno3_TOTAL(monitorDepthNitrogen, KT+1)./RHO_bb(monitorDepthNitrogen);
                     end
                 end
                break
            end
       end
    end
    
    % 定义上一级目录的文件夹路径
    outputFolder = fullfile('..', 'DataOutput');

    % 检查文件夹是否存在，如果不存在则创建
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    %% 3.保存 Sim_output 结构体为 CSV 文件
    fieldNames = fieldnames(Sim_output);  % 获取 Sim_output 中的所有字段名

    % 遍历 Sim_output 中的每个字段
    for i = 1:numel(fieldNames)
        data = Sim_output.(fieldNames{i});  % 获取当前字段的数据
        [nRows, nCols] = size(data);  % 获取数据的行数和列数

        % 创建包含行列号的矩阵
        dataWithIndex = [[NaN, 1:nCols]; (1:nRows)', data];  % 第一行和第一列是索引

        % 定义文件名并保存到上一级 DataOutput 文件夹
        fileName = fullfile(outputFolder, sprintf('Sim_output_%s.csv', fieldNames{i}));

        % 写入 CSV 文件
        writematrix(dataWithIndex, fileName);
    end

    %% 4.保存 flux_vars 结构体为 CSV 文件
    fieldNames = fieldnames(flux_vars);  % 获取 flux_vars 中的所有字段名

    % 遍历 flux_vars 中的每个字段
    for i = 1:numel(fieldNames)
        data = flux_vars.(fieldNames{i});  % 获取当前字段的数据
        [nRows, nCols] = size(data);  % 获取数据的行数和列数

        % 创建包含行列号的矩阵
        dataWithIndex = [[NaN, 1:nCols]; (1:nRows)', data];  % 第一行和第一列是索引

        % 定义文件名并保存到上一级 DataOutput 文件夹
        fileName = fullfile(outputFolder, sprintf('flux_vars_%s.csv', fieldNames{i}));

        % 写入 CSV 文件
        writematrix(dataWithIndex, fileName);
    end
    Computational_Time =toc;
    
    % run PlotResults.m
    % run PlotResults.m
    run output.m

    dailyResults = calculateDailyWeightedAverages(current_date, Sim_output);
    outputMatrices = extractDataToMatrices(dailyResults);

    % Define output path
    outputFolder = fullfile('..', 'DataOutput');
    
    % Ensure output directory exists
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
        fprintf('Created output directory: %s\n', outputFolder);
    end
    
    % Get all field names from outputMatrices
    fields = fieldnames(outputMatrices);
    
    % Process each field and save as CSV
    for i = 1:length(fields)
        fieldName = fields{i};
        fieldData = outputMatrices.(fieldName);
    
        % Construct output filename (without 'D' prefix)
        outputFile = fullfile(outputFolder, [fieldName '.csv']);
    
        % Handle different data types appropriately
        if isdatetime(fieldData)
            % Process datetime data
            writematrix(string(fieldData), outputFile);
            fprintf('Saved datetime field %s to %s\n', fieldName, outputFile);
    
        elseif istable(fieldData)
            % Process table data
            writetable(fieldData, outputFile);
            fprintf('Saved table field %s to %s\n', fieldName, outputFile);
    
        elseif isnumeric(fieldData) || iscell(fieldData)
            % Process numeric data or cell arrays
            writematrix(fieldData, outputFile);
            fprintf('Saved numeric field %s to %s\n', fieldName, outputFile);
    
        else
            % Handle other data types
            warning('Field %s with type %s may require special handling', fieldName, class(fieldData));
            try
                writematrix(fieldData, outputFile);
                fprintf('Saved field %s to %s\n', fieldName, outputFile);
            catch
                fprintf('Failed to save field %s - data type not supported for CSV export\n', fieldName);
            end
        end
    end
    
    fprintf('All fields exported successfully! Output directory: %s\n', outputFolder);
    
    disp('COMPUTATIONAL TIME [s] ')
    disp(Computational_Time)
    


% targetDates = datetime({'2023-04-18','2023-06-18','2023-08-18','2023-10-18'}); 
% results = struct('Date', {}, 'WeightedAvg', {}, 'Rowwater', {}, 'Rowno3', {});
% 
% % 循环处理每个日期
% for i = 1:length(targetDates)
%     targetDate = targetDates(i);
%     startTarget = targetDate;
%     endTarget = targetDate + days(1);
% 
%     mask = (current_date >= startTarget) & (current_date < endTarget);
%     dailyData = current_date(:,mask);
%     originalIndices = find(mask);
%     dd = originalIndices;
%     run texthaungdi.m
%     dailyData = sortrows(dailyData);
%     timeDiffs = seconds(diff(dailyData));
%     weights = zeros(1,length(dailyData));
%     weights(1) = timeDiffs(1) / 2;
%     weights(end) = timeDiffs(end) / 2;
%     weights(2:end-1) = (timeDiffs(1:end-1) + timeDiffs(2:end)) / 2;
%     weightedAvg = (aa .* (weights ./ sum(weights))) ;
%     weighted = (aano3 .* (weights ./ sum(weights))) ;
%     row_water = sum(weightedAvg, 2);
%     row_no3 = sum(weighted, 2);
% 
%     results(i).Date = targetDate;
%     results(i).WeightedAvg = weightedAvg;
%     results(i).Rowwater = row_water;
%     results(i).Rowno3 = row_no3;
% end
    % GenerateNitrateVideo(fullfile(pwd, 'soil_water_dynamics.avi'),outputMatrices.DSoilMoisture,current_date,SUMDELTZ);
    % GenerateNitrateVideo(fullfile(pwd, 'soil_ammonium_dynamics.avi'),outputMatrices.DAmmoniumConc,current_date,SUMDELTZ);
     io.GenerateSoilAmmonNitrateVideoWithRainfall(fullfile(pwd, 'soil_nitrate_with_rainfall.avi'), outputMatrices.DNitrateConc, outputMatrices.DAmmoniumConc, P, outputMatrices.DDates, SUMDELTZ);
    io.GenerateSoilMultiParameterVideo(fullfile(pwd, 'soil_water_with_rainfall.avi'), outputMatrices.DSoilMoisture, outputMatrices.DSoilTemp, outputMatrices.DAirPressure, P, outputMatrices.DDates, SUMDELTZ);
    io.GenerateSoilNitrateAndWaterParameterVideo(fullfile(pwd, 'soil_NitrateAndWater_with_rainfall.avi'), outputMatrices.DSoilMoisture,  outputMatrices.DNitrateConc, outputMatrices.DAmmoniumConc, P, outputMatrices.DDates, SUMDELTZ);