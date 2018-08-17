
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

function EvaluateStandardSettings

tolerance = 0.2;

ExcelFileName              = 'Stdrd_Tests_CMOST20_19072016';
ExcelSavePath              = 'U:\CMOST\Data_July_2016';
ExcelFileName              = fullfile(ExcelSavePath, ExcelFileName);

AnalysisPipeline = 'U:\CMOST\CMOST_Data\Data\Stdrd_Tests_CMOST20_15072016';
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
        if and(isempty(regexp(MasterDirectory(x,1).name, '_ModComp.mat$', 'once')),...
                isempty(regexp(MasterDirectory(x,1).name, 'RS_summary.mat$', 'once')))
            if and(~MasterDirectory(x,1).isdir, isempty(regexp(MasterDirectory(x,1).name, 'Results.mat$', 'once')))
                z=z+1;
                l = length(MasterDirectory(x,1).name)-4;
                FileName{z}  = [MasterDirectory(x,1).name(1:l) '_Results'];
                Directory{z} = pwd;
                if ~isempty(find(ismember(AllFiles, [FileName{z} '.mat'])==1));
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Benchmarks                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

counter = 1;
for f = 1 : BatchCounter
    if ~isempty(regexp(FileName{f}, '_Benchmarks_'))
        clear Results
        load(fullfile(Directory{f}, FileName{f}));
        AllBM.Value{counter} = Results.BM_Value;
        AllBM.Benchmark      = Results.Benchmark;
        AllBM.Description    = Results.BM_Description;
        counter = counter +1;
    end
end
counter = counter -1;
for f=1:length(AllBM.Value{1})
    if isnumeric(AllBM.Value{1}{f})
        sum1 = 0;
        for g=1:counter
            sum1 = sum1 + AllBM.Value{g}{f};
        end
        AllBM.Mean{f, 1} = sum1/counter;
        if and(AllBM.Mean{f} < AllBM.Benchmark{f}*(1+tolerance), AllBM.Mean{f} > AllBM.Benchmark{f}*(1-tolerance))
            AllBM.Flag{f, 1} = 'green';
      %  elseif and(AllBM.Benchmark{f}*(1+tolerance) < AllBM.Mean{f}, AllBM.Benchmark{f}*(1-tolerance) > AllBM.Mean{f})
      %      AllBM.Flag{f, 1} = 'green';
        else
            AllBM.Flag{f, 1} = 'red';
        end
    end
end

%%% benchmarks %%%
HeadLine{1, 1} = 'Description';
for f=1:counter
    HeadLine{1, f+1} = ['Results_' num2str(f)];
end
HeadLine{1, end+1} = 'mean';
HeadLine{1, end+1} = 'benchmark';
HeadLine{1, end+1} = 'flag';
xlswrite (ExcelFileName, HeadLine, 'Benchmark', 'A1')
xlswrite (ExcelFileName, AllBM.Description, 'Benchmark', 'A2')
try
    for g=1:counter
        xlswrite (ExcelFileName, AllBM.Value{g}, 'Benchmark', HeadLineColumns{g})
    end
catch exception
    rethrow (exception)
end
xlswrite (ExcelFileName, AllBM.Mean, 'Benchmark', HeadLineColumns{counter +1})
xlswrite (ExcelFileName, AllBM.Benchmark, 'Benchmark', HeadLineColumns{counter +2})
xlswrite (ExcelFileName, AllBM.Flag, 'Benchmark', HeadLineColumns{counter +3})

%%% Screening %%%
% discounting after year 50
DisCountMask = zeros(101,1);
DisCountMask(1:51)=1;
for ff=52:101
    DisCountMask(ff) = DisCountMask(ff-1)* 0.97;
end

BatchCounter = z;
NoInterventionCounter =0;
StandardColoCounter   =0;
ScreenCounter = zeros(1, 10);

