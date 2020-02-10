function [chosen,C_anat_labels,Weights,WeightsC] = density_coreset(B_dataset,pdf,c)

idxs = 1:size(B_dataset.fibers,1);
chosen = datasample(idxs,c,'Weights',pdf,'Replace',false);
C_anat_labels = B_dataset.anat_trct_label(chosen);
Weights = 1./(c*pdf);
WeightsC = Weights(chosen);

end

