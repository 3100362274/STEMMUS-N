        fig5=figure;
         
        yyaxis left%控制左纵轴
        subplot(10,1,1);plot (time, Sim_output.NO3(2:end,1), 'r-');title('30cm');xtickformat('yyyy-MM-dd');
        yyaxis right%控制右纵轴
        bar(time, Sim_output.Infiltration_act, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'none', 'BarWidth', 0.5);xtickformat('yyyy-MM-dd');
        ax = gca;
        ax.YColor = 'k';
        title('0cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time])
        yyaxis right%控制右纵轴
        ylabel('precipitation mm', 'FontName', 'Times New Roman')


        
        subplot(10,1,2);plot (time, Sim_output.NO3(2:end,13), 'r-');title('30cm');xtickformat('yyyy-MM-dd');
        title('10cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time])
       
        % ylim([0, 250]);
        subplot(10,1,3);plot (time, Sim_output.NO3(2:end,18), 'r-' );title('70cm');xtickformat('yyyy-MM-dd');
        title('20cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 250]);
        subplot(10,1,4);plot (time, Sim_output.NO3(2:end,23), 'r-' );title('100cm');xtickformat('yyyy-MM-dd');
        title('30cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        subplot(10,1,5);plot (time, Sim_output.NO3(2:end,27), 'r-');title('200cm');xtickformat('yyyy-MM-dd');
        title('40cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        ylabel('Soil NO3- (mg/kg)', 'Rotation', 90, 'FontName', 'Times New Roman', 'FontSize', 14);
        subplot(10,1,6);plot (time, Sim_output.NO3(2:end,29), 'r-');title('300cm');xtickformat('yyyy-MM-dd');
        title('50cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        subplot(10,1,7);plot (time, Sim_output.NO3(2:end,31),'r-' );title('500cm');xtickformat('yyyy-MM-dd');
        title('60cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        % ylim([0, 500]);
        
        subplot(10,1,8);plot (time, Sim_output.NO3(2:end,33),'r-');title('1000cm');xtickformat('yyyy-MM-dd');
        title('70cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
       

        subplot(10,1,8);plot (time, Sim_output.NO3(2:end,35),'r-');title('1000cm');xtickformat('yyyy-MM-dd');
        title('80cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
       

        subplot(10,1,9);plot (time, Sim_output.NO3(2:end,37),'r-');title('1000cm');xtickformat('yyyy-MM-dd');
        title('90cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
       

        subplot(10,1,10);plot (time, Sim_output.NO3(2:end,39),'r-');title('1000cm');xtickformat('yyyy-MM-dd');
        title('100cm', 'FontName', 'Times New Roman');
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
        xlim([start_time end_time]);
        set(fig5, 'Position', [100, 100, 800, 800]);
        % ylim([0, 500]);
        xlabel('Calibration Time(day)', 'FontName', 'Times New Roman', 'FontSize', 14);
        legend('Deep furrow applicationx', 'Deep furrow application','FontName', 'Times New Roman');