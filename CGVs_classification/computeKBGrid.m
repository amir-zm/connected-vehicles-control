function kb_grid = computeKBGrid(t, h)
    % Constructs the kb_grid array based on vector t.
    kb_grid = zeros(2, 1, h, h);
    for i = 1:h
        for j = 1:h
            kb_grid(:,:,i,j) = [t(j); t(i)];
        end
    end
end

