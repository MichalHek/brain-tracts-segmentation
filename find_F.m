function  [F, FP_fibers] = find_F(cascade, strong_classifier, evaluation_set, iteration , param_tresh)
    negativeNum = size(evaluation_set,1);
    cascade(iteration).strong_classifier= strong_classifier;
    cascade(iteration).param_tresh= param_tresh;
    
    % run the new cascade on the evaluation set and extract all TP:
    FP_fibers = run_cascade(cascade, evaluation_set);
    FP_idxs = find(FP_fibers);
    TFNum = length(FP_idxs);
    
    F = TFNum/negativeNum;
end

