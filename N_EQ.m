function [RHS,RHS1,C3,C4,SAVE]=N_EQ(C1,C1O,C2,C2O,C3,C4,C5,C6,NL,NN,Delt_t,N,No3,M,K,F,SAVE)
%Equality listing

%% NH4+__N
    RHS(1)=C5(1)+C1O(1,1)*N(1)/Delt_t;
    
    for ML=2:NL
        RHS(ML)=C5(ML)+C1O(ML,1)*N(ML)/Delt_t;
    end
    
    RHS(NN)=C5(NN)+C1O(NN,1)*N(NN)/Delt_t;
    
    for MN=1:NN
        for ND=1:2
            C3(MN,ND)=C1(MN,ND)/Delt_t+C3(MN,ND);
        end
    end
    
    
    SAVE(1,1,4)=RHS(1);
    SAVE(1,2,4)=C3(1,1);
    SAVE(1,3,4)=C3(1,2);
    SAVE(2,1,4)=RHS(NN);
    SAVE(2,2,4)=C3(NN-1,2);
    SAVE(2,3,4)=C3(NN,1);
     % 左边界固定浓度 (Dirichlet)
    % M(1,:) = 0;    M(1,1) = 1;    % 质量矩阵第一行清零，对角线置1
    % K(1,:) = 0;    K(1,1) = 1;    % 刚度矩阵同理
    % 更新左边界固定值

    % 右边界零梯度 (Neumann): 自然边界条件，无需额外处理
    % for  ML = 1:NL
    % % 构造线性方程组: (M + dt*K)*c_new = M*c_old + dt*F
    % % 此处无源项，F = 0
    % 
    % A = (M / Delt_t)+ K;         % 系统矩阵
    % B =  (M / Delt_t) * N + F  ;        % 右端项
    % 
    % % B(1) = 0;
    % % 求解线性方程组
    % % c_new = A \ B;
    % 
    % % 更新浓度场
    % % N = c_new;
    % end
    %% NO3-__N
    RHS1(1)=C6(1)+C2O(1,1)*No3(1)/Delt_t;
    
    for ML=2:NL
        RHS1(ML)=C6(ML)+C2O(ML,1)*No3(ML)/Delt_t;
    end
    
    RHS1(NN)=C6(NN)+C2O(NN,1)*No3(NN)/Delt_t;
    
    for MN=1:NN
        for ND=1:2
            C4(MN,ND)=C2(MN,ND)/Delt_t+C4(MN,ND);
        end
    end

    SAVE(1,1,5)=RHS1(1);
    SAVE(1,2,5)=C4(1,1);
    SAVE(1,3,5)=C4(1,2);
    SAVE(2,1,5)=RHS1(NN);
    SAVE(2,2,5)=C4(NN-1,2);
    SAVE(2,3,5)=C4(NN,1);
