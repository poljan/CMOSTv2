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

function varargout = ManualAdjustments(varargin)
% POLYPCALCULATOR 
%      simulation for the natural history of colorectal polyps and cancer
%      helpful for testing the effects of various screening strategies 
%
%      Program created by Benjamin Misselwitz, 2010-2011

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ManualAdjustments_OpeningFcn, ...
    'gui_OutputFcn',  @ManualAdjustments_OutputFcn, ...
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


% Executes just before ManualAdjustments is made visible.
function ManualAdjustments_OpeningFcn(hObject, eventdata, handles, varargin)
handles.Variables = get(0, 'userdata');
handles.OldVariables = handles.Variables;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Handles Variables            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% these variabels are internal references for the elemts in the GUI
handles.NewPolypHandles ={'New_1'; 'New_6'; 'New_11'; 'New_16';...
    'New_21'; 'New_26'; 'New_31'; 'New_36'; 'New_41';...
    'New_46'; 'New_51'; 'New_56'; 'New_61';...
    'New_66'; 'New_71'; 'New_76'; 'New_81';...
    'New_86'; 'New_91'; 'New_96'};
handles.EarlyProgressionHandles ={'Early_p_1'; 'Early_p_6'; 'Early_p_11'; 'Early_p_16';...
    'Early_p_21'; 'Early_p_26'; 'Early_p_31'; 'Early_p_36'; 'Early_p_41';...
    'Early_p_46'; 'Early_p_51'; 'Early_p_56'; 'Early_p_61';...
    'Early_p_66'; 'Early_p_71'; 'Early_p_76'; 'Early_p_81';...
    'Early_p_86'; 'Early_p_91'; 'Early_p_96'};
handles.AdvancedProgressionHandles ={'Adv_p_1'; 'Adv_p_6'; 'Adv_p_11'; 'Adv_p_16';...
    'Adv_p_21'; 'Adv_p_26'; 'Adv_p_31'; 'Adv_p_36'; 'Adv_p_41';...
    'Adv_p_46'; 'Adv_p_51'; 'Adv_p_56'; 'Adv_p_61';...
    'Adv_p_66'; 'Adv_p_71'; 'Adv_p_76'; 'Adv_p_81';...
    'Adv_p_86'; 'Adv_p_91'; 'Adv_p_96'};
handles.DirectCancerMaleHandles = {'direct_male_1'; 'direct_male_2'; 'direct_male_3';
    'direct_male_4'; 'direct_male_5'; 'direct_male_6'; 'direct_male_7';
    'direct_male_8'; 'direct_male_9'; 'direct_male_10'; 'direct_male_11';
    'direct_male_12'; 'direct_male_13'; 'direct_male_14'; 'direct_male_15';
    'direct_male_16'; 'direct_male_17'; 'direct_male_18'; 'direct_male_19'; 'direct_male_20'};
handles.DirectCancerFemaleHandles = {'direct_female_1'; 'direct_female_2'; 'direct_female_3';
    'direct_female_4'; 'direct_female_5'; 'direct_female_6'; 'direct_female_7';
    'direct_female_8'; 'direct_female_9'; 'direct_female_10'; 'direct_female_11';
    'direct_female_12'; 'direct_female_13'; 'direct_female_14'; 'direct_female_15';
    'direct_female_16'; 'direct_female_17'; 'direct_female_18'; 'direct_female_19'; 'direct_female_20'};
handles.ProgressionHandles ={'Progression_P1'; 'Progression_P2'; 'Progression_P3'; 'Progression_P4';...
    'Progression_P5'; 'Progression_Cis'};
handles.FastCancerHandles = {'fast_cancer_1'; 'fast_cancer_2'; 'fast_cancer_3'; 'fast_cancer_4'; 'fast_cancer_5'};
handles.HealingHandles ={'Healing_P1'; 'Healing_P2'; 'Healing_P3'; 'Healing_P4';...
    'Healing_P5'; 'Healing_Cis'};

% Update handles structure
handles.output = hObject;
guidata(hObject, handles)
handles = MakeImagesCurrent(hObject, handles);
% handles.Variables = AdjustRiskGraph(handles.Variables);
guidata(hObject, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% This function is called whenever a change is made within the GUI. This 
% function makes this changes visible

%%%% NEW POLYP
% filling the numbers between the settings
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.NewPolyp(counter) = (handles.Variables.NewPolypRate(x1) * (5-x2) + ...
            handles.Variables.NewPolypRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.NewPolyp(counter : 150) = handles.Variables.NewPolypRate(end);

%%%% EARLY PROGRESSION
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
            handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);

%%%% ADVANCED PROGRESSION
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
            handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);

