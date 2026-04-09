function [Dsh, DIF2, DISP2,Dsh_h,Dsh_T,Dsh_A] = CalculateSoluteDispersion(DIF1111, nS, NL, Theta_LL, Theta_s, QL,QL_h,QL_T ,QL_A, DISP11, NN, DeltZ, R, Tr, TT, eT, Delt_t, Srt, Theta_L, lArtD, lUpW, RHOKG1, PeCr, Retard)
% Calculate the solute dispersion coefficient

    EA=0;
    TD=zeros(NN);
    
    QL_nodes = convert_element_to_node(QL, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_h = convert_element_to_node(QL_h, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_T = convert_element_to_node(QL_T, NL, NN, DeltZ); % 转换为节点量
    QL_nodes_A = convert_element_to_node(QL_A, NL, NN, DeltZ); % 转换为节点量
    % QL_nodes = CalculateVelocities(QL, NL, NN, DeltZ, Theta_LL, Theta_L, Delt_t, Srt);
    
    fw = Theta_LL.^(7/3) ./ Theta_s'.^2;  % 向量化操作

    for MN=1:NN
        %Arrhenius FORMULA
        TD(MN)=(TT(MN)-Tr)/R/(TT(MN)+273.15)./(Tr+273.15);
        eT(MN)=exp(EA*TD(MN));
    end

    if eT(MN) > 1
        eT(MN) = 1;
    end    

    for js=1:nS
        for ML = 1:NL
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DIF2(ML, ND, js) = DIF1111(1,ML,js)' * fw(ML,ND) * eT(MN);  % 利用广播
            end
        end
    end
   
    for js = 1:nS
        for ML = 1:NL
            J = ML;  % 当前单元的土壤类型索引
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DISP2(ML, ND, js) = DISP11(J) * abs(QL_nodes(MN));  % 使用对应土壤类型的DISP1     
            end
        end
    end

    for js = 1:nS
        for ML = 1:NL
            J = ML;  % 当前单元的土壤类型索引
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DISP2_h(ML, ND, js) = DISP11(J) * abs(QL_nodes_h(MN));  % 使用对应土壤类型的DISP1     
            end
        end
    end

    for js = 1:nS
        for ML = 1:NL
            J = ML;  % 当前单元的土壤类型索引
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DISP2_T(ML, ND, js) = DISP11(J) * abs(QL_nodes_T(MN));  % 使用对应土壤类型的DISP1     
            end
        end
    end

    for js = 1:nS
        for ML = 1:NL
            J = ML;  % 当前单元的土壤类型索引
            for ND = 1:2
                MN = ML + ND - 1;  % 节点编号
                DISP2_A(ML, ND, js) = DISP11(J) * abs(QL_nodes_A(MN));  % 使用对应土壤类型的DISP1     
            end
        end
    end


    for js = 1:nS
        for ML = 1:NL
            for ND = 1:2
                Dsh(ML, ND, js) = Theta_LL(ML, ND) * DIF2(ML, ND, js) + DISP2(ML, ND, js);
            end
        end
    end

     for js = 1:nS
        for ML = 1:NL
            for ND = 1:2
                Dsh_h(ML, ND, js) = Theta_LL(ML, ND) * DIF2(ML, ND, js) + DISP2_h(ML, ND, js);
            end
        end
     end

      for js = 1:nS
        for ML = 1:NL
            for ND = 1:2
                Dsh_T(ML, ND, js) = Theta_LL(ML, ND) * DIF2(ML, ND, js) + DISP2_T(ML, ND, js);
            end
        end
      end

      for js = 1:nS
          for ML = 1:NL
              for ND = 1:2
                  Dsh_A(ML, ND, js) = Theta_LL(ML, ND) * DIF2(ML, ND, js) + DISP2_A(ML, ND, js);
              end
          end
      end


    if(~ lArtD && ~lUpW)
        DPom=zeros(NL,2,2);
        for ML = 1:NL
            for ND = 1:2
                DPom(ML, ND, 1) = max(Delt_t / (6  * ( Theta_LL(ML, ND) + RHOKG1(J))),0);
                DPom(ML, ND, 2) = max(Delt_t / (6  * Theta_LL(ML, ND)),0);
            end
        end
        for js = 1:nS
            for ML = 1:NL
                for ND = 1:2
                    MN = ML + ND -1;
                    Dsh(ML, ND, js) = max(Dsh(ML, ND, js) - QL_nodes(MN) * QL_nodes(MN) * DPom(ML, ND, js) , Dsh(ML, ND, js)/2);
                end
            end
        end
        for js = 1:nS
            for ML = 1:NL
                for ND = 1:2
                    MN = ML + ND -1;
                    Dsh_h(ML, ND, js) = max(Dsh_h(ML, ND, js) - QL_nodes_h(MN) * QL_nodes_h(MN) * DPom(ML, ND, js) , Dsh_h(ML, ND, js)/2);
                end
            end
        end
        for js = 1:nS
            for ML = 1:NL
                for ND = 1:2
                    MN = ML + ND -1;
                    Dsh_T(ML, ND, js) = max(Dsh_T(ML, ND, js) - QL_nodes_T(MN) * QL_nodes_T(MN) * DPom(ML, ND, js) , Dsh_T(ML, ND, js)/2);
                end
            end
        end
        for js = 1:nS
            for ML = 1:NL
                for ND = 1:2
                    MN = ML + ND -1;
                    Dsh_A(ML, ND, js) = max(Dsh_A(ML, ND, js) - QL_nodes_A(MN) * QL_nodes_A(MN) * DPom(ML, ND, js) , Dsh_A(ML, ND, js)/2);
                end
            end
        end
    end


    if(lArtD)
        DD=zeros(NL,2,2);
        if(PeCr ~= 0 && abs(min(QL_nodes)) > 1.e-15)
            for ML = 1:NL
                for ND = 1:2
                    DD(ML, ND, 1) = QL_nodes(MN) * QL_nodes(MN) * Delt_t / Theta_LL(ML, ND) / Retard(ML, ND) / PeCr;
                    DD(ML, ND, 2) = QL_nodes(MN) * QL_nodes(MN) * Delt_t / Theta_LL(ML, ND) / 1 / PeCr;
                end
            end
        end
        for js = 1:nS
            for ML = 1:NL
                for ND = 1:2
                    if(DD(ML, ND, js) > Dsh(ML, ND, js))
                        Dsh(ML, ND, js) = DD(ML, ND, js);
                    end
                end
            end
        end
    end



















