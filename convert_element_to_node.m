function QL_nodes = convert_element_to_node(QL_elements, NL, NN, DeltZ)
    % 将单元量QL_elements [NLx1] 转换为节点量QL_nodes [NNx1]
    QL_nodes = zeros(NN, 1);
    
    % 边界节点
    QL_nodes(1) = QL_elements(1);       % 第一个节点 = 第一个单元的值
    QL_nodes(end) = QL_elements(end);  % 最后一个节点 = 最后一个单元的值
    
    % 内部节点：相邻单元的平均值
    for i = 2:NN-1
        QL_nodes(i) = (QL_elements(i-1)* DeltZ(i) + QL_elements(i)*DeltZ(i-1)) / (DeltZ(i-1)+DeltZ(i));
    end
end