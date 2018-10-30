%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     CMOST: Colon Modeling with Open Source Tool
%     created by Meher Prakash and Benjamin Misselwitz 2012 - 2016
%
%     This program is part of free software package CMOST for colo-rectal  
%     cancer simulations: You can redistribute it and/or modify 
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%       
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = CMOST_Main(varargin)
% POLYPCALCULATOR 
%      simulation for the natural history of colorectal polyps and cancer
%      helpful for testing the effects of various screening strategies 
%
%      Program created by Benjamin Misselwitz, 2010-2011

%adding necessary paths to other functions
% addpath('Core procedures');
% addpath('Additional procedures');
% addpath('Storyboards');
% addpath('Settings');
%adding necessary paths to other functions
tmp = mfilename('fullpath');
tmp2= tmp(1:strfind(tmp, 'CMOST_Main')-1);

addpath(fullfile(tmp2,'Core procedures'));
addpath(fullfile(tmp2,'Additional procedures'));
addpath(fullfile(tmp2,'Storyboards'));
addpath(fullfile(tmp2,'Settings'));


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CMOST_Main_OpeningFcn, ...
    'gui_OutputFcn',  @CMOST_Main_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Opening Function                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Executes just before CMOST_Main is made visible.
function CMOST_Main_OpeningFcn(hObject, eventdata, handles, varargin)
% this opening function defines variables and settings and prepares the
% graphical user interface 

%%% Name and comments
handles.Variables.Settings_Name  = 'Default';
handles.Variables.Comment        = 'no comment please';
handles.Variables.Identification = 'This_is_a_genuine_PolypCalculator_File';

