global PT_PM_0 PT_PM_VEG PE_PM_SOIL T_act PME P Ts_msr
global RHOV_sur RHOV_A Resis_a Resis_s P_Va Velo_fric Theta_LL_sur  % RHOV_sur and Theta_L_sur should be stored at each time step.
global z_ref z_srT z_srm VK_Const d0_disp U_wind MO Ta U Ts Zeta_MO Stab_m Stab_T       % U_wind is the mean wind speed at height z_ref (m·s^-1), U is the wind speed at each time step.
global Rv g HR_a NL NN Evap KT RHOV Theta_LL EVAP
global Evaptranp_Cal DayNum t Ep DURTN  ETp Tp Tao LAI Tp_t Trap AFTP_TIME
global H1 H2 H3 H4 alpha_h bx LR Lm fr RL0 Srt Elmn_Lnth DeltZ RL TIME rwuef hh
global PT_PM_0 PT_PM_VEG PE_PM_SOIL T_act Theta_s J Resis_s1 Resis_s2 Resis_s3 Resis_s4 Resis_s5 Resis_a1
global Rns Rns_SOIL RnL G_SOIL r_s_VEG r_s_SOIL r_a_VEG r_a_SOIL Rn_SOIL Rn  Rs Ra w w1 w2 ws Rs0 e0_Ts e_a_Ts e0_Ta e_a wt wc Srt_1 rl LAI_act rl_min
global Es PME Kcb ET Theta_r Coefficient_n Coefficient_Alpha Nmsrmn JN Tm Tmax Tmin RHa n N u_2 WSI RG RDDF evfi rsuef 
% Set constants
sigma = 4.903e-9; % Stefan Boltzmann constant MJ.m-2.day-1 FAO56 pag 74
lambdav = 2.45;    % latent heat of evaporation [MJ.kg-1] FAO56 pag 31
% Gieske 2003 pag 74 Eq33/Dingman 2002
% lambda=2.501-2.361E-3*t, with t temperature evaporative surface (?C)
% see script Lambda_function_t.py
Gsc = 0.082;      % solar constant [MJ.m-2.min-1] FAO56 pag 47 Eq28
eps = 0.622;       % ratio molecular weigth of vapour/dry air FAO56 p26 BOX6
R = 0.287;         % specific gas [kJ.kg-1.K-1]    FAO56 p26 box6
Cp = 1.013E-3;     % specific heat at cte pressure [MJ.kg-1.?C-1] FAO56 p26 box6
k = 0.41;          % karman's cte   []  FAO 56 Eq4
Z=521;             % altitute of the location(m)
as=0.25;           % regression constant, expressing the fraction of extraterrestrial radiation FAO56 pag50
bs=0.5;
alfa=0.23;         % albeo of vegetation set as 0.23
z_m=10;            % observation height of wind speed; 10m
% Calculation procedure
for iN=1:length(JN)
    %% AIR PARAMETERS CALCULATION
    % compute DELTA - SLOPE OF SATURATION VAPOUR PRESSURE CURVE
    % [kPa.?C-1]
    % FAO56 pag 37 Eq13
    DELTA(iN) = 4098*(0.6108*exp(17.27*Tm(iN)/(Tm(iN)+237.3)))/(Tm(iN)+237.3)^2;
    % ro_a - MEAN AIR DENSITY AT CTE PRESSURE
    % [kg.m-3]
    % FAO56 pag26 box6
    Pa=101.3*((293-0.0065*Z)/293)^5.26;
    ro_a(iN) = Pa/(R*1.01*(Tm(iN)+273.16));
    % compute e0_Ta - saturation vapour pressure at actual air temperature
    % [kPa]
    % FAO56 pag36 Eq11
% % % % % % % % % % %     e0_Tm(iN) = 0.6108*exp(17.27*Tm(iN)/(Tm(iN)+237.3));
    e0_Tmax(iN) = 0.6108*exp(17.27*Tmax(iN)/(Tmax(iN)+237.3));
    e0_Tmin(iN) = 0.6108*exp(17.27*Tmin(iN)/(Tmin(iN)+237.3));
    es(iN)=(e0_Tmax(iN)+e0_Tmin(iN))/2;
    % compute e_a - ACTUAL VAPOUR PRESSURE
    % [kPa]
    % FAO56 pag74 Eq54
