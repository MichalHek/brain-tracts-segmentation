function [fibers] = vox2fib(voxel_mesh_res,pos_clas_fibers,brain_fibers)
% load('classified_fibers_results_final_vox');
% load('C:\Users\dell\Desktop\project\Brains_norm\102311.mat');
j = 0;
resolution = 1;
x = brain_fibers(:,1:3:60);
y = brain_fibers(:,2:3:60);
z = brain_fibers(:,3:3:60);
%% box
min_x = min(min(x)); min_y = min(min(y));  min_z  =  min(min(z));
fibers = [];
for i = 1:size(pos_clas_fibers,1)
    
    X = pos_clas_fibers(i,1:3:60);
    Y = pos_clas_fibers(i,2:3:60);
    Z = pos_clas_fibers(i,3:3:60);
    x_indices = floor((X(:)-min_x)/resolution)+1;
    y_indices = floor((Y(:)-min_y)/resolution)+1;
    z_indices = floor((Z(:)-min_z)/resolution)+1;
    indices = sub2ind(size(voxel_mesh_res),x_indices,y_indices,z_indices);
    pos_indices = find(voxel_mesh_res);
    similarity = ismember(pos_indices,indices);
    similarity_perc = sum(similarity')/length(indices);
    if similarity_perc > 0.1
        j = j+1;
        fibers(j,:) = pos_clas_fibers(i,:);
    end
end

end



% function similarity = voxel_similarity(indices,pos_indices)
% similarity = sum(ismember(indices,pos_indices))/length(indices);
% end


