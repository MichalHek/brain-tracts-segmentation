function [ d ] = feature_length( dataset )
%calculates the fiber's length by euclidean distance

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

d = sum(sqrt( (x(:,2:end)- x(:,1:end-1)).^2 + (y(:,2:end)- y(:,1:end-1)).^2 + (z(:,2:end)- z(:,1:end-1)).^2 ),2);


end

