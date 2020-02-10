function [ fibers_classification ] = run_cascade( cascade, data_set )
tic
%  load('mmmm');
SetSize = size(data_set,1);
StageNum = numel(cascade);
temp_class = ones(SetSize,1);
indices = find(temp_class);
for k=1:StageNum
    T = numel(cascade(k).strong_classifier);
    H =zeros(SetSize,1);
    threshold =zeros(SetSize,1);
    for t=1:T
        h_t = apply_weak(data_set(find(temp_class),:),cascade(k).strong_classifier(t));
        H = H + h_t*cascade(k).strong_classifier(t).weight;
        threshold = threshold + (cascade(k).strong_classifier(t).weight)*ones(SetSize,1);
    end
    threshold = 0.5*threshold*cascade(k).param_tresh;
    temp_class(indices) = (H>=threshold).*temp_class(indices);
    indices = find(temp_class);
    SetSize = sum(temp_class);
end
fibers_classification = temp_class;
fprintf('%f \n',toc)
end
