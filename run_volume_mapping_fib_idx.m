function [ volume_map ] = run_volume_mapping_fib_idx( fibers, reduced_idxs ,res)
% Calculate the size of the expected 3D hitogram:
hist_dim = calc_hist_dim(fibers, res);

volume_map = struct();
volume_mat_b_reduced = calc_volume_hist_binary_fib_idx( fibers,reduced_idxs,hist_dim, res );
volume_mat_b_full = calc_volume_hist_binary_fib_idx( fibers,1:size(fibers,1),hist_dim, res );

volume_map.volume_mat_b_full = volume_mat_b_full;
volume_map.volume_mat_b_reduced = volume_mat_b_reduced;

end