%%%% DIRECT CANCER
counter = 1;
for x1=1:19
    for x2=1:5
        DirectCancerCurve(1, counter) = (handles.Variables.DirectCancerRate(1, x1) * (5-x2) + ...
            handles.Variables.DirectCancerRate(1, x1+1) * (x2-1))/4; %#ok<AGROW>
        DirectCancerCurve(2, counter) = (handles.Variables.DirectCancerRate(2, x1) * (5-x2) + ...
            handles.Variables.DirectCancerRate(2, x1+1) * (x2-1))/4; %#ok<AGROW>
        counter = counter + 1;
    end
end
DirectCancerCurve(1, counter : 150) = DirectCancerCurve(1, (counter-1));
DirectCancerCurve(2, counter : 150) = DirectCancerCurve(2, (counter-1));

%%%% COLONOSCOPY LIKELYHOOD

% adjust graphs for new polyps
for f=1:length(handles.NewPolypHandles)
    set(handles.(handles.NewPolypHandles{f}), 'string', num2str(handles.Variables.NewPolypRate(f)));
end
axes(handles.New_Polyp_Plot); cla(handles.New_Polyp_Plot) %#ok<*MAXES>
plot(1:100, handles.Variables.NewPolyp(1:100)), hold on
for f=1:20, plot((f-1)*5+1, handles.Variables.NewPolypRate(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end, hold off, axis off
%xlabel('age'), ylabel('new per year'), hold off

% adjust graphs for early progression
for f=1:length(handles.EarlyProgressionHandles)
    set(handles.(handles.EarlyProgressionHandles{f}), 'string', num2str(handles.Variables.EarlyProgressionRate(f)));
end
axes(handles.Early_Progression_Plot); cla(handles.Early_Progression_Plot)
plot(1:100, handles.Variables.EarlyProgression(1:100)), hold on
for f=1:20
    plot((f-1)*5+1, handles.Variables.EarlyProgressionRate(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end, hold off, axis off

% adjust graphs for advanced progression
for f=1:length(handles.AdvancedProgressionHandles)
    set(handles.(handles.AdvancedProgressionHandles{f}), 'string', num2str(handles.Variables.AdvancedProgressionRate(f)));
end
axes(handles.Advanced_Progression_Plot); cla(handles.Advanced_Progression_Plot)
plot(1:100, handles.Variables.AdvancedProgression(1:100)), hold on
for f=1:20
    plot((f-1)*5+1, handles.Variables.AdvancedProgressionRate(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end, hold off, axis off

% direct cancer
for f=1:length(handles.DirectCancerMaleHandles)
    set(handles.(handles.DirectCancerMaleHandles{f}), 'string', num2str(handles.Variables.DirectCancerRate(1, f)));
end
for f=1:length(handles.DirectCancerFemaleHandles)
    set(handles.(handles.DirectCancerFemaleHandles{f}), 'string', num2str(handles.Variables.DirectCancerRate(2, f)));
end
axes(handles.direct_cancer_plot); cla(handles.direct_cancer_plot)
plot(1:100, DirectCancerCurve(1, 1:100)), hold on
plot(1:100, DirectCancerCurve(2, 1:100))
for f=1:20
    plot((f-1)*5+1, handles.Variables.DirectCancerRate(1, f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
    plot((f-1)*5+1, handles.Variables.DirectCancerRate(2, f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
hold off, axis off

% progression, fast cancer mortality
for f=1:length(handles.ProgressionHandles)
    set(handles.(handles.ProgressionHandles{f}), 'string', num2str(handles.Variables.Progression(f))); end
for f=1:length(handles.FastCancerHandles)
    set(handles.(handles.FastCancerHandles{f}), 'string', num2str(handles.Variables.FastCancer(f))); end
for f=1:length(handles.HealingHandles)
    set(handles.(handles.HealingHandles{f}), 'string', num2str(handles.Variables.Healing(f))); end

% female
set(handles.fraction_female, 'string', num2str(handles.Variables.fraction_female))
set(handles.new_polyp_female, 'string', num2str(handles.Variables.new_polyp_female))
set(handles.early_progression_female, 'string', num2str(handles.Variables.early_progression_female))
set(handles.advanced_progression_female, 'string', num2str(handles.Variables.advanced_progression_female))

% direct cancer speed
set(handles.direct_cancer_speed, 'string', num2str(handles.Variables.DirectCancerSpeed))

guidata(hObject, handles);

function varargout = ManualAdjustments_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%%% New Polyp Callbacks
function New_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_6_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_11_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_16_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_21_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_26_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_31_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_36_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_41_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_46_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_51_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_56_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_61_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_66_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_71_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_76_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_81_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_86_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_91_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function New_96_Callback(hObject, eventdata, handles)
c=20; tmp=get(handles.(handles.NewPolypHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.NewPolypRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%% Early Polyp Progression Callback
function Early_p_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_6_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_11_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_16_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_21_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_26_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_31_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_36_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_41_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_46_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_51_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_56_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_61_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_66_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_71_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_76_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_81_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_86_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_91_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Early_p_96_Callback(hObject, eventdata, handles)
c=20; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.EarlyProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%% Advanced Polyp Progression Callback
function Adv_p_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_6_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_11_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_16_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_21_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_26_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_31_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_36_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_41_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_46_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_51_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_56_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_61_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_66_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_71_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_76_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_81_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_86_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_91_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Adv_p_96_Callback(hObject, eventdata, handles) %#ok<*INUSL>
c=20; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.AdvancedProgressionRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% direct cancer male
function direct_male_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_male_2_Callback(hObject, eventdata, handles)    
c=2; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_3_Callback(hObject, eventdata, handles)    
c=3; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_male_4_Callback(hObject, eventdata, handles)    
c=4; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_male_5_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_male_6_Callback(hObject, eventdata, handles)    
c=6; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_7_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_8_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_9_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_12_Callback(hObject, eventdata, handles)   
c=12; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_13_Callback(hObject, eventdata, handles)   
c=13; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_14_Callback(hObject, eventdata, handles)   
c=14; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_15_Callback(hObject, eventdata, handles)   
c=15; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_16_Callback(hObject, eventdata, handles)   
c=16; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_17_Callback(hObject, eventdata, handles)    
c=17; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_18_Callback(hObject, eventdata, handles)    
c=18; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_19_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_male_20_Callback(hObject, eventdata, handles)
c=20; tmp=get(handles.(handles.DirectCancerMaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(1, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% direct cancer female
function direct_female_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function direct_female_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_7_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_8_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_9_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_14_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_15_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_16_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_17_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_18_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_19_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function direct_female_20_Callback(hObject, eventdata, handles)
c=20; tmp=get(handles.(handles.DirectCancerFemaleHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerRate(2, c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
    
%%% Progression Callbacks
function Progression_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Progression_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Progression_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Progression_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Progression_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Progression_Cis_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.ProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Progression(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%% Fast Cancer Callbacks
function fast_cancer_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.FastCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.FastCancer(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function fast_cancer_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.FastCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.FastCancer(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function fast_cancer_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.FastCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.FastCancer(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function fast_cancer_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.FastCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.FastCancer(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function fast_cancer_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.FastCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.FastCancer(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%% Healing Callbacks
function Healing_P1_Callback(hObject, eventdata, handles) 
c=1; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Healing_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Healing_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Healing_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Healing_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Healing_Cis_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.HealingHandles{c}), 'string'); [num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Healing(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

%%% male female Callbacks
function fraction_female_Callback(hObject, eventdata, handles)
tmp=get(handles.fraction_female, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.fraction_female=num; end, end
MakeImagesCurrent(hObject, handles);
function new_polyp_female_Callback(hObject, eventdata, handles)
tmp=get(handles.new_polyp_female, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.new_polyp_female=num; end, end
MakeImagesCurrent(hObject, handles);
function early_progression_female_Callback(hObject, eventdata, handles)
tmp=get(handles.early_progression_female, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.early_progression_female=num; end, end
MakeImagesCurrent(hObject, handles);
function advanced_progression_female_Callback(hObject, eventdata, handles)
tmp=get(handles.advanced_progression_female, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.advanced_progression_female=num; end, end
MakeImagesCurrent(hObject, handles);

% direct cancer speed
function direct_cancer_speed_Callback(hObject, eventdata, handles)
tmp=get(handles.direct_cancer_speed, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DirectCancerSpeed=num; end, end
MakeImagesCurrent(hObject, handles);

%%% Create Functions %%%
function New_1_CreateFcn(hObject, eventdata, handles), function New_6_CreateFcn(hObject, eventdata, handles), function New_11_CreateFcn(hObject, eventdata, handles), function New_16_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
function New_21_CreateFcn(hObject, eventdata, handles), function New_26_CreateFcn(hObject, eventdata, handles), function New_31_CreateFcn(hObject, eventdata, handles), function New_36_CreateFcn(hObject, eventdata, handles)
function New_41_CreateFcn(hObject, eventdata, handles), function New_46_CreateFcn(hObject, eventdata, handles), function New_51_CreateFcn(hObject, eventdata, handles), function New_56_CreateFcn(hObject, eventdata, handles) 
function New_61_CreateFcn(hObject, eventdata, handles), function New_66_CreateFcn(hObject, eventdata, handles), function New_71_CreateFcn(hObject, eventdata, handles), function New_76_CreateFcn(hObject, eventdata, handles)
function New_81_CreateFcn(hObject, eventdata, handles), function New_86_CreateFcn(hObject, eventdata, handles), function New_91_CreateFcn(hObject, eventdata, handles), function New_96_CreateFcn(hObject, eventdata, handles)
function Early_p_1_CreateFcn(hObject, eventdata, handles), function Early_p_6_CreateFcn(hObject, eventdata, handles), function Early_p_11_CreateFcn(hObject, eventdata, handles), function Early_p_16_CreateFcn(hObject, eventdata, handles)
function Early_p_21_CreateFcn(hObject, eventdata, handles), function Early_p_26_CreateFcn(hObject, eventdata, handles), function Early_p_31_CreateFcn(hObject, eventdata, handles), function Early_p_36_CreateFcn(hObject, eventdata, handles)
function Early_p_41_CreateFcn(hObject, eventdata, handles), function Early_p_46_CreateFcn(hObject, eventdata, handles), function Early_p_51_CreateFcn(hObject, eventdata, handles), function Early_p_56_CreateFcn(hObject, eventdata, handles)
function Early_p_61_CreateFcn(hObject, eventdata, handles), function Early_p_66_CreateFcn(hObject, eventdata, handles), function Early_p_71_CreateFcn(hObject, eventdata, handles), function Early_p_76_CreateFcn(hObject, eventdata, handles)
function Early_p_81_CreateFcn(hObject, eventdata, handles), function Early_p_86_CreateFcn(hObject, eventdata, handles), function Early_p_91_CreateFcn(hObject, eventdata, ~), function Early_p_96_CreateFcn(hObject, eventdata, handles)
function Adv_p_1_CreateFcn(hObject, eventdata, handles), function Adv_p_6_CreateFcn(hObject, eventdata, handles), function Adv_p_11_CreateFcn(hObject, eventdata, handles), function Adv_p_16_CreateFcn(hObject, eventdata, handles)
function Adv_p_21_CreateFcn(hObject, eventdata, handles), function Adv_p_26_CreateFcn(hObject, eventdata, handles), function Adv_p_31_CreateFcn(hObject, eventdata, handles), function Adv_p_36_CreateFcn(hObject, eventdata, handles)
function Adv_p_41_CreateFcn(hObject, eventdata, handles), function Adv_p_46_CreateFcn(hObject, eventdata, handles), function Adv_p_51_CreateFcn(hObject, eventdata, handles), function Adv_p_56_CreateFcn(hObject, eventdata, handles)
function Adv_p_61_CreateFcn(hObject, eventdata, handles), function Adv_p_66_CreateFcn(hObject, eventdata, handles), function Adv_p_71_CreateFcn(hObject, eventdata, handles), function Adv_p_76_CreateFcn(hObject, eventdata, handles)
function Adv_p_81_CreateFcn(hObject, eventdata, handles), function Adv_p_86_CreateFcn(hObject, eventdata, handles), function Adv_p_91_CreateFcn(hObject, eventdata, handles), function Adv_p_96_CreateFcn(hObject, eventdata, handles)
function Progression_P1_CreateFcn(hObject, eventdata, handles), function Progression_P2_CreateFcn(hObject, eventdata, handles), function Progression_P3_CreateFcn(hObject, eventdata, handles), function Progression_P4_CreateFcn(hObject, eventdata, handles)
function Progression_P5_CreateFcn(hObject, eventdata, handles), function Progression_Cis_CreateFcn(hObject, eventdata, handles)
function Healing_P1_CreateFcn(hObject, eventdata, handles), function Healing_P2_CreateFcn(hObject, eventdata, handles)
function Healing_P3_CreateFcn(hObject, eventdata, handles), function Healing_P4_CreateFcn(hObject, eventdata, handles), function Healing_P5_CreateFcn(hObject, eventdata, handles), function Healing_Cis_CreateFcn(hObject, eventdata, handles)
function fraction_female_CreateFcn(hObject, eventdata, handles)
function rel_risc_female_CreateFcn(hObject, eventdata, handles), function settings_name_CreateFcn(hObject, eventdata, handles), function comment_CreateFcn(hObject, eventdata, handles), function radiobutton7_Callback(hObject, eventdata, handles)
function special_text_CreateFcn(hObject, eventdata, handles), function fast_cancer_2_CreateFcn(hObject, eventdata, handles), function fast_cancer_3_CreateFcn(hObject, eventdata, handles)
function fast_cancer_1_CreateFcn(hObject, eventdata, handles), function fast_cancer_4_CreateFcn(hObject, eventdata, handles), function fast_cancer_5_CreateFcn(hObject, eventdata, handles), function advanced_progression_female_CreateFcn(hObject, eventdata, handles)
function early_progression_female_CreateFcn(hObject, eventdata, handles), function new_polyp_female_CreateFcn(hObject, eventdata, handles)
function direct_male_1_CreateFcn(hObject, eventdata, handles), function direct_male_2_CreateFcn(hObject, eventdata, handles), function direct_male_3_CreateFcn(hObject, eventdata, handles), function direct_male_4_CreateFcn(hObject, eventdata, handles)    
function direct_male_5_CreateFcn(hObject, eventdata, handles), function direct_male_6_CreateFcn(hObject, eventdata, handles), function direct_male_7_CreateFcn(hObject, eventdata, handles), function direct_male_8_CreateFcn(hObject, eventdata, handles)    
function direct_male_9_CreateFcn(hObject, eventdata, handles), function direct_male_10_CreateFcn(hObject, eventdata, handles), function direct_male_11_CreateFcn(hObject, eventdata, handles), function direct_male_12_CreateFcn(hObject, eventdata, handles)    
function direct_male_13_CreateFcn(hObject, eventdata, handles), function direct_male_14_CreateFcn(hObject, eventdata, handles), function direct_male_15_CreateFcn(hObject, eventdata, handles), function direct_male_16_CreateFcn(hObject, eventdata, handles)    
function direct_male_17_CreateFcn(hObject, eventdata, handles), function direct_male_18_CreateFcn(hObject, eventdata, handles), function direct_male_19_CreateFcn(hObject, eventdata, handles), function direct_male_20_CreateFcn(hObject, eventdata, handles)
function direct_female_1_CreateFcn(hObject, eventdata, handles), function direct_female_2_CreateFcn(hObject, eventdata, handles), function direct_female_3_CreateFcn(hObject, eventdata, handles), function direct_female_4_CreateFcn(hObject, eventdata, handles)
function direct_female_5_CreateFcn(hObject, eventdata, handles), function direct_female_6_CreateFcn(hObject, eventdata, handles), function direct_female_7_CreateFcn(hObject, eventdata, handles), function direct_female_8_CreateFcn(hObject, eventdata, handles)
function direct_female_9_CreateFcn(hObject, eventdata, handles), function direct_female_10_CreateFcn(hObject, eventdata, handles), function direct_female_11_CreateFcn(hObject, eventdata, handles), function direct_female_12_CreateFcn(hObject, eventdata, handles)    
function direct_female_13_CreateFcn(hObject, eventdata, handles), function direct_female_14_CreateFcn(hObject, eventdata, handles), function direct_female_15_CreateFcn(hObject, eventdata, handles), function direct_female_16_CreateFcn(hObject, eventdata, handles)    
function direct_female_17_CreateFcn(hObject, eventdata, handles), function direct_female_18_CreateFcn(hObject, eventdata, handles), function direct_female_19_CreateFcn(hObject, eventdata, handles), function direct_female_20_CreateFcn(hObject, eventdata, handles)
function direct_cancer_speed_CreateFcn(hObject, eventdata, handles)
function edit266_Callback(hObject, eventdata, handles)
function edit266_CreateFcn(hObject, eventdata, handles)
function edit265_Callback(hObject, eventdata, handles)
function edit265_CreateFcn(hObject, eventdata, handles)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Return                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Return_Callback(hObject, eventdata, handles)
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

  
