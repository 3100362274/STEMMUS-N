%% mainloop
if Nefc == 1
    % 定义阈值和容差参数（可配置到全局参数中）
    error_thresholds = [10, 100];      % [mg/L]
    error_tolerances = [0.1, 1, 5];    % 对应容差
    for j = 1 : 100
        [Retard,RetardBAR]=CalculateRetardationFactors(Theta_LL,RHOKG1,Retard,RetardBAR,NL);
        [Dsh, DIF2, DISP2] = CalculateSoluteDispersion(DIF1111, nS, NL, Theta_LL, Theta_s, QL, DISP11, NN);
        [Smin]=CalculateMineralizationorginal(TT,K31,Theta_LL,Theta_f,NL,Tr,R,eT,eTheta,RHOKG1,Smin);
        [Svol,SVvol]=CalculateAmmoniumVolatilization(TT,Nn,NL,PH1,DeltZ,FT,FZ,Svol,SVvol,Tot_Depth);
        [Snit,SVnit,Cvnit_N2o]=CalculateNitrificationorginal(TT,Nn,NL,Theta_LL,Theta_f,Theta_s,RHOKG1,K11,eT,eTheta,Snit,R,Tr,ePH,Cvnit_N2o,PH1,SVnit);
        [Sden,SVden,Cvdenit_N2o,Cvdenit_N2]=CalculateDenitrificationorginal(TT,K21,Theta_LL,Theta_s,Nno3,NL,eT,eTheta,Sden,R,Tr,Cvdenit_N2o,Cvdenit_N2,SVden);
        [Shys,Vpore,WFPS]=CalculateUreaHydrolysis(Kurea1,NL,Nurea,Vpore,WFPS,Theta_g,Theta_LL,Shys);
        if lBNF == 1
            [BNF]=CalculateBiologicalNfixation(DeltZ,NL);
        else
            BNF=0;
        end
        run N_sub;


        % 在需要计算容差处调用
        error_toleranceNno3 = calculate_error_tolerance(Nno3(1:NN), error_thresholds, error_tolerances);
        error_toleranceNn = calculate_error_tolerance(Nn(1:NN), error_thresholds, error_tolerances);

        if all(CHK3' < error_toleranceNno3) && all(CHK2' < error_toleranceNn)
            break
        end
    end
    NITTT(KT,1)=j;
end

  %% 计算QL
 
    for ML=1:NL 
        DhDZ(ML)=(hh(ML+1)-hh(ML))/DeltZ(ML);
        DTDZ(ML)=(TT(ML+1)-TT(ML))/DeltZ(ML);
        DPgDZ(ML)=(P_gg(ML+1)-P_gg(ML))/DeltZ(ML);
    end
    KLhBAR = (KL_h(:,1) + KL_h(:,2)) / 2;        % [NLx1]
    KLTBAR = (KL_T(:,1) + KL_T(:,2)) / 2;        % [NLx1]
    DTDBAR = (D_Ta(:,1) + D_Ta(:,2)) / 2;        % [NLx1]
  
    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;

            if KLa_Switch==1
                QL(ML)=-(KLhBAR(ML)*(DhDZ(ML)+DPgDZ(ML)/Gamma_w)+(KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML)+KLhBAR(ML));
                QL_h(ML)=-(KLhBAR(ML)*(DhDZ(ML)+DPgDZ(ML)/Gamma_w)+KLhBAR(ML));
                QL_T(ML)=-((KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML));
                QL_A(ML)=-(KLhBAR(ML)*(DPgDZ(ML)/Gamma_w));
            else
                QL(ML)=-(KLhBAR(ML)*DhDZ(ML)+(KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML)+KLhBAR(ML));
                QL_h(ML)=-(KLhBAR(ML)*DhDZ(ML)+KLhBAR(ML));
                QL_T(ML)=-((KLTBAR(ML)+DTDBAR(ML))*DTDZ(ML));

            end
        end
    end
         

% Calculate the solute dispersion coefficient
    
    QL_nodes = convert_element_to_node(QL, NL, NN);
    
    fw = Theta_LL.^(7/3) ./ Theta_s'.^2;  % 向量化操作
    
    for js=1:nS
        DIF2(:,:,js) = DIF1111(1,:,js)' .* fw;  % 利用广播
    end
   
    for js = 1:nS
        for ML = 1:NL
            J = ML;  % 当前单元的土壤类型索引
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DISP2(ML, ND, js) = DISP11(J) * abs(QL_nodes(MN));  % 使用对应土壤类型的DISP1
                Dsh(ML, ND, js) = Theta_LL(ML, ND) * DIF2(ML, ND, js) + DISP2(ML, ND, js);
            end
        end
    end
