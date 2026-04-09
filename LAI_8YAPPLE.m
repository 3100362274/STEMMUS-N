% 定义x的范围
x = linspace(1, 365, 365); % 可根据数据实际范围调整
for x = 1:365
% 公式1
if x <=161
y = 0.0001 * x.^2 - 0.0088 * x + 0.4378;
else
% 公式2
y = -2e-5 * x.^2 - 0.0054 * x + 4.0526;
end
end
% 绘制图像
figure;
hold on;
plot(x, y, 'r-', 'LineWidth', 2); % 公式1 - 红线


% 添加图例和标签
legend('y = 0.0001x^2 - 0.0088x + 0.4378', ...
       'y = 1e-6x^3 - 0.001x^2 + 0.2526x - 16.797', ...
       'Location', 'best');
xlabel('x');
ylabel('y');
title('回归方程图像');
grid on;
hold off;
