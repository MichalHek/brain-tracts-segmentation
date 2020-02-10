function [center] = feature_center( dataset )
%calculates the fiber's centroid
% dataset = gpuArray(dataset);
x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

x_center = mean(x,2);
y_center = mean(y,2);
z_center = mean(z,2);

center = [ x_center,y_center,z_center ];
end
