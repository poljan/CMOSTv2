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

function varargout = Auto_Calibration_Step_1(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibration_Step_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibration_Step_1_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Opening function                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Calibration_Step_1_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>

handles.Variables = get(0, 'userdata');
handles.OldVariables = handles.Variables;
handles = InitializeValues(handles);

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles, handles.BM);
guidata(hObject, handles);
% UIWAIT makes EarlyAdenomaBenchmarks wait for user response (see UIRESUME)
uiwait(handles.figure1);

function handles = InitializeValues(handles)
% we initialize flow variables
handles.Flow.StopFlag = 'off';
handles.Flow.Iteration = 1;
handles.Flow.RMS_prevalence_current =0;
handles.Flow.RMS_distribution_current =0;
handles.Flow.RMSMPop = 0;
handles.Flow.RMSE    = 0;
handles.Flow.RMS_adenoma_distribution_current =0;
handles.Flow.RMSP    = 0;

handles.Flow.Message = 'press START to start optimization';

handles.Flow.Number_first_iteration  = 10;
handles.Flow.Number_second_iteration = 30;

% we initialize variables for the adenoma prevalence graphs
handles.BM.Graph.EarlyAdenoma_Ov     = zeros(1, 100);
handles.BM.Graph.EarlyAdenoma_Male   = zeros(1, 100);
handles.BM.Graph.EarlyAdenoma_Female = zeros(1, 100);

for f=1:length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y)
    handles.BM.OutputFlags.EarlyAdenoma_Ov {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.EarlyPolyp.Male_y)
    handles.BM.OutputFlags.EarlyAdenoma_Male   {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.EarlyPolyp.Female_y)
    handles.BM.OutputFlags.EarlyAdenoma_Female {f} = 'red';
end

handles.BM.OutputValues.EarlyAdenoma_Ov     = zeros(1, length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y));
handles.BM.OutputValues.EarlyAdenoma_Male   = zeros(1, length(handles.Variables.Benchmarks.EarlyPolyp.Male_y));
handles.BM.OutputValues.EarlyAdenoma_Female = zeros(1, length(handles.Variables.Benchmarks.EarlyPolyp.Female_y));

% we initialize variables for the adenoma distribution graphs
for f=1:length(handles.Variables.Benchmarks.MultiplePolyp)
    handles.BM.OutputFlags.MidPop {f} = 'red';
end
handles.BM.OutputValues.YoungPop = zeros(1, length(handles.Variables.Benchmarks.MultiplePolypsYoung));
handles.BM.OutputValues.MidPop   = zeros(1, length(handles.Variables.Benchmarks.MultiplePolyp));
handles.BM.OutputValues.OldPop   = zeros(1, length(handles.Variables.Benchmarks.MultiplePolypsOld));

% we initialalizte record for adenoma stage distribution 1:4
handles.BM.Polyp_early        = zeros(6,1);
handles.BM.BM_value_early     = zeros(6,1);    
for f=1:6
    handles.BM.Pflag{f}       = 'red';
end

% we initialize the RMS record
handles.BM.RMSMPop = 0;
handles.BM.RMSE    = 0;
handles.BM.RMSP    = 0;



function varargout = Calibration_Step_1_OutputFcn(hObject, eventdata, handles)  %#ok<INUSL>
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
MarkerSz = 5;
LineSz   = 0.4;

set(handles.Stop, 'enable', 'on');
set(handles.message, 'string', handles.Flow.Message)

set(handles.RMS_prevalence_current, 'string', num2str(handles.Flow.RMS_prevalence_current), 'enable', 'off')
set(handles.RMS_distribution_current, 'string', num2str(handles.Flow.RMS_distribution_current), 'enable', 'off')
set(handles.RMS_stage_distribution_current, 'string', num2str(handles.Flow.RMS_adenoma_distribution_current), 'enable', 'off')

set(handles.Number_first_iteration, 'string', num2str(handles.Flow.Number_first_iteration))
set(handles.number_second_iteration, 'string', num2str(handles.Flow.Number_second_iteration))

