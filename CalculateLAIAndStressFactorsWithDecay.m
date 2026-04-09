function [LAI_daily,f_min] = CalculateLAIAndStressFactorsWithDecay(HU, CHU_record, GMHU, XLAI ...
    , dHUF, Tm, T_b, T_op, UN, UNO, Theta_LL, Theta_f, Theta_s, C_f, ...
    SHRL_all_days, HUI_record, HUI_D, beta, sowing_day, NL, hh, DeltZ, DayNum)

    % 初始化 LAI
    total_days = length(HU);  % 假设 HU、CHU 都是相同天数的数据
    LAI_daily = zeros(total_days, 1);  % 初始化 LAI 数组
    LAI_prev = 0;  % 初始时刻的叶面积指数
    LAI_D = 0;     % 初始化 LAI_D，为后续赋值
    Theta_ff = 0;
    Theta_ss = 0;

    % 初始化胁迫因子记录
    f_T = zeros(total_days, 1);     % 温度胁迫因子
    f_nut = zeros(total_days, 1);   % 养分胁迫因子
    f_wd = zeros(total_days, 1);    % 通风胁迫因子
    f_min = zeros(total_days, 1);   % 最小胁迫因子
    f_theta = zeros(total_days, 1); % 水分胁迫因子
    Theta_LL_100 = zeros(total_days, 1); 

    % 循环计算每个时间步的 LAI 和胁迫因子
    if DayNum >= sowing_day
        for k = sowing_day:total_days
            % 计算温度胁迫因子 f_T
            R_T = (Tm(k) - T_b) / (T_op - T_b);
            if R_T >= 0 && R_T <= 2
                f_T(k) = sin(1.5707 * R_T);
            else
                f_T(k) = 0;  % 如果 R_T 超出范围，温度胁迫因子为 0
            end
            % 计算养分胁迫因子 f_nut
            S_N = 200 * (UN / UNO);
            f_nut(k) = S_N / (S_N + exp(4.065 - 0.0535 * S_N));

            % 计算通风胁迫因子 f_wd
            for ML=34:NL
                Theta_LL_100(k)=Theta_LL_100(k)+(Theta_LL(ML,1)+Theta_LL(ML,2))/2*DeltZ(ML);
                Theta_ff=Theta_ff+(Theta_f(ML)*DeltZ(ML));
                Theta_ss=Theta_ss+(Theta_s(ML)*DeltZ(ML));
            end
            S_AT =  (((Theta_LL_100(k) - Theta_ff) / (Theta_ss - Theta_ff)) - C_f )/ (1 - C_f);
            if S_AT > 0
                f_wd(k) = 1-(S_AT / (S_AT + exp(2.901 - 0.0387 * S_AT)));
            else
                f_wd(k) = 1.0;  % 如果 S_AT 小于或等于 0，通风胁迫因子为 1.0
            end
            % 水分胁迫因子 f_theta water stress function parameters
           H1=-10;H2=-35;H4=-8000;H3=-900; 
            % h1为饱和土壤中厌氧状态下的水势(通常为0);h2为氧气胁迫的临界水势;
            % h4为植物枯萎状态的临界水势。h3为h3为水分胁迫的临界水势
            % piecewise linear reduction function
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    if hh(MN) >= H1
                        alpha_h(ML,ND) = 0;
                    elseif hh(MN) > H2
                        alpha_h(ML,ND) = (hh(MN)-H1)/(H2-H1);
                    elseif hh(MN) >= H3
                        alpha_h(ML,ND) = 1;
                    elseif hh(MN) > H4
                        alpha_h(ML,ND) = (hh(MN)-H4)/(H3-H4);
                    else
                        alpha_h(ML,ND) = 0;
                    end
                end
                % If DeltZ(ML) is the thickness of the ML-th soil layer:
                f_theta(k) = f_theta(k) + (alpha_h(ML,1) + alpha_h(ML,2)) / 2 * DeltZ(ML);
            end
            % Normalize by the total thickness of the soil layers:
            f_theta(k) = f_theta(k) / sum(DeltZ(1:NL));

            % 计算最小胁迫因子 f_min
            f_min(k) = min([f_T(k), f_nut(k), f_wd(k), f_theta(k)]);
            % 判断累积热量 CHU 是否大于 GMHU (叶面积指数达到最大值时的热量单元)
            if CHU_record(k) > GMHU
                % 如果当前 HUI 大于 HUI_D，开始衰减
                if HUI_record(k) > HUI_D
                    if LAI_D == 0
                        % 记录 LAI_D 为衰减开始时的最大 LAI 值
                        LAI_D = LAI_prev;
                    end
                    % 使用公式进行衰减计算
                    LAI_daily(k) = LAI_D * ((1.0 - HUI_record(k)) / (1.0 - HUI_D))^beta;
                else
                    if k ==1 
                      LAI_daily(k) = LAI_prev;
                    else
                    % 如果尚未达到 HUI_D，继续正常增长
                      LAI_daily(k) = LAI_prev + dHUF(k-1) * XLAI * sqrt(f_min(k)) * SHRL_all_days(k) ;
                      LAI_prev = LAI_daily(k);  % 更新前一天的 LAI
                    end 
                end
            else
                % 当 CHU <= GMHU 时，没有破土
                LAI_daily(k) = 0;
                LAI_prev = LAI_daily(k);
            end
            LAI_daily(k) = max(0, LAI_daily(k));
        end
    end


