clear;
close all;

n = 200;
r = 2;
p = 3;
noise_sig = 0;

cplx = false;


ndeg = r^2 * n*(n-1)/2;
Z = repmat(eye(r), n, 1);

% % Erdos-Renyi graph
% p = 0.1;
% adj = triu(rand(n) <= p);
% adj = adj + adj';

% Circulant graph
k = 5;
adjvec = [0, ones(1, k), zeros(1, n - (2*k+1)), ones(1,k)];
adj = toeplitz(adjvec);

optcost = -r*sum(adj, 'all'); % Optimal cost in noiseless case

mask = kron(adj, ones(r));
noise = noise_sig*randn(n*r);
noise = sqrt(0.5)*(noise + noise');
C = mask.*(Z*Z' + noise);


% % Random initialization
% Ntrials = 20;
% costs = zeros(1, Ntrials);
% for t = 1:Ntrials
%     [Yhat, cost, ~, ~] = stiefel_rotation_solve(C, n, r, p, cplx);
%     costs(t) = cost;
% end
% histogram(costs - optcost);

% Twisted state initialization if r = 2
assert(r == 2);
Y0 = zeros(p, r, n);
for i = 1:n
    theta = 2*pi*i*1/n;
    Y0(1:r, :, i) = [cos(theta), -sin(theta); sin(theta), cos(theta)];
end
Y0 = stackstiefel(Y0);
[Yhat, cost, ~, ~] = stiefel_rotation_solve(C, n, r, p, false, Y0, true);
costerror = cost - optcost