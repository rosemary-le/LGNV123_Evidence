%% Extract single shell from multi-shell diffusion data
%% TODO: functionalize
% A new version of Bvals, Bvecs, and Data will be created:
% dwi_{shellNumber}.bvec
% dwi_{shellNumber}.bval
% dwi_{shellNumber}.nii.gz

clear all; close all; clc; 

%% modify here

% subject path
subLoc = '100307';

% which shell values to extract. can be a vector
% typically we will want to extract 0 and a single other value (e.g. 2000)
% name the cropped files with the larger value
shellNumbers = [0 2000]; 

% location of raw diffusion data relative to subLoc
rawDataLoc = 'DiffusionRawAndExtracted';

% name of bvals, bvecs, and data. relative to rawDataLoc
bvalsName = 'bvals';
bvecsName = 'bvecs';
dataName = 'data.nii.gz';

% There are bvalues like 1005, 2995, 3010 ...
% roundBval equals true, we will round to the nearest thousand
roundBval = true; 

%% define things and initialize

% where the HCP data lives
dirHCP = '/sni-storage/wandell/data/LGNV123_HCP';

dirSubject = fullfile(dirHCP, subLoc);

chdir(dirSubject)
bvalsPath   = fullfile(dirSubject, rawDataLoc, bvalsName); 
bvecsPath   = fullfile(dirSubject, rawDataLoc, bvecsName); 
dataPath    = fullfile(dirSubject, rawDataLoc, dataName);

% we will save the cropped data in the same directory as the raw
baseName = ['dwi_' num2str(shellNumbers(end))];
bvalsKeepPath   = fullfile(dirSubject, rawDataLoc, [baseName '.bval']);
bvecsKeepPath   = fullfile(dirSubject, rawDataLoc, [baseName '.bvec']);
dataKeepPath    = fullfile(dirSubject, rawDataLoc, [baseName '.nii.gz']);

%% read in bvec, data, and data
% the bvecs
bvecs = dlmread(bvecsPath);

% the data
nii_dwi = readFileNifti(dataPath);

% the b values
bvalsRaw = textread(bvalsPath, '%f'); 
if roundBval
    tem = round(bvalsRaw/1000);
    bvals = tem*1000; 
    clear tem; 
else
    bvals = bvalsRaw; 
end

%% find the indices corresponding to the shell value we want
for bb = 1:length(shellNumbers)
    shellNumber = shellNumbers(bb);
    tem = (bvals == shellNumber);
    
    if bb == 1
        bvalsOfInterest = tem; 
    else
        bvalsOfInterest = tem | bvalsOfInterest; 
    end
    
end

bvalsIndOfInterest = find(bvalsOfInterest);

%% cropping the things ---------------------------------------------------
% bval
bvalsKeep = bvalsRaw(bvalsIndOfInterest)';
% ^ not rounded to the nearest thousand. Problematic when we do dtiInit and
% it tries to align to b == 0
bvalsKeepRound = round(bvalsKeep/1000)*1000; 
dlmwrite(bvalsKeepPath, bvalsKeepRound, ' ');

% bvec
bvecsKeep = bvecs(:,bvalsIndOfInterest);
dlmwrite(bvecsKeepPath, bvecsKeep, 'delimiter', '\t', 'precision', 8);

% the data
nii_dwiKeep = nii_dwi;
nii_dwiKeep.data = nii_dwi.data(:,:,:,bvalsIndOfInterest);
nii_dwiKeep.fname = dataKeepPath; 
writeFileNifti(nii_dwiKeep);

