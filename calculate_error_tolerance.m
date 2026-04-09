function tolerance = calculate_error_tolerance(concentration, thresholds, tolerances)
    % 根据浓度值计算动态误差容差
    %
    % 输入参数:
    %   concentration : 当前浓度值，支持标量或数组 [mg/L]
    %   thresholds    : 浓度阈值数组，定义区间边界 [mg/L]，需单调递增
    %   % 定义：浓度≤10 → 容差0.1，10<浓度≤100 → 容差1，浓度>100 → 容差5
    %   tolerances     : 容差值数组，长度需比thresholds多1
    %                    （例如：thresholds=[10,100], tolerances=[0.1,1,5]）
    %
    % 输出参数:
    %   tolerance      : 对应浓度的容差值

    % 输入验证
    validateattributes(concentration, {'numeric'}, {'nonnegative'});
    validateattributes(thresholds, {'numeric'}, {'vector', 'increasing'});
    validateattributes(tolerances, {'numeric'}, {'vector', 'numel', numel(thresholds)+1});

    % 初始化容差为最大值（超出阈值区间的部分）
    tolerance = ones(size(concentration)) * tolerances(end);
 

    % 分段设置容差
    for i = 1:numel(thresholds)
        mask = concentration <= thresholds(i);    % 找到当前区间内的位置
        tolerance(mask) = tolerances(i);          % 设置对应容差
        concentration(mask) = Inf;               % 标记已处理部分
    end
end