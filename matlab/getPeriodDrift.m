function [period_drift] = plotPeriodDrift(periods)

    period_drift = zeros(1,length(periods));
    period_drift(1) = 0;
    for i = 2:length(periods)
        period_drift(i) = periods(i) - periods(1);
    end

end

