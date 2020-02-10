function [ positive_set, negative_set] = get_trct( B_dataset, trct_name )
% clc; clear all; close all;
% load('C:\Users\a0mar\Documents\Rula Amer\final project\matlab files\Matlab files\100307.mat')
% trct_name = 'R_CS';
%B_dataset: Training brains
%trct_name: wanted tract
num_neg = 2000;
num_pos = 20000;
trct_number = trct_encoder( trct_name );
AllFibersBelongToTract = B_dataset.fibers(B_dataset.anat_trct_label==trct_number,:);
AllFibersNotBelongToTract = B_dataset.fibers(B_dataset.anat_trct_label~=trct_number,:);
positive_set = AllFibersBelongToTract(randsample(size(AllFibersBelongToTract,1),num_pos),:); %randomize 20,000 fibers from all the fibers belong to the specified tract
positive_set(:,size(positive_set,2)+1) = 1;
negative_set = AllFibersNotBelongToTract(randsample(size(AllFibersNotBelongToTract,1),num_neg),:); %randomize 20,000 fibers from all the fibers are not belong to the specified tract
negative_set(:,size(negative_set,2)+1) = 0;
% b = length(B_dataset.fibers);
% a = 1;
% negative_set_idx = ceil((b-a)*rand(1,2e4) + a);%randomize 20,000 fibers indices between 1- 1,000,00
% unwanted_idx = find(B_dataset.anat_trct_label==trct_number);%indices belong to positive set which we dont want for negative set
% trct_label_tmp = B_dataset.anat_trct_label;
% trct_label_tmp(negative_set_idx) = 100;
% trct_label_tmp(unwanted_idx) = trct_number;%not taking tracts belong to positive set
% negative_set = B_dataset.fibers(trct_label_tmp==100,:);
% negative_set(:,size(negative_set,2)+1) = 0;
end

