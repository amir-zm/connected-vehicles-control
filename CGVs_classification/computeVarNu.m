function [varrho_t_iip, nu_t_iip] = computeVarNu(ift_num, followers_num, IC, pos_def1, vel_def1, tau)
    % Computes varrho_t_iip and nu_t_iip using a parallel loop.
    varrho_t_iip = zeros(followers_num, ift_num);
    nu_t_iip = zeros(followers_num, ift_num);
    parfor IFT = 1:ift_num
        for i = 1:followers_num
            if i ~= 1
                idx_ic = find(IC.Value(i-1,:,IFT) > 0);
                idx_icp = find(IC.Value(i,:,IFT) > 0);
                idx_ic_sz = length(idx_ic);
                idx_ic_szp = length(idx_icp);
                pk_kplus_z = zeros(2, 1, idx_ic_sz);
                pk_kplus_zp = zeros(2, 1, idx_ic_szp);
                pk_kplus_b = zeros(2, 1, idx_ic_sz);
                pk_kplus_bp = zeros(2, 1, idx_ic_szp);
                pk_kplus_z0 = zeros(2, 1, idx_ic_sz);
                pk_kplus_z0p = zeros(2, 1, idx_ic_szp);
                for j = 1:idx_ic_sz
                    if idx_ic(j) == followers_num+1
                        for kappa = 0:i-2
                            pk_kplus_z0(:,:,j) = pk_kplus_z0(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    elseif idx_ic(j) < i-1
                        for kappa = idx_ic(j):i-2
                            pk_kplus_z(:,:,j) = pk_kplus_z(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    elseif idx_ic(j) > i
                        for kappa = i:idx_ic(j)-1
                            pk_kplus_b(:,:,j) = pk_kplus_b(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    end
                end
                pk_kplus_z02 = sum(pk_kplus_z0, 3);
                pk_kplus_z2 = sum(pk_kplus_z, 3);
                pk_kplus_b2 = sum(pk_kplus_b, 3);
                for j = 1:idx_ic_szp
                    if idx_icp(j) == followers_num+1
                        for kappa = 0:i-2
                            pk_kplus_z0p(:,:,j) = pk_kplus_z0p(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    elseif idx_icp(j) < i-1
                        for kappa = idx_icp(j):i-2
                            pk_kplus_zp(:,:,j) = pk_kplus_zp(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    elseif idx_icp(j) > i
                        for kappa = i:idx_icp(j)-1
                            pk_kplus_bp(:,:,j) = pk_kplus_bp(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    end
                end
                pk_kplus_z02p = sum(pk_kplus_z0p, 3);
                pk_kplus_z2p = sum(pk_kplus_zp, 3);
                pk_kplus_b2p = sum(pk_kplus_bp, 3);
                temp_u = (1/tau.Value(i-1))*(pk_kplus_z2 + pk_kplus_z02 - pk_kplus_b2) + ...
                    (1/tau.Value(i))*(pk_kplus_b2p - pk_kplus_z2p - pk_kplus_z02p);
            else
                idx_icp = find(IC.Value(i,:,IFT) > 0);
                idx_ic_szp = length(idx_icp);
                pk_kplus_bp = zeros(2, 1, idx_ic_szp);
                for j = 1:idx_ic_szp
                    if idx_icp(j) > i && idx_icp(j) ~= (followers_num+1)
                        for kappa = i:idx_icp(j)-1
                            pk_kplus_bp(:,:,j) = pk_kplus_bp(:,:,j) + [pos_def1.Value(kappa+1); vel_def1.Value(kappa+1)];
                        end
                    end
                end
                pk_kplus_b2p = sum(pk_kplus_bp, 3);
                temp_u = (1/tau.Value(i)) * pk_kplus_b2p;
            end
            varrho_t_iip(i, IFT) = temp_u(1);
            nu_t_iip(i, IFT) = temp_u(2);
        end
    end
end

