function [Theta_iip, Gamma_iip, Lambda0_iip, Lambda1_iip, Lambda2_iip, Psi_iip] = computeErrorMetrics(IFT, k, b, kb_iip, bb_iip, hb_iip, follwers_num)
    % Computes error-related metrics (Theta, Gamma, Lambda, Psi) for each follower.
    Theta_iip = zeros(1, follwers_num);
    Gamma_iip = zeros(1, follwers_num);
    Lambda0_iip = zeros(1, follwers_num);
    Lambda1_iip = zeros(1, follwers_num);
    Lambda2_iip = zeros(1, follwers_num);
    for i = 1:follwers_num
        Theta_iip(i) = k * varrho_t_iip.Value(i,IFT) + b * nu_t_iip.Value(i,IFT);
        Gamma_iip(i) = k * nu_t_iip.Value(i,IFT);
        Lambda0_iip(i) = Gamma_iip(i) - vel_def1.Value(i) * kb_iip(i);
        Lambda1_iip(i) = Theta_iip(i) - pos_def1.Value(i) * kb_iip(i) - vel_def1.Value(i) * bb_iip(i);
        Lambda2_iip(i) = acc_def1.Value(i);
        H_iip_a(i) = Lambda2_iip(i) * s^2 + Lambda1_iip(i) * s + Lambda0_iip(i);
        Psi_iip(i) = H_iip_a(i) * Upsilon_iip(i);
    end
end

