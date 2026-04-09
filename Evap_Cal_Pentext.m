function [CHU_record,HUI_record,HU,SHRL_all_days,DRDS_list, RDS_list, HUF, dHUF, LAI_daily,LAI,Resis_a,r_s_SOIL,r_s_VEG,r_a_VEG,f_min]= Evap_Cal_Pentext(DeltZ,TIME,RHOV,Ta,HR_a,U,Theta_LL,Ts, ...
    g,NL,NN,KT,hh,Tm,Tmax, Tmin,Theta_f, Theta_s,JN,n_act,h_v, ...
    rl_min,Z,dms_string,Lm,DayNum,Tao)
% a one-step calculation of actual soil evaporation and potential transpiration 
% by incorporating canopy minimum surface resistance and actual soil resistance into the Penman–Monteith model.

%% Set constants
% =0.56;          % light attenual coefficient
sigma = 4.903e-9;  % Stefan Boltzmann constant MJ.m-2.day-1 FAO56 pag 42
lambdav = 2.45;    % latent heat of evaporation [MJ.kg-1] FAO56 pag 31
Gsc = 0.082;       % solar constant [MJ.m-2.min-1] FAO56 pag 47 Eq28
R = 0.287;         % specific gas [kJ.kg-1.K-1]    FAO56 p26 box6
Cp = 1.013E-3;     % specific heat at cte pressure [MJ.kg-1.?C-1] FAO56 p26 box6
k = 0.41;          % karman's cte   []  FAO 56 Eq4
% Z=1051;          % altitute of the location(m) 根据不同地方需要改海拔
as=0.25;           % regression constant, expressKTg the fraction of extraterrestrial radiation FAO56 pag41
bs=0.5;
alfa=0.23;         % albeo of vegetation set as 0.23
% z_m=10;          % observation height of wKTd speed; 10m
Lz=240*pi()/180;   % latitude of Beijing time zone west of Greenwich
% Lm=242*pi()/180; % latitude of Local time, west of Greenwich 需要根据当地修正

%% 输入数据
sowing_day=274;
PHU = 1800;      % 作物从播种到成熟所需的潜在总热量单位 °C 1800-2100 wheat )
T_b = 3;         % 基准温度，单位：°C

% HUI_record        % 每天的热量单元
% CHU_record        % 累积热量单元
GMHU = 100;  % 作物种子萌芽所需的热量单元累计值
XLAI = 6.27;    % 最大叶面积指数
% dHUF ;  % 与热量单元指数HUI相关的变化量
% 胁迫因子输入数据
% T_b = 0;  % 基准温度，单位：°C
% Tm        % 日平均温度
T_op = 21;  % 最佳温度

UN = 80;   % 实际氮含量 kg/hm2 20-80 冬小麦
UNO = 250;  % 最佳氮含量 kg/hm2 150-250 冬小麦

% Theta_LL        % 土壤实际含水量
% Theta_r      % 土壤临界含水量
% Theta_s ;    % 土壤饱和含水量
C_f = 0.85;  % 临界通风因子

% HUI 和 LAI 衰减的参数
% HUI           % 热量单元指数
HUI_D = 0.6;  % 开始衰减的热量单元指数,叶面积衰败时作物生长阶段
beta = 1;   % LAI 衰减速率系数

%% 冬眠期判断
days_below_zero = 0;  % 连续低于0℃的天数
days_above_zero = 0;  % 连续高于0℃的天数
crop_in_dormancy = false;  % 作物是否处于冬眠状态
dormancy_data = [];  % 存储进入/解除冬眠的天数及对应的SHRL
num_steps = length(JN); 
LAI = zeros(1, num_steps); % Preallocate LAI to avoid dynamic allocation
SHRL_all_days = ones(1, num_steps);  % 初始化SHRL为1（假设初始状态为未冬眠）

