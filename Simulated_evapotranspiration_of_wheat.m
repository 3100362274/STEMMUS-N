global NL NN  KT  Theta_LL EVAP Ta
global DURTN  LAI Tp_t Trap 
global H1 H2 H3 H4 alpha_h bx b1 b11 LR Lmax fr RL0 Srt Elmn_Lnth DeltZ RL TIME rwuef hh tRmed xRmed tRmin RG RDDF
global PT_PM_0 
global Rns r_a_SOIL Rn Rs Ra Rs0 e_a wt wc Srt_1 LAI_act 
global PME Nmsrmn n 
global rsuef cc SinkS AUptakeA SPUptake SAUptake SAUptakeP SAUptakeA SAUptakeAN pai dms_string
global TT evfi RHO_2 ps WSI Nno3 Nn JN Tot_Depth Coefficient_n Coefficient_Alpha Pa LAI
    % 初始设置
    run Constants.m
    run StartInit.m
    % KIT = 0;                      % KIT 用于计数时间步中的迭代次数
    % NIT = 100;                    % 时间步的理想迭代次数
    % Nmsrmn = 2447 * 10;           % 为了应对可能定义的长模拟周期，这里尽可能大
    % 
    % % 定义时间点
    % start_time = datetime(2019, 4, 14, 0, 0, 0);
    % end_time = datetime(2019, 10, 30, 0, 0, 0);
    % 
    % % 计算时间间隔
    % [seconds_interval, hours_interval, days_interval] = calculate_time_interval(start_time, end_time);
    % 
    % % 模拟参数设置
    % DURTN = seconds_interval;     % 模拟周期的持续时间
    % KT = 0;                       % 时间步数
    % TIME = 0;                     % 模拟开始的时间
    % TEND = TIME + DURTN;          % 模拟周期结束的时间
    % Delt_t = 3600;                % 时间步长（秒）
    % tS = DURTN / Delt_t;          % 需要的时间步数
    % 
    % % 初始化时间步数组
    % TimeStep = zeros(tS + 1, 1);
    % SUMTIME = zeros(tS + 1, 1);
    % Processing = zeros(tS + 1, 1);
    % 
    % % 初始化当前日期
    % current_date = start_time;
    % current_year = year(current_date);
    
    % 时间步循环
    for i = 1:tS + 1
        KT = KT + 1;                             % 更新时间步计数器
        if KT > 1 && Delt_t > (TEND - TIME)
            Delt_t = TEND - TIME;                % 调整最后一个时间步的时间
        end
        TIME = TIME + Delt_t;                    % 更新已过时间
        TimeStep(KT, 1) = Delt_t;                % 记录时间步
        SUMTIME(KT, 1) = TIME;                  % 记录累积时间
        Processing(KT, 1) = TIME / TEND;        % 计算处理进度
    
        % 更新当前日期和检查年份变化
        current_date = start_time + seconds(TIME);
        if month(current_date) == 1 && day(current_date) == 1 && KT > 1
            current_year = year(current_date); % 打印年份变更信息
        end
    
    
        % Set constants
        Gasphaseparameterconstants = CalculateEvapotranspiration.SetGasphaseparameterconstants();
    
        % Initialize arrays
        num_steps = length(JN);
        [DELTAA, ro_a, e0_Tmax, e0_Tmin, es, e_a, VPD, dr, delta, Ws, Ra, Rs0, Rs, Rns, Rnl, Rn, u_2, r_a_SOIL] = CalculateEvapotranspiration.initialize_arrays(num_steps);
    
        % Calculate air and radiation parameters
        for iN = 1:num_steps
            Tm(iN) = (Tmax(iN) + Tmin(iN)) / 2;  % Assuming Tm is the mean temperature
        end
        [DELTAA, ro_a, es, e_a, VPD, gama] = CalculateEvapotranspiration.calculate_air_parameters(Tm, Tmax, Tmin, RHa,RHmax,RHmin, Z, Gasphaseparameterconstants,num_steps);
        [dr, delta, Ws, Ra, Rs0, N, Rs, Rns, Rnl, Rn] = CalculateEvapotranspiration.calculate_radiation_parameters(JN, Gasphaseparameterconstants, e_a, Tmax, Tmin, dms_string,n,num_steps);
        [PT_PM_0] = CalculateEvapotranspiration.calculate_ET0(DELTAA, Rn, gama, es, e_a, u_2, Tm,num_steps);
        [PME] = CalculateEvapotranspiration.calculate_PME(DELTAA, Rn, gama, Gasphaseparameterconstants,num_steps);
        
        % Calculate LAI and evaporation (Pereira et al. 2015)
        AFTP_TIME=TIME/86400+9;   % 9 is the daynumber initial，第九天开始有植物;

        if AFTP_TIME<14
            LAI(KT)=0; % emergance daynumber is 8
        elseif AFTP_TIME<22
            LAI(KT)=(AFTP_TIME-14)*0.45/8; % emergance daynumber is 8
        else
            LAI(KT)=-0.0021*AFTP_TIME^2+0.299*AFTP_TIME-5.1074;
        end
        if LAI(KT)<0
            LAI(KT)=0;
        end
       
        LAI(KT)=LAI(KT);
        
        if LAI(KT)<=2
            LAI_act(KT)=LAI(KT);
        elseif LAI(KT)<=4
            LAI_act(KT)=2;
        else
            LAI_act(KT)=0.5*LAI(KT);
        end
    
        Tao = 0.56;  % Light attenuation coefficient
        % input data
        n(1)=Coefficient_n(1);
        Alpha(1)=Coefficient_Alpha(1);
        m(1)=1-1/n(1);
        Theta_LL_sur1(KT)=Theta_LL(NL,2);
        Theta_LL_sur2(KT)=Theta_LL(NL-12,2); %-14减的大概土层深度原来14是25cm,
        Theta_LL_sat(KT)=Theta_r(1)+(Theta_s(1)-Theta_r(1))/(1+abs(Alpha(1)*200)^n(1))^m(1);
        coef_e=0.8; % 0.8-1.0 Johns 1982, Kemp 1997 调参
        coef_p=2.15;  %2-2.3 调参
        Kcbmax=1.07;  %for maize 1.10, for wheat 1.07 (allen 2009;duchemin 2006) Apple 0.9 调参
        coef_kd=0.84;% 0.84 for wheat  the extinction coefficient 调参
        Kcb(KT)=Kcbmax*(1-exp(-coef_kd*LAI(KT))); % Duchemin et al. (2006)
        if TIME<DURTN
            DayNum=fix(TIME/3600/24)+1;
            t=TIME-(DayNum-1)*86400;
            ETp=0.1.*PME(1:num_steps);  % mm-->cm  
            ET=0.1.*PT_PM_0(1:num_steps);
            Ep(KT)=(exp(-1*(Tao*LAI(KT))))*ETp(DayNum);%土壤潜在蒸散发 Ritchie (1972)
            if hh(NN)>-1e5  %实际土壤蒸发
                if (Theta_LL_sur1(KT)/Theta_LL_sat(KT))>((Ep(KT)/coef_e)^0.5)
                    Es(KT)=Ep(KT);
                else
                    Es(KT)=coef_e*(Theta_LL_sur1(KT)/Theta_LL_sat(KT))^coef_p;
                end
            else
                Es(KT)=coef_e*((Theta_LL_sur1(KT)+Theta_LL_sur2(KT))/2/Theta_LL_sat(KT))^coef_p;
            end
            if t>0.264*24*3600 && t<0.736*24*3600
                Tp(KT)=Kcb(KT)*ET(DayNum); % Tao LAI set as constant
                Evap(KT)=(2.75*sin(2*pi()*t/3600/24-pi()/2)/86400)*Es(KT); % transfer to second value
                EVAP(KT,1)=Evap(KT);
                Tp_t(KT)=(2.75*sin(2*pi()*t/3600/24-pi()/2)/86400)*Tp(KT); % transfer to second value
                TP_t(KT,1)=Tp_t(KT);
            else
                Tp(KT)=Kcb(KT)*ET(DayNum); % Tao LAI set as constant
                %           Tp(KT)=(1-exp(-1*(Tao*LAI(KT))))*ET(DayNum); % Tao LAI set as constant
                Evap(KT)=(0.24/86400)*Es(KT); % transfer to second value
                EVAP(KT,1)=Evap(KT);
                Tp_t(KT)=(0.24/86400)*Tp(KT); % transfer to second value
                TP_t(KT,1)=Tp_t(KT);
            end
        else
            DayNum=fix(TIME/3600/24);
            t=TIME-(DayNum-1)*86400;
            ETp=0.1.*PME(1:num_steps);%土壤潜在蒸散发计算公式的一个系数
            ET=0.1.*PT_PM_0(1:num_steps); %作物参考蒸发
            Ep(KT)=(exp(-1*(Tao*LAI(KT))))*ETp(DayNum); %Ep=土壤潜在蒸散发
            %        Kcb(KT)=Kcbmax*(1-exp(coef_kd*LAI_act(KT)));
            if hh(NN)>-1e5
                if (Theta_LL_sur1(KT)/Theta_LL_sat(KT))>((Ep(KT)/coef_e)^0.5)
                    Es(KT)=Ep(KT);%Es=实际土壤蒸发 由三个阶段计算获得
                else
                    Es(KT)=coef_e*(Theta_LL_sur1(KT)/Theta_LL_sat(KT))^coef_p;
                end
            else
                Es(KT)=coef_e*((Theta_LL_sur1(KT)+Theta_LL_sur2(KT))/2/Theta_LL_sat(KT))^coef_p;
            end
            % generate E and T function with time
            if t>0.264*24*3600 && t<0.736*24*3600
                Tp(KT)=Kcb(KT)*ET(DayNum); % Tao LAI set as constant
                Evap(KT)=(2.75*sin(2*pi()*t/3600/24-pi()/2)/86400)*Es(KT); % transfer to second value
                EVAP(KT,1)=Evap(KT);
                Tp_t(KT)=(2.75*sin(2*pi()*t/3600/24-pi()/2)/86400)*Tp(KT); % transfer to second value
                TP_t(KT,1)=Tp_t(KT);
            else
                Tp(KT)=Kcb(KT)*ET(DayNum); % Tao LAI set as constant
                %           Tp(KT)=(1-exp(-1*(Tao*LAI(KT))))*ET(DayNum); % Tao LAI set as constant
                Evap(KT)=(0.24/86400)*Es(KT); % transfer to second value
                EVAP(KT,1)=Evap(KT);
                Tp_t(KT)=(0.24/86400)*Tp(KT); % transfer to second value
                TP_t(KT,1)=Tp_t(KT);
            end
        end
    end
