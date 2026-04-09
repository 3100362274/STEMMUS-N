function bx = Calculate_actualbx(NL,Tot_Depth,DeltZ)
global SUMDELTZ
% 输入实测bx用

% % 3APPLE
% % y=[0.012820513
% % 0.009615385
% % 0.006410256
% % 0.009188034
% % 0.003418803
% % 0.005555556
% % 0.002564103
% % 0.00042735
% % ];
% %   b = zeros(size(SUMDELTZ));
% %     for i = 1:length(SUMDELTZ)
% %         if SUMDELTZ(i) <= 0
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 20
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 40
% %             b(i) = y(2);
% %         elseif SUMDELTZ(i) <= 60
% %             b(i) = y(3);
% %         elseif SUMDELTZ(i) <= 80
% %             b(i) = y(4);
% %         elseif SUMDELTZ(i) <= 100
% %             b(i) = y(5);
% %         elseif SUMDELTZ(i) <= 120
% %             b(i) = y(6);
% %         elseif SUMDELTZ(i) <= 140
% %             b(i) = y(7);
% %         elseif SUMDELTZ(i) <= 160
% %             b(i) = y(8);
% %         elseif SUMDELTZ(i) <= 180
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 200
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 240
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 280
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 320
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 360
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 400
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 440
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 480
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 520
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 560
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 600
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 640
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 680
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 720
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 760
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 800
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 840
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 880
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 920
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 960
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 1000
% %             b(i) = 0;
% %         else % >1000
% %             b(i) = 0;
% %         end
% %     end
% 
% % 4APPLE
% % y=[0.011038961039
% % 0.009956709957
% % 0.005411255411
% % 0.006060606061
% % 0.005411255411
% % 0.003030303030
% % 0.003246753247
% % 0.003030303030
% % 0.001731601732
% % 0.000865800866
% % 0.000216450216
% % ];
% %   b = zeros(size(SUMDELTZ));
% %     for i = 1:length(SUMDELTZ)
% %         if SUMDELTZ(i) <= 0
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 20
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 40
% %             b(i) = y(2);
% %         elseif SUMDELTZ(i) <= 60
% %             b(i) = y(3);
% %         elseif SUMDELTZ(i) <= 80
% %             b(i) = y(4);
% %         elseif SUMDELTZ(i) <= 100
% %             b(i) = y(5);
% %         elseif SUMDELTZ(i) <= 120
% %             b(i) = y(6);
% %         elseif SUMDELTZ(i) <= 140
% %             b(i) = y(7);
% %         elseif SUMDELTZ(i) <= 160
% %             b(i) = y(8);
% %         elseif SUMDELTZ(i) <= 180
% %             b(i) = y(9);
% %         elseif SUMDELTZ(i) <= 200
% %             b(i) =y(10);
% %         elseif SUMDELTZ(i) <= 220
% %             b(i) =y(11);
% %         elseif SUMDELTZ(i) <= 240
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 280
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 320
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 360
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 400
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 440
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 480
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 520
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 560
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 600
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 640
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 680
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 720
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 760
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 800
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 840
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 880
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 920
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 960
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 1000
% %             b(i) = 0;
% %         else % >1000
% %             b(i) = 0;
% %         end
% %     end
% 
% %5-6APPLE
% % y=[0.0113122172
% % 0.0098981900
% % 0.0050904977
% % 0.0062217195
% % 0.0053733032
% % 0.0031108597
% % 0.0036764706
% % 0.0028280543
% % 0.0016968326
% % 0.0005656109
% % 0.0002262443
% % ];
% %   b = zeros(size(SUMDELTZ));
% %     for i = 1:length(SUMDELTZ)
% %         if SUMDELTZ(i) <= 0
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 20
% %             b(i) = y(1);
% %         elseif SUMDELTZ(i) <= 40
% %             b(i) = y(2);
% %         elseif SUMDELTZ(i) <= 60
% %             b(i) = y(3);
% %         elseif SUMDELTZ(i) <= 80
% %             b(i) = y(4);
% %         elseif SUMDELTZ(i) <= 100
% %             b(i) = y(5);
% %         elseif SUMDELTZ(i) <= 120
% %             b(i) = y(6);
% %         elseif SUMDELTZ(i) <= 140
% %             b(i) = y(7);
% %         elseif SUMDELTZ(i) <= 160
% %             b(i) = y(8);
% %         elseif SUMDELTZ(i) <= 180
% %             b(i) = y(9);
% %         elseif SUMDELTZ(i) <= 200
% %             b(i) =y(10);
% %         elseif SUMDELTZ(i) <= 220
% %             b(i) =y(11);
% %         elseif SUMDELTZ(i) <= 240
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 280
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 320
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 360
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 400
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 440
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 480
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 520
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 560
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 600
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 640
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 680
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 720
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 760
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 800
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 840
% %             b(i) =0;
% %         elseif SUMDELTZ(i) <= 880
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 920
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 960
% %             b(i) = 0;
% %         elseif SUMDELTZ(i) <= 1000
% %             b(i) = 0;
% %         else % >1000
% %             b(i) = 0;
% %         end
% %     end
% 
% %7-8APPLE
% % y=[0.0085485
% % 0.004535939
% % 0.001744592
% % 0.005582694
% % 0.004884857
% % 0.001221214
% % 0.004012561
% % 0.003489184
% % 0.001570133
% % 0.001046755
% % 0.001919051
% % 0.001221214
% % 0.001046755
% % 0.001395673
% % 0.000697837
% % 0.000453594
% % 0.000523378
% % 0.000139567
% % 0.000872296
% % 0.001221214
% % 0.000348918
% % 0.000348918
% % 0.000697837
% % 0.000872296
% % 0.001046755
% % 0
% % 3.48918E-05
% % 0.000523378
% % ];
% %   b = zeros(size(SUMDELTZ)); 
% %   for i = 1:length(SUMDELTZ)
% %       % 0-200cm保持20cm间隔（原逻辑）
% %       if SUMDELTZ(i) <= 0
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 20
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 40
% %           b(i) = y(2);
% %       elseif SUMDELTZ(i) <= 60
% %           b(i) = y(3);
% %       elseif SUMDELTZ(i) <= 80
% %           b(i) = y(4);
% %       elseif SUMDELTZ(i) <= 100
% %           b(i) = y(5);
% %       elseif SUMDELTZ(i) <= 120
% %           b(i) = y(6);
% %       elseif SUMDELTZ(i) <= 140
% %           b(i) = y(7);
% %       elseif SUMDELTZ(i) <= 160
% %           b(i) = y(8);
% %       elseif SUMDELTZ(i) <= 180
% %           b(i) = y(9);
% %       elseif SUMDELTZ(i) <= 200
% %           b(i) = y(10);
% % 
% %           % 200cm后改为40cm间隔（共41段到2000cm）
% %       elseif SUMDELTZ(i) <= 240
% %           b(i) = y(11);
% %       elseif SUMDELTZ(i) <= 280
% %           b(i) = y(12);
% %       elseif SUMDELTZ(i) <= 320
% %           b(i) = y(13);
% %       elseif SUMDELTZ(i) <= 360
% %           b(i) = y(14);
% %       elseif SUMDELTZ(i) <= 400
% %           b(i) = y(15);
% %       elseif SUMDELTZ(i) <= 440
% %           b(i) = y(16);
% %       elseif SUMDELTZ(i) <= 480
% %           b(i) = y(17);
% %       elseif SUMDELTZ(i) <= 520
% %           b(i) = y(18);
% %       elseif SUMDELTZ(i) <= 560
% %           b(i) = y(19);
% %       elseif SUMDELTZ(i) <= 600
% %           b(i) = y(20);
% %       elseif SUMDELTZ(i) <= 640
% %           b(i) = y(21);
% %       elseif SUMDELTZ(i) <= 680
% %           b(i) = y(22);
% %       elseif SUMDELTZ(i) <= 720
% %           b(i) = y(23);
% %       elseif SUMDELTZ(i) <= 760
% %           b(i) = y(24);
% %       elseif SUMDELTZ(i) <= 800
% %           b(i) = y(25);
% %       elseif SUMDELTZ(i) <= 840
% %           b(i) = y(26);
% %       elseif SUMDELTZ(i) <= 880
% %           b(i) = y(27);
% %       elseif SUMDELTZ(i) <= 920
% %           b(i) = y(28);
% %       elseif SUMDELTZ(i) <= 960
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1000
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1040
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1080
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1120
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1160
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1200
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1240
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1280
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1320
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1360
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1400
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1440
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1480
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1520
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1560
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1600
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1640
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1680
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1720
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1760
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1800
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1840
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1880
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1920
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1960
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 2000
% %           b(i) = 0;
% % 
% %           % 处理超过2000cm的情况
% %       else
% %           b(i) = 0;
% %       end
% %   end
 
