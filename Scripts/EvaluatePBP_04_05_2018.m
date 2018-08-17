
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

function EvaluatePBP_04_05_2018

ExcelFileName              = 'PBP_CMOST13_04052018';
ExcelSavePath              = '/Users/misselwb/Documents/CRC Screening/_Bowel Prep_2/Data';
ExcelFileName              = fullfile(ExcelSavePath, ExcelFileName);

AnalysisPipeline = '/Users/misselwb/Documents/CRC Screening/_Bowel Prep_2/Data/Data_04052018';
cd (AnalysisPipeline)
MasterDirectory=dir;
for f=1:length(MasterDirectory)
    AllFiles{f} = MasterDirectory(f).name;
end
z=0;
Error = zeros(length(MasterDirectory), 1);
for x=1:length(MasterDirectory)
    if ~or(or(strcmp(MasterDirectory(x,1).name, '.'), strcmp(MasterDirectory(x,1).name, '..')) ,...
            or(strcmp(MasterDirectory(x,1).name, '.DS_S_Results'), strcmp(MasterDirectory(x,1).name, '.DS_S_Store')))
        if and(~MasterDirectory(x,1).isdir, isempty(regexp(MasterDirectory(x,1).name, 'Results.mat$', 'once')))
            z=z+1;
            l = length(MasterDirectory(x,1).name)-4;
            FileName{z}  = [MasterDirectory(x,1).name(1:l) '_Results'];
            Directory{z} = pwd;
            if ~isempty(find(ismember(AllFiles, [FileName{z} '.mat'])==1))
                Error(z) = 0;
            else
                Error(z) = 1;
            end
        end
    end
end
if max(Error) > 0
    display('Error, for the following files no output file was detected')
    for f=1:length(Error)
        if Error(f)
            display(Directory{f})
            display(FileName{f})
        end
    end
    return
end
BatchCounter = z;

HeadLineColumns=...
    {'B2' 'C2'  'D2'  'E2'  'F2'  'G2'  'H2'  'I2'  'J2'  'K2'  'L2'  'M2'  'N2'  'O2'  'P2'  'Q2' 'R2' 'S2' 'T2'...
    'U2'  'V2'  'W2'  'X2'  'Y2'  'Z2'  'AA2' 'AB2' 'AC2' 'AD2' 'AE2' 'AF2' 'AG2' 'AH2' 'AI2' 'AJ2'...
    'AK2' 'AL2' 'AM2' 'AN2' 'AO2' 'AP2' 'AQ2' 'AR2' 'AS2' 'AT2' 'AU2' 'AV2' 'AW2' 'AX2' 'AY2' 'AZ2'...
    'BA2' 'BB2' 'BC2' 'BD2' 'BE2' 'BF2' 'BG2' 'BH2' 'BI2' 'BJ2' 'BK2' 'BL2' 'BM2' 'BN2'...
    'Bo2' 'Bp2' 'Bq2' 'Br2' 'Bs2' 'Bt2' 'Bu2' 'Bv2' 'Bw2' 'Bx2' 'By2' 'Bz2' 'ca2' 'cb2'...
    'CC2' 'CD2' 'CE2' 'CF2' 'CG2' 'CH2' 'CI2' 'CJ2' 'CK2' 'CL2' 'CM2' 'CN2'...
    'CO2' 'CP2' 'CQ2' 'CR2' 'CS2' 'CT2' 'CU2' 'CV2' 'CW2' 'CX2' 'CY2' 'CZ2' 'DA2' 'DB2'...
    'DC2' 'DD2' 'DE2' 'DF2' 'DG2' 'DH2' 'DI2' 'DJ2' 'DK2' 'DL2' 'DM2' 'DN2'};

clear Headlines
Headlines{1,1} =  'Baseline_';
Headlines{1,2} =  'Standard_Screening_';
Headlines{1,3} =  'SC01_Aronchick_01_avg_';
Headlines{1,4} =  'SC01_Aronchick_01_low_';
Headlines{1,5} =  'SC01_Aronchick_01_high_';
Headlines{1,6} =  'SC01_Aronchick_02_avg_';
Headlines{1,7} =  'SC01_Aronchick_02_low_';
Headlines{1,8} =  'SC01_Aronchick_02_high_';
Headlines{1,9} =  'SC01_Aronchick_03_avg_';
Headlines{1,10} = 'SC01_Aronchick_03_low_';
Headlines{1,11} = 'SC01_Aronchick_03_high_';
Headlines{1,12} = 'SC01_Aronchick_04_avg_';
Headlines{1,13} = 'SC01_Aronchick_04_low_';
Headlines{1,14} = 'SC01_Aronchick_04_high_';

Headlines{1,15} =  'SC02_PBP_66_WWxx_Aronchick_01_avg_'; % insufficient
Headlines{1,16} =  'SC02_PBP_66_WWxx_Aronchick_01_low_';
Headlines{1,17} =  'SC02_PBP_66_WWxx_Aronchick_01_high_';

Headlines{1,18} =  'SC02_PBP_66_WWxx_Aronchick_02_avg_'; % poor
Headlines{1,19} =  'SC02_PBP_66_WWxx_Aronchick_02_low_';
Headlines{1,20} =  'SC02_PBP_66_WWxx_Aronchick_02_high_';

Headlines{1,21} =  'SC02_PBP_66_WWxx_Aronchick_03_avg_'; % fair
Headlines{1,22} =  'SC02_PBP_66_WWxx_Aronchick_03_low_';
Headlines{1,23} =  'SC02_PBP_66_WWxx_Aronchick_03_high_';

Headlines{1,24} =  'SC02_PBP_66_WWxx_Aronchick_04_avg_'; % good
Headlines{1,25} =  'SC02_PBP_66_WWxx_Aronchick_04_low_';
Headlines{1,26} =  'SC02_PBP_66_WWxx_Aronchick_04_high_';

Headlines{1,27} =  'SC02_PBP_66_WWxx_Aronchick_05_avg_'; % excellent

Headlines{1,28} = 'SC03_PBP_66_WW00_Aronchick_01_avg_';
Headlines{1,29} = 'SC03_PBP_66_WW01_Aronchick_01_avg_';
Headlines{1,30} = 'SC03_PBP_66_WW02_Aronchick_01_avg_';
Headlines{1,31} = 'SC03_PBP_66_WW03_Aronchick_01_avg_';
Headlines{1,32} = 'SC03_PBP_66_WW05_Aronchick_01_avg_';
Headlines{1,33} = 'SC03_PBP_66_WW10_Aronchick_01_avg_';

%%% SC03 - repeat
Headlines{1,34} = 'SC03_PBP_66_WW00_Aronchick_01_low_';
Headlines{1,35} = 'SC03_PBP_66_WW01_Aronchick_01_low_';
Headlines{1,36} = 'SC03_PBP_66_WW02_Aronchick_01_low_';
Headlines{1,37} = 'SC03_PBP_66_WW03_Aronchick_01_low_';
Headlines{1,38} = 'SC03_PBP_66_WW05_Aronchick_01_low_';
Headlines{1,39} = 'SC03_PBP_66_WW10_Aronchick_01_low_';

Headlines{1,40} = 'SC03_PBP_66_WW00_Aronchick_01_high_';
Headlines{1,41} = 'SC03_PBP_66_WW01_Aronchick_01_high_';
Headlines{1,42} = 'SC03_PBP_66_WW02_Aronchick_01_high_';
Headlines{1,43} = 'SC03_PBP_66_WW03_Aronchick_01_high_';
Headlines{1,44} = 'SC03_PBP_66_WW05_Aronchick_01_high_';
Headlines{1,45} = 'SC03_PBP_66_WW10_Aronchick_01_high_';

