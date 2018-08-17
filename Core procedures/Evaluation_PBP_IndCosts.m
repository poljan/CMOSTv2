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

function [data,BM] = Evaluation_PBP_IndCosts(data, Variables)

% comment about TIME (year)
% in all scripts PRECEDING this time was 1-100 (Lebensjahre)
% in EVALUATION we transform this to age (0-99)

% for PBC we save these data directly to the results variable
Results = struct;
Results.DiagnosedCancer = data.DiagnosedCancer;
Results.DeathYear       = data.DeathYear;

DispFlag    = Variables.DispFlag;
ResultsFlag = Variables.ResultsFlag;
ExcelFlag   = Variables.ExcelFlag;

y = data.y;
n = data.n;

% key settings
FontSz   = 7;
MarkerSz = 4;
LineSz   = 0.4;
bmc      = 1;

tolerance = 0.2;

BM.description = cell(100, 1);
BM.value       = cell(100, 1); 
BM.benchmark   = cell(100, 1);
BM.flag        = cell(100, 1);
 
% Benchmarks
% a few benchmarks remain hardcoded:

Variables.Benchmarks.MultiplePolypsYoung = [18 5  3  3 2];
% MidBenchmark   = [36 16 5  4 3];
% MidBenchmark   = Variables.Benchmarks.MultiplePolyp;
Variables.Benchmarks.MultiplePolypsOld   = [40 24 10 8 4];

Variables.Benchmarks.Cancer.SymptomaticStageDistribution  = [15 35.6 27.9 21.5];
Variables.Benchmarks.Cancer.ScreeningStageDistribution    = [39.5 34.7 17.3 8.5];

Variables.Benchmarks.Cancer.LocationRectumMale   = [41.2     34.1      28.6     23.8];
Variables.Benchmarks.Cancer.LocationRectumFemale = [37.2     28.3      23.0     19.0];
Variables.Benchmarks.Cancer.LocationRectumYear   = {[51 55], [61 65], [71 75], [81 85]};  % year adapted

Variables.Benchmarks.Cancer.Fastcancer           = [0.005 0.05 0.08 0.25 3 20];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       FIGUREs                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    h1 = figure('numbertitle', 'off', 'name', ['Figure 1: Prevalence of early and advanced adenoma, CRC incidence. Settings: ', Variables.Settings_Name]);
    h2 = figure('numbertitle', 'off', 'name', ['Figure 2: Adenoma characteristics. Settings: ', Variables.Settings_Name]);
    h3 = figure('numbertitle', 'off', 'name', ['Figure 3: Cancer characteristics. Settings: ', Variables.Settings_Name]);
    h4 = figure('numbertitle', 'off', 'name', ['Figure 4: CRC effects and CRC screening. Settings: ', Variables.Settings_Name]);
    scrsz = get(0, 'screensize');
    for f = [h1 h2 h3 h4]
        set(f, 'position', scrsz)
    end
    figure(h1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Early/ Advanced polyps All  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we calculate the number of patients with polpys 1-4 and express 
% them as percentage of survivors
for f=1:y
    NumPolyps(f)    = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>0); 
    NumPolyps_2(f)  = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>1);
    NumPolyps_3(f)  = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>2);
    NumPolyps_4(f)  = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>3);
    NumPolyps_5(f)  = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>4);
    NumPolyps_6(f)  = sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1)>5); 
end
for f=1:y
    FracPolyps(f) = NumPolyps(f)/sum(data.YearIncluded(f, :))*100; 
    FracPolyps_2(f) = NumPolyps_2(f)/sum(data.YearIncluded(f, :))*100;
    FracPolyps_3(f) = NumPolyps_3(f)/sum(data.YearIncluded(f, :))*100;
    FracPolyps_4(f) = NumPolyps_4(f)/sum(data.YearIncluded(f, :))*100;
    FracPolyps_5(f) = NumPolyps_5(f)/sum(data.YearIncluded(f, :))*100;
    FracPolyps_6(f) = NumPolyps_6(f)/sum(data.YearIncluded(f, :))*100;
end

% the fraction of surviving patients with advanced polyps
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(FracPolyps, bmc, BM, Variables.Benchmarks, 'EarlyPolyp', 'Ov_y', 'Ov_perc',...
    DispFlag, 1, 'early polyps year ', 'early polyps overall', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp'); 
BM.Graph.EarlyAdenoma_Ov = FracPolyps; BM.OutputFlags.EarlyAdenoma_Ov = OutputFlags; BM.OutputValues.EarlyAdenoma_Ov = OutputValues;

% the fraction of surviving patients with advanced polyps
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(FracPolyps_5, bmc, BM, Variables.Benchmarks, 'AdvPolyp', 'Ov_y', 'Ov_perc',...
    DispFlag, 2, 'advanced polyps year ', 'advanced polyps overall', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp');  
BM.Graph.AdvAdenoma_Ov = FracPolyps_5; BM.OutputFlags.AdvAdenoma_Ov = OutputFlags; BM.OutputValues.AdvAdenoma_Ov = OutputValues;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Cancer Incidence All  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for f=1:y
    i(f) = length(find(data.TumorRecord.Stage(f, :)));
    j(f) = sum(data.YearIncluded(f, :));
end  
% we summarize in 5 year intervals
SumCa =  [sum(i(1:4)) sum(i(5:8))   sum(i(11:15))  sum(i(16:20)) sum(i(21:25)) sum(i(26:30))... % year adapted
      sum(i(31:35))   sum(i(36:40)) sum(i(41:45)) sum(i(46:50)) sum(i(51:55)) sum(i(56:60))...
      sum(i(61:65))   sum(i(66:70)) sum(i(71:75)) sum(i(76:80)) sum(i(81:85)) sum(i(86:90))];
SumPat = [sum(j(1:4)) sum(j(5:8))   sum(j(11:15))  sum(j(16:20)) sum(j(21:25)) sum(j(26:30))...
      sum(j(31:35))   sum(j(36:40)) sum(j(41:45)) sum(j(46:50)) sum(j(51:55)) sum(j(56:60))...
      sum(j(61:65))   sum(j(66:70)) sum(j(71:75)) sum(j(76:80)) sum(j(81:85)) sum(j(86:90))];
  
% and express is as new cancer cases per 100'000 patients
for f=1:length(SumCa)
    Incidence(f) = SumCa(f)/SumPat(f);
end
Incidence = Incidence * 100000;

% Overall cancer incidence
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Incidence, bmc, BM, Variables.Benchmarks, 'Cancer', 'Ov_y', 'Ov_inc',...
    DispFlag, 3, 'Cancer incidence year ', 'cancer incidence overall', tolerance, LineSz, MarkerSz, FontSz, 'per 100''000 per year', 'Cancer');  
BM.Graph.Cancer_Ov = Incidence; BM.OutputFlags.Cancer_Ov = OutputFlags; BM.OutputValues.Cancer_Ov = OutputValues;

BM.Incidence = Incidence; 
clear Incidence SumCa SumPat i j 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Early/ advanced polyps Male/ Female    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear EarlyPolyps AdvPolyps Included
% we calculate the presence of polyps (all polyps or Advanced polyps and
% express as percent of survivors
for f1=1:2 % 1=male, 2=female
    Gender = data.Gender == f1;
    for f=1:y
        EarlyPolyps{f1}(f) = sum(data.MaxPolyps(f, and(Gender, data.YearIncluded(f, :)))>0); 
        AdvPolyps{f1}(f)   = sum(data.MaxPolyps(f, and(Gender, data.YearIncluded(f, :)))>4);
        Included           = sum(data.YearIncluded(f, Gender));
        EarlyPolyps{f1}(f) = EarlyPolyps{f1}(f)/Included*100; 
        AdvPolyps{f1}(f)   = AdvPolyps{f1}(f)/Included*100; 
    end
end

% Early polyps male
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(EarlyPolyps{1}, bmc, BM, Variables.Benchmarks, 'EarlyPolyp', 'Male_y', 'Male_perc',...
    DispFlag, 4, 'Early polyps male year ', 'early polyps present male', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp'); 
BM.Graph.EarlyAdenoma_Male = EarlyPolyps{1}; BM.OutputFlags.EarlyAdenoma_Male = OutputFlags; BM.OutputValues.EarlyAdenoma_Male = OutputValues;

% Early polyps female
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(EarlyPolyps{2}, bmc, BM, Variables.Benchmarks, 'EarlyPolyp', 'Female_y', 'Female_perc',...
    DispFlag, 7, 'Early polyps female year ', 'early polyps present female', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp'); 
BM.Graph.EarlyAdenoma_Female = EarlyPolyps{2}; BM.OutputFlags.EarlyAdenoma_Female = OutputFlags; BM.OutputValues.EarlyAdenoma_Female = OutputValues;

% advanced polyps male
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(AdvPolyps{1}, bmc, BM, Variables.Benchmarks, 'AdvPolyp', 'Male_y', 'Male_perc',...
    DispFlag, 5, 'Advanced polyps male year ', 'advanced polyps present male', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp'); 
BM.Graph.AdvAdenoma_Male = AdvPolyps{1}; BM.OutputFlags.AdvAdenoma_Male = OutputFlags; BM.OutputValues.AdvAdenoma_Male = OutputValues;

% advanced polyps female
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(AdvPolyps{2}, bmc, BM, Variables.Benchmarks, 'AdvPolyp', 'Female_y', 'Female_perc',...
    DispFlag, 8, 'Advanced polyps female year ', 'advanced polyps present female', tolerance, LineSz, MarkerSz, FontSz, '% of survivors', 'Polyp'); 
BM.Graph.AdvAdenoma_Female = AdvPolyps{2}; BM.OutputFlags.AdvAdenoma_Female = OutputFlags; BM.OutputValues.AdvAdenoma_Female = OutputValues;
clear AdvPolyps EarlyPolyps Gender Included

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Cancer Incidence Male/ Female   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear Counter Incidence1 i j tmp3 tmp4 tmp5
 
for f1=1:2
    for f2=1:y
        i(f2) = length(find(data.TumorRecord.Stage(f2, data.TumorRecord.Gender(f2, :)==f1)));
        j(f2) = sum(data.YearIncluded(f2, data.Gender ==f1));
    end    
    tmp3 =  [sum(i(1:4)) sum(i(5:8))   sum(i(11:15))  sum(i(16:20)) sum(i(21:25)) sum(i(26:30))... % year adapted
      sum(i(31:35))   sum(i(36:40)) sum(i(41:45)) sum(i(46:50)) sum(i(51:55)) sum(i(56:60))...
      sum(i(61:65))   sum(i(66:70)) sum(i(71:75)) sum(i(76:80)) sum(i(81:85)) sum(i(86:90))];
    tmp4 = [sum(j(1:4)) sum(j(5:8))   sum(j(11:15))  sum(j(16:20)) sum(j(21:25)) sum(j(26:30))...
      sum(j(31:35))   sum(j(36:40)) sum(j(41:45)) sum(j(46:50)) sum(j(51:55)) sum(j(56:60))...
      sum(j(61:65))   sum(j(66:70)) sum(j(71:75)) sum(j(76:80)) sum(j(81:85)) sum(j(86:90))];
  
    for f=1:length(tmp3)
        tmp5(f) = tmp3(f)/tmp4(f);
    end
    Incidence{f1} = tmp5 *100000;
end

% male cancer incidence
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Incidence{1}, bmc, BM, Variables.Benchmarks, 'Cancer', 'Male_y', 'Male_inc',...
    DispFlag, 6, 'Cancer incidence year male ', 'cancer incidence male', tolerance, LineSz, MarkerSz, FontSz, 'per 100''000 per year', 'Cancer');  
BM.Graph.Cancer_Male = Incidence{1}; BM.OutputFlags.Cancer_Male = OutputFlags; BM.OutputValues.Cancer_Male = OutputValues;

% female cancer incidence
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Incidence{2}, bmc, BM, Variables.Benchmarks, 'Cancer', 'Female_y', 'Female_inc',...
    DispFlag, 9, 'Cancer incidence year female ', 'cancer incidence female', tolerance, LineSz, MarkerSz, FontSz, 'per 100''000 per year', 'Cancer');  
BM.Graph.Cancer_Female = Incidence{2}; BM.OutputFlags.Cancer_Female = OutputFlags; BM.OutputValues.Cancer_Female = OutputValues;

if DispFlag
    title('cancer incidence female', 'fontsize', FontSz)
    ylabel('per 100''000 per year', 'fontsize', FontSz), xlabel('year', 'fontsize', FontSz)
    set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])
end
clear Incidence i j tmp3 tmp4 tmp5 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Early Polyps present  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    cm = colormap; cpos = [1  13 26 38 51 64];
    figure(h2),subplot(3,3,1)
    
    plot(0:99, FracPolyps, 'color', 'k'), hold on
    plot(0:99, FracPolyps_2, 'color', cm(cpos(1), :))
    plot(0:99, FracPolyps_3, 'color', cm(cpos(2), :))
    plot(0:99, FracPolyps_4, 'color', cm(cpos(3), :))
    plot(0:99, FracPolyps_5, 'color', cm(cpos(4), :))
    plot(0:99, FracPolyps_6, 'color', cm(cpos(5), :))
    
    xlabel('year', 'fontsize', FontSz), ylabel('% of survivors', 'fontsize', FontSz), title('all adenomas present', 'fontsize', FontSz)
    set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])
    l = legend('all early', 'at least P2', 'at least P3', 'at least P4', 'at least P5', 'P6');
    set(l, 'location', 'northoutside', 'fontsize', FontSz-2)
