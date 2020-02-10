function [ B_dataset ] = run_load_brain(location_of_fibersets,brain_name )
% fibers structure: this is a matrix N x 60, in which every line is a fiber

filename = [location_of_fibersets,'\',brain_name,'.mat'];
load(filename)

assert(size(B_dataset.fibers,2)==60,'The fiberset you loaded doesnt have 60D vectors as its lines')
end

