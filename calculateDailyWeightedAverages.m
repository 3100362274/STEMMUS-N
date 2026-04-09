function dailyResults = calculateDailyWeightedAverages(current_date, Sim_output)
    % Computes time-weighted daily averages preserving depth-time structure
    %
    % Inputs:
    %   current_date: datetime array (time stamps, size: 9957x1)
    %   Sim_output: struct containing depth profiles (size: 204x9957 for each field)
    %
    % Output:
    %   dailyResults: struct with fields (size: nDaysx1):
    %       - DDate: datetime
    %       - DSoilMoisture: 204x1 double (depth profile for that day)
    %       - DNitrateConc: 204x1 double
    %       - ... (other fields similarly with 'D' prefix)

    % 输入验证
    if nargin < 2
        error('必须提供 current_date 和 Sim_output 两个输入参数！');
    end
    if ~isdatetime(current_date)
        error('current_date 必须是 datetime 数组！');
    end
    if ~isstruct(Sim_output)
        error('Sim_output 必须是结构体！');
    end
    
    % 检查数据维度
    [nDepths, nTimes] = size(Sim_output.SoilMoisture);
    if length(current_date) ~= nTimes
        error('时间维度不匹配: current_date 长度=%d, 数据时间维度=%d',...
              length(current_date), nTimes);
    end

    % 获取唯一日期（天尺度）
    uniqueDates = unique(dateshift(current_date, 'start', 'day'));
    nDays = length(uniqueDates);

    % 初始化输出结构（按天存储，每字段保持深度维度）
    dailyResults = struct(...
        'DDate', cell(nDays, 1), ...
        'DPrecipitation', cell(nDays, 1), ...
        'DSoilMoisture', cell(nDays, 1), ...
        'DSoilTemp', cell(nDays, 1), ...
        'DAirPressure', cell(nDays, 1), ...
        'DAmmoniumConc', cell(nDays, 1), ...
        'DNitrateConc', cell(nDays, 1) ...
        );

    % 对每天计算各深度的加权平均
    for i = 1:nDays
        targetDate = uniqueDates(i);
        mask = (current_date >= targetDate) & (current_date < targetDate + days(1));
        
        if ~any(mask)
            continue;
        end
        
        % 计算时间权重（所有深度共用）
        dailyTimes = current_date(mask);
        timeDiffs = seconds(diff(dailyTimes));
        weights = zeros(length(dailyTimes), 1);
        
        if length(dailyTimes) == 1
            weights(1) = 1;
        else
            weights(1) = timeDiffs(1)/2;
            weights(end) = timeDiffs(end)/2;
            weights(2:end-1) = (timeDiffs(1:end-1) + timeDiffs(2:end))/2;
        end
        weights = weights / sum(weights);
        
        % 存储日期
        dailyResults(i).DDate = targetDate;
        
        % 处理每个字段（保持深度维度）
        fields = {'Precipitation','SoilMoisture', 'SoilTemperature','AirPressure', ...
                 'AmmoniumTotalConc','NitrateTotalConc'};
        outputFields = {'DPrecipitation','DSoilMoisture', 'DSoilTemp','DAirPressure',...
                       'DAmmoniumConc', 'DNitrateConc'};
        
        for f = 1:length(fields)
            % 提取当前字段数据（204xN）
            inputData = Sim_output.(fields{f})(:, mask);
            
            % 计算加权平均（沿时间维度，保持204行）
            weightedAvg = sum(inputData .* weights', 2);
            
            % 降雨量特殊处理
            if strcmp(fields{f}, 'Precipitation')
                weightedAvg = weightedAvg * 86400 * 10;
            end
            
            dailyResults(i).(outputFields{f}) = weightedAvg;
        end
    end
    
    % 移除空条目
    dailyResults = dailyResults(~cellfun(@isempty, {dailyResults.DDate}));
end