% 定义实际的每日平均温度数据和 LAI 测量数据
T_avg = [10, 12, 15, 17, 20, 22, 25, 28, 26, 24, 21, 19, 18, 17, 15];  % 每日平均温度数据
T_base = 8;  % 基准温度，例如 8°C
LAI_actual = [0.5, 1.2, 2.8, 4.5, 6.0, 5.5, 4.0, 2.5, 1.0, 0.8, 0.6, 0.5, 0.3, 0.2, 0.1];  % 实际的 LAI 数据

% 计算每日的积温
daily_GDD = max(0, T_avg - T_base);  % 每日有效积温
T_cumulative = cumsum(daily_GDD);  % 累积积温

% 保证 T_cumulative 和 LAI_actual 长度一致  
if length(T_cumulative) > length(LAI_actual)
    T_cumulative = T_cumulative(1:length(LAI_actual));  % 截断积温数据
end

% 定义 Baret 模型公式
baretModel = @(params, T) params(1) * (1 ./ (1 + exp(-params(2)*(T - params(3)))) - exp(-params(4)*(T - params(5))));

% 定义目标函数，最小化预测的 LAI 与实际 LAI 之间的平方误差
objectiveFunction = @(params) sum((baretModel(params, T_cumulative) - LAI_actual).^2);

% 设置初始参数猜测值 [LAI_Amp, b, T_i, a, T_s]
initialGuess = [max(LAI_actual), 0.1, 25, 0.1, 30];  % 初始猜测参数

% 设置优化选项，增大最大函数计算次数和迭代次数
options = optimset('MaxFunEvals', 1000, 'MaxIter', 1000, 'Display', 'iter');  % 增加迭代次数和函数评估次数，并显示迭代过程

% 使用 fminsearch 进行参数优化，最小化误差
optimalParams = fminsearch(objectiveFunction, initialGuess, options);

% 提取最优参数
LAI_Amp_opt = optimalParams(1);
b_opt = optimalParams(2);
Ti_opt = optimalParams(3);
a_opt = optimalParams(4);
Ts_opt = optimalParams(5);

% 输出最优参数值
fprintf('最优参数 LAI_Amp = %.4f\n', LAI_Amp_opt);
fprintf('最优参数 b = %.4f\n', b_opt);
fprintf('最优参数 T_i = %.4f\n', Ti_opt);
fprintf('最优参数 a = %.4f\n', a_opt);
fprintf('最优参数 T_s = %.4f\n', Ts_opt);

% 使用优化后的参数计算预测的 LAI
LAI_predict = baretModel(optimalParams, T_cumulative);

% 计算拟合的均方误差 MSE
MSE = mean((LAI_actual - LAI_predict).^2);
fprintf('均方误差 MSE = %.4f\n', MSE);

% 计算决定系数 R^2
SS_res = sum((LAI_actual - LAI_predict).^2);  % 残差平方和
SS_tot = sum((LAI_actual - mean(LAI_actual)).^2);  % 总平方和
R_squared = 1 - (SS_res / SS_tot);
fprintf('R^2 = %.4f\n', R_squared);

% 绘制预测值与实际值对比图
figure;
plot(T_cumulative, LAI_actual, 'bo-', 'MarkerSize', 8, 'DisplayName', '实际 LAI');
hold on;
plot(T_cumulative, LAI_predict, 'r-', 'LineWidth', 2, 'DisplayName', '预测 LAI');
xlabel('累积积温 T');
ylabel('LAI');
legend('show');
grid on;
title('LAI 预测值与实际值对比');
% 在图上显示 MSE 和 R^2

% 选择一个合适的位置显示文本，例如在图的右上角
x_pos = min(T_cumulative) + 0.2 * (max(T_cumulative) - min(T_cumulative));  % 位置偏向左侧
y_pos = max(LAI_actual) - 0.1 * (max(LAI_actual) - min(LAI_actual));        % 位置偏向顶部

% 在图上显示 MSE 和 R² 值
text(x_pos, y_pos, sprintf('MSE = %.4f\nR^2 = %.4f', MSE, R_squared), 'FontSize', 12, 'BackgroundColor', 'w', 'EdgeColor', 'k');