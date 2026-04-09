function outputMatrices = extractDataToMatrices(dailyResults)
    % EXTRACTDATATOMATRICES Extract each field data into separate matrices
    %
    % Input:
    %   dailyResults: struct array with fields (size: nDaysx1)
    %
    % Output:
    %   outputMatrices: struct containing matrices with proper date formatting
    %   (all field names prefixed with 'D')

    % 获取天数
    nDays = length(dailyResults);
    nDepths = size(dailyResults(1).DSoilMoisture, 1); % 固定深度层数
    
    % 初始化输出结构
    outputMatrices = struct();
    
    % 提取日期数据并确保第一行有对应时间
    outputMatrices.DDates = [dailyResults.DDate];
    
    % 确保DDates是行向量
    if size(outputMatrices.DDates, 1) > 1
        outputMatrices.DDates = outputMatrices.DDates';
    end
    
    % 定义要提取的字段列表（与图片中的列标题对应）
    fieldNames = {'DPrecipitation', 'DSoilMoisture', 'DSoilTemp', ...
                 'DAirPressure', 'DAmmoniumConc', 'DNitrateConc'};
    
    % 为每个字段创建矩阵
    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};
        
        % 预分配矩阵
        outputMatrices.(fieldName) = zeros(nDepths, nDays);
        
        % 逐天提取数据
        for day = 1:nDays
            outputMatrices.(fieldName)(:, day) = dailyResults(day).(fieldName);
        end
    end
    
    % 创建包含日期和数据的完整表格（类似图片中的格式）
    outputMatrices.DTableFormat = createFormattedTable(outputMatrices);
end

function formattedTable = createFormattedTable(dataStruct)
    % 创建格式化表格，第一行包含日期
    % 所有字段名都带有'D'前缀
    
    nDays = length(dataStruct.DDates);
    nDepths = size(dataStruct.DSoilMoisture, 1);
    
    % 创建表头（所有字段名带'D'前缀）
    headers = {'DDepthLevel', 'DDate', 'DPrecipitation', 'DSoilMoisture', ...
               'DSoilTemp', 'DAirPressure', 'DAmmoniumConc', 'DNitrateConc'};
    
    % 预分配表格数据
    tableData = cell(nDepths * nDays, length(headers));
    
    % 填充表格数据
    rowIndex = 1;
    for day = 1:nDays
        currentDate = dataStruct.DDates(day);
        
        for depth = 1:nDepths
            tableData{rowIndex, 1} = depth; % DDepthLevel
            tableData{rowIndex, 2} = currentDate; % DDate
            tableData{rowIndex, 3} = dataStruct.DPrecipitation(depth, day);
            tableData{rowIndex, 4} = dataStruct.DSoilMoisture(depth, day);
            tableData{rowIndex, 5} = dataStruct.DSoilTemp(depth, day);
            tableData{rowIndex, 6} = dataStruct.DAirPressure(depth, day);
            tableData{rowIndex, 7} = dataStruct.DAmmoniumConc(depth, day);
            tableData{rowIndex, 8} = dataStruct.DNitrateConc(depth, day);
            
            rowIndex = rowIndex + 1;
        end
    end
    
    % 创建表格
    formattedTable = cell2table(tableData, 'VariableNames', headers);
end