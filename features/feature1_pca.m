function [ azimuth, elevation, varCoef] = feature_pca( dataset )
%calculates the fiber's length by euclidean distance

x = dataset(:,1:3:end);
y = dataset(:,2:3:end);
z = dataset(:,3:3:end);

FN = length(dataset(:,1));
azimuth = zeros(FN,3);
elevation = zeros(FN,3);
varCoef = zeros(FN,3);
   for i=1:FN
        curr_x = x(i,:)';
        curr_y = y(i,:)';
        curr_z = z(i,:)';
        
        [coeff,score,latent] = pca([curr_x,curr_y,curr_z]);
        [curr_azimuth,curr_elevation,~] = cart2sph(coeff(1,:),coeff(2,:),coeff(3,:));
        azimuth(i,:) = curr_azimuth;
        elevation(i,:) = curr_elevation;
        varCoef(i,:) = latent; 
   end
    
end

