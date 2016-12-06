%% Workflow. 
% Evaluating the strength of the evidence for a tract between LGN and V2, V3
%
% (ASSUMES) SUBJECT DATA IS HERE: '/sni-storage/wandell/data/LGNV123_HCP/{subID}'
% 
% Github script repository is here: '/biac4/wandell/data/LGN_V123/LGNV123_Evidence'

% dirDiffusion. Diffusion data, relative to subject data is: /T1w/Diffusion 
% Whole brain connectome is stored in Diffusion directory (though this might be changed)
% dirDiffusion/fiberGroups: Other fiber groups are stored in Diffusion
%   opticChiasm

%% For a brand new subject, initialize the directories
% The script will ensure that the naming convention stays constant
edit hcp_initDirectories; 

%% Download things off Flywheel
% T1w_acpc_dc_restore_1.25.nii.gz
% and Diffusion data

%% Create shared anatomy directory and apply a canonical xform to the t1
% /biac4/wandell/data/anatomy/HCP_{ID}/T1w_acpc_dc_restore_1.25.nii.gz
edit hcp_t1SharedAnatomyAndXform.m

%% Upload the canonically xformed data back up to Flywheel


%% Run the Benson Docker on Flywheel 
%  www.flywheel.scitran.stanford.edu and move the following

%% Organize the Benson outputs
% {subDir}/retTemplate/scanner.template_areas.nii.gz 

% The Benson docker will also produce outputs in Freesurfer (these are currently)
% in a zipped file format. Unzip those files and save it here: 
% {subDir}/retTemplate/retTemplate_freesurfer/

%% Save a copy of the freesurfer outputs into the FS subject environment
edit hcp_freesurferCopyFilesToSubEnv.m; 

%% Define bilateral V1, V2, V3 from the Benson docker
% The bilateral nifti rois will be saved here: {dirAnatomy}/ROIsNiftis/
% and are named like: V1_Benson.nii.gz, V2_Benson.nii.gz, V3_Benson.nii.gz

edit hcp_retTemplate2NiftiROI.m

%% Define single-hemisphere V1, V2, V3 from the Benson Docker outputs

edit hcp_retTemplate2NiftiROI_singleHemisphere.m; 

%% Create the class file from the ribbon file
% Class file is used to make a mesh, and is also a better white matter mask
%
% TODO: Benson docker runs Freesurfer. Organize the Freesurfer in the
% directory

edit hcp_ribbon2classFile; 

%% extract the b=2000 values from the nifti diffusion data
% Creates DiffusionRawAndExtracted/ in the subject's directory
% dwi_2000.nii.gz
% dwi_2000.bvec
% dwi_2000.bval
edit hcp_extractSingleShell; 

%% dtiInit
% DiffusionRawAndExtracted/ contains
% bvals
% bvecs
% data.nii.gz
% nodif_brain_mask.nii.gz -- brain mask in diffusion space
edit hcp_dtiInit 

%% Draw the LGN ROIs
% First draw them as mat files in dirDiffusion/ROIS.
% 5mm sphere roi -- see Evernote for screenshots
    % in the coronal slice, halfway between we see clear delineation
    % of red and green
% 
% Then save them as niftis with the following naming convention. Keep them here:
% {sharedAnatomyDirectory}/ROIsNiftis/LGN_left.nii.gz

% 5mm radius sphere is what we did on a first run through
% To get more fibers, we might want
mrDiffusion; 

%% Convert the mrDiffusion ROIs into nifti files
edit hcp_dtiRoiNiftiFromMat.m
 
%%  Merge the nifti files
% Store in {dirAnatomy}/ROIsNiftis
% LGN.nii.gz = LGN_left.nii.gz + LGN_right.nii.gz
% LGN-V1.nii.gz = LGN.nii.gz + V1_Benson.nii.gz
% LGN-V2.nii.gz = LGN.nii.gz + V2_Benson.nii.gz
% LGN-V3.nii.gz = LGN.nii.gz + V3_Benson.nii.gz
edit hcp_mergeNiftiROIs.m; 

%% Basic Tractography steps ==============================================

