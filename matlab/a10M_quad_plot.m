filename = 'c_____1.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[scope_x_data,scope_y_data2] = importAgilentBin(filename,2);
[w,init_cross,final_cross,mid_level] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');
[w2,init_cross2,final_cross2,mid_level2] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');

f_samp = 4E9;
num_samp = length(scope_y_data);
t_max = num_samp*(1/f_samp); 
t=linspace(0,t_max,num_samp);

figure
hold on; 
plot(t*1e6-7.95-0.09,scope_y_data+4,'b');
plot(t*1e6-7.95-0.09,scope_y_data2,'r');

c = scope_y_data2;

filename = 'PA_10M_div4_1.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[scope_x_data,scope_y_data2] = importAgilentBin(filename,2);
[w,init_cross,final_cross,mid_level] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');
[w2,init_cross2,final_cross2,mid_level2] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');

t=linspace(0,t_max/2,num_samp);

move_dist = 190;
plot((t(move_dist:end)-move_dist*1/4E9)*1e6-7.95,c(move_dist:end)+8,'g'); %

num_samp = length(scope_y_data);
t_max = num_samp*(1/f_samp); 
t=linspace(0,t_max/2,num_samp);

move_dist = 178;
plot((t(move_dist:end)-move_dist*1/4E9)*1e6-7.95,scope_y_data2(move_dist:end)+12,'k');

ylabel('Amplitude')
xlabel('Time (s)')
xlim([80 81])
xlabel("Time (\mu sec)")
set(gca,'ytick',[])
legend(["10M div 8", "ref div 8", "10M div 4", "ref div 4"])