end
clear FracPolyps FracPolyps_2 FracPolyps_3 FracPolyps_4 FracPolyps_5 FracPolyps_6 cm cpos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Early Polyps distribution  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inactivated version for all 6 polyps
% BM_value = Variables.Benchmarks.Polyp_Distr;
% Summe = sum(sum(data.AllPolyps(:, 51:76))); % year adapted
% 
% for f=1:6
%     BM.description{bmc} = ['% of all polyps P' num2str(f)];
%     Polyp(f) = sum(data.AllPolyps(f, 51:76))/Summe*100; % year adapted
%     BM.value{bmc} = Polyp(f); BM.benchmark{bmc} = BM_value(f);
%     
%     if isequal(f, 1), LinePos(f) = Polyp(f)/2;
%     else LinePos(f) = sum(Polyp(1:f-1))+Polyp(f)/2;
%     end
%     if and(BM.value{bmc} > BM_value(f)*(1 - tolerance), BM.value{bmc} < (BM_value(f)*(1 + tolerance)))
%         BM.flag{bmc} = 'green'; Color{f} = 'g';
%     else
%         BM.flag{bmc} = 'red';   Color{f} = 'r';
%     end
%     BM.Polyp_Distr(f) = BM.value{bmc};
%     bmc = bmc +1;
% end
% if DispFlag
%     figure(h2), subplot(3,3,2)
%     bar(cat(2, Polyp', zeros(6,1), BM_value')', 'stacked'), hold on
%     for f=1:6, line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', Color{f}), end
%     l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Adenoma P5', 'Adv Adenoma P6');
%     set(l, 'location', 'northoutside', 'fontsize', 6)
%     ylabel('% of affected patients', 'fontsize', 6)
%     set(gca, 'xticklabel', {'Polpys' '' 'benchmark'}, 'fontsize', 6, 'ylim', [0 100])
% end
% BM.Pstage = cat(2, Polyp', zeros(6,1), BM_value')';
% BM.Pflag  = Color;
% clear LinePos Polyp Color Summe

Polyp_early         = zeros(6,1);
Polyp_adv           = zeros(6,1);
BM_value_early      = zeros(6,1);
BM_value_adv        = zeros(6,1);

BM_value            = Variables.Benchmarks.Polyp_Distr;
Summe_early         = sum(sum(data.AllPolyps(1:4, 51:76))); % year adapted
Summe_adv           = sum(sum(data.AllPolyps(5:6, 51:76))); % year adapted
BM_value_early(1:4) = BM_value(1:4)/sum(BM_value(1:4))*100;
BM_value_adv(5:6)   = BM_value(5:6)/sum(BM_value(5:6))*100;

for f=1:4
    BM.description{bmc} = ['% of all early polyps P ' num2str(f)];
    Polyp_early(f) = sum(data.AllPolyps(f, 51:76))/Summe_early*100; % year adapted
    BM.value{bmc} = Polyp_early(f); BM.benchmark{bmc} = BM_value_early(f);
    
    if isequal(f, 1), LinePos(f) = Polyp_early(f)/2;
    else LinePos(f) = sum(Polyp_early(1:f-1))+Polyp_early(f)/2;
    end
    if and(BM.value{bmc} > BM_value_early(f)*(1 - tolerance), BM.value{bmc} < (BM_value_early(f)*(1 + tolerance)))
        BM.flag{bmc} = 'green'; Color{f} = 'g';
    else
        BM.flag{bmc} = 'red';   Color{f} = 'r';
    end
    BM.Polyp_Distr(f) = BM.value{bmc};
    bmc = bmc +1;
end
for f=5:6
    BM.description{bmc} = ['% of all early polyps P ' num2str(f)];
    Polyp_adv(f) = sum(data.AllPolyps(f, 51:76))/Summe_adv*100; % year adapted
    BM.value{bmc} = Polyp_adv(f); BM.benchmark{bmc} = BM_value_adv(f);
    
    if isequal(f, 1), LinePos(f) = Polyp_adv(f)/2;
    else LinePos(f) = sum(Polyp_adv(1:f-1))+Polyp_adv(f)/2;
    end
    if and(BM.value{bmc} > BM_value_adv(f)*(1 - tolerance), BM.value{bmc} < (BM_value_adv(f)*(1 + tolerance)))
        BM.flag{bmc} = 'green'; Color{f} = 'g';
    else
        BM.flag{bmc} = 'red';   Color{f} = 'r';
    end
    BM.Polyp_Distr(f) = BM.value{bmc};
    bmc = bmc +1;
end
if DispFlag
    figure(h2), subplot(3,3,2)
    bar(cat(2, Polyp_early, zeros(6,1), BM_value_early, zeros(6,1), ...
        Polyp_adv, zeros(6,1), BM_value_adv)', 'stacked'), hold on
    for f=1:4, line([1.5 2.5], [LinePos(f) LinePos(f)], 'color', Color{f}), end
    for f=5:6, line([5.5 6.5], [LinePos(f) LinePos(f)], 'color', Color{f}), end
    l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Adenoma P5', 'Adv Adenoma P6');
    set(l, 'location', 'northoutside', 'fontsize', 6)
    ylabel('% of adenomas', 'fontsize', 6)
    set(gca, 'xticklabel', {'Ear.Ad.' '' 'BM' '' 'Adv.Ad.' '' 'BM'}, 'fontsize', 6, 'ylim', [0 100])
end
BM.Polyp_early    = Polyp_early;
BM.BM_value_early = BM_value_early;
BM.Polyp_adv      = Polyp_adv;
BM.BM_value_adv   = BM_value_adv;
BM.Pflag          = Color;
clear LinePos Polyp Color Summe

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Cumulative Cancer   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for f=1:100
    Early_Cancer(f) = sum(data.TumorRecord.Stage(f, :)==7) + sum(data.TumorRecord.Stage(f, :)==8); %#ok<*AGROW>
    Late_Cancer(f)  = sum(data.TumorRecord.Stage(f, :)==9) + sum(data.TumorRecord.Stage(f, :)==10);
end

PatientNumber = data.TumorRecord.PatientNumber;

DiagCancer    = zeros(1, n);
CumDiagCancer = zeros(1,100);
for f=1:100
    tmp2 = find(PatientNumber(f, :));
    for f2=1:length(tmp2);
        DiagCancer(PatientNumber(f, tmp2(f2))) = 1;
    end
    CumDiagCancer(f) = sum(DiagCancer)/n*100;
end

DiagCancer      = zeros(1, n);
DiagYCancer     = 500*ones(1, n);
MultipleCancer  = zeros(1,100);
MultipleSurvCanc= zeros(1,100);

for f=1:100
    tmp2 = find(PatientNumber(f, :));
    for f2=1:length(tmp2);
        pos = PatientNumber(f, tmp2(f2));
        if isequal(DiagCancer(pos), 1)
            MultipleCancer(f) = MultipleCancer(f) +1;
            if (f-DiagYCancer(pos))<=5
                MultipleSurvCanc(f) = MultipleSurvCanc(f) + 1;
            end
        else
            DiagCancer(pos)  = 1;
            DiagYCancer(pos) = f;
        end
    end
end

for f=1:100
    DoubleCancer(f) = sum(MultipleCancer(1:f));
end
DoubleCancer = DoubleCancer/n*100;
clear tmp tmp2 DiagCancer MultipleCancer

%m Recurrence/Metachronous
tmpL            = data.TumorRecord.Location;
PatLoc          = zeros(13,n);
MetachronCancer = zeros(1,n);
RecurrenCancer  = zeros(1,length(PatientNumber));

for fn=1:length(PatientNumber)
    tmp2 = find(PatientNumber(:, fn));

    if length(tmp2)>1
        RecurrenCancer(fn) = 1 ;
    end
    
    for f2=1:length(tmp2);
        pat = PatientNumber(tmp2(f2),fn);
        loc = tmpL(tmp2(f2),fn);
        if isequal(PatLoc(loc,pat), 0)
            PatLoc(loc,pos) = 1;
        else
            MetachronCancer(pat) = MetachronCancer(pat) +1;
        end
    end
end

for f=1:y
    CumulativeCancer(f) = sum(data.HasCancer(f,1:n))/n*100;
end

if DispFlag
    figure(h3), subplot(3,3,9)
    plot(0:99, CumulativeCancer, 'color','k'), hold on      % year adapted
    plot(0:99, CumDiagCancer, 'color', 'b')                 % year adapted
    plot(0:99, DoubleCancer, 'color', 'g')                  % year adapted
    l = legend('present', 'diagnosed', 'multiple cancer');
    set(l, 'location', 'northoutside', 'fontsize', FontSz-1)
    line([0 100], [6 6], 'color', 'r')
    ylabel('% of all patients', 'fontsize', FontSz), xlabel('year', 'fontsize', FontSz)
    title('cumulative cancer', 'fontsize', FontSz)
    set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])
end

MultCanc = DoubleCancer;
Metachronous(1,1) = sum(RecurrenCancer);
Metachronous(1,2) = sum(MetachronCancer);
Metachronous(1,3) = sum(MultipleSurvCanc);
BM.Cancer.Metachronous = Metachronous;
BM.Cancer.MultCanc     = MultCanc;
clear tmp tmp2 DiagCancer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Cancer Survival    4-4 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for f=1:y
    All(f)       = sum(data.YearIncluded(f, :)); 
    AllNoCa(f)   = sum(data.YearAlive(f, :));  
    Man(f)       = sum(data.YearIncluded(f, data.Gender == 1));  
    ManNoCa(f)   = sum(data.YearAlive(f,    data.Gender == 1));  
    Woman(f)     = sum(data.YearIncluded(f, data.Gender == 2));  
    WomanNoCa(f) = sum(data.YearAlive(f,    data.Gender == 2)); 
end

Number = All(1);
All   = All/Number*100;   AllNoCa   = AllNoCa/Number*100;
Man   = Man/Number*100;   ManNoCa   = ManNoCa/Number*100;
Woman = Woman/Number*100; WomanNoCa = WomanNoCa/Number*100;

if DispFlag
    figure(h4), subplot(3,3,4)
    plot(0:99, All, 'k'), hold on                                                % year adapted
    plot(0:99, AllNoCa, '-.k'), plot(0:99, Man, 'b'), plot(0:99, ManNoCa, '-.b') % year adapted
    plot(0:99, Woman, 'r'),     plot(0:99, WomanNoCa, '-.r')                     % year adapted
    ylabel('% of all patients', 'fontsize', FontSz), xlabel('year', 'fontsize', FontSz)
    l = legend('all', 'excl. Ca', 'Man', 'excl. Ca', 'Woman', 'excl. Ca');
    set (l, 'fontsize', FontSz-2, 'location', 'northoutside')
    title('Survival', 'fontsize', FontSz)
    set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])
end
clear AllNoCa ManNoCa WomanNoCa Man Woman Number


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Sojourn Time       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SojournCancer = []; DwellCancer = []; DwellFastCancer = [];
AgeSojourn    = []; AgeDwellCa  = []; AgeDwellFastCa  = [];

for f=1:99
    SojournCancer   = [SojournCancer   data.TumorRecord.Sojourn(f, 1:find(data.TumorRecord.Sojourn(f, :), 1, 'last'))];
    DwellCancer     = [DwellCancer     data.DwellTimeProgression(f, 1:find(data.DwellTimeProgression(f, :), 1, 'last'))];
    DwellFastCancer = [DwellFastCancer data.DwellTimeFastCancer(f, 1:find(data.DwellTimeFastCancer(f, :), 1, 'last'))];
    AgeSojourn      = [AgeSojourn ones(1, find(data.TumorRecord.Sojourn(f, :), 1, 'last')) * f];
    AgeDwellCa      = [AgeDwellCa ones(1, length(find(data.DwellTimeProgression(f, :)))) * f];
    AgeDwellFastCa  = [AgeDwellFastCa ones(1, length(find(data.DwellTimeFastCancer(f, :)))) * f];
end

SojournDoc.SojournMedian       = median(SojournCancer); 
SojournDoc.SojournMean         = mean(SojournCancer);
SojournDoc.SojournLowQuart     = quantile(SojournCancer, 0.25);
SojournDoc.SojournUppQuart     = quantile(SojournCancer, 0.75);

% we record the time for overall cancer
AllTimeCa = cat(2, DwellCancer, DwellFastCancer);
AllTimeCa = AllTimeCa + mean(SojournCancer); % this is an approximation 
AllTimeDoc.AllTimeMedian       = median(AllTimeCa); 
AllTimeDoc.AllTimeMean         = mean(AllTimeCa);
AllTimeDoc.AllTimeLowQuart     = quantile(AllTimeCa, 0.25);
AllTimeDoc.AllTimeUppQuart     = quantile(AllTimeCa, 0.75);

AgeSojourn     = round((AgeSojourn + 4)/10) * 10;       % year adapted
AgeDwellCa     = round((AgeDwellCa + 4)/10) * 10;       % year adapted
AgeDwellFastCa = round((AgeDwellFastCa + 4)/10) * 10;   % year adapted

AllCancer = []; AllAge = []; 
for f=1:length(SojournCancer)
    AllCancer = [AllCancer SojournCancer(f)];
    AllCancer = [AllCancer SojournCancer(f)];
    AllAge{end +1} = 'all'; 
    AllAge{end +1} = num2str(AgeSojourn(f));
end
        
if DispFlag
    subplot(3,3,8)
    boxplot(AllCancer, AllAge)
    ylabel('years', 'fontsize', FontSz), xlabel('decade', 'fontsize', FontSz)
    title('sojourn time', 'fontsize', FontSz)
    set(gca, 'fontsize', FontSz)
end

% we assume sojourn time 3 years, this is hard coded
if DispFlag
    line([1 10], [3 3], 'color', 'r', 'linestyle', ':')
    set(gca,'fontsize',6);
end

SojournDoc.MedianAllCa       = median(AllCancer); 
SojournDoc.MeanAllCa         = mean(AllCancer);
SojournDoc.LowQuartAllCa     = quantile(AllCancer, 0.25);
SojournDoc.UppQuartAllCa     = quantile(AllCancer, 0.75);
clear SojournCancer AgeSojourn  AllCancer AllAge tmp tmp2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Adenoma Dwell Time   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AllDwellCa     = []; AllAgeDwellCa     = []; 
AllDwellFastCa = []; AllAgeDwellFastCa = []; 
for f=1:length(DwellCancer)
    AllDwellCa            = [AllDwellCa DwellCancer(f)];
    AllDwellCa            = [AllDwellCa DwellCancer(f)];
    AllAgeDwellCa{end +1} = 'all'; 
    AllAgeDwellCa{end +1} = num2str(AgeDwellCa(f));
end
for f=1:length(DwellFastCancer)
    AllDwellFastCa            = [AllDwellFastCa DwellFastCancer(f)];
    AllDwellFastCa            = [AllDwellFastCa DwellFastCancer(f)];
    AllAgeDwellFastCa{end +1} = 'all'; 
    AllAgeDwellFastCa{end +1} = num2str(AgeDwellFastCa(f));
