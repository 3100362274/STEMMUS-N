function [DeltZ, DeltZ_R, NL, ML] = Dtrmn_Z(NL, Tot_Depth, max_elements)
    % 确定元素长度（网格划分），返回网格长度数组 DeltZ

    % 初始化 DeltZ_R 数组，设置足够大的上限，避免下标越界
    DeltZ_R = zeros(1, max_elements);

    % 为不同深度区间设置相应的单元长度
   DeltZ_R(1:2) = 0.25;      % 0.25 cm 的分辨率 
    DeltZ_R(3) = 0.5;         % 0.5 cm 的分辨率
    DeltZ_R(4:12) = 1;        % 1 cm 的分辨率 
    DeltZ_R(13:22) = 2;       % 2 cm 的分辨率
    DeltZ_R(23:26) = 2.5;     % 2.5 cm 的分辨率
    DeltZ_R(27:38) = 5;       % 5 cm 的分辨率
    DeltZ_R(39:128) = 10;      % 10 cm 的分辨率   10m
    DeltZ_R(129:203) = 20;      % 20 cm 的分辨率  20m
    DeltZ_R(204:253) = 50;      % 50 cm 的分辨率  50m
    DeltZ_R(254:max_elements) = 100; % 100 cm 的分辨率，超出部分

    % 计算累计元素长度，直到达到总深度
    Elmn_Lnth = 0; % 初始化累积长度
    for ML = 1:max_elements
        Elmn_Lnth = Elmn_Lnth + DeltZ_R(ML);
        if Elmn_Lnth >= Tot_Depth
            % 如果累计长度超过或等于总深度，调整当前单元长度并终止循环
            DeltZ_R(ML) = DeltZ_R(ML) - (Elmn_Lnth - Tot_Depth);
            NL = ML; % 更新节点数量为当前的 ML
            break; 
        end
    end

    % 反转数组并生成最终的 DeltZ
    DeltZ1 = flip(DeltZ_R(1:NL)); % 使用 MATLAB 内置的 flip 函数简化反转
    % 处理反转后的数组，确保没有前导的零元素
    DeltZ = DeltZ1(DeltZ1 > 0)';

    % 更新 NL 为去除零元素后的 DeltZ 长度
    NL = length(DeltZ);
    
    % 检查累计长度是否满足总深度要求
    final_length = sum(DeltZ);
    if final_length < Tot_Depth
        error('Total depth was not fully covered by the elements. Please check input parameters.');
    end
end


% function [DeltZ, DeltZ_R, NL, ML] = Dtrmn_Z(NL, Tot_Depth)
% 
%     % for ML=1:2
%     %     DeltZ_R(ML)=0.25;
%     % end
%     % DeltZ_R(3)=0.5;
%     % 
%     % for ML=4:12
%     %     DeltZ_R(ML)=1;
%     % end
%     % 
%     % for ML=13:22
%     %     DeltZ_R(ML)=2;
%     % end
%     % 
%     % for ML=23:26
%     %     DeltZ_R(ML)=2.5;
%     % end
%     % 
%     % for ML=27:38
%     %     DeltZ_R(ML)=5;
%     % end
%     % 
%     % % Sum of element lengths and compared to the total lenght, so that judge
%     % % can be made to determine the length of rest elements.
%     % 
%     % for ML=1:38
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     % end
%     % 
%     % % If the total sum of element lenth is over the predefined depth, stop the
%     % % for loop, make the ML, at which the element lenth sumtion is over defined
%     % % depth, to be new NL.
%     % for ML=39:48
%     %     DeltZ_R(ML)=10;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ1(ML)=DeltZ_R(MML);
%     %         end
%     %         if DeltZ1(1) == 0
%     %             for ML = 2:NL
%     %                 DeltZ(ML-1)= DeltZ1(ML);
%     %             end
%     %             NL = NL-1;
%     %         else
%     %             for ML=1:NL
%     %                 DeltZ(ML)=DeltZ1(ML);
%     %             end
%     %         end
%     %         return
%     %     elseif Elmn_Lnth<Tot_Depth && ML==NL
%     %         NL=NL+NL*2;
%     %     end
%     % end
%     % for ML=49:58
%     %     DeltZ_R(ML)=20;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ1(ML)=DeltZ_R(MML);
%     %         end
%     %         if DeltZ1(1) == 0
%     %             for ML = 2:NL
%     %                 DeltZ(ML-1)= DeltZ1(ML);
%     %             end
%     %             NL = NL-1;
%     %         else
%     %             for ML=1:NL
%     %                 DeltZ(ML)=DeltZ1(ML);
%     %             end
%     %         end
%     %         return
%     %     elseif Elmn_Lnth<Tot_Depth && ML==NL
%     %         NL=NL+NL*2;
%     %     end
%     % end
%     % for ML=59:63
%     %     DeltZ_R(ML)=20;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ1(ML)=DeltZ_R(MML);
%     %         end
%     %         if DeltZ1(1) == 0
%     %             for ML = 2:NL
%     %                 DeltZ(ML-1)= DeltZ1(ML);
%     %             end
%     %             NL = NL-1;
%     %         else
%     %             for ML=1:NL
%     %                 DeltZ(ML)=DeltZ1(ML);
%     %             end
%     %         end
%     %         return
%     %     elseif Elmn_Lnth<Tot_Depth && ML==NL
%     %         NL=NL+NL*2;
%     %     end
%     % end
%     % for ML=64:68
%     %     DeltZ_R(ML)=50;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ1(ML)=DeltZ_R(MML);
%     %         end
%     %         if DeltZ1(1) == 0
%     %             for ML = 2:NL
%     %                 DeltZ(ML-1)= DeltZ1(ML);
%     %             end
%     %             NL = NL-1;
%     %         else
%     %             for ML=1:NL
%     %                 DeltZ(ML)=DeltZ1(ML);
%     %             end
%     %         end
%     %         return
%     %     elseif Elmn_Lnth<Tot_Depth && ML==NL
%     %         NL=NL+NL*2;
%     %     end
%     % end
%     % for ML=69:71
%     %     DeltZ_R(ML)=100;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>=Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ1(ML)=DeltZ_R(MML);
%     %         end
%     %         if DeltZ1(1) == 0
%     %             for ML = 2:NL
%     %                 DeltZ(ML-1)= DeltZ1(ML);
%     %             end
%     %             NL = NL-1;
%     %         else
%     %             for ML=1:NL
%     %                 DeltZ(ML)=DeltZ1(ML);
%     %             end
%     %         end
%     %     elseif Elmn_Lnth<Tot_Depth && ML==NL
%     %         NL=NL+NL*2;
%     %         return
%     %     end
%     % end
%     % for ML=72:NL
%     %     DeltZ_R(ML)=200;
%     %     Elmn_Lnth=Elmn_Lnth+DeltZ_R(ML);
%     %     if Elmn_Lnth>=Tot_Depth
%     %         DeltZ_R(ML)=Tot_Depth-Elmn_Lnth+DeltZ_R(ML);
%     %         NL=ML;
%     % 
%     %         for ML=1:NL
%     %             MML=NL-ML+1;
%     %             DeltZ(ML)=DeltZ_R(MML);
%     %         end
%     %         return
%     %     end
%     % end
% end
    
    
    
    

