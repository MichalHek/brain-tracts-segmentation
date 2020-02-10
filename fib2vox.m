function [voxel_mesh] = fib2vox(fibers,brain_fibers)

resolution = 1;
x = brain_fibers(:,1:3:60);
y = brain_fibers(:,2:3:60);
z = brain_fibers(:,3:3:60);
X = fibers(:,1:3:60);
Y = fibers(:,2:3:60);
Z = fibers(:,3:3:60);
%% box
max_x = max(max(x)); max_y = max(max(y)); min_x = min(min(x)); 
min_y = min(min(y)); max_z = max(max(z)); min_z  =  min(min(z));
 
ventrical_length = max_x - min_x ; horiz_length = max_y - min_y ; depth = max_z - min_z ;
voxel_mesh = zeros(ceil(ventrical_length/resolution),ceil(horiz_length/resolution),ceil(depth/resolution));

x_indices = floor((X(:)-min_x)/resolution)+1;
y_indices = floor((Y(:)-min_y)/resolution)+1;
z_indices = floor((Z(:)-min_z)/resolution)+1;

indices = sub2ind(size(voxel_mesh),x_indices,y_indices,z_indices);
voxel_mesh(indices) = 1;
% for i = 1:length(indices)
%     voxel_mesh(indices(i)) = 1;
% end

end