for z=1:BatchCounter
    pos1 = regexp(FileName{z}, 'no_intervention');
    pos2 = regexp(FileName{z}, 'Screening_Kolo');
    pos3 = regexp(FileName{z}, 'Hemocc_II');
    pos4 = regexp(FileName{z}, 'Hemocc_Sensa');
    pos5 = regexp(FileName{z}, 'I_FOBT');
    pos6 = regexp(FileName{z}, 'RectoSigmo');
    pos7 = regexp(FileName{z}, 'Kolo_special');

    if ~isempty(pos1) || ~isempty(pos2) || ~isempty(pos3) || ~isempty(pos4) || ~isempty(pos5) || ~isempty(pos6) || ~isempty(pos7) 

        clear Results
        load(fullfile(Directory{z}, FileName{z}));
        
        Results.TotalCosts   = Results.Treatment + Results.Screening + Results.FollowUp + Results.Other;
        Results.DiscCosts    = Results.TotalCosts .* DisCountMask(1:100);
        try
            Results.SumDiscCosts = sum(Results.DiscCosts(51:100));
            
            Results.YearsLost    = Results.YearsLostCa + Results.YearsLostColo;
            Results.DiscYears    = Results.YearsLost .* DisCountMask(1:length(Results.YearsLost))';
            Results.SumDiscYears = sum(Results.DiscYears(51:100));
        catch exception
            rethrow(exception)
        end
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
        elseif ~isempty(pos3) % Hemocc II
            num = 3; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        elseif ~isempty(pos4) % Hemocc Sensa
            num = 4; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        elseif ~isempty(pos5) % I-FOBT
            num = 5; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        elseif ~isempty(pos6) % rectosigmo
            num = 6; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        elseif ~isempty(pos7) % kolo special
            num = 7; ScreenCounter(num) = ScreenCounter(num)+1;
            AllResults{num, ScreenCounter(num)} = Results.Variable;
            NumPat(num, ScreenCounter(num))  = Results.NumberPatients(51);
        end
    end
end

for f=1:7
    AllResultsMean{f} = cell(67,1);
end

for x1=1:7 % we add everything together
    for x2=1:ScreenCounter(x1)
        for x3=1:length(AllResults{x1, x2})
            if isnumeric(AllResults{x1, x2}{x3})
                if isequal(x2,1)
                    AllResultsMean{x1}{x3} = AllResults{x1, x2}{x3};
                else
                    AllResultsMean{x1}{x3} = AllResultsMean{x1}{x3} + AllResults{x1, x2}{x3};
                end
            end
        end
    end
end

for f=1:7 % we calculate an average
    for x3=1:length(AllResults{f, 1})
            if isnumeric(AllResults{f, 1}{x3})
                AllResultsMean{f}{x3} = AllResultsMean{f}{x3}/ScreenCounter(f);
            end
    end
end

NumPatAll = mean(mean(NumPat));
SummaryLegend = Results.Var_Legend;

% incidene reduction
SummaryLegend{60} = 'incidence reduction';
for f=1:7
    AllResultsMean{f}{60} = (AllResultsMean{1}{37}-AllResultsMean{f}{37}) /AllResultsMean{1}{37}*100;
end

% mortality reduction
SummaryLegend{61} = 'mortality reduction';
for f=1:7
    AllResultsMean{f}{61} = (AllResultsMean{1}{13}-AllResultsMean{f}{13}) /AllResultsMean{1}{13}*100;
end

% life years gained undiscounted
SummaryLegend{62} = 'life years gained';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{62} = ((AllResultsMean{1}{14}+AllResultsMean{1}{16}) - (AllResultsMean{f}{14}+AllResultsMean{f}{16})) /100;
    else
        AllResultsMean{f}{62} = ((AllResultsMean{1}{14}+AllResultsMean{1}{16}) - (AllResultsMean{f}{14}+AllResultsMean{f}{16})) /100;
    end
end

% screening colonoscopies
SummaryLegend{63} = 'screening colonoscopies';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{63} = AllResultsMean{f}{5}/100;
    else
        AllResultsMean{f}{63} = AllResultsMean{f}{5}/100;
    end
end

 % surveillance colonoscopies
SummaryLegend{64} = 'surveillance colonoscopies';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{64} = AllResultsMean{f}{7}/100;
    else
       AllResultsMean{f}{64} = AllResultsMean{f}{7}/100;
    end
end

