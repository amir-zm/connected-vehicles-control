function [SetlTime_Metric, SetlTime] = computeSetlTime(ind, Yout_p, tout, SetlTime_Metric, SetlTime, bt, kt, IFT)
    % Computes the settling time metric for a given follower.
    [y_tmp, t_tmp] = impulse(Yout_p(ind));
    set_indx = find(abs(y_tmp - y_tmp(end)) / abs(y_tmp(end)) <= 0.02);
    y_tmp(set_indx) = -100;
    y_tmp(y_tmp ~= -100) = 0;
    D_local = find(diff(y_tmp) < 0); % Difference between successive samples
    setlTime_indx = D_local(end) + 1;
    SetlTime_Metric(ind) = t_tmp(setlTime_indx);
    SetlTime(1,1,bt,kt,IFT,ind) = SetlTime_Metric(ind);
end


