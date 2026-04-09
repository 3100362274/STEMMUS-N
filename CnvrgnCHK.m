function [KT,TIME,Delt_t,IRPT1,IRPT2,tS,Delt_old, hh, TT, P_gg, Nn, Nno3, Nnurea, Nurea] = CnvrgnCHK(...
    Theta_LL, Theta_L, hh, h, TT, T, P_gg, P_g, Nn, N, Nno3, No3, Nnurea, Nurea,...
    xERR, hERR, TERR, PERR, NBCh, NBChB, NBCT, NBCTB, NL, ...
    Thmrlefc, Soilairefc, Nefc, Delt_t, NN, KT, TIME, tS, KIT, NIT)
   
  persistent backtrackCount lastGoodStep shrinkCount;  % 添加shrinkCount跟踪连续缩小
    if isempty(backtrackCount)
        backtrackCount   = 0;            % 已回退次数
        lastGoodStep     = Delt_t;       % 上一次认为收敛的步长
        shrinkCount      = 0;            % 连续缩小次数
    end
    maxBacktracks      = 40;        % 连续最大回退次数
    minTimeStep        = 10^-4;           % 最小步长
    maxTimeStep        = 3600;         % 最大小步长
    maxShrinks         = 10;           % 新参数：最大连续缩小次数，防无限循环
    maxFAC             = 6;            % 将6提取为变量
    
    IRPT1 = 0;  IRPT2 = 0;
    Delt_old = Delt_t;
    
    
    epsilon    = 1e-10;      % 小量防零除
    
    if KIT >= NIT
        % 超出最大迭代次数，准备回退
        backtrackCount = backtrackCount + 1;
        fprintf('第 %d 次回退：未在 %d 次迭代内收敛，减小时间步长重新计算\n', ...
            backtrackCount, NIT);
        % 保存当前步长为旧值
        Delt_old = Delt_t;
        % 减少步长并约束在[minTimeStep, maxTimeStep]范围内
        Delt_t = max(min(Delt_t * 0.5, maxTimeStep), minTimeStep);
    
        % 时间回退
        TIME = TIME - Delt_old;
        KT   = KT - 1;
        tS   = tS + 1;
    
        resetState();
    
        IRPT2 = 1;  % 标记为需要重新计算
    
        % 检查是否超过最大回退次数
        if backtrackCount > maxBacktracks
            % 超出最大回退次数，恢复至上一次成功步长并终止回退循环
            fprintf('连续回退超过 %d 次，恢复上次步长并终止回退\n', maxBacktracks);
            Delt_t = lastGoodStep;
    
            % 回滚时间及计数
            TIME = TIME + Delt_old;  % 重新走到恢复后的步长
            KT   = KT + 1;
            tS   = tS - 1;
    
            resetState();  % 恢复上一次成功状态
            IRPT2 = 0;     % 取消再计算标记
            backtrackCount = 0;  
            return;
        end
        return;
    end
    
    
    DxMAX = maxDiff(Theta_LL, Theta_L, NL, NBCh, NBChB);
    DhMAX = maxDiff(hh,       h,       NN, NBCh, NBChB);
    DTMAX = maxDiff(TT,       T,       NN, NBCT, NBCTB);
    DPMAX = maxDiff(P_gg,    P_g,     NN, NBCT, NBCTB);
    
    
    FACx = safeDiv(xERR, DxMAX, epsilon);
    FACh = safeDiv(hERR, DhMAX, epsilon);
    FACT = Thmrlefc * safeDiv(TERR, DTMAX, epsilon);
    FACP = Soilairefc * safeDiv(PERR, DPMAX, epsilon);
    FAC  = min([FACx, FACh, FACT + ~Thmrlefc, FACP + ~Soilairefc, maxFAC]);  % 最大放大因子6
   
    if isnan(FAC) || isinf(FAC)
        FAC = 0.2;  % 改为0.2，接近阈值
        fprintf('警告: FAC异常（NaN/Inf），重置为0.2\n');
    end
    
    if FAC < 0.25
        shrinkCount = shrinkCount + 1;  % 增连续缩小计数
        Delt_old=Delt_t; IRPT2 = 1;  KT = KT - 1;  tS = tS + 1;  TIME = TIME - Delt_old;
        Delt_t=max(Delt_t*FAC,minTimeStep);
        if Delt_t<=1.0e-6
            fprintf ('Delt_t is getting extremly small.')
        end
        if shrinkCount > maxShrinks  % 新增：防无限循环
            fprintf('错误: 连续缩小步长超过%d次，可能不收敛。尝试恢复lastGoodStep或检查模型。\n', maxShrinks);
            Delt_t = lastGoodStep;  % 强制恢复
            shrinkCount = 0;  % 重置
            IRPT2 = 0; KT = KT + 1; tS = tS - 1; TIME = TIME + Delt_old ;  
            resetState();
            return;  % 退出当前调用
        end
    else
        Delt_t = min(max(Delt_t * FAC, minTimeStep), maxTimeStep);
        lastGoodStep = Delt_t;
        backtrackCount = 0; 
        shrinkCount = 0;
    end
    
    
        function resetState()
            hh = h;
            Theta_LL=Theta_L;
            if Thmrlefc,    TT   = T;     end
            if Soilairefc,  P_gg = P_g;   end
            if Nefc,        Nn   = N;     Nno3 = No3;  Nnurea=Nurea;end
        end
    
        function m = maxDiff(A, B, nNode, B1, B2)
            m = 0;
            for i = 1:nNode
                % 边界条件跳过
                if (B1 && i==nNode) || (B2 && i==1), continue; end
                m = max(m, abs(A(i) - B(i)));
            end
        end
    
        function r = safeDiv(num, den, eps)
            r = num ./ (den + eps);
            r(isnan(r) | isinf(r)) = 0;  % 添加NaN/Inf处理
        end
    
    end
