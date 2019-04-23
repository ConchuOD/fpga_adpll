clearvars
num_files = 15;
std_period = zeros(4,num_files);
TIE_mean = zeros(4,num_files);
TIE_max = zeros(4,num_files);
N           = 4; 
step        = 2e6;
width_vect  = 4e6;
div_ratio = 4;
config = "div" + num2str(div_ratio);
config = "nodiv";

for inc = 1:num_files
    %filename = char("conor_test/settings1_" + num2str(inc) + ".bin");
    %filename = char("scope_41.bin");
        
    path3       = "~/gdrive/measurements/tuesday_last/adpll_des3_2x2_" + num2str(inc) + ".bin";
%     path3       = "~/gdrive/measurements/tuesday/net3x3_clocked_pd_5m18_" + num2str(inc) + ".bin";
%     path3       = "~/gdrive/measurements/wednesday/net3x3_5m00_kp_100_ki_1_" + num2str(inc) + ".bin";
%     path3       = "~/gdrive/measurements/monday/design2b_div" + num2str(div_ratio) + "_" + num2str(inc) + ".bin";    
%     path3       = "~/gdrive/measurements/monday/design2b_" + num2str(inc) + ".bin";

    disp(path3)
    fileID      = fopen(path3);
    A           = fread(fileID, 'double');
    fclose(fileID);
    ss = [];
    for chan=0:N-1 %start at 0 for chan1
        deb = chan*width_vect+1;
        ss = [ss A(deb:deb+step-1, 1) A(deb+step:deb+2*step-1, 1)];
    end

    scope_x_data = ss(:,1);
    scope_y_data1 = ss(:,2);
    scope_y_data2 = ss(:,4);
    scope_y_data3 = ss(:,6);
    scope_y_data4 = ss(:,8);
