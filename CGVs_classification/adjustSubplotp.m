function adjustSubplot(a1, IFT)
    % Adjust subplot position based on IFT index.
    b1 = get(a1, 'Position');
    if IFT <= 5
        b1(4) = b1(4) - 0.09;
        set(a1, 'Position', b1);
    else
        b1(4) = b1(4) - 0.09;
        b1(2) = b1(2) + 0.09;
        set(a1, 'Position', b1);
    end
end

