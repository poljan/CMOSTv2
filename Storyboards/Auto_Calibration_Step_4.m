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

function varargout = Auto_Calibration_Step_4(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Auto_Calibration_Step_4_OpeningFcn, ...
                   'gui_OutputFcn',  @Auto_Calibration_Step_4_OutputFcn, ...
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


function Auto_Calibration_Step_4_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>

handles.Variables = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.Start, 'interruptible', 'on')

% scenarios
handles.Flow.AllScenarios = {'RCT Atkin, Lancet 2010', 'RCT Schoen, NEJM, 2012', 'RCT Holme, JAMA 2014',...
    'RCT Segnan, JNCI 2011'};
handles.Flow.Scenario     = 'RCT Atkin, Lancet 2010';

handles.Variables.MaxIterations = 50;

% we initialize flow variables
handles.Flow.Iteration = 0;
handles.Flow.RCT_left  = 0;
handles.Flow.RCT_right = 0;
handles.Flow.RCT_ov    = 0;
handles.Flow.NumberAveraging   = 5;
handles.Flow.DirectCancerSpeed = 0;

% we initialize variables for incidence/ mortality reduction
handles.Flow.Inc_red_left   = 0;
handles.Flow.Inc_red_right  = 0;
handles.Flow.Inc_red_ov     = 0;
handles.Flow.RelInc_red_ov  = 0;
handles.Flow.Mort_red       = 0;

handles.BM.Graph.DirectCa.All   = 0;
handles.BM.Graph.DirectCa.Right = 0;

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles, handles.BM);
guidata(hObject, handles);
% UIWAIT makes EarlyAdenomaBenchmarks wait for user response (see UIRESUME)
uiwait(handles.figure1);


function varargout = Auto_Calibration_Step_4_OutputFcn(hObject, eventdata, handles)  %#ok<INUSL>
handles.output = 1;
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Images current                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this functions makes all chages to values visible
function handles = MakeImagesCurrent(hObject, handles, BM)
% This function is called whenever a change is made within the GUI. This 
% function makes these changes visible

FontSz   = 10;
MarkerSz = 5; %#ok<NASGU>
LineSz   = 0.4; %#ok<NASGU>

set(handles.Stop, 'enable', 'on');

set(handles.Direct_cancer_variable, 'string', num2str(handles.Variables.DirectCancerSpeed)) %adj
set(handles.Direct_cancer_variable, 'enable', 'off')
set(handles.Inc_red_ov_goal, 'string', num2str(handles.Variables.Benchmarks.RSRCTRef.IncRedOverall))
set(handles.Inc_red_ov_goal, 'enable', 'off')
set(handles.Iteration_number, 'string', num2str(handles.Flow.Iteration))
set(handles.Iteration_number, 'enable', 'off')
set(handles.max_iterations, 'string', num2str(handles.Variables.MaxIterations));
if handles.Flow.NumberAveraging > handles.Variables.MaxIterations
handles.Flow.NumberAveraging = handles.Variables.MaxIterations;
end
set(handles.NumberAveraging, 'string', num2str(handles.Flow.NumberAveraging)) 

% scenarios
tmp = 1;
for f=1:length(handles.Flow.AllScenarios)
    if isequal(handles.Flow.Scenario, handles.Flow.AllScenarios{f});
        tmp = f;
    end
end
set(handles.Scenario, 'string', handles.Flow.AllScenarios)
set(handles.Scenario, 'value', tmp)

% we adjust the incidence/ mortality reduction fields
set(handles.inc_red_left, 'string', num2str(handles.Flow.Inc_red_left))
set(handles.inc_red_left, 'enable', 'off')
set(handles.inc_red_right, 'string', num2str(handles.Flow.Inc_red_right))
set(handles.inc_red_right,'enable', 'off')
set(handles.inc_red_ov, 'string', num2str(handles.Flow.Inc_red_ov))
set(handles.inc_red_ov, 'enable', 'off')
set(handles.mort_red, 'string', num2str(handles.Flow.Mort_red))
set(handles.mort_red, 'enable', 'off')

axes(handles.direct_cancer), cla(handles.direct_cancer)
bar([BM.Graph.DirectCa.All BM.Graph.DirectCa.Right])
set(gca, 'ylim', [0 100])
line ([0.25 2.75], [50 50], 'color', 'r')
line ([0.25 2.75], [20 20], 'color', 'g')
set(gca, 'xticklabel', {'all Ca' 'right side'}), ylabel('% direct cancer', 'fontsize', FontSz)
set(gca, 'fontsize', FontSz), title('fraction of all carcinoma without polyp precursor', 'fontsize', FontSz-2)

% Adjusting RMS Graph 
Iteration = handles.Flow.Iteration;
if isequal(Iteration, 0)
    Iteration = 1;
