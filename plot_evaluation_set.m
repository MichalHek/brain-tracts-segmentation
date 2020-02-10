function plot_evaluation_set(positive_set, TP_fibers, fP_fibers)

% plot positive set
hax1 = subplot(1,2,1);
x = positive_set(:,1:3:60);
y = positive_set(:,2:3:60);
z = positive_set(:,3:3:60);
for i = 1:size(positive_set,1)
    plot3(x(i,:),y(i,:),z(i,:),'g');
    hold on
end


% plot detected tract
% hax1 = subplot(1,2,1);
x = TP_fibers(:,1:3:60);
y = TP_fibers(:,2:3:60);
z = TP_fibers(:,3:3:60);
for i = 1:size(TP_fibers,1)
    plot3(hax1,x(i,:),y(i,:),z(i,:),'blue');
    hold on
end
title('TP fibers');

% plot the original one
subplot(1,2,2);
x = fP_fibers(:,1:3:60);
y = fP_fibers(:,2:3:60);
z = fP_fibers(:,3:3:60);
for i = 1:size(fP_fibers,1)
    plot3(x(i,:),y(i,:),z(i,:),'red');
    hold on
end
title('FP fibers');

end