Headlines{1,46} = 'SC03_PBP_66_WW00_Aronchick_02_avg_';
Headlines{1,47} = 'SC03_PBP_66_WW01_Aronchick_02_avg_';
Headlines{1,48} = 'SC03_PBP_66_WW02_Aronchick_02_avg_';
Headlines{1,49} = 'SC03_PBP_66_WW03_Aronchick_02_avg_';
Headlines{1,50} = 'SC03_PBP_66_WW05_Aronchick_02_avg_';
Headlines{1,51} = 'SC03_PBP_66_WW10_Aronchick_02_avg_';

Headlines{1,52} = 'SC03_PBP_66_WW00_Aronchick_02_low_';
Headlines{1,53} = 'SC03_PBP_66_WW01_Aronchick_02_low_';
Headlines{1,54} = 'SC03_PBP_66_WW02_Aronchick_02_low_';
Headlines{1,55} = 'SC03_PBP_66_WW03_Aronchick_02_low_';
Headlines{1,56} = 'SC03_PBP_66_WW05_Aronchick_02_low_';
Headlines{1,57} = 'SC03_PBP_66_WW10_Aronchick_02_low_';

Headlines{1,58} = 'SC03_PBP_66_WW00_Aronchick_02_high_';
Headlines{1,59} = 'SC03_PBP_66_WW01_Aronchick_02_high_';
Headlines{1,60} = 'SC03_PBP_66_WW02_Aronchick_02_high_';
Headlines{1,61} = 'SC03_PBP_66_WW03_Aronchick_02_high_';
Headlines{1,62} = 'SC03_PBP_66_WW05_Aronchick_02_high_';
Headlines{1,63} = 'SC03_PBP_66_WW10_Aronchick_02_high_';

Headlines{1,64} = 'SC03_PBP_66_WW00_Aronchick_03_avg_';
Headlines{1,65} = 'SC03_PBP_66_WW01_Aronchick_03_avg_';
Headlines{1,66} = 'SC03_PBP_66_WW02_Aronchick_03_avg_';
Headlines{1,67} = 'SC03_PBP_66_WW03_Aronchick_03_avg_';
Headlines{1,68} = 'SC03_PBP_66_WW05_Aronchick_03_avg_';
Headlines{1,69} = 'SC03_PBP_66_WW10_Aronchick_03_avg_';

Headlines{1,70} = 'SC03_PBP_66_WW00_Aronchick_03_low_';
Headlines{1,71} = 'SC03_PBP_66_WW01_Aronchick_03_low_';
Headlines{1,72} = 'SC03_PBP_66_WW02_Aronchick_03_low_';
Headlines{1,73} = 'SC03_PBP_66_WW03_Aronchick_03_low_';
Headlines{1,74} = 'SC03_PBP_66_WW05_Aronchick_03_low_';
Headlines{1,75} = 'SC03_PBP_66_WW10_Aronchick_03_low_';

Headlines{1,76} = 'SC03_PBP_66_WW00_Aronchick_03_high_';
Headlines{1,77} = 'SC03_PBP_66_WW01_Aronchick_03_high_';
Headlines{1,78} = 'SC03_PBP_66_WW02_Aronchick_03_high_';
Headlines{1,79} = 'SC03_PBP_66_WW03_Aronchick_03_high_';
Headlines{1,80} = 'SC03_PBP_66_WW05_Aronchick_03_high_';
Headlines{1,81} = 'SC03_PBP_66_WW10_Aronchick_03_high_';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scenario 1                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Screening %%%
% discounting after year 50 or year 66
DisCountMask = zeros(101,1);
DisCountMask(1:51)=1;
for ff=52:101
    DisCountMask(ff) = DisCountMask(ff-1)* 0.97;
end
DisCountMask_65 = zeros(101,1);
DisCountMask_65(1:65)=1;
for ff=66:101
    DisCountMask_65(ff) = DisCountMask_65(ff-1)* 0.97;
end

BatchCounter = z;
NoInterventionCounter =0;
StandardColoCounter   =0;
ScreenCounter = zeros(1, length(Headlines));

for z=1:BatchCounter
    pos1  = regexp(FileName{z}, '_SC01_Baseline_');
    pos2  = regexp(FileName{z}, '_SC01_Standard_Screening_');
    
    flag = false;
    for f=3:length(Headlines)
        posX = regexp(FileName{z}, Headlines{f}, 'once');
        if ~isempty(posX)
            flag = true;
            pos = f;
        end
    end

    if ~isempty(pos1) || ~isempty(pos2) || flag

        clear Results 
        load(fullfile(Directory{z}, FileName{z}));
        
        Results.TotalCosts   = Results.Treatment + Results.Screening + Results.FollowUp + Results.Other;
        Results.DiscCosts    = Results.TotalCosts .* DisCountMask(1:100);
        Results.SumDiscCosts = sum(Results.DiscCosts(51:100));
        Results.Variable{71} = sum(Results.DiscCosts(51:100));
        
        Results.DiscCosts_65 = Results.TotalCosts .* DisCountMask_65(1:100);
        Results.Variable{76} = sum(Results.DiscCosts_65(66:100));
        
        Results.YearsLost    = Results.YearsLostCa + Results.YearsLostColo;
        Results.DiscYears    = Results.YearsLost .* DisCountMask(1:length(Results.YearsLost))';
        Results.SumDiscYears = sum(Results.DiscYears(51:100));
        Results.Variable{70} = Results.SumDiscYears;
        
        Results.DiscYears_65    = Results.YearsLost .* DisCountMask_65(1:length(Results.YearsLost))';
        Results.SumDiscYears_65 = sum(Results.DiscYears(66:100));
        Results.Variable{75}    = Results.SumDiscYears_65;
        
        Results.Variable{66} = -1000; % just to define the variable and prevent downstream errors
        Results.Variable{67} = -1000;
        Results.Variable{68} = -1000;
        Results.Variable{69} = -1000;
        
        Results.Variable{72} = -1000;
        Results.Variable{73} = -1000;
        Results.Variable{74} = -1000;
        
        if ~isempty(pos1) % no intervention
            num = 1; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NoInterventionCounter = NoInterventionCounter +1;
            control.NoIntervention.CaDeath(NoInterventionCounter)      = Results.Variable{13};
            control.NoIntervention.LYlost(NoInterventionCounter)       = Results.Variable{14};
            control.NoIntervention.AllCa(NoInterventionCounter)        = Results.Variable{37};
            control.NoIntervention.YLostColo(NoInterventionCounter)    = Results.Variable{16};
            control.NoIntervention.TotalCosts(NoInterventionCounter)   = Results.Variable{17};
            control.NoIntervention.DeathColo(NoInterventionCounter)    = Results.Variable{15};
            control.NoIntervention.SumDiscYears(NoInterventionCounter) = Results.SumDiscYears;
            control.NoIntervention.SumDiscCosts(NoInterventionCounter) = Results.SumDiscCosts;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        elseif ~isempty(pos2) % screening colo
            num = 2; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            StandardColoCounter = StandardColoCounter +1;
            control.StandardColo.CaDeath(StandardColoCounter)      = Results.Variable{13};
            control.StandardColo.LYlost(StandardColoCounter)       = Results.Variable{14};
            control.StandardColo.AllCa(StandardColoCounter)        = Results.Variable{37};
            control.StandardColo.YLostColo(StandardColoCounter)    = Results.Variable{16};
            control.StandardColo.TotalCosts(StandardColoCounter)   = Results.Variable{17};
            control.StandardColo.DeathColo(StandardColoCounter)    = Results.Variable{15};
            control.StandardColo.SumDiscYears(StandardColoCounter) = Results.SumDiscYears;
            control.StandardColo.SumDiscCosts(StandardColoCounter) = Results.SumDiscCosts;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        else 
            ScreenCounter(pos) = ScreenCounter(pos)+1;
            AllResults{pos, ScreenCounter(pos)} = Results.Variable;
            NumPat(pos, ScreenCounter(pos))     = Results.NumberPatients(51);
        end
    end
