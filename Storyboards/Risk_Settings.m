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

function varargout = Risk_Settings(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Risk_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @Risk_Settings_OutputFcn, ...
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


% --- Executes just before Risk_Settings is made visible.
function Risk_Settings_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.Variables    = get(0, 'userdata');
handles.OldVariables = handles.Variables;
set(handles.figure1, 'color', [0.6 0.6 1])
set(handles.figure1, 'name', 'Risk graphs', 'NumberTitle','off')
handles.output = hObject;

handles.IndividualRiskHandles = {'risk_10'; 'risk_20'; 'risk_30'; 'risk_40';...
    'risk_50'; 'risk_60'; 'risk_70'; 'risk_80'; 'risk_90';...
    'risk_95'; 'risk_97'; 'risk_100'};
handles.EarlyHandles = {'early_10'; 'early_20'; 'early_30'; 'early_40';...
    'early_50'; 'early_60'; 'early_70'; 'early_80'; 'early_90';...
    'early_95'; 'early_97'; 'early_100'};
handles.AdvHandles = {'adv_10'; 'adv_20'; 'adv_30'; 'adv_40';...
    'adv_50'; 'adv_60'; 'adv_70'; 'adv_80'; 'adv_90';...
    'adv_95'; 'adv_97'; 'adv_100'};

handles = MakeImagesCurrent(hObject, handles); 
guidata(hObject, handles);

function varargout = Risk_Settings_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Make Images Current          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = MakeImagesCurrent(hObject, handles)

FontSz = 9;

handles.Variables = AdjustRiskGraph(handles.Variables);    
Values = [10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 97, 100]*5;

% normalize
if isequal(handles.Variables.RiskNormalize, 'off'),set(handles.normalize_risk, 'Value', 0)
else set(handles.normalize_risk, 'Value', 1), end 
if isequal(handles.Variables.RiskEarlyNormalize, 'off'),set(handles.normalize_early, 'Value', 0)
else set(handles.normalize_early, 'Value', 1), end 
if isequal(handles.Variables.RiskAdvNormalize, 'off'),set(handles.normalize_adv, 'Value', 0)
else set(handles.normalize_adv, 'Value', 1), end 

% we adjust the individual risk graph
axes(handles.Individual_risk_axis), cla(gca)
bar(handles.Variables.IndividualRisk, 'facecolor', 'b'), set(gca,'xlim',[1 length(handles.Variables.IndividualRisk)]), hold on
% bar(handles.Variables.IndividualRisk, 'color', 'b'), set(gca,'xlim',[1 length(handles.Variables.IndividualRisk)]), hold on
line([0 length(handles.Variables.IndividualRisk)], [1 1], 'color', 'r')
if isequal(handles.Variables.RiskScale, 'linear')
    set(gca, 'yscale', 'linear')
else
    set(gca, 'yscale', 'log')
end
for x1=1:length(Values)
    plot(Values(x1), handles.Variables.Ind_Risk_Percentiles(x1),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'xtick', [0 50 100 150 200 250 300 350 400 450 500],...
    'xticklabel', {'0' '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'})
set(gca, 'fontsize', FontSz)
xlabel('percent of patients', 'fontsize', FontSz)
ylabel('relative risk', 'fontsize', FontSz)

% we adjust the early polyp graph
axes(handles.Early_Polyp_axis), cla(gca)
bar(handles.Variables.EarlyRisk, 'facecolor', 'b'), set(gca,'xlim',[1 length(handles.Variables.EarlyRisk)]), hold on
% bar(handles.Variables.EarlyRisk, 'color', 'b'), set(gca,'xlim',[1 length(handles.Variables.EarlyRisk)]), hold on
line([0 length(handles.Variables.EarlyRisk)], [1 1], 'color', 'r')
if isequal(handles.Variables.RiskEarlyScale, 'linear')
    set(gca, 'yscale', 'linear')
else
    set(gca, 'yscale', 'log')
end
for x1=1:length(Values)
    plot(Values(x1), handles.Variables.Early_Risk_Percentiles(x1),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'xtick', [0 50 100 150 200 250 300 350 400 450 500],...
    'xticklabel', {'0' '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'})
set(gca, 'fontsize', FontSz)
xlabel('percent of patients', 'fontsize', FontSz)
ylabel('relative risk', 'fontsize', FontSz)

% we adjust the advanced polyp graph
axes(handles.Adv_Polyp_axis), cla(gca)
bar(handles.Variables.AdvRisk, 'facecolor', 'b'), set(gca,'xlim',[1 length(handles.Variables.AdvRisk)]), hold on
% bar(handles.Variables.AdvRisk, 'color', 'b'), set(gca,'xlim',[1 length(handles.Variables.AdvRisk)]), hold on
line([0 length(handles.Variables.AdvRisk)], [1 1], 'color', 'r')
if isequal(handles.Variables.RiskAdvScale, 'linear')
    set(gca, 'yscale', 'linear')
else
    set(gca, 'yscale', 'log')
end
for x1=1:length(Values)
    plot(Values(x1), handles.Variables.Adv_Risk_Percentiles(x1),'--rs','LineWidth',1,...
        'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end
set(gca, 'xtick', [0 50 100 150 200 250 300 350 400 450 500],...
    'xticklabel', {'0' '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'})
set(gca, 'fontsize', FontSz)
xlabel('percent of patients', 'fontsize', FontSz)
ylabel('relative risk', 'fontsize', FontSz)

for x1=1:length(handles.IndividualRiskHandles)
    set(handles.(handles.IndividualRiskHandles{x1}), 'string', num2str(handles.Variables.Ind_Risk_Percentiles(x1)));
end
for x1=1:length(handles.EarlyHandles)
    set(handles.(handles.EarlyHandles{x1}), 'string', num2str(handles.Variables.Early_Risk_Percentiles(x1)));
end
for x1=1:length(handles.AdvHandles)
    set(handles.(handles.AdvHandles{x1}), 'string', num2str(handles.Variables.Adv_Risk_Percentiles(x1)));
end
if isequal(handles.Variables.RiskScale, 'linear'),set(handles.log_risk, 'Value', 0)
else set(handles.log_risk, 'Value', 1), end
if isequal(handles.Variables.RiskEarlyScale, 'linear'),set(handles.log_early, 'Value', 0)
else set(handles.log_early, 'Value', 1), end
if isequal(handles.Variables.RiskAdvScale, 'linear'),set(handles.log_adv, 'Value', 0)
else set(handles.log_adv, 'Value', 1), end
if isequal(handles.Variables.RiskCorrelation, 'on'),set(handles.correlate, 'Value', 1)
else set(handles.correlate, 'Value', 0), end
guidata(hObject, handles);

function correlate_Callback(hObject, eventdata, handles)
tmp=get(handles.correlate, 'Value');
if isequal(tmp, 1), handles.Variables.RiskCorrelation = 'on';
else
    handles.Variables.RiskScale = 'off';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function log_risk_Callback(hObject, eventdata, handles)
tmp=get(handles.log_risk, 'Value');
if isequal(tmp, 1), handles.Variables.RiskScale = 'logarithmic';
else
    handles.Variables.RiskScale = 'linear';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function log_early_Callback(hObject, eventdata, handles)
tmp=get(handles.log_early, 'Value');
if isequal(tmp, 1), handles.Variables.RiskEarlyScale = 'logarithmic';
else
    handles.Variables.RiskEarlyScale = 'linear';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function log_adv_Callback(hObject, eventdata, handles)
tmp=get(handles.log_adv, 'Value');
if isequal(tmp, 1), handles.Variables.RiskAdvScale = 'logarithmic';
else
    handles.Variables.RiskAdvScale = 'linear';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>   

function normalize_risk_Callback(hObject, eventdata, handles) %#ok<*INUSD>
tmp=get(handles.normalize_risk, 'Value');
if isequal(tmp, 1), handles.Variables.RiskNormalize = 'on';
else
    handles.Variables.RiskNormalize = 'off';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>      
function normalize_early_Callback(hObject, eventdata, handles)
tmp=get(handles.normalize_early, 'Value');
if isequal(tmp, 1), handles.Variables.RiskEarlyNormalize = 'on';
else
    handles.Variables.RiskEarlyNormalize = 'off';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>         
function normalize_adv_Callback(hObject, eventdata, handles)
tmp=get(handles.normalize_adv, 'Value');
if isequal(tmp, 1), handles.Variables.RiskAdvNormalize = 'on';
else
    handles.Variables.RiskAdvNormalize = 'off';
end    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>   

%%% Risk Percentile Callbacks
function risk_10_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
c=1; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_20_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_30_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_40_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_50_Callback(hObject, eventdata, handles)
c=5; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_60_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_70_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_80_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_90_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_95_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_97_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>
function risk_100_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.IndividualRiskHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Ind_Risk_Percentiles(c)=num; end, end
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>

function early_10_Callback(hObject, eventdata, handles)  
c=1; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>    
function early_20_Callback(hObject, eventdata, handles)    
c=2; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_30_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_40_Callback(hObject, eventdata, handles)    
c=4; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_50_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_60_Callback(hObject, eventdata, handles)    
c=6; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_70_Callback(hObject, eventdata, handles)   
c=7; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_80_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_90_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_95_Callback(hObject, eventdata, handles)
c=10; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_97_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function early_100_Callback(hObject, eventdata, handles)
c=12; tmp=get(handles.(handles.EarlyHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Early_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
    
function adv_10_Callback(hObject, eventdata, handles)
c=1; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>        
function adv_20_Callback(hObject, eventdata, handles)
c=2; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>    
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_30_Callback(hObject, eventdata, handles)
c=3; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_40_Callback(hObject, eventdata, handles)
c=4; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_50_Callback(hObject, eventdata, handles)    
c=5; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_60_Callback(hObject, eventdata, handles)
c=6; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_70_Callback(hObject, eventdata, handles)
c=7; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_80_Callback(hObject, eventdata, handles)
c=8; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_90_Callback(hObject, eventdata, handles)
c=9; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_95_Callback(hObject, eventdata, handles)    
c=10; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_97_Callback(hObject, eventdata, handles)
c=11; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>   
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
function adv_100_Callback(hObject, eventdata, handles) 
c=12; tmp=get(handles.(handles.AdvHandles{c}), 'string');
[num, succ] =str2num(tmp); if succ, if num >=0, handles.Variables.Adv_Risk_Percentiles(c)=num; end, end %#ok<*ST2NM>  
handles = MakeImagesCurrent(hObject, handles); %#ok<NASGU>  
    
function risk_95_CreateFcn(hObject, eventdata, handles), function risk_10_CreateFcn(hObject, eventdata, handles),function risk_90_CreateFcn(hObject, eventdata, handles),function risk_80_CreateFcn(hObject, eventdata, handles)
function risk_70_CreateFcn(hObject, eventdata, handles),function risk_60_CreateFcn(hObject, eventdata, handles),function risk_50_CreateFcn(hObject, eventdata, handles),function risk_40_CreateFcn(hObject, eventdata, handles)
function risk_30_CreateFcn(hObject, eventdata, handles),function risk_20_CreateFcn(hObject, eventdata, handles), function risk_100_CreateFcn(hObject, eventdata, handles),function risk_97_CreateFcn(hObject, eventdata, handles)
function early_95_CreateFcn(hObject, eventdata, handles),function erly_90_CreateFcn(hObject, eventdata, handles),function early_80_CreateFcn(hObject, eventdata, handles),function early_70_CreateFcn(hObject, eventdata, handles)
function early_60_CreateFcn(hObject, eventdata, handles),function early_50_CreateFcn(hObject, eventdata, handles),function early_40_CreateFcn(hObject, eventdata, handles),function early_30_CreateFcn(hObject, eventdata, handles)
function early_20_CreateFcn(hObject, eventdata, handles),function early_100_CreateFcn(hObject, eventdata, handles),function early_97_CreateFcn(hObject, eventdata, handles),function early_10_CreateFcn(hObject, eventdata, handles)
function adv_10_CreateFcn(hObject, eventdata, handles),function adv_97_CreateFcn(hObject, eventdata, handles),function adv_100_CreateFcn(hObject, eventdata, handles),function adv_20_CreateFcn(hObject, eventdata, handles)
function adv_30_CreateFcn(hObject, eventdata, handles),function adv_40_CreateFcn(hObject, eventdata, handles),function adv_50_CreateFcn(hObject, eventdata, handles),function adv_60_CreateFcn(hObject, eventdata, handles)
function adv_70_CreateFcn(hObject, eventdata, handles),function adv_80_CreateFcn(hObject, eventdata, handles),function adv_90_CreateFcn(hObject, eventdata, handles),function adv_95_CreateFcn(hObject, eventdata, handles)
function early_90_CreateFcn(hObject, eventdata, handles)
       
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

function Variables = AdjustRiskGraph(Variables)

Values = [10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 97, 100]*5;

% individual polyp risk
tmp(1:Values(1)) = Variables.Ind_Risk_Percentiles(1);
for x1=1:length(Values)-1
    Start = Values(x1)+1;
    Ende  = Values(x1+1);
    for x2=Start:Ende
        tmp(x2) = (Variables.Ind_Risk_Percentiles(x1) * (Ende-x2) + ...
            Variables.Ind_Risk_Percentiles(x1+1) * (x2-Start))/(Ende-Start);
    end
end

if isequal(Variables.RiskNormalize, 'on')
    tmp = tmp/mean(tmp);
    Variables.Ind_Risk_Percentiles = Variables.Ind_Risk_Percentiles/mean(tmp);
end
Variables.IndividualRisk = tmp; clear tmp

% early progression risk
tmp(1:Values(1)) = Variables.Early_Risk_Percentiles(1);
for x1=1:length(Values)-1
    Start = Values(x1)+1;
    Ende  = Values(x1+1);
    for x2=Start:Ende
        tmp(x2) = (Variables.Early_Risk_Percentiles(x1) * (Ende-x2) + ...
            Variables.Early_Risk_Percentiles(x1+1) * (x2-Start))/(Ende-Start);
    end
end

if isequal(Variables.RiskEarlyNormalize, 'on')
    tmp = tmp/mean(tmp);
    Variables.Early_Risk_Percentiles = Variables.Early_Risk_Percentiles/mean(tmp);
end
Variables.EarlyRisk = tmp; clear tmp

% advanced progression risk
tmp(1:Values(1)) = Variables.Adv_Risk_Percentiles(1);
for x1=1:length(Values)-1
    Start = Values(x1)+1;
    Ende  = Values(x1+1);
    for x2=Start:Ende
        tmp(x2) = (Variables.Adv_Risk_Percentiles(x1) * (Ende-x2) + ...
            Variables.Adv_Risk_Percentiles(x1+1) * (x2-Start))/(Ende-Start);
    end
end

if isequal(Variables.RiskAdvNormalize, 'on')
    tmp = tmp/mean(tmp);
    Variables.Adv_Risk_Percentiles = Variables.Adv_Risk_Percentiles/mean(tmp);
end
Variables.AdvRisk = tmp; clear tmp
