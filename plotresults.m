clear;
close all;

savefigs = true;
folder = "results";
graph_type = "ER";

listing = dir(folder);
T = table;
expr = sprintf("res_%s_(?<jobid>\\d+)_(?<arr_ind>\\d+).mat", graph_type);
for k = 1:numel(listing)
    l = listing(k);
    tkns = regexp(l.name, expr, 'names');

    if numel(tkns) > 0
        f = fullfile(l.folder, l.name);
        load(f, 'results_T');
        n_rows = height(results_T);
        job_ind = str2double(tkns.arr_ind);
        results_T.job_ind = job_ind*ones(n_rows, 1);
        T = [T; results_T];
    end
end
figuresize = [350, 200];

n_exp = height(T);
rank_Y = zeros(n_exp, 1);
T.sigma = round(T.sigma, 2, 'significant');

for i = 1:n_exp
    SVs = T.Yhat_SVs(i);
    SVs = SVs{1};
    rank_Y(i) = nnz(SVs >= 1e-3*sqrt(T.n(i)));
end
T.Yhat_rank = rank_Y;
T.rank_deficient = T.Yhat_rank < T.p;
T.rank_r = T.Yhat_rank == T.r;

f1 = figure(1);
sigmap_heatmap(T, 'relcorr', f1, figuresize, savefigs, sprintf('figures/%s-corr.pdf', graph_type));

f2 = figure(2);
sigmap_heatmap(T, 'rank_r', f2, figuresize, savefigs, sprintf('figures/%s-rankr.pdf', graph_type));

f3 = figure(3);
sigmap_heatmap(T, 'rank_deficient', f3, figuresize, savefigs, sprintf('figures/%s-rankdef.pdf', graph_type));

f4 = figure(4);
heatmap(T, 'sigma', 'p', 'ColorVariable', 'solvetime', 'Colormap', gray,...
    CellLabelColor='none',...
    CellLabelFormat='%.0f'...
    );
title('');
set(gca,'ColorScaling','log');
f4.Position(3:4) = figuresize;
if savefigs
    exportgraphics(gca, sprintf('figures/%s-solvetime.pdf', graph_type), 'ContentType', 'vector');
end

%% See how many experiments we have for each job index
% f5 = figure(5);
% [ind_counts, inds, ~] = groupcounts(T.job_ind);
% stem(inds, ind_counts)
% 
% f6 = figure(6)
% heatmap(T, 'sigma', 'p')