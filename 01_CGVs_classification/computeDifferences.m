function [pos_def1, vel_def1, acc_def1] = computeDifferences(followers_num)
    % Computes initial differences (position, velocity, acceleration)
    % Prerequisite variables: xleader_ini, Xreal_ini, omegatout, aleader_ini, plt_time
    pos_defx = [xleader_ini(plt_time,1)-Xreal_ini(1,:,plt_time)-omegatout(1), ...
        Xreal_ini(1,:,plt_time)-Xreal_ini(4,:,plt_time)-omegatout(1), ...
        Xreal_ini(4,:,plt_time)-Xreal_ini(7,:,plt_time)-omegatout(1), ...
        Xreal_ini(7,:,plt_time)-Xreal_ini(10,:,plt_time)-omegatout(1)];
    vel_defx = [vleader_ini(plt_time,1)-Xreal_ini(2,:,plt_time), ...
        Xreal_ini(2,:,plt_time)-Xreal_ini(5,:,plt_time), ...
        Xreal_ini(5,:,plt_time)-Xreal_ini(8,:,plt_time), ...
        Xreal_ini(8,:,plt_time)-Xreal_ini(11,:,plt_time)];
    acc_defx = [aleader_ini(plt_time,1)-Xreal_ini(3,:,plt_time), ...
        Xreal_ini(3,:,plt_time)-Xreal_ini(6,:,plt_time), ...
        Xreal_ini(6,:,plt_time)-Xreal_ini(9,:,plt_time), ...
        Xreal_ini(9,:,plt_time)-Xreal_ini(12,:,plt_time)];
    
    if followers_num == 4
        pos_def1 = pos_defx;
        vel_def1 = vel_defx;
        acc_def1 = acc_defx;
    elseif followers_num == 6
        pos_def1 = [pos_defx, pos_defx(1:2)];
        vel_def1 = [vel_defx, vel_defx(1:2)];
        acc_def1 = [acc_defx, acc_defx(1:2)];
    elseif followers_num == 8
        pos_def1 = [pos_defx, pos_defx];
        vel_def1 = [vel_defx, vel_defx];
        acc_def1 = [acc_defx, acc_defx];
    else
        pos_def1 = [pos_defx, pos_defx, pos_defx(1:2)];
        vel_def1 = [vel_defx, vel_defx, vel_defx(1:2)];
        acc_def1 = [acc_defx, acc_defx, acc_defx(1:2)];
    end
end

