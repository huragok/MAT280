function e = get_error(dist, dist_new)
% Evaluate the dimension reduction error defined in Eq (1) of 
% J. W. Sammon, "A Nonlinear Mapping for Data Structure Analysis,"
% in IEEE Transactions on Computers, vol. C-18, no. 5, pp. 401-409, May 
% 1969.

[~, d] = size(dist);
mask = triu(ones(d), 1);
dist = dist(mask == 1); % Extract the upper triangular into vector
dist_new = dist_new(mask == 1);

e = sum((dist - dist_new) .^ 2 ./ dist) / sum(dist);