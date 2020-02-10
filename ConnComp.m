function [result] = ConnComp(classified_fibers,trct_name)

CC = bwconncomp(classified_fibers); % find components
stats = regionprops(CC, 'centroid');

%% L_UNC
TP = zeros();
ind = 1;
if strcmp('L_UNC',trct_name)
    for ii = 1:CC.NumObjects
        centroid = stats(ii).Centroid;
        if centroid(1)<=60 & centroid(1)>=10 & centroid(3)<=23 & centroid(3)>=7 & centroid(2)<=60 & centroid(2)>=35
            TP(ind:ind+length(CC.PixelIdxList{ii})-1) = CC.PixelIdxList{ii};
            ind = ind + length(CC.PixelIdxList{ii});
        end
    end
    
elseif strcmp('R_CS',trct_name)
    for ii = 1:CC.NumObjects
        centroid = stats(ii).Centroid;
        if centroid(1)<=63 & centroid(1)>=25 & centroid(3)<=40 & centroid(3)>=10 & centroid(2)<=33 & centroid(2)>=15
            TP(ind:ind+length(CC.PixelIdxList{ii})-1) = CC.PixelIdxList{ii};
            ind = ind + length(CC.PixelIdxList{ii});
        end
    end
elseif strcmp('MCP',trct_name)
    for ii = 1:CC.NumObjects
        centroid = stats(ii).Centroid;
        if centroid(1)<=67 & centroid(1)>=41 & centroid(3)<=20 & centroid(3)>=8 & centroid(2)<=53 & centroid(2)>=14
            TP(ind:ind+length(CC.PixelIdxList{ii})-1) = CC.PixelIdxList{ii};
            ind = ind + length(CC.PixelIdxList{ii});
        end
    end
end
mask = zeros(size(classified_fibers,1),size(classified_fibers,2),size(classified_fibers,3));
mask(TP) = 1;
result = mask;
% displayVolumeSliceGUI(mask);
end