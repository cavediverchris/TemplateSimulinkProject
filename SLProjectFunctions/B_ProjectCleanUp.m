%% CLEAN_UP_PROJECT
% The CLEAN_UP_PROJECT script is designed to run on Project Close to clean
% up (remove) the local customisations made to the MATLAB Interactive
% Development Environment (IDE).

function B_ProjectCleanUp()
clc;
disp('Closing down project.');
% Get Project Root
[ ~ , ~ , projectRoot, ~ ] = GetProjObj;


% Remove paths added for this project. Get the single definition of the
% folders to add to the path:
folders = ProjectPaths();

% Remove these from the MATLAB path:
for Folder_Idx=1:numel(folders)
    disp(['     Removing path: ', fullfile(projectRoot, folders{Folder_Idx})]);
    rmpath( fullfile(projectRoot, folders{Folder_Idx}) );
end

% Reset the location where generated code and other temporary files are
% created (slprj) to the default:
Simulink.fileGenControl('reset');
