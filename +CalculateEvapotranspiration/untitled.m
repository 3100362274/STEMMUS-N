% Residual Equation for Surface Temperature Calculation
% soultions to the surface temperature of wet organisms
% Equation : Residual function for the surface temperature:
% f(Tl) = - Ri + epsilon * sigma * Tl^4 + h_t(Tl - Ta) + h_e(e_s(Tl) - e_a)
% Where:
% - Ri: Heat flux term
% - epsilon: Emissivity
% - sigma: Stefan-Boltzmann constant
% - h: Heat transfer coefficient
% - e(Tl): Saturation vapor pressure at temperature 
% - e_a: Ambient vapor pressure
% - T_a: Ambient temperature
% This equation accounts for radiation, heat transfer, and the effects of saturation vapor pressure.
%
% The first derivative of the residual function:
% f'(Tl) = 4 * epsilon * sigma * Tl^3 + h_t + h_e * S
% Where:
% - h_e: Water vapor transfer coefficient
% - S:  is the slope of the saturation vapor pressure curve d(e_s(Tl))/dT
%
% Quartic Solution Method for Wet Surface Energy Budget:
% A quartic solution method is used for solving the energy budget for the wet surface. However, the
% non-linearity of the saturation vapor pressure term e(T_l) needs to be approximated for a solution.
% The solution can be derived if the saturation vapor pressure function is approximated as a 4th or lower
% order polynomial.
%
% Wet Equivalent Temperature Calculation using 4th-order Polynomial Fit for Saturation Vapor Pressure
%
% In this method, a 4th-order polynomial is used to fit the saturation vapor pressure function 
% for the temperature range from 0°C to 45°C. The polynomial regression results are similar to Lowe's 
% (1977) 6th-order regression, providing high accuracy for the fit. The accuracy of the fit is 
% comparable to the Goff-Gratch equation, with the largest error of 0.3% at 0°C, reducing to less than 
% 0.1% from 5°C to 45°C within the biological temperature range.
%
% Polynomial equation for saturation vapor pressure:
% e_s(T) = xi + alpha*T + beta*T^2 + psi*T^3 + mu*T^4
% Where:
% - xi, alpha, beta, psi, mu are the coefficients obtained from polynomial regression.
%
% The accuracy of this method is at least as good as or better than most equations reported in 
% the literature (e.g., Osborne and Meyers, 1934; Langlois, 1967; Wexler and Greenspan, 1971).
%
% The use of this 4th-order equation allows for:
% - A quartic solution that simplifies the derivation with respect to temperature.
% - The ability to solve using linearized, quadratic, and iterative solutions.
%
% This equation provides a more accurate model for saturation vapor pressure in the temperature range 
% of biological interest and allows for efficient temperature calculations.
%
% This method provides an efficient and accurate way to calculate the wet equivalent temperature 
% based on the polynomial fit for the saturation vapor pressure, using the coefficients provided.
% References:
% Lowe, P. R. (1977). An approximating polynomial for the computation of saturation vapor pressure. 
% J. Appl. Meteorol., 16, 100-103.
%
% Osborne, N. S., & Meyers, C. H. (1934). A formula and tables for the pressure of saturated water vapor 
% in the range 0 to 374°C. J. Res. (NBS), 13, 1-20.
%
% Langlois, W. E. (1967). A rational approximation for saturation vapor pressure over the temperature range 
% of sea water. J. Appl. Meteorol., 6, 451.
%
% Wexler, A., & Greenspan, L. (1971). Vapor pressure equation for water in the range 0 to 100°C. 
% J. Res. (NBS), 75A, 213-230.
epsilon = 0.95;   % 叶片辐射放射率
sigma = 5.67e-8;  % 斯特藩-玻尔兹曼常数 (W/m^2·K^4)
h_mu = 10;        % 热传导系数，示例值

K1 = 273.15;       % being the conversion temperature between the Kelvin scale and the Celsius scale
Ri = 50;          % 叶片吸收的长波辐射和短波辐射之和absorbed radiation (wm-2)
T_a = 25;         % 环境温度 (°C)

rho = 1.225;   % 空气密度，单位：kg/m^3
Cp = 1005;     % 比热容，单位：J/(kg·K)
% gama   % 干湿比常数，单位：无单位
r_b = 0.1;     % 水汽的边界层阻力 (s/m)
r_s = 0.05;    % 水汽的气孔阻力 (s/m)

% 计算水汽传递系数 h_e
h_e = (rho * Cp) / (gama * (r_A + r_s));

% 计算热量传递系数 h_t
h_t = (rho * Cp) / r_A;

mu = 5.818e-4;   % Pa°C^-4
psi = 1.408e-2;  % Pa°C^-3
beta = 1.675e0;  % Pa°C^-2
alpha = 4.222e1; % Pa°C^-1
xi = 6.174e2;    % Pa

k = epsilon * sigma + h_e * mu;  % 计算k
a_prime = 4 * epsilon * sigma * K1  + h_e * psi;  % 计算a'
b_prime = 6 * epsilon * sigma * K1^2 + h_e * beta;  % 计算b'
c_prime = 4 * epsilon * sigma * K1^3 + h_e * alpha + h_t;  % 计算c'
d_prime = -Ri + epsilon * sigma * K1^4 + xi * h_e - h_e * e_a - h_t * T_a;  % 计算d'


coefficients = [k, a_prime, b_prime, c_prime, d_prime];

Tl = roots(coefficients);

e_s = xi + alpha * Tl + beta * Tl^2 + psi * Tl^3 + mu * Tl^4;

% 输出所有的根
disp('计算得到的所有根：');
disp(T_s_roots);

% 选择一个合理的实根（根据物理意义，选择正的温度）
T_s_real = T_s_roots(real(T_s_roots) > 0);

disp('有效的表面温度 T_s：');
disp(T_s_real);
