function Yout_a = computeResponse_A(IFT, followers_num, tau, IC, pos_def1, vel_def1, m_v, k, b, T_1, Uii, s)
    % Computes the auxiliary output Yout_a based on the system matrices.
    A = zeros(3,3,followers_num);
    B = zeros(3,1,followers_num);
    K = zeros(3,1,followers_num);
    for ii = 1:followers_num
        A(:,:,ii) = [0 1 0; 0 0 1; 0 0 -1/tau.Value(ii)];
        B(:,:,ii) = [0; 0; 1/tau.Value(ii)];
        K(:,:,ii) = [k; b; m_v(ii)];
    end
    Astar = A;
    for ii = 1:followers_num
        Astar(:,:,ii) = A(:,:,ii) - IC.Value(ii,1,IFT)*B(:,:,ii)*K(:,:,ii)';
    end
    A_sys = zeros(3,3,followers_num,followers_num);
    Asys = zeros(3*followers_num,3*followers_num);
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
    Yout_a = zeros(followers_num,1);
    for i = 1:followers_num
        % Compute control gains and related variables.
        K_st = [k, b, m_v(i)];
        if i == 1
            kb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i))*k;
            bb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i))*b;
            hb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i))*m_v(i) + (1/tau.Value(i));
        else
            kb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i) + ...
                sum(IC.Value(i-1,i:followers_num,IFT))/tau.Value(i-1))*k;
            bb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i) + ...
                sum(IC.Value(i-1,i:followers_num,IFT))/tau.Value(i-1))*b;
            hb_iip = ((sum(IC.Value(i,:,IFT))-sum(IC.Value(i,i:followers_num,IFT)))/tau.Value(i) + ...
                sum(IC.Value(i-1,i:followers_num,IFT))/tau.Value(i-1))*m_v(i) + (1/tau.Value(i));
        end
        Upsilon_iip = 1/(s^3 + hb_iip*s^2 + bb_iip*s + kb_iip);
        G_iip = s^2 * Upsilon_iip;
        % (Theta_iip, Gamma_iip placeholders as in the original code)
        Theta_iip = k*0 + b*0;
        Gamma_iip = k*0;
        Lambda0_iip = Gamma_iip - vel_def1.Value(i)*kb_iip;
        Lambda1_iip = Theta_iip - pos_def1.Value(i)*kb_iip - vel_def1.Value(i)*bb_iip;
        Lambda2_iip = acc_def1.Value(i);
        H_iip_a = Lambda2_iip*s^2 + Lambda1_iip*s + Lambda0_iip;
        Psi_iip = H_iip_a * Upsilon_iip;
        if i == 1
            Ui = ((1+tau.Value(i)*s)*s^2*Upsilon_iip*Uii)/(tau.Value(i));
        else
            Ui = ((tau.Value(i-1)-tau.Value(i))*s^2*Upsilon_iip*Uii)/(tau.Value(i-1)*tau.Value(i));
        end
        % Compute Q matrix.
        Q = eye(followers_num);
        for j = 1:followers_num
            if j == i
                Q(j,i) = 1;
            elseif j > i && j ~= 1
                K_jminusj_kminus = ((sum(IC.Value(j-1,:,IFT))-sum(IC.Value(j-1,i:followers_num,IFT)))/tau.Value(j-1) - ...
                    (sum(IC.Value(j,:,IFT))-sum(IC.Value(j,i:followers_num,IFT)))/tau.Value(j))*K_st - ...
                    [0, 0, (tau.Value(j-1)-tau.Value(j))/(tau.Value(j)*tau.Value(j-1))];
                Q(j,i) = -K_jminusj_kminus*T_1*G_iip;
            elseif j > i && j == 1
                K_jminusj_kminus = -(sum(IC.Value(j,:,IFT))-sum(IC.Value(j,i:followers_num,IFT)))/tau.Value(j)*K_st;
                Q(j,i) = -K_jminusj_kminus*T_1*G_iip;
            elseif j < i && j ~= 1
                K_jminusj_kplus = (sum(IC.Value(j,i:followers_num,IFT))/tau.Value(j) - ...
                    sum(IC.Value(j-1,i:followers_num,IFT))/tau.Value(j-1))*K_st;
                Q(j,i) = -K_jminusj_kplus*T_1*G_iip;
            elseif j < i && j == 1
                K_jminusj_kplus = sum(IC.Value(j,i:followers_num,IFT))/tau.Value(j)*K_st;
                Q(j,i) = -K_jminusj_kplus*T_1*G_iip;
            end
        end
        Yout_a(i) = Q \ (Psi_iip + Ui);
    end
end

