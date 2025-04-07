%% main_CGVs_classifier.m
function main_CGVs_classifier()
    % Main simulation function (modularized version)
    clc;
    close all;
    
    %% Input and Preallocations
    followers_num = input('enter the number of follwers, 4, 6, 8, or 10? ');
    ift_num = 10;
    Tag_CGs = zeros(40,40,ift_num);
    IC = zeros(followers_num, followers_num+1, ift_num);
    I = zeros(followers_num, 1, ift_num);
    
    %% System parameters and constants
    sd = 3;  % safe distance sp desired distance
    s = tf('s');
    T_1 = [1/s^2; 1/s; 1];
    initial_vel = parallel.pool.Constant(vleader_ini(plt_time,1));  % prerequisite variable
    Uii = ((4*s+1)*(s+1))/((s+2)*(s^2+2*s+12));
    
    %% IFT Configuration
    IC = configureIC(IC, followers_num, ift_num);
    
    %% Compute row sum for IC
    I = computeRowSum(IC, followers_num, ift_num);
    
    %% Setup gain grid (kb_grid)
    cgu_upper = 20;
    CG_incremental = 0.5;
    initial_of_gains = 0.1;
    t = initial_of_gains:CG_incremental:cgu_upper;
    h = numel(t);
    kb_grid = computeKBGrid(t, h);
    
    %% Define tau based on followers number
    tau = defineTau(followers_num);
    
    %% Compute initial differences (position, velocity, acceleration)
    [pos_def1, vel_def1, acc_def1] = computeDifferences(followers_num);
    
    %% Wrap variables for parallel processing
    pos_def1 = parallel.pool.Constant(pos_def1);
    vel_def1 = parallel.pool.Constant(vel_def1);
    acc_def1 = parallel.pool.Constant(acc_def1);
    tau = parallel.pool.Constant(tau);
    IC = parallel.pool.Constant(IC);
    
    %% Compute varrho_t_iip and nu_t_iip using parfor
    [varrho_t_iip, nu_t_iip] = computeVarNu(ift_num, followers_num, IC, pos_def1, vel_def1, tau);
    varrho_t_iip = parallel.pool.Constant(varrho_t_iip);
    nu_t_iip = parallel.pool.Constant(nu_t_iip);
    kb_grid = parallel.pool.Constant(kb_grid);
    
    %% Set up DataQueue for plot updates (uses the provided updatePlot function)
    D = parallel.pool.DataQueue;
    D.afterEach(@(x) updatePlot(x));
    
    %% Run Main Simulation Loop
    runSimulationLoop(ift_num, followers_num, kb_grid, CG_incremental, cgu_upper, ...
        initial_of_gains, tau, IC, pos_def1, vel_def1, acc_def1, s, T_1, Uii, sd, sp, D, Tag_CGs);
end



