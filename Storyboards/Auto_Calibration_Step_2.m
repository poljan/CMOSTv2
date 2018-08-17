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

function varargout = Auto_Calibration_Step_2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Auto_Calibration_Step_2_OpeningFcn, ...
                   'gui_OutputFcn',  @Auto_Calibration_Step_2_OutputFcn, ...
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

function Auto_Calibration_Step_2_OpeningFcn(hObject, ~, handles, varargin)

handles.Variables = get(0, 'userdata');
handles.OldVariables = handles.Variables;
handles = InitializeValues(handles);

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles, handles.BM);
guidata(hObject, handles);
uiwait(handles.figure1);

function handles = InitializeValues(handles)
% we initialize flow variables
handles.Flow.StopFlag = 'off';
handles.Flow.Iteration = 1;
handles.Flow.RMS_Adv_current            =0;
handles.Flow.RMS_Ad_distr_current       =0;

handles.Flow.RMSA   = 0;
handles.Flow.RMSP   = 0;
handles.Flow.Message = 'Press Start for automated parameter optimization';

handles.Flow.AdFlag                = 1;
handles.Flow.DistFlag              = 1;

handles.Flow.Number_first_iteration  = 30;
handles.Flow.Number_second_iteration = 60;

% we initialize variables for the advanced adenoma prevalence graphs
handles.BM.Graph.AdvAdenoma_Ov     = zeros(1, 100);
handles.BM.Graph.AdvAdenoma_Male   = zeros(1, 100);
handles.BM.Graph.AdvAdenoma_Female = zeros(1, 100);

% adenoma stage distribution 
handles.BM.Polyp_adv        = zeros(6,1);
handles.BM.BM_value_adv     = zeros(6,1);    
for f=1:6
    handles.BM.Pflag{f}            = 'red';
end

for f=1:length(handles.Variables.Benchmarks.AdvPolyp.Ov_y)
    handles.BM.OutputFlags.AdvAdenoma_Ov {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.AdvPolyp.Male_y)
    handles.BM.OutputFlags.AdvAdenoma_Male   {f} = 'red';
end
for f=1:length(handles.Variables.Benchmarks.AdvPolyp.Female_y)
    handles.BM.OutputFlags.AdvAdenoma_Female {f} = 'red';
end

handles.BM.OutputValues.AdvAdenoma_Ov     = zeros(1, length(handles.Variables.Benchmarks.AdvPolyp.Ov_y));
handles.BM.OutputValues.AdvAdenoma_Male   = zeros(1, length(handles.Variables.Benchmarks.AdvPolyp.Male_y));
handles.BM.OutputValues.AdvAdenoma_Female = zeros(1, length(handles.Variables.Benchmarks.AdvPolyp.Female_y));

function varargout = Auto_Calibration_Step_2_OutputFcn(hObject, eventdata, handles) %#ok<INUSL
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

set(handles.RMS_AdvAd_current, 'string', num2str(handles.Flow.RMS_Adv_current), 'enable', 'off')
set(handles.RMS_distribution_current, 'string', num2str(handles.Flow.RMS_Ad_distr_current), 'enable', 'off')

set(handles.Iteration_number, 'string', num2str(handles.Flow.Iteration), 'enable', 'off')

% we adjust the flags which parameter will be adjusted
set(handles.AdjAdvAdFlag, 'value', handles.Flow.AdFlag)
set(handles.AdjAdDistrFlag, 'value', handles.Flow.DistFlag)

set(handles.Number_first_iteration, 'string', num2str(handles.Flow.Number_first_iteration)) %#ok<
set(handles.Number_second_iteration, 'string', num2str(handles.Flow.Number_second_iteration)) %#ok<
set(handles.message, 'string', handles.Flow.Message)

