function [ coreset_rslt , anat_label ] = calc_coreset( B_dataset, redrate )

% parameters:
linear_reduction = 0;
CRST_ITERNUM = 10;
res_coreset_pdf = 1; % resolution
res_3d_ind_struct = 1;

% for several reduction rates:
redratesnum = 1; % put here 1 if you want only 1 reduction rate

fullFiberNum = size(B_dataset.fibers,1);
if redratesnum>1
    [ ReducedSetSize, redrate ] = red( fullFiberNum, linear_reduction ,redratesnum);
else
    ReducedSetSize = round(fullFiberNum/redrate);
end


density_pdf = create_pdf( B_dataset.fibers,res_coreset_pdf);%calculating weights

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
coreset_rslt = B_dataset.fibers(Coreset(redratesnum).set,:);
anat_label = B_dataset.anat_trct_label(Coreset(redratesnum).set);
end