% Calculate the solute nitrification;Nitrification depends on water content, temperature, PH
%EA 特定反应下的活化能 from：HARRIS R F. Energetics of Nitrogen Transformations[M]. Madison: American Society of Agronomy, 1982: 833-890.
%硝化反应EA值为81171 J/mol
    EA=81171;
    
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

            Snit(ML,ND)=0.98*K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*Nn(MN)*eT(MN)*eTheta(ML,ND)*ePH(ML);
            SVnit(ML,ND)=K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*eT(MN)*eTheta(ML,ND)*ePH(ML);
            Cvnit_N2o(ML)=0.02*K11(J)*(Theta_LL(ML,ND)+RHOKG1(J))*Nn(MN)*eT(MN)*eTheta(MN)*ePH(ML); %0.02 is the fraction of nitrified N lost as N2O flux
        end
    end
% Calculate the solute denitrification
    %EA 特定反应下的活化能 from：HARRIS R F. Energetics of Nitrogen Transformations[M]. Madison: American Society of Agronomy, 1982: 833-890.
    %应用文献提供的NO、NO2和N2O生成焓的均值近似表征反硝化作用的Ea值为68576.3 J/mol
    EA=68576.3;
               
    for ML=1:NL
        J=ML;
        for ND=1:2
            MN=ML+ND-1;
            %Arrhenius FORMULA
            TD(MN)=(TT(MN)-Tr)/R/(TT(MN)+273.15)./(Tr+273.15);
            eT(MN)=exp(EA*TD(MN));

            if Theta_LL(ML,ND)<=0.17
                eTheta(ML,ND)=0;
            else
                eTheta(ML,ND)=((Theta_LL(ML,ND)-0.17)./(Theta_s(J)-0.17)).^2;
            end

            Sden(ML,ND)=K21(J)*Nno3(MN)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN);
            SVden(ML,ND)=K21(J)*Theta_LL(ML,ND)*eTheta(ML,ND)*eT(MN);
            Cvdenit_N2o(ML)=Sden(ML,ND)*0.11; %Bessou et al.(2010)assume that the N2O flux from NO−3 0.11
            Cvdenit_N2(ML)=Sden(ML,ND)*0.89;
        end
    end
