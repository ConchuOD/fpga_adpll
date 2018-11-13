function plotVivadoSim(filepath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data = csvread(filepath);
plot(data(:,1),data(:,2))
title('Step response to ? frequency difference');
xlabel('Time steps');
ylabel('Error code');
end

