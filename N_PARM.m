function [R1, R1O, E1, B1, F1, G1, R2, R2O, E2, B2, F2, G2, cvSnit, cvSmin, cvSden, cvSinkS, cvSinkS1, cvSvol, ...
          QNH4, QNO3, DNH4DZ, DNO3DZ, QNH4_h, QNH4_T, QNH4_A, QNH4_convection, ...
          QNH4_convection_h, QNH4_convection_T, QNH4_convection_A, QNH4_dispersion, ...  
          QNH4_dispersion_h, QNH4_dispersion_T, QNH4_dispersion_A, QNO3_h, ...
          QNO3_T, QNO3_A, QNO3_convection, QNO3_convection_h, QNO3_convection_T, ...
          QNO3_convection_A, QNO3_dispersion, QNO3_dispersion_h, QNO3_dispersion_T, ...  
          QNO3_dispersion_A] = N_PARM(NL, RHOKG1, Dsh, Dsh_h, Dsh_T, Dsh_A, QL_nodes, QL_nodes_h, QL_nodes_T, QL_nodes_A, ...
          Theta_L, Theta_LL, Snit, SVnit, SVden, Smin, Svol, SinkS, Sden, ...
          cvSnit, cvSvol, cvSmin, cvSden, cvSinkS, cvSinkS1, DeltZ, R1, R1O, E1, B1, F1, G1, ...
          R2, R2O, E2, B2, F2, G2, Shys, Nn, Nno3, KT)
    % Calculation of coefficient of nitrogen transport equation

    % Calculate coefficients 
    for ML = 1:NL
        for ND = 1:2
            MN = ML + ND - 1; 
            % NH4+__N
            R1O(ML,ND) = 1+RHOKG1(ML)/Theta_L(ML,ND);
            R1(ML,ND)  = 1+RHOKG1(ML)/Theta_LL(ML,ND);
            E1(ML, ND) = Dsh(ML, ND, 1);
            B1(ML, ND) = QL_nodes(MN);
            F1(ML, ND) = -SVnit(ML, ND);
            G1(ML, ND) = Shys(ML, ND)+ Smin(ML, ND)-Svol(ML, ND)- SinkS(ML, ND, 1); %-Snit(ML, ND)

            % NO3-__N
            R2(ML,ND)  = 1;
            R2O(ML,ND) = 1;
            E2(ML, ND) = Dsh(ML, ND, 2);
            B2(ML, ND) = QL_nodes(MN);
            F2(ML, ND) = -SVden(ML, ND);
            G2(ML, ND) = Snit(ML, ND)-SinkS(ML, ND, 2);
        end
    end

    % Initialize output variables 
    DNH4DZ = zeros(NL, 1);
    DNO3DZ = zeros(NL, 1);
    QNH4 = zeros(NL, 1);
    QNH4_h = zeros(NL, 1);
    QNH4_T = zeros(NL, 1);
    QNH4_A = zeros(NL, 1);
    QNH4_convection = zeros(NL, 1);
    QNH4_convection_h = zeros(NL, 1);
    QNH4_convection_T = zeros(NL, 1);
    QNH4_convection_A = zeros(NL, 1);
    QNH4_dispersion = zeros(NL, 1);  
    QNH4_dispersion_h = zeros(NL, 1);  
    QNH4_dispersion_T = zeros(NL, 1);  
    QNH4_dispersion_A = zeros(NL, 1);  
    QNO3 = zeros(NL, 1);
    QNO3_h = zeros(NL, 1);
    QNO3_T = zeros(NL, 1);
    QNO3_A = zeros(NL, 1);
    QNO3_convection = zeros(NL, 1);
    QNO3_convection_h = zeros(NL, 1);
    QNO3_convection_T = zeros(NL, 1);
    QNO3_convection_A = zeros(NL, 1);
    QNO3_dispersion = zeros(NL, 1);  
    QNO3_dispersion_h = zeros(NL, 1);  
    QNO3_dispersion_T = zeros(NL, 1);  
    QNO3_dispersion_A = zeros(NL, 1);  

    % Calculate average parameters 
    E1BAR = mean(E1, 2);  % [NLx1]
    E2BAR = mean(E2, 2);
    
    Dsh_h1BAR = mean(Dsh_h(:, :, 1), 2);  % NH4的h导数
    Dsh_T1BAR = mean(Dsh_T(:, :, 1), 2);  % NH4的T导数
    Dsh_A1BAR = mean(Dsh_A(:, :, 1), 2);  % NH4的A导数
    
    Dsh_h2BAR = mean(Dsh_h(:, :, 2), 2);  % NO3的h导数
    Dsh_T2BAR = mean(Dsh_T(:, :, 2), 2);  % NO3的T导数
    Dsh_A2BAR = mean(Dsh_A(:, :, 2), 2);  % NO3的A导数

    % Calculate gradients
    for ML = 1:NL
        DNH4DZ(ML) = (Nn(ML+1) - Nn(ML)) / DeltZ(ML);
        DNO3DZ(ML) = (Nno3(ML+1) - Nno3(ML)) / DeltZ(ML);
    end

    % Calculate fluxes 
    for ML = 1:NL
        node_left = ML;
        node_right = ML + 1;

        % ================= NH4+ 通量计算 =================
        % 总通量
        flux_left = QL_nodes(node_left) * Nn(node_left) - E1BAR(ML) * DNH4DZ(ML);
        flux_right = QL_nodes(node_right) * Nn(node_right) - E1BAR(ML) * DNH4DZ(ML);
        QNH4(ML) = (flux_left + flux_right) / 2;
        
        % 通量导数 (h, T, A)
        flux_left_h = QL_nodes_h(node_left) * Nn(node_left) - Dsh_h1BAR(ML) * DNH4DZ(ML);
        flux_right_h = QL_nodes_h(node_right) * Nn(node_right) - Dsh_h1BAR(ML) * DNH4DZ(ML);
        QNH4_h(ML) = (flux_left_h + flux_right_h) / 2;
        
        flux_left_T = QL_nodes_T(node_left) * Nn(node_left) - Dsh_T1BAR(ML) * DNH4DZ(ML);
        flux_right_T = QL_nodes_T(node_right) * Nn(node_right) - Dsh_T1BAR(ML) * DNH4DZ(ML);
        QNH4_T(ML) = (flux_left_T + flux_right_T) / 2;
        
        flux_left_A = QL_nodes_A(node_left) * Nn(node_left) - Dsh_A1BAR(ML) * DNH4DZ(ML);
        flux_right_A = QL_nodes_A(node_right) * Nn(node_right) - Dsh_A1BAR(ML) * DNH4DZ(ML);
        QNH4_A(ML) = (flux_left_A + flux_right_A) / 2;
        
        % 对流项
        flux_left_convection = QL_nodes(node_left) * Nn(node_left);
        flux_right_convection = QL_nodes(node_right) * Nn(node_right);
        QNH4_convection(ML) = (flux_left_convection + flux_right_convection) / 2;
        
        flux_left_convection_h = QL_nodes_h(node_left) * Nn(node_left);  % 修复变量名
        flux_right_convection_h = QL_nodes_h(node_right) * Nn(node_right);  % 修复变量名
        QNH4_convection_h(ML) = (flux_left_convection_h + flux_right_convection_h) / 2;
        
        flux_left_convection_T = QL_nodes_T(node_left) * Nn(node_left);
        flux_right_convection_T = QL_nodes_T(node_right) * Nn(node_right);
        QNH4_convection_T(ML) = (flux_left_convection_T + flux_right_convection_T) / 2;
        
        flux_left_convection_A = QL_nodes_A(node_left) * Nn(node_left);
        flux_right_convection_A = QL_nodes_A(node_right) * Nn(node_right);
        QNH4_convection_A(ML) = (flux_left_convection_A + flux_right_convection_A) / 2;
        
        % 弥散项 
        flux_left_dispersion = -E1BAR(ML) * DNH4DZ(ML);
        flux_right_dispersion = -E1BAR(ML) * DNH4DZ(ML);
        QNH4_dispersion(ML) = (flux_left_dispersion + flux_right_dispersion) / 2;  
        
        flux_left_dispersion_h = -Dsh_h1BAR(ML) * DNH4DZ(ML);
        flux_right_dispersion_h = -Dsh_h1BAR(ML) * DNH4DZ(ML);
        QNH4_dispersion_h(ML) = (flux_left_dispersion_h + flux_right_dispersion_h) / 2;  
        
        flux_left_dispersion_T = -Dsh_T1BAR(ML) * DNH4DZ(ML);
        flux_right_dispersion_T = -Dsh_T1BAR(ML) * DNH4DZ(ML);
        QNH4_dispersion_T(ML) = (flux_left_dispersion_T + flux_right_dispersion_T) / 2;  
        
        flux_left_dispersion_A = -Dsh_A1BAR(ML) * DNH4DZ(ML);
        flux_right_dispersion_A = -Dsh_A1BAR(ML) * DNH4DZ(ML);
        QNH4_dispersion_A(ML) = (flux_left_dispersion_A + flux_right_dispersion_A) / 2;  

        % ================= NO3- 通量计算 =================
        % 总通量
        flux_left = QL_nodes(node_left) * Nno3(node_left) - E2BAR(ML) * DNO3DZ(ML);
        flux_right = QL_nodes(node_right) * Nno3(node_right) - E2BAR(ML) * DNO3DZ(ML);
        QNO3(ML) = (flux_left + flux_right) / 2;
        
        % 通量导数 (h, T, A) - 使用NO3专用参数
        flux_left_h = QL_nodes_h(node_left) * Nno3(node_left) - Dsh_h2BAR(ML) * DNO3DZ(ML);
        flux_right_h = QL_nodes_h(node_right) * Nno3(node_right) - Dsh_h2BAR(ML) * DNO3DZ(ML);
        QNO3_h(ML) = (flux_left_h + flux_right_h) / 2;
        
        flux_left_T = QL_nodes_T(node_left) * Nno3(node_left) - Dsh_T2BAR(ML) * DNO3DZ(ML);
        flux_right_T = QL_nodes_T(node_right) * Nno3(node_right) - Dsh_T2BAR(ML) * DNO3DZ(ML);
        QNO3_T(ML) = (flux_left_T + flux_right_T) / 2;
        
        flux_left_A = QL_nodes_A(node_left) * Nno3(node_left) - Dsh_A2BAR(ML) * DNO3DZ(ML);
        flux_right_A = QL_nodes_A(node_right) * Nno3(node_right) - Dsh_A2BAR(ML) * DNO3DZ(ML);
        QNO3_A(ML) = (flux_left_A + flux_right_A) / 2;
        
        % 对流项
        flux_left_convection = QL_nodes(node_left) * Nno3(node_left);
        flux_right_convection = QL_nodes(node_right) * Nno3(node_right);
        QNO3_convection(ML) = (flux_left_convection + flux_right_convection) / 2;
        
        flux_left_convection_h = QL_nodes_h(node_left) * Nno3(node_left);  
        flux_right_convection_h = QL_nodes_h(node_right) * Nno3(node_right);  
        QNO3_convection_h(ML) = (flux_left_convection_h + flux_right_convection_h) / 2;
        
        flux_left_convection_T = QL_nodes_T(node_left) * Nno3(node_left);
        flux_right_convection_T = QL_nodes_T(node_right) * Nno3(node_right);
        QNO3_convection_T(ML) = (flux_left_convection_T + flux_right_convection_T) / 2;
        
        flux_left_convection_A = QL_nodes_A(node_left) * Nno3(node_left);
        flux_right_convection_A = QL_nodes_A(node_right) * Nno3(node_right);
        QNO3_convection_A(ML) = (flux_left_convection_A + flux_right_convection_A) / 2;
        
        % 弥散项 
        flux_left_dispersion = -E2BAR(ML) * DNO3DZ(ML);
        flux_right_dispersion = -E2BAR(ML) * DNO3DZ(ML);
        QNO3_dispersion(ML) = (flux_left_dispersion + flux_right_dispersion) / 2; 
        
        flux_left_dispersion_h = -Dsh_h2BAR(ML) * DNO3DZ(ML);
        flux_right_dispersion_h = -Dsh_h2BAR(ML) * DNO3DZ(ML);
        QNO3_dispersion_h(ML) = (flux_left_dispersion_h + flux_right_dispersion_h) / 2; 
        
        flux_left_dispersion_T = -Dsh_T2BAR(ML) * DNO3DZ(ML);
        flux_right_dispersion_T = -Dsh_T2BAR(ML) * DNO3DZ(ML);
        QNO3_dispersion_T(ML) = (flux_left_dispersion_T + flux_right_dispersion_T) / 2; 
        
        flux_left_dispersion_A = -Dsh_A2BAR(ML) * DNO3DZ(ML);
        flux_right_dispersion_A = -Dsh_A2BAR(ML) * DNO3DZ(ML);
        QNO3_dispersion_A(ML) = (flux_left_dispersion_A + flux_right_dispersion_A) / 2;  
    end

    % 初始化累积变量
    cvSvol(KT) = 0;
    cvSnit(KT) = 0;
    cvSmin(KT) = 0;
    cvSden(KT) = 0;
    cvSinkS(KT) = 0;
    cvSinkS1(KT) = 0;
    
    % Calculate integrated values
    for ML = 1:NL
        cvSvol(KT) = cvSvol(KT) + DeltZ(ML) * mean(Svol(ML, :));
        cvSnit(KT) = cvSnit(KT) + DeltZ(ML) * mean(Snit(ML, :));
        cvSmin(KT) = cvSmin(KT) + DeltZ(ML) * mean(Smin(ML, :));
        cvSden(KT) = cvSden(KT) + DeltZ(ML) * mean(Sden(ML, :));
        cvSinkS(KT) = cvSinkS(KT) + DeltZ(ML) * mean(SinkS(ML, :, 1));
        cvSinkS1(KT) = cvSinkS1(KT) + DeltZ(ML) * mean(SinkS(ML, :, 2));  
    end
end
