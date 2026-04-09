% Constants.m
% Description: This file defines constants, parameters, and global variables 
%              used throughout the soil moisture and heat flow simulation model.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time and Spatial Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. Time settings
global Delt_t tS start_time end_time seconds_interval hours_interval days_interval 
global current_date current_year TIME KT TEND Delt_t0 KIT Nmsrmn NIT TimeStep SUMTIME  
global xERR hERR TERR PERR DURTN

% Simulation parameters
Delt_t = 3600;                % Time step duration (seconds)
KIT=0;                        % KIT is used to count the number of iteration in a time step;
NIT = 100;                    % Desirable number of iterations in a time step;
Nmsrmn=2799*100;               % Nmsrmn=2568*100;  Here, it is made as big as possible, 
                              % in case a long simulation period containing many time step is defined. 
start_time = datetime(2023, 4, 1, 0, 0, 0);  % Simulation start date
end_time = datetime(2024,12, 31, 0 ,0, 0);    % Simulation end date
current_date = start_time;
current_year = year(current_date);

% Calculate simulation duration
[seconds_interval, hours_interval, days_interval] = calculate_time_interval(start_time, end_time);
TIME = 0;                      % Initial simulation time
KT = 0;                        % Number of time steps completed
DURTN = seconds_interval; 
TEND = TIME + DURTN;       % Total simulation time (seconds)
tS = TEND / Delt_t;            % Total number of time steps
                               % Is the tS(time step) needed to be added with 1?  
                               % Cause the start of simulation period is from 0mins, 
                               % while the input data start from 30mins.
Delt_t0 = Delt_t;              % Last time step duration
Delt_old = Delt_t;
% Error tolerance settings
xERR = 0.02;                   % Moisture content change tolerance
hERR = 1e08;                   % Matric potential change tolerance
TERR = 2;                      % Temperature change tolerance
PERR = 5000;                   % Soil air pressure change tolerance (Pa,kg.m^-1.s^-1)
                                                                                   
% 初始化时间步数组
% TimeStep = zeros(tS + 1, 1);
% SUMTIME = zeros(tS + 1, 1);

%2. Spatial Domain Settings
global Tot_Depth NL nD max_elements 
global Eqlspace DeltZ NN ML mL mN SAVE SAVE1
global NS nS h_SUR Msrmn_Fitting SUMDELTZ    

Tot_Depth = 2500;              % Total depth of the soil (cm)
NL = 200;                      % Number of layers
nD=2;                          % Number of finite element nodes 
max_elements = 5000;            % Maximum number of elements for mesh  

% Uniform or non-uniform spacing indicatorNL
Eqlspace = 0;                  % 0 = Non-uniform, 1 = Uniform spacing                                                                              
if Eqlspace
    DeltZ = linspace(0, Tot_Depth, NL);
else
    [DeltZ, DeltZ_R, NL, ML] = Dtrmn_Z(NL, Tot_Depth, max_elements); % 调用不均匀间距的函数 % DeltZ是从土底到土表
    DeltZflip = flip(DeltZ);
    SUMDELTZ = cumsum(DeltZflip);
    SUMDELTZflip = flip(SUMDELTZ);
end                                                                                                                                                                   
NN=NL+1;                      % Number of nodes;                                             
mN=NN+1;                      % Number of nodes;. Prevending the exceeds of size of arraies;                                                         
mL=NL+1;                      % Number of elements. Prevending the exceeds of size of arraies;

% Number of soil types                                                     
NS=7;                         % Number of soil types;
nS=2;                         % Number of soulte types;   

% Boundary flux array (used to calculate boundary conditions)
SAVE=zeros(3,3,5);            % Arraies for calculating boundary flux; =1 water =2 Energy =3 Air =4 NH4+ =5 NO3-




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% logic variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global J ThmrlCondCap Evaptranp_Cal UseTs_msrmn h_TE W_Chg rsuef lCanopyInterception le_a Ntotal        
global Thmrlefc hThmrl Hystrs Soilairefc Nefc lBNF evfi rwuef WSI RG lExtrap lSat lUpW lArtD lActRSU  

J=1;                             % Indicator denotes the index of soil type for choosing soil physical parameters;                                 
rwuef=1;                         % Indicator denotes the index of Root water uptake;
lActRSU=1;                       % consider active root solute uptake  
if nS > 1, lActRSU=0; end        % disable for uptake on last solute
WSI=1;                           % water stress index :Value of 1 means the Feddes [1978] method,
                                 % Value of 0 means the Van[1987] method,otherwise Musters and Bouten(2000);
