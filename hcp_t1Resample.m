%% Resample the T1 to be 1mm isotropic voxels
% Hopefully this will fix the LiFE code crashing in 
% FINALIZE ON SOMEONE THAT THIS RUNS

clear all; close all; clc; 

%% modify here

% subject's shared anatomy directory
% ASSUMPTIONS: 
% * There is a t1 named ___ and that this is the t1 we want to resample
% * The resampled t1 will also be saved to this directory
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% name of nresampled t1
t1NewName = 't1.nii.gz'; 

% resample size
outMm = [1 1 1]; 

%% do things
% t1 to resample, full path
t1File = fullfile(dirAnatomy, 'T1w_acpc_dc_restore_1.25_xform.nii.gz');

% new t1 name, full path
outT1FileName = fullfile(dirAnatomy, t1NewName); 

% do it
mrAnatResampleT1(t1File, outT1FileName, outMm);
