function cascade = cascade_trainer()

dbstop if error
today = date;
diary_path = '.\log_file.txt';

%% paths
matlab_Path = cd;
addpath('.\cascades');
addpath('.\features');
addpath('.\Brains');
addpath('.\Brains\evaluation');
addpath('.\Brains\training');
tic
%% params
false_positive = 0.001;
trct_name = 'R_CS';
F_curr = 1;
D_curr = 1;
iteration = 0;
StagesNum = 10;
TPRate = 0.85;

%% create data
% [positive_evaluation_set,negative_evaluation_set] = create_eval_set([matlab_Path,'\Brains\evaluation\'], trct_name);
% [positive_set,negative_set] = create_eval_set( [matlab_Path,'\Brains\training\'], trct_name);
% save (['positive_evaluation_set_',trct_name,'.mat'],'positive_evaluation_set');
% save (['negative_evaluation_set_',trct_name,'.mat'],'negative_evaluation_set');
% save (['positive_set_',trct_name,'.mat'],'positive_set');
% save (['negative_set_',trct_name,'.mat'],'negative_set');
load (['positive_evaluation_set_',trct_name,'.mat']);
load (['negative_evaluation_set_',trct_name,'.mat']);
load (['positive_set_',trct_name,'.mat']);
load (['negative_set_',trct_name,'.mat']);
%%-----------------------------------------------
% reduced_neg_set_idxs  = FDC_main(negative_set.fibers,20000);
% reduced_neg_set_idxs = randsample(length(negative_set.anat_trct_label),round(length(negative_set.anat_trct_label)/6));
% negative_set = create_new_dataset(negative_set, sort(reduced_neg_set_idxs), 1);
% % reduced_pos_set_idxs  = FDC_main(positive_set.fibers,6000);
% reduced_pos_set_idxs = randsample(length(positive_set.anat_trct_label),round(length(positive_set.anat_trct_label)/4));
% positive_set = create_new_dataset(positive_set, sort(reduced_pos_set_idxs), 1);
%%--------------------------------------------------------
fprintf('number of samples for each set:\n');
fprintf('------------------------------\n');
fprintf('positive_evaluation_set= %d \n',size(positive_evaluation_set,1));
fprintf('negative_evaluation_set= %d \n',size(negative_evaluation_set,1));
fprintf('positive_set= %d \n',size(positive_set,1));
fprintf('negative_set= %d \n',size(negative_set,1));
%% start the training process
diary(diary_path)
diary on
fprintf('Start training cascade, date: %s \n', today)
cascade = struct ('strong_classifier',[],'param_tresh',[] );
while (F_curr>false_positive && iteration<=StagesNum)
    strong_classifier = struct('feature_name', [], 'val', [], 'polarity', [], 'weight', [], 'fibers_weights', []);
    iteration = iteration+1;
    fprintf('starts building stage number %d \n',iteration)
    T=5;
    [t, f, d] = update_params(iteration);
    [curr_set_positive, curr_set_negative, interrupt] = collect_training_set_new(TPRate,[matlab_Path,'\Brains\training\'],trct_name,cascade ,positive_set, negative_set,iteration, StagesNum);
    if interrupt
        fprintf('Not enough train fibers, aborting cascade training. the resulted cascade has %d stages',iteration-1);
        save('resulted_cascade.mat','cascade')
        break
    end
    F_next=F_curr;
    while F_next>f*F_curr
        strong_classifier = stage_trainer( matlab_Path,T, curr_set_positive, curr_set_negative,strong_classifier);
        param_tresh =1;
        [D_next, TP_curr_fibers]= find_D(cascade, strong_classifier, positive_evaluation_set, iteration, param_tresh);
        count = 0;
        while  (D_next < d*D_curr) && (count < 100)
            count = count + 1;
            param_tresh = 0.85*param_tresh;
            [D_next, TP_curr_fibers]= find_D(cascade, strong_classifier, positive_evaluation_set, iteration, param_tresh );
        end
        fprintf('Detection rate for the current stage being evaluated: %f \n', D_next)
        [F_next, fP_curr_fibers] = find_F(cascade, strong_classifier, negative_evaluation_set, iteration, param_tresh);
        fprintf('FP rate: %f . Should be less than: %f \n', F_next, f*F_curr)
        T=T+t;
    end
    fprintf('Number of weak classifiers in the current stage: %d \n', T-t)
    fprintf('Detection rate at the end of the current stage training: %f \n', D_next)
    fprintf('FP rate at the end of the current stage training: %f \n', F_next)
    cascade(iteration).strong_classifier= strong_classifier;
    cascade(iteration).param_tresh= param_tresh;
    F_curr = F_next;
    D_curr = D_next;
    TP_fibers = positive_evaluation_set( find(TP_curr_fibers),:);
    fP_fibers = negative_evaluation_set( find(fP_curr_fibers), :);
    figure;
    plot_evaluation_set(positive_evaluation_set,TP_fibers,fP_fibers);
    str = ['Cascades\cascade_stage',num2str(iteration),'_tract',trct_name,'StructureOnly_features.mat']; 
    save(str,'cascade');
    
end
save(['Cascades\resulted_cascade_structure_',date,'.mat'],'cascade');
fprintf('Running Time of this program is: %f',toc); 
diary off
end