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

function [y, Gender, DeathCause, Last, DeathYear, NaturalDeathYear,...
    DirectCancer, DirectCancerR, DirectCancer2, DirectCancer2R, ProgressedCancer, ProgressedCancerR, TumorRecord,...
    DwellTimeProgression, DwellTimeFastCancer,...
    HasCancer, NumPolyps, MaxPolyps, AllPolyps, NumCancer, MaxCancer,...
    PaymentType, Money, Number, EarlyPolypsRemoved, DiagnosedCancer, AdvancedPolypsRemoved, YearIncluded, YearAlive,...
    PBP_Doc]...
    = NumberCrunching_100000(p, StageVariables, Location, Cost, CostStage, risc,...
    flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
    NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable, MortalityMatrix,...
    LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed, DwellSpeed, PBP) %#codegen 

coder.extrinsic('sprintf', 'display')
% to do:
% write subfunction for adjustment of costs if patient died, to be included
% for colonoscopy and rectosigmoidoscopy

% INITIALIZE
n = 100000;
Included         = true(1, 100000); % initially all patients are included
Alive            = true(1, 100000); % initially all patients are alive
DeathCause       = zeros(1, 100000);
DeathYear        = zeros(1, 100000);
NaturalDeathYear = zeros(1, 100000);

DirectCancer      = zeros(5, 100);
DirectCancerR     = zeros(1, 100);
DirectCancer2     = zeros(1, 100);
DirectCancer2R    = zeros(1, 100);
ProgressedCancer  = zeros(1, 100);
ProgressedCancerR = zeros(1, 100);

PBP_Doc.Early     = ones(100000,1)*-1; 
PBP_Doc.Advanced  = ones(100000,1)*-1; 
PBP_Doc.Cancer    = ones(100000,1)*-1; 
PBP_Doc.Screening = zeros(100000,1);

TumorRecord.Stage         = zeros(100, round(100000/10));
TumorRecord.Location      = zeros(100, round(100000/10));
TumorRecord.Sojourn       = zeros(100, round(100000/10));
TumorRecord.DwellTime     = zeros(100, round(100000/10));
TumorRecord.Gender        = zeros(100, round(100000/10));
TumorRecord.Detection     = zeros(100, round(100000/10));
TumorRecord.PatientNumber = zeros(100, round(100000/10)); % RS ONLY !!!!!!

% these we won't summarize in the same variable since they are recorded
% while the tumor progresses, the TumorRecord variable while detected.
DwellTimeProgression   = zeros(100, round(100000/10));
DwellTimeFastCancer    = zeros(100, round(100000/10));

Last.Colonoscopy  = zeros(1, 100000);
Last.Polyp        = ones(1, 100000) *-100;
Last.AdvPolyp     = ones(1, 100000) *-100;
Last.Cancer       = ones(1, 100000) *-100;
Last.ScreenTest   = zeros(1,100000);
Last.Included     = zeros(1,100000); % RS ONLY !!!!!!
Last.TestDone     = zeros(1,100000); % RS ONLY !!!!!!
Last.TestYear     = zeros(1,100000); % RS ONLY !!!!!!
Last.TestYear2    = zeros(1,100000); % RS ONLY !!!!!!
AusschlussPolyp = 0;
AusschlussCa    = 0;
AusschlussKolo  = 0;
PosPolyp        = 0;
PosCa           = 0;
PosPolypCa      = 0;

Polyp.Polyps            = zeros(100000, 51);   % we initialize the polyps cells
Polyp.PolypYear         = zeros(100000, 51);   % we initialize the field for keeping track of years
Polyp.PolypLocation     = zeros(100000, 51);
Polyp.AdvProgression    = zeros(100000, 51);
Polyp.EarlyProgression  = zeros(100000, 51);

Ca.Cancer               = zeros(100000, 25);    % we initialize the cancer cells
Ca.CancerYear           = zeros(100000, 25);    % we initialize the field for keeping track of years
Ca.CancerLocation       = zeros(100000, 25);
Ca.TimeStage_I          = zeros(100000, 25);
Ca.TimeStage_II         = zeros(100000, 25);
Ca.TimeStage_III        = zeros(100000, 25);
Ca.SympTime             = zeros(100000, 25);
Ca.SympStage            = zeros(100000, 25);
Ca.DwellTime      = zeros(100000, 25);

% consider increasing this to 
Detected.Cancer         = zeros(100000, 50);    % this cancers are detected, patient might die
Detected.CancerYear     = zeros(100000, 50);    % year this cancer had beed diagnosed
Detected.CancerLocation = zeros(100000, 50);
Detected.MortTime       = zeros(100000, 50);

HasCancer = zeros(100, 100000);
NumPolyps = zeros(100, 100000);
MaxPolyps = zeros(100, 100000);

% MaxPolypsRight  = zeros(100, 100000);
% MaxPolypsRectum = zeros(100, 100000);
% MaxPolypsRest   = zeros(100, 100000);

AllPolyps       = zeros(6, 100);

DiagnosedCancer    = zeros(100, 100000);
NumCancer          = zeros(100, 100000);
MaxCancer          = zeros(100, 100000);

Money.AllCost         = zeros(100, 1);
Money.AllCostFuture   = zeros(100, 1);
Money.Treatment       = zeros(100, 1);
Money.FutureTreatment = zeros(100, 1);
Money.Screening       = zeros(100, 1);
Money.FollowUp        = zeros(100, 1);
Money.Other           = zeros(100, 1);

Number.Screening_Colonoscopy = zeros(1, 100);
Number.Symptoms_Colonoscopy  = zeros(1, 100);
Number.Follow_Up_Colonoscopy = zeros(1, 100);
Number.Baseline_Colonoscopy  = zeros(1, 100);

Number.RectoSigmo            = zeros(1, 100);
Number.FOBT                  = zeros(1, 100);
Number.I_FOBT                = zeros(1, 100);
Number.Sept9                 = zeros(1, 100);
Number.other                 = zeros(1, 100);

EarlyPolypsRemoved           = zeros(1, 100);
AdvancedPolypsRemoved        = zeros(1, 100);

YearIncluded = false(100, 100000);
YearAlive    = false(100, 100000);

% Colo_Detection_bckup = StageVariables.Colo_Detection;
%m2 
%m2 Number for each cost type
% 4 types, Type 1: For screening, Type 2: treatment; Type 3: Followup; Type
% 4: Other
%m2 Purely screening
PaymentType.FOBT             = zeros(1, 100);
PaymentType.I_FOBT           = zeros(1, 100);
PaymentType.Sept9_HighSens   = zeros(1, 100);
PaymentType.Sept9_HighSpec   = zeros(1, 100);
PaymentType.RS               = zeros(1, 100);
PaymentType.RSPolyp          = zeros(1, 100);

%m2 Colonoscopy can be for screening, treatment, followup,  
PaymentType.Colonoscopy      = zeros(4,100); 
PaymentType.ColonoscopyPolyp = zeros(4,100);

%m2 Complications at anytime screening, treatment or followup
PaymentType.Colonoscopy_Cancer= zeros(4, 100);
PaymentType.Perforation      = zeros(4, 100);
PaymentType.Serosa           = zeros(4, 100);
PaymentType.Bleeding         = zeros(4, 100);
PaymentType.BleedingTransf   = zeros(4, 100);

%m2 cancer treatment costs index is for stage
PaymentType.Cancer_ini      = zeros(4, 101);
PaymentType.Cancer_con      = zeros(4, 101);
PaymentType.Cancer_fin      = zeros(4, 101);

%m2 cancer treatment costs index is for stage, noted by quarters
PaymentType.QCancer_ini      = zeros(4, 101,4);
PaymentType.QCancer_con      = zeros(4, 101,20);
PaymentType.QCancer_fin      = zeros(4, 101,4);

PaymentType.Other            = zeros(1, 100);

% matrix for fast indexing
GenderProgression = ones(10, 2);
GenderProgression(1:4, 2) = female.early_progression_female;
GenderProgression(5:6, 2) = female.advanced_progression_female;

% matrix for fast indexing
LocationProgression = zeros(10, 13); % 10 polyps x 13 locations
LocationProgression(1, :) = Location.EarlyProgression;
LocationProgression(2, :) = Location.EarlyProgression;
LocationProgression(3, :) = Location.EarlyProgression;
LocationProgression(4, :) = Location.EarlyProgression;
LocationProgression(5, :) = Location.EarlyProgression;
%LocationProgression(5, :)= Location.AdvancedProgression;
LocationProgression(6, :) = Location.AdvancedProgression;
LocationProgression(7, :) = Location.CancerProgression;
LocationProgression(8, :) = Location.CancerProgression;
LocationProgression(9, :) = Location.CancerProgression;
LocationProgression(10, :) = Location.CancerProgression;

% reach of rectosigmoidoscopy
TmpLoc = zeros(13,1000);
for f = 1:13
    TmpLoc(f, 1:round(1000*Location.RectoSigmoReach(f))) = 1;
end
for f = 1:12
    TmpLoc(f+1, :) = or(TmpLoc(f+1, :), TmpLoc(f, :));
end
RectoSigmoReachMatrix = -sum(TmpLoc, 1)+14;
% reach of colonoscopy
TmpLoc = zeros(13,1000);
for f = 1:13
    TmpLoc(f, 1:round(1000*Location.ColoReach(f))) = 1;
end
for f = 1:12
    TmpLoc(f+1, :) = or(TmpLoc(f+1, :), TmpLoc(f, :));
end
ColoReachMatrix = -sum(TmpLoc, 1)+14;

Counter = 1;
for f = 1 : 13
    Ende = round(sum(Location.NewPolyp(1:f))/sum(Location.NewPolyp)*1000);
    LocationMatrix(Counter:Ende) = f;
    Counter = Ende;
end

% Cancer progression
% Stage 1: 5%, Stage 2: 35%, Stage 3: 40%, Stage 4: 20%.
StageMatrix = zeros(1000, 1);
StageMatrix(1:150)    = 7; 
StageMatrix(151:506)   = 8;
StageMatrix(507:785)  = 9;
StageMatrix(786:1000) = 10;

