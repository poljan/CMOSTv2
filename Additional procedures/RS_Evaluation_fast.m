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

function RS_Evaluation = RS_Evaluation_fast(data, Variables)

% we need to split up the incidence colorectal carcinoma according to location.
% mortality to crc according to inclusion in study

n=data.n;


DeathYear = data.DeathYear;
Included  = data.Last.Included;
PatientNumber = data.TumorRecord.PatientNumber;
Location  = data.TumorRecord.Location;
DeathCause = data.DeathCause;

%%% for codegen put the breakpoint below this line
All={DeathYear, Included, PatientNumber, Location, DeathCause, n};
% codegen QuickRS -args All


[Tumor, Counter, SurvivalMatrix, CancerMortality, Survival, PatientsAtRisk] = QuickRS_mex ...
    (DeathYear, Included, PatientNumber, Location, DeathCause, n);

Survival = Survival(1:Counter);
TestIncluded = sum(data.Last.TestDone == 1);
for f=1:50
    FractionSurvived(f,1) = sum(Survival>=f-1)/TestIncluded*100;
    NumberSurvived(f,1)   = sum(SurvivalMatrix(:, f));
end

SummaryLegend = {'Number Patients';... 
    'Included in study';...        , 2 %2
    'Average Age';...               %3
    'Average included patients';... %4
    'Screening Colonoscopies';...   %5 
    'Symptom Colonoscopies';...     %6
    'Follow up Colonoscopies';...   %7
    'Rectosigmoidoscopies';...      %8
    'Colon cancer deaths of included';...          %
    'Years lost to colon cancer of included';...
    'Patients died of colonoscopy of included';... 
    'Years lost due to colonoscopy of included';... 
    'comment'; 'settings name'};


SummaryVariable{1,1} = n;
SummaryVariable{2,1} = TestIncluded;
SummaryVariable{3,1} = round(sum(data.DeathYear)/n*100)/100;
SummaryVariable{4,1} = round(sum(data.DeathYear(data.Last.TestDone==1))/TestIncluded*100)/100;

SummaryVariable{5,1} = sum(data.Number.Screening_Colonoscopy);
SummaryVariable{6,1} = sum(data.Number.Symptoms_Colonoscopy);
SummaryVariable{7,1} = sum(data.Number.Follow_Up_Colonoscopy);
SummaryVariable{8,1} = sum(data.Number.RectoSigmo);

SummaryVariable{9,1} = sum(data.DeathCause(data.Last.TestDone==1) == 2);
SummaryVariable{10,1}= sum(data.NaturalDeathYear(and((data.Last.TestDone==1), (data.DeathCause==2)))...
    -data.DeathYear(and((data.Last.TestDone==1), (data.DeathCause==2))));
SummaryVariable{11,1} = sum(data.DeathCause(data.Last.TestDone==1) == 3);
SummaryVariable{12,1} = sum(data.NaturalDeathYear(and((data.Last.TestDone==1), (data.DeathCause==3)))...
    -data.DeathYear(and((data.Last.TestDone==1), (data.DeathCause==3))));

SummaryVariable{13,1} = Variables.Comment;
SummaryVariable{14,1} = Variables.Settings_Name;

% HeadLineColumns_1={'B1' 'C1' 'D1' 'E1' 'F1' 'G1' 'H1' 'I1' 'J1' 'K1' 'L1' 'M1' 'N1' 'O1' 'P1' 'Q1' 'R1' 'S1' 'T1' 'U1'...
%     'V1' 'W1' 'X1' 'Y1' 'Z1' 'AA1' 'AB1' 'AC1' 'AD1' 'AE1' 'AF1' 'AG1' 'AH1' 'AI1' 'AJ1' 'AK1'};
% HeadLineColumns_2={'B2' 'C2' 'D2' 'E2' 'F2' 'G2' 'H2' 'I2' 'J2' 'K2' 'L2' 'M2' 'N2' 'O2' 'P2' 'Q2' 'R2' 'S2' 'T2' 'U2'...
%     'V2' 'W2' 'X2' 'Y2' 'Z2' 'AA2' 'AB2' 'AC2' 'AD2' 'AE2' 'AF2' 'AG2' 'AH2' 'AI2' 'AJ2' 'AK2'};

FileName = fullfile(Variables.ResultsPath, [Variables.Settings_Name '_RS_summary']);

% [Succ Msg] = xlswrite(FileName, SummaryLegend, 'Summary', 'A2');
% %#ok<NASGU,ASGLU> [Succ Msg]=xlswrite(FileName, SummaryVariable,
% 'Summary', 'B2'); %#ok<NASGU,ASGLU>
%     
% [Succ Msg] = xlswrite(FileName, reshape((1:50), 50, 1), 'Cancer Incidence', 'A2'); %#ok<NASGU,ASGLU>
% [Succ Msg] = xlswrite(FileName, Tumor(1:50, 1:13),      'Cancer Incidence', 'B2');
% 
% [Succ Msg] = xlswrite(FileName, reshape((1:50), 50, 1), 'Mortality',  'A2'); %#ok<NASGU,ASGLU>
% [Succ Msg] = xlswrite(FileName, FractionSurvived, 'Mortality',  'B2'); 
% [Succ Msg] = xlswrite(FileName, NumberSurvived, 'Mortality',  'C2'); 
% [Succ Msg] = xlswrite(FileName, reshape(CancerMortality(1:50), 50 ,1), 'Mortality',  'D2'); 

RS_Evaluation.SummaryVariable  = SummaryVariable;
RS_Evaluation.SummaryLegend    = SummaryLegend;
RS_Evaluation.Mortality        = reshape(CancerMortality(1:50), 50 ,1);
RS_Evaluation.FractionSurvived = FractionSurvived;
RS_Evaluation.NumberSurvived   = NumberSurvived;
RS_Evaluation.Tumor            = Tumor(1:50, 1:13);
RS_Evaluation.PatientsAtRisk   = PatientsAtRisk(1:50);

save(FileName, 'RS_Evaluation')

