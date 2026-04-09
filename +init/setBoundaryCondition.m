function BoundaryCondition = setBoundaryCondition(Soilairefc, Thmrlefc, Ts_msr,Nefc)
    % Variables information for boundary condition settings
    % NBCh   Indicator for type of surface boundary condition on mass euqation to be applied;
    %        "1"--Specified matric head;
    %        "2"--Specified potential moisture flux (potential evaporation rate of precipitation rate);
    %        "3"--Specified atmospheric forcing;
    % NBCT   Indicator for type of surface boundary condtion on energy equation to be applied;
    %        "1"--Specified temperature;
    %        "2"--Specified heat flux;
    %         "3"--Specified atmospheric forcing;
    % NBCP   Indicator for type of surface boundary condition on dry air equation to be applied;
    %        "1"--Specified atmospheric pressure;
    %        "2"--Specified atmospheric forcing (Measured atmospheric pressure data);
    % BCh    Value of specified matric head (if NBCh=1) or specified potential moisture flux (if NBCh=2) at surface;
    % BChB   The same as BCh but at the bottom of column;
    % BCT    Value of specified temperature (if NBCT=1) or specified head flux (if NBCT=2) at surface;
    % BCTB   The same as BCT but at the bottom of column;
    % BCPB   Value of specified atmospheric pressure;
    % BCP    The same as BCP but at the bottom of column;
    % hN     Specified value of matric head when a fist-type BC is used;
    % NBChB  Type of boundary condition on matric head at bottom of column;
    %        "1"--Specified head of BChB at bottom;
    %        "2"--Specified moisture flux of BChB;
    %        "3"--Zero matric head gradient at bottom(Gravity drainage);
    % NBCTB  Type of boundary condition on temperature at bottom of column;
    %        "1"--Specified temperature BCTB at bottom;
    %        "2"--Specified heat flux BCTB at bottom;
    %        "3"--Zero temperature gradient at bottom (advection only);
    % NBCPB  Type of boundary condition on soil air pressure;
    %        "1"--Specified dry air flux BCPB at bottom;
    %        "2"--Zero soil air pressure gradient at bottom;
    % NBChh  Type of surface BC actually applied on a particular trial of a time step when NBCh euqals 2 or 3;
    %        "1"--Specified matric head;
    %        "2"--Specified actual flux;
    % DSTOR  Depth of depression storage at end of current time step;
    % DSTOR0 Depth of depression storage at start of current time step;
    % DSTMAX Depression storage capacity;
    % EXCESS Excess of available water over infiltration rate for current time step,expressed as a rate;
    % AVAIL  Maximum rate at which water can be supplied to the soil from above during the current time step;

        NBCP = [];
        BCTB = [];
        NBCPB = [];
        BCPB = [];
        BCT = [];
        BCP = [];
        NBCN=[];
        NBCNB=[];
        BCN=[];
        BCNB=[];
        IRPT1=0;
        IRPT2=0;
    
        %% soil moisture boundary condition
        NBCh=3;      % Moisture Surface B.C.: 1 --> Specified matric head(BCh); 2 --> Specified flux(BCh); 3 --> Atmospheric forcing;
        BCh=-20/3600;
        NBChB=2;    % Moisture Bottom B.C.: 1 --> Specified matric head (BChB); 2 --> Specified flux(BChB); 3 --> Zero matric head gradient (Gravitiy drainage);
        BChB=0;
        if NBCh~=1
            NBChh=2;                    % Assume the NBChh=2 firstly;
        end
    
        %% soil temperature boundary condition
        if Thmrlefc==1
            NBCT=1;  % Energy Surface B.C.: 1 --> Specified temperature (BCT); 2 --> Specified heat flux (BCT); 3 --> Atmospheric forcing;
            % BCT=1;Ts_msr(1);  % surface temperature
            NBCTB=1;% Energy Bottom B.C.: 1 --> Specified temperature (BCTB); 2 --> Specified heat flux (BCTB); 3 --> Zero temperature gradient;
            BCTB=mean(Ts_msr);
        end
    
        %% soil air boundary condition
        if Soilairefc==1
            NBCP=3; % Soil air pressure B.C.: 1 --> Ponded infiltration caused a specified pressure value;
            % 2 --> The soil air pressure is allowed to escape after beyond the threshold value;
            % 3 --> The atmospheric forcing;
            BCP=0;
            NBCPB=2;  % Soil air Bottom B.C.: 1 --> Bounded bottom with specified air pressure; 2 --> Soil air is allowed to escape from bottom;
            BCPB=0;
        end
    
        %% soil Nitrogen boundary condition
        if Nefc==1
            NBCN=2;
            %Indicator for type of surface boundary condition on N equation to be applied;
            %>        "1"--Specified N concentration;
            %>        "2"--Specified N flux;
            BCN=1;  %cTop(KT,js);
            NBCNB=2;
            %Type of boundary condition on N at bottom of column;
            %>        "1"--Specified concentration of BCNB at bottom;
            %>        "2"--Specified N flux of BCNB;
            %>        "3"--Zero matric N gradient at bottom(Gravity drainage);
            BCNB=1;  %cBot(KT,js);
        end
    
        %% depression storage and runoff
        FACc=0;                         % Used in MeteoDataCHG for check is FAC changed?
        BtmPg=89821.33497*10;
        % Atmospheric pressure at the bottom (Pa), set fixed with the value of mean atmospheric pressure;
        DSTOR=0;                        % Depth of depression storage at end of current time step，可以是灌溉量，也可以是洼地量;
        DSTOR0=DSTOR;              % Dept of depression storage at start of current time step;
        RS=0;                             % Rate of surface runoff;
        DSTMAX=0;                     % Depression storage capacity;
    
    
    
    
        % used in main script
        BoundaryCondition.NBCh = NBCh;
        BoundaryCondition.NBCT = NBCT;
        BoundaryCondition.NBChB = NBChB;
        BoundaryCondition.NBCTB = NBCTB;
        BoundaryCondition.BCh = BCh;
        BoundaryCondition.DSTOR = DSTOR;
        BoundaryCondition.DSTOR0 = DSTOR0;
        BoundaryCondition.RS = RS;
        BoundaryCondition.NBChh = NBChh;
        BoundaryCondition.DSTMAX = DSTMAX;
        BoundaryCondition.IRPT1 = IRPT1;
        BoundaryCondition.IRPT2 = IRPT2;
    
        % used by other scripts
        BoundaryCondition.NBCP = NBCP;
        BoundaryCondition.BChB = BChB;
        BoundaryCondition.BCTB = BCTB;
        BoundaryCondition.BCPB = BCPB;
        BoundaryCondition.BCT = BCT;
        BoundaryCondition.BCP = BCP;
        BoundaryCondition.BtmPg = BtmPg;
        BoundaryCondition.NBCPB = NBCPB;
        BoundaryCondition.NBCN=NBCN;
        BoundaryCondition.NBCNB=NBCNB;
        BoundaryCondition.BCN=BCN;
        BoundaryCondition.BCNB=BCNB;
end
