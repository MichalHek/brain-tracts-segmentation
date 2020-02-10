function strong_classifier = stage_trainer( matlab_Path,T, positive_set, negative_set, strong_classifier)

[weights,combine_set]=run_combine_training_set(negative_set,positive_set );

% strong_classifier = struct('feature_name', [], 'val', [], 'polarity', [], 'weight', []);
if ~isempty(strong_classifier)
    s = 1;
else
    s = length(strong_classifier)+1;
    weights = strong_classifier(end).fibers_weights;
end
for t=s:T
    fprintf('starts calculating the %d weak classifier \n',t)
    weights = weights./sum(weights);
    [ eps_t,threshold,polarity,feature_name, e_i ] = best_classifier_picker( matlab_Path, combine_set, weights );

   %update the weights
   betta_t= eps_t/(1-eps_t);
   weights = weights.*(betta_t.^(1-e_i));
   
   feature_weight = log (1/betta_t);
   
   strong_classifier(t).feature_name = feature_name;
   strong_classifier(t).val = threshold;
   strong_classifier(t).polarity = polarity;
   strong_classifier(t).weight = feature_weight;
   strong_classifier(t).fibers_weights = weights;
   if (eps_t == eps)
      break; 
   end


end

end