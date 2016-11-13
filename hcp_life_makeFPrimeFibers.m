%% Define the path neighborhood PRIME of a tract of interest f
% Save it out as a fiber group (FPrime).
%
% Pseudo code: 
% Load all fibers that do not run from LGN to V(123)
% Load f and get its coordinates
% Get all fibers that interest f at some point

clear all; close all; clc; 

%% modify here

% paths
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307/';
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307/'; 

% the comprehensive connectome that we will restrict
% location is relative to dirAnatomy
% the number of rows equals the number of connectomes we will create
conComDir = 'ROIsConnectomes';
list_conComNames = {
    'EverythingExcept_LGN-V1_Benson_51100fibers.pdb'
    'EverythingExcept_LGN-V2_Benson_51100fibers.pdb'
    'EverythingExcept_LGN-V3_Benson_51100fibers.pdb'
    };

% the fiber group whose coordinates we will restrict the conCom to
% location is relative to dirAnatomy
fDir = 'ROIsFiberGroups';
list_fNames = {
    'LGN-V1_200fibers.pdb'
    'LGN-V2_200fibers.pdb'
    'LGN-V3_200fibers.pdb'
    };  

% Prime name
list_saveNames = {
    'LGN-V1_Benson-FPrimeFibers'
    'LGN-V2_Benson-FPrimeFibers'
    'LGN-V3_Benson-FPrimeFibers'
    };

% where to save, relative to dirAnatomy
saveDir = 'ROIsConnectomes';

%% do things

chdir(dirDiffusion); 
% number of connectomes to create
numCons = length(list_fNames); 

for jj = 1:numCons

    conComName = list_conComNames{jj};
    fName = list_fNames{jj};
    saveName = list_saveNames{jj};
    
    %% comprehensive connectome
    conComPath = fullfile(dirAnatomy, conComDir, conComName);
    conCom = fgRead(conComPath);

    %% load the fiber group
    % We want to restrict the comprehensive connectome  
    % to coordinates of a specific fiber group. Load the fiber group so we
    % can get the coordinates
    fPath = fullfile(dirAnatomy, fDir, fName); 
    f = fgRead(fPath); 

    %% convert the fiber group to a mrDiffusion roi so that we can use dtiIntersectFibersWithRoi
    % roi = dtiCreateRoiFromFibers(fg,saveFlag)
    roi = dtiCreateRoiFromFibers(f,0); 

    %% Define new fiber groups
    % F: the tract of interest plus all intersecting fibers
    [F, ~, keep] = dtiIntersectFibersWithRoi([],{'and'}, [], roi, conCom); 
    F.name = saveName;

    %% Saving
    chdir(fullfile(dirAnatomy, saveDir));

    % save F, the path neighborhood (all fibers intersecting the tract,
    % plus the tract f)
    fgWrite(F, F.name, 'pdb')

end
