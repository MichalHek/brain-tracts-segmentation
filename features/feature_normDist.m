function [normDist] = feature_normDist( dataset )
%calculates the fiber's edges of each coordinate

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

d = sum(sqrt( (x(:,2:end)- x(:,1:end-1)).^2 + (y(:,2:end)- y(:,1:end-1)).^2 + (z(:,2:end)- z(:,1:end-1)).^2 ),2);

x_normDist = abs(x(:,1)- x(:,end))./d;
y_normDist = abs(y(:,1)- y(:,end))./d;
z_normDist = abs(z(:,1)- z(:,end))./d;

normDist = [ x_normDist, y_normDist, z_normDist];

end