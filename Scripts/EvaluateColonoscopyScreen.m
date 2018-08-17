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

function EvaluateColonoscopyScreen

% directory with colonoscopy files
AnalysisPipeline1           = '/Users/misselwb/Documents/CMOST_Data/Data/CMOST8_1D';
% directory with no intervention files
AnalysisPipeline2           = '/Users/misselwb/Documents/CMOST_Data/Data/Stdrd_Tests_CMOST8_15072016';

ExcelSavePath              = '/Users/misselwb/Documents/CMOST_Data';

% we check the first analysis pipeline (containing the colonoscopy screen
% files
cd (AnalysisPipeline1)
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
                FileName1{z}  = [MasterDirectory(x,1).name(1:l) '_Results'];
                Directory1{z} = pwd;
                if ~isempty(find(ismember(AllFiles, [FileName1{z} '.mat'])==1));
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
            display(Directory1{f})
            display(FileName1{f})
        end
    end
    return
end
BatchCounter1 = z;

% we check the first analysis pipeline (containing the colonoscopy screen
% files
clear AllFiles MasterDirectory Error

cd (AnalysisPipeline2)
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
                FileName2{z}  = [MasterDirectory(x,1).name(1:l) '_Results'];
                Directory2{z} = pwd;
                if ~isempty(find(ismember(AllFiles, [FileName2{z} '.mat'])==1));
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
            display(Directory2{f})
            display(FileName2{f})
        end
    end
    return
end
BatchCounter2 = z;

HeadLineColumns={'B2' 'C2' 'D2' 'E2' 'F2' 'G2' 'H2' 'I2' 'J2' 'K2' 'L2' 'M2' 'N2' 'O2' 'P2' 'Q2' 'R2' 'S2' 'T2' 'U2'...
    'V2' 'W2' 'X2' 'Y2' 'Z2' 'AA2' 'AB2' 'AC2' 'AD2' 'AE2' 'AF2' 'AG2' 'AH2' 'AI2' 'AJ2' 'AK2'...
    'AL2' 'AM2' 'AN2' 'AO2' 'AP2' 'AQ2' 'AR2' 'AS2' 'AT2' 'AU2' 'AV2' 'AW2' 'AX2' 'AY2' 'AZ2'...
    'BA2' 'BB2' 'BC2' 'BD2' 'BE2' 'BF2' 'BG2' 'BH2' 'BI2' 'BJ2' 'BK2' 'BL2' 'BM2' 'BN2'...
    'Bo2' 'Bp2' 'Bq2' 'Br2' 'Bs2' 'Bt2' 'Bu2' 'Bv2' 'Bw2' 'Bx2' 'By2' 'Bz2' 'ca2' 'cb2'};


%%% Screening %%%
% discounting after year 50
DisCountMask = zeros(101,1);
DisCountMask(1:20)=1;
for f=21:101
    DisCountMask(f) = DisCountMask(f-1)* 0.97;
end

for f=1:100
    CostsScreeningComplete{f} = zeros(1,100);
end;
% we identify and read the files with 1 colonoscopy
for z=1:BatchCounter1
    pos1 = regexp(FileName1{z}, '_1D__ScX', 'once');

    if ~isempty(pos1) 
        clear Results
        load(fullfile(Directory1{z}, FileName1{z}));
        
        Results.TotalCosts   = (Results.Treatment + Results.Screening + Results.FollowUp + Results.Other)  * 1000;
        Results.DiscCosts    = Results.TotalCosts .* DisCountMask(1:100);
        Results.SumDiscCosts = sum(Results.DiscCosts(21:100));
        
        Results.YearsLost    = Results.YearsLostCa + Results.YearsLostColo;
        Results.DiscYears    = Results.YearsLost .* DisCountMask(1:length(Results.YearsLost))';
        pos2 = regexp(FileName1{z}, '_repeat_');
        
        YearVariable    = str2num(FileName1{z}(pos2-2)) * 10 + str2num(FileName1{z}(pos2-1)); %#ok<ST2NM>
        ReplicaVariable = str2num(FileName1{z}(pos2+8)) * 10 + str2num(FileName1{z}(pos2+9)); %#ok<ST2NM>
        NumberCaAll(YearVariable, ReplicaVariable)   = Results.Variable{37};
        NumberCaDeath(YearVariable, ReplicaVariable) = Results.Variable{13};
        YearsLost(YearVariable, ReplicaVariable)     = sum(Results.YearsLost(21:100));
        DiscYearsLost(YearVariable, ReplicaVariable) = sum(Results.DiscYears(21:100));
        Costs(YearVariable, ReplicaVariable)         = sum(Results.TotalCosts(21:100));
        DiscCosts(YearVariable, ReplicaVariable)     = Results.SumDiscCosts;
        AllResults{YearVariable, ReplicaVariable} = Results.Variable;
        ScreeningColoCounter(YearVariable, ReplicaVariable) = 1;
        
        CostsScreening(YearVariable, ReplicaVariable)  = sum(Results.Screening(20:100))  * 1000;
        try
            CostsScreeningComplete{YearVariable}        = CostsScreeningComplete{YearVariable} + Results.Screening';
        catch exception
            rethrow(exception)
        end
        CostsTreatment(YearVariable, ReplicaVariable)  = sum(Results.Treatment(20:100)) * 1000;
        CostsFollowUp(YearVariable, ReplicaVariable)   = sum(Results.FollowUp(20:100)) * 1000;
        CostsOther(YearVariable, ReplicaVariable)      = sum(Results.Other(20:100)) * 1000;
    end
end

% we identify and read the files with the control interventino
NoInterventionCounter = 0;
for z=1:BatchCounter2
    pos1 = regexp(FileName2{z}, 'no_intervention', 'once');
    if ~isempty(pos1)
        clear Results
        load(fullfile(Directory2{z}, FileName2{z}));
        NoInterventionCounter = NoInterventionCounter +1;
        
        Results.TotalCosts   = (Results.Treatment + Results.Screening + Results.FollowUp + Results.Other)*1000;
        Results.DiscCosts    = Results.TotalCosts .* DisCountMask(1:100);
        Results.SumDiscCosts = sum(Results.DiscCosts(21:100));
        
        Results.YearsLost    = Results.YearsLostCa + Results.YearsLostColo;
        Results.DiscYears    = Results.YearsLost .* DisCountMask(1:length(Results.YearsLost))';
        Results.SumDiscYears = sum(Results.DiscYears(21:100));
        
        ControlNumberCaAll(NoInterventionCounter)   = Results.Variable{37};
        ControlNumberCaDeath(NoInterventionCounter) = Results.Variable{13};
        ControlYearsLost(NoInterventionCounter)     = sum(Results.YearsLost(21:100));
        ControlDiscYearsLost(NoInterventionCounter) = sum(Results.DiscYears(21:100));
        ControlDiscCosts(NoInterventionCounter)     = Results.SumDiscCosts;
        ControlCosts(NoInterventionCounter)         = sum(Results.TotalCosts(21:100));
        
        ConctrolCostsScreening(YearVariable, ReplicaVariable)  = sum(Results.Screening(20:100)) * 1000;
        ConctrolCostsTreatment(YearVariable, ReplicaVariable)  = sum(Results.Treatment(20:100)) * 1000;
        ConctrolCostsFollowUp(YearVariable, ReplicaVariable)   = sum(Results.FollowUp(20:100)) * 1000;
        ConctrolCostsOther(YearVariable, ReplicaVariable)      = sum(Results.Other(20:100)) * 1000;
        
        ControlResults{NoInterventionCounter} = Results.Variable;
    end
end

% we put everything together controls
MeanControlNumberCaAll     = mean(ControlNumberCaAll);
MeanControlNumberCaDeath   = mean(ControlNumberCaDeath);
MeanControlYearsLost       = mean(ControlYearsLost);
MeanControlDiscYearsLost   = mean(ControlDiscYearsLost);
MeanControlDiscCosts       = mean(ControlDiscCosts);

% we put everything together interventions
MeanNumberCaAll     = mean(NumberCaAll, 2);
MeanNumberCaDeath   = mean(NumberCaDeath, 2);
MeanYearsLost       = mean(YearsLost, 2);
MeanDiscYearsLost   = mean(DiscYearsLost, 2);
MeanDiscCosts       = mean(DiscCosts, 2);

%Incidence reduction
IncRed  = (MeanControlNumberCaAll - MeanNumberCaAll)/MeanControlNumberCaAll * 100;

% Mortality reduction
MortRed = (MeanControlNumberCaDeath - MeanNumberCaDeath)/MeanControlNumberCaDeath * 100;

% life years gained
LifeYearsGained     = (MeanControlYearsLost - MeanYearsLost)/100;

% discounted life years gained
DiscLifeYearsGained = (MeanControlDiscYearsLost - MeanDiscYearsLost)/100;

% USD per LYG
USDperLYG           = (MeanDiscCosts - MeanControlDiscCosts)./ DiscLifeYearsGained;

% we save everything to the disc
CMOST8.ControlNumberCaAll      = ControlNumberCaAll;
CMOST8.ControlNumberCaDeath    = ControlNumberCaDeath;
CMOST8.ControlYearsLost        = ControlYearsLost;
CMOST8.ControlDiscYearsLost    = ControlDiscYearsLost;
CMOST8.ControlDiscCosts        = ControlDiscCosts;
CMOST8.ControlCosts            = ControlCosts;

CMOST8.NumberCaAll   = NumberCaAll;
CMOST8.NumberCaDeath = NumberCaDeath;
CMOST8.YearsLost     = YearsLost;
CMOST8.DiscYearsLost = DiscYearsLost;
CMOST8.DiscCosts     = DiscCosts;
CMOST8.Costs         = Costs;
CMOST8.CostsScreeningComplete = CostsScreeningComplete;

CMOST8.CostsScreening = CostsScreening;
CMOST8.CostsTreatment = CostsTreatment;
CMOST8.CostsFollowUp  = CostsFollowUp;
CMOST8.CostsOther     = CostsOther;

CMOST8.ConctrolCostsScreening = ConctrolCostsScreening;
CMOST8.ConctrolCostsTreatment = ConctrolCostsTreatment;
CMOST8.ConctrolCostsFollowUp  = ConctrolCostsFollowUp;
CMOST8.ConctrolCostsOther     = ConctrolCostsOther;

CMOST8.IncRed              = IncRed;
CMOST8.MortRed             = MortRed;
CMOST8.LifeYearsGained     = LifeYearsGained;
CMOST8.DiscLifeYearsGained = DiscLifeYearsGained;
CMOST8.USDperLYG           = USDperLYG;

cd '/Users/misselwb/Documents/CMOST_Data/Data/1D_Kolo_Summary'
save ('CMOST8_2', 'CMOST8')
display('ende')