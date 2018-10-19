y_fft = fft(scope_y_data);
f_samp = 4E9;
num_samp = length(scope_y_data);
y_fft_scaled = abs(y_fft)/num_samp;
freqs = f_samp*(1:1:num_samp/2)/(num_samp);
y_fft_plottable = real(y_fft_scaled(1:floor(num_samp/2)));

plot(freqs,y_fft_plottable)
