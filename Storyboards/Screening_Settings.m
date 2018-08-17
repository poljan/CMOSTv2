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

function varargout = Screening_Settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Screening_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Screening_Settings_OutputFcn, ...
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



function Screening_Settings_OpeningFcn(hObject, eventdata, handles, varargin)

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Screening', 'NumberTitle','off')

handles.Colohandles = {'Colo_PercPop', 'Colo_adherence', 'Colo_y_start', 'Colo_y_end',...
     'Colo_interval', 'Colo_y_after_colo', 'Colo_specificity'};  
handles.RectoSigmohandles = {'RectoSigmo_PercPop', 'RectoSigmo_adherence',...
     'RectoSigmo_follow_up', 'RectoSigmo_y_start', 'RectoSigmo_y_end',...
     'RectoSigmo_interval', 'RectoSigmo_y_after_colo', 'RectoSigmo_specificity'};    
handles.FOBThandles = {'FOBT_PercPop', 'FOBT_adherence',...
     'FOBT_follow_up', 'FOBT_y_start', 'FOBT_y_end',...
     'FOBT_interval', 'FOBT_y_after_colo', 'FOBT_specificity'};
handles.FOBT_Sens_handles = {'FOBT_Sens_P1', 'FOBT_Sens_P2', 'FOBT_Sens_P3', 'FOBT_Sens_P4',...
    'FOBT_Sens_P5', 'FOBT_Sens_P6', 'FOBT_Sens_Ca1', 'FOBT_Sens_Ca2', 'FOBT_Sens_Ca3', 'FOBT_Sens_Ca4'};  
handles.I_FOBThandles = {'I_FOBT_PercPop', 'I_FOBT_adherence',...
     'I_FOBT_follow_up', 'I_FOBT_y_start', 'I_FOBT_y_end',...
     'I_FOBT_interval', 'I_FOBT_y_after_colo', 'I_FOBT_specificity'};  
handles.I_FOBT_Sens_handles = {'I_FOBT_Sens_P1', 'I_FOBT_Sens_P2', 'I_FOBT_Sens_P3', 'I_FOBT_Sens_P4',...
    'I_FOBT_Sens_P5', 'I_FOBT_Sens_P6', 'I_FOBT_Sens_Ca1', 'I_FOBT_Sens_Ca2', 'I_FOBT_Sens_Ca3', 'I_FOBT_Sens_Ca4'}; 
handles.Sept9_HiSenshandles = {'Sept9_HiSens_PercPop', 'Sept9_HiSens_adherence',...
     'Sept9_HiSens_follow_up', 'Sept9_HiSens_y_start', 'Sept9_HiSens_y_end',...
     'Sept9_HiSens_interval', 'Sept9_HiSens_y_after_colo', 'Sept9_HiSens_specificity'};
handles.Sept9_HiSens_Sens_handles = {'Sept9_HiSens_Sens_P1', 'Sept9_HiSens_Sens_P2', 'Sept9_HiSens_Sens_P3', 'Sept9_HiSens_Sens_P4',...
    'Sept9_HiSens_Sens_P5', 'Sept9_HiSens_Sens_P6', 'Sept9_HiSens_Sens_Ca1', 'Sept9_HiSens_Sens_Ca2', 'Sept9_HiSens_Sens_Ca3', 'Sept9_HiSens_Sens_Ca4'}; 
handles.Sept9_HiSpechandles = {'Sept9_HiSpec_PercPop', 'Sept9_HiSpec_adherence',...
     'Sept9_HiSpec_follow_up', 'Sept9_HiSpec_y_start', 'Sept9_HiSpec_y_end',...
     'Sept9_HiSpec_interval', 'Sept9_HiSpec_y_after_colo', 'Sept9_HiSpec_specificity'};   
handles.Sept9_HiSpec_Sens_handles = {'Sept9_HiSpec_Sens_P1', 'Sept9_HiSpec_Sens_P2', 'Sept9_HiSpec_Sens_P3', 'Sept9_HiSpec_Sens_P4',...
    'Sept9_HiSpec_Sens_P5', 'Sept9_HiSpec_Sens_P6', 'Sept9_HiSpec_Sens_Ca1', 'Sept9_HiSpec_Sens_Ca2', 'Sept9_HiSpec_Sens_Ca3', 'Sept9_HiSpec_Sens_Ca4'};   
handles.otherhandles = {'other_PercPop', 'other_adherence',...
     'other_follow_up', 'other_y_start', 'other_y_end',...
     'other_interval', 'other_y_after_colo', 'other_specificity'};  
