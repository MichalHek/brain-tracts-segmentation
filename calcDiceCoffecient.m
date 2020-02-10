function calcDiceCoffecient

trct_name = 'L_UNC';
brainPath = 'D:\Guy\rula\Brains\extra\';
load('cascade_stage3_tractL_UNC_All_features_CRST.mat');
red_mode = 'CRST';
fprintf('starts plotting the results\n');
gtFiles = dir([brainPath,'*.mat']);
gtFiles = {gtFiles.name};

diceVec = cell(4,length(gtFiles));
for i = 1: length(gtFiles)
load([brainPath,gtFiles{i}]);

trct_num = trct_encoder(trct_name);
whole_brain = B_dataset.fibers;
TP_idx = (B_dataset.anat_trct_label==trct_num);
positive_set = B_dataset.fibers(TP_idx,:);
classified_fibers = run_cascade(cascade, B_dataset.fibers);
pos_clas_fibers = B_dataset.fibers(classified_fibers == 1,:);
% load('pos_clas_fibers');
% TP_fibers = B_dataset.fibers((classified_fibers'.*TP_idx) == 1,:);

% Post processing
whole_brain_voxels = fib2vox(pos_clas_fibers,whole_brain);
posclassfibers = postProcessing( pos_clas_fibers,whole_brain_voxels,whole_brain,trct_name );

TPNum = 0;
fPNum = 0;

positive_voxels = fib2vox(positive_set,whole_brain);
pos_class_voxels = fib2vox(posclassfibers,whole_brain);

checkmemb = ismember(find(pos_class_voxels==1),find(positive_voxels==1));
TPNum = TPNum + sum(checkmemb);
fPNum = fPNum + sum(~checkmemb);

D1 = TPNum/length(positive_voxels(find(positive_voxels)));
F1 = fPNum/sum(~positive_voxels(:));

plot_output_set(posclassfibers,'b')
% dice coffeficients
commonVox = find(pos_class_voxels & positive_voxels);
diceVec{1,i} = gtFiles{i};
diceVec{2,i} = 100*2*length(commonVox)/(length(find(pos_class_voxels)) + length((find(positive_voxels))));
diceVec{3,i} = 100*F1; diceVec{4,i} = 100*D1;
fprintf('result for brain "%s":\nDice = %f\n',diceVec{1,i},diceVec{2,i});

end
save(['diceVec',trct_name,'_all_faetures_',red_mode,'.mat'],'diceVec');
% figure;cellplot(diceVec)
end