function [seconds_interval, hours_interval, days_interval] = calculate_time_interval(start_time, end_time)
    % 计算两个时间点之间的时间间隔，分别以秒、小时和天为单位
    % 输入:
    %   start_time: 起始时间，datetime类型
    %   end_time: 结束时间，datetime类型
    % 输出:
    %   seconds_interval: 时间间隔，以秒为单位，double类型
    %   hours_interval: 时间间隔，以小时为单位，double类型
    %   days_interval: 时间间隔，以天为单位，double类型

    % 检查输入是否为datetime类型
    if ~isa(start_time, 'datetime') || ~isa(end_time, 'datetime')
        error('输入必须为datetime类型');
    end
    
    % 计算时间间隔
    interval = end_time - start_time;
    
    % 将时间间隔转换为秒、小时和天
    seconds_interval = seconds(interval);
    hours_interval = hours(interval);
    days_interval = days(interval);
    
    % 输出结果
    disp(['时间间隔为: ', num2str(seconds_interval), ' 秒']);
    disp(['时间间隔为: ', num2str(hours_interval), ' 小时']);
    disp(['时间间隔为: ', num2str(days_interval), ' 天']);
end

