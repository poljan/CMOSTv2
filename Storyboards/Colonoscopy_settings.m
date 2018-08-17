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

function varargout = Colonoscopy_settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Colonoscopy_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Colonoscopy_settings_OutputFcn, ...
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


% --- Executes just before Colonoscopy_settings is made visible.
function Colonoscopy_settings_OpeningFcn(hObject, eventdata, handles, varargin) 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Handles Variables            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Colonoscopy', 'NumberTitle','off')

% handles.Variables.RectoSigmo_Detection = handles.Variables.Colo_Detection;

% these variabels are internal references for the elemts in the GUI
handles.ColonoscopyRateHandles ={'rate_1'; 'rate_6'; 'rate_11'; 'rate_16';...
    'rate_21'; 'rate_26'; 'rate_31'; 'rate_36'; 'rate_41';...
    'rate_46'; 'rate_51'; 'rate_56'; 'rate_61';...
    'rate_66'; 'rate_71'; 'rate_76'; 'rate_81';...
    'rate_86'; 'rate_91'; 'rate_96'};

handles.ColoDetectionHandles ={'colo_detection_P1'; 'colo_detection_P2'; 'colo_detection_P3'; 'colo_detection_P4';...
    'colo_detection_P5'; 'colo_detection_cis'; 'colo_detection_I'; 'colo_detection_II'; 'colo_detection_III';...
    'colo_detection_IV'};  
handles.RectosigmoDetectionHandles ={'rectosigmo_detection_P1'; 'rectosigmo_detection_P2'; 'rectosigmo_detection_P3'; 'rectosigmo_detection_P4';...
    'rectosigmo_detection_P5'; 'rectosigmo_detection_P6'; 'rectosigmo_detection_Ca1'; 'rectosigmo_detection_Ca2'; 'rectosigmo_detection_Ca3';...
    'rectosigmo_detection_Ca4'};  

handles.output = hObject;
handles = MakeImagesCurrent(hObject, handles); 
guidata(hObject, handles);

function varargout = Colonoscopy_settings_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)
% adjust graphs for colonoscopy rate
for f=1:length(handles.ColonoscopyRateHandles)
    set(handles.(handles.ColonoscopyRateHandles{f}), 'string', num2str(handles.Variables.ColonoscopyRate(f)), 'enable', 'off');
