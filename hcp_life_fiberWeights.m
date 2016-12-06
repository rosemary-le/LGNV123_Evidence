%% For a given feStruct, plot histogram of fiber weights of given fibers of interest
% this script rests on the assumption that if the <f> tract has n number of
% fibers, then the last n fibers of the F_LiFEStruct corresponds to f

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% name of the life struct for the F fiber group. 
% assumes it is in dirDiffusion/LiFEStructs/
feName = 'LGN-V1_Benson_cleaned-FFibers_N360_LiFEStruct.mat';

% name of f that was was used to create F
% assumes that this pdb file is in dirAnatomy/ROIsFiberGroups
fName = 'LGN-V1_200fibers_cleaned.pdb';

%% end modification section

chdir(dirDiffusion);

% load the life struct
fePath = fullfile(dirDiffusion, 'LiFEStructs', feName); 
load(fePath)

% load the f fiber group so that we know how many fibers are in it
fPath = fullfile(dirAnatomy, 'ROIsFiberGroups', fName); 
f = fgRead(fPath);
f_numFibers = fgGet(f, 'nfibers');

%% the weights
% get all of them
w_all = feGet(fe, 'fiberweights')
figure; 
hist(w_all,50)

% the weights of the fibers in f
% this is assuming that when the feStruct was computed on F, the last
% f_numFibers pertain to the f fiber group
w_f = w_all(end-(f_numFibers-1):end); 

% indices of the nonzero weight
w_f_indNonZero = find(w_f > 0); 

% only the non zero weights
w_f_nonZero = w_f(w_f_indNonZero);

% percent of non-zero fibers
numOverZero = sum(w_f > 0); 
perNonZero = numOverZero / f_numFibers; 

%% plotting weights for all fibers in the tract
figure; 
hist(w_f,20);

titleName = {
    [fName ' fiber weights']
    ['Percent of non-zero fibers: ' num2str(perNonZero)]
    };

title(titleName, 'fontweight', 'bold'); 
xlabel('fiber weights');
ylabel('number of fibers');
grid on

% set the x-axis to start at 0
xlim = get(gca, 'xlim');
set(gca, 'xlim', [0 xlim(2)])

%% some fibers have non-zero but still really really tiny weights
% which makes it difficult to get a true sense of the distribution
% in this plot we only show the non-zero fibers

hist(w_f_nonZero,20)

titleName = {
    [fName ' non-zero fiber weights']
    ['Percent of non-zero fibers: ' num2str(perNonZero)]
    };

title(titleName, 'fontweight', 'bold'); 
xlabel('fiber weights');
ylabel('number of fibers');
grid on

% set the x-axis to start at 0
xlim = get(gca, 'xlim');
set(gca, 'xlim', [0 xlim(2)])
set(gca, 'ylim', [0 35])
