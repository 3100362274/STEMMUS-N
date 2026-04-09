function [C1, C1O, C2, C2O, C3, C4, C3_a, C4_a, C5, C6,M,K,Me,Ke_diff,Ke_conv,F] = N_MAT(R1, R1O, E1, B1, F1, G1, R2, R2O, E2, B2, F2, G2, DeltZ, NL, NN, wc2, wc1,Theta_L,Theta_LL)
    % Assemble nitrogen individual matrices

    % Initialize matrices
    C1 = zeros(NN, 2);
    C1O = zeros(NN, 2);
    C2 = zeros(NN, 2);
    C2O = zeros(NN, 2);
    C3 = zeros(NN, 2);
    C4 = zeros(NN, 2);
    C3_a = zeros(NN, 1);
    C4_a = zeros(NN, 1);
    C5 = zeros(NN, 1);
    C6 = zeros(NN, 1);
    M = zeros(NN,NN);     % 质量矩阵
    K = zeros(NN,NN);     % 刚度矩阵（扩散 + 对流）
    F = zeros(NN,1);
    % Assemble matrices
    for ML = 1:NL
        n1 = ML;
        n2 = ML+1;
        %% NH4+__N

        C1O(ML,1)=C1O(ML,1)+(Theta_L(ML,1)*R1O(ML,1)) * DeltZ(ML)/2;
        C1O(ML+1,1)=C1O(ML+1,1)+(Theta_L(ML,2)*R1O(ML,2)) * DeltZ(ML)/2;
        C1(ML, 1) = C1(ML, 1) + (Theta_LL(ML,1)*R1(ML,1)) * DeltZ(ML)/2;
        C1(ML + 1, 1) = C1(ML + 1, 1) + (Theta_LL(ML,2)*R1(ML, 2)) * DeltZ(ML)/2;

    
        % 局部质量矩阵 (积分 phi_i*phi_j)
        diag_elements = DeltZ(ML)/6 * [2*R1(ML,1)+R1(ML,2), R1(ML,1)+2*R1(ML,2)];
        Me = diag(diag_elements);

        % 局部扩散矩阵 (积分 D*dphi_i/dx * dphi_j/dx)
        Ke_diff = (E1(ML, 1) + E1(ML, 2)) / (2 * DeltZ(ML)) * [1, -1;
            -1, 1];

        % 局部对流矩阵 (积分 u*phi_i*dphi_j/dx)
        Ke_conv = 1/6 * [-2*B1(ML,1)-B1(ML,2), -B1(ML,1)-2*B1(ML,2);
            2*B1(ML,1)+B1(ML,2), B1(ML,1)+2*B1(ML,2)];

        % 局部反应矩阵 (积分 phi_i*phi_j)
        Ke_reac = DeltZ(ML)/12 * [3*F1(ML,1)+F1(ML,2), F1(ML,1)+F1(ML,2);
            F1(ML,1)+F1(ML,2), F1(ML,1)+3*F1(ML,2)];

        % 局部源汇矩阵 (积分 phi_i)
        Ke_S = DeltZ(ML) / 6 * [2 * G1(ML, 1) + G1(ML, 2); G1(ML, 1) + 2 * G1(ML, 2)];


        % 合并局部刚度矩阵
        Ke = Ke_diff - Ke_conv -  Ke_reac;

        % 组装到全局矩阵
        M([n1,n2],[n1,n2]) = M([n1,n2],[n1,n2]) + Me;
        K([n1,n2],[n1,n2]) = K([n1,n2],[n1,n2]) + Ke;
        F([n1,n2]) = F([n1,n2]) + Ke_S;

        C3diff = (E1(ML, 1) + E1(ML, 2)) / (2 * DeltZ(ML));
        C3conv_1 = ((2 + 3 *  wc1(ML)) * B1(ML, 1)  + B1(ML, 2)) / 6;
        C3conv_2 = (B1(ML, 1) + (2 - 3 *  wc1(ML)) *  B1(ML, 2)) / 6;
        C3reac_1 = ((1 / 4) * F1(ML, 1) + (1 / 12) * F1(ML, 2)) * DeltZ(ML);
        C3reac_2 = ((1 / 12) * F1(ML, 1) + (1 / 4) * F1(ML, 2)) * DeltZ(ML);
        C3reac_3 = ((1 / 12) * F1(ML, 1) + (1 / 12) * F1(ML, 2)) * DeltZ(ML);
        C3(ML, 1) = C3(ML, 1) + C3diff + C3conv_1 - C3reac_1;
        C3(ML, 2) = C3(ML, 2) - C3diff + C3conv_2 - C3reac_3;
        C3(ML + 1, 1) = C3(ML + 1, 1) + C3diff - C3conv_2 - C3reac_2;
        C3_a(ML) = -C3diff - C3conv_1 - C3reac_3;

        C5S1 = (2 * G1(ML, 1) + G1(ML, 2)) * DeltZ(ML) / 6;
        C5S2 = (G1(ML, 1) + 2 * G1(ML, 2)) * DeltZ(ML) / 6;
        C5(ML, 1) = C5(ML, 1) + C5S1;
        C5(ML + 1, 1) = C5(ML + 1, 1) + C5S2;

        %% NO3-__N
       
        C2O(ML,1)=C2O(ML,1)+(Theta_L(ML,1)*R2O(ML,1)) * DeltZ(ML)/2;
        C2O(ML+1,1)=C2O(ML+1,1)+(Theta_L(ML,2)*R2O(ML,2)) * DeltZ(ML)/2;
        C2(ML, 1) = C2(ML, 1) + (Theta_LL(ML,1)*R2(ML,1)) * DeltZ(ML)/2;
        C2(ML + 1, 1) = C2(ML + 1, 1) + (Theta_LL(ML,2)*R2(ML, 2)) * DeltZ(ML)/2;

        C4diff = (E2(ML, 1) + E2(ML, 2)) / (2 * DeltZ(ML));
        C4conv_1 = ((2 + 3 *  wc2(ML)) * B2(ML, 1)  + B2(ML, 2)) / 6;
        C4conv_2 = (B2(ML, 1) + (2 - 3 *  wc2(ML)) *  B2(ML, 2)) / 6;
        C4reac_1 = ((1 / 4) * F2(ML, 1) + (1 / 12) * F2(ML, 2)) * DeltZ(ML);
        C4reac_2 = ((1 / 12) * F2(ML, 1) + (1 / 4) * F2(ML, 2)) * DeltZ(ML);
        C4reac_3 = ((1 / 12) * F2(ML, 1) + (1 / 12) * F2(ML, 2)) * DeltZ(ML);
        C4(ML, 1) = C4(ML, 1) + C4diff + C4conv_1 - C4reac_1;
        C4(ML, 2) = C4(ML, 2) - C4diff + C4conv_2 - C4reac_3;
        C4(ML + 1, 1) = C4(ML + 1, 1) + C4diff - C4conv_2 - C4reac_2;
        C4_a(ML) = -C4diff - C4conv_1 - C4reac_3;

        C6S1 = (2 * G2(ML, 1) + G2(ML, 2)) * DeltZ(ML) / 6;
        C6S2 = (G2(ML, 1) + 2 * G2(ML, 2)) * DeltZ(ML) / 6;
        C6(ML, 1) = C6(ML, 1) + C6S1;
        C6(ML + 1, 1) = C6(ML + 1, 1) + C6S2;
    end
  
end