% all colonoscopies
SummaryLegend{65} = 'all colonoscopies';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{65} = (AllResultsMean{f}{5}+AllResultsMean{f}{6}+AllResultsMean{f}{7})/100;
    else
        AllResultsMean{f}{65} = (AllResultsMean{f}{5}+AllResultsMean{f}{6}+AllResultsMean{f}{7})/100;
    end
end

% CRC cases prevented
SummaryLegend{66} = 'crc cases prevented';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{66} = (AllResultsMean{1}{37}-AllResultsMean{f}{37})/100;
    else
        AllResultsMean{f}{66} = (AllResultsMean{1}{37}-AllResultsMean{f}{37})/100;
    end
end

% CRC mortality cases prevented
SummaryLegend{67} = 'crc mortality cases prevented';
for f=1:7
    if isequal(f,7)
        AllResultsMean{f}{67} = (AllResultsMean{1}{13}-AllResultsMean{f}{13})/100;
    else
        AllResultsMean{f}{67} = (AllResultsMean{1}{13}-AllResultsMean{f}{13})/100;
    end
end

% colonoscopies per case prevented
SummaryLegend{68} = 'colonoscopies per case prevented';
for f=1:7
    AllResultsMean{f}{68} = AllResultsMean{f}{65}/AllResultsMean{f}{66};
end

% colonoscopies per life year gained
SummaryLegend{69} = 'colonoscopies per LY gained';
try
for f=1:7
    AllResultsMean{f}{69} = AllResultsMean{f}{65}/AllResultsMean{f}{62};
end
catch exception
    rethrow(exception)
end

clear Headlines
Headlines{1,1} = 'no_intervention';
Headlines{1,2} =  'Screening_Kolo';
Headlines{1,3} =  'Hemocc_II';
Headlines{1,4} =  'Hemocc_Sensa';
Headlines{1,5} =  'I_FOBT';
Headlines{1,6} = 'RectoSigmo';
Headlines{1,7} = 'Kolo_special';

xlswrite (ExcelFileName, Headlines, 'Screening', 'B1')
xlswrite (ExcelFileName, SummaryLegend, 'Screening', 'A2')
for f=1:7
    xlswrite (ExcelFileName, AllResultsMean{f}, 'Screening', HeadLineColumns{f})
end

%%%%%%%%%%%%%%%%%%%%
%%%  RS-RCT      %%%
%%%%%%%%%%%%%%%%%%%%

RS_Atkin = struct; Mock_Atkin = struct; RS_Holme = struct; Mock_Holme = struct;
RS_Schoen = struct; Mock_Schoen = struct; RS_Segnan = struct; Mock_Segnan = struct;
ReplicaNumber = 0;

for z=1:BatchCounter
    
    pos1 = regexp(FileName{z}, 'RS-Atkin', 'once'); % Atkin study
    pos2 = regexp(FileName{z}, 'RS-Holme', 'once'); % Holme study
    pos3 = regexp(FileName{z}, 'RS-Schoen', 'once'); % Schoen study
    pos4 = regexp(FileName{z}, 'RS-Segnan_', 'once'); % Segnan study
    posMock = regexp(FileName{z}, 'Mock', 'once');
        
    if ~isempty(pos1) || ~isempty(pos2) || ~isempty(pos3) || ~isempty(pos4) 
        FileTemp = strrep(FileName{z},'_Results' ,'_RS_summary');
        
        pos = regexp(FileTemp, '_RS_summary'); pos = pos(end);
        NumTmp0= str2num(FileTemp((pos-3)));
        NumTmp1= str2num(FileTemp((pos-2)));
        NumTmp2= str2num(FileTemp((pos-1)));
        if isempty(NumTmp1)
            ReplicaVar = NumTmp2;
        elseif isempty(NumTmp0)
            ReplicaVar = NumTmp1*10+NumTmp2;
        else
            ReplicaVar = NumTmp0*100+NumTmp1*10+NumTmp2;
        end
        ReplicaNumber = max(ReplicaNumber, ReplicaVar);
        clear RS_Evaluation 
        tmp = load(fullfile(Directory{z}, FileTemp));
        try
        if and(~isempty(pos1), isempty(pos2)) % Atkin
            if isempty(posMock)
                RS_Atkin     = Add_RS_Results(tmp, RS_Atkin, ReplicaVar);
            else
                Mock_Atkin   = Add_RS_Results(tmp, Mock_Atkin, ReplicaVar);
            end
        elseif ~isempty(pos2) % Holme
            if isempty(posMock)
                RS_Schoen     = Add_RS_Results(tmp, RS_Schoen, ReplicaVar);     
            else
                Mock_Schoen   = Add_RS_Results(tmp, Mock_Schoen, ReplicaVar);
            end
        elseif ~isempty(pos3) % Schoen
            if isempty(posMock)
                RS_Holme     = Add_RS_Results(tmp, RS_Holme, ReplicaVar);
            else
                Mock_Holme   = Add_RS_Results(tmp, Mock_Holme, ReplicaVar);
            end
        elseif ~isempty(pos4) % Segnan
            if isempty(posMock)
                RS_Segnan     = Add_RS_Results(tmp, RS_Segnan, ReplicaVar);
            else
                Mock_Segnan   = Add_RS_Results(tmp, Mock_Segnan, ReplicaVar);
            end
        end
        catch exception
            rethrow(exception)
        end
    end
