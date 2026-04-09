function [Tsh,Tbh,Ts1] = CalculateTemperatureBoundary(Tav,At,Tm,Tao,LAI,Tot_Depth,Lambda_eff,c_unsat, ...
    start_time,end_time,Lambda_effBAR,c_unsatBAR,BCT,current_year,NL,KT,Ts1,Tb,SUMTIME)
    
    NoTime(KT)=fix(SUMTIME(KT)/3600/24);
    % 循环计算每一层的平均值
    for ML = 1 : NL
        Lambda_effBAR(ML) = mean(Lambda_eff(ML,:));
        c_unsatBAR(ML) = mean(c_unsat(ML,:));
    end
    
    % 计算所有层的总平均值
    Lambda_effAverage = mean(Lambda_effBAR);
    c_unsatAverage = mean(c_unsatBAR);


    % % 生成儒略日序列
    jd_series = generateJDSeries(start_time, end_time);
    %   计算儒略日和阻尼深度
    JD0 = calculateJulianDay200th(current_year);  % max tem of JD %长武191天
    De = (365  * 86400 * Lambda_effAverage / (pi() * c_unsatAverage))^0.5;

    % 如果当前时间小于持续时间
    % if TIME < DURTN
    %     NoTime(KT) = fix(TIME / 3600 / 24) + 1;
    % else
    %     NoTime(KT) = fix(TIME / 3600 / 24);
    % end 
    
        if NoTime(KT) <= 0
            Ts1(1) = BCT;
        else
            if Tm(NoTime(KT)) >= Ts1(NoTime(KT)+1 - 1)
                Ts1(NoTime(KT)) = Ts1(NoTime(KT)+1 - 1) + 0.25 * (Tm(NoTime(KT)) - Ts1(NoTime(KT)+1 - 1)) * exp(-Tao * LAI(KT));
            else
                Ts1(NoTime(KT)) = Ts1(NoTime(KT)+1 - 1) + 0.25 * (Tm(NoTime(KT)) - Ts1(NoTime(KT)+1 - 1));
            end
        end
    
        % 更新底部温度
        if NoTime(KT) <= 0
            Tb(1) = Tav(1) + At(1) * exp(-Tot_Depth / De)  * cos(2* pi() * (jd_series(1) - JD0) / 365 - (Tot_Depth / De));
        else
            Tb(NoTime(KT)+1) = Tav(1) + At(1) * exp(-Tot_Depth / De)  * cos(2* pi() * (jd_series(NoTime(KT)+1) - JD0) / 365 - (Tot_Depth / De));
        end
        if NoTime(KT) <= 0
            Tsh(KT) = Ts1(1);
            Tbh(KT) = Tb(1);
        else
            Tsh(KT) = Ts1(NoTime(KT)+1);
            Tbh(KT) = Tb(NoTime(KT)+1);
        end