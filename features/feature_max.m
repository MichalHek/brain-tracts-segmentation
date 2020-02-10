function [max_xyz] = feature_max( dataset )
%calculates the fiber's maximum values

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

x_max = max(x,[],2);
y_max = max(y,[],2);
z_max = max(z,[],2);

max_xyz = [ x_max,y_max,z_max ];
end