function latitude_radian = convert_dms_string_to_radian(dms_string)
    % convert_dms_string_to_radian 将度、分、秒格式的纬度字符串转换为弧度
    %
    % 输入:
    %   dms_string - 度、分、秒格式的纬度字符串 (例如 '13°44' N')
    %
    % 输出:
    %   latitude_radian - 转换后的弧度

    % 解析输入字符串
    [degrees, minutes, direction] = parse_dms_string(dms_string);

    % 将度、分格式转换为十进制格式
    decimalLatitude = dms_to_decimal(degrees, minutes, direction);

    % 将十进制格式转换为弧度
    latitude_radian = decimal_to_radian(decimalLatitude);
    
    % 显示结果
    % disp(['度、分格式的纬度: ', dms_string]);
    % disp(['转换为十进制纬度: ', num2str(decimalLatitude)]);
    % disp(['转换为弧度: ', num2str(latitude_radian)]);

    % 嵌套函数：解析度、分字符串
    function [degrees, minutes, direction] = parse_dms_string(dms_string)
        % parse_dms_string 解析度、分、秒格式的纬度字符串
        %
        % 输入:
        %   dms_string - 度、分格式的纬度字符串 (例如 '13°44' N')
        %
        % 输出:
        %   degrees - 度数
        %   minutes - 分钟
        %   direction - 方向 ('N' 或 'S')

        % 使用正则表达式解析字符串
        pattern = '(?<degrees>\d+)°(?<minutes>\d+)''(?<direction>[NS])';
        tokens = regexp(dms_string, pattern, 'names');
        
        % 将解析结果转换为数值
        degrees = str2double(tokens.degrees);
        minutes = str2double(tokens.minutes);
        direction = tokens.direction;
    end

    % 嵌套函数：将度、分格式的纬度转换为十进制格式
    function decimalLatitude = dms_to_decimal(degrees, minutes, direction)
        % dms_to_decimal 将度、分格式的纬度转换为十进制格式
        %
        % 输入:
        %   degrees - 度数
        %   minutes - 分钟
        %   direction - 方向 ('N' 或 'S')
        %
        % 输出:
        %   decimalLatitude - 十进制格式的纬度

        % 计算十进制纬度
        decimalLatitude = degrees + minutes / 60;

        % 如果是南纬，转换为负值
        if strcmp(direction, 'S')
            decimalLatitude = -decimalLatitude;
        end
    end

    % 嵌套函数：将十进制纬度转换为弧度
    function radian = decimal_to_radian(decimalLatitude)
        % decimal_to_radian 将十进制纬度转换为弧度
        %
        % 输入:
        %   decimalLatitude - 十进制纬度 (可以是标量、向量或矩阵)
        %
        % 输出:
        %   radian - 转换后的弧度

        % 将十进制纬度转换为弧度
        radian = decimalLatitude * (pi / 180);
    end
end