%     [~,scope_y_data1] = importAgilentBin(filename,1);
%     [~,scope_y_data2] = importAgilentBin(filename,2);
%     [~,scope_y_data3] = importAgilentBin(filename,3);
%     [scope_x_data,scope_y_data4] = importAgilentBin(filename,4);
    f_samp = 4E9;
    num_samp = length(scope_y_data1);
    t_max = num_samp*(1/f_samp); 
    t=linspace(0,t_max,num_samp);

    [~,init_cross1,~,~] = pulsewidth(scope_y_data1,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross2,~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
    [~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

    len = length(init_cross1);
    periods = ones(4,length(init_cross2)-1)*NaN;
    periods(1,1:len-1) = getPeriods(init_cross1); 
    periods(2,:) = getPeriods(init_cross2);
    periods(3,:) = getPeriods(init_cross3);
    periods(4,:) = getPeriods(init_cross4);

    mean_period(1) = nanmean(periods(1,:));
    mean_period(2) = mean(periods(2,:));
    mean_period(3) = mean(periods(3,:));
    mean_period(4) = mean(periods(4,:));

    std_period(2,inc) = std(periods(2,:));
    std_period(3,inc) = std(periods(3,:));
    std_period(4,inc) = std(periods(4,:));
    

    
    if config == "nodiv"
        if length(init_cross2) == length(init_cross1)
            TIE = init_cross2(1:len)-init_cross1;
            TIE_mean(2,inc) = mean((TIE));
            TIE_max(2,inc) = max(abs(TIE));
        elseif length(init_cross2) > length(init_cross1)
            TIE = init_cross2(2:end)-init_cross1;
            TIE_mean(2,inc) = mean((TIE));
            TIE_max(2,inc) = max(abs(TIE));
        end
        TIE2 = TIE;
        
        if length(init_cross3) == length(init_cross1)
            TIE = init_cross3(1:len)-init_cross1;
            TIE_max(3,inc) = max(abs(TIE));
            TIE_mean(3,inc) = mean((TIE));
        elseif length(init_cross3) > length(init_cross1)
            TIE = init_cross3(2:end)-init_cross1;
            TIE_max(3,inc) = max(abs(TIE));
            TIE_mean(3,inc) = mean((TIE));
        end
        TIE3 = TIE;
        
        if length(init_cross4) == length(init_cross1)
            TIE = init_cross4(1:len)-init_cross1;
            TIE_max(4,inc) = max(abs(TIE));
            TIE_mean(4,inc) = mean((TIE));
        elseif length(init_cross4) > length(init_cross1)
            TIE = init_cross4(2:end)-init_cross1;
            TIE_max(4,inc) = max(abs(TIE));
            TIE_mean(4,inc) = mean((TIE));
        end
        TIE4 = TIE;

    elseif config == "div2" || config == "div4"
        if length(init_cross2) - div_ratio*length(init_cross1) > div_ratio 
            error("error: too many periods in gen")
        elseif length(init_cross2) - div_ratio*length(init_cross1) < 0 
            error("error: too many periods in ref")           
        elseif length(init_cross2) - div_ratio*length(init_cross1) == 0
            TIE = init_cross2(div_ratio:div_ratio:end)-init_cross1;
            TIE_mean(2,inc) = mean((TIE)); 
            TIE_max(2,inc) = max(abs(TIE));
        elseif length(init_cross2) - div_ratio*length(init_cross1) < div_ratio
            TIE = init_cross2(div_ratio:div_ratio:len)-init_cross1;
            TIE_mean(2,inc) = mean((TIE)); 
            TIE_max(2,inc) = max(abs(TIE));  
        elseif length(init_cross2) - div_ratio*length(init_cross1) == div_ratio
            TIE = init_cross2(1+div_ratio:div_ratio:end)-init_cross1;
            TIE_mean(2,inc) = mean((TIE));
            TIE_max(2,inc) = max(abs(TIE));
        end
        TIE2 = TIE;
        
        if length(init_cross3) - div_ratio*length(init_cross1) > div_ratio 
            error("error: too many periods in gen")
        elseif length(init_cross3) - div_ratio*length(init_cross1) < 0 
            error("error: too many periods in ref")           
        elseif length(init_cross3) - div_ratio*length(init_cross1) == 0
            TIE = init_cross3(1:div_ratio:end)-init_cross1;
            TIE_mean(3,inc) = mean((TIE)); 
            TIE_max(3,inc) = max(abs(TIE));
        elseif length(init_cross3) - div_ratio*length(init_cross1) < div_ratio
            TIE = init_cross3(1:div_ratio:len)-init_cross1;
            TIE_mean(3,inc) = mean((TIE));  
            TIE_max(3,inc) = max(abs(TIE));
        elseif length(init_cross3) - div_ratio*length(init_cross1) == div_ratio
            TIE = init_cross3(1+div_ratio:div_ratio:end)-init_cross1;
            TIE_mean(3,inc) = mean((TIE)); 
            TIE_max(3,inc) = max(abs(TIE));  
        end
        TIE3 = TIE;
        
        if length(init_cross4) - div_ratio*length(init_cross1) > div_ratio 
            error("error: too many periods in gen")
        elseif length(init_cross4) - div_ratio*length(init_cross1) < 0 
            error("error: too many periods in ref")           
        elseif length(init_cross4) - div_ratio*length(init_cross1) == 0
            TIE = init_cross4(1:div_ratio:end)-init_cross1;
            TIE_mean(4,inc) = mean((TIE)); 
            TIE_max(4,inc) = max(abs(TIE));
        elseif length(init_cross4) - div_ratio*length(init_cross1) < div_ratio
            TIE = init_cross4(1:div_ratio:len)-init_cross1;
            TIE_mean(4,inc) = mean((TIE));    
            TIE_max(4,inc) = max(abs(TIE));            
        elseif length(init_cross4) - div_ratio*length(init_cross1) == div_ratio
            TIE = init_cross4(1+div_ratio:div_ratio:end)-init_cross1;
            TIE_mean(4,inc) = mean((TIE)); 
            TIE_max(4,inc) = max(abs(TIE));        
        end
        TIE4 = TIE;
    end


%     string = num2str(std_period_2) + ", " + num2str(std_period_3) + ", " + num2str(std_period_4) + ", " + ...
%              num2str(TIE_2) + ", " +  num2str(TIE_3) + ", " + num2str(TIE_4) + ", "
end

if config ~= "nodiv"
    TIE_fixed0 = mod(TIE_mean,mean_period(2));
    TIE_fixed1 = TIE_fixed0-(TIE_fixed0 > mean_period(2)/2 )*mean_period(2);
    TIE_mean = TIE_fixed1;
    
    TIE_max_fixed0 = mod(TIE_max,mean_period(2));
    TIE_max_fixed1 = TIE_max_fixed0-(TIE_max_fixed0 > mean_period(2)/2 )*mean_period(2);
    TIE_max = TIE_max_fixed1;
end

result = zeros(3,9);
for inc = 1:3
    result(inc,4) = mean(TIE_max(2,inc:5*inc));

    result(inc,5) = mean(TIE_max(3,inc:5*inc));
    
    result(inc,6) = mean(TIE_max(4,inc:5*inc));
    
    result(inc,1) = mean(std_period(2,inc:5*inc));

    result(inc,2) = mean(std_period(3,inc:5*inc));
    
    result(inc,3) = mean(std_period(4,inc:5*inc));
    
    result(inc,7) = mean(TIE_mean(2,inc:5*inc));

    result(inc,8) = mean(TIE_mean(3,inc:5*inc));
    
    result(inc,9) = mean(TIE_mean(4,inc:5*inc));
end

str = "";
for inc1 = 1:3
    for inc2 = 1:9
        str = str + "&" + num2str(result(inc1,inc2));
    end    
    str = str + newline;
end
str
% + ...
% num2str(mean2_3) + "+-" +  num2str(std_diff2_3) + ", " + ...
% num2str(mean3_4) + "+-" +  num2str(std_diff3_4) + ", " + ...
% num2str(mean4_2) + "+-" +  num2str(std_diff4_2)

% figure(1)
% hold on; 
% plot(t*1e6-7.95-0.09,scope_y_data+15,'b');
% plot(t*1e6-7.95-0.09,scope_y_data2+10,'r');
% plot(t*1e6-7.95-0.09,scope_y_data3+5,'g');
% plot(t*1e6-7.95-0.09,scope_y_data4+0,'k');
% 
% figure
% hold on;
% histfit((periods2)*1e9+6)
% histfit((periods3)*1e9+6)
% histfit((periods4)*1e9+6)
% title('')
% xlabel('Period (ns)','fontsize',16);
% ylabel('Occurance Rate','fontsize',16);
% yticklabels([])
% ax = gca;
% ax.FontSize = 16;
% alpha(.33)
% legend("ADPLL 11","ADPLL 12","ADPLL 22")
