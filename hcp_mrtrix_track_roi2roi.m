%% Generate tracts between 2 rois

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';
dirDiffusion = '/sni-storage/wandell/data/LGNV123_HCP/100307';

% dirSave
dirSave = fullfile(dirAnatomy, 'ROIsFiberGroups');

% the roi pairs we want to track between
% should be a numPairs x 2 cell
% ROIs should be in nifti format. So we assume location is
% dirAnatomy/ROIsNiftis
list_roiPairs = {
    'LGN','V1_Benson';
    'LGN','V2_Benson';
    'LGN','V3_Benson';
    };

% We should have already created a union nifti. Specify these here.
% dirAnatomy/ROIs/Nifts
list_seeds = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

% stop track as soon as it enters the specified region. 
% unclear what will happen if the seed and the stop are the same. 
% it still works!! maybe because there is a minimum distance for a fiber
list_stops = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

% number of fibers we want
numFibers = 1000; 

% maximum number of fibers to generate. The algorithm will stop after
% generating this number of tracks, even if the desired number of fibers
% has not been reached. An option of 0 means the algorithm will continue 
% generating tracks until the desired number has been reached
numFibersGenerate = 0; 

% name to give the new fiber group
list_fgNewNames = {
    ['LGN-V1_' num2str(numFibers) 'fibers'] 
    ['LGN-V2_' num2str(numFibers) 'fibers'] 
    ['LGN-V3_' num2str(numFibers) 'fibers'] 
    };

% some other default mrtrix values
verbose = true; 
bkgrnd = false; 

%% loop over the ROI pairs
for jj = 1:size(list_roiPairs,1)

    %% making code more readable
    fgNewName = list_fgNewNames{jj};
    roi1Name = list_roiPairs{jj,1};
    roi2Name = list_roiPairs{jj,2};
    seedName = list_seeds{jj};
    stopName = list_stops{jj};

    %% define/make some paths

    % nifti paths
    roi1Path = fullfile(dirAnatomy, 'ROIsNiftis', [roi1Name '.nii.gz']);
    roi2Path = fullfile(dirAnatomy, 'ROIsNiftis', [roi2Name '.nii.gz']);
    seedPath = fullfile(dirAnatomy, 'ROIsNiftis', [seedName '.nii.gz']); 
    stopPath = fullfile(dirAnatomy, 'ROIsNiftis', [stopName '.nii.gz']); 

    % roi 1 and 2 and seed -- mif file path
    roi1MifPath = fullfile(dirAnatomy, 'ROIsMifs', [roi1Name '.mif']);
    roi2MifPath = fullfile(dirAnatomy, 'ROIsMifs', [roi2Name '.mif']);
    seedMifPath = fullfile(dirAnatomy, 'ROIsMifs', [list_seeds{jj} '.mif']);
    stopMifPath = fullfile(dirAnatomy, 'ROIsMifs', [list_stops{jj} '.mif']);
    
    % make the mif files if it doesn't exist
    if ~exist(roi1MifPath)
        mrtrix_mrconvert(roi1Path, roi1MifPath);
    end
    if ~exist(roi2MifPath)
        mrtrix_mrconvert(roi2Path, roi2MifPath);
    end
    if ~exist(seedMifPath)
        mrtrix_mrconvert(seedPath, seedMifPath);
    end
    if ~exist(stopMifPath)
        mrtrix_mrconvert(stopPath, stopMifPath);
    end

    %% load other input arguments for mrtrix_track_roi2roi

    % files from mrtrix_init -- <files>
    load(fullfile(dirDiffusion,'files_mrtrix_init.mat'))

     % mask: string, filename for a .mif format of a mask. Use the *_wm.mif file for Whole-Brain tractography.
    maskMifPath = files.wm; 

    % mode: {'SD_PROB'} for probabilistic tracking. 
    mode = 'SD_PROB'; 

     % nSeeds: The number of fibers to generate.
    nSeeds = numFibers;

    %% output tck file
    chdir(fullfile(dirDiffusion, 'mrtrix'));
    [~,csdName,~] = fileparts(files.csd);
    [~,wmName,~] = fileparts(files.wm);

    tck_file = strcat(ff_stringRemove(csdName, '.mif'), '_' , ... 
        roi1Name, '_', roi2Name, '_', seedName , '_', ...
        ff_stringRemove(wmName, '.mif'), '_', mode, ...
        '_numFibers', num2str(numFibers), '.tck'); 

    %% run mrtrix ====================================================
    % [pdb_file, status, results] = mrtrix_track_roi2roi(files, ...
    %     roi1MifPath, roi2MifPath, seedMifPath, maskMifPath, mode, numFibers, [], [], [])

    % Mif files are written whereever we are. 
    % So move to the 'ROIsMifs' directory in dirAnatomy
    chdir(fullfile(dirAnatomy, 'ROIsMifs'));

    % streamtrack [options] type source tracks
    cmd_str = sprintf( ...
        'streamtrack -seed %s -mask %s -include %s -include %s -number %d -maxnum %d -stop %s %s %s',...
        seedMifPath, maskMifPath, roi1MifPath, roi2MifPath, ...
        numFibers, numFibersGenerate, ...
        mode, files.csd, tck_file);
    
    %% track it!
    [status, results] = mrtrix_cmd(cmd_str, bkgrnd, verbose);
    
    %% save appropriately
    % convert the tracks to pdb format
    pdb_file = fullfile(dirSave, [fgNewName '.pdb'])
    mrtrix_tck2pdb(tck_file, pdb_file)
   

end