% %9-10APPLE
% % y=[0.001246827
% % 0.0035968
% % 0.001784446
% % 0.003809513
% % 0.00112269
% % 0.00143359
% % 0.000601638
% % 0.000674501
% % 0.00147775
% % 0.001064242
% % 0.001947568
% % 0.00195732
% % 0.001779511
% % 0.000938689
% % 0.001868869
% % 0.002135449
% % 0.00160733
% % 0.000590641
% % 0.000284752
% % 0.000783416
% % 0.000143154
% % 0.000123581
% % 0.000535177
% % 0.001389077
% % 0.000698631
% % 0.000468148
% % 3.98135E-05
% % 0.000546821
% % 0.000285723
% % 9.61561E-05
% % 8.98716E-05
% % 0.001391826
% % 0.001070556
% % 0.001177936
% % 0.000805128
% % 0.000853698
% % 0.001163357
% % 0.001393301
% % 0.000424808
% % 0.00033294
% % 0.000927637
% % 0.001723122
% % 0.000291714
% % 0.000369903
% % 0.000916993
% % 0.000955828
% % 0.000816692
% % 0.000262864
% % ];
% % b = zeros(size(SUMDELTZ));
% %   for i = 1:length(SUMDELTZ)
% %       if SUMDELTZ(i) <= 0
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 20
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 40
% %           b(i) = y(2);
% %       elseif SUMDELTZ(i) <= 60
% %           b(i) = y(3);
% %       elseif SUMDELTZ(i) <= 80
% %           b(i) = y(4);
% %       elseif SUMDELTZ(i) <= 100
% %           b(i) = y(5);
% %       elseif SUMDELTZ(i) <= 120
% %           b(i) = y(6);
% %       elseif SUMDELTZ(i) <= 140
% %           b(i) = y(7);
% %       elseif SUMDELTZ(i) <= 160
% %           b(i) = y(8);
% %       elseif SUMDELTZ(i) <= 180
% %           b(i) = y(9);
% %       elseif SUMDELTZ(i) <= 200
% %           b(i) = y(10);
% %       elseif SUMDELTZ(i) <= 220
% %           b(i) = y(11);
% %           % 从240cm开始按照20cm间隔扩展到2000cm
% %       elseif SUMDELTZ(i) <= 240
% %           b(i) = y(12);
% %       elseif SUMDELTZ(i) <= 260
% %           b(i) = y(13);
% %       elseif SUMDELTZ(i) <= 280
% %           b(i) = y(14);
% %       elseif SUMDELTZ(i) <= 300
% %           b(i) = y(15);
% %       elseif SUMDELTZ(i) <= 320
% %           b(i) = y(16);
% %       elseif SUMDELTZ(i) <= 340
% %           b(i) = y(17);
% %       elseif SUMDELTZ(i) <= 360
% %           b(i) = y(18);
% %       elseif SUMDELTZ(i) <= 380
% %           b(i) = y(19);
% %       elseif SUMDELTZ(i) <= 400
% %           b(i) = y(20);
% %       elseif SUMDELTZ(i) <= 420
% %           b(i) = y(21);
% %       elseif SUMDELTZ(i) <= 440
% %           b(i) = y(22);
% %       elseif SUMDELTZ(i) <= 460
% %           b(i) = y(23);
% %       elseif SUMDELTZ(i) <= 480
% %           b(i) = y(24);
% %       elseif SUMDELTZ(i) <= 500
% %           b(i) = y(25);
% %       elseif SUMDELTZ(i) <= 520
% %           b(i) = y(26);
% %       elseif SUMDELTZ(i) <= 540
% %           b(i) = y(27);
% %       elseif SUMDELTZ(i) <= 560
% %           b(i) = y(28);
% %       elseif SUMDELTZ(i) <= 580
% %           b(i) = y(29);
% %       elseif SUMDELTZ(i) <= 600
% %           b(i) = y(30);
% %       elseif SUMDELTZ(i) <= 620
% %           b(i) = y(31);
% %       elseif SUMDELTZ(i) <= 640
% %           b(i) = y(32);
% %       elseif SUMDELTZ(i) <= 660
% %           b(i) = y(33);
% %       elseif SUMDELTZ(i) <= 680
% %           b(i) = y(34);
% %       elseif SUMDELTZ(i) <= 700
% %           b(i) = y(35);
% %       elseif SUMDELTZ(i) <= 720
% %           b(i) = y(36);
% %       elseif SUMDELTZ(i) <= 740
% %           b(i) = y(37);
% %       elseif SUMDELTZ(i) <= 760
% %           b(i) = y(38);
% %       elseif SUMDELTZ(i) <= 780
% %           b(i) = y(39);
% %       elseif SUMDELTZ(i) <= 800
% %           b(i) = y(40);
% %       elseif SUMDELTZ(i) <= 820
% %           b(i) = y(41);
% %       elseif SUMDELTZ(i) <= 840
% %           b(i) = y(42);
% %       elseif SUMDELTZ(i) <= 860
% %           b(i) = y(43);
% %       elseif SUMDELTZ(i) <= 880
% %           b(i) = y(44);
% %       elseif SUMDELTZ(i) <= 900
% %           b(i) = y(45);
% %       elseif SUMDELTZ(i) <= 920
% %           b(i) = y(46);
% %       elseif SUMDELTZ(i) <= 940
% %           b(i) = y(47);
% %       elseif SUMDELTZ(i) <= 960
% %           b(i) = y(48);
% %       elseif SUMDELTZ(i) <= 980
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1000
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1020
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1040
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1060
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1080
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1100
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1120
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1140
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1160
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1180
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1200
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1220
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1240
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1260
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1280
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1300
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1320
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1340
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1360
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1380
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1400
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1420
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1440
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1460
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1480
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1500
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1520
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1540
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1560
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1580
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1600
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1620
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1640
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1660
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1680
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1700
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1720
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1740
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1760
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1780
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1800
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1820
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1840
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1860
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1880
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1900
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1920
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1940
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1960
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1980
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 2000
% %           b(i) = 0;
% %           % 处理超过2000cm的情况
% %       else
% %           b(i) = 0;
% %       end
% %   end
 