% % % % % % % % % % %     e_a(iN) = e0_Tm(iN)*RHa(iN)/100;
    e_a(iN) = (RHa(iN)/100)*(e0_Tmin(iN)+e0_Tmax(iN))/2;
    % gama - PSYCHROMETRIC CONSTANT
    % [kPa.?C-1]
    % FAO56 pag31 eq8
    gama = 0.664742*1e-3*Pa;
    
    %% RADIATION PARAMETERS CALCULATION
    % compute dr - inverse distance to the sun
    % [rad]
    % FAO56 pag47 Eq23
    dr(iN) = 1+0.033*cos(2*pi()*JN(iN)/365);
    
    % compute delta - solar declination
    % [rad]
    % FAO56 pag47 Eq24
    delta(iN) = 0.409*sin(2*pi()*JN(iN)/365-1.39);   

    % compute compute ws - sunset hour angle
    % [rad]
    % FAO56 pag48 Eq31
    Ws(iN)=acos((-1)*tan(0.654)*tan(delta(iN)));
    
    % compute Ra - extraterrestrial radiation
    % [MJ.m-2.day-1]
    % FAO56 pag47 Eq28
    Ra(iN)=24*60/pi()*Gsc*dr(iN)*(Ws(iN)*sin(0.654)*sin(delta(iN))+cos(0.654)*cos(delta(iN))*sin(Ws(iN)));
    %Ra_Watts.append(Ra[j]*24/0.08864)
    % compute Rs0 - clear-sky solar (shortwave) radiation
    % [MJ.m-2.day-1]
    % FAO56 pag51 Eq37
    Rs0(iN) = (0.75+2E-5*Z)*Ra(iN);
    
    % compute Rs - SHORTWAVE RADIATION
    % [MJ.m-2.day-1]
    % FAO56 pag51 Eq37
    Rs(iN)=(as+bs*n(iN)/N(iN))*Ra(iN);
    
    % compute Rns - NET SHORTWAVE RADIATION
    % [MJ.m-2.day-1]
    % FAO56 pag51 Eq37
    % for each type of vegetation, crop and soil (albedo dependent)
    Rns(iN)= (1-alfa).*Rs(iN);
    % compute Rnl - NET LONGWAVE RADIATION
    % [MJ.m-2.day-1]
    % FAO56 pag51 Eq37 and pag74 of hourly computing
    Rnl(iN)=(sigma*(((Tmax(iN) + 273.16)^4+(Tmin(iN) + 273.16)^4)/4)*(0.34-0.14*sqrt(e_a(iN)))*(1.35*Rs(iN)/Rs0(iN)-0.35));
%     Rnl(iN)=(sigma*(Tm(iN) + 273.16)^4)*(0.34-0.14*sqrt(e_a(iN)))*(1.35*Rs(iN)/Rs0(iN)-0.35);
    Rn(iN) = Rns(iN) - Rnl(iN);
    %% SURFACE RESISTANCE PARAMETERS CALCULATION
    
    % r_s - SURFACE RESISTANCE
    % [s.m-1]
    % VEG: Dingman pag 208 (canopy conductance) (equivalent to FAO56 pag21 Eq5)
%     r_s_VEG(iN) = rl(iN)/LAI_act(iN);
    
    % SOIL: equation 20 of van de Griend and Owe, 1994
    %Theta_LL_sur(KT)=Theta_LL(NL,2);
    % [m.s-1]
    % FAO56 pag56 eq47
    
