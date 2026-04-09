function [Sden]=CalculateDenitrification(TT,Km,KC,Theta_LL,Theta_s,Nn,NL,NN,J,mL,mN)
% Calculate the solute denitrification
    
   
    eT=zeros(mN,1);                 % Soil temperature correction function
    eTheta=zeros(mN,1);                 % Soil depth correction function
    Sden=zeros(mL,1);               % Denitrification  rate (μg/(cm^3.d))
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
        if Theta_LLBAR(ML)<=0.17
        eTheta(ML)=0;
        else
        eTheta(ML)=((Theta_LLBAR(ML)-0.17)/(Theta_s(J)-0.17))^2;   
        end
    end

    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;
            Sden(ML)=-(Km*Nn(MN,1)*Theta_LLBAR*eTheta(ML)*eT(MN))/(Nn(MN,1)*Theta_LLBAR+KC);
        end
    end

        
  
