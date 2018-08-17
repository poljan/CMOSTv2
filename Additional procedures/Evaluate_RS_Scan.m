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

function [AnalysisPipeline, CancerVariable, mod] = Evaluate_RS_Scan(ResultsPath)

mod = 'OK';

AnalysisPipeline = uigetdir(ResultsPath, 'Select folder with files of RS scan');
if isequal(AnalysisPipeline, 0) 
    return
end  

cd (AnalysisPipeline)
MasterDirectory=dir;
for f=1:length(MasterDirectory)
    AllFiles{f} = MasterDirectory(f).name;
end
z=0;
Error = zeros(length(MasterDirectory), 1);
for x=1:length(MasterDirectory)
    if ~or(or(strcmp(MasterDirectory(x,1).name, '.'), strcmp(MasterDirectory(x,1).name, '..')) ,...
            or(strcmp(MasterDirectory(x,1).name, '.DS_S_Results'), strcmp(MasterDirectory(x,1).name, '.DS_Store')))
        if and(isempty(regexp(MasterDirectory(x,1).name, '_ModComp.mat$', 'once')),...
                isempty(regexp(MasterDirectory(x,1).name, 'RS_summary.mat$', 'once')))
            if and(~MasterDirectory(x,1).isdir, isempty(regexp(MasterDirectory(x,1).name, 'Results.mat$', 'once')))
                z=z+1;
                l = length(MasterDirectory(x,1).name)-4;
                FileName{z}  = [MasterDirectory(x,1).name(1:l) '_Results']; %#ok<AGROW>
                Directory{z} = pwd; %#ok<AGROW>
                if ~isempty(find(ismember(AllFiles, [FileName{z} '.mat'])==1)); %#ok<EFIND>
                    Error(z) = 0;
                else
                    Error(z) = 1;
                end
            end
        end
    end
end
if max(Error) > 0
    display('Error, for the following files no output file was detected')
    errordlg('Some files possibly have not been evaluated', 'Files missing')
    mod = 'error';
    for f=1:length(Error)
        if Error(f)
            display(Directory{f})
            display(FileName{f})
        end
    end
    return
end
BatchCounter = z; ReplicaNumber = 0;

RS_Atkin = struct; Mock_Atkin = struct; RS_Holme = struct; Mock_Holme = struct;
RS_Schoen = struct; Mock_Schoen = struct; RS_Segnan = struct; Mock_Segnan = struct;

for z=1:BatchCounter
    pos1 = regexp(FileName{z}, 'RS-Atkin_', 'once'); % Atkin study
    pos2 = regexp(FileName{z}, 'RS-Holme_', 'once'); % Holme study
    pos3 = regexp(FileName{z}, 'RS-Schoen_', 'once'); % Schoen study
    pos4 = regexp(FileName{z}, 'RS-Segnan_', 'once'); % Segnan study
    
    posMock = regexp(FileName{z}, 'Mock', 'once');
    
    if ~isempty(pos1) || ~isempty(pos2) || ~isempty(pos3) || ~isempty(pos4) || ~isempty(pos5) || ~isempty(pos6)
        FileTemp = strrep(FileName{z},'_Results' ,'_RS_summary');
        clear RS_Evaluation 
        tmp = load(fullfile(Directory{z}, FileTemp));
        
        pos = regexp(FileTemp, '__'); pos = pos(end);
        CancerVar  = str2num(FileTemp((pos-2):(pos-1))); %#ok<ST2NM>
        ReplicaVar = str2num(FileTemp((pos+2):(pos+3))); %#ok<ST2NM>
        ReplicaNumber = max(ReplicaNumber, ReplicaVar);
        
        if ~isempty(pos1) % Atkin
            if isempty(posMock)
                RS_Atkin     = Add_RS_Results(tmp, RS_Atkin, CancerVar, ReplicaVar);
            else
                Mock_Atkin   = Add_RS_Results(tmp, Mock_Atkin, CancerVar, ReplicaVar);
            end
        elseif ~isempty(pos2) % Holme
            if isempty(posMock)
                RS_Holme     = Add_RS_Results(tmp, RS_Holme, CancerVar, ReplicaVar);
            else
                Mock_Holme   = Add_RS_Results(tmp, Mock_Holme, CancerVar, ReplicaVar);
            end
        elseif ~isempty(pos3) % Schoen
            if isempty(posMock)
                RS_Schoen     = Add_RS_Results(tmp, RS_Schoen, CancerVar, ReplicaVar);
            else
                Mock_Schoen   = Add_RS_Results(tmp, Mock_Schoen, CancerVar, ReplicaVar);
            end
        elseif ~isempty(pos4) % Segnan
            if isempty(posMock)
                RS_Segnan     = Add_RS_Results(tmp, RS_Segnan, CancerVar, ReplicaVar);
            else
                Mock_Segnan   = Add_RS_Results(tmp, Mock_Segnan, CancerVar, ReplicaVar);
            end
        end
    end