handles.other_Sens_handles = {'other_Sens_P1', 'other_Sens_P2', 'other_Sens_P3', 'other_Sens_P4',...
    'other_Sens_P5', 'other_Sens_P6', 'other_Sens_Ca1', 'other_Sens_Ca2', 'other_Sens_Ca3', 'other_Sens_Ca4'}; 

handles.output = hObject;
handles = MakeImagesCurrent(hObject,handles);
guidata(hObject, handles);

function varargout = Screening_Settings_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% This function is called whenever a change is made within the GUI. This 
% function makes this changes visible

 for f=1:length(handles.Colohandles)
    set(handles.(handles.Colohandles{f}), 'string', num2str(handles.Variables.Screening.Colonoscopy(f))); end
 for f=1:length(handles.RectoSigmohandles)
    set(handles.(handles.RectoSigmohandles{f}), 'string', num2str(handles.Variables.Screening.Rectosigmoidoscopy(f))); end
 for f=1:length(handles.FOBThandles)
    set(handles.(handles.FOBThandles{f}), 'string', num2str(handles.Variables.Screening.FOBT(f))); end
 for f=1:length(handles.FOBT_Sens_handles)
    set(handles.(handles.FOBT_Sens_handles{f}), 'string', num2str(handles.Variables.Screening.FOBT_Sens(f))); end
 for f=1:length(handles.I_FOBThandles)
    set(handles.(handles.I_FOBThandles{f}), 'string', num2str(handles.Variables.Screening.I_FOBT(f))); end
 for f=1:length(handles.I_FOBT_Sens_handles)
    set(handles.(handles.I_FOBT_Sens_handles{f}), 'string', num2str(handles.Variables.Screening.I_FOBT_Sens(f))); end
 for f=1:length(handles.Sept9_HiSenshandles)
    set(handles.(handles.Sept9_HiSenshandles{f}), 'string', num2str(handles.Variables.Screening.Sept9_HiSens(f))); end
 for f=1:length(handles.Sept9_HiSens_Sens_handles)
    set(handles.(handles.Sept9_HiSens_Sens_handles{f}), 'string', num2str(handles.Variables.Screening.Sept9_HiSens_Sens(f))); end
 for f=1:length(handles.Sept9_HiSpechandles)
    set(handles.(handles.Sept9_HiSpechandles{f}), 'string', num2str(handles.Variables.Screening.Sept9_HiSpec(f))); end
 for f=1:length(handles.Sept9_HiSpec_Sens_handles)
    set(handles.(handles.Sept9_HiSpec_Sens_handles{f}), 'string', num2str(handles.Variables.Screening.Sept9_HiSpec_Sens(f))); end
 for f=1:length(handles.otherhandles)
    set(handles.(handles.otherhandles{f}), 'string', num2str(handles.Variables.Screening.other(f))); end
 for f=1:length(handles.other_Sens_handles)
    set(handles.(handles.other_Sens_handles{f}), 'string', num2str(handles.Variables.Screening.other_Sens(f))); end

Summe = handles.Variables.Screening.Colonoscopy(1) +... 
handles.Variables.Screening.Rectosigmoidoscopy(1) +...
handles.Variables.Screening.FOBT(1) +...
handles.Variables.Screening.I_FOBT(1) +...
handles.Variables.Screening.Sept9_HiSens(1) +...
handles.Variables.Screening.Sept9_HiSpec(1) +...
handles.Variables.Screening.other(1);
set(handles.Percent_no_screening, 'string', num2str(1-Summe))
guidata(hObject, handles);

