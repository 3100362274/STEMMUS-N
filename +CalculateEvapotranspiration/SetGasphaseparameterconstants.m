function Gasphaseparameterconstants = SetGasphaseparameterconstants(Tm,KT,NoTime)
    Gasphaseparameterconstants.sigma = 4.903e-9;  % Stefan Boltzmann constant MJ.m-2.day-1 K-4 FAO56 pag 74
    if NoTime(KT) <=0
    Gasphaseparameterconstants.lambdav = (2.501-0.002361*Tm(1));    % latent heat of evaporation [MJ.kg-1] FAO56 pag 31
    else
    Gasphaseparameterconstants.lambdav = (2.501-0.002361*Tm(NoTime(KT)+1)); 
    end
    Gasphaseparameterconstants.Gsc = 0.082;       % solar constant [MJ.m-2.min-1] FAO56 pag 47 Eq28
    Gasphaseparameterconstants.eps = 0.622;       % ratio molecular weight of vapour/dry air FAO56 p26 BOX6
    Gasphaseparameterconstants.R = 0.287;         % specific gas [kJ.kg-1.K-1] FAO56 p26 box6
    Gasphaseparameterconstants.Cp = 1.013E-3;     % specific heat at constant pressure [MJ.kg-1.?C-1] FAO56 p26 box6
    Gasphaseparameterconstants.k = 0.41;          % karman's constant []  FAO 56 Eq4
    % Gasphaseparameterconstants.Z = 1200;          % altitude of the location (m)
    Gasphaseparameterconstants.as = 0.25;         % regression constant, expressing the fraction of extraterrestrial radiation FAO56 pag50
    Gasphaseparameterconstants.bs = 0.5;
    Gasphaseparameterconstants.alfa = 0.23;       % albedo of vegetation set as 0.23
    Gasphaseparameterconstants.Lz=240*pi()/180;   % latitude of Beijing time zone west of Greenwich
    % Gasphaseparameterconstants.Lm=107.67*pi()/180;   % latitude of Local time, west of Greenwich 需要根据当地修正
end
