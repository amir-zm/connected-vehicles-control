function tau = defineTau(followers_num)
    % Defines the tau vector based on the number of followers.
    if followers_num == 6
        tau = [0.7; 0.6; 1; 0.9; 0.7; 0.6];
    elseif followers_num == 8
        tau = [0.7; 0.6; 1; 0.9; 0.7; 0.6; 1; 0.9];
    elseif followers_num == 10
        tau = [0.7; 0.6; 1; 0.9; 0.7; 0.6; 1; 0.9; 0.7; 0.6];
    else
        tau = [tau1; tau2; tau3; tau4];
    end
end

