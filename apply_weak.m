function [ h_t ] = apply_weak(fibers ,strong_classifier)

setSize = size(fibers,1);
name = strong_classifier.feature_name;

feature_str = strsplit(name,'_');
feature_name = [feature_str{1},'_',feature_str{2}];
k = str2num(feature_str{3});
feature_func = str2func(feature_name);%construct function handle from feature name
feature_vals_curr = feature_func(fibers(:,1:60));
Akk = feature_vals_curr(:,k);

threshold = (strong_classifier.val)*ones(setSize,1);
polarity = (strong_classifier.polarity)*ones(setSize,1);

if polarity==1
    h_t = (Akk>threshold);
else
    h_t = (Akk<threshold);
end

end




