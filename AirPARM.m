function [Cah,CaT,Caa,Kah,KaT,Kaa,Vah,VaT,Vaa,Cag,QL,QL_h,QL_T,QL_A,KLhBAR,KLTBAR,DhDZ,DTDZ,DPgDZ,DTDBAR]=AirPARM(NL,NN,hh,TT,Theta_LL,DeltZ,DTheta_LLh,DTheta_LLT,POR,RHOL,V_A,KL_h,D_Ta, ...
    KL_T,D_V,D_Vg,P_gg,Beta_g,Gamma_w,KLa_Switch, ...
    Xah,XaT,Xaa,RHODA,Hc,DhDZ,DTDZ,DPgDZ,QL,QL_h,QL_T,QL_A, ...
    Cah,CaT,Caa,Kah,KaT,Kaa,Vah,VaT,Vaa,Cag)

    for ML=1:NL 
        DhDZ(ML)=(hh(ML+1)-hh(ML))/DeltZ(ML);
        DTDZ(ML)=(TT(ML+1)-TT(ML))/DeltZ(ML);
        DPgDZ(ML)=(P_gg(ML+1)-P_gg(ML))/DeltZ(ML);
    end
    KLhBAR = mean(KL_h,2);        % [NLx1]
    KLTBAR = mean(KL_T,2);        % [NLx1]
    DTDBAR = mean(D_Ta,2);         % [NLx1]
  
    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;

            if KLa_Switch==1
                QL(ML)=-(KLhBAR(ML)*(DhDZ(ML)+DPgDZ(ML)/Gamma_w)+(KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML)+KLhBAR(ML));
                QL_h(ML)=-(KLhBAR(ML)*(DhDZ(ML))+KLhBAR(ML));
                QL_T(ML)=-((KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML));
                QL_A(ML)=-(KLhBAR(ML)*(DPgDZ(ML)/Gamma_w));
            else
                QL(ML)=-(KLhBAR(ML)*DhDZ(ML)+(KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML)+KLhBAR(ML));
                QL_h(ML)=-(KLhBAR(ML)*DhDZ(ML)+KLhBAR(ML));
                QL_T(ML)=-((KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML));
            end
        end
    end

            % 变成节点量2025-3-18-朱寄子星
            D_Vgg = convert_element_to_node(D_Vg, NL, NN, DeltZ);
            V_AA = convert_element_to_node(V_A, NL, NN, DeltZ);
            QLL = convert_element_to_node(QL, NL, NN, DeltZ);
            for ML=1:NL
                J=ML;
                for ND=1:2
                    MN=ML+ND-1;
                    Cah(ML,ND)=Xah(MN)*(POR(J)+(Hc-1)*Theta_LL(ML,ND))+(Hc-1)*RHODA(MN)*DTheta_LLh(ML,ND);
                    CaT(ML,ND)=XaT(MN)*(POR(J)+(Hc-1)*Theta_LL(ML,ND))+(Hc-1)*RHODA(MN)*DTheta_LLT(ML,ND);
                    Caa(ML,ND)=Xaa(MN)*(POR(J)+(Hc-1)*Theta_LL(ML,ND));

                    Kah(ML,ND)=Xah(MN)*(D_V(ML,ND)+D_Vgg(MN))+Hc*RHODA(MN)*KL_h(ML,ND);
                    KaT(ML,ND)=XaT(MN)*(D_V(ML,ND)+D_Vgg(MN))+Hc*RHODA(MN)*(KL_T(ML,ND)+D_Ta(ML,ND));
                    Kaa(ML,ND)=Xaa(MN)*(D_V(ML,ND)+D_Vgg(MN))+RHODA(MN)*(Beta_g(ML,ND)+Hc*KL_h(ML,ND)/Gamma_w);%

                    Cag(ML,ND)=Hc*RHODA(MN)*KL_h(ML,ND);

                    Vah(ML,ND)=-(V_AA(MN)+Hc*QLL(MN)/RHOL)*Xah(MN); %0;%
                    VaT(ML,ND)=-(V_AA(MN)+Hc*QLL(MN)/RHOL)*XaT(MN); %0;%
                    Vaa(ML,ND)=-(V_AA(MN)+Hc*QLL(MN)/RHOL)*Xaa(MN); %0;%
                end
            end
end

