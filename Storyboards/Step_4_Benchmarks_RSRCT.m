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

function varargout = Step_4_Benchmarks_RSRCT(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Step_4_Benchmarks_RSRCT_OpeningFcn, ...
                   'gui_OutputFcn',  @Step_4_Benchmarks_RSRCT_OutputFcn, ...
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


% --- Executes just before Step_4_Benchmarks_RSRCT is made visible.
function Step_4_Benchmarks_RSRCT_OpeningFcn(hObject, ~, handles, varargin)

handles.Variables = get(0, 'userdata');
handles = MakeImagesCurrent(hObject, handles);
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes EarlyAdenomaBenchmarks wait for user response (see UIRESUME)
uiwait(handles.figure1);

function varargout = Step_4_Benchmarks_RSRCT_OutputFcn(~, ~, handles) 
handles.output = 1; 
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)

set(handles.RSRCTIncRedOverall, 'string',   handles.Variables.Benchmarks.RSRCTRef.IncRedOverall)
set(handles.RSRCTMortRed, 'string',         handles.Variables.Benchmarks.RSRCTRef.MortRed)
set(handles.RSRCTIncRedLeft, 'string',      handles.Variables.Benchmarks.RSRCTRef.IncRedLeft)
set(handles.RSRCTIncRedRight, 'string',     handles.Variables.Benchmarks.RSRCTRef.IncRedRight)
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   input for RS-RCT                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RSRCTIncRedOverall_Callback(hObject, ~, handles) %#ok<DEFNU>
tmp=get(handles.RSRCTIncRedOverall, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Benchmarks.RSRCTRef.IncRedOverall=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function RSRCTIncRedLeft_Callback(hObject, ~, handles) %#ok<DEFNU>
tmp=get(handles.RSRCTIncRedLeft, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Benchmarks.RSRCTRef.IncRedLeft=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function RSRCTIncRedRight_Callback(hObject, ~, handles) %#ok<DEFNU>
tmp=get(handles.RSRCTIncRedRight, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Benchmarks.RSRCTRef.IncRedRight=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function RSRCTMortRed_Callback(hObject, ~, handles) %#ok<DEFNU> 
tmp=get(handles.RSRCTMortRed, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Benchmarks.RSRCTRef.MortRed=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Return                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Return_Callback(~, ~, handles) %#ok<DEFNU>
Answer = questdlg('Do you want to keep the settings?', 'Return?', 'Yes', 'No', 'Cancel', 'Yes');
if isequal(Answer, 'Cancel')
    return
elseif isequal(Answer, 'Yes')
    set(0, 'userdata', handles.Variables);
end

uiresume(handles.figure1);

if ishandle(handles.figure1)
    delete(handles.figure1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   create functions                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RSRCTMortRed_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RSRCTStopage_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RSRCTStartage_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RSRCTIncRedLeft_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RSRCTIncRedRight_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
function RSRCTIncRedOverall_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
