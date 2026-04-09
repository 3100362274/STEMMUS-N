function [results] = InNitrogenConcentrationDistribute(SUMDELTZ, x_data, y_data)


% Your desired nodes (second list)
x_nodes = SUMDELTZ;
y_interp_liner = custom_interp(x_data, y_data, x_nodes);
y_interp_pchip = interp1(x_data, y_data, x_nodes, 'pchip', 0);
% yq = pchip(x_data, y_data, x_nodes);
results = [x_nodes,y_interp_liner,y_interp_pchip];
% 绘制原始数据和插值结果
% figure;
% plot(x_data, y_data, 'o', 'DisplayName', 'Original Data'); % 原始数据
% hold on;
% plot(x_nodes, y_interp, '-', 'DisplayName', 'Interpolated Data'); % 插值结果
% plot(x_nodes, y_interp2, '-b', 'DisplayName', 'Interpolated Data'); % 插值结果
% legend;
% xlabel('X-values');
% ylabel('Y-values');
% title('Linear Interpolation of Data with Custom Function');
% grid on;