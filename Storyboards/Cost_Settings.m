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

function varargout = Cost_Settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Cost_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Cost_Settings_OutputFcn, ...
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

function Cost_Settings_OpeningFcn(hObject, eventdata, handles, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Handles Variables            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Costs', 'NumberTitle','off')

% these variabels are internal references for the elemts in the GUI
handles.Fieldhandles = {'Colonoscopy', 'Colonoscopy_Polyp', 'Rectosigmoidoscopy', 'Rectosigmoidoscopy_Polyp'...
    'Perforation', 'serosa_burn', 'bleeding', 'severe_bleeding_transfusion',...
    'Cancer_I_initial', 'Cancer_II_initial', 'Cancer_III_initial', 'Cancer_IV_initial',...
    'cancer_I_cont', 'Cancer_II_cont', 'Cancer_III_cont', 'Cancer_IV_cont',...
    'Cancer_I_terminal', 'Cancer_II_terminal', 'Cancer_III_terminal', 'Cancer_VI_terminal',...
    'Cancer_I_terminal_oc', 'Cancer_II_terminal_oc', 'Cancer_III_terminal_oc', 'Cancer_IV_terminal_oc',...
    'FOBT', 'I_FOBT', 'Sept9_HighSens', 'Sept9_HighSpec', 'other'};

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles); 
guidata(hObject, handles);

function varargout = Cost_Settings_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
if isequal(handles.Variables.Cost.NearFuture, 'off')

    handles.VariableHandles = {'Colonoscopy', 'Colonoscopy_Polyp', 'Sigmoidoscopy', 'Sigmoidoscopy_Polyp',... 
    'Colonoscopy_Perforation', 'Colonoscopy_Serosal_burn', 'Colonoscopy_bleed', 'Colonoscopy_bleed_transfusion',...
    'Initial_I', 'Initial_II', 'Initial_III', 'Initial_IV',... 
   'Cont_I', 'Cont_II', 'Cont_III', 'Cont_IV',... 
    'Final_I', 'Final_II', 'Final_III', 'Final_IV',...
    'Final_oc_I', 'Final_oc_II', 'Final_oc_III', 'Final_oc_IV',...
    'FOBT', 'I_FOBT', 'Sept9_HighSens', 'Sept9_HighSpec', 'other'};
else
    handles.VariableHandles = {'Colonoscopy', 'Colonoscopy_Polyp', 'Sigmoidoscopy', 'Sigmoidoscopy_Polyp',... 
    'Colonoscopy_Perforation', 'Colonoscopy_Serosal_burn', 'Colonoscopy_bleed', 'Colonoscopy_bleed_transfusion',...
    'FutInitial_I', 'FutInitial_II', 'FutInitial_III', 'FutInitial_IV',... 
    'FutCont_I', 'FutCont_II', 'FutCont_III', 'FutCont_IV',... 
    'FutFinal_I', 'FutFinal_II', 'FutFinal_III', 'FutFinal_IV',...
    'FutFinal_oc_I', 'FutFinal_oc_II', 'FutFinal_oc_III', 'FutFinal_oc_IV',...
    'FOBT', 'I_FOBT', 'Sept9_HighSens', 'Sept9_HighSpec', 'other'};
end
% adjust graphs for new polyps
for f=1:length(handles.Fieldhandles)
    set(handles.(handles.Fieldhandles{f}), 'string', num2str(handles.Variables.Cost.(handles.VariableHandles{f})));
end
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Done                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function done_Callback(hObject, eventdata, handles) %#ok<*INUSD>
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


