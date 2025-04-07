function plotMeanStdIFT(ifts, colors, TAble, MeaN, StD, DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num)
    % Plot Mean and Standard Deviation per IFT (aggregated over vehicles)
    figure('units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'color', 'white');
    
    for ift = 1:ift_num
        % DRAC
        subplot(16,2,1:2:8);
        mean_DRAC_nscaled = mean(cumsum(DRAC(:,:,:,:,ift,:)*sampling_time_ini), [3,4,6]);
        mean_DRAC_scaled_int = mean_DRAC_nscaled * scale;
        drac_ift(ift) = plot(tout, mean_DRAC_scaled_int, 'LineWidth', 2, 'Color', colors{ift});
        hold on;
        scale_cnt = (sum(NC_common_tag == 0, 'all') / 1600) * scale;
        scale_plus_DRACi = scale_cnt * (mean_DRAC_nscaled.^2);
        var_nscaled_DRACi = var(cumsum(DRAC(:,:,:,:,ift,:)*sampling_time_ini), 0, [3,4,6]);
        var_scaled_DRACi = var_nscaled_DRACi * scale - scale_plus_DRACi;
        std_amplitude_DRAC = sqrt(var_scaled_DRACi);
        plot(tout, std_amplitude_DRAC, 'LineWidth', 1, 'Color', colors{ift}, 'LineStyle', "--");
        hold on;
        TAble(:, MeaN, 5, 1, ift, DRAC_num) = mean_DRAC_scaled_int(end);
        TAble(:, StD, 5, 1, ift, DRAC_num) = std_amplitude_DRAC(end);
        if ift == ift_num
            legend(drac_ift, ifts{1:ift}, 'Interpreter', 'latex', 'fontsize', 18, 'Orientation', 'horizontal');
            xlabel('Time', 'Interpreter','latex','FontSize',24);
            ylabel('DRAC', 'Interpreter','latex','FontSize',14);
            set(gca, 'Fontsize', 20);
            grid on;
            xlim([0, final_time_ini]);
        end
        
        % Repeat similar plotting for TTC, InpuT, ACC, JRK in corresponding subplots
        % (The code structure is similar to the above; please refer to the per-vehicle
        %  plots and adjust the averaging dimensions as needed.)
    end
end

