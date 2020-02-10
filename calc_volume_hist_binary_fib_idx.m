function [ volume_mat_b ] = calc_volume_hist_binary_fib_idx( full_set,examined_set_idxs,hist_dim, res )
FN = length(examined_set_idxs);
dotperfiber = size(full_set,2)/3;
x_idx = 1:3:size(full_set,2)-2;
y_idx = 2:3:size(full_set,2)-1;
z_idx = 3:3:size(full_set,2);

mincoor_pre = min(full_set,[],1);
mincoor = [min(mincoor_pre(x_idx)),min(mincoor_pre(y_idx)),min(mincoor_pre(z_idx))];

volume_mat_b = zeros(hist_dim);

temp=repmat(mincoor,FN,dotperfiber);
fibersquant = full_set(examined_set_idxs,:)-temp;
fibersquant = floor(fibersquant./res)+1;

x_coor = reshape(fibersquant(:,x_idx),FN*dotperfiber,1);
y_coor = reshape(fibersquant(:,y_idx),FN*dotperfiber,1);
z_coor = reshape(fibersquant(:,z_idx),FN*dotperfiber,1);
idx=sub2ind(size(volume_mat_b), x_coor,y_coor,z_coor);
volume_mat_b(idx)=1;

end
