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

function RS_Evaluation = RS_Evaluation(data, Variables)

% we need to split up the incidence colorectal carcinoma according to location.
% mortality to crc according to inclusion in study

n=data.n;
Tumor = zeros(70, 13);
Counter = 1;
SpecialText = Variables.SpecialText;

SurvivalMatrix  = zeros(1, 100);
CancerMortality = zeros(1, 100);
PatientsAtRisk  = zeros(1, 100);
Survival        = zeros(1, n);

% [Tumor, Counter, SurvivalMatrix, CancerMortality, Survival] = function...
%         (DeathYear, Included, PatientNumber, Location, PatientsAtRisk, CancerMortality)
% data.DeathYear
% data.Last.Included
% data.TumorRecord.PatientNumber
% data.TumorRecord.Location
% data.DeathCause

try
%     if or(or(isequal(SpecialText, 'RS-RCT-Validation') , isequal(SpecialText, 'RS-RCT-Validation_Mock')),...
%            or(isequal(SpecialText, 'RS-Holme') , isequal(SpecialText, 'RS-Holme_Mock'))) 
        for z=1:n
            TestYear = data.Last.Included(z);
            % if isequal(data.Last.TestDone(z), 1) % this would be the per-protocol analysis
            if data.DeathYear(z) > TestYear % if the patient had been alive during the test period
                if ~isequal(TestYear, -1) % if the patient had not been excluded
                    PatientsAtRisk(1: (round(data.DeathYear(z)) - TestYear +1)) = PatientsAtRisk(1: (round(data.DeathYear(z)) - TestYear +1)) + 1;
                    for y=(TestYear-1):100
                        pos = find(data.TumorRecord.PatientNumber(y,:)==z, 1);
                        if ~isempty(pos)
                            Location = data.TumorRecord.Location(y, pos);
                            Tumor(y-TestYear+2, Location) = Tumor(y-TestYear+2, Location) +1;
                        end
                        if isequal(data.DeathYear(z), y)
                            if isequal(data.DeathCause(z), 2) % CRC specific mortality
                                CancerMortality(y-TestYear+2) = CancerMortality(y-TestYear+2) +1;
                            end
                        end
                    end
                    
                    Survival(Counter)     = data.DeathYear(z)-TestYear;
                    SurvivalMatrix(Counter, 1:round(data.DeathYear(z))-TestYear) =1;
                    
     %               CauseOfDeath(Counter) = data.DeathCause(z);
                    Counter = Counter + 1;
                end
                %     end
            end
        end
Survival = Survival(1:Counter);

%     elseif and(isequal(SpecialText(1:6), 'RS-RCT'),...
%             ~or(isequal(SpecialText, 'RS-RCT-Validation'), isequal(SpecialText, 'RS-RCT-Validation_Mock')))
%         for z=1:n
%             TestYear = data.Last.TestYear(z);
%             if isequal(data.Last.TestDone(z), 1)
%                 for y=TestYear-1:100
%                     pos = find(data.TumorRecord.PatientNumber(y,:)==z, 1);
%                     if ~isempty(pos)
%                         Location = data.TumorRecord.Location(y, pos);
%                         Tumor(y-TestYear+2, Location) = Tumor(y-TestYear+2, Location) +1;
%                     end
%                     if isequal(data.DeathYear(z), y)
%                         if isequal(data.DeathCause(z), 2)
%                             CancerMortality(y-TestYear+2) = CancerMortality(y-TestYear+2) +1;
%                         end
%                     end
%                 end
%                 
%                 Survival(Counter)     = data.DeathYear(z)-TestYear;
%                 SurvivalMatrix(Counter, 1:round(data.DeathYear(z))-TestYear) =1;
%                 
%                 CauseOfDeath(Counter) = data.DeathCause(z);
%                 Counter = Counter + 1;
%             end
%         end
%     end
catch Exception
    rethrow(Exception)
end

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