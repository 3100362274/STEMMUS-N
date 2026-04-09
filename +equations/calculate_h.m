function Inith = calculate_h(Theta_s, Theta_r, InitX0, m, n, Alpha)
    % 计算每个节点的初始水头值
    % 输入参数：
    %   Theta_s: 饱和含水量向量（长度 NL）
    %   Theta_r: 残余含水量向量（长度 NL）
    %   InitX0: 初始含水量向量（长度 NL）
    %   m, n, Alpha: 模型参数向量（长度 NL）
    % 输出：
    %   Inith: 初始水头向量（长度 NL）
    
    if InitX0 >=Theta_s
        Inith = -1e-6;
    elseif InitX0 <=Theta_r
        Inith = -1e7;
    else
        % 分步计算公式中的各中间项
        term1 = (Theta_s - Theta_r) ./ (InitX0 - Theta_r+ eps);  % 分式项
        term2 = term1 .^ (1./m);           % 1/m 次幂
        term3 = term2 - 1;                 % 减去常数项
        term4 = term3 .^ (1./n);           % 1/n 次幂
        Inith = -term4 ./ Alpha;           % 最终水头计算
    end
end