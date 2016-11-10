%% Merge some nifti ROIs:
% LGN.nii.gz = LGN_left.nii.gz + LGN_right.nii.gz
% LGN-V1.nii.gz = LGN.nii.gz + V1_Benson.nii.gz
% LGN-V2.nii.gz = LGN.nii.gz + V2_Benson.nii.gz
% LGN-V3.nii.gz = LGN.nii.gz + V3_Benson.nii.gz

clear all; close all; clc; 

%% modify here

% anatomy directory
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% niftis to combine
% each row in this cell is string vector, indicating the niftis to combine
niftiCombinations = { ...
    {'LGN_left.nii.gz', 'LGN_right.nii.gz'}
    {'LGN.nii.gz', 'V1_Benson.nii.gz'}
    {'LGN.nii.gz', 'V2_Benson.nii.gz'}
    {'LGN.nii.gz', 'V3_Benson.nii.gz'}
    };

% new nifti names
% each row corresponds to a row in niftiCombinations
list_niiNewNames = {
    'LGN.nii.gz'
    'LGN-V1.nii.gz'
    'LGN-V2.nii.gz'
    'LGN-V3.nii.gz'
    };

%% do it

chdir(fullfile(dirAnatomy,'ROIsNiftis'))

% number of combinations to make
numCombinations = size(niftiCombinations,1); 

for jj = 1:numCombinations
    
    toCombine = niftiCombinations{jj};
    niiNewName = list_niiNewNames{jj};
    
    niiMerged = niftiMerge(toCombine, niiNewName); 
    
end

