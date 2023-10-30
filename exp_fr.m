function exp_fr(batch_index, Ntrials, job_id)

r = 2;
sigmas = 0.2*logspace(-1, 1, 2*8+1);
ps = 2:10;

nsigs = length(sigmas);
nps = length(ps);
max_ind = nsigs*nps - 1; % 152
if batch_index < 0 || batch_index > max_ind
    error('Index %d too large; maximum is %d', batch_index, max_ind);
end
sigma = sigmas(1+mod(batch_index, nsigs));
p = ps(1 + floor(batch_index/nsigs));

graph_f = './graphs/fr079.mat';
res_f = sprintf('results/res_fr_%d_%d.mat', job_id, batch_index);

landscape_exp(graph_f, res_f, r, p, sigma, Ntrials);

end
