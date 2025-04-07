function IC = configureIC(IC, followers_num, ift_num)
    % Configures the interconnection matrix (IC) for each IFT case.
    for IFT = 1:ift_num
        switch IFT
            case 1  % PF
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                    end
                end
            case 4  % PFL
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        IC(i, followers_num+1, IFT) = 1;
                    end
                end
            case 7  % BD
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                        IC(i, i+1, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        if i < followers_num
                            IC(i, i+1, IFT) = 1;
                        elseif i == followers_num
                            continue;
                        end
                    end
                end
            case 6  % BDL
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                        IC(i, i+1, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        IC(i, followers_num+1, IFT) = 1;
                        if i < followers_num
                            IC(i, i+1, IFT) = 1;
                        end
                    end
                end
            case 5  % TPF
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        if i == 2
                            IC(i, 1+followers_num, IFT) = 1;
                        else
                            IC(i, i-2, IFT) = 1;
                        end
                    end
                end
            case 3  % TPFL
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        if i == 2
                            IC(i, 1+followers_num, IFT) = 1;
                        else
                            IC(i, i-2, IFT) = 1;
                            IC(i, 1+followers_num, IFT) = 1;
                        end
                    end
                end
            case 2  % MPF
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                    else
                        IC(i, i-1, IFT) = 1;
                        if i == 2
                            IC(i, 1+followers_num, IFT) = 1;
                        elseif i == 3
                            IC(i, 1+followers_num, IFT) = 1;
                            IC(i, i-2, IFT) = 1;
                        else
                            IC(i, i-2, IFT) = 1;
                            IC(i, i-3, IFT) = 1;
                        end
                    end
                end
            case 8  % TBD
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                        IC(i, i+1, IFT) = 1;
                        IC(i, i+2, IFT) = 1;
                    else
                        if i > 2
                            IC(i, i-1, IFT) = 1;
                            IC(i, i-2, IFT) = 1;
                        else
                            IC(i, i-1, IFT) = 1;
                            IC(i, 1+followers_num, IFT) = 1;
                        end
                        if i <= followers_num-2
                            IC(i, i+1, IFT) = 1;
                            IC(i, i+2, IFT) = 1;
                        elseif i == followers_num-1
                            IC(i, i+1, IFT) = 1;
                        elseif i == followers_num
                            continue;
                        end
                    end
                end
            case 9  % TPSF
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                        IC(i, i+1, IFT) = 1;
                    else
                        if i > 2
                            IC(i, i-1, IFT) = 1;
                            IC(i, i-2, IFT) = 1;
                        else
                            IC(i, i-1, IFT) = 1;
                            IC(i, 1+followers_num, IFT) = 1;
                        end
                        if i <= followers_num-1
                            IC(i, i+1, IFT) = 1;
                        elseif i == followers_num
                            continue;
                        end
                    end
                end
            case 10  % SPTF
                for i = 1:followers_num
                    if i-1 == 0
                        IC(i, i+followers_num, IFT) = 1;
                        IC(i, i+1, IFT) = 1;
                        IC(i, i+2, IFT) = 1;
                    else
                        if i >= 2
                            IC(i, i-1, IFT) = 1;
                        end
                        if i <= followers_num-2
                            IC(i, i+1, IFT) = 1;
                            IC(i, i+2, IFT) = 1;
                        elseif i == followers_num-1
                            IC(i, i+1, IFT) = 1;
                        end
                    end
                end
        end
    end
end

