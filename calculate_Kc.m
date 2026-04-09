function Kci = calculate_Kc(Kc_prev, Kc_next, JN, sowing_day, L_stage, L_prev_sum, KT)
    % Kci: 当前天数的作物系数
    % Kc_prev: 当前阶段的初始作物系数
    % Kc_next: 下一个阶段的初始作物系数
    % i: 当前阶段的天数 (1 到 L_stage)
    % L_stage: 当前阶段的总长度（天）
    % L_prev_sum: 所有前阶段的总长度（天）

    % 按照公式 (66) 计算 Kci
    Kci = Kc_prev + (((JN(KT) - sowing_day) - L_prev_sum) / L_stage) * (Kc_next - Kc_prev);
end