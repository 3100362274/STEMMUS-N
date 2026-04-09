%% function MainLoop
clc;
clear;
close all;
run Constants               %input soil parameters
if Evaptranp_Cal==1
    run EvapTransp_Cal;
end

%% 0.Globals
global i tS KT Delt_t TEND TIME MN NN NL ML ND hOLD TOLD h hh T TT P_gOLD P_g P_gg Delt_t0 
global KIT NIT NITT TimeStep Processing 
global SUMTIME hhh TTT P_ggg Theta_LLL DSTOR Thmrlefc CHK Theta_LL Theta_L
global NBCh AVAIL Evap DSTOR0 EXCESS QMT RS BCh hN hSAVE NBChh DSTMAX Soilairefc Trap sumTRAP_dir sumEVAP_dir
global TSAVE IRPT1 IRPT2 AVAIL0 TIMEOLD TIMELAST SRT ALPHA BX alpha_h bx Srt L
global QL QL_h QL_T QV Qa KL_h Chh ChT Khh KhT QV_h QV_T DhDZ DTDZ 
global cvSnit cvSmin cvSden cvSinkS cvSinkS1
global Nefc N Nn NNN  NOLD  NSAVE NSAVE2 js nS V_L 
global rBot cvBot cvTop NBCNB NBCN 
global D_Vg Theta_g Sa V_A k_g MU_a DeltZ Alpha_Lg
global J Beta_g KaT_Switch Theta_s
global D_V D_A fc Eta nD POR Se 
global ThmrlCondCap ZETA XK DVT_Switch 
global m g MU_W Ks RHOL
global Lambda1 Lambda2 Lambda3 c_unsat Lambda_eff RHO_bulk
global HCAP SF TCA GA1 GA2 GB1 GB2 HCD ZETA0 CON0 PS1 PS2 XWILT
global RHODA RHOV c_a c_V c_L
global ETCON EHCAP
global Xaa XaT Xah RDA Rv KL_T
global DRHOVT DRHOVh DRHODAt DRHODAz
global hThmrl Tr COR CORh IS Hystrs XWRE
global Theta_V DTheta_LLh IH 
global W WW D_Ta SSUR
global W_Chg 
global KLT_Switch Theta_r Alpha n CKTN trap Evapo SMC lEstot lEctot Ztot Rl 


%% 1.Initial state setting
run StartInit;   % Initialize Temperature, Matric potential and soil air pressure.

