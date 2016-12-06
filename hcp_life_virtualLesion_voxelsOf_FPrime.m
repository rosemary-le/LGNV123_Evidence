%% Virtual lesion method: Plot the RMSE distribution of voxels v(f) 
% For two models: one that is fit with f, and one that is fit lesioned f.
%
% Assumes the fe struct has been computed for each of the connectomes
% refits the model for the optimized connectome

clear all; close all; clc;
bookKeeping; 

%% modify here
tic

% shared anatomy directory
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% subject's diffusion directory
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% {ConnectomeName}_N{N}_LiFEStruct.mat
% 1st connectome FE STRUCT location, relative to dirDiffusion
% This is F: the path neighborhood of f
feStruct1Loc = 'LiFEStructs/LGN-V1_1000fibers_cleaned-FFibers_N360_LiFEStruct.mat';

% 2nd connectome FE STRUCT location, relative to dirDiffusion
% This is F': F - f
feStruct2Loc = 'LiFEStructs/LGN-V1_1000fibers_cleaned-FPrimeFibers_N360_LiFEStruct.mat';

% Specify the fiber tract that was used to define F and F'
% relative to dirAnatomy
fLoc = 'ROIsFiberGroups/LGN-V1_1000fibers_cleaned.pdb';

%% Load the fe structs

chdir(dirDiffusion);

% loads a variable called <fe>
load(fullfile(dirDiffusion, feStruct1Loc))
fe1 = fe; 
clear fe; 

load(fullfile(dirDiffusion, feStruct2Loc))
fe2 = fe; 
clear fe

%% Description for each fe struct
conCan.descript = 'F: PathNeighborhood';
conLes.descript = 'FPrime: Lesioned'; 

% subject ID (for titles and plot saving purposes)
parts = strsplit(dirAnatomy, '/');
hcpSubStr = parts{end}; 

%% Extract  things from the fe struct --------------------------------
% the RMSE model on the fitted data set
conCan.rmseAll = feGet(fe1, 'vox rmse'); 
conLes.rmseAll = feGet(fe2, 'vox rmse');

% the fitted weights for the fascicles
conCan.w = feGet(fe1, 'fiber weights');
conLes.w = feGet(fe2, 'fiber weights');

% xform info. should be the same for fe1 and fe2
xform = feGet(fe1, 'xform'); 


%% Coordinates information -------------------------------------------

%% for the tract of interest

% load f so as to extract coordinate information
fPath = fullfile(dirAnatomy, fLoc); 
f = fgRead(fPath); % acpc space
fImgSpace = dtiXformFiberCoords(f, xform.acpc2img); % image space

% get the "roi coords" of the fiber tract
fImgCoordsUnique = fgGet(fImgSpace, 'uniqueimagecoords'); 

%% for F and F'
% the coordinates (voxels) that F and F' run through in IMAGE space
can.coordsAll = feGet(fe1, 'roi coords'); 
les.coordsAll = feGet(fe2, 'roi coords');

% the coords of interest: those that are present in both F and FPrime
can.coordsOfInterest = ismember(can.coordsAll, les.coordsAll, 'rows');

%% Assign rmse accordingly
conCan.rmse = conCan.rmseAll(can.coordsOfInterest); 
conLes.rmse = conLes.rmseAll; 

%% Plotting things

% Compute the evidence --makes a struct
% this step can take a little more time
se = feComputeEvidence(conCan.rmse,conLes.rmse);

% histogram of fitted fascicle weights
[fh_com(3), ~] = plotHistWeights(conCan, conCan.descript);
[fh_opt(3), ~] = plotHistWeights(conLes, conLes.descript);

% Make a scatter plot of the RMSE of the two tractography models
fh(4) = scatterPlotRMSE(conCan,conLes);

% Strength of evidence
fh(5) = distributionPlotStrengthOfEvidence(se, conCan.descript, conLes.descript);
titleAppendStr = [f.name '. Sub' hcpSubStr];
ff_titleAppend(titleAppendStr);
ff_dropboxSave; 


% Earth mover's distance
fh(6) = distributionPlotEarthMoversDistance(se, conCan.descript, conLes.descript);

toc