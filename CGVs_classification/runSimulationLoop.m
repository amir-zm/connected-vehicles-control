function runSimulationLoop(ift_num, followers_num, kb_grid, CG_incremental, cgu_upper, ...
    initial_of_gains, tau, IC, pos_def1, vel_def1, acc_def1, s, T_1, Uii, sd, sp, D, Tag_CGs)
    % Main simulation plotting and system response loop.
    m = 4;  % fixed value as in the original code
    for IFT = 1:ift_num
        if IFT == 1
            hh = figure('units','normalized','outerposition',[0 0 1 1]);
            set(hh, 'Color', 'w');
        end
        if IFT <= 5
            a1 = subplot(2, 24, 4*IFT-3+(IFT-1):4*IFT+(IFT-1));
        else
            a1 = subplot(2, 24, 4*IFT-3+(IFT-2):4*IFT+(IFT-2));
        end
        m_v = m * ones(followers_num, 1);
        k0 = [];
        b0 = [];
        bb0 = [];
        q = 0;
        h_val = size(kb_grid.Value, 3);
        for i = 1:h_val
            for j = 1:h_val
                temp = kb_grid.Value(:,:,i,j);
                k = temp(1);
                b = temp(2);
                k_v = k * ones(followers_num,1);
                b_v = b * ones(followers_num,1);
                % Compute system matrices and overall system matrix
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
                Asys = zeros(3*followers_num,3*followers_num);
                for ii = 1:followers_num
                    A_sys(:,:,ii,ii) = Astar(:,:,ii);
                    Asys((3*ii-2):3*ii,(3*ii-2):3*ii) = A_sys(:,:,ii,ii);
                    for jj = 1:followers_num
                        if jj ~= ii
                            A_sys(:,:,ii,jj) = IC.Value(ii,jj,IFT)*B(:,:,ii)*K(:,:,ii)';
                            Asys((3*ii-2):3*ii,(3*jj-2):3*jj) = A_sys(:,:,ii,jj);
                        end
                    end
                end
                if any(real(eig(Asys)) >= 0)
                    plot(k, b, 'y.', 'MarkerSize', 12);
                    drawnow;
                    hold on;
                    Tag_CGs(i,j,IFT) = 4;
                else
                    b0(end+1) = b;
                    bb0(1) = b0(1);
                    if b ~= bb0(end)
                        bb0(end+1) = b;
                        q = q + 1;
                    end
                    k0(q+1,1) = k;
                end
            end
        end
        
        p = 1;
        range_b = bb0(1):CG_incremental:cgu_upper;
        for bt = 1:length(range_b)
            b = range_b(bt);
            renage_k = initial_of_gains:CG_incremental:k0(p);
            Ui = tf(zeros(followers_num,1));
            parfor kt = 1:length(renage_k)
                [Yout_p, tictoc1, tictoc2] = computeResponse(renage_k, kt, b, followers_num, IFT, m_v, tau, IC, T_1, Uii, sd, sp, pos_def1, vel_def1, acc_def1, s);
                if tictoc2
                    Tag_CGs(bt, kt, IFT) = 3;
                elseif tictoc1
                    Tag_CGs(bt, kt, IFT) = 2;
                else
                    Tag_CGs(bt, kt, IFT) = 1;
                end
                send(D, [renage_k(kt), b, tictoc1, tictoc2, IFT, m, cgu_upper]);
            end
            p = p + 1;
        end
        
        adjustSubplot(a1, IFT);
    end
    saveas(gcf, num2str(m,1));
    save('areas');
    close;
end

