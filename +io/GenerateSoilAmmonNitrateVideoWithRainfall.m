function GenerateSoilAmmonNitrateVideoWithRainfall(outputPath, nitrateData, ammoniaData, P, current_date, SUMDELTZ)
    % 土壤硝态氮和铵态氮浓度变化视频生成函数（带降雨柱状图）
    % 输入参数：
    %   outputPath - 输出视频文件路径
    %   nitrateData - 硝态氮浓度数据矩阵（128x461）
    %   ammoniaData - 铵态氮浓度数据矩阵（128x461）
    %   P - 降雨量数据向量（461x1）
    %   current_date - 时间序列
    %   SUMDELTZ - 土壤深度向量
    
    % 提取或创建时间序列
    if ~exist('current_date', 'var') || length(current_date) ~= size(nitrateData, 2)
        current_date = 1:size(nitrateData, 2);
    end
    
    % 创建土壤深度向量
    if exist('SUMDELTZ', 'var')
        soilDepth = [0; SUMDELTZ];
    else
        soilDepth = linspace(0, 1000, size(nitrateData, 1))';
    end
    
    % 确保土壤深度向量与数据矩阵行数匹配
    if length(soilDepth) ~= size(nitrateData, 1)
        error('土壤深度向量长度(%d)与数据矩阵行数(%d)不匹配!', length(soilDepth), size(nitrateData, 1));
    end
    
    nitrate_conc_max = max(nitrateData(:)); % 硝态氮浓度最大值
    ammonia_conc_max = max(ammoniaData(:)); % 铵态氮浓度最大值
    depth_max = max(soilDepth);    % 土壤深度最大值
    rain_max = max(P); % 降雨量最大值
    
    % 创建VideoWriter对象
    outputVideo = VideoWriter(outputPath, 'Motion JPEG AVI');
    outputVideo.FrameRate = 10;
    outputVideo.Quality = 95; % 高质量
    
    % 尝试创建视频
    try
        open(outputVideo);
        disp(['视频写入器已成功打开: ', outputPath]);
        
        % 创建图形窗口 - 调整宽度以容纳三个图
        fig = figure('Position', [100, 100, 1600, 600], 'Color', 'white');
        
        % 循环处理每一列（每一帧）
        for dayIdx = 1:size(nitrateData, 2)
            % 获取当前列的数据
            currentNitrateData = nitrateData(:, dayIdx);
            currentAmmoniaData = ammoniaData(:, dayIdx);
            
            % 创建图形显示
            clf(fig);
            
            % ==================== 左侧坐标轴 - 铵态氮浓度图 ====================
            ax0 = axes('Position', [0.05, 0.15, 0.25, 0.7]);
            
            % 使用fill函数创建曲线下方填充
            x_fill_ammonia = [currentAmmoniaData; zeros(size(currentAmmoniaData))];
            y_fill_ammonia = [soilDepth; flipud(soilDepth)];
            
            % 填充曲线下方的区域（使用浅绿色）
            fill(x_fill_ammonia, y_fill_ammonia, [0.7, 0.9, 0.7], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
            
            % 绘制原始曲线（使用深绿色）
            plot(ax0, currentAmmoniaData, soilDepth, 'g-', 'LineWidth', 1.5, 'Color', [0, 0.5, 0]);
            
            % 设置坐标轴属性
            set(ax0, 'YDir', 'reverse');
            xlabel(ax0, '铵态氮浓度 (mg/kg)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(ax0, '土壤深度 (cm)', 'FontSize', 12, 'FontWeight', 'bold');
            
            % 设置标题
             if isdatetime(current_date)
                start_date_str = datestr(current_date(1), 'yyyy-mm-dd');
                end_date_str = datestr(current_date(end), 'yyyy-mm-dd');
                title_text = sprintf('%s - %s 铵态氮模拟', start_date_str, end_date_str);
            else
                title_text = sprintf('%d - %d 铵态氮模拟', current_date(1), current_date(end));
            end
            title(ax0, title_text, 'FontSize', 14, 'FontWeight', 'bold');
            
            % 设置坐标轴范围
            xlim(ax0, [0, ammonia_conc_max]);
            ylim(ax0, [0, depth_max]);
            
            % 设置网格
            grid(ax0, 'on');
            set(ax0, 'GridAlpha', 0.3);
            
            % 设置刻度
            set(ax0, 'XTick', 0:50:ammonia_conc_max);
            set(ax0, 'YTick', 0:250:depth_max);

            if isdatetime(current_date)
                day_str = datestr(current_date(dayIdx), 'yyyy-mm-dd'); % 格式化为年-月-日
            else
                day_str = sprintf('DAY %d', dayIdx); % 如果不是日期格式，保持原样
            end

            text(ax0, 0.85, 0.15, day_str, 'Units', 'normalized', ...
                'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'BackgroundColor', [1, 1, 1, 0.9], ...
                'EdgeColor', [0.5, 0.5, 0.5], 'Margin', 5);

            % text(0.95, 0.15, sprintf('DAY %d', dayIdx), 'Units', 'normalized', ...
            %      'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'right', ...
            %      'VerticalAlignment', 'top', 'BackgroundColor', [1, 1, 1, 0.9], ...
            %      'EdgeColor', [0.5, 0.5, 0.5], 'Margin', 5);
            
            % ==================== 中间坐标轴 - 硝态氮浓度图 ====================
            ax1 = axes('Position', [0.35, 0.15, 0.25, 0.7]);
            
            % 使用fill函数创建曲线下方填充
            x_fill = [currentNitrateData; zeros(size(currentNitrateData))];
            y_fill = [soilDepth; flipud(soilDepth)];
            
            % 填充曲线下方的区域（使用浅蓝色）
            fill(x_fill, y_fill, [0.7, 0.9, 1], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
            
            % 绘制原始曲线（使用深蓝色）
            plot(ax1, currentNitrateData, soilDepth, 'b-', 'LineWidth', 1.5, 'Color', [0, 0.2, 0.6]);
            
            % 设置坐标轴属性
            set(ax1, 'YDir', 'reverse');
            xlabel(ax1, '硝态氮浓度 (mg/kg)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(ax1, '土壤深度 (cm)', 'FontSize', 12, 'FontWeight', 'bold');
            
            % 设置标题
            if isdatetime(current_date)
                start_date_str = datestr(current_date(1), 'yyyy-mm-dd');
                end_date_str = datestr(current_date(end), 'yyyy-mm-dd');
                title_text = sprintf('%s - %s 硝态氮模拟', start_date_str, end_date_str);
            else
                title_text = sprintf('%d - %d 硝态氮模拟', current_date(1), current_date(end));
            end
            title(ax1, title_text, 'FontSize', 14, 'FontWeight', 'bold');
            
            % 设置坐标轴范围
            xlim(ax1, [0, nitrate_conc_max]);
            ylim(ax1, [0, depth_max]);
            
            % 设置网格
            grid(ax1, 'on');
            set(ax1, 'GridAlpha', 0.3);
            
            % 设置刻度
            set(ax1, 'XTick', 0:50:nitrate_conc_max);
            set(ax1, 'YTick', 0:250:depth_max);
            
            % 在右上角添加当前天数显示
            if isdatetime(current_date)
                day_str = datestr(current_date(dayIdx), 'yyyy-mm-dd'); % 格式化为年-月-日
            else
                day_str = sprintf('DAY %d', dayIdx); % 如果不是日期格式，保持原样
            end

            text(ax1, 0.85, 0.15, day_str, 'Units', 'normalized', ...
                'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', 'BackgroundColor', [1, 1, 1, 0.9], ...
                'EdgeColor', [0.5, 0.5, 0.5], 'Margin', 5);
            
            % ==================== 右侧坐标轴 - 降雨量柱状图 ====================
            ax2 = axes('Position', [0.65, 0.15, 0.25, 0.7]);

            bar(ax2, 1:length(P(1:length(current_date))), P(1:length(current_date)), 'FaceColor', [0.2, 0.4, 0.8], 'EdgeColor', 'none');
            hold on;
            
            % 创建红色覆盖数据（随时间从左到右覆盖）
            overlay_data = P(1:length(current_date));
            overlay_data(dayIdx+1:end) = 0; % 将当前时间点之后的数据设为0
            
            % 绘制红色覆盖层
            bar(ax2, 1:length(overlay_data), overlay_data, 'FaceColor', [1, 0, 0], 'EdgeColor', 'none', 'FaceAlpha', 0.6);
            
            % 设置坐标轴属性
            xlabel(ax2, '时间 (天)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(ax2, '降雨量 (mm)', 'FontSize', 12, 'FontWeight', 'bold');
            title(ax2, '降雨量变化', 'FontSize', 14, 'FontWeight', 'bold');
            
            % 设置坐标轴范围
            xlim(ax2, [0, length(P(1:length(current_date)))+1]);
            ylim(ax2, [0, rain_max*1.1]);
            
            % 设置网格
            grid(ax2, 'on');
            set(ax2, 'GridAlpha', 0.3);
            
            % 刷新图形
            drawnow;
            
            % 获取当前帧
            frame = getframe(fig);
            
            % 将帧写入视频
            writeVideo(outputVideo, frame);
            
            % 显示进度
            if mod(dayIdx, 50) == 0
                fprintf('已处理 %d/%d 帧...\n', dayIdx, size(nitrateData, 2));
            end
        end
        
        % 完成视频写入
        close(outputVideo);
        close(fig);
        disp(['视频创建完成: ', outputPath]);
        
    catch ME
        % 错误处理
        disp('视频创建过程中发生错误:');
        disp(ME.message);
        
        % 确保关闭视频对象和图形窗口
        if exist('outputVideo', 'var') && isvalid(outputVideo)
            close(outputVideo);
        end
        if exist('fig', 'var') && isvalid(fig)
            close(fig);
        end
        
        rethrow(ME);
    end
end