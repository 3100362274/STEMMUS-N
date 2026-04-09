function [CanopyInterception,ExcesInt,Throughfall] = Interception(LAI,Scf,Precip,ExcesInt,aInterc,Tp_t,KT,Throughfall,lCanopyInterception)
% rInterc - interception rate [L/T], [cm/d]
% aInterc -  Constant a in the interception model (=0.25 mm/d)->cm/d
% Interc*LAI - max interception
% ExcesInt- intercepted water from previous time step =0一开始
% Tp_t  - potential transpiration [mm/d]  
if lCanopyInterception  
    CanopyInterception(KT) = min((aInterc / 24 / 3600) * LAI(KT) * (1 - 1 / (1 + Scf(KT)*Precip(KT) / ((aInterc / 24 / 3600) * LAI(KT)))),Precip(KT));
    if isnan(CanopyInterception(KT))
        CanopyInterception(KT) = 0;
    end
    if(CanopyInterception(KT)+ExcesInt > aInterc*LAI(KT))
        CanopyInterception(KT)=aInterc*LAI(KT)-ExcesInt;
    end
    Throughfall(KT) = max(Precip(KT) - CanopyInterception(KT),0);
    CanopyInterception(KT)=ExcesInt+CanopyInterception(KT); % Old interception + new interception
    ExcesInt=0;
    if(Tp_t(KT)-CanopyInterception(KT) < 0)
        ExcesInt=-Tp_t(KT)+CanopyInterception(KT);
    end
end 