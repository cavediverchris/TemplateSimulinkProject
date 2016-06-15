%% Project Set Up
% This script sets up the environment for the current Simulink Project.
% This script needs to be added to the Shortcuts to Run at Start to ensure
% all the initialisation is conducted at project start.

%% Clear the workspace and command window
% The workspace is cleared of all current variables and all windows are
% closed.
% clc
% clear all
% close all

%% Acquire SIMULINK Project Information
% Set up the SIMULINK Project object based upon the release.

[ ProjObj , LegacyFlag , projectRoot, projectName ] = GetProjObj;

%% Set Project Paths
% Project paths are set based on information in the project_paths script as
% well as setting the default folder for code generation etc.

% Print message to screen.
disp(['Initialising Project : ',projectName])

% Set the location of slprj to be the "work" folder of the current project:
myCacheFolder = fullfile(projectRoot, 'SimulationRunTimeFiles');
if ~exist(myCacheFolder, 'dir')
    mkdir(myCacheFolder)
end
 
myCodeGenFolder = fullfile(projectRoot, 'CompiledCode');
if ~exist(myCodeGenFolder, 'dir')
    mkdir(myCodeGenFolder)
end

Simulink.fileGenControl('set', 'CacheFolder', myCacheFolder, ...
    'CodeGenFolder', myCodeGenFolder);


% Add project folders to the path.
folders = ProjectPaths();
for folder_idx = 1:numel(folders)
    addpath( genpath( fullfile(projectRoot, folders{folder_idx}) ));
    
    % Print message to screen.
    disp(strcat(['  adding path: ', fullfile(projectRoot, folders{folder_idx})]))
end

%% Refresh SIMULINK Browser
% This is used to make sure that custom libraries are re-loaded from the
% project workspace

if verLessThan('matlab','R2015a')
    % Print message to screen.
    disp('Refreshing Simulink Library Browser');
    LibBrow = LibraryBrowser.StandaloneBrowser;

    LibBrow.refreshLibraryBrowser
end

%% Back Up - Project Folder
% This schedules an aut-export of the Simulink project every day, it simply
% checks whether a folder with the project name / date exists in the export
% location

% Print message to screen.
disp('Back Up Process');

% set this path to a folder to contain the ZIPS.
exportLocation = 'D:\';

% Set this flag to false to disable archiving
BackUpFlag = false;

backupFile = strcat(exportLocation, projectName, '_backup_', date,'.zip');

% Check if the backup file exists for today, if not, create it.
if BackUpFlag == false
    % Print message to screen.
    disp('... Secondary back-up disabled.')
elseif exist(backupFile , 'file') == 0 & (backupFile == true)
    % Print message to screen.
    disp(strcat(['... No archive file found, exporting project to ', backupFile]))
    
    %dbstop if caught error
    export(ProjObj, backupFile);
    %dbclear all
    
    % Print message to screen.
    disp('... Back up completed.')
elseif exist(backupFile , 'file') == 1
    % Print message to screen.
    disp ('... Archive file found for current project - skipping export')
end

%% Clean Up
% clear up the workspace
clear all;
