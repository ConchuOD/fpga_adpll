for inc = 1:15
    %filename = char("conor_test/settings1_" + num2str(inc) + ".bin");
    %filename = char("scope_41.bin");
    
    path3       = "test_conor/settings3_" + num2str(inc) + ".bin";
    fileID      = fopen(path3);
    A           = fread(fileID, 'double');
    fclose(fileID);
    N        = 2; 
    step        = 2e6;
    width_vect  = 4e6;
    ss          = [];
    for chan=0:N-1 %start at 0 for chan1
        deb = chan*width_vect+1;
        ss = [ss A(deb:deb+step-1, 1) A(deb+step:deb+2*step-1, 1)];
    end

%     Ni = N-1;
%     for jkl = 0:Ni
%          [w,init_cross,final_cross,mid_level] = pulsewidth(ss(:,2+2*jkl),ss(:,1+2*jkl), 'Polarity', 'Positive');
%          switch jkl
%              case 0
%                 PP = init_cross;
%              otherwise
%                  if length(PP)>length(init_cross)
%                     PP = [PP(1:length(init_cross),:) init_cross];
%                  elseif length(PP)<length(init_cross)
%                     PP = [PP init_cross(1:length(PP),:)];  
%                  else
%                     PP = [PP init_cross]; 
%                  end
%          end
%     end
    scope_x_data = ss(:,1);
    scope_y_data1 = ss(:,2);
    scope_y_data2 = ss(:,4);
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
%     [~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
%     [~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

    len = length(init_cross1);
    periods(1,:) = getPeriods(init_cross1); 
    periods(2,:) = getPeriods(init_cross2);
%     periods(3,:) = getPeriods(init_cross3);
%     periods(4,:) = getPeriods(init_cross4);

    mean_period(1) = mean(periods(1,:));
    mean_period(2) = mean(periods(2,:));
%     mean_period(3) = mean(periods(3,:));
%     mean_period(4) = mean(periods(4,:));

    std_period(2,inc) = std(periods(2,:));
%     std_period(3,inc) = std(periods(3,:));
%     std_period(4,inc) = std(periods(4,:));

<<<<<<< HEAD
%     max_2 = max(periods2-mean(periods2));
%     min_2 = min(periods2-mean(periods2));
%     p2p_2 = max_2-min_2;
%     max_3 = max(periods3-mean(periods3));
%     min_3 = min(periods3-mean(periods3));
%     p2p_3 = max_3-min_3;
%     max_4 = max(periods4-mean(periods4));
%     min_4 = min(periods4-mean(periods4));
%     p2p_4 = max_4-min_4;
% 
    if length(init_cross2) == length(init_cross1)
        TIE(2,inc) = max(abs(init_cross2(1:len)-init_cross1));
    elseif length(init_cross2) > length(init_cross1)
        TIE(2,inc) = max(abs(init_cross2(2:end)-init_cross1));
    end
%     if length(init_cross3) == length(init_cross1)
%         TIE(3,inc) = max(abs(init_cross3(1:len)-init_cross1));
%     elseif length(init_cross3) > length(init_cross1)
%         TIE(3,inc) = max(abs(init_cross3(2:end)-init_cross1));
%         inc
%         end
%     if length(init_cross4) == length(init_cross1)
%         TIE(4,inc) = max(abs(init_cross4(1:len)-init_cross1));
%     elseif length(init_cross4) > length(init_cross1)
%         TIE(4,inc) = max(abs(init_cross4(2:end)-init_cross1));
%         inc
%     end
=======
    max_2 = max(periods2-mean(periods2));
    min_2 = min(periods2-mean(periods2));
    p2p_2 = max_2-min_2;
    max_3 = max(periods3-mean(periods3));
    min_3 = min(periods3-mean(periods3));
    p2p_3 = max_3-min_3;
    max_4 = max(periods4-mean(periods4));
    min_4 = min(periods4-mean(periods4));
    p2p_4 = max_4-min_4;

    if length(init_cross2) == length(init_cross1)
        TIE_2(inc) = max(abs(init_cross2(1:len)-init_cross1));
    elseif length(init_cross2) > length(init_cross1)
        TIE_2(inc) = max(abs(init_cross2(2:end)-init_cross1));
        inc
    end
    if length(init_cross3) == length(init_cross1)
        TIE_3(inc) = max(abs(init_cross3(1:len)-init_cross1));
    elseif length(init_cross3) > length(init_cross1)
        TIE_3(inc) = max(abs(init_cross3(2:end)-init_cross1));
        inc
        end
    if length(init_cross4) == length(init_cross1)
        TIE_4(inc) = max(abs(init_cross4(1:len)-init_cross1));
    elseif length(init_cross4) > length(init_cross1)
        TIE_4(inc) = max(abs(init_cross4(2:end)-init_cross1));
        inc
    end
>>>>>>> 3cdddbfaa0e3c4b6aa61cb1ea82c39f65ed412fa

%     string = num2str(std_period_2) + ", " + num2str(std_period_3) + ", " + num2str(std_period_4) + ", " + ...
%              num2str(TIE_2) + ", " +  num2str(TIE_3) + ", " + num2str(TIE_4) + ", "
end

<<<<<<< HEAD
result = zeros(3,6);
for inc = 1:3
    result(inc,4) = mean(TIE(2,inc:5*inc));

    % result(inc,5) = mean(TIE(3,inc:5*inc))
    % 
    % result(inc,6) = mean(TIE(4,inc:5*inc))
    %%
    result(inc,1) = mean(std_period(2,inc:5*inc));

    % result(inc,2) = mean(std_period(3,inc:5*inc))
    % 
    % result(inc,3) = mean(std_period(4,inc:5*inc))
end
=======
mean_tie_2_s1 = mean(TIE_2(1:5))
mean_tie_2_s2 = mean(TIE_2(6:10))
% mean_tie_2_s3 = mean(TIE_2(11:15))

mean_tie_3_s1 = mean(TIE_3(1:5))
mean_tie_3_s2 = mean(TIE_3(6:10))
% mean_tie_3_s3 = mean(TIE_3(11:15))

mean_tie_4_s1 = mean(TIE_4(1:5))
mean_tie_4_s2 = mean(TIE_4(6:10))
% mean_tie_4_s3 = mean(TIE_4(11:15))
%%
mean_jitter_2_s1 = mean(std_period_2(1:5))
mean_jitter_2_s2 = mean(std_period_2(6:10))
% mean_jitter_2_s3 = mean(std_period_2(11:15))

mean_jitter_3_s1 = mean(std_period_3(1:5))
mean_jitter_3_s2 = mean(std_period_3(6:10))
% mean_jitter_3_s3 = mean(std_period_3(11:15))

mean_jitter_4_s1 = mean(std_period_4(1:5))
mean_jitter_4_s2 = mean(std_period_4(6:10))
% mean_jitter_4_s3 = mean(std_period_4(11:15))
>>>>>>> 3cdddbfaa0e3c4b6aa61cb1ea82c39f65ed412fa

str = "";
for inc1 = 1:3
    for inc2 = 1:6
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
