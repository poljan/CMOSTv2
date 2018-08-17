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

function varargout = Step_3_Benchmarks_Carcinoma(varargin)
% STEP_3_BENCHMARKS_CARCINOMA MATLAB code for Step_3_Benchmarks_Carcinoma.fig


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Step_3_Benchmarks_Carcinoma_OpeningFcn, ...
                   'gui_OutputFcn',  @Step_3_Benchmarks_Carcinoma_OutputFcn, ...
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


% --- Executes just before Step_3_Benchmarks_Carcinoma is made visible.
function Step_3_Benchmarks_Carcinoma_OpeningFcn(hObject, eventdata, handles, varargin)

handles.Variables = get(0, 'userdata');
handles.Benchmarks = handles.Variables.Benchmarks;

% these variabels are internal references for the elements in the GUI
handles.Ov_y_handles ={'Ov_y_01'; 'Ov_y_02'; 'Ov_y_03'; 'Ov_y_04'; 'Ov_y_05';...
    'Ov_y_06'; 'Ov_y_07'; 'Ov_y_08'; 'Ov_y_09'; 'Ov_y_10'; 'Ov_y_11';...
    'Ov_y_12'; 'Ov_y_13'; 'Ov_y_14'; 'Ov_y_15'; 'Ov_y_16'; 'Ov_y_17'; 'Ov_y_18'};
handles.Ov_perc_handles ={'Ov_perc_01'; 'Ov_perc_02'; 'Ov_perc_03'; 'Ov_perc_04'; 'Ov_perc_05';...
    'Ov_perc_06'; 'Ov_perc_07'; 'Ov_perc_08'; 'Ov_perc_09'; 'Ov_perc_10'; 'Ov_perc_11';...
    'Ov_perc_12'; 'Ov_perc_13'; 'Ov_perc_14'; 'Ov_perc_15'; 'Ov_perc_16'; 'Ov_perc_17'; 'Ov_perc_18'};
handles.Male_y_handles ={'male_y_01'; 'male_y_02'; 'male_y_03'; 'male_y_04'; 'male_y_05';...
    'male_y_06'; 'male_y_07'; 'male_y_08'; 'male_y_09'; 'male_y_10'; 'male_y_11';...
    'male_y_12'; 'male_y_13'; 'male_y_14'; 'male_y_15'; 'male_y_16'; 'male_y_17'; 'male_y_18'};
handles.Male_perc_handles ={'male_perc_01'; 'male_perc_02'; 'male_perc_03'; 'male_perc_04'; 'male_perc_05';...
    'male_perc_06'; 'male_perc_07'; 'male_perc_08'; 'male_perc_09'; 'male_perc_10'; 'male_perc_11';...
    'male_perc_12'; 'male_perc_13'; 'male_perc_14'; 'male_perc_15'; 'male_perc_16'; 'male_perc_17'; 'male_perc_18'};
handles.Female_y_handles ={'female_y_01'; 'female_y_02'; 'female_y_03'; 'female_y_04'; 'female_y_05';...
    'female_y_06'; 'female_y_07'; 'female_y_08'; 'female_y_09'; 'female_y_10'; 'female_y_11';...
    'female_y_12'; 'female_y_13'; 'female_y_14'; 'female_y_15'; 'female_y_16'; 'female_y_17'; 'female_y_18'};
handles.Female_perc_handles ={'female_perc_01'; 'female_perc_02'; 'female_perc_03'; 'female_perc_04'; 'female_perc_05';...
    'female_perc_06'; 'female_perc_07'; 'female_perc_08'; 'female_perc_09'; 'female_perc_10'; 'female_perc_11';...
    'female_perc_12'; 'female_perc_13'; 'female_perc_14'; 'female_perc_15'; 'female_perc_16'; 'female_perc_17'; 'female_perc_18'};
