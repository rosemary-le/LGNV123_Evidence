%% Merge the whole brain connectome and the tract of interest

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% whole brain connectome. for faster code, only load it once.
% location relative to dirAnatomy
conLoc = 'ROIsConnectomes';
conName = 'WholeBrain500000.pdb';

% fibers to merge with whole brain connectome
% can be a list. location relative to dirAnatomy
fgLoc = 'ROIsFiberGroups';
list_fgNames = {
    'LGN-V1_1000fibers.pdb'
    'LGN-V2_1000fibers.pdb'
    'LGN-V3_1000fibers.pdb'
    };

% where to save the merged fg
dirSave = fullfile(dirAnatomy, 'ROIsConnectomes'); 

% new names of the merged connectome
% assumption: it will be:
% {conName}_mergedWith_{fgName}.pdb
% Ex: 'WholeBrain500000_mergedWith_LGN-V3_1000fibers.pdb'

%% end modification section

% load the whole brain connectome
conPath = fullfile(dirAnatomy, conLoc, conName); 
con = fgRead(conPath); 

[~,conBase] = fileparts(conPath); 

%%

for jj = 1:length(list_fgNames)
    
    % read in the fiber group
    fgName = list_fgNames{jj};
    fgPath = fullfile(dirAnatomy, fgLoc, fgName); 
    fgTract = fgRead(fgPath); 

    % new name of the merged connectome
    fgMergedName = [conBase '_mergedWith_' fgName]; 

    % the merging and saving
    fgMerged = fgMerge(con, fgTract); 
    fgMerged.name = fgMergedName; 

    chdir(dirSave); 
    fgWrite(fgMerged); 
       
end
