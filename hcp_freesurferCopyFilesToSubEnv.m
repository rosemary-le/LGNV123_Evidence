%% Copy over the Freesurfer outputs into 
% fsSubDir = getenv('SUBJECTS_DIR')
% 
% Because this is where some vista code assumes the data are stored

clear all; close all; clc; 

%% modify here

% directory with the subject's outputs
fsOutputs = '/sni-storage/wandell/data/LGNV123_HCP/100307/retTemplate/retTemplate_freesurfer/xhemi';

% name that we want to give the 
% HCP_100307, e.g.
subName = 'HCP_100307';

%% end modification section

% the freesurfer dir
fsSubDir = getenv('SUBJECTS_DIR'); 

% make the subject directory IF IT DOES NOT EXIST
chdir(fsSubDir)

if ~exist(subName, 'dir')
    mkdir(subName)
    
    %% copy over
    copyfile(fsOutputs, subName)
    % cmdstr = ['! cp -r ' fsOutputs ' ' fsSubDir];
    
end