handles.Ad_danger_handles = {'ad_danger_1'; 'ad_danger_2'; 'ad_danger_3'; 'ad_danger_4'; 'ad_danger_5'; 'ad_danger_6'};
handles.Rectum_Ca_y_handles = {'rectum_y_1'; 'rectum_y_2'; 'rectum_y_3'; 'rectum_y_4'};
handles.Rectum_Ca_male_handles = {'rectum_male_1'; 'rectum_male_2'; 'rectum_male_3'; 'rectum_male_4'};
handles.Rectum_Ca_female_handles = {'rectum_female_1'; 'rectum_female_2'; 'rectum_female_3'; 'rectum_female_4'};

%handles.Benchmarks.Cancer.LocationRectumYear   = {[51 55], [61 65], [71 75], [81 85]};
for f=1:length(handles.Rectum_Ca_y_handles)
    handles.Tmp.Benchmarks_Cancer_y(f) = handles.Benchmarks.Cancer.LocationRectumYear{f}(1) +1;
end
handles.output = hObject;


% we sort all values and write values in the handles structure and update
% the display
handles = SortValues(hObject, handles);
handles = MakeImagesCurrent(hObject, handles);

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort Values                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this function will sort values all values and delete entries with 0
% years
function handles = SortValues(hObject, handles)

% we first adjust the lengths of the values
for f= (length(handles.Benchmarks.Cancer.Ov_y) + 1) : length(handles.Ov_y_handles)
    handles.Benchmarks.Cancer.Ov_y(f) = 0;
end
for f= (length(handles.Benchmarks.Cancer.Ov_inc) + 1) : length(handles.Ov_perc_handles)
    handles.Benchmarks.Cancer.Ov_inc(f) = 0;
end
for f= (length(handles.Benchmarks.Cancer.Male_y) + 1) : length(handles.Male_y_handles)
    handles.Benchmarks.Cancer.Male_y(f) = 0;
end
for f= (length(handles.Benchmarks.Cancer.Male_inc) + 1) : length(handles.Male_perc_handles)
    handles.Benchmarks.Cancer.Male_inc(f) = 0;
end
for f= (length(handles.Benchmarks.Cancer.Female_y) + 1) : length(handles.Female_y_handles)
    handles.Benchmarks.Cancer.Female_y(f) = 0;
end
for f= (length(handles.Benchmarks.Cancer.Female_inc) + 1) : length(handles.Female_perc_handles)
    handles.Benchmarks.Cancer.Female_inc(f) = 0;
end

[~,vv] = sort(handles.Benchmarks.Cancer.Ov_y);
handles.Benchmarks.Cancer.Ov_y = handles.Benchmarks.Cancer.Ov_y(vv);
handles.Benchmarks.Cancer.Ov_inc  = handles.Benchmarks.Cancer.Ov_inc(vv);
[~,vv] = sort(handles.Benchmarks.Cancer.Male_y);
handles.Benchmarks.Cancer.Male_y = handles.Benchmarks.Cancer.Male_y(vv);
handles.Benchmarks.Cancer.Male_inc  = handles.Benchmarks.Cancer.Male_inc(vv);
[~,vv] = sort(handles.Benchmarks.Cancer.Female_y);
handles.Benchmarks.Cancer.Female_y = handles.Benchmarks.Cancer.Female_y(vv);
handles.Benchmarks.Cancer.Female_inc  = handles.Benchmarks.Cancer.Female_inc(vv);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Images current                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this functions makes all changes to values visible
function handles = MakeImagesCurrent(hObject, handles)
% This function is called whenever a change is made within the GUI. This 
% function makes these changes visible

% adjusting numbers overall
for f=1:length(handles.Ov_y_handles)
    set(handles.(handles.Ov_y_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Ov_y(f)));
end
for f=1:length(handles.Ov_perc_handles)
    set(handles.(handles.Ov_perc_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Ov_inc(f)));
end

% adjusting numbers male
for f=1:length(handles.Male_y_handles)
    set(handles.(handles.Male_y_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Male_y(f)));