%%% the path were this proggram is stored
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
addpath(path)
CurrentPath = Path(1:pos-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Handles Variables            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load default settings
load(fullfile(CurrentPath, 'Settings', 'CMOST13.mat')) 
set(handles.Default_SettingsName, 'string', 'CMOST13.mat', 'enable', 'off')
handles.Variables=temp;
handles.Variables.ResultsPath = fullfile(Path(1:pos-1), 'Results');

%%% the path were this program is stored
handles.Variables.CurrentPath = CurrentPath;
clear temp

handles.Variables.NumberPatientsValues = [10000 25000 50000 100000];
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Life Table                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we load the saved variable
load (fullfile(handles.Variables.CurrentPath,'Settings', 'LifeTable.mat'))
handles.Variables.LifeTable = LifeTable;

% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

handles = MakeImagesCurrent(hObject, handles);
%handles.Variables = AdjustRiskGraph(handles.Variables);
guidata(hObject, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% This function is called whenever a change is made within the GUI. This 
% function makes these changes visible
 
% FIX BM to enable higher number of patients 26.10.2018
handles.Variables.NumberPatientsValues = [10000 20000 50000 100000 200000 500000];

tmp = find(handles.Variables.NumberPatientsValues == handles.Variables.Number_patients);
set(handles.Number_patients, 'value', tmp)

set(handles.SaveDataPath_Edit, 'string', handles.Variables.ResultsPath)
set(handles.settings_name, 'string', handles.Variables.Settings_Name)
set(handles.comment, 'string', handles.Variables.Comment)

if isequal(handles.Variables.Polyp_Surveillance, 'off')
    set(handles.Polyp_Surveillance, 'value', 0)
else
    set(handles.Polyp_Surveillance, 'value', 1)
end
if isequal(handles.Variables.Cancer_Surveillance, 'off')
    set(handles.Cancer_Surveillance, 'value', 0)
else
    set(handles.Cancer_Surveillance, 'value', 1)
end
if isequal(handles.Variables.Screening.Mode, 'off')
    set(handles.screening_checkbox, 'value', 0)
else
    set(handles.screening_checkbox, 'value', 1)
end 
set(handles.SaveDataPath_Edit, 'string', handles.Variables.ResultsPath)
set(handles.settings_name, 'string', handles.Variables.Settings_Name)
set(handles.comment, 'string', handles.Variables.Comment)

if isequal(handles.Variables.Starter.CurrentSummary, 'none')
    set(handles.start_batch, 'enable', 'off')
else
    set(handles.start_batch, 'enable', 'on')
end

if isequal(handles.Variables.SpecialFlag, 'off')
    set(handles.special, 'value', 0)
    set(handles.special_text, 'enable', 'off')
else
    set(handles.special, 'value', 1)
    set(handles.special_text, 'enable', 'on')
end
if handles.Variables.ResultsFlag
    set(handles.enable_results, 'value', 1)
else
    set(handles.enable_results, 'value', 0)
end
if handles.Variables.ExcelFlag
    set(handles.excel_file, 'value', 1)
else
    set(handles.excel_file, 'value', 0)
end
if handles.Variables.DispFlag
    set(handles.enable_pdf, 'value', 1)
else
    set(handles.enable_pdf, 'value', 0)
end

set(handles.special_text, 'string', handles.Variables.SpecialText)

guidata(hObject, handles);

function varargout = CMOST_Main_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Screening and Surveillance                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% enable adenoma surveillance
function Polyp_Surveillance_Callback(hObject, eventdata, handles)
tmp = get(handles.Polyp_Surveillance, 'value');
if isequal(tmp, 1)
    handles.Variables.Polyp_Surveillance = 'on';
else
    handles.Variables.Polyp_Surveillance = 'off';
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% enable cancer surveillance
function Cancer_Surveillance_Callback(hObject, eventdata, handles)
tmp = get(handles.Cancer_Surveillance, 'value');
if isequal(tmp, 1)
    handles.Variables.Cancer_Surveillance = 'on';
else
    handles.Variables.Cancer_Surveillance = 'off';
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% enable screening
function screening_checkbox_Callback(hObject, eventdata, handles)
tmp = get(handles.screening_checkbox, 'value');
if isequal(tmp, 1)
    handles.Variables.Screening.Mode = 'on';
else
    handles.Variables.Screening.Mode = 'off';
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    

% Special
function special_Callback(hObject, eventdata, handles)
tmp = get(handles.special, 'value');
if isequal(tmp, 1)
    handles.Variables.SpecialFlag = 'on';
else
    handles.Variables.SpecialFlag = 'off';
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% special text
function special_text_Callback(hObject, eventdata, handles)
handles.Variables.SpecialText=get(handles.special_text, 'string');
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         OUTPUT                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% enable results
function enable_results_Callback(hObject, eventdata, handles)
tmp = get(handles.enable_results, 'value');
if isequal(tmp, 1)
    handles.Variables.ResultsFlag = true;
else
    handles.Variables.ResultsFlag = false;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

% enable excel 
function excel_file_Callback(hObject, eventdata, handles)
tmp = get(handles.excel_file, 'value');
if isequal(tmp, 1)
    handles.Variables.ExcelFlag = true;
else
    handles.Variables.ExcelFlag = false;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

% enavle pdf
function enable_pdf_Callback(hObject, eventdata, handles)
tmp = get(handles.enable_pdf, 'value');
if isequal(tmp, 1)
    handles.Variables.DispFlag = true;
else
    handles.Variables.DispFlag = false;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Paths and settings                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% settings
function settings_name_Callback(hObject, eventdata, handles)
tmp=get(handles.settings_name, 'string');
if isvarname(tmp)
    handles.Variables.Settings_Name = tmp;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
else
    errordlg('Invalid name')
end

% save
function SaveDataPath_Edit_Callback(hObject, eventdata, handles)
tmp=get(handles.SaveDataPath_Edit, 'string');
if isdir(tmp)
    handles.Variables.ResultsPath = tmp;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
else
    errordlg('Invalid name')
end

% browse
function Browse_Callback(hObject, eventdata, handles)
folder_name = uigetdir(handles.Variables.ResultsPath, 'Select folder to save files');
if ~isequal(folder_name, 0) 
    handles.Variables.ResultsPath = folder_name;
    guidata(hObject, handles)
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
end

% comment
function comment_Callback(hObject, eventdata, handles)
tmp=get(handles.comment, 'string');
handles.Variables.Comment = tmp;
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('.mat' ,'Loading cell data', handles.Variables.CurrentPath);
if isequal(filename, 0), return, end
temp=importdata(fullfile(pathname, filename));
if isstruct(temp)
    if isfield(temp, 'Identification')
        if isequal(temp.Identification, 'This_is_a_genuine_PolypCalculator_File')
            handles.Variables = temp;
            handles.Variables.NumberPatientsValues = [10000 25000 50000 100000];
            if ~isfield(handles.Variables, 'MortalityCorrection')
                handles.Variables.MortalityCorrectionGraph(1 : 150) = 1;
            end
            if ~isfield(handles.Variables,'DwellSpeed')      %m
                handles.Variables.DwellSpeed     = 'Fast';   %m
            end

            Flag = 0;
            try
                handles = MakeImagesCurrent(hObject, handles);
                %handles.Variables = AdjustRiskGraph(handles.Variables);
                if ~isfield(handles.Variables, 'RiskCorrelation')
                    handles.Variables.RiskCorrelation = 'on';
                end
                guidata(hObject, handles);
            catch
                Flag = 1;
            end
        end
    else Flag=1;
    end
else Flag=1;
end
if isequal(Flag, 1)
    errordlg('Loaded settings not valid')
else
    msgbox('Settings succesfully loaded')
    handles.Variables.CurrentPath = pathname;
    set(handles.Default_SettingsName, 'string', filename , 'enable', 'off')
end
guidata(hObject,handles)

% save
function Save_Callback(hObject, eventdata, handles)
[filename, pathname] = uiputfile('.mat', 'Saving settings',...
    fullfile(handles.Variables.CurrentPath, [handles.Variables.Settings_Name, '.mat']));
if ischar(filename) % if user presses cancel, 0 is returned 
    if isempty(regexp(filename, '.mat$', 'once' ))
        filename=strcat(filename, '.mat');
    end
    try
        handles.Variables.Settings_Name = strrep(filename, '.mat', '');
        temp=handles.Variables; %#ok<NASGU>
        save(fullfile(pathname, filename), 'temp');
        if ~exist(fullfile(pathname, filename))==2 %#ok<EXIST>
            errordlg('Saving settings failed')
        else
            msgbox('Settings succesfully saved')
            handles.Variables.CurrentPath = pathname;
            handles = MakeImagesCurrent(hObject, handles);
            guidata(hObject,handles)
        end
    catch 
        uiwait(errordlg('Problems saving settings. You might not have permission to write in this place or the contact to the server might be lost. Please check connections and try again.'))
    end
end

% default
function Default_SettingsName_Callback(hObject, eventdata, handles) %#ok<INUSD>

function Starter_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Starter)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function VariablesScan_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(ScanVariables)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Colonoscopy_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Colonoscopy_settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Location_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Location_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Cost_settings_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Cost_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Risk_Settings_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Risk_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Screening_Settings_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Screening_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Mortality_Settings_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Mortality_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Sensitivity_Analysis_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Sensitivity_Analysis
% uiwait(Sensitivity_Analysis)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Costs_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Cost_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% --- Executes on button press in Risk.
function Risk_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Risk_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% --- Executes on button press in Screening.
function Screening_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Screening_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% --- Executes on button press in Mortality.
function Mortality_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(Mortality_Settings)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Number_patients_Callback(hObject, eventdata, handles) %#ok<*INUSL>
tmp=get(handles.Number_patients, 'value');
value = handles.Variables.NumberPatientsValues(tmp);  
handles.Variables.Number_patients = value;
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   functions for benchmark input                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% opens GUI to adjust early adenoma benchmarks
function EarlyBenchmarks_Callback(hObject, eventdata, handles) %#ok<*INUSL>
set(0, 'userdata', handles.Variables);
Step_1_Benchmarks_EarlyAdenoma
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% opens GUI to adjust advanced adenoma benchmarks including dwell time
function AdvBenchmarks_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
set(0, 'userdata', handles.Variables);
Step_2_Benchmarks_AdvancedAdenoma
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% opens GUI to adjust carcinoma benchmarks including polyp danger
function CaBenchmarks_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Step_3_Benchmarks_Carcinoma
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

% opens GUI to adjust benchmarks for direct cancer, using the
% rectosigmoidoscopy study for benchmarking
function RSRCT_benchmarks_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Step_4_Benchmarks_RSRCT
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   functions for automated adjustment of program settings         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Step1.
function Step1_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Auto_Calibration_Step_1
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Step2_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Auto_Calibration_Step_2
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)

