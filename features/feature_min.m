function [min_xyz] = feature_min( dataset )
%calculates the fiber's minimum values

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

x_min = min(x,[],2);
y_min = min(y,[],2);
z_min = min(z,[],2);


min_xyz = [ x_min,y_min,z_min ];
end