function [Yout_p, tictoc1, tictoc2] = computeResponse(renage_k, kt, b, followers_num, IFT, m_v, tau, IC, T_1, Uii, sd, sp, pos_def1, vel_def1, acc_def1, s)
    % Computes the system response and flags (tictoc1, tictoc2) for given gains.
    k = renage_k(kt);
    k_v = k * ones(followers_num,1);
    b_v = b * ones(followers_num,1);
    
    A = zeros(3,3,followers_num);
    B = zeros(3,1,followers_num);
    K = zeros(3,1,followers_num);
    Astar = zeros(3,3,followers_num);
    for ii = 1:followers_num
        A(:,:,ii) = [0 1 0; 0 0 1; 0 0 -1/tau.Value(ii)];
        B(:,:,ii) = [0; 0; 1/tau.Value(ii)];
        K(:,:,ii) = [k_v(ii); b_v(ii); m_v(ii)];
        Astar(:,:,ii) = A(:,:,ii) - IC.Value(ii,1,IFT)*B(:,:,ii)*K(:,:,ii)';
    end
    A_sys = zeros(3,3,followers_num,followers_num);
    Asys = zeros(3*followers_num, 3*followers_num);
    for ii = 1:followers_num
        A_sys(:,:,ii,ii) = Astar(:,:,ii);
        Asys((3*ii-2):3*ii, (3*ii-2):3*ii) = A_sys(:,:,ii,ii);
        for jj = 1:followers_num
            if jj ~= ii
                A_sys(:,:,ii,jj) = IC.Value(ii,jj,IFT)*B(:,:,ii)*K(:,:,ii)';
                Asys((3*ii-2):3*ii, (3*jj-2):3*jj) = A_sys(:,:,ii,jj);
            end
        end
    end
    % Compute Yout_a and then Yout_p using the given transfer functions.
    Yout_a = computeResponse_A(IFT, followers_num, tau, IC, pos_def1, vel_def1, m_v, k, b, T_1, Uii, s);
    Yout_v = (Yout_a + vel_def1.Value') / s;
    Yout_p = (Yout_a + vel_def1.Value') / s^2 + pos_def1.Value' / s;
    
    % Set tictoc flags based on impulse response comparisons.
    if followers_num == 10
        tictoc1 = any(impulse(Yout_p(1)) < -(sp-sd)) || any(impulse(Yout_p(2)) < -(sp-sd)) || ...
                  any(impulse(Yout_p(3)) < -(sp-sd)) || any(impulse(Yout_p(4)) < -(sp-sd)) || ...
                  any(impulse(Yout_p(5)) < -(sp-sd)) || any(impulse(Yout_p(6)) < -(sp-sd)) || ...
                  any(impulse(Yout_p(7)) < -(sp-sd)) || any(impulse(Yout_p(8)) < -(sp-sd)) || ...
                  any(impulse(Yout_p(9)) < -(sp-sd)) || any(impulse(Yout_p(10)) < -(sp-sd));
        tictoc2 = any(impulse(Yout_p(1)) <= -sp) || any(impulse(Yout_p(2)) <= -sp) || ...
                  any(impulse(Yout_p(3)) <= -sp) || any(impulse(Yout_p(4)) <= -sp) || ...
                  any(impulse(Yout_p(5)) <= -sp) || any(impulse(Yout_p(6)) <= -sp) || ...
                  any(impulse(Yout_p(7)) <= -sp) || any(impulse(Yout_p(8)) <= -sp) || ...
                  any(impulse(Yout_p(9)) <= -sp) || any(impulse(Yout_p(10)) <= -sp);
    elseif followers_num == 4
        tictoc1 = any(impulse(Yout_p(1)) < -(sp-sd)) || any(impulse(Yout_p(2)) < -(sp-sd)) || ...
                  any(impulse(Yout_p(3)) < -(sp-sd)) || any(impulse(Yout_p(4)) < -(sp-sd));
        tictoc2 = any(impulse(Yout_p(1)) <= -sp) || any(impulse(Yout_p(2)) <= -sp) || ...
                  any(impulse(Yout_p(3)) <= -sp) || any(impulse(Yout_p(4)) <= -sp);
    elseif followers_num == 6
        tictoc1 = any((impulse(Yout_p(1)) < -(sp-sd))==1) || any((impulse(Yout_p(2)) < -(sp-sd))==1) || ...
                  any((impulse(Yout_p(3)) < -(sp-sd))==1) || any((impulse(Yout_p(4)) < -(sp-sd))==1) || ...
                  any((impulse(Yout_p(5)) < -(sp-sd))==1) || any((impulse(Yout_p(6)) < -(sp-sd))==1);
        tictoc2 = any((impulse(Yout_p(1)) <= -sp)==1) || any((impulse(Yout_p(2)) <= -sp)==1) || ...
                  any((impulse(Yout_p(3)) <= -sp)==1) || any((impulse(Yout_p(4)) <= -sp)==1) || ...
                  any((impulse(Yout_p(5)) <= -sp)==1) || any((impulse(Yout_p(6)) <= -sp)==1);
    elseif followers_num == 8
        tictoc1 = any((impulse(Yout_p(1)) < -(sp-sd))==1) || any((impulse(Yout_p(2)) < -(sp-sd))==1) || ...
                  any((impulse(Yout_p(3)) < -(sp-sd))==1) || any((impulse(Yout_p(4)) < -(sp-sd))==1) || ...
                  any((impulse(Yout_p(5)) < -(sp-sd))==1) || any((impulse(Yout_p(6)) < -(sp-sd))==1) || ...
                  any((impulse(Yout_p(7)) < -(sp-sd))==1) || any((impulse(Yout_p(8)) < -(sp-sd))==1);
        tictoc2 = any((impulse(Yout_p(1)) <= -sp)==1) || any((impulse(Yout_p(2)) <= -sp)==1) || ...
                  any((impulse(Yout_p(3)) <= -sp)==1) || any((impulse(Yout_p(4)) <= -sp)==1) || ...
                  any((impulse(Yout_p(5)) <= -sp)==1) || any((impulse(Yout_p(6)) <= -sp)==1) || ...
                  any((impulse(Yout_p(7)) <= -sp)==1) || any((impulse(Yout_p(8)) <= -sp)==1);
    end
end

