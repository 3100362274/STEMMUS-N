function [C6,P_gg,RHS]=Air_Solve(C6,NN,NL,C6_a,RHS,P_gg)
eps = 1e-100;  

C6(1,1) = max(abs(C6(1,1)), eps) * sign(C6(1,1));
RHS(1) = RHS(1) / C6(1,1);

for ML=2:NN
    C6_denominator = max(abs(C6(ML-1,1)), eps) * sign(C6(ML-1,1));
    C6(ML,1)=C6(ML,1)-C6_a(ML-1)*C6(ML-1,2)/C6_denominator;
    C6(ML,1) = max(abs(C6(ML,1)), eps) * sign(C6(ML,1));
    RHS(ML)=(RHS(ML)-C6_a(ML-1)*RHS(ML-1))/C6(ML,1);
end

for ML=NL:-1:1
    RHS(ML)=RHS(ML)-C6(ML,2)*RHS(ML+1)/C6(ML,1);
end

for MN=1:NN
    P_gg(MN)=RHS(MN);
end