%% Scatter plots from the fe model
% Might be useful in figuring out why the strength of evidence of the
% LGN-V1 tract is not that strong, or it just might be busy work >.<
%
% Scatter plots:
% Fiber length and fiber weight
% RMSE and B0
% RMSE and FA

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% name of the life struct for the F fiber group. 
% assumes it is in dirDiffusion/LiFEStructs/
feName = 'LGN-V1_Benson-FFibers_N360_LiFEStruct.mat';

% name of f that was was used to create F
% assumes that this pdb file is in dirAnatomy/ROIsFiberGroups
fName = 'LGN-V1_200fibers.pdb';

plotName = {
    feName 
    'HCP100307'
    };

% path of the dt6 file
pathDt6 = '/sni-storage/wandell/data/LGNV123_HCP/100307/dti90trilin/dt6.mat';

%% end modification section

chdir(dirDiffusion);

% load the life struct
fePath = fullfile(dirDiffusion, 'LiFEStructs', feName); 
load(fePath)

% load the f fiber group so that we know how many fibers are in it
fPath = fullfile(dirAnatomy, 'ROIsFiberGroups', fName); 
f = fgRead(fPath);
f_numFibers = fgGet(f, 'nfibers');

%% rmse and FA

rmse = feGet(fe,'vox rmse'); % vector of length 291375


%% rmse and mean b0 signal
% Get the diffusion signal at 0 diffusion weighting (B0) for this voxel

b0sig = feGet(fe,'b0signalimage');
b0sigMean = mean(b0sig, 2); 

figure; 
plot(b0sigMean, rmse, '.'); 
xlabel('Mean B0 signal');
ylabel('RMSE');
title(plotName);
grid on;

%% fiber weight vs. fiber length
fweight = feGet(fe, 'fiberweights');
flen = fefgGet(fe.fg,'length');

figure; 
plot(flen, fweight, '.')
grid on
xlabel('Fiber length (mm)')
ylabel('Fiber weight')

title(plotName, 'fontweight', 'bold')

%% rmse versus FA
fa = fefgGet(fe.fg, 'fa', pathDt6)