% Advanced adenoma graphs        
% overall
MakeGraphik(handles.Adv_Ov_Axes, BM.Graph.AdvAdenoma_Ov, handles.Variables.Benchmarks.AdvPolyp.Ov_y,...
    handles.Variables.Benchmarks.AdvPolyp.Ov_perc, BM.OutputValues.AdvAdenoma_Ov,...
    BM.OutputFlags.AdvAdenoma_Ov, 'Prevalence adenoma overall', 'percent of patients', LineSz, MarkerSz, FontSz, 'Ad')

% male
MakeGraphik(handles.Adv_Male_Axes, BM.Graph.AdvAdenoma_Male, handles.Variables.Benchmarks.AdvPolyp.Male_y,...
    handles.Variables.Benchmarks.AdvPolyp.Male_perc, BM.OutputValues.AdvAdenoma_Male,...
    BM.OutputFlags.AdvAdenoma_Male, 'Prevalence adenoma male', 'percent of patients', LineSz, MarkerSz, FontSz, 'Ad')

% female
MakeGraphik(handles.Adv_Female_Axes, BM.Graph.AdvAdenoma_Female, handles.Variables.Benchmarks.AdvPolyp.Female_y,...
    handles.Variables.Benchmarks.AdvPolyp.Female_perc, BM.OutputValues.AdvAdenoma_Female,...
    BM.OutputFlags.AdvAdenoma_Female, 'Prevalence adenoma female', 'percent of patients', LineSz, MarkerSz, FontSz, 'Ad')
guidata(hObject, handles);

