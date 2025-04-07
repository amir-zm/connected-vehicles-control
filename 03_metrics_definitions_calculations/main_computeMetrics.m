function main_computeMetrics()
    % Main function to compute metrics (DRAC, TTC, InpuT, ACC, JRK, SetlTime)
    % for different IFTs under shared control gains.
    clc;
    
    % --- Prerequisite data ---
    % Assumes that the following variables are available in the workspace:
    %   - tout, ift_num, follwers_num, NC_common_tag, s, tau, Uii, vel_def1,
    %     pos_def1, acc_def1, varrho_t_iip, nu_t_iip, IC, T_1, tau_ini
    % Also assumes that the Control System Toolbox is available (for tf and impulse).
    
    size_tout = size(tout,2);
    
    % --- Initialize environmental and vehicle parameters as parallel constants ---
    sigmaAir = createParallelConstant(1.204);
    mass = createParallelConstant([1900.258, 1800.036, 1950.980, 2000.877]);
    crossSectional = createParallelConstant([2.444, 2.713, 2.543, 3.791]);
    dragCoefficient = createParallelConstant([0.412, 0.311, 0.359, 0.511]);
    mechanicalDrag = createParallelConstant([4.111, 3.831, 3.902, 4.001]);
    
    % --- Set constant value for m ---
    m = 4;
    
    % --- Initialize metric arrays ---
    [DRAC, TTC, InpuT, ACC, JRK, SetlTime] = initMetricArrays(size_tout, ift_num, follwers_num);
    
    % --- Loop over IFT configurations, b (row index) and k (column index) ---
    for IFT = 1:ift_num
        for bt = 1:40
            b = (bt-1)*0.5 + 0.1;
            % Use parfor for the inner loop over k
            parfor kt = 1:40
                k = (kt-1)*0.5 + 0.1;
                if NC_common_tag(bt,kt) > 0
                    % Initialize temporary arrays for impulse responses and metrics
                    [DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp, SetlTime_Metric, ...
                        MeTric_DRAC, MeTric_TTC, MeTric_InpuT, MeTric_JRK, MeTric_ACC] = ...
                        initTempArrays(size_tout, follwers_num);
                    
                    % Compute transfer function gains and related quantities
                    [Ui, G_iip, Psi_iip, Upsilon_iip, H_iip_a, kb_iip, bb_iip, hb_iip] = ...
                        computeGainsMetrics(IFT, k, b, m, follwers_num);
                    
                    % Compute Q matrix based on control gains
                    Q = computeQMatrix(IFT, k, b, m, follwers_num);
                    
                    % Compute additional metrics (Theta, Gamma, Lambda, Psi)
                    [Theta_iip, Gamma_iip, Lambda0_iip, Lambda1_iip, Lambda2_iip, Psi_iip] = ...
                        computeErrorMetrics(IFT, k, b, kb_iip, bb_iip, hb_iip, follwers_num);
                    
                    % Compute controller output and system response
                    U10 = s^2*(1+tau.Value(1)*s)*Uii/(tau.Value(1)*s^3+(1+m)*s^2+b*s+k);
                    Ui(1,:) = U10;
                    Yout_a = Q \ (Psi_iip + Ui);
                    Yout_v = (Yout_a + vel_def1.Value')/s;
                    Yout_p = (Yout_a + vel_def1.Value')/s^2 + pos_def1.Value'/s;
                    
                    % Form platoon output and state vector
                    D_platoon = Yout_p + [5/s; 5/s; 5/s; 5/s];
                    Xtilda_t = formXtilda(Yout_p, Yout_v, Yout_a);
                    
                    % Compute impulse responses for DRAC, JRK, and ACC metrics
                    [DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp] = ...
                        computeImpulseResponses(Xtilda_t, tout, follwers_num);
                    
                    % Loop over each follower to compute individual metrics
                    for ind = 1:follwers_num
                        % Compute settling time metric and store it
                        [SetlTime_Metric, SetlTime] = computeSetlTime(ind, Yout_p, tout, SetlTime_Metric, SetlTime, bt, kt, IFT);
                        
                        % Compute TTC metric
                        [MeTric_TTC, TTC] = computeTTC(ind, Yout_v, Yout_a, D_platoon, tout, TTC, bt, kt, IFT);
                        
                        % Compute DRAC metric
                        [MeTric_DRAC, DRAC] = computeDRAC(ind, Yout_v, Yout_a, D_platoon, tout, DRAC, bt, kt, IFT);
                        
                        % Compute pk_kplus values for InpuT, JRK, and ACC metrics based on interconnection
                        [pk_kplus_z02, pk_kplus_z2, pk_kplus_b2, ...
                            pk_kplus_z02_jrk, pk_kplus_z2_jrk, pk_kplus_b2_jrk, ...
                            pk_kplus_z02_acc, pk_kplus_z2_acc, pk_kplus_b2_acc] = ...
                            computePKKplusMetrics(ind, size_tout, IC, DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp, follwers_num);
                        
                        % Compute Input Metric
                        temp_u = pk_kplus_b2 - pk_kplus_z2 - pk_kplus_z02;
                        MeTric_InpuT(:,ind) = mass.Value(ind) * ( - k*temp_u(:,1) - b*temp_u(:,2) - m*temp_u(:,3) ) + ...
                            (0.5 * sigmaAir.Value * crossSectional.Value(ind) * dragCoefficient.Value(ind)) .* (impulse(Yout_v(ind,:),tout).^2) + ...
                            mechanicalDrag.Value(ind) + ...
                            (tau.Value(ind)*sigmaAir.Value*crossSectional.Value(ind)*dragCoefficient.Value(ind)) .* (impulse(Yout_v(ind,:),tout) .* impulse(Yout_a(ind,:),tout));
                        InpuT(:,:,bt,kt,IFT,ind) = MeTric_InpuT(:,ind).^2;
                        
                        % Compute JRK Metric
                        temp_u_jrk = pk_kplus_b2_jrk - pk_kplus_z2_jrk - pk_kplus_z02_jrk;
                        MeTric_JRK(:,ind) = - k*temp_u_jrk(:,1) - b*temp_u_jrk(:,2) - m*temp_u_jrk(:,3);
                        JRK(:,:,bt,kt,IFT,ind) = MeTric_JRK(:,ind).^2;
                        
                        % Compute ACC Metric
                        temp_u_acc = pk_kplus_b2_acc - pk_kplus_z2_acc - pk_kplus_z02_acc;
                        MeTric_ACC(:,ind) = - k*temp_u_acc(:,1) - b*temp_u_acc(:,2) - m*temp_u_acc(:,3);
                        ACC(:,:,bt,kt,IFT,ind) = MeTric_ACC(:,ind).^2;
                    end
                else
                    continue;
                end
            end
        end
    end
    
    % Save the computed metrics to a MAT-file
    save('03_Safe&Unsafe_CCGs_4Plot');
end

