function Air_sub

global Cah CaT Caa Kah KaT Kaa Vah VaT Vaa Cag Xah XaT Xaa RHODA Hc
global POR D_V D_Ta D_Vg KL_T Gamma_w V_A RHOL
global QL Theta_LL hh TT DeltZ DTheta_LLT QL_h QL_T  QL_A
global NL DTheta_LLh P_gg Beta_g  
global KLhBAR KLTBAR DhDZ DTDZ DPgDZ DTDBAR  KLa_Switch 
global C1 C2 C3 C4 C5 C6 C7 C4_a C5_a C6_a NN KL_h
global Delt_t RHS T h P_g  Thmrlefc
global BtmPg TopPg KT SAVE
global NBCPB BCPB NBCP BCP  



[Cah,CaT,Caa,Kah,KaT,Kaa,Vah,VaT,Vaa,Cag,QL,QL_h,QL_T,QL_A,KLhBAR,KLTBAR,DhDZ,DTDZ,DPgDZ,DTDBAR]=AirPARM(NL,NN,hh,TT,Theta_LL,DeltZ,DTheta_LLh,DTheta_LLT,POR,RHOL,V_A,KL_h,D_Ta, ...
    KL_T,D_V,D_Vg,P_gg,Beta_g,Gamma_w,KLa_Switch, ...
    Xah,XaT,Xaa,RHODA,Hc,DhDZ,DTDZ,DPgDZ,QL,QL_h,QL_T,QL_A, ...
    Cah,CaT,Caa,Kah,KaT,Kaa,Vah,VaT,Vaa,Cag);
[C1,C2,C3,C4,C4_a,C5,C5_a,C6,C6_a,C7]=Air_MAT(Cah,CaT,Caa,Kah,KaT,Kaa,Vah,VaT,Vaa,Cag,DeltZ,NL,NN,C1,C2,C3,C4,C4_a,C5,C5_a,C6,C6_a,C7);
[RHS,C6,SAVE]=Air_EQ(C1,C2,C3,C4,C4_a,C5,C5_a,C6,C7,NL,NN,Delt_t,T,TT,h,hh,P_g,Thmrlefc,RHS,SAVE);
[RHS,C6,C6_a]=Air_BC(RHS,KT,NN,BtmPg,TopPg,NBCPB,BCPB,NBCP,BCP,C6,C6_a);
[C6,P_gg,RHS]=Air_Solve(C6,NN,NL,C6_a,RHS,P_gg);

for ML = 1 :NL
    for ND =1 : 2
        MN = ML + ND - 1;
        if isnan(P_gg(MN)) 
            P_gg(MN) = P_g(MN); 
        end
    end
end