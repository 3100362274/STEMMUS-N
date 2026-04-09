% function Evap_Cal

    % Set constants
    Gasphaseparameterconstants = CalculateEvapotranspiration.SetGasphaseparameterconstants(Tm,KT,NoTime);
    
    % Initialize arrays
    num_steps = length(JN); 
    LAI = zeros(1, num_steps); % Preallocate LAI to avoid dynamic allocation

  % Calculate air and radiation parameters
      for iN = 1:num_steps
          Tm(iN) = (Tmax(iN) + Tmin(iN)) / 2;  % Assuming Tm is the mean temperature
      end
        [DELTAA, ro_a, es, e_a, VPD, gama, Pa, RHmin] = CalculateEvapotranspiration.calculate_air_parameters(Tm, Tmax, Tmin, RHa,RHmax,RHmin, Z, Gasphaseparameterconstants,num_steps);
        [dr, delta, Ws, Ra, Rs0, Nd, Rs, Rns, Rnl, Rn] = CalculateEvapotranspiration.calculate_radiation_parameters(JN, Gasphaseparameterconstants, e_a, Tmax, Tmin, dms_string,n_act,num_steps,Z,Rn_msr);
        PT_PM_0 = CalculateEvapotranspiration.calculate_ET0(DELTAA, Rn, gama, es, e_a, u_2, Tm, num_steps);
        PME = CalculateEvapotranspiration.calculate_PME(DELTAA, Rn, gama, Gasphaseparameterconstants, num_steps);
        % 3-4龄果树LAI
        % sowing_day = 100;
        % max_day = 299;
        % a=2.5805;
        % b=0.0219;
        % c=189.11;
        % d=2.3455;
        % e=0.252;
        % f=-118.69; 
        % g=314.4;
        % if NoTime(KT) <= 0
        %     if JN(1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(1)-c)));
        %     elseif  JN(1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(1)/g)^f);
        %     end
        % else
        %     if JN(NoTime(KT)+1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(NoTime(KT)+1)-c)));
        %     elseif  JN(NoTime(KT)+1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(NoTime(KT)+1)/g)^f);
        %     end
        % end

        % 5龄果树LAI
        % sowing_day = 100;
        % max_day = 286;
        % a  =  1.6767 ;
        % b  =  0.0321  ;
        % c  =  126.98  ;
        % d=1.7488;
        % e=0.2505;
        % f=-97.592;
        % g=314.05;
        % if NoTime(KT) <= 0
        %     if JN(1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(1)-c)));
        %     elseif  JN(1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(1)/g)^f);
        %     end
        % else
        %     if JN(NoTime(KT)+1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(NoTime(KT)+1)-c)));
        %     elseif  JN(NoTime(KT)+1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(NoTime(KT)+1)/g)^f);
        %     end
        % end
        
        % 6-7龄果树LAI
        % sowing_day = 100;
        % max_day = 270;
        % a  =  1.6953 ;
        % b  =  0.0325  ;
        % c  =  139.8  ;
        % d=1.6268;
        % e=0.254;
        % f=-130.73;
        % g=306.1;
        % if NoTime(KT) <= 0
        %     if JN(1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(1)-c)));
        %     elseif  JN(1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(1)/g)^f);
        %     end
        % else
        %     if JN(NoTime(KT)+1) < max_day
        %         LAI(KT) = a/(1 + exp(-b*(JN(NoTime(KT)+1)-c)));
        %     elseif  JN(NoTime(KT)+1) <= 366
        %         LAI(KT) =  d + (e-d)/(1 + (JN(NoTime(KT)+1)/g)^f);
        %     end
        % end

        % 8-9-10龄果树LAI
        % sowing_day = 100;
        % max_day = 270;
        % a  =  2.5352 ;
        % b  =  214.56  ;
        % c  =  92.999  ;
        % if NoTime(KT) <= 0
        %     LAI(KT) = a.*exp(-((JN(1)-b)./c).^2);
        % else
        %     LAI(KT) = a.*exp(-((JN(NoTime(KT)+1)-b)./c).^2);
        % end

        % 11-12-13龄果树LAI
        % sowing_day = 100;
        % max_day = 270;
        % a  =  3.1671 ;
        % b  =  216.26  ;
        % c  =  89.952  ;
        % if NoTime(KT) <= 0
        %     LAI(KT) = a.*exp(-((JN(1)-b)./c).^2);
        % else
        %     LAI(KT) = a.*exp(-((JN(NoTime(KT)+1)-b)./c).^2);
        % end

        % 14-15-16龄果树LAI
        % sowing_day = 100;
        % max_day = 270;
        % a  =  3.5137 ;
        % b  =  211.12 ;
        % c  =  95.806 ;
        % if NoTime(KT) <= 0
        %     LAI(KT) = a.*exp(-((JN(1)-b)./c).^2);
        % else
        %     LAI(KT) = a.*exp(-((JN(NoTime(KT)+1)-b)./c).^2);
        % end

        % 17-20龄果树LAI
        % sowing_day = 100;
        % max_day = 270;
        % a  =  2.9976 ;
        % b  =   213.42 ;
        % c  =   97.955 ;
        % if NoTime(KT) <= 0
        %     LAI(KT) = a.*exp(-((JN(1)-b)./c).^2);
        % else
        %     LAI(KT) = a.*exp(-((JN(NoTime(KT)+1)-b)./c).^2);
        % end
        
         % 21 - 26龄果树LAI
         sowing_day = 100;
         max_day = 270;
         a  =  2.6735 ;
         b  =   217.96 ;
         c  =   97.797 ;
         if NoTime(KT) <= 0
             LAI(KT) = a.*exp(-((JN(1)-b)./c).^2);
         else
             LAI(KT) = a.*exp(-((JN(NoTime(KT)+1)-b)./c).^2);
         end

    % Rn_SOIL(KT) =Rn(KT)*exp(-1*(0.6*LAI(KT))); 
    % PE_PM_SOIL(KT) = (DELTAA(KT)*(Rn_SOIL(KT)-0)+86400*ro_a(KT)*1.013E-3*(es(KT)-e_a(KT))/  r_a_SOIL(KT))/((2.501-0.002361*Tm(KT))*(DELTAA(KT) + gama*(1+r_s_SOIL(KT)/r_a_SOIL(KT))))/10/86400;
    [EVAP,Tp_t,Scf] = CalculateEvapotranspiration.calculate_evaporation_and_transpiration(TIME, JN, KT, NL, Theta_LL, ...
    PT_PM_0, PME, LAI,num_steps,Coefficient_n,Coefficient_Alpha,Theta_r,Theta_s,NN,hh,Tao,u_2,RHmin,h_v,DURTN, Tm, Ts_msr, g, RHa,  RHOV, SUMTIME, sowing_day);
   [CanopyInterception,ExcesInt,Throughfall] = Interception(LAI,Scf,Precip,ExcesInt,aInterc,Tp_t,KT,Throughfall,lCanopyInterception);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%Root Water Uptake%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if rwuef==1
        Rootuptake(KT) = 0;
        Rootuptake(KT) =Tp_t(KT);
        % water stress function parameters
        H1=-10;H2=-35;H3L=-3000;H3H=-3000;H4=-10000; % 26 >20
        %H1=-10;H2=-35;H3L=-2000;H3H=-2000;H4=-8000;  %17 15 - 20from 李冰冰博士论文
        %H1=-10;H2=-35;H3L=-800;H3H=-500;H4=-8000; %9 <15            h1为饱和土壤中厌氧状态下的水势(通常为0);h2为氧气胁迫的临界水势;h4为植物枯萎状态的临界水势。h3为h3为水分胁迫的临界水势
        r2L = 0.1/3600/24; r2H = 0.5/3600/24; % cm/day Potential transpiration rate
        if Tp_t(KT) < r2L
            H3=H3L;
        elseif Tp_t(KT) > r2H
            H3=H3H;
        else
            H3=H3H+(H3L-H3H)/(r2H-r2L)*(r2H-Tp_t(KT));
        end


        MN=0;
        if WSI==1% water stress index :Value of 1 means the Feddes [1978] method;
            % piecewise linear reduction function
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    if hh(MN)  >=H1
                        alpha_h(ML,ND) = 0;
                    elseif  hh(MN)  >=H2
                        alpha_h(ML,ND) = (H1-hh(MN))/(H1-H2);
                    elseif  hh(MN)  >=H3
                        alpha_h(ML,ND) = 1;
                    elseif  hh(MN)  >=H4
                        alpha_h(ML,ND) = (hh(MN)-H4)/(H3-H4);
                    else
                        alpha_h(ML,ND) = 0;
                    end
                end
            end
        elseif WSI==0 %S模型 VAN1987;
            P1=3;%1.5-3 <1为快速递减在变慢，否则慢速递减在变快
            h_50=H1;%吸水量占潜在蒸腾量一半时的水头值
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    alpha_h(ML,ND)=1/(1+(hh(MN)/h_50)^P1);
                end
            end
        else %Musters and Bouten(2000);
            h2=-800;%临界水势阈值，需要根据试验测量
            P1=1.64;
            for ML=1:NL
                for ND=1:2
                    MN=ML+ND-1;
                    if hh(MN) < H4
                        alpha_h(ML,ND) = 0;
                    elseif   hh(MN) > h2
                        alpha_h(ML,ND)=1;
                    else
                        alpha_h(ML,ND)=1-((hh(MN)-h2)/(H4-h2))^P1;
                    end
                end
            end
        end
        if rsuef == 1
            % P2=3;
            % h_fai50=26.0845;%考虑溶质势作用时吸水量占潜在蒸腾量一半时的水头值
            % a=1;  % 转换系数，将浓度转化为渗透head
            % for ML=1:NL
            %     for ND=1:2
            %         MN=ML+ND-1;
            %         h_fai(MN) = a * (Nno3(MN)+Nn(MN));
            %         alpha_N(ML,ND)=1/(1+(h_fai(MN)/h_fai50)^P2);
            %     end
            % end
            for ML=1:NL
                for ND=1:2
                    alpha_N(ML,ND)=1;
                end
            end
        else
            for ML=1:NL
                for ND=1:2
                    alpha_N(ML,ND)=1;
                end
            end
        end
        ALPHA(NN) = alpha_h(NL,2);
        for ML = 1 : NL
            ALPHA(ML) = alpha_h(ML,1);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%% Root lenth distribution %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%Root growth%%%%%%%%%%
        Lmax=2400;                    %最大根长 cm
        RL0=2;                        %初始根长 cm
        if RG==1
            LR_prev = RL0;
            % 假设 num_steps 为天数，SHRL_all_days 已经存储了每一天的 SHRL 状态
            hours_per_day = 24;
            num_hours = num_steps * hours_per_day;  % 将天数转化为小时数
            SHRL_all_hours = zeros(1, num_hours);  % 初始化 SHRL 小时尺度数组

            % 将 SHRL_all_days 的值扩展为 SHRL_all_hours，按照每个天扩展为 24 小时
            for daynum = 1:num_steps
                start_hour = (daynum - 1) * hours_per_day + 1;
                end_hour = daynum * hours_per_day;
                SHRL_all_hours(start_hour:end_hour) = SHRL_all_days(daynum);  % 每天的 SHRL 值扩展为 24 小时
            end
            % 根系生长逻辑，根据 SHRL_all_hours 的状态来更新根系长度
            % 假设 KT 是时间步长，已在外部循环中定义
            if SHRL_all_hours(KT) == 0
                % 作物处于冬眠状态，根系停止生长，保持上一时间步长的根系长度
                LR(KT) = LR_prev;  % 保持上一时刻的根系长度
            else
                % 作物未处于冬眠状态，根系继续生长
                r =9.48915E-07;%((Lmax - RL0) / 2) / (((Nmsrmn / 10 + 1) / 24 / 2) * 24 * 3600);  % 根系生长速率 (cm/s)
                % Logistic 根系生长函数，更新 fr(KT) 和 LR(KT)
                fr(KT) = RL0 / (RL0 + (Lmax - RL0) * exp(-r * TIME));  % Logistic 根系生长函数
                LR(KT) = Lmax * fr(KT);  % 更新根长
                LR_prev =  LR(KT);
            end
        elseif RG==0
            r=1.3079e-07; % root growth rate cm/s  果树1.13m/y = 1.3079e-07cm/s    
            if NoTime(KT) <= 0
                if JN(1) < 154
                    fr(KT) =RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*(91+JN(1))*86400)));
                elseif  JN(1) < sowing_day
                    fr(KT) =0;
                else
                    fr(KT)=RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*(JN(1)-sowing_day+1)*86400))); %Logistic根系生长函数
                end
                LR(KT)=Lmax*fr(KT);
            else
                if JN(NoTime(KT)+1) < 154
                    fr(KT) =RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*(91+JN(NoTime(KT)+1))*86400)));
                elseif   JN(NoTime(KT)+1) < sowing_day
                    fr(KT) =0;
                else
                    fr(KT)=RL0/(RL0+(Lmax-RL0)*exp((-1)*(r*(JN(NoTime(KT)+1)-sowing_day)*86400))); %Logistic根系生长函数
                end
                LR(KT)=Lmax*fr(KT);                               %根长
            end
        end

        %%%%%%%%%%%%%%%%%%根系分布密度函数%%%%%%%%%%
       
        RL=Tot_Depth; %土体长
        %Elmn_Lnth=0;
        % (Hoffma and Van Genuchten,1983)
        % if LR(KT)<=1
        %     for ML=1:NL-1      % ignore the surface root water uptake 1cm
        %         for ND=1:2
        %             MN=ML+ND-1;
        %             bx(ML,ND)=0;
        %         end
        %     end
        % else
        %     for ML=1:NL
        %         Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
        %             if Elmn_Lnth<RL-LR(KT)
        %                 bx(ML)=0;
        %             elseif Elmn_Lnth>=RL-LR(KT) && Elmn_Lnth<RL-0.2*LR(KT)
        %                 bx(ML)=2.0833*(1-(RL-Elmn_Lnth)/LR(KT))/LR(KT);
        %             else
        %                 bx(ML)=1.66667/LR(KT);
        %             end
        %             for ND=1:2
        %                 MN=ML+ND-1;
        %                 bx(ML,ND)=bx(MN);
        %             end
        %     end
        % end
        
        % 果树根系
        a = -0.00000003;
        b =0.0005; 
        %C = 0.0032;
        Elmn_Lnth = 0;

        bx = zeros(NN, 2);  % 创建一个大小为 NL×2 的二维数组

        for ML = 1:NL
            Elmn_Lnth = Elmn_Lnth + DeltZ(ML);
            if Elmn_Lnth < RL - Lmax
                bx(ML, 1) = 0;  % 使用二维数组
            elseif Elmn_Lnth >= RL - Lmax
                bx(ML, 1) = b + 2 .* a .* (RL - Elmn_Lnth);
                %bx(ML, 1) = C + 2 .* b .* (RL - Elmn_Lnth) + 3 .* a .* ((RL - Elmn_Lnth) .^ 2);
            end
        end
        for ML = 1:NL
            for ND=1:2
                MN=ML+ND-1;
                bx(ML,ND)=bx(MN,1);
            end
        end

        % bx = Calculate_actualbx(NL,Lmax,Tot_Depth);%11ling
        % bx = Calculate_actualbx(NL,Tot_Depth,DeltZ);
        %%%%%%%%%%%%%%环境因子影响根系生长%%%%%%%%%%%%%%%%%%%
        if evfi==1   %考虑环境因子影响根系生长
            bd=RHO_2+0.00445*ps;       % bl,b2是取决于土壤质地的参数
            bu=RHO_2+0.35+0.005*ps;    % RHO_bulk是土壤容重g/cm3，ps为土壤含沙量，RHO_2为含沙量为0时的极限容重kg/m3,1g/cm3=1000kg/m3
            b2=(log(0.112*bd)-log(8.0*bu))/(bd-bu);
            bl=log(0.0112*bd)-b2;
            SS=(RHO_bulk)/((RHO_bulk)+exp(bl+b2*(RHO_bulk)));  %表示土壤阻力对根系生长的胁迫
            % ATS=(100-Sal)/(100-Smax);                   %表示铝毒害胁迫系数
            Top=21; % 小麦 20-22 玉米30-32
            Tb=3;   % 小麦 3-4.5 玉米8-10

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
                Srt_1(ML,ND)=Fr*alpha_h(ML,ND)*alpha_N(ML,ND)*bx(ML,ND)*Rootuptake(KT);
            end
            Trap_1(KT)=Trap_1(KT)+(Srt_1(ML,1)+Srt_1(ML,2))/2*DeltZ(ML);   %Actual transpiration = root water uptake integration by DeltZ;
        end
        % consideration of water compensation effect2025/6/4
        if Rootuptake(KT)==0
           Trap(KT)=0;
           Srt(:,:) = 0;
           wt(KT) = 1;
        else
            wt(KT)=Trap_1(KT)/Rootuptake(KT);  % 胁迫因子
            wc=0.05; % compensation coefficient
            Trap(KT)=0;
            if wt(KT)<wc
                for ML=1:NL
                    for ND=1:2
                        MN=ML+ND-1;
                        J=ML;
                        Srt(ML,ND)=Fr*alpha_h(ML,ND)*alpha_N(ML,ND)*bx(ML,ND)*Rootuptake(KT)/wc;
                        % 2025.3.20朱寄子星加入保护措施
                        if Theta_LL(ML,ND)-0.00025 < Theta_r(J) , Srt(ML,ND) = 0;end
                        if WSI == 1
                            PMin= H4;
                        else
                            PMin=10 * h_50;
                        end
                        ThLimit(J) = equations.van_genuchten(Theta_s(J), Theta_r(J), Alpha(J), PMin, n(J),m(J));
                        Srt(ML,ND)=min(Srt(ML,ND),max(0 , 0.5*(Theta_LL(ML,ND)-ThLimit(J))/Delt_t));
                    end
                    Trap(KT)=Trap(KT)+(Srt(ML,1)+Srt(ML,2))/2*DeltZ(ML);   % root water uptake integration by DeltZ;
                end
            else
                for ML=1:NL
                    for ND=1:2
                        MN=ML+ND-1;
                         J=ML;
                        Srt(ML,ND)=Fr*alpha_h(ML,ND)*alpha_N(ML,ND)*bx(ML,ND)*Rootuptake(KT)/wt(KT);
                         % 2025.3.20朱寄子星加入保护措施
                        if Theta_LL(ML,ND)-0.00025 < Theta_r(J) , Srt(ML,ND) = 0;end
                        if WSI == 1
                            PMin= H4;
                        else
                            PMin=10 * h_50;
                        end
                        ThLimit(J) = equations.van_genuchten(Theta_s(J), Theta_r(J), Alpha(J), PMin, n(J),m(J));
                        Srt(ML,ND)=min(Srt(ML,ND),max(0 , 0.5*(Theta_LL(ML,ND)-ThLimit(J))/Delt_t));
                    end
                    Trap(KT)=Trap(KT)+(Srt(ML,1)+Srt(ML,2))/2*DeltZ(ML);   % root water uptake integration by DeltZ;
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%溶质运移根系吸收溶质%%%%%%%%%%%%
    if rsuef==1
        % 最大作物吸氮量
        SPOT(KT) = 0;
        for ML=1:NL
            for ND=1:2
                MN=ML+ND-1;
                Spot(ML,ND)=Srt(ML,ND)*(Nn(MN)+Nno3(MN));
            end
            SPOT(KT)=SPOT(KT)+(Spot(ML,1)+Spot(ML,2))/2*DeltZ(ML);   
        end
        % Inputs:
        Nmin=0;           %- The roots begin to absorb the lowest concentration(ACTIVE) of no3- Unit:mg/L=pg/cm^3(mL)
        % SPot=0;         %- potential root solute uptake 假定植物对no3-溶质的一个潜在需求量 Unit:mg/L=pg/cm^3(mL)
        paic=1;           %- solute stress index 人为测量规定
        rKM=0.5;          %- Michaelis-Menten constant from:Bar-Yosef, B., Advances in fertigation, Advances in Agronomy, 65, 1-77, 1999
        NRootMaxNH4=50;  %- maximum concentration for the passive solute uptake Unit:mg/L=piug/cm^3(mL)
        NRootMaxNO3=100;  %- maximum concentration for the passive solute uptake Unit:mg/L=piug/cm^3(mL)1.7417
        %硝态氮最大被动吸收阈值：大约 5 - 30 微克/cm³铵态氮最大被动吸收阈值：大约 10 - 50 微克/cm³。
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
        global lActRSU
        nStep=1;      %step 1: Passive uptake
        if lActRSU==1
            nStep=2;  % step 2: Active uptake without compensation
        elseif lActRSU==1 && paic<=1
            nStep=3;  % step 3: Active uptake with compensation
        end
        % Notice: Active uptake only for the last solute

        for iStep=1:nStep
            for MN=1:NL
                cc(MN)=max(Nno3(MN)-Nmin,0);
            end
            if iStep==1
                 SPUptake(KT,1) = 0;
                 SPUptake(KT,2) = 0;
                for ML=1:NL
                    for ND=1:2
                        MN=ML+ND-1;
                        SinkS(ML,ND,1)=Srt(ML,ND)*1*max(min(N(MN),NRootMaxNH4),0.0);
                        SinkS(ML,ND,2)=Srt(ML,ND)*1*max(min(No3(MN),NRootMaxNO3),0.0);
                    end
                    SPUptake(KT,1)=SPUptake(KT,1)+(SinkS(ML,1,1)+SinkS(ML,2,1))/2*DeltZ(ML); % potential PASSIVE solute uptake root solute uptake integration by DeltZ;
                    SPUptake(KT,2)=SPUptake(KT,2)+(SinkS(ML,1,2)+SinkS(ML,2,2))/2*DeltZ(ML); % potential PASSIVE solute uptake root solute uptake integration by DeltZ;
                    SAUptakeP(KT)=max(SPOT(KT)*wt(KT)-SPUptake(KT,2)-SPUptake(KT,1),0);   % potential active solute uptake (step 1)
                end
            elseif iStep==2
                for ML=1:NL
                    for ND=1:2
                        MN=ML+ND-1;
                        AUptakeA(ML,ND)=cc(MN)/(rKM+cc(MN))*bx(ML,ND)*SAUptakeP(KT);  %Actual local active solute uptake
                    end
                end
                SAUptake(KT)=0;

                for ML=1:NL
                    SAUptake(KT)=SAUptake(KT)+((AUptakeA(ML,1)+AUptakeA(ML,2))/2*DeltZ(ML));  %Actual active solute uptake
                    if nStep==2
                        for ND=1:2
                            SinkS(ML,ND,2)=SinkS(ML,ND,2)+AUptakeA(ML,ND);
                        end
                    end
                    SAUptakeAN(KT)=SAUptake(KT);  %- uncompensated actual active solute uptake (step 2)
                    if SAUptakeP(KT) >= 0
                        pai(KT)=SAUptake(KT)/SAUptakeP(KT);  %溶质胁迫因子
                        if isnan(pai(KT))
                            pai(KT)= 1;
                        end
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

  