function [ pdf ] = create_pdf( fibers,res)
% Calculate the size of the expected 3D hitogram:
hist_dim = calc_hist_dim(fibers, res);
volume_mat = calc_volume_hist_full( fibers,fibers,hist_dim, res );
volume_mat(volume_mat==0)=NaN;
inv_density = 1./volume_mat;
pdf = pdf_calc(inv_density,fibers,hist_dim, res);

end

