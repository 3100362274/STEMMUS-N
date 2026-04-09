function [cvBot,cvTop,cvBot1,cvTop1]=N_Bndry_Flux(SAVE,Nn,Nno3,NN,KT, ...
    cvTop,cvBot,cvTop1,cvBot1,QL_nodes,cBot,cTop,cTop1,cBot1,NBCN,NBCNB,rMin,Thmrlefc,QMB)

%% NH4+__N
    if NBCN == 2
        if QL_nodes(NN)<0, cvTop(KT)=cvTop(KT) + QL_nodes(NN)*cTop(KT); end
    else
        cvTop(KT)=SAVE(2,1,4)-SAVE(2,2,4)*Nn(NN-1)-SAVE(2,3,4)*Nn(NN);
    end
    
    if NBCNB == 2
        if QL_nodes(1)>=0 , cvBot(KT)=cvBot(KT)+QL_nodes(1)*cBot(KT); end
        if QL_nodes(1)<0 ,  cvBot(KT)=cvBot(KT)+QL_nodes(1)*Nn(1); end
        if Thmrlefc == 1 && QMB(KT) == 0 ,  cvBot(KT)=0; end
    elseif   NBCNB == 3
        % cvBot(KT)=cvBot(KT)+QL_nodes(1)*Nn(1); 
        cvBot(KT)=-SAVE(1,1,4)+SAVE(1,2,4)*Nn(1)+SAVE(1,3,4)*Nn(2);
    else
        cvBot(KT)=-SAVE(1,1,4)+SAVE(1,2,4)*Nn(1)+SAVE(1,3,4)*Nn(2);
    end
    
    if(abs(cvTop(KT)) < rMin) ,cvTop(KT)=0; end
    if(abs(cvBot(KT)) < rMin) , cvBot(KT)=0; end

%% NO3-__N

    if NBCN == 2
        if QL_nodes(NN)<0, cvTop1(KT)=cvTop1(KT) + QL_nodes(NN)*cTop1(KT); end
    else
        cvTop1(KT)=SAVE(2,1,5)-SAVE(2,2,5)*Nno3(NN-1)-SAVE(2,3,5)*Nno3(NN);
    end
    
    if NBCNB == 2
        if QL_nodes(1)>=0 , cvBot1(KT)=cvBot1(KT)+QL_nodes(1)*cBot1(KT); end
        if QL_nodes(1)<0 ,  cvBot1(KT)=cvBot1(KT)+QL_nodes(1)*Nno3(1); end
        if Thmrlefc == 1 && QMB(KT) == 0 ,  cvBot1(KT)=0; end
    elseif   NBCNB == 3
        % cvBot1(KT)=cvBot1(KT)+QL_nodes(1)*Nno3(1); 
        cvBot1(KT)=-SAVE(1,1,5)+SAVE(1,2,5)*Nno3(1)+SAVE(1,3,5)*Nno3(2);
    else
        cvBot1(KT)=-SAVE(1,1,5)+SAVE(1,2,5)*Nno3(1)+SAVE(1,3,5)*Nno3(2);
    end
    
    if(abs(cvTop1(KT)) < rMin) , cvTop1(KT)=0; end
    if(abs(cvBot1(KT)) < rMin) , cvBot1(KT)=0; end

