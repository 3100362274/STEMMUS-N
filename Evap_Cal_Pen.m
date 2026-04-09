% function Penman_Monteith_model
global RHOV_sur Resis_a Theta_LL_sur  % RHOV_sur and Theta_L_sur should be stored at each time step.
global z_ref z_srT z_srm VK_Const d0_disp  MO Ta U Ts Zeta_MO Stab_m Stab_T       % U_wind is the mean wind speed at height z_ref (m·s^-1), U is the wind speed at each time step.
global Rv g HR_a NL NN Evap KT RHOV Theta_LL EVAP
global DayNum t Tao LAI Tp_t Trap AFTP_TIME
global H1 H2 H3 H4 alpha_h bx LR Lmax r fr RL0 Srt Elmn_Lnth DeltZ RL Tot_Depth TIME rwuef hh tRmed xRmed tRmin RG 
global PT_PM_VEG PE_PM_SOIL VPD
global Rns Rns_SOIL RnL G_SOIL r_s_VEG r_s_SOIL r_a_VEG r_a_SOIL Rn_SOIL Rn_vege Rn  Rs Ra w w1 w2 ws Rs0 e0_Ts e_a_Ts e0_Ta e_a wt wc Srt_1 rl LAI_act rl_min
global Nmsrmn n_act h_v Z Lm 
global rsuef cc SinkS AUptakeA SPUptake SAUptake SAUptakeP SAUptakeA SAUptakeAN pai
global TT evfi RHO_2 ps WSI Nno3 Nn dms_string  JN 
Tao=0.56;  %light attenual coefficient

% a one-step calculation of actual soil evaporation and potential transpiration 
% by incorporating canopy minimum surface resistance and actual soil resistance into the Penman–Monteith model.

%% Set constants
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

%% albedo of soil calculation;
Theta_LL_sur(KT)=Theta_LL(NL,2);
if Theta_LL_sur(KT)<0.1
    alfa_s(KT)=0.25;
elseif Theta_LL_sur(KT)<0.25
    alfa_s(KT)=0.35-Theta_LL_sur(KT);
else
    alfa_s(KT)=0.1;
end

DayNum=fix(TIME/3600/24)+1;
JN1(KT)=JN(DayNum);    % day number
n_act(KT)=n_act(DayNum);
% 植物指标
h_v(KT)=h_v(DayNum);
rl_min(KT)=rl_min(DayNum);

% Calculation procedure
%%  LAI and light extinction coefficient calculation 
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
% AFTP_TIME=TIME/86400;   
% 
% if AFTP_TIME < 22
%     LAI(KT)=0; 
% elseif AFTP_TIME <= 237
%     LAI(KT)=0.00031*(AFTP_TIME-22)^2-0.04689*(AFTP_TIME-22)+1.74524; 
% elseif AFTP_TIME <= 287 && AFTP_TIME >= 237
%     LAI(KT)=-0.00151*(AFTP_TIME-22)^2+0.56787*(AFTP_TIME-22)-45.88808;
% else
%     LAI(KT)=0;
% end
% if LAI(KT)<0
%     LAI(KT)=0;
% end
if LAI(KT)<=2
    LAI_act(KT)=LAI(KT);
elseif LAI(KT)<=4
    LAI_act(KT)=2;
else
    LAI_act(KT)=0.5*LAI(KT);
end

%% AIR PARAMETERS CALCULATION

% compute DELTA - SLOPE OF SATURATION VAPOUR PRESSURE CURVE
% [kPa.?C-1]
% FAO56 pag 37 Eq13
DELTAA(KT) = 4098*(0.6108*exp(17.27*Ta(KT)/(Ta(KT)+237.3)))/(Ta(KT)+237.3)^2;

% ro_a - MEAN AIR DENSITY AT CTE PRESSURE
% [kg.m-3]
% FAO56 pag26 box6
Pa=101.3*((293-0.0065*Z)/293)^5.26;
ro_a(KT) = Pa/(R*1.01*(Ta(KT)+273.16));

% compute e0_Ta -  mean saturation vapour pressure at actual air temperature
% [kPa]
% FAO56 pag36 Eq11
e0_Ta(KT) = 0.6108*exp(17.27*Ta(KT)/(Ta(KT)+237.3));
e0_Ts(KT) = 0.6108*exp(17.27*Ts(KT)/(Ts(KT)+237.3));

