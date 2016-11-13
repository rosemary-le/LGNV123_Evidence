%% merge the no endpoints and one endpoint fibers
% Name: ROIsConnectomes/LGN-V1_EveyrthingExcept_{numFibers}fibers.pdb

clear all; close all; clc; 

%% modify here

% subject's anatomy directory
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% number of rows will be number of new FGs to create
% the fgs in each row will be the fgs to merge
% assumption is that these fgs are in dirAnatomy/ROIsFiberGroups
% another assumption is that there are only 2 fgs that we want to merge,
% because of the use of fgMerge later
list_fgsToMerge = {
    'WholeBrainExcluding_LGN-V1_50000fibers'    'OneEndpoint_LGN-V1_Benson_1100fibers'
    'WholeBrainExcluding_LGN-V2_50000fibers'    'OneEndpoint_LGN-V2_Benson_1100fibers'
    'WholeBrainExcluding_LGN-V3_50000fibers'    'OneEndpoint_LGN-V3_Benson_1100fibers'
    };

list_fgMergedName = {
    'EverythingExcept_LGN-V1_Benson_51100fibers'
    'EverythingExcept_LGN-V2_Benson_51100fibers'
    'EverythingExcept_LGN-V3_Benson_51100fibers'
    };

% where we want to save the merged FG, relative to dirAnatomy
saveLoc = 'ROIsConnectomes';

%% do things

% make the dirSave if it does not exist
dirSave = fullfile(dirAnatomy, saveLoc);
if ~exist(dirSave,'dir')
    mkdir(dirSave);
end

for ff = 1:size(list_fgsToMerge,1)

    fgsToMerge = list_fgsToMerge(ff,:);
    fgNewName = list_fgMergedName{ff};

    fg1Name = fgsToMerge{1};
    fg2Name = fgsToMerge{2};
    fg1Path = fullfile(dirAnatomy, 'ROIsFiberGroups', [fg1Name '.pdb']);
    fg2Path = fullfile(dirAnatomy, 'ROIsFiberGroups', [fg2Name '.pdb']);

    % the individual fgs
    fg1 = fgRead(fg1Path);
    fg2 = fgRead(fg2Path);

    %% the merged fg
    fgNew = fgMerge(fg1, fg2); 
    fgNew.name = fgNewName;

    % save!
    chdir(dirSave)
    fgWrite(fgNew)

end



