function Enrgy_sub
global TT Tb_msr MN NN Tbh
global NL hh DeltZ P_gg
global CTh CTT CTa KTh KTT KTa CTg Vvh VvT Vaa Kaa
global c_a c_L c_V RHOL DRHOVT DRHOVh RHOV Hc RHODA DRHODAz L WW 
global Theta_V Theta_g QL V_A 
global KL_h KL_T D_Ta Lambda_eff c_unsat D_V Eta D_Vg Xah XaT Xaa DTheta_LLT Soilairefc
global DTheta_LLh DVa_Switch
global Khh KhT Kha KLhBAR KLTBAR DTDBAR DhDZ DTDZ DPgDZ Beta_g DEhBAR DETBAR QV Qa QV_h QV_T QVA RHOVBAR EtaBAR
global C1 C2 C3 C4 C5 C6 C7 C4_a C5_a C6_a VTT VTh VTa DRHOVhDz DRHOVTDz
global Delt_t RHS T TOLD h P_g  Thmrlefc Kcva Kcah KcaT Kcaa Ccah CcaT Ccaa
global QMB SH Precip KT G NoTime
global NBCTB NBCT BCT DSTOR0 Ts Ta L_ts 
global EVAP Rn CHK QET QEB Resis_a SAVE


    if Ts(KT)<=0
        Ts(KT)=0.002;
    end

QL_nodes = convert_element_to_node(QL, NL, NN, DeltZ); % 转换为节点量
[G,CTh,CTT,CTa,KTh,KTT,KTa,VTT,VTh,VTa,CTg,QL,QV,QVV,Qa,QV_h,QV_T,QVA,KLhBAR,KLTBAR,DTDBAR,DhDZ,DTDZ,DPgDZ,Beta_g,DEhBAR,DETBAR,RHOVBAR,EtaBAR]=EnrgyPARM(NL,hh,TT,DeltZ,P_gg,Kaa,Vvh,VvT,Vaa,c_a,c_L,DTheta_LLh,RHOV,Hc,RHODA,DRHODAz,L,WW,RHOL,Theta_V,DRHOVh,DRHOVT,KL_h,D_Ta,KL_T,D_V,D_Vg,DVa_Switch,Theta_g,QL, ...
          V_A,Lambda_eff,c_unsat,Eta,Xah,XaT,Xaa,DTheta_LLT,Soilairefc,Khh,KhT, ...
          Kha,KLhBAR,KLTBAR,DTDBAR,DhDZ,DTDZ,DPgDZ,Beta_g,DEhBAR,DETBAR,DRHOVhDz,DRHOVTDz,QV,Qa,QV_h,QV_T,QVA,RHOVBAR,EtaBAR, ...
          Kcva,Kcah,KcaT,Kcaa,Ccah,CcaT,Ccaa,CTh,CTT,CTa,KTh,KTT,KTa,VTh,VTT,VTa,CTg,NN);
[C1,C2,C3,C4,C4_a,C5,C5_a,C6,C6_a,C7]=Enrgy_MAT(CTh,CTT,CTa,KTh,KTT,KTa,CTg,VTT,VTh,VTa,DeltZ,NL,NN,Soilairefc);
[RHS,C5,SAVE]=Enrgy_EQ(C1,C2,C3,C4,C4_a,C5,C6_a,C6,C7,NL,NN,Delt_t,T,h,hh,P_g,P_gg,Thmrlefc,Soilairefc,SAVE);
[RHS,C5,C5_a]=Enrgy_BC(RHS,KT,NN,c_L,RHOL,QMB,SH,Precip,L,L_ts,NBCTB,NBCT,BCT,Tbh,Tb_msr,DSTOR0,Delt_t,T,Ts,Ta,EVAP,Rn,C5,C5_a,c_a,Resis_a,QL_nodes,QVV,c_V);
[TT,CHK,RHS,C5]= Enrgy_Solve(C5,C5_a,TT,NN,NL,RHS);
[QET,QEB]=Enrgy_Bndry_Flux(SAVE,TT,NN,KT);


    if any(isnan(TT)) 
        for MN = 1:NN
            TT(MN) = TOLD(MN);
        end
    end
    for MN=1:NN
        if TT(MN)<=0
            TT(MN)=TOLD(MN);
        end
    end