end

for f=1:length(Headlines)
    AllResultsVector{f} = cell(67,1);
end

% line 21 in the results file is empty, we replace this with -1000
for x1=1:length(Headlines)
    for x2=1:ScreenCounter(x1)
        if isempty(AllResults{x1, x2}{21})
            AllResults{x1, x2}{21} = -1000;
        else
            error ('line not empty')
        end
    end
end

for x1=1:length(Headlines) % we re-assemble everything 
    for x2=1:ScreenCounter(x1)
        for x3=1:length(AllResults{x1, x2})
            if isnumeric(AllResults{x1, x2}{x3})
                AllResultsVector{x1}{x3}(x2) = AllResults{x1, x2}{x3};
            end
        end
    end
end

NumPatAll = mean(mean(NumPat));
SummaryLegend = Results.Var_Legend;

% incidene reduction
SummaryLegend{60} = 'incidence reduction';
for f=1:length(Headlines)
    AllResultsVector{f}{60} = (AllResultsVector{1}{37}-AllResultsVector{f}{37}) ./AllResultsVector{1}{37}*100;
end

% mortality reduction
SummaryLegend{61} = 'mortality reduction';
for f=1:length(Headlines)
    AllResultsVector{f}{61} = (AllResultsVector{1}{13}-AllResultsVector{f}{13}) ./AllResultsVector{1}{13}*100;
end

% life years gained undiscounted
SummaryLegend{62} = 'life years gained';
for f=1:length(Headlines)
    AllResultsVector{f}{62} = ((AllResultsVector{1}{14}+AllResultsVector{1}{16}) - (AllResultsVector{f}{14}+AllResultsVector{f}{16})) /100;
end

% screening colonoscopies
SummaryLegend{63} = 'screening colonoscopies';
for f=1:length(Headlines)
    AllResultsVector{f}{63} = AllResultsVector{f}{5}/100;
end

% surveillance colonoscopies
SummaryLegend{64} = 'surveillance colonoscopies';
for f=1:length(Headlines)
    AllResultsVector{f}{64} = AllResultsVector{f}{7}/100;
end

% all colonoscopies
SummaryLegend{65} = 'all colonoscopies';
for f=1:length(Headlines)
    AllResultsVector{f}{65} = (AllResultsVector{f}{5}+AllResultsVector{f}{6}+AllResultsVector{f}{7})/100;
end

% CRC cases prevented
SummaryLegend{66} = 'crc cases prevented';
for f=1:length(Headlines)
    AllResultsVector{f}{66} = (AllResultsVector{1}{37}-AllResultsVector{f}{37})/100;
end

% CRC mortality cases prevented
SummaryLegend{67} = 'crc mortality cases prevented';
for f=1:length(Headlines)
    AllResultsVector{f}{67} = (AllResultsVector{1}{13}-AllResultsVector{f}{13})/100;
end

% colonoscopies per case prevented
SummaryLegend{68} = 'colonoscopies per case prevented';
for f=1:length(Headlines)
    AllResultsVector{f}{68} = AllResultsVector{f}{65}./AllResultsVector{f}{66};
end

% colonoscopies per life year gained
SummaryLegend{69} = 'colonoscopies per LY gained';
try
for f=1:length(Headlines)
    AllResultsVector{f}{69} = AllResultsVector{f}{65}./AllResultsVector{f}{62};
end
catch exception
    rethrow(exception)
end

% cost-effectiveness
SummaryLegend{70} = 'Discounted life years, age 50 - 100';
SummaryLegend{71} = 'Discounted costs, age 50 - 100';
SummaryLegend{72} = 'Disc LYG -bg, age 50 - 100';
SummaryLegend{73} = 'Disc costs -bg, age 50 - 100';
SummaryLegend{74} = 'discUSD per discLYG 50+';

SummaryLegend{75} = 'Discounted life years, age 65 - 100';
SummaryLegend{76} = 'Discounted costs, age 65 - 100';
SummaryLegend{77} = 'Disc LYG -bg, age 65 - 100';
SummaryLegend{78} = 'Disc costs -bg, age 65 - 100';
SummaryLegend{79} = 'discUSD per discLYG 65+';

% we do the cost calculations
for f=1:length(Headlines)  
    AllResultsVector{f}{72} = AllResultsVector{1}{70}  - AllResultsVector{f}{70};
    AllResultsVector{f}{73} = AllResultsVector{f}{71} - AllResultsVector{1}{71};
    AllResultsVector{f}{74} = AllResultsVector{f}{73} ./ AllResultsVector{f}{72} * 100000;
    
    AllResultsVector{f}{77} = AllResultsVector{1}{75}  - AllResultsVector{f}{75};
    AllResultsVector{f}{78} = AllResultsVector{f}{76} - AllResultsVector{1}{76};
    AllResultsVector{f}{79} = AllResultsVector{f}{78} ./ AllResultsVector{f}{77} * 100000;
end

% we calculate 
for f=1:length(Headlines) % we calculate an average
    for x3=1:length(AllResultsVector{1, f})
        AllResultsMean{f}{x3} = mean(AllResultsVector{f}{x3});
        AllResultsStd{f}{x3}  = std(AllResultsVector{f}{x3});
    end
end


% xlswrite (ExcelFileName, Headlines, 'PBP_mean', 'B1')
% xlswrite (ExcelFileName, Headlines, 'PBP_std', 'B1')
% xlswrite (ExcelFileName, SummaryLegend, 'PBP_mean', 'A2')
% xlswrite (ExcelFileName, SummaryLegend, 'PBP_std', 'A2')
% for f=1:length(Headlines)
%     xlswrite (ExcelFileName, AllResultsMean{f}, 'PBP_mean', HeadLineColumns{f})
%     xlswrite (ExcelFileName, AllResultsStd{f},  'PBP_std',  HeadLineColumns{f})
% end

%%%%%% we write csv-files
spalte = length(AllResultsMean);
zeile  = length(AllResultsMean{1});

for f=1:zeile
    for f2=1:spalte
        RawTable_mean{f, f2} = AllResultsMean{f2}{f};
%         RawTable_std{f, f2}  = AllResultsStd{f2}{f};
    end
end
Tmean = cell2table(RawTable_mean,'VariableNames',Headlines, 'RowNames',SummaryLegend);
% Tstd  = cell2table(RawTable_std,'VariableNames',Headlines, 'RowNames',SummaryLegend);

%%%% we write everything in one .csv file
for f=1:zeile
    ColumnCounter = 1;
    for f2=1:spalte
        RawTable_All{f, ColumnCounter}    = AllResultsMean{f2}{f};
        RawTable_All{f, ColumnCounter+1}  = AllResultsStd{f2}{f};
        RawTable_All{f, ColumnCounter+2}  = ScreenCounter(f2);
        ColumnCounter = ColumnCounter + 3;
    end
end