% compute e_a - ACTUAL VAPOUR PRESSURE
% [kPa]
% FAO56 pag74 Eq54
e_a(KT) = e0_Ta(KT)*HR_a(KT);
e_a_Ts(KT) = e0_Ts(KT)*HR_a(KT);

 % VPD - Water vapor pressure difference [kPa]
VPD(KT) = e0_Ta(KT) - e_a(KT);

% gama - Hygrometer constant
% [kPa.。C-1]
% FAO56 pag31 eq8
gama = 0.664742*1e-3*Pa;

%% RADIATION PARAMETERS CALCULATION（Hours or less）
% compute dr - KTverse distance to the sun
% [rad]
% FAO56 pag38 Eq23
dr(KT) = 1+0.033*cos(2*pi()*JN1(KT)/365);

% compute delta - solar Magnetic declination
% [rad]
% FAO56 pag38 Eq24
delta(KT) = 0.409*sin(2*pi()*JN1(KT)/365-1.39);

% compute fai - Geographical latitude
% [rad]
% FAO56 pag38 Eq22
latitude_radian = convert_dms_string_to_radian(dms_string);

% compute Sc - seasonnal correction of solar time
% [hour]
% FAO56 pag47 Eq32
Sc = [];
b(KT) = 2.0*pi()*(JN1(KT)-81.0)/364.0;    % Eq 33
Sc(KT) = 0.1645*sin(2*b(KT)) - 0.1255*cos(b(KT)) - 0.025*sin(b(KT));

% compute w - solar time angle at the midpoKTt of the period (time)
% [rad]
% FAO56 pag48 Eq31
w(KT)=pi()/12*((TIME/3600-fix(TIME/3600/24-0.001)*24-0.5+0.06667*(Lz-Lm)+Sc(KT))-12);

% compute w1 - solar time angle at the beginning of the period (time)
% [rad]
% FAO56 pag47 Eq29
tl = 1;  %  hourly data 根据时间间隔要改
w1(KT) = (w(KT) - pi()*tl/24.0);

% compute w2 - solar time angle at the end of the period (time + 1h)
% [rad]
% FAO56 pag47 Eq30
w2(KT) = w(KT) + pi()*tl/24.0;

% compute ws - sunset hour angle
% [rad]
% FAO56 pag47 Eq25
ws(KT)=acos((-1)*tan(latitude_radian)*tan(delta(KT)));  %for daily duration

% compute Ra - Zenith radiation
% [MJ.m-2.hour-1]
% FAO56 pag39 Eq28
if w(KT)>= -ws(KT) &&  w(KT) <= ws(KT)
    Ra(KT)=12*60/pi()*Gsc*dr(KT)*((w2(KT)-w1(KT))*sin(latitude_radian)*sin(delta(KT)) + cos(latitude_radian)*cos(delta(KT))*(sin(w2(KT))-sin(w1(KT))));
else
    Ra(KT)=0;
end
if Ra(KT)<0
    Ra(KT)=0;
end

% compute Rs0 - clear-sky solar (shortwave) radiation 
% [MJ.m-2.hour-1]
% FAO56 pag41 Eq36
Rs0(KT) = (0.75+2E-5*Z)*Ra(KT);
%    Rs0_Watts = Rs0*24.0/0.08864

% daylight hours N
N(KT)=24*ws(KT)/pi();

% compute Rs - SHORTWAVE RADIATION
% [MJ.m-2.hour-1]
% FAO56 pag51 Eq37
Rs(KT)=(as+bs*n_act(KT)/N(KT))*Ra(KT);

% compute Rns - NET SHORTWAVE RADIATION
% [MJ.m-2.hour-1]
% FAO56 pag51 Eq37
% for each type of vegetation, crop and soil (albedo dependent)
Rns(KT)= (1-alfa)*Rs(KT);
Rns_SOIL(KT) = (1 - alfa_s(KT))*Rs(KT);

