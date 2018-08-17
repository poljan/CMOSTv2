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

function varargout = Auto_Calibration_Step_3(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Auto_Calibration_Step_3_OpeningFcn, ...
                   'gui_OutputFcn',  @Auto_Calibration_Step_3_OutputFcn, ...
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

function Auto_Calibration_Step_3_OpeningFcn(hObject, ~, handles, varargin)

handles.Variables = get(0, 'userdata');
handles.OldVariables = handles.Variables;
handles = InitializeValues(handles);
handles.Flow.Number_first_iteration  = 50;
handles.Flow.Number_second_iteration = 60;

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles, handles.BM);
guidata(hObject, handles);
uiwait(handles.figure1);

function handles = InitializeValues(handles)
% we initialize flow variables
handles.Flow.StopFlag = 'off';
handles.Flow.Iteration = 1;
handles.Flow.RMS_Adv_current            =0;
handles.Flow.RMS_Ca_current             =0;
handles.Flow.RMS_Ad_distr_current       =0;
handles.Flow.RMS_Rel_danger_current     =0;
handles.Flow.RMS_Adjust_rectum_current  =0;

handles.Flow.RMSI   = 0;
handles.Flow.RMSD   = 0;
handles.Flow.RMSR   = 0;
handles.Flow.Message = 'Press Start for automated parameter optimization';

handles.Flow.CaFlag                = 1;
handles.Flow.RelDangerFlag         = 1;
handles.Flow.AdjFractionRectumFlag = 1;

% relativ danger adenoma
handles.BM.CancerOriginArea = 0;
handles.BM.CancerOriginSummary = 0;

for f=1:6
    handles.BM.CancerOriginSummary(f) = 0;
    handles.BM.CancerOriginValue(f)   = 0;
    handles.BM.CancerOriginFlag{f}    = 'red';
end

% we initialize variables for the carcinoma incidence graphs
handles.BM.Graph.Cancer_Ov     = zeros(1, length(handles.Variables.Benchmarks.Cancer.Ov_y));
handles.BM.Graph.Cancer_Male   = zeros(1, length(handles.Variables.Benchmarks.Cancer.Male_y));
handles.BM.Graph.Cancer_Female = zeros(1, length(handles.Variables.Benchmarks.Cancer.Female_y));

for f=1:length(handles.Variables.Benchmarks.Cancer.Ov_y)
    handles.BM.OutputFlags.Cancer_Ov {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.Cancer.Male_y)
    handles.BM.OutputFlags.Cancer_Male   {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.Cancer.Female_y)
    handles.BM.OutputFlags.Cancer_Female {f} = 'red';
end

handles.BM.OutputValues.Cancer_Ov     = zeros(1, length(handles.Variables.Benchmarks.Cancer.Ov_y));
handles.BM.OutputValues.Cancer_Male   = zeros(1, length(handles.Variables.Benchmarks.Cancer.Male_y));
handles.BM.OutputValues.Cancer_Female = zeros(1, length(handles.Variables.Benchmarks.Cancer.Female_y));

% fraction rectum
handles.BM.LocationRectumAllGender(1:100) = 0;
handles.BM.LocationRest(1:100)            = 0;
handles.BM.LocX{1}                        = [0 0];
handles.BM.LocationRectum                 = 0;
handles.BM.LocBenchmark                   = 0;
for f=1:length(handles.Variables.Benchmarks.Cancer.LocationRectumYear)
    handles.BM.LocationRectumFlag{f}          = 'red';
end

function varargout = Auto_Calibration_Step_3_OutputFcn(hObject, eventdata, handles) %#ok<INUSL
handles.output = 1;
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Images current                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this functions makes all chages to values visible
function handles = MakeImagesCurrent(hObject, handles, BM) %#ok<INUSL>
% This function is called whenever a change is made within the GUI. This 
% function makes these changes visible

FontSz   = 10;
MarkerSz = 5;
LineSz   = 0.4;

set(handles.Stop_Cal3, 'enable', 'on');

set(handles.RMS_CaInc_current, 'string', num2str(handles.Flow.RMS_Ca_current), 'enable', 'off')
set(handles.RMS_rel_danger_current, 'string', num2str(handles.Flow.RMS_Rel_danger_current), 'enable', 'off')
set(handles.RMS_Fraction_Rectum_current, 'string', num2str(handles.Flow.RMS_Adjust_rectum_current), 'enable', 'off')

