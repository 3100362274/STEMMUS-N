function fert_handle = init_fertilizer_controller(fert_params)
    % 解析参数（带默认值）
    if nargin < 1
        fert_params = struct();  % 允许空输入
    end
    
    % 合并默认参数
    default_params = struct(...
        't_fert', [], ...        % 必须指定（施肥时间向量）
        'F_tree', [], ...        % 必须指定（施肥量向量，kg/棵）
        'A_tree', 12, ...        % 默认树冠面积（m²）
        'RHO_bulk', 1.5, ...     % 默认土壤密度（g/cm³）
        'DEPTH', 20 ...         % 默认施肥深度（cm）
    );
    params = mergestruct(default_params, fert_params);
    
    % 初始化状态
    state.fert_applied = false(size(params.t_fert));  % 每个时间点是否已施肥
    state.eps_tol = hours(1);                             % 时间容差
    
    % 绑定参数
    state.t_fert = params.t_fert;
    state.F_tree = params.F_tree;
    state.A_tree = params.A_tree;
    state.RHO_bulk = params.RHO_bulk;
    state.DEPTH = params.DEPTH;
    
    % 返回闭包句柄
    fert_handle = @apply_fertilizer;
    
    function [should_apply, F_conc] = apply_fertilizer(current_date)
        F_conc = 0;
        should_apply = false;
        
        % 遍历所有施肥时间点
        for i = 1:length(state.t_fert)
            % 检查时间是否匹配且未施肥
            if current_date >= state.t_fert(i) && current_date < state.t_fert(i) + hours(1) && ~state.fert_applied(i)
                % 调用原计算函数
                F_conc_i = fertilizer_flux(...
                    current_date, ...
                    state.t_fert(i), ...  % 传入当前时间点
                    state.F_tree(i), ...
                    state.A_tree, ...
                    state.RHO_bulk, ...
                    state.DEPTH ...
                );
                
                % 累加浓度（或选择第一个匹配项）
                F_conc = F_conc + F_conc_i;
                should_apply = true;
                
                % 标记该时间点已施肥
                state.fert_applied(i) = true;
            end
        end
    end
end

% === 自定义结构体合并函数 ===
function S = mergestruct(default, user)
    fields = fieldnames(default);
    S = default;
    for i = 1:length(fields)
        field = fields{i};
        if isfield(user, field)
            S.(field) = user.(field);
        end
    end
end