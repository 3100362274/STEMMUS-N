isp ('Convergence Achieved.')
figure;
subplot(3,3,1); plot (hhh, 'DisplayName','hhh', 'YDataSource', 'hhh');
subplot(3,3,2); plot(TTT, 'DisplayName','TTT', 'YDataSource', 'TTT');
subplot(3,3,3); plot(SUMTIME/86400,flux_vars.Srt);
subplot(3,3,4); plot(SUMTIME/86400,Sim_output.EVAP);
subplot(3,3,5); plot(SUMTIME/86400,Sim_output.Tp_t);
subplot(3,3,6); plot(SUMTIME/86400,Ta(1:KT));
subplot(3,3,7); plot(SUMTIME/86400,u_2(1:KT));
subplot(3,3,8); plot(SUMTIME/86400,HR_a(1:KT));
subplot(3,3,9); plot(SUMTIME/86400,RHOV_A(1:KT));

if Msrmn_Fitting
    fig1=figure;
    subplot(7,1,1);plot (SUMTIME/86400, Sim_output.Theta(:,23), 'r-',Msr_Time, Msr_Mois(:,1),'b-','LineWidth',2);title('30cm', 'FontName', 'Times New Roman'); set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4); 
    subplot(7,1,2);plot (SUMTIME/86400, Sim_output.Theta(:,37), 'r-',Msr_Time, Msr_Mois(:,2),'b-','LineWidth',2);title('100cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    subplot(7,1,3);plot (SUMTIME/86400, Sim_output.Theta(:,49), 'r-',Msr_Time, Msr_Mois(:,3),'b-','LineWidth',2);title('200cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    subplot(7,1,4);plot (SUMTIME/86400, Sim_output.Theta(:,59), 'r-',Msr_Time, Msr_Mois(:,4),'b-','LineWidth',2);title('300cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    ylabel('Soil moisture \theta','Rotation',90, 'FontName', 'Times New Roman', 'FontSize', 14)
    subplot(7,1,5);plot (SUMTIME/86400, Sim_output.Theta(:,79), 'r-',Msr_Time, Msr_Mois(:,5),'b-','LineWidth',2);title('500cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    subplot(7,1,6);plot (SUMTIME/86400, Sim_output.Theta(:,100),'r-',Msr_Time, Msr_Mois(:,6),'b-','LineWidth',2);title('700cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    subplot(7,1,7);plot (SUMTIME/86400, Sim_output.Theta(:,128),'r-',Msr_Time, Msr_Mois(:,7),'b-','LineWidth',2);title('1000cm', 'FontName', 'Times New Roman');set(gca, 'FontName', 'Times New Roman', 'FontSize',10);ylim([0, 0.4]); yticks(0:0.1:0.4);
    xlabel('Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);  
    legend('Simulations','Observations', 'FontName', 'Times New Roman', 'FontSize', 10, 'Orientation', 'horizontal', 'Location', 'northeast')
    set(fig1, 'Position', [100, 100, 800, 800]); 

 
    fig2=figure;
    subplot(5,1,1);plot (SUMTIME/3600, Sim_Temp_ind(:,17), 'r-' ,SUMTIME/3600, Sim_Temp(:,17), 'g-' ,Msr_Time/3600, Msr_Temp(1,:),'b.','LineWidth',2);title('20cm');
    subplot(5,1,2);plot (SUMTIME/3600, Sim_Temp_ind(:,21), 'r-' ,SUMTIME/3600, Sim_Temp(:,21), 'g-' ,Msr_Time/3600, Msr_Temp(2,:),'b.','LineWidth',2);title('40cm');
    subplot(5,1,3);plot (SUMTIME/3600, Sim_Temp_ind(:,24), 'r-' ,SUMTIME/3600, Sim_Temp(:,24), 'g-' ,Msr_Time/3600, Msr_Temp(3,:),'b.','LineWidth',2);title('60cm');
    ylabel('Soil temperature T','Rotation',90)
    subplot(5,1,4);plot (SUMTIME/3600, Sim_Temp_ind(:,26), 'r-' ,SUMTIME/3600, Sim_Temp(:,26), 'g-' ,Msr_Time/3600, Msr_Temp(4,:),'b.','LineWidth',2);title('80cm');
    subplot(5,1,5);plot (SUMTIME/3600, Sim_Temp_ind(:,28), 'r-' ,SUMTIME/3600, Sim_Temp(:,28), 'g-' ,Msr_Time/3600, Msr_Temp(5,:),'b.','LineWidth',2);title('100cm');
    xlabel('Time(h)');
    legend('Tind','Tdir','Tobs')
    fig3=figure;
    plot (SUMTIME/3600, EVAP_ind+TRAP_ind, 'b-' ,SUMTIME/3600, EVAP_dir+TRAP_dir, 'r-' ,Msr_Time/3600,ET_H,'ko','LineWidth',2,'MarkerSize',5);
    xlabel('Time(h)');
    ylabel('EvapoTranspiration ET(mm)','Rotation',90);
    legend('ETind','ETdir','ETobs','Location','best')
    fig4=figure;
    subplot(2,1,1);plot (175:275, sumEVAP_ind+sumTRAP_ind, 'b-' ,175:275, sumEVAP_dir+sumTRAP_dir, 'r-' ,175:275,ET_D(1:101),'ko','LineWidth',2,'MarkerSize',5);
    xlabel('DOY');
    ylabel('EvapoTranspiration ET(mm)','Rotation',90);
    legend('ETind','ETdir','ETobs','Location','best')
    subplot(2,1,2);plot (175:275, sumEVAP_ind, 'b-' ,175:275, sumEVAP_dir, 'r-' ,175:275,E_D(1:101),'ko','LineWidth',2,'MarkerSize',5);
    xlabel('DOY');
    ylabel('Evaporation E(mm)','Rotation',90);
    legend('Eind','Edir','Eobs','Location','best')
end