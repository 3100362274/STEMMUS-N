%% 一维溶质运移有限元求解（非均匀网格 + 向后差分）
% 控制方程: ∂c/∂t + u*∂c/∂x = D*∂²c/∂x²
% 边界条件: c(0,t) = c_left (固定浓度), ∂c/∂x(L,t) = 0 (右端零梯度)
% 初始条件: c(x,0) = 0

clc; clear; close all;

%% 参数定义
L = 10.0;        % 空间域长度 [m]
T = 5.0;         % 总模拟时间 [s]
D = 0.1;         % 扩散系数 [m²/s]
u = 0.5;         % 流速 [m/s]
c_left = 1.0;    % 左边界浓度
Nx = 20;         % 空间节点数
Nt = 100;        % 时间步数
dt = T/Nt;       % 时间步长 [s]

%% 生成非均匀空间网格（线性递增步长）
x = zeros(Nx,1);          % 网格节点坐标
h = zeros(Nx-1,1);        % 单元长度
x(1) = 0;                 % 左端点
dx_min = L/(Nx*(Nx-1)/2); % 最小步长（等差基数）
for i = 1:Nx-1
    h(i) = dx_min * i;     % 单元长度线性递增
    x(i+1) = x(i) + h(i); 
end

%% 组装全局质量矩阵 M 和刚度矩阵 K
M = zeros(Nx,Nx);     % 质量矩阵
K = zeros(Nx,Nx);     % 刚度矩阵（扩散 + 对流）

% 遍历每个单元进行局部矩阵计算并组装
for e = 1:Nx-1
    % 当前单元节点编号
    n1 = e;
    n2 = e+1;
    
    % 单元长度
    he = h(e);
    
    % 局部质量矩阵 (积分 phi_i*phi_j)
    Me = he/6 * [2, 1; 
                 1, 2];
    
    % 局部扩散矩阵 (积分 D*dphi_i/dx * dphi_j/dx)
    Ke_diff = D/he * [1, -1; 
                     -1, 1];
    
    % 局部对流矩阵 (积分 u*phi_i*dphi_j/dx)
    Ke_conv = u/2 * [-1, 1; 
                    -1, 1];
    
    % 合并局部刚度矩阵
    Ke = Ke_diff + Ke_conv;
    
    % 组装到全局矩阵
    M([n1,n2],[n1,n2]) = M([n1,n2],[n1,n2]) + Me;
    K([n1,n2],[n1,n2]) = K([n1,n2],[n1,n2]) + Ke;
end

%% 处理边界条件
% 左边界固定浓度 (Dirichlet)
M(1,:) = 0;    M(1,1) = 1;    % 质量矩阵第一行清零，对角线置1
K(1,:) = 0;    K(1,1) = 1;    % 刚度矩阵同理

% 右边界零梯度 (Neumann): 自然边界条件，无需额外处理

%% 初始化浓度场
c_old = zeros(Nx,1);     % 初始浓度全为0
c_old(1) = c_left;       % 左边界初始值

%% 时间步进求解（向后差分）
c_history = zeros(Nx,Nt); % 存储浓度历史
for n = 1:Nt
    % 构造线性方程组: (M + dt*K)*c_new = M*c_old + dt*F
    % 此处无源项，F = 0
    
    A = M + dt*K;         % 系统矩阵
    b = M * c_old;        % 右端项
    
    % 更新左边界固定值
    b(1) = c_left;        % 直接覆盖
    
    % 求解线性方程组
    c_new = A \ b;
    
    % 更新浓度场
    c_old = c_new;
    c_history(:,n) = c_new;
end

%% 结果可视化
[X, T_grid] = meshgrid(x, linspace(0,T,Nt));
surf(X, T_grid, c_history', 'EdgeColor', 'none');
xlabel('空间位置 x [m]');
ylabel('时间 t [s]');
zlabel('浓度 c');
title('一维溶质运移有限元解');
colorbar;