end

if ~isempty(fields(RS_Atkin))
    [Inc_red, Mort_red] = Summarize_RS(RS_Atkin, Mock_Atkin);
    p_Atkin = DisplayIncRed(Inc_red, Mort_red, 'Atkin', 23, 36, 2, 31, ReplicaNumber);
    CancerVariable = DisplayCalibrations(p_Atkin, 1, 1, 1, p_Atkin, 'Atkin calibration', 23); 
elseif ~isempty(fields(RS_Schoen))
    [Inc_red, Mort_red] = Summarize_RS(RS_Schoen, Mock_Schoen);
    p_Schoen = DisplayIncRed(Inc_red, Mort_red, 'Schoen', 21, 29, 14, 26, ReplicaNumber);
    CancerVariable = DisplayCalibrations(p_Schoen, 1, 1, 1, p_Schoen, 'Schoen calibration', 21); 
elseif ~isempty(fields(RS_Holme))
    [Inc_red, Mort_red] = Summarize_RS(RS_Holme, Mock_Holme);
    p_Holme = DisplayIncRed(Inc_red, Mort_red, 'Holme', 20, 24, 10, 27, ReplicaNumber);
    CancerVariable = DisplayCalibrations(p_Holme, 1, 1, 1, p_Holme, 'Holme calibration', 20); 
elseif ~isempty(fields(RS_Segnan))
    [Inc_red, Mort_red] = Summarize_RS(RS_Segnan, Mock_Segnan);
    p_Segnan = DisplayIncRed(Inc_red, Mort_red, 'Segnan', 18, 24, 9, 22, ReplicaNumber);
    CancerVariable = DisplayCalibrations(p_Segnan, 1, 1, 1, p_Segnan, 'Segnan calibration', 18); 
end

% CancerVariable = DisplayCalibrations(p_Atkin, 1, 1, 1, p_Atkin, 'Atkin calibration', 23); 
% DisplayCalibrations(p_Atkin, p_Schoen, p_Holme, p_Segnan, p_Atkin, 'Atkin calibration', 23) 
% DisplayCalibrations(p_Atkin, p_Schoen, p_Holme, p_Segnan, p_Schoen, 'Schoen calibration', 21) 
% DisplayCalibrations(p_Atkin, p_Schoen, p_Holme, p_Segnan, p_Holme, 'Holme calibration', 20) 
% DisplayCalibrations(p_Atkin, p_Schoen, p_Holme, p_Segnan, p_Segnan, 'Segnan calibration', 18) 

function CancerVariable = DisplayCalibrations(p_Atkin, p_Schoen, p_Holme, p_Segnan, predictor, TitleString, OvRef) 
display(sprintf(TitleString))
% 23 = p1 * CVar + p2
CancerVariable = (OvRef-predictor.all(2))/predictor.all(1);
display(sprintf('CancerVariable = %.1f', CancerVariable))
display(sprintf('Predicting Atkin. all: %.1f, left: %.1f, right: %.1f, mortality: %.1f',...
    p_Atkin.all(1) * CancerVariable + p_Atkin.all(2),... 
    p_Atkin.left(1) * CancerVariable + p_Atkin.left(2),...
    p_Atkin.right(1) * CancerVariable + p_Atkin.right(2),...
    p_Atkin.mort(1) * CancerVariable + p_Atkin.mort(2)))