% Calculation of coefficient of nitrogen transport equation


    % Calculate coefficients
    for ML = 1:NL
        for ND = 1:2
            MN = ML + ND - 1; 
            % NH4+__N
            R1(ML, ND) = Theta_LL(ML, ND) *(1 + RHOKG1(ML) / Theta_LL(ML, ND));
            E1(ML, ND) = Dsh(ML, ND, 1);
            B1(ML, ND) = QL_nodes(MN);
            F1(ML, ND) = -SVnit(ML, ND) ;%- SVvol(ML, ND)
            G1(ML, ND) = Smin(ML, ND) + Shys(ML, ND) - SinkS(ML, ND, 1);

            % NO3-__N
            R2(ML, ND) = Theta_LL(ML, ND) ;
            E2(ML, ND) = Dsh(ML, ND, 2);
            B2(ML, ND) = QL_nodes(MN);
            F2(ML, ND) = -SVden(ML, ND);
            G2(ML, ND) = -SinkS(ML, ND, 2);% Snit(ML, ND) 加上以后矿化速率太高引起硝酸根极速升高，有待讨论
        end
    end

 
       % Calculate gradients and averages
       E1BAR = mean(E1, 2);                        % [NLx1]
       E2BAR = mean(E2, 2);
       for ML=1:NL
           DNH4DZ(ML)=(Nn(ML+1)-Nn(ML))/DeltZ(ML);
           DNO3DZ(ML)=(Nno3(ML+1)-Nno3(ML))/DeltZ(ML);
       end

       for ML = 1:NL
           % 当前单元的两个节点编号
           node_left = ML;          % 左节点
           node_right = ML + 1;     % 右节点

           % NH4+通量（左右节点分别计算后平均）
           flux_left = QL_nodes(node_left) * Nn(node_left) - E1BAR(ML) * DNH4DZ(ML);
           flux_right = QL_nodes(node_right) * Nn(node_right) - E1BAR(ML) * DNH4DZ(ML);
           QNH4(ML) = (flux_left + flux_right) / 2;  % 单元平均通量

           % NO3-通量（同理）
           flux_left = QL_nodes(node_left) * Nno3(node_left) - E2BAR(ML) * DNO3DZ(ML);
           flux_right = QL_nodes(node_right) * Nno3(node_right) - E2BAR(ML) * DNO3DZ(ML);
           QNO3(ML) = (flux_left + flux_right) / 2;
       end
    
    % Calculate integrated values
    for ML = 1:NL
        cvSnit(ML) = sum(DeltZ(ML) * mean(Snit(ML, :)));
        cvSmin(ML) = sum(DeltZ(ML) * mean(Smin(ML, :)));
        cvSden(ML) = sum(DeltZ(ML) * mean(Sden(ML, :)));
        cvSinkS(ML) = sum(DeltZ(ML) * mean(SinkS(ML, :, 1)));
        cvSinkS1(ML) = sum(DeltZ(ML) * mean(SinkS(ML, :, 2)));
    end

      % Initialize matrices
    C1 = zeros(NN, 2);
    C1O = zeros(NN, 2);
    C2 = zeros(NN, 2);
    C2O = zeros(NN, 2);
    C3 = zeros(NN, 2);
    C4 = zeros(NN, 2);
    C3_a = zeros(NN, 1);
    C4_a = zeros(NN, 1);
    C5 = zeros(NN, 2);
    C6 = zeros(NN, 2);

    % Assemble matrices
    for ML = 1:NL
        %% NH4+__N
       
        C1(ML, 1) = C1(ML, 1) + R1(ML, 1) * DeltZ(ML) / 2;
        C1(ML + 1, 1) = C1(ML + 1, 1) +  R1(ML, 2) * DeltZ(ML) / 2;

        C3ARG1 = (E1(ML, 1) + E1(ML, 2)) / (2 * DeltZ(ML));
        C3ARG2_1 = B1(ML, 1) / 3 + B1(ML, 2) / 6;
        C3ARG2_2 = B1(ML, 1) / 6 + B1(ML, 2) / 3;
        C3ARG3_1 = (2 * F1(ML, 1) + F1(ML, 2)) * DeltZ(ML) / 6;
        C3ARG3_2 = (F1(ML, 1) + 2 * F1(ML, 2)) * DeltZ(ML) / 6;
        C3(ML, 1) = C3(ML, 1) + C3ARG1 + C3ARG2_1 - C3ARG3_1;
        C3(ML, 2) = C3(ML, 2) - C3ARG1 + C3ARG2_2 - 0;
        C3(ML + 1, 1) = C3(ML + 1, 1) + C3ARG1 - C3ARG2_2 - C3ARG3_2;
        C3_a(ML) = -C3ARG1 - C3ARG2_1 - 0;

        C5ARG1 = (2 * G1(ML, 1) + G1(ML, 2)) * DeltZ(ML) / 6;
        C5ARG2 = (G1(ML, 1) + 2 * G1(ML, 2)) * DeltZ(ML) / 6;
        C5(ML, 1) = C5(ML, 1) - C5ARG1;
        C5(ML + 1, 1) = C5(ML + 1, 1) - C5ARG2;

        %% NO3-__N
       
        C2(ML, 1) = C2(ML, 1) + R2(ML, 1) * DeltZ(ML) / 2;
        C2(ML + 1, 1) = C2(ML + 1, 1) + R2(ML, 2) * DeltZ(ML) / 2;

        C4ARG1 = (E2(ML, 1) + E2(ML, 2)) / (2 * DeltZ(ML));
        C4ARG2_1 = B2(ML, 1) / 3 + B2(ML, 2) / 6;
        C4ARG2_2 = B2(ML, 1) / 6 + B2(ML, 2) / 3;
        C4ARG3_1 = ((1 / 3) * F2(ML, 1) + (1 / 6) * F2(ML, 2)) * DeltZ(ML);
        C4ARG3_2 = ((1 / 6) * F2(ML, 1) + (1 / 3) * F2(ML, 2)) * DeltZ(ML);
        C4(ML, 1) = C4(ML, 1) + C4ARG1 + C4ARG2_1 - C4ARG3_1;
        C4(ML, 2) = C4(ML, 2) - C4ARG1 + C4ARG2_2 - 0;
        C4(ML + 1, 1) = C4(ML + 1, 1) + C4ARG1 - C4ARG2_2 - C4ARG3_2;
        C4_a(ML) = -C4ARG1 - C4ARG2_1 - 0;

        C6ARG1 = (2 * G2(ML, 1) + G2(ML, 2)) * DeltZ(ML) / 6;
        C6ARG2 = (G2(ML, 1) + 2 * G2(ML, 2)) * DeltZ(ML) / 6;
        C6(ML, 1) = C6(ML, 1) - C6ARG1;
        C6(ML + 1, 1) = C6(ML + 1, 1) - C6ARG2;
    end

    %Equality listing

