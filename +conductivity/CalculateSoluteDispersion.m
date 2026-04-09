function [Dsh]=CalculateSoluteDispersion(DIF1111,mL,nD,nS,Theta_LL,Theta_s,QL,DISP1111)
% Calculate the solute dispersion coefficient

    Dsh=zeros(mL,1,nS);
    fw=zeros(mL,nD);                 % Liquid phase pore tortuosity
    DIF2BAR=zeros(mL,1,nS);
    DISP2=zeros(mL,1,nS);            %Mechanical dispersion coefficient of solute(m^2.s^-1)
    DIF2=zeros(mL,nD,nS);            %Molecular diffusion coefficient of solute in soil(s^2.m^-1)
    Theta_LLBAR=zeros(mL,1);
    
    for js=1:nS
        for ML=1:NL
            J=ML;
            for ND=1:2
                fw(ML,ND)=Theta_LL(ML,ND)^(7/3)/Theta_s(J)^2; 
                DIF2(ML,ND,js)=DIF1111(J,js)*fw(ML,ND);
            end
        end
        
        for ML=1:NL
            DIF2BAR(ML,js)=(DIF2(ML,1,js)+DIF2(ML,2,js))/2;
            DISP2(ML,js)=DISP1111(J,js)*abs(QL(ML));
            Theta_LLBAR(ML)=(Theta_LL(ML,1)+Theta_LL(ML,2))/2;
        end
        
        for ML=1:NL
            Dsh(ML,js)=DIF2BAR(ML,js)*Theta_LLBAR(ML)+DISP2(ML,js);
        end
    end

end