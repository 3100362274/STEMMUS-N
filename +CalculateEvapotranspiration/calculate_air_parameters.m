function [DELTAA, ro_a, es, e_a, VPD, gama, Pa, RHmin] = calculate_air_parameters(Tm, Tmax, Tmin, RHa,RHmax,RHmin, Z, Gasphaseparameterconstants,num_steps)  
    for iN = 1:num_steps
    % compute DELTA - SLOPE OF SATURATION VAPOUR PRESSURE CURVE
    % [kPa.?C-1] FAO56 pag 37 Eq13
    DELTAA(iN) = 4098 * (0.6108 * exp(17.27 * Tm(iN) / (Tm(iN) + 237.3))) / (Tm(iN) + 237.3)^2;
    
    % ro_a - MEAN AIR DENSITY AT CONSTANT PRESSURE [kg.m-3] FAO56 pag26 box6
    % Pa [kpa]
    Pa=101.3*((293-0.0065*Z)/293)^5.26;
    ro_a(iN) = Pa / (Gasphaseparameterconstants.R * 1.01 * (Tm(iN) + 273.16));
    
    % compute es - saturation vapour pressure at actual air temperature
    % [kPa] FAO56 pag30 Eq11
    e0_Tmax(iN) = 0.6108 * exp(17.27 * Tmax(iN) / (Tmax(iN) + 237.3));
    e0_Tmin(iN) = 0.6108 * exp(17.27 * Tmin(iN) / (Tmin(iN) + 237.3));
    es(iN) = (e0_Tmax(iN) + e0_Tmin(iN)) / 2;

    % compute e_a - ACTUAL VAPOUR PRESSURE [kPa] FAO56 pag31 Eq17
    if exist('RHmax', 'var') && exist('RHmin', 'var') && ~isempty(RHmax(iN)) && ~isempty(RHmin(iN)) ...
            && RHmax(iN) ~= 0 && RHmin(iN) ~= 0
        % 使用第一个公式，当 RHmax 和 RHmin 都存在且不为 0 时
        e_a(iN) = (e0_Tmin(iN) * (RHmax(iN) / 100) + e0_Tmax(iN) * (RHmin(iN) / 100)) / 2;
    else
        % 使用第二个公式，当 RHmax 或 RHmin 为 0 时
        e_a(iN) = (RHa(iN) / 100) * es(iN);
        %Tdew、Tmax 分别是中期阶段平均露点温度和平均最高日气温。在露点温度或其它表示湿润性 的数据短缺或精度低的地方RH min 用日平均最小气温 Tmin 替换 Tdew 计算。那么:
        RHmin(iN) = e0_Tmin(iN) ./  e0_Tmax(iN)*100;
    end
    
    % VPD - Water vapor pressure difference [kPa]
    VPD(iN) = es(iN) - e_a(iN);
   
    % gama - Hygrometer constant [kPa.?C-1] FAO56 pag31 eq8
    gama = 0.0016286 * Pa / Gasphaseparameterconstants.lambdav;
    end
end