function Step3_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Auto_Calibration_Step_3
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles)    

function Step4_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
Auto_Calibration_Step_4
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles) 

function ManualAdjustments_Callback(hObject, eventdata, handles)
set(0, 'userdata', handles.Variables);
uiwait(ManualAdjustments)
handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
guidata (hObject, handles) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   create functions                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function settings_name_CreateFcn(hObject, eventdata, handles) %#ok<INUSD>
function SaveDataPath_Edit_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function comment_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function Number_patients_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function special_text_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function popupmenu1_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>

function RMSIncCutoff_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function RMSAdvPolypCutoff_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function RMSPolypCutoff_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function RMSEarlyCutoff_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function Default_SettingsName_CreateFcn(hObject, eventdata, handles)%#ok<INUSD>
function Untitled_1_Callback(hObject, eventdata, handles)%#ok<INUSD>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   START                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_Callback(hObject, eventdata, handles)
[handles, BM] = CalculateSub(handles);%#ok<ASGLU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         START BATCH                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function start_batch_Callback(hObject, eventdata, handles)

OldVariables = handles.Variables;
if isdir(handles.Variables.ResultsPath)
    ResultsPath = handles.Variables.ResultsPath;
elseif isdir(handles.Variables.CurrentPath)
    ResultsPath = handles.Variables.CurrentPath;
