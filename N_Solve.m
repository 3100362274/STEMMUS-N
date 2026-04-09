function [Nn,Nno3,C4,C3,CHK2,CHK3]=N_Solve(C4,C3,Nn,Nno3,NN,NL,C4_a,C3_a,RHS,RHS1)
%Solve the tridiagonal matrix equations using Thomas algorithm 立即归一化法，稳定性好
eps = 1e-100;  
%% NH4+__N
    
    
    RHS(1)=RHS(1)/max(C3(1,1),eps) * sign(C3(1,1));
    
    for ML=2:NN
        C3_denominator = max(abs(C3(ML-1,1)), eps) * sign(C3(ML-1,1));
        C3(ML,1)=C3(ML,1)-C3_a(ML-1)*C3(ML-1,2)/C3_denominator;
        C3(ML,1) = max(abs(C3(ML,1)), eps) * sign(C3(ML,1));
        RHS(ML)=(RHS(ML)-C3_a(ML-1)*RHS(ML-1))/C3(ML,1);
    end
    
    for ML=NL:-1:1
        RHS(ML)=RHS(ML)-C3(ML,2)*RHS(ML+1)/C3(ML,1);
    end
    
    CHK2 = zeros(NN, 1);
    for MN=1:NN
        CHK2(MN)=abs(RHS(MN)-Nn(MN)); 
        Nn(MN,1)=RHS(MN);
    end
    
     %% NO3-__N
 
     C4(1,1) = max(abs(C4(1,1)), eps) * sign(C4(1,1));
     RHS1(1) = RHS1(1) / C4(1,1);

     for ML = 2:NN
         C4_denominator = max(abs(C4(ML-1,1)), eps) * sign(C4(ML-1,1));
         C4(ML,1) = C4(ML,1) - C4_a(ML-1)*C4(ML-1,2)/C4_denominator;
         C4(ML,1) = max(abs(C4(ML,1)), eps) * sign(C4(ML,1));
         RHS1(ML) = (RHS1(ML) - C4_a(ML-1)*RHS1(ML-1)) / C4(ML,1);
     end

     for ML = NL:-1:1
         RHS1(ML) = RHS1(ML) - C4(ML,2)*RHS1(ML+1)/C4(ML,1);
     end

     CHK3 = zeros(NN, 1);
     for MN = 1:NN
         CHK3(MN) = abs(RHS1(MN) - Nno3(MN));
         Nno3(MN) = RHS1(MN);
     end
end