for iN = 1:num_steps
    % 温度条件判断
    if Tm(iN) < 0
        days_below_zero = days_below_zero + 1;  % 增加低于0℃的天数计数
        days_above_zero = 0;  % 重置高于0℃的计数
        % 判断是否满足进入冬眠的条件，且当前不在冬眠期
        if days_below_zero == 5 && ~crop_in_dormancy
            crop_in_dormancy = true;  % 标记作物进入冬眠
            SHRL = 0;  % 冬眠状态，SHRL设为0
            dormancy_data = [dormancy_data; iN, SHRL];  % 记录进入冬眠期的天数及SHRL
        end
    elseif Tm(iN) > 0
        days_above_zero = days_above_zero + 1;  % 增加高于0℃的天数计数
        days_below_zero = 0;  % 重置低于0℃的计数
        % 判断是否满足解除冬眠的条件，且当前处于冬眠期
        if days_above_zero == 5 && crop_in_dormancy
            crop_in_dormancy = false;  % 取消冬眠标记
            SHRL = 1;  % 未冬眠状态，SHRL设为1
            dormancy_data = [dormancy_data; iN, SHRL];  % 记录解除冬眠期的天数及SHRL
        end
    else
        days_below_zero = 0;
        days_above_zero = 0;
    end

    % 更新每一天的SHRL值
    if crop_in_dormancy
        SHRL_all_days(iN) = 0;  % 冬眠期，SHRL设为0
    else
        SHRL_all_days(iN) = 1;  % 未冬眠期，SHRL设为1
    end
end      

%% Calculate Heat Unit
 [CHU_record, HU, HUI_record, DRDS_list, RDS_list, HUF, dHUF] = CalculateHeatUnit(Tmax, Tmin, sowing_day, T_b, PHU);

%%  LAI and light extinction coefficient calculation 
[LAI_daily,f_min] = CalculateLAIAndStressFactorsWithDecay(HU, CHU_record, GMHU, XLAI ...
    , dHUF, Tm, T_b, T_op, UN, UNO, Theta_LL, Theta_f, Theta_s, C_f, ...
    SHRL_all_days, HUI_record, HUI_D, beta, sowing_day, NL, hh, DeltZ, DayNum );

JN1(KT)=JN(DayNum);    % day number
n_act(KT)=n_act(DayNum);
% 植物指标
h_v(KT)=h_v(DayNum);
LAI(KT)=LAI_daily(DayNum);
rl_min(KT)=rl_min(DayNum);
if LAI(KT)<=2
    LAI_act(KT)=LAI(KT);
elseif LAI(KT)<=4
    LAI_act(KT)=2;
else
    LAI_act(KT)=0.5*LAI(KT);
end

%% albedo of soil calculation;
% Theta_LL_sur(KT)=Theta_LL(NL,2);
% if Theta_LL_sur(KT)<0.1
%     alfa_s(KT)=0.25;
% elseif Theta_LL_sur(KT)<0.25
%     alfa_s(KT)=0.35-Theta_LL_sur(KT);
% else
%     alfa_s(KT)=0.1;
% end

