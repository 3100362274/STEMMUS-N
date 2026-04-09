function JD0 = calculateJulianDay200th(year)
    % 基准年份和儒略日
    baseYear = 2000;
    baseJulianDay = 2451697.5;
    
    % 计算从基准年到目标年的年份差
    yearDifference = year - baseYear;
    
    % 计算间隔年份内的闰年数量
    leapDays = 0;
    for y = baseYear:(year-1)
        if mod(y, 4) == 0 && (mod(y, 100) ~= 0 || mod(y, 400) == 0)
            leapDays = leapDays + 1;
        end
    end
    
    % 计算第200天的儒略日
    JD0 = baseJulianDay + 365 * yearDifference + leapDays + 190;
end


