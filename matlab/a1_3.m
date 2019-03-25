for inc = 1:15
    filename = char("new/z1a_" + num2str(inc) + ".bin");
    [~,scope_y_data1] = importAgilentBin(filename,1);
    [~,scope_y_data2] = importAgilentBin(filename,2);
    [~,scope_y_data3] = importAgilentBin(filename,3);
    [scope_x_data,scope_y_data4] = importAgilentBin(filename,4);

    f_samp = 4E9;
    num_samp = length(scope_y_data1);
    t_max = num_samp*(1/f_samp); 
    t=linspace(0,t_max,num_samp);

    [~,init_cross1,~,~] = pulsewidth(scope_y_data1,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross2,~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

    periods1 = getPeriods(init_cross1); 
    periods2 = getPeriods(init_cross2);
    periods3 = getPeriods(init_cross3);
    periods4 = getPeriods(init_cross4);

    mean_period_1 = mean(periods1);
    mean_period_2 = mean(periods2);
    mean_period_3 = mean(periods3);
    mean_period_4 = mean(periods4);

    std_period_2(inc) = std(periods2);
    std_period_3(inc) = std(periods3);
    std_period_4(inc) = std(periods4);

%     max_2 = max(periods2-mean(periods2));
%     min_2 = min(periods2-mean(periods2));
%     p2p_2 = max_2-min_2;
%     max_3 = max(periods3-mean(periods3));
%     min_3 = min(periods3-mean(periods3));
%     p2p_3 = max_3-min_3;
%     max_4 = max(periods4-mean(periods4));
%     min_4 = min(periods4-mean(periods4));
%     p2p_4 = max_4-min_4;

    TIE_2(inc) = max(abs(periods2-mean_period_1));
    TIE_3(inc) = max(abs(periods3-mean_period_1));
    TIE_4(inc) = max(abs(periods4-mean_period_1));


%     string = num2str(std_period_2) + ", " + num2str(std_period_3) + ", " + num2str(std_period_4) + ", " + ...
%              num2str(TIE_2) + ", " +  num2str(TIE_3) + ", " + num2str(TIE_4) + ", "
end

mean_tie_2_s1 = mean(TIE_2(1:5))
mean_tie_2_s2 = mean(TIE_2(6:10))
mean_tie_2_s3 = mean(TIE_2(11:15))

mean_tie_3_s1 = mean(TIE_3(1:5))
mean_tie_3_s2 = mean(TIE_3(6:10))
mean_tie_3_s3 = mean(TIE_3(11:15))

mean_tie_4_s1 = mean(TIE_4(1:5))
mean_tie_4_s2 = mean(TIE_4(6:10))
mean_tie_4_s3 = mean(TIE_4(11:15))
%%
mean_jitter_2_s1 = mean(std_period_2(1:5))
mean_jitter_2_s2 = mean(std_period_2(6:10))
mean_jitter_2_s3 = mean(std_period_2(11:15))

mean_jitter_3_s1 = mean(std_period_3(1:5))
mean_jitter_3_s2 = mean(std_period_3(6:10))
mean_jitter_3_s3 = mean(std_period_3(11:15))

mean_jitter_4_s1 = mean(std_period_4(1:5))
mean_jitter_4_s2 = mean(std_period_4(6:10))
mean_jitter_4_s3 = mean(std_period_4(11:15))

% + ...
% num2str(mean2_3) + "+-" +  num2str(std_diff2_3) + ", " + ...
% num2str(mean3_4) + "+-" +  num2str(std_diff3_4) + ", " + ...
% num2str(mean4_2) + "+-" +  num2str(std_diff4_2)

% figure(1)
% hold on; 
% plot(t*1e6-7.95-0.09,scope_y_data+15,'b');
% plot(t*1e6-7.95-0.09,scope_y_data2+10,'r');
% plot(t*1e6-7.95-0.09,scope_y_data3+5,'g');
% plot(t*1e6-7.95-0.09,scope_y_data4+0,'k');
% 
% figure
% hold on;
% histfit((periods2)*1e9)
% histfit((periods3)*1e9)
% histfit((periods4)*1e9)
% title('')
% xlabel('Period (ns)')
% ylabel('Occurance Rate')
% yticklabels([])
% alpha(.33)
% legend("ADPLL 11","ADPLL 12","ADPLL 22")