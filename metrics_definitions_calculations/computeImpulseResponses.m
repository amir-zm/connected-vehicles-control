function [DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp] = computeImpulseResponses(Xtilda_t, tout, follwers_num)
    % Computes impulse responses for each follower and returns the temporary arrays.
    for kappa = 1:follwers_num
        DRAC_TTC_InpuT_temp(:,:,kappa) = impulse(Xtilda_t(3*kappa-2:3*kappa,1), tout);
        JRK_temp(:,:,kappa) = impulse(s * Xtilda_t(3*kappa-2:3*kappa,1) / (1 + tau_ini(kappa)*s), tout);
        ACC_temp(:,:,kappa) = impulse(Xtilda_t(3*kappa-2:3*kappa,1) / (1 + tau_ini(kappa)*s), tout);
    end
end