set(handles.Iteration_number, 'string', num2str(handles.Flow.Iteration), 'enable', 'off')

% young population
MakeGraphik2(handles.Pop_young, BM.OutputValues.YoungPop, handles.Variables.Benchmarks.MultiplePolypsYoung,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'young population (40-54y)')

% intermediate population
MakeGraphik2(handles.Pop_intermediate, BM.OutputValues.MidPop, handles.Variables.Benchmarks.MultiplePolyp,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'intermediate population (55-74y)')

try
    for f=1:length(BM.OutputValues.MidPop)
        line([f-0.5 f+0.5], [BM.OutputValues.MidPop(f) BM.OutputValues.MidPop(f)], 'color', BM.OutputFlags.MidPop{f})
        plot(f, BM.OutputValues.MidPop(f), '--ks', 'MarkerEdgeColor', BM.OutputFlags.MidPop{f},...
            'MarkerFaceColor', BM.OutputFlags.MidPop{f}, 'MarkerSize',MarkerSz)
    end

% old population
MakeGraphik2(handles.Pop_old, BM.OutputValues.OldPop, handles.Variables.Benchmarks.MultiplePolypsOld,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'old population (75-90y)')
        
% overall
MakeGraphik(handles.Ad_Ov_Axes, BM.Graph.EarlyAdenoma_Ov, handles.Variables.Benchmarks.EarlyPolyp.Ov_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Ov_perc, BM.OutputValues.EarlyAdenoma_Ov,...
    BM.OutputFlags.EarlyAdenoma_Ov, 'Prevalence adenoma overall', 'percent of patients', LineSz, MarkerSz, FontSz)

% male
MakeGraphik(handles.Ad_Male_Axes, BM.Graph.EarlyAdenoma_Male, handles.Variables.Benchmarks.EarlyPolyp.Male_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Male_perc, BM.OutputValues.EarlyAdenoma_Male,...
    BM.OutputFlags.EarlyAdenoma_Male, 'Prevalence adenoma male', 'percent of patients', LineSz, MarkerSz, FontSz)

% female
MakeGraphik(handles.Ad_Female_Axes, BM.Graph.EarlyAdenoma_Female, handles.Variables.Benchmarks.EarlyPolyp.Female_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Female_perc, BM.OutputValues.EarlyAdenoma_Female,...
    BM.OutputFlags.EarlyAdenoma_Female, 'Prevalence adenoma female', 'percent of patients', LineSz, MarkerSz, FontSz)
guidata(hObject, handles);

catch
    rethrow (lasterror) %#ok<LERR>
end

