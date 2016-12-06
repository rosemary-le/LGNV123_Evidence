%% script to initialize dti data (dt6.mat file)
% can either run for subjects individually, or run as a loop
clear all; close all; clc; 

%% modify here

% subject directory relative to dirHCP
locSub = '100408';

% location of Diffusion data relative to locSub
locData = 'DiffusionRawAndExtracted';


%% define things here

% directory with hcp data
dirHCP = '/sni-storage/wandell/data/LGNV123_HCP';

% anatomy directory
dirAnatomy = ['/biac4/wandell/data/anatomy/HCP_' locSub]; 

% path of subjects' acpc'd t1.nii.gz
t1Path = fullfile(dirAnatomy, 't1.nii.gz'); 

% subject directory
dirSubject = fullfile(dirHCP, locSub);

% dirDiffusion contains:
% bvals
% bvecs
% data.nii.gz
% nodif_brain_mask.nii.gz -- brain mask in diffusion space
% subject's dti data path including /Diffusion
dirDiffusion = fullfile(dirSubject, locData); 

% path of the extracted 2000 dti nifti
niiPath     = fullfile(dirDiffusion, 'dwi_2000.nii.gz');
% path of the extracted 2000 bvec file
bvecPath    = fullfile(dirDiffusion, 'dwi_2000.bvec');
% path of the extracted 2000 bval file
bvalPath    = fullfile(dirDiffusion, 'dwi_2000.bval'); 

% create initial dti parameters
dwParams    = dtiInitParams; 

% edit these dti parameters
dwParams.bvecsFile = bvecPath;
dwParams.bvalsFile = bvalPath;

% anatomy nifti
niiAnatomy = readFileNifti(t1Path);

% millimeters per voxel - specify it to have the same resolution as the
% anatomy
mmPerVox            = niiAnatomy.pixdim(1:3);
dwParams.dwOutMm    = mmPerVox; 
dwParams.clobber    = 1; % any existing files silently overwritten

% phase encoding direction
% From the HCP manual -- data is acquired left-to-right
% (1= L/R 'row', 2 = A/P 'col')
dwParams.phaseEncodeDir = 1; 

% Rotate bvecs using Rx or CanXform
dwParams.rotateBvecsWithRx       = false;
dwParams.rotateBvecsWithCanXform = true; 

%% move a copy of the anatomy to the subject's directory (because dtiInit wants it)
copyfile(t1Path,dirSubject);

%% do dti init!
chdir(dirDiffusion)
dtiInit(niiPath, t1Path, dwParams);


