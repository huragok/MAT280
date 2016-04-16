clear all;
close all;
clc;

load('SomeYaleFaces.mat');
[d, n_image] = size(X);
k = [10, 20, 50, 100, 200, 500, 800, 1000];
seed = 8; 
n_sample = 20; % How many random matrix instances are generated

% Evaluate the pairwise distance between the original images
dist = get_dist(X);

% Error measurement for different k and projection methods
e_jl = zeros(length(k), 1); % Johnson Lindenstrauss projection
e_fjl = zeros(length(k), 1); % Fast Johnson Lindenstrauss projection
e_rs = zeros(length(k), 1); % Random selection

rng(seed);
for i_k = 1 : length(k)
    tic;
    % Johnson Lindenstrauss projection
    P = randn(d, k(i_k), n_sample);
    for i_sample = 1 : n_sample
       P_tmp = orth(P(:, :, i_sample))';
       X_proj_jl = sqrt(d / k(i_k)) * P_tmp * X;
       dist_tmp = get_dist(X_proj_jl);
       e_jl(i_k) = e_jl(i_k) + get_error(dist, dist_tmp);
    end
    e_jl(i_k) = e_jl(i_k) / n_sample;
    toc;
    disp(['k = ', num2str(k(i_k)), ' error (JL) = ', num2str(e_jl(i_k))]);
    tic;
    
    % Fast Johnson Lindenstrauss projection
    sign = 2 * randi(2, d, n_sample) - 3;
    idx_col = zeros(k(i_k), n_sample);
    for i_sample = 1 : n_sample
        idx_col(:, i_sample) = randperm(d, k(i_k))';
    end

    for i_sample = 1 : n_sample
        X_proj_fjl = d / sqrt(k(i_k)) * fwht(diag(sign(:, i_sample)) * X);
        X_proj_fjl = X_proj_fjl(idx_col(:, i_sample), :);
        
        dist_tmp = get_dist(X_proj_fjl);
        e_fjl(i_k) = e_fjl(i_k) + get_error(dist, dist_tmp);
    end
    e_fjl(i_k) = e_fjl(i_k) / n_sample;
    toc;
    disp(['k = ', num2str(k(i_k)), ' error (FJL) = ', num2str(e_fjl(i_k))]);
    tic;
    
    % Random sampling
    for i_sample = 1 : n_sample
        X_proj_rs = sqrt(d / k(i_k)) * X(idx_col(:, i_sample), :);
        
        dist_tmp = get_dist(X_proj_rs);
        e_rs(i_k) = e_rs(i_k) + get_error(dist, dist_tmp);
    end
    e_rs(i_k) = e_rs(i_k) / n_sample;
    toc;
    disp(['k = ', num2str(k(i_k)), ' error (RS) = ', num2str(e_rs(i_k))]);
end

figure;
loglog(k, e_jl, 'b+-', 'linewidth', 2), hold on;
loglog(k, e_fjl, 'ro--', 'linewidth', 2);
loglog(k, e_rs, 'ks-.', 'linewidth', 2);
xlabel('k', 'fontsize', 18), ylabel('Error', 'fontsize', 18); 
grid on;
legend('JF', 'FJL', 'RS');
set(gca, 'fontsize', 18);