% Colonoscopy    
function Colo_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp);
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_y_start_Callback(hObject, eventdata, handles)    
c=3; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function Colo_y_end_Callback(hObject, eventdata, handles)      
c=4; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>            
function Colo_interval_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function Colo_y_after_colo_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function Colo_specificity_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Colohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Colonoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% Rectosigmo   
function RectoSigmo_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function RectoSigmo_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp);  %#ok<*ST2NM>
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_y_end_Callback(hObject, eventdata, handles)  
c=5; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_interval_Callback(hObject, eventdata, handles)    
c=6; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_y_after_colo_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function RectoSigmo_specificity_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.RectoSigmohandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Rectosigmoidoscopy(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

% FOBT
function FOBT_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function FOBT_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function FOBT_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function FOBT_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>            
function FOBT_y_end_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function FOBT_interval_Callback(hObject, eventdata, handles) 
c=6; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function FOBT_y_after_colo_Callback(hObject, eventdata, handles)   
c=7; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function FOBT_specificity_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
    
% FOBT Sensitivities    
function FOBT_Sens_P1_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
c=1; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function FOBT_Sens_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_P6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_Ca1_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_Ca2_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_Ca3_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function FOBT_Sens_Ca4_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
 
% Immune-FOBT
function I_FOBT_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_y_end_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_interval_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_y_after_colo_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_specificity_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.I_FOBThandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
  
% Immune-FOBT - Sensitivities
function I_FOBT_Sens_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>       
function I_FOBT_Sens_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_P6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_Ca1_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_Ca2_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_Ca3_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function I_FOBT_Sens_Ca4_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.I_FOBT_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.I_FOBT_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      

% Septin 9 High Sensitivity    
function Sept9_HiSens_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function Sept9_HiSens_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_y_end_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_interval_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_y_after_colo_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_specificity_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Sept9_HiSenshandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     

% Septin 9 High Sensitivity  - Sensitivities
function Sept9_HiSens_Sens_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSens_Sens_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_P6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_Ca1_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_Ca2_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_Ca3_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSens_Sens_Ca4_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Sept9_HiSens_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSens_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         

% Septin 9 High Specificity
function Sept9_HiSpec_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_y_end_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_interval_Callback(hObject, eventdata, handles)    
c=6; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_y_after_colo_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_specificity_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Sept9_HiSpechandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     

% Septin 9 High Specificity - Sensitivities
function Sept9_HiSpec_Sens_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function Sept9_HiSpec_Sens_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_P6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_Ca1_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_Ca2_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_Ca3_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function Sept9_HiSpec_Sens_Ca4_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.Sept9_HiSpec_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.Sept9_HiSpec_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         

% other
function other_PercPop_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function other_adherence_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function other_follow_up_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>            
function other_y_start_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function other_y_end_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function other_interval_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function other_y_after_colo_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function other_specificity_Callback(hObject, eventdata, handles) 
c=8; tmp=get(handles.(handles.otherhandles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles);          %#ok<NASGU>
 
% other sensitivity
function other_Sens_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function other_Sens_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_P4_Callback(hObject, eventdata, handles)   
c=4; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_P6_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_Ca1_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_Ca2_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_Ca3_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     
function other_Sens_Ca4_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.other_Sens_handles{c}), 'string'); [num, succ] =str2num(tmp); 
if succ, if num >=0, handles.Variables.Screening.other_Sens(c)=num; end, end, handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>     

