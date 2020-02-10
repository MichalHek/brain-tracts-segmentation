function [edges] = feature_edges( dataset )
%calculates the fiber's edges of each coordinate

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);
x_up = x(:,1);
x_down = x(:,end);
y_up = y(:,1);
y_down = y(:,end);
z_up = z(:,1);
z_down = z(:,end);

edges = [ x_up, y_up, z_up, x_down, y_down, z_down];

end