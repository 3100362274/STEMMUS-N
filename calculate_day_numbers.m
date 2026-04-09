function dateAndDayNumbers = calculate_day_numbers(start_time, end_time)
    % calculate_day_numbers 计算从起始日期到截止日期期间的所有天数的日序数
    %
    % 输入:
    %   startDate - 起始日期，格式为 [年, 月, 日]
    %   endDate - 截止日期，格式为 [年, 月, 日]
    %
    % 输出:
    %   dateAndDayNumbers - 包含所有日期和对应日序数的表格

    % 将起始日期和截止日期转换为 datetime 对象
    % start_time = datetime(startDate(1), startDate(2), startDate(3));
    % end_time = datetime(endDate(1), endDate(2), endDate(3));

    % 计算起始日期和截止日期之间的所有日期
    allDates = start_time:end_time;

    % 初始化日序数数组
    dayNumbers = zeros(length(allDates), 1);

    % 计算每个日期的日序数
    for i = 1:length(allDates)
        currentDate = allDates(i);
        yearVal = year(currentDate);
        monthVal = month(currentDate);
        dayVal = day(currentDate);
        dayNumbers(i) = day_of_year(monthVal, dayVal, yearVal);
    end

    % 创建输出表格，包含日期和对应的日序数
    dateAndDayNumbers = table(allDates', dayNumbers, 'VariableNames', {'Date', 'DayNumber'});
end

function J = day_of_year(M, D, year)
    % day_of_year 计算某月某天在一年中的日序数
    %
    % 输入:
    %   M - 月份 (1-12)
    %   D - 天数 (1-31)
    %   year - 年份 (例如 2023)
    %
    % 输出:
    %   J - 日序数 (1-366)

    % 计算初始日序数
    J = floor(275 * M / 9 - 30 + D) - 2;

    % 如果月份小于3，则调整日序数
    if M < 3
        J = J + 2;
    end

    % 检查是否是闰年
    if is_leap_year(year) && M > 2
        J = J + 1;
    end
end

function is_leap = is_leap_year(year)
    % is_leap_year 检查是否是闰年
    %
    % 输入:
    %   year - 年份 (例如 2023)
    %
    % 输出:
    %   is_leap - 布尔值，true 表示闰年，false 表示平年

    if mod(year, 4) == 0
        if mod(year, 100) == 0
            if mod(year, 400) == 0
                is_leap = true;
            else
                is_leap = false;
            end
        else
            is_leap = true;
        end
    else
        is_leap = false;
    end
end