% Adenoma distribution
axes(handles.Ad_stage_distribution), cla(handles.Ad_stage_distribution)
bar(cat(2, BM.Polyp_early, zeros(6,1), BM.BM_value_early)', 'stacked'), hold on
for f=1:4 
    if isequal(f, 1), LinePos(f) = BM.Polyp_early(f)/2; 
    else LinePos(f) = sum(BM.Polyp_early(1:f-1))+BM.Polyp_early(f)/2;
    end
end
for f=1:4
    line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', BM.Pflag{f})
end    
l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Adenoma P5', 'Adv Adenoma P6');
set(l, 'location', 'northoutside', 'fontsize', FontSz)
ylabel('% of affected patients', 'fontsize', FontSz)
title('distribution of P1 ... P4 adenoma stages')
set(gca, 'xticklabel', {'adenomas' '' 'benchmark' ''}, 'fontsize', FontSz, 'ylim', [0 100])

Iteration = handles.Flow.Iteration;
% Adjusting RMS Graph early
axes(handles.RMS_Early); cla(handles.RMS_Early) %#ok<*MAXES>
plot(1:Iteration, BM.RMSE(1:Iteration)), hold on
for f=1:Iteration
    plot(f, BM.RMSE(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
title('RMS adenoma prevalence', 'fontsize', FontSz)

% Adjusting RMS Graph population
axes(handles.RMS_Pop); cla(handles.RMS_Pop) %#ok<*MAXES>
plot(1:Iteration, BM.RMSMPop(1:Iteration)), hold on
for f=1:Iteration, 
    plot(f, BM.RMSMPop(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
title('RMS adenoma distribution', 'fontsize', FontSz)

% Adjusting RMS for adenoma stage distribution
axes(handles.RMS_adenoma_stage_distribution); cla(handles.RMS_adenoma_stage_distribution) %#ok<*MAXES>
plot(1:Iteration, BM.RMSP(1:Iteration)), hold on
for f=1:Iteration, 
    plot(f, BM.RMSP(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
title('RMS adenoma stage distribution', 'fontsize', FontSz)
drawnow

drawnow

function MakeGraphik(AxHandle, DataGraph, BM_year, BM_value, BM_current, BM_flags, GraphTitle, LabelY, LineSz, MarkerSz, FontSz)
axes(AxHandle), cla(AxHandle) 
plot(0:99, DataGraph, 'color', 'k'), hold on
plot(BM_year, BM_value, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)

for f=1:length(BM_year)
    plot(BM_year(f), BM_current(f), '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', BM_flags{f}, 'MarkerSize',3)
    line([BM_year(f)-2 BM_year(f)+2], [BM_current(f) BM_current(f)], 'color', BM_flags{f});
end
xlabel('year', 'fontsize', FontSz), ylabel(LabelY, 'fontsize', FontSz), title(GraphTitle, 'fontsize', FontSz)
set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])

function MakeGraphik2(AxHandle, Population, Benchmark, LineSz, MarkerSz, FontSz, XaxisLabel, YaxisLabel, FigTitle)
axes(AxHandle), cla(AxHandle) 
plot(Population,   '--ks','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','m', 'MarkerSize',MarkerSz), hold on
plot(Benchmark,    '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
xlabel(XaxisLabel, 'fontsize', FontSz); ylabel(YaxisLabel, 'fontsize', FontSz)
set(gca, 'XTick', [1 2 3 4 5]), title(FigTitle, 'fontsize', FontSz), set(gca, 'fontsize', FontSz)
                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First and second iteration         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Number_first_iteration_Callback(hObject, eventdata, handles)%#ok<INUSL,DEFNU>
tmp=get(handles.Number_first_iteration, 'string'); [num, succ] =str2num(tmp); %#ok<ASGLU,ST2NM>
handles.Flow.Number_first_iteration = abs(round(num));
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

function number_second_iteration_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.number_second_iteration, 'string'); [num, succ] =str2num(tmp);%#ok<ASGLU,ST2NM>
handles.Flow.Number_second_iteration = abs(round(num));
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

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
handles.Flow.StopFlag = 'on';
set(handles.Stop, 'enable', 'off');
drawnow
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Functions                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Iteration_number_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_distribution_goal_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function RMS_prevalence_goal_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function RMS_distribution_current_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function RMS_prevalence_current_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function Number_first_iteration_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function number_second_iteration_CreateFcn(hObject, eventdata, handles)%#ok<DEFNU,INUSD>
function RMS_stage_distribution_current_CreateFcn(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_prevalence_current_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function Iteration_number_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_prevalence_goal_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_distribution_goal_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_distribution_current_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSD>
function RMS_stage_distribution_current_Callback(hObject, eventdata, handles)%#ok<DEFNU,INUSD>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% es geht los
handles.Flow.Message = sprintf('Approaching optimimum best of %d steps will be used', handles.Flow.Number_first_iteration);
set(handles.message, 'string', handles.Flow.Message)
drawnow
 
% we backup the flags
DispFlagBackup    = handles.Variables.DispFlag;
ResultsFlagBackup = handles.Variables.ResultsFlag;
ExcelFlagBackup   = handles.Variables.ExcelFlag;
VariablesBackup   = handles.Variables;

handles.Variables.DispFlag     = 0;
handles.Variables.ResultsFlag  = 0;
handles.Variables.ExcelFlag    = 0;
index_age=1:20;

RMSYPop = 0;
RMSMPop = 0;
RMSOPop = 0;
RMSE    = 0;
RMSP    = 0;
BMEarlyy      = cell(1,1);
BMPop         = cell(1,1);
BMMPop        = cell(1,1);
BMProgression = cell(1,1);

% we get the benchmarks for adenoma prevalence
BM_Early_year = handles.Variables.Benchmarks.EarlyPolyp.Ov_y;  %#ok<NASGU>
BM_Early_perc  = handles.Variables.Benchmarks.EarlyPolyp.Ov_perc; %#ok<NASGU>

% we get the benchmarks for adenoma distribution
BM_YPop   = handles.Variables.Benchmarks.MultiplePolypsYoung;
BM_MPop   = handles.Variables.Benchmarks.MultiplePolyp;
BM_OPop   = handles.Variables.Benchmarks.MultiplePolypsOld;
BM_OvPop  = 1/3*(BM_YPop+BM_MPop+BM_OPop); 

i=1;
for j=1:length(BM_MPop)
    CoeffsPop{i}(j) = 0.5*BM_MPop(6-j);
end
% transform to logarithmic scale
handles.Variables.IndividualRisk = logscale(CoeffsPop{i});

% we transform the graph described by the benchmarks into a vector of
% parameters, a sigmoid function is assumed
B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y, handles.Variables.Benchmarks.EarlyPolyp.Ov_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
CoeffsEarly{1} = B;
EEarly{20} = B;

handles = AdaptRates(handles, CoeffsEarly{i}, CoeffsPop{i}, index_age, i);

i=1; % the first run...
[~, BM]=CalculateSub(handles);

[BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
CalculateRMS(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i);

B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
CoeffsEarly{i} = B;
EEarly{i}      = B;

% we save the correction factor
FemFactor(1) = handles.Variables.new_polyp_female;

% we save the start values for the adenoma progression
BMProgression{i} = handles.Variables.Progression;

% we put the results to the graphical user interphase
BM.RMSMPop = RMSMPop; BM.RMSE = RMSE; BM.RMSP = RMSP;
handles.Flow.RMS_prevalence_current   = RMSE(i);
handles.Flow.RMS_distribution_current = RMSMPop(i);
handles.Flow.RMS_adenoma_distribution_current = RMSP(i);

handles.Flow.Iteration = i;
handles = MakeImagesCurrent(hObject, handles, BM);

KeepFlag = -1;
for i=2:handles.Flow.Number_first_iteration
    drawnow
    if isequal(get(handles.Stop, 'enable'), 'off')
       choice = questdlg('Do you want to keep the best result of this run of optimization?',...
           'Keep results?','yes', 'no', 'cancel', 'cancel'); 
       switch choice
           case    'yes'
               KeepFlag = 1;
               % we look for the best coefficients
               tmp1 = sort(RMSE);
               for f=1:length(RMSE), tmp1R(f)=find(tmp1==RMSE(f), 1); end 
               tmp2 = sort(RMSMPop);
               for f=1:length(RMSMPop), tmp2R(f)=find(tmp2==RMSMPop(f), 1); end  
               tmp3 = sort(RMSP);
               for f=1:length(RMSP), tmp3R(f)=find(tmp3==RMSP(f), 1); end  
               
               tmp     = tmp1R + tmp2R + tmp3R;
               MinAll  = find(tmp     == min(tmp(1:(i-1))), 1);
               CoeffsEarlyFinal                   = CoeffsEarly{MinAll};
               CoeffsPopFinal                     = CoeffsPop{MinAll};
               CoeffsProgressionFinal             = BMProgression{MinAll}; %#ok<NASGU>
               
               handles.Variables.new_polyp_female = FemFactor(MinAll);
               handles.Variables.Progression      = BMProgression{MinAll};
               i=i-1; %#ok<FXSET>
               break
           case    'no'
               KeepFlag = 0;
               break
       end
    end    
    % we adjust early polyp parameters 
    B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i-1},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
    
    CoeffsEarly{i}(1) = CoeffsEarly{i-1}(1)*exp(-0.10*(EEarly{i-1}(1)-EEarly{20}(1))) * exp(-0.1*BM_OvPop(1)/BMPop{i-1}(1)) ;
    CoeffsEarly{i}(2) = CoeffsEarly{i-1}(2)-1*(EEarly{i-1}(2)-EEarly{20}(2)) ;
    CoeffsEarly{i}(3) = CoeffsEarly{i-1}(3)-0.5*(EEarly{i-1}(3)-EEarly{20}(3)) ;
    
    B(2) = CoeffsEarly{i}(2);
    B(3) = CoeffsEarly{i}(3); %#ok<NASGU>
    
    % we adjust adenoma ditribution parameters 
    for j=1:5
        CoeffsPop{i}(j) = CoeffsPop{i-1}(j) * (BM_MPop(j)/BMMPop{i-1}(j))^0.5;
    end
    
    % we adjust male/ female ratios
    
    MaleSum = 0; FemaleSum = 0;
    for f = 1:length(handles.Variables.Benchmarks.EarlyPolyp.Male_y)
        % we check, how much the male prevalence for early adenoma remains
        % above benchmarks
        MaleSum = MaleSum + (BM.OutputValues.EarlyAdenoma_Male(f) - handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f))/...
            handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f);
    end
    for f = 1:length(handles.Variables.Benchmarks.EarlyPolyp.Female_y)
        % we check, how much the female prevalence for early adenoma remains
        % above benchmarks
        FemaleSum = FemaleSum + (BM.OutputValues.EarlyAdenoma_Female(f) - handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f))/...
            handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f);
    end
    FemaleSum = FemaleSum/length(handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f));
    MaleSum   = MaleSum/length(handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f));
    
    Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
    handles.Variables.new_polyp_female = handles.Variables.new_polyp_female * Factor;
    
    FemFactor(i) = handles.Variables.new_polyp_female; 
    handles = AdaptRates(handles, CoeffsEarly{i}, CoeffsPop{i}, index_age, i);
    
    % we adjust adenoma stage ditribution parameters  
    if mod(i, 2)
        for f=2:2:4
            Factor = (BM.Polyp_early(f)/BM.BM_value_early(f))^(1/3);
            handles.Variables.Progression(f-1) = handles.Variables.Progression(f-1) /Factor;
        end
    else
        for f=3:2:4
            Factor = (BM.Polyp_early(f)/BM.BM_value_early(f))^(1/3);
            handles.Variables.Progression(f-1) = handles.Variables.Progression(f-1) /Factor;
        end
    end
    BMProgression{i} = handles.Variables.Progression;
    
    % the next iteration
    [~, BM] = CalculateSub(handles);
    
    % we use subfunction to calculate the RMS
    [BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
        CalculateRMS(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i);
    
    B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
    EEarly{i} = B;
    
    % we put the numbers to the display
    BM.RMSE = RMSE;
    BM.RMSP = RMSP;
    BM.RMSMPop = RMSMPop;
    handles = MakeImagesCurrent(hObject, handles, BM);
end

if isequal(KeepFlag, -1) % user did not interrupt
    % the next step will be fminsearch
    % we look for the best coefficients
    % we look for the best coefficients
    tmp1 = sort(RMSE);
    for f=1:length(RMSE), tmp1R(f)=find(tmp1==RMSE(f), 1); end 
    tmp2 = sort(RMSMPop);
    for f=1:length(RMSMPop), tmp2R(f)=find(tmp2==RMSMPop(f), 1); end
    tmp3 = sort(RMSP);
    for f=1:length(RMSP), tmp3R(f)=find(tmp3==RMSP(f), 1); end
    
    tmp     = tmp1R + tmp2R + tmp3R;
    MinAll  = find(tmp     == min(tmp(1:(i-1))), 1);
    
    CoeffEarly_Start = CoeffsEarly{MinAll}; % sum minimum was best
    CoeffPop_Start   = CoeffsPop{MinAll};
    handles.Variables.new_polyp_female = FemFactor(MinAll);
    handles.Variables.Progression      = BMProgression{MinAll};
    
    % we save data to be recovered by tempfunction and outfunction
    Calibration_1_temp.Variables = handles.Variables;
    Calibration_1_temp.Flow      = handles.Flow;
    Calibration_1_temp.BM        = BM; %#ok<STRNU>
    
    %%% the path were this program is stored, this must be the CMOST path
    Path = mfilename('fullpath');
    pos = regexp(Path, [mfilename, '$']);
    CurrentPath = Path(1:pos-1);
    cd (fullfile(CurrentPath, 'Temp'))
    save('Calibration_1_temp', 'Calibration_1_temp');
    
    set(handles.message, 'string', 'Adjusting early adenoma prevalence and distribution by Nelder-Mead simplex search')
    drawnow
    options = optimset('OutputFcn', @Auto_Calib_1_OutFunction, 'MaxFunEvals', handles.Flow.Number_second_iteration);
    tmpff = @(x)Auto_Calib_1_TempFunction(x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8));
    [x] = fminsearch(tmpff,[CoeffEarly_Start(1), CoeffEarly_Start(2), CoeffEarly_Start(3),...
        CoeffPop_Start(1), CoeffPop_Start(2), CoeffPop_Start(3), CoeffPop_Start(4), CoeffPop_Start(5)], options);
    choice = questdlg('Do you want to keep the result of this run of optimization?',...
        'Keep results?','yes', 'no', 'yes');
    switch choice
        case    'yes'
            KeepFlag = 1;
            CoeffsEarlyFinal(1:3) = x(1:3);
            CoeffsPopFinal(1:5)   = x(4:8);
        case    'no'
            KeepFlag = 0;
    end
