%% The subset of the fibers in F and FPrime which have non-zero weights
% For visualization purposes

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% name of the life struct for the fiber group. 
% assumes it is in dirDiffusion/LiFEStructs/
feName = 'LGN-V1_1000fibers_cleaned-FFibers_N360_LiFEStruct.mat';

% name and location of the fiber group that the fe struct is made from
% location is relative to dirAnatomy
fgLoc = 'ROIsConnectomes';
fgName = 'LGN-V1_1000fibers_cleaned-FFibers.pdb';

% save name and directory
[~,baseName] = fileparts(fgName); 
newNamePositive = [baseName '-positiveFibers']; 
newNameZero = [baseName '-zeroFibers'];
saveDir = fullfile(dirAnatomy, 'ROIsConnectomes');

%% end modification section

chdir(dirDiffusion)

% load the fiber group
fgPath = fullfile(dirAnatomy, fgLoc, fgName); 
fg = fgRead(fgPath);

% load the life struct
fePath = fullfile(dirDiffusion, 'LiFEStructs', feName); 
load(fePath)


%% the weights
% get all of them
w_all = feGet(fe, 'fiberweights'); 

% indices of fibers whose weights are positive
w_indNonZero = find(w_all > 0); 

% indices of fiber whose weights are zero
w_indZero = find(w_all == 0); 

% total number of fibers and 
% number of fibers with non zero weights
numFibers = length(w_all); 
numNonZeroFibers = length(w_indNonZero); 


%% make the new fiber group

fgPositive = fgExtract(fg, w_indNonZero, 'keep'); 

fgZero = fgExtract(fg, w_indZero, 'keep');

chdir(saveDir); 
% rename and save
fgPositive.name = newNamePositive; 
fgWrite(fgPositive); 

fgZero.name = newNameZero; 
fgWrite(fgZero); 