ColumnCounter = 1;
for f2=1:spalte
    Headlines_2{ColumnCounter}   = [Headlines{f2} '_mean'];
    Headlines_2{ColumnCounter+1} = [Headlines{f2} '_std'];
    Headlines_2{ColumnCounter+2} = [Headlines{f2} '_n'];
    ColumnCounter = ColumnCounter + 3;
end 
TAll = cell2table(RawTable_All,'VariableNames',Headlines_2, 'RowNames',SummaryLegend);

writetable(Tmean, [ExcelFileName '_SC01_summary_mean.csv'], 'WriteRowNames', true)
% writetable(Tstd,  [ExcelFileName 'std.csv'], 'WriteRowNames', true)
writetable(TAll,  [ExcelFileName '_SC01_summary_all.csv'], 'WriteRowNames', true)

clear Tmean TAll Headlines_2 RawTable_All RawTable_mean

%%%%%%%%%%%%%%%%%%%%%%
%%%  Scenario 2    %%%
%%%%%%%%%%%%%%%%%%%%%%

ReplicaNumber = 0;
n=100000;

for z=1:BatchCounter 
    flag = false;
    for f=15:length(Headlines)
        posX = regexp(FileName{z}, Headlines{f}, 'once'); 
        if ~isempty(posX)
            flag = true;
            pos  = f;
        end
    end
    display(z)    
    if flag 
        FileTemp = FileName{z};
        posX = regexp(FileTemp, '_Results'); posX = posX(end);
        NumTmp1= str2num(FileTemp((posX-1)));
        NumTmp2= str2num(FileTemp((posX-2)));
        NumTmp3= str2num(FileTemp((posX-3)));
        if isempty(NumTmp2)
            ReplicaVar = NumTmp1;
        elseif isempty(NumTmp3)
            ReplicaVar = NumTmp2*10+NumTmp1;
        else
            ReplicaVar = NumTmp3*100+NumTmp2*10+NumTmp1;
        end
        ReplicaNumber = max(ReplicaNumber, ReplicaVar);
        
        clear Results 
        load(fullfile(Directory{z}, FileTemp));
        
        % DiagnosedCancer(y, z); the number indicates the maximum stage
        % tumor diagnosed at that year
        
        % all individuals
        DiagnosedCancer = Results.DiagnosedCancer >1;
        AliveArea = zeros(n, 100);
        
        % we loop over all individuals and see whether they took part in
        % screening
        
