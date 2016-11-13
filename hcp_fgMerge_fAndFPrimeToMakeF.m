%% merge f and Fprime to make F
% assumes Fprime is already made
clear all; close all; clc; 
bookKeeping; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% number of rows will be the number of connectomes to create
% we will merge over the number of columns (assumption that there is 2 for code readability)
% assumption is that first column is in ROIsConnectomes and second column
% is in ROIsFiberGroups
list_fgsToMerge = {
    'LGN-V1_Benson-FPrimeFibers'      'LGN-V1_200fibers'
    'LGN-V2_Benson-FPrimeFibers'      'LGN-V2_200fibers' 
    'LGN-V3_Benson-FPrimeFibers'      'LGN-V3_200fibers' 
    };

list_fgNewNames = {
    'LGN-V1_Benson-FFibers'
    'LGN-V2_Benson-FFibers'
    'LGN-V3_Benson-FFibers'
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
    



