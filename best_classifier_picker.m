function [ eps_t,best_threshold,best_polarity,best_feature_name, best_e_i ] = best_classifier_picker( matlab_Path, dataset, weights)%A_features
% Inputs: Dataset- a set of training images, A set of A_features and a
% compatible set of weights for the images.
% Outputs- the index of the chosen feature from the A_feature struct,
% together with its best threshold, best polarity and error epsilon_t.

% if iteration==1 %force geometrical features for 1st iteration
    gtFiles = dir([matlab_Path,'\features\','feature_*.m']);
    gtFiles = {gtFiles.name};
% else
%     gtFiles = dir([matlab_Path,'features\','feature_*.m']); %geometrical & statistical features
%     gtFiles1 = dir([matlab_Path,'features\','feature1_*.m']);%physical features
%     gtFiles = {gtFiles.name};
%     gtFiles1 = {gtFiles1.name};
%     gtFiles = [gtFiles,gtFiles1];
% end

featureNum = length(gtFiles);
fiberNum = size(dataset,1);
class = zeros(fiberNum,1);
if (fiberNum > 1000)
    Nt = 4;%even number
else
    Nt = 1;
end
% feature_vals = zeros(length(featureNum)+extraPlaces,fiberNum); use if
% we want to utilize running time (by knowing num of array vals from advance
feature_vals = [];
featre_comp = zeros(featureNum,1);
fprintf('--------------------\n');
fprintf('starts calculating features:\n\n')
tic
for i = 1:featureNum
    feature_name = gtFiles{i}(1:end-2);
    fprintf([feature_name,'\n'])
    feature_func = str2func(feature_name);%construct function handle from feature name
    feature_vals_curr = feature_func(dataset(:,1:60));
    featre_comp(i) = length(feature_vals_curr(1,:));
    feature_vals = [feature_vals, feature_vals_curr];
end
toc
feature_sum = length(feature_vals(1,:));

pos_idx = find(dataset(:,61)==1);
neg_idx = find(dataset(:,61)==0);
class(pos_idx) = 1;

%create the thresholds:
% add some noise
Akk = feature_vals;
Akk_noise = padarray(0.01*min(Akk),[fiberNum-1 0],'replicate','post').*randn(fiberNum,feature_sum);
Akk_sorted = sort(Akk + Akk_noise);
Akk_sorted =Akk_sorted(1:Nt:end,:);
% apply each of the features on the dataset and calc the classification errors
features_result = struct('result_mat',[],'polarity',[],'threshold',[],'eps_t',[]);
eps_t = inf;
best_feature = 0;
best_threshold = 0;
best_polarity = 1;
 downsampled = ceil(fiberNum/Nt);
% downsampled = fiberNum;
fprintf('\nfind the best feature\n'); 
resArr_curr = cell(4,feature_sum);

for k=1:feature_sum
    if ~(eps_t == eps)
        fprintf('feature number %d \n',k)
        result = bsxfun(@lt, Akk_sorted(:,k)', Akk(:,k));
        e_i = abs(bsxfun(@minus,result, class));
        class_error = bsxfun(@times, weights, e_i);
        error_summed_up = sum(class_error);
        error_summed_down = 1-error_summed_up;
        [minError_up,minidx_up] = min(error_summed_up);
        [minError_down,minidx_down] = min(error_summed_down);
        minError = min([minError_up,minError_down]);
        if minError == minError_up
            Idx = minidx_up;
            polarity = 1;
            selected_e_i = (e_i(:, Idx));
        else
            Idx = minidx_down;
            polarity = -1;
            selected_e_i = 1-(e_i(:, Idx));
        end
             
        
        features_result(k).polarity = polarity;
        features_result(k).threshold = Akk_sorted(Idx,k);
        features_result(k).eps_t = minError;
        fprintf('Classification error for current feature: %.4f\n',minError);
        tmp_arr = cumsum(featre_comp);
        tmp_idx = find(tmp_arr>=k);
        tmp_idx = tmp_idx(1);
        if ~(tmp_idx == 1)
            feature_name = [gtFiles{tmp_idx}(1:end-2),'_',num2str(k-tmp_arr(tmp_idx-1))] ;
        else
            feature_name = [gtFiles{tmp_idx}(1:end-2),'_',num2str(k)] ;
        end
        resArr_curr{1,k} = feature_name;
        resArr_curr{2,k} = Akk_sorted(Idx,k);
        resArr_curr{3,k} = polarity;
        resArr_curr{4,k} = minError;
        % update the best so far:
        if minError<eps_t
            eps_t = minError;
            if (eps_t == 0)
                eps_t = eps;
            end
            best_feature_name = feature_name;
            best_threshold = Akk_sorted(Idx,k);
            best_polarity = polarity;
            best_e_i = selected_e_i;
        end
    end
   
end

% resArr_new = cell(feature_sum,4);
% eps_t = Inf;
% % learning rate
% alpha = 0.01;
% % N = feature_sum*2;
% for k=1:feature_sum
% %     class(class==0) = -1;
% %% logistic regression
% % initialize parameters theta
% initialTheta = zeros(2,1);
% x = feature_vals(:,k);
% y = class;
% [J, grad] = computeCost(initialTheta, x, y);
% options = optimoptions('fminunc','GradObj','on');
% [optTheta, functionVal, exitFlag] = fminunc(@(t)computeCost(t,x,y), initialTheta, options);
% prediction = predict(optTheta, x);
% % b = glmfit(x,y,'binomial','link','logit');
% % thresh = -b(1)/b(2);
% resArr_new{k,1} = resArr_curr{1,k};
% featureVec = feature_vals(:,k);
% % featureVecSorted = Akk_sorted(:,k);
% % [x,y] = sort(featureVec);
% % featureLabel = dataset.anat_trct_label';
% % x = featureVec;
% % x = x-mean(x);
% % x_sorted = sort(featureVec-mean(featureVec))/std(featureVec);
% % x_sorted(end+1) = 0;
% % x_sorted = sort(x_sorted);
% % idx = find(x_sorted == 0);
% % y = featureLabel;
% sigmoid = 1./(1 + exp(-teta'*class));
% % sigmoid_noise = 1./(1 + exp(-featureVecSorted));
% figure;
% plot(teta,sigmoid); hold on
% x_sorted(idx) = [];
% plot(featureVec-mean(featureVec),class,'or'); hold on
% plot(ones(8,1)*x_sorted(find(sigmoid == 0.5)),linspace(0,1,8),'-g')
% % plot(x_sort,y_sort,'or');hold on
% % thresh = x_sorted(find(diff(sigmoid) == max(diff(sigmoid)))) + mean(featureVec);
% % d = diff(sigmoid);
% thresh = x_sorted(find(sigmoid ==0.5))+ mean(featureVec);
% resArr_new{k,2} = thresh;
% result1 = featureVec > thresh;
% result2 = featureVec < thresh;
% e_i = abs(result1-class);
% e_i_down = abs(result2-class);
% class_error = weights.*e_i;
% class_error_down = weights.*e_i_down;
% % class_error_down = 1 - class_error;
% Error_up = sum(class_error);
% Error_down = sum(class_error_down);
% minErr = min([Error_up,Error_down]);
% if minErr==Error_down
%     polarity = -1;
%     resArr_new{k,3} = polarity;
%     e_i = 1-e_i;
%     error_summed = sum(class_error_down);
% else
%     polarity = 1;
%     resArr_new{k,3} = polarity;
%     error_summed = sum(class_error);
% end
% if error_summed<eps_t
%     eps_t = error_summed;
%     if (eps_t == 0)
%         eps_t = eps;
%     end
%     best_feature_name = resArr_new{k,1};
%     best_threshold = thresh;
%     best_polarity = polarity;
%     best_e_i = e_i;
% end
% resArr_new{k,4} =  error_summed;
% hold on
% scatter (resArr_curr{2,k},1,'b');hold on;
% 
% end
% fprintf('---------------------\n');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [J, grad] = computeCost(initialTheta, x, y)
% 
% m = length(x);
% x = [ones(m,1) x];
% N = length(initialTheta);
% h = sigmoid(x*initialTheta);
% J = -(1/m) * sum(y .* log(h) + (1-y) .* log(1 - h));
% grad = zeros(N,1);
% for i = 1:N
%     grad(i) = (1/m)* sum( (h - y ).* x(:,i) );
% end
% 
% end
% 
% function [h] = sigmoid(x)
% 
% h = 1./(1 + exp(-x));
% 
% end
% 
% function [p] = predict(theta, x)
% 
% p = sigmoid([ones(length(x),1) x]*theta);
% 
% end