%% New SubSystem
% This script is designed to automate the process of creating a sub system.
% This script will create a new folder with all the required files and
% sub-folders inside the SubSystemModels folder.

%% Request Prefix


% Define prefixes
prefixArray = {...,
               'ALG',...
               'LSR',...
               'ENV',...
                };
            
rationaleArray = {...,
               ' - Algorithms',...
               ' - Laser',...
               ' - Environmental',...
                };    

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

SubSysName = inputdlg('Enter sub-system name : ', 'Sub-System Name');
%% Copy Template folder
% The folder to contain the suitable files and fodlers can now be created

ParentFolder = '\SubSystemModels\';
folderName = strcat(Prefix, '_', SubSysName{1});

Proj = slproject.getCurrentProject;

mkdir([Proj.RootFolder, ParentFolder , folderName, '\']);
copyfile([Proj.RootFolder, '\Resources\Template'], [Proj.RootFolder, ParentFolder , folderName, '\']);

% Add to path
addpath(genpath([Proj.RootFolder,ParentFolder , folderName]));

%% Update Models
% Main steps of functionality:
%
% # The directory is changed to ensure that only the intended files are
% renamed.
% # Copied files are renamed
% # Model referencing updated
% # TODO Add to Project
% # directory returned to original
%
cd([Proj.RootFolder, ParentFolder, folderName]);

% Define Test Harness and Model Names
th_name = ['MSTR_', folderName, '_TestHarness.slx'];
model_name = ['MSTR_', folderName, '_Model.slx'];

% use movefile to perform a rename
movefile('MSTR_Model.slx', model_name);
movefile('MSTR_TestHarness.slx', th_name);

% Change model reference properties (ignore the .slx at the end of th_name)
load_system(th_name);
set_param(strcat(th_name(1:end-4), '/Model'), 'ModelName', fullfile(model_name))
save_system(th_name);

% Add to project
folderContents = ls(pwd);
[numFiles, ~] = size(folderContents);

% loop over each entry in folderContents, first two entries are just
% markers for higher levels
for fileIdx = 3:numFiles
  addFile(Proj, folderContents(fileIdx,:));
  disp(['Added file: ', folderContents(fileIdx,:), ' to project.']);
end

% Change directory
cd(Proj.RootFolder);