function [Evap, r_a_SOIL, r_a_CANOPY, r_a_AIR, r_s_SOIL, RHOV_air]= calculate_daily_evap(Theta_LL, Tm, Ts, u_2, h_v, LAI, NL, KT, g, RHa, RHOV, NoTime, Theta_r, Theta_s)
NN =NL+1;
Theta_LL_sur(KT)=Theta_LL(NL,2);
% r_s - SURFACE RESISTANCE
% [s.m-1]

% b = 0.25;  % the empirical minimum value above which the soil is able to deliver vapor at a potential rate
% a = 0.3563*100.0;  % the fitted  parameter
% c = 10.0; % the resistance to molecular diffusion across the water surface itself
% if Theta_LL_sur(KT) > b
%     r_s_SOIL(KT)=10;
% else
%     r_s_SOIL(KT)=c*exp(a*(b-Theta_LL_sur(KT)));   % 0.25 set as minmum soil moisture for potential evaporation
% end
 
% (Hu and Jia, 2015),doi:10.3390/rs70303056
r_ss_min = 50; % (Hu and Jia, 2015),doi:10.3390/rs70303056
theta_g  = (Theta_LL_sur(KT)-Theta_r(NL))./(Theta_s(NL)-Theta_r(NL));
r_s_SOIL(KT) = r_ss_min.*(theta_g).^(-3);
if r_s_SOIL(KT) < r_ss_min
    r_s_SOIL(KT) =  r_ss_min;
elseif  r_s_SOIL(KT)>5000 || isinf(r_s_SOIL(KT))
    r_s_SOIL(KT) = 5000;
end

% r_a - AIR RESISTANCE
% [s.m-1]
z_srl = 0.01*100;        % cm zog is the surface ground roughness length form : Van bavel 1976
sigma = 1 - (0.5 / (0.5 + LAI(KT))) * exp(-LAI(KT) ^ 2 / 8); %  the coefficient of momentum distribution among the canopy and the soil (Shaw & Pereira, 1981;Taconet et al., 1986)
VK_Const=0.41;           % The von Karman constant (=0.41) 固定值
z_ref=200;               % cm The reference height of windspeed(momentum) measurement (usually 2 m) 固定值
if NoTime(KT) <= 0
    d0_disp=0.63*sigma*h_v(1)*100;  % cm The zero-plane displacement 
    z_0 = (1 - sigma) * z_srl + sigma * (h_v(1) * 100 - d0_disp) / 3; %  The surface roughness
else
    d0_disp=0.63*sigma*h_v(NoTime(KT))*100;  % cm The zero-plane displacement 
    z_0 = (1 - sigma) * z_srl + sigma * (h_v(NoTime(KT)) * 100 - d0_disp) / 3; %  The surface roughness
end
if z_ref < d0_disp
    warning('z_ref must be greater than d0_disp');
end
z_srT=z_0/7;               % cm The surface roughness for the heat flux 
z_srm=z_0;                 % cm The surface roughness for momentum flux 

% 计算Monin-Obukhov长度 
if NoTime(KT) <= 0
    MO(KT)=((Tm(1)+273.15)*u_2(1)^2)/(g*(Tm(1)-Ts(1))*log((z_ref-d0_disp)/z_srm));  % Wind speed should be KT cm.s^-1, MO-cm;
    % 计算稳定性参数
    Zeta_MO(KT)=(z_ref-d0_disp)/MO(KT);
    % 根据不同条件计算稳定性修正项
    if abs(Tm(1)-Ts(1))<=0.01 %中性条件
        Stab_m(KT)=0;
        Stab_T(KT)=0;
    elseif Tm(1)<Ts(1) || Zeta_MO(KT)<0
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
    u_h(KT) = 0.83 * u_2(1) * sigma + (1 - sigma) * u_2(1);  % AVERAGE WIND SPEED AT CANNOPY HEIGHT (m/s)
    % 计算空气动力学阻力 aerodynamic resistance to water vapor flow
    r_a(KT)=((log((z_ref-d0_disp)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*u_2(1)) ;     %(s.m^-1)
    r_a_SOIL(KT) = u_h(KT) / ((1 - sigma) * u_2(1)) * r_a(KT);
    r_a_CANOPY(KT) = u_h(KT) / (sigma * u_2(1)) * r_a(KT);
    if r_a_CANOPY(KT) == Inf
        r_a_CANOPY(KT) = 0;
    end
    r_a_AIR(KT) = (u_2(1) - u_h(KT)) / u_2(1) * r_a(KT);
    
    RHOV_air(KT) = CalculateEvapotranspiration.calculateAirWaterVapor(Tm(1), RHa(1));
else
    MO(KT)=((Tm(NoTime(KT)+1)+273.15)*u_2(NoTime(KT)+1)^2)/(g*(Tm(NoTime(KT)+1)-Ts(NoTime(KT)+1))*log((z_ref-d0_disp)/z_srm));  % Wind speed should be KT cm.s^-1, MO-cm;
    % 计算稳定性参数
    Zeta_MO(KT)=(z_ref-d0_disp)/MO(KT);
    % 根据不同条件计算稳定性修正项
    if abs(Tm(NoTime(KT)+1)-Ts(NoTime(KT)+1))<=0.01 %中性条件
        Stab_m(KT)=0;
        Stab_T(KT)=0;
    elseif Tm(NoTime(KT)+1)<Ts(NoTime(KT)+1) || Zeta_MO(KT)<0
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
    u_h(KT) = 0.83 * u_2(1) * sigma + (1 - sigma) * u_2(1);
    % 计算空气动力学阻力 aerodynamic resistance to water vapor flow
    r_a(KT)=((log((z_ref-d0_disp)/z_srT)+Stab_T(KT)) * (log((z_ref-d0_disp)/z_srm)+Stab_m(KT))) / ((VK_Const^2)*u_2(NoTime(KT)+1)) ;     %(s.m^-1)
    r_a_SOIL(KT) = u_h(KT) / ((1 - sigma) * u_2(NoTime(KT)+1)) * r_a(KT);
    r_a_CANOPY(KT) = u_h(KT) / (sigma * u_2(NoTime(KT)+1)) * r_a(KT);
    if r_a_CANOPY(KT) == Inf
        r_a_CANOPY(KT) = 0;
    end
    r_a_AIR(KT) = (u_2(NoTime(KT)+1) - u_h(KT)) / u_2(NoTime(KT)+1) * r_a(KT);

    RHOV_air(KT) = CalculateEvapotranspiration.calculateAirWaterVapor(Tm(NoTime(KT)+1), RHa(NoTime(KT)+1));
end

% 裸土蒸发 g/cm2/s
Evap (KT)= 0.1 * (RHOV(NN)  * 1000 -  RHOV_air(KT) * 1000) / (r_a_SOIL(KT)+r_s_SOIL(KT)); 