end
clear HeadLines
HeadLines{1, 1} = 'year';
HeadLines{1, 2} = 'right_1';
HeadLines{1, 3} = 'right_2';
HeadLines{1, 4} = 'right_3';
HeadLines{1, 5} = 'right_4';
HeadLines{1, 6} = 'left_1';
HeadLines{1, 7} = 'left_2';
HeadLines{1, 8} = 'left_3';
HeadLines{1, 9} = 'rectum';
HeadLines{1, 10} = 'all';
HeadLines{1, 11} = 'Mortality';
HeadLines{1, 12} = '';
HeadLines{1, 14} = 'Inc red all';
HeadLines{1, 15} = 'Inc red left';
HeadLines{1, 16} = 'Inc red right';
HeadLines{1, 17} = 'Mort red final';

% we write the Excel files
[Inc_red, Mort_red, IncMean, IncMeanFinal] = Summarize_RS(ReplicaNumber, RS_Atkin, Mock_Atkin);
xlswrite (ExcelFileName, HeadLines, 'RS-Study_Atkin', 'A1')
xlswrite (ExcelFileName, IncMean, 'RS-Study_Atkin', 'A2')
xlswrite (ExcelFileName, IncMeanFinal, 'RS-Study_Atkin', 'N2')

[Inc_red, Mort_red, IncMean, IncMeanFinal] = Summarize_RS(ReplicaNumber, RS_Schoen, Mock_Schoen);
xlswrite (ExcelFileName, HeadLines, 'RS-Study_Schoen', 'A1')
xlswrite (ExcelFileName, IncMean, 'RS-Study_Schoen', 'A2')
xlswrite (ExcelFileName, IncMeanFinal, 'RS-Study_Schoen', 'N2')

[Inc_red, Mort_red, IncMean, IncMeanFinal] = Summarize_RS(ReplicaNumber, RS_Holme, Mock_Holme);
xlswrite (ExcelFileName, HeadLines, 'RS-Study_Holme', 'A1')
xlswrite (ExcelFileName, IncMean, 'RS-Study_Holme', 'A2')
xlswrite (ExcelFileName, IncMeanFinal, 'RS-Study_Holme', 'N2')

