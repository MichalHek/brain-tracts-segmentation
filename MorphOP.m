function [result] = MorphOP(classified_fibers,whole_brain_voxels,N)
% load('classified_fibers');
% load('C:\Users\dell\Desktop\project\Brains_norm\102311.mat');
% % load('positive_set');
% classified_fibers = pos_clas_fibers;
% clearvars pos_clas_fibers
% whole_brain = B_dataset.fibers;

% trct_num = trct_encoder(trct_name);
% TP_idx = (B_dataset.anat_trct_label==trct_num);
% positive_set = B_dataset.fibers(TP_idx,:);
% voxels = fib2vox(positive_set,whole_brain);

% voxelized_fibers = fib2vox(classified_fibers,whole_brain);
% N = 5; %size of cube
mid = ceil(N/2);
SE = zeros(N,N,N);%structure element
SE(mid,mid,:) = 1;  SE(mid,:,mid) = 1;   SE(:,mid,mid) = 1;   
result = imopen(whole_brain_voxels,SE);
% save('classified_fibers_results.mat','result');
% displayVolumeSliceGUI(result);
 
end