end
if KeepFlag
    handles = AdaptRates(handles, CoeffsEarlyFinal, CoeffsPopFinal, index_age, i);
    handles.Variables.new_polyp_female = FemFactor(MinAll);
    set(handles.message, 'string', 're-running with optimized parameters')
    drawnow
    
    % we run the calculations againd
    [~, BM] = CalculateSub(handles);
    
    % we use subfunction to calculate the RMS
    [BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
        CalculateRMS(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i); %#ok<ASGLU>
    
    % we put the numbers to the display
    handles.Flow.Iteration = i;
    BM.RMSE = RMSE;
    BM.RMSP = RMSP;
    BM.RMSMPop = RMSMPop;

    % we get back the flags
    handles.Variables.DispFlag    = DispFlagBackup;
    handles.Variables.ResultsFlag = ResultsFlagBackup;
    handles.Variables.ExcelFlag   = ExcelFlagBackup;
    handles.Flow.Message          = 'Optimization finished';
    set(handles.message, 'string', handles.Flow.Message)
else
    handles.Variables = VariablesBackup;
    handles = InitializeValues(handles);
end
handles = MakeImagesCurrent(hObject, handles, BM); %#ok<NASGU>

% adapt rates
function handles = AdaptRates(handles, CoeffsEarly, CoeffsPop, index_age, i)

if isequal(i, 1)
    handles.Variables.NewPolypRate  = 0.1*0.90*0.07/50*exp(-0.0*...
        (handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(end)))*...
        CoeffsEarly(1)./(1 + exp(-((index_age*5*CoeffsEarly(2))-14*CoeffsEarly(2)-CoeffsEarly(3))));
else
    handles.Variables.NewPolypRate = 0.3*0.90*0.07/50*exp(-0.0*...
        (handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(end)))*...
        CoeffsEarly(1)./(1 + exp(-((index_age*5*CoeffsEarly(2))-14*CoeffsEarly(2)-CoeffsEarly(3))));
end
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.NewPolyp(counter) = (handles.Variables.NewPolypRate(x1) * (5-x2) + ...
            handles.Variables.NewPolypRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.NewPolyp(counter : 150) = handles.Variables.NewPolypRate(end);

handles.Variables.IndividualRisk = logscale(CoeffsPop);
handles.Variables.IndividualRisk = sort(handles.Variables.IndividualRisk);

if isequal(i, 1)
    handles.Variables.IndividualRisk = 25*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(450));
else
    handles.Variables.IndividualRisk = 5*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(480));
