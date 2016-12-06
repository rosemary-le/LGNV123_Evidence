%% merge f and Fprime to make F
% assumes Fprime is already made
clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% number of rows will be the number of connectomes to create
% we will merge over the number of columns (assumption that there is 2 for code readability)
% assumption is that first column is in ROIsConnectomes and second column
% is in ROIsFiberGroups
list_fgsToMerge = {
    'LGN-V1_1000fibers_cleaned-FPrimeFibers'      'LGN-V1_1000fibers_cleaned'
    'LGN-V2_1000fibers_cleaned-FPrimeFibers'      'LGN-V2_1000fibers_cleaned' 
    'LGN-V3_1000fibers_cleaned-FPrimeFibers'      'LGN-V3_1000fibers_cleaned' 
    };

list_fgNewNames = {
    'LGN-V1_1000fibers_cleaned-FFibers'
    'LGN-V2_1000fibers_cleaned-FFibers'
    'LGN-V3_1000fibers_cleaned-FFibers'
    };

%% do things

for jj = 1:size(list_fgsToMerge,1)

    fgsToMerge = list_fgsToMerge(jj,:);
    fgNewName = list_fgNewNames{jj};

    % assumption in this script is that there are only 2 to merge, and
    % that the  first column is in ROIsConnectomes and second column
    % is in ROIsFiberGroups
    fg1Name = fgsToMerge{1};
    fg2Name = fgsToMerge{2};
    fg1Path = fullfile(dirAnatomy, 'ROIsConnectomes', [fg1Name '.pdb']); 
    fg2Path = fullfile(dirAnatomy, 'ROIsFiberGroups', [fg2Name '.pdb']);

    %% load the fgs
    fg1 = fgRead(fg1Path); 
    fg2 = fgRead(fg2Path); 

    %% merge
    fgMerged = fgMerge(fg1, fg2);
    fgMerged.name = fgNewName;

    %% save
    chdir(fullfile(dirAnatomy, 'ROIsConnectomes'))
    fgWrite(fgMerged)

end
    



