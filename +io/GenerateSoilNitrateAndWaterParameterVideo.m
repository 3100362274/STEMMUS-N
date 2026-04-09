function GenerateSoilNitrateAndWaterParameterVideo(outputPath, moistureData, nitrateData, ammoniaData, rainfallData, current_date, SUMDELTZ)
    % 土壤多参数变化视频生成函数
    % 输入参数：
    %   outputPath - 输出视频文件路径
    %   moistureData - 土壤水分数据矩阵（128x461）
    %   nitrateData - 土壤硝态氮数据矩阵（128x461）
    %   ammoniaData - 土壤铵态氮数据矩阵（128x461）
    %   rainfallData - 降雨量数据向量（461x1）
    %   current_date - 时间序列
    %   SUMDELTZ - 土壤深度向量
    
    % 提取或创建时间序列
    if ~exist('current_date', 'var') || length(current_date) ~= size(moistureData, 2)
        current_date = 1:size(moistureData, 2);
    end
    
    % 创建土壤深度向量
    if exist('SUMDELTZ', 'var')
        soilDepth = [0; SUMDELTZ];
    else
        soilDepth = linspace(0, 1000, size(moistureData, 1))';
    end
    
    % 确保土壤深度向量与数据矩阵行数匹配
    if length(soilDepth) ~= size(moistureData, 1)
        error('土壤深度向量长度(%d)与数据矩阵行数(%d)不匹配!', length(soilDepth), size(moistureData, 1));
    end
    
    % 计算各参数最大值
    moisture_max = max(moistureData(:));     % 土壤水分最大值
    temperature_max = max(nitrateData(:)); % 土壤硝态氮最大值
    pressure_max = max(ammoniaData(:));     % 土壤铵态氮最大值
    rainfall_max = max(rainfallData);        % 降雨量最大值
    depth_max = max(soilDepth);              % 土壤深度最大值
    
    % 创建VideoWriter对象
    outputVideo = VideoWriter(outputPath, 'Motion JPEG AVI');
    outputVideo.FrameRate = 10;
    outputVideo.Quality = 95; % 高质量
    
    % 尝试创建视频
    try
        open(outputVideo);
        disp(['视频写入器已成功打开: ', outputPath]);
        
        % 创建图形窗口 - 调整为适合2x2布局的大小
        fig = figure('Position', [100, 100, 1200, 900], 'Color', 'white');
        
        % 循环处理每一列（每一帧）
        for dayIdx = 1:size(moistureData, 2)
            % 获取当前列的数据
            currentMoistureData = moistureData(:, dayIdx);
            currentTemperatureData = nitrateData(:, dayIdx);
            currentPressureData = ammoniaData(:, dayIdx);
            
            % 创建图形显示
            clf(fig);
            
            % ==================== 左上坐标轴 - 土壤水分图 ====================
            ax1 = axes('Position', [0.1, 0.55, 0.35, 0.35]);
            
            % 使用fill函数创建曲线下方填充
            x_fill_moisture = [currentMoistureData; zeros(size(currentMoistureData))];
            y_fill_moisture = [soilDepth; flipud(soilDepth)];
            
            % 填充曲线下方的区域（使用浅蓝色）
            fill(x_fill_moisture, y_fill_moisture, [0.7, 0.8, 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
            
            % 绘制原始曲线（使用深蓝色）
            plot(ax1, currentMoistureData, soilDepth, 'b-', 'LineWidth', 1.5, 'Color', [0, 0.3, 0.6]);
            
            % 设置坐标轴属性
            set(ax1, 'YDir', 'reverse');
            xlabel(ax1, '土壤水分 (%)', 'FontSize', 10, 'FontWeight', 'bold');

            ylabel(ax1, '土壤深度 (cm)', 'FontSize', 10, 'FontWeight', 'bold');
            title(ax1, '土壤水分剖面', 'FontSize', 12, 'FontWeight', 'bold');
            xlim(ax1, [0, moisture_max]);
            ylim(ax1, [0, depth_max]);
            grid(ax1, 'on');
            set(ax1, 'GridAlpha', 0.3);
            set(ax1, 'XTick', linspace(0, moisture_max, 5));
            xticklabels = arrayfun(@(x) sprintf('%.3g', x), xticks, 'UniformOutput', false);
            set(ax1, 'XTick', xticks);
            set(ax1, 'XTickLabel', xticklabels);
            set(ax1, 'YTick', 0:250:depth_max);


            % ==================== 右上坐标轴 - 土壤硝态氮图 ====================
            ax2 = axes('Position', [0.55, 0.55, 0.35, 0.35]);
            
            % 使用fill函数创建曲线下方填充
            x_fill_temperature = [currentTemperatureData; zeros(size(currentTemperatureData))];
            y_fill_temperature = [soilDepth; flipud(soilDepth)];
            
            % 填充曲线下方的区域（使用浅红色）
            fill(x_fill_temperature, y_fill_temperature, [0.9, 0.8, 0.7], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
            
            % 绘制原始曲线（使用深红色）
            plot(ax2, currentTemperatureData, soilDepth, 'r-', 'LineWidth', 1.5, 'Color', [0.6, 0.2, 0]);
            
            % 设置坐标轴属性
            set(ax2, 'YDir', 'reverse');
            xlabel(ax2, '土壤硝态氮 (mg/kg)', 'FontSize', 10, 'FontWeight', 'bold');
            ylabel(ax2, '土壤深度 (cm)', 'FontSize', 10, 'FontWeight', 'bold');
            title(ax2, '土壤硝态氮剖面', 'FontSize', 12, 'FontWeight', 'bold');
            xlim(ax2, [0, temperature_max]);
            ylim(ax2, [0, depth_max]);
            grid(ax2, 'on');
            set(ax2, 'GridAlpha', 0.3);
            set(ax2, 'XTick',  0:50:temperature_max);
            xticklabels = arrayfun(@(x) sprintf('%d', round(x)), xticks, 'UniformOutput', false);
            set(ax2, 'XTick', xticks);
            set(ax2, 'XTickLabel', xticklabels);
            set(ax2, 'YTick', 0:250:depth_max);
          
            % ==================== 左下坐标轴 - 土壤气压图 ====================
            ax3 = axes('Position', [0.1, 0.1, 0.35, 0.35]);
            
            % 使用fill函数创建曲线下方填充
            x_fill_pressure = [currentPressureData; zeros(size(currentPressureData))];
            y_fill_pressure = [soilDepth; flipud(soilDepth)];
            
            % 填充曲线下方的区域（使用浅紫色）
            fill(x_fill_pressure, y_fill_pressure, [0.8, 0.7, 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
            
            % 绘制原始曲线（使用深紫色）
            plot(ax3, currentPressureData, soilDepth, 'm-', 'LineWidth', 1.5, 'Color', [0.5, 0, 0.5]);
            
            % 设置坐标轴属性
            set(ax3, 'YDir', 'reverse');
            xlabel(ax3, '土壤铵态氮 (mg/kg)', 'FontSize', 10, 'FontWeight', 'bold');
            ylabel(ax3, '土壤深度 (cm)', 'FontSize', 10, 'FontWeight', 'bold');
            title(ax3, '土壤铵态氮', 'FontSize', 12, 'FontWeight', 'bold');
            xlim(ax3, [0, pressure_max*1.1]);
            ylim(ax3, [0, depth_max]);
            grid(ax3, 'on');
            set(ax3, 'GridAlpha', 0.3);
            set(ax3, 'XTick', 0:50:pressure_max*1.1);
            set(ax3, 'YTick', 0:250:depth_max);
           
            % ==================== 右下坐标轴 - 降雨量柱状图 ====================
            ax4 = axes('Position', [0.55, 0.1, 0.35, 0.35]);
            
            bar(ax4, 1:length(rainfallData(1:length(current_date))), rainfallData(1:length(current_date)), 'FaceColor', [0.2, 0.4, 0.8], 'EdgeColor', 'none');
            hold on;
            
            % 创建红色覆盖数据（随时间从左到右覆盖）
            overlay_data = rainfallData(1:length(current_date));
            overlay_data(dayIdx+1:end) = 0; % 将当前时间点之后的数据设为0
            
            % 绘制红色覆盖层
            bar(ax4, 1:length(overlay_data), overlay_data, 'FaceColor', [1, 0, 0], 'EdgeColor', 'none', 'FaceAlpha', 0.6);
            
            % 设置坐标轴属性
            xlabel(ax4, '时间 (天)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(ax4, '降雨量 (mm)', 'FontSize', 12, 'FontWeight', 'bold');
            title(ax4, '降雨量变化', 'FontSize', 14, 'FontWeight', 'bold');
            
            % 设置坐标轴范围
            xlim(ax4, [0, length(rainfallData(1:length(current_date)))+1]);
            ylim(ax4, [0, rainfall_max*1.1]);
            
            % 设置网格
            grid(ax4, 'on');
            set(ax4, 'GridAlpha', 0.3);
            
            
            % 添加全局标题和当前天数显示
            if isdatetime(current_date)
                start_date_str = datestr(current_date(1), 'yyyy-mm-dd');
                end_date_str = datestr(current_date(end), 'yyyy-mm-dd');
                title_text = sprintf('%s - %s 土壤多参数监测', start_date_str, end_date_str);
            else
                title_text = sprintf('Day 1 - Day %d 土壤多参数监测', size(moistureData, 2));
            end
            sgtitle(title_text, 'FontSize', 14, 'FontWeight', 'bold');

             
             if isdatetime(current_date)
                 day_str = datestr(current_date(dayIdx), 'yyyy-mm-dd');
             else
                 day_str = sprintf('DAY %d', dayIdx);
             end
            

             annotation(fig, 'textbox',...
                [0.45, 0.48, 0.1, 0.04], ... % 调整位置和大小
                'String', day_str, ...
                'FontSize', 10, ... % 字体变小
                'FontWeight', 'bold', ...
                'EdgeColor', [0.5, 0.5, 0.5], ...
                'BackgroundColor', [1, 1, 1, 0.9], ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'FitBoxToText', 'off');
                                   
            % 刷新图形
            drawnow;
            
            % 获取当前帧
            frame = getframe(fig);
            
            % 将帧写入视频
            writeVideo(outputVideo, frame);
            
            % 显示进度
            if mod(dayIdx, 50) == 0
                fprintf('已处理 %d/%d 帧...\n', dayIdx, size(moistureData, 2));
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