tx2 = 0.25 : 0.25 : 6.25;
SojournMatrix = zeros(1000, 4);
for f=1:4
    tx3 = tx1(:, f);
    tx3 = round(tx3/sum(tx3)*10*1000);
    Counter = 1;
    for f2=1:25
        if ~isequal(round(tx3(f2)/10), 0)
            SojournMatrix(Counter : round(sum(tx3(1:f2))/10), f) = tx2(f2);
            Counter = round(sum(tx3(1:f2))/10);
            if and(isequal(f2, 25), ~isequal(Counter, 1000))
                SojournMatrix(Counter:1000, f) = tx2(f2);
            end
        end
    end
end

CaSurv  = zeros(1,4);
CaDeath = zeros(1,4);

y=0; % year
while and((sum(Included) > 0), y<100)
    y=y+1;
%     if y==2
%          save variables_3_10_2013.mat
%     end
    % for speed we make this calculation in advance
    % we need to check, whether this works
    PolypRate = ones(1, 100000);
    % the individual risc
    PolypRate = PolypRate .* IndividualRisk;
    % the age specific risc
    PolypRate = PolypRate .* NewPolyp(y);
    % the gender specific risc
    PolypRate(Gender == 2) = PolypRate(Gender == 2) * female.new_polyp_female;
    
    for z=1:n
        
        for q = 1:4
            time = y + (q-1)/4;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  people die of natural causes     %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %     try
            if Alive(z)
                % divided by 4 since this is a quarterly calculation
                if rand < (LifeTable(y, Gender(z))/4)
                    Alive(z)            = false;
                    NaturalDeathYear(z) = time;
                    
                    % in these cases the patient was really alive
                    if Included(z)
                        Included(z)   = false;
                        DeathCause(z) = 1;
                        DeathYear(z)  = time;
                        
                        % we need to calculate the costs
                        if sum(Detected.Cancer(z, :)) > 0
                            [Money, PaymentType] = AddCosts(Detected, CostStage, PaymentType, Money, time, z, 'oc');
                        end
                    end
                end
            end
            %             catch exception
            %                 rethrow (exception)
            %             end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %    people die of cancer           %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %         try
            if Included(z)
                if ~isempty(find(Detected.Cancer(z, :), 1, 'first'))
                    l = length(find(Detected.Cancer(z, :)));
                    for f = 1:l
                        if Detected.MortTime(z, f) < 21
                            if (time - Detected.CancerYear(z, f)) >= Detected.MortTime(z, f)/4
                                
                                % patient died of cancer
                                Included(z)  = false;
                                DeathCause(z)= 2;
                                DeathYear(z) = time;
                                
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                % we need to calculate the costs  %
                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                
                                [Money, PaymentType] = AddCosts(Detected, CostStage, PaymentType, Money, time, z, 'tu');
                                CaDeath(Detected.Cancer(z,f)-6) = CaDeath(Detected.Cancer(z,f)-6) + 1;
                                % we leave the loop
                                break      
                            end
                        elseif (time - Detected.CancerYear(z, f)) == 21/4
                            CaSurv(Detected.Cancer(z,f)-6) = CaSurv(Detected.Cancer(z,f)-6) + 1;
                        end
                    end
                end
            end
            %             catch exception
            %                 rethrow (exception)
            %             end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % a NEW POLYP appears               %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if Included(z) % only in the first quarter
                %    try
                % a new polyp appears
                if rand < PolypRate(z)
                    if Polyp.Polyps(z, 1) > 0
                        pos = find(Polyp.Polyps(z, :), 1, 'last' )+1;
                    else
                        pos = 1;
                    end
                    if max(pos)<50 % number polyps limited to 50
                        Polyp.Polyps(z, pos)           = 1;
                        Polyp.PolypYear(z, pos)        = time;
                        Polyp.PolypLocation(z, pos)    = LocationMatrix(1, round(rand*999)+1);
                        
                        % we just save the percentile of the risk, not the
                        % absolute risk
                        Polyp.EarlyProgression(z, pos) = round(rand*499)+1;
                        
                        % if correlation applies, both percentiles are
                        % identical
                        if flag.Correlation
                            Polyp.AdvProgression(z, pos) = Polyp.EarlyProgression(z, pos);
                        else
                            Polyp.AdvProgression(z, pos) = round(rand*499)+1;
                        end
                    end
                end
                %                 catch exception
                %                     rethrow(exception)
                %                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % a NEW Cancer appears DIRECTLY     %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if rand < DirectCancerRate(Gender(z), y) * DirectCancerSpeed
                    % this is cancer now. we need to write
                    % everything into the cancer variable
                    l2 = length(find(Ca.Cancer(z, :)))+1;
                    if l2<25
                        Ca.Cancer(z, l2)         = 7;
                        Ca.CancerYear(z, l2)     = time;
                        Ca.CancerLocation(z, l2) = LocationMatrix(2, round(rand*999)+1);
                        Ca.DwellTime(z,l2)       = 0; % POSSIBLY DELETE LATER
                        
                        % a random number for stage and sojourn time
                        tmp1 = StageMatrix(round(rand*999+1));
                        tmp2 = SojournMatrix(round(rand*999+1), tmp1-6);
                        
                        Ca.SympTime(z, l2)       = time+tmp2;
                        Ca.SympStage(z, l2)      = tmp1;
                        if tmp1 > 7
                            Ca.TimeStage_I(z, l2)    = time + round(tmp2*StageDuration(tmp1-6, 1)*4)/4;
                        else
                            Ca.TimeStage_I(z, l2)    = 1000;
                        end
                        if tmp1 > 8
                            Ca.TimeStage_II(z, l2)   = time + round(tmp2*sum(StageDuration(tmp1-6, 1:2))*4)/4;
                        else
                            Ca.TimeStage_II(z, l2)   = 1000;
                        end
                        if tmp1 > 9
                            Ca.TimeStage_III(z, l2)  = time + round(tmp2*sum(StageDuration(tmp1-6, 1:3))*4)/4;
                        else
                            Ca.TimeStage_III(z, l2)  = 1000;
                        end
                        
                        % we keep track
                        DwellTimeProgression(y, length(find(DwellTimeProgression(y, :)))+1) = 0;
                        HasCancer(y:100, z) = 1;
                        DirectCancer2(y)  = DirectCancer2(y) + 1;
                        if Ca.CancerLocation(z, l2) < 4
                            DirectCancer2R(y) = DirectCancer2R(y) +1;
                        end
                    end
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %      a polyp progresses           %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %      try
                l = length(find(Polyp.Polyps(z, :)));
                for f=l:-1:1
                    tmp = AgeProgression(Polyp.Polyps(z, f), y)...
                        * LocationProgression(Polyp.Polyps(z,f), Polyp.PolypLocation(z, f))... % location influence
                        * GenderProgression(Polyp.Polyps(z, f), Gender(z))... % gender influence
                        * ((Polyp.Polyps(z, f)<5) * RiskDistribution.EarlyRisk(Polyp.EarlyProgression(z, f)) +...
                        ( Polyp.Polyps(z, f)>4) * RiskDistribution.AdvancedRisk(Polyp.AdvProgression(z, f)));