% Adenoma distribution
axes(handles.Adenoma_distribution), cla(handles.Adenoma_distribution)
bar(cat(2, BM.Polyp_adv, zeros(6,1), BM.BM_value_adv)', 'stacked'), hold on
for f=5:6 
    if isequal(f, 5), LinePos(f) = BM.Polyp_adv(f)/2; %#ok<AGROW>
    else LinePos(f) = sum(BM.Polyp_adv(5:f-1))+BM.Polyp_adv(f)/2; %#ok<AGROW>
    end
end
for f=5:6
    line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', BM.Pflag{f})
end    
l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Adenoma P5', 'Adv Adenoma P6');
set(l, 'location', 'northoutside', 'fontsize', FontSz)
ylabel('% of affected patients', 'fontsize', FontSz)
title('distribution of P5/ P6 adenoma stages')
set(gca, 'xticklabel', {'adenomas' '' 'benchmark' ''}, 'fontsize', FontSz, 'ylim', [0 100])
    
% Adjusting RMS Graph advanced
axes(handles.RMS_Adv); cla(handles.RMS_Adv) %#ok<*MAXES>
tmp = length(handles.Flow.RMSA);
plot(1:tmp, handles.Flow.RMSA(1:tmp)), hold on
title('RMS adv. ad. prevalence')
for f=1:length(handles.Flow.RMSA)
    plot(f, handles.Flow.RMSA(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% Adjusting RMS adenoma distribution
axes(handles.RMS_distribution); cla(handles.RMS_distribution) %#ok<*MAXES>
tmp = length(handles.Flow.RMSP);
plot(1:tmp, handles.Flow.RMSP(1:tmp)), hold on
title('RMS ad. stage distribution')
for f=1:length(handles.Flow.RMSP)
    plot(f, handles.Flow.RMSP(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
drawnow


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
% Stop                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Stop_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
set(handles.Stop, 'enable', 'off');
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flags for adjustments              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function AdjAdvAdFlag_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.Flow.AdFlag = get(handles.AdjAdvAdFlag, 'value');
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>
function AdjAdDistrFlag_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.Flow.DistFlag = get(handles.AdjAdDistrFlag, 'value'); 
handles = MakeImagesCurrent(hObject, handles, handles.BM); %#ok<NASGU>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Functions and non-functional callbacks  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Iteration_number_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_AdvAd_current_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_distribution_current_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_distribution_current_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RMS_AdvAd_current_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Iteration_number_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Number_first_iteration_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function Number_second_iteration_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_Callback(hObject, ~, handles) %#ok<DEFNU>
% BM.Polyp_adv, zeros(6,1), BM.BM_value_adv
if ~or(handles.Flow.AdFlag, handles.Flow.DistFlag)
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
RMSA = 0; % for advanced adenoma
RMSP = 0; % for adenoma distribution

EAdv = cell(1,1);
BMAdvx = cell(1,1); BMAdvy = cell(1,1); BMIncx = cell(1,1); BMIncy = cell(1,1);

i=1; % first iteration

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

if handles.Flow.AdFlag
    handles.Variables.EarlyProgressionRate = 0.04*CoeffsAdv{1}(1).*exp(-0.01*CoeffsAdv{1}(2)*( index_age - CoeffsAdv{1}(3) ).^2); %mmmm 4*
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
                handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);
end

% first run
[~, BM]=CalculateSub(handles);

% we get the RMS values
[RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i);

lastwarn('')
B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
if ~isempty(lastwarn)
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
end
EAdv{i}=B;

CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.06*(EAdv{i}(1)-EAdv_Start(1)));
CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));

% we save the factors by which adjustments for females are made
FemFactorAdv(i) = handles.Variables.early_progression_female;

% we save the start vectors for adenoma progression
CoeffPStage{i}         = handles.Variables.Progression;
ProgressionCoefficient = handles.Variables.Progression(5);

% we put the results to the graphical user interphase
handles.Flow.RMSA                    = RMSA;
handles.Flow.RMSP                    = RMSP;

if handles.Flow.AdFlag
    handles.Flow.RMS_Adv_current     = RMSA(i);
end
if handles.Flow.DistFlag
    handles.Flow.RMS_Ad_distr_current = RMSP(i);
end
handles.Flow.Iteration = i;
handles = MakeImagesCurrent(hObject, handles, BM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first run with educated guesses                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KeepFlag = -1;
if handles.Flow.Number_first_iteration >2
    for i=2:handles.Flow.Number_first_iteration
        drawnow
        if isequal(get(handles.Stop, 'enable'), 'off')
            choice = questdlg('Do you want to keep the best result of this run of optimization?',...
                'Keep results?','yes', 'no', 'cancel', 'cancel');
            switch choice
                case    'yes'
                    KeepFlag = 1;
                    % we look for the best coefficients
                    tmp1 = sort(RMSA);
                    for f=1:length(RMSA), tmp1R(f)=find(tmp1==RMSA(f), 1); end %#ok<AGROW>
                    tmp2 = sort(RMSP);
                    for f=1:length(RMSP), tmp2R(f)=find(tmp2==RMSP(f), 1); end %#ok<AGROW>
                    
                    tmp     = tmp1R + tmp2R;
                    if i>2
                        MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
                    else
                        MinAll  = find(tmp == min(tmp), 1);
                    end
                    CoeffsAdv_Final                     = CoeffsAdv{MinAll};
                    CoffsPolypProgressionFinal          = CoeffPStage{MinAll};
                    if handles.Flow.AdFlag
                        handles.Variables.early_progression_female    = FemFactorAdv(MinAll);
                    end
                    i=i-1;
                    break
                case    'no'
                    KeepFlag = 0;
                    break
            end
        end
        if handles.Flow.DistFlag
            % we adjust progression rates for individual adenoma stages
            FactorP5(i) = 1; % (BM.BM_value_adv(5) / BM.Polyp_adv(5))^(1/4); %#ok<AGROW>
            handles.Variables.Progression(5)= handles.Variables.Progression(5) / FactorP5(i);
        end
        CoeffPStage{i} = handles.Variables.Progression;
        
        % adjusting rates for sdv adenoma and carcinoma is in a subroutine
        if handles.Flow.AdFlag
            handles = AdjustRates(handles, CoeffsAdv, index_age, i);
        end
        
        % the next run
        [~, BM]=CalculateSub(handles);
        
        % and we get the rms results
        [RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS(handles, BM, BMAdvx,...
            BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i);
        
        % the new coefficients for adenoma progression adenoma
        B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
        EAdv{i}=B;
        
        CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.19*(EAdv{i}(1)-EAdv_Start(1))); %m -0.06*  %m 0.19
        CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
        CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));
        
        if handles.Flow.AdFlag
            % we make adjustments ADVANCED ADENOMAS for females
            MaleSum = 0; FemaleSum = 0;
            for f = 1:length(handles.Variables.Benchmarks.AdvPolyp.Male_y)
                % we check, how much the male prevalence for early adenoma remains
                % above benchmarks
                MaleSum = MaleSum + (BM.OutputValues.AdvAdenoma_Male(f) - handles.Variables.Benchmarks.AdvPolyp.Male_perc(f))/...
                    handles.Variables.Benchmarks.AdvPolyp.Male_perc(f);
            end
            for f = 1:length(handles.Variables.Benchmarks.AdvPolyp.Female_y)
                % we check, how much the female prevalence for early adenoma remains
                % above benchmarks
                FemaleSum = FemaleSum + (BM.OutputValues.AdvAdenoma_Female(f) - handles.Variables.Benchmarks.AdvPolyp.Female_perc(f))/...
                    handles.Variables.Benchmarks.AdvPolyp.Female_perc(f);
            end
            FemaleSum = FemaleSum/length(handles.Variables.Benchmarks.AdvPolyp.Female_perc(f));
            MaleSum   = MaleSum/length(handles.Variables.Benchmarks.AdvPolyp.Male_perc(f));
            
            Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
            handles.Variables.early_progression_female = handles.Variables.early_progression_female * Factor;
            
            FemFactorAdv(i) = handles.Variables.early_progression_female;
        end
        
        % we put the results to the graphical user interphase
        handles.Flow.RMSA                    = RMSA;
        handles.Flow.RMSP                    = RMSP;
        
        if handles.Flow.AdFlag
            handles.Flow.RMS_Adv_current     = RMSA(i);
        end
        if handles.Flow.DistFlag
            handles.Flow.RMS_Ad_distr_current = RMSP(i);
        end
        handles.Flow.Iteration       = i;
        handles                      = MakeImagesCurrent(hObject, handles, BM);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second run Nelder Mead algorithm               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(KeepFlag, -1) % user did not interrupt
    % the next step will be fminsearch
    % we look for the best coefficients
    
    % we look for the best coefficients
    tmp1 = sort(RMSA);
    for f=1:length(RMSA), tmp1R(f)=find(tmp1==RMSA(f), 1); end
    tmp2 = sort(RMSP);
    for f=1:length(RMSP), tmp2R(f)=find(tmp2==RMSP(f), 1); end
    
    tmp     = tmp1R + tmp2R;
    if i>2
        MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
    else
        MinAll  = find(tmp == min(tmp), 1);
    end
    CoeffsAdv_Final                     = CoeffsAdv{MinAll};
    ProgressionCoefficient              = CoeffPStage{MinAll}(5);
    
    if handles.Flow.AdFlag
        handles.Variables.early_progression_female    = FemFactorAdv(MinAll);
    end
    if handles.Flow.DistFlag
        handles.Variables.Progression = CoeffPStage{MinAll};
    end
    
    % we save data to be recovered by tempfunction and outfunction
    Calibration_2_temp.Variables = handles.Variables;
    Calibration_2_temp.Flow      = handles.Flow;
    Calibration_2_temp.BM        = BM; 
    
    if handles.Flow.Number_second_iteration >0 % if adv adenoma and carcinoma will be adjusted
        set(handles.message, 'string', 'Adjusting advanced adenoma by Nelder-Mead simplex search')
        drawnow
        %%% the path were this program is stored, this must be the CMOST path
        Path = mfilename('fullpath');
        pos = regexp(Path, [mfilename, '$']);
        CurrentPath = Path(1:pos-1);
        cd (fullfile(CurrentPath, 'Temp'))
        save('Calibration_2_temp', 'Calibration_2_temp');
        
        % for the second optimization we use the misearch function
        options = optimset('OutputFcn', @Auto_Calib_2_OutFunction, 'MaxFunEvals', handles.Flow.Number_second_iteration);
        if and(handles.Flow.AdFlag, handles.Flow.DistFlag) % we optimize adv. adenoma
            tmpff = @(x)Auto_Calib_2_TempFunction(x(1), x(2), x(3), x(4));
            [output] = fminsearch(tmpff,[CoeffsAdv_Final(1), CoeffsAdv_Final(2), CoeffsAdv_Final(3), ...
                ProgressionCoefficient], options); 
        elseif handles.Flow.AdFlag % we optimize adv adenoma
            tmpff = @(x)Calib_2_TempFunction(x(1), x(2), x(3));
            [output] = fminsearch(tmpff, [CoeffsAdv_Final(1) CoeffsAdv_Final(2), CoeffsAdv_Final(3)], options); %,...
        elseif handles.Flow.DistFlag
            tmpff = @(x)Auto_Calib_2_TempFunction(x(1));
            [output] = fminsearch(tmpff, ProgressionCoefficient, options); 
            
        end
        if and(handles.Flow.AdFlag, handles.Flow.DistFlag)
            CoeffsAdv_Final(1:3) = output(1:3);
            ProgressionCoefficient = output(4);
        elseif handles.Flow.AdFlag
            CoeffsAdv_Final(1:3) = output(1:3);
        elseif handles.Flow.DistFlag
            ProgressionCoefficient = output(1);
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
    clear tmp1 
    tmp1{1} = CoeffsAdv_Final; 
    if handles.Flow.AdFlag
        handles = AdjustRates(handles, tmp1, index_age, 1);
        handles.Flow.CoeffsAdv = CoeffsAdv_Final;
        handles.Variables.early_progression_female = FemFactorAdv(MinAll);
    end
    if handles.Flow.DistFlag
        handles.Variables.Progression(5) = ProgressionCoefficient;
    end
    set(handles.message, 'string', 'Re-running with optimized parameters')
    drawnow
    
    % we run the calculations againd
    [~, BM] = CalculateSub(handles);
    
    % we use subfunction to calculate the RMS
    [RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i);
    
    % we let the user know
    handles.Flow.RMSA = RMSA;
    handles.Flow.RMSP = RMSP;
    handles.Flow.Iteration = i;
    if handles.Flow.AdFlag
        handles.Flow.RMS_Adv_current     = RMSA(i);
    end
    if handles.Flow.DistFlag
        handles.Flow.RMS_Ad_distr_current = RMSP(i);
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
function [RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i)

