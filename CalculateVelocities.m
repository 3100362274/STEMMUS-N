function QL_nodes = CalculateVelocities(QL_elements, NL, NN, DeltZ, Theta_LL, Theta_L,  Delt_t, Srt)
    % 将单元量QL_elements [NLx1] 转换为节点量QL_nodes [NNx1]
    QL_nodes = zeros(NN, 1);
    
    % 边界节点
    QL_nodes(1) = QL_elements(1) + DeltZ(1)/2*((Theta_LL(1,1)-Theta_L(1,1))/Delt_t+Srt(1,1));       % 第一个节点 = 第一个单元的值
    QL_nodes(NN) = QL_elements(NL)-DeltZ(NL)/2*((Theta_LL(NL,2)-Theta_L(NL,2))/Delt_t+Srt(NL,2));  % 最后一个节点 = 最后一个单元的值
    
    % 内部节点：相邻单元的平均值
    for i = 2:NN-1
        QL_nodes(i) = (QL_elements(i-1)* DeltZ(i) + QL_elements(i)*DeltZ(i-1)) / (DeltZ(i-1)+DeltZ(i));
    end
end