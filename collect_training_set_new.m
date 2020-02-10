function [curr_pos,curr_neg,interrupt] = collect_training_set_new(red_mode,brain_Path,trct_name,cascade ,prev_positive_set, prev_negative_set,iteration, StagesNum)
if iteration==1
    
    curr_pos = prev_positive_set;
    curr_neg = prev_negative_set;
    
    
    interrupt = 0;
else
    gtFiles = dir([brain_Path,'*.mat']);
    gtFiles = {gtFiles.name};
    trct_num = trct_encoder(trct_name);
    num_neg = 1000;
    num_pos = 500;
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
    
    
    
    
    TP = run_cascade(cascade,positive_set);
    FP = run_cascade(cascade,negative_set);
    positive_selected_set = positive_set(find(TP),:);
    negative_selected_set = negative_set(find(FP),:);
    FP_idxs = find(FP);
    lastN = length(FP_idxs);
    TP_idxs = find(TP);
    lastP = length(TP_idxs);
    PositiveNum = size(positive_set,1);
    NegativeNum = size(negative_set,1);
    required_p = 1000;%floor(PositiveNum/(1+(StagesNum-1)*(1-TPRate)));
    required_N = 2*required_p;
    Cont_P = (lastP >= required_p);
    Cont_N = (lastN >= required_N);
    if Cont_P && Cont_N
        rnd_idx_P=randsample(lastP,required_p);
        curr_pos = positive_selected_set(rnd_idx_P,:);
        
        rnd_idx_N=randsample(lastN,required_N);
        curr_neg = negative_selected_set(rnd_idx_N,:);
        
        interrupt = 0;
    else
        interrupt = 1;
        curr_pos=[];
        curr_neg =[];
    end
end
end