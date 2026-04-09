% 输入示例数据
HU = [10, 15, 20, 18, 25, 30, 35];  % 每天的热量单元
CHU = cumsum(HU);  % 累积热量单元
GMHU = 100;  % 从萌发到叶面积最大所需的热量单元
XLAI = 5;  % 最大叶面积指数
dHUF = 0.1;  % 与热量单元指数HUI相关的变化量
SHRL = [1, 1, 1, 1, 1, 1, 1];  % 作物未冬眠

% 胁迫因子输入数据
T_av = [18, 20, 22, 24, 26, 28, 30];  % 日平均温度
T_b = 5;    % 基准温度
T_op = 25;  % 最佳温度

UN = [150, 160, 170, 180, 190, 200, 210];   % 实际氮含量
UNO = 200;  % 最佳氮含量

theta = [0.25, 0.30, 0.32, 0.35, 0.38, 0.40, 0.42];  % 土壤实际含水量
theta_b = 0.1;  % 土壤临界含水量
theta_s = 0.4;  % 土壤饱和含水量
C_f = 0.85;  % 临界通风因子

% HUI 和 LAI 衰减的参数
HUI = [0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9];  % 热量单元指数
HUI_D = 0.7;  % 开始衰减的热量单元指数
beta = 1.0;   % LAI 衰减速率系数

% 计算 LAI 和胁迫因子
[LAI, f_T, f_nut, f_wd] = CalculateLAIAndStressFactorsWithDecay(HU, CHU, GMHU, XLAI, dHUF, T_av, T_b, T_op, UN, UNO, theta, theta_b, theta_s, C_f, SHRL, HUI, HUI_D, beta);

% 显示结果
disp('叶面积指数 (LAI):');
disp(LAI);
disp('温度胁迫因子 f_T:');
disp(f_T);
disp('养分胁迫因子 f_nut:');
disp(f_nut);
disp('通风胁迫因子 f_wd:');
disp(f_wd);
