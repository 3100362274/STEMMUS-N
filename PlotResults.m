time = datetime(2022,7,17) + days(0:1261); 

fig1 = figure; 
    % 第1个子图 (30cm)
    
    subplot(8,1,1);
    
    yyaxis left%控制左纵轴
    plot(time, Sim_output.Theta(:,1), 'r-');xtickformat('yyyy-MM-dd');
    yticks(0:0.1:0.4);
    ylim([0, 0.4]);
    ax = gca;
    ax.YColor = 'k';
    yyaxis right%控制右纵轴
    bar(time, Sim_output.Infiltration_act, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'none', 'BarWidth', 0.5);xtickformat('yyyy-MM-dd');
    title('0cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    ax = gca;
    ax.YColor = 'k';
    xlim([start_time end_time]);
    yyaxis right%控制右纵轴
    ylabel('precipitation mm', 'FontName', 'Times New Roman')
    
    
    subplot(8,1,2);
    plot(time, Sim_output.Theta(:,23), 'r-');xtickformat('yyyy-MM-dd');
    title('30cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    yticks(0:0.1:0.4);
    ylim([0, 0.4]);
   
    % 第2个子图 (100cm)
    subplot(8,1,3);
    plot(time, Sim_output.Theta(:,37), 'r-');xtickformat('yyyy-MM-dd');
    title('100cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4);
    % 计算 MAE 和 NRMSE
    
    % 第3个子图 (200cm)
    subplot(8,1,4);
    plot(time, Sim_output.Theta(:,49), 'r-');xtickformat('yyyy-MM-dd');
    title('200cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4);
 
    
    % 第4个子图 (300cm)
    subplot(8,1,5);
    plot(time, Sim_output.Theta(:,59), 'r-');xtickformat('yyyy-MM-dd');
    title('300cm', 'FontName', 'Times New Roman');
    xlim([start_time end_time]);
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4);
   
    % 第5个子图 (500cm)
    subplot(8,1,6);
    plot(time, Sim_output.Theta(:,79), 'r-');xtickformat('yyyy-MM-dd');
    title('500cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4); 
    
    % 第6个子图 (700cm)
    subplot(8,1,7);
    plot(time, Sim_output.Theta(:,100), 'r-');xtickformat('yyyy-MM-dd');
    title('700cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4);
  
    
    % 第7个子图 (1000cm)
    subplot(8,1,8);
    plot(time, Sim_output.Theta(:,128), 'r-');xtickformat('yyyy-MM-dd');
    title('1000cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 0.4]);
    yticks(0:0.1:0.4);  
    % 图例
    legend('Simulations', 'Observations', 'FontName', 'Times New Roman', 'FontSize', 10, 'Orientation', 'horizontal', 'Location', 'northeast');
    % 设置图形窗口大小
    set(fig1, 'Position', [100, 100, 800, 800]);
    
 fig2=figure;
 

    subplot(7,1,1);plot (time, Sim_output.Temp(2:end,24), 'r-' );title('30cm');xtickformat('yyyy-MM-dd');
    title('30cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);

    subplot(7,1,2);plot (time, Sim_output.Temp(2:end,38), 'r-');title('70cm');xtickformat('yyyy-MM-dd');
    title('100cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);


    subplot(7,1,3);plot (time, Sim_output.Temp(2:end,50), 'r-' );title('100cm');xtickformat('yyyy-MM-dd');
    title('200cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);

    subplot(7,1,4);plot (time, Sim_output.Temp(2:end,60), 'r-' );title('200cm');xtickformat('yyyy-MM-dd');
    title('300cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);
    ylabel('Soil temperature (°C)', 'Rotation', 90, 'FontName', 'Times New Roman', 'FontSize', 14); 

    subplot(7,1,5);plot (time, Sim_output.Temp(2:end,80), 'r-' );title('300cm');xtickformat('yyyy-MM-dd');
    title('500cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);

    subplot(7,1,6);plot (time, Sim_output.Temp(2:end,101),'r-' );title('500cm');xtickformat('yyyy-MM-dd');
    title('700cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);

    subplot(7,1,7);plot (time, Sim_output.Temp(2:end,128),'r-' );title('1000cm');xtickformat('yyyy-MM-dd');
    title('1000cm', 'FontName', 'Times New Roman');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    xlim([start_time end_time]);
    ylim([0, 30]);
    yticks(0:10:30);
    % Calibration Time Validation
    xlabel('Calibration Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);
    legend('Simulations', 'Observations', 'FontName', 'Times New Roman', 'FontSize', 10, 'Orientation', 'horizontal', 'Location', 'northeast');
    set(fig2, 'Position', [100, 100, 800, 800]);
    if Soilairefc == 1
        fig3=figure;
        subplot(2,1,1);plot (time, Sim_output.Pg(2:end,23 ), 'r-',time, Sim_output.Pg(:,37 ), 'b-' , time, Sim_output.Pg(:,49 ), 'c-' , time, Sim_output.Pg(:,59 ), 'g-' , time, Sim_output.Pg(:,79 ), 'y-', time, Sim_output.Pg(:,100 ), 'k-', time, Sim_output.Pg(:,128 ), 'b--' ,'LineWidth', 2  );
        xtickformat('yyyy-MM-dd');
        xlim([start_time end_time]);
        title('Pg', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlabel('Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);
        legend('30cm', '100cm',  '200cm', '300cm', '500cm', '700cm', '1000cm','FontName', 'Times New Roman', 'FontSize', 6, 'Location', 'northeast');

    end
    if Nefc == 1
        fig4=figure;
        yyaxis left%控制左纵轴
        subplot(7,1,1);plot (time, Sim_output.NH4(2:end,23), 'r-');title('30cm');xtickformat('yyyy-MM-dd');
        yyaxis right%控制右纵轴
        bar(time, Sim_output.Infiltration_act, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'none', 'BarWidth', 0.5);xtickformat('yyyy-MM-dd');
        title('30cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time])
        yyaxis right%控制右纵轴
        ylabel('precipitation mm', 'FontName', 'Times New Roman')

        subplot(7,1,2);plot (time, Sim_output.NH4(2:end,37), 'r-' );title('70cm');xtickformat('yyyy-MM-dd');
        title('100cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);

        subplot(7,1,3);plot (time, Sim_output.NH4(2:end,49), 'r-' );title('100cm');xtickformat('yyyy-MM-dd');
        title('200cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);

        subplot(7,1,4);plot (time, Sim_output.NH4(2:end,59), 'r-' );title('200cm');xtickformat('yyyy-MM-dd');
        title('300cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);

        subplot(7,1,5);plot (time, Sim_output.NH4(2:end,79), 'r-' );title('300cm');xtickformat('yyyy-MM-dd');
        title('500cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);

        subplot(7,1,6);plot (time, Sim_output.NH4(2:end,100),'r-' );title('500cm');xtickformat('yyyy-MM-dd');
        title('700cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);

        subplot(7,1,7);plot (time, Sim_output.NH4(2:end,128));title('1000cm');xtickformat('yyyy-MM-dd');
        title('1000cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        set(fig4, 'Position', [100, 100, 800, 800]);

        fig5=figure;

        yyaxis left%控制左纵轴
        subplot(8,1,1);plot (time, Sim_output.NO3(2:end,1), 'r-');title('30cm');xtickformat('yyyy-MM-dd');
        yyaxis right%控制右纵轴
        bar(time, Sim_output.Infiltration_act, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'none', 'BarWidth', 0.5);xtickformat('yyyy-MM-dd');
        title('0cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time])
        yyaxis right%控制右纵轴
        ylabel('precipitation mm', 'FontName', 'Times New Roman')

        
        subplot(8,1,2);plot (time, Sim_output.NO3(2:end,23), 'r-');title('30cm');xtickformat('yyyy-MM-dd');
        title('30cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time])
       
        % ylim([0, 250]);
        subplot(8,1,3);plot (time, Sim_output.NO3(2:end,37), 'r-' );title('70cm');xtickformat('yyyy-MM-dd');
        title('100cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 250]);
        subplot(8,1,4);plot (time, Sim_output.NO3(2:end,49), 'r-' );title('100cm');xtickformat('yyyy-MM-dd');
        title('200cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        subplot(8,1,5);plot (time, Sim_output.NO3(2:end,59), 'r-' );title('200cm');xtickformat('yyyy-MM-dd');
        title('300cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        ylabel('Soil NO3- (mg/kg)', 'Rotation', 90, 'FontName', 'Times New Roman', 'FontSize', 14);
        subplot(8,1,6);plot (time, Sim_output.NO3(2:end,79), 'r-' );title('300cm');xtickformat('yyyy-MM-dd');
        title('500cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        subplot(8,1,7);plot (time, Sim_output.NO3(2:end,100),'r-' );title('500cm');xtickformat('yyyy-MM-dd');
        title('700cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        
        subplot(8,1,8);plot (time, Sim_output.NO3(2:end,128));title('1000cm');xtickformat('yyyy-MM-dd');
        title('1000cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        set(fig5, 'Position', [100, 100, 800, 800]);
        % ylim([0, 500]);
        xlabel('Calibration Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);

        fig6=figure;
        subplot(3,3,1);plot (time, Sim_output.cvTop1, 'r-');title('cvTop1');xtickformat('yyyy-MM-dd');
        subplot(3,3,2);plot (time, Sim_output.cvBot1, 'r-');title('cvBot1');xtickformat('yyyy-MM-dd');
        subplot(3,3,3);plot (time, Sim_output.Cvdenit_N2oo , 'r-');title('CvdenitN_2O');xtickformat('yyyy-MM-dd');
        subplot(3,3,4);plot (time, Sim_output.Cvdenit_N22 , 'r-');title('CvdenitN_2');xtickformat('yyyy-MM-dd');
        subplot(3,3,5);plot (time, Sim_output.cvSdenn , 'r-');title('cvSdenn');xtickformat('yyyy-MM-dd');
        subplot(3,3,6);plot (time, Sim_output.cvSminn, 'r-');title('cvSminn');xtickformat('yyyy-MM-dd');
        subplot(3,3,7);plot (time, Sim_output.cvSinkSS , 'r-');title('NH_4^+SinkS');xtickformat('yyyy-MM-dd');
        subplot(3,3,8);plot (time, Sim_output.cvSinkS11 , 'r-');title('NO_3^-SinkS');xtickformat('yyyy-MM-dd');
        subplot(3,3,9);plot (time, Sim_output.Trap , 'r-');title('water^-SinkS');xtickformat('yyyy-MM-dd');
    end
    fig6=figure;
    plot (time, Sim_output.Trap, 'r-',time, Sim_output.Tp_t,'b-',time, Sim_output.EVAP,'g-');xtickformat('yyyy-MM-dd');
    legend('Trap', 'Tp',  'Ep','FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'northeast');
    xlabel('Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);
    xlim([start_time end_time]);
    fig7=figure;
    % subplot(1,4,1);plot ( Sim_output.NO3 (275,:),[0;SUMDELTZ],'r-',Sim_output.Theta (275,:).*100,[0;SUMDELTZ],'b-');title('2023-4-18-11A');set(gca, 'YDir', 'reverse');
    % subplot(1,4,2);plot ( Sim_output.NO3 (336,:),[0;SUMDELTZ],'r-',Sim_output.Theta (336,:).*100,[0;SUMDELTZ],'b-');title('2023-6-18-11A');set(gca, 'YDir', 'reverse');
    % subplot(1,4,3);plot ( Sim_output.NO3 (397,:),[0;SUMDELTZ],'r-',Sim_output.Theta (397,:).*100,[0;SUMDELTZ],'b-');title('2023-8-18-11A');set(gca, 'YDir', 'reverse');
    % subplot(1,4,4);plot ( Sim_output.NO3 (458,:),[0;SUMDELTZ],'r-',Sim_output.Theta (458,:).*100,[0;SUMDELTZ],'b-');title('2023-10-18-11A');set(gca, 'YDir', 'reverse');
    % legend('No_3 concentration(mg/kg)', 'soil moisture(100%)','FontName', 'Times New Roman', 'FontSize', 8, 'Location', 'northeast');
    plot ( Sim_output.NO3 (275,:),[0;SUMDELTZ],Sim_output.NO3 (336,:),[0;SUMDELTZ],Sim_output.NO3 (397,:),[0;SUMDELTZ],Sim_output.NO3 (458,:),[0;SUMDELTZ]);title('11A-NO_3');set(gca, 'YDir', 'reverse');
    legend('4-18', '6-18','8-18','10-18','FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'northeast');

     plot ( Sim_output.NO3 (275,:),[0;SUMDELTZ],Sim_output.NO3 (275+365,:),[0;SUMDELTZ],Sim_output.NO3 (275+365*2,:),[0;SUMDELTZ]);title('11A-NO_3');set(gca, 'YDir', 'reverse');
    legend('4-18', '6-18','8-18','10-18','FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'northeast');