% 11-13APPLE
% y=[0.0008 
% 0.0015 
% 0.0041 
% 0.0041 
% 0.0016 
% 0.0009 
% 0.0008 
% 0.0008 
% 0.0008 
% 0.0010 
% 0.0003 
% 0.0010 
% 0.0005 
% 0.0007 
% 0.0006 
% 0.0006 
% 0.0010 
% 0.0012 
% 0.0012 
% 0.0010 
% 0.0017 
% 0.0013 
% 0.0015 
% 0.0002 
% 0.0016 
% 0.0006 
% 0.0002 
% 0.0006 
% 0.0004 
% 0.0002 
% 0.0002 
% 
% ];
%  b = zeros(size(SUMDELTZ)); 
%   for i = 1:length(SUMDELTZ)
%       % 0-200cm保持20cm间隔（原逻辑）
%       if SUMDELTZ(i) <= 0
%           b(i) = y(1);
%       elseif SUMDELTZ(i) <= 20
%           b(i) = y(1);
%       elseif SUMDELTZ(i) <= 40
%           b(i) = y(2);
%       elseif SUMDELTZ(i) <= 60
%           b(i) = y(3);
%       elseif SUMDELTZ(i) <= 80
%           b(i) = y(4);
%       elseif SUMDELTZ(i) <= 100
%           b(i) = y(5);
%       elseif SUMDELTZ(i) <= 120
%           b(i) = y(6);
%       elseif SUMDELTZ(i) <= 140
%           b(i) = y(7);
%       elseif SUMDELTZ(i) <= 160
%           b(i) = y(8);
%       elseif SUMDELTZ(i) <= 180
%           b(i) = y(9);
%       elseif SUMDELTZ(i) <= 200
%           b(i) = y(10);
% 
%           % 200cm后改为40cm间隔（共41段到2000cm）
%       elseif SUMDELTZ(i) <= 240
%           b(i) = y(11);
%       elseif SUMDELTZ(i) <= 280
%           b(i) = y(12);
%       elseif SUMDELTZ(i) <= 320
%           b(i) = y(13);
%       elseif SUMDELTZ(i) <= 360
%           b(i) = y(14);
%       elseif SUMDELTZ(i) <= 400
%           b(i) = y(15);
%       elseif SUMDELTZ(i) <= 440
%           b(i) = y(16);
%       elseif SUMDELTZ(i) <= 480
%           b(i) = y(17);
%       elseif SUMDELTZ(i) <= 520
%           b(i) = y(18);
%       elseif SUMDELTZ(i) <= 560
%           b(i) = y(19);
%       elseif SUMDELTZ(i) <= 600
%           b(i) = y(20);
%       elseif SUMDELTZ(i) <= 640
%           b(i) = y(21);
%       elseif SUMDELTZ(i) <= 680
%           b(i) = y(22);
%       elseif SUMDELTZ(i) <= 720
%           b(i) = y(23);
%       elseif SUMDELTZ(i) <= 760
%           b(i) = y(24);
%       elseif SUMDELTZ(i) <= 800
%           b(i) = y(25);
%       elseif SUMDELTZ(i) <= 840
%           b(i) = y(26);
%       elseif SUMDELTZ(i) <= 880
%           b(i) = y(27);
%       elseif SUMDELTZ(i) <= 920
%           b(i) = y(28);
%       elseif SUMDELTZ(i) <= 960
%           b(i) = y(29);
%       elseif SUMDELTZ(i) <= 1000
%           b(i) = y(30);
%       elseif SUMDELTZ(i) <= 1040
%           b(i) = y(31);
%       elseif SUMDELTZ(i) <= 1080
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1120
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1160
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1200
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1240
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1280
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1320
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1360
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1400
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1440
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1480
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1520
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1560
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1600
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1640
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1680
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1720
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1760
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1800
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1840
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1880
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1920
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 1960
%           b(i) = 0;
%       elseif SUMDELTZ(i) <= 2000
%           b(i) = 0;
% 
%           % 处理超过2000cm的情况
%       else
%           b(i) = 0;
%       end
%   end
 