[Inc_red, Mort_red, IncMean, IncMeanFinal] = Summarize_RS(ReplicaNumber, RS_Segnan, Mock_Segnan);
xlswrite (ExcelFileName, HeadLines, 'RS-Study_Segnan', 'A1')
xlswrite (ExcelFileName, IncMean, 'RS-Study_Segnan', 'A2')
xlswrite (ExcelFileName, IncMeanFinal, 'RS-Study_Segnan', 'N2')
clear Inc_red Mort_red IncMean IncMeanFinal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  maximum clinical incidence reduction      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Treated_counter = 0; Untreated_counter = 0;
% for f=1:BatchCounter, if ~isempty(regexp(FileName{f}, '_Po..55_')), FileName{f}, end, end
for z=1:BatchCounter
    pos1 = regexp(FileName{z}, '_perfect_'); 
    pos2 = regexp(FileName{z}, '_no_intervention_'); % here the polyps are untreated

    if or(~isempty(pos1), ~isempty(pos2))
        FileTemp = strrep(FileName{z}, '_Results', '_ModComp');
        clear DiffResults
        load(fullfile(Directory{z}, FileTemp));
        
        if ~isempty(pos1)
            Treated_counter = Treated_counter +1;
            if isequal(Treated_counter, 1)
                PerfectIntPatientsTreated   = DiffResults.PerfectInterventionPatients';
                PerfectIntCancerTreated     = DiffResults.PerfectInterventionCancer';
            else
                PerfectIntPatientsTreated   = DiffResults.PerfectInterventionPatients' + PerfectIntPatientsTreated;
                PerfectIntCancerTreated     = DiffResults.PerfectInterventionCancer' + PerfectIntCancerTreated;
            end
            
        elseif ~isempty(pos2)
            Untreated_counter = Untreated_counter +1;
            if isequal(Untreated_counter, 1)
                PerfectIntPatientsUntreated   = DiffResults.PerfectInterventionPatients';
                PerfectIntCancerUntreated     = DiffResults.PerfectInterventionCancer';
            else
                PerfectIntPatientsUntreated   = DiffResults.PerfectInterventionPatients' + PerfectIntPatientsUntreated;
                PerfectIntCancerUntreated     = DiffResults.PerfectInterventionCancer' + PerfectIntCancerUntreated;
            end
        end
    end
end
HeadLinesPerfect = {'Number_treated', 'Number_untreated', 'Cancer_treated', 'Cancer_untreated'};
xlswrite (ExcelFileName, HeadLinesPerfect, 'perfect', 'A1')
xlswrite (ExcelFileName, PerfectIntPatientsTreated, 'perfect', 'A2')
xlswrite (ExcelFileName, PerfectIntPatientsUntreated, 'perfect', 'B2')
xlswrite (ExcelFileName, PerfectIntCancerTreated, 'perfect', 'C2')
xlswrite (ExcelFileName, PerfectIntCancerUntreated, 'perfect', 'D2')


Treated_counter = 0; Untreated_counter = 0;
SojournTime = [];     DwellTime = [];     OverallTime = [];
SojournTime_All = []; DwellTime_All = []; OverallTime_All = [];
Lesions_10y_55 = []; Lesions_10y_65 = []; Lesions_10y_75 = []; Lesions_10y_85 = [];
Lesions_20y_55 = []; Lesions_20y_65 = []; Lesions_20y_75 = []; Lesions_20y_85 = [];

