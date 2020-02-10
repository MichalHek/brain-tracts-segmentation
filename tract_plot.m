function tract_plot(dataset,redrate,trct_name,full_path_to_brain,datatype,clustered,QB,ds_rate)
% full_path_to_brain ='C:\Guys folder\Master\Thesis\Data sets\HCP_full_fiber_sets\100307.mat'
% Example: tract_plot(brain3_ds_crst_results,10,'CC','C:\Guys folder\Master\Thesis\Data sets\HCP_full_fiber_sets\brain3_ds.mat','reduced_set',10)
coreset_res = 2;
res_3d = 2;


    switch datatype
        case 'original_set'
            fibers = dataset.fibers;
            labels = dataset.anat_trct_label;            
        case 'reduced_set'
            fibname = ['red',num2str(redrate)];
            fibers = dataset.full_reduced_sets.(fibname);
            labelname = ['red',num2str(redrate),'anatLabel'];
            labels = dataset.full_reduced_sets.(labelname); 
            load(full_path_to_brain)
        case 'crst_res_rsrch'
            fibers = dataset.coreset_package.reduced_sets{coreset_res,redrate,res_3d};
            labels = dataset.coreset_package.anat_trct_label{coreset_res,redrate,res_3d};
            load(full_path_to_brain)
    end 
    
    label_idx = trct_encoder(trct_name);
    fibers_idx = find(labels==label_idx);
    fiber_num = length(fibers_idx);
    clrs = jet(floor(fiber_num/ds_rate));
    if strcmp(datatype,'original_set')
        trct_fibers = fibers(fibers_idx,:);
    else
        if clustered || QB
            trct_fibers = reconstruct_reduced(B_dataset.fibers,fibers(fibers_idx),QB&&~clustered);
            else
            	trct_fibers = B_dataset.fibers(fibers(fibers_idx),:); 
        end
    end
    for k=1:(floor(fiber_num/ds_rate))
                hold on;
                current_clr=clrs(k,:);
                plot3(trct_fibers(ds_rate*k,1:3:end),trct_fibers(ds_rate*k,2:3:end),trct_fibers(ds_rate*k,3:3:end),'color',current_clr,'linewidth',2,'linestyle','-');
                hold on;

    end
    grid on
    view(3)
end