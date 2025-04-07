function plotPerVehicleMetrics(kappa, ifts, colors, TAble, SetlTime_IFT, SetlTime_IFT_AVE, SetlTime_PerFV, SetlTime_PerFV_AVE, DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num, MeaN, StD, scale, CCGs_num)
    % For a given vehicle index (kappa), generate plots of metrics per vehicle.
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'color', 'white');
    
    for ift = 1:ift_num
        p = 1;
        % Accumulate settling time values from the grid where shared CG exists
        for i = 1:40
            for j = 1:40
                if NC_common_tag(i,j) > 0
                    SetlTime_PerFV(p,1,kappa,ift) = SetlTime_PerFV(p,1,kappa,ift) + SetlTime(1,1,i,j,ift,kappa);
                    SetlTime_PerFV_AVE(p,1,kappa,ift) = SetlTime_PerFV(p,1,kappa,ift) / p;
                    SetlTime_IFT(p,1,ift) = SetlTime_IFT(p,1,ift) + SetlTime(1,1,i,j,ift,kappa);
                    SetlTime_IFT_AVE(p,1,ift) = SetlTime_IFT(p,1,ift) / p;
                    p = p + 1;
                end
            end
        end
        
        % Plot DRAC per vehicle
        subplot(16,2,1:2:8);
        mean_DRAC_nscaled = mean(cumsum(DRAC(:,:,:,:,ift,kappa)*sampling_time_ini), [3,4]);
        mean_DRAC_scaled_int = mean_DRAC_nscaled * scale;
        drac_perfv(ift) = plot(tout, mean_DRAC_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_DRAC = scale_cnt * (mean_DRAC_nscaled.^2);
        var_nscaled_DRAC = var(cumsum(DRAC(:,:,:,:,ift,kappa)*sampling_time_ini), 0, [3,4]);
        var_scaled_DRAC = var_nscaled_DRAC * scale - scale_plus_DRAC;
        std_amplitude_DRAC = sqrt(var_scaled_DRAC);
        plot(tout, std_amplitude_DRAC, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, kappa, 1, ift, DRAC_num) = mean_DRAC_scaled_int(end);
        TAble(:, StD, kappa, 1, ift, DRAC_num) = std_amplitude_DRAC(end);
        if ift == ift_num
            legend(drac_perfv, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('DRAC', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Plot TTC per vehicle
        subplot(16,2,2:2:8);
        mean_TTC_nscaled = mean(cumsum(TTC(:,:,:,:,ift,kappa)*sampling_time_ini), [3,4]);
        mean_TTC_scaled_int = mean_TTC_nscaled * scale;
        ttc_perfv(ift) = plot(tout, mean_TTC_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_TTC = scale_cnt * (mean_TTC_nscaled.^2);
        var_nscaled_TTC = var(cumsum(TTC(:,:,:,:,ift,kappa)*sampling_time_ini), 0, [3,4]);
        var_scaled_TTC = var_nscaled_TTC * scale - scale_plus_TTC;
        std_amplitude_TTC = sqrt(var_scaled_TTC);
        plot(tout, std_amplitude_TTC, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, kappa, 1, ift, TTC_num) = mean_TTC_scaled_int(end);
        TAble(:, StD, kappa, 1, ift, TTC_num) = std_amplitude_TTC(end);
        if ift == ift_num
            legend(ttc_perfv, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('TTC', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Plot InpuT per vehicle
        subplot(16,2,13:2:20);
        mean_InpuT_nscaled = mean(cumsum(InpuT(:,:,:,:,ift,kappa)*sampling_time_ini), [3,4]);
        mean_InpuT_scaled_int = mean_InpuT_nscaled * scale;
        input_perfv(ift) = plot(tout, mean_InpuT_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_InpuT = scale_cnt * (mean_InpuT_nscaled.^2);
        var_nscaled_InpuT = var(cumsum(InpuT(:,:,:,:,ift,kappa)*sampling_time_ini), 0, [3,4]);
        var_scaled_InpuT = var_nscaled_InpuT * scale - scale_plus_InpuT;
        std_amplitude_InpuT = sqrt(var_scaled_InpuT);
        plot(tout, std_amplitude_InpuT, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, kappa, 1, ift, InpuT_num) = mean_InpuT_scaled_int(end);
        TAble(:, StD, kappa, 1, ift, InpuT_num) = std_amplitude_InpuT(end);
        if ift == ift_num
            legend(input_perfv, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('InpuT', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Plot ACC per vehicle
        subplot(16,2,14:2:20);
        mean_ACC_nscaled = mean(cumsum(ACC(:,:,:,:,ift,kappa)*sampling_time_ini), [3,4]);
        mean_ACC_scaled_int = mean_ACC_nscaled * scale;
        acc_perfv(ift) = plot(tout, mean_ACC_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_ACC = scale_cnt * (mean_ACC_nscaled.^2);
        var_nscaled_ACC = var(cumsum(ACC(:,:,:,:,ift,kappa)*sampling_time_ini), 0, [3,4]);
        var_scaled_ACC = var_nscaled_ACC * scale - scale_plus_ACC;
        std_amplitude_ACC = sqrt(var_scaled_ACC);
        plot(tout, std_amplitude_ACC, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, kappa, 1, ift, ACC_num) = mean_ACC_scaled_int(end);
        TAble(:, StD, kappa, 1, ift, ACC_num) = std_amplitude_ACC(end);
        if ift == ift_num
            legend(acc_perfv, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('ACC', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Plot JRK per vehicle
        subplot(16,2,25:2:32);
        mean_JRK_nscaled = mean(cumsum(JRK(:,:,:,:,ift,kappa)*sampling_time_ini), [3,4]);
        mean_JRK_scaled_int = mean_JRK_nscaled * scale;
        jrk_perfv(ift) = plot(tout, mean_JRK_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_JRK = scale_cnt * (mean_JRK_nscaled.^2);
        var_nscaled_JRK = var(cumsum(JRK(:,:,:,:,ift,kappa)*sampling_time_ini), 0, [3,4]);
        var_scaled_JRK = var_nscaled_JRK * scale - scale_plus_JRK;
        std_amplitude_JRK = sqrt(var_scaled_JRK);
        plot(tout, std_amplitude_JRK, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, kappa, 1, ift, JRK_num) = mean_JRK_scaled_int(end);
        TAble(:, StD, kappa, 1, ift, JRK_num) = std_amplitude_JRK(end);
        if ift == ift_num
            legend(jrk_perfv, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('JRK', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Plot Settling Time per vehicle
        subplot(16,2,26:2:32);
        setltime_perfv_ave(ift) = plot(1:CCGs_num, cumsum(SetlTime_PerFV_AVE(1:CCGs_num, :, kappa, ift)), 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        if ift == ift_num
            legend(setltime_perfv_ave, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Number of CCG', 'Interpreter','latex','FontSize',24);
            ylabel('SetlTime', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
        end
    end
end