end

DwellTimeAllCa          = median([AllDwellCa AllDwellFastCa]);
DwellTimeProgressedCa   = median(AllDwellCa);
DwellTimeFastCa         = median(AllDwellFastCa);

DwellDoc.MedianAllCa       = median([AllDwellCa AllDwellFastCa]); 
DwellDoc.MeanAllCa         = mean([AllDwellCa AllDwellFastCa]);
DwellDoc.LowQuartAllCa     = quantile([AllDwellCa AllDwellFastCa], 0.25);
DwellDoc.UppQuartAllCa     = quantile([AllDwellCa AllDwellFastCa], 0.75);

DwellDoc.MedianFastCa      = median(AllDwellFastCa); 
DwellDoc.MeanFastCa        = mean(AllDwellFastCa);
DwellDoc.LowQuartFastCa    = quantile(AllDwellFastCa, 0.25);
DwellDoc.UppQuartFastCa    = quantile(AllDwellFastCa, 0.75);

DwellDoc.MedianProgCa      = median(AllDwellCa); 
DwellDoc.MeanProgCa        = mean(AllDwellCa);
DwellDoc.LowQuartProgCa    = quantile(AllDwellCa, 0.25);
DwellDoc.UppQuartProgCa    = quantile(AllDwellCa, 0.75);

DwellString{1} = sprintf('median dwell time all ca: %.2f', DwellTimeAllCa); 
DwellString{2} = sprintf('median dwell time progressed ca: %.2f', DwellTimeProgressedCa); 
DwellString{3} = sprintf('median dwell time fast ca: %.2f', DwellTimeFastCa);  
DwellString{4} = ['avg dwell time all ca: ' num2str(round(mean([AllDwellCa AllDwellFastCa])*10)/10)]; 
DwellString{5} = ['avg dwell time progressed ca: ' num2str(round( mean(AllDwellCa)*10)/10)];  
DwellString{6} = ['avg dwell time fast ca: ' num2str(round(mean(AllDwellFastCa)*10)/10)]; 

% we calculate again, using only diagnosed cancer
DwellTime   = data.TumorRecord.DwellTime(data.TumorRecord.Gender > 0);
SojournTime = data.TumorRecord.Sojourn(data.TumorRecord.Gender > 0);
OverallTime = DwellTime + SojournTime;

Doc.MedianDwellTime   = median(DwellTime);  
Doc.MeanDwellTime     = mean(DwellTime); 
Doc.LowQuartDwellTime = quantile(DwellTime, 0.25); 
Doc.UpQuartDwellTime  = quantile(DwellTime, 0.75); 

Doc.MedianSojournTime    = median(SojournTime);  
Doc.MeanSojournTime      = mean(SojournTime); 
Doc.LowQuartSojournTime  = quantile(SojournTime, 0.25); 
Doc.UpQuartSojournTime   = quantile(SojournTime, 0.75); 

Doc.MedianOverAllTime    = median(OverallTime); 
Doc.MeanOverAllTime      = mean(OverallTime); 
Doc.LowQuartOverAllTime  = quantile(OverallTime, 0.25);  
Doc.UpQuartOverAllTime   = quantile(OverallTime, 0.75); 

if DispFlag
    figure(h3), subplot(3,3,8)
    boxplot([AllDwellCa AllDwellFastCa], [AllAgeDwellCa AllAgeDwellFastCa])
    FigureLabel = sprintf('median dwell time all ca: %.2f', DwellTimeAllCa);
    hold on, text(2, 70, FigureLabel, 'FontSize', 12)
    ylabel('years', 'fontsize', FontSz), xlabel('decade', 'fontsize', FontSz)
    title('dwell time all Ca', 'fontsize', FontSz)
    set(gca, 'fontsize', 6)
end

BM.DwellTime = (round(DwellTimeAllCa*10)/10);

BM.description{bmc} = 'dwell time diagnosed cancer'; 
BM.value{bmc}       = BM.DwellTime;
BM.flag{bmc}        = 'black';
BM.benchmark{bmc}   = 0;
bmc                 = bmc + 1;

clear AllDwellCa AllAgeDwellCa AgeDwellCa tmp tmp2
clear AllDwellFastCa AllAgeDwellFastCa AgeDwellFastCa
clear DwellTime SojournTime OverallTime


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Adenoma, cancer in (screening) population       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Polyp_40_49 = [];
for f=41:50, tmp = data.NumPolyps(f,:); % year adapted
    Polyp_40_49 = cat(2, Polyp_40_49, tmp(tmp>0)); end 
Polyp_50_59 = [];
for f=51:60, tmp = data.NumPolyps(f,:); % year adapted
    Polyp_50_59 = cat(2, Polyp_50_59, tmp(tmp>0)); end 
Polyp_60_69 = [];
for f=61:70, tmp = data.NumPolyps(f,:); % year adapted
    Polyp_60_69 = cat(2, Polyp_60_69, tmp(tmp>0)); end 
Polyp_70_79 = [];
for f=71:80, tmp = data.NumPolyps(f,:); % year adapted
    Polyp_70_79 = cat(2, Polyp_70_79, tmp(tmp>0)); end 
Polyp_80_89 = [];
for f=81:90, tmp = data.NumPolyps(f,:); % year adapted
    Polyp_80_89 = cat(2, Polyp_80_89, tmp(tmp>0)); end 

String = cell(16, 1); 
String{1}=sprintf('summary number polyps');
String{2}=sprintf('');
String{3}=sprintf('40-49y: %g (%g)', round(mean(Polyp_40_49)*100)/100, round(std(Polyp_40_49)*100)/100);
String{4}=sprintf('50-59y: %g (%g)', round(mean(Polyp_50_59)*100)/100, round(std(Polyp_50_59)*100)/100);
String{5}=sprintf('60-69y: %g (%g)', round(mean(Polyp_60_69)*100)/100, round(std(Polyp_60_69)*100)/100);
String{6}=sprintf('70-79y: %g (%g)', round(mean(Polyp_70_79)*100)/100, round(std(Polyp_70_79)*100)/100);
String{7}=sprintf('80-89y: %g (%g)', round(mean(Polyp_80_89)*100)/100, round(std(Polyp_80_89)*100)/100); 

% we give a summary of the screening population 50-80 years of age
tmp = 0; Polyp = 0; AdvPolyp = 0; Cancer = 0;
for f=51:81; % year adapted
    tmp      = tmp      + sum(data.YearIncluded(f, :)); 
    Polyp    = Polyp    + sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1) > 0);
    AdvPolyp = AdvPolyp + sum(data.MaxPolyps(f, data.YearIncluded(f, :)==1) > 4);
    Cancer   = Cancer   + sum(data.MaxCancer(f, data.YearIncluded(f, :)==1) > 6);
end

String{8}='';
String{9}=sprintf('screening population (50-80y)');
String{10}=sprintf('');
String{11}=sprintf('adenoma prevalvence   : %g%%' , round(Polyp/tmp*1000)/10);
String{12}=sprintf('advanced adenoma prev.:%g%%', round(AdvPolyp/tmp*1000)/10);
String{13}=sprintf('carcinoma prevalence:%g%%', round(Cancer/tmp*1000)/10);
if DispFlag
    figure(h2), subplot(3,3,7), axis off
    text(0, 0.6, String, 'Interpreter', 'none', 'FontSize', FontSz-2), hold on
end

BM.Preval = [round(Polyp/tmp*1000)/10, round(AdvPolyp/tmp*1000)/10, round(Cancer/tmp*1000)/10];
clear String tmp Polyp AdvPolyp Cancer Polyp_40_49 Polyp_50_59 Polyp_60_69 Polyp_70_79 Polyp_80_89

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% number polyps age graph  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we summarize the number of polyps
for f=1:y
    FivePolyps(f) = sum(data.NumPolyps(f,:) > 4); 
    FourPolyps(f) = sum(data.NumPolyps(f,:) > 3);
    ThreePolyps(f)= sum(data.NumPolyps(f,:) > 2); 
    TwoPolyps(f)  = sum(data.NumPolyps(f,:) > 1); 
    OnePolyp(f)   = sum(data.NumPolyps(f,:) > 0); 
end

