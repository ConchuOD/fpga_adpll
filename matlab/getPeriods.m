function [periods] = getPeriods(init_cross)

    periods = zeros(1,length(init_cross)-1);
    for i = 2:length(init_cross)
        periods(i-1) = init_cross(i) - init_cross(i-1);
    end
end