% display(sprintf('Predicting Schoen. all: %.1f, left: %.1f, right: %.1f, mortality: %.1f',...
%     p_Schoen.all(1) * CancerVariable + p_Schoen.all(2),... 
%     p_Schoen.left(1) * CancerVariable + p_Schoen.left(2),...
%     p_Schoen.right(1) * CancerVariable + p_Schoen.right(2),...
%     p_Schoen.mort(1) * CancerVariable + p_Schoen.mort(2)))
% display(sprintf('Predicting Holme. all: %.1f, left: %.1f, right: %.1f, mortality: %.1f',...
%     p_Holme.all(1) * CancerVariable + p_Holme.all(2),... 
%     p_Holme.left(1) * CancerVariable + p_Holme.left(2),...
%     p_Holme.right(1) * CancerVariable + p_Holme.right(2),...
%     p_Holme.mort(1) * CancerVariable + p_Holme.mort(2)))
% display(sprintf('Predicting Segnan. all: %.1f, left: %.1f, right: %.1f, mortality: %.1f',...
%     p_Segnan.all(1) * CancerVariable + p_Segnan.all(2),... 
%     p_Segnan.left(1) * CancerVariable + p_Segnan.left(2),...
%     p_Segnan.right(1) * CancerVariable + p_Segnan.right(2),...
%     p_Segnan.mort(1) * CancerVariable + p_Segnan.mort(2)))

function p = DisplayIncRed(Inc_red, Mort_red, TitleLable, Norm_all, Norm_left, Norm_right, Norm_mort, ReplicaNumber)
figure('Name', TitleLable)

% incidence reduction overall
subplot(2,2,1)
for f=1:ReplicaNumber
    scatter(1:15, Inc_red.all(:, f), 'MarkerEdgeColor', 'b', 'Markerfacecolor', 'b')
    hold on
end
for f=1:15
    y(f) =  mean(Inc_red.all(f, :));
    scatter(f, y(f), 'MarkerEdgeColor', 'r', 'Markerfacecolor', 'r')
    
    line([f-0.3 f+0.3], [y(f) y(f)], 'color', 'r')
end
p.all = polyfit(1:15, y, 1);
plot(1:15, (1:15)*p.all(1)+p.all(2), 'k')
line([1 15], [Norm_all Norm_all])
title('Incidence reduction overall')
xlabel('Cancer Variable')
ylabel('Incidence reduction')

% incidence reduction left
subplot(2,2,2)
for f=1:ReplicaNumber
    scatter(1:15, Inc_red.left(:, f), 'MarkerEdgeColor', 'b', 'Markerfacecolor', 'b')
    hold on
end
for f=1:15
    y(f) =  mean(Inc_red.left(f, :));
    scatter(f, y(f), 'MarkerEdgeColor', 'r', 'Markerfacecolor', 'r')
    
    line([f-0.3 f+0.3], [y(f) y(f)], 'color', 'r')
end
p.left = polyfit(1:15, y, 1);
plot(1:15, (1:15)*p.left(1)+p.left(2), 'k')
line([1 15], [Norm_left Norm_left])
title('Incidence reduction left')
xlabel('Cancer Variable')
ylabel('Incidence reduction')

% incidence reduction right
subplot(2,2,3)
for f=1:ReplicaNumber
    scatter(1:15, Inc_red.right(:, f), 'MarkerEdgeColor', 'b', 'Markerfacecolor', 'b')
    hold on
end
for f=1:15
    y(f) =  mean(Inc_red.right(f, :));
    scatter(f, y(f), 'MarkerEdgeColor', 'r', 'Markerfacecolor', 'r')
    
    line([f-0.3 f+0.3], [y(f) y(f)], 'color', 'r')
end
p.right = polyfit(1:15, y, 1);
plot(1:15, (1:15)*p.right(1)+p.right(2), 'k')
line([1 15], [Norm_right Norm_right])
title('Incidence reduction right')
xlabel('Cancer Variable')
ylabel('Incidence reduction')

% incidence mortality reduction
subplot(2,2,4)
for f=1:ReplicaNumber
    scatter(1:15, Mort_red(:, f), 'MarkerEdgeColor', 'b', 'Markerfacecolor', 'b')
    hold on
end
for f=1:15
    y(f) =  mean(Mort_red(f, :));
    scatter(f, y(f), 'MarkerEdgeColor', 'r', 'Markerfacecolor', 'r')
    
    line([f-0.3 f+0.3], [y(f) y(f)], 'color', 'r')
end
p.mort = polyfit(1:15, y, 1);
plot(1:15, (1:15)*p.mort(1)+p.mort(2), 'k')
line([1 15], [Norm_mort Norm_mort])
title('Mortality reduction')
xlabel('Cancer Variable')
ylabel('Incidence reduction')


function [Inc_red, Mort_red] = Summarize_RS(RS, Mock)

