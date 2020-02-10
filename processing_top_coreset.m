% processing_top.m
% Here we process the HCP fiber-sets using clustering scheme and coreset
% scheme. the output is a structure of reduced sets per brain.
clc
clear all
today = date;

% parameters:
linear_reduction = 0;
replace_existing_files = 1;

BrainNames = {'100307'};
% BrainNames = {'100307','100408','101006','101107','101309','101410','101915'...
%     ,'102008','102311','102816','103111','103414','103818','104820','105014'};

BrainNum = numel(BrainNames);

CRST_ITERNUM = 10;
res_coreset_pdf = 2; % resolution
res_3d_ind_struct = 1;

% for several reduction rates:
redratesnum = 10; % put here 1 if you want only 1 reduction rate
% for single reduction:
redrate = 10;

location = 'laptop';

switch location
    case 'laptop'
        location_of_fibersets = 'C:\Guys folder\Master\Thesis\Data sets\HCP_full_fiber_sets';
        location_of_results = 'C:\Guys folder\Master\Thesis\My experiments\For_journal_paper_reduction\results';
        vlfeat_dir = 'C:\Guys folder\Master\Thesis\My experiments\vlfeat-0.9.19-bin\vlfeat-0.9.19\toolbox';
        addpath(location_of_results)
        diary_path = 'C:\Guys folder\Master\Thesis\My experiments\For_journal_paper_reduction\results\log_file.txt';
    case 'lab'
        location_of_fibersets = 'D:\Guy\HCP_full_fiber_sets';
        location_of_results = 'D:\Guy\Dropbox\MIPLAB sync\For_journal_paper\results';
        vlfeat_dir = 'D:\Guy\vlfeat-0.9.20\toolbox';
        addpath(location_of_results)
        diary_path = 'D:\Guy\Dropbox\MIPLAB sync\For_journal_paper\results\log_file.txt';
end

diary(diary_path)
diary off

%% start processing brains:
for k=1:BrainNum
    B_dataset = run_load_brain(location_of_fibersets,BrainNames{k}); %IMPLEMENTed
    fullFiberNum = size(B_dataset.fibers,1);
    if redratesnum>1
        [ ReducedSetSize, redrate ] = red( fullFiberNum, linear_reduction ,redratesnum);
    else
        ReducedSetSize = round(fullFiberNum/redrate);
    end
    fprintf('Starting building Coresets... \n') %TODO - update
    
    result_strct_crst = [BrainNames{k},'_crst_results'];
    A = exist([result_strct_crst,'.mat'],'file');
    if (A~=2 || replace_existing_files)
        tic;
        
        density_pdf = create_pdf( B_dataset.fibers,res_coreset_pdf);

        current_strct_crst = struct('density_pdf',density_pdf,'pdf_grid',res_coreset_pdf,'redrates',redrate,'full_reduced_sets',[]);
        hist_dist_C = zeros(1,redratesnum);
        Best_hist_dist_C = zeros(1,redratesnum);
        total_itr_for_update = 0;
        Coreset = struct('set',[],'hist_dist',[],'Weights',[],'WeightsC',[],'selected_groups',[]); % replace with the new struct
 
        for t=1:redratesnum             
        %% create the coreset:
            c = ReducedSetSize(t);
            last_itr_update = 1;
            for iter=1:CRST_ITERNUM
                [Coreset_idx,C_anat_labels,~,WeightsC] = density_coreset(B_dataset,density_pdf,c); %TODO - update B_dataset instead of fibers

        %% Calculate volume maps for the whole region (all groups):
                selected_groups.volume_map = run_volume_mapping_fib_idx( B_dataset.fibers, Coreset_idx ,res_3d_ind_struct);


        %% calc Hamming distance:
                reducLevel = ['red',num2str(t)];
                Label = ['red',num2str(t),'anatLabel'];
                hist_dist_C(t) = calc_hist_dists(selected_groups.volume_map);
                fprintf('Haming distance between original and reduced set at RedRate %d: %.2f \n',redrate(t),100*hist_dist_C(t));

            if iter==1
                Coreset(t).set = Coreset_idx;
                Coreset(t).hist_dist = hist_dist_C(t);
                Coreset(t).WeightsC = WeightsC;
                Coreset(t).selected_groups = selected_groups;
                Best_hist_dist_C(t) = hist_dist_C(t);
                current_strct_crst.full_reduced_sets.(reducLevel)=Coreset_idx;
                current_strct_crst.full_reduced_sets.(Label)=C_anat_labels;
            else
                if Coreset(t).hist_dist>hist_dist_C(t)
                    Coreset(t).set = Coreset_idx;
                    Coreset(t).hist_dist = hist_dist_C(t);
                    Coreset(t).WeightsC = WeightsC;
                    Coreset(t).selected_groups = selected_groups;
                    Best_hist_dist_C(t) = hist_dist_C(t);
                    current_strct_crst.full_reduced_sets.(reducLevel)=Coreset_idx;
                    current_strct_crst.full_reduced_sets.(Label)=C_anat_labels;
                    last_itr_update = iter;
                end  
            end

            end
            total_itr_for_update = total_itr_for_update+last_itr_update;
        end
        diary on
        fprintf('%s - Time to perform coreset reduction: %f \n',today,toc)
        fprintf('%s - mean iteration number needed for convergence: %f \n',today,total_itr_for_update/redratesnum)
        diary off        
        
        assignin('base', ['B',BrainNames{k},'_crst_results'],current_strct_crst);    
        savename = [location_of_results,'\',BrainNames{k},'_crst_results.mat'];
        save(savename,['B',BrainNames{k},'_crst_results'],'-v7.3')
    
    end 

   clear B_dataset 
end