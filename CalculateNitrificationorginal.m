function [Snit,SVnit,Cvnit_N2o]=CalculateNitrificationorginal(TT,N,NL,Theta_LL,Theta_f,Theta_s,RHOKG1,K11,eT,eTheta,Snit,R,Tr,ePH,Cvnit_N2o,PH1,SVnit,KT,DeltZ)
% Calculate the solute nitrification;Nitrification depends on water content, temperature, PH
%EA 特定反应下的活化能 from：HARRIS R F. Energetics of Nitrogen Transformations[M]. Madison: American Society of Agronomy, 1982: 833-890.
%硝化反应EA值为81171 J/mol
    EA=81171;
    Cvnit_N2 = zeros(NL+1,2);
    TD = zeros(NL+1,1);
    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;

            %Arrhenius FORMULA
            TD(MN)=(TT(MN)-Tr)/R/(TT(MN)+273.15)./(Tr+273.15);
            eT(MN)=exp(EA*TD(MN));

            % Eckersten H(1996) AND Parton et al.(1996)
            if Theta_LL(ML,ND)<0.12
                eTheta(ML,ND)=0;
            elseif  Theta_LL(ML,ND)<=0.24
                eTheta(ML,ND)=(Theta_LL(ML,ND)-0.12)/0.12;
            elseif  Theta_LL(ML,ND)<0.33
                eTheta(ML,ND)=1;
            elseif  Theta_LL(ML,ND)<=Theta_s(J)
                eTheta(ML,ND)=0.6+0.4*(Theta_s(J)-Theta_LL(ML,ND))/(Theta_s(J)-0.33);
            end
            % eTheta(ML)=min(1,(Theta_LLBAR(ML)/Theta_f(ML))^0.7);

            ePH(ML) = 0.56 + atan(pi() * 0.45 * (-5 + min(PH1(J), 14))) / pi();  % 限制pH的值
            
            SVnit(ML,ND)=K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eT(MN)*eTheta(ML,ND)*ePH(ML);
            % from：Parton, W. J., Holland, E. A., Del Grosso, S. J., Hartman, M. D., Martin, R. E., Mosier, A. R., Ojima, D. S., and Schimel, D. S.: Generalized model for NO2 and N2O emissions from soils, 
            % J. Geophys. Res.-Atmos., 106, 17403–17419, https://doi.org/10.1029/2001JD900101, 2001.
            Snit(ML,ND)=0.98*K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eT(MN)*eTheta(ML,ND)*ePH(ML)*N(MN);
            % SVnit(ML,ND)=K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eT(MN)*eTheta(ML,ND)*ePH(ML);
            Cvnit_N2(ML,ND)=0.02*K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eT(MN)*eTheta(ML,ND)*ePH(ML)*N(MN);%0.02 is the fraction of nitrified N lost as N2O flux
        end
    end
    Cvnit_N2o(KT) = 0;
    for ML = 1:NL
        Cvnit_N2o(KT) = Cvnit_N2o(KT) + DeltZ(ML) * mean(Cvnit_N2(ML,:));
    end