% compute Rnl - NET LONGWAVE RADIATION
% [MJ.m-2.hour-1]
% FAO56 pag51 Eq37 and pag74 of hourly computKTg
r_sunset=[];
r_angle=[];
R_i=[];
%由于Rs/Rso是用于描述云层覆盖度的,所以以小时为时段计算夜间的Rnl时,Rs/Rso可以定为日落前2-3小时的Rs/Rso值
%日落前2-3小时用公式31计算的太阳时角ω∈ [(ωs-0.79),(ωs-0.52)]
if (ws(KT) - 0.52) <= w(KT) && w(KT)<= (ws(KT) - 0.10) 
    R_i = 1;
    if Rs0(KT) > 0
        if Rs(KT)/Rs0(KT) > 0.3
            r_sunset = Rs(KT)/Rs0(KT);
        else
            r_sunset = 0.3; %云层完全覆盖
            
        end
    else
        r_sunset = 0.75;  % see FAO56 pag60 干旱半干旱地区
    end
end
if (ws(KT) - 0.10) < w(KT) || w(KT) <= (-ws(KT)+ 0.10)
    if R_i>0
        r_angle(KT)=r_sunset;
    else
        r_angle(KT)=0.75;  %see FAO56 pag75
    end
else
    r_angle(KT)=Rs(KT)/Rs0(KT);
end
RnL(KT)=(sigma/24*((Ta(KT) + 273.16)^4)*(0.34-0.14*sqrt(e_a(KT)))*(1.35*r_angle(KT)-0.35));
if RnL(KT)<0
    r_angle(KT)=0.8;
    RnL(KT)=(sigma/24*((Ta(KT) + 273.16)^4)*(0.34-0.14*sqrt(e_a(KT)))*(1.35*r_angle(KT)-0.35));
end

% net radiation for vegetation
Rn(KT) = Rns(KT) - RnL(KT);


% net radiation for soil
Rn_SOIL(KT) =Rn(KT)*exp(-1*(Tao*LAI(KT)));

% net radiation for vegetation
Rn_vege(KT) = Rn(KT) -  Rn_SOIL(KT);
        

% soil heat flux
t=TIME-(fix(TIME/3600/24))*86400;
if t>0.264*24*3600 && t<0.736*24*3600  % 白天开始时间和结束时间
    G(KT)=0.1*Rn(KT); %地表热通量
    G_SOIL(KT)=0.1*Rn_SOIL(KT);
else
    G(KT)=0.5*Rn(KT);
    G_SOIL(KT)=0.5*Rn_SOIL(KT);
end



%% SURFACE RESISTANCE PARAMETERS CALCULATION
% Total stomatal resistance of well-lit leaf surface
% [s.m-1]
R_a=0.81;R_b=0.004*24*11.6;R_c=0.05;
% R_fun(KT)=((R_b*Rns(KT)+R_c)/(R_a*(R_b*Rns(KT)+1)));
rl(KT)=rl_min(KT)/((R_b*Rns(KT)+R_c)/(R_a*(R_b*Rns(KT)+1)));

% r_s - SURFACE RESISTANCE %植被表面阻力
% [s.m-1]
% VEG: Dingman pag 208 (canopy conductance) (equivalent to FAO56 pag21 Eq5)
r_s_VEG(KT) = rl(KT)/LAI_act(KT);

% SOIL: equation 20 of van de Griend and Owe, 1994 :0.15-Theta_LL_sur
%Theta_LL_sur(KT)=Theta_LL(NL,2);
    if Theta_LL_sur(KT)>0.15
        r_s_SOIL(KT)=10;
    else
        r_s_SOIL(KT)=10.0*exp(0.3563*100.0*(0.15-Theta_LL_sur(KT)));   % 0.25 set as minmum soil moisture for potential evaporation 
    end

% correction wKTdspeed measurement and scalKTg at h+2m
% [m.s-1]
% FAO56 pag56 eq47

