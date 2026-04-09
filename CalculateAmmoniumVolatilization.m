function [Svol]=CalculateAmmoniumVolatilization(TT,N,NL,PH1,KT,Svol,Tm,u_2,NN,NoTime)
% Calculate the solute ammonium volatilization μg/(cm2·s)
    
    C_ammonium=0;%大气中的氨气浓度，一般设置为0如果有实测可以改成实测输入
    L=0.0025; % 挥发特征长度m
    
    %方法一：Freney(1985)
    % KH = (2.39*10^5/(Tm(KT)+273.15))*exp(-4151/(Tm(KT)+273.15)); % Henry’s law constant Kh
    % hm = 48.4*u_2(KT)^0.8*(Tm(KT)+273.15)^-1.4; % m/s   % hm is the convective mass transfer coefficient
    % Svol(NL,2)=hm*((KH*(N(NN))/(1+10^(0.09018+(2729.92/(TT(NN)+273.15))-PH1(5))))-C_ammonium); % μg/(cm2·s)
     
    %方法二
   
    if NoTime(KT) <=0
        KH = (0.2138/(Tm(1)+273.15))*10^(6.123-1825/(Tm(1)+273.15));
        hm = 0.000612*u_2(1)^0.8*(Tm(1)+273.15)^0.382*L^-0.2;
        Svol(NL,2)=hm*((KH*(N(NN))/(1+10^(-0.05+(2788/(TT(NN)+273.15))-PH1(5))))-C_ammonium);
    else
        KH = (0.2138/(Tm(NoTime(KT)+1)+273.15))*10^(6.123-1825/(Tm(NoTime(KT)+1)+273.15));
        hm = 0.000612*u_2(NoTime(KT)+1)^0.8*(Tm(NoTime(KT)+1)+273.15)^0.382*L^-0.2;
        Svol(NL,2)=hm*((KH*(N(NN))/(1+10^(-0.05+(2788/(TT(NN)+273.15))-PH1(5))))-C_ammonium);
    end


  

