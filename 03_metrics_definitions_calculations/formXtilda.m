function Xtilda_t = formXtilda(Yout_p, Yout_v, Yout_a)
    % Constructs the state vector Xtilda_t based on position, velocity, and acceleration.
    X_01 = [Yout_p(1); Yout_v(1); Yout_a(1)];
    X_12 = [Yout_p(2); Yout_v(2); Yout_a(2)];
    X_23 = [Yout_p(3); Yout_v(3); Yout_a(3)];
    X_34 = [Yout_p(4); Yout_v(4); Yout_a(4)];
    Xtilda_t = [X_01; X_12; X_23; X_34];
end


