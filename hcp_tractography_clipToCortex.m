%% Clip a fiber group to only the endpoints
%% Pseudocode

% Read in the fiber group in acpc space
% Grab the endpoints
% See which endpoint is the more posterior one
% Keep only XX number of coordinates from the end

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

% number of coordinates to clip
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
        
        % the first and second endpoint
        ep1 = fiberCoords(:,1); 
        ep2 = fiberCoords(:,end); 
        
        % which one is the more posterior one?
        % wPosterior = 1 | 2; 
        % RAS increasing. The smaller the 2nd value, the more posterior
        if ep1(2) <= ep2(2)
           wPosterior = 1;
        else
           wPosterior = 2;
        end
        
        %% grab the next numClip values from the given endpoint
        
        if wPosterior == 1
            % move forwards from the front
            newFiber = fiberCoords(:,1:numClip);    
        else
            % move backwards from the back
            newFiber = fiberCoords(:, (end-numClip+1):end);    
        end
        
        % assign to the new fg
        fgNew.fibers{ff} = newFiber; 
                
    end % loop over each individual fiber
    
    %% naming and saving the fiber group
    chdir(dirSave)

    [~,baseName] = fileparts(list_fgNames{jj});
    fgNew.name = [baseName '-posteriorClipped_' num2str(numClip) '.pdb'];
    fgWrite(fgNew); 
    
end



