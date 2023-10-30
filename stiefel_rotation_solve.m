function [Yhat, cost, info, converged] = stiefel_rotation_solve(C, n, r, p, cplx, Y0, adv_solve)

if ~exist('cplx', 'var')
    cplx = false;
end

if ~exist('Y0', 'var')
    Y0 = [];
end

if ~exist('adv_solve', 'var')
    adv_solve = false;
end

if ~isreal(C) || cplx
    M = stiefelcomplexfactory(p, r, n);
    problem.M = M;
    problem.cost = @(x) - real(trace(stackstiefel(x)'*C*stackstiefel(x)));
    problem.egrad = @(x) - unstackstiefel(2*C*stackstiefel(x), n, r, p);
    problem.ehess = @(x, u) - unstackstiefel(2*C*stackstiefel(u), n, r, p);
    if numel(Y0) > 0
        Y0 = unstackstiefel(Y0, n, r, p);
    end
else
    M = stiefelstackedfactory(n, r, p);
    problem.M = M;
    problem.cost = @(x) - sum(x.*(C*x), 'all');
    problem.egrad = @(x) - 2*C*x;
    problem.ehess = @(x, u) - 2*C*u;
end

options.debug=0;
options.verbosity = 2;
if adv_solve % Necessary to escape exact saddle points. Unnecessary with random initialization.
    options.useRand = true;
    options.miniter = 2;
end
options.tolgradnorm = 1e-6*sqrt(n);
options.maxiter=400;
options.subproblemsolver = @trs_tCG;

[Y_opt, cost, info] = trustregions(problem, Y0, options);
converged = info(end).gradnorm <= options.tolgradnorm;
Yhat = Y_opt;

end