[CancVar_Counter, RS_Counter] = size(RS.right_1);
for x1=1:CancVar_Counter
    for x2=1:RS_Counter
        
        for g=1:40
            Inc.right_1(x1, x2, g) = (1-sum(RS.right_1{x1, x2}(1:g))/sum(Mock.right_1{x1, x2}(1:g)))*100;
            Inc.right_2(x1, x2, g) = (1-sum(RS.right_2{x1, x2}(1:g))/sum(Mock.right_2{x1, x2}(1:g)))*100;
            Inc.right_3(x1, x2, g) = (1-sum(RS.right_3{x1, x2}(1:g))/sum(Mock.right_3{x1, x2}(1:g)))*100;
            Inc.right_4(x1, x2, g) = (1-sum(RS.right_4{x1, x2}(1:g))/sum(Mock.right_4{x1, x2}(1:g)))*100;
            
            Inc.left_1(x1, x2, g) = (1-sum(RS.left_1{x1, x2}(1:g))/sum(Mock.left_1{x1, x2}(1:g)))*100;
            Inc.left_2(x1, x2, g) = (1-sum(RS.left_2{x1, x2}(1:g))/sum(Mock.left_2{x1, x2}(1:g)))*100;
            Inc.left_3(x1, x2, g) = (1-sum(RS.left_3{x1, x2}(1:g))/sum(Mock.left_3{x1, x2}(1:g)))*100;
            Inc.left_4(x1, x2, g) = (1-sum(RS.left_4{x1, x2}(1:g))/sum(Mock.left_4{x1, x2}(1:g)))*100;
            
            Inc.rectum(x1, x2, g) = (1-sum(RS.rectum{x1, x2}(1:g))/sum(Mock.rectum{x1, x2}(1:g)))*100;
            Inc.all(x1, x2, g)    = (1-sum(RS.all{x1, x2}(1:g))/sum(Mock.all{x1, x2}(1:g)))*100;
            
            Mort(x1, x2, g)       = (1-sum(RS.Mortality{x1, x2}(1:g))/sum(Mock.Mortality{x1, x2}(1:g)))*100; %#ok<AGROW>
        end
        Inc_red.all(x1, x2)     = Inc.all(x1, x2, 12);
        Inc_red.left(x1, x2)    = Inc.left_2(x1, x2, 12);
        Inc_red.right(x1, x2)   = Inc.right_2(x1, x2, 12);
        Mort_red(x1, x2)        = Mort(x1, x2, 12); %#ok<AGROW>
    end
end

% IncMean(:, 1) = 1:40;
% IncMean(:, 2) = mean(Inc.right_1, 1);
% IncMean(:, 3) = mean(Inc.right_2, 1);
% IncMean(:, 4) = mean(Inc.right_3, 1);
% IncMean(:, 5) = mean(Inc.right_4, 1);
% 
% IncMean(:, 6) = mean(Inc.left_1, 1);
% IncMean(:, 7) = mean(Inc.left_2, 1);
% IncMean(:, 7) = mean(Inc.left_3, 1);
% IncMean(:, 8) = mean(Inc.left_4, 1);
% 
% IncMean(:, 9)  = mean(Inc.rectum, 1);
% IncMean(:, 10) = mean(Inc.all, 1);
% IncMean(:, 11) = mean(Mort, 1);
% 
% IncMeanFinal(1, 1) = mean(Inc_red.all);
% IncMeanFinal(1, 2) = mean(Inc_red.left);
% IncMeanFinal(1, 3) = mean(Inc_red.right);
% IncMeanFinal(1, 4) = mean(Mort_red);

function [tmp] = Add_RS_Results(x, tmp, CancerVar, ReplicaVar)

tmp.right_1{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 1:2), 2);
tmp.right_2{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 1:4), 2);
tmp.right_3{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 1:5), 2);
tmp.right_4{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 1:6), 2);

tmp.left_1{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 10:13), 2);
tmp.left_2{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 7:13), 2);
tmp.left_3{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 6:13), 2);
tmp.left_4{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 5:13), 2);

tmp.rectum{CancerVar, ReplicaVar} = sum(x.RS_Evaluation.Tumor(:, 13), 2);
tmp.all{CancerVar, ReplicaVar}    = sum(x.RS_Evaluation.Tumor(:, 1:13), 2);

tmp.Mortality{CancerVar, ReplicaVar}      = x.RS_Evaluation.Mortality;
tmp.NumberSurvived{CancerVar, ReplicaVar} = x.RS_Evaluation.NumberSurvived;