%                     switch DwellSpeed  %m2 moved the switch statement up. otherwise without cancer m remains 0
%                         case 'Slow'
%                             tmp2 = StageVariables.FastCancer(Polyp.Polyps(z, f))...
%                                 * AgeProgression(6, y)...
%                                 * LocationProgression(6, Polyp.PolypLocation(z, f))...
%                                 * GenderProgression(6, Gender(z));
%                         case 'Fast'
%                             tmp2 = StageVariables.FastCancer(Polyp.Polyps(z, f))...
%                                 * AgeProgression(6, y)...
%                                 * LocationProgression(6, Polyp.PolypLocation(z, f))...
%                                 * GenderProgression(6, Gender(z));       
%                     end
                    
                    if rand < tmp
                        Polyp.Polyps(z, f) = Polyp.Polyps(z, f)+1;
                        if Polyp.Polyps(z, f) > 6
                            % this is cancer now. we need to write
                            % everything into the cancer variable
                            l2 = length(find(Ca.Cancer(z, :)))+1;
                            Ca.Cancer(z, l2)         = 7;
                            Ca.CancerYear(z, l2)     = time;
                            Ca.CancerLocation(z, l2) = Polyp.PolypLocation(z, f);
                            Ca.DwellTime(z,l2) = time - Polyp.PolypYear(z, f); % POSSIBLY DELETE LATER
                            
                            % a random number for stage and sojourn time
                            tmp1 = StageMatrix(round(rand*999+1));
                            tmp2 = SojournMatrix(round(rand*999+1), tmp1-6);
                            
                            Ca.SympTime(z, l2)       = time+tmp2;
                            Ca.SympStage(z, l2)      = tmp1;
                            if tmp1 > 7
                                Ca.TimeStage_I(z, l2)    = time + round(tmp2*StageDuration(tmp1-6, 1)*4)/4;
                            else
                                Ca.TimeStage_I(z, l2)    = 1000; 
                            end
                            if tmp1 > 8
                                Ca.TimeStage_II(z, l2)   = time + round(tmp2*sum(StageDuration(tmp1-6, 1:2))*4)/4;
                            else
                                Ca.TimeStage_II(z, l2)   = 1000; 
                            end
                            if tmp1 > 9
                                Ca.TimeStage_III(z, l2)  = time + round(tmp2*sum(StageDuration(tmp1-6, 1:3))*4)/4;
                            else
                                Ca.TimeStage_III(z, l2)  = 1000; 
                            end
                            
                            % we keep track
                            DwellTimeProgression(y, length(find(DwellTimeProgression(y, :)))+1) =...
                                time - Polyp.PolypYear(z, f);
                            HasCancer(y:100, z) = 1;
                            ProgressedCancer(y) = ProgressedCancer(y) + 1;
                            if Ca.CancerLocation(z, l2)<4
                                ProgressedCancerR(y) = ProgressedCancerR(y) + 1;
                            end
                            % and we delete the polyp
                            Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
                            Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
                            Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
                            Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
                            Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
                        end
                    elseif rand < (strcmp(DwellSpeed,'Slow'))*(StageVariables.FastCancer(Polyp.Polyps(z, f))...
                        * AgeProgression(6, y)...
                        * LocationProgression(6, Polyp.PolypLocation(z, f))...
                        * GenderProgression(6, Gender(z)))...
                        + (strcmp(DwellSpeed,'Fast'))*(StageVariables.FastCancer(Polyp.Polyps(z, f))...
                        * AgeProgression(6, y)...
                        * LocationProgression(6, Polyp.PolypLocation(z, f))...
                        * GenderProgression(6, Gender(z)))...
                        * ((Polyp.Polyps(z, f)<5) * RiskDistribution.EarlyRisk(Polyp.EarlyProgression(z, f)) +...
                          ( Polyp.Polyps(z, f)>4) * RiskDistribution.AdvancedRisk(Polyp.AdvProgression(z, f)))
         
                    
                        % this is fast progressed cancer now. we need to write
                        % everything into the cancer variable
                        l2 = length(find(Ca.Cancer(z, :)))+1;
                        Ca.Cancer(z, l2)         = 7;
                        Ca.CancerYear(z, l2)     = time;
                        Ca.CancerLocation(z, l2) = Polyp.PolypLocation(z, f);
                        Ca.DwellTime(z,l2) = time - Polyp.PolypYear(z, f); % POSSIBLY DELETE LATER
                        
                        % a random number for stage and sojourn time
                        tmp1 = StageMatrix(round(rand*999+1));
                        tmp2 = SojournMatrix(round(rand*999+1), tmp1-6);
                        
                        Ca.SympTime(z, l2)       = time+tmp2;
                        Ca.SympStage(z, l2)      = tmp1;
                        if tmp1 > 7
                            Ca.TimeStage_I(z, l2)    = time + round(tmp2*StageDuration(tmp1-6, 1)*4)/4;
                        else
                            Ca.TimeStage_I(z, l2)    = 1000;
                        end
                        if tmp1 > 8
                            Ca.TimeStage_II(z, l2)   = time + round(tmp2*sum(StageDuration(tmp1-6, 1:2))*4)/4;
                        else
                            Ca.TimeStage_II(z, l2)   = 1000;
                        end
                        if tmp1 > 9
                            Ca.TimeStage_III(z, l2)  = time + round(tmp2*sum(StageDuration(tmp1-6, 1:3))*4)/4;
                        else
                            Ca.TimeStage_III(z, l2)  = 1000;
                        end

                        % we keep track
                        DwellTimeFastCancer(y, length(find(DwellTimeFastCancer(y, :)))+1) =...
                            time - Polyp.PolypYear(z, f);
                        HasCancer(y:100, z) = 1;
                        DirectCancer(Polyp.Polyps(z, f), y) = DirectCancer(Polyp.Polyps(z, f), y) +1;
                        if Ca.CancerLocation(z, l2)<4
                            DirectCancerR(y) = DirectCancerR(y) +1;
                        end
                        % and we delete the polyp
                        Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
                        Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
                        Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
                        Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
                        Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
                    end
                end
                %                 catch exception
                %                     rethrow(exception)
                %                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %   a polyp shrinks or disappears      %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %    try
                l = length(find(Polyp.Polyps(z, :))); % we need to calculate the length again
                for f=l:-1:1
                    if rand < StageVariables.Healing(Polyp.Polyps(z, f))
                        Polyp.Polyps(z, f) = Polyp.Polyps(z, f) - 1;
                        if isequal(Polyp.Polyps(z, f), 0)
                            % in this case, the polyp had been of the smallest size,
                            % further shrinkage causes disappearance
                            Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
                            Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
                            Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
                            Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
                            Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
                        end
                    end
                end
                %                 catch exception
                %                     rethrow(exception)
                %                 end
                                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % symptom development               %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % try
                    for f=length(find(Ca.Cancer(z, :))) : -1 : 1
                        if time >= Ca.SympTime(z,f)
                            % if symptoms appear we do colonoscopy
                            Number.Symptoms_Colonoscopy(y) = Number.Symptoms_Colonoscopy(y)+1 ;
                            [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved,...
                                Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                = Colonoscopy(z, y, q, 'Symp', Gender, Polyp,...
                                Ca, Detected, Included, DeathCause, DeathYear,...
                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            break
                        end
                    end
%                 catch exception
%                     rethrow(exception)
%                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Cancer Progression                %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %                try
                for f=1:length(find(Ca.Cancer(z, :)))
                    if isequal(Ca.Cancer(z, f), 7)
                        if time >= Ca.TimeStage_I(z, f)
                            Ca.Cancer(z, f) = 8;
                        end
                    elseif isequal(Ca.Cancer(z, f), 8)
                        if time >= Ca.TimeStage_II(z, f)
                            Ca.Cancer(z, f) = 9;
                        end
                    elseif isequal(Ca.Cancer(z, f), 9)
                        if time >= Ca.TimeStage_III(z, f)
                            Ca.Cancer(z, f) = 10;
                        end
                    end
                end
                %                 catch exception
                %                     rethrow(exception)
                %                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %    baseline colonoscopy           %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % There is a small chance,
                % symptoms appear even without a leasion
                
                %                 if isequal(q,1)
                %                     if rand < ColonoscopyLikelyhood(y)
                %                         % symptoms without a polyp: we do baseline colonoscopy
                %                         Number.Baseline_Colonoscopy(y) = Number.Baseline_Colonoscopy(y) +1;
                %                         [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                %                             DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money]...
                %                             = Colonoscopy(z, y, q, 'Base', Gender, Polyp,...
                %                             Ca, Detected, Included, DeathCause, DeathYear,...
                %                             DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                %                             StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage);
                %                     end
                %                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % polyp and cancer surveillance     %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if isequal(q, 1)
                    SurveillanceFlag = 0;
                    if flag.Polyp_Surveillance
                        % a polyp removed 5 years ago if no colonoscopy
                        % performed inbetween.
                        %      try
                        if     and(isequal(y - Last.Polyp(z), 5), ((y - Last.Colonoscopy(z)) >=5))
                            SurveillanceFlag = 1;
                            % between 5 and 9 years after polyp removal after last colonoscopy
                        elseif and((y - Last.Polyp(z))>5, (y - Last.Polyp(z))<=9) && ((y-Last.Colonoscopy(z)) >=5)
                            SurveillanceFlag = 1;
                            % This provides surveillance every 5 years after
                            % each polyp !!!
                            %   elseif and(~isequal(Last.Polyp(z), -100), y-Last.Colonoscopy(z) >=5)
                            %       SurveillanceFlag = 1;
                            % an advanced polyp 3 years ago
                        elseif and(isequal(y - Last.AdvPolyp(z), 3), (y - Last.Colonoscopy(z) >=3))
                            SurveillanceFlag = 1;
                            % 5 years intervals if an advanced polyp had been
                            % diagnosed
                        elseif ~isequal(Last.AdvPolyp(z), -100)
                            if and((y - Last.AdvPolyp(z))>=5, (y-Last.Colonoscopy(z)) >=5)
                                % and((y - LastAdvPolyp(z))>8, (y - LastAdvPolyp(z))<=13) && ((y-LastColonoscopy(z)) >=5)
                                SurveillanceFlag = 1;
                            end
                        elseif flag.AllPolypFollowUp
                            if ~isequal(Last.Polyp(z), -100)
                                if and((y - Last.Polyp(z))>=5, (y-Last.Colonoscopy(z)) >=5)
                                    SurveillanceFlag = 1;
                                end
                            end
                        end
                        %                     catch exception
                        %                         rethrow(exception)
                        %                     end
                        
                    end
                    if flag.Cancer_Surveillance
                        if ~isequal(Last.Cancer(z), -100)
                            % 1 year after cancer diagnosis
                            if  and(isequal(y - Last.Cancer(z), 1), isequal((y-Last.Colonoscopy(z)), 1))
                                SurveillanceFlag = 1;
                                % 4 years after cancer diagnosis
                            elseif  and(isequal(y - Last.Cancer(z), 4), isequal((y-Last.Colonoscopy(z)), 3))
                                SurveillanceFlag = 1;
                                % 5 years intervals after this
                            elseif  and((y - Last.Cancer(z))>=5, (y-Last.Colonoscopy(z)) >=5)
                                SurveillanceFlag = 1;
                            end
                        end
                    end
                    if isequal(SurveillanceFlag, 1)
                        Number.Follow_Up_Colonoscopy(y) = Number.Follow_Up_Colonoscopy (y) + 1;
                        [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                            = Colonoscopy(z, y, q, 'Foll', Gender, Polyp,...
                            Ca, Detected, Included, DeathCause, DeathYear,...
                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                            StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                    end
                    
                    % perhaps we do screening?
                    if flag.Screening
                        % we only screen patients who are alive
                        if and(Included(z), ~isequal(ScreeningPreference(z), 0))
                            % x-matrix
                            % 1: PercentPop, 2: Adherence,    3: FollowUp,   4:y-start, 5:y-end,
                            % 6: interval,   7: y after colo, 8: specificity
                            
                            % y-matrix
                            % 1: colonoscopy, 2: Rectosigmoidoscopy, 3: FOBT, 4: I_FOBT
                            % 5: Sept9_HiSens, 6: Sept9_HiSpec, 7: other
                            preference = ScreeningPreference(z);
                            if and(y >= ScreeningTest(preference, 4), y <ScreeningTest(preference, 5))
                                % if and(y >= Screening.Year_Start, y <Screening.Year_End) % if the patients qualifies agewise
                                if y-Last.Colonoscopy(z) >= ScreeningTest(preference, 7) % we only screen so and so many years after the last Colonoscopy
                                    
                                    if isequal(preference, 1) % Colonoscopy
                                        if y-Last.Colonoscopy(z) >= ScreeningTest(preference, 6) % interval
                                            Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                            [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                Ca, Detected, Included, DeathCause, DeathYear,...
                                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                        end
                                    elseif isequal(preference, 2) % Rectosigmoidoscopy
                                        if y-Last.ScreenTest(z) >= ScreeningTest(preference, 6)  % interval
                                            if rand < ScreeningTest(preference, 2) % compliance with test
                                                Number.RectoSigmo(y) = Number.RectoSigmo(y) + 1;
                                                Last.ScreenTest(z)   = y;
                                                [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
                                                    = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
                                                    StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag);
                                                if or(or(PolypFlag, CancerFlag), AdvPolypFlag)
                                                    % StageVariables.Colo_Detection(7:10) = 1; % BM 29.5.2016
                                                    if rand < ScreeningTest(preference, 3) % compliance with follow up kolo
                                                        Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                                        ScreeningPreference(z) = 1; % according to paper by Zauber et al. we need to continue with colonoscopy screening
                                                        [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                            = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                            Ca, Detected, Included, DeathCause, DeathYear,...
                                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                            StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                                    end
                                                    % StageVariables.Colo_Detection = Colo_Detection_bckup;
                                                end
                                            end
                                        end
                                        %%% we need to fill this
                                    else % other test
                                        % we do the Septin9 or any other test
                                        if y-Last.ScreenTest(z) >= ScreeningTest(preference, 6)
                                            if rand < ScreeningTest(preference, 2) % compliance with test
                                                Last.ScreenTest(z)   = y;
                                                Limit = 0;
                                                if ~isempty(find(Polyp.Polyps(z, :), 1, 'last'))
                                                    Limit = Sensitivity(preference, max(Polyp.Polyps(z, :)));
                                                end
                                                if ~isempty(find(Ca.Cancer(z, :), 1, 'last'))
                                                    Limit = Sensitivity(preference, max(Ca.Cancer(z, :)));
                                                end
                                                Limit = max(Limit, 1-ScreeningTest(preference, 8));
                                                if rand < Limit % if the test happens to be positive
                                                    if rand < ScreeningTest(preference, 3) % compliance with follow up
                                                        Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                                        ScreeningPreference(z) = 1; % according to paper by Zauber et al. we need to continue with colonoscopy screening
                                                        [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                            = Colonoscopy(z, y, q, 'Scre', Gender, Polyp, Ca, Detected,...
                                                            Included, DeathCause, DeathYear,...
                                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                            StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                                    end
                                                end
                                                if isequal(preference, 3)
                                                    Number.FOBT(y) = Number.FOBT(y) +1;
                                                    Money.Screening(y) = Money.Screening(y) + Cost.FOBT;
                                                    PaymentType.FOBT(1, y) = PaymentType.FOBT(1, y) +1;
                                                elseif isequal(preference, 4)
                                                    Number.I_FOBT(y)   = Number.I_FOBT(y) +1;
                                                    Money.Screening(y) = Money.Screening(y) + Cost.I_FOBT;
                                                    PaymentType.I_FOBT(1, y) = PaymentType.I_FOBT(1, y) +1;
                                                elseif isequal(preference, 5)
                                                    Number.Sept9(y)    = Number.Sept9(y) +1;
                                                    Money.Screening(y) = Money.Screening(y) + Cost.Sept9_HighSens;
                                                    PaymentType.Sept9_HighSens(1, y) = PaymentType.Sept9_HighSens(1, y) +1;
                                                elseif isequal(preference, 6)
                                                    Number.Sept9(y)    = Number.Sept9(y) +1;
                                                    Money.Screening(y) = Money.Screening(y) + Cost.Sept9_HighSpec;
                                                    PaymentType.Sept9_HighSpec(1, y) = PaymentType.Sept9_HighSpec(1, y) +1;
                                                elseif isequal(preference, 7)
                                                    Number.other(y)    = Number.other(y) +1;
                                                    Money.Screening(y) = Money.Screening(y) + Cost.other;
                                                    PaymentType.Other(1, y) = PaymentType.Other(1, y) +1;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %    special scenarios              %
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    if and(flag.SpecialFlag, isequal(q, 1))
                        if flag.PBP % the special scenario with poor bowel preparation
                            if isequal(y, PBP.Year)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                PBP_Doc.Screening(z) = 1;
                                
                                tmp = StageVariables.Colo_Detection; % we stored the colo-characteristics of PBP in this variable
                                StageVariables.Colo_Detection = StageVariables.RectoSigmo_Detection;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'PBPx', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                StageVariables.Colo_Detection = tmp;
                            end
                            if PBP.RepeatYear > -1 % if repeat year not xx (i.e. not planned)
                                if isequal(y, PBP.Year + PBP.RepeatYear)
                                    if isequal(Last.Colonoscopy(z), PBP.Year) % if a colonoscopy had not been performed recently
                                        Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                        [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                            = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,... % changed after first run
                                            Ca, Detected, Included, DeathCause, DeathYear,...
                                            DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                            StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                        
                                    end
                                end
                            end
                        end
                        if flag.Atkin 
                            if isequal(y,1)
                                if isequal(z, 1)
                                    % randomly one test year between 55 and 64
                                    tmp=55:64;
                                    for f=1:n
                                        Last.Included(f) = tmp(round(rand*(length(tmp)-1)+1));
                                        if rand < 0.71 % adherence to first screening
                                            Last.TestYear(f) = Last.Included(f);
                                        end
                                    end
                                end
                            else
                                if isequal(Last.Included(z), y)
                                    % we need to check inclusion criteria
                                    
                                    StudyFlag = true;
                                    StudyFlag = and(StudyFlag, y-Last.Colonoscopy(z)>3);
                                    StudyFlag = and(StudyFlag, isequal(Last.Cancer(z),-100));
                                    StudyFlag = and(StudyFlag, isequal(Last.Polyp(z),-100));
                                    StudyFlag = and(StudyFlag, isequal(Last.AdvPolyp(z),-100));
                                    
                                    if ~StudyFlag % we exclude the patient by setting the years to -1
                                        Last.TestYear(z)  = -1;
                                        Last.TestYear2(z) = -1;
                                        Last.Included(z)  = -1;
                                    end
                                end
                                if isequal(Last.TestYear(z), y)
                                    Last.TestDone(z) = 1;
                                    if ~flag.Mock
                                        Number.RectoSigmo(y) = Number.RectoSigmo(y) + 1;
                                        % Number.Custom(y)     = Number.Custom(y) + 1;
                                        [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
                                            = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
                                            StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag);
                                        if AdvPolypFlag  %
                                            Last.AdvPolyp(z) = y;
                                        elseif PolypFlag
                                            Last.Polyp(z) = y;
                                        end
                                        if or(AdvPolypFlag, CancerFlag) %m
                                            if PolypFlag, PosPolyp = PosPolyp + 1; end
                                            if CancerFlag, PosCa = PosCa + 1; end
                                            if and(CancerFlag, PolypFlag), PosPolypCa = PosPolypCa + 1; end
                                            
                                            % StageVariables.Colo_Detection(7:10) = 1; % BM 29.5.2017
                                            Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                            [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                Ca, Detected, Included, DeathCause, DeathYear,...
                                                DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                            % StageVariables.Colo_Detection = Colo_Detection_bckup;
                                        end
                                    end
                                end
                            end
                        elseif flag.Schoen
                            % for this validation we use the study by
                            % Schoen et al., NEJM 2012.
                            % patients aged 55-74 were 1:1 randomized to
                            % undergo two rectosigmoidoscopies. adherence for the first RS: 83.5%, 
                            % to the second RS: 54%. "In the intervention
                            % group, 83.5% of the participants underwent baseline screening and 
                            % 54.0% underwent subsequent screening. A 
                            % total of 86.6% of participants underwent at least one flexible 
                            % sigmoidoscopic screening, and 50.9% 
                        %if strcmp(SpecialText, 'RS-RCT')
                            %SpecialText
                            %fprintf('reached here 54 ')
                            if isequal(y,1) % for the first year, for the first patient we setup this validation
                                if isequal(z, 1)
                                    % randomly one test year between 55 and 74
                                    tmp=55:74;
                                    for f=1:n
                                        Last.Included(f) = tmp(round(rand*(length(tmp)-1)+1));
                                        if rand < 0.83 % adherence to first screening
                                            Last.TestYear(f) = Last.Included(f);
                                            if rand < 0.65 %0.54/0.83 % 54% of all individuals (more of the 83% screened individuals)
                                                % in the first 2 years
                                                % second screening after 3
                                                % years, last 6y after 5y
                                                if rand <0.25
                                                    Last.TestYear2(f) = Last.Included(f) + 3;
                                                else
                                                    Last.TestYear2(f) = Last.Included(f) + 5;
                                                end
                                            elseif rand < 0.035 % only second screening
                                                if rand <0.25
                                                    Last.TestYear2(f) = Last.Included(f) + 3;
                                                else
                                                    Last.TestYear2(f) = Last.Included(f) + 5;
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                if isequal(Last.Included(z), y)
                                    % we need to check inclusion and
                                    % exclusion criteria at the year of
                                    % inclusion, first quarter
                                    StudyFlag = true;
                                    StudyFlag = and(StudyFlag, y-Last.Colonoscopy(z)>3);
                                    if y-Last.Colonoscopy(z)<=3, AusschlussKolo = AusschlussKolo +1; end
                                    StudyFlag = and(StudyFlag, isequal(Last.Cancer(z),-100));
                                    if ~isequal(Last.Cancer(z),-100), AusschlussCa = AusschlussCa +1; end
                                    StudyFlag = and(StudyFlag, isequal(Last.Polyp(z),-100));
                                    if or(~isequal(Last.Polyp(z),-100), ~isequal(Last.AdvPolyp(z),-100)),
                                        AusschlussPolyp = AusschlussPolyp + 1; end
                                    StudyFlag = and(StudyFlag, isequal(Last.AdvPolyp(z),-100));
                                    
                                    if ~StudyFlag % we exclude the patient by setting the years to -1
                                        Last.TestYear(z)  = -1;
                                        Last.TestYear2(z) = -1;
                                        Last.Included(z)  = -1;
                                    end
                                end
                                if or(isequal(Last.TestYear(z), y), isequal(Last.TestYear2(z), y))
                                    % now we do the screening
                                    if isequal(q, 1)
                                        Last.TestDone(z) = 1; % for the per protocol analysis if necessary
                                        if ~flag.Mock % special text would be: 'RS-RCT-Validation_Mock'
                                            Number.RectoSigmo(y) = Number.RectoSigmo(y) + 1;
                                            % Number.Custom(y)     = Number.Custom(y) + 1;
                                            [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
                                                = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
                                                StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag);
                                            if AdvPolypFlag  %
                                                Last.AdvPolyp(z) = y;
                                            elseif PolypFlag > 0
                                                Last.Polyp(z) = y;
                                            end
                                            if or(PolypFlag > 1, or(AdvPolypFlag, CancerFlag)) % we do follow up for a polyp >0.5 cm or a cancer
                                                % please note that for this
                                                % study PolypFlag will be
                                                % 1.5 for polyps >0.5mm
                                                if PolypFlag, PosPolyp = PosPolyp + 1; end
                                                if CancerFlag, PosCa = PosCa + 1; end
                                                if and(CancerFlag, PolypFlag), PosPolypCa = PosPolypCa + 1; end
                                                
                                                % StageVariables.Colo_Detection(7:10) = 1; % BM 29.5.2017
                                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                                % StageVariables.Colo_Detection = Colo_Detection_bckup;
                                                
                                            end
                                        end
                                    end
                                end
                            end
                        elseif flag.Segnan % Segnan
                            % for this validation we use the study by
                            % SEgnan et al., JNCI 2011.
                            % patients aged 55-64 were 1:1 randomized to
                            % undergo two rectosigmoidoscopy. adherence 58.35% 
                            if isequal(y,1) % for the first year, for the first patient we setup this validation
                                if isequal(z, 1)
                                    % randomly one test year between 55 and 74
                                    tmp=55:64;
                                    for f=1:n
                                        Last.Included(f) = tmp(round(rand*(length(tmp)-1)+1));
                                        if rand < 0.583 % adherence to screening
                                            Last.TestYear(f) = Last.Included(f);
                                        end
                                    end
                                end
                            else
                                if isequal(Last.Included(z), y)
                                    % we need to check inclusion and
                                    % exclusion criteria at the year of
                                    % inclusion, first quarter
                                    StudyFlag = true;
                                    StudyFlag = and(StudyFlag, y-Last.Colonoscopy(z)>2); 
                                    StudyFlag = and(StudyFlag, isequal(Last.Cancer(z),-100));
                                    
                                    if ~StudyFlag % we exclude the patient by setting the years to -1
                                        Last.TestYear(z)  = -1;
                                        Last.TestYear2(z) = -1;
                                        Last.Included(z)  = -1;
                                    end
                                end
                                if isequal(Last.TestYear(z), y)
                                    % now we do the screening
                                    if isequal(q, 1)
                                        Last.TestDone(z) = 1; % for the per protocol analysis if necessary
                                        if ~flag.Mock % special text would be: 'RS-RCT-Validation_Mock'
                                            Number.RectoSigmo(y) = Number.RectoSigmo(y) + 1;
                                            % Number.Custom(y)     = Number.Custom(y) + 1;
                                            [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
                                                = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
                                                StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag);
                                            if AdvPolypFlag  %
                                                Last.AdvPolyp(z) = y;
                                            elseif PolypFlag > 0
                                                Last.Polyp(z) = y;
                                            end
                                            if or(PolypFlag > 1, or(AdvPolypFlag, CancerFlag)) % we do follow up for a polyp >0.5 cm or a cancer
                                                % please note that for this
                                                % study PolypFlag will be
                                                % 1.5 for polyps >0.5mm
                                                if PolypFlag, PosPolyp = PosPolyp + 1; end
                                                if CancerFlag, PosCa = PosCa + 1; end
                                                if and(CancerFlag, PolypFlag), PosPolypCa = PosPolypCa + 1; end
                                                
                                                % StageVariables.Colo_Detection(7:10) = 1; % BM 29.5.2016
                                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                                % StageVariables.Colo_Detection = Colo_Detection_bckup;
                                            end
                                        end
                                    end
                                end
                            end
                        elseif flag.Holme
                        % This uses the Norwegian Holme trial (JAMA 2014) for validation 
                        % it includes patients 50-64 years of age. 63%
                        % screening adherence. We model the intention to
                        % screen analysis of the subgroup with
                        % rectosigmoidoscopy only.
                            if isequal(y,1)
                                if isequal(z, 1)
                                    % randomly one test year between 55 and 64
                                    tmp=51:65;
                                    for f=1:n
                                        Last.Included(f) = tmp(round(rand*(length(tmp)-1)+1));
                                        if rand < 0.651 % adherence to screening
                                            Last.TestYear(f) = Last.Included(f);
                                        end
                                    end
                                end
                            else
                                if isequal(Last.TestYear(z), y)
                                    if ~isequal(Last.TestDone(z),1)
                                        % we need to check inclusion and
                                        % exclusion criteria - only
                                        % patients with previous ca will be
                                        % excluded
                                        StudyFlag = true;
                                        StudyFlag = and(StudyFlag, isequal(Last.Cancer(z),-100));
                                        if ~isequal(Last.Cancer(z),-100), AusschlussCa = AusschlussCa +1; end
                                        
                                        if StudyFlag
                                            Last.TestDone(z) = 1;
                                            if ~flag.Mock
                                                Number.RectoSigmo(y) = Number.RectoSigmo(y) + 1;
                                                % Number.Custom(y)     = Number.Custom(y) + 1;
                                                [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
                                                    = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
                                                    StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag);
                                                if AdvPolypFlag  %
                                                    Last.AdvPolyp(z) = y;
                                                elseif PolypFlag
                                                    Last.Polyp(z) = y;
                                                end
                                                if or(PolypFlag, or(AdvPolypFlag, CancerFlag)) % follow up for all lesions here 
                                                    if PolypFlag, PosPolyp = PosPolyp + 1; end
                                                    if CancerFlag, PosCa = PosCa + 1; end
                                                    if and(CancerFlag, PolypFlag), PosPolypCa = PosPolypCa + 1; end
                                                    
                                                    % StageVariables.Colo_Detection(7:10) = 1; % BM 29.5.2016
                                                    Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                                    [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                                        DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                                        = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                                        Ca, Detected, Included, DeathCause, DeathYear,...
                                                        DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                                        StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                                                    % StageVariables.Colo_Detection = Colo_Detection_bckup;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if flag.perfect
                            
                            % we do analysis, examining a perfect screening
                            % intervention once
                            PerfectYear = 66;
                            if isequal(y, PerfectYear)
                                Polyp.Polyps           = zeros(100000, 51);   % we initialize the polyps cells
                                Polyp.PolypYear        = zeros(100000, 51);   % we initialize the field for keeping track of years
                                Polyp.PolypLocation    = zeros(100000, 51);
                                Polyp.AdvProgression   = zeros(100000, 51);
                                Polyp.EarlyProgression = zeros(100000, 51);
                                
                                Ca.Cancer            = zeros(100000, 25);    % we initialize the cancer cells
                                Ca.CancerYear        = zeros(100000, 25);    % we initialize the field for keeping track of years
                                Ca.CancerLocation    = zeros(100000, 25);
                                Ca.TimeStage_I        = zeros(100000, 25);
                                Ca.TimeStage_II       = zeros(100000, 25);
                                Ca.TimeStage_III      = zeros(100000, 25);
                                Ca.SympTime           = zeros(100000, 25);
                                Ca.SympStage          = zeros(100000, 25);
                                Ca.DwellTime          = zeros(100000, 25);
                                Detected.Cancer         = zeros(100000, 50);    % this cancers are detected, patient might die
                                Detected.CancerYear     = zeros(100000, 50);    % year this cancer had beed diagnosed
                                Detected.CancerLocation = zeros(100000, 50);
                                Detected.MortTime       = zeros(100000, 50);
                                
                                TumorRecord.Stage         = zeros(100, round(100000/10));
                                TumorRecord.Location      = zeros(100, round(100000/10));
                                TumorRecord.Sojourn       = zeros(100, round(100000/10));
                                TumorRecord.DwellTime     = zeros(100, round(100000/10));
                                TumorRecord.Gender        = zeros(100, round(100000/10));
                                TumorRecord.Detection     = zeros(100, round(100000/10));
                                TumorRecord.PatientNumber = zeros(100, round(100000/10)); % RS ONLY !!!!!!

                            end
                        elseif flag.Kolo1
                            if isequal(ScreeningTest(1, 4), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                        elseif flag.Kolo2
                            if isequal(ScreeningTest(1, 4), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                            if isequal(ScreeningTest(1, 5), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                        elseif flag.Kolo3
                            if isequal(ScreeningTest(1, 4), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                            if isequal(ScreeningTest(1, 5), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                            if isequal(ScreeningTest(1, 6), y)
                                Number.Screening_Colonoscopy(y) = Number.Screening_Colonoscopy(y) + 1;
                                [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money, PBP_Doc]...
                                    = Colonoscopy(z, y, q, 'Scre', Gender, Polyp,...
                                    Ca, Detected, Included, DeathCause, DeathYear,...
                                    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved, Last, TumorRecord, PaymentType, Money,...
                                    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc);
                            end
                        elseif flag.Po55
                            if isequal(y, 56)
                                if or(or(max(Polyp.Polyps(z, :)) > 0, max(Ca.Cancer(z, :)) > 0),...
                                        or(Last.Polyp(z) > -100, Last.Cancer(z) > -100))
                                    Last.TestDone(z) = 1;
                                else
                                    Last.TestDone(z) = 2;
                                end
                                if flag.treated
                                    Polyp.Polyps(z, 1:51)           = 0;
                                    Polyp.PolypYear(z, 1:51)        = 0;
                                    Polyp.PolypLocation(z, 1:51)    = 0;
                                    Polyp.AdvProgression(z, 1:51)   = 0;
                                    Polyp.EarlyProgression(z, 1:51) = 0;
                                    
                                    Ca.Cancer        (z, 1:25) = 0;
                                    Ca.CancerYear    (z, 1:25) = 0;
                                    Ca.CancerLocation(z, 1:25) = 0;
                                    Ca.TimeStage_I   (z, 1:25) = 0;
                                    Ca.TimeStage_II  (z, 1:25) = 0;
                                    Ca.TimeStage_III (z, 1:25) = 0;
                                    Ca.SympTime      (z, 1:25) = 0;
                                    Ca.SympStage     (z, 1:25) = 0;
                                    
                                    Detected.Cancer         (z, 1:50) = 0; % this cancers are detected, patient might die
                                    Detected.CancerYear     (z, 1:50) = 0;
                                    Detected.CancerLocation (z, 1:50) = 0;
                                    Detected.MortTime       (z, 1:50) = 0;
                                    
                                end
                            end
                            % elseif (isequal(SpecialText(1:16), 'Po+-55nontreated'))
                        end
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %    summarizing polyps             %
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    % before a polyp can be detected and removed for screening we
                    % summarize the prevalence of all polyps and cancers
                    %try
                    if ~isempty(find(Polyp.Polyps(z, :), 1))
                        MaxPolyps(y, z)      = max(Polyp.Polyps(z, :));
                        NumPolyps(y, z)      = length(find(Polyp.Polyps(z, :)));
                        
                        %                     if ~isempty(find(Polyp.PolypLocation(z, :)<4, 1, 'first'))
                        %                         MaxPolypsRight(y,z)  = max(Polyp.Polyps(z, (Polyp.PolypLocation(z, :)<4)));
                        %                     end
                        %                     if ~isempty(find(and(Polyp.PolypLocation(z, :)>3, Polyp.PolypLocation(z,:)<13), 1, 'first'))
                        %                         MaxPolypsRest(y,z)   = max(Polyp.Polyps(z, and(Polyp.PolypLocation(z, :)>3, Polyp.PolypLocation(z,:)<13)));
                        %                     end
                        %                     if ~isempty(find(Polyp.PolypLocation(z, :)==13, 1, 'first'))
                        %                         MaxPolypsRectum(y,z) = max(Polyp.Polyps(z, (Polyp.PolypLocation(z, :)==13)));
                        %                     end
                        for f=1:6
                            AllPolyps(f, y) = AllPolyps(f, y) + sum(length(find(Polyp.Polyps(z, :)==f)));
                        end
                    end
                end
            end
%                 catch Exception
%                     rethrow(Exception)
%                 end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %    summarizing cancer             %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        if ~isempty(find(Ca.Cancer(z, :), 1))
            MaxCancer(y, z) = max(Ca.Cancer(z, :));
            NumCancer(y, z) = length(find(Ca.Cancer(z, :)));
        end
    end
    
    % we summarize the whole cohort
    YearIncluded(y, :) = Included;
    YearAlive(y, :)    = Alive;

    %display(sprintf('calculating results for year: %d', y))
    display(sprintf('Calculating year %d', y))
end


% Death  = zeros(1,4);
% AliveX = zeros(1,4);
% for f=1:n
%     if isequal(length(find(Detected.Cancer(f,:))), 1)
%         Stage = Detected.Cancer(f, 1)-6;
%         DiagnoseTime = Detected.CancerYear(f, 1);
%         if DeathYear(f) - DiagnoseTime <= 5
%             if DeathCause(f) == 2
%                 Death(Stage) = Death(Stage)+1;
%             end
%         else
%             AliveX(Stage) = AliveX(Stage)+1;
%         end
%     end
% end
% RelMort = zeros(1,4);
% RelMort = Death./(AliveX+Death)*100
for f=1:100000
    if Alive(f)
        NaturalDeathYear(f) = 100;
    end
end

Money.AllCost       = Money.Treatment + Money.Screening + Money.FollowUp + Money.Other; 
Money.AllCostFuture = Money.FutureTreatment + Money.Screening + Money.FollowUp + Money.Other; 
% display(sprintf('In RS-Study %d patients excluded due to Ca, %d due to Kolo, %d due to past polyps',...
%     AusschlussCa, AusschlussKolo, AusschlussPolyp)) 
% display(sprintf('In RS-examinations %d times polyps, %d times cancer and %d times polyps and cancer found',...
%     PosCa, PosPolyp, PosPolypCa))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         COLONOSCOPY                               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

function [Polyp, Ca, Detected, Included, DeathCause, DeathYear,...
    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved,...
    Last, TumorRecord, PaymentType, Money, PBP_Doc]...
    = Colonoscopy(z, y, q, Modus, Gender, Polyp,...
    Ca, Detected, Included, DeathCause, DeathYear,...
    DiagnosedCancer, AdvancedPolypsRemoved, EarlyPolypsRemoved,...
    Last, TumorRecord, PaymentType, Money,...
    StageVariables, Cost, Location, risc, ColoReachMatrix, MortalityMatrix, CostStage, PBP, PBP_Doc)

% in this function we do a colonoscopy for the respective patient (number
% z). We cure all detected polyps, and handle the case if a cancer was
% detected

% we determine the reach of this colonoscopy (cecum = 1, rectum = 13))
CurrentReach = ColoReachMatrix(round(rand*999+1));
CurrentReachMatrix = zeros(1, 13);
CurrentReachMatrix(CurrentReach:13) = 1;

% these variables we use to document the outcome of PBP 
EarlyTmp       = PBP_Doc.Early; 
AdvancedTmp    = PBP_Doc.Advanced;
CancerTmp      = PBP_Doc.Cancer;
EarlyTmp(z)    = 0;
AdvancedTmp(z) = 0;
CancerTmp(z)   = 0;


counter = 0;
for f=length(find(Polyp.Polyps(z, :))) : -1 : 1
    Tumor = Polyp.Polyps(z, f);
    if and(rand < StageVariables.Colo_Detection(Tumor) *...    % influence of polyp stage
            Location.ColoDetection(Polyp.PolypLocation(z, f)),...    % influence of location on detection
            CurrentReachMatrix(Polyp.PolypLocation(z, f)) == 1)      % has current current colonoscopy reached location of polyp?
        % we delete the current polyp
        l = length(find(Polyp.Polyps(z, :)));
        Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
        Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
        Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
        Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
        Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
        counter = counter + 1;
        if Tumor > 4
            AdvancedPolypsRemoved(y) = AdvancedPolypsRemoved(y)+1; 
            Last.AdvPolyp(z) = y;
            AdvancedTmp(z) = AdvancedTmp(z) +1; % for PBP
        else
            Last.Polyp(z) = y;
            EarlyPolypsRemoved(y) = EarlyPolypsRemoved(y) + 1;
            EarlyTmp(z) = EarlyTmp(z) +1; % for PBP
        end
    end
end
if counter > 2
    Last.AdvPolyp(z) = y; % 3 polyps counts as an advanced polyp
end

StageTmp    = 0; 
EStage      = 0;
ELocation   = 0;
ESojourn    = 0;
EDwellTime  = 0;
LocationTmp = 0;
SojournTmp  = 0;
DwellTimeTmp  = 0;

m = 0;
switch Modus  %m2 moved the switch statement up. otherwise without cancer m remains 0
    case 'Scre' % Screening
        m=1;
    case 'PBPx' % poor bowel preparateion
        m=1;
    case 'Symp' % Symptoms
        m=2;
    case 'Foll' % Follow-up
        m=3;
    case 'Base' % Baseline
        m=4;
end

for f=length(find(Ca.Cancer(z, :))) : -1 : 1
    Tumor = Ca.Cancer(z, f);
    if and(rand < StageVariables.Colo_Detection(Tumor),...        % influence of cancer stage on detection
            CurrentReachMatrix(Ca.CancerLocation(z, f)) == 1)        % has current current colonoscopy reached location of polyp?
        
        if isequal(counter, 0)
            counter = -1;
        end
        CancerTmp(z) = CancerTmp(z) +1;  % for PBP
        % the cancer is now a detected cancer
        pos = length(find(Detected.Cancer(z, :)))+1;
        Detected.Cancer(z, pos)         = Ca.Cancer(z, f);
        Detected.CancerYear(z, pos)     = y+(q-1)/4;
        Detected.CancerLocation(z, pos) = Ca.CancerLocation(z, f);
        Detected.MortTime(z, pos)       = MortalityMatrix(Ca.Cancer(z, f)-6, y, round(rand*999+1));
        % dfisplay(sprintf('cancer stage %d mortality %d months', Detected.Cancer(z, pos), Detected.MortTime(z, pos)))
        % we need keep track of key parameters
        % Stage Location SojournTime Sex DetectionMode
        StageTmp    = Tumor;
        LocationTmp = Ca.CancerLocation(z, f);
        SojournTmp  = y + (q-1)/4 - Ca.CancerYear(z, f);
        DwellTimeTmp   = Ca.DwellTime(z, f);
        
        % the original cancer is removed from the database
        l = length(find(Ca.Cancer(z, :)));
        Ca.Cancer(z, f:l)         = Ca.Cancer(z, f+1:l+1);
        Ca.CancerYear(z, f:l)     = Ca.CancerYear(z, f+1:l+1);
        Ca.CancerLocation(z, f:l) = Ca.CancerLocation(z, f+1:l+1);
        Ca.DwellTime(z, f:l) = Ca.DwellTime(z, f+1:l+1); % POSSIBLY DELETE
        Ca.SympTime(z, f:l)       = Ca.SympTime(z, f+1:l+1);
        Ca.SympStage(z, f:l)      = Ca.SympStage(z, f+1:l+1);
        Ca.TimeStage_I(z, f:l)    = Ca.TimeStage_I(z, f+1:l+1);
        Ca.TimeStage_II(z, f:l)   = Ca.TimeStage_II(z, f+1:l+1);
        Ca.TimeStage_III(z, f:l)  = Ca.TimeStage_III(z, f+1:l+1);
        
        DiagnosedCancer(y, z)  = max(DiagnosedCancer(y, z), Tumor); % max in case we would have found 2 tumors
        Last.Cancer(z)         = y;
        
        switch Modus
            case 'Scre' % Screening
                m=1;
            case 'PBPx' % poor bowel preparateion
                m=1;
            case 'Symp' % Symptoms
                m=2;
            case 'Foll' % Follow-up
                m=3;
            case 'Base' % Baseline
                m=4;
        end
    end
    
    if ~isequal(StageTmp, 0)
        if StageTmp > EStage
            EStage     = StageTmp;
            ELocation  = LocationTmp;
            ESojourn   = SojournTmp;
            EDwellTime = DwellTimeTmp;
        end
    end
end
if ~isequal(StageTmp, 0)
    pos = length(find(TumorRecord.Stage(y, :))) + 1;
    TumorRecord.Stage(y, pos)     = EStage;
    TumorRecord.Location(y, pos)  = ELocation;
    TumorRecord.DwellTime(y, pos) = EDwellTime;
    TumorRecord.Sojourn(y, pos)   = ESojourn;
    TumorRecord.Gender(y, pos)    = Gender(z);
    TumorRecord.Detection(y, pos) = m;
    TumorRecord.PatientNumber(y, pos) = z; % RS ONLY !!!!!!
end

if isequal (Modus, 'PBPx')
    PBP_Doc.Early    = EarlyTmp;
    PBP_Doc.Advanced = AdvancedTmp;
    PBP_Doc.Cancer   = CancerTmp;
end

Last.Colonoscopy(z) = y;

if isequal(counter, 0) % in this case no tumor or polyp
    factor = 0.75;
    moneyspent = Cost.Colonoscopy;
    PaymentType.Colonoscopy(m,y) = PaymentType.Colonoscopy(m,y) + 1 ; 
    % AllCost(y) = AllCost(y) + Cost.Colonoscopy;
elseif isequal(counter, -1)
    factor = 1.5;
    moneyspent = Cost.Colonoscopy_Cancer;
    PaymentType.Colonoscopy_Cancer(m,y) = PaymentType.Colonoscopy_Cancer(m,y) + 1 ; 
    % AllCost(y) = AllCost(y) + Cost.Colonoscopy_Polyp;
else 
    factor = 1.5;
    moneyspent = Cost.Colonoscopy_Polyp;
    PaymentType.ColonoscopyPolyp(m,y) = PaymentType.ColonoscopyPolyp(m,y) + 1 ; 
end

%%%% Complications
if rand < risc.Colonoscopy_RiscPerforation             * factor
    % a perforation happend
    moneyspent = moneyspent + Cost.Colonoscopy_Perforation;
    PaymentType.Perforation(m,y) = PaymentType.Perforation(m,y) + 1 ; 
    if rand < risc.DeathPerforation
        % patient died during colonoscopy from a perforation
        Included(z)  = false;
        DeathCause(z)= 3;
        DeathYear(z) = y;
        % we add the costs
        [Money, PaymentType] = AddCosts(Detected, CostStage, PaymentType, Money, y+(q-1)/4, z, 'oc');
    end
elseif rand < risc.Colonoscopy_RiscSerosaBurn          * factor
    % serosal burn
    moneyspent = moneyspent + Cost.Colonoscopy_Serosal_burn;
    PaymentType.Serosa(m,y) = PaymentType.Serosa(m,y) + 1 ; 
elseif rand < risc.Colonoscopy_RiscBleeding            * factor
    % a bleeding episode (no transfusion)
    moneyspent = moneyspent + Cost.Colonoscopy_bleed;
    PaymentType.Bleeding(m,y) = PaymentType.Bleeding(m,y) + 1 ; 
elseif rand < risc.Colonoscopy_RiscBleedingTransfusion * factor
    % bleeding recquiring transfusion
    moneyspent = moneyspent + Cost.Colonoscopy_bleed_transfusion;
    PaymentType.BleedingTransf(m,y) = PaymentType.BleedingTransf(m,y) + 1 ; 
    if rand < risc.DeathBleedingTransfusion
        % patient died during colonoscopy from a bleeding complication
        Included(z)  = false;
        DeathCause(z)= 3;
        DeathYear(z) = y;
    end
end
switch Modus
    case 'Scre' % Screening
        Money.Screening(y)    = Money.Screening(y) + moneyspent;
    case 'PBPx' % poor bowel preparation
        Money.Screening(y)    = Money.Screening(y) + moneyspent;
    case 'Symp' % Symptoms
        Money.Treatment(y)    = Money.Treatment(y) + moneyspent;
    case 'Foll' % Follow-up
        Money.FollowUp(y)     = Money.FollowUp(y) + moneyspent;
    case 'Base' % Baseline
        Money.Other(y)        = Money.Other(y) + moneyspent;
end

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Rectosigmoidoscpy                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Polyp, PolypFlag, AdvPolypFlag, CancerFlag, PaymentType, Money, Included, DeathCause, DeathYear]...
    = RectoSigmo(z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
    StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag)

% in this function we do a rectosigmoidoscopy for the respective patient (number
% z). We just note whether a polyp or a cancer was found and pass the
% information back to the calling function

% we determine the reach of this rectosigmoidoscopy (cecum = 1, rectum = 13))
CurrentReach = RectoSigmoReachMatrix(round(rand*999+1));
CurrentReachMatrix = zeros(1, 13);
CurrentReachMatrix(CurrentReach:13) = 1; 

counter  = 0; PolypFlag = 0; AdvPolypFlag = 0; CancerFlag = 0; %m
PolypMax = 0;

if flag.Schoen % schoen
        for f=length(find(Polyp.Polyps(z, :))) : -1 : 1
            Tumor = Polyp.Polyps(z, f);
            if and(rand < StageVariables.RectoSigmo_Detection(Tumor) *...    % influence of polyp stage
                    Location.RectoSigmoDetection(Polyp.PolypLocation(z, f)),...    % influence of location on detection
                    CurrentReachMatrix(Polyp.PolypLocation(z, f)) == 1)      % has current current colonoscopy reached location of polyp?
                % we record the polyp
                % in this scenario we only do follow up for larger polyps
                if Tumor >2
                    PolypFlag = 1.5;
                elseif isequal(PolypFlag, 1.5)
                    PolypFlag = 1.5;
                else
                    PolypFlag = 1;
                end
                counter  = counter + 1;
                PolypMax = max(PolypMax, Tumor);
            end
        end
elseif flag.Atkin % atkin
        for f=length(find(Polyp.Polyps(z, :))) : -1 : 1
            Tumor = Polyp.Polyps(z, f);
            if and(rand < StageVariables.RectoSigmo_Detection(Tumor) *...    % influence of polyp stage
                    Location.RectoSigmoDetection(Polyp.PolypLocation(z, f)),...    % influence of location on detection
                    CurrentReachMatrix(Polyp.PolypLocation(z, f)) == 1)      % has current current colonoscopy reached location of polyp?
                % we record the polyp
                if Tumor >2
                    PolypFlag = 1;  
                end
                counter = counter + 1;
                
                % we delete the current polyp only in the Atkins study. outside this
                % study we would remove the polyp during colonoscopy
                if Tumor>2
                    l = length(find(Polyp.Polyps(z, :)));
                    Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
                    Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
                    Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
                    Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
                    Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
                end
                
                PolypMax = max(PolypMax, Tumor);
                
            end
        end
elseif flag.Segnan % italian/ Segnan study
        for f=length(find(Polyp.Polyps(z, :))) : -1 : 1
            Tumor = Polyp.Polyps(z, f);
            if and(rand < StageVariables.RectoSigmo_Detection(Tumor) *...    % influence of polyp stage
                    Location.RectoSigmoDetection(Polyp.PolypLocation(z, f)),...    % influence of location on detection
                    CurrentReachMatrix(Polyp.PolypLocation(z, f)) == 1)      % has current current colonoscopy reached location of polyp?
                % we record the polyp
                if Tumor >2
                    PolypFlag = 1;
                    PolypMax = max(PolypMax, Tumor);
                    counter = counter + 1;
                else
                    % in this study we only delete small polyps; larger polyps are referred to colonoscopy
                    l = length(find(Polyp.Polyps(z, :)));
                    Polyp.Polyps(z, f:l)           = Polyp.Polyps(z, f+1:l+1);
                    Polyp.PolypYear(z, f:l)        = Polyp.PolypYear(z, f+1:l+1);
                    Polyp.PolypLocation(z, f:l)    = Polyp.PolypLocation(z, f+1:l+1);
                    Polyp.EarlyProgression(z, f:l) = Polyp.EarlyProgression(z, f+1:l+1);
                    Polyp.AdvProgression(z, f:l)   = Polyp.AdvProgression(z, f+1:l+1);
                end
            end
        end
else
        for f=length(find(Polyp.Polyps(z, :))) : -1 : 1
            Tumor = Polyp.Polyps(z, f);
            if and(rand < StageVariables.RectoSigmo_Detection(Tumor) *...    % influence of polyp stage
                    Location.RectoSigmoDetection(Polyp.PolypLocation(z, f)),...    % influence of location on detection
                    CurrentReachMatrix(Polyp.PolypLocation(z, f)) == 1)      % has current current colonoscopy reached location of polyp?
                % we record the polyp
                PolypFlag = 1;
                counter = counter + 1;
            PolypMax = max(PolypMax, Tumor);       
            end
        end
end

if or(PolypMax>4, counter>2)
    AdvPolypFlag = 1;
end

for f=length(find(Ca.Cancer(z, :))) : -1 : 1
    Tumor = Ca.Cancer(z, f);
    if and(rand < StageVariables.RectoSigmo_Detection(Tumor),...           % influence of cancer stage on detection
            CurrentReachMatrix(Ca.CancerLocation(z, f)) == 1)        % has current current colonoscopy reached location of polyp?
        counter = counter + 1;
        CancerFlag = 1;
    end
end

if isequal(counter, 0) % in this case no tumor or polyp
    Money.Screening(y) = Money.Screening(y) + Cost.Sigmoidoscopy;
    PaymentType.RS(1,y)= PaymentType.RS(1,y)+1;  %m2 assumption. RS is only done for screening. not for followup or treatment
else
    Money.Screening(y) = Money.Screening(y) + Cost.Sigmoidoscopy_Polyp;
    PaymentType.RSPolyp(1,y)= PaymentType.RSPolyp(1,y)+1; %m2 assumption. RS is only done for screening. not for followup or treatment
end

%%%% Complications
if rand < risc.Rectosigmo_Perforation
    % a perforation happend
    Money.Screening(y) = Money.Screening(y) + Cost.Colonoscopy_Perforation;
    PaymentType.Perforation(1,y)= PaymentType.Perforation(1,y) + 1;
    if rand < risc.DeathPerforation
        % patient died during colonoscopy from a perforation
        Included(z)  = false;
        DeathCause(z)= 3;
        DeathYear(z) = y;
        % we set these flags to zero to prevent colonoscopy on a deceased
        % patienta
        CancerFlag = 0; PolypFlag = 0;
    end
end


function [Money, PaymentType] = AddCosts(Detected, CostStage, PaymentType, Money, time, z, mode)
% in this case a cancer has been diagnosed and
% we need to take care of the costs

SubCost       = zeros(25, 404);  % for temporary calculations
SubCostFut    = zeros(25, 404);
SubCostAll    = zeros(1, 404);   %#ok<NASGU> % for temporary calculations
SubCostAllFut = zeros(1, 404);   %#ok<NASGU>

Ende      = time;
l = length(find(Detected.Cancer(z, :)));
% we add the cost for the rest of the
% treatment time
for x1 = 1:l
    Start      = Detected.CancerYear(z, x1);
    Difference = Ende - Start;
    
    % costs differ dependent if patient died of tumor or of other causes
%     if isequal(mode, 'oc') % died of other causes
%         FinalCosts    = CostStage.Final_oc(Detected.Cancer(z, x1)-6); 
%         FutFinalCosts = CostStage.FutFinal_oc(Detected.Cancer(z, x1)-6); 
%     else
%         FinalCosts    = CostStage.Final(Detected.Cancer(z, x1)-6); % patient died of tumor
%         FutFinalCosts = CostStage.FutFinal(Detected.Cancer(z, x1)-6); % patient died of tumor
%     end
       
    % all other tumors
    %m for the costs, the following changes are made:
    %m after 5 years, the treatment is discontinued
    %m during the 5 years of treatment if the death is due to other
    %reasons, these costs are not included
    %m the initial phase is for 3 months, and the remaining time until the
    %terminal or the 5th year are the continuing costs.
    
    if  Difference <= 1/4
        % the costs for the first year of treatment apply, independent
        % whether the patient survived a full year or not
        SubCost(x1,  Start*4+1)             = CostStage.Initial(Detected.Cancer(z, x1)-6); % START
        SubCostFut(x1,  Start*4+1)          = CostStage.FutInitial(Detected.Cancer(z, x1)-6);
        PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) = PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) + 1;
        PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1) = PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1) + 1;
        
    elseif and((Difference > 1/4) , (Difference <= 1.25))
        SubCost(x1,  Start*4+1 )    = CostStage.Initial(Detected.Cancer(z, x1)-6);
        SubCostFut(x1,  Start*4+1 ) = CostStage.FutInitial(Detected.Cancer(z, x1)-6);
        PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) = PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) + 1;
        PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1)= PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1) + 1;
        
        if ~isequal(mode, 'oc')
            SubCost(x1, (Start*4+1)+1 : Ende*4)        = 1/4* CostStage.Final(Detected.Cancer(z, x1)-6); % START
            SubCostFut(x1, (Start*4+1)+1 : Ende*4)     = 1/4* CostStage.FutFinal(Detected.Cancer(z, x1)-6); % START
            PaymentType.Cancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1))  = PaymentType.Cancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1)) + (4*Ende-(4*Start+1))/4.0; %m2 ini is for q1, and the cont is for rest. but to keep it all integers, I use y
            for Qcount=1:(4*Ende-(4*Start+1))
                PaymentType.QCancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount)  = PaymentType.QCancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount) + 1; %m2 this finQ is counting in quarters
            end
        elseif isequal(mode, 'oc')
            SubCost(x1, (Start*4+1)+1 : Ende*4)        = 1/4* CostStage.Cont(Detected.Cancer(z, x1)-6); % START
            SubCostFut(x1, (Start*4+1)+1 : Ende*4)     = 1/4* CostStage.FutCont(Detected.Cancer(z, x1)-6); % START
            PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1))  = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1)) + (4*Ende-(4*Start+1))/4.0; %m2 ini is for q1, and the cont is for rest. but to keep it all integers, I use y
            for Qcount=1:(4*Ende-(4*Start+1))
                PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount)  = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount) + 1; %m2 this finQ is counting in quarters
            end
        end
    elseif and((Difference > 1.250) ,(Difference <= 5.0)) %m new costs treatment o
        SubCost(x1, (Start*4)+1 : (Start*4) + 1)    = CostStage.Initial(Detected.Cancer(z, x1)-6);
        SubCostFut(x1, Start*4+1 : (Start*4 + 1))   = CostStage.FutInitial(Detected.Cancer(z, x1)-6);
        SubCost(x1, (Start*4+1)+1 : (Ende-1)*4)     = 1/4*CostStage.Cont(Detected.Cancer(z, x1)-6); % CONT
        SubCostFut(x1, (Start*4+1)+1 : (Ende-1)*4)  = 1/4*CostStage.FutCont(Detected.Cancer(z, x1)-6); % CONT
        PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) = PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6,floor(Start)) + 1;
        PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1)= PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1) + 1;
        
        yyears = floor(Difference-1.25);
        qquarters = (Difference-1.25) - floor(Difference-1.25);
        
        for con_y=1:yyears
            PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y) = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
            for Qcount=(con_y*4-3):(con_y*4)
                PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y,Qcount) = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y,Qcount) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
            end
        end
        
        PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1)= PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1) + qquarters;
        for Qcount=1:(4*qquarters)
            PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1,con_y*4+Qcount) = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y+1,con_y*4+Qcount) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
        end
        
        %m PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)) = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6,floor(Start)) + ((4*Ende-4*1)-(4*Start+1))/4;
        
        if ~isequal(mode, 'oc')
            SubCost(x1, (Ende-1)*4+1 : Ende*4)         = 1/4* CostStage.Final(Detected.Cancer(z, x1)-6);
            SubCostFut(x1, (Ende-1)*4+1 : Ende*4)      = 1/4* CostStage.FutFinal(Detected.Cancer(z, x1)-6);
            PaymentType.Cancer_fin(Detected.Cancer(z, x1)-6, floor(Ende)-1) = PaymentType.Cancer_fin(Detected.Cancer(z, x1)-6,floor(Ende)-1) + 1;
            for Qcount=1:4 %m here all 4 quarters of treatment are followed, unlike when difference<1.25 where only few quarters of final year are implemented
                PaymentType.QCancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount)  = PaymentType.QCancer_fin(Detected.Cancer(z, x1)-6, floor(Ende-1),Qcount) + 1; %m2 this finQ is counting in quarters
            end
        elseif isequal(mode, 'oc')
            SubCost(x1, (Ende-1)*4+1 : Ende*4)         = 1/4* CostStage.Cont(Detected.Cancer(z, x1)-6);
            SubCostFut(x1, (Ende-1)*4+1 : Ende*4)      = 1/4* CostStage.FutCont(Detected.Cancer(z, x1)-6);
            PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Ende)-1) = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6,floor(Ende)-1) + 1;
            for Qcount=1:4%m8 (4*Ende-(4*Start+1)) %m here all 4 quarters of treatment are followed, unlike when difference<1.25 where only few quarters of final year are implemented
                PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1),con_y*4+qquarters*4+Qcount)  = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Ende-1),con_y*4+qquarters*4+Qcount) + 1; %m2 this finQ is counting in quarters %m8
            end
        end
    elseif Difference > 5
        SubCost(x1, Start*4+1 : (Start*4 + 1))     = CostStage.Initial(Detected.Cancer(z, x1)-6);
        SubCostFut(x1, Start*4+1 : (Start*4 + 1))  = CostStage.FutInitial(Detected.Cancer(z, x1)-6);
       %m8 SubCost(x1, (Start*4+1)+1 : (Start+5)*4)        = 1/4*CostStage.Cont(Detected.Cancer(z, x1)-6); % CONT
       %m8 SubCostFut(x1, (Start*4+1)+1 : (Start+5)*4)     = 1/4*CostStage.FutCont(Detected.Cancer(z, x1)-6); % CONT
        SubCost(x1, (Start*4+1)+1 : Ende*4)    = 1/4*CostStage.Cont(Detected.Cancer(z, x1)-6); % CONT
        SubCostFut(x1, (Start*4+1)+1 : Ende*4) = 1/4*CostStage.FutCont(Detected.Cancer(z, x1)-6); % CONT
        PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) = PaymentType.Cancer_ini(Detected.Cancer(z, x1)-6, floor(Start)) + 1;
        PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1)= PaymentType.QCancer_ini(Detected.Cancer(z, x1)-6, floor(Start),1) + 1;
        %m the following con_y is for all Difference. it must be just upto
        %year 5. So, yyears must be 5?
        %%m yyears = floor(Difference-1.25);
        %%m qquarters = (Difference-1.25) - floor(Difference-1.25);
        for con_y=1:4%%m yyears
            PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y) = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
            for Qcount=(con_y*4-3):(con_y*4)
                PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y,Qcount) = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y,Qcount) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
            end
        end
        PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1)= PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1) + 0.75;
        for Qcount=1:3
            PaymentType.QCancer_con(Detected.Cancer(z, x1)-6, floor(Start)+con_y+1,Qcount) = PaymentType.QCancer_con(Detected.Cancer(z, x1)-6,floor(Start)+con_y+1,Qcount) + 1;%((4*Ende-4*1)-(4*Start+1))/4;
        end
        
        %m PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start))  = PaymentType.Cancer_con(Detected.Cancer(z, x1)-6, floor(Start)) + (4*Ende-(4*Start+1))/4; %m2 ini is for q1, and the cont is for rest. but to keep it all integers, I use y
    end
    
end

SubCostAll    =  sum(SubCost); %m2 sum(SubCost,1); remove max and add sum %max(SubCost)/4; % since all costs are quarterly we need to adjust %m3 and remove max()
SubCostAllFut =  sum(SubCostFut); % since all costs are quarterly we need to adjust %m3
Counter = 1;
for x1 = 1:100
    for x2= 1:4
        Money.Treatment(x1)       = Money.Treatment(x1) + SubCostAll(Counter);
        Money.FutureTreatment(x1) = Money.FutureTreatment(x1) + SubCostAllFut(Counter);
        Counter = Counter + 1;
    end
end

