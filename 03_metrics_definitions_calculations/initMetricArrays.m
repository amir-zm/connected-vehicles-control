function [DRAC, TTC, InpuT, ACC, JRK, SetlTime] = initMetricArrays(size_tout, ift_num, follwers_num)
    % Initializes the main metric arrays with the required dimensions.
    DRAC = zeros(size_tout, 1, 40, 40, ift_num, follwers_num);
    TTC = zeros(size_tout, 1, 40, 40, ift_num, follwers_num);
    InpuT = zeros(size_tout, 1, 40, 40, ift_num, follwers_num);
    ACC = zeros(size_tout, 1, 40, 40, ift_num, follwers_num);
    JRK = zeros(size_tout, 1, 40, 40, ift_num, follwers_num);
    SetlTime = zeros(1, 1, 40, 40, ift_num, follwers_num);
end

