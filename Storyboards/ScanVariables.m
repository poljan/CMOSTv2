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

function varargout = ScanVariables(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScanVariables_OpeningFcn, ...
                   'gui_OutputFcn',  @ScanVariables_OutputFcn, ...
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


% --- Executes just before ScanVariables is made visible.
function ScanVariables_OpeningFcn(hObject, eventdata, handles, varargin)

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Variables Scan', 'NumberTitle','off')
handles.output = hObject;

if isfield(handles.Variables, 'ScanSettings')
    handles.Settings = handles.Variables.ScanSettings;
    handles.Settings.number_repeats = 1;
    handles.Settings.linker_repeats = '_repeat_';
else
    handles.Settings.Scan            = 'off';
    handles.Settings.NumberVariables = 1;
    handles.Settings.NumberSteps     = 10;
    handles.Settings.NumberSteps_2   = 5;
    handles.Settings.NumberSteps_3   = 5;
    
    handles.Settings.Variable{1}{1} = 'unused';
    handles.Settings.Variable{2}{1} = 'unused';
    handles.Settings.Variable{3}{1} = 'unused';
    handles.Settings.Variable{4}{1} = 'unused';
    handles.Settings.Variable{5}{1} = 'unused';
    
    handles.Settings.Variable{1}{2} = 'unused';
    handles.Settings.Variable{2}{2} = 'unused';
    handles.Settings.Variable{3}{2} = 'unused';
    handles.Settings.Variable{4}{2} = 'unused';
    handles.Settings.Variable{5}{2} = 'unused';
    
    handles.Settings.NumberSubpositions{1} = 0;
    handles.Settings.NumberSubpositions{2} = 0;
    handles.Settings.NumberSubpositions{3} = 0;
    handles.Settings.NumberSubpositions{4} = 0;
    handles.Settings.NumberSubpositions{5} = 0;
    
    handles.Settings.Subposition{1} = 0;
    handles.Settings.Subposition{2} = 0;
    handles.Settings.Subposition{3} = 0;
    handles.Settings.Subposition{4} = 0;
    handles.Settings.Subposition{5} = 0;
    
    handles.Settings.SelectionDepth{1} = 1;
    handles.Settings.SelectionDepth{2} = 1;
    handles.Settings.SelectionDepth{3} = 1;
    handles.Settings.SelectionDepth{4} = 1;
    handles.Settings.SelectionDepth{5} = 1;
    
    handles.Settings.IsVector{1} = 'no';
    handles.Settings.IsVector{2} = 'no';
    handles.Settings.IsVector{3} = 'no';
    handles.Settings.IsVector{4} = 'no';
    handles.Settings.IsVector{5} = 'no';
    
    handles.Settings.Minimum{1} = 0;
    handles.Settings.Minimum{2} = 0;
    handles.Settings.Minimum{3} = 0;
    handles.Settings.Minimum{4} = 0;
    handles.Settings.Minimum{5} = 0;
    
    handles.Settings.Maximum{1} = 0;
    handles.Settings.Maximum{2} = 0;
    handles.Settings.Maximum{3} = 0;
    handles.Settings.Maximum{4} = 0;
    handles.Settings.Maximum{5} = 0;
    
    handles.Settings.Comment{1} = 'empty';
    handles.Settings.Comment{2} = 'empty';
    handles.Settings.Comment{3} = 'empty';
    handles.Settings.Comment{4} = 'empty';
    handles.Settings.Comment{5} = 'empty';
    
    handles.Settings.Values{1} = 'empty';
    handles.Settings.Values{2} = 'empty';
    handles.Settings.Values{3} = 'empty';
    handles.Settings.Values{4} = 'empty';
    handles.Settings.Values{5} = 'empty';
    
    handles.Settings.Linker   = 'empty';
    handles.Settings.Linker_2 = 'empty';
    handles.Settings.Linker_3 = 'empty';
    
    handles.Settings.number_repeats = 1;
    handles.Settings.linker_repeats = '_repeat_';

    handles.Settings.SaveDataPath = handles.Variables.ResultsPath;
    handles.Settings.Filename     = handles.Variables.Settings_Name;
    
    handles.Settings.EconomyFlag = true;
end

handles = MakeImagesCurrent(hObject, handles);
handles.output = hObject;
guidata(hObject, handles);

function varargout = ScanVariables_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
Enable = zeros(1,5);
set(handles.Number_Variables, 'string', num2str(handles.Settings.NumberVariables))
set(handles.Number_Steps, 'string', num2str(handles.Settings.NumberSteps))
set(handles.Number_Steps_2, 'string', num2str(handles.Settings.NumberSteps_2))
set(handles.Number_Steps_3, 'string', num2str(handles.Settings.NumberSteps_3))

for f=1:5
    if isequal(handles.Settings.SelectionDepth{f}, 1)
        tmp = handles.Settings.Variable{f}{1};
    else
        tmp = [handles.Settings.Variable{f}{1} '.' handles.Settings.Variable{f}{2}];
    end
    set(handles.(['Variable_' num2str(f)]), 'string', tmp)
    set(handles.(['Subposition_' num2str(f)]), 'string', num2str(handles.Settings.Subposition{f}))
    set(handles.(['min_' num2str(f)]),      'string', num2str(handles.Settings.Minimum{f}))
    set(handles.(['max_' num2str(f)]),      'string', num2str(handles.Settings.Maximum{f}))
    set(handles.(['comment_' num2str(f)]),  'string', handles.Settings.Comment{f})
end
for f=1:5
    if ~isequal(handles.Settings.IsVector{f}, 'no')
        set(handles.(['NumberSubPos_' num2str(f)]), 'string', ['Subposition of ', num2str(handles.Settings.NumberSubpositions{f})])
        set(handles.(['Subposition_' num2str(f)]), 'enable', 'on')
    else
        set(handles.(['NumberSubPos_' num2str(f)]), 'string', 'no subpositions')
        set(handles.(['Subposition_' num2str(f)]), 'enable', 'off')
    end   
end

for f = 1:5
    if f <= handles.Settings.NumberVariables
        Enable(f) = 1;
        set(handles.(['Variable_' num2str(f)]), 'enable', 'on')
        set(handles.(['Choose_' num2str(f)]),   'enable', 'on')
        set(handles.(['min_' num2str(f)]),      'enable', 'on')
        set(handles.(['max_' num2str(f)]),      'enable', 'on')
        set(handles.(['comment_' num2str(f)]),  'enable', 'on')
        set(handles.(['adjust_' num2str(f)]),   'enable', 'on')
    else
        Enable(f) = 0;
        set(handles.(['Variable_' num2str(f)]), 'enable', 'off')
        set(handles.(['Choose_' num2str(f)]),   'enable', 'off')
        set(handles.(['min_' num2str(f)]),      'enable', 'off')
        set(handles.(['max_' num2str(f)]),      'enable', 'off')
        set(handles.(['comment_' num2str(f)]),  'enable', 'off')
        set(handles.(['adjust_' num2str(f)]),   'enable', 'off')
    end
end

if isequal(handles.Settings.Scan, '2D')
    Enable(1:2) = 1; Enable(3:5) = 0;
    set(handles.scan, 'Value', 0)
    set(handles.scan_2D, 'Value', 1)
    set(handles.scan_3D, 'Value', 0)
    set(handles.Number_Variables, 'enable', 'off', 'string', '2')
    set(handles.Number_Steps_2, 'enable', 'on')
    set(handles.Number_Steps_3, 'enable', 'off')
    
    set(handles.Variable_2, 'enable', 'on')
    set(handles.Choose_2, 'enable', 'on')
    if ~isequal(handles.Settings.IsVector{2}, 'no')
        set(handles.Subposition_2, 'enable', 'on')
    end
    for f=1:5
        if f<3, tmp = 'on'; else tmp = 'off'; end
        set(handles.(['Variable_' num2str(f)]),    'enable', tmp)
        set(handles.(['Choose_' num2str(f)]),      'enable', tmp)
        set(handles.(['Subposition_' num2str(f)]), 'enable', tmp)
        set(handles.(['min_' num2str(f)]),         'enable', tmp)
        set(handles.(['max_' num2str(f)]),         'enable', tmp)
        set(handles.(['comment_' num2str(f)]),     'enable', tmp)
        set(handles.(['adjust_' num2str(f)]),      'enable', tmp)
    end
elseif isequal(handles.Settings.Scan, '3D')
    Enable(1:4) = 1; Enable(4:5) = 0;
    set(handles.scan, 'Value', 0)
    set(handles.scan_2D, 'Value', 0)
    set(handles.scan_3D, 'Value', 1)
    set(handles.Number_Variables, 'enable', 'off', 'string', '3')
    set(handles.Number_Steps_2, 'enable', 'on')
    set(handles.Number_Steps_3, 'enable', 'on')
    
    set(handles.Variable_2, 'enable', 'on')
    set(handles.Choose_2, 'enable', 'on')
    if ~isequal(handles.Settings.IsVector{2}, 'no')
        set(handles.Subposition_2, 'enable', 'on')
    end
    set(handles.Variable_3, 'enable', 'on')
    set(handles.Choose_3, 'enable', 'on')
    if ~isequal(handles.Settings.IsVector{3}, 'no')
        set(handles.Subposition_3, 'enable', 'on')
    end
    
    for f=1:5
        if f<4, tmp = 'on'; else tmp = 'off'; end
        set(handles.(['Variable_' num2str(f)]),    'enable', tmp)
        set(handles.(['Choose_' num2str(f)]),      'enable', tmp)
        set(handles.(['Subposition_' num2str(f)]), 'enable', tmp)
        set(handles.(['min_' num2str(f)]),         'enable', tmp)
        set(handles.(['max_' num2str(f)]),         'enable', tmp)
        set(handles.(['comment_' num2str(f)]),     'enable', tmp)
        set(handles.(['adjust_' num2str(f)]),      'enable', tmp)
    end    
else
    set(handles.scan, 'Value', 1)
    set(handles.scan_2D, 'Value', 0)
    set(handles.scan_3D, 'Value', 0)
    set(handles.Number_Variables, 'enable', 'on')
    set(handles.Number_Steps_2, 'enable', 'off')
    set(handles.Number_Steps_3, 'enable', 'off')
end

for f=1:5
    if isequal(handles.Settings.Variable{f}{1}, 'unused')
        tmp = 'off';
    else
        if isequal(Enable(f), 0)
            tmp = 'off';
        else
            tmp = 'on';
        end
    end
    set(handles.(['Subposition_' num2str(f)]), 'enable', tmp)
    set(handles.(['min_' num2str(f)]),         'enable', tmp)
    set(handles.(['max_' num2str(f)]),         'enable', tmp)
    set(handles.(['comment_' num2str(f)]),     'enable', tmp)
end
for f=1:5
    if and(isequal(handles.Settings.Variable{f}{1}, 'unused'), isequal(Enable(f), 1))
        tmp = [0.8 0.1 0.1];
    else
        tmp = [1 1 1];
    end
    set(handles.(['Variable_' num2str(f)]), 'backgroundcolor', tmp)
    if and(isequal(handles.Settings.Values{f}, 'empty'), isequal(Enable(f), 1))
        tmp = [0.8 0.1 0.1];
    else
        tmp = [1 1 1];
    end
    set(handles.(['min_' num2str(f)]), 'backgroundcolor', tmp)
    set(handles.(['max_' num2str(f)]), 'backgroundcolor', tmp)
end
tmp = 'on';
for f=1:5
    if and(isequal(Enable(f), 1), isequal(handles.Settings.Values{f}, 'empty'))
        tmp = 'off';
    end
end
set(handles.create, 'enable', tmp)
handles.Settings.Enable = Enable;

set(handles.save_settings_path, 'string', handles.Settings.SaveDataPath)
set(handles.filename, 'string', handles.Settings.Filename)

if handles.Settings.EconomyFlag
    set(handles.economy, 'Value', 1)
else
    set(handles.economy, 'Value', 0)
end
set(handles.number_repeats, 'string', num2str(handles.Settings.number_repeats))
set(handles.linker_repeats, 'string', handles.Settings.linker_repeats)
if handles.Settings.number_repeats > 1
    set(handles.linker_repeats, 'enable', 'on')
else
    set(handles.linker_repeats, 'enable', 'off')
end
guidata(hObject, handles)

function economy_Callback(hObject, eventdata, handles)
tmp=get(handles.economy, 'Value');
if isequal(tmp, 1), handles.Settings.EconomyFlag = true;
else
    handles.Settings.EconomyFlag= false;
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
function scan_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
tmp=get(handles.scan, 'Value');
if isequal(tmp, 1), handles.Settings.Scan = 'on';
else
    handles.Settings.Scan= 'on';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
function scan_2D_Callback(hObject, eventdata, handles)
tmp=get(handles.scan_2D, 'Value');
if isequal(tmp, 1), handles.Settings.Scan = '2D';
else
    handles.Settings.Scan= 'on';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
function scan_3D_Callback(hObject, eventdata, handles)
tmp=get(handles.scan, 'Value');
if isequal(tmp, 1), handles.Settings.Scan = '3D';
else
    handles.Settings.Scan= 'on';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

function Number_Variables_Callback(hObject, eventdata, handles)
tmp=get(handles.Number_Variables, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find([1 2 3 4 5]==num, 1))
        handles.Settings.NumberVariables=num; 
    end
end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Number_Steps_Callback(hObject, eventdata, handles)
tmp=get(handles.Number_Steps, 'string');
[num, succ] =str2num(tmp);
if succ
    num = round(num);
    if num>0
        % we need to delete the now invalid values
        old = handles.Settings.NumberSteps;
        handles.Settings.NumberSteps=num;
        if ~isequal(old, num)
            for f=1:5
                handles.Settings.Values{f} = 'empty';
            end
        end
    end
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Number_Steps_2_Callback(hObject, eventdata, handles)
tmp=get(handles.Number_Steps_2, 'string');
[num, succ] =str2num(tmp);
if succ
    num = round(num); if tmp>0,handles.Settings.NumberSteps_2=num; end
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Number_Steps_3_Callback(hObject, eventdata, handles)
tmp=get(handles.Number_Steps_3, 'string');
[num, succ] =str2num(tmp);
if succ
    num = round(num); if tmp>0,handles.Settings.NumberSteps_3=num; end
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Variable_1_Callback(hObject, eventdata, handles)
tmp=get(handles.Variable_1, 'string');
if isequal(tmp, 'unused')
    handles.Settings.Variable{1}{1}     = tmp;
    handles.Settings.Variable{1}{2}     = tmp;
    handles.Settings.Subposition{1}    = 0;
    handles.Settings.SelectionDepth{1} = 1;
    handles.Settings.IsVector{1}       = 'no';
    handles.Settings.Minimum{1} = 0; handles.Settings.Maximum{1} = 0; 
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
    return
end
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(tmp);
if isequal(ok, 1) 
    handles.Settings.Variable{1}{1}         = String1;
    handles.Settings.Variable{1}{2}         = String2;
    handles.Settings.Subposition{1}        = Subposition;
    handles.Settings.NumberSubpositions{1} = NumberSubpositions;
    handles.Settings.SelectionDepth{1}     = SelectionDepth;
    handles.Settings.IsVector{1}           = IsVector;
    handles.Settings.Minimum{1} = 0; handles.Settings.Maximum{1} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
    
function Variable_2_Callback(hObject, eventdata, handles)
    tmp=get(handles.Variable_2, 'string');
if isequal(tmp, 'unused')
    handles.Settings.Variable{2}{1}     = tmp;
    handles.Settings.Variable{2}{2}     = tmp;
    handles.Settings.Subposition{2}    = 0;
    handles.Settings.SelectionDepth{2} = 1;
    handles.Settings.IsVector{2}       = 'no';
    handles.Settings.Minimum{2} = 0; handles.Settings.Maximum{2} = 0;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
    return
end
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(tmp);
if isequal(ok, 1) 
    handles.Settings.Variable{2}{1}         = String1;
    handles.Settings.Variable{2}{2}         = String2;
    handles.Settings.Subposition{2}        = Subposition;
    handles.Settings.NumberSubpositions{2} = NumberSubpositions;
    handles.Settings.SelectionDepth{2}     = SelectionDepth;
    handles.Settings.IsVector{2}           = IsVector;
    handles.Settings.Minimum{2} = 0; handles.Settings.Maximum{2} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Variable_3_Callback(hObject, eventdata, handles)
tmp=get(handles.Variable_3, 'string');
if isequal(tmp, 'unused')
    handles.Settings.Variable{3}{1}     = tmp;
    handles.Settings.Variable{3}{2}     = tmp;
    handles.Settings.Subposition{3}    = 0;
    handles.Settings.SelectionDepth{3} = 1;
    handles.Settings.IsVector{3}       = 'no';
    handles.Settings.Minimum{3} = 0; handles.Settings.Maximum{3} = 0;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
    return
end
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(tmp);
if isequal(ok, 1) 
    handles.Settings.Variable{3}{1}         = String1;
    handles.Settings.Variable{3}{2}         = String2;
    handles.Settings.Subposition{3}        = Subposition;
    handles.Settings.NumberSubpositions{3} = NumberSubpositions;
    handles.Settings.SelectionDepth{3}     = SelectionDepth;
    handles.Settings.IsVector{3}           = IsVector;
    handles.Settings.Minimum{3} = 0; handles.Settings.Maximum{3} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Variable_4_Callback(hObject, eventdata, handles)
tmp=get(handles.Variable_4, 'string');
if isequal(tmp, 'unused')
    handles.Settings.Variable{4}{1}     = tmp;
    handles.Settings.Variable{4}{2}     = tmp;
    handles.Settings.Subposition{4}    = 0;
    handles.Settings.SelectionDepth{4} = 1;
    handles.Settings.IsVector{4}       = 'no';
    handles.Settings.Minimum{4} = 0; handles.Settings.Maximum{4} = 0;
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
    return
end
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(tmp);
if isequal(ok, 1) 
    handles.Settings.Variable{4}{1}         = String1;
    handles.Settings.Variable{4}{2}         = String2;
    handles.Settings.Subposition{4}        = Subposition;
    handles.Settings.NumberSubpositions{4} = NumberSubpositions;
    handles.Settings.SelectionDepth{4}     = SelectionDepth;
    handles.Settings.IsVector{4}           = IsVector;
    handles.Settings.Minimum{4} = 0; handles.Settings.Maximum{4} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Variable_5_Callback(hObject, eventdata, handles)
tmp=get(handles.Variable_5, 'string');
if isequal(tmp, 'unused')
    handles.Settings.Variable{5}{1}     = tmp;
    handles.Settings.Variable{5}{2}     = tmp;
    handles.Settings.Subposition{5}    = 0;
    handles.Settings.SelectionDepth{5} = 1;
    handles.Settings.IsVector{5}       = 'no';
    handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 
    handles.Settings.Minimum{5} = 0; handles.Settings.Maximum{5} = 0;
    return
end
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(tmp);
if isequal(ok, 1) 
    handles.Settings.Variable{5}{1}         = String1;
    handles.Settings.Variable{5}{2}         = String2;
    handles.Settings.Subposition{5}        = Subposition;
    handles.Settings.NumberSubpositions{5} = NumberSubpositions;
    handles.Settings.SelectionDepth{5}     = SelectionDepth;
    handles.Settings.IsVector{5}           = IsVector;
    handles.Settings.Minimum{5} = 0; handles.Settings.Maximum{5} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Choose_1_Callback(hObject, eventdata, handles)
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(handles.Variables);
if isequal(ok, 1) 
    handles.Settings.Variable{1}{1}         = String1;
    handles.Settings.Variable{1}{2}         = String2;
    handles.Settings.Subposition{1}        = Subposition;
    handles.Settings.NumberSubpositions{1} = NumberSubpositions;
    handles.Settings.SelectionDepth{1}     = SelectionDepth;
    handles.Settings.IsVector{1}           = IsVector;
    handles.Settings.Minimum{1} = 0; handles.Settings.Maximum{1} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Choose_2_Callback(hObject, eventdata, handles)
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(handles.Variables);
if isequal(ok, 1) 
    handles.Settings.Variable{2}{1}         = String1;
    handles.Settings.Variable{2}{2}         = String2;
    handles.Settings.Subposition{2}        = Subposition;
    handles.Settings.NumberSubpositions{2} = NumberSubpositions;
    handles.Settings.SelectionDepth{2}     = SelectionDepth;
    handles.Settings.IsVector{2}           = IsVector;
    handles.Settings.Minimum{2} = 0; handles.Settings.Maximum{2} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

function Choose_3_Callback(hObject, eventdata, handles)
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(handles.Variables);
if isequal(ok, 1) 
    handles.Settings.Variable{3}{1}         = String1;
    handles.Settings.Variable{3}{2}         = String2;
    handles.Settings.Subposition{3}        = Subposition;
    handles.Settings.NumberSubpositions{3} = NumberSubpositions;
    handles.Settings.SelectionDepth{3}     = SelectionDepth;
    handles.Settings.IsVector{3}           = IsVector;
    handles.Settings.Minimum{3} = 0; handles.Settings.Maximum{3} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Choose_4_Callback(hObject, eventdata, handles)
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(handles.Variables);
if isequal(ok, 1) 
    handles.Settings.Variable{4}{1}         = String1;
    handles.Settings.Variable{4}{2}         = String2;
    handles.Settings.Subposition{4}        = Subposition;
    handles.Settings.NumberSubpositions{4} = NumberSubpositions;
    handles.Settings.SelectionDepth{4}     = SelectionDepth;
    handles.Settings.IsVector{4}           = IsVector;
    handles.Settings.Minimum{4} = 0; handles.Settings.Maximum{4} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Choose_5_Callback(hObject, eventdata, handles)
[ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(handles.Variables);
if isequal(ok, 1) 
    handles.Settings.Variable{5}{1}         = String1;
    handles.Settings.Variable{5}{2}         = String2;
    handles.Settings.Subposition{5}        = Subposition;
    handles.Settings.NumberSubpositions{5} = NumberSubpositions;
    handles.Settings.SelectionDepth{5}     = SelectionDepth;
    handles.Settings.IsVector{5}           = IsVector;
    handles.Settings.Minimum{5} = 0; handles.Settings.Maximum{5} = 0;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
   
function Subposition_1_Callback(hObject, eventdata, handles)
tmp=get(handles.Subposition_1, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find((1:handles.Settings.NumberSubpositions{1})==num, 1))
        handles.Settings.Subposition{1}=num; 
    end
end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Subposition_2_Callback(hObject, eventdata, handles)
tmp=get(handles.Subposition_2, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find((1:handles.Settings.NumberSubpositions{2})==num, 1))
        handles.Settings.Subposition{2}=num; 
    end
end 
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Subposition_3_Callback(hObject, eventdata, handles)
tmp=get(handles.Subposition_3, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find((1:handles.Settings.NumberSubpositions{3})==num, 1))
        handles.Settings.Subposition{3}=num; 
    end
end 
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function Subposition_4_Callback(hObject, eventdata, handles)
tmp=get(handles.Subposition_4, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find((1:handles.Settings.NumberSubpositions{4})==num, 1))
        handles.Settings.Subposition{4}=num; 
    end
end 
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function Subposition_5_Callback(hObject, eventdata, handles)
tmp=get(handles.Subposition_5, 'string');
[num, succ] =str2num(tmp); 
if succ
    if ~isempty(find((1:handles.Settings.NumberSubpositions{5})==num, 1))
        handles.Settings.Subposition{5}=num; 
    end
end 
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% Minimum
function min_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(['min_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Minimum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function min_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(['min_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Minimum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function min_3_Callback(hObject, eventdata, handles)    
c=3; tmp=get(handles.(['min_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Minimum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function min_4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(['min_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Minimum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function min_5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(['min_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Minimum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    

% maximum
function max_1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(['max_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Maximum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function max_2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(['max_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Maximum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function max_3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(['max_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Maximum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function max_4_Callback(hObject, eventdata, handles)    
c=4; tmp=get(handles.(['max_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Maximum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function max_5_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(['max_' num2str(c)]), 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >0
        handles.Settings.Maximum{c}=num; 
    end
end 
[OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c}  = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    


function adjust_1_Callback(hObject, eventdata, handles)
c=1; [OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c} = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function adjust_2_Callback(hObject, eventdata, handles)
c=2; [OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c} = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function adjust_3_Callback(hObject, eventdata, handles)
c=3; [OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c} = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function adjust_4_Callback(hObject, eventdata, handles)
c=4; [OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c} = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function adjust_5_Callback(hObject, eventdata, handles)
c=5; [OK, Minimum, Maximum, Values] = ChooseValues(handles.Variables, handles.Settings, c); 
if OK
    handles.Settings.Minimum{c} = Minimum;
    handles.Settings.Maximum{c} = Maximum;
    handles.Settings.Values{c} = Values;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    

function comment_1_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_1, 'string');
if isvarname(tmp), handles.Settings.Comment{1}=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function comment_2_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_2, 'string');
if isvarname(tmp), handles.Settings.Comment{2}=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function comment_3_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_3, 'string');
if isvarname(tmp), handles.Settings.Comment{3}=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function comment_4_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_4, 'string');
if isvarname(tmp), handles.Settings.Comment{4}=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function comment_5_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_5, 'string');
if isvarname(tmp), handles.Settings.Comment{5}=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    

% number repeats
function number_repeats_Callback(hObject, eventdata, handles)
tmp=get(handles.number_repeats, 'string');
[num, succ] =str2num(tmp); 
if succ, 
    if num >=1
        handles.Settings.number_repeats=round(num); 
    end
end 
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  

function linker_repeats_Callback(hObject, eventdata, handles)
tmp=get(handles.comment_1, 'string');
if isvarname(tmp), handles.Settings.linker_repeats=tmp;end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% Filename
function Browse_Callback(hObject, eventdata, handles)
path = uigetdir(handles.Settings.SaveDataPath, 'Select folder to save files'); 
if ~isequal(path, 0)
    handles.Settings.SaveDataPath = path;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function save_settings_path_Callback(hObject, eventdata, handles)
tmp=get(handles.save_settings_path, 'string');
if isdir(tmp)
    handles.Settings.SaveDataPath = tmp;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function filename_Callback(hObject, eventdata, handles)
tmp=get(handles.filename, 'string');
if isvarname(tmp)
    handles.Settings.Filename = tmp;
end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function Number_Variables_CreateFcn(hObject, eventdata, handles),function Variable_1_CreateFcn(hObject, eventdata, handles),function Variable_2_CreateFcn(hObject, eventdata, handles),function Variable_3_CreateFcn(hObject, eventdata, handles)
function Variable_4_CreateFcn(hObject, eventdata, handles),function Variable_5_CreateFcn(hObject, eventdata, handles),function Subposition_1_CreateFcn(hObject, eventdata, handles),function Subposition_2_CreateFcn(hObject, eventdata, handles)
function Subposition_3_CreateFcn(hObject, eventdata, handles),function Subposition_4_CreateFcn(hObject, eventdata, handles),function Subposition_5_CreateFcn(hObject, eventdata, handles),function Number_Steps_CreateFcn(hObject, eventdata, handles)
function Number_Steps_2_CreateFcn(hObject, eventdata, handles),function save_settings_path_CreateFcn(hObject, eventdata, handles),function comment_1_CreateFcn(hObject, eventdata, handles),function comment_2_CreateFcn(hObject, eventdata, handles)
function comment_3_CreateFcn(hObject, eventdata, handles),function comment_4_CreateFcn(hObject, eventdata, handles),function comment_5_CreateFcn(hObject, eventdata, handles),function min_1_CreateFcn(hObject, eventdata, handles)
function max_1_CreateFcn(hObject, eventdata, handles),function min_2_CreateFcn(hObject, eventdata, handles),function max_2_CreateFcn(hObject, eventdata, handles),function min_3_CreateFcn(hObject, eventdata, handles)
function max_3_CreateFcn(hObject, eventdata, handles),function min_4_CreateFcn(hObject, eventdata, handles),function max_4_CreateFcn(hObject, eventdata, handles),function max_5_CreateFcn(hObject, eventdata, handles)
function min_5_CreateFcn(hObject, eventdata, handles), function filename_CreateFcn(hObject, eventdata, handles), function Number_Steps_3_CreateFcn(hObject, eventdata, handles)    
function linker_repeats_CreateFcn(hObject, eventdata, handles), function number_repeats_CreateFcn(hObject, eventdata, handles)         
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Create                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function create_Callback(hObject, eventdata, handles)

for f=1:5
    if handles.Settings.Enable(f)
        MaxBeforeComma = 0;
        MaxAfterComma  = 0;
        clear CommaPos
        for g=1:length(handles.Settings.Values{f})
            ValueStr{f}{g} = num2str(handles.Settings.Values{f}{g});
            tmp = strfind(ValueStr{f}{g}, '.');
            if isequal(tmp, [])
                CommaPos(g) = length(ValueStr{f}{g})+1;
            else
                CommaPos(g) = tmp;
            end
            if CommaPos(g) -1 > MaxBeforeComma
                MaxBeforeComma = CommaPos(g) -1;
            end
            if length(ValueStr{f}{g}) - CommaPos(g) > MaxAfterComma
                MaxAfterComma = length(ValueStr{f}{g}) - CommaPos(g);
            end
        end
        for g=1:length(handles.Settings.Values{f})
            if MaxBeforeComma > CommaPos(g) -1
                for h=1:(MaxBeforeComma - (CommaPos(g) -1))
                    ValueStr{f}{g} = ['0' ValueStr{f}{g}];
                end
            end
            if MaxAfterComma >0
                if isequal(strfind(ValueStr{f}{g}, '.'), [])
                    ValueStr{f}{g} = [ValueStr{f}{g} '.'];
                end
                tmp = length(ValueStr{f}{g}) - strfind(ValueStr{f}{g}, '.');
                for h=1:MaxAfterComma - tmp
                    ValueStr{f}{g} = [ValueStr{f}{g} '0'];
                end
            end
        end
    end
end

h = msgbox('writing filenames');
if isequal(handles.Settings.Scan, '2D')
    for x1 = 1:handles.Settings.NumberSteps
        if handles.Settings.EconomyFlag
            EndSteps_2   = 0;
            if handles.Settings.Values{2}{1} < handles.Settings.Values{1}{x1}
                for f=1:handles.Settings.NumberSteps_2
                    EndSteps_2 = f;
                    if handles.Settings.Values{2}{f} > handles.Settings.Values{1}{x1}
                        break
                    end
                end
            end
        else
            EndSteps_2 = handles.Settings.NumberSteps_2;
        end
        
        for x2 = 1:EndSteps_2
            Variables = handles.Variables;
            Value{1} = handles.Settings.Values{1}{x1};
            Value{2} = handles.Settings.Values{2}{x2};
            for f=1:2
                if isequal(handles.Settings.SelectionDepth{f}, 1)
                    if handles.Settings.IsVector{f}
                        Variables.(handles.Settings.Variable{f}{1})(handles.Settings.Subposition{f}) = Value{f};
                    else
                        Variables.(handles.Settings.Variable{f}{1}) = Value{f};
                    end
                else
                    if handles.Settings.IsVector{f}
                        Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2})(handles.Settings.Subposition{f}) = Value{f};
                    else
                        Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2}) = Value{f};
                    end
                end
            end
            StringX  = num2str(x1); StringY  = num2str(x2);
            for f=1:(length(num2str(handles.Settings.NumberSteps)) - length(StringX))
                StringX = ['0' StringX];
            end
            for f=1:(length(num2str(handles.Settings.NumberSteps_2)) - length(StringY))
                StringY = ['0' StringY];
            end
            FileName = [strrep(handles.Settings.Filename, '.mat', '') '_'... 
                'ScX' StringX '_'...
                handles.Settings.Comment{1} '_' strrep(ValueStr{1}{x1}, '.', '_') '_'...
                'ScY' StringY '_'...
                handles.Settings.Comment{2} '_' strrep(ValueStr{2}{x2}, '.', '_') '.mat'];
            Variables.Settings_Name = FileName;
            % save(fullfile(handles.Settings.SaveDataPath, FileName), 'Variables');
            SaveFilenames(handles, FileName, Variables)
        end
    end
elseif isequal(handles.Settings.Scan, '3D')
    FolderFlag = true;
    for x1 = 1:handles.Settings.NumberSteps
        if FolderFlag
            StringX  = num2str(x1);
            for f=1:(length(num2str(handles.Settings.NumberSteps)) - length(StringX))
                StringX = ['0' StringX];
            end
            tmp = ['Job_series_number_' StringX];
            cd(handles.Settings.SaveDataPath), mkdir(tmp)
            PathName = fullfile(handles.Settings.SaveDataPath, tmp);
        else
            PathName = handles.Settings.SaveDataPath;
        end
        if handles.Settings.EconomyFlag
            EndSteps_2   = 0;
            if handles.Settings.Values{2}{1} < handles.Settings.Values{1}{x1}
                for f=1:handles.Settings.NumberSteps_2
                    EndSteps_2 = f;
                    if handles.Settings.Values{2}{f} > handles.Settings.Values{1}{x1}
                        break
                    end
                end
            end
        else
            EndSteps_2 = handles.Settings.NumberSteps_2;
        end 
        for x2 = 1:EndSteps_2
            if handles.Settings.EconomyFlag
                EndSteps_3   = 0;
                if handles.Settings.Values{3}{1} < handles.Settings.Values{2}{x2}
                    for f=1:handles.Settings.NumberSteps_3
                        EndSteps_3 = f;
                        if handles.Settings.Values{3}{f} > handles.Settings.Values{2}{x2}
                            break
                        end
                    end
                end
            else
                EndSteps_3 = handles.Settings.NumberSteps_3;
            end
            for x3 = 1:EndSteps_3
                Variables = handles.Variables;
                Value{1} = handles.Settings.Values{1}{x1};
                Value{2} = handles.Settings.Values{2}{x2};
                Value{3} = handles.Settings.Values{3}{x3};
                for f=1:3
                    if isequal(handles.Settings.SelectionDepth{f}, 1)
                        if handles.Settings.IsVector{f}
                            Variables.(handles.Settings.Variable{f}{1})(handles.Settings.Subposition{f}) = Value{f};
                        else
                            Variables.(handles.Settings.Variable{f}{1}) = Value{f};
                        end
                    else
                        if handles.Settings.IsVector{f}
                            Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2})(handles.Settings.Subposition{f}) = Value{f};
                        else
                            Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2}) = Value{f};
                        end
                    end
                end
                StringX  = num2str(x1); StringY  = num2str(x2); StringZ  = num2str(x3);
                for f=1:(length(num2str(handles.Settings.NumberSteps)) - length(StringX))
                    StringX = ['0' StringX];
                end
                for f=1:(length(num2str(handles.Settings.NumberSteps_2)) - length(StringY))
                    StringY = ['0' StringY];
                end
                for f=1:(length(num2str(handles.Settings.NumberSteps_3)) - length(StringZ))
                    StringZ = ['0' StringZ];
                end
                FileName = [strrep(handles.Settings.Filename, '.mat', ' ') '_'...
                    'ScX' StringX '_'...
                    handles.Settings.Comment{1} '_' strrep(ValueStr{1}{x1}, '.', '_') '_'...
                    'ScY' StringY '_'...
                    handles.Settings.Comment{2} '_' strrep(ValueStr{2}{x2}, '.', '_') '_'...
                    'ScZ' StringZ '_'...
                    handles.Settings.Comment{3} '_' strrep(ValueStr{3}{x3}, '.', '_') '.mat'];
                Variables.Settings_Name = FileName;
                %save(fullfile(handles.Settings.SaveDataPath, FileName), 'Variables');
                save(fullfile(PathName, FileName), 'Variables');
            end
        end
    end
else
    for x1 = 1:handles.Settings.NumberSteps
        Variables = handles.Variables;
        FileName = strrep(handles.Settings.Filename, '.mat', ' ');
        for f=1:handles.Settings.NumberVariables
            Value = handles.Settings.Values{f}{x1};
            if isequal(handles.Settings.SelectionDepth{f}, 1)
                if handles.Settings.IsVector{f}
                    Variables.(handles.Settings.Variable{f}{1})(handles.Settings.Subposition{f}) = Value;
                else
                    Variables.(handles.Settings.Variable{f}{1}) = Value;
                end
            else
                if handles.Settings.IsVector{f}
                    Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2})(handles.Settings.Subposition{f}) = Value;
                else
                    Variables.(handles.Settings.Variable{f}{1}).(handles.Settings.Variable{f}{2}) = Value;
                end
            end
            StringX  = num2str(x1);
            for f1=1:(length(num2str(handles.Settings.NumberSteps)) - length(StringX))
                StringX = ['0' StringX];
            end
            FileName = [FileName '_'...
                'ScX' StringX '_'...
                handles.Settings.Comment{f} '_' strrep(ValueStr{f}{x1}, '.', '_')];
        end
        Variables.Settings_Name = FileName;
        %save(fullfile(handles.Settings.SaveDataPath, FileName), 'Variables');
        SaveFilenames(handles, FileName, Variables)
    end
end
if ishandle(h)
    close(h)
end

% Save Filenames
function SaveFilenames(handles, FileName, Variables)
if isequal(handles.Settings.number_repeats, 1)
    save(fullfile(handles.Settings.SaveDataPath, FileName), 'Variables');
else 
    for f=1:handles.Settings.number_repeats
        if handles.Settings.number_repeats < 10
            LinkerString = [handles.Settings.linker_repeats num2str(f)];
        elseif handles.Settings.number_repeats < 100
            if f<10
                LinkerString = [handles.Settings.linker_repeats '0' num2str(f)];
            else
                LinkerString = [handles.Settings.linker_repeats num2str(f)];
            end
        elseif handles.Settings.number_repeats < 1000
            if f<10
                LinkerString = [handles.Settings.linker_repeats '00' num2str(f)];
            elseif f<10
                LinkerString = [handles.Settings.linker_repeats '0' num2str(f)];
            else
                LinkerString = [handles.Settings.linker_repeats num2str(f)];
            end
        end
        FileNameTmp = [FileName LinkerString];
        save(fullfile(handles.Settings.SaveDataPath, FileNameTmp), 'Variables');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Done                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function done_Callback(hObject, eventdata, handles) %#ok<*INUSL,*INUSD>
Answer = questdlg('Do you want to keep the settings?', 'Return?', 'Yes', 'No', 'Cancel', 'Yes');
if isequal(Answer, 'Cancel')
    return
elseif isequal(Answer, 'Yes')
    handles.Variables.ScanSettings = handles.Settings;
end
set(0, 'userdata', handles.Variables);
uiresume(handles.figure1);

if ishandle(handles.figure1)
    delete(handles.figure1);
end

function [ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = CheckVariable(Variables)
ok                 = 0;
SelectionDepth     = 1;
IsVector           = 'no';
NumberSubpositions = 0;
Subposition        = 0;
String1            = 'unused';
String2            = 'unused';

tmp = strfind(input, '.');
if length(tmp) > 1
    return
elseif length(tmp) == 1
    String1 = input(1:tmp-1);
    String2 = input(tmp+1: length(input));
    if isfield(Variables, String1)
        if isfield(Variables.(String1), String2)
            if isnumeric(Variables.(String1).(String2))
                ok = 1;
                SelectionDepth = 2;
                if ~isscalar(Variables.(String1).(String2))
                    IsVector           = 'yes';
                    NumberSubpositions = length(Variables.(String1).(String2));
                    Subposition        = 1;
                end
            end
        end
    end
else
    String1 = input;
    if isfield(Variables, String1)
        ok = 1;
        SelectionDepth = 1;
        if ~isscalar(Variables.(String1))
            IsVector           = 'yes';
            NumberSubpositions = length(Variables.(String1));
            Subposition        = 1;
        end
    end
end

function [ok, SelectionDepth, IsVector, NumberSubpositions, Subposition, String1, String2]...
    = ChooseVariable(Variables)

ok                 = 0;
SelectionDepth     = 1;
IsVector           = 'no';
NumberSubpositions = 0;
Subposition        = 1;
String1            = 'unused';
String2            = 'unused';

VariablesFields  = fields(Variables);
SelectionFields  = [];
SelectionCounter = 1;
for f=1:length(VariablesFields)
    if isnumeric(Variables.(VariablesFields{f}))
        SelectionFields{SelectionCounter} = VariablesFields{f}; 
        SelectionCounter = SelectionCounter +1;
    elseif isstruct(Variables.(VariablesFields{f}))
        SelectionFields{SelectionCounter} = VariablesFields{f}; %#ok<*AGROW>
        SelectionCounter = SelectionCounter +1;
    end
end
[Selection, valid] = listdlg('PromptString','Select a Variable:',...
                'SelectionMode','single', 'ListString',SelectionFields);
if isequal(valid, 0)
    return
end
if isnumeric(Variables.(SelectionFields{Selection}))
    String1        = SelectionFields{Selection};
    SelectionDepth = 1;
    if ~isscalar(Variables.(SelectionFields{Selection}))
        [valid, NumberSubpositions, Subposition] = ChooseSubposition(Variables, SelectionDepth, String1, String2);
        if valid
            IsVector = 'yes';
            ok = 1;
        end
    else
        ok = 1;
    end
elseif isstruct(Variables.(SelectionFields{Selection}))
    % the more complicated case where a substructure exists
    String1            = SelectionFields{Selection};
    VariablesFields_2  = fields(Variables.(String1));
    SelectionFields_2    = [];
    SelectionCounter_2   = 1;
    for f=1:length(VariablesFields_2)
        if isnumeric(Variables.(String1).(VariablesFields_2{f}))
            SelectionFields_2{SelectionCounter_2} = VariablesFields_2{f};
            SelectionCounter_2 = SelectionCounter_2 +1;
        elseif isstruct(Variables.(String1).(VariablesFields_2{f}))
            SelectionFields_2{SelectionCounter_2} = VariablesFields_2{f}; %#ok<*AGROW>
            SelectionCounter_2 = SelectionCounter_2 +1;
        end
    end
    [Selection_2, valid] = listdlg('PromptString','Select a Subvariable:',...
        'SelectionMode','single', 'ListString',SelectionFields_2);
    if isequal(valid, 0)
        return
    end
    if isnumeric(Variables.(String1).(SelectionFields_2{Selection_2}))
        String2        = SelectionFields_2{Selection_2};
        SelectionDepth = 2;
        if ~isscalar(Variables.(String1).(SelectionFields_2{Selection_2}))
            [valid, NumberSubpositions, Subposition] = ChooseSubposition(Variables, SelectionDepth, String1, String2);
            if valid
                IsVector = 'yes';
                ok = 1;
            end
        else
            ok = 1;
        end
    end
else
    return
end
display('break');

% Choose subposition
function [ok, NumberSubpositions, Subposition] = ChooseSubposition(Variables, SelectionDepth, String1, String2)

ok = 0;
if isequal(SelectionDepth, 1)
    NumberSubpositions = length(Variables.(String1));
    for f=1:NumberSubpositions
        PositionSelection{f} = ['Position ' num2str(f) ' value: ' num2str(Variables.(String1)(f))];
    end
else
    NumberSubpositions = length(Variables.(String1).(String2));
    for f=1:NumberSubpositions
        PositionSelection{f} = ['Position ' num2str(f) ' value: ' num2str(Variables.(String1).(String2)(f))];
    end
end
[Subposition, valid] = listdlg('PromptString','Select a Subposition:',...
    'SelectionMode','single', 'ListString',PositionSelection);
if isequal(valid, 0)
    return
else
    ok = 1;
end

% Choose Values
function [OK, Minimum, Maximum, Values] = ChooseValues(Variables, Settings, num) 

number = num;
OK =0;
Maximum = 0;
Minimum = 0;
Values = [];

if isequal(Settings.SelectionDepth{num}, 1)
    if Settings.IsVector{num}
        CurrentValue = Variables.(Settings.Variable{num}{1})(Settings.Subposition{num});
    else
        CurrentValue = Variables.(Settings.Variable{num}{1});
    end
else
    if Settings.IsVector{num}
        CurrentValue = Variables.(Settings.Variable{num}{1}).(Settings.Variable{num}{2})(Settings.Subposition{1});
    else
        CurrentValue = Variables.(Settings.Variable{num}{1}).(Settings.Variable{num}{2});
    end
end
prompt = {['Value: ' num2str(CurrentValue) '. Please choose minimum!'], ['Value: ' num2str(CurrentValue) '. Please choose maximum!']};    
answer = inputdlg(prompt, 'Choose Miminum and Maximum', 1, {num2str(Settings.Minimum{num}), num2str(Settings.Maximum{num})});
[num, succ] =str2num(answer{1}); 
if succ
    if num>0
        Minimum = num;
    else return
    end
else return
end
[num, succ] =str2num(answer{2});
if succ
    if num>0
        Maximum = num;
    else return
    end
else return
end

if isequal(Settings.Scan, '2D')
    if isequal(number, 1)
        NumberSteps = Settings.NumberSteps;
    else
        NumberSteps = Settings.NumberSteps_2;
    end
elseif isequal(Settings.Scan, '3D')
    if isequal(number, 1)
        NumberSteps = Settings.NumberSteps;
    elseif isequal(number, 2)
        NumberSteps = Settings.NumberSteps_2;
    else
        NumberSteps = Settings.NumberSteps_3;
    end
else
    NumberSteps = Settings.NumberSteps;
end
 
% we get the strings and default values for the input dialogue
for f=1:NumberSteps
    prompt{f}  = ['Please choose value for calculation ' num2str(f)];
    if isequal(f,1)
        default{f} = num2str(Minimum);
    else
        default{f} = num2str(Minimum + (Maximum - Minimum)/(NumberSteps-1)*(f-1));
    end
end
QuestPerBox = 10; % this says how many questions will be asked 
NumberQuestions = floor(NumberSteps/QuestPerBox);
if (mod(NumberSteps, QuestPerBox) > 0)
    NumberQuestions = NumberQuestions + 1;
end

try
clear answer
counter = 1;
for f=1:NumberQuestions
    FirstStep = (f-1)*QuestPerBox+1;
    if isequal(f, NumberQuestions)
        LastStep = NumberSteps;
    else
        LastStep  = f*QuestPerBox;
    end
    answer{f} = inputdlg(prompt(FirstStep:LastStep), 'Please choose values for the various steps!',...
        1, default(FirstStep:LastStep));
    if isequal(answer, []), return, end
    counter2=1;
    for f2=FirstStep:LastStep
        [num, succ] =str2num(answer{f}{counter2});
        if succ
            if num>0
                Values{counter} = num;
                counter  = counter + 1;
                counter2 = counter2 + 1;
            else return
            end
        else return
        end
    end
end
catch
    rethrow (lasterror)
end
OK = 1;