set(handles.Iteration_number, 'string', num2str(handles.Flow.Iteration))

% we adjust the flags which parameter will be adjusted
set(handles.AdjustCancerFlag, 'value', handles.Flow.CaFlag)
set(handles.AdjRelDangerAdFlag, 'value', handles.Flow.RelDangerFlag)
set(handles.Adjust_Fraction_Rectum, 'value', handles.Flow.AdjFractionRectumFlag)

set(handles.Number_first_iteration, 'string', num2str(handles.Flow.Number_first_iteration)) %#ok<
set(handles.Number_second_iteration, 'string', num2str(handles.Flow.Number_second_iteration)) %#ok<
set(handles.message, 'string', handles.Flow.Message)

% Carcinoma graphs       
% overall
MakeGraphik(handles.Ca_Ov, BM.Graph.Cancer_Ov, handles.Variables.Benchmarks.Cancer.Ov_y,...
    handles.Variables.Benchmarks.Cancer.Ov_inc, BM.OutputValues.Cancer_Ov,...
    BM.OutputFlags.Cancer_Ov, 'Incidence carcinoma overall', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca')

% male
MakeGraphik(handles.Ca_Male, BM.Graph.Cancer_Male, handles.Variables.Benchmarks.Cancer.Male_y,...
    handles.Variables.Benchmarks.Cancer.Male_inc, BM.OutputValues.Cancer_Male,...
    BM.OutputFlags.Cancer_Male, 'Incidence carcinoma male', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca')

% female
MakeGraphik(handles.Ca_Female, BM.Graph.Cancer_Female, handles.Variables.Benchmarks.Cancer.Female_y,...
    handles.Variables.Benchmarks.Cancer.Female_inc, BM.OutputValues.Cancer_Female,...
    BM.OutputFlags.Cancer_Female, 'Incidence carcinoma female', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca')

% relative danger adenoma 
axes(handles.Rel_danger_adenoma), cla(handles.Rel_danger_adenoma)
if handles.Flow.RelDangerFlag
    clear LinePos
    RelDanger = cat(1, BM.CancerOriginValue, zeros(size(BM.CancerOriginValue)),...
        handles.Variables.Benchmarks.Rel_Danger(1:length(BM.CancerOriginValue)));
    bar(RelDanger, 'stacked'), hold on
    set(gca, 'yscale', 'log')
    for f=1:6
        if isequal(f, 1), LinePos(f) = BM.CancerOriginValue(f)/2;  %#ok<*AGROW>
        else LinePos(f) = sum(BM.CancerOriginValue(1:f-1))+BM.CancerOriginValue(f)/2; 
        end
    end
    for f=1:6
        line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', BM.CancerOriginFlag{f})
    end
    title('origin of cancer', 'fontsize', FontSz)
    l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Ad P5', 'Adv Ad P6');
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
else
    area(BM.CancerOriginArea), grid on, colormap summer, set(gca,'Layer','top')
    ylabel('% of all cancer', 'fontsize', FontSz), xlabel('decade', 'fontsize', FontSz)
    title('origin of cancer', 'fontsize', FontSz)
    set(gca, 'xlim', [0 10], 'ylim', [0 100], 'fontsize', FontSz)
    cm = colormap; %#ok<NASGU>
    cpos = [1  13 26 38 51 64]; %#ok<NASGU> % these are the positions in the colormap used for the graphs
    for f=1:5
        %    line ([0.1 4], [BM.CancerOriginSummary(f) BM.CancerOriginSummary(f)], 'color', cm(cpos(f), :))
    end
    warning('off', 'MATLAB:legend:IgnoringExtraEntries')
    l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Ad P5', 'Adv Ad P6', 'direct');
    warning('on', 'MATLAB:legend:IgnoringExtraEntries')
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
    ypos = 0;
    for f=1:6
        line([1.5 2.5], [(ypos + BM.CancerOriginValue(f)/2) (ypos + BM.CancerOriginValue(f)/2)],...
            'color', BM.CancerOriginFlag{f})
        ypos = ypos + BM.CancerOriginValue(f);
    end
end

% fraction rectum
axes(handles.Fraction_Rectum); cla(handles.Fraction_Rectum) %#ok<*MAXES>
plot(0:99, BM.LocationRectumAllGender(1:100)./ (BM.LocationRectumAllGender(1:100) + BM.LocationRest(1:100))*100, 'color', 'k'), hold on
for f=1:length(BM.LocX)
    x(f) = mean(BM.LocX{f}(1):BM.LocX{f}(2));
    line(BM.LocX{f}, [BM.LocationRectum(f) BM.LocationRectum(f)], 'color', BM.LocationRectumFlag{f})
    plot(x(f), BM.LocationRectum(f), '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k',...
        'MarkerFaceColor', BM.LocationRectumFlag{f}, 'MarkerSize',MarkerSz)
end
plot(x, BM.LocationRectum, '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',MarkerSz)
plot(x, BM.LocBenchmark, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
xlabel('year', 'fontsize', FontSz), ylabel('% rectum of all ca', 'fontsize', FontSz)
set(gca, 'fontsize', FontSz), title('fraction rectum carcinoma', 'fontsize', FontSz)
    
% Adjusting RMS carcinoma
axes(handles.RMS_Ca); cla(handles.RMS_Ca) %#ok<*MAXES>
tmp = length(handles.Flow.RMSI);
plot(1:tmp, handles.Flow.RMSI(1:tmp)), hold on
title('RMS carcinoma incidence')
for f=1:length(handles.Flow.RMSI)
    plot(f, handles.Flow.RMSI(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjusting rel. danger adenoma
axes(handles.RMS_rel_danger); cla(handles.RMS_rel_danger) %#ok<*MAXES>
tmp = length(handles.Flow.RMSD);
plot(1:tmp, handles.Flow.RMSD(1:tmp)), hold on
title('RMS rel. danger adenoma')
for f=1:length(handles.Flow.RMSD) 
    plot(f, handles.Flow.RMSD(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjusting fraction rectum
axes(handles.RMS_Fraction_Rectum); cla(handles.RMS_Fraction_Rectum) %#ok<*MAXES>
tmp = length(handles.Flow.RMSR);
plot(1:tmp, handles.Flow.RMSR(1:tmp)), hold on
title('RMS rel. fraction rectum-Ca')
for f=1:length(handles.Flow.RMSR) 
    plot(f, handles.Flow.RMSR(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
drawnow
guidata(hObject, handles)

function MakeGraphik(AxHandle, DataGraph, BM_year, BM_value, BM_current, BM_flags, GraphTitle, LabelY, LineSz, MarkerSz, FontSz, Mod)
axes(AxHandle), cla(AxHandle) 
if isequal(Mod, 'Ca')
    plot(BM_year, DataGraph, 'color', 'k'), hold on
else
    plot(0:99, DataGraph, 'color', 'k'), hold on
end
plot(BM_year, BM_value, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)

for f=1:length(BM_year)
    if isequal(BM_flags{f}, '')
        BM_flags{f} = 'black';
    end
    plot(BM_year(f), BM_current(f), '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', BM_flags{f}, 'MarkerSize',3)
    line([BM_year(f)-2 BM_year(f)+2], [BM_current(f) BM_current(f)], 'color', BM_flags{f});
end
xlabel('year', 'fontsize', FontSz), ylabel(LabelY, 'fontsize', FontSz), title(GraphTitle, 'fontsize', FontSz)
set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First and second iteration         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Number_first_iteration_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.Number_first_iteration, 'string'); [num, succ] =str2num(tmp); %#ok<ASGLU,ST2NM>
handles.Flow.Number_first_iteration = abs(round(num));
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

function Number_second_iteration_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
tmp=get(handles.Number_second_iteration, 'string'); [num, succ] =str2num(tmp);%#ok<ASGLU,ST2NM>
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
% Stop_Cal3                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Stop_Cal3_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
set(handles.Stop_Cal3, 'enable', 'off');
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flags for adjustments              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AdjustCancerFlag_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.Flow.CaFlag = get(handles.AdjustCancerFlag, 'value');
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>
function AdjRelDangerAdFlag_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.Flow.RelDangerFlag = get(handles.AdjRelDangerAdFlag, 'value');
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>
function Adjust_Fraction_Rectum_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
handles.Flow.AdjFractionRectumFlag = get(handles.Adjust_Fraction_Rectum, 'value');
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Functions and non-functional callbacks  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Iteration_number_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Iteration_number_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Number_first_iteration_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Number_second_iteration_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

function RMS_CaInc_current_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_CaInc_current_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_rel_danger_current_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_rel_danger_current_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_Fraction_Rectum_current_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_Fraction_Rectum_current_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_Callback(hObject, ~, handles) %#ok<DEFNU>
if ~or(handles.Flow.CaFlag, or(handles.Flow.AdjFractionRectumFlag, handles.Flow.RelDangerFlag))
    return % we return if no optimization is selected
end

% we get started
handles.Flow.Message = sprintf('Approaching optimimum: best of %d steps will be used', handles.Flow.Number_first_iteration);
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

% we initialize variables for tracking RMS
RMSI = 0; % for cancer
RMSD = 0; % for relative danger adenoma
RMSR = 0; % for fraction rectum

EAdv = cell(1,1);
BMAdvx = cell(1,1); BMAdvy = cell(1,1); BMIncx = cell(1,1); BMIncy = cell(1,1);

i=1; % first iteration

Benchmark_Ca_y     = 1/5 * handles.Variables.Benchmarks.Cancer.Ov_y;
Benchmark_Ca_inc   =       handles.Variables.Benchmarks.Cancer.Ov_inc;

% the ca-incidence curve is coupled to the adenoma
% prevalence curve so we need to keep some calculations for advanced
% adenomas
Benchmark_AdvAd_y    = 1/5 * handles.Variables.Benchmarks.AdvPolyp.Ov_y;
Benchmark_AdvAd_perc = handles.Variables.Benchmarks.AdvPolyp.Ov_perc;

% if coefficients have already been calculated we use those
if isfield(handles.Flow, 'CoeffsAdv')
    CoeffsAdv{1} = handles.Flow.CoeffsAdv;
    EAdv_Start   = handles.Flow.CoeffsAdv;
else
    CoeffsAdv{1} = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    EAdv_Start   = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
end

% if coefficients have already been calculated we use those
if isfield(handles.Flow, 'CoeffsInc')
    CoeffsInc{i} = handles.Flow.CoeffsInc;
    EInc_Start   = handles.Flow.CoeffsInc;
else
    CoeffsInc{i} = nlinfit(Benchmark_Ca_y,Benchmark_Ca_inc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    EInc_Start   = nlinfit(Benchmark_Ca_y,Benchmark_Ca_inc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
end

% first run
[~, BM]=CalculateSub(handles);

% we get the RMS values
[RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i);

% the following 10 lines are left in place since cancer
% incidence calculations are linked to the advanced adenoma curve
lastwarn('')
B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
if ~isempty(lastwarn)
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
end
EAdv{i}=B;
CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.06*(EAdv{i}(1)-EAdv_Start(1)));
CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));

lastwarn('')
B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
if ~isempty(lastwarn)
    B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
end

EInc{i}=B;
CoeffsInc{i+1}(1) = CoeffsInc{i}(1)*exp(-0.0005*(EInc{i}(1)-EInc_Start(1)));
CoeffsInc{i+1}(2) = CoeffsInc{i}(2)-0.1*(EInc{i}(2)-EInc_Start(2));
CoeffsInc{i+1}(3) = CoeffsInc{i}(3)-0.5*(EInc{i}(3)-EInc_Start(3));

% we save the factors by which adjustments for females are made
FemFactorCa(i)  = handles.Variables.advanced_progression_female;

% we save the start vectors for relative danger and fraction rectum
CoeffRelDanger{i} = handles.Variables.FastCancer;
CoeffRectum{i}    = [handles.Variables.Location_EarlyProgression(13)...
    handles.Variables.Location_AdvancedProgression(13)];

% we put the results to the graphical user interphase
handles.Flow.RMSI                    = RMSI;
handles.Flow.RMSD                    = RMSD;
handles.Flow.RMSR                    = RMSR;

if handles.Flow.CaFlag
    handles.Flow.RMS_Ca_current      = RMSI(i);
end
if handles.Flow.RelDangerFlag
    handles.Flow.RMS_Rel_danger_current = RMSD(i);
end
if handles.Flow.AdjFractionRectumFlag
    handles.Flow.RMS_Rel_danger_current = RMSR(i);
end
handles.Flow.Iteration = i;
handles = MakeImagesCurrent(hObject, handles, BM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first run with educated guesses                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KeepFlag = -1;
for i=2:handles.Flow.Number_first_iteration
    drawnow
    if isequal(get(handles.Stop_Cal3, 'enable'), 'off')
       choice = questdlg('Do you want to keep the best result of this run of optimization?',...
           'Keep results?','yes', 'no', 'cancel', 'cancel'); 
       switch choice
           case    'yes'
               KeepFlag = 1;
               % we look for the best coefficients
               tmp1 = sort(RMSI);
               for f=1:length(RMSI), tmp1R(f)=find(tmp1==RMSI(f), 1); end 
               tmp2 = sort(RMSD);
               for f=1:length(RMSD), tmp2R(f)=find(tmp2==RMSD(f), 1); end 
               tmp3 = sort(RMSR);
               for f=1:length(RMSR), tmp3R(f)=find(tmp3==RMSR(f), 1); end
               
               tmp     = tmp1R + tmp2R + tmp3R;
               if i>2
                   MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
               else
                   MinAll  = find(tmp == min(tmp), 1);
               end
               CoeffsInc_Final                     = CoeffsInc{MinAll};
               CoeffRelDangerFinal                 = CoeffRelDanger{MinAll};  %#ok<NASGU>
               CoeffRectumFinal                    = CoeffRectum{MinAll};  %#ok<NASGU>
               if handles.Flow.CaFlag
                   handles.Variables.advanced_progression_female = FemFactorCa(MinAll);
               end
               i=i-1;
               break
           case    'no'
               KeepFlag = 0;
               break
       end
    end

    if handles.Flow.RelDangerFlag
        % we adjust relative danger of adenoma stages
        if isequal(mod(i,2),1)
            for j=2:2:5
            handles.Variables.FastCancer(j) = handles.Variables.FastCancer(j)*...
                sqrt(handles.Variables.Benchmarks.Rel_Danger(j)/BM.CancerOriginValue(j));
            end
        else
            for j=1:2:5
                handles.Variables.FastCancer(j) = handles.Variables.FastCancer(j)*...
                   sqrt(handles.Variables.Benchmarks.Rel_Danger(j)/BM.CancerOriginValue(j));
            end
        end
    end
    CoeffRelDanger{i} = handles.Variables.FastCancer;
    
    % adjusting fraction of rectum carcinoma
    if handles.Flow.AdjFractionRectumFlag
        Factor1 = (BM.LocBenchmark(2)/ BM.LocationRectum(2))^(1/3);
        Factor2 = (BM.LocBenchmark(3)/ BM.LocationRectum(3))^(1/3);
        handles.Variables.Location_EarlyProgression(13) = ...
            handles.Variables.Location_EarlyProgression(13) * Factor1 * Factor2;
        handles.Variables.Location_AdvancedProgression(13) = ...    
            handles.Variables.Location_AdvancedProgression(13) * Factor1 * Factor2;
    end
    CoeffRectum{i} = [handles.Variables.Location_EarlyProgression(13)...
            handles.Variables.Location_AdvancedProgression(13)];
    
    % adjusting rates for sdv adenoma and carcinoma is in a subroutine
    handles = AdjustRates(handles, CoeffsInc, index_age, i);
    
    % the next run
    [~, BM]=CalculateSub(handles);
    
    % and we get the rms results
    [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i); 
    
    % the new coefficients for adenoma progression adenoma  
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
    EAdv{i}=B;
    
    CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.19*(EAdv{i}(1)-EAdv_Start(1))); %m -0.06*  %m 0.19
    CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
    CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));
    
    % the new coefficients for advanced adenoma progression adenoma/
    % carcinoma incidence
    B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
    EInc{i}=B;
    
    CoeffsInc{i+1}(1) = CoeffsInc{i}(1)*exp(-0.002*2*EAdv_Start(1)/EAdv{i}(1)*(EInc{i}(1)-EInc_Start(1))); % coupled  %0.002*2
    CoeffsInc{i+1}(2) = CoeffsInc{i}(2)-0.1*(EInc{i}(2)-EInc_Start(2));
    CoeffsInc{i+1}(3) = CoeffsInc{i}(3)-0.5*(EInc{i}(3)-EInc_Start(3));
    
    if handles.Flow.CaFlag
        % we make adjustments CARCINOMAS for females
        MaleSum = 0; FemaleSum = 0;
        for f = 9:15 % 5:length(handles.Variables.Benchmarks.Cancer.Male_y)
            % we check, how much the male prevalence for early adenoma remains
            % above benchmarks
            MaleSum = MaleSum + (BM.OutputValues.Cancer_Male(f) - handles.Variables.Benchmarks.Cancer.Male_inc(f))/...
                handles.Variables.Benchmarks.Cancer.Male_inc(f);
        end
        for f = 9:15 % 5:length(handles.Variables.Benchmarks.Cancer.Female_y)
            % we check, how much the female prevalence for early adenoma remains
            % above benchmarks
            FemaleSum = FemaleSum + (BM.OutputValues.Cancer_Female(f) - handles.Variables.Benchmarks.Cancer.Female_inc(f))/...
                handles.Variables.Benchmarks.Cancer.Female_inc(f);
        end
        FemaleSum = FemaleSum/(length(handles.Variables.Benchmarks.Cancer.Female_inc(9:15)));
        MaleSum   = MaleSum/  (length(handles.Variables.Benchmarks.Cancer.Male_inc  (9:15)));
        
        Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
        handles.Variables.advanced_progression_female = handles.Variables.advanced_progression_female * Factor;
        FemFactorCa(i) = handles.Variables.advanced_progression_female;
    end
    
    % we put the results to the graphical user interphase
    handles.Flow.RMSI                    = RMSI;
    handles.Flow.RMSD                    = RMSD;
    handles.Flow.RMSR                    = RMSR;
    
    if handles.Flow.CaFlag
        handles.Flow.RMS_Ca_current      = RMSI(i);
    end
    if handles.Flow.RelDangerFlag
        handles.Flow.RMS_Rel_danger_current = RMSD(i);
    end
    if handles.Flow.AdjFractionRectumFlag
        handles.Flow.RMS_Adjust_rectum_current = RMSR(i); 
    end
    handles.Flow.Iteration       = i;
    handles                      = MakeImagesCurrent(hObject, handles, BM);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second run Nelder Mead algorithm               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(KeepFlag, -1) % user did not interrupt
    % the next step will be fminsearch
    % we look for the best coefficients
    
    % we look for the best coefficients
    tmp1 = sort(RMSI);
    for f=1:length(RMSI), tmp1R(f)=find(tmp1==RMSI(f), 1); end
    tmp2 = sort(RMSD);
    for f=1:length(RMSD), tmp2R(f)=find(tmp2==RMSD(f), 1); end
    tmp3 = sort(RMSR);
    for f=1:length(RMSR), tmp3R(f)=find(tmp3==RMSR(f), 1); end
    
    tmp     = tmp1R + tmp2R + tmp3R;
    if i>2
        MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
    else
        MinAll  = find(tmp == min(tmp), 1);
    end
    
    CoeffsInc_Final                     = CoeffsInc{MinAll};
    CoeffRelDanger_Final                = CoeffRelDanger{MinAll}; %#ok<NASGU>
    
    if handles.Flow.CaFlag
        handles.Variables.advanced_progression_female = FemFactorCa(MinAll);
    end
    if handles.Flow.RelDangerFlag
        handles.Variables.FastCancer = CoeffRelDanger{MinAll};
    end
    if handles.Flow.AdjFractionRectumFlag
        handles.Variables.Location_EarlyProgression(13)    = CoeffRectum{MinAll}(1);
        handles.Variables.Location_AdvancedProgression(13) = CoeffRectum{MinAll}(2);
    end
    
    % we save data to be recovered by tempfunction and outfunction
    Calibration_3_temp.Variables = handles.Variables;
    Calibration_3_temp.Flow      = handles.Flow;
    Calibration_3_temp.BM        = BM;  %#ok<STRNU>
    
    if handles.Flow.Number_second_iteration >0 % if adv adenoma and carcinoma will be adjusted
        set(handles.message, 'string', 'Adjusting carcinoma by Nelder-Mead simplex search')
        drawnow
        %%% the path were this program is stored, this must be the CMOST path
        Path = mfilename('fullpath');
        pos = regexp(Path, [mfilename, '$']);
        CurrentPath = Path(1:pos-1);
        cd (fullfile(CurrentPath, 'Temp'))
        save('Calibration_3_temp', 'Calibration_3_temp');
        
        % for the second optimization we use the misearch function
        options = optimset('OutputFcn', @Auto_Calib_3_OutFunction, 'MaxFunEvals', handles.Flow.Number_second_iteration);
        if handles.Flow.CaFlag % we optimize carcinoma
            tmpff = @(x)Auto_Calib_3_TempFunction(x(1), x(2), x(3));
            [output] = fminsearch(tmpff,[CoeffsInc_Final(1), CoeffsInc_Final(2), CoeffsInc_Final(3)], options); %,...
            CoeffsInc_Final(1:3) = output(1:3);
        end
    end
    
    choice = questdlg('Do you want to keep the result of this run of optimization?',...
        'Keep results?','yes', 'no', 'yes');
    switch choice
        case    'yes'
            KeepFlag = 1;
        case    'no'
            KeepFlag = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% final run optimized parameters                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if KeepFlag
    clear tmp2
    tmp2{1} = CoeffsInc_Final;
    handles = AdjustRates(handles, tmp2, index_age, 1);
    if handles.Flow.CaFlag
        handles.Flow.CoeffsInc = CoeffsInc_Final;
        handles.Variables.advanced_progression_female = FemFactorCa(MinAll);
    end
    set(handles.message, 'string', 'Re-running with optimized parameters')
    drawnow
    
    % we run the calculations againd
    [~, BM] = CalculateSub(handles);
    
    handles.Flow.Iteration = i;
    
    % we use subfunction to calculate the RMS
    [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i); %#ok<ASGLU>
    
    % we let the user know
    handles.Flow.RMSI = RMSI;
    handles.Flow.RMSD = RMSD;
    handles.Flow.RMSR = RMSR;
    
    if handles.Flow.CaFlag
        handles.Flow.RMS_Ca_current      = RMSI(i);
    end
    if handles.Flow.RelDangerFlag
        handles.Flow.RMS_Rel_danger_current = RMSD(i);
    end
    if handles.Flow.AdjFractionRectumFlag
        handles.Flow.RMS_Adjust_rectum_current = RMSR(i);
    end
    
    % we get back the flags
    handles.Variables.DispFlag    = DispFlagBackup;
    handles.Variables.ResultsFlag = ResultsFlagBackup;
    handles.Variables.ExcelFlag   = ExcelFlagBackup;
    handles.Flow.Message          = 'Optimization finished';
else
    handles.Variables = VariablesBackup;
    handles = InitializeValues(handles);
end
handles = MakeImagesCurrent(hObject, handles, BM); %#ok<NASGU>

%%%% calculate RMS
function [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i)

% RMS for advanced adenoma
BMAdvx{i}   = 1/5*handles.Variables.Benchmarks.AdvPolyp.Ov_y; %corr BM
BMAdvy{i}   = BM.OutputValues.AdvAdenoma_Ov;

% RMS for carcinoma
BMIncx{i}   = 1/5*handles.Variables.Benchmarks.Cancer.Ov_y; %corr BM
BMIncy{i}   = BM.OutputValues.Cancer_Ov;
if handles.Flow.CaFlag
    RMStemp=0;
    for j=5:length(BMIncx{1})
        if ~isequal(Benchmark_Ca_inc(j),0)
            RMStemp = RMStemp + (1 - BMIncy{i}(j)/Benchmark_Ca_inc(j))^2;
        end
    end
    RMSI(i) = RMStemp;
end

if handles.Flow.RelDangerFlag
    % RMS for relative danger
    RMSD(i) = 0;
    for f=1:5
        RMSD(i) = RMSD(i) + (1 - BM.CancerOriginValue(f)/handles.Variables.Benchmarks.Rel_Danger(f))^2;
    end
end
if handles.Flow.AdjFractionRectumFlag
    RMSR(i) = 0;
    for f=2:3
        RMSR(i) = RMSR(i) + ((BM.LocationRectum(f) - BM.LocBenchmark(f))/ BM.LocBenchmark(f))^2;
    end
end

% adjust rates
function handles = AdjustRates(handles, CoeffsInc, index_age, i)

if handles.Flow.CaFlag
    % we adjust advanced adenoma progression rates
    handles.Variables.AdvancedProgressionRate = 8*5.1/6.5*0.3e-4*CoeffsInc{i}(1).*exp(-0.01*CoeffsInc{i}(2)*( index_age - CoeffsInc{i}(3) ).^2);
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
                handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);
end


% DELETE
function figure1_DeleteFcn(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
handles.Variables = handles.OldVariables;
guidata(hObject, handles)