%% NH4+__N
    RHS(1)=-C5(1)+(C1(1,1)*N(1)+C1(1,2)*N(2))/Delt_t;
    
    for ML=2:NL
        RHS(ML)=-C5(ML)+(C1(ML-1,2)*N(ML-1)+C1(ML,1)*N(ML)+C1(ML,2)*N(ML+1))/Delt_t;
    end
    
    RHS(NN)=-C5(NN)+(C1(NN-1,2)*N(NN-1)+C1(NN,1)*N(NN))/Delt_t;
    
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
    
    %% NO3-__N
    RHS1(1)=-C6(1)+(C2(1,1)*No3(1)+C2(1,2)*No3(2))/Delt_t;
    
    for ML=2:NL
        RHS1(ML)=-C6(ML)+(C2(ML-1,2)*No3(ML-1)+C2(ML,1)*No3(ML)+C2(ML,2)*No3(ML+1))/Delt_t;
    end
    
    RHS1(NN)=-C6(NN)+(C2(NN-1,2)*No3(NN-1)+C2(NN,1)*No3(NN))/Delt_t;
    
    for MN=1:NN
        for ND=1:2
            C4(MN,ND)=C2(MN,ND)/Delt_t+C4(MN,ND);
        end
    end

    SAVE1(1,1)=RHS1(1);
    SAVE1(1,2)=C4(1,1);
    SAVE1(1,3)=C4(1,2);
    SAVE1(2,1)=RHS1(NN);
    SAVE1(2,2)=C4(NN-1,2);
    SAVE1(2,3)=C4(NN,1);

    %% NH4+__N
%%%%%%%%%% Apply the bottom boundary condition called for by NBCNB %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCNB==1            %-----> Specify concentration at bottom to be ---BCNB;
        RHS(1)=cBot(KT);
        C3(1,1)=1;
        RHS(2)=RHS(2)-C3(1,2)*RHS(1);
        C3(1,2)=0;
        C3_a(1)=0;
    elseif NBCNB==2        %-----> Specify concentration flux at bottom to be ---BCNB (Positive upwards);
        if QL(1)>0 || (DVa_Switch==1 && QMB(KT)==0)
            RHS(1)=RHS(1)+QL(1)*cBot(KT);
        else
            % C3(1,1)=-1;
            % C3(1,2)=1;
            RHS(1)=RHS(1);
        end
    elseif NBCNB==3        %-----> NBChB=3,Gravity drainage at bottom--specify concentration flux= 0;
        % C3(1,1)=-1;
        % C3(1,2)=1;
        RHS(1)=RHS(1)+QL(1)*Nn(1);
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
        if QL(NL)<0
            RHS(NN)=RHS(NN)-QL(NN)*cTop(KT);
        else
            RHS(NN)=RHS(NN);
        end
    end

    %% NO3-__N
%%%%%%%%%% Apply the bottom boundary condition called for by NBCNB %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBCNB==1            %-----> Specify concentration at bottom to be ---BCNB;
        RHS1(1)=1;%cBot1(KT);
        C4(1,1)=1;
        RHS1(2)=RHS1(2)-C4(1,2)*RHS1(1);
        C4(1,2)=0;
        C4_a(1)=0;
    elseif NBCNB==2        %-----> Specify concentration flux at bottom to be ---BCNB (Positive upwards);
        if QL(1)>0 || (DVa_Switch==1 && QMB(KT)==0)
            RHS1(1)=RHS1(1)+QL(1)*cBot1(KT);
        else
            % C4(1,1)=-1;
            % C4(1,2)=1;
            RHS1(1)=RHS1(1);
        end
    elseif NBCNB==3        %-----> NBChB=3,Gravity drainage at bottom--specify concentration flux= 0;
        % C4(1,1)=-1;
        % C4(1,2)=1;
        RHS1(1)=RHS1(1)+QL(1)*Nno3(1);
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
    if QL(NL) < 0  % If flux is downward
        RHS1(NN) = RHS1(NN) - QL(NN) * cTop1(KT);
    else
        RHS1(NN) = RHS1(NN);
    end
end

%% NH4+__N
    RHS(1)=RHS(1)/C3(1,1);
    
    for ML=2:NN
        C3(ML,1)=C3(ML,1)-C3_a(ML-1)*C3(ML-1,2)/C3(ML-1,1);
        RHS(ML)=(RHS(ML)-C3_a(ML-1)*RHS(ML-1))/C3(ML,1);
    end
    
    for ML=NL:-1:1
        RHS(ML)=RHS(ML)-C3(ML,2)*RHS(ML+1)/C3(ML,1);
    end
    
    for MN=1:NN
        CHK2(MN)=abs(RHS(MN)-Nn(MN)); 
        Nn(MN,1)=RHS(MN);
    end
    
     %% NO3-__N
    RHS1(1)=RHS1(1)/C4(1,1);
    
    for ML=2:NN
        C4(ML,1)=C4(ML,1)-C4_a(ML-1)*C4(ML-1,2)/C4(ML-1,1);
        RHS1(ML)=(RHS1(ML)-C4_a(ML-1)*RHS1(ML-1))/C4(ML,1);
    end
    
    for ML=NL:-1:1
        RHS1(ML)=RHS1(ML)-C4(ML,2)*RHS1(ML+1)/C4(ML,1);
    end
    
    for MN=1:NN
        CHK3(MN)=abs(RHS1(MN)-Nno3(MN)); 
        Nno3(MN)=RHS1(MN);
    end