end

% calculate RMS
function [BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
CalculateRMS(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i)

BMEarlyy{i} = BM.OutputValues.EarlyAdenoma_Ov;
BMMPop{i} = BM.OutputValues.MidPop;

for f=1:length(BM.OutputValues.EarlyAdenoma_Ov)
    Ear.BM{f} = BM.OutputValues.EarlyAdenoma_Ov(f);
end

BMMPop{i} = BM.OutputValues.MidPop; %?????
for j=1:(length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y))
    BMEarlyy{i}(j) = Ear.BM{j}; %mod BM
end

RMSE(i) = 0;
for j=1:length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y)
    RMSE(i) = RMSE(i) +(1 - BMEarlyy{i}(j)/handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(j))^2;
end

BMPop{i}  = 1/3*(BM.OutputValues.YoungPop+BM.OutputValues.MidPop+BM.OutputValues.OldPop);

RMSYPop(i)=0; RMSMPop(i)=0; RMSOPop(i)=0;
for j=1:length(BM.OutputValues.YoungPop)
    if ~isequal(BM_YPop(j),0)
        RMSYPop(i) = RMSYPop(i) + (1 - BM.OutputValues.YoungPop(j)/BM_YPop(j))^2;
        RMSMPop(i) = RMSMPop(i) + (1 - BM.OutputValues.MidPop(j)/BM_MPop(j))^2;
        RMSOPop(i) = RMSOPop(i) + (1 - BM.OutputValues.OldPop(j)/BM_OPop(j))^2;
    end
