function  [cvNH4,cvNO3,DNH4DZ,DNO3DZ]=N_Flux(E1,E2,Nn,Nno3,NL,DeltZ,cvNH4,cvNO3,E1BAR,DNH4DZ,E2BAR,DNO3DZ,QL);
% Calculate flux concentration for the NH4+__N and NO3-__N

%% NH4+__N
for ML=1:NL
        E1BAR(ML)=(E1(ML,1)+E1(ML,2))/2;
        DNH4DZ(ML)=(Nn(ML+1)-Nn(ML))/DeltZ(ML);     
end  
    for ML=1:NL
        for ND=1:2
            MN=ML+ND-1;    
            cvNH4(ML)=QL(ML)*Nn(MN)-E1BAR(ML)*DNH4DZ(ML);
        end
    end

%% NO3-__N
for ML=1:NL
        E2BAR(ML)=(E2(ML,1)+E2(ML,2))/2;
        DNO3DZ(ML)=(Nno3(ML+1)-Nno3(ML))/DeltZ(ML);     
end  
    for ML=1:NL
        for ND=1:2
            MN=ML+ND-1;    
            cvNO3(ML)=QL(ML)*Nno3(MN)-E2BAR(ML)*DNO3DZ(ML);
        end
    end