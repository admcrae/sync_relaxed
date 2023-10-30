function landscape_exp(graph_f, res_f, r, p, sigma, Ntrials)

load(graph_f);

Z = repmat(eye(r), n, 1);
mask = kron(A, ones(r));
results_T = table;
for i = 1:Ntrials
    noise = sigma*randn(n*r);
    noise = sqrt(0.5)*(noise + noise');
    C = mask.*(Z*Z' + noise);
    if issparse(A)
        C = sparse(C);
    end
    
    % Ensure we begin in correct connected component if p = r
    if p == r
        M2 = rotationsfactory(r, n);
        Y0 = stackstiefel(M2.rand());
    else
        Y0 = [];
    end

    [Yhat, ~, info, converged] = stiefel_rotation_solve(C, n, r, p, false, Y0, false);
    Yhat_SVs = {svd(Yhat)};
    relcorr = norm(Yhat'*Z, 'fro')^2/(n^2*r);
    solvetime = info(end).time;
    
    results_T = [results_T; table(graph_type, n, avg_deg, r, p, sigma, Yhat_SVs, relcorr, converged, solvetime)];
end
save(res_f, "results_T");