% %14-15-16APPLE
% % y=[0.000223048
% % 0.000966543
% % 0.000966543
% % 0.00267658
% % 0.002081784
% % 0.003568773
% % 0.003457249
% % 0.00133829
% % 0.000669145
% % 0.000223048
% % 0.000483271
% % 0.00063197
% % 0.000111524
% % 0.000111524
% % 0.000371747
% % 0.000334572
% % 0.000817844
% % 0.001412639
% % 0.000817844
% % 0.000817844
% % 0.000334572
% % 0.000669145
% % 0.000594796
% % 0.001152416
% % 0.001040892
% % 0.001115242
% % 0.000817844
% % 0.000334572
% % 0.000111524
% % 0.000223048
% % 0.000223048
% % 0.000111524
% % 0.000446097
% % 0.000483271
% % 0.000334572
% % 3.71747E-05
% % 0.000111524
% % 0.000557621
% % 0.000297398
% % 0.000185874
% % 0.000371747
% % 0.000223048
% % 7.43494E-05
% % 0.000111524
% % 0.000223048
% % 0.000185874
% % 7.43494E-05
% % 3.71747E-05
% % 0.000334572
% % 0
% % 0.000185874
% % 
% % ];
% %  b = zeros(size(SUMDELTZ)); 
% %   for i = 1:length(SUMDELTZ)
% %       % 0-200cm保持20cm间隔（原逻辑）
% %       if SUMDELTZ(i) <= 0
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 20
% %           b(i) = y(1);
% %       elseif SUMDELTZ(i) <= 40
% %           b(i) = y(2);
% %       elseif SUMDELTZ(i) <= 60
% %           b(i) = y(3);
% %       elseif SUMDELTZ(i) <= 80
% %           b(i) = y(4);
% %       elseif SUMDELTZ(i) <= 100
% %           b(i) = y(5);
% %       elseif SUMDELTZ(i) <= 120
% %           b(i) = y(6);
% %       elseif SUMDELTZ(i) <= 140
% %           b(i) = y(7);
% %       elseif SUMDELTZ(i) <= 160
% %           b(i) = y(8);
% %       elseif SUMDELTZ(i) <= 180
% %           b(i) = y(9);
% %       elseif SUMDELTZ(i) <= 200
% %           b(i) = y(10);
% % 
% %           % 200cm后改为40cm间隔（共41段到2000cm）
% %       elseif SUMDELTZ(i) <= 240
% %           b(i) = y(11);
% %       elseif SUMDELTZ(i) <= 280
% %           b(i) = y(12);
% %       elseif SUMDELTZ(i) <= 320
% %           b(i) = y(13);
% %       elseif SUMDELTZ(i) <= 360
% %           b(i) = y(14);
% %       elseif SUMDELTZ(i) <= 400
% %           b(i) = y(15);
% %       elseif SUMDELTZ(i) <= 440
% %           b(i) = y(16);
% %       elseif SUMDELTZ(i) <= 480
% %           b(i) = y(17);
% %       elseif SUMDELTZ(i) <= 520
% %           b(i) = y(18);
% %       elseif SUMDELTZ(i) <= 560
% %           b(i) = y(19);
% %       elseif SUMDELTZ(i) <= 600
% %           b(i) = y(20);
% %       elseif SUMDELTZ(i) <= 640
% %           b(i) = y(21);
% %       elseif SUMDELTZ(i) <= 680
% %           b(i) = y(22);
% %       elseif SUMDELTZ(i) <= 720
% %           b(i) = y(23);
% %       elseif SUMDELTZ(i) <= 760
% %           b(i) = y(24);
% %       elseif SUMDELTZ(i) <= 800
% %           b(i) = y(25);
% %       elseif SUMDELTZ(i) <= 840
% %           b(i) = y(26);
% %       elseif SUMDELTZ(i) <= 880
% %           b(i) = y(27);
% %       elseif SUMDELTZ(i) <= 920
% %           b(i) = y(28);
% %       elseif SUMDELTZ(i) <= 960
% %           b(i) = y(29);
% %       elseif SUMDELTZ(i) <= 1000
% %           b(i) = y(30);
% %       elseif SUMDELTZ(i) <= 1040
% %           b(i) = y(31);
% %       elseif SUMDELTZ(i) <= 1080
% %           b(i) = y(32);
% %       elseif SUMDELTZ(i) <= 1120
% %           b(i) = y(33);
% %       elseif SUMDELTZ(i) <= 1160
% %           b(i) = y(34);
% %       elseif SUMDELTZ(i) <= 1200
% %           b(i) = y(35);
% %       elseif SUMDELTZ(i) <= 1240
% %           b(i) = y(36);
% %       elseif SUMDELTZ(i) <= 1280
% %           b(i) = y(37);
% %       elseif SUMDELTZ(i) <= 1320
% %           b(i) = y(38);
% %       elseif SUMDELTZ(i) <= 1360
% %           b(i) = y(39);
% %       elseif SUMDELTZ(i) <= 1400
% %           b(i) = y(40);
% %       elseif SUMDELTZ(i) <= 1440
% %           b(i) = y(41);
% %       elseif SUMDELTZ(i) <= 1480
% %           b(i) = y(42);
% %       elseif SUMDELTZ(i) <= 1520
% %           b(i) = y(43);
% %       elseif SUMDELTZ(i) <= 1560
% %           b(i) = y(44);
% %       elseif SUMDELTZ(i) <= 1600
% %           b(i) = y(45);
% %       elseif SUMDELTZ(i) <= 1640
% %           b(i) = y(46);
% %       elseif SUMDELTZ(i) <= 1680
% %           b(i) = y(47);
% %       elseif SUMDELTZ(i) <= 1720
% %           b(i) = y(48);
% %       elseif SUMDELTZ(i) <= 1760
% %           b(i) = y(49);
% %       elseif SUMDELTZ(i) <= 1800
% %           b(i) = y(50);
% %       elseif SUMDELTZ(i) <= 1840
% %           b(i) = y(51);
% %       elseif SUMDELTZ(i) <= 1880
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1920
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 1960
% %           b(i) = 0;
% %       elseif SUMDELTZ(i) <= 2000
% %           b(i) = 0;
% % 
% %           % 处理超过2000cm的情况
% %       else
% %           b(i) = 0;
% %       end
% %   end
% 
% %17-20
% y=[0.000529114
% 0.000701383
% 0.000689078
% 0.000246099
% 0.000270709
% 0.000701383
% 0.000652163
% 0.000602943
% 0.000467589
% 0.000738298
% 0.000479894
% 0.000393759
% 0.000713688
% 0.000504504
% 0.000356844
% 0.000529114
% 0.000566028
% 0.000467589
% 0.000442979
% 0.000408525
% 0.00019934
% 0.000344539
% 0.000529114
% 0.000529114
% 0.001021312
% 0.001316631
% 0.001279716
% 0.000799823
% 0.000935177
% 0.000381454
% 0.000674312
% 0.000885958
% 0.000664468
% 0.000418369
% 0.000689078
% 0.000307624
% 0.000553723
% 0.000713688
% 0.000455284
% 0.000393759
% 0.000196879
% 0.000110745
% 0.000393759
% 0.000590638
% 0.000196879
% 0.000159965
% 0.000319929
% 0.000135355
% 0.00017227
% 0.000430674
% 0.000295319
% 0.000430674
% 0.000602943
% 0.00014766
% 6.15248E-05
% 
% ];
%  b = zeros(size(SUMDELTZ)); 
%   for i = 1:length(SUMDELTZ)
%       % 0-200cm保持20cm间隔（原逻辑）
%       if SUMDELTZ(i) <= 0
%           b(i) = y(1);
%       elseif SUMDELTZ(i) <= 20
%           b(i) = y(1);
%       elseif SUMDELTZ(i) <= 40
%           b(i) = y(2);
%       elseif SUMDELTZ(i) <= 60
%           b(i) = y(3);
%       elseif SUMDELTZ(i) <= 80
%           b(i) = y(4);
%       elseif SUMDELTZ(i) <= 100
%           b(i) = y(5);
%       elseif SUMDELTZ(i) <= 120
%           b(i) = y(6);
%       elseif SUMDELTZ(i) <= 140
%           b(i) = y(7);
%       elseif SUMDELTZ(i) <= 160
%           b(i) = y(8);
%       elseif SUMDELTZ(i) <= 180
%           b(i) = y(9);
%       elseif SUMDELTZ(i) <= 200
%           b(i) = y(10);
% 
%           % 200cm后改为40cm间隔（共41段到2000cm）
%       elseif SUMDELTZ(i) <= 240
%           b(i) = y(11);
%       elseif SUMDELTZ(i) <= 280
%           b(i) = y(12);
%       elseif SUMDELTZ(i) <= 320
%           b(i) = y(13);
%       elseif SUMDELTZ(i) <= 360
%           b(i) = y(14);
%       elseif SUMDELTZ(i) <= 400
%           b(i) = y(15);
%       elseif SUMDELTZ(i) <= 440
%           b(i) = y(16);
%       elseif SUMDELTZ(i) <= 480
%           b(i) = y(17);
%       elseif SUMDELTZ(i) <= 520
%           b(i) = y(18);
%       elseif SUMDELTZ(i) <= 560
%           b(i) = y(19);
%       elseif SUMDELTZ(i) <= 600
%           b(i) = y(20);
%       elseif SUMDELTZ(i) <= 640
%           b(i) = y(21);
%       elseif SUMDELTZ(i) <= 680
%           b(i) = y(22);
%       elseif SUMDELTZ(i) <= 720
%           b(i) = y(23);
%       elseif SUMDELTZ(i) <= 760
%           b(i) = y(24);
%       elseif SUMDELTZ(i) <= 800
%           b(i) = y(25);
%       elseif SUMDELTZ(i) <= 840
%           b(i) = y(26);
%       elseif SUMDELTZ(i) <= 880
%           b(i) = y(27);
%       elseif SUMDELTZ(i) <= 920
%           b(i) = y(28);
%       elseif SUMDELTZ(i) <= 960
%           b(i) = y(29);
%       elseif SUMDELTZ(i) <= 1000
%           b(i) = y(30);
%       elseif SUMDELTZ(i) <= 1040
%           b(i) = y(31);
%       elseif SUMDELTZ(i) <= 1080
%           b(i) = y(32);
%       elseif SUMDELTZ(i) <= 1120
%           b(i) = y(33);
%       elseif SUMDELTZ(i) <= 1160
%           b(i) = y(34);
%       elseif SUMDELTZ(i) <= 1200
%           b(i) = y(35);
%       elseif SUMDELTZ(i) <= 1240
%           b(i) = y(36);
%       elseif SUMDELTZ(i) <= 1280
%           b(i) = y(37);
%       elseif SUMDELTZ(i) <= 1320
%           b(i) = y(38);
%       elseif SUMDELTZ(i) <= 1360
%           b(i) = y(39);
%       elseif SUMDELTZ(i) <= 1400
%           b(i) = y(40);
%       elseif SUMDELTZ(i) <= 1440
%           b(i) = y(41);
%       elseif SUMDELTZ(i) <= 1480
%           b(i) = y(42);
%       elseif SUMDELTZ(i) <= 1520
%           b(i) = y(43);
%       elseif SUMDELTZ(i) <= 1560
%           b(i) = y(44);
%       elseif SUMDELTZ(i) <= 1600
%           b(i) = y(45);
%       elseif SUMDELTZ(i) <= 1640
%           b(i) = y(46);
%       elseif SUMDELTZ(i) <= 1680
%           b(i) = y(47);
%       elseif SUMDELTZ(i) <= 1720
%           b(i) = y(48);
%       elseif SUMDELTZ(i) <= 1760
%           b(i) = y(49);
%       elseif SUMDELTZ(i) <= 1800
%           b(i) = y(50);
%       elseif SUMDELTZ(i) <= 1840
%           b(i) = y(51);
%       elseif SUMDELTZ(i) <= 1880
%           b(i) = y(52);
%       elseif SUMDELTZ(i) <= 1920
%           b(i) = y(53);
%       elseif SUMDELTZ(i) <= 1960
%           b(i) = y(54);
%       elseif SUMDELTZ(i) <= 2000
%           b(i) = y(55);
% 
%           % 处理超过2000cm的情况
%       else
%           b(i) = 0;
%       end
%   end
% 
% % bxx=flip(y)';
% % bxx=[bxx;0];
% % RL=Tot_Depth; %土体长
% % Elmn_Lnth=0;
% % LR = 1000;
% % for ML=1:NL
% %     Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
% % 
% %     if Elmn_Lnth<=RL-LR
% %         bx(ML)=0;
% %         MML = ML;
% %     else
% %         MML = ML-1;
% %         bx(ML)=bxx(ML-MML);
% %     end
% % end
% % for ML=1:NL
% %     for ND=1:2
% %         MN=ML+ND-1;
% %         bx(ML,ND)=bx(MN);
% %     end
% % end
% bxx=flip(b);
% bxx=[bxx;0];
% for ML=1:NL
%     for ND=1:2
%         MN=ML+ND-1;
%         bx(ML,ND)=bxx(MN);
%     end
% end



