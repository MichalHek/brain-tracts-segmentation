function plot_output_set(fibers,color)
figure
% plot all detected set including positive & negative
x = fibers(:,1:3:60);
y = fibers(:,2:3:60);
z = fibers(:,3:3:60);
for i = 1:size(fibers,1)
    plot3(x(i,:),y(i,:),z(i,:),'color',color);
    hold on
end
% axis off
title('L_UNC');

end