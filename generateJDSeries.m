function jd_series = generateJDSeries(start_time, end_time)
    % This function generates a series of Julian Dates for a given date range.
    % Inputs:
    %   startDate: [year, month, day] - Start date of the range
    %   endDate: [year, month, day] - End date of the range
    % Output:
    %   jd_series: Array of Julian Dates for each day in the range
    
    startJD = myDate2JD(year(start_time), month(start_time), day(start_time));
    endJD = myDate2JD(year(end_time), month(end_time), day(end_time));
    
    % Generating series of Julian Dates
    jd_series = startJD:endJD;
end


function JD = myDate2JD(y, m, d)
    % This function converts a Gregorian date to a Julian date.
    % Inputs:
    %   y: Year
    %   m: Month
    %   d: Day
    % Output:
    %   jd: Julian Date
    
    if m == 1 || m == 2
        m = m + 12;
        y = y - 1;
    end
    
    B = 0;
    if y > 1582 || (y == 1582 && m > 10) || (y == 1582 && m == 10 && d >= 15)
        B = 2 - floor(y / 100) + floor(y / 400);
    end
    
    JD = floor(365.25 * (y + 4712)) + floor(30.6 * (m + 1)) + d - 63.5 + B;
end
