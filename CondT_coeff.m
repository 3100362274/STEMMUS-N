    function [c_unsat,Lambda_eff,ZETA,ETCON,EHCAP]=CondT_coeff(Theta_LL,Lambda1,Lambda2,Lambda3,RHO_bulk,Theta_g,RHODA,RHOV,c_a,c_V,c_L,NL,nD,ThmrlCondCap, ...
        HCAP,SF,TCA,GA1,GA2,GB1,GB2,HCD,ZETA0,CON0,PS1,PS2,XWILT,XK,TT,POR,DRHOVT,L,D_A,Theta_V, ...
        c_unsat,Lambda_eff,ETCON,EHCAP,ZETA,TCON)
    %This is to calculate thermal conductivity and thermal capacity.

    %{
                Chung, S. O., and R. Horton (1987), Soil heat and water flow with a
                partial surface mulch, Water Resour. Res., 23(12), 2175-2186,
                Zeng, Y., Su, Z., Wan, L. and Wen, J.: Numerical analysis of
                air-water-heat flow in unsaturated soil: Is it necessary to consider
                airflow in land surface models?, J. Geophys. Res. Atmos., 116(D20),
                20107, doi:10.1029/2011JD015835, 2011.
    %}
    
        if ThmrlCondCap==1
            [ETCON,EHCAP,ZETA]=EfeCapCond(HCAP,TCON,SF,TCA,GA1,GA2,GB1,GB2,HCD,ZETA0,CON0,PS1,PS2,XWILT,XK,TT,NL,POR,Theta_LL,DRHOVT,L,D_A,RHOV,Theta_V,ZETA,ETCON,EHCAP);
        end
        for ML=1:NL
            for ND=1:nD
                if ThmrlCondCap==1
                    Lambda_eff(ML,ND)=ETCON(ML,ND);
                    if Lambda_eff(ML,ND)<=0
                        Lambda_eff(ML,ND)=0.0008;
                    elseif Lambda_eff(ML,ND)>=0.02
                        Lambda_eff(ML,ND)=0.02;
                    else
                        Lambda_eff(ML,ND)=Lambda_eff(ML,ND);
                    end
                    c_unsat(ML,ND)=EHCAP(ML,ND);
                else
                    MN=ML+ND-1;
                    Lambda_eff(ML,ND)=Lambda1+Lambda2*Theta_LL(ML,ND)+Lambda3*Theta_LL(ML,ND)^0.5; %3.6*0.001*4.182; % It is possible to add the dispersion effect here to consider the heat dispersion.
                    c_unsat(ML,ND)= 837*RHO_bulk/1000+Theta_LL(ML,ND)*c_L+Theta_g(ML,ND)*(RHODA(MN)*c_a+RHOV(MN)*c_V);%9.79*0.1*4.182;%
                end
            end
        end
    end

%%%%% Unit of Lambda_eff is (J.m^-1.s^-1.Cels^-1), While c_unsat is (J.m^-3.Cels^-1)
%%%%% UnitC needs to be used here to convert 'm' to 'cm' . 837 in J.kg^-1.Cels^-1. RHO_bulk in kg.m^-3 %%%%% 
%%%%% c_a, c_v,would be in J.g^-1.Cels^-1 as showed in
%%%%% globalization.  RHOV and RHODA would be in g.cm^-3