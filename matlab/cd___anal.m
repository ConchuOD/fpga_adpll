for inc = 1:10
    filename = char("new/uhh" + num2str(inc) + ".bin");
    [scope_x_data,scope_y_data] = importAgilentBin(filename,3);

    f_samp = 4E9;
    num_samp = length(scope_y_data);
    t_max = num_samp*(1/f_samp); 
    t=linspace(0,t_max,num_samp);

    [~,init_cross4,~,~] = pulsewidth(scope_y_data,scope_x_data, 'Polarity', 'Positive');

    periods4 = getPeriods(init_cross4);

    std_period_4 = std(periods4);

    max_4 = max(periods4-mean(periods4));
    min_4 = min(periods4-mean(periods4));
    p2p_4 = max_4-min_4;

    clc
    string = num2str(std_period_4) + ", " + num2str(max_4) + ", " + num2str(min_4) + ", " + num2str(p2p_4)
end



% figure
% hold on;
% histfit(periods4)
% title('')
% xlabel('')
% ylabel('')