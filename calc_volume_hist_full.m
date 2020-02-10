function [ volume_mat ] = calc_volume_hist_full( full_set,fibers,hist_dim, res )
FN = size(fibers,1);
dotperfiber = size(full_set,2)/3;
x_idx = 1:3:size(full_set,2)-2;
y_idx = 2:3:size(full_set,2)-1;
z_idx = 3:3:size(full_set,2);

mincoor_pre = min(full_set,[],1);
mincoor = [min(mincoor_pre(x_idx)),min(mincoor_pre(y_idx)),min(mincoor_pre(z_idx))];

temp=repmat(mincoor,FN,dotperfiber);
fibersquant = fibers-temp;
fibersquant = floor(fibersquant./res)+1;

x_coor = reshape(fibersquant(:,x_idx),FN*dotperfiber,1);
y_coor = reshape(fibersquant(:,y_idx),FN*dotperfiber,1);
z_coor = reshape(fibersquant(:,z_idx),FN*dotperfiber,1);
idx=sub2ind(hist_dim, x_coor,y_coor,z_coor);

%% version 2: accumolating histogram

% Fibers per cell (weighted centroids):
temp_hist = hist(idx,1:hist_dim(1)*hist_dim(2)*hist_dim(3));
volume_mat = reshape(temp_hist,hist_dim(1),hist_dim(2),hist_dim(3));

end
