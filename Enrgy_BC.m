function [RHS,C5,C5_a]=Enrgy_BC(RHS,KT,NN,c_L,RHOL,QMB,SH,Precip,L,L_ts,NBCTB,NBCT,BCT,Tbh,Tb_msr,DSTOR0,Delt_t,T,Ts,Ta,EVAP,Rn,C5,C5_a,c_a,Resis_a,QL_nodes,QVV,c_V)


% 2024-11-29 删除BCTB，因为可以预测底部温度
%%%%%%%%% Apply the bottom boundary condition called for by NBCTB %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NBCTB==1
    RHS(1)=Tbh(KT); % 没有实测数据Tb_msr用自动化Tbh(KT);
    C5(1,1)=1;
    RHS(2)=RHS(2)-C5_a(1)*RHS(1);
    C5(1,2)=0;
    C5_a(1)=0;
elseif NBCTB==2
    % 2025-3-21朱寄子星改动
    RHS(1)=RHS(1)+Tbh(KT)*c_L*QL_nodes(1);
else  
    % 几乎没有区别2025-3-21朱寄子星改动 是不是没有考虑水蒸气出去
    C5(1,1)=C5(1,1)+c_L*RHOL*QMB(KT); 
    % C5(1,1)=-1;
    % C5(1,2)=1;
    % RHS(1)=0;
end   

%%%%%%%%%% Apply the surface boundary condition called by NBCT %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NBCT==1
    RHS(NN)=Ts(KT); %没有实测的时候用Tsh(KT)
    C5(NN,1)=1;
    RHS(NN-1)=RHS(NN-1)-C5(NN-1,2)*RHS(NN);
    C5(NN-1,2)=0;
    C5_a(NN-1)=0;
elseif NBCT==2
     % 2025-3-21朱寄子星改动 % QMT
    RHS(NN)=RHS(NN)-Ts(KT)*c_L*QL_nodes(NN)-c_V*Ts(KT)*QVV(NN) - L(NN)*QVV(NN);%BCT;
else    
    L_ts(KT)=L(NN); 
    SH(KT)=0.1200*c_a*(T(NN)-Ta(KT))/Resis_a(KT);%;   % J cm-2 s-1  Ta 小时尺度 Tm 天尺度
    RHS(NN)=RHS(NN)+Rn(KT)-RHOL*L_ts(KT)*EVAP(KT)-SH(KT)+RHOL*c_L*(Ta(KT)*Precip(KT)+DSTOR0*T(NN)/Delt_t);  
end
  
