function Kcmax = calculate_Kcmax(u2, RH_min, h , Kcb)
    % 计算 Kcmax 的值
    %
    % 输入:
    %   u2 - 风速 (m/s)
    %   RH_min - 最小相对湿度 (%)
    %   h - 作物平均最大高度 (m) apple:4m
    %   Kcb - 基础作物系数 0.9
    %
    % 输出:
    %   Kcmax - 最大作物系数

    % 计算第一个部分
    part1 = 1.2 + (0.04 * (u2 - 2) - 0.004 * (RH_min - 45))*(h / 3)^0.3 ;
  
    % 计算第二个部分
    part2 = (Kcb + 0.05);
    
    % 计算 Kcmax
    Kcmax = max(part1, part2);
end
