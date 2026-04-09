function [dr, delta, Ws, Ra, Rs0, Nd, Rs, Rns, Rnl, Rn] = calculate_radiation_parameters(JN, Gasphaseparameterconstants, e_a, Tmax, Tmin, dms_string,n_act,num_steps,Z,Rn_msr)
    for iN = 1:num_steps
        % compute dr - inverse distance to the sun [-] FAO56 pag38 Eq23
        dr = (1 + 0.033 * cos(2 * pi() * JN / 365))';
    
        % compute delta - solar declination [rad] FAO56 pag38 Eq24
        delta = (0.409 * sin(2 * pi() * JN / 365 - 1.39))';
    
        % compute fai - Geographical latitude
        % [rad]
        % FAO56 pag38 Eq22
        latitude_radian = convert_dms_string_to_radian(dms_string);
    
        % compute ws - sunset hour angle [rad] FAO56 pag38 Eq25
        Ws = acos(-tan(latitude_radian) * tan(delta));
    
        % compute Ra - extraterrestrial radiation [MJ.m-2.day-1] FAO56 pag37 Eq21总辐射
        Ra(iN) = 24 * 60 / pi() * Gasphaseparameterconstants.Gsc * dr(iN) * (Ws(iN) * sin(latitude_radian) * sin(delta(iN)) + cos(latitude_radian) * cos(delta(iN)) * sin(Ws(iN)));
    
        % compute Rs0 - clear-sky solar (shortwave) radiation [MJ.m-2.day-1] FAO56 pag41 Eq37
        Rs0(iN) = (0.75 + 2E-5 * Z) * Ra(iN);
    
        % daylight hours N
        Nd(iN)=24*Ws(iN)/pi();
    
        % compute Rs - SHORTWAVE RADIATION [MJ.m-2.day-1] FAO56 pag51 Eq37
        % (如果有实测太阳辐射替代）
        Rs(iN) = (Gasphaseparameterconstants.as + Gasphaseparameterconstants.bs * n_act(iN) / Nd(iN)) * Ra(iN);
    
        % compute Rns - NET SHORTWAVE RADIATION [MJ.m-2.day-1] FAO56 pag51 Eq37
        Rns(iN) = (1 - Gasphaseparameterconstants.alfa) * Rs(iN);
    
        % compute Rnl - NET LONGWAVE RADIATION [MJ.m-2.day-1] FAO56 pag51 Eq37
            Rnl(iN) = Gasphaseparameterconstants.sigma * (((Tmax(iN) + 273.16)^4 + (Tmin(iN) + 273.16)^4) / 2) * (0.34 - 0.14 * sqrt(e_a(iN))) * (1.35 * Rs(iN) / Rs0(iN) - 0.35);      
      
        % net radiation 净辐射
        if exist('Rn_msr', 'var')  & ~isempty(Rn_msr(iN))  & Rn_msr(iN) ~= 0
            Rn(iN) = Rn_msr(iN);
        else
            Rn(iN) = Rns(iN) - Rnl(iN);
        end
    end
end
