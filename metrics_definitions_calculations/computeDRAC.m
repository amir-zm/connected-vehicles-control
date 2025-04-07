function [MeTric_DRAC, DRAC] = computeDRAC(ind, Yout_v, Yout_a, D_platoon, tout, DRAC, bt, kt, IFT)
    % Computes the DRAC metric for a given follower.
    MeTric_DRAC(:,ind) = (impulse(Yout_v(ind,:), tout).^2) ./ (2 * impulse(D_platoon(ind,:), tout));
    DRAC_idx = find(impulse(Yout_v(ind,:), tout) >= 0);
    acc_temp = impulse(Yout_a(ind,:), tout);
    acc_temp_neg_indx = acc_temp(DRAC_idx) < 0;
    DRAC_idx_temp = nonzeros(DRAC_idx .* double(acc_temp_neg_indx));
    if ~isempty(DRAC_idx)
        MeTric_DRAC(DRAC_idx,ind) = zeros(length(DRAC_idx),1);
        MeTric_DRAC(DRAC_idx_temp,ind) = abs(acc_temp(DRAC_idx_temp));
    end
    DRAC(:,:,bt,kt,IFT,ind) = MeTric_DRAC(:,ind);
end

