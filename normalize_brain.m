function  normalize_brain()
% the function takes a chosen brain, devides it to its x,y,z coordinates
% and in case of a minimum value- normalizes the relevant coordinate
matlab_Path = 'D:\Guy\HCP_full_fiber_sets\Brains_norm\';
gtFiles = dir([matlab_Path,'*.mat']);
gtFiles = {gtFiles.name};
isSaveBrain = 0;

for i =1:length(gtFiles)
    load([matlab_Path,gtFiles{i}]);
    x = B_dataset.fibers(:,1:3:end);
    y = B_dataset.fibers(:,2:3:end);
    z = B_dataset.fibers(:,3:3:end);
    
    min_x = min(min(x));
    min_y = min(min(y));
    min_z = min(min(z));
    
    if (min_x < 0)
        x = x + abs(min_x);
        B_dataset.fibers(:,1:3:end) = x;
        isSaveBrain = 1;
    elseif (min_x > 0)
        x = x - min_x;
        B_dataset.fibers(:,1:3:end) = x;
        isSaveBrain = 1;
    end
    
    if (min_y < 0)
        y = y + abs(min_y);
        B_dataset.fibers(:,2:3:end) = y;
        isSaveBrain = 1;
    elseif (min_y > 0)
        y = y - min_y;
        B_dataset.fibers(:,2:3:end) = y;
        isSaveBrain = 1;
    end
    
    if (min_z < 0)
        z = z + abs(min_z);
        B_dataset.fibers(:,3:3:end) = z;
        isSaveBrain = 1;
    elseif (min_z > 0)
        z = z - min_z;
        B_dataset.fibers(:,3:3:end) = z;
        isSaveBrain = 1;
    end
    
    min_x = min(min(x));
    min_y = min(min(y));
    min_z = min(min(z));
    if  (isSaveBrain)
        fprintf('brain %d was moved successfully!\n',i);
        save([matlab_Path,gtFiles{i}],'B_dataset');
    else
        fprintf('didnt save brain %d\n',i);
    end
    
end




end

