function [G,CTh,CTT,CTa,KTh,KTT,KTa,VTT,VTh,VTa,CTg,QL,QV,QVV,Qa,QV_h,QV_T,QVA,KLhBAR,KLTBAR,DTDBAR,DhDZ,DTDZ,DPgDZ,Beta_g,DEhBAR,DETBAR,RHOVBAR,EtaBAR]=EnrgyPARM(NL,hh,TT,DeltZ,P_gg,Kaa,Vvh,VvT,Vaa,c_a,c_L,DTheta_LLh,RHOV,Hc,RHODA,DRHODAz,L,WW,RHOL,Theta_V,DRHOVh,DRHOVT,KL_h,D_Ta,KL_T,D_V,D_Vg,DVa_Switch,Theta_g,QL, ...
          V_A,Lambda_eff,c_unsat,Eta,Xah,XaT,Xaa,DTheta_LLT,Soilairefc,Khh,KhT, ...
          Kha,KLhBAR,KLTBAR,DTDBAR,DhDZ,DTDZ,DPgDZ,Beta_g,DEhBAR,DETBAR,DRHOVhDz,DRHOVTDz,QV,Qa,QV_h,QV_T,QVA,RHOVBAR,EtaBAR, ...
          Kcva,Kcah,KcaT,Kcaa,Ccah,CcaT,Ccaa,CTh,CTT,CTa,KTh,KTT,KTa,VTh,VTT,VTa,CTg,NN)
%calculate all the parameters related to energy balance equation 

for ML=1:NL
    if ~Soilairefc
        KLhBAR(ML)=(KL_h(ML,1)+KL_h(ML,2))/2;
        KLTBAR(ML)=(KL_T(ML,1)+KL_T(ML,2))/2;
        DETBAR(ML)=(D_V(ML,1)*Eta(ML,1)+D_V(ML,2)*Eta(ML,2))/2;
        DhDZ(ML)=(hh(ML+1)-hh(ML))/DeltZ(ML);
        DTDZ(ML)=(TT(ML+1)-TT(ML))/DeltZ(ML);    
        DPgDZ(ML)=(P_gg(ML+1)-P_gg(ML))/DeltZ(ML);
    end
    DTDBAR(ML)=(D_Ta(ML,1)+D_Ta(ML,2))/2;
    DEhBAR(ML)=(D_V(ML,1)+D_V(ML,2))/2;
    DRHOVhDz(ML)=(DRHOVh(ML+1)+DRHOVh(ML))/2;
    DRHOVTDz(ML)=(DRHOVT(ML+1)+DRHOVT(ML))/2;
    RHOVBAR(ML)=(RHOV(ML+1)+RHOV(ML))/2;
    EtaBAR(ML)=(Eta(ML,1)+Eta(ML,2))/2;
end

%%%%%% NOTE: The soil air gas in soil-pore is considered with Xah and XaT terms.(0.0003,volumetric heat capacity)%%%%%% 
for ML=1:NL
    for ND=1:2
        MN=ML+ND-1;
        if ~Soilairefc
            QL(ML)=-(KLhBAR(ML)*DhDZ(ML)+(KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML)+KLhBAR(ML));  
            Qa(ML)=0;
        else            
            Qa(ML)=-((DEhBAR(ML)+D_Vg(ML))*DRHODAz(ML)-RHODA(ML)*(V_A(ML)+Hc*QL(ML)/RHOL));
        end
           
        if DVa_Switch==1
            QV(ML)=-(DEhBAR(ML)+D_Vg(ML))*DRHOVhDz(ML)*DhDZ(ML)-(DEhBAR(ML)*EtaBAR(ML)+D_Vg(ML))*DRHOVTDz(ML)*DTDZ(ML)+RHOVBAR(ML)*V_A(ML);
            QV_h(ML)=-(DEhBAR(ML)+D_Vg(ML))*DRHOVhDz(ML)*DhDZ(ML);
            QV_T(ML)=-(DEhBAR(ML)*EtaBAR(ML)+D_Vg(ML))*DRHOVTDz(ML)*DTDZ(ML);
            QVA(ML)=RHOVBAR(ML)*V_A(ML);
        else
            QV(ML)=-(DEhBAR(ML)+D_Vg(ML))*DRHOVhDz(ML)*DhDZ(ML)-(DEhBAR(ML)*EtaBAR(ML)+D_Vg(ML))*DRHOVTDz(ML)*DTDZ(ML);
            QV_h(ML)=-(DEhBAR(ML)+D_Vg(ML))*DRHOVhDz(ML)*DhDZ(ML);
            QV_T(ML)=-(DEhBAR(ML)*EtaBAR(ML)+D_Vg(ML))*DRHOVTDz(ML)*DTDZ(ML);
        end
    end
end

for ML=1:NL
    for ND=1:2
        MN=ML+ND-1;
        G(MN) = - Lambda_eff(ML,ND)*DTDZ(ML) + (QL(ML) * c_L + Qa(ML)  * c_a) * (TT(MN) - 20) + QV(ML) * (c_L *  (TT(MN) - 20) + L(MN));
    end
