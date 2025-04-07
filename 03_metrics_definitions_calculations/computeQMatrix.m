function Q = computeQMatrix(IFT, k, b, m, follwers_num)
    % Computes the Q matrix based on the control gains for each follower.
    Q = tf(zeros(follwers_num, follwers_num));
    for j = 1:follwers_num
        for i = 1:follwers_num
            if j == i
                Q(j,i) = 1;
            elseif j > i && j ~= 1
                K_jminusj_kminus = ((sum(IC.Value(j-1,:,IFT)) - sum(IC.Value(j-1,i:follwers_num,IFT))) / tau.Value(j-1) - ...
                                     (sum(IC.Value(j,:,IFT)) - sum(IC.Value(j,i:follwers_num,IFT))) / tau.Value(j)) * [k, b, m] - ...
                                     [0, 0, (tau.Value(j-1) - tau.Value(j))/(tau.Value(j)*tau.Value(j-1))];
                Q(j,i) = -K_jminusj_kminus * T_1 * G_iip(j);
            elseif j > i && j == 1
                K_jminusj_kminus = -(sum(IC.Value(j,:,IFT)) - sum(IC.Value(j,i:follwers_num,IFT))) / tau.Value(j) * [k, b, m];
                Q(j,i) = -K_jminusj_kminus * T_1 * G_iip(j);
            elseif j < i && j ~= 1
                K_jminusj_kplus = (sum(IC.Value(j,i:follwers_num,IFT)) / tau.Value(j) - ...
                                    sum(IC.Value(j-1,i:follwers_num,IFT)) / tau.Value(j-1)) * [k, b, m];
                Q(j,i) = -K_jminusj_kplus * T_1 * G_iip(j);
            elseif j < i && j == 1
                K_jminusj_kplus = sum(IC.Value(j,i:follwers_num,IFT)) / tau.Value(j) * [k, b, m];
                Q(j,i) = -K_jminusj_kplus * T_1 * G_iip(j);
            end
        end
    end
end

