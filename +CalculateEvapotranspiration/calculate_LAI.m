function [LAI, LAI_act] = calculate_LAI(TIME, KT,Nmsrmn)
LAI = zeros(Nmsrmn,1);
    % LAI and light extinction coefficient calculation
    AFTP_TIME = TIME / 86400;
    if AFTP_TIME < 20
        LAI(KT) = 0.098 * AFTP_TIME + 0.248;
    else
        LAI(KT) = -0.04 * AFTP_TIME^2 + 0.63 * AFTP_TIME + 2.063;
    end

    if LAI(KT) <= 2
        LAI_act(KT) = LAI(KT);
    elseif LAI(KT) <= 4
        LAI_act(KT) = 2;
    else
        LAI_act(KT) = 0.5 * LAI(KT);
    end

end

