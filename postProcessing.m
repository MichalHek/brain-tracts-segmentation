function [ pos_class_fibers ] = postProcessing( posclasfibers,whole_brain_voxels,whole_brain,trct_name )
%CC--> morphological operator
% save('posclasfibers.mat');
if strcmp(trct_name,'R_CS')
    N = 5;
else
    N = 3;
end
after_Morph = MorphOP(posclasfibers,whole_brain_voxels,N);
result = ConnComp(after_Morph,trct_name);
pos_class_fibers = vox2fib(result,posclasfibers,whole_brain);

end

