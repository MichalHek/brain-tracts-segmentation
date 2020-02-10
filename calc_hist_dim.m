function [ numcells ] = calc_hist_dim( fibers , res)

x_idx = 1:3:size(fibers,2)-2;
y_idx = 2:3:size(fibers,2)-1;
z_idx = 3:3:size(fibers,2);
maxcoor_pre = max(fibers,[],1);
mincoor_pre = min(fibers,[],1);
maxcoor = [max(maxcoor_pre(x_idx)),max(maxcoor_pre(y_idx)),max(maxcoor_pre(z_idx))];
mincoor = [min(mincoor_pre(x_idx)),min(mincoor_pre(y_idx)),min(mincoor_pre(z_idx))];
coordelta = maxcoor - mincoor;
numcells = ceil(coordelta./res);

end

