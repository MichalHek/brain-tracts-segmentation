function [ pdf ] = pdf_calc( inv_density,fibers,hist_dim, res )
FN = size(fibers,1);
dotperfiber = size(fibers,2)/3;
x_idx = 1:3:size(fibers,2)-2;
y_idx = 2:3:size(fibers,2)-1;
z_idx = 3:3:size(fibers,2);

mincoor_pre = min(fibers,[],1);
mincoor = [min(mincoor_pre(x_idx)),min(mincoor_pre(y_idx)),min(mincoor_pre(z_idx))];

temp=repmat(mincoor,FN,dotperfiber);
fibersquant = fibers-temp;
fibersquant = floor(fibersquant./res)+1;

x_coor = reshape(fibersquant(:,x_idx)',FN*dotperfiber,1);
y_coor = reshape(fibersquant(:,y_idx)',FN*dotperfiber,1);
z_coor = reshape(fibersquant(:,z_idx)',FN*dotperfiber,1);
idx=sub2ind(hist_dim, x_coor,y_coor,z_coor);

pdf = zeros(1,FN);
for i=1:FN
    pdf(i) = nanmean(inv_density(idx((i-1)*dotperfiber+1:i*dotperfiber)));
end
pdf = pdf/sum(pdf);
end
