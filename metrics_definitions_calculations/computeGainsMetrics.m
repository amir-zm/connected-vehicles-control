function [Ui, G_iip, Psi_iip, Upsilon_iip, H_iip_a, kb_iip, bb_iip, hb_iip] = computeGainsMetrics(IFT, k, b, m, follwers_num)
    % Computes transfer function based gains and related arrays.
    Ui = tf(zeros(follwers_num, 1));
    G_iip = tf(zeros(follwers_num, 1));
    Psi_iip = tf(zeros(follwers_num, 1));
    Upsilon_iip = tf(zeros(follwers_num, 1));
    H_iip_a = tf(zeros(follwers_num, 1));
    kb_iip = zeros(1, follwers_num);
    bb_iip = zeros(1, follwers_num);
    hb_iip = zeros(1, follwers_num);
    for i = 1:follwers_num
        if i == 1
            kb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i)) * k;
            bb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i)) * b;
            hb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i)) * m + (1/tau.Value(i));
        else
            kb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i) + ...
                         sum(IC.Value(i-1,i:follwers_num,IFT)) / tau.Value(i-1)) * k;
            bb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i) + ...
                         sum(IC.Value(i-1,i:follwers_num,IFT)) / tau.Value(i-1)) * b;
            hb_iip(i) = ((sum(IC.Value(i,:,IFT)) - sum(IC.Value(i,i:follwers_num,IFT))) / tau.Value(i) + ...
                         sum(IC.Value(i-1,i:follwers_num,IFT)) / tau.Value(i-1)) * m + (1/tau.Value(i));
        end
        G_iip(i) = s^2 / (s^3 + hb_iip(i)*s^2 + bb_iip(i)*s + kb_iip(i));
        Upsilon_iip(i) = 1 / (s^3 + hb_iip(i)*s^2 + bb_iip(i)*s + kb_iip(i));
    end
end

