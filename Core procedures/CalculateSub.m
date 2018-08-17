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

function [handles, BM] = CalculateSub(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Preparation of Variables         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we prepare variables for transfer to a mex function  

p     = 10;   % types of polyps
n     = handles.Variables.Number_patients; %%number patients

% Direct Cancer
counter = 1;
for x1=1:19
    for x2=1:5
        DirectCancerRate(1, counter) = (handles.Variables.DirectCancerRate(1, x1) * (5-x2) + ...
            handles.Variables.DirectCancerRate(1, x1+1) * (x2-1))/4;
        DirectCancerRate(2, counter) = (handles.Variables.DirectCancerRate(2, x1) * (5-x2) + ...
            handles.Variables.DirectCancerRate(2, x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
DirectCancerRate(1, counter : 150) = handles.Variables.DirectCancerRate(1, end);
DirectCancerRate(2, counter : 150) = handles.Variables.DirectCancerRate(2, end);
DirectCancerSpeed = handles.Variables.DirectCancerSpeed;

% StageVariables
StageVariables.Progression          = handles.Variables.Progression;
StageVariables.FastCancer           = handles.Variables.FastCancer;
StageVariables.FastCancer(6:10)     = 0;
StageVariables.Healing              = handles.Variables.Healing;
StageVariables.Symptoms             = handles.Variables.Symptoms;
StageVariables.Colo_Detection       = handles.Variables.Colo_Detection;
StageVariables.RectoSigmo_Detection = handles.Variables.RectoSigmo_Detection;

StageVariables.Mortality            = handles.Variables.Mortality;

if isfield(handles.Variables,'DwellSpeed') %% I do not understand
    DwellSpeed        = handles.Variables.DwellSpeed;
else
    DwellSpeed        = 'Fast';
end

%m change
DwellSpeed        = 'Slow';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Location                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Location                                         
Location.NewPolyp            = handles.Variables.Location_NewPolyp;
Location.DirectCa            = handles.Variables.Location_DirectCa;
Location.EarlyProgression    = handles.Variables.Location_EarlyProgression;
Location.AdvancedProgression = handles.Variables.Location_AdvancedProgression;
Location.CancerProgression   = handles.Variables.Location_CancerProgression;
Location.CancerSymptoms      = handles.Variables.Location_CancerSymptoms;
Location.ColoDetection       = handles.Variables.Location_ColoDetection;
Location.RectoSigmoDetection = handles.Variables.Location_RectoSigmoDetection; 
% Location.RectoSigmoDetection = handles.Variables.Location_ColoDetection(1:10); % change later
Location.ColoReach           = handles.Variables.Location_ColoReach;
Location.RectoSigmoReach     = handles.Variables.Location_RectoSigmoReach;
% Location.RectoSigmoReach     = handles.Variables.Location_ColoReach;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   male or female                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% female 1=male, 2=female.

female.fraction_female               = handles.Variables.fraction_female;
female.new_polyp_female              = handles.Variables.new_polyp_female;
female.early_progression_female      = handles.Variables.early_progression_female;
female.advanced_progression_female   = handles.Variables.advanced_progression_female;
female.symptoms_female               = handles.Variables.symptoms_female;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Costs                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost

Cost.Colonoscopy                    = handles.Variables.Cost.Colonoscopy;
Cost.Colonoscopy_Polyp              = handles.Variables.Cost.Colonoscopy_Polyp;
Cost.Colonoscopy_Cancer             = handles.Variables.Cost.Colonoscopy_Cancer;
Cost.Sigmoidoscopy                  = handles.Variables.Cost.Sigmoidoscopy;
Cost.Sigmoidoscopy_Polyp            = handles.Variables.Cost.Sigmoidoscopy_Polyp;
Cost.Colonoscopy_Perforation        = handles.Variables.Cost.Colonoscopy_Perforation;
Cost.Colonoscopy_Serosal_burn       = handles.Variables.Cost.Colonoscopy_Serosal_burn;
Cost.Colonoscopy_bleed              = handles.Variables.Cost.Colonoscopy_bleed;
Cost.Colonoscopy_bleed_transfusion  = handles.Variables.Cost.Colonoscopy_bleed_transfusion;
Cost.FOBT                           = handles.Variables.Cost.FOBT;
Cost.I_FOBT                         = handles.Variables.Cost.I_FOBT;
Cost.Sept9_HighSens                 = handles.Variables.Cost.Sept9_HighSens;
Cost.Sept9_HighSpec                 = handles.Variables.Cost.Sept9_HighSpec;
Cost.other                          = handles.Variables.Cost.other;

% current treatment costs
CostStage.Initial(1)  = handles.Variables.Cost.Initial_I; 
CostStage.Initial(2)  = handles.Variables.Cost.Initial_II;
CostStage.Initial(3)  = handles.Variables.Cost.Initial_III;
CostStage.Initial(4)  = handles.Variables.Cost.Initial_IV;
CostStage.Cont(1)     = handles.Variables.Cost.Cont_I;
CostStage.Cont(2)     = handles.Variables.Cost.Cont_II;
CostStage.Cont(3)     = handles.Variables.Cost.Cont_III;
CostStage.Cont(4)     = handles.Variables.Cost.Cont_IV;
CostStage.Final(1)    = handles.Variables.Cost.Final_I;
CostStage.Final(2)    = handles.Variables.Cost.Final_II;
CostStage.Final(3)    = handles.Variables.Cost.Final_III;
CostStage.Final(4)    = handles.Variables.Cost.Final_IV;
CostStage.Final_oc(1) = handles.Variables.Cost.Final_oc_I;
CostStage.Final_oc(2) = handles.Variables.Cost.Final_oc_II;
CostStage.Final_oc(3) = handles.Variables.Cost.Final_oc_III;
CostStage.Final_oc(4) = handles.Variables.Cost.Final_oc_IV;

% treatment costs in the near future    
CostStage.FutInitial(1)  = handles.Variables.Cost.FutInitial_I;
CostStage.FutInitial(2)  = handles.Variables.Cost.FutInitial_II;
CostStage.FutInitial(3)  = handles.Variables.Cost.FutInitial_III;
CostStage.FutInitial(4)  = handles.Variables.Cost.FutInitial_IV;
CostStage.FutCont(1)     = handles.Variables.Cost.FutCont_I;
CostStage.FutCont(2)     = handles.Variables.Cost.FutCont_II;
CostStage.FutCont(3)     = handles.Variables.Cost.FutCont_III;
CostStage.FutCont(4)     = handles.Variables.Cost.FutCont_IV;
CostStage.FutFinal(1)    = handles.Variables.Cost.FutFinal_I;
CostStage.FutFinal(2)    = handles.Variables.Cost.FutFinal_II;
CostStage.FutFinal(3)    = handles.Variables.Cost.FutFinal_III;
CostStage.FutFinal(4)    = handles.Variables.Cost.FutFinal_IV;
CostStage.FutFinal_oc(1) = handles.Variables.Cost.FutFinal_oc_I;
CostStage.FutFinal_oc(2) = handles.Variables.Cost.FutFinal_oc_II;
CostStage.FutFinal_oc(3) = handles.Variables.Cost.FutFinal_oc_III;
CostStage.FutFinal_oc(4) = handles.Variables.Cost.FutFinal_oc_IV;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Complications                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% risc

risc.Colonoscopy_RiscPerforation         = handles.Variables.Colonoscopy_RiscPerforation;
risc.Rectosigmo_Perforation              = handles.Variables.Rectosigmo_Perforation;
risc.Colonoscopy_RiscSerosaBurn          = handles.Variables.Colonoscopy_RiscSerosaBurn;
risc.Colonoscopy_RiscBleedingTransfusion = handles.Variables.Colonoscopy_RiscBleedingTransfusion;
risc.Colonoscopy_RiscBleeding            = handles.Variables.Colonoscopy_RiscBleeding;

risc.DeathPerforation                    = handles.Variables.DeathPerforation;
risc.DeathBleedingTransfusion            = handles.Variables.DeathBleedingTransfusion;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Special scenarios              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flag, SpecialText

% we pad the strings to ensure length is always equal for the mex function
SpecialText = handles.Variables.SpecialText;
tmp = '                         ';
if length(SpecialText) >= 25
    SpecialText = SpecialText (1:25);
else tmp(1:length(SpecialText)) = SpecialText;
    SpecialText = tmp; 
end

flag.Polyp_Surveillance  = isequal(handles.Variables.Polyp_Surveillance, 'on');
flag.Cancer_Surveillance = isequal(handles.Variables.Cancer_Surveillance, 'on');
flag.SpecialFlag         = isequal(handles.Variables.SpecialFlag, 'on');
flag.Screening           = isequal(handles.Variables.Screening.Mode, 'on');
flag.Correlation         = isequal(handles.Variables.RiskCorrelation, 'on');

% SpecialFlags
flag.Schoen     = false;
flag.Holme      = false;
flag.Segnan     = false;
flag.Atkin      = false;
flag.perfect    = false;
flag.Mock       = false;
flag.Kolo1      = false;
flag.Kolo2      = false;
flag.Kolo3      = false;
flag.Po55       = false;
flag.treated    = false;
flag.AllPolypFollowUp = false;

% poor bowel preparation
if ~contains(SpecialText, 'PBP')
    flag.PBP = false;
    PBP.Year = -1;
    PBP.RepeatYear = -1;
    PBP.Mock = -1;
else
    flag.PBP = true;
    tmp  = strfind(SpecialText, 'PBP');
    [tmp2, status] = str2num(SpecialText((tmp+4):(tmp+5)));
    if status
        PBP.Year = tmp2;
    else
        error('PBP_year could not be deciphered')
    end
    
    tmp  = strfind(SpecialText, 'WW');
    [tmp2, status] = str2num(SpecialText((tmp+2):(tmp+3))); %#ok<*ST2NM>
    if status
        PBP.RepeatYear = tmp2;
    else
        if isequal(SpecialText((tmp+2):(tmp+3)), 'xx')
            PBP.RepeatYear = -1;
        else
            error('PBP repeat year could not be deciphered')
        end
    end
    
    if  contains(SpecialText, 'Mock')
        PBP.Mock = 1;
    else
        PBP.Mock = -1;
    end
    
end


if isequal(SpecialText(1:9), 'RS-Schoen')
    flag.Schoen = true;
elseif isequal(SpecialText(1:8), 'RS-Holme')
    flag.Holme = true;
elseif isequal(SpecialText(1:9), 'RS-Segnan')
    flag.Segnan = true;
elseif isequal(SpecialText(1:8), 'RS-Atkin')
    flag.Atkin = true;
elseif isequal(SpecialText(1:7), 'perfect')
    flag.perfect = true;
elseif isequal(SpecialText(1:16), 'AllPolypFollowUp')
    flag.AllPolypFollowUp = true;
elseif isequal(SpecialText(1:5), 'Kolo1')
    flag.Kolo1 = true;
elseif isequal(SpecialText(1:5), 'Kolo2')
    flag.Kolo2 = true;
elseif isequal(SpecialText(1:5), 'Kolo3')
    flag.Kolo3 = true;
elseif isequal(SpecialText(1:6), 'Po+-55')
    flag.Po55   = true;
elseif ~isempty(regexp(SpecialText, 'treated', 'once'))
    flag.treated = true;
end
if ~isempty(regexp(SpecialText, 'Mock', 'once'))
    flag.Mock = true;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Screening Variables          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PercentPop, Adherence, FollowUp, y-start, y-end, interval, y after colo, specificity    
ScreeningTest(1, 1:8) = [handles.Variables.Screening.Colonoscopy(1:2), 0, handles.Variables.Screening.Colonoscopy(3:7)];
ScreeningTest(2, 1:8) = handles.Variables.Screening.Rectosigmoidoscopy; 
ScreeningTest(3, 1:8) = handles.Variables.Screening.FOBT;
ScreeningTest(4, 1:8) = handles.Variables.Screening.I_FOBT;
ScreeningTest(5, 1:8) = handles.Variables.Screening.Sept9_HiSens;
ScreeningTest(6, 1:8) = handles.Variables.Screening.Sept9_HiSpec;
ScreeningTest(7, 1:8) = handles.Variables.Screening.other;

ScreeningHandles = {'Colonoscopy', 'Rectosigmoidoscopy', 'FOBT', 'I_FOBT',...
    'Sept9_HiSens', 'Sept9_HiSpec', 'other'};
% 1: colonoscopy, 2: Rectosigmoidoscopy, 3: FOBT, 4: I_FOBT
% 5: Sept9_HiSens, 6: Sept9_HiSpec, 7: other

ScreeningMatrix = zeros(1, 1000);
Start = 1;
Summe = 0;
for f=1:length(ScreeningHandles)
    Summe = Summe + handles.Variables.Screening.(ScreeningHandles{f})(1);
end
for f=1:length(ScreeningHandles)
    if handles.Variables.Screening.(ScreeningHandles{f})(1) > 0
        Ende = round(handles.Variables.Screening.(ScreeningHandles{f})(1) * 1000);
        ScreeningMatrix(Start:Ende) = f;
        Start = Ende + 1;
    end
end

% P1, P2, P3, P4, P5, P6, Ca1, Ca2, Ca3, Ca4 
Sensitivity(3,:)        = handles.Variables.Screening.FOBT_Sens;
Sensitivity(4,:)        = handles.Variables.Screening.I_FOBT_Sens;
Sensitivity(5,:)        = handles.Variables.Screening.Sept9_HiSens_Sens;
Sensitivity(6,:)        = handles.Variables.Screening.Sept9_HiSpec_Sens;
Sensitivity(7,:)        = handles.Variables.Screening.other_Sens;

% we define polyp 1-4 as early, 5-6 as advanced
AgeProgression      = zeros(6, 150);
AgeProgression(1,:) = handles.Variables.EarlyProgression    * handles.Variables.Progression(1);
AgeProgression(2,:) = handles.Variables.EarlyProgression    * handles.Variables.Progression(2);
AgeProgression(3,:) = handles.Variables.EarlyProgression    * handles.Variables.Progression(3);
AgeProgression(4,:) = handles.Variables.EarlyProgression    * handles.Variables.Progression(4);
AgeProgression(5,:) = handles.Variables.AdvancedProgression * handles.Variables.Progression(5);
AgeProgression(6,:) = handles.Variables.AdvancedProgression * handles.Variables.Progression(6);

NewPolyp              = handles.Variables.NewPolyp;              % 1:150
ColonoscopyLikelyhood = handles.Variables.ColonoscopyLikelyhood; % 1:150

IndividualRisk = zeros(1, n);
RiskDistribution.EarlyRisk      = handles.Variables.EarlyRisk;
RiskDistribution.AdvancedRisk   = handles.Variables.AdvRisk;

Gender         = zeros(1, n);
for f=1:n
    % we calculate an individual polyp appearance risk per patient
    IndividualRisk(f) = handles.Variables.IndividualRisk(round(rand*499)+1);
    % we calculate the gender of the patient. 1 = male, 2 = female.
    if rand < handles.Variables.fraction_female
        Gender(f) = 2;
    else
        Gender(f) = 1;
    end
    ScreeningPreference(f) = ScreeningMatrix(round(rand*999)+1);
end

% Calculating Mortality
% source: relative survival by survival time by caner site: all ages, all
% races, both sexes 1988-2008.
SurvivalTmp = [100,... 
82.4, ... y1
74.6, ... y2
69.5, ... y3
65.9, ... y4
63.3, ... y5
61.5, ... y6 for now we use only until year 6
60,   ... y7
58.9, ... y8
58,   ... y9
57.3];  % y10
SurvivalTmp = SurvivalTmp/100;

% we create a smooth curve
counter = 1;
for x1=1:5
    for x2=1:4
        Surf(counter) = SurvivalTmp(x1) * (5-x2)/4 + SurvivalTmp(x1+1) * (x2-1)/4;
        counter = counter +1;
    end
end
Surf(counter) = SurvivalTmp(x1+1);
Surf          = ones(1, 21) - Surf;
MortalityCorrection = handles.Variables.MortalityCorrectionGraph - ones(1, 150);
try
MortalityMatrix  = ones(4, 100, 1000)*25; 
for f=1:4
    Surf2 = Surf * (StageVariables.Mortality(f+6))/(1-SurvivalTmp(6));
    for x=1:21
        Surf4(x) = Surf2(x)*Surf2(x);
    end
    for y=1:100
        for f2=1:length(Surf2)
            MortTemp(f2) = Surf2(f2) +...
                Surf2(f2) * MortalityCorrection(y)/(Surf2(f2) * MortalityCorrection(y)+Surf2(f2))...
                *(1-Surf4(f2));
        end
        MortTemp2 = MortTemp(2:21);
        MortTemp2(MortTemp2>1) = 1;
        IndStart = 1;
        try
        for g=1:20
            IndEnd = round(MortTemp2(g)*1000);
            if IndEnd < 1, IndEnd = 1; end
            MortalityMatrix(f, y, IndStart : IndEnd) = g;
            IndStart = IndEnd+1;
            if IndStart > 1000, IndStart = 1000; end
            if isequal(g, 20)
                MortalityMatrix(f, y, IndStart:round(MortTemp2(g)*1000)) = 20;
                if round(MortTemp2(g)*1000) < 1000
                    MortalityMatrix(f, y, round(MortTemp2(g)*1000+1):1000) = 25;
                end
            end
        end
        MortalityMatrix(f, y,1:1000) = MortalityMatrix(f, y, randperm(1000));
        catch
            rethrow(lasterror)
        end
    end
end
catch
    rethrow(lasterror)
end

% Life Table
LifeTable        = handles.Variables.LifeTable;
%LifeTable = zeros(size(LifeTable));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%          STAGES                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

StageDuration = [ 1 0 0 0;...
    0.468	    0.532       0           0;...
    0.25        0.398	    0.352       0;
    0.162       0.22        0.275	    0.343];
%     0.45	    0.55        0           0;...
%     0.12        0.135	    0.745       0;
%     0.11        0.15        0.327	    0.413];


% StageDuration = [ 1 0 0 0;...
%     0.67	    0.33        0           0;...
%     0.19        0.178	    0.632       0;
%     0.2         0.15        0.27	    0.38];
% %     0.45	    0.55        0           0;...
% %     0.12        0.135	    0.745       0;
% %     0.11        0.15        0.327	    0.413];

tx1 = ...
[0.442	0.490	0.010	0.003;
0.413	0.515	0.017	0.006;
0.385	0.533	0.028	0.010;
0.716	1.091	0.083	0.032;
0.662	1.101	0.118	0.050;
0.913	1.645	0.243	0.111;
0.833	1.616	0.321	0.158;
1.004	2.087	0.546	0.288;
0.899	1.992	0.675	0.380;
0.996	2.344	1.012	0.605;
1.223	3.049	1.654	1.047;
1.670	4.396	2.960	1.979;
1.571	4.352	3.598	2.532;
1.233	3.587	3.604	2.663;
0.668	2.036	2.464	1.907;
0.405	1.289	1.864	1.508;
0.274	0.910	1.560	1.317;
0.231	0.800	1.615	1.420;
0.146	0.527	1.243	1.137;
0.123	0.461	1.267	1.204;
0.069	0.270	0.856	0.843;
0.059	0.236	0.863	0.881;
0.025	0.104	0.434	0.458;
0.021	0.091	0.434	0.473;
0.018	0.080	0.434	0.488];

% we use this matrix to conveniently assign a location to each new polyp
LocationMatrix = zeros(2, 1000);
Counter = 1;
% location for new polyp
for f = 1 : 13
    Ende = round(sum(Location.NewPolyp(1:f))/sum(Location.NewPolyp)*1000);
    LocationMatrix(1, Counter:Ende) = f;
    Counter = Ende;
end
Counter = 1;
% location for direct cancer
for f = 1 : 13
    Ende = round(sum(handles.Variables.Location_DirectCa(1:f))/sum(handles.Variables.Location_DirectCa)*1000);
    LocationMatrix(2, Counter:Ende) = f;
    Counter = Ende;
end

data   = struct;
data.n = n;
if isequal (SpecialText(1:6), 'Po+-55') 
    LifeTable = zeros(size(LifeTable));
end
% flag.Polyp_Surveillance  = 1 == 1;
% flag.Cancer_Surveillance = 1 == 1;
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      CODEGEN                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% for codegen put the breakpoint below this line
All={p, StageVariables, Location, Cost, CostStage, risc, flag, SpecialText, female, Sensitivity,...
    ScreeningTest, ScreeningPreference, AgeProgression,NewPolyp, ColonoscopyLikelyhood, IndividualRisk,...
    RiskDistribution, Gender, LifeTable, MortalityMatrix,LocationMatrix, StageDuration, tx1, DirectCancerRate,...
    DirectCancerSpeed,DwellSpeed, PBP}; %#ok<NASGU>

% The index 100000 in the command line below indicates that the population size is
% 100000. If the population size is different from this, the name of the
% file below may be changed. More importantly, the file
% NumberCrunching_V2.m should be modified to replace all occurances of
% 100000 to 50000 or 25000 as required.

% Running the command codegen requires a C compiler to be associated with
% Matlab. The list of supported compilers for Matlab
% R2015b release is given at the following URL:
% http://www.mathworks.com/support/compilers/R2015b/maci64.html 
% One can add the C compiler by beginnnig with the command
% >> mex -setup
% in the command line.

% for codegeneration type this line (without '%') in the command line
% codegen NumberCrunching_V2_2_100000 -args All

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Running the calulations      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to run the calculations number crunching is used
try
    [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
                    data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
                    data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
                    data.DwellTimeProgression, data.DwellTimeFastCancer,...
                    data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
                    data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
                    data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive, data.PBP_Doc]...
                    = NumberCrunching(p, StageVariables, Location, Cost, CostStage, risc,...
                    flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
                    NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
                    LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed, PBP,SurvivalTmp, MortalityCorrection);
catch exception %#ok<NASGU>
    errordlg('Could not run CMOST calculations using optimized routines by Jan Poleszczuk', 'No Jan Poleszczuk optimized subroutines')
    
    switch n
        case 100000
            [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
                data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
                data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
                data.DwellTimeProgression, data.DwellTimeFastCancer,...
                data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
                data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
                data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive, data.PBP_Doc]...
                = NumberCrunching_100000_PBP_IndCosts_mex(p, StageVariables, Location, Cost, CostStage, risc,...
                flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
                NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
                LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed, PBP);            
    end
end
% catch exception %#ok<NASGU>
%     error('Could not run CMOST calculations using coder optimized subroutines. CMOST will try to use the standard version of the code. Check manual for deatails.')
%     % the mex versions of the tool were not available. We will use the slower uncompiled versions. The user should consult the manual and use coder. 
%     try
%         switch n
%             case 10000
%                 [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
%                     data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
%                     data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
%                     data.DwellTimeProgression, data.DwellTimeFastCancer,...
%                     data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
%                     data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
%                     data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive]...
%                     = NumberCrunching_10000(p, StageVariables, Location, Cost, CostStage, risc,...
%                     flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
%                     NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
%                     LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed);
%             case 25000
%                 [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
%                     data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
%                     data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
%                     data.DwellTimeProgression, data.DwellTimeFastCancer,...
%                     data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
%                     data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
%                     data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive]...
%                     = NumberCrunching_25000(p, StageVariables, Location, Cost, CostStage, risc,...
%                     flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
%                     NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
%                     LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed);
%             case 50000
%                 [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
%                     data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
%                     data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
%                     data.DwellTimeProgression, data.DwellTimeFastCancer,...
%                     data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
%                     data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
%                     data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive]...
%                     = NumberCrunching_50000(p, StageVariables, Location, Cost, CostStage, risc,...
%                     flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
%                     NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
%                     LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed);
%             case 100000
%                 [data.y, data.Gender, data.DeathCause, data.Last, data.DeathYear, data.NaturalDeathYear,...
%                     data.DirectCancer, data.DirectCancerR, data.DirectCancer2, data.DirectCancer2R,...
%                     data.ProgressedCancer, data.ProgressedCancerR, data.TumorRecord,...
%                     data.DwellTimeProgression, data.DwellTimeFastCancer,...
%                     data.HasCancer, data.NumPolyps, data.MaxPolyps, data.AllPolyps, data.NumCancer, data.MaxCancer,...
%                     data.PaymentType, data.Money, data.Number, data.EarlyPolypsRemoved,...
%                     data.DiagnosedCancer, data.AdvancedPolypsRemoved, data.YearIncluded, data.YearAlive]...
%                     = NumberCrunching_100000(p, StageVariables, Location, Cost, CostStage, risc,...
%                     flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
%                     NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
%                     LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed);
%         end
%     catch exception %#ok<NASGU>
%         errordlg('Could not run CMOST calculations. Check CalculateSub program and available versions of NumberCrunching for consistency.', 'Cannot run calculations.')
%         return
%     end
% end

data.InputCost = Cost;
data.InputCostStage = CostStage;
    
% for some evaluations special algorithms exist
% if flag.SpecialFlag
%     if flag.Atkin || flag.Schoen || flag.Segnan || flag.Holme
%         % rectosigmoidoscopy randomized controlled trial
%         if isequal(n, 100000)
%             tmp = RS_Evaluation_fast(data, handles.Variables);
%         else
%             tmp = RS_Evaluation(data, handles.Variables);
%         end
%     elseif flag.Po55 || flag.perfect
%         DifferentialPolypEvaluation (data, handles.Variables)
%     end
% elseif isequal(SpecialText(1:17), '_no_intervention_')   
%     DifferentialPolypEvaluation (data, handles.Variables)
% end

% we start the evaluation routine
data.PBP = PBP;
[data,BM] = Evaluation_PBP_IndCosts(data, handles.Variables); % ,Step,Iter); BM
BM.RSRCT  = tmp;
