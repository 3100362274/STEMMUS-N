function porosity = calculate_porosity(bulk_density, particle_density)
    % 计算土壤孔隙度
    %
    % 输入:
    %   bulk_density - 干密度 (g/cm^3)
    %   particle_density - 粒密度 (g/cm^3) 2.65
    %
    % 输出:
    %   porosity - 孔隙度 (%)

    % 确保粒密度大于干密度
    if particle_density <= bulk_density
        error('粒密度必须大于干密度');
    end

    % 计算孔隙
    porosity = (1 - (bulk_density / 2.65)) ;
end
