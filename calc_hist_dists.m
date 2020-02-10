function H_dist_full_reduced = calc_hist_dists( volume_map )
volume_mat_b_reduced = volume_map.volume_mat_b_reduced;
volume_mat_b_full = volume_map.volume_mat_b_full;

%Hamming
numcells = numel(volume_mat_b_reduced);
diff_cells = bsxfun(@xor,volume_mat_b_reduced , volume_mat_b_full);
diff_num = numel(find(diff_cells));
H_dist_full_reduced = diff_num/numcells;

end