y=[0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0014
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0013
0.0012
0.0012
0.0012
0.0012
0.0012
0.0012
0.0012
0.0012
0.0011
0.0011
0.0011
0.0011
0.0011
0.0011
0.0011
0.0011
0.0011
0.0010
0.0010
0.0010
0.0010
0.0010
0.0010
9.6800e-04
9.5600e-04
9.4400e-04
9.3200e-04
9.2000e-04
9.0800e-04
8.9600e-04
8.8400e-04
8.7200e-04
8.6000e-04
8.4800e-04
8.3600e-04
8.2400e-04
8.1200e-04
8.0000e-04
7.8800e-04
7.7600e-04
7.6400e-04
7.5200e-04
7.4000e-04
7.2800e-04
7.1600e-04
7.0400e-04
6.9200e-04
6.8000e-04
6.6800e-04
6.5600e-04
6.4400e-04
6.3200e-04
6.2000e-04
6.0800e-04
5.9600e-04
5.8400e-04
5.7200e-04
5.6000e-04
5.4800e-04
5.3600e-04
5.2400e-04
5.1200e-04
5.0000e-04
4.8800e-04
4.7600e-04
4.6400e-04
4.5200e-04
4.4000e-04
4.2800e-04
4.1600e-04
4.0400e-04
3.9200e-04
3.8000e-04
3.6800e-04
3.5600e-04
3.4400e-04
3.3200e-04
3.2000e-04
3.0800e-04
2.9600e-04
2.8400e-04
2.7200e-04
2.6000e-04
2.4800e-04
2.3600e-04
2.2400e-04
2.1200e-04
2.0000e-04];
% % bxx=flip(y)';
% % bxx=[bxx;0];
% % RL=Tot_Depth; %土体长
% % Elmn_Lnth=0;
% % LR = 1000;
% % for ML=1:NL
% %     Elmn_Lnth=Elmn_Lnth+DeltZ(ML);
% % 
% %     if Elmn_Lnth<=RL-LR
% %         bx(ML)=0;
% %         MML = ML;
% %     else
% %         MML = ML-1;
% %         bx(ML)=bxx(ML-MML);
% %     end
% % end
% % for ML=1:NL
% %     for ND=1:2
% %         MN=ML+ND-1;
% %         bx(ML,ND)=bx(MN);
% %     end
% % end
bxx=flip(y);
bxx=[bxx;0];
for ML=1:NL
    for ND=1:2
        MN=ML+ND-1;
        bx(ML,ND)=bxx(MN);
    end
end