end
for f=1:length(handles.Male_perc_handles)
    set(handles.(handles.Male_perc_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Male_inc(f)));
end

% adjusting numbers female
for f=1:length(handles.Female_y_handles)
    set(handles.(handles.Female_y_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Female_y(f)));
end
for f=1:length(handles.Female_perc_handles)
    set(handles.(handles.Female_perc_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.Female_inc(f)));
end

% Adjusting graph overall
axes(handles.Ov_plot); cla(handles.Ov_plot) %#ok<*MAXES>
XX = handles.Benchmarks.Cancer.Ov_y;
YY = handles.Benchmarks.Cancer.Ov_inc;
vv = find(XX==0);
XX(vv)=[];
YY(vv)=[];

plot(XX, YY), hold on
for f=1:length(XX), plot(XX(f), YY(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% Adjusting Male graph
axes(handles.Male_plot); cla(handles.Male_plot) %#ok<*MAXES>
XX = handles.Benchmarks.Cancer.Male_y;
YY = handles.Benchmarks.Cancer.Male_inc;
vv = find(XX==0);
XX(vv)=[];
YY(vv)=[];

plot(XX, YY), hold on
for f=1:length(XX), plot(XX(f), YY(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% Adjusting Female graph
axes(handles.Female_plot); cla(handles.Female_plot) %#ok<*MAXES>
XX = handles.Benchmarks.Cancer.Female_y;
YY = handles.Benchmarks.Cancer.Female_inc;
vv = find(XX==0);
XX(vv)=[];
YY(vv)=[];

plot(XX, YY), hold on
for f=1:length(XX), plot(XX(f), YY(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjust multiple polyps
for f=1:length(handles.Ad_danger_handles)
    set(handles.(handles.Ad_danger_handles{f}), 'string', num2str(handles.Benchmarks.Rel_Danger(f)));
end

% Adjusting adenoma danger plot
axes(handles.Ad_danger_plot); cla(handles.Ad_danger_plot) %#ok<*MAXES>
XX = [1 2 3 4 5 6];
YY = handles.Benchmarks.Rel_Danger;
vv = find(XX==0);
XX(vv)=[];
YY(vv)=[];

plot(XX, YY), hold on
for f=1:length(XX), plot(XX(f), YY(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% adjusting rectum Ca
for f=1:length(handles.Rectum_Ca_y_handles)
    set(handles.(handles.Rectum_Ca_y_handles{f}), 'string', num2str(handles.Tmp.Benchmarks_Cancer_y(f)));
    handles.Benchmarks.Cancer.LocationRectumYear{f} = ...
        [handles.Tmp.Benchmarks_Cancer_y(f)-1 handles.Tmp.Benchmarks_Cancer_y(f)+3];
end
for f=1:length(handles.Rectum_Ca_male_handles)
    set(handles.(handles.Rectum_Ca_male_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.LocationRectumMale(f)));
end
for f=1:length(handles.Rectum_Ca_female_handles)
    set(handles.(handles.Rectum_Ca_female_handles{f}), 'string', num2str(handles.Benchmarks.Cancer.LocationRectumFemale(f)));
end
% adjusting retum Ca plot
axes(handles.Rectum_Ca_plot); cla(handles.Rectum_Ca_plot)
plot(handles.Tmp.Benchmarks_Cancer_y, handles.Benchmarks.Cancer.LocationRectumMale), hold on
plot(handles.Tmp.Benchmarks_Cancer_y, handles.Benchmarks.Cancer.LocationRectumFemale)
for f=1:length(handles.Tmp.Benchmarks_Cancer_y)
    plot(handles.Tmp.Benchmarks_Cancer_y(f), handles.Benchmarks.Cancer.LocationRectumMale(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
    plot(handles.Tmp.Benchmarks_Cancer_y(f), handles.Benchmarks.Cancer.LocationRectumFemale(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')     

guidata(hObject, handles)

% --- Outputs from this function are returned to the command line.
function varargout = Step_3_Benchmarks_Carcinoma_OutputFcn(hObject, eventdata, handles) 
% varargout{1} = handles.output;

function Ov_perc_01_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
function Ov_perc_02_CreateFcn(hObject, eventdata, handles)
function Ov_perc_03_CreateFcn(hObject, eventdata, handles)
function Ov_perc_04_CreateFcn(hObject, eventdata, handles)
function Ov_perc_05_CreateFcn(hObject, eventdata, handles)
function Ov_perc_06_CreateFcn(hObject, eventdata, handles)
function Ov_perc_07_CreateFcn(hObject, eventdata, handles)
function Ov_perc_08_CreateFcn(hObject, eventdata, handles)
function Ov_perc_09_CreateFcn(hObject, eventdata, handles)
function Ov_perc_10_CreateFcn(hObject, eventdata, handles)
function Ov_perc_11_CreateFcn(hObject, eventdata, handles)
function Ov_perc_12_CreateFcn(hObject, eventdata, handles)
function Ov_perc_13_CreateFcn(hObject, eventdata, handles)
function Ov_perc_14_CreateFcn(hObject, eventdata, handles)
function Ov_perc_15_CreateFcn(hObject, eventdata, handles)
function Ov_perc_16_CreateFcn(hObject, eventdata, handles)
function Ov_perc_17_CreateFcn(hObject, eventdata, handles)
function Ov_perc_18_CreateFcn(hObject, eventdata, handles)
function Ov_perc_19_CreateFcn(hObject, eventdata, handles)
function Ov_y_01_CreateFcn(hObject, eventdata, handles)
function Ov_y_02_CreateFcn(hObject, eventdata, handles)
function Ov_y_03_CreateFcn(hObject, eventdata, handles)
function Ov_y_04_CreateFcn(hObject, eventdata, handles)
function Ov_y_05_CreateFcn(hObject, eventdata, handles)
function Ov_y_06_CreateFcn(hObject, eventdata, handles)
function Ov_y_07_CreateFcn(hObject, eventdata, handles)
function Ov_y_08_CreateFcn(hObject, eventdata, handles)
function Ov_y_09_CreateFcn(hObject, eventdata, handles)
function Ov_y_10_CreateFcn(hObject, eventdata, handles)
function Ov_y_11_CreateFcn(hObject, eventdata, handles)
function Ov_y_12_CreateFcn(hObject, eventdata, handles)
function Ov_y_13_CreateFcn(hObject, eventdata, handles)
function Ov_y_14_CreateFcn(hObject, eventdata, handles)
function Ov_y_15_CreateFcn(hObject, eventdata, handles)
function Ov_y_16_CreateFcn(hObject, eventdata, handles)
function Ov_y_17_CreateFcn(hObject, eventdata, handles)
function Ov_y_18_CreateFcn(hObject, eventdata, handles)
function Ov_y_19_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVERALL                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ov_perc_01_Callback(hObject, ~, handles) 
c=1; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_02_Callback(hObject, ~, handles) %#ok<*DEFNU>
c=2; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_03_Callback(hObject, ~, handles)
c=3; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_04_Callback(hObject, ~, handles)
c=4; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_05_Callback(hObject, ~, handles)
c=5; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_06_Callback(hObject, ~, handles)
c=6; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_07_Callback(hObject, ~, handles)
c=7; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_08_Callback(hObject, ~, handles)
c=8; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_09_Callback(hObject, ~, handles)
c=9; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_10_Callback(hObject, ~, handles)
c=10; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_11_Callback(hObject, ~, handles)
c=11; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_12_Callback(hObject, ~, handles)
c=12; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_13_Callback(hObject, ~, handles)
c=13; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Ov_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_perc_19_Callback(hObject, eventdata, handles)

function Ov_y_01_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_02_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_03_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_04_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_05_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_06_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_07_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_08_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_09_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Ov_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Ov_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Ov_y_19_Callback(hObject, eventdata, handles)


function male_perc_01_CreateFcn(hObject, eventdata, handles)
function male_perc_02_CreateFcn(hObject, eventdata, handles)
function male_perc_03_CreateFcn(hObject, eventdata, handles)
function male_perc_04_CreateFcn(hObject, eventdata, handles)
function male_perc_05_CreateFcn(hObject, eventdata, handles)
function male_perc_06_CreateFcn(hObject, eventdata, handles)
function male_perc_07_CreateFcn(hObject, eventdata, handles)
function male_perc_08_CreateFcn(hObject, eventdata, handles)
function male_perc_09_CreateFcn(hObject, eventdata, handles)
function male_perc_10_CreateFcn(hObject, eventdata, handles)
function male_perc_11_CreateFcn(hObject, eventdata, handles)
function male_perc_12_CreateFcn(hObject, eventdata, handles)
function male_perc_13_CreateFcn(hObject, eventdata, handles)
function male_perc_14_CreateFcn(hObject, eventdata, handles)
function male_perc_15_CreateFcn(hObject, eventdata, handles)
function male_perc_16_CreateFcn(hObject, eventdata, handles)
function male_perc_17_CreateFcn(hObject, eventdata, handles)
function male_perc_18_CreateFcn(hObject, eventdata, handles)
function male_perc_19_CreateFcn(hObject, eventdata, handles)
function male_y_01_CreateFcn(hObject, eventdata, handles)
function male_y_02_CreateFcn(hObject, eventdata, handles)
function male_y_03_CreateFcn(hObject, eventdata, handles)
function male_y_04_CreateFcn(hObject, eventdata, handles)
function male_y_05_CreateFcn(hObject, eventdata, handles)
function male_y_06_CreateFcn(hObject, eventdata, handles)
function male_y_07_CreateFcn(hObject, eventdata, handles)
function male_y_08_CreateFcn(hObject, eventdata, handles)
function male_y_09_CreateFcn(hObject, eventdata, handles)
function male_y_10_CreateFcn(hObject, eventdata, handles)
function male_y_11_CreateFcn(hObject, eventdata, handles)
function male_y_12_CreateFcn(hObject, eventdata, handles)
function male_y_13_CreateFcn(hObject, eventdata, handles)
function male_y_14_CreateFcn(hObject, eventdata, handles)
function male_y_15_CreateFcn(hObject, eventdata, handles)
function male_y_16_CreateFcn(hObject, eventdata, handles)
function male_y_17_CreateFcn(hObject, eventdata, handles)
function male_y_18_CreateFcn(hObject, eventdata, handles)
function male_y_19_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MALE                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function male_perc_01_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_02_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_03_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_04_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_05_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_06_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_07_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_08_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_09_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Male_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_perc_19_Callback(hObject, eventdata, handles)

function male_y_01_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_02_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_03_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_04_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_05_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_06_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_07_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_08_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_09_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Male_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Male_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function male_y_19_Callback(hObject, eventdata, handles)

function female_perc_01_CreateFcn(hObject, eventdata, handles)
function female_perc_02_CreateFcn(hObject, eventdata, handles)
function female_perc_03_CreateFcn(hObject, eventdata, handles)
function female_perc_04_CreateFcn(hObject, eventdata, handles)
function female_perc_05_CreateFcn(hObject, eventdata, handles)
function female_perc_06_CreateFcn(hObject, eventdata, handles)
function female_perc_07_CreateFcn(hObject, eventdata, handles)
function female_perc_08_CreateFcn(hObject, eventdata, handles)
function female_perc_09_CreateFcn(hObject, eventdata, handles)
function female_perc_10_CreateFcn(hObject, eventdata, handles)
function female_perc_11_CreateFcn(hObject, eventdata, handles)
function female_perc_12_CreateFcn(hObject, eventdata, handles)
function female_perc_13_CreateFcn(hObject, eventdata, handles)
function female_perc_14_CreateFcn(hObject, eventdata, handles)
function female_perc_15_CreateFcn(hObject, eventdata, handles)
function female_perc_16_CreateFcn(hObject, eventdata, handles)
function female_perc_17_CreateFcn(hObject, eventdata, handles)
function female_perc_18_CreateFcn(hObject, eventdata, handles)

function female_y_01_CreateFcn(hObject, eventdata, handles)
function female_y_02_CreateFcn(hObject, eventdata, handles)
function female_y_03_CreateFcn(hObject, eventdata, handles)
function female_y_04_CreateFcn(hObject, eventdata, handles)
function female_y_05_CreateFcn(hObject, eventdata, handles)
function female_y_06_CreateFcn(hObject, eventdata, handles)
function female_y_07_CreateFcn(hObject, eventdata, handles)
function female_y_08_CreateFcn(hObject, eventdata, handles)
function female_y_09_CreateFcn(hObject, eventdata, handles)
function female_y_10_CreateFcn(hObject, eventdata, handles)
function female_y_11_CreateFcn(hObject, eventdata, handles)
function female_y_12_CreateFcn(hObject, eventdata, handles)
function female_y_13_CreateFcn(hObject, eventdata, handles)
function female_y_14_CreateFcn(hObject, eventdata, handles)
function female_y_15_CreateFcn(hObject, eventdata, handles)
function female_y_16_CreateFcn(hObject, eventdata, handles)
function female_y_17_CreateFcn(hObject, eventdata, handles)
function female_y_18_CreateFcn(hObject, eventdata, handles)
function female_y_19_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEMALE                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function female_perc_01_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_02_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_03_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_04_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_05_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_06_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_07_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_08_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_09_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_13_Callback(hObject, eventdata, handles) %#ok<*INUSL>
c=13; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Female_perc_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_inc(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_perc_19_Callback(hObject, eventdata, handles)

function female_y_01_Callback(hObject, ~, handles)
c=1; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_02_Callback(hObject, ~, handles)
c=2; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_03_Callback(hObject, ~, handles)
c=3; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_04_Callback(hObject, ~, handles)
c=4; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_05_Callback(hObject, ~, handles)
c=5; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_06_Callback(hObject, ~, handles)
c=6; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_07_Callback(hObject, ~, handles)
c=7; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_08_Callback(hObject, ~, handles)
c=8; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_09_Callback(hObject, ~, handles)
c=9; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_10_Callback(hObject, ~, handles)
c=10; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_11_Callback(hObject, ~, handles)
c=11; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_12_Callback(hObject, ~, handles)
c=12; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_13_Callback(hObject, ~, handles)
c=13; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.Female_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.Female_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function female_y_19_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adenoma danger (probability directly turing to cancer)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ad_danger_1_CreateFcn(hObject, eventdata, handles)
function ad_danger_2_CreateFcn(hObject, eventdata, handles)
function ad_danger_3_CreateFcn(hObject, eventdata, handles)
function ad_danger_4_CreateFcn(hObject, eventdata, handles)
function ad_danger_5_CreateFcn(hObject, eventdata, handles)
function ad_danger_6_CreateFcn(hObject, eventdata, handles)

function ad_danger_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function ad_danger_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function ad_danger_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function ad_danger_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function ad_danger_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function ad_danger_6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Ad_danger_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Rel_Danger(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fraction rectum carcinoma                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rectum_y_1_CreateFcn(hObject, eventdata, handles)
function rectum_y_2_CreateFcn(hObject, eventdata, handles)
function rectum_y_3_CreateFcn(hObject, eventdata, handles)
function rectum_y_4_CreateFcn(hObject, eventdata, handles)
function rectum_male_1_CreateFcn(hObject, eventdata, handles)
function rectum_male_2_CreateFcn(hObject, eventdata, handles)
function rectum_male_3_CreateFcn(hObject, eventdata, handles)
function rectum_male_4_CreateFcn(hObject, eventdata, handles)
function rectum_female_1_CreateFcn(hObject, eventdata, handles)
function rectum_female_2_CreateFcn(hObject, eventdata, handles)
function rectum_female_3_CreateFcn(hObject, eventdata, handles)
function rectum_female_4_CreateFcn(hObject, eventdata, handles)

function rectum_y_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Rectum_Ca_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Tmp.Benchmarks_Cancer_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_y_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Rectum_Ca_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Tmp.Benchmarks_Cancer_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_y_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Rectum_Ca_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Tmp.Benchmarks_Cancer_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_y_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Rectum_Ca_y_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Tmp.Benchmarks_Cancer_y(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function rectum_male_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Rectum_Ca_male_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumMale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_male_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Rectum_Ca_male_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumMale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_male_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Rectum_Ca_male_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumMale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_male_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Rectum_Ca_male_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumMale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function rectum_female_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Rectum_Ca_female_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumFeale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_female_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Rectum_Ca_female_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumFeale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_female_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Rectum_Ca_female_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumFeale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectum_female_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Rectum_Ca_female_handles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Benchmarks.Cancer.LocationRectumFeale(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETURN                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Return_Callback(hObject, eventdata, handles)
Answer = questdlg('Do you want to keep the settings?', 'Return?', 'Yes', 'No', 'Cancel', 'Yes');
if isequal(Answer, 'Cancel')
    return
elseif isequal(Answer, 'Yes')
    [~,vv] = sort(handles.Benchmarks.Cancer.Ov_y);
    handles.Benchmarks.Cancer.Ov_y     = handles.Benchmarks.Cancer.Ov_y(vv);
    handles.Benchmarks.Cancer.Ov_inc  = handles.Benchmarks.Cancer.Ov_inc(vv);
    for f=length(handles.Benchmarks.Cancer.Ov_y):-1:1
        if isequal(handles.Benchmarks.Cancer.Ov_y(f), 0)
            handles.Benchmarks.Cancer.Ov_y(f) = [];
            handles.Benchmarks.Cancer.Ov_inc(f) = [];
        end
    end
    
    [~,vv] = sort(handles.Benchmarks.Cancer.Male_y);
    handles.Benchmarks.Cancer.Male_y     = handles.Benchmarks.Cancer.Male_y(vv);
    handles.Benchmarks.Cancer.Male_inc  = handles.Benchmarks.Cancer.Male_inc(vv);
    for f=length(handles.Benchmarks.Cancer.Male_y):-1:1
        if isequal(handles.Benchmarks.Cancer.Male_y(f), 0)
            handles.Benchmarks.Cancer.Male_y(f) = [];
            handles.Benchmarks.Cancer.Male_inc(f) = [];
        end
    end
    
    [~,vv] = sort(handles.Benchmarks.Cancer.Female_y);
    handles.Benchmarks.Cancer.Female_y = handles.Benchmarks.Cancer.Female_y(vv);
    handles.Benchmarks.Cancer.Female_inc  = handles.Benchmarks.Cancer.Female_inc(vv);
    for f=length(handles.Benchmarks.Cancer.Female_y):-1:1
        if isequal(handles.Benchmarks.Cancer.Female_y(f), 0)
            handles.Benchmarks.Cancer.Female_y(f)    = [];
            handles.Benchmarks.Cancer.Female_inc(f) = [];
        end
    end
    
    handles.Variables.Benchmarks  = handles.Benchmarks;
end
set(0, 'userdata', handles.Variables);
uiresume(handles.figure1);

if ishandle(handles.figure1)
    delete(handles.figure1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SORT                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Sort_Callback(hObject, eventdata, handles)
% we sort all values and write values in the handles structure and update
% the display
handles = SortValues(hObject, handles);
handles = MakeImagesCurrent(hObject, handles);
guidata(hObject, handles);
