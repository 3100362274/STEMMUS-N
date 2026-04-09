function [Sden,SVden,Cvdenit_N2o,Cvdenit_N2]=CalculateDenitrificationorginal(TT,K21,Theta_LL,Theta_s,No3,NL,eT,eTheta,Sden,R,Tr,Cvdenit_N2o,Cvdenit_N2,SVden,KT,DeltZ,Km1,KC1)
% Calculate the solute denitrification
    %EA 特定反应下的活化能 from：HARRIS R F. Energetics of Nitrogen Transformations[M]. Madison: American Society of Agronomy, 1982: 833-890.
    %应用文献提供的NO、NO2和N2O生成焓的均值近似表征反硝化作用的Ea值为68576.3 J/mol
    EA=68576.3;
    TD=zeros(NL+1,1);
    Sden_N2o = zeros(NL,2);
    Sden_N2 = zeros(NL,2);

    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;
            %Arrhenius FORMULA
            TD(MN)=(TT(MN)-Tr)/R/(TT(MN)+273.15)./(Tr+273.15);
            eT(MN)=exp(EA*TD(MN));
            % from ：Eckersten H, Jansson P E, Johnsson H. SOILN model user’s guide[M]//Version 9.1. Uppsala, Sweden:
            % Department of Soil Science, Swedish University of Agriculture Science, 1996.
            if Theta_LL(ML,ND)<=0.17
                eTheta(ML,ND)=0;
            else
                eTheta(ML,ND)=((Theta_LL(ML,ND)-0.17)./(Theta_s(J)-0.17)).^2;
            end
            
            % Michaelis-Menten
            % Sden(ML,ND) = Km1(J) * (Nno3(MN) * Theta_LL(ML,ND)) / (Nno3(MN) * Theta_LL(ML,ND) + KC1(J)) *eTheta(ML,ND)*eT(MN);
            % SVden(ML,ND) = Km1(J) * Theta_LL(ML,ND) / (Nno3(MN) * Theta_LL(ML,ND) + KC1(J)) *eTheta(ML,ND)*eT(MN);
            
            % Decay function or linear function
            SVden(ML,ND)=K21(J)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN);
            Sden(ML,ND)=K21(J)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN)*No3(MN);
            
            %Bessou et al.(2010)assume that the N2O flux from NO−3 0.11
            %from ： Bessou, C., Mary, B., Léonard, J., Roussel, M., Gréhan, E., and Gabrielle, B.
            % : Modelling soil compaction impacts on nitrous oxide emissions in arable fields, Eur. J. Soil Sci., 61, 348–363, https://doi.org/10.1111/j.1365-2389.2010.01243.x, 2010
            Sden_N2o(ML,ND)=0.11*K21(J)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN)*No3(MN);
            Sden_N2(ML,ND)=0.89*K21(J)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN)*No3(MN);
        end
    end

    Cvdenit_N2o(KT) = 0;
    Cvdenit_N2(KT) = 0;
    for ML = 1: NL
        Cvdenit_N2o(KT) = Cvdenit_N2o(KT) + DeltZ(ML) * (Sden_N2o(ML,1)+Sden_N2o(ML,2))/2;
        Cvdenit_N2(KT) = Cvdenit_N2(KT) + DeltZ(ML) * (Sden_N2(ML,1)+Sden_N2(ML,2))/2;
    end

    