end
%%%% COLONOSCOPY LIKELYHOOD
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.ColonoscopyLikelyhood(counter) = (handles.Variables.ColonoscopyRate(x1) * (5-x2) + ...
            handles.Variables.ColonoscopyRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.ColonoscopyLikelyhood(counter : 150) = handles.Variables.ColonoscopyLikelyhood(end);
% adjusting the graph
axes(handles.axes1); cla(handles.axes1) %#ok<*MAXES>
plot(1:100, handles.Variables.ColonoscopyLikelyhood(1:100)), hold on
for f=1:20, plot((f-1)*5+1, handles.Variables.ColonoscopyRate(f),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end, hold off, axis off
%xlabel('age'), ylabel('new per year'), hold off

for f=1:length(handles.ColoDetectionHandles)
    set(handles.(handles.ColoDetectionHandles{f}), 'string', num2str(handles.Variables.Colo_Detection(f)));
end
for f=1:length(handles.RectosigmoDetectionHandles)
    set(handles.(handles.RectosigmoDetectionHandles{f}), 'string', num2str(handles.Variables.RectoSigmo_Detection(f)));
end

% we adjust the numbers in the other windows
set(handles.risc_perforation, 'string', num2str(handles.Variables.Colonoscopy_RiscPerforation))
set(handles.risc_serosa_burn, 'string', num2str(handles.Variables.Colonoscopy_RiscSerosaBurn))
set(handles.risc_bleeding,  'string', num2str(handles.Variables.Colonoscopy_RiscBleeding))
set(handles.risc_severe_bleeding, 'string', num2str(handles.Variables.Colonoscopy_RiscBleedingTransfusion))
set(handles.death_perforation, 'string', num2str(handles.Variables.DeathPerforation))
set(handles.death_severe_bleeding, 'string', num2str(handles.Variables.DeathBleedingTransfusion))
set(handles.risc_perforation_rectosigmo, 'string', num2str(handles.Variables.Rectosigmo_Perforation))
guidata(hObject, handles);

function rate_1_Callback(hObject, eventdata, handles) 
c=1; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_6_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_11_Callback(hObject, eventdata, handles) 
c=3; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_16_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_21_Callback(hObject, eventdata, handles) 
c=5; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_26_Callback(hObject, eventdata, handles) 
c=6; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_31_Callback(hObject, eventdata, handles) 
c=7; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_36_Callback(hObject, eventdata, handles) 
c=8; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_41_Callback(hObject, eventdata, handles) 
c=9; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_46_Callback(hObject, eventdata, handles) 
c=10; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_51_Callback(hObject, eventdata, handles) 
c=11; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_56_Callback(hObject, eventdata, handles) 
c=12; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_61_Callback(hObject, eventdata, handles) 
c=13; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_66_Callback(hObject, eventdata, handles) 
c=14; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_71_Callback(hObject, eventdata, handles) 
c=15; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_76_Callback(hObject, eventdata, handles) 
c=16; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_81_Callback(hObject, eventdata, handles) 
c=17; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_86_Callback(hObject, eventdata, handles) 
c=18; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_91_Callback(hObject, eventdata, handles) 
c=19; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rate_96_Callback(hObject, eventdata, handles) 
c=20; tmp=get(handles.(handles.ColonoscopyRateHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.ColonoscopyRate(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function risc_perforation_Callback(hObject, eventdata, handles) 
tmp=get(handles.risc_perforation, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Colonoscopy_Risc_Normal=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risc_serosa_burn_Callback(hObject, eventdata, handles) 
tmp=get(handles.risc_serosa_burn, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Colonoscopy_Death_Normal=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risc_bleeding_Callback(hObject, eventdata, handles) 
tmp=get(handles.risc_bleeding, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Colonoscopy_Risc_Polyp=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risc_severe_bleeding_Callback(hObject, eventdata, handles) 
tmp=get(handles.risc_severe_bleeding, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Colonoscopy_Death_Polyp=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function death_perforation_Callback(hObject, eventdata, handles) %#ok<*INUSL>
tmp=get(handles.death_perforation, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DeathPerforation=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function death_severe_bleeding_Callback(hObject, eventdata, handles)
tmp=get(handles.death_severe_bleeding, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.DeathBleedingTransfusion=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risc_perforation_rectosigmo_Callback(hObject, eventdata, handles)
tmp=get(handles.risc_perforation_rectosigmo, 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Rectosigmo_Perforation=num; end, end %#ok<ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function rate_1_CreateFcn(hObject, eventdata, handles), function rate_6_CreateFcn(hObject, eventdata, handles), function rate_11_CreateFcn(hObject, eventdata, handles), function rate_16_CreateFcn(hObject, eventdata, handles)  %#ok<*DEFNU,*INUSD>
function rate_21_CreateFcn(hObject, eventdata, handles), function rate_26_CreateFcn(hObject, eventdata, handles), function rate_31_CreateFcn(hObject, eventdata, handles), function rate_36_CreateFcn(hObject, eventdata, handles) 
function rate_41_CreateFcn(hObject, eventdata, handles), function rate_46_CreateFcn(hObject, eventdata, handles),function rate_51_CreateFcn(hObject, eventdata, handles), function rate_56_CreateFcn(hObject, eventdata, handles) 
function rate_61_CreateFcn(hObject, eventdata, handles), function rate_66_CreateFcn(hObject, eventdata, handles), function rate_71_CreateFcn(hObject, eventdata, handles), function rate_76_CreateFcn(hObject, eventdata, handles) 
function rate_81_CreateFcn(hObject, eventdata, handles), function rate_86_CreateFcn(hObject, eventdata, handles), function rate_91_CreateFcn(hObject, eventdata, handles), function rate_96_CreateFcn(hObject, eventdata, handles) 
function risc_perforation_CreateFcn(hObject, eventdata, handles), function risc_serosa_burn_CreateFcn(hObject, eventdata, handles) 
function risc_bleeding_CreateFcn(hObject, eventdata, handles), function risc_severe_bleeding_CreateFcn(hObject, eventdata, handles) 
function colo_detection_P1_CreateFcn(hObject, eventdata, handles), function colo_detection_P2_CreateFcn(hObject, eventdata, handles)
function colo_detection_P3_CreateFcn(hObject, eventdata, handles), function colo_detection_P4_CreateFcn(hObject, eventdata, handles)
function colo_detection_P5_CreateFcn(hObject, eventdata, handles), function colo_detection_cis_CreateFcn(hObject, eventdata, handles)
function colo_detection_I_CreateFcn(hObject, eventdata, handles), function colo_detection_II_CreateFcn(hObject, eventdata, handles)
function colo_detection_III_CreateFcn(hObject, eventdata, handles), function colo_detection_IV_CreateFcn(hObject, eventdata, handles)
function death_perforation_CreateFcn(hObject, eventdata, handles), function death_severe_bleeding_CreateFcn(hObject, eventdata, handles)
function risc_perforation_rectosigmo_CreateFcn(hObject, eventdata, handles)
function rectosigmo_detection_P1_CreateFcn(hObject, eventdata, handles), function rectosigmo_detection_P2_CreateFcn(hObject, eventdata, handles)
function rectosigmo_detection_P3_CreateFcn(hObject, eventdata, handles), function rectosigmo_detection_P4_CreateFcn(hObject, eventdata, handles)
function rectosigmo_detection_P5_CreateFcn(hObject, eventdata, handles), function rectosigmo_detection_P6_CreateFcn(hObject, eventdata, handles)
function rectosigmo_detection_Ca1_CreateFcn(hObject, eventdata, handles), function rectosigmo_detection_Ca2_CreateFcn(hObject, eventdata, handles)
function rectosigmo_detection_Ca3_CreateFcn(hObject, eventdata, handles), function rectosigmo_detection_Ca4_CreateFcn(hObject, eventdata, handles) 
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Done                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

function colo_detection_P1_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_P2_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_P3_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_P4_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_P5_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_cis_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_I_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_II_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_III_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function colo_detection_IV_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.ColoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.Colo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function rectosigmo_detection_P1_Callback(hObject, eventdata, handles)
    c=1; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_P2_Callback(hObject, eventdata, handles)
    c=2; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_P3_Callback(hObject, eventdata, handles)
    c=3; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function rectosigmo_detection_P4_Callback(hObject, eventdata, handles)
    c=4; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function rectosigmo_detection_P5_Callback(hObject, eventdata, handles)
    c=5; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_P6_Callback(hObject, eventdata, handles)
    c=6; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_Ca1_Callback(hObject, eventdata, handles)
    c=7; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_Ca2_Callback(hObject, eventdata, handles)
    c=8; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_Ca3_Callback(hObject, eventdata, handles)
    c=9; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function rectosigmo_detection_Ca4_Callback(hObject, eventdata, handles)
    c=10; tmp=get(handles.(handles.RectosigmoDetectionHandles{c}), 'string'); [num, succ] =str2num(tmp); %#ok<ST2NM>
if succ, if num >=0, handles.Variables.RectoSigmo_Detection(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
    