RG=0;                            % Root growth: Value of 1 means the winter crop method, otherwise, Logistic method; 
evfi=0;                          % The influence of environmental factors on root growth was considered
Evaptranp_Cal=2;                 % Indicator denotes the method of estimating evapotranspiration; 
                                 % Value of 1 means the ETind method, otherwise, ETdir method; 
UseTs_msrmn=1;                   % Value of 1 means the measurement Ts would be used; Otherwise, 0;                      
Msrmn_Fitting=0;                 % Value of 1 means the measurement data is used to fit the simulations; 
Hystrs=1;                        % If the value of Hystrs is 1, then the hysteresis is considered, otherwise 0;          
Thmrlefc=1;                      % Consider the isothermal water flow if the value is 0, otherwise 1;                    
Soilairefc=1;                    % The dry air transport is considered with the value of 1,otherwise 0;                  
Nefc=1;                          % The N transport is considered with the value of 1,otherwise 0;  
Ntotal = 1;                      % Use the initial total concentration in the soil                       
if rwuef==1 && Nefc==1
rsuef=1;                         % Indicator denotes the index of Root SOLUTE uptake;  
end
lBNF=0;                          % The biological nitrogen fixation value is considered to be 1
hThmrl=1;                        % Value of 1, the special calculation of water capacity is used, otherwise 0;
h_TE=1;                          % Value of 1 means that the temperature dependence                                      
                                 % of matric head would be considered.Otherwise,0;                                          
W_Chg=1;                         % Value of 0 means that the heat of wetting would                                       
                                 % be calculated by Milly's method，Otherwise,1. The                                     
                                 % method of Lyle Prunty would be used;                                                  
ThmrlCondCap=1;                  % The indicator for choosing Milly's effective thermal capacity and conductivity         
                                 % formulation to verify the vapor and heat transport in extremly dry soil.              
lExtrap = 1;                     % Must be turned on. Extrapolation of hNew from previous time step. 
lSat= 1;                         % 判读边界是否饱和,开始为1
lUpW = 1;                        % Upstream Weighted Formulation Christie et al. [1976]
lArtD = 0;                       % additional longitudinal dispersion [Perrochet and Berod, 1993]
lCanopyInterception = 1;         % = 1 consider interception
le_a =0 ;                        % =1使用Tdew计算实际水汽压，否则用温度计算
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameter definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Gsc Sigma_E  CKTN RHOL Rv g RDA R  MU_a Unit_C Hc UnitC
global Lambda1 Lambda2 Lambda3 c_L c_a c_V L0 Tr rBot
global GWT Gamma0 MU_W0 MU1 b W0 Gamma_w  ExcesInt  PeCr aInterc

rBot=0;                                                %规定的水流的底部通量[LT-1]（在狄利克雷 BC 的情况下，将此变量设置为零）。;
CKTN=(50+2.575*20);                                    % Constant used in calculating viscosity factor for hydraulic conductivity
g=981;                                                 % Gravity acceleration (cm.s^-2);
RHOL=1;                                                % Water density (g.cm^-3);
Rv=461.5*1e4;                                          % (cm^2.s^-2.Cels^-1)Gas constant for vapor (original J.kg^-1.Cels^-1);
RDA=287.1*1e4;                                         % (cm^2.s^-2.Cels^-1)Gas constant for dry air (original J.kg^-1.Cels^-1);
R=8.314;                                               % Gas constant for nomal Jmol-1 K−1
 
Unit_C=1;                                              % Change the mH2O into (kg.m^-1.s^-2)  %101325/10.3;
UnitC=100;                                             % Change of meter into centimeter;
Hc=0.02;                                               % Henry's constant;
GWT=7;                                                 % The gain factor(dimensionless),which assesses the temperature
                                                       % dependence of the soil water retention curve is set as 7 for 
                                                       % sand (Noborio et al, 1996);
