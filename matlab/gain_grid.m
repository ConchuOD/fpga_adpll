for inc = 1:4 %kp loop
    for inner_inc = 1:15 %ki_loop

        kp = inc;
        ki = inner_inc;

        path3       = "~/gdrive/measurements/wednesday/indep_pll_3x3_5m00_kp_" + num2str(kp) + "_ki_" + num2str(ki) + ".bin";
        disp(path3);
        fileID      = fopen(path3);
        A           = fread(fileID, 'double');
        fclose(fileID);
        N           = 4; 
        step        = 2e6;
        width_vect  = 4e6;
        ss          = [];
        for chan=0:N-1 %start at 0 for chan1
            deb = chan*width_vect+1;
            ss = [ss A(deb:deb+step-1, 1) A(deb+step:deb+2*step-1, 1)];
        end
        clear A

        scope_x_data = ss(:,1);
        scope_y_data1 = ss(:,2);
        scope_y_data2 = ss(:,4);
        scope_y_data3 = ss(:,6);
        scope_y_data4 = ss(:,8);

%         [~,init_cross(1,:),~,~] = pulsewidth(scope_y_data1,scope_x_data, 'Polarity', 'Positive');
%         [~,init_cross(2,:),~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
%         [~,init_cross(3,:),~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
%         [~,init_cross(4,:),~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');
% 
%         periods(1,:) = getPeriods(init_cross(1,:)); 
%         periods(2,:) = getPeriods(init_cross(2,:));
%         periods(3,:) = getPeriods(init_cross(3,:));
%         periods(4,:) = getPeriods(init_cross(4,:));
% 
%         std_period(2,inc,inner_inc) = std(periods(2,:));
%         std_period(3,inc,inner_inc) = std(periods(3,:));
%         std_period(4,inc,inner_inc) = std(periods(4,:));
        
        [~,init_cross1,~,~] = pulsewidth(scope_y_data1,scope_x_data, 'Polarity', 'Positive');
        [~,init_cross2,~,~] = pulsewidth(scope_y_data2,scope_x_data, 'Polarity', 'Positive');
        [~,init_cross3,~,~] = pulsewidth(scope_y_data3,scope_x_data, 'Polarity', 'Positive');
        [~,init_cross4,~,~] = pulsewidth(scope_y_data4,scope_x_data, 'Polarity', 'Positive');

        periods1 = getPeriods(init_cross1); 
        periods2 = getPeriods(init_cross2);
        periods3 = getPeriods(init_cross3);
        periods4 = getPeriods(init_cross4);

        std_period(2,inc,inner_inc) = std(periods2);
        std_period(3,inc,inner_inc) = std(periods3);
        std_period(4,inc,inner_inc) = std(periods4);
        
        
        mean_jitter = squeeze(mean(std_period,1));
        
%         if size(init_cross(2,:),2) == size(init_cross(1,:),2)
%             TIE(2,inc,inner_inc) = max(abs(init_cross(2,1:size(init_cross(1,:),2))-init_cross(1,1:size(init_cross(1,:),2))));
%         elseif length(init_cross2) > length(init_cross1)
%             TIE(2,inc,inner_inc) = max(abs(init_cross(2,2:end)-init_cross(1,1:len)));
%         end
%         if size(init_cross(3,:)) == size(init_cross(1,:),2)
%             TIE(3,inc,inner_inc) = max(abs(init_cross(3,1:size(init_cross(1,:),2))-init_cross(1,1:size(init_cross(1,:),2))));
%         elseif length(init_cross(3,:)) > size(init_cross(1,:),2)
%             TIE(3,inc,inner_inc) = max(abs(init_cross(3,2:end)-init_cross(1,1:len)));
%             end
%         if length(init_cross(4,:)) == size(init_cross(1,:),2)
%             TIE(4,inc,inner_inc) = max(abs(init_cross(4,1:size(init_cross(1,:),2))-init_cross(1,1:size(init_cross(1,:),2))));
%         elseif size(init_cross(4,:),2) > size(init_cross(1,:),2)
%             TIE(4,inc,inner_inc) = max(abs(init_cross(4,2:end)-init_cross(1,1:len)));
%         end
        
    end
end

mean_jitter = squeeze(mean(std_period,1));

fig_handle = figure(1);
axes_handle = subplot(1,1,1);
scatter([1:15],mean_jitter(1,:)*1E9,'b');
hold(axes_handle,'on')
scatter([1:15],mean_jitter(2,:)*1E9,'r');
scatter([1:15],mean_jitter(3,:)*1E9,'g');
scatter([1:15],mean_jitter(4,:)*1E9,'k');
set(gca, 'TickLabelInterpreter', 'latex', 'XTickLabel', {'$\frac{0}{64}$', '$\frac{5}{64}$', '$\frac{10}{64}$', '$\frac{15}{64}$', '$\frac{10}{64}$', '$\frac{12}{64}$', '$\frac{14}{64}$', '$\frac{16}{64}$'})
xlabel(axes_handle,"$k_i$",'Interpreter','latex');
ylabel(axes_handle,"Cycle-To-Cycle Jitter (ns)");%,'Interpreter','latex');
legend(axes_handle,"$k_p = \frac{1}{16}$","$k_p = \frac{2}{16}$","$k_p = \frac{3}{16}$","$k_p = \frac{4}{16}$","Location","Best",'Interpreter','latex');
set(axes_handle,'FontSize', 14)

% fig_handle = figure(2);
% axes_handle = subplot(1,1,1);
% scatter([1:15],squeeze(TIE(2,1,:)),'b');
% hold(axes_handle,'on')
% scatter([1:15],squeeze(TIE(2,2,:)),'r');
% xlabel(axes_handle,"ki");
% ylabel(axes_handle,"tie");
% legend(axes_handle,"kp = 8","kp = 10","Location","Best");