for z=1:BatchCounter
    pos1 = regexp(FileName{z}, '_Po..55treated');
    pos2 = regexp(FileName{z}, '_Po..55_');

    if or(~isempty(pos1), ~isempty(pos2))
        FileTemp = strrep(FileName{z}, '_Results', '_ModComp');
        clear DiffResults
        load(fullfile(Directory{z}, FileTemp));
        
        if ~isempty(pos1)
            Treated_counter = Treated_counter +1;
            if isequal(Treated_counter, 1)
                Treated_NumberPolyp    = DiffResults.NumberPolyp;
                Treated_NumberNoPolyp  = DiffResults.NumberNoPolyp;
                
                Treated_PolypCancer    = DiffResults.NumberPolypCancer;
                Treated_NoPolypCancer  = DiffResults.NumberNoPolypCancer;
            else
                Treated_NumberPolyp    = Treated_NumberPolyp + DiffResults.NumberPolyp;
                Treated_NumberNoPolyp  = Treated_NumberNoPolyp + DiffResults.NumberNoPolyp;
                
                Treated_PolypCancer    = Treated_PolypCancer + DiffResults.NumberPolypCancer;
                Treated_NoPolypCancer  = Treated_NoPolypCancer + DiffResults.NumberNoPolypCancer;
            end
        elseif ~isempty(pos2)
            Untreated_counter = Untreated_counter +1;
            if isequal(Untreated_counter, 1)
                Untreated_NumberPolyp    = DiffResults.NumberPolyp;
                Untreated_NumberNoPolyp  = DiffResults.NumberNoPolyp;
                
                Untreated_PolypCancer    = DiffResults.NumberPolypCancer;
                Untreated_NoPolypCancer  = DiffResults.NumberNoPolypCancer;
            else
                Untreated_NumberPolyp    = Untreated_NumberPolyp + DiffResults.NumberPolyp;
                Untreated_NumberNoPolyp  = Untreated_NumberNoPolyp + DiffResults.NumberNoPolyp;
                
                Untreated_PolypCancer    = Untreated_PolypCancer + DiffResults.NumberPolypCancer;
                Untreated_NoPolypCancer  = Untreated_NoPolypCancer + DiffResults.NumberNoPolypCancer;
            end
            
            for g=40:90
                for f=1:length(DiffResults.DwellTime{g})
                    if DiffResults.DwellTime{g}(f) > 0 % we ignore all direct cancers
                        SojournTime = cat(2, SojournTime, DiffResults.SojournTime{g}(f));
                        DwellTime   = cat(2, DwellTime, DiffResults.DwellTime{g}(f));
                        OverallTime = cat(2, OverallTime, DiffResults.SojournTime{g}(f) + DiffResults.DwellTime{g}(f));
                    end
                end
                SojournTime_All = cat(2, SojournTime_All, DiffResults.SojournTime{g}(f));
                DwellTime_All   = cat(2, DwellTime_All, DiffResults.DwellTime{g}(f));
                OverallTime_All = cat(2, OverallTime_All, DiffResults.SojournTime{g}(f) + DiffResults.DwellTime{g}(f));
            end
            
            % percent lesions at age 55 arising within 10 or 20 years
            % before diagnosis
            tmp  = DiffResults.DwellTime{56} + DiffResults.SojournTime{56};
            tmp1 = length(find(tmp < 10))/length(tmp) * 100;
            tmp2 = length(find(tmp < 20))/length(tmp) * 100;
            Lesions_10y_55 = cat(2, Lesions_10y_55, tmp1);
            Lesions_20y_55 = cat(2, Lesions_20y_55, tmp2);
            
            % percent lesions at age 65 arising within 10 or 20 years
            % before diagnosis
            tmp  = DiffResults.DwellTime{66} + DiffResults.SojournTime{66};
            tmp1 = length(find(tmp < 10))/length(tmp) * 100;
            tmp2 = length(find(tmp < 20))/length(tmp) * 100;
            Lesions_10y_65 = cat(2, Lesions_10y_65, tmp1);
            Lesions_20y_65 = cat(2, Lesions_20y_65, tmp2);
            
            % percent lesions at age 75 arising within 10 or 20 years
            % before diagnosis
            tmp  = DiffResults.DwellTime{76} + DiffResults.SojournTime{76};
            tmp1 = length(find(tmp < 10))/length(tmp) * 100;
            tmp2 = length(find(tmp < 20))/length(tmp) * 100;
            Lesions_10y_75 = cat(2, Lesions_10y_75, tmp1);
            Lesions_20y_75 = cat(2, Lesions_20y_75, tmp2);
            
            % percent lesions at age 85 arising within 10 or 20 years
            % before diagnosis
            tmp  = DiffResults.DwellTime{86} + DiffResults.SojournTime{86};
            tmp1 = length(find(tmp < 10))/length(tmp) * 100;
            tmp2 = length(find(tmp < 20))/length(tmp) * 100;
            Lesions_10y_85 = cat(2, Lesions_10y_85, tmp1);
            Lesions_20y_85 = cat(2, Lesions_20y_85, tmp2);
        end
    end
end
PolypTimes2{1, 1} = mean(Lesions_10y_55);
PolypTimes2{2, 1} = mean(Lesions_20y_55);
PolypTimes2{1, 2} = mean(Lesions_10y_65);
PolypTimes2{2, 2} = mean(Lesions_20y_65);
PolypTimes2{1, 3} = mean(Lesions_10y_75);
PolypTimes2{2, 3} = mean(Lesions_20y_75);
PolypTimes2{1, 4} = mean(Lesions_10y_85);
PolypTimes2{2, 4} = mean(Lesions_20y_85);

