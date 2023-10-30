# sync_relaxed
MATLAB code for the paper [Benign landscapes of low-dimensional relaxations for orthogonal synchronization on general graphs](https://arxiv.org/abs/2307.02941).

This code depends on [Manopt](https://www.manopt.org). You must install Manopt and add it to your MATLAB path before running the solvers.

The main solver function is `stiefel_rotation_solve.m`. Some basic examples are found in `stiefel_opt_test.m`.

The `exp_*.m` MATLAB scripts are for running the large batches of experiments required for the paper's phase-transition plots.
The `batch_*.run` files are scripts for running the batches on a [Slurm](https://slurm.schedmd.com) cluster.
`plotresults.m` generates plots from the resulting data files.