end

RMSP(i) = 0;
for f=1:4
    RMSP(i) = ((BM.Polyp_early(f) - BM.BM_value_early(f))/BM.Polyp_early(f))^2;
end
    
BM.RMSE = RMSE; BM.RMSMPop = RMSMPop; BM.RMSP = RMSP;
handles.Flow.RMS_prevalence_current   = RMSE(i);
handles.Flow.RMS_distribution_current = RMSMPop(i);
handles.Flow.RMS_adenoma_distribution_current = RMSP(i);

handles.Flow.Iteration = i;

function uy = logscale(Coeff)%,BMref,BMout)

ur = zeros(1,500);
Coeff = sort(Coeff); % new 
for j=1:5
%m    CoeffsPop{i}(j) = 0.5*BMPop{50}(6-j);
    %ur0(j)  = 1/(6-j)*CoeffsPop{i}(j);
    ur0(j*100)  = Coeff(j);
    %ur(j*100) = 0.5*BMPop{50}(6-j);
end

for j=1:100
    ur(0  +j) = ur0(100)*j/100;
end
for j=101:430
ur(j) = ur0(100) + (ur0(200)-ur0(100))*(j-100)/330;
end
for j=431:470
ur(j) = ur0(200) + (ur0(300)-ur0(200))*(j-430)/40;
end
for j=471:496
ur(j) = ur0(300) + (ur0(400)-ur0(300))*(j-470)/25;
end
for j=496:500
ur(j) = ur0(400) + (ur0(500)-ur0(400))*(j-495)/5;
end

u1 = 1:1:500;

u2 = 500/6.21416*log(u1); %new 

for i=1:21
ux(i) = 500*(i-1)/(21-1); %#ok<*AGROW>
tmp = abs(u2-ux(i));
[idx, idx] = min(tmp);  %#ok<ASGLU>
ux2(i) = u2(idx); 
uy2(i) = ur(idx); %new 
end

for i=1:20
    for j=1:25
     ux3((i-1)*25+j) =  ux2(i) + (ux2(i+1)-ux2(i)) * (j/25);   
     uy3((i-1)*25+j) =  uy2(i) + (uy2(i+1)-uy2(i)) * (j/25);
    end
end

uy = uy3;


% DELETE
function figure1_DeleteFcn(hObject, eventdata, handles) %#ok<INUSL,DEFNU>



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
