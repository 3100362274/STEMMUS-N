function [RHS,RHS1,C4,C4_a,C3,C3_a,cTop1,cTop]=N_BC(RHS1,C3,C3_a,RHS,NBCN,NBCNB,KT,C4,NN,C4_a,QL_nodes,Thmrlefc,QMB,cBot,cTop,cBot1,cTop1,lBNF,BNF) 
%% NH4+__N
%%%%%%%%%% Apply the bottom boundary condition called for by NBCNB %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCNB==1            %-----> Specify concentration at bottom to be ---BCNB;
        RHS(1)=cBot(KT);
        C3(1,1)=1;
        RHS(2)=RHS(2)-C3_a(1)*RHS(1);
        C3(1,2)=0;
        C3_a(1)=0;
    elseif NBCNB==2        %-----> Specify concentration flux at bottom to be ---BCNB (Positive upwards);
        if QL_nodes(1)>0 || (Thmrlefc==1 && QMB(KT)==0)
            RHS(1)=RHS(1)+QL_nodes(1)*cBot(KT);
        else
            C3(1,1)=-1;
            C3(1,2)=1;
            RHS(1)=0;
        end
    elseif NBCNB==3        %-----> NBChB=3,Gravity drainage at bottom--specify concentration flux= 0;
        C3(1,1)=-1;
        C3(1,2)=1;
        RHS(1)=0;
    end
    
%%%%%%%%%% Apply the surface boundary condition called for by NBCN  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCN==1             %-----> Specified concentration at surface---equal to cTop;
        if lBNF == 0
        RHS(NN)=cTop(KT);
        else
         RHS(NN)=cTop(KT)+BNF;
        end
        C3(NN,1)=1;
        RHS(NN-1)=RHS(NN-1)-C3(NN-1,2)*RHS(NN);
        C3(NN-1,2)=0;
        C3_a(NN-1)=0;
    else 
        if QL_nodes(NN)<0
            RHS(NN)=RHS(NN)-QL_nodes(NN)*cTop(KT);
        end
    end

   
    %% NO3-__N
%%%%%%%%%% Apply the bottom boundary condition called for by NBCNB %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCNB==1            %-----> Specify concentration at bottom to be ---BCNB;
        RHS1(1)=cBot1(KT);
        C4(1,1)=1;
        RHS1(2)=RHS1(2)-C4_a(1)*RHS1(1);
        C4(1,2)=0;
        C4_a(1)=0;
    elseif NBCNB==2        %-----> Specify concentration flux at bottom to be ---BCNB (Positive upwards);
        if QL_nodes(1)>0 || (Thmrlefc==1 && QMB(KT)==0)
            RHS1(1)=RHS1(1)+QL_nodes(1)*cBot1(KT);
        else
            C4(1,1)=-1;
            C4(1,2)=1;
            RHS1(1)=0;
        end
    elseif NBCNB==3        %-----> NBChB=3,Gravity drainage at bottom--specify concentration flux= 0;       
        C4(1,1)=-1;
        C4(1,2)=1;
        RHS1(1)=0;
    end
    
%%%%%%%%%% Apply the surface boundary condition called for by NBCN  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCN==1             %-----> Specified concentration at surface---equal to cTop;
        RHS1(NN)=cTop1(KT);
        C4(NN,1)=1;
        RHS1(NN-1)=RHS1(NN-1)-C4(NN-1,2)*RHS1(NN);
        C4(NN-1,2)=0;
        C4_a(NN-1)=0;
    else
        if QL_nodes(NN) < 0  % If flux is downward
            RHS1(NN) = RHS1(NN) - QL_nodes(NN) * cTop1(KT);%cTop1(KT)/86400;%QL_nodes(NN) * cTop1(KT);
        end
    end
end


% %  if(WLayer.and.hNew(NumNP).gt.0.) then ! mass balance in the surface layer
%         hT=hNew(NumNP)
%         do 15 jj=1,NS
%           if((hT+dt*(Prec-rSoil)).gt.0.)
%      !      cTop(jj)=(hT*cTop(jj)+dt*Prec*cT(jj))/(hT+dt*(Prec-rSoil))
% 15      continue
%       end if  解释代码物理含义来自于hydrus    考虑hnew有积水的时候再加，rsoil是蒸发
