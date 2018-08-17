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

function varargout = Mortality_Settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mortality_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Mortality_Settings_OutputFcn, ...
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


function Mortality_Settings_OpeningFcn(hObject, eventdata, handles, varargin)

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Mortality', 'NumberTitle','off')

handles.MortHandles ={'Mort_01'; 'Mort_06'; 'Mort_11'; 'Mort_16';...
    'Mort_21'; 'Mort_26'; 'Mort_31'; 'Mort_36'; 'Mort_41';...
    'Mort_46'; 'Mort_51'; 'Mort_56'; 'Mort_61';...
    'Mort_66'; 'Mort_71'; 'Mort_76'; 'Mort_81';...
    'Mort_86'; 'Mort_91'; 'Mort_96'};
handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles); 
guidata(hObject, handles);

function varargout = Mortality_Settings_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function Mort_01_CreateFcn(hObject, eventdata, handles),function Mort_06_CreateFcn(hObject, eventdata, handles),function Mort_11_CreateFcn(hObject, eventdata, handles)
function Mort_16_CreateFcn(hObject, eventdata, handles),function Mort_21_CreateFcn(hObject, eventdata, handles),function Mort_26_CreateFcn(hObject, eventdata, handles)
function Mort_31_CreateFcn(hObject, eventdata, handles),function Mort_36_CreateFcn(hObject, eventdata, handles),function Mort_41_CreateFcn(hObject, eventdata, handles),function Mort_46_CreateFcn(hObject, eventdata, handles),
function Mort_51_CreateFcn(hObject, eventdata, handles),function Mort_56_CreateFcn(hObject, eventdata, handles),function Mort_61_CreateFcn(hObject, eventdata, handles),function Mort_66_CreateFcn(hObject, eventdata, handles),
function Mort_71_CreateFcn(hObject, eventdata, handles),function Mort_76_CreateFcn(hObject, eventdata, handles),function Mort_81_CreateFcn(hObject, eventdata, handles),function Mort_86_CreateFcn(hObject, eventdata, handles),
function Mort_91_CreateFcn(hObject, eventdata, handles),function Mort_96_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% This function is called whenever a change is made within the GUI. This 
% function makes this changes visible

counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.MortalityCorrectionGraph(counter) = (handles.Variables.MortalityCorrection(x1) * (5-x2) + ...
            handles.Variables.MortalityCorrection(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.MortalityCorrectionGraph(counter : 150) = handles.Variables.MortalityCorrection(end);

% adjust graphs for new polyps
for f=1:length(handles.MortHandles)
    set(handles.(handles.MortHandles{f}), 'string', num2str(handles.Variables.MortalityCorrection(f)));
end
axes(handles.Axis_1); cla(handles.Axis_1) %#ok<*MAXES>
plot(1:100, handles.Variables.MortalityCorrectionGraph(1:100)), hold on
for f=1:20, plot((f-1)*5+1, handles.Variables.MortalityCorrection(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end, hold off, axis off
guidata(hObject, handles)

%%% Mortality Handles Callbacks
function Mort_01_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_06_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_11_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_16_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_21_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_26_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_31_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_36_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_41_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_46_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_51_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_56_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_61_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_66_Callback(hObject, eventdata, handles)
c=14; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_71_Callback(hObject, eventdata, handles)
c=15; tmp=get(handles.(handles.MortHandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_76_Callback(hObject, eventdata, handles)
c=16; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_81_Callback(hObject, eventdata, handles)
c=17; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_86_Callback(hObject, eventdata, handles)
c=18; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_91_Callback(hObject, eventdata, handles)
c=19; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Mort_96_Callback(hObject, eventdata, handles)
c=20; tmp=get(handles.(handles.MortHandles{c}), 'string');[num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.MortalityCorrection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function done_Callback(hObject, eventdata, handles)
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
