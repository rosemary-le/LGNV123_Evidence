%% After fitting the model, define the set of optimized fibers from candidate fibers
% We want to save new 

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% names of the feStructs
% the fgs here are in image space
list_feStructs = {
    'LGN-V1_1000fibers_cleaned-FFibers_N360_LiFEStruct.mat'
    'LGN-V2_1000fibers_cleaned-FFibers_N360_LiFEStruct.mat'
    'LGN-V3_1000fibers_cleaned-FFibers_N360_LiFEStruct.mat'
    };

% corresponding names of the fiber groups the feStructs were run on
% these are in acpc space, which is what we want to save the new fg as
list_fgNames = {
    'LGN-V1_1000fibers_cleaned-FFibers'
    'LGN-V2_1000fibers_cleaned-FFibers'
    'LGN-V3_1000fibers_cleaned-FFibers'
    };

% location of the corresponding fiber groups, relative to dirAnatomy
fgLoc = 'ROIsConnectomes';

% where we want to save the new fgs
dirSave = fullfile(dirAnatomy, 'ROIsConnectomes'); 

%% end modification section

% number of new fgs to make
numFgs = length(list_feStructs);


for jj = 1:numFgs
    
    fePath = fullfile(dirDiffusion, 'LiFEStructs', list_feStructs{jj}); 
    fgPath = fullfile(dirAnatomy, fgLoc, [list_fgNames{jj} '.pdb']);
    
    %% load the fe struct -- variable called fe
    load(fePath); 
    
    %% load the fg
    fg = fgRead(fgPath)
    
    %% Weights
    
    % weights of all the fibers
    w = feGet(fe, 'fiberweights'); 
    
    % indices of fibers with non-zero weights
    w_indNonZero = find(w > 0); 
    
    %% Extract the fibers with positive weight
    fgPositive = fgExtract(fg, w_indNonZero,'keep'); 
    
    % rename and save
    fgPositive.name = [fg.name '-positiveWeights']; 
    chdir(dirSave);
    fgWrite(fgPositive); 
   
    
end



