function  [D, TP_fibers] = find_D(cascade, strong_classifier, evaluation_set, iteration , param_tresh)
    PositiveNum = size(evaluation_set,1);
    cascade(iteration).strong_classifier= strong_classifier;
    cascade(iteration).param_tresh= param_tresh;
    
    % run the new cascade on the evaluation set and extract all TP:
    TP_fibers = run_cascade(cascade, evaluation_set);
    TP_idxs = find(TP_fibers);
    TPNum = length(TP_idxs);
    
    D = TPNum/PositiveNum;
end