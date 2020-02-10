function [weights, combined_training_set] = run_combine_training_set(training_set_negative,training_set_positive )

lastN = size(training_set_negative,1);%numel(training_set_negative);
lastP = size(training_set_positive,1);%numel(training_set_positive);
combined_training_set = [training_set_positive;training_set_negative];
w_upper = (1/lastP)*ones(lastP,1);%why not: length(lastN)/(length(lastN)+length(lastP));
w_lower = (1/lastN)*ones(lastN,1);
weights = [w_upper;w_lower];

% save('combined_training_set.mat','combined_training_set','weights');
end