PolypTimes{1, 1} = mean(SojournTime);
PolypTimes{1, 2} = mean(SojournTime_All);
PolypTimes{1, 3} = mean(DwellTime);
PolypTimes{1, 4} = mean(DwellTime_All);
PolypTimes{1, 5} = mean(OverallTime);
PolypTimes{1, 6} = mean(OverallTime_All);

PolypTimes{2, 1} = median(SojournTime);
PolypTimes{2, 2} = median(SojournTime_All);
PolypTimes{2, 3} = median(DwellTime);
PolypTimes{2, 4} = median(DwellTime_All);
PolypTimes{2, 5} = median(OverallTime);
PolypTimes{2, 6} = median(OverallTime_All);

PolypTimes{3, 1} = quantile(SojournTime, 0.25);
PolypTimes{3, 2} = quantile(SojournTime_All, 0.25);
PolypTimes{3, 3} = quantile(DwellTime, 0.25);
PolypTimes{3, 4} = quantile(DwellTime_All, 0.25);
PolypTimes{3, 5} = quantile(OverallTime, 0.25);
PolypTimes{3, 6} = quantile(OverallTime_All, 0.25);

PolypTimes{4, 1} = quantile(SojournTime, 0.75);
PolypTimes{4, 2} = quantile(SojournTime_All, 0.75);
PolypTimes{4, 3} = quantile(DwellTime, 0.75);
PolypTimes{4, 4} = quantile(DwellTime_All, 0.75);
PolypTimes{4, 5} = quantile(OverallTime, 0.75);
PolypTimes{4, 6} = quantile(OverallTime_All, 0.75);

clear HeadLines
HeadLines = {'Untreated_NumberPolyp', 'Untreated_NumberNoPolyp', 'Untreated_PolypCancer', 'Untreated_NoPolypCancer',...
    'Treated_NumberPolyp', 'Treated_NumberNoPolyp', 'Treated_PolypCancer', 'Treated_NoPolypCancer',...
    '', 'Explanation', 'Sojourn no direct', 'Sojourn all', 'Dwell no direct', 'Dwell all',...
    'Overall no direct', 'Overall all', '', 'Explanation',...
    'age 55', 'age 65', 'age 75', 'age 85'};

LineExpl{1, 1} = 'mean';
LineExpl{2, 1} = 'median';
LineExpl{3, 1} = 'lower quartile';
LineExpl{4, 1} = 'upper quartile';

LineExpl2{1, 1} = 'lesions arising within 10y';
LineExpl2{2, 1} = 'lesions arising within 20y';

xlswrite (ExcelFileName, HeadLines, 'Diff_Pol_eva', 'A1')
xlswrite (ExcelFileName, LineExpl, 'Diff_Pol_eva', 'J2')
xlswrite (ExcelFileName, LineExpl2, 'Diff_Pol_eva', 'R2')
xlswrite (ExcelFileName, Untreated_NumberPolyp', 'Diff_Pol_eva',   'A2')
xlswrite (ExcelFileName, Untreated_NumberNoPolyp', 'Diff_Pol_eva', 'B2')
xlswrite (ExcelFileName, Untreated_PolypCancer', 'Diff_Pol_eva',   'C2')
xlswrite (ExcelFileName, Untreated_NoPolypCancer', 'Diff_Pol_eva', 'D2')
xlswrite (ExcelFileName, Treated_NumberPolyp', 'Diff_Pol_eva',     'E2')
xlswrite (ExcelFileName, Treated_NumberNoPolyp', 'Diff_Pol_eva',   'F2')
xlswrite (ExcelFileName, Treated_PolypCancer', 'Diff_Pol_eva',     'G2')
xlswrite (ExcelFileName, Treated_NoPolypCancer', 'Diff_Pol_eva',   'H2')

xlswrite (ExcelFileName, PolypTimes, 'Diff_Pol_eva', 'K2')
xlswrite (ExcelFileName, PolypTimes2, 'Diff_Pol_eva', 'S2')  

function [tmp, tmp_Counter] = Add_RS_Results(x, tmp, tmp_Counter)
try
tmp.right_1{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 1:2), 2);
tmp.right_2{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 1:4), 2);
tmp.right_3{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 1:5), 2);
tmp.right_4{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 1:6), 2);

tmp.left_1{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 10:13), 2);
tmp.left_2{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 7:13), 2);
tmp.left_3{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 6:13), 2);
tmp.left_4{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 5:13), 2);