function other_Sens_P1_CreateFcn(hObject, eventdata, handles),function other_Sens_P2_CreateFcn(hObject, eventdata, handles),function other_Sens_P3_CreateFcn(hObject, eventdata, handles),function other_Sens_P4_CreateFcn(hObject, eventdata, handles),function other_Sens_P5_CreateFcn(hObject, eventdata, handles),function other_Sens_P6_CreateFcn(hObject, eventdata, handles),function other_Sens_Ca1_CreateFcn(hObject, eventdata, handles),function other_Sens_Ca2_CreateFcn(hObject, eventdata, handles)
function other_Sens_Ca3_CreateFcn(hObject, eventdata, handles), function other_Sens_Ca4_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_P2_CreateFcn(hObject, eventdata, handles), function Sept9_HiSpec_Sens_P3_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_P4_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_P5_CreateFcn(hObject, eventdata, handles)
function Sept9_HiSpec_Sens_P6_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_Ca1_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_Ca2_CreateFcn(hObject, eventdata, handles), function Sept9_HiSpec_Sens_Ca3_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_Ca4_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_Sens_P1_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_Sens_P2_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_Sens_P3_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_Sens_P4_CreateFcn(hObject, eventdata, handles)
function Sept9_HiSens_Sens_P5_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_Sens_P6_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_Sens_Ca1_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_Sens_Ca2_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_Sens_Ca3_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_Sens_Ca4_CreateFcn(hObject, eventdata, handles),function I_FOBT_Sens_P2_CreateFcn(hObject, eventdata, handles), function I_FOBT_Sens_P3_CreateFcn(hObject, eventdata, handles),function I_FOBT_Sens_P4_CreateFcn(hObject, eventdata, handles), function I_FOBT_Sens_P5_CreateFcn(hObject, eventdata, handles)
function I_FOBT_Sens_P6_CreateFcn(hObject, eventdata, handles), function I_FOBT_Sens_Ca1_CreateFcn(hObject, eventdata, handles),function I_FOBT_Sens_Ca2_CreateFcn(hObject, eventdata, handles), function I_FOBT_Sens_Ca3_CreateFcn(hObject, eventdata, handles),function I_FOBT_Sens_Ca4_CreateFcn(hObject, eventdata, handles), function I_FOBT_Sens_P1_CreateFcn(hObject, eventdata, handles),function other_PercPop_CreateFcn(hObject, eventdata, handles), function other_adherence_CreateFcn(hObject, eventdata, handles),function other_interval_CreateFcn(hObject, eventdata, handles), function other_y_after_colo_CreateFcn(hObject, eventdata, handles)
function other_specificity_CreateFcn(hObject, eventdata, handles), function other_follow_up_CreateFcn(hObject, eventdata, handles),function other_y_start_CreateFcn(hObject, eventdata, handles), function other_y_end_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_PercPop_CreateFcn(hObject, eventdata, handles), function Sept9_HiSpec_adherence_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_interval_CreateFcn(hObject, eventdata, handles), function Sept9_HiSpec_y_after_colo_CreateFcn(hObject, eventdata, handles)
function Sept9_HiSpec_specificity_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_follow_up_CreateFcn(hObject, eventdata, handles),function Sept9_HiSpec_y_start_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_interval_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_PercPop_CreateFcn(hObject, eventdata, handles), function Sept9_HiSpec_y_end_CreateFcn(hObject, eventdata, handles)
function Sept9_HiSens_adherence_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_y_after_colo_CreateFcn(hObject, eventdata, handles),function Sept9_HiSens_specificity_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_follow_up_CreateFcn(hObject, eventdata, handles)
function Sept9_HiSens_y_start_CreateFcn(hObject, eventdata, handles), function Sept9_HiSens_y_end_CreateFcn(hObject, eventdata, handles),function I_FOBT_PercPop_CreateFcn(hObject, eventdata, handles), function I_FOBT_adherence_CreateFcn(hObject, eventdata, handles),function I_FOBT_interval_CreateFcn(hObject, eventdata, handles), function I_FOBT_y_after_colo_CreateFcn(hObject, eventdata, handles)
function I_FOBT_specificity_CreateFcn(hObject, eventdata, handles), function I_FOBT_follow_up_CreateFcn(hObject, eventdata, handles),function I_FOBT_y_start_CreateFcn(hObject, eventdata, handles),function I_FOBT_y_end_CreateFcn(hObject, eventdata, handles),function FOBT_PercPop_CreateFcn(hObject, eventdata, handles), function FOBT_adherence_CreateFcn(hObject, eventdata, handles),function FOBT_interval_CreateFcn(hObject, eventdata, handles),function FOBT_y_after_colo_CreateFcn(hObject, eventdata, handles)
function FOBT_specificity_CreateFcn(hObject, eventdata, handles),function FOBT_follow_up_CreateFcn(hObject, eventdata, handles),function FOBT_y_start_CreateFcn(hObject, eventdata, handles),function FOBT_y_end_CreateFcn(hObject, eventdata, handles),function RectoSigmo_PercPop_CreateFcn(hObject, eventdata, handles), function RectoSigmo_adherence_CreateFcn(hObject, eventdata, handles),function RectoSigmo_interval_CreateFcn(hObject, eventdata, handles), function RectoSigmo_y_after_colo_CreateFcn(hObject, eventdata, handles)
function RectoSigmo_specificity_CreateFcn(hObject, eventdata, handles), function RectoSigmo_follow_up_CreateFcn(hObject, eventdata, handles),function y_start_CreateFcn(hObject, eventdata, handles)
function FOBT_Sens_P1_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_P2_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_P3_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_P4_CreateFcn(hObject, eventdata, handles)
function FOBT_Sens_P5_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_P6_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_Ca1_CreateFcn(hObject, eventdata, handle),function FOBT_Sens_Ca2_CreateFcn(hObject, eventdata, handles)
function FOBT_Sens_Ca3_CreateFcn(hObject, eventdata, handles),function FOBT_Sens_Ca4_CreateFcn(hObject, eventdata, handles),function Colo_y_start_CreateFcn(hObject, eventdata, handles),function Colo_PercPop_CreateFcn(hObject, eventdata, handles)
function Colo_adherence_CreateFcn(hObject, eventdata, handles),function Colo_interval_CreateFcn(hObject, eventdata, handles),function Colo_y_after_colo_CreateFcn(hObject, eventdata, handles)
function Colo_specificity_CreateFcn(hObject, eventdata, handles),function Percent_no_screening_CreateFcn(hObject, eventdata, handles)
function Percent_no_screening_Callback(hObject, eventdata, handles)

function Sept9_HiSens_Sens_P1_CreateFcn(hObject, eventdata, handles)    
function RectoSigmo_y_end_CreateFcn(hObject, eventdata, handles) 
function RectoSigmo_y_start_CreateFcn(hObject, eventdata, handles)
function Colo_y_end_CreateFcn(hObject, eventdata, handles)
        
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