end
axes(handles.RMS_RSRCT); cla(handles.RMS_RSRCT) %#ok<*MAXES>
plot(1:Iteration, handles.Flow.RCT_left(1:Iteration)), hold on
for f=1:Iteration
    plot(f, handles.Flow.RCT_left(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
plot(1:Iteration, handles.Flow.RCT_right(1:Iteration))
for f=1:Iteration
    plot(f, handles.Flow.RCT_right(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',3)
end 
plot(1:Iteration, handles.Flow.RCT_ov(1:Iteration))
for f=1:Iteration
    plot(f, handles.Flow.RCT_ov(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjusting direct cancer history graph
axes(handles.DirectCancerVar_history); cla(handles.DirectCancerVar_history) %#ok<*MAXES>
plot(1:Iteration, handles.Flow.DirectCancerSpeed(1:Iteration)), hold on
for f=1:Iteration
    plot(f, handles.Flow.DirectCancerSpeed(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjusting the rel. inc red. overall graph
axes(handles.Diff_IncRed); cla(handles.Diff_IncRed) %#ok<*MAXES>
plot(1:Iteration, handles.Flow.RelInc_red_ov(1:Iteration)), hold on
for f=1:Iteration
    plot(f, handles.Flow.RelInc_red_ov(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

guidata(hObject, handles);
drawnow

            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Return_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
Answer = questdlg('Do you want to keep the settings?', 'Return?', 'Yes', 'No', 'Cancel', 'Yes');
if isequal(Answer, 'Cancel')
    return
elseif isequal(Answer, 'No')
    handles.Variables = handles.OldVariables;
end
set(0, 'userdata', handles.Variables);
uiresume(handles.figure1);

if ishandle(handles.figure1)
    delete(handles.figure1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stop                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Stop_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
handles.StopFlag = 'on';
set(handles.Stop, 'enable', 'off');
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Function                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% here we got all functions inactivated
function Iteration_number_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Inc_red_ov_goal_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Direct_cancer_variable_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Scenario_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function NumberAveraging_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

function inc_red_left_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function inc_red_right_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function inc_red_ov_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function mort_red_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function max_iterations_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

function inc_red_left_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function inc_red_right_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function inc_red_ov_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function mort_red_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

function Iteration_number_Callback(hObject, ~, handles) %#ok<INUSD,DEFNU>
function Inc_red_ov_goal_Callback(hObject, ~, handles) %#ok<INUSD,DEFNU>
function Direct_cancer_variable_Callback(hObject, ~, handles) %#ok<INUSD,DEFNU>

function max_iterations_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.max_iterations, 'string'); [num, succ] =str2num(tmp); %#ok<ASGLU,ST2NM>
handles.Variables.MaxIterations = abs(round(num));
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

function NumberAveraging_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.NumberAveraging, 'string'); [num, succ] =str2num(tmp); %#ok<ASGLU,ST2NM>
handles.Flow.NumberAveraging = abs(round(num));
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

function Scenario_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.Scenario, 'value');
handles.Flow.Scenario = handles.Flow.AllScenarios{tmp};
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>

set(handles.Stop, 'enable', 'on');

% we backup the flags
DispFlagBackup    = handles.Variables.DispFlag;
ResultsFlagBackup = handles.Variables.ResultsFlag;
ExcelFlagBackup   = handles.Variables.ExcelFlag;
DirectCancerSpeedBackup = handles.Variables.DirectCancerSpeed;

% we start
handles.Variables.DispFlag    = 0;
handles.Variables.ResultsFlag = 0;
handles.Variables.ExcelFlag   = 0;

SpecialBackup     = handles.Variables.SpecialFlag;
SpecialTextBackup = handles.Variables.SpecialText;

handles.Variables.SpecialFlag  ='on';
IncRedOv_Ref = handles.Variables.Benchmarks.RSRCTRef.IncRedOverall;

% % handles.Variables.Location_DirectCa           = [1, 1, 1, 0.7773, 0.2227, 0.0230, 0.0019, 0.0002, 0.0, 0.0, 0.0, 0.0, 0.0]; 
%generated using  the sigmoid z=1./(1+exp(2.5*(y-4.5)));

% % handles.Variables.Location_DirectCa           = [1, 1, 0.998, 0.977, 0.777, 0.2223, 0.023, 0.0019, 0.0002, 0.0, 0.0, 0.0, 0.0]; 
%generated using  the sigmoid z=1./(1+exp(2.5*(y-5.5)));

for i=1:handles.Variables.MaxIterations
    
    switch handles.Flow.Scenario
        case 'RCT Atkin, Lancet 2010'
            SpecialText1  ='RS-RCT';
            SpecialText2  ='RS-RCT_Mock';
        case 'RCT Schoen, NEJM, 2012'
            SpecialText1  ='RS-RCT-Validation';
            SpecialText2  ='RS-RCT-Validation_Mock';
        case 'RCT Holme, JAMA 2014'
            SpecialText1  ='RS-Holme';
            SpecialText2  ='RS-Holme_Mock';
        case 'RCT Segnan, JNCI 2011'
            SpecialText1  ='RS-Segnan';
            SpecialText2  ='RS-Segnan_Mock';
    end
    % we run the calculations - the screening arm
    handles.Variables.SpecialText  = SpecialText1;
    [handles, BM] = CalculateSub(handles);
    RSRCT_trial = BM.RSRCT;
    
    % we run the calculations - the control arm
    handles.Variables.SpecialText  = SpecialText2;
    [handles, BM] = CalculateSub(handles);
    RSRCT_mock  = BM.RSRCT;
    
    % a cancer to the splenic flexure is considered
    % distal, transverse through cecum proximal
    % 1 Cecum
    % 2 Ascendens
    % 3 Ascendens
    % 4 re Flexur
    % 5 transversum
    % 6 transversum
    % 7 junction
    % 8 descendens
    % 9 descendens
    % 10 junction
    % 11 sigma
    % 12 sigma
    % 13 rectum
    
    % calculations for the mock population
    Mock_right_2        = sum(RSRCT_mock.Tumor(:, 1:6), 2);
    Mock_left_2         = sum(RSRCT_mock.Tumor(:, 7:13), 2);
    Mock_all            = sum(RSRCT_mock.Tumor(:, 1:13), 2);
    
    Mock_Mortality      = RSRCT_mock.Mortality;
    Mock_NumberSurvived = RSRCT_mock.NumberSurvived; %#ok<NASGU>
    
    % calculations for the treated population
    RS_right_2          = sum(RSRCT_trial.Tumor(:, 1:6), 2);
    RS_left_2           = sum(RSRCT_trial.Tumor(:, 7:13), 2);
    RS_all              = sum(RSRCT_trial.Tumor(:, 1:13), 2);
    
    RS_Mortality       = RSRCT_trial.Mortality;
    RS_NumberSurvived  = RSRCT_trial.NumberSurvived; %#ok<NASGU>
    
    for g=1:40
        Inc_right_2(g) = sum(RS_right_2(1:g))/sum(Mock_right_2(1:g))*100; %#ok<AGROW>
        Inc_left_2(g)  = sum(RS_left_2(1:g))/sum(Mock_left_2(1:g))*100; %#ok<AGROW>
        Inc_all(g)     = sum(RS_all(1:g))/sum(Mock_all(1:g))*100; %#ok<AGROW>
        
        Mort(g)        = sum(RS_Mortality(1:g))/sum(Mock_Mortality(1:g))*100; %#ok<AGROW>
    end
    
    IncRed_Ov      = 100 - Inc_all(11);
    IncRed_Left    = 100 - Inc_left_2(11);
    IncRed_Right   = 100 - Inc_right_2(11);
    MortRed        = 100 - Mort(13);

    handles.Flow.RCT_left(i)   = IncRed_Left; 
    handles.Flow.RCT_right(i)  = IncRed_Right;
    handles.Flow.RCT_ov(i)     = IncRed_Ov;
    handles.Flow.RelInc_red_ov(i) = IncRed_Ov - IncRedOv_Ref;
    handles.Flow.DirectCancerSpeed(i) = handles.Variables.DirectCancerSpeed;
    
    handles.Flow.Inc_red_left  = IncRed_Left;
    handles.Flow.Inc_red_right = IncRed_Right;
    handles.Flow.Inc_red_ov    = IncRed_Ov;
    handles.Flow.Mort_red      = MortRed;
    
    handles.Flow.Iteration = i;
    
    handles.Variables.DirectCancerSpeed = handles.Variables.DirectCancerSpeed * sqrt(abs(IncRed_Ov/IncRedOv_Ref));
    
    % we make the changes visible
    handles = MakeImagesCurrent(hObject, handles, BM);
    if isequal(get(handles.Stop, 'enable'), 'off')
        break
    end
end

% we get back the flags
handles.Variables.DispFlag    = DispFlagBackup;
handles.Variables.ResultsFlag = ResultsFlagBackup;
handles.Variables.ExcelFlag   = ExcelFlagBackup;

handles.Variables.SpecialFlag = SpecialBackup;
handles.Variables.SpecialText = SpecialTextBackup;

choice = questdlg('Do you want to keep the result of this run of optimization?',...
    'Keep results?','yes', 'no', 'yes');
switch choice
    case    'no'
        handles.Variables.DirectCancerSpeed = DirectCancerSpeedBackup;
    case 'yes'
        handles.Variables.DirectCancerSpeed = mean(handles.Flow.DirectCancerSpeed((end-handles.Flow.NumberAveraging+1):end));
end
handles = MakeImagesCurrent(hObject, handles, BM); %#ok<NASGU>
