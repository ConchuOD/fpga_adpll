filename = 'test_measurement_number2.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[~,scope_y_data2] = importAgilentBin(filename,2);
[~,scope_y_data3] = importAgilentBin(filename,3);
[scope_x_data,scope_y_data4] = importAgilentBin(filename,4);

f_samp = 4E9;
num_samp = length(scope_y_data);
t_max = num_samp*(1/f_samp); 
t=linspace(0,t_max,num_samp);

figure(1)
hold on; 
plot(t*1e6-7.95-0.09,scope_y_data+15,'b');
plot(t*1e6-7.95-0.09,scope_y_data2+10,'r');
plot(t*1e6-7.95-0.09,scope_y_data3+5,'g');
plot(t*1e6-7.95-0.09,scope_y_data4+0,'k');

[~,init_cross2,~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
[~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
[~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

diff2_3 = init_cross2-init_cross3;
diff3_4 = init_cross3-init_cross4;
diff4_2 = init_cross4-init_cross2;

std2_3 = std(diff2_3);
std3_4 = std(diff3_4);
std4_2 = std(diff4_2);

mean2_3 = mean(abs(diff2_3));
mean3_4 = mean(abs(diff3_4));
mean4_2 = mean(abs(diff4_2));