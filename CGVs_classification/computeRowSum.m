function I = computeRowSum(IC, followers_num, ift_num)
    % Computes the row sum of the IC matrix for each IFT.
    for IFT = 1:ift_num
        for i = 1:followers_num
            I(i,1,IFT) = sum(IC(i,:,IFT));
        end
    end
end