MU_a=1.846*10^(-4);                                    % (g.cm^-1.s^-1)Viscosity of air (original 1.846*10^(-5)kg.m^-1.s^-1);  
Gamma0=71.89;                                          % The surface tension of soil water at 25 Cels degree. (g.s^-2);
Gamma_w=RHOL*g;                                        % Specific weight of water(g.cm^-2.s^-2);
Lambda1=0.228/UnitC;%-0.197/UnitC;% 0.243/UnitC;       % Coefficients in thermal conductivity;
Lambda2=-2.406/UnitC;%-0.962/UnitC;%  0.393/UnitC;     % W.m^-1.Cels^-1 (1 W.s=J);  From HYDRUS1D heat transport parameter.(Chung Hortan 1987 WRR)
Lambda3=4.909/UnitC;%2.521/UnitC;%  1.534/UnitC;       % UnitC is used to convert m^-1 as cm^-1 
MU_W0=2.4152*10^(-4);                                  % Viscosity of water (g.cm^-1.s^-1) at reference temperature(original 2.4152*10^(-5)kg.m^-1.s^-1);
MU1=4742.8;                                            % Coefficient for calculating viscosity of water (J.mol^-1);
b=4*10^(-6);                                           % Coefficient for calculating viscosity of water (cm);
W0=1.001*10^3;                                         % Coefficient for calculating differential heat of wetting by Milly's method
L0=597.3*4.182;
Tr=20;                                                 % Reference temperature
c_L=4.186;                                             % Specific heat capacity of liquid water (J·g^-1·Cels^-1) %%%%%%%%% Notice the original unit is 4186kg^-1
c_V=1.870;                                             % Specific heat capacity of vapor (J·g^-1·Cels^-1)
% c_a=1.255e-3;                                        % Specific heat capacity of air (J·g^-1·Cels^-1)
c_a=1.005;                                             % 0.0003*4.186; %Specific heat capacity of dry air (J·g^-1·Cels^-1)
Gsc=1360;                                              % The solar constant (1360 W·m^-2)
Sigma_E=4.90*10^(-9);                                  % The stefan-Boltzman constant.(=4.90*10^(-9) MJ·m^-2·Cels^-4·d^-1)
% 2025-4-20朱寄子星加截流
ExcesInt=0;                                            % intercepted water from previous time step
aInterc = 0.025;                                       % Constant a in the interception model (=0.25 mm/d)->cm/d
PeCr=2;                                                % A second option for minimizing or eliminating numerical  oscillations uses the criterion developed by Perrochet and Berod [1993] 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soil Hydraulic and Thermal Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global KL_h KL_T D_Ta Theta_L Theta_LL Se h hh T TT 
global W WW MU_W f0 L_WT DhT Vpore WFPS
global Lambda_eff c_unsat L LL EHCAP ETCON ZETA V_L VInfil

% Hydraulic Conductivity and Moisture
KL_h = zeros(mL,nD);        % Hydraulic conductivity (m·s^-1)
KL_T = zeros(mL,nD);        % Conductivity controlled by thermal gradient (m^2·Cels^-1·s^-1)
D_Ta = zeros(mL,nD);        % Thermal dispersivity for soil water (m^2·Cels^-1·s^-1)
Theta_L = zeros(NL,nD);     % Soil moisture at the start of current step
Theta_LL = zeros(mL,nD);    % Soil moisture at the end of current step
Se = zeros(mL,nD);          % Saturation degree of soil moisture
Vpore = zeros(mL,nD);       % volume of pores
WFPS = zeros(mL,nD);        % Water-filled Pore Space 
W=zeros(mL,nD);             % Differential heat of wetting at the start of current time step(J·kg^-1);  
WW=zeros(mL,nD);            % Differential heat of wetting at the end of current time step(J·kg^-1); 
                            % Integral heat of wetting in individual time step(J·m^-2); 
                            % Notice: the formulation of this in 'CondL_Tdisp' is not a sure.                       
MU_W=zeros(mL,nD);          % Visocity of water(kg·m^?6?1·s^?6?1);
f0=zeros(mL,nD);            % Tortusity factor [Millington and Quirk (1961)];kg.m^2.s^-2.m^-2.kg.m^-3       

VInfil = zeros(Nmsrmn,1);   % water infiltration rate(cm/s)

% Matric Head and Temperature
h = zeros(mL,1);            % Matric potential at start of time step (m)
hh = zeros(mL,1);           % Matric potential at end of time step (m)
T = zeros(mN,1);            % Soil temperature at start of time step (C)
TT = zeros(mN,1);           % Soil temperature at end of time step (C)
  
