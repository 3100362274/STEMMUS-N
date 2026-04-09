function counter = count_calls()
    persistent call_count; % 定义一个持久变量

    if isempty(call_count)
        call_count = 0; % 初始化
    end

    call_count = call_count + 1; % 每次调用时加一
    counter = call_count; % 输出当前计数
end

