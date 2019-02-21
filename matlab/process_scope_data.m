%% get data
clear variables

periods = [];
for inc1 = 1:10
    filename = char("PA_10M_div4.bin");
    [scope_x_data(inc1,:),scope_y_data(inc1,:)] = importAgilentBin(filename,1);
    
    [w,init_cross,final_cross,mid_level] = pulsewidth(scope_y_data(inc1,:),scope_x_data(inc1,:), 'Polarity', 'Positive');
    periods = [periods;getPeriods(init_cross)];
end

periods = reshape(periods, [1 size(periods,1)*size(periods,2)]);

%% fft
f_samp = 4E9;
num_samp = length(scope_y_data);
freqs = f_samp*(1:1:num_samp/2)/(num_samp)/1E6;

y_fft = fft(scope_y_data);
y_fft_scaled = abs(y_fft);
y_fft_plottable = real(y_fft_scaled(1:floor(num_samp/2)));

num_datasets = 1;
for loop_inc = 1:num_datasets
%% compute periods
%     [w,init_cross,final_cross,mid_level] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');
% 
%     [periods] = getPeriods(init_cross);
    
    period_mean(loop_inc) = mean(periods)*1E9; %in nanoseconds
    period_jitter_std(loop_inc) = std(periods)*1E9; %in nanoseconds
    period_max_vs_min(loop_inc) = (max(periods)-min(periods))*1E9;
   % period_jitter_rms(loop_inc) = 
    
    % @~1000 samples 3.090 for 1 outside
    % https://www.sitime.com/api/gated/AN10007-Jitter-and-measurement.pdf
    period_jitter_p2p = 2*3.719*period_jitter_std; %in nanoseconds
    
%     if(length(periods) >= 10000)
%         long_term_jitter(loop_inc) = periods(10000)-periods(1);
%     end   
       
    phase_shift = 0;
    [t,square_wave] = generateSquareWave(period_mean/1E9,num_samp,f_samp,phase_shift);
    
%     [~,init_cross_ideal,~,~] = pulsewidth(square_wave,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross_ideal,~,~] = pulsewidth(square_wave,scope_x_data(1,:), 'Polarity', 'Positive');

    
    [periods_ideal] = getPeriods(init_cross_ideal);
    
    %time_interval_error = (periods - periods_ideal);%*1E9; %in nanoseconds
end

tmp = abs(periods-period_mean*1E-9);
max(tmp)


if (false)
    time_interval_error = periods - periods2(size(periods2,2)-size(periods,2)+1:end);
end
if (num_datasets == 1)
    figure
    plot(t,scope_y_data)
    title('Time Domain Data')
    ylabel('Amplitude')
    xlabel('Time (s)')
    
    figure
    plot(freqs,y_fft_plottable)
    title('FFT')
    ylabel('')
    xlabel('Frequency (MHz)')
    
    %figure
    %plot(time_interval_error)
    %title('Time Interval Error')
    %label('Error (ns)')
    %xlabel('Samples')
    
    figure
    histfit(periods)
    title()
    xlabel()
    ylabel()
    
    figure
    plot(t*1e6-7.95,scope_y_data,'b')
    hold on;    
    plot(t*1e6-7.95,scope_y_data2+4,'r')
    ylabel('Amplitude')
    xlabel('Time (s)')
    xlim([0 9])
    xlabel("Time (\mu sec)")
    set(gca,'ytick',[])
end