%% save a mrvista mat roi into a nifti
% [ni, roiName] = dtiRoiNiftiFromMat(matRoi,refImg,roiName,saveFlag)
% matRoi and refImg just need be the paths 
% NOTE that the matRoi is the path to the DIFFUSION ROI
% Use wm_xformROIs to xform functional to diffusion ROIs

close all; clear all; clc; 
bookKeeping; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307/'; 

% save the nifti
saveFlag = true;

%% loop over subjects

pathT1 = fullfile(dirAnatomy, 't1.nii.gz'); 

% assumption: we will save nifti rois in {sharedAnatomyDirectory}/ROIsNiftis
% make this directory if it does not exist
saveDir = fullfile(dirAnatomy, 'ROIsNiftis'); 
if ~exist(saveDir, 'dir')
    mkdir(saveDir)
end

% assumption: the diffusion rois are in {dirAnatomy}/ROIsMrDiffusion
dirROIs = fullfile(dirAnatomy, 'ROIsMrDiffusion'); 

% get the names and paths of all ROIs
chdir(dirROIs)
ROIS = dir; 

%% loop over ROIs
for jj = 1:length(ROIS)

    % check that element in dir is indeed a .mat file
    if ~ROIS(jj).isdir
        roiName = ROIS(jj).name; 
        roiPath = fullfile(dirROIs, [roiName]);

        % dtiRoiNiftiFromMat will save the nifti to whatever directory
        % we're currently in. TODO: fix this. 
        chdir(saveDir); 
        [ni, roiName] = dtiRoiNiftiFromMat(roiPath,pathT1,roiName,saveFlag);          
    end     
end


