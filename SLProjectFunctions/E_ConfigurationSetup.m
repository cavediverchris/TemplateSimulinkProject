%% Setup Project
% This setup file is used to set up some of the environmental variables
% needed to run the project and reference models. These include parameter
% classes, loading base configurations for Simulink models etc.
%% Paramter setup 
% Two parameter files contains global parameters that can be used globally.
% Once project parameter files (ProjClass) have been created, these are
% loaded from this cell.

disp('     Loading project-specific class definitions.')
ProjClassDef = ProjClass;


%% Read in the base configuration settings
% The configuration reference for consistent modelling parameters is set up

% Setup configuration for configuration references
disp('     Loading project-specific configurations.')
BaseConfig_FixedStep = ConfigurationSetup_FixedStep;