% these data are for the next plot which uses uncorrected numbers (at least
% one polyp... we summarize the population of different ages
NumYoung = 0; NumMid = 0; NumOld = 0; NumAllAges = 0;
for f=41:55;  NumYoung = NumYoung+sum(data.YearIncluded(f, :)); end % year adapted
for f=56:75;  NumMid   = NumMid+sum(data.YearIncluded(f, :)); end   % year adapted
for f=76:91; NumOld   = NumOld+sum(data.YearIncluded(f, :)); end    % year adapted
for f=50:100;  NumAllAges = NumAllAges+sum(data.YearIncluded(f, :)); end % year adapted

YoungPop(1) = sum(OnePolyp(41:55))/NumYoung;    MidPop(1) = sum(OnePolyp(56:75))/NumMid;   OldPop(1)  = sum(OnePolyp(76:91))/NumOld;   % year adapted
YoungPop(2) = sum(TwoPolyps(41:55))/NumYoung;   MidPop(2) = sum(TwoPolyps(56:75))/NumMid;   OldPop(2) = sum(TwoPolyps(76:91))/NumOld;  % year adapted
YoungPop(3) = sum(ThreePolyps(41:55))/NumYoung; MidPop(3) = sum(ThreePolyps(56:75))/NumMid; OldPop(3) = sum(ThreePolyps(76:91))/NumOld;% year adapted
YoungPop(4) = sum(FourPolyps(41:55))/NumYoung;  MidPop(4) = sum(FourPolyps(56:75))/NumMid;  OldPop(4) = sum(FourPolyps(76:91))/NumOld; % year adapted
YoungPop(5) = sum(FivePolyps(41:55))/NumYoung;  MidPop(5) = sum(FivePolyps(56:75))/NumMid;  OldPop(5) = sum(FivePolyps(76:91))/NumOld; % year adapted
YoungPop = YoungPop*100; MidPop = MidPop*100; OldPop = OldPop*100;
BM.YoungPop=YoungPop;BM.MidPop=MidPop;BM.OldPop=OldPop;

% we correct for multiple polyps
AllPolyps   = OnePolyp(1:100)/100;
OnePolyp    = OnePolyp - TwoPolyps;
TwoPolyps   = TwoPolyps - ThreePolyps;
ThreePolyps = ThreePolyps - FourPolyps;
FourPolyps  = FourPolyps  - FivePolyps;

if DispFlag
    figure(h2), subplot(3,3,3)
    plot(0:99, OnePolyp(1:100)./AllPolyps, 'color', 'r'), hold on
    plot(0:99, TwoPolyps(1:100)./AllPolyps, 'color', 'k')
    plot(0:99, ThreePolyps(1:100)./AllPolyps, 'color', 'b')
    plot(0:99, FourPolyps(1:100)./AllPolyps, 'color', 'g')
    plot(0:99, FivePolyps(1:100)./AllPolyps, 'color', 'm')
    set(gca, 'xlim', [0 100],  'fontsize', FontSz)
    xlabel('year'), ylabel('% of patients with adenomas', 'Fontsize', FontSz), title('number of adenomas', 'Fontsize', FontSz)
    l=legend('1 adenoma', '2 adenomas', '3 adenomas', '4 adenomas', '>4 adenomas');
    set(l, 'location', 'northoutside', 'fontsize', FontSz-1)
    set(gca, 'xlim', [0 100],  'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Number Polyps Frequency distribution    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

YoungBenchmark = Variables.Benchmarks.MultiplePolypsYoung;
MidBenchmark   = Variables.Benchmarks.MultiplePolyp;
OldBenchmark   = Variables.Benchmarks.MultiplePolypsOld;

BM.OutputValues.YoungPop = YoungPop; BM.OutputValues.MidPop = MidPop; BM.OutputValues.OldPop = OldPop; 
% Young Population Plot
if DispFlag
    figure(h2), subplot(3,3,4)
    plot(YoungPop, '--ks','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',MarkerSz), hold on
    plot(YoungBenchmark,  '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
    xlabel('min number polyps', 'fontsize', FontSz); ylabel('% of population', 'fontsize', FontSz)
    set(gca, 'XTick', [1 2 3 4 5]), title('young population (40-54y)', 'fontsize', FontSz), set(gca, 'fontsize', FontSz)
end

if DispFlag
    figure(h2), subplot(3,3,5)
    % Intermediate Population Plot
    plot(MidPop,   '--ks','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','m', 'MarkerSize',MarkerSz), hold on
    plot(MidBenchmark,    '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
    xlabel('min number polyps', 'fontsize', FontSz); ylabel('% of population', 'fontsize', FontSz)
    set(gca, 'XTick', [1 2 3 4 5]), title('intermediate population (55-74y)', 'fontsize', FontSz), set(gca, 'fontsize', FontSz)
end

for f=1:5
    BM.description{bmc} = ['middle ' num2str(f) ' polyp']; BM.value{bmc} = MidPop(f); BM.benchmark{bmc} = MidBenchmark(f); 
    if and(BM.value{bmc} > BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)))
        BM.flag{bmc} = 'green'; 
    else
        BM.flag{bmc} = 'red'; 
    end
    if DispFlag
        line([f-0.5 f+0.5], [BM.value{bmc} BM.value{bmc}], 'color', BM.flag{bmc})
        plot(f, BM.value{bmc}, '--ks', 'MarkerEdgeColor', BM.flag{bmc}, 'MarkerFaceColor', BM.flag{bmc}, 'MarkerSize',MarkerSz)
    end
    BM.OutputFlags.MidPop{f} = BM.flag{bmc};
    bmc =bmc+1;
end
if DispFlag
    figure(h2), subplot(3,3,6)
    % Old Population Plot
    plot(OldPop,   '--ks','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',MarkerSz), hold on
    plot(OldBenchmark,    '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
    xlabel('min number polyps', 'fontsize', FontSz); ylabel('% of population', 'fontsize', FontSz)
    set(gca, 'XTick', [1 2 3 4 5]), title('old population (75-90y)', 'fontsize', FontSz), set(gca, 'fontsize', FontSz)
    set(gca, 'fontsize', FontSz)
end
for f=1:5
    BM.description{bmc} = ['old ' num2str(f) ' polyp']; BM.value{bmc} = OldPop(f); BM.benchmark{bmc} = OldBenchmark(f); 
    if and(BM.value{bmc} > BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)))
        BM.flag{bmc} = 'green';  
    else
        BM.flag{bmc} = 'red'; 
    end
    if DispFlag
        line([f-0.5 f+0.5], [BM.value{bmc} BM.value{bmc}], 'color', BM.flag{bmc})
        plot(f, BM.value{bmc}, '--ks', 'MarkerEdgeColor', BM.flag{bmc}, 'MarkerFaceColor', BM.flag{bmc}, 'MarkerSize',MarkerSz)
    end
    bmc =bmc+1;
end
clear YoungPop MidPop OldPop YoungBenchmark MidBenchmark OldBenchmark
clear OnePolyp TwoPolyps ThreePolyps FourPolyps FivePolyps NumYoung NumMid NumOld AllPolyps


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Written Summary    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear SummaryVariable String
female = sum(data.Gender == 2);
 
SummaryVariable{1,1} = n;
SummaryVariable{2,1} = round(sum(data.DeathYear)/n*100)/100 -1;                          % year adapted
SummaryVariable{3,1} = round(sum(data.DeathYear(data.Gender==1))/(n-female)*100)/100 -1; % year adapted
SummaryVariable{4,1} = round(sum(data.DeathYear(data.Gender==2))/female*100)/100 -1;     % year adapted
SummaryVariable{5,1} = sum(data.Number.Screening_Colonoscopy);
SummaryVariable{6,1} = sum(data.Number.Symptoms_Colonoscopy);
SummaryVariable{7,1} = sum(data.Number.Follow_Up_Colonoscopy);
SummaryVariable{8,1} = sum(data.Number.RectoSigmo);
SummaryVariable{9,1} = sum(data.Number.FOBT);
SummaryVariable{10,1} = sum(data.Number.I_FOBT);
SummaryVariable{11,1} = sum(data.Number.Sept9);
SummaryVariable{12,1} = sum(data.Number.other);
SummaryVariable{13,1} = sum(data.DeathCause == 2);
SummaryVariable{14,1} = sum(data.NaturalDeathYear(data.DeathCause==2)...
    -data.DeathYear(data.DeathCause==2));
SummaryVariable{15,1} = sum(data.DeathCause == 3);
SummaryVariable{16,1} = sum(data.NaturalDeathYear(data.DeathCause==3)...
    -data.DeathYear(data.DeathCause==3));
SummaryVariable{17,1} = sum(sum(data.Money.AllCost(1:100)));
SummaryVariable{18,1} = DwellTimeAllCa;
SummaryVariable{19,1} = DwellTimeProgressedCa;
SummaryVariable{20,1} = DwellTimeFastCa;
%SummaryVariable{21,1} = SojournTimeAllCancer;

SummaryVariable{64,1} = Variables.Comment;
SummaryVariable{65,1} = Variables.Settings_Name;

SummaryVariable{56,1} = SojournDoc.SojournMedian;
SummaryVariable{57,1} = SojournDoc.SojournMean;
SummaryVariable{58,1} = SojournDoc.SojournLowQuart;
SummaryVariable{59,1} = SojournDoc.SojournUppQuart;

SummaryVariable{60,1} = AllTimeDoc.AllTimeMedian;
SummaryVariable{61,1} = AllTimeDoc.AllTimeMean;
SummaryVariable{62,1} = AllTimeDoc.AllTimeLowQuart;
SummaryVariable{63,1} = AllTimeDoc.AllTimeUppQuart;

SummaryVariable{44,1} = DwellDoc.MedianAllCa; % 44-47 AllCa
SummaryVariable{45,1} = DwellDoc.MeanAllCa;
SummaryVariable{46,1} = DwellDoc.LowQuartAllCa;
SummaryVariable{47,1} = DwellDoc.UppQuartAllCa;

SummaryVariable{48,1} = DwellDoc.MedianFastCa; % 48-51: fast Ca
SummaryVariable{49,1} = DwellDoc.MeanFastCa;
SummaryVariable{50,1} = DwellDoc.LowQuartFastCa;
SummaryVariable{51,1} = DwellDoc.UppQuartFastCa;

SummaryVariable{52,1} = DwellDoc.MedianProgCa; % 52-55 progressed Ca
SummaryVariable{53,1} = DwellDoc.MeanProgCa;
SummaryVariable{54,1} = DwellDoc.LowQuartProgCa;
SummaryVariable{55,1} = DwellDoc.UppQuartProgCa;

%Discounted years%
DisCountMask = zeros(101,1); %m 
DisCountMask(1:21)=1;
for ff=22:101 %m 
    DisCountMask(ff) = DisCountMask(ff-1)* 0.97;    %m 
end
for i=1:n
    Diff(i) = cumulativeDiscYears(floor(1+data.DeathYear(i)), floor(1+data.NaturalDeathYear(i)), DisCountMask );
end
% SummaryVariable{56,1} = sum(Diff(data.DeathCause==2));
% SummaryVariable{57,1} = sum(Diff(data.DeathCause==3));

String{1}=sprintf('population: %d patients', n);
String{2}=sprintf('age: all: %g, male: %g, female: %g', round(sum(data.DeathYear)/n*100)/100 -1,... % year adapted
    round(sum(data.DeathYear(data.Gender==1))/(n-female)*100)/100 -1,...                                            % year adapted
    round(sum(data.DeathYear(data.Gender==2))/female*100)/100 -1);                                                  % year adapted

String{3}=sprintf('%d screening colos performed', sum(data.Number.Screening_Colonoscopy));
String{4}=sprintf('%d symptom colos performed',   sum(data.Number.Symptoms_Colonoscopy));
String{5}=sprintf('%d follow up colos performed', sum(data.Number.Follow_Up_Colonoscopy));

String{6}=sprintf('%d custom tests performed',...
    sum(data.Number.RectoSigmo) + sum(data.Number.FOBT) + sum(data.Number.I_FOBT) + sum(data.Number.Sept9) + sum(data.Number.other));
String{7}=sprintf('%d patients died of CRC', sum(data.DeathCause == 2));
String{8}=sprintf('%g years lost to CRC', sum(data.NaturalDeathYear(data.DeathCause==2)...
                                                - data.DeathYear(data.DeathCause==2)));
String{9}=sprintf('%d pat. died due to colo', sum(data.DeathCause == 3));
String{10}=sprintf('%g years lost to colo', sum(data.NaturalDeathYear(data.DeathCause==3)...
                                                - data.DeathYear(data.DeathCause==3)));
String{11}=sprintf('%g total CRR rel costs', sum(sum(data.Money.AllCost)));                                            
String{12}=sprintf('comment: %s', Variables.Comment);
String{13}=sprintf('settings: %s', Variables.Settings_Name);

if DispFlag
    figure(h4), subplot(3,3,9), axis off
    text(0, 0.6, String, 'Interpreter', 'none', 'FontSize', FontSz-2)
end
clear String female

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Fast Cancer        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we summarize the instances of progression of fast cancer and progressed
% cancer per decade
for f=1:10
    Start=(f-1)*10+1;
    Ende =f*10;
    ProgressedCancer(f) = sum(data.ProgressedCancer(Start:Ende)); 
    FastCancer_1(f)     = sum(data.DirectCancer(1, Start:Ende)); % cancer derived from polyp p1
    FastCancer_2(f)     = sum(data.DirectCancer(2, Start:Ende)); % cancer derived from polyp p2
    FastCancer_3(f)     = sum(data.DirectCancer(3, Start:Ende)); % etc.
    FastCancer_4(f)     = sum(data.DirectCancer(4, Start:Ende));
    FastCancer_5(f)     = sum(data.DirectCancer(5, Start:Ende));
    FastCancer_x(f)     = sum(data.DirectCancer2(Start:Ende)); % cancer derived without precursor
end

AllCancer = ProgressedCancer + FastCancer_1 + FastCancer_2 + FastCancer_3 + FastCancer_4 + FastCancer_5 + FastCancer_x;
% we will later draw lines to visualize the whole cohort
Summary(1) = sum(FastCancer_1);
Summary(2) = Summary(1) + sum(FastCancer_2);
Summary(3) = Summary(2) + sum(FastCancer_3);
Summary(4) = Summary(3) + sum(FastCancer_4);
Summary(5) = Summary(4) + sum(FastCancer_5);
Summary(6) = Summary(5) + sum(FastCancer_x);
Summary = Summary/sum(AllCancer)*100;

PlotData = [FastCancer_1./AllCancer; FastCancer_2./AllCancer; FastCancer_3./AllCancer;...
    FastCancer_4./AllCancer; FastCancer_5./AllCancer; ProgressedCancer./AllCancer; FastCancer_x./AllCancer] *100;
PlotData(isnan(PlotData)) = 0; % we replace empty elements by zero

if DispFlag
    figure(h2), subplot(3,3,9)
    area(PlotData'), grid on, colormap summer, set(gca,'Layer','top')
    ylabel('% of all cancer', 'fontsize', FontSz), xlabel('decade', 'fontsize', FontSz)
    title('origin of cancer', 'fontsize', FontSz)
    set(gca, 'xlim', [0 10], 'ylim', [0 100], 'fontsize', FontSz)
    cm = colormap;
    cpos = [1  13 26 38 51 64]; % these are the positions in the colormap used for the graphs
    for f=1:5
        line ([0.1 4], [Summary(f) Summary(f)], 'color', cm(cpos(f), :))
    end
    l=legend('Adenoma 3mm', 'Adenoma 5mm', 'Adenoma 7mm', 'Adenoma 9mm', 'Adv Ad P5', 'Adv Ad P6', 'direct');
    set(l, 'location', 'northoutside', 'fontsize', 5)
end
% we save for later display as a benchmark
BM.CancerOriginArea    = PlotData';
BM.CancerOriginSummary = Summary;

for f=1:5
    value(f) = sum(data.DirectCancer(f, 1:100))/sum(data.AllPolyps(f,1:100))*100;
end
value(6) = sum(data.ProgressedCancer(1:100))/sum(data.AllPolyps(6,1:100))*100;


BenchMark = Variables.Benchmarks.Cancer.Fastcancer;
FastCancerValue     = value;
FastCancerBenchMark = BenchMark;    

% we correct and now talk about relative danger of each polyp
BenchMark = BenchMark./sum(BenchMark)*100;

% we correct to relative danger
value = value./ sum(value)*100;
% we save for later display as a benchmark
BM.CancerOriginValue   = value;
% if DispFlag
%     subplot(3,3,9)
%     bar(cat(2, value', zeros(6,1), BenchMark')', 'stacked'), hold on
%     l=legend('P1', 'P2', 'P3', 'P4', 'P5', 'P6');
%     set(l, 'location', 'Eastoutside', 'fontsize', 6)
% end
ypos = 0;
for f=1:6
    BM.description{bmc} = ['%P' num2str(f) ' transforming']; BM.value{bmc} = value(f); BM.benchmark{bmc} = BenchMark(f); 
    if and(BM.value{bmc} > BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)))
        BM.flag{bmc} = 'green';    
    else
        BM.flag{bmc} = 'red';
    end
    if DispFlag
        line([1.5 2.5], [(ypos + value(f)/2) (ypos + value(f)/2)], 'color', BM.flag{bmc})
    end
    ypos = ypos + value(f);
    % we save for later display as a benchmark
    BM.CancerOriginFlag{f} = BM.flag{bmc};
    bmc = bmc + 1;
end
% if DispFlag
%     ylabel('relative danger of polyps', 'fontsize', 6)
%     set(gca, 'xticklabel', {'polyps' '' 'benchmark'}, 'fontsize', 6, 'yscale', 'log')
% end
clear PlotData cm Summary FastCancer_1 FastCancer_2 FastCancer_3 FastCancer_4
clear FastCancer_5 AllCancer Start Ende value BenchMark


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Stage Distribution   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for x=1:3
    clear Cis Stage_I Stage_II Stage_III Stage_IV population
    switch x
        case 1
            headline = 'stage distribution screening';
            tmp = data.TumorRecord.Stage;
            tmp(~(data.TumorRecord.Detection == 1)) = 0;
            benchmark = Variables.Benchmarks.Cancer.ScreeningStageDistribution;
        case 2
            headline = 'stage distribution symptomatic cancer';
            tmp = data.TumorRecord.Stage;
            tmp(~(data.TumorRecord.Detection == 2)) = 0;
            benchmark = Variables.Benchmarks.Cancer.SymptomaticStageDistribution;
        case 3
            headline = 'stage distribution follow up';
            tmp = data.TumorRecord.Stage;
            tmp(~(data.TumorRecord.Detection == 3)) = 0;
            benchmark = Variables.Benchmarks.Cancer.ScreeningStageDistribution;
    end
    population(1, :) = [sum(sum(tmp(1:50,:)==7))   sum(sum(tmp(1:50,:)==8))   sum(sum(tmp(1:50,:)==9))   sum(sum(tmp(1:50,:)==10))];  % year adapted
    population(2, :) = [sum(sum(tmp(51:60,:)==7))  sum(sum(tmp(51:60,:)==8))  sum(sum(tmp(51:60,:)==9))  sum(sum(tmp(51:60,:)==10))]; % year adapted
    population(3, :) = [sum(sum(tmp(61:70,:)==7))  sum(sum(tmp(61:70,:)==8))  sum(sum(tmp(61:70,:)==9))  sum(sum(tmp(61:70,:)==10))]; % year adapted
    population(4, :) = [sum(sum(tmp(71:80,:)==7))  sum(sum(tmp(71:80,:)==8))  sum(sum(tmp(71:80,:)==9))  sum(sum(tmp(71:80,:)==10))]; % year adapted
    population(5, :) = [sum(sum(tmp(81:90,:)==7))  sum(sum(tmp(81:90,:)==8))  sum(sum(tmp(81:90,:)==9))  sum(sum(tmp(81:90,:)==10))]; % year adapted
    population(6, :) = [sum(sum(tmp(91:100,:)==7)) sum(sum(tmp(91:100,:)==8)) sum(sum(tmp(91:100,:)==9)) sum(sum(tmp(91:100,:)==10))]; % year adapted
    population(7, :) = [sum(sum(tmp(1:100,:)==7))  sum(sum(tmp(1:100,:)==8))  sum(sum(tmp(1:100,:)==9))  sum(sum(tmp(1:100,:)==10))]; % year adapted
    
    if isequal(x, 1)
        SummaryVariable{22} = population(7, 1); SummaryVariable{23} = population(7, 2); 
        SummaryVariable{24} = population(7, 3); SummaryVariable{25} = population(7, 4);
    elseif isequal(x, 2)
        SummaryVariable{26} = population(7, 1); SummaryVariable{27} = population(7, 2); 
        SummaryVariable{28} = population(7, 3); SummaryVariable{29} = population(7, 4);
    end
    
    for f=1:7
        population(f, :) = population(f, :)/sum(population(f, :))*100; 
    end
    population(8, :) = [0   0    0    0];
    population(9, :) = benchmark;
    if DispFlag
        figure(h3), subplot(3,3,x)
        bar(population, 'stacked'), hold on
        l=legend('Stage I', 'Stage II', 'Stage III', 'Stage IV');
        set(l, 'location', 'Northoutside', 'fontsize', 6)
        xlabel('year', 'fontsize', 6), ylabel('% of affected patients', 'fontsize', 6)
        set(gca, 'xticklabel', {'<50' '50+' '60+' '70+' '80+' '90+' 'all' ''  'b-mark'}, 'fontsize', 5, 'ylim', [0 100])
        title(headline, 'fontsize', FontSz)
    end
    if isequal(x,2)
        ypos = 0;
        for f=1:4
            BM.description{bmc} = ['% stage ' num2str(f)]; BM.value{bmc} = population(7, f);
            BM.benchmark{bmc} = benchmark(f); 
            if and(BM.value{bmc} > BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)))
                BM.flag{bmc} = 'green';
            else
                BM.flag{bmc} = 'red';
            end
            if DispFlag
                line([7.5 8.5], [(ypos + BM.value{bmc}/2) (ypos + BM.value{bmc}/2)], 'color', BM.flag{bmc})
            end
            ypos = ypos + BM.value{bmc};
            bmc = bmc + 1;
        end
    end
