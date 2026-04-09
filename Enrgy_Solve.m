function [TT,CHK,RHS,C5]= Enrgy_Solve(C5,C5_a,TT,NN,NL,RHS) 

eps = 1e-100;  

C5(1,1) = max(abs(C5(1,1)), eps) * sign(C5(1,1));
RHS(1) = RHS(1) / C5(1,1);

for ML=2:NN
    C5_denominator = max(abs(C5(ML-1,1)), eps) * sign(C5(ML-1,1));
    C5(ML,1)=C5(ML,1)-C5_a(ML-1)*C5(ML-1,2)/C5_denominator;
    C5(ML,1) = max(abs(C5(ML,1)), eps) * sign(C5(ML,1));
    RHS(ML)=(RHS(ML)-C5_a(ML-1)*RHS(ML-1))/C5(ML,1);
end

for ML=NL:-1:1
    RHS(ML)=RHS(ML)-C5(ML,2)*RHS(ML+1)/C5(ML,1);
end

CHK = zeros(NN, 1);
for MN=1:NN
    CHK(MN)=abs(RHS(MN)-TT(MN));  %abs((RHS(MN)-TT(MN))/TT(MN)); 
    TT(MN)=RHS(MN);
end
