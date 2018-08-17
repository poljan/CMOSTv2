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

function varargout = Starter(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Starter_OpeningFcn, ...
                   'gui_OutputFcn',  @Starter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); %#ok<NASGU>
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% OPENING FUNCTION
function Starter_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<INUSL>
% we get the data from the calling window
handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
MakeMenuCurrent(hObject, handles)
set(handles.figure1, 'name', 'Starter', 'NumberTitle','off')
% UIWAIT makes Starter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = Starter_OutputFcn(hObject, eventdata, handles)  %#ok<INUSD,STOUT,INUSL>
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MAKE MENU CURRENT                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function MakeMenuCurrent(hObject, handles)

CurrentSummary   = handles.Variables.Starter.CurrentSummary;
[x y]            = size(CurrentSummary); %#ok<ASGLU,NASGU>
CurrentLine      = handles.Variables.Starter.CurrentLine;
if isequal(CurrentSummary, 'none')
    CurrentSummary = 'empty';
    Enable = 'off';
else
    Enable = 'on';
end
% we adjust the settings of the big menu
if CurrentLine > y
    CurrentLine = y;
elseif CurrentLine <1
    CurrentLine = 1;
end
handles.Variables.Starter.CurrentLine = CurrentLine;
set(handles.ContentListbox, 'string', CurrentSummary, 'value', CurrentLine, 'enable', Enable)
guidata(hObject, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   CONTENTLISTBOX                                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ContentListbox_CreateFcn(hObject, eventdata, handles) %#ok<INUSD>
function ContentListbox_Callback(hObject, eventdata, handles) %#ok<INUSL>
handles.Variables.Starter.CurrentLine   = get(hObject,'Value');
MakeMenuCurrent(hObject, handles)


% PLUS-PUSHBUTTON
function pushbutton_plus_Callback(hObject, eventdata, handles) %#ok<INUSL>
CurrentLine    = handles.Variables.Starter.CurrentLine;
[FileName, PathName, FilterIndex] = uigetfile('.mat', 'Please select the settings file!', handles.Variables.CurrentPath);
% we include one additional line
if isequal(FilterIndex, 1)
    if ~isequal(handles.Variables.Starter.CurrentSummary, 'none')
        handles.Variables.Starter.CurrentSummary(CurrentLine+2:end+1) = handles.Variables.Starter.CurrentSummary(CurrentLine+1:end);
        handles.Variables.Starter.CurrentPath(CurrentLine+2:end+1)    = handles.Variables.Starter.CurrentPath(CurrentLine+1:end);
        handles.Variables.Starter.CurrentSummary{CurrentLine+1} = FileName;
        handles.Variables.Starter.CurrentPath{CurrentLine+1}    = PathName;
        handles.Variables.Starter.CurrentLine = CurrentLine + 1;
    else
        
        % handles.Variables.Starter.CurrentSummary = cell(1, length(handles.Variables.Starter.CurrentSummary));
        handles.Variables.Starter.CurrentSummary = [];
        handles.Variables.Starter.CurrentPath = [];
        handles.Variables.Starter.CurrentSummary{1} = FileName;
        % handles.Variables.Starter.CurrentPath = cell(1, length(PathName));
        handles.Variables.Starter.CurrentPath{1} = PathName;
    end
    handles.Variables.CurrentPath = PathName;
end
guidata(hObject, handles)
MakeMenuCurrent(hObject, handles);

% ADD FOLDER
function add_folder_Callback(hObject, eventdata, handles) %#ok<*DEFNU,INUSL>
[PathName] = uigetdir(handles.Variables.CurrentPath, 'Please select folder!');
if isequal(PathName, 0) 
    return
end
tmp = dir(PathName);
Counter = 1;
for f=1:length(tmp)
    if ~isempty(strfind(tmp(f).name, '.mat'))
       SelectionFiles{Counter} = tmp(f).name; %#ok<AGROW>
       Counter = Counter + 1;
    end
end
[Selection, ok] = listdlg('PromptString','Select files:',...
                'SelectionMode','multiple', 'ListString', SelectionFiles);
if ~isequal(ok, 1)
    return
end
CurrentLine    = handles.Variables.Starter.CurrentLine;
CurrentSummary = handles.Variables.Starter.CurrentSummary;
CurrentPath    = handles.Variables.Starter.CurrentPath;

for f=1:length(Selection)
    if Selection(f)
        if ~isequal(CurrentSummary, 'none')
            CurrentSummary(CurrentLine+2:end+1) = CurrentSummary(CurrentLine+1:end);
            CurrentPath(CurrentLine+2:end+1)    = CurrentPath(CurrentLine+1:end);
            CurrentSummary{CurrentLine+1}       = SelectionFiles{f};
            CurrentPath{CurrentLine+1}          = PathName;
            CurrentLine                         = CurrentLine + 1;
        else
            CurrentSummary   = [];
            CurrentPath      = [];
            CurrentSummary{1} = SelectionFiles{f}; %#ok<AGROW>
            CurrentPath{1} = PathName; %#ok<AGROW>
        end
    end
end
handles.Variables.Starter.CurrentLine    = CurrentLine;
handles.Variables.Starter.CurrentSummary = CurrentSummary;
handles.Variables.Starter.CurrentPath    = CurrentPath;
guidata(hObject, handles)
MakeMenuCurrent(hObject, handles);

% MINUS-PUSHBUTTON
function pushbutton_minus_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
Answer = questdlg('Are you sure you want to delete this item?', 'Delete items', 'Yes', 'No', 'Yes');
if isequal(Answer, 'No')
    return
end
CurrentLine    = handles.Variables.Starter.CurrentLine;
[x y] = size(handles.Variables.Starter.CurrentSummary);
if isequal(y, 1)
    handles.Variables.Starter.CurrentSummary = 'none';
else
    handles.Variables.Starter.CurrentSummary{CurrentLine} = [];
   % for f=1:x
    handles.Variables.Starter.CurrentSummary(CurrentLine) = [];
    handles.Variables.Starter.CurrentPath(CurrentLine) = [];
   %  end
   % handles.Variables.Starter.CurrentSummary(all(cellfun(@isempty,handles.Variables.Starter.CurrentSummary),2), : ) = [];
   % handles.Variables.Starter.CurrentPath(all(cellfun(@isempty,handles.Variables.Starter.CurrentPath),2), : ) = [];
    if isequal(y, CurrentLine)
        handles.handles.Variables.Starter.CurrentLine = CurrentLine -1;
    end
end
guidata(hObject, handles)
MakeMenuCurrent(hObject, handles);

% PUSHBUTTON-UP
function pushbutton_up_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
CurrentLine    = handles.Variables.Starter.CurrentLine;
CurrentSummary = handles.Variables.Starter.CurrentSummary;
CurrentPath    = handles.Variables.Starter.CurrentPath;
if ~isequal(CurrentLine, 1)
    temp = CurrentSummary(CurrentLine-1);
    CurrentSummary(CurrentLine-1) = CurrentSummary(CurrentLine);
    CurrentSummary(CurrentLine)   = temp;

    temp = CurrentPath(CurrentLine-1);
    CurrentPath(CurrentLine-1) = CurrentPath(CurrentLine);
    CurrentPath(CurrentLine)   = temp;
end
handles.Variables.Starter.CurrentSummary = CurrentSummary;
handles.Variables.Starter.CurrentPath    = CurrentPath;
handles.Variables.Starter.CurrentLine    = CurrentLine-1;
guidata(hObject, handles)
MakeMenuCurrent(hObject, handles);

% PUSHBUTTON-DOWN
function pushbutton_down_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
CurrentLine    = handles.Variables.Starter.CurrentLine;
CurrentSummary = handles.Variables.Starter.CurrentSummary;
CurrentPath    = handles.Variables.Starter.CurrentPath;
[x y] = size(CurrentSummary);
if ~isequal(CurrentLine, y)
    temp = CurrentSummary(CurrentLine+1);
    CurrentSummary(CurrentLine+1) = CurrentSummary(CurrentLine);
    CurrentSummary(CurrentLine)   = temp;
    
    temp = CurrentPath(CurrentLine+1);
    CurrentPath(CurrentLine+1) = CurrentPath(CurrentLine);
    CurrentPath(CurrentLine)   = temp;    
    
    handles.Variables.Starter.CurrentSummary = CurrentSummary;
    handles.Variables.Starter.CurrentPath    = CurrentPath;
    handles.Variables.Starter.CurrentLine = CurrentLine+1;
    guidata(hObject, handles)
    MakeMenuCurrent(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Return                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Return_Callback(hObject, eventdata, handles) %#ok<INUSL>
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Close Request                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function figure1_CloseRequestFcn(hObject, eventdata, handles) %#ok<DEFNU>
Return_Callback(hObject, eventdata, handles);
if ishandle(hObject)
    delete(hObject);
end

