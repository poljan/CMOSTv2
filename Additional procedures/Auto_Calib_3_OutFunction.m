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

function stop = Auto_Calib_3_OutFunction(varargin)

%%% the path were this proggram is stored, this must be the CMOST path
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
CurrentPath = Path(1:pos-1);
cd (fullfile(CurrentPath, 'Temp'))
load ('Calibration_3_temp');

handles.Variables = Calibration_3_temp.Variables;
handles.Flow      = Calibration_3_temp.Flow;
BM                = Calibration_3_temp.BM;

FontSz   = 10;
MarkerSz = 5;
LineSz   = 0.4;
a=findall(0);

stop = false;

c=findobj(a, 'tag', 'Iteration_number');
set(c, 'string', num2str(handles.Flow.Iteration))

c=findobj(a, 'tag', 'RMS_Ca_current');
set(c, 'string', num2str(handles.Flow.RMSI(end)))

c=findobj(a, 'tag', 'RMS_rel_danger_current');
set(c, 'string', num2str(handles.Flow.RMSD(end)))

c=findobj(a, 'tag', 'RMS_Fraction_Rectum_current');
set(c, 'string', num2str(handles.Flow.RMSR(end)))

% adjust Carcinoma graphs     
% overall
MakeGraphik(BM.Graph.Cancer_Ov, handles.Variables.Benchmarks.Cancer.Ov_y,...
    handles.Variables.Benchmarks.Cancer.Ov_inc, BM.OutputValues.Cancer_Ov,...
    BM.OutputFlags.Cancer_Ov, 'Incidence carcinoma overall', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca', a)

% male
MakeGraphik(BM.Graph.Cancer_Male, handles.Variables.Benchmarks.Cancer.Male_y,...
    handles.Variables.Benchmarks.Cancer.Male_inc, BM.OutputValues.Cancer_Male,...
    BM.OutputFlags.Cancer_Male, 'Incidence carcinoma male', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca', a)

% female
MakeGraphik(BM.Graph.Cancer_Female, handles.Variables.Benchmarks.Cancer.Female_y,...
    handles.Variables.Benchmarks.Cancer.Female_inc, BM.OutputValues.Cancer_Female,...
    BM.OutputFlags.Cancer_Female, 'Incidence carcinoma female', 'per 100''000 per year', LineSz, MarkerSz, FontSz, 'Ca', a)

% relative danger adenoma 
b=findobj(a, 'string', 'origin of cancer');
axes(b.Parent), cla(b.Parent)
area(BM.CancerOriginArea), grid on, colormap summer, set(gca,'Layer','top')
ylabel('% of all cancer', 'fontsize', FontSz), xlabel('decade', 'fontsize', FontSz)
title('origin of cancer', 'fontsize', FontSz)
set(gca, 'xlim', [0 10], 'ylim', [0 100], 'fontsize', FontSz)
cm = colormap; %#ok<NASGU>
cpos = [1  13 26 38 51 64]; %#ok<NASGU> % these are the positions in the colormap used for the graphs
for f=1:5
    %    line ([0.1 4], [BM.CancerOriginSummary(f) BM.CancerOriginSummary(f)], 'color', cm(cpos(f), :))
end
l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Ad P5', 'Adv Ad P6', 'direct');
set(l, 'location', 'northoutside', 'fontsize', FontSz)
ypos = 0;
for f=1:6
    line([1.5 2.5], [(ypos + BM.CancerOriginValue(f)/2) (ypos + BM.CancerOriginValue(f)/2)],...
        'color', BM.CancerOriginFlag{f})
    ypos = ypos + BM.CancerOriginValue(f);
end

% fraction rectum
b=findobj(a, 'string', 'fraction rectum carcinoma');
axes(b.Parent), cla(b.Parent)
plot(0:99, BM.LocationRectumAllGender(1:100)./ (BM.LocationRectumAllGender(1:100) + BM.LocationRest(1:100))*100, 'color', 'k'), hold on
for f=1:length(BM.LocX)
    x(f) = mean(BM.LocX{f}(1):BM.LocX{f}(2)); %#ok<AGROW>
    line(BM.LocX{f}, [BM.LocationRectum(f) BM.LocationRectum(f)], 'color', BM.LocationRectumFlag{f})
    plot(x(f), BM.LocationRectum(f), '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k',...
        'MarkerFaceColor', BM.LocationRectumFlag{f}, 'MarkerSize',MarkerSz)
end
plot(x, BM.LocationRectum, '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',MarkerSz)
plot(x, BM.LocBenchmark, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
xlabel('year', 'fontsize', FontSz), ylabel('% rectum of all ca', 'fontsize', FontSz)
set(gca, 'fontsize', FontSz), title('fraction rectum carcinoma', 'fontsize', FontSz)

% Adjusting RMS Graph carcinoma
b=findobj(a, 'string', 'RMS carcinoma incidence');
axes(b.Parent), cla(b.Parent)
plot(1:length(handles.Flow.RMSI), handles.Flow.RMSI(1:length(handles.Flow.RMSI))), hold on
for f=1:length(handles.Flow.RMSI), 
    plot(f, handles.Flow.RMSI(f), '--rs','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',3)
end 
title('RMS carcinoma incidence')
set(gca, 'color',  [0.6 0.6 1], 'box', 'off')
drawnow

c=findobj(a, 'tag', 'Stop_Cal3');  
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

function MakeGraphik(DataGraph, BM_year, BM_value, BM_current, BM_flags, GraphTitle, LabelY, LineSz, MarkerSz, FontSz, Mod, a)
b=findobj(a, 'string', GraphTitle);
axes(b.Parent), cla(b.Parent) 
if isequal(Mod, 'Ca')
    plot(BM_year, DataGraph, 'color', 'k'), hold on
else
    plot(0:99, DataGraph, 'color', 'k'), hold on
end
plot(BM_year, BM_value, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)

for f=1:length(BM_year)
    if isequal(BM_flags{f}, '')
        BM_flags{f} = 'black';
    end
    plot(BM_year(f), BM_current(f), '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', BM_flags{f}, 'MarkerSize',3)
    line([BM_year(f)-2 BM_year(f)+2], [BM_current(f) BM_current(f)], 'color', BM_flags{f});
end
xlabel('year', 'fontsize', FontSz), ylabel(LabelY, 'fontsize', FontSz), title(GraphTitle, 'fontsize', FontSz)
set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])