tmp.rectum{tmp_Counter} = sum(x.RS_Evaluation.Tumor(:, 13), 2);
tmp.all{tmp_Counter}    = sum(x.RS_Evaluation.Tumor(:, 1:13), 2);

tmp.Mortality{tmp_Counter}      = x.RS_Evaluation.Mortality;
tmp.NumberSurvived{tmp_Counter} = x.RS_Evaluation.NumberSurvived;
catch exception
    rethrow(exception)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Subfunctions            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Inc_red, Mort_red, IncMean, IncMeanFinal] = Summarize_RS(RS_Counter, RS, Mock)
try
for f=1:RS_Counter
    for g=1:40
        Inc.right_1(f, g) = (1-sum(RS.right_1{f}(1:g))/sum(Mock.right_1{f}(1:g)))*100;
        Inc.right_2(f, g) = (1-sum(RS.right_2{f}(1:g))/sum(Mock.right_2{f}(1:g)))*100;
        Inc.right_3(f, g) = (1-sum(RS.right_3{f}(1:g))/sum(Mock.right_3{f}(1:g)))*100;
        Inc.right_4(f, g) = (1-sum(RS.right_4{f}(1:g))/sum(Mock.right_4{f}(1:g)))*100;
        
        Inc.left_1(f, g) = (1-sum(RS.left_1{f}(1:g))/sum(Mock.left_1{f}(1:g)))*100;
        Inc.left_2(f, g) = (1-sum(RS.left_2{f}(1:g))/sum(Mock.left_2{f}(1:g)))*100;
        Inc.left_3(f, g) = (1-sum(RS.left_3{f}(1:g))/sum(Mock.left_3{f}(1:g)))*100;
        Inc.left_4(f, g) = (1-sum(RS.left_4{f}(1:g))/sum(Mock.left_4{f}(1:g)))*100;
        
        Inc.rectum(f, g) = (1-sum(RS.rectum{f}(1:g))/sum(Mock.rectum{f}(1:g)))*100;
        Inc.all(f, g)    = (1-sum(RS.all{f}(1:g))/sum(Mock.all{f}(1:g)))*100;
        
        Mort(f, g)       = (1-sum(RS.Mortality{f}(1:g))/sum(Mock.Mortality{f}(1:g)))*100; %#ok<AGROW>
    end
    Inc_red.all(f)     = Inc.all(f, 12);
    Inc_red.left(f)    = Inc.left_2(f, 12);
    Inc_red.right(f)   = Inc.right_2(f, 12);
    Mort_red(f)        = Mort(f, 12); %#ok<AGROW>
end

IncMean(:, 1) = 1:40;
IncMean(:, 2) = mean(Inc.right_1, 1);
IncMean(:, 3) = mean(Inc.right_2, 1);
IncMean(:, 4) = mean(Inc.right_3, 1);
IncMean(:, 5) = mean(Inc.right_4, 1);

IncMean(:, 6) = mean(Inc.left_1, 1);
IncMean(:, 7) = mean(Inc.left_2, 1);
IncMean(:, 7) = mean(Inc.left_3, 1);
IncMean(:, 8) = mean(Inc.left_4, 1);

IncMean(:, 9)  = mean(Inc.rectum, 1);
IncMean(:, 10) = mean(Inc.all, 1);
IncMean(:, 11) = mean(Mort, 1);

IncMeanFinal(1, 1) = mean(Inc_red.all);
IncMeanFinal(1, 2) = mean(Inc_red.left);
IncMeanFinal(1, 3) = mean(Inc_red.right);
IncMeanFinal(1, 4) = mean(Mort_red);
catch exception
    rethrow(exception)
end