function [Snit]=CalculateNitrification(TT,Nn,NL,NN,Theta_LL,Theta_s,RHOKG1,K1,mL,J,mN)
% Calculate the solute nitrification
    
    eT=zeros(mN,1);                 % Soil temperature correction function
    eTheta=zeros(mN,1);             % Soil moisture correction function
    Snit=zeros(mL,1);               % Nitration  rate (μg/(cm^3.d))
    Theta_LLBAR=zeros(mL,1);

    for MN=1:NN
        if TT>=5
        eT(MN)=3^((TT(MN)-20)/10);
        else
        eT(MN)=(TT(MN)/5)*3^((TT(MN)-20)/10);    
        end
    end
    for ML=1:NL
        for ND=1:2
            Theta_LLBAR(ML)=(Theta_LL(ML,1)+Theta_LL(ML,2))/2;
        end
    end
    for ML=1:NL
        if Theta_LLBAR(ML)<0.12
        eTheta(ML)=0;
        elseif  Theta_LLBAR(ML)<=0.24
        eTheta(ML)=(Theta_LLBAR(ML)-0.12)/0.12; 
        elseif  Theta_LLBAR(ML)<0.33
        eTheta(ML)=1; 
        elseif  Theta_LLBAR(ML)<=Theta_s(J)
        eTheta(ML)=0.6+0.4*(Theta_s(J)-Theta_LLBAR(ML))/(Theta_s(J)-0.33);   
        end
    end

    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;
            Snit(ML)=-K1*(Theta_LLBAR(ML)+RHOKG1(J))*Nn(MN,1)*eT(MN)*eTheta(ML);
        end
    end