% RMS for advanced adenoma
BMAdvx{i}   = 1/5*handles.Variables.Benchmarks.AdvPolyp.Ov_y; %corr BM
BMAdvy{i}   = BM.OutputValues.AdvAdenoma_Ov;
if handles.Flow.AdFlag
    RMStemp=0;
    for j=1:length(BMAdvx{1})
        RMStemp = RMStemp +(1 - BMAdvy{i}(j)/Benchmark_AdvAd_perc(j))^2;
    end
    RMSA(i) = RMStemp;
end

if handles.Flow.DistFlag
    % RMS for advanced adenoma distribution
    RMSP(i) = 0;
    for f=5:6
        RMSP(i) = RMSP(i) + ((BM.Polyp_adv(f) - BM.BM_value_adv(f))/BM.BM_value_adv(f))^2;
    end
end

% adjust rates
function handles = AdjustRates(handles, CoeffsAdv, index_age, i)
if handles.Flow.AdFlag
    % we adjust the early adenoma progression rates
    handles.Variables.EarlyProgressionRate = 1.5*0.04*CoeffsAdv{i}(1).*exp(-0.01*CoeffsAdv{i}(2)*( index_age - CoeffsAdv{i}(3) ).^2);
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
                handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);
end

% DELETE
function figure1_DeleteFcn(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
handles.Variables = handles.OldVariables;
guidata(hObject, handles)
