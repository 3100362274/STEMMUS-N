function [CHKWATER,CHK_RESWATER,hh,C4,SAVEhh]=hh_Solve(C4,hh,NN,NL,C4_a,RHS,my_eps)

    C4(1,1) = max(abs(C4(1,1)), my_eps) * sign(C4(1,1));
    RHS(1) = RHS(1) / C4(1,1);

     for ML = 2:NN
         C4_denominator = max(abs(C4(ML-1,1)), my_eps) * sign(C4(ML-1,1));
         C4(ML,1) = C4(ML,1) - C4_a(ML-1)*C4(ML-1,2)/C4_denominator;
         C4(ML,1) = max(abs(C4(ML,1)), my_eps) * sign(C4(ML,1));
         RHS(ML) = (RHS(ML) - C4_a(ML-1)*RHS(ML-1)) / C4(ML,1);
     end
        
    for ML = NL:-1:1
        RHS(ML) = RHS(ML) - C4(ML,2)*RHS(ML+1)/C4(ML,1);
    end
    
    CHKWATER = zeros(NN, 1);
    CHK_RESWATER = zeros(NN, 1);
    SAVEhh = zeros(NN, 1);
    for MN = 1:NN
        CHKWATER(MN) = abs(RHS(MN) - hh(MN));
        CHK_RESWATER(MN)=norm((RHS(MN) - hh(MN)),2) / (norm(hh(MN),2) + 1e-10);
        hh(MN) = 1*RHS(MN)+0*hh(MN);SAVEhh(MN)=hh(MN);
    end

    % if isnan(SAVEhh)==1
    %     keyboard
    % end
    % if ~isreal(SAVEhh)
    %     keyboard
    % end