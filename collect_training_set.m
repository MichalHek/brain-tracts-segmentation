function [ new_positive_set, new_negative_set , interrupt] = collect_training_set(TPRate,StagesNum, positive_set, negative_set, iteration, cascade )
    if iteration==1
        
        new_positive_set = positive_set;
        new_negative_set = negative_set;


        interrupt = 0;
    else

        % run the current cascade on the positive set and extract all TP:
        TP_imgs = run_cascade(cascade, positive_set); % implement this func -TODO returns a binary array.
        TP_idxs = find(TP_imgs);
        lastP = length(TP_idxs);

        % run the current cascade on the negative set and extract all FP:    
        FP_imgs = run_cascade(cascade, negative_set);
        FP_idxs = find(FP_imgs);
        lastN = length(FP_idxs);
        PositiveNum = size(positive_set,1);
        NegativeNum = size(negative_set,1);
        required_p = floor(PositiveNum/(1+(StagesNum-1)*(1-TPRate)));
        required_N = 2*required_p;

        Cont_P = (lastP >= required_p*1.1);
        Cont_N = (lastN >= required_N);

        if Cont_P && Cont_N
            rnd_idx_P=randsample(PositiveNum,required_p);
            new_positive_set = positive_set(rnd_idx_P,:);
            
            rnd_idx_N=randsample(NegativeNum,required_N);
            new_negative_set = negative_set(rnd_idx_N,:);

            interrupt = 0;
        else
            interrupt = 1;
            new_positive_set =[];
            new_negative_set =[];
        end
    end
end

