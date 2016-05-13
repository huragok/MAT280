clear all;
close all;
clc;

load('crescents.mat');
[p, n] = size(x);
% figure;
% scatter(x(1,:), x(2, :))

epsilon = 0.01;
W = exp(-pdist2(x', x') .^ 2 / epsilon);

L = diag(sum(W)) - W;
[V, D] = eig(L);
v = real(V(:, 2));
idx = kmeans(v, 2);

figure;
scatter(x(1, idx == 1), x(2, idx == 1), [], 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'), hold on;
scatter(x(1, idx == 2), x(2, idx == 2), [], 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');
xlabel('x_1', 'fontsize', 16), ylabel('x_2', 'fontsize', 16);
legend('Cluster 1', 'Cluster 2')
set(gca, 'fontsize', 16);
grid on;

figure;
[n1,v1] = hist(v(idx == 1));
[n2,v2] = hist(v(idx == 2));
bar(v1, n1, 'hist')
hold on; 
h=bar(v2, n2, 'hist'); hold off
set(h,'facecolor','r');
legend('Cluster 1', 'Cluster 2');
xlabel('v', 'fontsize', 16), ylabel('count', 'fontsize', 16);
set(gca, 'fontsize', 16);
grid on;

[~, idx_sort] = sort(v);
figure;
imagesc(W(idx_sort, idx_sort)), hold on;
if idx(idx_sort(1)) == 1
    n_cluster1 = sum(idx == 1);
else
    n_cluster1 = sum(idx == 2);
end

plot(n_cluster1 * ones(1, n), 1 : n, 'k', 'linewidth', 2);
plot(1 : n, n_cluster1 * ones(1, n), 'k', 'linewidth', 2);
colorbar;
axis equal
set(gca, 'fontsize', 16);
xlim([0, 200]), ylim([0, 200]);
xlabel('i', 'fontsize', 16), ylabel('j', 'fontsize', 16);