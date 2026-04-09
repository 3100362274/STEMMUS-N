% 基准日期
base_date = datetime('2022-07-17');

% 目标日期列表
target_dates = [
    datetime('2022-10-20');
    datetime('2023-04-15');
    datetime('2023-07-20');
    datetime('2023-10-20')
];

% 计算天数差
days_diff = days(target_dates - base_date);

% 显示结果
disp('距离 2022-07-17 的天数：');
disp(table(target_dates, days_diff, 'VariableNames', {'日期', '天数差'}));