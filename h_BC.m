function [AVAIL0,RHS,C4,C4_a,Throughfall,Infiltration,Infiltration_act,TopFlux_potential]=h_BC(RHS,NBCh,NBChB,BCh,BChB, ...
    hN,KT,Delt_t,DSTOR0,NBChh,h_SUR,C4,KL_h,Khh,Throughfall,NN,AVAIL0,C4_a, ...
    EVAP,CanopyInterception,fmax,Tot_Depth,Ks0,theta_s0,Theta_LL,DeltZ)

%%%%%%%%%% Apply the bottom boundary condition called for by NBChB %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if NBChB==1            %-----> Specify matric head at bottom to be ---BChB;
        RHS(1)=BChB;
        C4(1,1)=1;
        RHS(2)=RHS(2)-C4_a(1)*RHS(1);
        C4(1,2)=0;
        C4_a(1)=0;
    elseif NBChB==2        %-----> Specify flux at bottom to be ---BChB (Positive upwards);
        RHS(1)=RHS(1)+BChB;
    elseif NBChB==3        %-----> NBChB=3,Gravity drainage at bottom--specify flux= hydraulic conductivity;
        RHS(1)=RHS(1)-Khh(1,1);%KL_h Khh
    end
    
%%%%%%%%%% Apply the surface boundary condition called for by NBCh  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2025-5-27 朱寄子星加入判断边界切换
    % if DSTMAX == 0
    %     if(hh(NN) > 0)
    %         if NBChh == 2
    %             NBChh = 1;
    %             hN = 0;
    %         end
    %         if hh(NN) <= hcrit
    %             if NBChh == 2
    %                 NBChh = 1;
    %                 hN = hcrit;
    %             end
    %         end
    %     end
    % end

    Infiltration(KT) = Throughfall(KT) .* (1 - fmax .* exp(-0.5 * 0.5 * Tot_Depth / 100));  %随土层的衰减
    % f_max 也可能表示土壤的最大吸水能力。对于不同类型的土壤，
    % 土壤的导水率和饱和度不同，因此 f_max 用来调节降水渗透到土壤的比例。
    % 典型的值范围：0.3 到 0.6。
    % 较低值（如 0.3）通常表示土壤的吸水能力较差，可能是由于土壤结构紧密或含水量接近饱和状态。
    % 较高值（如 0.6）则表示土壤可以吸收更多降水，通常发生在土壤较为干燥或渗透性较好的情况下
    Infiltration_act(KT) = min(Infiltration(KT), Ks0 );
    Infiltration_act(KT) = min(Infiltration_act(KT), (sum(theta_s0 * DeltZ(1:123)) - sum(DeltZ(124:128) .* Theta_LL(124:128, 1)))/Delt_t);
    % run Evap_Cal_Pentext.m; 
    AVAIL0=Infiltration(KT)+DSTOR0/Delt_t;
    TopFlux_potential(KT) = -abs(AVAIL0)+abs(EVAP(KT));
    if NBCh==1             %-----> Specified matric head at surface---equal to hN;
        RHS(NN)=hN;%h_SUR(KT);
        C4(NN,1)=1;
        RHS(NN-1)=RHS(NN-1)-C4(NN-1,2)*RHS(NN);
        C4(NN-1,2)=0;
        C4_a(NN-1)=0;
    elseif NBCh==2
        if NBChh==1
            RHS(NN)=hN;
            C4(NN,1)=1;
            RHS(NN-1)=RHS(NN-1)-C4(NN-1,2)*RHS(NN);
            C4(NN-1,2)=0;
        else
            RHS(NN)=RHS(NN)-BCh;   %> and a specified matric head (saturation or dryness)was applied;
        end
    else  
        if NBChh==1
            RHS(NN)=hN;
            C4(NN,1)=1;
            RHS(NN-1)=RHS(NN-1)-C4(NN-1,2)*RHS(NN);
            C4(NN-1,2)=0;
            C4_a(NN-1)=0;
        else
            RHS(NN)=RHS(NN)-TopFlux_potential(KT);
        end
    end

  % Atmospheric boundary condition 放在边界处理之前
  %     if(TopInf.and.(abs(KodTop).eq.4.or.
  %    !              (abs(KodTop).eq.1.and.rTop.gt.0.))) then
  %       if(KodTop.gt.0) then
  %         M=N-1
  %         dx=(x(N)-x(M))
  %         if(lDensity) fRE=fRo(1,Conc(1,N))
  %         if(lCentrif) Grav=CosAlf*(Radius+abs((x(N)+x(M))/2.))
  %         vTop=-(Con(N)+Con(M))/2.*((hNew(N)-hNew(M))/dx+Grav*fRE)-
  %    !           (ThNew(N)-ThOld(N))*fRE*dx/2./dt-Sink(N)*dx/2.
  %         if(iDualPor.gt.0) vTop=vTop-SinkIm(N)*dx/2.
  %         if(lWTDep) vTop=vTop-
  %    !              (ConLT(N)+ConLT(M))/2.*(Temp(N)-Temp(M))/dx
  %         if(lVapor) vTop=vTop-
  %    !             (ConVh(N)+ConVh(M))/2.*(hNew(N)-hNew(M))/dx-
  %    !             (ConVT(N)+ConVT(M))/2.*(Temp(N)-Temp(M))/dx
  %         if(abs(vTop).gt.abs(rTop).or.vTop*rTop.le.0.) then 
  %           if(abs(KodTop).eq.4) KodTop=-4
  %         end if
  %         if(KodTop.eq.4.and.hNew(N).le.0.99*hCritA.and.rTop.lt.0.)
  %    !      KodTop=-4
  %       else
  %         if(.not.WLayer) then
  %           if(hNew(N).gt.0.) then
  %             if(abs(KodTop).eq.4) KodTop=4
  %             if(abs(KodTop).eq.1) KodTop=1
  %             hTop=0.
  %           end if
  %         end if
  %         if(hNew(N).le.hCritA) then
  %           if(abs(KodTop).eq.4) KodTop=4
  %           if(abs(KodTop).eq.1) KodTop=1
  %           hTop=hCritA
  %         end if
  %       end if
  %     end if