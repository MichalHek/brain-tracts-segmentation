function [ positive_set, negative_set] = create_eval_set( brain_Path, trct_name)%, fibers_num )
num_neg = 4000;
num_pos = 1000;
gtFiles = dir([brain_Path,'*.mat']);
gtFiles = {gtFiles.name};

trct_number = trct_encoder( trct_name );
positive_set = [];
negative_set = [];
for i = 1:length(gtFiles)
    load([brain_Path,gtFiles{i}]);
    %% negative set
    neg = struct('fibers',B_dataset.fibers(~(B_dataset.anat_trct_label == trct_number),:),'anat_trct_label',B_dataset.anat_trct_label(~(B_dataset.anat_trct_label == trct_number)));
    negative_idx = find(B_dataset.anat_trct_label~=trct_number);
    reduced_neg_set_idxs = randsample(length(negative_idx),num_neg);
    negative_set_tmp = neg.fibers(reduced_neg_set_idxs,:);
    negative_set = [negative_set;negative_set_tmp];
    %% positive set
    pos = struct('fibers',B_dataset.fibers((B_dataset.anat_trct_label == trct_number),:),'anat_trct_label',B_dataset.anat_trct_label(~(B_dataset.anat_trct_label == trct_number)));
    positive_idx = find(B_dataset.anat_trct_label==trct_number);
    reduced_pos_set_idxs = randsample(length(positive_idx),num_pos);
    positive_set_tmp = pos.fibers(reduced_pos_set_idxs,:);
    positive_set = [positive_set;positive_set_tmp];
end
positive_set(:,61) = 1;
negative_set(:,61) = 0;
end
