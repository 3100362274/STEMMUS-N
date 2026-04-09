% 定义变量
HUI1 = 0.18; % 替换为 HUI1 的实际值
HUI2 = 0.03; % 替换为 HUI2 的实际值
HUF1 = 0.60; % 替换为 HUF1 的实际值
HUF2 = 0.95; % 替换为 HUF2 的实际值

% 计算 ah2
fenzi_ah2 = log((-HUI2 * (HUF2 - 1)) / HUF2) - log((-HUI1 * (HUF1 - 1)) / HUF1);
fenmu_ah2 = HUI1 - HUI2;
ah2 = fenzi_ah2 / fenmu_ah2;

% 计算 ah1
ah1 = log((-HUI1 * (HUF1 - 1)) / HUF1) + ah2 * HUI1;

% 显示结果
disp(['ah2 的值为: ', num2str(ah2)]);
disp(['ah1 的值为: ', num2str(ah1)]);