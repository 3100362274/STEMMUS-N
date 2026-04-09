function Forcing_PARM
global tmax1 TIME KT TIMEOLD NBCT DURTN
global Hrmax Hrmin HR_a RHmax RHmin RHa Tmax Tmin Tm Ta Umax Umin Um Ur U
global TopPg P Precip   NoTime SUMTIME
global Rn Rns Rnl     
global SH P_Va RHOV_A Rv h_SUR u_2  
global Ts Ts_msr Z Soilairefc
global Pg_w Pg_a0 Pg_a Pg_b Ts_a0 Ts_a Ts_w Ts_b Tsmax Tsmin Hsur_w Hsur_a0 Hsur_a Hsur_b Kcb LAI_act
    
    if TIMEOLD==KT
        Ta(KT)=0;HR_a(KT)=0;Ts(KT)=0;U(KT)=0;SH(KT)=0;Rns(KT)=0;Rnl(KT)=0;Rn(KT)=0;h_SUR(KT)=0;%TopPg(KT)=0;
    end
    if Soilairefc == 1
        if NBCT==1 && KT==1
            Ts(1)=0;
        end
    end
    % Unit of windspeed (cm/s)
    Um=100.*u_2';
    
    %relative humidity (cm/s)
    Hrmax=0.01.*RHmax';
    Hrmin=0.01.*RHmin';
    HR_a=0.01.*RHa';
    NoTime(KT)=fix(SUMTIME(KT)/3600/24);
    if  NoTime(KT)<=0%TIME<DURTN
        
        Tmax1(KT)=Tmax(1);
        Tmin1(KT)=Tmin(1);
        %Ta(KT)=Tm(NoTime(KT));
        %Ta(KT)=(Tmax(KT)+Tmin(KT))/2;
        Ta(KT)=Ta(KT)+(Tmax1(KT)+Tmin1(KT))/2+(Tmax1(KT)-Tmin1(KT))/2*cos(2*pi()*((TIME-(1-1)*86400)/3600-15)/24);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%% soil surface temperature%%%%%%%%%%%%%%%
        % Tsmax=Tsmax(1);
        % Tsmin=Tsmin(1);
        % Tsmax(KT)=Tsmax;
        % Tsmin(KT)=Tsmin;
        % Ts(KT)=Ts(KT)+(Tsmax(KT)+Tsmin(KT))/2+(Tsmax(KT)-Tsmin(KT))/2*cos(2*pi()*((TIME-(1-1)*86400)/3600-13)/24);
        Tsmax=Tmax(1);
        Tsmin=Tmin(1);
        Tsmax(KT)=Tsmax;
        Tsmin(KT)=Tsmin;
        %Ts(KT)=Ts(KT)+Ts_msr(1)+(Tsmax(KT)-Tsmin(KT))/2*cos(2*pi()*((TIME-(1-1)*86400)/3600-13)/24);
        Ts(KT)=Ts_msr(ceil(SUMTIME(KT) / 3600));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Precip%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Precip(KT)=P(1)*0.1/3600/24;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%% Humidity%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hrmin1(KT)=RHmin(1);
        Hrmax1(KT)=RHmax(1);
        %HR_a(KT)=HR_a(NoTime(KT));
        %HR_a(KT)=(Hrmax(KT)+Hrmin(KT))/2;
        HR_a(KT)=(Hrmax1(KT)+Hrmin1(KT))/2+(Hrmax1(KT)-Hrmin1(KT))/2*cos(2*pi()*((TIME-(1-1)*86400)/3600-6)/24);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Wind%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % wind Ur=Umax/Umin; according to the previous observations, set as 2/0.2=10;
        % Tmax set as 1500h;
        Um1(KT)=Um(1);
        tmax1 =15;
        if Um1(KT)<80
            Ur=2.5;
        elseif Um1(KT)<200
            Ur=9;
        else
            Ur=15;
        end
        Umax(KT)=2*Ur*Um1(KT)/(1+Ur);
        Umin(KT)=2*Um1(KT)/(1+Ur);
        U(KT)=Um1(KT)+(Umax(KT)-Umin(KT))*cos(2*pi()*((TIME-(1-1)*86400)/3600-tmax1)/24);
        % U(KT)=Um(KT);
        % % 计算不同高度风速 m / s
        % afa = 0.28;
        % if h_v(1) == 0
        %     u_h(KT) = u_2(1) * (2 / 2) ^ afa;
        % else
        %     u_h(KT) = u_2(1) * (h_v(1) / 2) ^ afa;
        % end
    else
        Tmax1(KT)=Tmax(NoTime(KT)+1);
        Tmin1(KT)=Tmin(NoTime(KT)+1);
        % Ta(KT)=Tm(KT);
        % Ta(KT)=(Tmax(KT)+Tmin(KT))/2;
        Ta(KT)=Ta(KT)+(Tmax1(KT)+Tmin1(KT))/2+(Tmax1(KT)-Tmin1(KT))/2*cos(2*pi()*((TIME-(NoTime(KT)+1-1)*86400)/3600-17)/24);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%soil surface temperature%%%%%%%%%%%%%%%
        Tsmax=Tmax(NoTime(KT)+1);
        Tsmin=Tmin(NoTime(KT)+1);
        Tsmax(KT)=Tsmax;
        Tsmin(KT)=Tsmin;
        Ts(KT)=Ts_msr(ceil(SUMTIME(KT) / 3600));
        %%%%%%%%%%%%%%%%%%%%%%%%%%% Precip%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Precip(KT)=P(ceil(SUMTIME(KT) / 3600))*0.1/3600;
        Precip(KT)=P(NoTime(KT)+1)*0.1/3600/24;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Humidity%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hrmin1(KT)=Hrmin(NoTime(KT)+1);
        Hrmax1(KT)=Hrmax(NoTime(KT)+1);
        % HR_a(KT)=RHa(NoTime(KT));
        % HR_a(KT)=(Hrmax(KT)+Hrmin(KT))/2;
        HR_a(KT)=(Hrmax1(KT)+Hrmin1(KT))/2+(Hrmax1(KT)-Hrmin1(KT))/2*cos(2*pi()*((TIME-(NoTime(KT)+1-1)*86400)/3600-6)/24);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% Wind%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % wind Ur=Umax/Umin; according to the previous observations, set as 2/0.2=10;
        % Tmax set as 1500h;
        Um1(KT)=Um(NoTime(KT)+1);
        tmax1 =15;
        if Um1(KT)<80
            Ur=2.5;
        elseif Um1(KT)<200
            Ur=9;
        else
            Ur=15;
        end
        Umax(KT)=2*Ur*Um1(KT)/(1+Ur);
        Umin(KT)=2*Um1(KT)/(1+Ur);
        U(KT)=Um1(KT)+(Umax(KT)-Umin(KT))*cos(2*pi()*((TIME-(NoTime(KT)+1-1)*86400)/3600-tmax1)/24);
        % U(KT)=Um(KT);
 
    end
    if U(KT)<20
        U(KT)=20;
    end
    % % 计算不同高度风速 m / s
    % afa = 0.28;
    % if h_v(NoTime(KT)) == 0
    %     u_h(KT) = u_2(NoTime(KT)) * (2 / 2) ^ afa;
    % else
    %     u_h(KT) = u_2(NoTime(KT)) * (h_v(NoTime(KT)) / 2) ^ afa;
    % end
    %%%%%%%%%%%%%%%%%%%%%%TopPg地表气压值作边界条件用%%%%%%%%%%%%%%%%%%%%%%
    % if exist('TopPg_msr', 'var') &  ~isempty(TopPg_msr) & TopPg_msr ~= 0 
    %     if  NoTime(KT)<=0
    %         TopPg(KT)  =   TopPg_msr(1);
    %     else
    %         TopPg(KT)  =   TopPg_msr(NoTime(KT)+1);
    %     end
    % else
    TopPg(KT)=1013250*exp((-1)*9.80665*0.0289644*Z/8.31432/(Ts(KT)+273.15));  
    % end
    
    %%%%%%%%%%%%%%%%%%%%%随时间变化的地表水头值%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%如果需要要实际测量%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     for i=1:6
    %         h_SUR(KT)=h_SUR(KT)+Hsur_a(i)*cos(i*TIME*Hsur_w)+Hsur_b(i)*sin(i*TIME*Hsur_w);
    %     end
    %     h_SUR(KT)=h_SUR(KT)+Hsur_a0;
    
    %%%%%%%%%%%%%%P_Va水蒸气大气压%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P_Va(KT)=0.611*exp(17.27*Ta(KT)/(Ta(KT)+237.3))*HR_a(KT);  %The atmospheric vapor pressure (KPa)  (1000Pa=1000.1000.g.100^-1.cm^-1.s^-2)
    
    %%%%%%%%%%%%%%%%%%%%%%%RHOV_A水蒸气密度%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RHOV_A(KT)=P_Va(KT)*1e4/(Rv*(Ta(KT)+273.15));  %  g.cm^-3;  Rv-cm^2.s^-2.Cels^-1
 
