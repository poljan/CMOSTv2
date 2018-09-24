clear variables;

addpath('Core procedures')
addpath('Additional procedures')

% load default settings
load(fullfile(pwd(), 'Settings', 'CMOST13.mat')) 
handles.Variables=temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Life Table                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we load the saved variable
load (fullfile(pwd(),'Settings', 'LifeTable.mat'))
handles.Variables.LifeTable = LifeTable;

%define number of patients
handles.Variables.Number_patients = 25000;

%%
[handles, BM] = CalculateSub(handles);