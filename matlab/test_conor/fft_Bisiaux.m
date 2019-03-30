function [Xfft, Yfft] = fft_Bisiaux(Fs,fft_pts,x_input)
%FFT_BISIAUX Summary of this function goes here
%   Detailed explanation goes here
% Nfft        = pow2(14); %length(v_modul);%   
% Xfft_moi    = Fs*(0:Nfft/2-1)/Nfft;
% Yfft        = fft(v_modul, Nfft);
% Yfft        = Yfft(1:Nfft/2);
% Yfft        = abs(Yfft)/length(Yfft);
Nfft        = fft_pts; %length(v_modul);%   
Xfft        = Fs*(0:Nfft/2-1)/Nfft;
Yfft        = fft(x_input, Nfft);
Yfft        = Yfft(1:Nfft/2);
Yfft        = abs(Yfft)/length(Yfft);
end

