%% Shared anatomy directory
% - Create it: /biac4/wandell/data/anatomy/HCP_{ID}

% - Move the T1 there. The T1w that is measured at the same resolution of the
% diffusion data is under: T1w/T1w_acpc_dc_restore_1.25.nii.gz 
clear all; close all; clc; 

%% Modify here

% where the HCP data is stored
dirHCP = '/sni-storage/wandell/data/LGNV123_HCP';

% unique number
subID = '100307';

%% define things

% subject directory
dirSub = fullfile(dirHCP, subID); 

% path of the t1 that is at the same resolution as the diffusion
pathT1_HCP = fullfile(dirSub, 'Anatomy', 'T1w_acpc_dc_restore_1.25.nii.gz'); 

%% define directories and paths
dirShareAnatomy = '/biac4/wandell/data/anatomy/';
dirShareAnatomySubject = fullfile(dirShareAnatomy, ['HCP_' subID]);

% make the shared anatomy folder if it does not already exist
if ~exist(dirShareAnatomySubject)
    mkdir(dirShareAnatomySubject)
end

% path and name of where we want to store the T1
pathT1_shared = fullfile(dirShareAnatomySubject, 't1.nii.gz');

%% apply a canonical xform to the HCP T1

nii = readFileNifti(pathT1_HCP); 
niiNew = niftiApplyCannonicalXform(nii);

% save to the shared anatomy
niiNew.fname = pathT1_shared; 
writeFileNifti(niiNew);

% save to the dirDiffusion
niiNew.fname = fullfile(dirSub, 't1.nii.gz');
writeFileNifti(niiNew)




