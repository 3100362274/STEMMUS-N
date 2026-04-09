function N_sub
%Nitrogen transport equation

     global R1 R1O E1 B1 F1 G1 R2 R2O E2 B2 F2 G2 QL  QL_h QL_T  QL_A V_L cvSnit cvSmin cvSden cvSinkS cvSinkS1 cvSvol
    global NL RHOKG1 Retard Dsh Dsh_h Dsh_T Dsh_A Theta_LL Theta_L Snit Smin SVnit SinkS Sden SVden Svol KL_h KL_T hh TT P_gg D_Ta
    global KLa_Switch DeltZ DhDZ DTDZ DPgDZ KLhBAR KLTBAR DTDBAR Theta_LLBAR Gamma_w NN  Nn Nno3 Delt_t  
    global C1 C1O C2 C2O C3 C4 C3_a C4_a C5 C6 CHK2 CHK3 PeCr
    global SAVE SAVE1  N No3  lUpW Peclet2 Peclet1 Infiltration Srt
    global DVa_Switch QMB cBot cTop cBot1 cTop1 cT1 cT cB cB1 NBCh NBCN NBCNB KT Nno3 NBChh Thmrlefc DSTMAX hN
    global cvBot cvTop cvBot1 cvTop1 QNH4 QNO3 E1BAR DNH4DZ E2BAR DNO3DZ Precip DSTOR0 EVAP lBNF BNF Shys TIME t_fert F_tree A_tree DEPTH RHO_bulk
    global QNH4_h QNH4_T QNH4_A QNH4_convection QNH4_convection_h QNH4_convection_T QNH4_convection_A QNH4_dispersion ...  
          QNH4_dispersion_h QNH4_dispersion_T QNH4_dispersion_A QNO3_h ...
          QNO3_T  QNO3_A QNO3_convection QNO3_convection_h QNO3_convection_T ...
          QNO3_convection_A QNO3_dispersion QNO3_dispersion_h QNO3_dispersion_T QNO3_dispersion_A
    vv = zeros(NL,1);
    vv1 = zeros(NL,1);
    wc1 = zeros(NL,1);
    wc2 = zeros(NL,1);
    Peclet = zeros(NL,1);
    rMin =1.e-30;  


    QL_nodes = convert_element_to_node(QL, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_h = convert_element_to_node(QL_h, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_T = convert_element_to_node(QL_T, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_A = convert_element_to_node(QL_A, NL, NN, DeltZ); % 转换为节点量
    % QL_nodes = CalculateVelocities(QL, NL, NN, DeltZ, Theta_LL, Theta_L, Delt_t, Srt);
    cTop(KT) =  0;
    cTop1(KT) = 0;
    if DSTMAX && hN > 0
        cTop(KT) =  cTop_WLayer(KT);
        cTop1(KT) = cTop1_WLayer(KT);
        AVAIL0 = (Infiltration(KT) - EVAP(KT)) + DSTOR0 / Delt_t;
        if(AVAIL0 > 0)
            cTop(KT) = (hN / Delt_t * cTop(KT) + Infiltration(KT) * cT(KT)) / (hN / Delt_t + (Infiltration(KT) - EVAP(KT)));
            cTop1(KT) = (hN / Delt_t * cTop1(KT) + Infiltration(KT) * cT1(KT)) / (hN / Delt_t + (Infiltration(KT) - EVAP(KT)));
        end
    else
        if NBCh == 3 && NBCN == 2
            denom = Infiltration(KT) - EVAP(KT);
            if abs(denom) > 1e-6
                cTop(KT) =Infiltration(KT)/ (Infiltration(KT)-EVAP(KT))*cT(KT);
                cTop1(KT) =Infiltration(KT)/ (Infiltration(KT)-EVAP(KT))*cT1(KT);
            elseif(EVAP(KT)>0)
                cTop(KT)=0;
                cTop1(KT)=0;
            end
        end
    end 
    cBot(KT)=cB(KT);
    cBot1(KT)=cB1(KT);

    [R1, R1O, E1, B1, F1, G1, R2, R2O, E2, B2, F2, G2, cvSnit, cvSmin, cvSden, cvSinkS, cvSinkS1, cvSvol, ...
          QNH4, QNO3, DNH4DZ, DNO3DZ, QNH4_h, QNH4_T, QNH4_A, QNH4_convection, ...
          QNH4_convection_h, QNH4_convection_T, QNH4_convection_A, QNH4_dispersion, ...  
          QNH4_dispersion_h, QNH4_dispersion_T, QNH4_dispersion_A, QNO3_h, ...
          QNO3_T, QNO3_A, QNO3_convection, QNO3_convection_h, QNO3_convection_T, ...
          QNO3_convection_A, QNO3_dispersion, QNO3_dispersion_h, QNO3_dispersion_T, ...  
          QNO3_dispersion_A] = N_PARM(NL, RHOKG1, Dsh, Dsh_h, Dsh_T, Dsh_A, QL_nodes, QL_nodes_h, QL_nodes_T, QL_nodes_A, ...
          Theta_L, Theta_LL, Snit, SVnit, SVden, Smin, Svol, SinkS, Sden, ...
          cvSnit, cvSvol, cvSmin, cvSden, cvSinkS, cvSinkS1, DeltZ, R1, R1O, E1, B1, F1, G1, ...
          R2, R2O, E2, B2, F2, G2, Shys, Nn, Nno3, KT);
    [Peclet1, wc1, Courant1, PECR1] = PeCour( lUpW , E1, NL, Theta_LL, QL_nodes, DeltZ, Delt_t, vv, vv1, wc1, Peclet, Retard);
    [Peclet2, wc2, Courant2, PECR2] = PeCour( lUpW , E2, NL, Theta_LL, QL_nodes, DeltZ, Delt_t, vv, vv1, wc2, Peclet, ones(NL,2));
    [C1, C1O, C2, C2O, C3, C4, C3_a, C4_a, C5, C6,M,K,Me,Ke_diff,Ke_conv,F] = N_MAT(R1, R1O, E1, B1, F1, G1, R2, R2O, E2, B2, F2, G2, DeltZ, NL, NN, wc2, wc1,Theta_L,Theta_LL);
    [RHS,RHS1,C3,C4,SAVE]=N_EQ(C1,C1O,C2,C2O,C3,C4,C5,C6,NL,NN,Delt_t,N,No3,M,K,F,SAVE);
    [RHS,RHS1,C4,C4_a,C3,C3_a,cTop1,cTop]=N_BC(RHS1,C3,C3_a,RHS,NBCN,NBCNB,KT,C4,NN,C4_a,QL_nodes,Thmrlefc,QMB,cBot,cTop,cBot1,cTop1,lBNF,BNF) ;
    [Nn,Nno3,C4,C3,CHK2,CHK3]=N_Solve(C4,C3,Nn,Nno3,NN,NL,C4_a,C3_a,RHS,RHS1);
    for MN=1:NN
        Nno3(MN) = max(Nno3(MN),0);
        Nn(MN) = max(Nn(MN),0) ;
        if Nno3(MN) < 1.e-30 && Nno3(MN) > 0
            Nno3(MN) = 0;
        end
        if Nn(MN) < 1.e-30 && Nn(MN) > 0
            Nn(MN) = 0;
        end
    end
    if all(PECR1 > PeCr) || all(PECR2 > PeCr)
        warning('May be Oscillatory Behavior,Please decrease DELTt or DELTx');
    end
    [cvBot,cvTop,cvBot1,cvTop1]=N_Bndry_Flux(SAVE,Nn,Nno3,NN,KT, ...
    cvTop,cvBot,cvTop1,cvBot1,QL_nodes,cBot,cTop,cTop1,cBot1,NBCN,NBCNB,rMin,Thmrlefc,QMB);
   
end