end

stage_I   = sum(sum(data.TumorRecord.Stage == 7));
stage_II  = sum(sum(data.TumorRecord.Stage == 8));
stage_III = sum(sum(data.TumorRecord.Stage == 9));
stage_IV  = sum(sum(data.TumorRecord.Stage == 10));

Summe = sum(sum(data.TumorRecord.Stage >0));
SummaryVariable{30} = stage_I/Summe*100;   SummaryVariable{31} = stage_II/Summe*100; 
SummaryVariable{32} = stage_III/Summe*100; SummaryVariable{33} = stage_IV/Summe*100;

SummaryVariable{34} = stage_I;   SummaryVariable{35} = stage_II; 
SummaryVariable{36} = stage_III; SummaryVariable{37} = Summe;

SummaryVariable{38} = sum(sum(data.TumorRecord.Detection==1));   
SummaryVariable{39} = sum(sum(data.TumorRecord.Detection==2));  
SummaryVariable{40} = sum(sum(data.TumorRecord.Detection==3)); 
SummaryVariable{41} = sum(sum(data.TumorRecord.Detection==4)); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Cause of Death     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edges = [0 9.1 19.1 29.1 39.1 49.1 59.1 69.1 79.1 89.1 150]; % year adapted
NaturalDeath    = histc(data.DeathYear(data.DeathCause == 1), edges); 
CancerDeath     = histc(data.DeathYear(data.DeathCause == 2), edges); 
ColonoscDeath   = histc(data.DeathYear(data.DeathCause == 3), edges); 

