function F_conc = fertilizer_flux(current_date, t_fert, F_tree, A_tree, RHO_bulk, DEPTH )
    % 施肥浓度计算
    
    F_conc = 0;  % 初始施肥浓度为0
    
    % 检查当前时间是否接近施肥时间点
    for i = 1:length(t_fert)
        if abs(current_date - t_fert(i)) <= hours(1)  % 判断时间是否接近施肥时间点
            % DEPTH动态计算施肥浓度（转换为表层0-30cm的浓度）
            % 这里的 rho 是土壤密度（可以随水分含量变化而变化）g/cm³
            % 将施肥量从 kg/棵 转换为 µg/cm³
            F_conc =   (F_tree(i) * 1e9) / (1e8* DEPTH); % µg/cm2/cm
            % F_conc = (F_tree(i) * 1e6) / (A_tree * 1e4 * DEPTH * RHO_bulk);   % mg/kg 
        end
    end
end
 