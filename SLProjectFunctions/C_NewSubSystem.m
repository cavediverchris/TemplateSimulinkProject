%% New SubSystem
% This script is designed to automate the process of creating a sub system.
% This script will create a new folder with all the required files and
% sub-folders inside the SubSystemModels folder.

%% Clean Up Workspace
close all;
clear all;
clc;

%% Assemble Prefixes
% Import data from external file

FileID = fopen('SubSystemPrefixes.txt');
PrefixData = fscanf(FileID, '%s');
fclose(FileID);

% Calculate number of 'comma's'
CommaIdxs = strfind(PrefixData, ',');
NumCommas = length(CommaIdxs);

% Check that all prefixes contain a definition, i.e. there will be
% multiples of 2 number of commas.
if rem(NumCommas,2) ~= 0
    % ERROR
    disp('ERROR : Source file contains an odd number of commas.');
end

%% Pre-Allocate Memory
% Pre-Allocate Arrays for Prefix and Rationale
NumEntries = NumCommas/2;
prefixArray = cell(NumEntries,1);
rationaleArray = cell(NumEntries,1);

% Populate arrays

for ArrayIdx = 1: NumCommas
    % Determine the entry number
    if rem(ArrayIdx,2) == 0
        % This will be the second pair for the entry
    	row = ArrayIdx/2;
    else
        % This will be the first pair for the entry
        row = (ArrayIdx + 1) /2;
    end
    
    % Calculate Start & End points
    if ArrayIdx == 1
        StartIdx = 1;
        EndIdx = CommaIdxs(ArrayIdx) - 1;
    else
        StartIdx = CommaIdxs(ArrayIdx-1) + 1;
        EndIdx = CommaIdxs(ArrayIdx) - 1;
    end
    
    
    % Extract Text
    TextData = PrefixData(StartIdx: EndIdx);
    
    if rem(ArrayIdx,2) == 0
        % This is rationale
        rationaleArray{row} = TextData;
    elseif rem(ArrayIdx,2) == 1
        % This is prefix
        prefixArray{row} = TextData;
    end
end

%% TBD
% Merge the two arrays
numPrefixes = length (prefixArray);
PrefixOptionsArray = cell(1, numPrefixes);

for PrefixIdx = 1 : numPrefixes
    PrefixOptionsArray{PrefixIdx} = [prefixArray{PrefixIdx} rationaleArray{PrefixIdx}];
end

[SelectionIndex, ButtonVal] = listdlg('PromptString','Select prefix to categorise this model', 'SelectionMode','single', 'ListString',PrefixOptionsArray);

if ButtonVal == 0
    disp('User pressed cancel - aborted');
    return;
else
    Prefix = prefixArray{SelectionIndex};
end
    
%% Request Name
% The user is then prompted to provide the name for this sub-system.

NewModelName = inputdlg('Enter sub-system name : ', 'Sub-System Name');

if isempty(NewModelName)
    % CASE: User pressed cancel
    % ACTION: Abort
    disp('User pressed cancel');
    return;
end

%% Create folder for new model
% The folder to contain the suitable files and fodlers can now be created

ParentFolder = '\SubSystemModels\';
folderName = strcat(Prefix, '_', NewModelName{1});

try
    Proj = slproject.getCurrentProject;
catch ME
    if (strcmp(ME.identifier, 'SimulinkProject:api:NoProjectCurrentlyLoaded'))
        % CASE: A Simulink Project is not loaded
        % ACTION: The function is being used outside of SL Project, set a
        % rootfolder path
        RootFolder = pwd;       
    end
end
RootFolder = Proj.RootFolder;

mkdir([RootFolder, ParentFolder , folderName, '\']);

% Add to path
addpath(genpath([RootFolder,ParentFolder , folderName]));

% Define Test Harness and Model Names
th_name = [folderName, '_TestHarness'];
model_name = [folderName, '_Model'];

%% Create model
% In this cell, we create the new model

open_system(new_system(model_name));

% Add an inport
add_block('simulink/Sources/In1', [gcs, '/Inport']);
set_param([gcs, '/Inport'], 'position', [100 100 130 130]);

% Add a unity gain block
add_block('simulink/Math Operations/Gain', [gcs, '/UnityGain']);
set_param([gcs, '/UnityGain'], 'position', [200 100 230 130]);

% Add an outport
add_block('simulink/Sinks/Out1', [gcs, '/Outport']);
set_param([gcs, '/Outport'], 'position', [300 100 330 130]);

% save current model
save_system(gcs)


% Connect the inport to the gain block
add_line(gcs, 'Inport/1', 'UnityGain/1');

% Connect the gain block to the outport
add_line(gcs, 'UnityGain/1', 'Outport/1');

% save current model
save_system(gcs)
close_system(model_name);
%movefile [pwd, '\', model_name] [RootFolder, ParentFolder , folderName, '\']

%% Create test harness

SLTestInstalled = false;

if SLTestInstalled
    % CASE: Simulink Test is installed, 
    % ACTION:create a test harness using the Simulink Test command
    % TODO
else
    % CASE: Simulink Test is not installed
    % ACTION: create a test harness manually
    
    open_system(new_system(th_name));

    % Add an constant block
    add_block('simulink/Sources/Constant', [gcs, '/Constant']);
    set_param([gcs, '/Constant'], 'position', [100 100 130 130]);
    
    % Add a model reference
    add_block('simulink/Ports & Subsystems/Model', [gcs, '/ReferencedModel'])
    set_param([gcs, '/ReferencedModel'], 'position', [200 75 430 150]);
    
    % Add an display
    add_block('simulink/Sinks/Display', [gcs, '/Display']);
    set_param([gcs, '/Display'], 'position', [500 100 550 130]);
    
    save_system(gcs)
    % Set the model reference to point at the previously created model
    set_param([gcs, '/ReferencedModel'], 'ModelName', fullfile(model_name));

    % Connect the constant to the model reference
    add_line(gcs, 'Constant/1', 'ReferencedModel/1');
    
    % Connect the Output of the model reference to the display
    add_line(gcs, 'ReferencedModel/1', 'Display/1');
    
    save_system(gcs)
    close_system(th_name);
end

%% Add Requirements Module

newReqSet = slreq.new([RootFolder,ParentFolder , folderName, '\', folderName, '_Reqts']);

% Opens the requirements editor
% myReqSetObj = slreq.open(newReqSet);

% Load the requirements set
% myReqSetObj = slreq.load(newReqSet);

% Set the description of the linkset
% TODO

%% Move Models
% Main steps of functionality:
%
% # The directory is changed to ensure that only the intended files are
% renamed.
% # Copied files are renamed
% # Model referencing updated
% # Add to Project
% # directory returned to original
%
Path = [RootFolder, ParentFolder, folderName];

% use movefile to perform a rename
movefile([model_name,'.slx'], [Path, '\', model_name, '.slx']);
movefile([th_name,'.slx'], [Path, '\', th_name, '.slx']);

% Change model reference properties (ignore the .slx at the end of th_name)
load_system(th_name);
set_param(strcat(th_name, '/ReferencedModel'), 'ModelName', fullfile(model_name))
save_system(th_name);

%% Add to project
folderContents = ls([RootFolder, '\SubSystemModels\']);
[numFiles, ~] = size(folderContents);

% loop over each entry in folderContents, first two entries are just
% markers for higher levels
for fileIdx = 3:numFiles
  addFile(Proj, [RootFolder, '\SubSystemModels\', folderContents(fileIdx,:)]);
  disp(['Added file: ', folderContents(fileIdx,:), ' to project.']);
end