% r_a - AERODYNAMIC RESISTANCE
% [s.m-1]
% FAO56 pag20 eq4- (d - zero displacement plane, z_0m - roughness length momentum transfer, z_0h - roughness length heat and vapour transfer, [m], FAO56 pag21 BOX4
r_a_VEG(KT) = log((2-(2*h_v(KT)/3))/(0.123*h_v(KT)))*log((2-(2*h_v(KT)/3))/(0.1*0.0123*h_v(KT)))/((k^2)*u_2(KT))*100;  % s/m -> s/cm

% r_a of SOIL
% From : Liu www.hydrol-earth-syst-sci.net/11/769/2007/
% only function of ws, it is assumed that roughness are the same for any type of soil
RHOV_sur(KT)=RHOV(NN);
% Theta_LL_sur(KT)=Theta_LL(NL,2);

z_ref=200;          % cm The reference height of windspeed(momentum) measurement (usually 2 m) 固定值
d0_disp=80;          % cm The zero-plane displacement (=0 m) 2/3*h_v
z_srT=0.08;          % cm The surface roughness for the heat flux (=0.001m) 0.001-0.1 cm
VK_Const=0.41;      % The von Karman constant (=0.41) 固定值
z_srm=0.08;          % cm The surface roughness for momentum flux (=0.001m) 0.001-0.1 cm
% 对于矮草地和光滑的裸土表面，通常使用的粗糙度长度在0.005到0.01米之间。0.0058米是一个常用的值，代表相对光滑的地表条件

% 计算Monin-Obukhov长度 
MO(KT)=((Ta(KT)+273.15)*U(KT)^2)/(g*(Ta(KT)-Ts(KT))*log((z_ref-d0_disp)/z_srm));  % Wind speed should be KT cm.s^-1, MO-cm;
% 计算稳定性参数
Zeta_MO(KT)=(z_ref-d0_disp)/MO(KT);
% 根据不同条件计算稳定性修正项
if abs(Ta(KT)-Ts(KT))<=0.01 %中性条件
    Stab_m(KT)=0;
    Stab_T(KT)=0;
elseif Ta(KT)<Ts(KT) || Zeta_MO(KT)<0
    Stab_T(KT)=-2*log((1+sqrt(1-16*Zeta_MO(KT)))/2);
    Stab_m(KT)=-2*log((1+(1-16*Zeta_MO(KT))^0.25)/2)+Stab_T(KT)/2+2*atan((1-16*Zeta_MO(KT))^0.25)-pi/2;
else
    if Zeta_MO(KT)>1
        Stab_T(KT)=5;
        Stab_m(KT)=5;
    else
        Stab_T(KT)=5*Zeta_MO(KT);
        Stab_m(KT)=5*Zeta_MO(KT);
    end
end

% 计算空气动力学阻力
% Resis_a(KT)=((log((z_ref-d0_disp+z_srT)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp+z_srm)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*U(KT)) * 100;     %(s.cm^-1)
Resis_a(KT)=((log((z_ref-d0_disp)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*U(KT)) * 100;     %(s.m^-1)
% equation for neutral conditions (eq. 9) 简化版
r_a_SOIL(KT) = log((2.0)/0.0058)*log(2.0/0.0058)/((k^2)*U(KT))*100;   %(s.m^-1)


%% Penman-Montheith
% PT/PE - Penman-Montheith 
% mm.hours-1
% FAO56 pag19 eq3
% VEG
PT_PM_VEG(KT) = (DELTAA(KT)*(Rn_vege(KT)-G(KT))+3600*ro_a(KT)*Cp*(e0_Ta(KT)-e_a(KT))/r_a_VEG(KT))/(lambdav*(DELTAA(KT) + gama*(1+r_s_VEG(KT)/r_a_VEG(KT))))/3600;
% for SOIL
PE_PM_SOIL(KT) = (DELTAA(KT)*(Rn_SOIL(KT)-G_SOIL(KT))+3600*ro_a(KT)*Cp*(e0_Ta(KT)-e_a(KT))/Resis_a(KT))/(lambdav*(DELTAA(KT) + gama*(1+r_s_SOIL(KT)/Resis_a(KT))))/3600;
Evap(KT)=0.1.*PE_PM_SOIL(KT); % transfer to cm value
EVAP(KT,1)=Evap(KT);
Tp_t(KT)=0.1.*PT_PM_VEG(KT); % transfer to cm value
TP_t(KT,1)=Tp_t(KT);

% reference et ET0
% PT_PM_0(KT) = (0.408*DELTAA(KT)*(Rn(KT)-G(KT))+gama*37/(Ta(KT)+273)*(e0_Ta(KT)-e_a(KT))*u_2(KT))/(DELTAA(KT) + gama*(1+0.34*u_2(KT)));
%T_act(KT)=PT_PM_0(KT)*Kcb(KT);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%Root Water Uptake%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rwuef==1
    % water stress function parameters
    H1=-10;H2=-35;H4=-16000;H3L=-800;H3H=-500;%h1为饱和土壤中厌氧状态下的水势(通常为0);h2为氧气胁迫的临界水势;h4为植物枯萎状态的临界水势。h3为h3为水分胁迫的临界水势
    if Tp_t(KT)<0.02/3600
        H3=H3L;
    elseif Tp_t(KT)>0.05/3600
        H3=H3H;
    else
        H3=H3H+(H3L-H3H)/(0.03/3600)*(0.05/3600-Tp_t(KT));
    end


    MN=0;
    if WSI==1% water stress index :Value of 1 means the Feddes [1978] method;
        % piecewise linear reduction function
        for ML=1:NL
            for ND=1:2
                MN=ML+ND-1;
                if hh(MN)  >=H1
                    alpha_h(ML,ND) = 0;
                elseif  hh(MN)  >H2
                    alpha_h(ML,ND) = (hh(MN)-H1)/(H2-H1);
                elseif  hh(MN)  >=H3
                    alpha_h(ML,ND) = 1;
                elseif  hh(MN)  >H4
                    alpha_h(ML,ND) = (hh(MN)-H4)/(H3-H4);
                else
                    alpha_h(ML,ND) = 0;
                end
            end
        end
    elseif WSI==0 %S模型 VAN1987;
        P1=3;
        h_50=-800;%吸水量占潜在蒸腾量一半时的水头值
        for ML=1:NL
            for ND=1:2
                MN=ML+ND-1;
                alpha_h(ML,ND)=1/(1+(hh(MN)/h_50)^p1);
            end
        end
    else %Musters and Bouten(2000);
        h2=1;%临界水势阈值，需要根据试验测量
        P1=3;
        for ML=1:NL
            for ND=1:2
                MN=ML+ND-1;
                if hh(MN)<=H4
                    alpha_h(ML,ND) = 0;
                elseif    H4<hh(MN) && hh(MN)<h2
                    alpha_h(ML,ND)=1-((hh(MN)-h2)/(H4-h2))^p1;
                else
                    alpha_h(ML,ND)=1;
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%% Root lenth distribution %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%Root growth%%%%%%%%%%
    Lmax=143;                    %最大根长 cm
    RL0=10;                     %初始根长 cm
    tRmed=40;                     %根系生长发育到一半时的时间 d
    tRmin=5;                     %根系开始生长的时间 d
    xRmed=50;                     %根系生长发育到一半时的根长 cm,若无实测数据可以假设发育到一半时的根长为0.5Lmax
    if RG==1
        days_below_zero = 0;
        days_above_zero = 0;
        root_growth_stopped = false;
        if Ta(KT) < 0
            days_below_zero = days_below_zero + 1;
            days_above_zero = 0; % 重置春季计数器
            if days_below_zero == 5
                disp('连续5天温度低于0℃，根系停止生长。');
                root_growth_stopped = true;
            end
        elseif Ta(KT) > 0
            days_above_zero = days_above_zero + 1;
            days_below_zero = 0; % 重置冬季计数器
            if days_above_zero == 5 && root_growth_stopped
                disp('连续5天温度高于0℃，根系开始恢复生长。');
                root_growth_stopped = false; % 根系开始恢复生长
            end
        else
            days_below_zero = 0;
            days_above_zero = 0;
        end

        if ~root_growth_stopped
            disp('未达到连续5天温度低于0℃的条件，根系未停止生长。');
            r=(1/((tRmed-tRmin))*24*3600)*log((RL0*(Lmax-xRmed))/(xRmed*(Lmax-RL0))); % root growth rate cm/s
            LR(KT)=(Lmax*RL0)/(RL0+(Lmax-RL0)*exp((-1)*(r*(TIME-tRmin*3600*24))));
        else
            LR(KT)=LR(KT);
        end
    elseif RG==0
        r=((Lmax-RL0)/2)/(((Nmsrmn/10+1)/24/2)*24*3600);  % root growth rate cm/s
        assignin('base', 'r', r);

        fr(KT)=RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*TIME))); %Logistic根系生长函数
        LR(KT)=Lmax*fr(KT);                               %根长
    end

    %%%%%%%%%%%%%%%%%%根系分布密度函数%%%%%%%%%%
    RL=Tot_Depth; %土体长
    Elmn_Lnth=0;
    %(Hoffma and Van Genuchten,1983)
    if LR(KT)<=1
        for ML=1:NL-1      % ignore the surface root water uptake 1cm
            for ND=1:2
                MN=ML+ND-1;
                bx(ML,ND)=0;
            end
        end
    else
        for ML=1:NL
            Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
            for ND=1:2
                if Elmn_Lnth<RL-LR(KT)
                    bx(ML,ND)=0;
                elseif Elmn_Lnth>=RL-LR(KT) && Elmn_Lnth<RL-0.2*LR(KT)
                    bx(ML,ND)=2.0833*(1-(RL-Elmn_Lnth)/LR(KT))/LR(KT);
                else
                    bx(ML,ND)=1.66667/LR(KT);
                end
            end
        end
    end
   

    %%%%%%%%%%%%%%环境因子影响根系生长%%%%%%%%%%%%%%%%%%%
    if evfi==1   %考虑环境因子影响根系生长
        bd=RHO_2+0.00445*ps;       %bl,b2是取决于土壤质地的参数
        bu=RHO_2+0.35+0.005*ps;    %RHO_bulk是土壤容重g/cm3，ps为土壤含沙量，RHO_2为含沙量为0时的极限容重kg/m3,1g/cm3=1000kg/m3
        b2=(log(0.112*bd)-log(8.0*bu))/(bd-bu);
        bl=log(0.0112*bd)-b2;
        SS=(RHO_bulk)/((RHO_bulk)+exp(bl+b2*(RHO_bulk)));  %表示土壤阻力对根系生长的胁迫
        % ATS=(100-Sal)/(100-Smax);                   %表示铝毒害胁迫系数
        Top=21; %小麦 20-22 玉米30-32
        Tb=3;  %小麦 3-4.5 玉米8-10
        
        if TT(NN)>0    %表示温度胁迫系数
            STS=((2.0*TT(NN))/(Top+Tb))^0.5;       %InitT0为土壤表面温度。Top为作物最适宜生长温度，Tb作物特有的基点温度
        else
            STS=0;
        end
        Fr=min(SS,STS);
    else
        Fr=1;
    end

    %%%%%%%%%%%%%%%%计算根系吸水%%%%%%%%%%%%%
    Trap_1(KT)=0; %总的根系吸水
    for ML=1:NL
        for ND=1:2
            MN=ML+ND-1;
            Srt_1(ML,ND)=Fr*alpha_h(ML,ND)*bx(ML,ND)*Tp_t(KT);
        end
        Trap_1(KT)=Trap_1(KT)+(Srt_1(ML,1)+Srt_1(ML,2))/2*DeltZ(ML);   % root water uptake integration by DeltZ;
    end
    %     % consideration of water compensation effect
    if Tp_t(KT)==0
        Trap(KT)=0;
    else
        wt(KT)=Trap_1(KT)/Tp_t(KT);  %补偿因子
        wc=1; % compensation coefficient
        Trap(KT)=0;
        if wt(KT)<wc
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    Srt(ML,ND)=Fr*alpha_h(ML,ND)*bx(ML,ND)*Tp_t(KT)/wc;
                end
                Trap(KT)=Trap(KT)+(Srt(ML,1)+Srt(ML,2))/2*DeltZ(ML);   % root water uptake integration by DeltZ;
            end
        else
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    Srt(ML,ND)=Fr*alpha_h(ML,ND)*bx(ML,ND)*Tp_t(KT)/wt(KT);
                end
                Trap(KT)=Trap(KT)+(Srt(ML,1)+Srt(ML,2))/2*DeltZ(ML);   % root water uptake integration by DeltZ;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%溶质运移根系吸收溶质%%%%%%%%%%%%
if rsuef==1
    % Inputs:
    Nmin=0;           %-The roots begin to absorb the lowest concentration of no3- Unit:mg/L=piug/cm^3(mL)
    SPot=24.8;        %- potential root solute uptake假定植物对no3-溶质的一个潜在需求量 Unit:mg/L=piug/cm^3(mL)
    paic=1;           %- solute stress index 人为测量规定
    rKM=0.5;          %- Michaelis-Menten constant
    lActRSU=1;        %- consider active root solute uptake
    NRootMaxNH4=10;   %- maximum concentration for the passive solute uptake Unit:mg/L=piug/cm^3(mL)
    NRootMaxNO3=10;   %- maximum concentration for the passive solute uptake Unit:mg/L=piug/cm^3(mL)
    %From Water Flow
    %Srt(ML,ND)       %- Root water uptake
    %wt(KT)           %- ratio of actual and potential transpiration
    %SPUptake(ML,ND)  %- Passive solute absorption throughout the root zone (step 1)
    %SAUptakeP(KT)    %- potential active solute uptake (step 1)
    %SAUptakeAN(KT)   %- uncompensated actual active solute uptake (step 2)
    %SAUptakeA(KT)    %- compensated actual active solute uptake (step 3)
    %SinkS(ML,ND,js)  %- Sum  solute uptake
    %SAUptake(KT)     %- Actual avtive solute uptake
    %initialization

    nStep=1;      %step 1: Passive uptake
    if lActRSU==1
        nStep=2;  % step 2: Active uptake without compensation
    elseif LActRSU==1 && paic<=1
        nStep=3;  % step 3: Active uptake with compensation
    end
    % Notice: Active uptake only for the last solute

    for iStep=1:nStep
        for MN=1:NN
            cc(MN)=max(Nno3(MN)-Nmin,0);
        end
        if iStep==1
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    SinkS(ML,ND,1)=Srt(ML,ND)*max(min(Nn(MN),NRootMaxNH4),0);
                    SinkS(ML,ND,2)=Srt(ML,ND)*max(min(Nno3(MN),NRootMaxNO3),0);
                end
                SPUptake(KT,1)=SPUptake(KT,1)+(SinkS(ML,1,1)+SinkS(ML,2,1))/2*DeltZ(ML); % potential PASSIVE solute uptake root solute uptake integration by DeltZ;
                SPUptake(KT,2)=SPUptake(KT,2)+(SinkS(ML,1,2)+SinkS(ML,2,2))/2*DeltZ(ML); % potential PASSIVE solute uptake root solute uptake integration by DeltZ;
                SAUptakeP(KT)=max(SPot*wt(KT)-SPUptake(KT,2),0);   % potential active solute uptake (step 1)
            end
        elseif iStep==2
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    AUptakeA(ML,ND)=cc(MN)/(rKM+cc(MN))*bx(ML,ND)*SAUptakeP(KT); %Actual local active solute uptake
                end
                SAUptake(KT)=SAUptake(KT)+(AUptakeA(ML,1)+AUptakeA(ML,2))/2*DeltZ(ML);  %Actual active solute uptake
                if nStep==2
                    for ND=1:2
                        SinkS(ML,ND,2)=SinkS(ML,ND,2)+AUptakeA(ML,ND);
                    end
                end
                SAUptakeAN(KT)=SAUptake(KT);  %- uncompensated actual active solute uptake (step 2)
                if SAUptakeP(KT)>=0
                    pai(KT)=SAUptake(KT)/SAUptakeP(KT);  %溶质胁迫因子
                end
            end
        elseif nStep==3
            if pai(KT)<paic && pai(KT)>0
                Compen=paic;  % 补偿因子
            else
                Compen=pai(KT);
            end
            if Compen>0
                for ML=1:NL
                    for ND=1:2
                        MN=ML+ND-1;
                        AUptakeA(ML,ND)=cc(MN)/(rKM+cc(MN))*bx(ML,ND)*SAUptakeP(KT)/Compen;
                        SinkS(ML,ND,2)=SinkS(ML,ND,2)+AUptakeA(ML,ND);
                    end
                    SAUptakeA(KT)=SAUptakeA(KT)+(AUptakeA(ML,1)+AUptakeA(ML,2))/2*DeltZ(ML);    %compensated actual active solute uptake root solute uptake integration by DeltZ;
                end
            end
        end
    end
end
   