%% Initialize files for mrtrix tractography
edit hcp_mrtrix_init;

%% Whole brain tractography
% Location/Name: {dirAnatomy}/ROIsConnectomes/
edit hcp_mrtrix_wholeBrainTractography;

%% Generate the gray matter / white matter boundary
% edit hcp_mrtrix_5ttgen; 

%% Tractography. =========================================================

%% (1) Generate a connectome with no endpoints in LGN-V(123).mat 
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V1_50000fibers.pdb
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V2_50000fibers.pdb
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V3_50000fibers.pdb
edit hcp_mrtrix_track_noEndpointsInROIs.m 

%% (2) Generate the fibers with only one endpoint in the LGN-V(123) 
% (2a) Generate the fibers with one endpoint in LGN 
% (2b) Generate the fibers with one endpoint in V(123)
% Merge the 2a and 2b fibers % Name: ROIsFiberGroups/OneEndpoint_LGN-V1_Benson_{numFibers}fibers.pdb
edit hcp_mrtrix_track_oneEndpointInROI.m
 
%% (pre 3) Just track between the LGN and V123. A lot of fibers. 
% Name: LGN-V1_1000fibers.pdb. 
edit hcp_mrtrix_track_roi2roi; 

%% (3) Clean the fibers to remove fiber outliers!
% Name: LGN-V1_1000fibers_cleaned.pdb
edit hcp_AFQ_removeFiberOutliers.m; 

%% (4) Combine fibers from (1) and (2) 
% This is everything in the brain except for the tract of interest
% name: EverythingExcept_LGN-V1_Benson_51100fibers.pdb
edit hcp_fgMerge_everythingExceptTractOfInterest.m; 

%% Inteserect the fibers from (4) with (3) to find FPrime
% Name: LGN-V1_1000fibers_cleaned-FPrimeFibers  % cleaned version
edit hcp_life_makeFPrimeFibers.m; 
 
%% Merge FPrime with (3a) to get F
% Name: LGN-V1_1000fibers_cleaned-FFibers       % cleaned version
edit hcp_fgMerge_fAndFPrimeToMakeF.m;

%% Fit the model F and FPrime
% Loc: {dirDiffusion}/LiFEStructs/
% Name: WholeBrain500000_mergedWith_LGN-V1_1000fibers_N360_LiFEStruct.mat
edit hcp_life_feStructCompute; 

%% After fitting the model, define the set of optimized fibers from candidate fibers
edit hcp_life_feStructOptimizedFibers; 
 
%% Virtual lesion ... couple ways of doing this

% in the voxels of the lesioned path neighborhood
edit hcp_life_virtualLesion_voxelsOf_FPrime.m;

% in the voxels of the tract of interest 
edit hcp_life_virtualLesion_voxelsOf_f.m; 

% in the voxels at the endpoints of the fibers
% see hcp_tractography_clip*.m on how to get those fibers
edit hcp_life_virtualLesion_voxelsOf_anRoiSubset.m; 
 

%% See the fiber weights
edit hcp_life_fiberWeights.m;

%% AFQ Things ============================================================

%% Run AFQ
% Also, save the afq struct in {subjectDirectory}/{dt6dir}/AFQ/...
% AFQ_Run_Outputs.mat

edit hcp_AFQ_Run; 

%% Convert the afq outputs into pdb files
% The {dirDiffusion}/{dt6Dir}/fibers/ directory has these files:
% MoriGroups_Cortex.mat
% MoriGroups_Cortex_clean_D5_L4.mat
%
% Loading these mat files gives us a variable called fg
% fg is a 1x20 struct

% --> Save each cell of fg as its own fiber group!

edit hcp_AFQ_MoriGroups2Pdbs.m; 


%% make meshes
% TODO: finish this script
% edit hcp_buildMeshes.m;

%% Visualizations and analyses ===========================================

%% The subset of the fibers in F and FPrime which have non-zero weights
% For visualization purposes
edit hcp_life_fgSubsetNonZeroWeights.m; 

%% Get the portion of the fibers that are just near cortex
edit hcp_tractography_clipToCortex.m; 

%% Get the fibers 