function Colonoscopy_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Colonoscopy_Polyp_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Rectosigmoidoscopy_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Rectosigmoidoscopy_Polyp_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Perforation_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function serosa_burn_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function bleeding_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function severe_bleeding_transfusion_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_I_initial_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_II_initial_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_III_initial_Callback(hObject, eventdata, handles)
    c=11; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_IV_initial_Callback(hObject, eventdata, handles)
    c=12; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function cancer_I_cont_Callback(hObject, eventdata, handles)
    c=13; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_II_cont_Callback(hObject, eventdata, handles) 
    c=14; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_III_cont_Callback(hObject, eventdata, handles)
    c=15; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_IV_cont_Callback(hObject, eventdata, handles)
    c=16; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_I_terminal_Callback(hObject, eventdata, handles)
    c=17; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_II_terminal_Callback(hObject, eventdata, handles)
    c=18; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_III_terminal_Callback(hObject, eventdata, handles) 
    c=19; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_VI_terminal_Callback(hObject, eventdata, handles)  
    c=20; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_I_terminal_oc_Callback(hObject, eventdata, handles)
    c=21; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_II_terminal_oc_Callback(hObject, eventdata, handles)
    c=22; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_III_terminal_oc_Callback(hObject, eventdata, handles)
    c=23; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Cancer_IV_terminal_oc_Callback(hObject, eventdata, handles)
    c=24; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function FOBT_Callback(hObject, eventdata, handles)
    c=25; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function I_FOBT_Callback(hObject, eventdata, handles)
    c=26; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);    
function Sept9_HighSens_Callback(hObject, eventdata, handles)
    c=27; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function Sept9_HighSpec_Callback(hObject, eventdata, handles)
    c=28; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);
function other_Callback(hObject, eventdata, handles)
    c=29; tmp=get(handles.(handles.Fieldhandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Cost.(handles.VariableHandles{c})=num; end, end, MakeImagesCurrent(hObject, handles);

function near_future_Callback(hObject, eventdata, handles)
tmp=get(handles.near_future, 'Value');
if isequal(tmp, 1), handles.Variables.Cost.NearFuture = 'on';
else
     handles.Variables.Cost.NearFuture = 'off';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU> 

function Colonoscopy_CreateFcn(hObject, eventdata, handles), function Colonoscopy_Polyp_CreateFcn(hObject, eventdata, handles), function Rectosigmoidoscopy_CreateFcn(hObject, eventdata, handles), function Rectosigmoidoscopy_Polyp_CreateFcn(hObject, eventdata, handles)
function Perforation_CreateFcn(hObject, eventdata, handles), function serosa_burn_CreateFcn(hObject, eventdata, handles), function bleeding_CreateFcn(hObject, eventdata, handles), function severe_bleeding_transfusion_CreateFcn(hObject, eventdata, handles) %#ok<*DEFNU>
function Cancer_I_initial_CreateFcn(hObject, eventdata, handles), function Cancer_II_initial_CreateFcn(hObject, eventdata, handles), function Cancer_III_initial_CreateFcn(hObject, eventdata, handles), function Cancer_IV_initial_CreateFcn(hObject, eventdata, handles)
function cancer_I_cont_CreateFcn(hObject, eventdata, handles), function Cancer_II_cont_CreateFcn(hObject, eventdata, handles), function Cancer_III_cont_CreateFcn(hObject, eventdata, handles), function Cancer_IV_cont_CreateFcn(hObject, eventdata, handles)
function Cancer_I_terminal_CreateFcn(hObject, eventdata, handles), function Cancer_II_terminal_CreateFcn(hObject, eventdata, handles), function Cancer_III_terminal_CreateFcn(hObject, eventdata, handles), function Cancer_VI_terminal_CreateFcn(hObject, eventdata, handles)
function Cancer_I_terminal_oc_CreateFcn(hObject, eventdata, handles), function Cancer_II_terminal_oc_CreateFcn(hObject, eventdata, handles), function Cancer_III_terminal_oc_CreateFcn(hObject, eventdata, handles), function Cancer_IV_terminal_oc_CreateFcn(hObject, eventdata, handles)
function FOBT_CreateFcn(hObject, eventdata, handles),function I_FOBT_CreateFcn(hObject, eventdata, handles),function Sept9_High_Sens_CreateFcn(hObject, eventdata, handles),function Sept9_HighSpec_CreateFcn(hObject, eventdata, handles), function other_CreateFcn(hObject, eventdata, handles)
function Sept9_HighSens_CreateFcn(hObject, eventdata, handles)