if DispFlag
    figure(h4), subplot(3, 3, 5)
    bar(NaturalDeath, 'b'), hold on
    bar(CancerDeath, 'r')
    bar(ColonoscDeath, 'k')
    set(gca, 'yscale', 'log', 'xlim', [1 10],...
        'XTickLabel', {'1', '2', '3' '4' '5' '6' '7' '8' '9' '10+'}, 'fontsize', FontSz)
    xlabel('decade', 'fontsize', FontSz), ylabel('number patients', 'fontsize', FontSz)
    title('cause of death', 'fontsize', FontSz)
    l=legend('natural', 'cancer', 'colonoscopy');
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Colonoscopies      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    figure(h4), subplot(3, 3, 6)
    plot(0:99, data.Number.Symptoms_Colonoscopy(1:100), 'k'), hold on
    plot(0:99, data.Number.Screening_Colonoscopy(1:100), 'r')
    plot(0:99, data.Number.Follow_Up_Colonoscopy(1:100), 'b')
    plot(0:99, data.Number.Baseline_Colonoscopy(1:100), 'c')
    set(gca, 'yscale', 'log',  'fontsize', FontSz)
    xlabel('year', 'fontsize', FontSz), ylabel('number patients', 'fontsize', FontSz)
    title('reasons for colonoscopies', 'fontsize', FontSz)
    l=legend('symptoms', 'screening', 'follow up', 'baseline');
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Adenomas Removed     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    figure(h4), subplot(3, 3, 7)
    plot(0:99, data.EarlyPolypsRemoved(1:100), 'r'),  hold on
    plot(0:99, data.AdvancedPolypsRemoved(1:100), 'k')
    set(gca, 'fontsize', FontSz)
    l=legend('early', 'advanced');
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
    xlabel('year', 'fontsize', FontSz), ylabel('number adenomas', 'fontsize', FontSz)
    title('adenomas removed', 'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Dollars spent per person     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    figure(h4), subplot(3, 3, 8)
    tmp=sum(data.Money.AllCost,2); plot(0:99, tmp(1:100)/n, 'g'),  hold on
    tmp=sum(data.Money.Treatment,2); plot(0:99, tmp(1:100)/n, 'k')
    tmp=sum(data.Money.FollowUp,2); plot(0:99, tmp(1:100)/n, 'b')
    tmp=sum(data.Money.Screening,2); plot(0:99, tmp(1:100)/n, 'r')
    
    set(gca, 'fontsize', FontSz)
    xlabel('year', 'fontsize', FontSz), ylabel('US Dollar', 'fontsize', FontSz)
    title('dollars spent per person', 'fontsize', FontSz)
    l=legend('all cost', 'treatment', 'follow up', 'screening');
    set(l, 'location', 'northoutside', 'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Location           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp_all    = data.TumorRecord.Stage;
tmp_male   = data.TumorRecord.Gender == 1;
tmp_female = data.TumorRecord.Gender == 2;

tmp_Rectum = data.TumorRecord.Stage;
tmp_Rectum(data.TumorRecord.Location <13) = 0;
tmp_Right  = data.TumorRecord.Stage;
tmp_Right(data.TumorRecord.Location >3) = 0;
tmp_Rest   = data.TumorRecord.Stage;
tmp_Rest(data.TumorRecord.Location ==13) = 0;
tmp_Rest(data.TumorRecord.Location <4) = 0;

for f=1:4
    Sum_Stage_all(f)    = sum(sum(tmp_all==f+6));
    Sum_Stage_Rectum(f) = sum(sum(tmp_Rectum==f+6));
    Sum_Stage_Right(f)  = sum(sum(tmp_Right==f+6));
    Sum_Stage_Rest(f)   = sum(sum(tmp_Rest==f+6));
end

tmp_Rectum_male  = tmp_Rectum>0;
tmp_Rectum_male(tmp_female) = 0;
tmp_Rest_male    = tmp_Rest>0;
tmp_Rectum_male(tmp_female) = 0;
tmp_all_male     = tmp_all >0;%m
tmp_all_male(tmp_female) = 0; %m

tmp_Rectum_female  = tmp_Rectum>0;
tmp_Rectum_female(tmp_male) = 0;
tmp_Rest_female    = tmp_Rest>0;
tmp_Rectum_female(tmp_male) = 0;
tmp_all_female     = tmp_all >0;%m
tmp_all_female(tmp_male) = 0; %m

clear value x 
for f=1:100
    LocationRectum{1}(f) = sum(tmp_Rectum_male(f,:));
    LocationRest{1}(f)   = sum(tmp_Rest_male(f,:));
    LocationRectum{2}(f) = sum(tmp_Rectum_female(f,:));
    LocationRest{2}(f)   = sum(tmp_Rest_female(f,:));
    LocationAll{1}(f)    = sum(tmp_all_male(f,:));
    LocationAll{2}(f)    = sum(tmp_all_female(f,:));
end
%m for calculating the percentage of rectal cancer. This percentage is used

%%% benchmarks
LocBenchmarkMale   = Variables.Benchmarks.Cancer.LocationRectumMale;
LocBenchmarkFemale = Variables.Benchmarks.Cancer.LocationRectumFemale;
LocX               = Variables.Benchmarks.Cancer.LocationRectumYear;
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% carcinoma rectum both genders                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we average the male and female benchmarks
% here we only collect the data for display during adjustment of adenomas
BM.LocationRectumAllGender = (LocationRectum{1}(1:100) + LocationRectum{2}(1:100))/2;
BM.LocationRest            = (LocationRest{1}(1:100) + LocationRest{2}(1:100))/2;
BM.LocBenchmark            = (LocBenchmarkMale + LocBenchmarkFemale)/2; 
BM.LocX                    = LocX;

for f=1:length(BM.LocX)
    x(f)     = mean(BM.LocX{f}(1):BM.LocX{f}(2));
    value(f) = sum(BM.LocationRectumAllGender((BM.LocX{f}(1)-2):(BM.LocX{f}(2)+2)))/...
        (sum(BM.LocationRectumAllGender((LocX{f}(1)-2):(LocX{f}(2)+2))) + sum(BM.LocationRest((BM.LocX{f}(1)-2):(BM.LocX{f}(2)+2))))*100;
    if and(value(f) > BM.LocBenchmark(f)*(1 - tolerance), value(f) < (BM.LocBenchmark(f)*(1 + tolerance)))
        tmpflag = 'green';
    else
        tmpflag = 'red';
    end
    if or(isequal(f, 2), isequal(f, 3))
        BM.description{bmc} = ['% rectum Ca year ' num2str(LocX{f}(1)) ' to ' num2str(LocX{f}(2))];
        BM.flag{bmc} = tmpflag;
        BM.benchmark{bmc} = BM.LocBenchmark(f); 
        BM.value{bmc} = value(f);
        BM.LocationRectumFlag{f} = tmpflag;
        bmc = bmc + 1;
    else
        BM.LocationRectumFlag{f} = 'black';
    end
        BM.LocationRectum(f)     = value(f);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% carcinoma rectum male                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    figure (h3), subplot(3, 3, 5)
    plot(0:99, LocationRectum{1}(1:100)./ (LocationRectum{1}(1:100) + LocationRest{1}(1:100))*100, 'color', 'k'), hold on
end
for f=1:length(LocX)
    x(f)     = mean(LocX{f}(1):LocX{f}(2));
    value(f) = sum(LocationRectum{1}((LocX{f}(1)-2):(LocX{f}(2)+2)))/(sum(LocationRectum{1}((LocX{f}(1)-2):(LocX{f}(2)+2))) + sum(LocationRest{1}((LocX{f}(1)-2):(LocX{f}(2)+2))))*100;
    if and(value(f) > LocBenchmarkMale(f)*(1 - tolerance), value(f) < (LocBenchmarkMale(f)*(1 + tolerance)))
        tmpflag = 'green';
    else
        tmpflag = 'red';
    end
    if DispFlag
        line(LocX{f}, [value(f) value(f)], 'color', tmpflag)
        plot(x(f), value(f), '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', tmpflag, 'MarkerSize',MarkerSz)
    end
    if or(isequal(f, 2), isequal(f, 3))
        BM.description{bmc} = ['% rectum Ca year male ' num2str(LocX{f}(1)) ' to ' num2str(LocX{f}(2))];
        BM.flag{bmc} = tmpflag;
        BM.benchmark{bmc} = LocBenchmarkMale(f); 
        BM.value{bmc} = value(f);
        
        BM.Cancer.LocationRectumMale(f)     = BM.value{bmc};
        BM.Cancer.LocationRectumMaleYear(f) = LocX(f);
        bmc = bmc + 1;
    end
end
if DispFlag
    plot(x, value, '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',MarkerSz)
    plot(x, LocBenchmarkMale, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
    xlabel('year', 'fontsize', FontSz), ylabel('% rectum of all ca', 'fontsize', FontSz)
    set(gca, 'fontsize', FontSz), title('fraction rectum carcinoma male', 'fontsize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% carcinoma rectum female                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if DispFlag
    figure(h3), subplot(3, 3, 6)
    plot(0:99, LocationRectum{2}(1:100)./ (LocationRectum{2}(1:100) + LocationRest{2}(1:100))*100, 'color', 'k'), hold on
end
for f=1:length(LocX)
    x(f)     = mean(LocX{f}(1):LocX{f}(2));
    value(f) = sum(LocationRectum{2}((LocX{f}(1)-2):(LocX{f}(2)+2)))/(sum(LocationRectum{2}((LocX{f}(1)-2):(LocX{f}(2)+2))) + sum(LocationRest{2}((LocX{f}(1)-2):(LocX{f}(2)+2))))*100;
    if and(value(f) > LocBenchmarkFemale(f)*(1 - tolerance), value(f) < (LocBenchmarkFemale(f)*(1 + tolerance)))
        tmpflag = 'green';
    else
        tmpflag = 'red';
    end
    if DispFlag
        line(LocX{f}, [value(f) value(f)], 'color', tmpflag)
        plot(x(f), value(f), '--rs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', tmpflag, 'MarkerSize',MarkerSz)
    end
    if or(isequal(f, 2), isequal(f, 3))
        BM.description{bmc} = ['% rectum Ca year female ' num2str(LocX{f}(1)) ' to ' num2str(LocX{f}(2))];
        BM.flag{bmc} = tmpflag;
        BM.benchmark{bmc} = LocBenchmarkFemale(f); 
        BM.value{bmc} = value(f);
        
        BM.Cancer.LocationRectumFemale(f)     = BM.value{bmc};
        BM.Cancer.LocationRectumFemaleYear(f) = LocX(f);
        bmc = bmc + 1;
    end
end
if DispFlag
    plot(x, LocBenchmarkFemale, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
    xlabel('year', 'fontsize', FontSz), ylabel('% rectum of all ca', 'fontsize', FontSz)
    set(gca, 'fontsize', FontSz), title('fraction rectum carcinoma female', 'fontsize', FontSz)
end
clear value x LocBenchmarkFemale LocBenchmarkMale tmp_Rectum_female tmp_Rectum_male tmp_Rest_female tmp_Rest_male LocX


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% stage distribution location                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Summe = sum(Sum_Stage_all)/100;
PlotData = [Sum_Stage_all/Summe; Sum_Stage_Rectum/Summe; Sum_Stage_Right/Summe; Sum_Stage_Rest/Summe];
if DispFlag
    figure(h3), subplot(3, 3, 4)
    bar(PlotData, 'stacked') % NOT year adapted
    xlabel('year', 'fontsize', FontSz), ylabel('% of affected patients', 'fontsize', FontSz)
    set(gca, 'xticklabel', {'all' 'Rectum' 'Right' 'Rest'}, 'fontsize', FontSz-1)
    title('Stage distribution per location', 'fontsize', FontSz)
end

clear tmp_all tmp_Rectum tmp_Right tmp_Rest Ca_all Ca_Rectum Ca_Right Ca_Rest
clear Sum_all Sum_Rectum Sum_Right Sum_Rest Sum_Stage_all Sum_Stage_Rectum Sum_Stage_Right Sum_Stage_Rest Summe PlotData
clear Polyps_all AdvPolyps_all Polyps_right AdvPolyps_right Polyps_rest AdvPolyps_rest Polyps_rectum Polyps_rectum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% relative danger polyps                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

value     = FastCancerValue./sum(FastCancerValue)*100;
BenchMark = FastCancerBenchMark./sum(FastCancerBenchMark)*100;

String1{1} = 'Relative danger adenomas';
AdenomaLabel = {'Ad 3mm', 'Ad 3mm', 'Ad 3mm', 'Ad 3mm', 'Adv P5', 'Adv P6'};
for f=1:6
    BM.description{bmc} = [AdenomaLabel{f} num2str(f) ' relative danger']; BM.value{bmc} = value(f); BM.benchmark{bmc} = BenchMark(f); 
    String1{f+1}        = AdenomaLabel{f};
    String2{f+1}        = num2str(round(BM.value{bmc}*1000)/1000);
    String3{f+1}        = num2str(round(BM.benchmark{bmc}*1000)/1000);
    if and(BM.value{bmc} > BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)))
        BM.flag{bmc} = 'green';    
    else
        BM.flag{bmc} = 'red';
    end
    String4{f+1}        = BM.flag{bmc};
    bmc = bmc + 1;
end
if DispFlag
    figure(h2), subplot(3, 3, 8), axis off
    text(0,   0.8, String1, 'Interpreter', 'none', 'FontSize', FontSz-1), hold on
    text(0.3, 0.8, String2, 'Interpreter', 'none', 'FontSize', FontSz-1)
    text(0.6, 0.8, String3, 'Interpreter', 'none', 'FontSize', FontSz-1)
    text(0.9, 0.8, String4, 'Interpreter', 'none', 'FontSize', FontSz-1) 
    
%     figure(h2), subplot(3,3,9), axis off
%     clear String1 String2 String3 String4
%     text(0,   0.6, DwellString, 'Interpreter', 'none', 'FontSize', FontSz)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Cancer Mortality All/ Male/ Female   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear i j tmp3 tmp4 tmp5
DeathYear = floor(data.DeathYear);
for f1=1:3
    if ~isequal(f1, 3)
        tmp                       = DeathYear;
        tmp(~(data.Gender ==f1))    = 0;
        tmp(~(data.DeathCause ==2)) = 0; 
        for f2=1:y
            i(f2) = length(find(tmp == f2));
            j(f2) = sum(data.YearIncluded(f2, data.Gender ==f1));
        end
    else
        for f2=1:y
            tmp                       = DeathYear;
            tmp(~(data.DeathCause ==2)) = 0;
            i(f2) = length(find(tmp == f2));
            j(f2) = sum(data.YearIncluded(f2, :));
        end
    end
    tmp3 =  [sum(i(1:4)) sum(i(5:8))   sum(i(11:15))  sum(i(16:20)) sum(i(21:25)) sum(i(26:30))... % year adapted
      sum(i(31:35))   sum(i(36:40)) sum(i(41:45)) sum(i(46:50)) sum(i(51:55)) sum(i(56:60))...
      sum(i(61:65))   sum(i(66:70)) sum(i(71:75)) sum(i(76:80)) sum(i(81:85)) sum(i(86:90))];
    tmp4 = [sum(j(1:4)) sum(j(5:8))   sum(j(11:15))  sum(j(16:20)) sum(j(21:25)) sum(j(26:30))...
      sum(j(31:35))   sum(j(36:40)) sum(j(41:45)) sum(j(46:50)) sum(j(51:55)) sum(j(56:60))...
      sum(j(61:65))   sum(j(66:70)) sum(j(71:75)) sum(j(76:80)) sum(j(81:85)) sum(j(86:90))];
  
    for f=1:length(tmp3)
        tmp5(f) = tmp3(f)/tmp4(f);
    end
    Mortality{f1} = tmp5 *100000;
end

if DispFlag
    figure (h4)
end

% cancer mortality male
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Mortality{1}, bmc, BM, Variables.Benchmarks, 'Cancer', 'Ov_y_mort', 'Male_mort',...
    DispFlag, 1, 'Cancer mortality male year ', 'Cancer mortality per year male', tolerance, LineSz, MarkerSz, FontSz, 'per 100 000 per year', 'Cancer');  %#ok<ASGLU>

% cancer mortality female
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Mortality{2}, bmc, BM, Variables.Benchmarks, 'Cancer', 'Ov_y_mort', 'Female_mort',...
    DispFlag, 2, 'Cancer mortality female year ', 'Cancer mortality per year female', tolerance, LineSz, MarkerSz, FontSz, 'per 100 000 per year', 'Cancer');  %#ok<ASGLU>

% cancer mortality overall
[BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(Mortality{3}, bmc, BM, Variables.Benchmarks, 'Cancer', 'Ov_y_mort', 'Ov_mort',...
    DispFlag, 3, 'Cancer mortality overall year ', 'Cancer mortality per year overall', tolerance, LineSz, MarkerSz, FontSz, 'per 100 000 per year', 'Cancer');  %#ok<ASGLU>


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Direct Cancer      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp_all    = sum(data.DirectCancer, 1)+data.DirectCancer2+data.ProgressedCancer;
tmp_right  = data.DirectCancerR+data.DirectCancer2R+data.ProgressedCancerR;

SumAll      = sum(tmp_all);
DirectAll   = sum(data.DirectCancer2);
SumRight    = sum(tmp_right);
DirectRight = sum(data.DirectCancer2R);

SummaryVariable{42,1} = round(DirectAll/SumAll*1000)/10;
SummaryVariable{43,1} = round(DirectRight/SumRight*1000)/10;

if DispFlag
    figure (h3)
    subplot(3, 3, 7)
    bar([DirectAll/SumAll*100 DirectRight/SumRight*100])
    set(gca, 'ylim', [0 100])
    line ([0.25 2.75], [50 50], 'color', 'r')
    line ([0.25 2.75], [20 20], 'color', 'g')
    set(gca, 'xticklabel', {'all Ca' 'right side'}), ylabel('% direct cancer', 'fontsize', FontSz)
    set(gca, 'fontsize', FontSz), title('fraction of all carcinoma without polyp precursor', 'fontsize', FontSz-2)
end
BM.Graph.DirectCa.All   = DirectAll/SumAll*100;
BM.Graph.DirectCa.Right = DirectRight/SumRight*100;

BM.description{bmc} = 'fraction of all carcinoma without polyp precursor all'; 
BM.value{bmc}       = SummaryVariable{42,1};
BM.flag{bmc}        = 'black';
BM.benchmark{bmc}   = 0;
bmc                 = bmc + 1;

BM.description{bmc} = 'fraction of all carcinoma without polyp precursor right'; 
BM.value{bmc}       = SummaryVariable{43,1};
BM.flag{bmc}        = 'black';
BM.benchmark{bmc}   = 0;
bmc                 = bmc + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Live Years Lost     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we need to calculate life years lost for each year of the
% simulation for subsequent discounting
LY_Ca_Temp   = zeros(sum(data.DeathCause == 2), 101); 
LY_Colo_Temp = zeros(sum(data.DeathCause == 3), 101);
Ca_Counter  = 1; Colo_Counter  = 1;
for f=1:n
    if isequal(data.DeathCause(f), 2)
        tmp1 = zeros(1, 101); tmp2 = zeros(1, 101); 
        tmp1(1:floor(data.NaturalDeathYear(f))) = 1;
        if (data.NaturalDeathYear(f) - floor(data.NaturalDeathYear(f))) >0
            tmp1(floor(data.NaturalDeathYear(f))+1) = data.NaturalDeathYear(f)- floor(data.NaturalDeathYear(f));
        end
        tmp2(1:floor(data.DeathYear(f))) = 1;
        if (data.DeathYear(f) - floor(data.DeathYear(f))) >0
            tmp2(floor(data.DeathYear(f))+1) = data.DeathYear(f)- floor(data.DeathYear(f));
        end
        LY_Ca_Temp(Ca_Counter, :) = tmp1 - tmp2;
        Ca_Counter = Ca_Counter+1;
    elseif isequal(data.DeathCause(f), 3)
        tmp1 = zeros(1, 101); tmp2 = zeros(1, 101); 
        tmp1(1:floor(data.NaturalDeathYear(f))) = 1;
        if (data.NaturalDeathYear(f) - floor(data.NaturalDeathYear(f))) >0
            tmp1(floor(data.NaturalDeathYear(f))+1) = data.NaturalDeathYear(f)- floor(data.NaturalDeathYear(f));
        end
        tmp2(1:floor(data.DeathYear(f))) = 1;
        if (data.DeathYear(f) - floor(data.DeathYear(f))) >0
            tmp2(floor(data.DeathYear(f))+1) = data.DeathYear(f)- floor(data.DeathYear(f));
        end
        LY_Colo_Temp(Colo_Counter, :) = tmp1 - tmp2;
        Colo_Counter = Colo_Counter+1;
    end
end

% we save results to the Results variable
Results.YearsLostCa   = sum(LY_Ca_Temp, 1);
Results.YearsLostColo = sum(LY_Colo_Temp, 1);
clear LY_Ca_Temp LY_Colo_Temp Ca_Counter Colo_Counter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Live Years Lost PBP    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% here we redo the calculation with a breakdown for different results according to
% PBP_Documentation (no adenoma, one, two adenoma or oder advanced adenoma

% we redo the  to calculate life years lost for each year of the
% simulation for subsequent discounting
LY_Ca_NoPolyp_Temp      = zeros(1, 101); 
LY_Ca_OnePolyp_Temp     = zeros(1, 101); 
LY_Ca_TwoPolyps_Temp    = zeros(1, 101); 
LY_Ca_AdvPolyp_Temp     = zeros(1, 101);  
LY_Ca_AdvScenario_Temp  = zeros(1, 101);  
LY_Ca_Cancer_Temp       = zeros(1, 101);  

LY_Colo_NoPolyp_Temp     = zeros(1, 101); 
LY_Colo_OnePolyp_Temp    = zeros(1, 101); 
LY_Colo_TwoPolyps_Temp   = zeros(1, 101); 
LY_Colo_AdvPolyp_Temp    = zeros(1, 101); 
LY_Colo_AdvScenario_Temp = zeros(1, 101); 
LY_Colo_Cancer_Temp      = zeros(1, 101); 

Ca_NoPolyp_Counter      = 1;
Ca_OnePolyp_Counter     = 1;
Ca_TwoPolyp_Counter     = 1;
Ca_AdvPolyp_Counter     = 1;
Ca_AdvScenario_Counter  = 1;
Ca_Cancer_Counter       = 1;

Colo_NoPolyp_Counter      = 1;
Colo_OnePolyp_Counter     = 1;
Colo_TwoPolyp_Counter     = 1;
Colo_AdvPolyp_Counter     = 1;
Colo_AdvScenario_Counter  = 1;
Colo_Cancer_Counter       = 1;

for f=1:n
    if or(isequal(data.DeathCause(f), 2), isequal(data.DeathCause(f), 3))
        if isequal(data.PBP_Doc.Screening(f), 1) % has undergone poor bowel prep colonoscopy
            tmp1 = zeros(1, 101); tmp2 = zeros(1, 101);
            tmp1(1:floor(data.NaturalDeathYear(f))) = 1;
            if (data.NaturalDeathYear(f) - floor(data.NaturalDeathYear(f))) > 0
                tmp1(floor(data.NaturalDeathYear(f))+1) = data.NaturalDeathYear(f)- floor(data.NaturalDeathYear(f));
            end
            tmp2(1:floor(data.DeathYear(f))) = 1;
            if (data.DeathYear(f) - floor(data.DeathYear(f))) >0
                tmp2(floor(data.DeathYear(f))+1) = data.DeathYear(f)- floor(data.DeathYear(f));
            end
            % death due to carcinoma
            if isequal(data.DeathCause(f), 2)
                if data.PBP_Doc.Cancer(f) > 0 % cancer found during poor bowel preparation screening
                    LY_Ca_Cancer_Temp(Ca_Cancer_Counter, :) = tmp1 - tmp2;
                    Ca_Cancer_Counter = Ca_Cancer_Counter+1;
                elseif data.PBP_Doc.Advanced(f) >0 % at least one adv. adenoma
                    LY_Ca_AdvPolyp_Temp(Ca_AdvPolyp_Counter, :) = tmp1 - tmp2;
                    Ca_AdvPolyp_Counter = Ca_AdvPolyp_Counter+1;
                elseif data.PBP_Doc.Early(f) >1 % two or more early adenoma
                    LY_Ca_TwoPolyps_Temp(Ca_TwoPolyp_Counter, :) = tmp1 - tmp2;
                    Ca_TwoPolyp_Counter = Ca_TwoPolyp_Counter+1;
                elseif isequal(data.PBP_Doc.Early(f), 1) % one early adenoma
                    LY_Ca_OnePolyp_Temp(Ca_OnePolyp_Counter, :) = tmp1 - tmp2;
                    Ca_OnePolyp_Counter = Ca_OnePolyp_Counter+1;
                else % no adenoma
                    LY_Ca_NoPolyp_Temp(Ca_NoPolyp_Counter, :) = tmp1 - tmp2;
                    Ca_NoPolyp_Counter = Ca_NoPolyp_Counter+1;
                end
                if (data.PBP_Doc.Cancer(f) == 0) && ((data.PBP_Doc.Early(f) > 2) || (data.PBP_Doc.Advanced(f) > 0)) 
                    % i.e. more than two early adenoma OR one advanced
                    % adenoma
                    LY_Ca_AdvScenario_Temp(Ca_AdvScenario_Counter, :) = tmp1 - tmp2;
                    Ca_AdvScenario_Counter = Ca_AdvScenario_Counter+1;
                end
                % death due to colonoscopy
            elseif isequal(data.DeathCause(f), 3)
                if data.PBP_Doc.Cancer(f) > 0 % cancer found during poor bowel preparation screening
                    LY_Colo_Cancer_Temp(Colo_Cancer_Counter, :) = tmp1 - tmp2;
                    Colo_Cancer_Counter = Colo_Cancer_Counter+1;
                elseif data.PBP_Doc.Advanced(f) >0 % at least one adv. adenoma
                    LY_Colo_AdvPolyp_Temp(Colo_AdvPolyp_Counter, :) = tmp1 - tmp2;
                    Colo_AdvPolyp_Counter = Colo_AdvPolyp_Counter+1;
                elseif data.PBP_Doc.Early(f) >1 % two or more early adenoma
                    LY_Colo_TwoPolyps_Temp(Colo_TwoPolyp_Counter, :) = tmp1 - tmp2;
                    Colo_TwoPolyp_Counter = Colo_TwoPolyp_Counter+1;
                elseif data.PBP_Doc.Early(f) >1 % one early adenoma
                    LY_Colo_OnePolyp_Temp(Colo_OnePolyp_Counter, :) = tmp1 - tmp2;
                    Colo_OnePolyp_Counter = Colo_OnePolyp_Counter+1;
                else % no adenoma
                    LY_Colo_NoPolyp_Temp(Colo_NoPolyp_Counter, :) = tmp1 - tmp2;
                    Colo_NoPolyp_Counter = Colo_NoPolyp_Counter+1;
                end
                if (data.PBP_Doc.Cancer(f) == 0) && ((data.PBP_Doc.Early(f) > 2) || (data.PBP_Doc.Advanced(f) > 0))
                    % i.e. more than two early adenoma OR one advanced
                    % adenoma
                    LY_Colo_AdvScenario_Temp(Colo_AdvScenario_Counter, :) = tmp1 - tmp2;
                    Colo_AdvScenario_Counter = Colo_AdvScenario_Counter+1;
                end
            end
        end
        
        
    end
end

% we save results to the Results variable
Results.LY_Ca_NoPolyp     = sum(LY_Ca_NoPolyp_Temp, 1);
Results.LY_Ca_OnePolyp    = sum(LY_Ca_OnePolyp_Temp, 1);
Results.LY_Ca_TwoPolyps   = sum(LY_Ca_TwoPolyps_Temp, 1);
Results.LY_Ca_AdvPolyp    = sum(LY_Ca_AdvPolyp_Temp, 1);
Results.LY_Ca_AdvScenario = sum(LY_Ca_AdvScenario_Temp, 1);
Results.LY_Ca_Cancer      = sum(LY_Ca_Cancer_Temp, 1);

Results.LY_Colo_NoPolyp     = sum(LY_Colo_NoPolyp_Temp, 1);
Results.LY_Colo_OnePolyp    = sum(LY_Colo_OnePolyp_Temp, 1);
Results.LY_Colo_TwoPolyps   = sum(LY_Colo_TwoPolyps_Temp, 1);
Results.LY_Colo_AdvPolyp    = sum(LY_Colo_AdvPolyp_Temp, 1);
Results.LY_Colo_AdvScenario = sum(LY_Colo_AdvScenario_Temp, 1);
Results.LY_Colo_Cancer      = sum(LY_Colo_Cancer_Temp, 1);

Results.Ca_NoPolyp_Counter     = Ca_NoPolyp_Counter-1;
Results.Ca_OnePolyp_Counter    = Ca_OnePolyp_Counter-1;
Results.Ca_TwoPolyp_Counter    = Ca_TwoPolyp_Counter-1;
Results.Ca_AdvPolyp_Counter    = Ca_AdvPolyp_Counter-1;
Results.Ca_AdvScenario_Counter = Ca_AdvScenario_Counter-1;
Results.Ca_Cancer_Counter      = Ca_Cancer_Counter-1;

Results.Colo_NoPolyp_Counter     = Colo_NoPolyp_Counter-1;
Results.Colo_OnePolyp_Counter    = Colo_OnePolyp_Counter-1;
Results.Colo_TwoPolyp_Counter    = Colo_TwoPolyp_Counter-1;
Results.Colo_AdvPolyp_Counter    = Colo_AdvPolyp_Counter-1;
Results.Colo_AdvScenario_Counter = Colo_AdvScenario_Counter-1;
Results.Colo_Cancer_Counter      = Colo_Cancer_Counter-1;

Results.PBP_Doc_Early     = data.PBP_Doc.Early;
Results.PBP_Doc_Advanced  = data.PBP_Doc.Advanced;
Results.PBP_Doc_Cancer    = data.PBP_Doc.Cancer;
Results.PBP_Doc_Screening = data.PBP_Doc.Screening;

clear LY_Ca_NoPolyp_Temp LY_Ca_OnePolyp_Temp LY_Ca_TwoPolyps_Temp LY_Ca_AdvPolyp_Temp LY_Ca_Cancer_Temp  
clear LY_Colo_NoPolyp_Temp LY_Colo_OnePolyp_Temp LY_Colo_TwoPolyps_Temp LY_Colo_AdvPolyp_Temp LY_Colo_Cancer_Temp
clear Ca_Cancer_Counter Ca_AdvPolyp_Counter Ca_TwoPolyp_Counter Ca_OnePolyp_Counter Ca_NoPolyp_Counter
clear Colo_Cancer_Counter Colo_AdvPolyp_Counter Colo_TwoPolyp_Counter Colo_OnePolyp_Counter Colo_NoPolyp_Counter


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    USD - PBP              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% here we redo the calculation with a breakdown for different results according to
% PBP_Documentation (no adenoma, one, two adenoma or oder advanced adenoma

% we redo the calculations for USD for each year of the
% simulation for subsequent discounting
USD_NoPolyp_Temp      = zeros(100, 1); 
USD_OnePolyp_Temp     = zeros(100, 1); 
USD_TwoPolyps_Temp    = zeros(100, 1); 
USD_AdvPolyp_Temp     = zeros(100, 1);  
USD_AdvScenario_Temp  = zeros(100, 1);  
USD_Cancer_Temp       = zeros(100, 1);  

USD_NoPolyp_Counter      = 0;
USD_OnePolyp_Counter     = 0;
USD_TwoPolyp_Counter     = 0;
USD_AdvPolyp_Counter     = 0;
USD_AdvScenario_Counter  = 0;
USD_Cancer_Counter       = 0;

for f=1:n
    if isequal(data.PBP_Doc.Screening(f), 1) % has undergone poor bowel prep colonoscopy
        tmp = data.Money.Treatment(:, f) +  data.Money.Screening(:, f) + data.Money.FollowUp(:, f) + data.Money.Other(:, f);
        if data.PBP_Doc.Cancer(f) > 0 % cancer found during poor bowel preparation screening
            USD_Cancer_Temp      = USD_Cancer_Temp + tmp;
            USD_Cancer_Counter   = USD_Cancer_Counter+1;
        elseif data.PBP_Doc.Advanced(f) >0 % at least one adv. adenoma
            USD_AdvPolyp_Temp    = USD_AdvPolyp_Temp + tmp;
            USD_AdvPolyp_Counter = USD_AdvPolyp_Counter+1;
        elseif data.PBP_Doc.Early(f) >1 % two or more early adenoma
            USD_TwoPolyps_Temp   = USD_TwoPolyps_Temp + tmp;
            USD_TwoPolyp_Counter = USD_TwoPolyp_Counter+1;
        elseif isequal(data.PBP_Doc.Early(f), 1) % one early adenoma
            USD_OnePolyp_Temp    = USD_OnePolyp_Temp + tmp;
            USD_OnePolyp_Counter = USD_OnePolyp_Counter+1;
        else % no adenoma
            USD_NoPolyp_Temp     = USD_NoPolyp_Temp + tmp;
            USD_NoPolyp_Counter  = USD_NoPolyp_Counter+1;
        end
        if (data.PBP_Doc.Cancer(f) == 0) && ((data.PBP_Doc.Early(f) > 2) || (data.PBP_Doc.Advanced(f) > 0))
            % i.e. more than two early adenoma OR one advanced
            % adenoma
            USD_AdvScenario_Temp    = USD_AdvScenario_Temp + tmp;
            USD_AdvScenario_Counter = USD_AdvScenario_Counter+1;
        end
    end
end

% we save results to the Results variable
Results.USD_NoPolyp     = USD_NoPolyp_Temp;
Results.USD_OnePolyp    = USD_OnePolyp_Temp;
Results.USD_TwoPolyps   = USD_TwoPolyps_Temp;
Results.USD_AdvPolyp    = USD_AdvPolyp_Temp;
Results.USD_AdvScenario = USD_AdvScenario_Temp;
Results.USD_Cancer      = USD_Cancer_Temp;

Results.USD_NoPolyp_Counter     = USD_NoPolyp_Counter;
Results.USD_OnePolyp_Counter    = USD_OnePolyp_Counter;
Results.USD_TwoPolyp_Counter    = USD_TwoPolyp_Counter;
Results.USD_AdvPolyp_Counter    = USD_AdvPolyp_Counter;
Results.USD_AdvScenario_Counter = USD_AdvScenario_Counter;
Results.USD_Cancer_Counter      = USD_Cancer_Counter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                    SAVING  DATA                                      %%%                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(Variables.StarterFlag, 'on')
    answer = 'Yes';
    ResultsName = Variables.Settings_Name;
    ResultsPath = Variables.ResultsPath;
else
    answer ='Yes';
    % ResultsFullfile = fullfile(Variables.ResultsPath, [Variables.Settings_Name '_' '_Iter_']);
end
ResultsFullfile = fullfile(Variables.ResultsPath, Variables.Settings_Name);

if isequal(answer, 'Yes')
    if DispFlag
        for f=[h1 h2 h3 h4]
            set(f, 'PaperUnits', 'inches');
            set(f, 'PaperSize', [6.25 7.5]);
            set(f, 'PaperPositionMode', 'manual');
            set(f, 'PaperPosition', [0 0 6.25 7.5]);
        end
        try
            saveas(h1, [ResultsFullfile '_1'], 'pdf')
            saveas(h2, [ResultsFullfile '_2'], 'pdf')
            saveas(h3, [ResultsFullfile '_3'], 'pdf')
            saveas(h4, [ResultsFullfile '_4'], 'pdf')
        catch
            warning('Could not save pdf files, enter a correct pathway to the save data path in main window.')
        end
    end
end

%%% Excel
if isequal(Variables.StarterFlag, 'on')
    HeadLineColumns_1 = cell(2054, 1);
    HeadLineColumns_2 = cell(2054, 1);
    
    ColumnString1 = {'' 'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N'...
        'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' 'AA' 'AB' 'AC' 'AD' 'AE'...
        'AF' 'AG' 'AH' 'AI' 'AJ' 'AK' 'AL' 'AM' 'AN' 'AO' 'AP' 'AQ' 'AR' 'AS' 'AT'...
        'AU' 'AV' 'AW' 'AX' 'AY' 'AZ' 'BA' 'BB' 'BC' 'BD' 'BE'...
        'BF' 'BG' 'BH' 'BI' 'BJ' 'BK' 'BL' 'BM' 'BN' 'BO' 'BP' 'BQ' 'BR' 'BS' 'BT' 'BU' 'BV' 'BW' 'BX' 'BY' 'BZ'};
    
    ColumnString2 = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N'...
        'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
    
    Counter = 1;
    for x1=1:length(ColumnString1)
        for x2=1:length(ColumnString2)
            HeadLineColumns_1{Counter} = [ColumnString1{x1} ColumnString2{x2} '1'];
            HeadLineColumns_2{Counter} = [ColumnString1{x1} ColumnString2{x2} '2'];
            Counter = Counter +1;
        end
    end
else
    HeadLineColumns_1={'B1' 'C1' 'D1' 'E1' 'F1' 'G1' 'H1' 'I1' 'J1' 'K1' 'L1' 'M1' 'N1' 'O1' 'P1' 'Q1' 'R1' 'S1' 'T1' 'U1'...
        'V1' 'W1' 'X1' 'Y1' 'Z1' 'AA1' 'AB1' 'AC1' 'AD1' 'AE1' 'AF1' 'AG1' 'AH1' 'AI1' 'AJ1' 'AK1'...
        'AL1' 'AM1' 'AN1' 'AO1' 'AP1' 'AQ1' 'AR1' 'AS1' 'AT1' 'AU1' 'AV1' 'AW1' 'AX1' 'AY1' 'AZ1'...
        'BA1' 'BB1' 'BC1' 'BD1' 'BE1' 'BF1' 'BG1' 'BH1' 'BI1' 'BJ1' 'BK1' 'BL1' 'BM1' 'BN1'...
        'Bo1' 'Bp1' 'Bq1' 'Br1' 'Bs1' 'Bt1' 'Bu1' 'Bv1' 'Bw1' 'Bx1' 'By1' 'Bz1' 'ca1' 'cb1'};
    HeadLineColumns_2={'B2' 'C2' 'D2' 'E2' 'F2' 'G2' 'H2' 'I2' 'J2' 'K2' 'L2' 'M2' 'N2' 'O2' 'P2' 'Q2' 'R2' 'S2' 'T2' 'U2'...
        'V2' 'W2' 'X2' 'Y2' 'Z2' 'AA2' 'AB2' 'AC2' 'AD2' 'AE2' 'AF2' 'AG2' 'AH2' 'AI2' 'AJ2' 'AK2'...
        'AL2' 'AM2' 'AN2' 'AO2' 'AP2' 'AQ2' 'AR2' 'AS2' 'AT2' 'AU2' 'AV2' 'AW2' 'AX2' 'AY2' 'AZ2'...
        'BA2' 'BB2' 'BC2' 'BD2' 'BE2' 'BF2' 'BG2' 'BH2' 'BI2' 'BJ2' 'BK2' 'BL2' 'BM2' 'BN2'...
        'Bo2' 'Bp2' 'Bq2' 'Br2' 'Bs2' 'Bt2' 'Bu2' 'Bv2' 'Bw2' 'Bx2' 'By2' 'Bz2' 'ca2' 'cb2'};
end

SummaryLegend = {'Number Patients'; 'Average Age'; 'Average Age male'; 'Average Age female';...
    'Screening Colonoscopies'; 'Symptom Colonoscopies';...
    'Follow up Colonoscopies'; 'Number Rectosigmo'; 'Number FOBT'; 'Numer I-FOBT';...
    'Number Septin9'; 'Number other'; ...
    'Colon cancer deaths'; 'Years lost to colon cancer';...
    'Patients died of colonoscopy'; 'Years lost due to colonoscopy';
    'Total costs'; % 17
    'Dwell time all cancer (median)'; % 18
    'Dwell time all progressed cancer (median)'; % 19
    'Dwell time all fast cancer (median)'; % 20
    'Sojourn time (median)'; %21
    'screening stage I'; 'screening stage II'; 'screening stage III'; 'screening stage IV'; % 22 - 25
    'symptoms stage I'; 'symptoms stage II'; 'symptoms stage III'; 'symptoms stage IV'; % 26 - 29
    'all stage I'; 'all stage II'; 'all stage III'; 'all stage IV'; % 30 - 33
    'number stage I'; 'number stage II'; 'number stage III'; 'Number ALL Ca' % 34 - 37
    'detected screening'; 'detected symptoms'; 'detected surveillance'; 'detected baseline' % 38 - 41
    'fraction direct all'; 'fraction direct right'; % 42 - 43
    'dwell time all ca median'; 'dwell time all ca mean'; 'dwell time all ca lower quartile'; 'dwell time all ca upper quartile'; % 44 - 47
    'dwell time fast ca. median'; 'dwell time fast ca. mean'; 'dwell time fast ca. lower quartile'; 'dwell time fast ca. upper quartile'; % 48 - 51
    'progressed ca dwell time time median'; 'progressed ca dwell time mean'; 'progressed ca dwell time lower quartile'; 'progressed ca dwell time upper quartile';... % 52 - 55
    'sojourn time median'; 'sojourn time mean'; 'sojourn time lower quartile'; 'sojourn time upper quartile'; % 56-59
    'overall time median'; 'overall time mean'; 'overall time lower quartile'; 'overall time upper quartile'; % 60-63
    'comment'; 'settings name'}; % 64-65

if ExcelFlag
    % headlines of the Excel-Sheet
    if isequal(Variables.StarterFlag, 'on')
        Counter  = Variables.Starter.Counter;
        FileName = fullfile(Variables.ResultsPath, 'StarterSummary.xlsx');
        if isequal(Counter, 1)
            [Succ, Msg] = xlswrite(FileName, SummaryLegend, 'Summary', 'A2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, reshape((0:99), 100, 1), 'Early_Cancer', 'A2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, reshape((0:99), 100, 1), 'Late_Cancer',  'A2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, reshape((0:99), 100, 1), 'Costs',  'A2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, BM.description, 'Benchmark',  'A2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, BM.benchmark, 'Benchmark',  'B2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, BM.value, 'Wert', 'C2'); %#ok<ASGLU>
            [Succ, Msg] = xlswrite(FileName, BM.flag, 'BM flag',  'A2'); %#ok<ASGLU>
        end
        [Succ, Msg]=xlswrite(FileName, SummaryVariable, 'Summary', HeadLineColumns_2{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, reshape(Early_Cancer(1:100), 100, 1), 'Early_Cancer', HeadLineColumns_2{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, reshape(Late_Cancer(1:100), 100, 1), 'Late_Cancer', HeadLineColumns_2{Counter}); %#ok<ASGLU>
        tmp = sum(data.Money.AllCost, 2);
        [Succ, Msg]=xlswrite(FileName, reshape(round(tmp(1:100)/n*100)/100, 100, 1), 'Costs', HeadLineColumns_2{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, BM.value, 'Benchmark', HeadLineColumns_2{Counter+2}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, BM.flag,  'BM flag', HeadLineColumns_2{Counter}); %#ok<ASGLU>
        
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'Summary', HeadLineColumns_1{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'Early_Cancer', HeadLineColumns_1{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'Late_Cancer',  HeadLineColumns_1{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'Costs',  HeadLineColumns_1{Counter}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'Benchmark',  HeadLineColumns_1{Counter+2}); %#ok<ASGLU>
        [Succ, Msg]=xlswrite(FileName, {ResultsName}, 'BM flag',  HeadLineColumns_1{Counter}); %#ok<ASGLU>
        close(h1), close(h2), close(h3), close(h4)
    else
        if isequal(answer, 'Yes')
            if ExcelFlag
                FileName = [ResultsFullfile '.xlsx'];
                [Succ, Msg]=xlswrite(FileName, SummaryLegend, 'Summary', 'A1'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, SummaryVariable, 'Summary', 'B1'); %#ok<ASGLU>
                
                [Succ, Msg]=xlswrite(FileName, {'Year', 'Early Cancer', 'Late Cancer', 'Costs per person'}, 'Summary', 'C1'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, reshape((0:99), 100, 1), 'Summary', 'C2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, reshape(Early_Cancer(1:100), 100, 1), 'Summary', 'D2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, reshape(Late_Cancer(1:100), 100, 1), 'Summary', 'E2'); %#ok<ASGLU>
                tmp = sum(data.Money.AllCost, 2);
                [Succ, Msg]=xlswrite(FileName, reshape(round(tmp(1:100)/n*100)/100, 100, 1), 'Summary', 'F2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, {'description', 'value', 'upper limit', 'lower limit', 'flag'}, 'Benchmark', 'A1'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, BM.description, 'Benchmark', 'A2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, BM.value, 'Benchmark', 'B2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, BM.benchmark,   'Benchmark', 'C2'); %#ok<ASGLU>
                [Succ, Msg]=xlswrite(FileName, BM.flag,  'Benchmark', 'D2'); %#ok<ASGLU>
            end
        end
    end
end
if ResultsFlag
    FileName = [ResultsFullfile '_Results.mat'];
    Results.Var_Legend      = SummaryLegend;
    Results.Variable        = SummaryVariable;
    Results.BM_Description  = BM.description;
    Results.BM_Value        = BM.value;
    Results.Benchmark       = BM.benchmark;
    
    for f=1:100
         Results.NumberPatients(f, 1) = sum(data.YearIncluded(f, :));
    end
    Results.Early_Cancer    = reshape(Early_Cancer(1:100), 100, 1);
    Results.Late_Cancer     = reshape(Late_Cancer(1:100), 100, 1);

    tmp = sum(data.Money.Treatment, 2);
    Results.Treatment       = reshape(round(tmp(1:100)/n*100)/100, 100, 1);
    tmp = sum(data.Money.FutureTreatment, 2);
    Results.TreatmentFuture = reshape(round(tmp(1:100)/n*100)/100, 100, 1); 
    tmp = sum(data.Money.Screening, 2);
    Results.Screening       = reshape(round(tmp(1:100)/n*100)/100, 100, 1);
    tmp = sum(data.Money.FollowUp, 2);
    Results.FollowUp        = reshape(round(tmp(1:100)/n*100)/100, 100, 1);
    tmp = sum(data.Money.Other, 2);
    Results.Other           = reshape(round(tmp(1:100)/n*100)/100, 100, 1);

    Results.InputCost       = data.InputCost;
    Results.InputCostStage  = data.InputCostStage;
    Results.PaymentType     = data.PaymentType;
    
    % now we do the detailed reporting 
    Results.CostTreatment_detailed =zeros(100,5);
    Results.CostScreening_detailed =zeros(100,5);
    Results.CostFollowUp_detailed =zeros(100,5);
    Results.CostOther_detailed =zeros(100,5);
    
    for f=1:1
        if isequal(data.PBP_Doc.Screening(f), 1) % PBP screening has been performed
        if data.PBP_Doc.Cancer(f) > 0
            tmp = 1;
        elseif data.PBP_Doc.Advanced(f) >0
            tmp = 2;
        elseif data.PBP_Doc.Early(f) >1
            tmp = 3;
        elseif isequal(data.PBP_Doc.Early(f), 1)
            tmp = 4;
        else
            tmp = 5;
        end
          Results.CostTreatment_detailed(:, tmp) = Results.CostTreatment_detailed(:, tmp) + data.Money.Treatment(:, f);
          Results.CostScreening_detailed(:, tmp) = Results.CostScreening_detailed(:, tmp) + data.Money.Screening(:, f);
          Results.CostFollowUp_detailed(:, tmp)  = Results.CostFollowUp_detailed(:, tmp)  + data.Money.FollowUp(:, f);
          Results.CostOther_detailed(:, tmp)     = Results.CostOther_detailed(:, tmp)     + data.Money.Other(:, f);
        end
    end

    try
        save(FileName, 'Results')
    catch
        warning('Could not save matlab results file, try entering a correct pathway to the save data path in main window.')
    end
    for f=1:3
        if isequal(exist(FileName, 'file'), 0)
            pause(5)
            save(FileName, 'Results')
        else
            return
        end
    end
end
if DispFlag % we display figure 1
    if ishandle(h1)
        figure(h1)
    end
end

function y = cumulativeDiscYears(y1,y2,DisCountMask) 
temp=0;
for i=y1:y2
    temp = temp + DisCountMask(i);
end
y = temp;
     

function [BM , bmc, OutputFlags, OutputValues] = CalculateAgreement(DataGraph, bmc, BM, Benchmarks, Struct1, Struct2, Struct3, DispFlag,...
        SubPlotPos, GraphDescription, GraphTitle, tolerance, LineSz, MarkerSz, FontSz, LabelY, Flag) 
BM_year  = Benchmarks.(Struct1).(Struct2);
BM_value = Benchmarks.(Struct1).(Struct3);

OutputFlags  = cell(1, length(BM_year));
OutputValues = zeros(1, length(BM_year));
if DispFlag
    subplot(3,3,SubPlotPos)
    if isequal(Flag, 'Polyp')
        plot(0:99, DataGraph, 'color', 'k'), hold on % year adapted
    elseif isequal(Flag, 'Cancer')
        plot(BM_year, DataGraph, 'color', 'k'), hold on % year adapted
    end
end
% add bench marks
if DispFlag   
        plot(BM_year, BM_value, '--bs','LineWidth',LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',MarkerSz)
end
for f=1:length(BM_year)
    if (BM_year(f) >5) && (BM_year(f) <95)
        if isequal(Flag, 'Polyp')
            BM.description{bmc} = [GraphDescription num2str(BM_year(f))]; BM.benchmark{bmc} = BM_value(f);
            BM.value{bmc} = mean(DataGraph(BM_year(f)-1 : BM_year(f)+3)); % year adapted
            if and(BM.value{bmc} < (BM.benchmark{bmc}*(1 + tolerance)), BM.value{bmc} > (BM.benchmark{bmc}*(1 - tolerance)))
                BM.flag{bmc} = 'green';
            else
                BM.flag{bmc} = 'red';
            end
            if DispFlag
                plot(BM_year(f), BM.value{bmc}, '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor','k', 'MarkerFaceColor', BM.flag{bmc}, 'MarkerSize',3)
                line([BM_year(f)-2 BM_year(f)+2], [BM.value{bmc} BM.value{bmc}], 'color', BM.flag{bmc});
            end
            BM.(Struct1).(Struct3)(f) = BM.value{bmc};
            OutputFlags{f} = BM.flag{bmc}; 
            OutputValues(f)= BM.value{bmc}; 
            bmc = bmc+1;
        elseif isequal(Flag, 'Cancer')
            if BM_year(f) >20  % we ignore benchmarks for age 1-20
                BM.description{bmc} = [GraphDescription num2str(BM_year(f))]; BM.benchmark{bmc} = BM_value(f);
                BM.value{bmc} = DataGraph(f); % year adapted
                if and(BM.value{bmc} >= BM.benchmark{bmc}*(1 - tolerance), BM.value{bmc} <= (BM.benchmark{bmc}*(1 + tolerance)))
                    BM.flag{bmc} = 'green';
                elseif abs(BM.value{bmc} - BM.benchmark{bmc}) <= 2 % we ignore very small absolute differences
                    BM.flag{bmc} = 'green';
                else
                    BM.flag{bmc} = 'red';
                end
                if DispFlag
                    plot(round(BM_year(f)), BM.value{bmc}, '--rs', 'LineWidth', LineSz, 'MarkerEdgeColor',BM.flag{bmc}, 'MarkerFaceColor', BM.flag{bmc}, 'MarkerSize',3)
                    line([BM_year(f)-2 BM_year(f)+2], [BM.value{bmc} BM.value{bmc}], 'color', BM.flag{bmc});
                end
                BM.(Struct1).(Struct3)(f) = BM.value{bmc};
                OutputFlags{f} = BM.flag{bmc}; 
                OutputValues(f)= BM.value{bmc}; 
                bmc = bmc + 1;
            end
        else
            error('wrong flag')
        end
    end
end

if DispFlag
    xlabel('year', 'fontsize', FontSz), ylabel(LabelY, 'fontsize', FontSz), title(GraphTitle, 'fontsize', FontSz)
    set(gca, 'xlim', [0 100], 'fontsize', FontSz, 'xtick', [0 20 40 60 80 100])
end