% %% AIR PARAMETERS CALCULATION
% 
% % compute DELTA - SLOPE OF SATURATION VAPOUR PRESSURE CURVE
% % [kPa.?C-1]
% % FAO56 pag 37 Eq13
% DELTAA(KT) = 4098*(0.6108*exp(17.27*Ta(KT)/(Ta(KT)+237.3)))/(Ta(KT)+237.3)^2;
% 
% % ro_a - MEAN AIR DENSITY AT CTE PRESSURE
% % [kg.m-3]
% % FAO56 pag26 box6
% Pa=101.3*((293-0.0065*Z)/293)^5.26;
% ro_a(KT) = Pa/(R*1.01*(Ta(KT)+273.16));
% 
% % compute e0_Ta -  mean saturation vapour pressure at actual air temperature
% % [kPa]
% % FAO56 pag36 Eq11
% e0_Ta(KT) = 0.6108*exp(17.27*Ta(KT)/(Ta(KT)+237.3));
% e0_Ts(KT) = 0.6108*exp(17.27*Ts(KT)/(Ts(KT)+237.3));
% 
% % compute e_a - ACTUAL VAPOUR PRESSURE
% % [kPa]
% % FAO56 pag74 Eq54
% e_a(KT) = e0_Ta(KT)*HR_a(KT);
% e_a_Ts(KT) = e0_Ts(KT)*HR_a(KT);
% 
%  % VPD - Water vapor pressure difference [kPa]
% VPD(KT) = e0_Ta(KT) - e_a(KT);
% 
% % gama - Hygrometer constant
% % [kPa.。C-1]
% % FAO56 pag31 eq8
% gama = 0.664742*1e-3*Pa;
% 
% %% RADIATION PARAMETERS CALCULATION（Hours or less）
% % compute dr - KTverse distance to the sun
% % [rad]
% % FAO56 pag38 Eq23
% dr(KT) = 1+0.033*cos(2*pi()*JN1(KT)/365);
% 
% % compute delta - solar Magnetic declination
% % [rad]
% % FAO56 pag38 Eq24
% delta(KT) = 0.409*sin(2*pi()*JN1(KT)/365-1.39);
% 
% % compute fai - Geographical latitude
% % [rad]
% % FAO56 pag38 Eq22
% latitude_radian = convert_dms_string_to_radian(dms_string);
% 
% % compute Sc - seasonnal correction of solar time
% % [hour]
% % FAO56 pag47 Eq32
% Sc = [];
% b(KT) = 2.0*pi()*(JN1(KT)-81.0)/364.0;    % Eq 33
% Sc(KT) = 0.1645*sin(2*b(KT)) - 0.1255*cos(b(KT)) - 0.025*sin(b(KT));
% 
% % compute w - solar time angle at the midpoKTt of the period (time)
% % [rad]
% % FAO56 pag48 Eq31
% w(KT)=pi()/12*((TIME/3600-fix(TIME/3600/24-0.001)*24-0.5+0.06667*(Lz-Lm)+Sc(KT))-12);
% 
% % compute w1 - solar time angle at the beginning of the period (time)
% % [rad]
% % FAO56 pag47 Eq29
% tl = 1;  %  hourly data 根据时间间隔要改
% w1(KT) = (w(KT) - pi()*tl/24.0);
% 
% % compute w2 - solar time angle at the end of the period (time + 1h)
% % [rad]
% % FAO56 pag47 Eq30
% w2(KT) = w(KT) + pi()*tl/24.0;
% 
% % compute ws - sunset hour angle
% % [rad]
% % FAO56 pag47 Eq25
% ws(KT)=acos((-1)*tan(latitude_radian)*tan(delta(KT)));  %for daily duration
% 
% % compute Ra - Zenith radiation
% % [MJ.m-2.hour-1]
% % FAO56 pag39 Eq28
% if w(KT)>= -ws(KT) &&  w(KT) <= ws(KT)
%     Ra(KT)=12*60/pi()*Gsc*dr(KT)*((w2(KT)-w1(KT))*sin(latitude_radian)*sin(delta(KT)) + cos(latitude_radian)*cos(delta(KT))*(sin(w2(KT))-sin(w1(KT))));
% else
%     Ra(KT)=0;
% end
% if Ra(KT)<0
%     Ra(KT)=0;
% end
% 
% % compute Rs0 - clear-sky solar (shortwave) radiation 
% % [MJ.m-2.hour-1]
% % FAO56 pag41 Eq36
% Rs0(KT) = (0.75+2E-5*Z)*Ra(KT);
% %    Rs0_Watts = Rs0*24.0/0.08864
% 
% % daylight hours N
% N(KT)=24*ws(KT)/pi();
% 
% % compute Rs - SHORTWAVE RADIATION
% % [MJ.m-2.hour-1]
% % FAO56 pag51 Eq37
% Rs(KT)=(as+bs*n_act(KT)/N(KT))*Ra(KT);
% 
% % compute Rns - NET SHORTWAVE RADIATION
% % [MJ.m-2.hour-1]
% % FAO56 pag51 Eq37
% % for each type of vegetation, crop and soil (albedo dependent)
% Rns(KT)= (1-alfa)*Rs(KT);
% Rns_SOIL(KT) = (1 - alfa_s(KT))*Rs(KT);
% 
% % compute Rnl - NET LONGWAVE RADIATION
% % [MJ.m-2.hour-1]
% % FAO56 pag51 Eq37 and pag74 of hourly computKTg
% r_sunset=[];
% r_angle=[];
% R_i=[];
% %由于Rs/Rso是用于描述云层覆盖度的,所以以小时为时段计算夜间的Rnl时,Rs/Rso可以定为日落前2-3小时的Rs/Rso值
% %日落前2-3小时用公式31计算的太阳时角ω∈ [(ωs-0.79),(ωs-0.52)]
% if (ws(KT) - 0.52) <= w(KT) && w(KT)<= (ws(KT) - 0.10) 
%     R_i = 1;
%     if Rs0(KT) > 0
%         if Rs(KT)/Rs0(KT) > 0.3
%             r_sunset = Rs(KT)/Rs0(KT);
%         else
%             r_sunset = 0.3; %云层完全覆盖
% 
%         end
%     else
%         r_sunset = 0.75;  % see FAO56 pag60 干旱半干旱地区
%     end
% end
% if (ws(KT) - 0.10) < w(KT) || w(KT) <= (-ws(KT)+ 0.10)
%     if R_i>0
%         r_angle(KT)=r_sunset;
%     else
%         r_angle(KT)=0.75;  %see FAO56 pag75
%     end
% else
%     r_angle(KT)=Rs(KT)/Rs0(KT);
% end
% RnL(KT)=(sigma/24*((Ta(KT) + 273.16)^4)*(0.34-0.14*sqrt(e_a(KT)))*(1.35*r_angle(KT)-0.35));
% if RnL(KT)<0
%     r_angle(KT)=0.8;
%     RnL(KT)=(sigma/24*((Ta(KT) + 273.16)^4)*(0.34-0.14*sqrt(e_a(KT)))*(1.35*r_angle(KT)-0.35));
% end
% 
% % net radiation for vegetation
% Rn(KT) = Rns(KT) - RnL(KT);
% 
% 
% % net radiation for soil
% Rn_SOIL(KT) =Rn(KT)*exp(-1*(Tao*LAI(KT)));
% 
% % net radiation for vegetation
% Rn_vege(KT) = Rn(KT) -  Rn_SOIL(KT);
% 
% 
% % soil heat flux
% t=TIME-(fix(TIME/3600/24))*86400;
% if t>0.264*24*3600 && t<0.736*24*3600  % 白天开始时间和结束时间
%     G(KT)=0.1*Rn(KT); %地表热通量
%     G_SOIL(KT)=0.1*Rn_SOIL(KT);
% else
%     G(KT)=0.5*Rn(KT);
%     G_SOIL(KT)=0.5*Rn_SOIL(KT);
% end
% 
% 
% 
% %% SURFACE RESISTANCE PARAMETERS CALCULATION
% % Total stomatal resistance of well-lit leaf surface-where rl is the minimum leaf stomatal resistance
% % [s.m-1]
% R_a=0.81;R_b=0.004*24*11.6;R_c=0.05;
% % R_fun(KT)=((R_b*Rns(KT)+R_c)/(R_a*(R_b*Rns(KT)+1)));
% rl(KT)=rl_min(KT)/((R_b*Rns(KT)+R_c)/(R_a*(R_b*Rns(KT)+1)));
% 
% % r_s - SURFACE RESISTANCE %植被表面阻力The minimum canopy surface resistance
% % [s.m-1]
% % VEG: Dingman pag 208 (canopy conductance) (equivalent to FAO56 pag21 Eq5)
% r_s_VEG(KT) = rl(KT)/LAI_act(KT);
% 
% % SOIL: equation 20 of van de Griend and Owe, 1994 :0.15-Theta_LL_sur
% % Theta_LL_sur(KT)=Theta_LL(NL,2);
% 
% if Theta_LL_sur(KT)>0.15
%     r_s_SOIL(KT)=10;
% else
%     r_s_SOIL(KT)=10.0*exp(0.3563*100.0*(0.15-Theta_LL_sur(KT)));   % 0.25 set as minmum soil moisture for potential evaporation
% end
% 
% % r_a - AERODYNAMIC RESISTANCE
% % [s.m-1]
% % FAO56 pag20 eq4- (d - zero displacement plane, z_0m - roughness length momentum transfer, z_0h=0.1*hv - roughness length heat and vapour transfer, [m], FAO56 pag21 BOX4
% r_a_VEG(KT) = log((2-(2*h_v(KT)/3))/(0.123*h_v(KT)))*log((2-(2*h_v(KT)/3))/(0.1*0.0123*h_v(KT)))/((k^2)*U(KT)./100)*100;  % s/m -> s/cm
% 
% % r_a of SOIL
% % From : Liu www.hydrol-earth-syst-sci.net/11/769/2007/
% % only function of ws, it is assumed that roughness are the same for any type of soil
% RHOV_sur(KT)=RHOV(NN);
% % Theta_LL_sur(KT)=Theta_LL(NL,2);
% 
% z_ref=200;          % cm The reference height of windspeed(momentum) measurement (usually 2 m) 固定值
% d0_disp=0;          % cm The zero-plane displacement (=0 m) 2/3*h_v
% z_srT=0.1;          % cm The surface roughness for the heat flux (=0.001m) 0.001-0.1 m
% VK_Const=0.41;      % The von Karman constant (=0.41) 固定值
% z_srm=0.1;          % cm The surface roughness for momentum flux (=0.001m) 0.001-0.1 m
% % 对于矮草地和光滑的裸土表面，通常使用的粗糙度长度在0.005到0.01米之间。0.0058米是一个常用的值，代表相对光滑的地表条件
% % 计算Monin-Obukhov长度 
% MO(KT)=((Ta(KT)+273.15)*U(KT)^2)/(g*(Ta(KT)-Ts(KT))*log((z_ref-d0_disp)/z_srm));  % Wind speed should be KT cm.s^-1, MO-cm;
% % 计算稳定性参数
% Zeta_MO(KT)=(z_ref-d0_disp)/MO(KT);
% % 根据不同条件计算稳定性修正项
% if abs(Ta(KT)-Ts(KT))<=0.01 %中性条件
%     Stab_m(KT)=0;
%     Stab_T(KT)=0;
% elseif Ta(KT)<Ts(KT) || Zeta_MO(KT)<0
%     Stab_T(KT)=-2*log((1+sqrt(1-16*Zeta_MO(KT)))/2);
%     Stab_m(KT)=-2*log((1+(1-16*Zeta_MO(KT))^0.25)/2)+Stab_T(KT)/2+2*atan((1-16*Zeta_MO(KT))^0.25)-pi/2;
% else
%     if Zeta_MO(KT)>1
%         Stab_T(KT)=5;
%         Stab_m(KT)=5;
%     else
%         Stab_T(KT)=5*Zeta_MO(KT);
%         Stab_m(KT)=5*Zeta_MO(KT);
%     end
% end
% 
% % 计算空气动力学阻力 aerodynamic resistance to water vapor flow
% % Resis_a(KT)=((log((z_ref-d0_disp+z_srT)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp+z_srm)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*U(KT)) * 100;     %(s.cm^-1)
% Resis_a(KT)=((log((z_ref-d0_disp)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*U(KT)) * 100;     %(s.m^-1)
% % equation for neutral conditions (eq. 9) 简化版
% r_a_SOIL(KT) = log((2.0)/0.0058)*log(2.0/0.0058)/((k^2)*U(KT)./100)*100;   %(s.m^-1)
% 

%% Penman-Montheith
% PT/PE - Penman-Montheith 
% mm.hours-1
% FAO56 pag19 eq3
% VEG
% PT_PM_VEG(KT) = (DELTAA(KT)*(Rn_vege(KT)-G(KT))+3600*ro_a(KT)*Cp*(e0_Ta(KT)-e_a(KT))/r_a_VEG(KT))/(lambdav*(DELTAA(KT) + gama*(1+r_s_VEG(KT)/r_a_VEG(KT))))/3600;
% 
% % for SOIL
% PE_PM_SOIL(KT) = (DELTAA(KT)*(Rn_SOIL(KT)-G_SOIL(KT))+3600*ro_a(KT)*Cp*(e0_Ta(KT)-e_a(KT))/Resis_a(KT))/(lambdav*(DELTAA(KT) + gama*(1+r_s_SOIL(KT)/r_a_SOIL(KT))))/3600;
% Evap(KT)=0.1.*PE_PM_SOIL(KT); % transfer to cm value
% EVAP(KT,1)=Evap(KT);
% Tp_t(KT)=0.1.*PT_PM_VEG(KT); % transfer to cm value
% TP_t(KT,1)=Tp_t(KT);
% if isnan(Tp_t(KT))
%     Tp_t(KT) = 0;
% end


% reference et ET0
% PT_PM_0(KT) = (0.408*DELTAA(KT)*(Rn(KT)-G(KT))+3600*gama*37/(Ta(KT)+273)*(e0_Ta(KT)-e_a(KT))*U(KT))/(DELTAA(KT) + gama*(1+0.34*U(KT)))/3600;
%T_act(KT)=PT_PM_0(KT)*Kcb(KT);

end
   