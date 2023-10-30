function corr = rotcorr(Z, X)
    [nr, r] = size(Z);
    n = round(nr/r);

    if size(X, 2) == nr
        corr = real(trace(Z'*X*Z)) / (n*nr);
    else
        corr = norm(Z'*X, 'fro')^2 / (n*nr);
    end
end