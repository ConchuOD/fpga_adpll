clear all;
clc;
fclose all;
format long

disp('**********  OPENING FILES   ***********');

file_type = 'binary';       % choice : 'binary', 'csv', 'dat' : Default Value = 'binary'
       % is there a majority gate measurement in the file? 'on' or 'off' : Default Value = 'off'
serie_or_append = 'append';  % as the other file, 'serie' or 'append'
pll_order = [11];           % Default Value = [11]
% pll_order = [11 12 13 23]; % which pll is opened

for kp=1:1
    kp
    for stuff=1:length(pll_order);
        clear R_EK_2
        clear R_EK_coef
        clear R_PB_2
        clear R_PB_coef 
        clear ss
        clear PP
        clear T_sig
        stuff
        if strcmp(file_type,'dat')
            switch  N
                case 3
                    path = './ADPLL_network/measurement/ADPLL_3x1_network/kp=05_ki=1..13_64/';
                    s1 = importdata(strcat(path, 'sig_div1.dat' ));
                    s2 = importdata(strcat(path, 'sig_div2.dat'));
                    s3 = importdata(strcat(path, 'sig_div3.dat'));
                    s4 = importdata(strcat(path, 'sig_mg.dat'));
                    s5 = importdata(strcat(path, 'sig_ref.dat'));
                    ss = [s1 s2 s3 s4 s5];
                case 5
                    path = './measure/PLL_x5/serie33/';
                    s1 = importdata(strcat(path, 'sig_div1.dat' ));
                    s2 = importdata(strcat(path, 'sig_div2.dat'));
                    s3 = importdata(strcat(path, 'sig_div3.dat'));
                    s4 = importdata(strcat(path, 'sig_div4.dat'));
                    s5 = importdata(strcat(path, 'sig_div5.dat'));
                    s6 = importdata(strcat(path, 'sig_mg.dat'));
                    s7 = importdata(strcat(path, 'sig_ref.dat'));
                    ss = [s1 s2 s3 s4 s5 s6 s7];
                case 7
                    path = './measure/vacances7PLL/';
                    s1 = importdata(strcat(path, 'sig_div1.dat' ));
                    s2 = importdata(strcat(path, 'sig_div2.dat'));
                    s3 = importdata(strcat(path, 'sig_div3.dat'));
                    s4 = importdata(strcat(path, 'sig_div4.dat'));
                    s5 = importdata(strcat(path, 'sig_div5.dat'));
                    s6 = importdata(strcat(path, 'sig_div6.dat'));
                    s7 = importdata(strcat(path, 'sig_div7.dat'));
                    s8 = importdata(strcat(path, 'sig_mg.dat'));
                    s9 = importdata(strcat(path, 'sig_ref.dat'));
                    ss = [s1 s2 s3 s4 s5 s6 s7 s8 s9];
            end
        elseif strcmp (file_type, 'binary')    
            topology = 'conor'; %'pfd_9_adll'
            switch topology
                
                case 'pfd_9_adll'
                    MG_measure = 'off';  
                    ki       = 6;
                    N        = 9 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_PLL1-2-3-4-5-6-7-8-9_kp', num2str(kp),'_16-ki', num2str(ki),'_256.bin');
                    end
                case 'MG3_1st'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG3_v1_kp3_16-ki6_256.bin');
                    end
                case 'MG3_2nd'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG3_v2_kp3_16-ki6_256.bin');
                    end
                case 'MG3_3rd'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG3_v3_kp3_16-ki6_256.bin');
                    end
                case 'MG5_1st'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 6 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG5_v1_kp3_16-ki6_256.bin');
                    end
                case 'MG5_2nd'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 6 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG5_v2_kp3_16-ki6_256.bin');
                    end 
                case 'MG5_3rd'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 6 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG5_v3_kp3_16-ki6_256.bin');
                    end
                case 'MG7_1st'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 8 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG7_v1_kp3_16-ki6_256.bin');
                    end
                case 'MG7_2nd'
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 8 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/independent_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('independent_MG7_v2_kp3_16-ki6_256.bin');
                    end
                case 'network_adplls'    
                    MG_measure = 'off';  
                    ki       = 6;
                    N        = 9 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_PLL_11-12-13-21-22-23-31-32-33_kp3_16-ki6_256.bin');
                    end
                case 'network_MG3_v1'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG3_v13_16-ki6_256.bin');
                    end 
                case 'network_MG3_v2'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG3_v23_16-ki6_256.bin');
                    end  
                case 'network_MG3_v3'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 4 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG3_v33_16-ki6_256.bin');
                    end 
                case 'network_MG5_v1'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 6 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG5_v13_16-ki6_256.bin');
                    end 
                case 'network_MG5_v2'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 6 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG5_v2_3_16-ki6_256.bin');
                    end 
                case 'network_MG7_v1'    
                    MG_measure = 'on';  
                    ki       = 6;
                    N        = 8 ; % how many waveform in each file
                    path     = strcat('./Logbook_measurements/network_adplls/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')
                        filename = strcat('network_MG7_v1_3_16-ki6_256.bin');
                    end                     
                case 'test_errtdc3..0'
                    MG_measure = 'off';
                    kp      = 2;
                    ki       = 3;
                    N        = 2; % how many waveform in each file
                    path     = strcat('./EK_transient_response/');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')

                        filename = strcat('transient_kp', num2str(kp),'_16-ki', num2str(ki),'_256.bin');
                        %filename = strcat('test_analyzer_kp13_16-ki8_256.bin');
                    end  
                case 'conor'  %% STUFF TO CHANGE HERE (name of the file)
                    MG_measure = 'off';

                    N        = 2; 
                    path     = strcat('./');
                    if strcmp (serie_or_append, 'serie')
                        % 11 12 13 23 22 21 31 32 33
                        PLL      = pll_order(stuff);
                        filename = strcat('PLL',num2str(PLL) , '-kp',num2str(kp) ,'_16_', num2str(ki), '_256.bin');
                        fileeee  = strcat(path, 'PLL1-8_kp',num2str(kp) ,'_16_ki15_256-osc_vs_serie_jitter.csv');
                    elseif strcmp (serie_or_append, 'append')

                        filename = strcat('Settings1_1.bin'); % name of the file here
                    end                      
            end
            path3       = strcat(path, filename);
            fileID      = fopen(path3);
            A           = fread(fileID, 'double');
            fclose(fileID);
            step        = 2e6;
            width_vect  = 4e6;
            ss          = [];
            for chan=0:N-1 %start at 0 for chan1
                deb = chan*width_vect+1;
                ss = [ss A(deb:deb+step-1, 1) A(deb+step:deb+2*step-1, 1)];
            end

        elseif strcmp(file_type, 'csv')
            ss = [];
            for uuu = 1:N
                num_file = num2str(uuu);

                display(strcat('num_file :', num_file, '/', num2str(N)))
                path = './ADPLLs_alone/measure/2019_01_25/kp3_16_ki1..15_128/serie2/';
                       %\ADPLLs_alone\measure\2019_01_25\kp3_16_ki1..15_128\serie2
        %         path = './ADPLL_network/measurement/ADPLL_3x1_network/kp=05_ki=1..13_64/';
                s0 = importdata(strcat(path, 'kp=3_16_ki=', num_file, '_128.csv' ));
        %             s0 = importdata(strcat(path,  'kp=3_16_ki=15_128' ));

                s1 = [((0:(2e6-1))')./2e9 s0(:,2)];
                s2 = [((0:(2e6-1))')./2e9 s0(:,4)];
                %s2 = importdata(strcat(path, 'sig_div2.dat'));
                %s3 = importdata(strcat(path, 'sig_div3.dat'));
                %s4 = importdata(strcat(path, 'sig_mg.dat'));
                %s5 = importdata(strcat(path, 'sig_ref.dat'));
                ss = [ss s1 s2];
            end
        end

        disp('********** DATA PROCESSING ***********');


        %% NOTHING (CALCULATION MG IDEAL AND REG LIN
        Ni = N-1;
        for jkl = 0:Ni
             [w,init_cross,final_cross,mid_level] = pulsewidth(ss(:,2+2*jkl),ss(:,1+2*jkl), 'Polarity', 'Positive');
             switch jkl
                 case 0
                    PP = init_cross;
                 otherwise
                     if length(PP)>length(init_cross)
                        PP = [PP(1:length(init_cross),:) init_cross];
                     elseif length(PP)<length(init_cross)
                        PP = [PP init_cross(1:length(PP),:)];  
                     else
                        PP = [PP init_cross]; 
                     end
             end
        end
figure(6789);clf;hold on;
plot(PP(1:end-1,1), diff(PP(:,1)), '-x');
plot(PP(1:end-1,2), diff(PP(:,2)), '-ro');

        % calcul MG ideal
        Nmg_calc = N-1;
        if strcmp(MG_measure, 'on') % calcul MG ideal if there is MG measurement
            indicccc = floor(Nmg_calc/2)+1;
            for i=1:length(PP(:,1))
                nb_input        = length(PP(i,1:Nmg_calc));  % on prend le nombre de signaux à comparer
                line_to_check   = sort(PP(i,1:Nmg_calc)); % on les tri par ordre croissant
                b(i)            = min(find(PP(i,1:Nmg_calc)==line_to_check(indicccc))); % on prend le signal du milieu
                %[a b(i)]=min(Redge(i,2:4));b(i)=b(i)+1;
                Redge_MG_ideal(i, 1)= PP(i, b(i)); %min(Redge(i,[2:(b(i)-1) (b(i)+1):4]));
               % fprintf("%1.10e %1.10e %1.10e %1.10e %d\n", Redge(i,2), Redge(i,3), Redge(i,4), Redge_MG_ideal(i), b(i));
            end
            PP = [PP Redge_MG_ideal];
        end

        % calcul des coefs reg lin et de l'erreur sur tous les signaux
        if strcmp(MG_measure, 'on') % there is a MG measurement
            Nii = N+1; %N+1 with reference and MG signal
        else
            Nii = N; % N-1 just with div signals, (from 0 to N-1)
        end
        for jkl2 = 1:Nii % N + 2 signaux : DIV + MG + REF + MGideal (from 1 to N+3)
            x                   = 1:length(PP(:,jkl2));
            y                   = PP(:,jkl2);
            mdl                 = fitlm(x,y,'linear','RobustOpts','on');
            R_EK_2(:,jkl2)      = mdl.Residuals.Raw;
            R_EK_coef(:,jkl2)   = mdl.Coefficients.Estimate;


            XX                  = [ones(length(x),1) (1:length(x))'];
            b                   = XX\PP(:,jkl2);   
            for i=1:length(PP(:,1))
                R_PB_2(i, jkl2)=PP(i,jkl2)-(i*b(2)+b(1));
            end
            R_PB_coef(:,jkl2) = b;  
        end
        %% PERIOD CALCULTATION
        for klm = 1:Nii
        %     T_sig(:,klm) = PP(1:end-1,klm)-PP(2:end,klm);
              T_sig(:,klm) = diff(PP(:,klm),1);
        end
        transpose(std(T_sig)).*1e9;

        figure(6788);clf;
        plot(T_sig(:,1));
        %% DISPERSION CALCULTATION
        for klm = 1:Nii
            DS(klm) = sqrt(mean((T_sig(:,klm)-mean(T_sig(:,klm))).^2));
        end
        % calcul de la correlation des signaux
        % clear auto_corr_T
        % clear R_sig
        % for ii = 1:N-1
        %     for jj = ii+1:N
        for ii = 1:N
            for jj = 1:N
                corr_T(jj, ii) = mean((T_sig(:,ii)-mean(T_sig(:,ii))).*(T_sig(:,jj)-mean(T_sig(:,jj))));
                R_sig(jj, ii)  = corr_T(jj, ii)/(DS(:,jj)*DS(:,ii));
            end
        end
        R_sig;
        display('***** STD de l'' erreur (ns) (DCO1, 2, 3, 4, 5, 6, 7, MG, REF)*****');
        comp_erreur = [std(R_EK_2)' std(R_PB_2)'].*1e9;
        comp_erreur

        % corrcoef(R_EK_2(:,1:3))

        disp('**********  PLOT DATA  ***********');
        %% plot

        figure(1);clf;hold on;grid on;
        subplot(2,2,3);hold on;
        for kkk = 1:Nii
            histogram(R_EK_2(:,kkk), 30,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs');
        end
        title('PDFs for DCO periods')

        subplot(2,2,1);hold on;

        subplot(2,2,2);
        for jkl3 = 1:Nii % N + 2 signaux
            hold on;
            histogram(R_EK_2(:,jkl3), 30,'normalization', 'cdf','facealpha',.9,'DisplayStyle','stairs');
            hold on;
        end
        title('PDFs for DCO periods')
        switch Nii
            case 3
                legend('DCO1','DCO2','DCO3','MG')  
            case 5
                legend('DCO1','DCO2','DCO3','DCO4','DCO5','MG')
            case 7
                legend('DCO1','DCO2','DCO3','DCO4','DCO5','DCO6','DCO7','MG')
        end
        hold on
        %% pour data proc matlab // Period DCO
        figure(666);clf;hold on;

        for jkl4 = 1:Nii % N + 2 signaux
        %     subplot(N,1,jkl4);
            hold on;
            histogram(T_sig(:,jkl4).*1e9, 30,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 2);
            set(gca, 'fontsize', 14);hold on;
            axis([160 270 0 2]);
        end
        title('PDFs for DCO periods');
        if strcmp(MG_measure, 'on') % calcul MG ideal if there is MG measurement
        figure(669);clf;
            histogram(abs(T_sig(:,4)).*1e9, 30,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 2);
            set(gca, 'fontsize', 14);hold on;title('PDFs for MG period');
            legend('MG');axis([160 270 0 2]);
            xlabel('Period (ns)');
        end
        %% pour data proc matlab // Error DCO
        figure(667);clf;hold on;
        for jkl5 = 1:Nii % N + 2 signaux
        %     subplot(N,1,jkl5);hold on;
        hold on
            histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
            set(gca, 'fontsize', 14);hold on;
            axis([-10 10 0 0.5]);
        end
        legend('dco2', 'dco2','dco3','MG','dco5','dco6','dco7','dco8','dco9');

        title('PDFs for DCO error');
        if strcmp(MG_measure, 'on') % calcul MG ideal if there is MG measurement
        figure(668);clf;
            histogram(R_EK_2(:,4).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 2);
            set(gca, 'fontsize', 14);hold on;title('PDFs for MG error');
            legend('MG');axis([-10 10 0 0.5]);
            xlabel('Jitter (ns)');
        end
        %% FFT sig
        Fs = 1e9;
        fft_pts = 200e3;
        x_input = ss(:,2);

        figure(5678);clf;hold on
        [Xfft, Yfft] = fft_Bisiaux(Fs,fft_pts,x_input);
        plot(Xfft, Yfft)
        set(gca, 'Xscale', 'log');
        %% 
        acb = (1:length(PP(:,1)))*R_PB_coef(2,1)+R_PB_coef(1,1);
        XXX = transpose(PP(:,1))-acb;

        figure(2);clf;hold on;
        subplot(2,1,1); hold on; plot(PP(:,1), 'x-');
        plot(acb, '-xr')
        subplot(2,1,2); plot(XXX, '-xr');
        %% FOR SERIE FILE AND CREATE .csv file for EUGENE
        
        if strcmp (serie_or_append, 'serie')    
            if PLL==11
                comp_erreur_tmp = [transpose(comp_erreur(:,1))];
            else
                blabla_tmp = importdata(fileeee);
                comp_erreur_tmp = [blabla_tmp; transpose(comp_erreur(:,1))];
            end
             csvwrite(fileeee,comp_erreur_tmp)
                 %%
        figure(6666);clf;
        blabla_tmp = importdata(fileeee);
        plot(mean(transpose(blabla_tmp)))
        end
    end

  %% for EK_ data processing
    if strcmp('test_errtdc3..0', topology)
        time = ss(:,1);
        bit0 = (ss(:,2)>1.5);
        bit1 = (ss(:,4)>1.5);
        bit2 = (ss(:,6)>1.5);
        bit3 = (ss(:,8)>1.5);

        dec_err = [];
        pointspoints = 1:1:1.8e6;
        for POINTS = 1:length(pointspoints)
            indice_loc = pointspoints(POINTS);
            if  bit3(POINTS) == 0
                dec_err(POINTS) = bit0(indice_loc) + 2*bit1(indice_loc) + 4*bit2(indice_loc);
            elseif bit3(POINTS) == 1
                dec_err(POINTS) = -(not(bit0(indice_loc)) + 2*not(bit1(indice_loc)) + 4*not(bit2(indice_loc)) + 1);
            end
        end


        figure(999);clf;
        subplot(2,1,1);hold on;grid on;
            plot(bit3+5, '-');
            plot(bit2+3, '-r');
            plot(bit1+1, '-k');
            plot(bit0-1, '-g');    
            legend('sign', 'b2', 'b1', 'b0');
            axis([1 150000 -8 8]);
        subplot(2,1,2);hold on;grid on;
            plotSigNum(dec_err);
            axis([1 150000 -8 8]);
            
            file2write_EK = strcat(path, 'errTDC_DECIMAL_kp', num2str(kp),'_16-ki', num2str(ki),'_256.csv');
            csvwrite(file2write_EK, dec_err(100:20:end)); 
    end  
    
end

%% For Elena JRNET
%   figure(667);clf;hold on;
% for jkl5 = 1:3 % N + 2 signaux
%     %     subplot(N,1,jkl5);hold on;hold on
%     subplot(2,1,1);grid on;
%         histogram(R_EK_2(:,jkl5).*1e9, 20,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 2);
%         set(gca, 'fontsize', 14);hold on;
%         axis([-10 10 0 0.5]);
%         xlabel('Jitter (ns)');ylabel('Occurence');
% end
% legend('DIV21', 'DIV22','DIV23');
% 
% for jkl5 = 4:5 % N + 2 signaux
%     %     subplot(N,1,jkl5);hold on;hold on
%     subplot(2,1,2);grid on;
%         histogram(R_EK_2(:,jkl5).*1e9, 20,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 2);
%         set(gca, 'fontsize', 14);hold on;
%         axis([-10 10 0 0.5]);
%         xlabel('Jitter (ns)');ylabel('Occurence');
% end
% legend('MG_ measured', 'MG_ calculated');
%% For EK
%  path     = strcat('./NEWCAS19/independent_adpll/kp1..15_16-ki15_256/');
%  fileeee  = strcat(path, 'PLL1-8_kp1_16_ki15_256-osc_vs_serie_jitter');
%  fileeee2  = strcat(path, 'PLL1-8_kp2_16_ki15_256-osc_vs_serie_jitter');
%  fileeee3  = strcat(path, 'PLL1-8_kp3_16_ki15_256-osc_vs_serie_jitter');
%  
% a=     (mean(transpose(importdata(fileeee))));
% a2=     (mean(transpose(importdata(fileeee2))));
% a3=     (mean(transpose(importdata(fileeee3))));
% a4=     (mean(transpose(importdata(strcat(path, 'PLL1-8_kp4_16_ki15_256-osc_vs_serie_jitter')))));
% a5=     (mean(transpose(importdata(strcat(path, 'PLL1-8_kp5_16_ki15_256-osc_vs_serie_jitter')))));
% a6=     (mean(transpose(importdata(strcat(path, 'PLL1-8_kp6_16_ki15_256-osc_vs_serie_jitter')))));
% a7=     (mean(transpose(importdata(strcat(path, 'PLL1-8_kp7_16_ki15_256-osc_vs_serie_jitter')))));
% a8=     (mean(transpose(importdata(strcat(path, 'PLL1-8_kp8_16_ki15_256-osc_vs_serie_jitter')))));
% 
% aaa = [a a2 a3 a4 a5 a6 a7 a8];
% figure(11111);clf;
% hold on;
% plot(aaa, '-x');
% set(gca, 'Yscale', 'log');


% 
% fileID      = fopen('path/file.bin');
% A           = fread(fileID, 'double');
% fclose(fileID);
% step        = 2e6; %length of chan data
% width_vect  = 4e6; % end of data
% ss          = [];
% for chan=0:N-1 % N = number of channels saved
%     deb = chan*width_vect+1;
%     ss = [ss A(deb:deb+step-1, 1) A(deb+step:deb+2*step-1, 1)]; % putting everything in a single matrix X1 Y1 X2 Y2
% end

%% for logbook

  switch topology                
        case 'pfd_9_adll'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(3,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;

                axis([-10 10 0 0.5]);
                ylabel('Occurence');
                legend('dco11', 'dco12','dco13');         
                subplot(3,1,2);hold on;grid on;
                title(strcat('std21=', num2str(std_serie1(4)),' ns, std22=', num2str(std_serie1(5)),' ns, std23=', num2str(std_serie1(6)), 'ns'));
                histogram(R_EK_2(:,jkl5+3).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.5]); 
                ylabel('Occurence');legend('dco21', 'dco22','dco23');

                subplot(3,1,3);hold on;grid on;
                title(strcat('std31=', num2str(std_serie1(7)),' ns, std32=', num2str(std_serie1(8)),' ns, std33=', num2str(std_serie1(9)), 'ns'));
                hold on        
                histogram(R_EK_2(:,jkl5+6).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.5]);
                xlabel('Jitter after reg. lin. (ns)');
                ylabel('Occurence');
                legend('dco31', 'dco32','dco33');
            end
        case 'MG3_1st'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.5]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13');   
            end
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.5]); 
                ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end
        case 'MG3_2nd'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std21=', num2str(std_serie1(1)),' ns, std22=', num2str(std_serie1(2)),' ns, std23=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.5]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13');   
            end
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.5]); 
                ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end
        case 'MG3_3rd'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std31=', num2str(std_serie1(1)),' ns, std32=', num2str(std_serie1(2)),' ns, std33=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.5]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13');   
            end
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.5]); 
                ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end
        case 'MG5_1st'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:5 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns,\newline std21='...
                    , num2str(std_serie1(4)), 'ns, std22=', num2str(std_serie1(5)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.6]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13', 'dco21','dco22');   
            end
            for jkl5 = 6:7 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(6)),' ns, std MG theory=', num2str(std_serie1(7)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.6]);ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end
        case 'MG5_2nd'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:5 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std21=', num2str(std_serie1(1)),' ns, std31=', num2str(std_serie1(2)),' ns, std32=', num2str(std_serie1(3)),...
                    'ns,\newlinestd33=', num2str(std_serie1(4)), 'ns, std23=', num2str(std_serie1(5)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.6]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13', 'dco21','dco22');   
            end
            for jkl5 = 6:6 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(6)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.6]);ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end
        case 'MG5_3rd'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:5 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std12=', num2str(std_serie1(1)),' ns, std22=', num2str(std_serie1(2)),' ns, std32=', num2str(std_serie1(3)),...
                    'ns,\newlinestd21=', num2str(std_serie1(4)), 'ns, std23=', num2str(std_serie1(5)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.6]);
                ylabel('Occurence'); legend('dco11', 'dco12','dco13', 'dco21','dco22');   
            end
            for jkl5 = 6:6 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(6)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.6]);ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end   
        case 'MG7_1st'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:7 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)),...
                    'ns,\newlinestd21=', num2str(std_serie1(4)), 'ns, std22=', num2str(std_serie1(5)), 'ns, std23=',...
                    num2str(std_serie1(6)), 'ns, std31=', num2str(std_serie1(7)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.6]);
                ylabel('Occurence');
            end
            legend('dco11', 'dco12','dco13', 'dco21','dco22', 'dco23','dco31');  

            for jkl5 = 8:8 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(8)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 20,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.6]);ylabel('Occurence');legend('MG measured');
            end  
            
        case 'MG7_2nd'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:7 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std13=', num2str(std_serie1(2)),' ns, std21=', num2str(std_serie1(3)),...
                    'ns,\newline std22=', num2str(std_serie1(4)), 'ns, std23=', num2str(std_serie1(5)), 'ns, std31=',...
                    num2str(std_serie1(6)), 'ns, std33=', num2str(std_serie1(7)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.6]);
                ylabel('Occurence');
            end
            legend('dco11', 'dco13','dco21', 'dco22','dco23', 'dco31','dco33');   
            
            for jkl5 = 8:8 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(8)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 20,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.6]);ylabel('Occurence');legend('MG measured');
            end
        case 'network_adplls'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:9 % N + 2 signaux
                subplot(1,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)),...
                    'ns \newline std21=', num2str(std_serie1(4)), 'ns, std22=', num2str(std_serie1(5)), 'ns, std23=',...
                    num2str(std_serie1(6)), 'ns \newline std31=', num2str(std_serie1(7)), 'ns, std32=', num2str(std_serie1(8)), 'ns, std33=', num2str(std_serie1(9)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-20 20 0 0.35]);
                ylabel('Occurence');
            end
            legend('dco11', 'dco12','dco13', 'dco21','dco22', 'dco23','dco31', 'dco32','dco33');  
        case 'network_MG3_v1'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.35]);
                ylabel('Occurence');  
            end
             legend('dco11', 'dco12','dco13'); 
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.35]); 
                ylabel('Occurence');
            end
            legend('MG measured', 'MG theoretical');
        case 'network_MG3_v2'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std21=', num2str(std_serie1(1)),' ns, std22=', num2str(std_serie1(2)),' ns, std23=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.25]);
                ylabel('Occurence');  
            end
             legend('dco21', 'dco22','dco23'); 
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.25]); 
                ylabel('Occurence');
            end
            legend('MG measured', 'MG theoretical');
        case 'network_MG3_v3'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:3 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std31=', num2str(std_serie1(1)),' ns, std32=', num2str(std_serie1(2)),' ns, std33=', num2str(std_serie1(3)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-15 15 0 0.15]);
                ylabel('Occurence');  
            end
             legend('dco31', 'dco32','dco33'); 
            for jkl5 = 4:5 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(4)),' ns, std MG theory=', num2str(std_serie1(5)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.15]);ylabel('Occurence');
            end
            legend('MG measured', 'MG theoretical');
            
        case 'network_MG5_v1'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:5 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns\newline',...
                    'std12=', num2str(std_serie1(4)),' ns, std13=', num2str(std_serie1(5)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-15 15 0 0.3]);
                ylabel('Occurence');  
            end
             legend('dco31', 'dco32','dco33', 'dco32','dco33'); 
            for jkl5 = 6:7 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(6)),' ns, std MG theory=', num2str(std_serie1(7)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.3]);ylabel('Occurence');
            end
            legend('MG measured', 'MG theoretical');  
        case 'network_MG5_v2'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:5 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std12=', num2str(std_serie1(2)),' ns, std13=', num2str(std_serie1(3)), 'ns\newline',...
                    'std12=', num2str(std_serie1(4)),' ns, std13=', num2str(std_serie1(5)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-15 15 0 0.3]);
                ylabel('Occurence');  
            end
             legend('dco31', 'dco32','dco33', 'dco32','dco33'); 
            for jkl5 = 6:7 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(6)),' ns, std MG theory=', num2str(std_serie1(7)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.3]);ylabel('Occurence');
            end
            legend('MG measured', 'MG theoretical');
        case 'network_MG7_v1'
            std_serie1 = floor(std(R_EK_2).*1e11)/1e2;
            figure(667);clf;hold on;
            for jkl5 = 1:7 % N + 2 signaux
                subplot(2,1,1);hold on;grid on;hold on;
                title(strcat('std11=', num2str(std_serie1(1)),' ns, std13=', num2str(std_serie1(2)),' ns, std21=', num2str(std_serie1(3)),...
                    'ns,\newline std22=', num2str(std_serie1(4)), 'ns, std23=', num2str(std_serie1(5)), 'ns, std31=',...
                    num2str(std_serie1(6)), 'ns, std33=', num2str(std_serie1(7)), 'ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 25,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);axis([-10 10 0 0.25]);
                ylabel('Occurence');
            end
            legend('dco11', 'dco12','dco13', 'dco21','dco22', 'dco23','dco31');   
            
            for jkl5 = 8:9 % N + 2 signaux
                subplot(2,1,2);hold on;grid on;
                title(strcat('std MG measure=', num2str(std_serie1(8)),' ns, std MG theory=', num2str(std_serie1(9)),' ns'));
                histogram(R_EK_2(:,jkl5).*1e9, 20,'normalization', 'pdf','facealpha',.9,'DisplayStyle','stairs', 'linewidth', 3);
                set(gca, 'fontsize', 14);hold on;
                axis([-10 10 0 0.25]);ylabel('Occurence');legend('MG measured', 'MG theoretical');
            end           
  end

