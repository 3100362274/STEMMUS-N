function Kc_correct = calculate_Kc_correct(Kc_table, u_2, RHmin, h_v, KT)
    % 修正中期作物系数，末期作物系数 Kc_mid
    % 当RH min 不等于 45%或风速 u2 大或小于 2m/s 的气候条件下 ，末期作物系数<0.45,不用修正
    % 输入参数:
    % Kc_table: 表中提供的 Kc_mid 值
    % u_2: 平均风速 (m/s) 用于 1m/s < u_2 < 6m/s
    % RH_min: 最小相对湿度 (%) 用于 20%< RH min <80%
    % h_v: 作物高度 (m) 用于 0.1<h_v<10m0.95
    %
    % 输出参数:
    % Kc_mid: 修正后的中期作物系数

    % 根据公式计算
    Kc_correct = Kc_table + (0.04 * (u_2(KT) - 2) - 0.004 * (RHmin(KT) - 45)) * (h_v(KT) / 3)^0.3;
end
