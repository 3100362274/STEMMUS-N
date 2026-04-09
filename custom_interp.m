function y_interp = custom_interp(x_data, y_data, x_nodes)
 
   y_interp = zeros(size(x_nodes));  % 存储插值结果
    
   for i = 1:length(x_nodes)
       x_val = x_nodes(i);

       % 如果 x_val 在 x_data 范围内，直接取对应的 y 值
       if x_val >= x_data(1) && x_val <= x_data(end)
           % 找到区间：x_data(k) <= x_val < x_data(k+1)
           for j = 1:length(x_data)-1
               if x_val >= x_data(j) && x_val < x_data(j+1)
                   % 使用线性插值公式
                   y_interp(i) = y_data(j) + (y_data(j+1) - y_data(j)) * (x_val - x_data(j)) / (x_data(j+1) - x_data(j));
                   break;
               elseif x_val == x_data(j+1)  % 如果 x_val 恰好是 x_data 的最大值
                   y_interp(i) = y_data(j+1); % 直接返回对应的 y 值
                   break;
               end
           end
       elseif x_val < x_data(1)
           % 如果 x_val 小于 x_data 的最小值，使用最左边区间的外推
           y_interp(i) = y_data(1) + (y_data(2) - y_data(1)) * (x_val - x_data(1)) / (x_data(2) - x_data(1));
       else
           % 如果 x_val 大于 x_data 的最大值，使用最右边区间的外推
           % 改进：更好的外推方法，使用最后两个点的斜率
           y_interp(i) = y_data(end-1) + (y_data(end) - y_data(end-1)) * (x_val - x_data(end-1)) / (x_data(end) - x_data(end-1));
       end
   end
end