function GenerateNitrateVideo(outputPath,dataMatrix,current_date,SUMDELTZ)
    % 土壤硝态氮浓度变化视频生成函数
    % 根据用户提供的图片样式定制，保持原有代码逻辑不变
    % 设置输出路径到当前文件夹
    %outputPath = fullfile(pwd, 'soil_nitrate_dynamics.avi');
    
    % 提取或创建时间序列
    if ~exist('current_date', 'var') || length(current_date) ~= size(dataMatrix, 2)
        current_date = 1:size(dataMatrix, 2);
    end
    
    % 创建土壤深度向量 - 根据图片信息，深度范围应为0-1000cm
    % 如果SUMDELTZ是各层厚度，我们需要确保深度范围正确
    if exist('SUMDELTZ', 'var')
        % 计算累计深度并缩放到0-1000cm范围
        soilDepth = [0; SUMDELTZ];
    else
        % 如果没有SUMDELTZ，创建0-1000cm的均匀分布深度向量
        soilDepth = linspace(0, 1000, size(dataMatrix, 1))';
    end
    
    % 确保土壤深度向量与数据矩阵行数匹配
    if length(soilDepth) ~= size(dataMatrix, 1)
        error('土壤深度向量长度(%d)与数据矩阵行数(%d)不匹配!', length(soilDepth), size(dataMatrix, 1));
    end
    
    conc_max = max(dataMatrix(:)); % 硝态氮浓度最大值
    depth_max = max(soilDepth);    % 土壤深度最大值
         
    % 创建VideoWriter对象
    outputVideo = VideoWriter(outputPath, 'Motion JPEG AVI');
    outputVideo.FrameRate = 10;
    outputVideo.Quality = 95; % 高质量
    
    % 尝试创建视频
    try
        open(outputVideo);
        disp(['视频写入器已成功打开: ', outputPath]);
    
        % 创建图形窗口 - 根据图片样式设置
        fig = figure('Position', [100, 100, 800, 600], 'Color', 'white');
    
        % 循环处理每一列（每一帧）
        for dayIdx = 1:size(dataMatrix, 2)
            % 获取当前列的数据
            currentData = dataMatrix(:, dayIdx);
    
            % 创建图形显示
            clf(fig);
    
            % 创建主坐标轴
            ax = axes('Position', [0.15, 0.15, 0.75, 0.7]);
    
            % 使用fill函数创建曲线下方填充（根据图片样式）
            % 创建填充区域的坐标：从曲线上的点到X轴（浓度为0）
            x_fill = [currentData; zeros(size(currentData))];
            y_fill = [soilDepth; flipud(soilDepth)];
    
            % 填充曲线下方的区域（使用浅蓝色，与图片一致）
            fill(x_fill, y_fill, [0.7, 0.9, 1], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            hold on;
    
            % 绘制原始曲线（使用深蓝色，与图片一致）
            plot(ax, currentData, soilDepth, 'b-', 'LineWidth', 1.5, 'Color', [0, 0.2, 0.6]);
    
            % 设置坐标轴属性
            set(ax, 'YDir', 'reverse');
            xlabel(ax, '硝态氮浓度 (mg/kg)', 'FontSize', 12, 'FontWeight', 'bold');
            ylabel(ax, '土壤深度 (cm)', 'FontSize', 12, 'FontWeight', 'bold');
    
            % 设置标题 - 使用current_date的第一个值和最后一个值
            if isdatetime(current_date)
                % 如果是日期格式，转换为字符串
                start_date_str = datestr(current_date(1), 'yyyy-mm-dd');
                end_date_str = datestr(current_date(end), 'yyyy-mm-dd');
                title_text = sprintf('%s - %s 硝态氮模拟', start_date_str, end_date_str);
            else
                % 如果是数字格式，直接使用
                title_text = sprintf('%d - %d DAY硝态氮模拟', current_date(1), current_date(end));
            end
            title(ax, title_text, 'FontSize', 14, 'FontWeight', 'bold');
    
            % 设置坐标轴范围（根据图片信息）
            xlim(ax, [0, conc_max]);
            ylim(ax, [0, depth_max]);
    
            % 设置网格（根据图片信息）
            grid(ax, 'on');
            set(ax, 'GridAlpha', 0.3);
    
            % 设置刻度（根据图片信息）
            set(ax, 'XTick', 0:2:conc_max);
            set(ax, 'YTick', 0:250:depth_max);
    
            % 在右上角添加当前天数显示（根据图片样式）
            text(0.95, 0.95, sprintf('DAY %d', dayIdx), 'Units', 'normalized', ...
                'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'right', ...
                'VerticalAlignment', 'top', 'BackgroundColor', [1, 1, 1, 0.9], ...
                'EdgeColor', [0.5, 0.5, 0.5], 'Margin', 5);
    
            % 刷新图形
            drawnow;
    
            % 获取当前帧
            frame = getframe(fig);
    
            % 将帧写入视频
            writeVideo(outputVideo, frame);
    
            % 显示进度
            if mod(dayIdx, 50) == 0
                fprintf('已处理 %d/%d 帧...\n', dayIdx, size(dataMatrix, 2));
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