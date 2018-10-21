function [t,square_wave] = generateSquareWave(period_mean,num_samp,samp_rate,phase_shift)
    freq=1/period_mean;
    offset=3.375/2;
    amp=3.375/2;
    duty=50;
    t_max = num_samp*(1/samp_rate); 
    t=linspace(0,t_max,num_samp);%100 seconds
    square_wave=offset+amp*square(2*pi*freq.*t-duty+phase_shift*pi);
%     plot(t,sq_wav)
%     hold on;
%     plot(t,scope_y_data)
end