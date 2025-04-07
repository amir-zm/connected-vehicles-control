clc;
clear;

%% Initialization and simulation settings
sampling_time_ini = 0.01;
final_time_ini = 25;
follwers_num = 4;
tau_ini = [1; 1; 1; 1];
m = 4; % Number of vehicles (do not change)

%% Control gains for each follower (total net gains)
k_v_ini = [2.1; 1.2; 3.2; 1.1];
b_v_ini = [1.1; 2.2; 3.2; 2.1];
m_v_ini = [4; 8; 8; 4];

%% Inter-vehicle communication/control gains (Ks(i,j) means i receives info from j)
Ks = zeros(3,1,4,4);
Ks(:,:,2,1)= [0.1; 2.1; 4];
Ks(:,:,3,1)= [2.1; 1.1; 4];
Ks(:,:,3,2)= [1.1; 2.1; 4];
Ks(:,:,4,3)= [1.1; 2.1; 4];

%% System matrix construction for each follower
A_ini = sym(zeros(3,3,follwers_num));
B_ini = sym(zeros(3,1,follwers_num));
K_ini = sym(zeros(3,1,follwers_num));
Astar_ini = sym(zeros(3,3,follwers_num));
for i=1:follwers_num
    A_ini(:,:,i) = [0 1 0; 0 0 1; 0 0 -1/tau_ini(i)];
    B_ini(:,:,i) = [0; 0; 1/tau_ini(i)];
    K_ini(:,:,i) = [k_v_ini(i); b_v_ini(i); m_v_ini(i)];
    Astar_ini(:,:,i) = A_ini(:,:,i) - B_ini(:,:,i)*K_ini(:,:,i)';
end

%% Full block-diagonal system matrix assembly
A_sys_ini = sym(zeros(3,3,follwers_num,follwers_num));
Asys_ini = sym([]);
for i=1:follwers_num
    A_sys_ini(:,:,i,i) = Astar_ini(:,:,i);
    Asys_ini((3*i-2):3*i,(3*i-2):3*i) = A_sys_ini(:,:,i,i);
    for j=1:follwers_num
        if i > j
            A_sys_ini(:,:,i,j) = B_ini(:,:,i)*Ks(:,:,i,j)';
            Asys_ini((3*i-2):3*i,(3*j-2):3*j) = A_sys_ini(:,:,i,j);
        end
    end
end

%% Initial states and leader trajectory generation
Xf0_ini = zeros(3*follwers_num,1);
Xf0_ini(1:3:3*follwers_num,1) = [-15.7, -32.6, -47.8, -62.6];
Xf0_ini(2:3:3*follwers_num,1) = 0;
Xf0_ini(3:3:3*follwers_num,1) = 0;

if sampling_time_ini == 0.01
    plt_time = 120;
elseif sampling_time_ini == 0.001
    plt_time = 2281;
elseif sampling_time_ini == 0.03
    plt_time = 77;
end

tout = 0:sampling_time_ini:final_time_ini;
h_ini = size(tout,2);

xleader0_ini = 0;
vleader0_ini = 0;
vehicle_length_ini = [4, 4, 4, 4];
spacing_distance_ini = [5, 5, 5, 5];
omegatout = vehicle_length_ini + spacing_distance_ini;

leader_acc_ini = 4;
leader_nacc_ini = -8;

Xfstar_ini = zeros(3*follwers_num,1,h_ini);
Xtilda_ini = zeros(3*follwers_num,1,h_ini);
xleader_ini = zeros(h_ini,1);
vleader_ini = zeros(h_ini,1);
aleader_ini = zeros(h_ini,1);

%% Set initial reference and tracking errors
for i = 1:follwers_num
    Xfstar_ini(3*i-2,1,1) = xleader_ini(1) - sum(omegatout(1:i));
    Xfstar_ini(3*i-1,1,1) = vleader_ini(1);
    Xfstar_ini(3*i,1,1) = aleader_ini(1);
end
Xtilda_ini(:,:,1) = Xf0_ini - reshape(Xfstar_ini(:,:,1),[follwers_num*3,1]);

%% Leader trajectory: acceleration → constant speed → deceleration
hh = 1;
bb = [];
for tt = 2:plt_time
    if tout(tt) <= final_time_ini/3
        % Acceleration phase
        aleader_ini(tt) = leader_acc_ini;
        vleader_ini(tt) = leader_acc_ini*tout(tt) + vleader0_ini;
        xleader_ini(tt) = 0.5*leader_acc_ini*tout(tt)^2 + vleader0_ini*tout(tt) + xleader0_ini;
        tt_acc0 = tt;
    elseif tout(tt) <= 2*final_time_ini/3
        % Constant velocity phase
        aleader_ini(tt) = 0;
        vleader_ini(tt) = vleader_ini(tt_acc0);
        xleader_ini(tt) = vleader_ini(tt_acc0)*(tout(tt) - tout(tt_acc0)) + xleader_ini(tt_acc0);
        tt_acc00 = tt;
    else
        % Deceleration phase
        aleader_ini(tt) = leader_nacc_ini;
        vleader_ini(tt) = leader_nacc_ini*(tout(tt) - tout(tt_acc00)) + vleader_ini(tt_acc00);
        xleader_ini(tt) = 0.5*leader_nacc_ini*(tout(tt) - tout(tt_acc00))^2 + ...
                          vleader_ini(tt_acc00)*(tout(tt) - tout(tt_acc00)) + ...
                          xleader_ini(tt_acc00);
        if abs(vleader_ini(tt)) < 0.04
            leader_nacc_ini = 0;
            bb(hh) = tt;
            tt_acc00 = bb(1);
            hh = hh + 1;
        end
    end

    % Update reference states and error dynamics
    for i = 1:follwers_num
        Xfstar_ini(3*i-2,1,tt) = xleader_ini(tt) - sum(omegatout(1:i));
        Xfstar_ini(3*i-1,1,tt) = vleader_ini(tt);
        Xfstar_ini(3*i,1,tt)   = aleader_ini(tt);
    end
    Xtilda_ini(:,:,tt) = (eye(follwers_num*3) + ...
                          sampling_time_ini*Asys_ini) * reshape(Xtilda_ini(:,:,tt-1),[follwers_num*3,1]);
end

%% Final output: actual states of each follower
Xreal_ini = Xtilda_ini + Xfstar_ini;

