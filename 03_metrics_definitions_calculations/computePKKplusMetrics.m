function [pk_kplus_z02, pk_kplus_z2, pk_kplus_b2, ...
          pk_kplus_z02_jrk, pk_kplus_z2_jrk, pk_kplus_b2_jrk, ...
          pk_kplus_z02_acc, pk_kplus_z2_acc, pk_kplus_b2_acc] = computePKKplusMetrics(ind, size_tout, IC, DRAC_TTC_InpuT_temp, JRK_temp, ACC_temp, follwers_num)
    % Computes the aggregate pk_kplus terms needed for InpuT, JRK, and ACC metrics.
    ICi = IC.Value(:,:,ind);
    index_ic = find(ICi(ind,:) > 0);
    index_ic_sz = numel(index_ic);
    
    % Initialize temporary arrays for each metric and their summation terms
    pk_kplus_z = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_b = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_z0 = zeros(size_tout, 3, index_ic_sz);
    
    pk_kplus_z_jrk = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_b_jrk = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_z0_jrk = zeros(size_tout, 3, index_ic_sz);
    
    pk_kplus_z_acc = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_b_acc = zeros(size_tout, 3, index_ic_sz);
    pk_kplus_z0_acc = zeros(size_tout, 3, index_ic_sz);
    
    for szd = 1:index_ic_sz
        if index_ic(szd) == follwers_num+1
            for kappa = 0:ind-1
                pk_kplus_z0(:,:,szd) = pk_kplus_z0(:,:,szd) + DRAC_TTC_InpuT_temp(:,:,kappa+1);
                pk_kplus_z0_jrk(:,:,szd) = pk_kplus_z0_jrk(:,:,szd) + JRK_temp(:,:,kappa+1);
                pk_kplus_z0_acc(:,:,szd) = pk_kplus_z0_acc(:,:,szd) + ACC_temp(:,:,kappa+1);
            end
        elseif index_ic(szd) < ind
            for kappa = index_ic(szd):ind-1
                pk_kplus_z(:,:,szd) = pk_kplus_z(:,:,szd) + DRAC_TTC_InpuT_temp(:,:,kappa+1);
                pk_kplus_z_jrk(:,:,szd) = pk_kplus_z_jrk(:,:,szd) + JRK_temp(:,:,kappa+1);
                pk_kplus_z_acc(:,:,szd) = pk_kplus_z_acc(:,:,szd) + ACC_temp(:,:,kappa+1);
            end
        elseif index_ic(szd) > ind
            for kappa = ind:index_ic(szd)-1
                pk_kplus_b(:,:,szd) = pk_kplus_b(:,:,szd) + DRAC_TTC_InpuT_temp(:,:,kappa+1);
                pk_kplus_b_jrk(:,:,szd) = pk_kplus_b_jrk(:,:,szd) + JRK_temp(:,:,szd) + JRK_temp(:,:,kappa+1);
                pk_kplus_b_acc(:,:,szd) = pk_kplus_b_acc(:,:,szd) + ACC_temp(:,:,kappa+1);
            end
        end
    end
    
    % Sum the pk_kplus arrays for each metric
    pk_kplus_z02 = sum(pk_kplus_z0, 3);
    pk_kplus_z2 = sum(pk_kplus_z, 3);
    pk_kplus_b2 = sum(pk_kplus_b, 3);
    
    pk_kplus_z02_jrk = sum(pk_kplus_z0_jrk, 3);
    pk_kplus_z2_jrk = sum(pk_kplus_z_jrk, 3);
    pk_kplus_b2_jrk = sum(pk_kplus_b_jrk, 3);
    
    pk_kplus_z02_acc = sum(pk_kplus_z0_acc, 3);
    pk_kplus_z2_acc = sum(pk_kplus_z_acc, 3);
    pk_kplus_b2_acc = sum(pk_kplus_b_acc, 3);
end

