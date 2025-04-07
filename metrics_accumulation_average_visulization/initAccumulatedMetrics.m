function [MeaN, StD, DRAC_num, TTC_num, InpuT_num, ACC_num, JRK_num, metric_num, ...
    TAble, CCGs_num, scale, SetlTime_IFT, SetlTime_IFT_AVE, ...
    SetlTime_PerFV, SetlTime_PerFV_AVE, ifts, colors] = initAccumulatedMetrics()
    % Initializes constants and preallocates arrays for the module.
    
    MeaN = 1;
    StD = 2;
    DRAC_num = 1;
    TTC_num = 2;
    InpuT_num = 3;
    ACC_num = 4;
    JRK_num = 5;
    metric_num = 5; % DRAC, TTC, InpuT, ACC, JRK
    
    % TAble: dimensions: 1x2 x (follwers_num+1) x 1 x ift_num x metric_num
    TAble = zeros(1, 2, follwers_num+1, 1, ift_num, metric_num);
    
    % Calculate number of grid points with non-zero shared CGs
    CCGs_num_zero = sum(NC_common_tag == 0, 'all');
    CCGs_num = 1600 - CCGs_num_zero;
    scale = 1600 / CCGs_num;
    
    % Preallocate settling time arrays
    SetlTime_IFT = zeros(CCGs_num, 1, ift_num);
    SetlTime_IFT_AVE = zeros(CCGs_num, 1, ift_num);
    SetlTime_PerFV = zeros(CCGs_num, 1, follwers_num, ift_num);
    SetlTime_PerFV_AVE = zeros(CCGs_num, 1, follwers_num, ift_num);
    
    % Define IFT names and colors for plotting
    ifts = {'PF', 'MPF', 'TPFL', 'PFL', 'TPF', 'BDL', 'BD', 'TBD', 'TPSF', 'SPTF'};
    col1 = [1, 0, 0];
    col2 = [0, 0, 1];
    col3 = [0, 1, 0];
    col4 = [0, 1, 1];
    col5 = [1, 0, 1];
    col6 = [1, 1, 0];
    col7 = [0, 0, 0];
    col8 = [1, 0.5, 0];
    col9 = [0.5, 0, 0.5];
    col10 = [0.64, 0.16, 0.16];
    colors = {col1, col2, col3, col4, col5, col6, col7, col8, col9, col10};
end

