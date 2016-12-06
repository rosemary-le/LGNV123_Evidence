%% Convert from freesurfer label files to nifti files
% Benson nifti outputs currently do not distinguish between the left and right
% hemisphere. If we want left and right separately, we will convert the
% freesurfer label files. This scripts converts the label files into nifti
% files.
%
% ASSUMPTIONS:
% That the unzipped freesurfer outputs are stored here:
% {dirDiffusion}/retTemplate/retTemplate_freesurfer/

clear all; close all; clc; 

%% modify here

% subject's directory. assumes that within this directory, the freesurfer
% outputs are stored in retTemplate/retTemplate_freesurfer/
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% full path of anatomical t1
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307/';

% location of the label files relative to dirDiffusion
locLabels = 'retTemplate/retTemplate_freesurfer/label';

% list of the label files we want to convert to niis
list_files = {
    'lh.V1.label'
    'lh.V2.label'
    'lh.V3.label'
    'rh.V1.label'
    'rh.V2.label'
    'rh.V3.label'
    };

% location to save the nifti roi file relative to dirAnatomy
dirSave = fullfile(dirAnatomy, 'ROIsNiftis');

% subject's directory in the FS dir: getenv('SUBJECTS_DIR')
fs_subject = 'HCP_100307';



% [niftiRoiName, niftiRoi] = 
% fs_labelFileToNiftiRoi(fs_subject,labelFileName, ...
% niftiRoiName,[hemisphere],[regMgzFile],[smoothingKernel])
    

%% define things

% number of files to convert
numFiles = length(list_files);

% path of t1
pathT1 = fullfile(dirAnatomy, 't1.nii.gz');

%% do the converting

for jj = 1:numFiles
    
    fName = list_files{jj};
    labelFileName = fullfile(dirDiffusion, locLabels, fName); 
        
    % niftiRoiName  - The fullpath to the .nii.gz file that will
    % be saved out. With NO .nii.gz extension.
    niftiPath = fullfile(dirSave,[fName]); 
    
    % 
    [niftiPath, niftiRoi] = fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiPath, 'lh',[],0); 
    
end

%% the code below works (and is from Jon
% 
% % debugging some FS calls
% % with some help from Jon
% 
% % Get freesurfer directory
% fssubjectsdir = getenv('SUBJECTS_DIR');
% 
% % Download ernie freesurfer directory if needed
% forceOverwrite = false;
% dFolder = mrtInstallSampleData('anatomy/freesurfer', 'ernie', ...
% fssubjectsdir, forceOverwrite);
% 
% labelFileName = fullfile(dFolder, 'label', 'lh.V1.label');
% niftiRoiName = 'lh_V1';
% fs_labelFileToNiftiRoi('ernie', labelFileName,niftiRoiName, 'lh',[],0);

