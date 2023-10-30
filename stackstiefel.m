function Xstacked = stackstiefel(X)
    [p, r, n] = size(X);
    Xstacked = reshape(permute(X, [2, 3, 1]), [n*r, p]);
end