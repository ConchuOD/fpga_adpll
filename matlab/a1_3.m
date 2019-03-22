filename = 'scope_41.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[~,scope_y_data2] = importAgilentBin(filename,2);
[~,scope_y_data3] = importAgilentBin(filename,3);
[scope_x_data,scope_y_data4] = importAgilentBin(filename,4);

f_samp = 4E9;
num_samp = length(scope_y_data);
t_max = num_samp*(1/f_samp); 
t=linspace(0,t_max,num_samp);

% figure(1)
% hold on; 
% plot(t*1e6-7.95-0.09,scope_y_data+15,'b');
% plot(t*1e6-7.95-0.09,scope_y_data2+10,'r');
% plot(t*1e6-7.95-0.09,scope_y_data3+5,'g');
% plot(t*1e6-7.95-0.09,scope_y_data4+0,'k');

[~,init_cross2,~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
[~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
[~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

periods2 = getPeriods(init_cross2);
periods3 = getPeriods(init_cross3);
periods4 = getPeriods(init_cross4);

mean_period_2 = mean(periods2);
mean_period_3 = mean(periods3);
mean_period_4 = mean(periods4);

std_period_2 = std(periods2);
std_period_3 = std(periods3);
std_period_4 = std(periods4);

max_2 = max(periods2-mean(periods2));
min_2 = min(periods2-mean(periods2));
p2p_2 = max_2-min_2;
max_3 = max(periods3-mean(periods3));
min_3 = min(periods3-mean(periods3));
p2p_3 = max_3-min_3;
max_4 = max(periods4-mean(periods4));
min_4 = min(periods4-mean(periods4));
p2p_4 = max_4-min_4;

% diff2_3 = init_cross2-init_cross3;
% diff3_4 = init_cross3-init_cross4;
% diff4_2 = init_cross4-init_cross2;
% 
% std_diff2_3 = std(diff2_3);
% std_diff3_4 = std(diff3_4);
% std_diff4_2 = std(diff4_2);
% 
% mean2_3 = mean((diff2_3));
% mean3_4 = mean((diff3_4));
% mean4_2 = mean((diff4_2));

% [~,init_cross_ref,~,~] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');
% TIE_2 = max(abs(init_cross2 - init_cross_ref));
% TIE_3 = max(abs(init_cross3 - init_cross_ref));
% TIE_4 = max(abs(init_cross4 - init_cross_ref));
% 
% 
% string = num2str(std_period_2) + ", " + num2str(std_period_3) + ", " + num2str(std_period_4) + ", " + ...
%          num2str(TIE_2) + ", " +  num2str(TIE_3) + ", " + num2str(TIE_4) + ", "
     
% + ...
% num2str(mean2_3) + "+-" +  num2str(std_diff2_3) + ", " + ...
% num2str(mean3_4) + "+-" +  num2str(std_diff3_4) + ", " + ...
% num2str(mean4_2) + "+-" +  num2str(std_diff4_2)

figure
hold on;
histfit((periods2)*1e9)
histfit((periods3)*1e9)
histfit((periods4)*1e9)
title('')
xlabel('Period (ns)')
ylabel('Occurance Rate')
yticklabels([])
alpha(.33)
legend("ADPLL 11","ADPLL 12","ADPLL 22")