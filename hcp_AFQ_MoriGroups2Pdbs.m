%% Convert the afq outputs into pdb files
% The {dirDiffusion}/{dt6Dir}/fibers/ directory has these files:
% MoriGroups_Cortex.mat
% MoriGroups_Cortex_clean_D5_L4.mat
%
% Loading these mat files gives us a variable called fg
% fg is a 1x20 struct

% --> Save each cell of fg as its own fiber group!

clear all; close all; clc; 

%% modify here

% subject's shared anatomy directory
% we will save the pdbs in: {dirAnatomy}/ROIsFiberGroups
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307/';

% subject directory
dirSubject = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% location of the afq output relative to dirSubject:  
moriLoc = 'dti90trilin/fibers/MoriGroups_Cortex.mat';



%% end modification section

% full path of the MoriGroups
moriPath = fullfile(dirSubject, moriLoc);

% load it
% should load a variable called fg
load(moriPath);

%% make the save directory if it does not exist
dirSave = fullfile(dirAnatomy, 'ROIsFiberGroups'); 
if ~exist(dirSave)
    mkdir(dirSave)
end

chdir(dirSave)

%% loop over the fiber groups indicated in the MoriGroups_Cortex.mat


for ii = 1:length(fg)
   
    tem = fg(ii); 
    fgWrite(tem);
    
end