end

         % 变成节点量2025-3-18-朱寄子星
        QVV = convert_element_to_node(QV, NL, NN, DeltZ);
        V_AA = convert_element_to_node(V_A, NL, NN, DeltZ);
        QLL = convert_element_to_node(QL, NL, NN, DeltZ);
        Qaa = convert_element_to_node(Qa, NL, NN, DeltZ);
        D_Vgg = convert_element_to_node(D_Vg, NL, NN, DeltZ);
for ML=1:NL
    for ND=1:2
        MN=ML+ND-1;        
        if Soilairefc==1
            Kcah(ML,ND)=c_a*TT(MN)*((D_V(ML,ND)+D_Vgg(MN))*Xah(MN)+Hc*RHODA(MN)*KL_h(ML,ND));
            KcaT(ML,ND)=c_a*TT(MN)*((D_V(ML,ND)+D_Vgg(MN))*XaT(MN)+Hc*RHODA(MN)*(KL_T(ML,ND)+D_Ta(ML,ND))); %
            Kcaa(ML,ND)=c_a*TT(MN)*Kaa(ML,ND); % Kaa=((D_V(ML,ND)+D_Vg(ML))*Xaa(MN)+RHODA(MN)*(Beta_g(ML,ND)+Hc*KL_h(ML,ND)/Gamma_w)); %
            if DVa_Switch==1
                Kcva(ML,ND)=L(MN)*RHOV(MN)*Beta_g(ML,ND);  % (c_V*TT(MN)+L(MN))--->(c_L*TT(MN)+L(MN))
            else
                Kcva(ML,ND)=0;
            end
            Ccah(ML,ND)=c_a*TT(MN)*(-V_A(ML)-Hc*QLL(MN)/RHOL)*Xah(MN);
            CcaT(ML,ND)=c_a*TT(MN)*(-V_A(ML)-Hc*QLL(MN)/RHOL)*XaT(MN);
            Ccaa(ML,ND)=c_a*TT(MN)*Vaa(ML,ND); % Vaa=(-V_A(ML)-Hc*QL(ML)/RHOL)*Xaa(MN); %
        end
        %  Main coefficients for energy transport is here:
        CTh(ML,ND)=((c_L*TT(MN)-WW(ML,ND))*RHOL-(c_L*TT(MN)+L(MN))*RHOV(MN)-c_a*RHODA(MN)*TT(MN))*DTheta_LLh(ML,ND) ...
            +(c_L*TT(MN)+L(MN))*Theta_g(ML,ND)*DRHOVh(MN)+c_a*TT(MN)*Theta_g(ML,ND)*Xah(MN);          
        CTT(ML,ND)=c_unsat(ML,ND)+(c_L*TT(MN)+L(MN))*Theta_g(ML,ND)*DRHOVT(MN)+c_a*TT(MN)*Theta_g(ML,ND)*XaT(MN) ...
            +((c_L*TT(MN)-WW(ML,ND))*RHOL-(c_L*TT(MN)+L(MN))*RHOV(MN)-c_a*RHODA(MN)*TT(MN))*DTheta_LLT(ML,ND);             
        CTa(ML,ND)=TT(MN)*Theta_V(ML,ND)*c_a*Xaa(MN);                   % There is not this term in Milly's work.
        
        KTh(ML,ND)=L(MN)*(D_V(ML,ND)+D_Vg(ML))*DRHOVh(MN)+c_L*TT(MN)*RHOL*Khh(ML,ND)+Kcah(ML,ND); 
        KTT(ML,ND)=Lambda_eff(ML,ND)+c_L*TT(MN)*RHOL*KhT(ML,ND)+KcaT(ML,ND)+L(MN)*(D_V(ML,ND)*Eta(ML,ND)+D_Vg(ML))*DRHOVT(MN);  % Revised from: "Lambda_eff(ML,ND)+c_L*TT(MN)*RHOL*KhT(ML,ND);"
        KTa(ML,ND)=Kcva(ML,ND)+Kcaa(ML,ND)+c_L*TT(MN)*RHOL*Kha(ML,ND);  % There is not this term in Milly's work.
      
       

        if DVa_Switch==1
            VTh(ML,ND)=c_L*TT(MN)*RHOL*Vvh(ML,ND)+Ccah(ML,ND)-L(MN)*V_AA(MN)*DRHOVh(MN); 
            VTT(ML,ND)=c_L*TT(MN)*RHOL*VvT(ML,ND)+CcaT(ML,ND)-L(MN)*V_AA(MN)*DRHOVT(MN)-(c_L*(QLL(MN)+QVV(MN))+c_a*Qaa(MN)-2.369*QVV(MN)); 
        else
            VTh(ML,ND)=c_L*TT(MN)*RHOL*Vvh(ML,ND)+Ccah(ML,ND); 
            VTT(ML,ND)=c_L*TT(MN)*RHOL*VvT(ML,ND)+CcaT(ML,ND)-(c_L*(QLL(MN)+QVV(MN))+c_a*Qaa(MN)-2.369*QVV(MN)); 
        end
        
        VTa(ML,ND)=Ccaa(ML,ND); %c_a*TT(MN)*Vaa(ML,ND);
        
        CTg(ML,ND)=(c_L*RHOL+c_a*Hc*RHODA(MN))*KL_h(ML,ND)*TT(MN); % Revised from "c_L*T(MN)*KL_h(ML,ND)"
    end
end