%% 2.Run the model
fprintf('\nThe calculations start now\n')
TIMEOLD=0;
TIMELAST=0;
for i=1:tS+1                          % Notice here: In this code, the 'i' is strictly used for timestep loop and the arraies index of meteorological forcing data.
    KT=KT+1                          % Counting Number of timesteps
    if KT>1 && Delt_t>(TEND-TIME)
        Delt_t=TEND-TIME;           % If Delt_t is changed due to excessive change of state variables, the judgement of the last time step is excuted.
    end
    TIME=TIME+Delt_t;               % The time elapsed since start of simulation
    TimeStep(KT,1)=Delt_t;
    SUMTIME(KT,1)=TIME;
    Processing=TIME/TEND
    
    %%%%%% Updating the state variables. %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     if TIME>=2250*3600 && TIME<=2252*3600    %7-13 9-10 p=52mm
    %         NBChh=1;
    %     elseif TIME>=728*3600 && TIME<=730*3600  %8-1 16-18 p=60mm
    %         NBChh=1;
    % %     elseif TIME>=1288*3600 && TIME<=1297*3600  %8-15 16-17 p=67mm
    % %         NBChh=1;
    % %     elseif TIME>=1862*3600 && TIME<=1870*3600  %9-8 14-18 p=93.11mm
    % %         NBChh=1;
    %     else
    NBChh=2;
    %     end
    if IRPT1==0 && IRPT2==0
        for MN=1:NN
            hOLD(MN)=h(MN);
            h(MN)=hh(MN);
            hhh(MN,KT)=hh(MN);
            KL_h(MN,KT)=KL_h(MN,2);
            Chh(MN,KT)=Chh(MN,2);
            ChT(MN,KT)=ChT(MN,2);
            Khh(MN,KT)=Khh(MN,2);
            KhT(MN,KT)=KhT(MN,2);

            if Thmrlefc==1
                TOLD(MN)=T(MN);
                T(MN)=TT(MN);
                TTT(MN,KT)=TT(MN);
            end
            if Soilairefc==1
                P_gOLD(MN)=P_g(MN);
                P_g(MN)=P_gg(MN);
                P_ggg(MN,KT)=P_gg(MN);
            end
            if Nefc==1
                for js=1:nS
                    NOLD(MN,1,js)=N(MN,1,js);
                    N(MN,1,js)=Nn(MN,1,js);
                    NNN(MN,KT,js)=Nn(MN,js);
                end
            end
            if rwuef==1
                SRT(MN,KT)=Srt(MN,1);
                ALPHA(MN,KT)=alpha_h(MN,1);
                BX(MN,KT)=bx(MN,1);
            end
        end
        DSTOR0=DSTOR;
        
        if KT>1
            run SOIL1
        end
    end

    if Delt_t~=Delt_t0
        for MN=1:NN
            hh(MN)=h(MN)+(h(MN)-hOLD(MN))*Delt_t/Delt_t0;
            TT(MN)=T(MN)+(T(MN)-TOLD(MN))*Delt_t/Delt_t0;
            for js=1:nS
            Nn(MN,js)=N(MN,js)+(N(MN,js)-NOLD(MN,js))*Delt_t/Delt_t0;
            end
        end
    end
    hSAVE=hh(NN);
    TSAVE=TT(NN);
    NSAVE=Nn(NN,1);
    NSAVE2=Nn(NN,2);
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
            hN=DSTOR0;
            hh(NN)=hN;
            hSAVE=hN;
        end
    end
    if NBCNB==2
        for js=1:nS
            if V_L(1)>=0
                cvBot(KT,js)=0*cBot(jS);
            end
            if V_L(1)<=0
                cvBot(KT,js)=0*Nn(1,js)*V_L(1);
            end
            if DVa_Switch==1 || DVT_Switch==1
                if rBot==0
                    cvBot(KT,js)=0;
                end
            end
        end
    elseif NBCNB==3
        for js=1:nS
            cvBot(KT,js)=0*Nn(1,js)*V_L(1);
        end
    end
    if NBCN==2 && KT~=1
        if V_L(NN)<=0
            cvTop(KT,js)=0*Nn(NN,js)*V_L(NN);
        end
    end

    run Forcing_PARM

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for KIT=1:NIT   % Start the iteration procedure in a time step.
        [hh,COR,CORh,J,Theta_V,Theta_g,Se,KL_h,Theta_LL,DTheta_LLh]=SOIL2(hh,COR,CORh,hThmrl,NN,NL,TT,Tr,Hystrs,XWRE,Theta_s,IH,KIT,Theta_r,Alpha,n,m,Ks,Theta_L,h,Thmrlefc,CKTN,POR,J);
        [KL_T]=CondL_T(NL);
        [RHOV,DRHOVh,DRHOVT]=Density_V(TT,hh,g,Rv,NN);
        [W,WW,MU_W,D_Ta]=CondL_Tdisp(POR,Theta_LL,Theta_L,SSUR,RHO_bulk,RHOL,TT,Theta_s,h,hh,W_Chg,NL,nD,Delt_t,Theta_g,KLT_Switch);
        [L]= Latent(TT,NN);
        [Xaa,XaT,Xah,DRHODAt,DRHODAz,RHODA]=Density_DA(T,RDA,P_g,Rv,DeltZ,h,hh,TT,P_gg,Delt_t,NL,NN,DRHOVT,DRHOVh,RHOV);
        [c_unsat,Lambda_eff,ZETA,ETCON,EHCAP]=CondT_coeff(Theta_LL,Lambda1,Lambda2,Lambda3,RHO_bulk,Theta_g,RHODA,RHOV,c_a,c_V,c_L,NL,nD,ThmrlCondCap, ...
        HCAP,SF,TCA,GA1,GA2,GB1,GB2,HCD,ZETA0,CON0,PS1,PS2,XWILT,XK,TT,POR,DRHOVT,L,D_A,Theta_V, ...
        c_unsat,Lambda_eff,ETCON,EHCAP,ZETA);
        run Condg_k_g;
        run CondV_DE;
        run CondV_DVg;

        run h_sub;

        if NBCh==1
            DSTOR=0;
            RS=0;
        elseif NBCh==2
            AVAIL=-BCh;
            EXCESS=(AVAIL+QMT(KT))*Delt_t;
            if abs(EXCESS/Delt_t)<=1e-10,EXCESS=0;end
            DSTOR=min(EXCESS,DSTMAX);
            RS=(EXCESS-DSTOR)/Delt_t;
        else
            AVAIL=AVAIL0-Evap(KT);
            EXCESS=(AVAIL+QMT(KT))*Delt_t;
            if abs(EXCESS/Delt_t)<=1e-10,EXCESS=0;end
            DSTOR=0;
            RS=0;
        end

        if Soilairefc==1
            run Air_sub;
        end

        if Thmrlefc==1
            run Enrgy_sub;
        end
        if Nefc==1
            run N_sub;
        end

        if max(CHK)<0.001
            break
        end
        hSAVE=hh(NN);
        TSAVE=TT(NN);
        NSAVE=Nn(NN,1);
        NSAVE2=Nn(NN,2);
    end
    NITT(KT)=KIT;
    TIMEOLD=KT;
    KIT
    KIT=0;
    run SOIL2;

      % run TimestepCHK

    if IRPT1==0 && IRPT2==0
        if KT        % In case last time step is not convergent and needs to be repeated.
            MN=0;
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    Theta_LLL(ML,ND,KT)=Theta_LL(ML,ND);
                    Theta_L(ML,ND)=Theta_LL(ML,ND);

                end
            end
            run ObservationPoints
        end
        if (TEND-TIME)<1E-3
            for MN=1:NN
                hOLD(MN)=h(MN);
                h(MN)=hh(MN);
                hhh(MN,KT)=hh(MN);
                if Thmrlefc==1
                    TOLD(MN)=T(MN);
                    T(MN)=TT(MN);
                    TTT(MN,KT)=TT(MN);
                end
                if Soilairefc==1
                    P_gOLD(MN)=P_g(MN);
                    P_g(MN)=P_gg(MN);
                    P_ggg(MN,KT)=P_gg(MN);
                end
                if Nefc==1
                    for js=1:nS
                        NOLD(MN,1,js)=N(MN,1,js);
                        N(MN,1,js)=Nn(MN,1,js);
                        NNN(MN,KT,js)=Nn(MN,js);
                    end
                end
            end
            break
        end
    end
    %%%%%%%%%%%%%%%%%%%通量获取%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for MN=1:NN
        QL(MN,KT)=QL(MN);
        QL_h(MN,KT)=QL_h(MN);
        QL_T(MN,KT)=QL_T(MN);
        Qa(MN,KT)=Qa(MN);
        QV(MN,KT)=QV(MN);
        QV_h(MN,KT)=QV_h(MN);
        QV_T(MN,KT)=QV_T(MN);
        DhDZ(MN,KT)=DhDZ(MN);
        DTDZ(MN,KT)=DTDZ(MN);
        cvSnit(MN,KT)=cvSnit(MN);
        cvSmin(MN,KT)=cvSmin(MN);
        cvSden(MN,KT)=cvSden(MN);
        cvSinkS(MN,KT)=cvSinkS(MN);
        cvSinkS1(MN,KT)=cvSinkS1(MN);
    end
