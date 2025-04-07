function area_percetage = computeAreaPercentage(ift_num, Tag_CGs)
    % Computes the percentage area based on safe/unsafe control gains.
    area_percetage = cell(1, ift_num);
    for i = 1:ift_num
        area_percetage{1,i} = num2str((1 - (sum(Tag_CGs(:,:,i) == 1, 'all') / 1600)) * 100, '%.3f');
    end
end

