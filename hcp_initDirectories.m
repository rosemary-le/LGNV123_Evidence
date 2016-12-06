%% For a brand new subject, initialize the directories
% The script will ensure that the naming convention stays constant

%% modify here

subDir = '/sni-storage/wandell/data/LGNV123_HCP/101107'; 

%% do things

chdir(subDir); 

mkdir('Anatomy')                    % HCP T1 will go here
mkdir('retTemplate')                % Benson things will go here
mkdir('DiffusionRawAndExtracted')   % dwi, bvecs, and bvals go here

