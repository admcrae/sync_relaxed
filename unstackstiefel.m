function X = unstackstiefel(Xstacked, n, r, p)
    X = permute( reshape(Xstacked, r, n, p), [3, 1, 2]  );
end