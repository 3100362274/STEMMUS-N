function [Smin]=CalculateMineralizationorginal(TT,K31,Theta_LL,Theta_f,NL,Tr,R,eT,eTheta,RHOKG1,Smin,PH1,ePH)
% Calculate the solute Mineralization
% EA 特定反应下的活化能 STENGER R, PRIESACK E, BEESE F. Rates of net nitrogen mineralization in disturbed and undisturbed soils[J]. Plant and Soil, 1995, 171(2): 323-332.
% 应用文献提供的矿化Ea值可取为57142.1 J/mol
    
    EA=57142.1;
    TD=zeros(NL+1);

    % 2024-11-28加入固态的矿化速率
    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;

            %Arrhenius FORMULA
            TD(MN)=(TT(MN)-Tr)/R/(TT(MN)+273.15)./(Tr+273.15);
            eT(MN)=exp(EA*TD(MN));
            

            % WALKER FORMULA
            eTheta(ML,ND)=min(1,(Theta_LL(ML,ND)/Theta_f(ML)).^0.7);

            % from ：Eckersten H, Jansson P E, Johnsson H. SOILN model user’s guide[M]//Version 9.1. 
            % Uppsala, Sweden: Department of Soil Science, Swedish University of Agriculture Science, 1996.
            ePH(ML) = 1 / (1 + exp(-2.5 * (PH1(J) - 5.0)));

            if eT(MN) > 1
                eT(MN) = 1;
            end
            if eTheta(ML,ND) > 1
                eTheta(ML,ND) = 1;
            end
            if ePH(ML) > 1
                ePH(ML) = 1;
            end

 
            Smin(ML,ND)=K31(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eTheta(ML,ND)*eT(MN)*ePH(ML);
        end
    end
    
    