end

% run PlotResults
%%%%%%%%%%%%%%%%%%%save the variables for ETind scenario%%%%%%%%%%%%
if Evaptranp_Cal==1  
    Sim_Theta_ind=Sim_Theta;
    Sim_Temp_ind=Sim_Temp;
    %TRAP=864000.*Trap;
    TRAP=Trap;
    TRAP_ind=TRAP';
    %EVAP=864000.*Evap;
    EVAP=Evap;
    EVAP_ind=EVAP';
    % disp ('Convergence Achieved for ETind scenario. Please switch to ETdir scenario and run again.')

else
    TRAP=Trap;
    TRAP_dir=TRAP';
    EVAP=Evap;
    EVAP_dir=EVAP';
%%%%%%%%%%%%%%%%%%%%%天计数%%%%%%%%%%%%%%%%%%%%%%
    for i=1:KT
           sumTRAP_ind(i)=0;
           sumEVAP_ind(i)=0;
           sumTRAP_dir(i)=0;
           sumEVAP_dir(i)=0;
           for j=1:i
               sumTRAP_ind(i)=TRAP_ind(j)+sumTRAP_ind(i);
               sumEVAP_ind(i)=EVAP_ind(j)+sumEVAP_ind(i);
               sumTRAP_dir(i)=TRAP_dir(j)+sumTRAP_dir(i);
               sumEVAP_dir(i)=EVAP_dir(j)+sumEVAP_dir(i);
           end
       end
 %%%%%%%%%%%%%%%%%%%%%%小时计数%%%%%%%%%%%%%%%%%%%   
    %      for i=1:KT/24
    %        sumTRAP_ind(i)=0;
    %        sumEVAP_ind(i)=0;
    %         sumTRAP_dir(i)=0;
    %         sumEVAP_dir(i)=0;
    %        for j=(i-1)*24+1:i*24
    %            sumTRAP_ind(i)=TRAP_ind(j)+sumTRAP_ind(i);
    %            sumEVAP_ind(i)=EVAP_ind(j)+sumEVAP_ind(i);
    %             sumTRAP_dir(i)=TRAP_dir(j)+sumTRAP_dir(i);
    %             sumEVAP_dir(i)=EVAP_dir(j)+sumEVAP_dir(i);
    %        end
    %    end
    run PlotResults1
end
