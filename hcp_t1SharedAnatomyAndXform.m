%% Shared anatomy directory
% - Create it: /biac4/wandell/data/anatomy/HCP_{ID}

% - Move the T1 there. The T1w that is measured at the same resolution of the
% diffusion data is under: T1w/T1w_acpc_dc_restore_1.25.nii.gz 
clear all; close all; clc; 

%% Modify here

% where the HCP data is stored
dirHCP = '/sni-storage/wandell/data/LGNV123_HCP';

% unique number
subID = '100408';

% name of anatomy file WITHOUT nii.gz extension
nameAnatomy = 'T1w_acpc_dc_restore_1.25'; 

% new for the canonical xformed t1:
newName = 't1.nii.gz';

%% define things

% subject directory
dirSub = fullfile(dirHCP, subID); 

% path of the t1 that is at the same resolution as the diffusion
pathT1_HCP = fullfile(dirSub, 'Anatomy', [nameAnatomy '.nii.gz']); 

% shared anatomy directory
dirShareAnatomy = '/biac4/wandell/data/anatomy/';
dirAnatomy = fullfile(dirShareAnatomy, ['HCP_' subID]);

% make the shared anatomy folder if it does not already exist
if ~exist(dirAnatomy)
    mkdir(dirAnatomy)
end

%% move the original HCP T1 to shared anatomy directory
copyfile(pathT1_HCP, dirAnatomy); 

%% make a canonical xform of the orginal HCP T1
nii = readFileNifti(pathT1_HCP); 
niiNew = niftiApplyCannonicalXform(nii); 
niiNew.fname = newName; 

chdir(dirAnatomy); 
writeFileNifti(niiNew); 
