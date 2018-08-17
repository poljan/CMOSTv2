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

function varargout = Location_Settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Location_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Location_Settings_OutputFcn, ...
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


function Location_Settings_OpeningFcn(hObject, eventdata, handles, varargin) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Handles Variables            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Location', 'NumberTitle','off')

% handles.Variables.Location_RectoSigmoDetection = handles.Variables.Location_ColoDetection; % DELETE later

% these variabels are internal references for the elemts in the GUI
handles.NewPolypHandles ={'new_1'; 'new_2'; 'new_3'; 'new_4';...
    'new_5'; 'new_6'; 'new_7'; 'new_8'; 'new_9';...
    'new_10'; 'new_11'; 'new_12'; 'new_13'};
handles.EarlyProgressionHandles ={'early_1'; 'early_2'; 'early_3'; 'early_4';...
    'early_5'; 'early_6'; 'early_7'; 'early_8'; 'early_9';...
    'early_10'; 'early_11'; 'early_12'; 'early_13'};
handles.AdvancedProgressionHandles ={'advanced_1'; 'advanced_2'; 'advanced_3'; 'advanced_4';...
    'advanced_5'; 'advanced_6'; 'advanced_7'; 'advanced_8'; 'advanced_9';...
    'advanced_10'; 'advanced_11'; 'advanced_12'; 'advanced_13'};
handles.ColodetectionHandles ={'Colo_detection_1'; 'Colo_detection_2'; 'Colo_detection_3'; 'Colo_detection_4';...
    'Colo_detection_5'; 'Colo_detection_6'; 'Colo_detection_7'; 'Colo_detection_8'; 'Colo_detection_9';...
    'Colo_detection_10'; 'Colo_detection_11'; 'Colo_detection_12'; 'Colo_detection_13'};
handles.RectoSigmoDetectionHandles ={'RectoSigmo_detection_1'; 'RectoSigmo_detection_2'; 'RectoSigmo_detection_3'; 'RectoSigmo_detection_4';...
    'RectoSigmo_detection_5'; 'RectoSigmo_detection_6'; 'RectoSigmo_detection_7'; 'RectoSigmo_detection_8'; 'RectoSigmo_detection_9';...
    'RectoSigmo_detection_10'; 'RectoSigmo_detection_11'; 'RectoSigmo_detection_12'; 'RectoSigmo_detection_13'};
handles.ColoReachHandles ={'colo_reach_1'; 'colo_reach_2'; 'colo_reach_3'; 'colo_reach_4';...
    'colo_reach_5'; 'colo_reach_6'; 'colo_reach_7'; 'colo_reach_8'; 'colo_reach_9';...
    'colo_reach_10'; 'colo_reach_11'; 'colo_reach_12'; 'colo_reach_13'};
handles.RectoSigmoReachHandles ={'rectosigmo_reach_1'; 'rectosigmo_reach_2'; 'rectosigmo_reach_3'; 'rectosigmo_reach_4';...
    'rectosigmo_reach_5'; 'rectosigmo_reach_6'; 'rectosigmo_reach_7'; 'rectosigmo_reach_8'; 'rectosigmo_reach_9';...
    'rectosigmo_reach_10'; 'rectosigmo_reach_11'; 'rectosigmo_reach_12'; 'rectosigmo_reach_13'};
handles.DirectCancerHandles ={'direct_1'; 'direct_2'; 'direct_3'; 'direct_4';...
    'direct_5'; 'direct_6'; 'direct_7'; 'direct_8'; 'direct_9';...
    'direct_10'; 'direct_11'; 'direct_12'; 'direct_13'};
    
handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles); 
guidata(hObject, handles);

function varargout = Location_Settings_OutputFcn(hObject, eventdata, handles)  
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% adjust location for new polyps
for f=1:length(handles.NewPolypHandles)
    set(handles.(handles.NewPolypHandles{f}), 'string', num2str(handles.Variables.Location_NewPolyp(f)));
end
% adjust location early polyp progression
for f=1:length(handles.EarlyProgressionHandles)
    set(handles.(handles.EarlyProgressionHandles{f}), 'string', num2str(handles.Variables.Location_EarlyProgression(f)));
end
% adjust location advanced polyp progression
for f=1:length(handles.AdvancedProgressionHandles)
    set(handles.(handles.AdvancedProgressionHandles{f}), 'string', num2str(handles.Variables.Location_AdvancedProgression(f)));
