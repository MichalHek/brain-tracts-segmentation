function deriv = feature_secondDeriv(dataset)


deriv = diff(dataset,2,2);
% quarter_length = ceil(length(deriv(:,1))/4);
% averagedDerivativePerquarter = zeros(4,3);
% for i = 0:3
%     if i<3
%         averagedDerivativePerquarter(i+1,:) = mean(deriv(quarter_length*i+1:quarter_length*(i+1),:));
%     else
%         averagedDerivativePerquarter(i+1,:) = mean(deriv(quarter_length*i+1:length(deriv(:,1)),:));
%     end
% end
% averagedDerivativePerquarter = averagedDerivativePerquarter';
% averagedDerivativePerquarter = averagedDerivativePerquarter(:)';
% 
end
