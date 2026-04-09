function [KL_T]=CondL_T(NL,KLT_Switch,hh,GWT,TT,Gamma0,KL_h)

%%%%%%%%%%%%不考虑KLT%%%%%%%%%%%%%%%%%%%%%%


for ML=1:NL
    for ND=1:2
        MN = ML + ND - 1;
        if KLT_Switch==1 && hh(MN) < 0
            KL_T(ML,ND)=KL_h(ML,ND)*((hh(MN)*GWT)/Gamma0)*(-0.1425-4.76*10^(-4)*TT(MN));  %(50+2.75*TT(MN))/((50+2.75*20));%
        else
            KL_T(ML,ND)=0;
        end
    end
end
end


%%%%%%%%%%%%%%考虑KLT%%%%%%%%%%%%%%%%%%%%%%%%%%
% MN=0;
% for ML=1:NL
%     for ND=1:2
%         MN=ML+ND-1;
%         if KLT_Switch==1
%             KL_h(ML,ND)*((hh(MN)*GWT)/Gamma0)*(-0.1425-4.76*10^(-4)*TT(MN)); 
%         else 
%             KL_T(ML,ND)=0;
%         end        
%     end
% end
%%%%%%%% Unit of KL_T is determined by KL_h, which is subsequently %%%%%%%%
%%%%%%%% determined by Ks set at the beginning. %%%%%%%%%%%%%%%%%%%%%%%%%%%