%% PROJECT_PATHS
% The project_paths function returns a string array of folders that are to
% be added to the Project Path to ensure that all files are accessible
% during run-time.
%
% The paths specified in each element of the cell-array are relative to the
% project root. For example,
%
%   folders = { ...
%               'AuxiliaryFunctions', ...
%               'DeployFiles', ...
%               'ModelConfigurationScripts', ...
%               'ReportGenerators', ...
%               'Resources', ...
%               'SimulationRunTimeFiles', ...
%               'SLProjectFunctions', ...
%               'SubSystemModels', ...
%               'SystemModel', ...
%               };
%
% NOTE : Using the command 'fullfile' when constructing fodler hierarchies
% will make the project compatible with multiple operating systems (Linux
% and Windows).

function folders = ProjectPaths()
%project_paths   Define the set of folders to add to the MATLAB path
%  
%   Definition of the folders to add to the MATLAB path when this Project
%   is opened, and remove from the path when it is closed. Edit the
%   definition of folders below to add your own paths to the current
%   project.
%
%   The variable folders is a cell-array of paths relative to the project
%   root. For example,
%
%       folders = { ...
%           'data', ...
%           'models', ...
%           'src', ...
%           fullfile('components','core'), ...
%           'utilities' ...
%           };
%
%   Using the MATLAB command fullfile when constructing folder hierarchies
%   will make your project compatible with multiple operating systems
%   (for example, both Windows and Linux).

%   Copyright 2011-2012 The MathWorks, Inc.

folders = {...
    fullfile('AutomaticReportGenerators'), ...
    fullfile('AuxiliaryFunctions'), ...
    fullfile('ModelConfigurationScripts'), ...
    fullfile('Resources'), ...
    fullfile('SimulationRunTimeFiles'), ...
    fullfile('SLProjectFunctions'), ...
    fullfile('SubSystemModels'), ...
    };

