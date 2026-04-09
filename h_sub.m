function h_sub
global hh MN NN
global C1 C2 C4 C3 C4_a C5 C6 C7 
global Chh ChT Khh KhT Kha Vvh VvT Chg DeltZ C5_a
global NL nD  
global Delt_t RHS T TT  h P_gg  Thmrlefc Soilairefc
global RHOL Gamma_w DTheta_LLh DTheta_LLT
global Theta_L Theta_LL Theta_V Eta V_A
global RHOV DRHOVh DRHOVT KL_h D_Ta KL_T D_V D_Vg 
global COR hThmrl Beta_g Gamma0 KLa_Switch DVa_Switch
global Precip CHKWATER CHK_RESWATER  CHK SAVEhh EVAP CanopyInterception fmax Tot_Depth Ks0 theta_s0 hOLD
global NBCh NBChB BCh BChB hN KT DSTOR0 NBChh hcrit  h_SUR AVAIL0 Throughfall Infiltration Infiltration_act
global QMT QMB SAVE TopFlux_potential hsaturation DSTMAX VInfil
global  Srt C9  % U_wind is the mean wind speed at height z_ref (m·s^-1), U is the wind speed at each time step.


my_eps = 1e-100; 
[Chh,ChT,Khh,KhT,Kha,Vvh,VvT,Chg,DTheta_LLh,DTheta_LLT]=hPARM(NL,hh,...
h,TT,T,Theta_LL,Theta_L,DTheta_LLh,DTheta_LLT,RHOV,RHOL,Theta_V,V_A,Eta,DRHOVh,...
DRHOVT,KL_h,D_Ta,KL_T,D_V,D_Vg,COR,Beta_g,Gamma0,Gamma_w,KLa_Switch,DVa_Switch,hThmrl,Thmrlefc,nD);
[C1,C2,C4,C3,C4_a,C5,C6,C7,C5_a,C9]=h_MAT(Chh,ChT,Khh,KhT,Kha,Vvh,VvT,Chg,DeltZ,NL,NN,Srt);
[RHS,C4,SAVE]=h_EQ(C1,C2,C4,C5,C6,C7,C5_a,C9,NL,NN,Delt_t,T,TT,h,P_gg,Thmrlefc,Soilairefc,SAVE);
[AVAIL0,RHS,C4,C4_a,Throughfall,Infiltration,Infiltration_act,TopFlux_potential]=h_BC(RHS,NBCh,NBChB,BCh,BChB, ...
    hN,KT,Delt_t,DSTOR0,NBChh,h_SUR,C4,KL_h,Khh,Throughfall,NN,AVAIL0,C4_a, ...
    EVAP,CanopyInterception,fmax,Tot_Depth,Ks0,theta_s0,Theta_LL,DeltZ);
[CHKWATER,CHK_RESWATER,hh,C4,SAVEhh]=hh_Solve(C4,hh,NN,NL,C4_a,RHS,my_eps); 
[QMT,QMB]=h_Bndry_Flux(SAVE,hh,NN,KT);
% 是否要加入超出上界限值 0
for ML = 1 :NL
    for ND =1 : 2
        MN = ML + ND - 1;
        if isnan(hh(MN)) || any(hh(1:NN)<=-1E12)
            hh(MN) = hOLD(MN); 
        end
        if hh(MN) >= -1e-6 
            hh(MN) = -1e-6 ;
        end
        if NBCh == 3 && hh(MN) < hcrit && MN == NN
            hh(MN)=hcrit;
        end
        if NBCh == 3 && hh(MN) < hcrit && MN > NN*9/10 && Srt(ML,ND) <= 0  %表层区域若无水源则限制水头
            hh(MN)=hcrit;
        end
        % if hh(MN) >= -1e-6 
        %     hh(MN) = -0.5 ;
        % end
        %2025-5-27 朱寄子星加入
        if DSTMAX 
            if hh(NN) > 0
                hh(MN)=0;
                NBChh = 1;
            end
        end
    end
end
 % 算入渗速率
 % 算入渗速率
 if QMT(KT) < 0 && (Infiltration(KT) > 0 || (DSTMAX && hh(Nn)> 0))
     VInfil(KT)=-QMT(KT)+EVAP(KT);
 else
      VInfil(KT) = 0;
 end
 if QMT(KT) < 0 && Infiltration(KT) > 0
     VInfil(KT)=Infiltration(KT);
 else
     VInfil(KT) = 0;
 end