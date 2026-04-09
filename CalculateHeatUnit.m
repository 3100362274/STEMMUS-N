function [CHU_record, HU, HUI_record, DRDS_list, RDS_list, HUF, dHUF] = CalculateHeatUnit(Tmax, Tmin, sowing_day, T_b, PHU)

    % 确保 Tmax 和 Tmin 是列向量或同样长度的数组
    if length(Tmax) ~= length(Tmin)
        error('Tmax 和 Tmin 的长度必须相同');
    end
    
    % 计算总天数
    total_days = length(Tmax);

    % 初始化输出数据
    RDS = 0;
    HU = zeros(total_days, 1); % 每天的热量单位数组 °C
    CHU = 0;                  % 累积热量单位 °C
    CHU_record = zeros(total_days, 1); % 记录每个时间步的 CHU °C
    HUI_record = zeros(total_days, 1); % 记录每个时间步的 HUI 热量单元指数 °C
    DRDS_list = zeros(total_days, 1);  % 每日的 DRDS 增量
    RDS_list = zeros(total_days, 1);   % 累积的 RDS


    % 从播种日开始计算
    for DayNum = sowing_day:total_days
        % 计算当天的热量单位 (HU)
        HU(DayNum) = max(((Tmax(DayNum) + Tmin(DayNum)) / 2 - T_b), 0);

        % 计算作物出苗到成熟期间每日的相对生长发育阶段增量 DRDS
        DRDS = max(((Tmax(DayNum) + Tmin(DayNum)) / 2 - T_b) / PHU, 0);

        % 累加 RDS
        RDS = RDS + DRDS;

        % 保存 DRDS 和 RDS 的值
        DRDS_list(DayNum) = DRDS;
        RDS_list(DayNum) = RDS;

        % 更新累积热量单位 (CHU)
        CHU = CHU + HU(DayNum);

        % 记录累积热量单位
        CHU_record(DayNum) = CHU;

        % 计算热量单位指数 (HUI)
        HUI_record(DayNum) = CHU / PHU;
        HUF(DayNum) = HUI_record(DayNum) / (HUI_record(DayNum) + exp(7 - 29 * HUI_record(DayNum)));  
        % HUF(DayNum) = HUI_record(DayNum) / (HUI_record(DayNum) + exp(ah1 - ah2 * HUI_record(DayNum)));  
        if RDS >= 1.0
            % 作物成熟，停止循环
            break;
        end
    end
        dHUF = diff(HUF) ;

