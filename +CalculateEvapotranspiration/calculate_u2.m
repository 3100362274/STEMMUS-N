function u_2 = calculate_u2(u_z_m, z_m)
    % calculate_u2 计算 u_2 给定的 u_z_m 和 z_m
    %
    % 输入:
    %   u_z_m - 参考高度 z_m 处的风速 (m/s)
    %   z_m - 参考高度 (m)
    %
    % 输出:
    %   u_2 - 2米高度处的风速 (m/s)

    % 计算 2米高度处的风速
    u_2 = u_z_m * 4.87 / log(67.8 * z_m - 5.42);
end
