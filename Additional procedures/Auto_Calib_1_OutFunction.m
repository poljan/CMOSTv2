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

function stop = Auto_Calib_1_OutFunction(varargin)

%%% the path were this proggram is stored, this must be the CMOST path
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
CurrentPath = Path(1:pos-1);
cd (fullfile(CurrentPath, 'Temp'))
load ('Calibration_1_temp');

handles.Variables = Calibration_1_temp.Variables;
handles.Flow      = Calibration_1_temp.Flow;
BM                = Calibration_1_temp.BM;

FontSz   = 10;
MarkerSz = 5;
LineSz   = 0.4;
a=findall(0);

stop = false;

c=findobj(a, 'tag', 'RMS_distribution_current');  
set(c, 'string', num2str(handles.Flow.RMSMPop(end)))

c=findobj(a, 'tag', 'RMS_prevalence_current');
set(c, 'string', num2str(handles.Flow.RMSE(end)))

c=findobj(a, 'tag', 'RMS_stage_distribution_current');
set(c, 'string', num2str(handles.Flow.RMSP(end)))

c=findobj(a, 'tag', 'Iteration_number');
set(c, 'string', num2str(handles.Flow.Iteration))

% young population
MakeGraphik2(BM.OutputValues.YoungPop, handles.Variables.Benchmarks.MultiplePolypsYoung,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'young population (40-54y)', a)

% intermediate population
MakeGraphik2(BM.OutputValues.MidPop, handles.Variables.Benchmarks.MultiplePolyp,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'intermediate population (55-74y)', a)

try
    for f=1:length(BM.OutputValues.MidPop)
        line([f-0.5 f+0.5], [BM.OutputValues.MidPop(f) BM.OutputValues.MidPop(f)], 'color', BM.OutputFlags.MidPop{f})
        plot(f, BM.OutputValues.MidPop(f), '--ks', 'MarkerEdgeColor', BM.OutputFlags.MidPop{f},...
            'MarkerFaceColor', BM.OutputFlags.MidPop{f}, 'MarkerSize',MarkerSz)
    end
catch
    rethrow (lasterror)
end
% old population
MakeGraphik2(BM.OutputValues.OldPop, handles.Variables.Benchmarks.MultiplePolypsOld,...
    LineSz, MarkerSz, FontSz, 'min number polyps', '% of population', 'old population (75-90y)', a)

% overall
MakeGraphik(BM.Graph.EarlyAdenoma_Ov, handles.Variables.Benchmarks.EarlyPolyp.Ov_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Ov_perc, BM.OutputValues.EarlyAdenoma_Ov,...
    BM.OutputFlags.EarlyAdenoma_Ov, 'Prevalence adenoma overall', 'percent of patients', LineSz, MarkerSz, FontSz, a)

% male
MakeGraphik(BM.Graph.EarlyAdenoma_Male, handles.Variables.Benchmarks.EarlyPolyp.Male_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Male_perc, BM.OutputValues.EarlyAdenoma_Male,...
    BM.OutputFlags.EarlyAdenoma_Male, 'Prevalence adenoma male', 'percent of patients', LineSz, MarkerSz, FontSz, a)

% female
MakeGraphik(BM.Graph.EarlyAdenoma_Female, handles.Variables.Benchmarks.EarlyPolyp.Female_y,...
    handles.Variables.Benchmarks.EarlyPolyp.Female_perc, BM.OutputValues.EarlyAdenoma_Female,...
    BM.OutputFlags.EarlyAdenoma_Female, 'Prevalence adenoma female', 'percent of patients', LineSz, MarkerSz, FontSz, a)

% Adenoma distribution
b=findobj(a, 'string', 'distribution of P1 ... P4 adenoma stages');
axes(b.Parent), cla(b.Parent)
bar(cat(2, BM.Polyp_early, zeros(6,1), BM.BM_value_early)', 'stacked'), hold on
for f=1:4 
    if isequal(f, 1), LinePos(f) = BM.Polyp_early(f)/2; %#ok<AGROW>
    else LinePos(f) = sum(BM.Polyp_early(1:f-1))+BM.Polyp_early(f)/2; %#ok<AGROW>
    end
end
for f=1:4
    line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', BM.Pflag{f})
end    
l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Adenoma P5', 'Adv Adenoma P6');
set(l, 'location', 'northoutside', 'fontsize', FontSz)
ylabel('% of affected patients', 'fontsize', FontSz)
title('distribution of P1 ... P4 adenoma stages')
set(gca, 'xticklabel', {'adenomas' '' 'benchmark' ''}, 'fontsize', FontSz, 'ylim', [0 100])

% Adjusting RMS Graph early
b=findobj(a, 'string', 'RMS adenoma prevalence');
axes(b.Parent), cla(b.Parent)
tmp = length(BM.RMSE);
plot(1:tmp, BM.RMSE(1:tmp)), hold on
for f=1:tmp
    plot(f, BM.RMSE(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% Adjusting RMS Graph population
b=findobj(a, 'string', 'RMS adenoma distribution');
axes(b.Parent), cla(b.Parent)
tmp = length(BM.RMSMPop);
plot(1:tmp, BM.RMSMPop(1:tmp)), hold on
for f=1:tmp, 
    plot(f, BM.RMSMPop(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')

% Adjusting RMS for adenoma stage distribution
b=findobj(a, 'string', 'RMS adenoma stage distribution');
axes(b.Parent), cla(b.Parent)
tmp = length(BM.RMSP);
plot(1:tmp, BM.RMSP(1:tmp)), hold on
for f=1:tmp, 
    plot(f, BM.RMSP(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
title('RMS adenoma stage distribution', 'fontsize', FontSz)

drawnow

c=findobj(a, 'tag', 'Stop');  
d=get(c, 'enable');
if isequal(d{1}, 'off')
       choice = questdlg('Are you sure you want to quit?',...
           'Quitting optimization?','yes', 'no', 'no'); 
       switch choice
           case    'yes'
               stop = true;
           case    'no'
               stop = false;
       end
end

function MakeGraphik(DataGraph, BM_year, BM_value, BM_current, BM_flags, GraphTitle, LabelY, LineSz, MarkerSz, FontSz, a)
b=findobj(a, 'string', GraphTitle);
axes(b.Parent), cla(b.Parent) 
plot(0:99, DataGraph, 'color', 'k'), hold on
plot(BM_year, BM_value, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)

for f=1:length(BM_year)
    plot(BM_year(f), BM_current(f), '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', BM_flags{f}, 'MarkerSize',3)
    line([BM_year(f)-2 BM_year(f)+2], [BM_current(f) BM_current(f)], 'color', BM_flags{f});
end
xlabel('year', 'fontsize', FontSz), ylabel(LabelY, 'fontsize', FontSz), title(GraphTitle, 'fontsize', FontSz)
set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])

function MakeGraphik2(Population, Benchmark, LineSz, MarkerSz, FontSz, XaxisLabel, YaxisLabel, FigTitle, a)
b=findobj(a, 'string', FigTitle);
axes(b.Parent), cla(b.Parent) 
plot(Population,   '--ks','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','m', 'MarkerSize',MarkerSz), hold on
plot(Benchmark,    '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
xlabel(XaxisLabel, 'fontsize', FontSz); ylabel(YaxisLabel, 'fontsize', FontSz)
set(gca, 'XTick', [1 2 3 4 5]), title(FigTitle, 'fontsize', FontSz), set(gca, 'fontsize', FontSz)
                
