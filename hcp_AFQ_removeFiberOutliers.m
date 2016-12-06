%% Remove fiber outliers from the LGN-V123 tracts

close all; clear all; clc; 

%% modify here

% location of the fg
fgLoc = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307/ROIsFiberGroups';

% the names of the fibers we want to clean
list_fgNames = {
    'LGN-V1_1000fibers.pdb'
    'LGN-V2_1000fibers.pdb'
    'LGN-V3_1000fibers.pdb'
    };

% SAVE assumptions
% Naming convention: {fgName}_cleaned.pdb
% In the same directory as the tract to be cleaned

% Parameters for fiber cleaning
% fg,maxDist,maxLen,numNodes,M,count,maxIter,show
% clean un-clipped fiber group
% [fg keep]=AFQ_removeFiberOutliers(fg,maxDist,maxLen,numNodes,M,count,maxIter,show)
% fg_clean(jj) = AFQ_removeFiberOutliers(fg_clean(jj),afq.params.maxLen,'mean',0,afq.params.cleanIter)
afq = AFQ_Create;                      % default values
maxDist = 5;                           % 5. Keep only fibers within this number of standard deviations away from M
maxLen  = 3;                           % 4. Keep only fibers within this number of standard deviations awawy from M
numNodes = afq.params.numberOfNodes;   % 100. Each fiber will be resampled to have this number of points
M = 'mean';                            % 'mean' 'median' to represent the center of the tract 
count = 1;                             % Whether or not to print pruning results to screen
maxIter = afq.params.cleanIter;        % 5. Max number of iterations for the algorithm
show = 0;                              % whether or not to show which fibers are being removed in each
                                       % iteration. If show == 1 then the the fibers that are being 
                                       % kept and removed will be rendered in 3-D and the user will be 
                                       % prompted to decide whether continue with the cleaning


%% end modification section

numFgs = length(list_fgNames); 
chdir(fgLoc); 

%% do the cleaning

for jj = 1:numFgs
    
    fgName = list_fgNames{jj};
    [~,baseName] = fileparts(fgName); 
    fgNewName = [baseName '_cleaned.pdb']; 
    
    % assume we are already in the directory where the fg lives
    fgUnclean = fgRead(fgName); 
    
    % cleaning
    % [fg keep]=AFQ_removeFiberOutliers(fg,maxDist,maxLen,numNodes,M,count,maxIter,show)
    fg = AFQ_removeFiberOutliers(fgUnclean,maxDist,maxLen,numNodes,M,count,maxIter,show)
    
    % rename and save
    fg.name = fgNewName; 
    fgWrite(fg);
    
end