% Soil Heat Transfer Properties
Lambda_eff = zeros(mL,nD);  % Effective thermal conductivity
c_unsat = zeros(mL,nD);     % Unsaturated heat capacity
L = zeros(mN,1);            % Latent heat of vaporization at start
LL = zeros(mN,1);           % Latent heat of vaporization at end
EHCAP = zeros(mL,nD);       % Effective heat capacity
ETCON = zeros(mL,nD);       % Effective thermal conductivity
ZETA = zeros(mL,nD);        % Thermal parameter (unspecified physical meaning)
L_WT=zeros(mL,nD);          % Liquid dispersion factor in Thermal dispersivity(kg·m^-1·s^-1)=m^2 (1.5548e-013 m^2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soil dry air and vapor Transformation and Transport Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
global HR RHOV_s RHOV DRHOV_sT DRHOVh DRHOVT
global RHODA DRHODAt DRHODAz Xaa XaT Xah
global D_Vg D_V D_A Theta_V P_g P_gg Theta_g 
global k_g Sa V_A Alpha_Lg POR_C Eta Beta_g

% Soil Air Variables
P_g = zeros(mN,1);           % Soil air pressure at start
P_gg = zeros(mN,1);          % Soil air pressure at end
Theta_g = zeros(mL,nD);      % Volumetric gas content
Theta_V = zeros(mL,nD);      % Volumetric gas content (dimensionless)
V_L=zeros(mL,nD);            % Average pore water velocity=q/thetaL;

HR=zeros(mN,1);             % The relative humidity in soil pores, used for calculatin the vapor density;
RHOV_s=zeros(mN,1);         % Saturated vapor density in soil pores (kg·m^-3);
RHOV=zeros(mN,1);           % Vapor density in soil pores (kg·m^-3);
DRHOV_sT=zeros(mN,1);       % Derivative of saturated vapor density with respect to temperature;
DRHOVh=zeros(mN,1);         % Derivative of vapor density with respect to matric head;
DRHOVT=zeros(mN,1);         % Derivative of vapor density with respect to temperature;

RHODA=zeros(mN,1);          % Dry air density in soil pores(kg·m^-3);
DRHODAt=zeros(mN,1);        % Derivative of dry air density with respect to time;
DRHODAz=zeros(mN,1);        % Derivative of dry air density with respect to distance;
Xaa=zeros(mN,1);            % Coefficients of derivative of dry air density with respect to temperature and matric head;
XaT=zeros(mN,1);            % Coefficients of derivative of dry air density with respect to temperature and matric head;
Xah=zeros(mN,1);            % Coefficients of derivative of dry air density with respect to temperature and matric head;

D_Vg=zeros(mL,1);           % Gas phase longitudinal dispersion coefficient (m^2·s^-1);
D_V=zeros(mL,nD);           % Molecular diffusivity of water vapor in soil(m^2·s^-1);
D_A=zeros(mN,1);            % Diffusivity of water vapor in air (m^2·s^-1);

k_g=zeros(mL,nD);           % Intrinsic air permeability (m^2);
Sa=zeros(mL,nD);            % Saturation degree of gas in soil pores;
V_A=zeros(mL,nD);              % Soil air velocity (m·s^-1);
Alpha_Lg=zeros(mL,nD);      % Longitudinal dispersivity in gas phase (m);
POR_C=zeros(mL,nD);         % The threshold air-filled porosity;
Eta=zeros(mL,nD);           % Enhancement factor for thermal vapor transport in soil.
Beta_g=zeros(mL,nD);        % The simplified coefficient for the soil air pressure linearization equation;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soil Nitrogen Transformation and Transport Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global N Nn Nurea No3 Nno3  Retard DIF2 DISP2 Shys FT FZ
global cTop cBot cRoot cTop1 cBot1
global E1BAR DNH4DZ E2BAR DNO3DZ RetardBAR Dsh fw  
global eT eTheta ePH Smin Sden SVden Snit SVnit Svol SVvol

% Nitrogen State Variables
N=zeros(NN, 1);             % The Ammonium nitrogen at the start of current time step;
Nn=zeros(NN, 1);            % The Ammonium nitrogen at the end of current time step;
No3=zeros(NN, 1);           % The Nitrate nitrogen at the start of current time step;
Nno3=zeros(NN, 1);          % The Nitrate nitrogen at the end of current time step;
Nurea=zeros(NN,1);          % The initial content of urea in soil；

% Nitrogen Transport Properties
% DIF111=zeros(1,NS,nS);         % Soil water diffusivity(m^2.d^-1)
% DISP111=zeros(1,NS,nS);        % Longitudinal dispersivity in water phase(m)
Dsh=zeros(mL,nD,nS);            % hydrodynamic dispersion coefficient(m^2.d^-1)
Retard=zeros(mL,nD);           % RHO_bulk(kg.m^-3)*kg(m^3.kg) (-)
eT=zeros(mL,1);                % Soil temperature correction function
eTheta=zeros(mL,1);            % Soil moisture correction function
ePH=zeros(mL,1);               % Soil PH correction function
FT=zeros(mN,1);                % Soil temperature correction function at vola
FZ=zeros(mN,1);                % Soil depth correction function at vola
Sden=zeros(mL,nD);             % Denitrification  rate (μg/(cm^3.S))
SVden=zeros(mL,nD);            % Denitrification  rate constant (μg/(cm^3.S))
Smin=zeros(mL,nD);             % Mineralization  rate (μg/(cm^3.S))
Snit=zeros(mL,nD);             % Nitrification rate (μg/(cm^3.S))
SVnit=zeros(mL,nD);            % Nitrification rate constant (μg/(cm^3.S))
Svol=zeros(mL,nD);             % Ammonia volatilization rate (μg/(cm^3.S))
SVvol=zeros(mL,nD);            % Ammonia volatilization rate constant (μg/(cm^3.S))
Shys=zeros(mL,nD);             % urea hydrolysis rate (μg/(cm^3.S))
fw=zeros(mL,nD);               % Liquid phase pore tortuosity
DISP2=zeros(mL);               % dispersion coefficient of solute(m^2.s^-1)
DIF2=zeros(mL,nD,nS);          % Molecular diffusion coefficient of solute in soil(s^2.m^-1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meteorological Forcing Information Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Precip Ta U Ts HR_a Rn Rns Rnl MO TopPg Zeta_MO SH Tmax Tmin Hrmax Hrmin Um CanopyInterception Throughfall

Precip=zeros(Nmsrmn,1);     % Precipitation(m.s^-1);
Ta=zeros(Nmsrmn,1);         % Air temperature;
Ts=zeros(Nmsrmn,1);         % Surface temperature;
U=zeros(Nmsrmn,1);          % Wind speed (m.s^-1);
HR_a=zeros(Nmsrmn,1);       % Air relative humidity;
Rns=zeros(Nmsrmn,1);        % Net shortwave radiation(W·m^-2);
Rnl=zeros(Nmsrmn,1);        % Net longwave radiation(W·m^-2);
Rn=zeros(Nmsrmn,1);         % Net radiation(W·m^-2);
h_SUR=zeros(Nmsrmn,1);      % Observed matric potential at surface;
SH=zeros(Nmsrmn,1);         % Sensible heat (W·m^-2);
MO=zeros(Nmsrmn,1);         % Monin-Obukhov's stability parameter (MO Length);
Zeta_MO=zeros(Nmsrmn,1);    % Atmospheric stability parameter;
TopPg=zeros(Nmsrmn,1);      % Atmospheric pressure above the surface as the boundary condition (Pa);
CanopyInterception = zeros(Nmsrmn,1); %canopy interception (cm/s)
Throughfall= zeros(Nmsrmn,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Root Water Uptake and Root Soulte Uptake  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global alpha_h bx Srt b1 b11 ALPHA
global cc SinkS AUptakeA SPUptake SAUptake SAUptakeP SAUptakeA SAUptakeAN SPOT

% root water uptake 
alpha_h=zeros(mL,nD); 
ALPHA = zeros(mL); 
b1=zeros(mL,nD); 
b11=zeros(mL,nD);
bx=zeros(mL,nD);
Srt=zeros(mL,nD);

% root Soulte Uptake
cc=zeros(mN,1);             % The concentration of solute absorption at the beginning of the root system;
SinkS=zeros(mL,nD,nS);      % Passive solute absorption rate or Sum solute uptake;
SPUptake=zeros(Nmsrmn,nS);  % Passive solute absorption throughout the root zone 
SAUptakeP=zeros(Nmsrmn,1);  % potential active solute uptake
AUptakeA=zeros(mL,nD);      % Actual local active solute uptake rate 
SAUptake=zeros(Nmsrmn,1);   % Actual avtive solute uptake throughout the root zone
SAUptakeAN=zeros(Nmsrmn,1); % uncompensated actual active solute uptake throughout the root zone 
SAUptakeA=zeros(Nmsrmn,1);  % compensated actual active solute uptake throughout the root zone
SPOT=zeros(Nmsrmn,1);       % MAX solute uptake throughout the root zone

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrix parameter  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Chh ChT Khh KhT Kha Vvh VvT Chg RHS RHS1
global C1 C1O C2 C2O C3 C4 C5 C6 C7 C9 C3_a C4_a C5_a C6_a 
global R1 R1O E1 B1 F1 G1 R2 R2O E2 B2 F2 G2
global CTh CTT CTa KTh KTT KTa VTT VTh VTa CTg
global Kcvh KcvT Kcva Ccvh CcvT Kcah KcaT Kcaa Ccah CcaT Ccaa 
global Cah CaT Caa Kah KaT Kaa Vah VaT Vaa Cag

DhT=zeros(mN,1);            % Difference of matric head with respect to temperature;              m. kg.m^-1.s^-1
RHS=zeros(mN,1);            % The right hand side part of equations in '*_EQ' subroutine;
RHS1=zeros(mN,1);           % The right hand side part of equations in '*_EQ' subroutine;
Chh=zeros(mL,nD);           % Storage coefficients in moisture mass conservation equation related to matric head;
ChT=zeros(mL,nD);           % Storage coefficients in moisture mass conservation equation related to temperature;
Khh=zeros(mL,nD);           % Conduction coefficients in moisture mass conservation equation related to matric head;
KhT=zeros(mL,nD);           % Conduction coefficients in moisture mass conservation equation related to temperature;
Kha=zeros(mL,nD);           % Conduction coefficients in moisture mass conservation equation related to soil air pressure;
Vvh=zeros(mL,nD);           % Conduction coefficients in moisture mass conservation equation related to matric head;
VvT=zeros(mL,nD);           % Conduction coefficients in moisture mass conservation equation related tempearture;
Chg=zeros(mL,nD);           % Gravity coefficients in moisture mass conservation equation;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C1=zeros(mL,nD);            % The coefficients for storage term related to matric head or NH4+__N;
C1O=zeros(mL,nD);           % The coefficients for storage term related to NH4+__N at the start of current time step;
C2=zeros(mL,nD);            % The coefficients for storage term related to tempearture or N03-__N;
C2O=zeros(mL,nD);           % The coefficients for storage term related to N03-__N at the start of current time step;
C3=zeros(mL,nD);            % Storage term coefficients related to soil air pressure or Conductivity term coefficients and Conversion parameter related to NH4+__N;
C4=zeros(mL,nD);            % Conductivity term coefficients related to matric head or Conductivity term coefficients and Conversion parameter related to N03-__N;
C5=zeros(mL,nD);            % Conductivity term coefficients related to temperature or source coefficients to NH4+__N;
C6=zeros(mL,nD);            % Conductivity term coefficients related to soil air pressure or source coefficients to NH4+__N;
C7=zeros(mN,1);             % Gravity term coefficients;
C9=zeros(mN,1);             % root water uptake coefficients;
C3_a=zeros(mN,1);           % C3 Lower diagonal value;
C4_a=zeros(mN,1);           % C4 Lower diagonal value;
C5_a=zeros(mN,1);           % C5 Lower diagonal value;
C6_a=zeros(mN,1);           % C6 Lower diagonal value;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R1=zeros(mL,nD);            % Storage coefficients in Ammonium nitrogen conservation equation related to concentration  at the end of current time step ;
R1O=zeros(mL,nD);           % Storage coefficients in Ammonium nitrogen conservation equation related to concentration  at the start of current time step;
E1=zeros(mL,nD);            % Conduction coefficients in Ammonium nitrogen conservation equation related to concentration;  
B1=zeros(mL,nD);            % Conduction coefficients in Ammonium nitrogen conservation equation related to water flux;
F1=zeros(mL,nD);            % First order conversion rate of ammonium nitrogen;
G1=zeros(mL,nD);            % Zero order conversion rate of ammonium nitrogen;
R2=zeros(mL,nD);            % Storage coefficients in Nitrate nitrogen conservation equation related to concentration  at the end of current time step ;
R2O=zeros(mL,nD);           % Storage coefficients in Nitrate nitrogen conservation equation related to concentration  at the start of current time step;
E2=zeros(mL,nD);            % Conduction coefficients in Nitrate nitrogen conservation equation related to concentration;  
B2=zeros(mL,nD);            % Conduction coefficients in Nitrate nitrogen conservation equation related to water flux;
F2=zeros(mL,nD);            % First order conversion rate of Nitrate nitrogen;
G2=zeros(mL,nD);            % Zero order conversion rate of Nitrate nitrogen;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cah=zeros(mL,nD);           % Storage coefficients in dry air mass conservation equation related to matric head;
CaT=zeros(mL,nD);           % Storage coefficients in dry air mass conservation equation related to temperature;
Caa=zeros(mL,nD);           % Storage coefficients in dry air mass conservation equation related to soil air pressure;
Kah=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to matric head;
KaT=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to temperature;
Kaa=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to soil air pressure;
Vah=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to matric head;
VaT=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to temperature;
Vaa=zeros(mL,nD);           % Conduction coefficients in dry air mass conservation equation related to soil air pressure;
Cag=zeros(mL,nD);           % Gravity coefficients in dry air mass conservation equation;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CTh=zeros(mL,nD);           % Storage coefficient in energy conservation equation related to matric head;
CTT=zeros(mL,nD);           % Storage coefficient in energy conservation equation related to temperature;
CTa=zeros(mL,nD);           % Storage coefficient in energy conservation equation related to soil air pressure;
KTh=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to matric head;
KTT=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to temperature;
KTa=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to soil air pressure;
VTT=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to matric head;
VTh=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to temperature;
VTa=zeros(mL,nD);           % Conduction coefficient in energy conservation equation related to soil air pressure;
CTg=zeros(mL,nD);           % Gravity coefficient in energy conservation equation;

Kcvh=zeros(mL,nD);          % Conduction coefficient of vapor transport in energy conservation equation related to matric head;
KcvT=zeros(mL,nD);          % Conduction coefficient of vapor transport in energy conservation equation related to temperature;
Kcva=zeros(mL,nD);          % Conduction coefficient of vapor transport in energy conservation equation related to soil air pressure;
Ccvh=zeros(mL,nD);          % Storage coefficient of vapor transport in energy conservation equation related to matric head;
CcvT=zeros(mL,nD);          % Storage coefficient of vapor transport in energy conservation equation related to temperature;
Kcah=zeros(mL,nD);          % Conduction coefficient of dry air transport in energy conservation equation related to matric head;
KcaT=zeros(mL,nD);          % Conduction coefficient of dry air transport in energy conservation equation related to temperature;
Kcaa=zeros(mL,nD);          % Conduction coefficient of dry air transport in energy conservation equation related to soil air pressure;
Ccah=zeros(mL,nD);          % Storage coefficient of dry air transport in energy conservation equation related to matric head;
CcaT=zeros(mL,nD);          % Storage coefficient of dry air transport in energy conservation equation related to temperature;
Ccaa=zeros(mL,nD);          % Storage coefficient of dry air transport in energy conservation equation related to soil air pressure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fluxes information with different mechanisms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global QL QL_D QL_disp QL_Dts QL_dispts QLts QV_Dts QV_Ats QV_dispts QVts QA_Dts QA_Ats QA_dispts QAts
global QV QV_D QV_A QVA QV_disp QA_D QA_A QA_disp Qa QL_T QL_h QL_A QV_T QV_h DhDZ DTDZ DPgDZ
global KLhBAR KLTBAR RHOVBAR EtaBAR Lambda_effBAR c_unsatBAR DTDBAR DETBAR Theta_LLBAR DEhBAR DRHOVhDz DRHOVTDz DIF2BAR
global QNH4 QNO3  cvTop cvBot cvTop1 cvBot1 cvSnit cvSmin cvSden cvSinkS cvSinkS1 Cvnit_N2o Cvdenit_N2o Cvdenit_N2 cvnh4OLD cvno3OLD cvnh4 cvno3 cvSvol
QL=zeros(NL,1);               % Soil moisture mass flux (kg·m^-2·s^-1);
QL_D=zeros(mL,1);             % Convective moisturemass flux (kg·m^-2·s^-1);
QL_disp=zeros(mL,1);          % Dispersive moisture mass flux (kg·m^-2·s^-1);
QL_h=zeros(mL,1);             % potential driven moisture mass flux (kg·m^-2·s^-1);
QL_T=zeros(mL,1);             % temperature driven moisture mass flux (kg·m^-2·s^-1);
QL_A=zeros(mL,1);             % pressure driven moisture mass flux (kg·m^-2·s^-1);
QL_Dts=zeros(mL,1);            % Convective moisture mass flux in one time step;
QL_dispts=zeros(mL,1);         % Dispersive moisture mass flux in one time step;
QLts=zeros(mL,1);              % Total moisture mass flux in one time step;

QV=zeros(mL,nD);               % Soil vapor mass flux (kg·m^-2·s^-1);
QV_h=zeros(mL,nD);             % potential driven vapor mass flux (kg·m^-2·s^-1);
QV_T=zeros(mL,nD);             % temperature driven vapor mass flux (kg·m^-2·s^-1);
QVA=zeros(mL,nD);
DhDZ=zeros(mL,1);
DTDZ=zeros(mL,1);
KLhBAR=zeros(mL,1);
KLTBAR=zeros(mL,1);
RHOVBAR=zeros(mL,1);
EtaBAR=zeros(mL,1);
Lambda_effBAR=zeros(mL,1);
c_unsatBAR=zeros(mL,1);
Theta_LLBAR=zeros(mL,1);
DPgDZ=zeros(mL,1);
DTDBAR=zeros(mL,1);
DETBAR=zeros(mL,1);
DEhBAR=zeros(mL,1);
DRHOVhDz=zeros(mL,1);
DRHOVTDz=zeros(mL,1);
DIF2BAR=zeros(mL,1,nS);

QV_D=zeros(mL,1);               % Diffusive vapor mass flux;
QV_A=zeros(mL,1);               % Convective vapor mass flux;
QV_disp=zeros(mL,1);            % Dispersive vapor mass flux;
QV_Dts=zeros(mL,1);             % Diffusive vapor mass flux in one time step;
QV_Ats=zeros(mL,1);             % Convective vapor mass flux in one time step;
QV_dispts=zeros(mL,1);          % Dispersive vapor mass flux in one time step;
QVts=zeros(mL,1);               % Total vapor mass flux in one time step;

QA_D=zeros(mL,1);               % Diffusive dry air mass flux;
QA_A=zeros(mL,1);               % Convective dry air mass flux;
QA_disp=zeros(mL,1);            % Dispersive dry air mass flux;
QA_Dts=zeros(mL,1);             % Diffusive dry air mass flux in one time step;
QA_Ats=zeros(mL,1);             % Convective dry air mass flux in one time step;
QA_dispts=zeros(mL,1);          % Dispersive dry air mass flux in one time step;
QAts=zeros(mL,1);               % Total dry air mass flux in one time step;
Qa=zeros(mL,1);

QNH4=zeros(mL,1);
QNO3=zeros(mL,1);
cvnh4OLD=zeros(1,Nmsrmn);
cvno3OLD=zeros(1,Nmsrmn);
cvnh4=zeros(1,Nmsrmn);
cvno3=zeros(1,Nmsrmn);
cvTop=zeros(1,Nmsrmn);        % Surface Solute concentration Flux
cvBot=zeros(1,Nmsrmn);        % Bottom Solute concentration Flux
cvTop1=zeros(1,Nmsrmn);       % Surface Solute concentration Flux
cvBot1=zeros(1,Nmsrmn);       % Bottom Solute concentration Flux
cvSvol=zeros(1,Nmsrmn);       % the solute ammonium volatilization
cvSnit=zeros(1,Nmsrmn);       % Ammonium nitrogen nitrification concentration flux            
cvSmin=zeros(1,Nmsrmn);       % Organic nitrogen mineralization concentration flux 
cvSden=zeros(1,Nmsrmn);       % Nitrate denitrification concentration flux
cvSinkS=zeros(1,Nmsrmn);      % Ammonium nitrogen Solute concentration Uptake
cvSinkS1=zeros(1,Nmsrmn);     % Nitrate Solute Uptake
Cvnit_N2o=zeros(1,Nmsrmn);    % the concentration flux of nitrified N lost as N2O flux
Cvdenit_N2o=zeros(1,Nmsrmn);  % the concentration flux of denitrified N lost as N2O flux
Cvdenit_N2=zeros(1,Nmsrmn);   % the concentration flux of denitrified N  as N2 flux
cTop=zeros(Nmsrmn,1);         % Surface Concentration of Ammonium
cBot=zeros(Nmsrmn,1);         % Bottom Concentration of Ammonium
cTop1=zeros(Nmsrmn,1);        % Surface Concentration of Nitrate
cBot1=zeros(Nmsrmn,1);        % Bottom Concentration of Nitrate
cRoot=zeros(mL,nD,nS);        % Root Zone Concentration    
E1BAR=zeros(mL,1);
E2BAR=zeros(mL,1);
DNH4DZ=zeros(mL,1);
DNO3DZ=zeros(mL,1);
RetardBAR=zeros(mL,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable information for updating the state variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global hOLD TOLD P_gOLD NOLD Nno3OLD    

hOLD=zeros(mL,1);           % Array used to get the matric head at the end of last time step and extraplot the matric head at the start of current time step;
TOLD=zeros(mL,1);           % The same meanings of hOLD,but for temperature;
P_gOLD=zeros(mL,1);         % The same meanins of TOLD,but for soil air pressure;
NOLD=zeros(mL,1);           % The same meanins of NH4+OLD,but for N transport ;
Nno3OLD=zeros(mL,1);        % The same meanins of NO3-OLD,but for N transport ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables information for boundary condition settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global DVhSUM DVTSUM DVaSUM KahSUM KaTSUM KaaSUM  KLhhSUM KLTTSUM Ts1 Tb

DVhSUM=zeros(Nmsrmn/2,1);DVTSUM=zeros(Nmsrmn/2,1); DVaSUM=zeros(Nmsrmn/2,1); 
KahSUM=zeros(Nmsrmn/2,1); KaTSUM=zeros(Nmsrmn/2,1); KaaSUM=zeros(Nmsrmn/2,1);  
KLhhSUM=zeros(Nmsrmn/2,1); KLTTSUM=zeros(Nmsrmn/2,1);
Ts1 = zeros(1, Nmsrmn);  % 初始化地表温度数组
Tb = zeros(1, Nmsrmn);   % 初始化底部温度数组

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial soilproperty and Meteorological data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run soilpropertyread.m