%         DiagnosedCancer_65 = Screening_65.DiagnosedCancer >1;
%         AliveArea_Screening_65 = zeros(n, 100);
%         for f=1:size(DiagnosedCancer_65, 2)
%             AliveArea_Screening_65(f, 1 : round(Screening_65.DeathYear(f))) = 1;
%         end
        
        for f=1:size(DiagnosedCancer, 2)
            if isequal(Results.PBP_Doc_Screening(f), 0) 
                DiagnosedCancer(:, f) = 0;
            else
                AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
            end
        end
        IntervallCancer.All{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
        Alive.All{pos, ReplicaVar} = sum(AliveArea, 1);
        
        % NO POLYP
        if pos >14
            DiagnosedCancer = Results.DiagnosedCancer >1;
            AliveArea = zeros(n, 100);
            
            % we loop over all individuals and see whether they were they participated in screening
            % have no polyp
            for f=1:n
                if isequal(Results.PBP_Doc_Screening(f), 1) && isequal(Results.PBP_Doc_Early(f), 0)...
                        && isequal(Results.PBP_Doc_Advanced(f), 0) && isequal(Results.PBP_Doc_Cancer(f), 0)
                    AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
                else
                    DiagnosedCancer(:, f) = 0;
                end
            end
            IntervallCancer.NoPolyp{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
            Alive.NoPolyp{pos, ReplicaVar} = sum(AliveArea, 1);
        end
        
        % ONE EARLY POLYP
        if pos >14
            DiagnosedCancer = Results.DiagnosedCancer >1;
            AliveArea = zeros(n, 100);
            
            % we loop over all individuals and see whether they were they participated in screening
            % and have ONE early polyp
            for f=1:n
                if isequal(Results.PBP_Doc_Screening(f), 1) && isequal(Results.PBP_Doc_Early(f), 1)...
                        && isequal(Results.PBP_Doc_Advanced(f), 0) && isequal(Results.PBP_Doc_Cancer(f), 0)
                    AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
                else
                    DiagnosedCancer(:, f) = 0;
                end
            end
            IntervallCancer.OnePolyp{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
            Alive.OnePolyp{pos, ReplicaVar} = sum(AliveArea, 1);
        end
        
        % TWO EARLY POLYPs
        if pos >14
            DiagnosedCancer = Results.DiagnosedCancer >1;
            AliveArea = zeros(n, 100);
            
            % we loop over all individuals and see whether they were they participated in screening
            % have TWO or MORE early polyps
            for f=1:n
                if isequal(Results.PBP_Doc_Screening(f), 1) && Results.PBP_Doc_Early(f) > 1 ...
                        && isequal(Results.PBP_Doc_Advanced(f), 0) && isequal(Results.PBP_Doc_Cancer(f), 0)
                    AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
                else
                    DiagnosedCancer(:, f) = 0;
                end
            end
            IntervallCancer.TwoPolyp{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
            Alive.TwoPolyp{pos, ReplicaVar} = sum(AliveArea, 1);
        end
        
        % ONE ADVANCED POLYP
        if pos >14
            DiagnosedCancer = Results.DiagnosedCancer >1;
            AliveArea = zeros(n, 100);
            
            % we loop over all individuals and see whether they were they participated in screening
            % have AT LEAST ONE ADVANCED polyp
            for f=1:n
                if isequal(Results.PBP_Doc_Screening(f), 1) ...
                        && Results.PBP_Doc_Advanced(f) >0 && isequal(Results.PBP_Doc_Cancer(f), 0)
                    AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
                else
                    DiagnosedCancer(:, f) = 0;
                end
            end
            IntervallCancer.OneAdvPolyp{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
            Alive.OneAdvPolyp{pos, ReplicaVar} = sum(AliveArea, 1);
        end
        
        % ONE ADVANCED POLYP or >2 EARLY
        if pos >14
            DiagnosedCancer = Results.DiagnosedCancer >1;
            AliveArea = zeros(n, 100);
            
            % we loop over all individuals and see whether they were they participated in screening
            % have AT LEAST ONE ADVANCED or MORE THEN TWO EARLY polyps
            for f=1:n
                if isequal(Results.PBP_Doc_Screening(f), 1) ...
                        && Results.PBP_Doc_Advanced(f) >0 || Results.PBP_Doc_Early(f) >2 && isequal(Results.PBP_Doc_Cancer(f), 0)
                    AliveArea(f, 1 : round(Results.DeathYear(f))) = 1;
                else
                    DiagnosedCancer(:, f) = 0;
                end
            end
            IntervallCancer.AdvScenarioPolyp{pos, ReplicaVar} = sum(DiagnosedCancer, 2);
            Alive.AdvScenarioPolyp{pos, ReplicaVar} = sum(AliveArea, 1);
        end
        
        if pos >14
            Life_Years_Lost.NoPolyp{pos, ReplicaVar}                    = Results.LY_Ca_NoPolyp + Results.LY_Colo_NoPolyp;
            Life_Years_Lost.OnePolyp{pos, ReplicaVar}                   = Results.LY_Ca_OnePolyp + Results.LY_Colo_OnePolyp;
            Life_Years_Lost.TwoPolyp{pos, ReplicaVar}                   = Results.LY_Ca_TwoPolyps + Results.LY_Colo_TwoPolyps;
            Life_Years_Lost.OneAdvPolyp{pos, ReplicaVar}                = Results.LY_Ca_AdvPolyp + Results.LY_Colo_AdvPolyp;
            Life_Years_Lost.AdvScenarioPolyp{pos, ReplicaVar}           = Results.LY_Ca_AdvScenario + Results.LY_Colo_AdvScenario;
            Life_Years_Lost.Cancer{pos, ReplicaVar}                     = Results.LY_Ca_Cancer + Results.LY_Colo_Cancer;
            
            Life_Years_Lost_Counter.NoPolyp{pos, ReplicaVar}            = Results.Ca_NoPolyp_Counter + Results.Colo_NoPolyp_Counter;
            Life_Years_Lost_Counter.OnePolyp{pos, ReplicaVar}           = Results.Ca_OnePolyp_Counter + Results.Colo_OnePolyp_Counter;
            Life_Years_Lost_Counter.TwoPolyp{pos, ReplicaVar}           = Results.Ca_TwoPolyp_Counter + Results.Colo_TwoPolyp_Counter;
            Life_Years_Lost_Counter.OneAdvPolyp{pos, ReplicaVar}        = Results.Ca_AdvPolyp_Counter + Results.Colo_AdvPolyp_Counter;
            Life_Years_Lost_Counter.AdvScenarioPolyp{pos, ReplicaVar}   = Results.Ca_AdvScenario_Counter + Results.Colo_AdvScenario_Counter;
            Life_Years_Lost_Counter.Cancer{pos, ReplicaVar}             = Results.Ca_Cancer_Counter + Results.Colo_Cancer_Counter;

            USD.NoPolyp{pos, ReplicaVar}                                = Results.USD_NoPolyp;
            USD.OnePolyp{pos, ReplicaVar}                               = Results.USD_OnePolyp;
            USD.TwoPolyp{pos, ReplicaVar}                               = Results.USD_TwoPolyps;
            USD.OneAdvPolyp{pos, ReplicaVar}                            = Results.USD_AdvPolyp;
            USD.AdvScenarioPolyp{pos, ReplicaVar}                       = Results.USD_AdvScenario;
            USD.Cancer{pos, ReplicaVar}                                 = Results.USD_Cancer;  
            
            USD.NoPolyp_Counter{pos, ReplicaVar}                        = Results.USD_NoPolyp_Counter;
            USD.OnePolyp_Counter{pos, ReplicaVar}                       = Results.USD_OnePolyp_Counter;
            USD.TwoPolyp_Counter{pos, ReplicaVar}                       = Results.USD_TwoPolyp_Counter;
            USD.OneAdvPolyp_Counter{pos, ReplicaVar}                    = Results.USD_AdvPolyp_Counter;
            USD.AdvScenarioPolyp_Counter{pos, ReplicaVar}               = Results.USD_AdvScenario_Counter;
            USD.Cancer_Counter{pos, ReplicaVar}                         = Results.USD_Cancer_Counter; 
        end
    end
end
    
for x1=15:length(Headlines) % we re-assemble everything
    for x2=1:ReplicaNumber
        if isequal(x2, 1)
            R_IntervallCancer.All{x1}              = IntervallCancer.All{x1, x2};
            R_Alive.All{x1}                        = Alive.All{x1, x2}(1:100)';
            R_IntervallCancer.NoPolyp{x1}          = IntervallCancer.NoPolyp{x1, x2};
            R_Alive.NoPolyp{x1}                    = Alive.NoPolyp{x1, x2}(1:100)';
            R_IntervallCancer.OnePolyp{x1}         = IntervallCancer.OnePolyp{x1, x2};
            R_Alive.OnePolyp{x1}                   = Alive.OnePolyp{x1, x2}(1:100)';
            R_IntervallCancer.TwoPolyp{x1}         = IntervallCancer.TwoPolyp{x1, x2};
            R_Alive.TwoPolyp{x1}                   = Alive.TwoPolyp{x1, x2}(1:100)';
            R_IntervallCancer.OneAdvPolyp{x1}      = IntervallCancer.OneAdvPolyp{x1, x2};
            R_Alive.OneAdvPolyp{x1}                = Alive.OneAdvPolyp{x1, x2}(1:100)';
            R_IntervallCancer.AdvScenarioPolyp{x1} = IntervallCancer.AdvScenarioPolyp{x1, x2};
            R_Alive.AdvScenarioPolyp{x1}           = Alive.AdvScenarioPolyp{x1, x2}(1:100)';
            
            R_Life_Years_Lost.NoPolyp{x1}                    = Life_Years_Lost.NoPolyp{x1, x2}';
            R_Life_Years_Lost.OnePolyp{x1}                   = Life_Years_Lost.OnePolyp{x1, x2}';
            R_Life_Years_Lost.TwoPolyp{x1}                   = Life_Years_Lost.TwoPolyp{x1, x2}'; 
            R_Life_Years_Lost.OneAdvPolyp{x1}                = Life_Years_Lost.OneAdvPolyp{x1, x2}';    
            R_Life_Years_Lost.AdvScenarioPolyp{x1}           = Life_Years_Lost.AdvScenarioPolyp{x1, x2}'; 
            R_Life_Years_Lost.Cancer{x1}                     = Life_Years_Lost.Cancer{x1, x2}';   
            
            R_Life_Years_Lost_Counter.NoPolyp{x1}            = Life_Years_Lost_Counter.NoPolyp{x1, x2}; 
            R_Life_Years_Lost_Counter.OnePolyp{x1}           = Life_Years_Lost_Counter.OnePolyp{x1, x2};
            R_Life_Years_Lost_Counter.TwoPolyp{x1}           = Life_Years_Lost_Counter.TwoPolyp{x1, x2};
            R_Life_Years_Lost_Counter.OneAdvPolyp{x1}        = Life_Years_Lost_Counter.OneAdvPolyp{x1, x2}; 
            R_Life_Years_Lost_Counter.AdvScenarioPolyp{x1}   = Life_Years_Lost_Counter.AdvScenarioPolyp{x1, x2};
            R_Life_Years_Lost_Counter.Cancer{x1}             = Life_Years_Lost_Counter.Cancer{x1, x2}; 

            R_USD.NoPolyp{x1}                                = USD.NoPolyp{x1, x2}; 
            R_USD.OnePolyp{x1}                               = USD.OnePolyp{x1, x2};
            R_USD.TwoPolyp{x1}                               = USD.TwoPolyp{x1, x2};
            R_USD.OneAdvPolyp{x1}                            = USD.OneAdvPolyp{x1, x2}; 
            R_USD.AdvScenarioPolyp{x1}                       = USD.AdvScenarioPolyp{x1, x2};  
            R_USD.Cancer{x1}                                 = USD.Cancer{x1, x2};
            
            R_USD_Counter.NoPolyp{x1}                        = USD.NoPolyp_Counter{x1, x2}; 
            R_USD_Counter.OnePolyp{x1}                       = USD.OnePolyp_Counter{x1, x2};
            R_USD_Counter.TwoPolyp{x1}                       = USD.TwoPolyp_Counter{x1, x2};
            R_USD_Counter.OneAdvPolyp{x1}                    = USD.OneAdvPolyp_Counter{x1, x2};
            R_USD_Counter.AdvScenarioPolyp{x1}               = USD.AdvScenarioPolyp_Counter{x1, x2}; 
            R_USD_Counter.Cancer{x1}                         = USD.Cancer_Counter{x1, x2}; 
            
        else
            R_IntervallCancer.All{x1}              = cat(2, R_IntervallCancer.All{x1}, IntervallCancer.All{x1, x2});
            R_Alive.All{x1}                        = cat(2, R_Alive.All{x1}, Alive.All{x1, x2}(1:100)');
            R_IntervallCancer.NoPolyp{x1}          = cat(2, R_IntervallCancer.NoPolyp{x1}, IntervallCancer.NoPolyp{x1, x2});
            R_Alive.NoPolyp{x1}                    = cat(2, R_Alive.NoPolyp{x1}, Alive.NoPolyp{x1, x2}(1:100)');
            R_IntervallCancer.OnePolyp{x1}         = cat(2, R_IntervallCancer.OnePolyp{x1}, IntervallCancer.OnePolyp{x1, x2});
            R_Alive.OnePolyp{x1}                   = cat(2, R_Alive.OnePolyp{x1}, Alive.OnePolyp{x1, x2}(1:100)');
            R_IntervallCancer.TwoPolyp{x1}         = cat(2, R_IntervallCancer.TwoPolyp{x1}, IntervallCancer.TwoPolyp{x1, x2});
            R_Alive.TwoPolyp{x1}                   = cat(2, R_Alive.TwoPolyp{x1}, Alive.TwoPolyp{x1, x2}(1:100)');
            R_IntervallCancer.OneAdvPolyp{x1}      = cat(2, R_IntervallCancer.OneAdvPolyp{x1}, IntervallCancer.OneAdvPolyp{x1, x2});
            R_Alive.OneAdvPolyp{x1}                = cat(2, R_Alive.OneAdvPolyp{x1}, Alive.OneAdvPolyp{x1, x2}(1:100)');
            R_IntervallCancer.AdvScenarioPolyp{x1} = cat(2, R_IntervallCancer.AdvScenarioPolyp{x1}, IntervallCancer.AdvScenarioPolyp{x1, x2});
            R_Alive.AdvScenarioPolyp{x1}           = cat(2, R_Alive.AdvScenarioPolyp{x1}, Alive.AdvScenarioPolyp{x1, x2}(1:100)');
            
            R_Life_Years_Lost.NoPolyp{x1}                    = cat(2, R_Life_Years_Lost.NoPolyp{x1}, Life_Years_Lost.NoPolyp{x1, x2}');
            R_Life_Years_Lost.OnePolyp{x1}                   = cat(2, R_Life_Years_Lost.OnePolyp{x1}, Life_Years_Lost.OnePolyp{x1, x2}');
            R_Life_Years_Lost.TwoPolyp{x1}                   = cat(2, R_Life_Years_Lost.TwoPolyp{x1}, Life_Years_Lost.TwoPolyp{x1, x2}'); 
            R_Life_Years_Lost.OneAdvPolyp{x1}                = cat(2, R_Life_Years_Lost.OneAdvPolyp{x1}, Life_Years_Lost.OneAdvPolyp{x1, x2}');    
            R_Life_Years_Lost.AdvScenarioPolyp{x1}           = cat(2, R_Life_Years_Lost.AdvScenarioPolyp{x1}, Life_Years_Lost.AdvScenarioPolyp{x1, x2}'); 
            R_Life_Years_Lost.Cancer{x1}                     = cat(2, R_Life_Years_Lost.Cancer{x1}, Life_Years_Lost.Cancer{x1, x2}');   
            
            R_Life_Years_Lost_Counter.NoPolyp{x1}            = cat(2, R_Life_Years_Lost_Counter.NoPolyp{x1}, Life_Years_Lost_Counter.NoPolyp{x1, x2}); 
            R_Life_Years_Lost_Counter.OnePolyp{x1}           = cat(2, R_Life_Years_Lost_Counter.OnePolyp{x1}, Life_Years_Lost_Counter.OnePolyp{x1, x2});
            R_Life_Years_Lost_Counter.TwoPolyp{x1}           = cat(2, R_Life_Years_Lost_Counter.TwoPolyp{x1}, Life_Years_Lost_Counter.TwoPolyp{x1, x2});
            R_Life_Years_Lost_Counter.OneAdvPolyp{x1}        = cat(2, R_Life_Years_Lost_Counter.OneAdvPolyp{x1}, Life_Years_Lost_Counter.OneAdvPolyp{x1, x2}); 
            R_Life_Years_Lost_Counter.AdvScenarioPolyp{x1}   = cat(2, R_Life_Years_Lost_Counter.AdvScenarioPolyp{x1}, Life_Years_Lost_Counter.AdvScenarioPolyp{x1, x2});
            R_Life_Years_Lost_Counter.Cancer{x1}             = cat(2, R_Life_Years_Lost_Counter.Cancer{x1}, Life_Years_Lost_Counter.Cancer{x1, x2}); 

            R_USD.NoPolyp{x1}                                = cat(2, R_USD.NoPolyp{x1}, USD.NoPolyp{x1, x2}); 
            R_USD.OnePolyp{x1}                               = cat(2, R_USD.OnePolyp{x1}, USD.OnePolyp{x1, x2});
            R_USD.TwoPolyp{x1}                               = cat(2, R_USD.TwoPolyp{x1}, USD.TwoPolyp{x1, x2});
            R_USD.OneAdvPolyp{x1}                            = cat(2, R_USD.OneAdvPolyp{x1}, USD.OneAdvPolyp{x1, x2}); 
            R_USD.AdvScenarioPolyp{x1}                       = cat(2, R_USD.AdvScenarioPolyp{x1}, USD.AdvScenarioPolyp{x1, x2});  
            R_USD.Cancer{x1}                                 = cat(2, R_USD.Cancer{x1}, USD.Cancer{x1, x2});
            
            R_USD_Counter.NoPolyp{x1}                        = cat(2, R_USD_Counter.NoPolyp{x1}, USD.NoPolyp_Counter{x1, x2}); 
            R_USD_Counter.OnePolyp{x1}                       = cat(2, R_USD_Counter.OnePolyp{x1}, USD.OnePolyp_Counter{x1, x2});
            R_USD_Counter.TwoPolyp{x1}                       = cat(2, R_USD_Counter.TwoPolyp{x1}, USD.TwoPolyp_Counter{x1, x2});
            R_USD_Counter.OneAdvPolyp{x1}                    = cat(2, R_USD_Counter.OneAdvPolyp{x1}, USD.OneAdvPolyp_Counter{x1, x2});
            R_USD_Counter.AdvScenarioPolyp{x1}               = cat(2, R_USD_Counter.AdvScenarioPolyp{x1}, USD.AdvScenarioPolyp_Counter{x1, x2}); 
            R_USD_Counter.Cancer{x1}                         = cat(2, R_USD_Counter.Cancer{x1}, USD.Cancer_Counter{x1, x2}); 
        end
    end
end

% we calculate mean and standard deviation
Readouts   = {'All', 'NoPolyp', 'OnePolyp', 'TwoPolyp', 'OneAdvPolyp', 'AdvScenarioPolyp'};
Readouts_2 = {'NoPolyp', 'OnePolyp', 'TwoPolyp', 'OneAdvPolyp', 'AdvScenarioPolyp', 'Cancer'};
clear Mean_IntervallCancer Mean_Alive Std_IntervallCancer Std_Alive

for x1 = 1 : length(Headlines) % we calculate an average
    for x2=1:length(Readouts)
        if x1 < 15
            Mean_IntervallCancer.(Readouts{x2}){x1}           = -1;
            Mean_Alive.(Readouts{x2}){x1}                     = -1;
        else
            Mean_IntervallCancer.(Readouts{x2}){x1} = mean(R_IntervallCancer.(Readouts{x2}){x1}, 2);
            Mean_Alive.(Readouts{x2}){x1}           = mean(R_Alive.(Readouts{x2}){x1}, 2);
            
            Std_IntervallCancer.(Readouts{x2}){x1}  = std(R_IntervallCancer.(Readouts{x2}){x1},0,2);
            Std_Alive.(Readouts{x2}){x1}            = std(R_Alive.(Readouts{x2}){x1},0,2);
        end
    end
       
    for x2=1:length(Readouts_2) % we calculate an average and do discounting
        if x1 < 15
            Mean_Life_Years_Lost.(Readouts_2{x2}){x1}         = -1;
            Mean_Life_Years_Lost_Counter.(Readouts_2{x2}){x1} = -1;
            Mean_USD_Counter.(Readouts_2{x2}){x1}             = -1;
            Mean_USD_Counter.(Readouts_2{x2}){x1}             = -1;
        else
            Mean_Life_Years_Lost.(Readouts_2{x2}){x1}         = mean(R_Life_Years_Lost.(Readouts_2{x2}){x1}, 2) .* DisCountMask_65;
            Mean_Life_Years_Lost_Counter.(Readouts_2{x2}){x1} = mean(R_Life_Years_Lost_Counter.(Readouts_2{x2}){x1}, 2);
            Mean_USD.(Readouts_2{x2}){x1}                     = mean(R_USD.(Readouts_2{x2}){x1}, 2) .* DisCountMask_65(1:100);
            Mean_USD_Counter.(Readouts_2{x2}){x1}             = mean(R_USD_Counter.(Readouts_2{x2}){x1}, 2);
        end
    end
end

% we correct for the respective control without repeat colonoscopy
         %1  2  3  4  5  6  7  8  9 10 11 12 13 14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  31  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51 52   53  54  55  56  57  58  59  60  61  62  63  64  65  66  67 6 8  69  70  71  72  73  74  75  76  77  78  79  80  81
RowKey = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23];

for x1=1:length(Headlines)
    for x2=1:length(Readouts_2)
        if x1 < 15
            LYG_Disc_bg.(Readouts_2{x2}){x1} = -1;
            USD_Disc_bg.(Readouts_2{x2}){x1} = -1;
        else
            LYG_Disc_bg.(Readouts_2{x2}){x1} = - Mean_Life_Years_Lost.(Readouts_2{x2}){x1} + Mean_Life_Years_Lost.(Readouts_2{x2}){RowKey(x1)};
            USD_Disc_bg.(Readouts_2{x2}){x1} = - Mean_USD.(Readouts_2{x2}){x1} + Mean_USD.(Readouts_2{x2}){RowKey(x1)};
        end
    end
end

clear SummaryLegend
for f=1:length(Headlines)
    % interval cancer all individuals
    SummaryLegend{1, 1} = 'ALL Interval cancer 66 - 71';
    SummaryLegend{2, 1} = 'ALL mean number individuals 66 - 71';
    SummaryLegend{3, 1} = 'ALL Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(1, f) = -1;
        RawTable(2, f) = -1;
        RawTable(3, f) = -1;
    else
        RawTable(1, f) = sum(Mean_IntervallCancer.(Readouts{1}){f}(67:72));
        RawTable(2, f) = mean(Mean_Alive.(Readouts{1}){f}(67:72));
        RawTable(3, f) = RawTable(1, f)/RawTable(2, f)*1000;
    end
    
    % interval cancer no polyp
    SummaryLegend{4, 1} = 'NoPolyp Interval cancer 66 - 71';
    SummaryLegend{5, 1} = 'NoPolyp mean number individuals 66 - 71';
    SummaryLegend{6, 1} = 'NoPolyp Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(4, f) = -1;
        RawTable(5, f) = -1;
        RawTable(6, f) = -1;
    else
        RawTable(4, f) = sum(Mean_IntervallCancer.(Readouts{2}){f}(67:72));
        RawTable(5, f) = mean(Mean_Alive.(Readouts{2}){f}(67:72));
        RawTable(6, f) = RawTable(4, f)/RawTable(5, f)*1000;
    end
    
    % interval cancer one polyp
    SummaryLegend{7, 1} = 'OnePolyp Interval cancer 66 - 71';
    SummaryLegend{8, 1} = 'OnePolyp mean number individuals 66 - 71';
    SummaryLegend{9, 1} = 'OnePolyp Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(7, f) = -1;
        RawTable(8, f) = -1;
        RawTable(9, f) = -1;
    else
        RawTable(7, f) = sum(Mean_IntervallCancer.(Readouts{3}){f}(67:72));
        RawTable(8, f) = mean(Mean_Alive.(Readouts{3}){f}(67:72));
        RawTable(9, f) = RawTable(7, f)/RawTable(8, f)*1000;
    end
    
    % interval cancer two polyps
    SummaryLegend{10, 1} = 'TwoPolyp Interval cancer 66 - 71';
    SummaryLegend{11, 1} = 'TwoPolyp mean number individuals 66 - 71';
    SummaryLegend{12, 1} = 'TwoPolyp Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(10, f) = -1;
        RawTable(11, f) = -1;
        RawTable(12, f) = -1;
    else
        RawTable(10, f) = sum(Mean_IntervallCancer.(Readouts{4}){f}(67:72));
        RawTable(11, f) = mean(Mean_Alive.(Readouts{4}){f}(67:72));
        RawTable(12, f) = RawTable(10, f)/RawTable(11, f)*1000;
    end
    
    % interval cancer one advanced polyp
    SummaryLegend{13, 1} = 'OneAdvPolyp Interval cancer 66 - 71';
    SummaryLegend{14, 1} = 'OneAdvPolyp mean number individuals 66 - 71';
    SummaryLegend{15, 1} = 'OneAdvPolyp Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(13, f) = -1;
        RawTable(14, f) = -1;
        RawTable(15, f) = -1;
    else
        RawTable(13, f) = sum(Mean_IntervallCancer.(Readouts{5}){f}(67:72));
        RawTable(14, f) = mean(Mean_Alive.(Readouts{5}){f}(67:72));
        RawTable(15, f) = RawTable(13, f)/RawTable(14, f)*1000;
    end
    
    % interval cancer advanced polyp scenario
    SummaryLegend{16, 1} = 'AdvScenarioPolyp Interval cancer 66 - 71';
    SummaryLegend{17, 1} = 'AdvScenarioPolyp mean number individuals 66 - 71';
    SummaryLegend{18, 1} = 'AdvScenarioPolyp Interval cancer 66 - 71 per 1000 individuals';
    if f<15
        RawTable(16, f) = -1;
        RawTable(17, f) = -1;
        RawTable(18, f) = -1;
    else
        RawTable(16, f) = sum(Mean_IntervallCancer.(Readouts{6}){f}(67:72));
        RawTable(17, f) = mean(Mean_Alive.(Readouts{6}){f}(67:72));
        RawTable(18, f) = RawTable(16, f)/RawTable(17, f)*1000;
    end

    % cost effectiveness, no polyp
    SummaryLegend{19, 1} = 'NoPolyp disc USD 66';
    SummaryLegend{20, 1} = 'NoPolyp disc LYG 66';
    SummaryLegend{21, 1} = 'NoPolyp disc USD per LYG 66';
    SummaryLegend{22, 1} = 'NoPolyp number screened 66';
    SummaryLegend{23, 1} = 'NoPolyp number cancer 66';
    if f<15
        RawTable(19, f) = -1;
        RawTable(20, f) = -1;
        RawTable(21, f) = -1;
        RawTable(22, f) = -1;
        RawTable(23, f) = -1;
    else
        RawTable(19, f) = sum(USD_Disc_bg.(Readouts_2{1}){f}(67:100));
        RawTable(20, f) = sum(LYG_Disc_bg.(Readouts_2{1}){f}(67:100));
        RawTable(21, f) = RawTable(19, f)/RawTable(20, f);
        RawTable(22, f) = Mean_USD_Counter.(Readouts_2{1}){f};
        RawTable(23, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{1}){f};
    end
    
    % cost effectiveness, one polyp 
    SummaryLegend{24, 1} = 'OnePolyp disc USD 66';
    SummaryLegend{25, 1} = 'OnePolyp disc LYG 66';
    SummaryLegend{26, 1} = 'OnePolyp disc USD per LYG 66';
    SummaryLegend{27, 1} = 'OnePolyp number screened 66';
    SummaryLegend{28, 1} = 'OnePolyp number cancer 66';
    if f<15
        RawTable(24, f) = -1;
        RawTable(25, f) = -1;
        RawTable(26, f) = -1;
        RawTable(27, f) = -1;
        RawTable(28, f) = -1;
    else
        RawTable(24, f) = sum(USD_Disc_bg.(Readouts_2{2}){f}(67:100));
        RawTable(25, f) = sum(LYG_Disc_bg.(Readouts_2{2}){f}(67:100));
        RawTable(26, f) = RawTable(24, f)/RawTable(25, f);
        RawTable(27, f) = Mean_USD_Counter.(Readouts_2{2}){f};
        RawTable(28, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{2}){f};
    end
    
    % cost effectiveness, two polyps 
    SummaryLegend{29, 1} = 'TwoPolyp disc USD 66';
    SummaryLegend{30, 1} = 'TwoPolyp disc LYG 66';
    SummaryLegend{31, 1} = 'TwoPolyp disc USD per LYG 66';
    SummaryLegend{32, 1} = 'TwoPolyp number screened 66';
    SummaryLegend{33, 1} = 'TwoPolyp number cancer 66';
    if f<15
        RawTable(29, f) = -1;
        RawTable(30, f) = -1;
        RawTable(31, f) = -1;
        RawTable(32, f) = -1;
        RawTable(33, f) = -1;
    else
        RawTable(29, f) = sum(USD_Disc_bg.(Readouts_2{3}){f}(67:100));
        RawTable(30, f) = sum(LYG_Disc_bg.(Readouts_2{3}){f}(67:100));
        RawTable(31, f) = RawTable(29, f)/RawTable(30, f);
        RawTable(32, f) = Mean_USD_Counter.(Readouts_2{3}){f};
        RawTable(33, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{3}){f};
    end
    % cost effectiveness, advanced polyp
    SummaryLegend{34, 1} = 'OneAdvPolyp disc USD 66';
    SummaryLegend{35, 1} = 'OneAdvPolyp disc LYG 66';
    SummaryLegend{36, 1} = 'OneAdvPolyp disc USD per LYG 66';
    SummaryLegend{37, 1} = 'OneAdvPolyp number screened 66';
    SummaryLegend{38, 1} = 'OneAdvPolyp number cancer 66';
    if f<15
        RawTable(34, f) = -1;
        RawTable(35, f) = -1;
        RawTable(36, f) = -1;
        RawTable(37, f) = -1;
        RawTable(38, f) = -1;
    else
        RawTable(34, f) = sum(USD_Disc_bg.(Readouts_2{4}){f}(67:100));
        RawTable(35, f) = sum(LYG_Disc_bg.(Readouts_2{4}){f}(67:100));
        RawTable(36, f) = RawTable(34, f)/RawTable(35, f);
        RawTable(37, f) = Mean_USD_Counter.(Readouts_2{4}){f};
        RawTable(38, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{4}){f};
    end
    % cost effectiveness, advanced polyp scenario
    SummaryLegend{39, 1} = 'Cancer disc USD 66';
    SummaryLegend{40, 1} = 'Cancer disc LYG 66';
    SummaryLegend{41, 1} = 'Cancer disc USD per LYG 66';
    SummaryLegend{42, 1} = 'Cancer number screened 66';
    SummaryLegend{43, 1} = 'Cancer number cancer 66';
    if f<15
        RawTable(39, f) = -1;
        RawTable(40, f) = -1;
        RawTable(41, f) = -1;
        RawTable(42, f) = -1;
        RawTable(43, f) = -1;
    else
        RawTable(39, f) = sum(USD_Disc_bg.(Readouts_2{5}){f}(67:100));
        RawTable(40, f) = sum(LYG_Disc_bg.(Readouts_2{5}){f}(67:100));
        RawTable(41, f) = RawTable(39, f)/RawTable(40, f);
        RawTable(42, f) = Mean_USD_Counter.(Readouts_2{5}){f};
        RawTable(43, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{5}){f};
    end
    % cost effectiveness, cancer
    SummaryLegend{44, 1} = 'AdvScenarioPolyp disc USD 66';
    SummaryLegend{45, 1} = 'AdvScenarioPolyp disc LYG 66';
    SummaryLegend{46, 1} = 'AdvScenarioPolyp disc USD per LYG 66';
    SummaryLegend{47, 1} = 'AdvScenarioPolyp number screened 66';
    SummaryLegend{48, 1} = 'AdvScenarioPolyp number cancer 66';
    if f<15
        RawTable(44, f) = -1;
        RawTable(45, f) = -1;
        RawTable(46, f) = -1;
        RawTable(47, f) = -1;
        RawTable(48, f) = -1;
    else
        RawTable(44, f) = sum(USD_Disc_bg.(Readouts_2{6}){f}(67:100));
        RawTable(45, f) = sum(LYG_Disc_bg.(Readouts_2{6}){f}(67:100));
        RawTable(46, f) = RawTable(44, f)/RawTable(45, f);
        RawTable(47, f) = Mean_USD_Counter.(Readouts_2{6}){f};
        RawTable(48, f) = Mean_Life_Years_Lost_Counter.(Readouts_2{6}){f};
    end
end

%%%%%% we write csv-files

 T = cell2table(num2cell(RawTable),'VariableNames',Headlines, 'RowNames',SummaryLegend);
 writetable(T, [ExcelFileName '_IntCancer_CostEffectiveness.csv'], 'WriteRowNames', true)
 
% for f=1:length(Headlines)
%     for f2=1:length(Readouts)
%         if f<15
%             RawTable_IntervalCancer_mean.(Readouts{f2})(1:100,f) = 0;
%             RawTable_Alive_mean.(Readouts{f2})(1:100,f)          = 0;
%         else
%             RawTable_IntervalCancer_mean.(Readouts{f2})(1:100,f) = Mean_IntervallCancer.(Readouts{f2}){f};
%             RawTable_Alive_mean.(Readouts{f2})(1:100,f)          = Mean_Alive.(Readouts{f2}){f};
%         end
%     end
% end
% 
% clear RowNames
% for f=1:100
%     RowNames{f} = num2str(f);
% end
% 
% for f2=1:length(Readouts)
%     T1 = cell2table(num2cell(RawTable_IntervalCancer_mean.(Readouts{f2})),'VariableNames',Headlines, 'RowNames',RowNames);
%     T2 = cell2table(num2cell(RawTable_Alive_mean.(Readouts{f2})),'VariableNames',Headlines, 'RowNames',RowNames);
% 
%     writetable(T1, [ExcelFileName '_' Readouts{f2} '_IntervalCancer_mean.csv'], 'WriteRowNames', true)
%     writetable(T2, [ExcelFileName '_' Readouts{f2} '_Alive_mean.csv'], 'WriteRowNames', true)
% end
% 
% 
% 
% 
