% function Penman_Monteith_model
% a one-step calculation of actual soil evaporation and potential transpiration by incorporating  canopy minimum surface resistance and actual soil resistance into the Penman–Monteith model.

%% 初始设置
    run Constants.m
    run StartInit.m
    
%% 时间步循环
    for i = 1:tS + 1 % for while 都可以，while适用于不确定循环次数，随时间动态变化
        % while TIME < TEND
        KT = KT + 1;                             % 更新时间步计数器
        if KT > 1 && Delt_t > (TEND - TIME)
            Delt_t = TEND - TIME;                % 调整最后一个时间步的时间
        end
        TIME = TIME + Delt_t;                    % 更新已过时间
        TimeStep(KT, 1) = Delt_t;                % 记录时间步
        SUMTIME(KT, 1) = TIME;                  % 记录累积时间
        Processing(KT, 1) = TIME / TEND;        % 计算处理进度
        if TIME<DURTN
            DayNum=fix(TIME/3600/24)+1;
        else
            DayNum=fix(TIME/3600/24);
        end
    
        % 更新当前日期和检查年份变化
        current_date = start_time + seconds(TIME);  % 根据秒数增加日期
        if month(current_date) == 1 && day(current_date) == 1 && KT > 1
            current_year = year(current_date);  % 获取当前年份
        end
    
        run Forcing_PARM.m
        [Rn,CHU_record,HUI_record,HU,SHRL_all_days,DRDS_list, RDS_list,LAI_daily,VPD,Evap,EVAP,Tp_t,TP_t,Resis_a,r_s_SOIL,r_s_VEG,r_a_VEG,Trap,Srt,f_min]= Evap_Cal_Pentext(DeltZ,TIME,RHOV,Ta,HR_a,U,Theta_LL,Ts, ...
    g,NL,NN,KT,hh,rwuef,TT,Srt,Tm,Tmax, Tmin,Theta_f, Theta_s,JN,n_act,h_v, ...
    rl_min,Z,dms_string,Lm,WSI,RG,evfi,Nmsrmn,Tot_Depth,rsuef,DayNum);
        run Evap_Cal_FAO.m
        Tao = 0.6;
    [Tsh,Tbh] = CalculateTemperatureBoundary(Tav,At,TIME,DURTN,Ta,Tao,LAI_daily,Tot_Depth,Lambda_eff,c_unsat, ...
    start_time,end_time,Lambda_effBAR,c_unsatBAR,BCT,current_year,NL,KT);
      sim_Tsh(KT) = Tsh (KT);  
      sim_Tbh(KT) = Tbh (KT);
    end
