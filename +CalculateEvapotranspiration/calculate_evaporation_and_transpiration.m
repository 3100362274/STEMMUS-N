function [EVAP,Tp_t,Scf] = calculate_evaporation_and_transpiration(TIME, JN, KT, NL, Theta_LL, ...
    PT_PM_0, PME, LAI,num_steps,Coefficient_n,Coefficient_Alpha,Theta_r,Theta_s,NN,hh,Tao,u_2,RHmin,h_v,DURTN, Tm, Ts_msr, g, RHa,  RHOV,SUMTIME,sowing_day)

    coef_e=0.9;    % 0.8-1.0 Johns 1982, Kemp 1997 0.68
    coef_p=2.15;   %2-2.3 2.5
    % Kcbmax=0.95;   %for maize 1.10, for wheat 1.07 (allen 2009;duchemin 2006) Apple0.9
    % coef_kd=-0.56; %-0.84 for wheat between  
    nn(1)=Coefficient_n(1);
    Alphaa(1)=Coefficient_Alpha(1);
    mm(1)=1-1/nn(1);
    Theta_LL_sur1(KT)=Theta_LL(NL,2);
    Theta_LL_sur2(KT)=Theta_LL(NL-14,2);
    Theta_LL_sat(KT)=Theta_r(NL)+(Theta_s(NL)-Theta_r(NL))/(1+abs(Alphaa(1)*200)^nn(1))^mm(1);
    % Kcb(KT)=Kcbmax*(1-exp(coef_kd*LAI(KT)));
    Scf(KT) = 1-exp(-Tao*LAI(KT)); %植被的土壤覆盖比例
 
    NoTime(KT)=fix(SUMTIME(KT)/3600/24);
    DayHour(KT) = mod(SUMTIME(KT) / 3600 / 24 , 1) ;
    ET = 0.1 * PT_PM_0(1:num_steps);      % 作物参考蒸发
           
    % 根据不同作物要进行修改生长期时间，生长期的Kc值，判断需不需要修正
    if NoTime(KT) <= 0
        if JN(1) < 100 % 休眠期
            Kc(KT) = 0.15;
        elseif JN(1) <= 125 % 生长初期
            Kc(KT) = 0.5;
        elseif JN(1) <= 157 % 快速生长期
            if RHmin(1) == 0.45 || u_2(1) == 2
                Kc_mid_correct(KT) = 1.2;
            else
                Kc_mid_correct(KT) = calculate_Kc_correct(1.2, u_2, RHmin, h_v, 1);
            end
            Kc(KT) = calculate_Kc(0.5, Kc_mid_correct(KT), JN, 100, 32, 25, 1);
        elseif JN(1) <= 244 % 生长中期
            if RHmin(1) == 0.45 || u_2(1) == 2
                Kc(KT) = 1.2;
            else
                Kc(KT) = calculate_Kc_correct(1.2, u_2, RHmin, h_v, 1);
            end
            % Kc(KT) = 1.2;
        elseif JN(1) <= 300 % 生长末期
            if RHmin(1) == 0.45 || u_2(1) == 2
                Kc_end_correct(KT) = 0.95;
            else
                Kc_end_correct(KT) = calculate_Kc_correct(0.95, u_2, RHmin, h_v, 1);
            end
            Kc(KT) = calculate_Kc(1.2, Kc_end_correct(KT), JN, 100, 56, 144, 1);
        else % 休眠期
            Kc(KT) = 0.15;
        end
        ETa(KT) = Kc(KT)*ET(1);
        if  ETa(KT) <= 0
            ETa(KT) = 0;
        end
    else
        if JN(NoTime(KT)+1) < 100 % 休眠期
            Kc(KT) = 0.15;
        elseif JN(NoTime(KT)+1) <= 125 % 生长初期
            Kc(KT) = 0.5;
        elseif JN(NoTime(KT)+1) <= 157 % 快速生长期
            if RHmin(NoTime(KT)+1) == 0.45 || u_2(NoTime(KT)+1) == 2
                Kc_mid_correct(KT) = 1.2;
            else
                Kc_mid_correct(KT) = calculate_Kc_correct(1.2, u_2, RHmin, h_v, NoTime(KT)+1);
            end
            Kc(KT) = calculate_Kc(0.5, Kc_mid_correct(KT), JN, 100, 32, 25, NoTime(KT)+1);
        elseif JN(NoTime(KT)+1) <= 244 % 生长中期
            if RHmin(NoTime(KT)+1) == 0.45 || u_2(NoTime(KT)+1) == 2
                Kc(KT) = 1.2;
            else
                Kc(KT) = calculate_Kc_correct(1.2, u_2, RHmin, h_v, NoTime(KT)+1);
            end
            % Kc(KT) = 1.2;
        elseif JN(NoTime(KT)+1) <= 300 % 生长末期
            if RHmin(NoTime(KT)+1) == 0.45 || u_2(NoTime(KT)+1) == 2
                Kc_end_correct(KT) = 0.95;
            else
                Kc_end_correct(KT) = calculate_Kc_correct(0.95, u_2, RHmin, h_v, NoTime(KT)+1);
            end
            Kc(KT) = calculate_Kc(1.2, Kc_end_correct(KT), JN, 100, 56, 144, NoTime(KT)+1);
        else % 休眠期
            Kc(KT) = 0.15;
        end
        ETa(KT) = Kc(KT)*ET(NoTime(KT)+1);
        if  ETa(KT) <= 0
            ETa(KT) = 0;
        end
    end

    Evap(KT)=(exp(-1*(Tao*LAI(KT))))*ETa(KT);%土壤蒸发
    Tp(KT)=(1-exp(-1*(Tao*LAI(KT))))*ETa(KT);%土壤蒸腾
     

    % if hh(NN)>-1e5
    %     if (Theta_LL_sur1(KT)/Theta_LL_sat(KT))>((Evap(KT)/coef_e)^0.5) % 含水量的值比较多，应该是向下的总体，所以是潜在蒸发
    %         Es(KT)=Evap(KT);
    %     else
    %         Es(KT)=coef_e*(Theta_LL_sur1(KT)/Theta_LL_sat(KT))^coef_p; % 含水量减少 ，取决于表层的向上速率
    %     end
    % else  % 比他小说明含水量几乎为0 ，等于一个表层的含水量比率值，exfiltration rate
    %     Es(KT)=coef_e*((Theta_LL_sur1(KT)+Theta_LL_sur2(KT))/2/Theta_LL_sat(KT))^coef_p;
    % end


    if  DayHour(KT)>0.264 &&  DayHour(KT)<0.736
        EVAPh(KT)=(2.75*sin(2*pi()*DayHour(KT)-pi()/2)/86400)*Evap(KT); % transfer to second value
        EVAP(KT,1)=EVAPh(KT);
        Tp_t(KT,1)=(2.75*sin(2*pi()*DayHour(KT)-pi()/2)/86400)*Tp(KT); % transfer to second value
    else
        EVAPh(KT)=(0.24/86400)*Evap(KT); % transfer to second value
        EVAP(KT,1)=EVAPh(KT);
        Tp_t(KT,1)=(0.24/86400)*Tp(KT); % transfer to second value
    end
end
