function [box] = feature_BoundingBox( dataset )
%calculates the fiber's minimum values

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

x_min = min(x,[],2);
y_min = min(y,[],2);
z_min = min(z,[],2);

x_max = max(x,[],2);
y_max = max(y,[],2);
z_max = max(z,[],2);

box = [ x_max-x_min,y_max-y_min,z_max-z_min ];
end