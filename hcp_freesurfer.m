%% script that will call freesurfer command and 
%% convert the ribbon file into a nifti class file

clear all; close all; clc

%% modify here

% last name of the subject
% assumes that is a directory in the shared anatomy directory of this name
% assumes that we want the freesurfer ouputs to be in a directory of this name
% under ** /biac4/wandell/data/reading_prf/anatomy **
% ^ at the moment not sure why it just puts everything here ...
lastName = 'HCP_100307'; 

dirFSOutputs = '/sni-storage/wandell/data/reading_prf/anatomy';


%% define things and run freesurfer

anatomyTop = '/biac4/wandell/data/anatomy';
dirAnatomy = fullfile(anatomyTop, lastName); 

% path T1 - make sure acpc'd aligned!
pathT1 = fullfile(dirAnatomy, 't1.nii.gz');

% directory name for freesurfer outputs
% at the moment, not sure if it accepts full path name
% TODO: look into this later, and just specify directory name

% recon-all -i <PATH_TO_YOUR_T1_NIFTI_FILE> -subjid <SUBJECT_ID> -all
% <SUBJECT_ID> is the folder name

% what and where we want the class file to be saved (with extension)
outputClassNii  = fullfile(dirAnatomy, 't1_class_pretouchup.nii.gz'); 

% where freesurfer will automatically store segmentations
dirFSsubject    = fullfile(dirFSOutputs, lastName); 

% input ribbon file
inputRibbonFile = fullfile(dirFSsubject, 'mri','ribbon.mgz'); 

% run freesurfer
eval(['! recon-all -i ' pathT1 ' -subjid ' dirFSsubject ' -all'])

% fs_ribbon2itk(<subjid>, <outfile>, [], <PATH_TO_YOUR_T1_NIFTI_FILE>)
fs_ribbon2itk(inputRibbonFile, outputClassNii, [], pathT1, [])









