 condition1 = (t < 0.264) | (t > 0.736);
    T_p_t(condition1) = 0.24 * T_p;

    % 第二段：0.264 ≤ t ≤ 0.736
    condition2 = (t >= 0.264) & (t <= 0.736);
    T_p_t(condition2) = 2.75 * T_p * sin(2*pi*t(condition2) - pi/2);

    % 输入总时间（秒），例如 1.2 天 = 103680 秒
totalSeconds = 86400*1.65; 

% 计算当前天数（从 1 开始）
currentDay = floor(totalSeconds / 86400) + 1;

% 计算当天内的剩余秒数
remainingSeconds = mod(totalSeconds, 86400);

% 转换为当天的小时数（含小数）
currentHour = remainingSeconds / 3600;

% 输出结果
disp(['当前是第 ', num2str(currentDay), ' 天']);
disp(['当天时间: ', num2str(currentHour), ' 小时']);

timeStep = 3600;   % 时间步长（秒）
numSteps = 30;     % 模拟 30 个时间步（即 30 小时）

% 初始化总秒数
totalSeconds = 0;

for i = 1:numSteps
    % 计算当前天数和小时
    currentDay = floor(totalSeconds / 86400) + 1;
    remainingSeconds = mod(totalSeconds, 86400);
    currentHour = remainingSeconds / 3600;
    
    % 输出当前时间状态
    disp(['时间步 ', num2str(i), ': 第 ', num2str(currentDay), ' 天，', num2str(currentHour), ' 小时']);
    
    % 累加时间步长
    totalSeconds = totalSeconds + timeStep;
end

% 参数设置
A = 0.2;           % 振幅（默认0.2，用户可调整）
phase_shift = 13;   % 温度峰值时间（小时）
overlap = 2;        % 平滑过渡的小时数

% 日均温度数据（示例）
T_days = [22.2000000000000
23.2500000000000
18.6500000000000
19.2500000000000];
num_days = length(T_days);

% 生成24小时形状函数（均值为1）
h = 0:23;
shape_function = 1 + A * sin(2*pi*(h - phase_shift)/24);

% 初始化小时温度数组
T_hours = zeros(1, num_days * 24);

% 填充小时温度
for day = 1:num_days
    start_idx = (day-1)*24 + 1;
    end_idx = day*24;
    T_hours(start_idx:end_idx) = T_days(day) * shape_function;
end

% 平滑天边界过渡
for day = 2:num_days
    prev_end_idx = (day-1)*24 - overlap + 1;
    prev_start_idx = (day-1)*24 - overlap + 1;
    next_start_idx = (day-1)*24 + 1;
    next_end_idx = (day-1)*24 + overlap;
    
    % 提取相邻天重叠部分
    prev_section = T_hours(prev_start_idx: (day-1)*24);
    next_section = T_hours(next_start_idx: next_end_idx);
    
    % 线性插值过渡
    interpolated = linspace(prev_section(1), next_section(end), 2*overlap);
    T_hours(prev_start_idx: (day-1)*24) = interpolated(1:overlap);
    T_hours(next_start_idx: next_end_idx) = interpolated(overlap+1:end);
end

% 时间步进循环示例
timeStep = 3600;    % 时间步长（秒）
totalSeconds = 0;   % 初始时间
numSteps = num_days * 24; % 模拟所有小时

for step = 1:numSteps
    % 计算当前天数和小时
    currentDay = floor(totalSeconds / 86400) + 1;
    remainingSeconds = mod(totalSeconds, 86400);
    currentHour = remainingSeconds / 3600;
    
    % 获取当前温度
    currentTemp = T_hours(step);
    
    % 输出结果
    fprintf('时间: 第 %d 天, %.1f 小时, 温度: %.2f°C\n', ...
            currentDay, currentHour, currentTemp);
    
    % 更新总时间
    totalSeconds = totalSeconds + timeStep;
end

% 可视化
figure;
plot(T_hours, 'LineWidth', 1.5);
xlabel('小时');
ylabel('土壤温度 (°C)');
title('小时尺度土壤温度（含平滑过渡）');
grid on;
xticks(0:24:num_days*24);


