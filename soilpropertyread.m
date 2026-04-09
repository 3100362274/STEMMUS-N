global SaturatedK SaturatedMC ResidualMC Coefficient_n Coefficient_Alpha porosity FOC FOS l MSOC PH fieldMC SSUR RHO_bulk RHO_2 ps fc
global DIF111 DISP1 RHOKG Ts_msr Tb_msr theta_s0 Ks0 
global InitialValues KG Km KC Kurea K1 K2 K3 hcrit hsaturation
global InitND0 InitND1 InitND2 InitND3 InitND4 InitND5 InitND6 InitND7 BtmND  BtmT BtmX P_g0
global InitT0 InitT1 InitT2 InitT3 InitT4 InitT5 InitT6 InitT7
global InitX0 InitX1 InitX2 InitX3 InitX4 InitX5 InitX6 InitX7
global InitNo30 InitNo31 InitNo32 InitNo33 InitNo34 InitNo35 InitNo36 InitNo37 BtmNo3 fmax Tao
global InitNurea0 InitNurea1 InitNurea2 InitNurea3 InitNurea4  InitNurea5 InitNurea6 InitNurea7 BtmNurea
global InitN0 InitN1 InitN2 InitN3 InitN4 InitN5 InitN6 InitN7 BtmN Z dms_string Lm start_time end_time
global RHmax RHmin RHa Tmax Tmin Tm P JN N n_act h_v rl_min u_2 LAI h_SUR_msr Nefc cB cT1 cB1 cT Tav At
global F_ha_total Density A_tree DEPTH F_tree_total fert_ratio F_tree t_fert 
    MMdata=readtable('.\Meterology data2000-2024.xls','sheet','sheet1','range','b8495:W9135'); %4
    % MMdata=readtable('.\Meterology data2019-2020','sheet','sheet1','range','b4:U491');
    Mdata = table2array(MMdata);
    Tmax=Mdata(:,1);           % 气温
    Tmin=Mdata(:,2);
    Tm=Mdata(:,3);
    Tdew=Mdata(:,4);
    RHa=Mdata(:,5);            % 湿度
    RHmax=Mdata(:,6);
    RHmin=Mdata(:,7);     
    % u_z_m=Mdata(:,8);
    u_2=Mdata(:,9);            % 2m风速 cm.s-1
    dateAndDayNumbers = calculate_day_numbers(start_time, end_time);  % 计算期间所有日期的日序数
    JN=dateAndDayNumbers.DayNumber;       % 日序
    % N_=Mdata(:,11);             % 理论日照
    n_act=Mdata(:,12);         % 实际日照
    % LAI=Mdata(:,13);         % 实际leaf area index
    h_v=Mdata(:,14);           % 株高canopy height
    % Kcb=Mdata(:,15);         % 作物系数
    rl_min=Mdata(:,16);        % 最小气孔阻力 minimum soil resistance
    P=Mdata(:,17);             % 降雨 
    Inboundaryhoursdata=table2array(readtable('.\Inboundaryhours.xlsx','sheet','sheet2','range','B203786:D219170'));
    % P=Inboundaryhoursdata(:,2);            % 降雨
    % Ts_msr=Mdata(:,18);        % 地表实测温度
    Ts_msr=Inboundaryhoursdata(:,1);
    % Tb_msr=Mdata(:,19);      % 地表实测温度
    % h_SUR_msr=Mdata(:,20);   % 地表随时间变化水头值
    TopPg_msr = Mdata(:,21).*1000; % hpa*1000
    Rn_msr =  Mdata(:,22);
    Z=1200;                    % altitute of the location(m) 根据不同地方需要改海拔
    Tav=10.67 ;                 % 年平均气温
    At=37.7 ;                  % 年平均气温振幅：最高温度-最低温度
    P_g0=889000;               % The mean atmospheric pressure(pa=kg.m^-1.s^-2=10g.cm^-1.s^-2) (Should be given in new simulation period subroutine.)
    Tao = 0.5;                 % 消光系数rExtinct  最小为0.1 from：hydrus
    dms_string = '35°14''N';   % 输入测量地区纬度0-30 30-60 60-90
    Lm=107.67*pi()/180;        % 输入测量地区经度, west of Greenwich 需要根据当地修正                       
    %% load 
    if Nefc == 1
        Ndata=readtable('.\Nboundaryconcentration.xlsx','sheet','sheet1','range','B3:E131453');
        NNdata = table2array(Ndata);
        cB=NNdata(:,2);
        cT=NNdata(:,1);
        cB1=NNdata(:,4);
        cT1=NNdata(:,3);
    end

    Sdata=readtable('.\soilproperty.xlsx','sheet','sheet1','range','B4:H33');
    Mmatrix = table2array(Sdata);
    %% load soil property
    FOC=Mmatrix(1,:)./100;     %fraction of clay
    FOS=Mmatrix(2,:)./100;     %fraction of sand
    % FOSL=1-FOC-FOS;          %fraction of silt
    MSOC=Mmatrix(3,:)./1000000;  %mass fraction of soil organic C UNIT: ppm/10000=百分比
    %% load soil chemistry
    PH=Mmatrix(7,:);
    %% load soil hydrulic parameters
    % soil property
    SaturatedK=Mmatrix(10,:)./(3600*24);   %[       100.29 48.34  20.71  19.71  11.5   10]./(3600*24);           % Saturation hydraulic conductivity (cm.s^-1);11.5 10
    SaturatedMC=Mmatrix(11,:);             %[      0.416  0.422  0.407  0.405  0.405  0.405];                  % Saturated water content;
    ResidualMC=Mmatrix(12,:);              %[       0.073  0.097  0.1    0.1    0.075  0.075];                  % The residual water content of soil;
    Coefficient_n=Mmatrix(13,:);           %[    1.35   1.43   1.53   1.93   1.54   1.43];                   % Coefficient in VG model;
    Coefficient_Alpha=Mmatrix(14,:);       %[0.0023 0.0062 0.0070 0.0052 0.0042 0.0032];                 % Coefficient in VG model;
    porosity=Mmatrix(15,:);                %[        0.4717  0.5245 0.5132 0.4943 0.5301 0.5283];             % Soil porosity; % porosity=[       0.5050 0.4906 0.4206 0.5019 0.5019 0.5019];    0.5165  0.5338 0.5168 0.4919 0.5194 0.5283 
    l=0.5;                                                            % Coefficient in VG model;
    fieldMC=(1./(((336.5.*Coefficient_Alpha).^(Coefficient_n)+1).^(1-1./Coefficient_n))).*(SaturatedMC-ResidualMC)+ResidualMC;   % usually 0.27
    SSUR=10^5;       % Surface area for loam  ,for sand 10^2 (cm^-1); 
    RHO_bulk=1.29;   % Bulk density of sand (g.cm^-3); 1.25
    RHO_2=1.89;      % 黑垆土 ：颗粒密度/(1+极限压实的孔隙比0.3-0.6） %RHO_2为含沙量为0时的极限容重(g.cm^-3)
    ps=mean(FOS);    % 土壤含沙量
    fc=mean(FOC);         % fraction of clay fc=0.022;  The fraction of clay,for loam,0.036; for sand,0.02;计算增强因子使用[Cass et al., 1984]
    theta_s0 = max(SaturatedMC);
    Ks0 = max(SaturatedK);
    fmax = 0;
    % f_max 可能表示土壤的最大衰减速率。对于不同类型的土壤，
    % 土壤的导水率和饱和度不同，因此 f_max 用来调节降水渗透到土壤的比例。
    hcrit = -1.5*10^(4); 
    % 最小压力水头 framland : -4.5*10^(4) apple: -1.5*10^(4); from libingbing2023
    % hCritA为土壤表面允许的最小压头。该值只能通过蒸发激活。当土壤表面压头大于hCritA时，实际蒸发速率等于潜在蒸发速率。
    % 一旦达到hCritA值，实际蒸发速率就会从潜在值下降，因为此时土壤过于干燥，无法提供潜在速率。
    % hCritA值不用于任何其他计算。hCritA值通常指定在-150米到-1000米的范围内（对于粗质土壤可能需要更低-参见下面的讨论）。
    % hCritA的选择应使相应的含水量至少比残留含水量高0.005。这可能是重要的，特别是对于粗糙的土壤（砂），它有一个非常陡峭的保留曲线。
    % 对于粗质土，干区含水量的微小变化会导致压头的大变化，从而使数值解不稳定。因此，可能需要使用一个相对较小的hCritA值。
    % 当考虑根系吸水时，它也应低于H4（当为负时）。当根系水分吸收极限（H4）和蒸发极限（hCritA）同时达到时，hCritA > H4 控制边界通量，导致流入。
    hsaturation = -0.5; %cm
    % 由于理查德方程的前提条件是非饱和态运动，所以土壤尤其表层数厘米到数毫米之间不应该存在接近于0的值，这里可以呀用于饱和含水量对应的基质势控制。
    % 当考虑蓄水层时，这个值为接近0的值保证边界处为饱和非饱和转换边界
    %% load soulte transport parameter
    if Nefc == 1
    DIF1=Mmatrix(18,:)./(3600*24);          
    DIF11=Mmatrix(19,:)./(3600*24);
    DIF111(1,:,1)=DIF1;                     % NH4+ Soil water diffusivity(cm.d^-1)
    DIF111(1,:,2)=DIF11;                    % NO3- Soil water diffusivity(cm.d^-1)
    DISP1=Mmatrix(20,:);             % Longitudinal dispersivity in water phase(cm)      
    KG=Mmatrix(21,:);                       % Adsorption isotherm coefficient, ks [M-1 L3]
    RHOKG=KG.*RHO_bulk;                     % (g.cm^-3)*(cm^3.g-1) (-)
    Km = Mmatrix(24, :)./ (3600 * 24);             % Denitrification rate constant under optimal temperature and moisture conditions [μg/(cm³·d)]  
    KC = Mmatrix(25, :);                           % Half-saturation constant [μg/cm³ = mg/L]
    Kurea = Mmatrix(26, :) ./ (3600 * 24);         % First-order hydrolysis rate constant [d⁻¹]
    K1 = Mmatrix(27, :) ./ (3600 * 24);            % First-order nitrification rate constant [d⁻¹]
    K2 = Mmatrix(28, :) ./ (3600 * 24) ;           % First-order denitrification rate constant [d⁻¹] 
    K3 = Mmatrix(29, :) ./ (3600 * 24);            % First-order mineralization rate constant [d⁻¹]
    end
    
    %% Input for producing initial soil moisture and soil temperature profile

    % Unit of it is cm. These variables are used to indicated the depth corresponding to the measurement.
    InitND0=0;
    InitND1=20;    % Unit of it is cm. These variables are used to indicated the depth corresponding to the measurement.
    InitND2=40;
    InitND3=80;
    InitND4=200;
    InitND5=300;
    InitND6=500;
    InitND7=700;
    BtmND=Tot_Depth;
    % Measured temperature at InitND1 depth at the start of simulation period
    InitT0= 11.366;	%Ts_msr(1);
    InitT1=	16.18558655;
    InitT2=	17.78731689;
    InitT3=	17.78731689;
    InitT4= 18.88903198;
    InitT5=	18.88903198;
    InitT6=	14;
    InitT7=	10;
    BtmT = 9.4;  %
    % Measured soil moisture content
    InitX0=	0.205;
    InitX1=	0.178; % Measured soil moisture content
    InitX2=	0.157;
    InitX3=	0.179;
    InitX4=	0.226;
    InitX5=	0.256;
    InitX6=	0.279;
    InitX7=0.310;
    BtmX=0.251;  % The initial moisture content at the bottom of the column

    if Nefc == 1
        % measured Soil ammonium nitrogen concentration (μg/cm3)
        InitN0=0;
        InitN1=0;
        InitN2=0;
        InitN3=0;
        InitN4=0;
        InitN5=0;
        InitN6=0;
        InitN7=0;
        BtmN=0;
        % measured Soil nitrate nitrogen content
        InitNo30=199.037;
        InitNo31=52.605;
        InitNo32=31.069;
        InitNo33=56.503;
        InitNo34=226.191;
        InitNo35=277.177;
        InitNo36=196.431;
        InitNo37=7.076;
        BtmNo3=0.293;
        % measured Soil urea content
        InitNurea0=0;
        InitNurea1=0;
        InitNurea2=0;
        InitNurea3=0;
        InitNurea4=0;
        InitNurea5=0;
        InitNurea6=0;
        InitNurea7=0;
        BtmNurea=0;
    end

    % Fertilization parameter
    % % 初始化两个控制器（节点5和节点8）
    % fert_controller_5 = init_fertilizer_controller();
    % fert_controller_8 = init_fertilizer_controller();
    % 
    % % 在时间循环内分别调用
    % [apply5, F5] = fert_controller_5(...);
    % [apply8, F8] = fert_controller_8(...);
    % 
    % if apply5
    %     cTop1(5) = cTop1(5) + F5;
    % end
    % if apply8
    %     cTop1(8) = cTop1(8) + F8;
    % end
    
    t_fert = datetime({'2023-04-08 10:00:00','2023-07-01 10:00:00','2023-10-22 10:00:00','2024-04-08 10:00:00','2024-07-01 10:00:00','2024-10-22 10:00:00'});  % 示例施肥时间点 苹果4月初、七月初、十月下旬
    F_ha_total = 716.94;                  % 年总公顷施N肥量 [kg N/ha]  肥料总量*N所占比例
    % DEPTH = 20;                         % 施肥深度 [cm]
    % Density = 833;                      % 种植密度 [棵/ha] 1ha/单株占地面积
    % A_tree = 12;                        % 单株占地面积 [m²/棵] → 4*4等 cm²/棵
    F_tree_total = F_ha_total ;           % 单株总施肥量 [kg/棵]
    fert_ratio =  [0.3 ,0.3, 0.4, 0.3 ,0.3, 0.4];        % 不同时期施肥比例，苹果是萌芽期，果实膨大期，收货后
    F_tree = F_tree_total * fert_ratio;   % 各阶段单株施肥量 [kg/棵]
% 生成fert_params结构体
fert_params = struct(...
    't_fert', t_fert, ...  % 直接传入datetime类型的施肥时间
    'F_tree', F_tree, ...  % 施肥量
    'A_tree', 1.2, ...     % 默认树冠面积（m²）
    'RHO_bulk', RHO_bulk, ... % 默认土壤密度
    'DEPTH', 5 ...        % 默认施肥深度（cm）
);

% 调用初始化施肥控制器
 fert_controller  = init_fertilizer_controller(fert_params);

  

    if InitX0 > SaturatedMC(1) || InitX1 > SaturatedMC(1) || InitX2 > SaturatedMC(2) || ...
            InitX3 > SaturatedMC(3) || InitX4 > SaturatedMC(4) || InitX5 > SaturatedMC(5) || ...
            InitX6 > SaturatedMC(6) || InitX7 > SaturatedMC(6)
        InitX0 = fieldMC(1);
        InitX1 = fieldMC(1); % Measured soil liquid moisture content
        InitX2 = fieldMC(2);
        InitX3 = fieldMC(3);
        InitX4 = fieldMC(4);
        InitX5 = fieldMC(5);
        InitX6 = fieldMC(6);
        InitX7 = fieldMC(7);
        BtmX  = fieldMC(7);
    end

InitialValues.initX = [InitX0, InitX1, InitX2, InitX3, InitX4, InitX5, InitX6, InitX7, BtmX];
InitialValues.initND = [InitND0, InitND1, InitND2, InitND3, InitND4, InitND5, InitND6, InitND7, BtmND];
InitialValues.initT = [InitT0, InitT1, InitT2, InitT3, InitT4, InitT5, InitT6, InitT7, BtmT];
InitialValues.InitNh4=[InitN0, InitN1, InitN2, InitN3, InitN4, InitN5, InitN6, InitT7, BtmN];
InitialValues.InitNo3=[InitNo30, InitNo31, InitNo32, InitNo33, InitNo34, InitNo35, InitNo36, InitNo37, BtmNo3];
InitialValues.InitNurea=[InitNurea0, InitNurea1, InitNurea2, InitNurea3, InitNurea4,  InitNurea5, InitNurea6, InitNurea7, BtmNurea];

%  The measured soil moisture and tempeature data here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Msrmn_Fitting
    %30, 100, 200, 300, 500, 700, 1000cm
    Xdata=readtable('.\INPUT_2020_2021_YM_DAY.xls.xlsx','sheet','sheet1','range','a3:Q367');
    Msr_Mois=table2array([Xdata(:,3) Xdata(:,4) Xdata(:,5) Xdata(:,6) Xdata(:,7) Xdata(:,8) Xdata(:,9)]);
    %30, 100, 200, 300, 500, 700, 1000cm
    Msr_Temp=table2array([Xdata(:,11) Xdata(:,12) Xdata(:,13) Xdata(:,14) Xdata(:,15) Xdata(:,16) Xdata(:,17)]);
    Msr_Time=table2array(Xdata(:,1));
    %30, 100, 200, 300, 500, 700, 1000cm
    % ETdata=xlsread('C:\Users\1\Desktop\STEMMUS\STEMMUS-original\ET','sheet1','A2:E2449');
    % ET_H=ETdata(:,1)';
    % ET_D=ETdata(:,3)';
    % E_D=ETdata(:,4)';
end