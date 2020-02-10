function plot_tract(cascade, trct_name)
trct_name = 'R_CS';
% load('cascade_stage2_tractR_CSPhysicalFeatures.mat');
load('cascade_stage2_tractR_CSLocationFeaturesOnly.mat');
fprintf('starts plotting the results');
% gtFiles = dir(['C:\Users\a0mar\Documents\Rula Amer\final project\modified_final_project\brains\extra\','*.mat']);
% gtFiles = {gtFiles.name};

%  load(['C:\Users\a0mar\Documents\Rula Amer\final project\modified_final_project\brains\extra\',gtFiles{4}]);

load('D:\Guy\rula\Brains\extra\102311.mat');
% redrate = 250;
% [dataset , anat_label] = calc_coreset( B_dataset, redrate );
trct_num = trct_encoder(trct_name);
whole_brain = B_dataset.fibers;
TP_idx = (B_dataset.anat_trct_label==trct_num);
positive_set = B_dataset.fibers(TP_idx,:);
classified_fibers = run_cascade(cascade, B_dataset.fibers);
posclasfibers = B_dataset.fibers(classified_fibers == 1,:);
% TP_fibers = B_dataset.fibers((classified_fibers'.*TP_idx) == 1,:);
% save ClassifiedFibers pos_clas_fibers
% save TP_fibers TP_fibers
% save positive_set positive_set
% Post processing
if strcmp(trct_name,'R_CS')
    N = 5;
else
    N = 3;
end
after_Morph = MorphOP(posclasfibers,whole_brain,N);
result = ConnComp(after_Morph,trct_name);
pos_clas_fibers = vox2fib(result,posclasfibers);
% displayVolumeSliceGUI(result);
% 
    TPNum = sum(classified_fibers'.*TP_idx);
    
    D = TPNum/sum(TP_idx)
     fPNum = sum((classified_fibers)'.*(~TP_idx));
    
    F = fPNum/sum(~TP_idx)
%     
% %%
figure
%% plot detected tract
% subplot(1,2,1);
set = pos_clas_fibers;
x = set(:,1:3:60);
y = set(:,2:3:60);
z = set(:,3:3:60);
for i = 1:size(set,1)
   plot3(x(i,:),y(i,:),z(i,:),'blue');
    hold on
end
str_TP = ['TP rate = ',num2str(D)];
str_FP = ['FP rate = ',num2str(F)];
title({['Segmented',trct_name],[str_TP,'   ',str_FP]});
% plot the original one
% subplot(1,2,2);
% set = positive_set;
% x = set(:,1:3:60);
% y = set(:,2:3:60);
% z = set(:,3:3:60);
% for i = 1:size(set,1)
%    plot3(x(:,:),y(:,:),z(:,:),'red');
%     hold on
% end
% title('Original MCP');
% % trct_name = 'L_U_N_C';
% suptitle(['Stage 1: Detection Rate = ',num2str(D*100),' %, False Positive = ',num2str(F*100),' %']);
% title(['Detection Rate = ',num2str(D),'  False Positive = ',num2str(F)]);
% title([plot1,plot2],{'Segmented MCP','Original MCP'});
% legend('Segmented Tract','Original Tract');
 zz=1;

end