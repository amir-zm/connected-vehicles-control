function [DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp, SetlTime_Metric, ...
          MeTric_DRAC, MeTric_TTC, MeTric_InpuT, MeTric_JRK, MeTric_ACC] = initTempArrays(size_tout, follwers_num)
    % Initializes temporary arrays for impulse responses and metric computations.
    DRAC_TTC_InpuT_temp = zeros(size_tout, 3, follwers_num);
    JRK_temp = zeros(size_tout, 3, follwers_num);
    ACC_temp = zeros(size_tout, 3, follwers_num);
    SetlTime_Metric = zeros(1, follwers_num);
    MeTric_DRAC = zeros(size_tout, follwers_num);
    MeTric_TTC = zeros(size_tout, follwers_num);
    MeTric_InpuT = zeros(size_tout, follwers_num);
    MeTric_JRK = zeros(size_tout, follwers_num);
    MeTric_ACC = zeros(size_tout, follwers_num);
end


