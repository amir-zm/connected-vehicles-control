function [MeTric_TTC, TTC] = computeTTC(ind, Yout_v, Yout_a, D_platoon, tout, TTC, bt, kt, IFT)
    % Computes the TTC metric for a given follower.
    Delta = (impulse(Yout_v(ind,:), tout).^2) - 2 .* impulse(D_platoon(ind,:), tout) .* impulse(Yout_a(ind,:), tout);
    MeTric_TTC(:,ind) = (-impulse(Yout_v(ind,:), tout) - sqrt(Delta)) ./ impulse(Yout_a(ind,:), tout);
    TTC_idx_zero1 = find(MeTric_TTC(:,ind) < 0 | imag(MeTric_TTC(:,ind)) ~= 0);
    if ~isempty(TTC_idx_zero1)
        MeTric_TTC(TTC_idx_zero1,ind) = 7460 * ones(length(TTC_idx_zero1),1);
    end
    TTC(:,:,bt,kt,IFT,ind) = 100 * exp(-0.1 * MeTric_TTC(:,ind));
end
	
