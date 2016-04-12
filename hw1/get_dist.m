function dist = get_dist(X)
% Function to evaluate the pairwise distances of the columns of a matrix
% Input:
%   X:      d * n matrix
% Output:
%   dist:   n * n matrix, dist(i, j) represents the distance between X(:,
%           i) and X(:, j) (j > i)

[~, n] = size(X);
dist = zeros(n, n);
for i = 1 : n - 1
    dist(i, (i+1) : n) = sum((repmat(X(:, i), 1, n - i) - X(:, (i+1) : n)) .^ 2, 1) .^ (1/2);
end