filename = 'tcope_2.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[~,scope_y_data2] = importAgilentBin(filename,2);
[~,scope_y_data3] = importAgilentBin(filename,3);
[scope_x_data,scope_y_data4] = importAgilentBin(filename,4);

f_samp = 4E9;
num_samp = length(scope_y_data);
t_max = num_samp*(1/f_samp); 
t=linspace(0,t_max,num_samp);

figure
hold on; 
plot(t*1e6-7.95-0.09,scope_y_data+15,'b');
plot(t*1e6-7.95-0.09,scope_y_data2+10,'r');
plot(t*1e6-7.95-0.09,scope_y_data3+5,'g');
plot(t*1e6-7.95-0.09,scope_y_data4+0,'k');