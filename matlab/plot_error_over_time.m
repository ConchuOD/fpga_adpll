%plot_error_over_time

filename = 'scope_31.bin';
[~,scope_y_data] = importAgilentBin(filename,1);
[scope_x_data,scope_y_data2] = importAgilentBin(filename,2);
[w,init_cross,final_cross,mid_level] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');
[w2,init_cross2,final_cross2,mid_level2] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');

fsamp = 4E9;
num_samp = size(scope_y_data,2);

periods = getPeriods(init_cross);
periods2 = getPeriods(init_cross2);

time_interval_error = periods - periods2(size(periods2,2)-size(periods,2)+1:end);

times = (1:1:size(time_interval_error,2))*mean(periods2)*1E6;

figure
plot(times,time_interval_error*1E9,'b')
hold on;
linex = [24.6 24.6];
liney = [-100 300];
plot(linex, liney,'r');
ylim([-50 200])
xlim([0 40])
ylabel('Time Interval Error (ns)')
xlabel('Time (\mus)')
text(30, 150, "Locked", 'Color', 'r');

figure
plot(times,1./periods*1E-6,'b')
hold on;
linex = [25.2 25.2];
liney = [-100 300];
plot(linex, liney,'r');
ylim([2 7])
xlim([0 40])
%xlabel("Time (\mu sec)")
%ylabel("Frequency (MHz)")
title("Frequency (MHz) over Time (\mus)")
text(30, 6.5, "Locked", 'Color', 'r');