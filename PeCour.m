function [Peclet, wc, Courant, PECR] = PeCour( lUpW , Disp, NL, Theta_LL, QL_nodes, DeltZ, Delt_t, vv, vv1, wc, Peclet, Retard)
% 计算局部Peclet和Courant数，并确定时间步长限制
% 输入参数与原始Fortran代码对应，输出更新后的参数


Courant=0;
% CourMax=1;

    % 定义双曲正切函数（与Fortran中数学等效）
    TanH = @(z) (exp(z) - exp(-z)) ./ (exp(z) + exp(-z));
    
    for ML = 1 : NL
        for ND = 1 : 2
            DD(ML, ND) = Disp(ML, ND) ./ Theta_LL(ML, ND);
        end
    end
    DDBAR = mean(DD,2);
    
    for ML = 1 : NL
        node_left = ML;          % 左节点
        node_right = ML + 1;     % 右节点
        if Theta_LL(ML, 1) > 1e-6 && Theta_LL(ML, 2) > 1e-6
            vv(ML) = (abs(QL_nodes(node_left))/ Theta_LL(ML, 1)  + abs(QL_nodes(node_right))/ Theta_LL(ML, 2) ) / 2; % 绝对流速平均
            vv1(ML) = (QL_nodes(node_left)/Theta_LL(ML, 1) + QL_nodes(node_right)/Theta_LL(ML, 2)) / 2;          % 实际流速平均（含方向）
        end
    end

    Pec(1:NL,1) = 99999;   % 初始Peclet数
    % dtMax = 1e30;  % 最大允许时间步长
    for ML = 1 : NL
        node_left = ML;          % 左节点
        node_right = ML + 1;     % 右节点
        vMax(ML) = (abs(QL_nodes(node_left)) + abs(QL_nodes(node_right))) / (Theta_LL(ML, 1) + Theta_LL(ML, 2)); % 最大特征速度
        RMin(ML) = min(Retard(ML, 1), Retard(ML, 2));         % 最小延迟因子
    end
    % 计算Peclet和Courant数
    for  ML = 1 : NL
        if DDBAR(ML) > 0
            Pec(ML) = abs(vv(ML)) * DeltZ(ML) / DDBAR(ML);  % Peclet数定义（对流/扩散比）
        end
    end
    Peclet = max(Peclet, Pec);
    
    for  ML = 1 : NL
        Cour(ML) = vMax(ML) * Delt_t / DeltZ(ML) /  RMin(ML); % Courant数定义（时间步稳定性）
    end
    % 更新全局最大值
   
    % 计算时间步长限制（CFL条件）  只有在中心差分和向前差分才考虑
    Courant = max(Courant, Cour');
    PECR = Courant.*Peclet;
    % % 确定Courant限制
    % Cour1 = CourMax;
    % if ~lUpW && ~lArtD
    %     for  ML = 1 : NL
    %         if Pec(ML) ~= 99999
    %             Cour1(ML) = min(1, PeCr / max(0.5, Pec(ML))); % Peclet相关限制
    %         end
    %     end
    % end
    % if epsi < 1 && vMax > 1e-20
    %     dtMax = Cour1 .* DeltZ .* RMin ./ vMax;
    % end
    % DtMax = max(dtMax);
    % dtMaxC = min(dtMaxC, dtMax); % 更新全局时间步限制
    if lUpW  == 1
         Pe2(1 :NL) = 11; % 初始Pe2值
        for ML =1 :NL
            % 上游加权因子计算（迎风格式）
            if DDBAR(ML) > 0
                Pe2(ML) = DeltZ(ML) * vv1(ML) / DDBAR(ML) / 2; % 网格Peclet数
            end
        end
        for ML =1 : NL
            if abs(vv(ML)) < 1e-30
                wc(ML) = 0;
            elseif abs(Pe2(ML)) > 10
                % 强对流主导时完全上游加权
                wc(ML) = sign(vv1(ML)); % +1或-1
            else
                % 混合格式（指数型权重）  (exp(z) - exp(-z)) ./ (exp(z) + exp(-z))
                wc_tmp(ML)  = 1/TanH(Pe2(ML)) - 1/Pe2(ML);
                wc(ML) = max(-1, min(1, wc_tmp(ML))); % 限制在[-1,1]区间
            end
        end
    end
end


