%% Clip a fiber group to only the endpoints
%% Pseudocode

% Read in the fiber group in acpc space
% Get the midpoint of each fiber
% Keep only XX number of coordinates from the center

clear all; close all; clc; 

%% modify here

dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';

% the fgs to do this for
list_fgNames = {
    'LGN-V1_1000fibers_cleaned.pdb'
    'LGN-V2_1000fibers_cleaned.pdb'
    'LGN-V3_1000fibers_cleaned.pdb'
    };

% location of fgs relative to dirAnatomy
fgLoc = 'ROIsFiberGroups';

% where we want to save the clipped fiber grouos
% Save name assumption = {fgName}-posteriorClipped_{numClip}.pdb
% e.g. LGN-V1_1000fibers_cleaned-posteriorClipped_5.pdb
dirSave = fullfile(dirAnatomy, 'ROIsFiberGroups'); 

% number of coordinates to clip (keep)
numClip = 10; 

%% end modification section

for jj = 1:length(list_fgNames)
    
    fgPath = fullfile(dirAnatomy, fgLoc, list_fgNames{jj});
    fg = fgRead(fgPath); 
    
    % make a copy, that we will edit
    fgNew = fg; 
    
    % number of fibers in this fiber group
    numFibers = fgGet(fg, 'nfibers'); 
    
    %% loop over fibers 
    for ff = 1:numFibers
        
        % the fiber coordinates
        fiberCoords = fg.fibers{ff};
        
        % the length of the fiber
        flen = size(fiberCoords,2); 
        flenMid = floor(flen/2); 
        
        % midway coordinate
        mp = fiberCoords(:,flenMid); 
        
        %% Grow equally from the midpoint
        % grow1 and grow are equal if numClip is even
        grow1 = floor(numClip/2); 
        grow2 = ceil(numClip/2); 
        
        theStart = flenMid -grow1; 
        
        newFiber = fiberCoords(:,theStart:theEnd); 
     
        
        % assign to the new fg
        fgNew.fibers{ff} = newFiber; 
                
    end % loop over each individual fiber
    
    %% naming and saving the fiber group
    chdir(dirSave)

    [~,baseName] = fileparts(list_fgNames{jj});
    fgNew.name = [baseName '-posteriorClipped_' num2str(numClip) '.pdb'];
    fgWrite(fgNew); 
    
end



