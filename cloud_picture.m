%% 步骤1：生成日期序列
start_date = datetime(2022,7,17);
end_date = datetime(2025,12,30);
date_sequence = start_date : end_date; % 生成全日期序列

%% 步骤1：读取数据（假设数据已保存为CSV文件）
% 替换为你的实际文件路径
data = readmatrix('D:\Zhujizixingword\Modle Information\STEMMUS\DataOutput\Sim_output_NO3.csv'); 
data1 = Sim_output.NO3;
%% 步骤2：提取时间和深度信息
time = data(1:1263, 1);   % 第一列是时间（排除首列）
depth =[0;SUMDELTZ];  % 第一行是深度（排除首行）
Z = data1(:, :)';  % 中间是数值矩阵
% Z1=flip(Z);
%% 步骤3：检查数据范围（可选）
fprintf('数值范围: [%.2f, %.2f]\n', min(Z(:)), max(Z(:)));

%% 步骤4：创建热力图
figure('Position', [100 100 800 600]) % 设置图像大小

[X, Y] = meshgrid(time, depth);

%% 绘制热力图（使用pcolor）
pcolor(X, Y, Z)        % 转置Z矩阵以匹配维度

% time 向量 ➔ 对应 矩阵 Z 的列数
% depth 向量 ➔ 对应 矩阵 Z 的行数
% Z(i,j) 的值显示在坐标 (time(j), depth(i)) 处



% surf(X, Y, Z, ...               % 输入网格和数据
%     'EdgeColor', 'none', ...    % 关闭边缘线
%     'FaceColor', 'interp', ...  % 面颜色插值
%     'FaceLighting', 'none' ...  % 禁用光照（避免颜色失真）
% );
% view(2);                        % 俯视2D视图
% colormap(jet(256));             % 设置色阶
% 生成并反转色阶（以 jet 色阶为例）
% 定义颜色节点（位置范围0~1，对应数据范围的最小值到最大值）
% 设置数据范围（假设实际数据范围是0.15~0.40）
% 设置数据范围（与图中完全一致）
data_min = 0.18;
data_max = 380;

% 将数值标签转换为归一化位置（范围0~1）
value_labels = [ 0, 10, 50, 90,150, 200, 300, 400];
normalized_positions = (value_labels - data_min) / (data_max - data_min);

% 定义颜色节点（RGB值需匹配图中的红、橙、黄、绿、青、蓝、深蓝）
colors = [
    1 0 0;       % 红 (0.15)
    1 0.5 0;     % 橙 (0.19)
    1 1 0;       % 黄 (0.23)
    0 1 0;       % 绿 (0.27)
    0 1 1;       % 青 (0.31)
    0 0 1;       % 蓝 (0.35)
    0 0 0.5;     % 深蓝 (0.39)
    0 0 0.5;     % 深蓝 (0.40)
];

% 生成颜色映射（线性插值）
custom_colormap = interp1(normalized_positions, colors, linspace(0, 1, 256));
colormap(custom_colormap);
clim([data_min, data_max]); % 绑定数据范围



% clim([0.11, 500]);        % 设置颜色范围（替换为你的数据范围）
shading interp;                 % 颜色插值平滑
colorbar;
set(gca, 'YDir', 'reverse');
%% 步骤3：设置日期坐标轴（关键代码）
ax = gca;

% 获取所有月份首日日期
month_starts = unique(dateshift(date_sequence, 'start', 'month'));

% 转换为数值坐标（天数差）
month_start_num = days(month_starts - start_date) + 1; % +1对应time=1是2019-09-02

% 设置主刻度（每月首日）
ax.XTick = month_start_num;

% 设置刻度标签（格式：YYYY-MM）
ax.XTickLabel = datestr(month_starts, 'mmm-yyyy'); % 例："Sep-2019"

% 添加次刻度（每月15日）
month_mid_num = month_start_num + days(dateshift(month_starts, 'end', 'month') - month_starts)/2;
ax.XAxis.MinorTick = 'on';
ax.XAxis.MinorTickValues = month_mid_num;

%% 步骤4：优化显示
xlabel('')
ax.XAxis.Label.String = '时间 (2019-09-02 至 2020-12-31)';
ylabel('深度')
title('按月标注的时间-深度热力图')

% 防止标签重叠
ax.XAxis.TickLabelRotation = 45;
ax.XAxis.TickLabelInterpreter = 'none';
ax.XAxis.MinorTickValues = month_mid_num; % 显示次要刻度

% hold on
% plot(month_start_num, zeros(size(month_start_num)), 'r|', 'MarkerSize', 20) % 标红主刻度线