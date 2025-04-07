function main_computeAccumulatedMetrics()
    % main_computeAccumulatedMetrics
    % This module computes accumulated average metrics and visualizes them.
    % It uses previously computed variables (e.g., NC_common_tag, Tag_CGs,
    % sampling_time_ini, tout, final_time_ini, follwers_num, ift_num, etc.)
    %
    % Metrics computed:
    %   - DRAC (Deceleration Rate)
    %   - TTC (Time-to-Collision)
    %   - InpuT (Input effort)
    %   - ACC (Acceleration)
    %   - JRK (Jerk)
    % And also the settling time per follower.
    %
    % The computed summary tables and area percentages are saved in 'last_result.mat'.
    
    %% Initialization
    [MeaN, StD, DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num, metric_num, ...
        TAble, CCGs_num, scale, SetlTime_IFT, SetlTime_IFT_AVE, ...
        SetlTime_PerFV, SetlTime_PerFV_AVE, ifts, colors] = initAccumulatedMetrics();
    
    %% Per-Vehicle Metrics Plots
    for kappa = 1:4
        plotPerVehicleMetrics(kappa, ifts, colors, TAble, SetlTime_IFT, ...
            SetlTime_IFT_AVE, SetlTime_PerFV, SetlTime_PerFV_AVE, ...
            DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num, MeaN, StD, scale, CCGs_num);
    end
    
    %% Mean and STD per IFT Plots
    plotMeanStdIFT(ifts, colors, TAble, MeaN, StD, DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num);
    
    %% Compute Summary Tables for Each Metric
    [TAbleDRAC, TAbleTTC, TAbleInpuT, TAbleACC, TAbleJRK] = computeTAbleResults(TAble, MeaN, StD);
    
    %% Compute Area Percentage
    area_percetage = computeAreaPercentage(ift_num, Tag_CGs);
    
    %% Save Final Results
    save('last_result');
end

