%% GETPROJOBJ
% The GetProjObj function is designed to create a Project Object for the
% intended Simulink Project. In order to ensure backward compatability (in
% particular) the function can return two versions of the object
% because in releases prior to, and including, R2012A a different API to
% the Simulink Project was used.
function [ ProjObj , LegacyFlag , projectRoot, projectName ] = GetProjObj( )

%% Acquire MATLAB release information
% The Simulink Project API has changed over versions of MATLAB, this
% section identifies the release.

if verLessThan('matlab', '8.2.0')
	% Release earlier than R2013B
    % TODO find version number for 2012A
    
    ProjObj = Simulink.ModelManagement.Project.CurrentProject;
    LegacyFlag = 1;
    % Extract project parameters - old API
    projectRoot = ProjObj.getRootFolder;
    projectName = ProjObj.getProjectName;
else
    % Release later than R2013B
    ProjObj = slproject.getCurrentProject;
    LegacyFlag = 0;
    
    % Extract project parameters - new API
    projectRoot = ProjObj.RootFolder;
    projectName = ProjObj.Name;
end

end