end
% adjust location colo detection
for f=1:length(handles.ColodetectionHandles)
    set(handles.(handles.ColodetectionHandles{f}), 'string', num2str(handles.Variables.Location_ColoDetection(f)));
end
% adjust location RectoSigmo detection
for f=1:length(handles.RectoSigmoDetectionHandles)
    set(handles.(handles.RectoSigmoDetectionHandles{f}), 'string', num2str(handles.Variables.Location_RectoSigmoDetection(f)));
end
% adjust location reach colonoscopy
for f=1:length(handles.ColoReachHandles)
    set(handles.(handles.ColoReachHandles{f}), 'string', num2str(handles.Variables.Location_ColoReach(f)));
end
% adjust location reach rectosigmoidoscopy
for f=1:length(handles.RectoSigmoReachHandles)
    set(handles.(handles.RectoSigmoReachHandles{f}), 'string', num2str(handles.Variables.Location_RectoSigmoReach(f)));
end
% adjust direct cancer
for f=1:length(handles.DirectCancerHandles)
    set(handles.(handles.DirectCancerHandles{f}), 'string', num2str(handles.Variables.Location_DirectCa(f)));
end

guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Done                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function done_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
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

function rectosigmo_reach_1_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_2_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_3_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_4_CreateFcn(hObject, eventdata, handles)
function rectosigmo_reach_5_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_6_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_7_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_8_CreateFcn(hObject, eventdata, handles)
function rectosigmo_reach_9_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_10_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_11_CreateFcn(hObject, eventdata, handles); function rectosigmo_reach_12_CreateFcn(hObject, eventdata, handles)
function rectosigmo_reach_13_CreateFcn(hObject, eventdata, handles)
function new_1_CreateFcn(hObject, eventdata, handles); function new_2_CreateFcn(hObject, eventdata, handles); function new_3_CreateFcn(hObject, eventdata, handles); function new_4_CreateFcn(hObject, eventdata, handles)
function new_5_CreateFcn(hObject, eventdata, handles); function new_6_CreateFcn(hObject, eventdata, handles); function new_7_CreateFcn(hObject, eventdata, handles); function new_8_CreateFcn(hObject, eventdata, handles)
function new_9_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
function new_10_CreateFcn(hObject, eventdata, handles); function new_11_CreateFcn(hObject, eventdata, handles); function new_12_CreateFcn(hObject, eventdata, handles); function new_13_CreateFcn(hObject, eventdata, handles)
function early_1_CreateFcn(hObject, eventdata, handles); function early_2_CreateFcn(hObject, eventdata, handles); function early_3_CreateFcn(hObject, eventdata, handles); function early_4_CreateFcn(hObject, eventdata, handles)
function early_5_CreateFcn(hObject, eventdata, handles); function early_6_CreateFcn(hObject, eventdata, handles); function early_7_CreateFcn(hObject, eventdata, handles); function early_8_CreateFcn(hObject, eventdata, handles)
function early_9_CreateFcn(hObject, eventdata, handles); function early_10_CreateFcn(hObject, eventdata, handles); function early_11_CreateFcn(hObject, eventdata, handles); function early_12_CreateFcn(hObject, eventdata, handles)
function early_13_CreateFcn(hObject, eventdata, handles)
function advanced_1_CreateFcn(hObject, eventdata, handles); function advanced_2_CreateFcn(hObject, eventdata, handles); function advanced_3_CreateFcn(hObject, eventdata, handles); function advanced_4_CreateFcn(hObject, eventdata, handles)
function advanced_5_CreateFcn(hObject, eventdata, handles); function advanced_6_CreateFcn(hObject, eventdata, handles); function advanced_7_CreateFcn(hObject, eventdata, handles); function advanced_8_CreateFcn(hObject, eventdata, handles)
function advanced_9_CreateFcn(hObject, eventdata, handles); function advanced_10_CreateFcn(hObject, eventdata, handles); function advanced_11_CreateFcn(hObject, eventdata, handles); function advanced_12_CreateFcn(hObject, eventdata, handles)
function advanced_13_CreateFcn(hObject, eventdata, handles)
function Colo_detection_1_CreateFcn(hObject, eventdata, handles); function Colo_detection_2_CreateFcn(hObject, eventdata, handles); function Colo_detection_3_CreateFcn(hObject, eventdata, handles); function Colo_detection_4_CreateFcn(hObject, eventdata, handles)
function Colo_detection_5_CreateFcn(hObject, eventdata, handles); function Colo_detection_6_CreateFcn(hObject, eventdata, handles); function Colo_detection_7_CreateFcn(hObject, eventdata, handles); function Colo_detection_8_CreateFcn(hObject, eventdata, handles)
function Colo_detection_9_CreateFcn(hObject, eventdata, handles); function Colo_detection_10_CreateFcn(hObject, eventdata, handles); function Colo_detection_11_CreateFcn(hObject, eventdata, handles); function Colo_detection_12_CreateFcn(hObject, eventdata, handles)
function Colo_detection_13_CreateFcn(hObject, eventdata, handles)
function RectoSigmo_detection_1_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_2_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_3_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_4_CreateFcn(hObject, eventdata, handles)
function RectoSigmo_detection_5_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_6_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_7_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_8_CreateFcn(hObject, eventdata, handles)
function RectoSigmo_detection_9_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_10_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_11_CreateFcn(hObject, eventdata, handles); function RectoSigmo_detection_12_CreateFcn(hObject, eventdata, handles)
function RectoSigmo_detection_13_CreateFcn(hObject, eventdata, handles)
function colo_reach_1_CreateFcn(hObject, eventdata, handles); function colo_reach_2_CreateFcn(hObject, eventdata, handles); function colo_reach_3_CreateFcn(hObject, eventdata, handles); function colo_reach_4_CreateFcn(hObject, eventdata, handles)
function colo_reach_5_CreateFcn(hObject, eventdata, handles); function colo_reach_6_CreateFcn(hObject, eventdata, handles); function colo_reach_7_CreateFcn(hObject, eventdata, handles); function colo_reach_8_CreateFcn(hObject, eventdata, handles)
function colo_reach_9_CreateFcn(hObject, eventdata, handles); function colo_reach_10_CreateFcn(hObject, eventdata, handles); function colo_reach_11_CreateFcn(hObject, eventdata, handles); function colo_reach_12_CreateFcn(hObject, eventdata, handles)
function colo_reach_13_CreateFcn(hObject, eventdata, handles)
function direct_1_CreateFcn(hObject, eventdata, handles); function direct_2_CreateFcn(hObject, eventdata, handles); function direct_3_CreateFcn(hObject, eventdata, handles); function direct_4_CreateFcn(hObject, eventdata, handles)
function direct_5_CreateFcn(hObject, eventdata, handles); function direct_6_CreateFcn(hObject, eventdata, handles); function direct_7_CreateFcn(hObject, eventdata, handles); function direct_8_CreateFcn(hObject, eventdata, handles)    
function direct_9_CreateFcn(hObject, eventdata, handles); function direct_10_CreateFcn(hObject, eventdata, handles); function direct_11_CreateFcn(hObject, eventdata, handles); function direct_12_CreateFcn(hObject, eventdata, handles)
function direct_13_CreateFcn(hObject, eventdata, handles)  
    
function new_1_Callback(hObject, eventdata, handles) %#ok<*INUSL>
c=1; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function new_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_7_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_8_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_9_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function new_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.NewPolypHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_NewPolyp(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function early_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_7_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_8_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_9_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function early_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.EarlyProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_EarlyProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function advanced_1_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_7_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_8_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_9_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_10_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_11_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_12_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function advanced_13_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.AdvancedProgressionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_AdvancedProgression(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Colo_detection_1_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_7_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_8_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_9_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_10_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_11_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_12_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_detection_13_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.ColodetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function RectoSigmo_detection_1_Callback(hObject, eventdata, handles)
     c=1; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_7_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_8_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_9_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_10_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_11_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_12_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_detection_13_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.RectoSigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoDetection(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function colo_reach_1_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_7_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_8_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_9_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_10_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_11_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_12_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_reach_13_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.ColoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_ColoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function rectosigmo_reach_1_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_7_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_8_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_9_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_10_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_11_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_12_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_reach_13_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.RectoSigmoReachHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_RectoSigmoReach(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function direct_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_7_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_8_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_9_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_10_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_11_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_12_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function direct_13_Callback(hObject, eventdata, handles)
c=13; tmp=get(handles.(handles.DirectCancerHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Location_DirectCa(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