% % % % %     u_2(iN) = u_z_m(iN)*4.87/log(67.8*z_m-5.42);
    
    % r_a - AERODYNAMIC RESISTANCE
    % [s.m-1]
    % FAO56 pag20 eq4- (d - zero displacement plane, z_0m - roughness length momentum transfer, z_0h - roughness length heat and vapour transfer, [m], FAO56 pag21 BOX4
%     r_a_VEG(iN) = log((2-(2*h_v(iN)/3))/(0.123*h_v(iN)))*log((2-(2*h_v(iN)/3))/(0.0123*h_v(iN)))/((k^2)*u_2(iN));
    % r_a of SOIL
    % Liu www.hydrol-earth-syst-sci.net/11/769/2007/
    % equation for neutral conditions (eq. 9)
    % only function of ws, it is assumed that roughness are the same for any type of soil
    % r_a_SOIL(iN) = log((2.0)/0.0058)*log(2.0/0.0058)/((k^2)*u_2(iN));
    
    % PT/PE - Penman-Montheith
    % mm.day-1
    % FAO56 pag19 eq3
%     PT_PM_VEG(iN) = (DELTA(iN)*Rn(iN)+86400*ro_a(iN)*Cp*(e0_Tm(iN)-e_a(iN))/r_a_VEG(iN))/(lambdav*(DELTA(iN) + gama*(1+r_s_VEG(iN)/r_a_VEG(iN))));
    % reference et ET0
    PT_PM_0(iN) = (0.408*DELTA(iN)*Rn(iN)+gama*900/(Tm(iN)+273)*(es(iN)-e_a(iN))*u_2(iN))/(DELTA(iN) + gama*(1+0.34*u_2(iN)));
%     PT_PM_0(iN) = (0.408*DELTA(iN)*Rn(iN)+gama*900/(Tm(iN)+273)*(e0_Tm(iN)-e_a(iN))*u_2(iN))/(DELTA(iN) + gama*(1+0.34*u_2(iN)));
   % T_act(iN)=PT_PM_0(iN)*Kcb(iN);
%     PME(iN)=DELTA(iN)*Rn(iN)/(lambdav*(DELTA(iN) + gama));
    PME(iN)=DELTA(iN)*Rn(iN)/(lambdav*(DELTA(iN) + gama));
end

%%%%%%% LAI and light extinction coefficient calculation %%%%%%%%%%%%%%%%%%
AFTP_TIME=TIME/86400;
  if AFTP_TIME<20
   LAI(KT)=0.098*AFTP_TIME+0.248;
%  LAI(KT)=-0.0053*AFTP_TIME^2+0.2317*AFTP_TIME+0.1;
 else
  LAI(KT)=-0.04*AFTP_TIME^2+0.63*AFTP_TIME+2.063;%0.0127*AFTP_TIME+0.5318;
 end

if LAI(KT)<=2
    LAI_act(KT)=LAI(KT);
elseif LAI(KT)<=4
    LAI_act(KT)=2;
else
    LAI_act(KT)=0.5*LAI(KT);
end

Tao=0.6;  %冬小麦夏玉米

    if TIME<DURTN
        DayNum=fix(TIME/3600/24)+1;
        t=TIME-(DayNum-1)*86400;
        ETp=0.1.*PME(1:121);
        ET=0.1.*PT_PM_0(1:121);
        Ep(KT)=(exp(-1*(Tao*LAI(KT))))*ETp(DayNum);%土壤潜在蒸散发
        Tp(KT)=(1-exp(-1*(Tao*LAI(KT))))*ETp(DayNum);%土壤潜在蒸散发
        Evap(KT)=Ep(KT)./86400; 
        EVAP(KT,1)=Evap(KT);
        Tp_t(KT)=Tp(KT); 
        TP_t(KT,1)=Tp_t(KT);
    else
        DayNum=fix(TIME/3600/24);
        t=TIME-(DayNum-1)*86400;
        ETp=0.1.*PME(1:121);%土壤潜在蒸散发计算公式的一个系数
        ET=0.1.*PT_PM_0(1:121); %作物参考蒸发
        Ep(KT)=(exp(-1*(Tao*LAI(KT))))*ETp(DayNum); %Ep=土壤潜在蒸散发
        Tp(KT)=(1-exp(-1*(Tao*LAI(KT))))*ETp(DayNum);%土壤潜在蒸散发
        Evap(KT)=Ep(KT)./86400; 
        EVAP(KT,1)=Evap(KT);
        Tp_t(KT)=Tp(KT); 
        TP_t(KT,1)=Tp_t(KT);
    end

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
    Lmax=200;                    %最大根长 cm
    RL0=200;                     %初始根长 cm
    tRmed=1;                     %根系生长发育到一半时的时间 d
    tRmin=1;                     %根系开始生长的时间 d
    xRmed=1;                     %根系生长发育到一半时的根长 cm,若无实测数据可以假设发育到一半时的根长为0.5Lmax
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
        fr(KT)=RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*TIME))); %Logistic根系生长函数
        LR(KT)=Lmax*fr(KT);                               %根长
    end

    %%%%%%%%%%%%%%%%%%根系分布密度函数%%%%%%%%%%
    RL=200; %土体长
    Elmn_Lnth=0;
    if RDDF==1  %(Hoffma and Van Genuchten,1983)
        if LR(KT)<=1
            for ML=1:NL-1      % ignore the surface root water uptake 1cm
                for ND=1:2
                    MN=ML+ND-1;
                    bx(ML,ND)=0;
                end
            end
        else
            for ML=1:NL
                for ND=1:2
                    Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
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
    else
        for ML=1:NL
            for ND=1:2
                Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
                b1(ML,ND)=(((5.0*RL)/LR(KT))*exp(((5.0*RL*(RL-Elmn_Lnth))/LR(KT))))/(1.0-exp(5.0*(RL-(RL-Elmn_Lnth))));
                b11(ML,ND)=b1(ML,ND).*Elmn_Lnth;
            end
        end
        sum_col1 = sum(b11(:,1));
        sum_col2 = sum(b11(:,2));
        total_sum = 0.5*(sum_col1 + sum_col2);
        for ML=1:NL
            for ND=1:2
                bx(ML,ND)=b1(ML,ND)./total_sum;
            end
        end
    end

    %%%%%%%%%%%%%%环境因子影响根系生长%%%%%%%%%%%%%%%%%%%
    if evfi==1   %考虑环境因子影响根系生长
        bd=RHO_2+0.00445*ps;       %bl,b2是取决于土壤质地的参数
        bu=RHO_2+0.35+0.005*ps;    %RHO_bulk是土壤容重g/cm3，ps为土壤含沙量，RHO_2为含沙量为0时的极限溶质kg/m3,1g/cm3=1000kg/m3
        bl=log(0.0112*bd)-b2;
        b2=(log(0.112*bd)-log(8.0*bu))/(bd-bu);
        SS=(RHO_bulk*1000)/((RHO_bulk*1000)+exp(bl+b2*(RHO_bulk*1000)));  %表示土壤阻力对根系生长的胁迫
        ATS=(100-Sal)/(100-Smax);                   %表示铝毒害胁迫系数
        Top=1;
        Tb=1;
        if TT(NN)>0    %表示温度胁迫系数
            STS=((2.0*TT(NN))/(Top+Tb))^0.5;       %InitT0为土壤表面温度。Top为作物最适宜生长温度，Tb作物特有的基点温度
        else
            STS=0;
        end
        Fr=min(SS,ATS,STS);
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
   