else
    ResultsPath = uigetdir(handles.Variables.CurrentPath, 'Please select path to save results');
end
handles.Variables.StarterFlag = 'on';

try
    for f = 1 : length(handles.Variables.Starter.CurrentSummary)
        handles.Variables = importdata(fullfile(handles.Variables.Starter.CurrentPath{f}, ...
            handles.Variables.Starter.CurrentSummary{f}));
        handles.Variables.StarterFlag = 'on';
        handles.Variables.Starter = OldVariables.Starter;
        handles.Variables.Starter.Counter = f;
        handles.Variables.ResultsPath = ResultsPath;
        [handles, BM] = CalculateSub(handles); %#ok<ASGLU>
    end
    handles.Variables = OldVariables;
catch
    handles.Variables = OldVariables;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
    rethrow(lasterror) %#ok<LERR>
end

% Default Benchmarks.
function DefaultBenchmarks_Callback(hObject, eventdata, handles)
handles = Default_Benchmarks(handles);
msgbox('Default settings restored')
guidata(hObject, handles)


% Automatic settings; routine writes a series of files which test basic
% characteristics of a given set of settings
function Automatic_settings_Callback(hObject, eventdata, handles)
Automatic_Settings_Writing(handles)

function Repeate_identical_settings_Callback(hObject, eventdata, handles)
PathName = uigetdir(handles.Variables.ResultsPath, 'Select folder to save files');
if isequal(PathName, 0) 
    return
end  

BaseName = handles.Variables.Settings_Name;
answer = inputdlg({'Please select base name for files!', 'Number replicas'}, 'Write settings repetitively', 1, {BaseName, num2str(10)});
if isempty(answer)
    return
end
BaseName = answer{1};
[NumberReplica, status] = str2num(answer{2}); %#ok<ST2NM>
if ~status
    return
end

Variables = handles.Variables; %#ok<NASGU>
for f= 1:NumberReplica
    if and(NumberReplica>100, f<10)
        tmp = [BaseName '_00' num2str(f)];
    elseif and(NumberReplica>100, f<100)
        tmp = [BaseName '_0' num2str(f)];
    elseif f<10
        tmp = [BaseName '_0' num2str(f)];
    else
        tmp = [BaseName '_' num2str(f)];
    end
    save(fullfile(PathName, tmp), 'Variables');
end
msgbox('files have been written')

function Write_PBP_Script_Callback(hObject, eventdata, handles)
PoorBowelPrep_WriteScript(handles)

function Automatic_RS_Callback(hObject, eventdata, handles)
Automatic_RS_Screen(handles)

function Automatic_RS_reading_Callback(hObject, eventdata, handles)
[AnalysisPipeline, DirectCancerSpeed, mod] = Evaluate_RS_Scan(handles.Variables.ResultsPath);
if isequal(mod, 'OK')
    button = questdlg(sprintf('Direct cancer speed %.2f. Do you want to keep the calculated value for direct cancer?',DirectCancerSpeed), 'title');
    if isequal(button, 'Yes')
        handles.Variables.DirectCancerSpeed = DirectCancerSpeed/10000000;
        handles.Variables.ResultsPath = AnalysisPipeline;
        handles = MakeImagesCurrent(hObject, handles);
        guidata(hObject, handles)
    end
end

function Auto_calib_123_Callback(hObject, eventdata, handles)
handles = AutomaticCalibration_Steps123(handles, 'normal');
handles = MakeImagesCurrent(hObject, handles);
guidata(hObject, handles)

function Auto_calib_123_bootstrapping_Callback(hObject, eventdata, handles)
handles = AutomaticCalibration_Steps123(handles, 'bootstrapping');
handles = MakeImagesCurrent(hObject, handles);
guidata(hObject, handles)
