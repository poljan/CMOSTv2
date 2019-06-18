function [currentYear, GenderOut, DeathCause, Last, DeathYear, NaturalDeathYear,...
    DirectCancer, DirectCancerR, DirectCancer2, DirectCancer2R, ProgressedCancer, ProgressedCancerR, TumorRecordOut,...
    DwellTimeProgressionOut, DwellTimeFastCancerOut,...
    HasCancerOut, NumPolyps, MaxPolyps, AllPolyps, NumCancer, MaxCancer,...
    PaymentType, Money, Number, EarlyPolypsRemoved, DiagnosedCancer, AdvancedPolypsRemoved, YearIncluded, YearAlive, PBP_Doc, TumorRecord] = simulate(p, StageVariables, Location, Cost, CostStage, risc,...
    flag, SpecialText, female, Sensitivity, ScreeningTest, ScreeningPreference, AgeProgression,...
    NewPolyp, ColonoscopyLikelyhood, IndividualRisk, RiskDistribution, Gender, LifeTable,...
    LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed, PBP, stats)

simSettings.yearsToSimulate = 100; %numbers of years to simulate
simSettings.numPeriods = 4; %number of periods in each simulation year

NAlive = uint32(length(Gender)); %number of individuals
disp(['Simulated population size: ' int2str(NAlive)]);
SubjectIDs = uint32(1:NAlive)'; %this will hold actual indices to the output vector
NumIndividualsToSimulate = NAlive;

BlockFromDeath = false(NAlive,1);

PBP_Doc.Early     = int16(ones(1, NAlive)*-1); % number early adenomas
PBP_Doc.Advanced  = int16(ones(1, NAlive)*-1); % number advanced adenomas
PBP_Doc.Cancer    = int16(ones(1, NAlive)*-1); % number cancer
PBP_Doc.Screening = false(1, NAlive);   % screening done?

%substitute of Included
SubjectsIDWouldBeAlive = uint32([]);
GenderWouldBeAlive     = uint16([]);

%precomputing life table by taking into account number of simulated periods
%within a year
LifeTable = 1-(1-LifeTable').^(1/double(simSettings.numPeriods));

%recasting other input variables
Gender = uint16(Gender)';
IndividualRisk = single(IndividualRisk');
ScreeningPreference = uint8(ScreeningPreference');
NewPolyp = single(NewPolyp');
RiskDistribution.EarlyRisk = single(RiskDistribution.EarlyRisk');
RiskDistribution.AdvancedRisk = single(RiskDistribution.AdvancedRisk');

Counter = 1;
for f = 1 : 13
    Ende = round(sum(Location.NewPolyp(1:f))/sum(Location.NewPolyp)*1000);
    LocationMatrix(Counter:Ende) = f;
    Counter = Ende;
end
LocationMatrix = uint8(LocationMatrix'); %again we can use uint8 for that

flds = fields(StageVariables);
for i = 1:length(flds) %transpose each field
    StageVariables.(flds{i}) = StageVariables.(flds{i})';
end
StageVariables.FastCancerRatios = StageVariables.FastCancer;
for i = 2:10
    StageVariables.FastCancerRatios(i) = StageVariables.FastCancer(i)/StageVariables.FastCancer(i-1);
end

flds = fields(CostStage);
for i = 1:length(flds) %transpose each field
    CostStage.(flds{i}) = CostStage.(flds{i})';
end

%recasting control variables
yearsToSimulate = uint16(simSettings.yearsToSimulate);
numPeriods = uint16(simSettings.numPeriods);

%preparing additional variables

%matrix for fast indexing
%here again we don't need to have double precision
GenderProgression = single(ones(10, 2));
GenderProgression(1:4, 2) = single(female.early_progression_female);
GenderProgression(5:6, 2) = single(female.advanced_progression_female);
GenderProgressionRows = uint16(size(GenderProgression,1));
GenderProgressionRatios = GenderProgression;
for i = 2:size(GenderProgression,1)
    GenderProgressionRatios(i,:) =  GenderProgression(i,:)/GenderProgression(i-1,:);
end

% matrix for fast indexing
LocationProgression = zeros(10, 13); % 10 polyps x 13 locations
LocationProgression(1:5, :) = repmat(Location.EarlyProgression,5,1);
LocationProgression(6, :) = Location.AdvancedProgression;
LocationProgression(7:10, :) = repmat(Location.CancerProgression,4,1);
LocationProgressionRatios = LocationProgression;
for i = 2:10
    LocationProgressionRatios(i,:) = LocationProgression(i,:)./LocationProgression(i-1,:);
end

LocationProgression = single(LocationProgression'); %again we don't need double precision
LocationProgressionRatios = single(LocationProgressionRatios'); %again we don't need double precision

LocationProgressionRows = uint16(size(LocationProgression,1)); %number of rows

% Cancer progression
%
StageDurationC = cumsum(StageDuration,2);
StageDurationC(StageDurationC == 1) = Inf;

%All of the matrices responsible for generating multinomail random
%variables are replaced by the Inverse CDF approach, i.e. by appropriate
%griddedInterpolants
%this saves memory especially in the case of Mortality time generation

%the beloow lines are depreciated, now in the main loop there is gender and
%age dependent stage random number generator
% Stage 1: 5%, Stage 2: 35%, Stage 3: 40%, Stage 4: 20% - THIS IS NOT TRUE
%StageProbability = [0 cumsum([150 356 279 215]/1000)];
%StageRandomGenerator = griddedInterpolant(StageProbability,7:11,'previous');

%defining sojourn time random generator
SojournCDF = [zeros(1,4); cumsum(bsxfun(@rdivide,tx1,sum(tx1)))]; %cumulative distribution function
meshSojournCDF = unique(SojournCDF);
SojournInvCDF = zeros(length(meshSojournCDF),4);
for i = 1:4
    SojournInvCDF(:,i) = interp1(SojournCDF(:,i)', 1:26, meshSojournCDF);
end
F = griddedInterpolant({7:10, meshSojournCDF},SojournInvCDF');
SojournRandomGenerator = @(Stage, R)(uint16(floor(F(Stage,R))));

% reach of rectosigmoidoscopy
F = find(Location.RectoSigmoReach == 1, 1,'first');
F2 = find(Location.RectoSigmoReach == 0, 1,'last')+1;
GIR = griddedInterpolant([0 Location.RectoSigmoReach(F2:F)],F2:(F+1),'previous');
RectoSigmoReachRandomGenerator = @(R)(uint8(GIR(R)));
Location.RectoSigmoDetection = Location.RectoSigmoDetection'; %transposing

% reach of colonoscopy
F = find(Location.ColoReach == 1, 1,'first');
GI = griddedInterpolant([0 Location.ColoReach(1:F)],1:(F+1),'previous');
ColoReachRandomGenerator = @(R)(uint8(GI(R)));
Location.ColoDetection = Location.ColoDetection'; %transposing


%output variables
%arrays with polyps will be dynamically expanded and contracted
Polyp.Polyps            = uint16([]);   % we initialize the polyps cells
Polyp.PolypYear         = uint16([]);   % we initialize the field for keeping track of years
Polyp.PolypLocation     = uint16([]);   %with uint8 we have up to 255 locations
Polyp.AdvProgression    = uint16([]); %up to 65535 with uint16
Polyp.EarlyProgression  = uint16([]); %up to 65535 with uint16
Polyp.SubjectID         = uint32([]);
Polyp.ProgressionProb   = single([]);
Polyp.DirectProgressionProb = single([]);
Polyp.OwnersGender      = uint16([]);

Ca.Cancer               = uint8([]);
Ca.CancerYear           = uint16([]);
Ca.CancerLocation       = uint8([]);
Ca.DwellTime            = uint16([]);
Ca.SympTime             = uint16([]);
Ca.SympStage            = uint16([]);
Ca.TimeStage_I          = uint16([]);
Ca.TimeStage_II         = uint16([]);
Ca.TimeStage_III        = uint16([]);
Ca.SubjectID            = uint32([]);
Ca.OwnersGender         = uint16([]);

Detected.Cancer         = uint8([]);
Detected.CancerYear     = uint16([]);
Detected.CancerLocation = uint8([]);
Detected.MortTime       = uint16([]);
Detected.SubjectID      = uint32([]);

%output variables
GenderOut = double(Gender');
DeathCause = uint8(zeros(NAlive,1));
DeathYear  = uint16(zeros(NAlive,1));
NaturalDeathYear = uint16(zeros(NAlive,1));

EarlyPolypsRemoved           = uint32(zeros(1, yearsToSimulate));
AdvancedPolypsRemoved        = uint32(zeros(1, yearsToSimulate));

TumorRecord.Stage         = uint8([]);
TumorRecord.Location      = uint8([]);
TumorRecord.DwellTime     = uint16([]);
TumorRecord.Sojourn       = uint8([]);
TumorRecord.Gender        = uint8([]);
TumorRecord.Detection     = uint8([]);
TumorRecord.SubjectID     = uint32([]);
TumorRecord.Year          = uint16([]);
TumorRecord.Time          = uint16([]);

% Colo_Detection_bckup = StageVariables.Colo_Detection;
%m2
%m2 Number for each cost type
% 4 types, Type 1: For screening, Type 2: treatment; Type 3: Followup; Type
% 4: Other
%m2 Purely screening
tmp = uint16(zeros(1, yearsToSimulate));
PaymentType.FOBT             = tmp;
PaymentType.I_FOBT           = tmp;
PaymentType.Sept9_HighSens   = tmp;
PaymentType.Sept9_HighSpec   = tmp;
PaymentType.RS               = tmp;
PaymentType.RSPolyp          = tmp;

%m2 Colonoscopy can be for screening, treatment, followup,
tmp = uint16(zeros(4, yearsToSimulate));
PaymentType.Colonoscopy      = tmp;
PaymentType.ColonoscopyPolyp = tmp;

%m2 Complications at anytime screening, treatment or followup
PaymentType.Colonoscopy_Cancer= tmp;
PaymentType.Perforation      = tmp;
PaymentType.Serosa           = tmp;
PaymentType.Bleeding         = tmp;
PaymentType.BleedingTransf   = tmp;

%m2 cancer treatment costs index is for stage
tmp = uint16(zeros(4, yearsToSimulate+1));
PaymentType.Cancer_ini      = tmp;
PaymentType.Cancer_con      = double(tmp);
PaymentType.Cancer_fin      = double(tmp);

%m2 cancer treatment costs index is for stage, noted by quarters
PaymentType.QCancer_ini      = uint16(zeros(4, yearsToSimulate+1,4));
PaymentType.QCancer_con      = uint16(zeros(4, yearsToSimulate+1,20));
PaymentType.QCancer_fin      = uint16(zeros(4, yearsToSimulate+1,4));
PaymentType.Other            = uint16(zeros(1, yearsToSimulate));

tmp = zeros(yearsToSimulate, NAlive);
%Money.AllCost         = tmp;
%Money.AllCostFuture   = tmp;

Money.Treatment       = tmp;
Money.FutureTreatment = tmp;
Money.Screening       = tmp;
Money.FollowUp        = tmp;
Money.Other           = tmp;


Last.Colonoscopy  = zeros(1,NAlive);
Last.Polyp        = ones(1,NAlive) *-100;
Last.AdvPolyp     = ones(1,NAlive) *-100;
Last.Cancer       = ones(1,NAlive) *-100;
Last.ScreenTest   = zeros(1,NAlive);
Last.Included     = zeros(1,NAlive); % RS ONLY !!!!!!
Last.TestDone     = zeros(1,NAlive); % RS ONLY !!!!!!
Last.TestYear     = zeros(1,NAlive); % RS ONLY !!!!!!
Last.TestYear2    = zeros(1,NAlive); % RS ONLY !!!!!!

DwellTimeProgression = cell(yearsToSimulate,1);
DwellTimeFastCancer  = cell(yearsToSimulate,1);
for i = 1:yearsToSimulate
    DwellTimeProgression{i} = uint16([]);
    DwellTimeFastCancer{i}  = uint16([]);
end
DirectCancer        = uint32(zeros(yearsToSimulate,5));
DirectCancer2       = uint32(zeros(yearsToSimulate,1));
DirectCancerR       = uint32(zeros(yearsToSimulate,1));
DirectCancer2R      = uint32(zeros(yearsToSimulate,1));
ProgressedCancer    = uint32(zeros(yearsToSimulate,1));
ProgressedCancerR   = uint32(zeros(yearsToSimulate,1));

tmp = uint32(zeros(1,yearsToSimulate));
Number.Screening_Colonoscopy = tmp;
Number.Symptoms_Colonoscopy  = tmp;
Number.Follow_Up_Colonoscopy = tmp;
Number.Baseline_Colonoscopy  = tmp;

Number.RectoSigmo            = tmp;
Number.FOBT                  = tmp;
Number.I_FOBT                = tmp;
Number.Sept9                 = tmp;
Number.other                 = tmp;

tmp = uint16(zeros(NAlive,yearsToSimulate));
HasCancer = uint8(Inf*ones(NAlive,1));
NumPolyps = tmp;
MaxPolyps = tmp;

AllPolyps       = uint32(zeros(6, yearsToSimulate));

DiagnosedCancer    = uint8(tmp);
NumCancer          = tmp;
MaxCancer          = tmp;

tmp = false(NAlive,yearsToSimulate);
YearIncluded = tmp;
YearAlive    = tmp;

PBP.Year = uint8(PBP.Year);

%% MAIN SIMULATION LOOP
stepCounter = uint16(0); %
ni = uint16(stats.mortalityYears);
while and(NAlive > 0 || ~isempty(GenderWouldBeAlive), stepCounter < yearsToSimulate*numPeriods)
    currentYear = idivide(stepCounter,numPeriods)+1; %need to use idivide, because of interger division rounding
    currentYear = uint8(currentYear); %just to be on a safe side when indexing matrices
    stepCounter = stepCounter + 1;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  some precalculation steps, done only once a year %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(stepCounter,numPeriods) == 1 %if we start a new year
        PolypRate = IndividualRisk .* NewPolyp(currentYear);
        % the gender specific risk
        PolypRate(Gender==2) = PolypRate(Gender==2) * female.new_polyp_female;
        
        %% mortality time generator preparations
        ranges = uint8([51 60 70 80]);
        whichCurve = sum(currentYear >= ranges);
        
        %I need to select survival curves by gender and for current age
        %group
        % SurvivalTmp = Survival(:,whichCurve*4 + (1:4))';
        nEl = 11; %number of data points for survival, there is data for 0,12,..,120 months
        nAgeGroups = 5; %number of available age groups
        nStages = 4;
        
        %gender -> stage -> age
        femaleShift = nEl*nAgeGroups*nStages;
        stageShift = nEl*nAgeGroups;
        indxS = ((1:nEl) + whichCurve*nEl)';
        SurvivalTmpMale   = stats.osByGenderAgeStage.surv([indxS indxS+stageShift indxS+2*stageShift indxS+3*stageShift])';
        SurvivalTmpFemale = stats.osByGenderAgeStage.surv([indxS indxS+stageShift indxS+2*stageShift indxS+3*stageShift]+femaleShift)';
        
        %%
        
        % we create a smooth curve (we take only first 6 points)
        L = double(ni*numPeriods+1);
        MortalityCDFmale = zeros(L+1,4); %prepare matrix for CDF
        MortalityCDFfemale = zeros(L+1,4); %prepare matrix for CDF
        for f = 1:4
            MortalityCDFmale(:,f) = [1-interp1(linspace(0,1,6), SurvivalTmpMale(f,1:(ni+1)),linspace(0,1,L)) 1];
            MortalityCDFfemale(:,f) = [1-interp1(linspace(0,1,6), SurvivalTmpFemale(f,1:(ni+1)),linspace(0,1,L)) 1];
        end
        
        meshMortalityCDFmale = unique(MortalityCDFmale);
        meshMortalityCDFfemale = unique(MortalityCDFfemale);
        MortalityInvCDFmale = zeros(length(meshMortalityCDFmale),4);
        MortalityInvCDFfemale = zeros(length(meshMortalityCDFfemale),4);
        for i = 1:4
            MortalityInvCDFmale(:,i) = interp1(MortalityCDFmale(:,i)', 1:(L+1), meshMortalityCDFmale);
            MortalityInvCDFfemale(:,i) = interp1(MortalityCDFfemale(:,i)', 1:(L+1), meshMortalityCDFfemale);
        end
        FmortMale = griddedInterpolant({7:10, meshMortalityCDFmale},MortalityInvCDFmale');
        FmortFemale = griddedInterpolant({7:10, meshMortalityCDFfemale},MortalityInvCDFfemale');
        
        MortalityRandomGeneratorMale   = @(Stage, R)(uint16(floor(FmortMale(Stage,R))));
        MortalityRandomGeneratorFemale = @(Stage, R)(uint16(floor(FmortFemale(Stage,R))));
        
        %stage random number generator definition
        ageGroups = uint8([0 (19:5:85)+1]);
        ageGroup = sum(currentYear >= ageGroups); %which age group we are considering now
        
        femalesIndcs = cellfun(@(x)(strcmpi(x,'female')),stats.stageDistribution.sex);
        dataF = table2array(stats.stageDistribution(femalesIndcs,3:6));
        dataM = table2array(stats.stageDistribution(~femalesIndcs,3:6));
        dataF = dataF(ageGroup,:); dataFcum = [0 cumsum(dataF)];
        dataM = dataM(ageGroup,:); dataMcum = [0 cumsum(dataM)];
        StageProbability = [dataMcum; dataFcum]';
        
        meshStageCDF = unique(StageProbability);
        StageInvCDF = zeros(length(meshStageCDF),2);
        for i = 1:2
            StageInvCDF(:,i) = interp1(StageProbability(:,i)', 7:11, meshStageCDF);
        end
        
        %Gender == 2 is female, 1 is male
        Fstage = griddedInterpolant({1:2, meshStageCDF},StageInvCDF');
        StageRandomGenerator = @(Gender, R)(floor(Fstage(Gender,R)));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %    summarizing cancer (once a year) %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isempty(Ca.Cancer)
            A = [Ca.SubjectID Ca.Cancer];
            A = sortrows(A);
            aux = find(diff([A(:,1); NumIndividualsToSimulate+1]));
            idxIDs = unique(A(:,1));
            NumCancer(idxIDs, currentYear) = diff([0; aux]);
            MaxCancer(idxIDs, currentYear) = A(aux,2);
        end
        
        % we summarize the whole cohort
        YearIncluded(SubjectIDs,currentYear) = true;
        YearAlive([SubjectIDs; SubjectsIDWouldBeAlive], currentYear) = true;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  people die of natural causes     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    diedNaturalCauses = rand(NAlive,1) < LifeTable(Gender,currentYear) & ~BlockFromDeath;%those will die now from other causes
    if any(diedNaturalCauses)
        NaturalDeathYear(SubjectIDs(diedNaturalCauses)) = stepCounter;
        DeathCause(SubjectIDs(diedNaturalCauses)) = 1;
        DeathYear(SubjectIDs(diedNaturalCauses)) = stepCounter;
        
        %we need to calculate the costs
        AddCosts(SubjectIDs(diedNaturalCauses),'oc');
        
        death(diedNaturalCauses, false);
    end
    
    %calculations for those that died before not from natural causes
    %(Included substitute)
    if ~isempty(GenderWouldBeAlive)
        diedNaturalCausesNotIncluded = rand(length(GenderWouldBeAlive),1) < LifeTable(GenderWouldBeAlive,currentYear);%those will die now from other causes
        if any(diedNaturalCausesNotIncluded)
            NaturalDeathYear(SubjectsIDWouldBeAlive(diedNaturalCausesNotIncluded)) = stepCounter;
            GenderWouldBeAlive(diedNaturalCausesNotIncluded) = [];
            SubjectsIDWouldBeAlive(diedNaturalCausesNotIncluded) = [];
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    people die of cancer           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    diedOfCancer = Detected.MortTime < ni*numPeriods+1 & (stepCounter - Detected.CancerYear) >= Detected.MortTime;
    if any(diedOfCancer)
        deathIDs = unique(Detected.SubjectID(diedOfCancer));
        DeathCause(deathIDs) = 2;
        DeathYear(deathIDs) = stepCounter;
        
        AddCosts(deathIDs,'tu');
        
        death(ismember(SubjectIDs, deathIDs));
    end
    
    %%%% I need to unblock those that that survived given period
%     survivedPeriod = Detected.MortTime >= ni*numPeriods+1 & (stepCounter - Detected.CancerYear) >= Detected.MortTime;
%     if any(survivedPeriod)
%         survivedIDs = unique(Detected.SubjectID(survivedPeriod));
%         %remove those that survived from Detected
%         deleteDetectedCancers(survivedPeriod);
%         %unblock the patients for dying
%         [im, LocC] = ismember(survivedIDs, SubjectIDs);
%         if ~all(im)
%             disp('Grave error #ID ublockingPatientError');
%         else
%             %finding which patients to block
%             %disp('Unblocking')
%             BlockFromDeath(LocC) = false;
%         end
%     end
    %%%
    R = rand(NAlive,2); %generating random numbers in advance
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % a NEW POLYP appears               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    developNewPolyp = R(:,1) < PolypRate; %those will get new polyps
    numNewPolyps = sum(developNewPolyp);
    if numNewPolyps %if there is a new polyp to add; there is no limit on the number of polyps
        Polyp.SubjectID = [Polyp.SubjectID; SubjectIDs(developNewPolyp)];
        Polyp.Polyps = [Polyp.Polyps; ones(numNewPolyps,1)];
        Polyp.PolypYear = [Polyp.PolypYear; repmat(stepCounter,numNewPolyps,1)];
        location = LocationMatrix(randi(1000,numNewPolyps,1));
        Polyp.PolypLocation = [Polyp.PolypLocation; location];
        Polyp.OwnersGender = [Polyp.OwnersGender; Gender(developNewPolyp)];
        
        progressionRate = randi(500,numNewPolyps,1);
        Polyp.EarlyProgression = [Polyp.EarlyProgression; progressionRate];
        if flag.Correlation
            Polyp.AdvProgression = [Polyp.AdvProgression; progressionRate];
        else
            Polyp.AdvProgression = [Polyp.AdvProgression; randi(500,numNewPolyps,1)];
        end
        
        %calculating initial progression probability
        Polyp.ProgressionProb = [Polyp.ProgressionProb; LocationProgression(location)...
            .* GenderProgression(1+(Gender(developNewPolyp) - 1)*GenderProgressionRows) ... %need to use linear indexing
            .* RiskDistribution.EarlyRisk(progressionRate)];
        
        aux = StageVariables.FastCancer(1).*LocationProgression(location,6).*...
            GenderProgression(6+(Gender(developNewPolyp) - 1)*GenderProgressionRows);
        if strcmp(DwellSpeed,'Fast')
            aux = aux.*RiskDistribution.EarlyRisk(progressionRate);
        end
        Polyp.DirectProgressionProb = [Polyp.DirectProgressionProb; aux];
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % a NEW Cancer appears DIRECTLY     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    developNewCancer = R(:,2) < DirectCancerRate(Gender,currentYear) * DirectCancerSpeed; %those will get new cancer
    if any(developNewCancer)
        
        numNewCancers = sum(developNewCancer);
        Ca.Cancer = [Ca.Cancer; 7*ones(numNewCancers,1)];
        Ca.CancerYear = [Ca.CancerYear; repmat(stepCounter,numNewCancers,1)];
        location = LocationMatrix(randi(1000,numNewCancers,1),2);
        Ca.CancerLocation = [Ca.CancerLocation; location];
        Ca.DwellTime = [Ca.DwellTime; zeros(numNewCancers,1)];
        IDs = SubjectIDs(developNewCancer);
        Ca.SubjectID = [Ca.SubjectID; IDs];
        
        %SympStage = StageRandomGenerator(rand(numNewCancers,1));
        SympStage = StageRandomGenerator(double(Gender(developNewCancer)), rand(numNewCancers,1));
        SympTimeAdd = SojournRandomGenerator(SympStage,rand(numNewCancers,1));

        SympTimeAddDouble = double(SympTimeAdd);
        SympStageShifted = SympStage-6;
        Ca.TimeStage_I = [Ca.TimeStage_I;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,1))];
        Ca.TimeStage_II = [Ca.TimeStage_II;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,2))];
        Ca.TimeStage_III = [Ca.TimeStage_III;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,3))];
        
        
        Ca.SympTime = [Ca.SympTime; stepCounter+SympTimeAdd];
        Ca.SympStage = [Ca.SympStage; SympStage];
        Ca.OwnersGender = [Ca.OwnersGender; Gender(developNewCancer)];
        
        %%% HERE ENDS THE CHECK
        %keeping track
        % we keep track
        %DwellTimeProgression{currentYear} = [DwellTimeProgression{currentYear}; repmat(uint16(0),numNewCancers,1)];
        HasCancer(IDs) = min( HasCancer(IDs), currentYear);
        DirectCancer2(currentYear)  = DirectCancer2(currentYear)+uint32(numNewCancers);
        DirectCancer2R(currentYear) = DirectCancer2R(currentYear)+uint32(sum(location < 4));
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %      a polyp progresses           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(Polyp.Polyps) %if there is any polyp
        
        progressionProbTotal = AgeProgression(Polyp.Polyps,currentYear).*Polyp.ProgressionProb;
        directProgressionProbTotal = AgeProgression(6,currentYear).*Polyp.DirectProgressionProb;
        %generating random numbers in advance
        Rin = rand(length(progressionProbTotal),2);
        
        progressing = Rin(:,1) < progressionProbTotal;
        progressingDirectlyToCancer = ~progressing & Rin(:,2) < directProgressionProbTotal;
        
        if any(progressing | progressingDirectlyToCancer)
            
            Polyp.Polyps(progressing) = Polyp.Polyps(progressing) + 1; %increase stage
            
            indirectProgression = (progressing & Polyp.Polyps > 6);
            progressionToCancer = indirectProgression | progressingDirectlyToCancer;
            
            %update progression probability for those polyps that progressed
            probUpdate = progressing & ~progressionToCancer;
            Polyp.ProgressionProb(probUpdate) = Polyp.ProgressionProb(probUpdate).*...
                LocationProgressionRatios((Polyp.Polyps(probUpdate)-1)*LocationProgressionRows+Polyp.PolypLocation(probUpdate)).*...
                GenderProgressionRatios(Polyp.Polyps(probUpdate)+(Polyp.OwnersGender(probUpdate) - 1)*GenderProgressionRows);
            
            Polyp.DirectProgressionProb(probUpdate) = Polyp.DirectProgressionProb(probUpdate).*...
                StageVariables.FastCancerRatios(Polyp.Polyps(probUpdate));
            
            advancedRiskSwitch = probUpdate & Polyp.Polyps == 5;
            if any(advancedRiskSwitch)
                aux = (RiskDistribution.AdvancedRisk(Polyp.AdvProgression(advancedRiskSwitch))./RiskDistribution.EarlyRisk(Polyp.EarlyProgression(advancedRiskSwitch)));
                Polyp.ProgressionProb(advancedRiskSwitch) = Polyp.ProgressionProb(advancedRiskSwitch).*aux;
                if strcmp(DwellSpeed,'Fast')
                    Polyp.DirectProgressionProb(advancedRiskSwitch) = Polyp.DirectProgressionProb(advancedRiskSwitch).*aux;
                end
            end
            
            if any(progressionToCancer) %any progressing to cancer
                numNewCancers = sum(progressionToCancer);
                Ca.Cancer = [Ca.Cancer; 7*ones(numNewCancers,1)];
                Ca.CancerYear = [Ca.CancerYear; repmat(stepCounter,numNewCancers,1)];
                Ca.CancerLocation = [Ca.CancerLocation; Polyp.PolypLocation(progressionToCancer)];
                Ca.DwellTime = [Ca.DwellTime; stepCounter - Polyp.PolypYear(progressionToCancer)];
                IDs = Polyp.SubjectID(progressionToCancer);
                Ca.SubjectID = [Ca.SubjectID; IDs];
                
                %SympStage = StageRandomGenerator(rand(numNewCancers,1));
                SympStage = StageRandomGenerator(double(Polyp.OwnersGender(progressionToCancer)),rand(numNewCancers,1));
                SympTimeAdd = SojournRandomGenerator(SympStage,rand(numNewCancers,1));
                
                SympTimeAddDouble = double(SympTimeAdd);
                SympStageShifted = SympStage-6;
                Ca.TimeStage_I = [Ca.TimeStage_I;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,1))];
                Ca.TimeStage_II = [Ca.TimeStage_II;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,2))];
                Ca.TimeStage_III = [Ca.TimeStage_III;  stepCounter + uint16(SympTimeAddDouble.*StageDurationC(SympStageShifted,3))];
                
                Ca.SympTime = [Ca.SympTime; stepCounter+SympTimeAdd];
                Ca.SympStage = [Ca.SympStage; SympStage];
                Ca.OwnersGender = [Ca.OwnersGender; Polyp.OwnersGender(progressionToCancer)];
                
                HasCancer(IDs) = min( HasCancer(IDs), currentYear);
                
                %we keep track
                if any(indirectProgression)
                    DwellTimeProgression{currentYear} = [DwellTimeProgression{currentYear}; stepCounter - Polyp.PolypYear(indirectProgression)];
                    ProgressedCancer(currentYear)  = ProgressedCancer(currentYear)+uint32(sum(indirectProgression));
                    ProgressedCancerR(currentYear) = ProgressedCancerR(currentYear)+uint32(sum(Polyp.PolypLocation(indirectProgression) < 4));
                end
                
                if any(progressingDirectlyToCancer)
                    DwellTimeFastCancer{currentYear} = [DwellTimeFastCancer{currentYear}; stepCounter - Polyp.PolypYear(progressingDirectlyToCancer)];
                    aux = Polyp.Polyps(progressingDirectlyToCancer);
                    U = unique(aux);
                    for i = 1:length(U)
                        DirectCancer(currentYear, U(i)) = DirectCancer(currentYear, U(i))+sum(aux == U(i));
                    end
                    DirectCancerR(currentYear) = DirectCancerR(currentYear)+uint32(sum(Polyp.PolypLocation(progressingDirectlyToCancer) < 4));
                end
                
                %deleting those polyps that are progressing to cancer
                deletePolyps(progressionToCancer);
            end
            
        end
        
    end %end if there are any polyps to progress
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   a polyp shrinks or disappears      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numPolyps = length(Polyp.Polyps);
    if numPolyps
        healing = rand(numPolyps,1) < StageVariables.Healing(Polyp.Polyps);
        if any(healing)
            
            Polyp.Polyps(healing) = Polyp.Polyps(healing)-1;
            dissapear = Polyp.Polyps == 0; %those healed completely
            
            %update progression probability for those polyps that shrinked
            probUpdate = healing & ~dissapear;
            Polyp.ProgressionProb(probUpdate) = Polyp.ProgressionProb(probUpdate)./...
                LocationProgressionRatios(Polyp.Polyps(probUpdate)*LocationProgressionRows+Polyp.PolypLocation(probUpdate))./...
                GenderProgressionRatios(Polyp.Polyps(probUpdate)+1+(Polyp.OwnersGender(probUpdate) - 1)*GenderProgressionRows);
            
            Polyp.DirectProgressionProb(probUpdate) = Polyp.DirectProgressionProb(probUpdate)./...
                StageVariables.FastCancerRatios(Polyp.Polyps(probUpdate)+1);
            
            advancedRiskSwitch = probUpdate & Polyp.Polyps == 4;
            if any(advancedRiskSwitch)
                aux = (RiskDistribution.AdvancedRisk(Polyp.AdvProgression(advancedRiskSwitch))./RiskDistribution.EarlyRisk(Polyp.EarlyProgression(advancedRiskSwitch)));
                Polyp.ProgressionProb(advancedRiskSwitch) = Polyp.ProgressionProb(advancedRiskSwitch)./aux;
                if strcmp(DwellSpeed,'Fast')
                    Polyp.DirectProgressionProb(advancedRiskSwitch) = Polyp.DirectProgressionProb(advancedRiskSwitch)./aux;
                end
            end
            
            %delete polyps that dissapear
            if any(dissapear)
                deletePolyps(dissapear);
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % symptom development               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    developedSymptoms = stepCounter >= Ca.SympTime; %those will develop symptoms
    if any(developedSymptoms)
        Number.Symptoms_Colonoscopy(currentYear) = Number.Symptoms_Colonoscopy(currentYear)+sum(developedSymptoms);
        Colonoscopy(unique(Ca.SubjectID(developedSymptoms)),'Symp');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Cancer Progression                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Stage_I_progression = Ca.Cancer == 7 & stepCounter >= Ca.TimeStage_I;
    Stage_II_progression = Ca.Cancer == 8 & stepCounter >= Ca.TimeStage_II;
    Stage_III_progression = Ca.Cancer == 9 & stepCounter >= Ca.TimeStage_III;
    if any(Stage_I_progression)
        Ca.Cancer(Stage_I_progression) = 8;
    end
    if any(Stage_II_progression)
        Ca.Cancer(Stage_II_progression) = 9;
    end
    if any(Stage_III_progression)
        Ca.Cancer(Stage_III_progression) = 10;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    baseline colonoscopy           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % There is a small chance,
    % symptoms appear even without a leasion
    
%                     if mod(stepCounter,numPeriods) == 1 %if we start a new year
%                         coloBase = rand(NAlive,1) < ColonoscopyLikelyhood(currentYear);
%                         if any(coloBase)
%                             % symptoms without a polyp: we do baseline colonoscopy
%                             Number.Baseline_Colonoscopy(y) = Number.Baseline_Colonoscopy(y) + sum(coloBase);
%                             Colonoscopy(SubjectIDs(coloBase),'Base');
%                         end
%                     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % polyp and cancer surveillance     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(stepCounter,numPeriods) == 1 %if we start a new year
        
        SurveillanceFlag = false(1,NAlive);
        dcurrentYear = double(currentYear);
        
        if flag.Polyp_Surveillance
            
            LastPolyp = Last.Polyp(SubjectIDs); %select for those that are alive
            LastAdvPolyp = Last.AdvPolyp(SubjectIDs); %select for those that are alive
            LastColonoscopy = Last.Colonoscopy(SubjectIDs); %select for those that are alive
            
            % a polyp removed 5 years ago if no colonoscopy
            % performed inbetween.
            SurveillanceFlag = SurveillanceFlag | (dcurrentYear - LastPolyp == 5 & dcurrentYear - LastColonoscopy >= 5);
            % between 5 and 9 years after polyp removal after last colonoscopy
            SurveillanceFlag = SurveillanceFlag | ((dcurrentYear - LastPolyp > 5 & dcurrentYear - LastPolyp <= 9) & dcurrentYear-LastColonoscopy >= 5);
            % an advanced polyp 3 years ago
            SurveillanceFlag = SurveillanceFlag | (dcurrentYear - LastAdvPolyp == 3 & dcurrentYear-LastColonoscopy >= 3);
            % 5 years intervals if an advanced polyp had been diagnosed
            SurveillanceFlag = SurveillanceFlag | (LastAdvPolyp ~= -100 & dcurrentYear - LastAdvPolyp >= 5 & dcurrentYear-LastColonoscopy >= 5);
            if flag.AllPolypFollowUp
                SurveillanceFlag = SurveillanceFlag | (LastPolyp ~= -100 & dcurrentYear - LastAdvPolyp >= 5 & dcurrentYear-LastColonoscopy >= 5);
            end
        end
        
        if flag.Cancer_Surveillance
           
            LastCancer = Last.Cancer(SubjectIDs);
            LastColonoscopy = Last.Colonoscopy(SubjectIDs); %select for those that are alive
            
            hadCancer = LastCancer ~= -100;
            % 1 year after cancer diagnosis
            SurveillanceFlag = SurveillanceFlag | (hadCancer & (dcurrentYear - LastCancer == 1 & dcurrentYear - LastColonoscopy == 1));
            % 4 years after cancer diagnosis
            SurveillanceFlag = SurveillanceFlag | (hadCancer & (dcurrentYear - LastCancer == 4 & dcurrentYear - LastColonoscopy == 3));
             % 5 years intervals after this
            SurveillanceFlag = SurveillanceFlag | (hadCancer & (dcurrentYear - LastCancer >= 5 & dcurrentYear - LastColonoscopy >= 5));
            
        end
        
        if any(SurveillanceFlag)
             Number.Follow_Up_Colonoscopy(currentYear) = Number.Follow_Up_Colonoscopy(currentYear) + sum(SurveillanceFlag);
             Colonoscopy(SubjectIDs(SurveillanceFlag),'Foll');
        end
        
        % perhaps we do screening?
        if flag.Screening
            % x-matrix
            % 1: PercentPop, 2: Adherence,    3: FollowUp,   4:y-start, 5:y-end,
            % 6: interval,   7: y after colo, 8: specificity
            % y-matrix
            % 1: colonoscopy, 2: Rectosigmoidoscopy, 3: FOBT, 4: I_FOBT
            % 5: Sept9_HiSens, 6: Sept9_HiSpec, 7: other
            screen = ScreeningPreference ~= 0;
            if any(screen)
                preferences = ScreeningPreference(screen);
                IDs = SubjectIDs(screen);
                
                toScreen = dcurrentYear >= ScreeningTest(preferences,4) & dcurrentYear < ScreeningTest(preferences,5);
                toScreen = toScreen & dcurrentYear-Last.Colonoscopy(IDs)' >= ScreeningTest(preferences,7); % we only screen so and so many years after the last Colonoscopy
                
                if any(toScreen)
                    
                    NtoScreen = sum(toScreen); %number of individuals to screen
                    preferences = preferences(toScreen); %preferences of screened indivisuals
                    IDs = IDs(toScreen); %IDs of the screened subjects
                    
                    compliance = rand(NtoScreen,1) < ScreeningTest(preferences,2); %compliance randomization for each screened subject
                    
                    screenColo = preferences == 1 & compliance & dcurrentYear-Last.Colonoscopy(IDs)' >=  ScreeningTest(preferences,6); % Colonoscopy % corrected 23.04.2018, %interval
                    
                    if any(screenColo) %performing colonoscopy
                        Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(screenColo);
                        Colonoscopy(IDs(screenColo),'Scre');
                    end
                    
                    screenRecto = preferences == 2 & compliance & dcurrentYear-Last.ScreenTest(IDs)' >= ScreeningTest(preferences,6);
                    
                    if any(screenRecto) %performing rectosigmoidoscopy
                        Number.RectoSigmo(currentYear) = Number.RectoSigmo(currentYear) + sum(screenRecto);
                        IDsSR = IDs(screenRecto);
                        Last.ScreenTest(IDsSR) = dcurrentYear;
                        [PolypFlag, AdvPolypFlag, CancerFlag] = RectoSigmo(IDsSR);
                        additionalColonoscopy = (PolypFlag | CancerFlag | AdvPolypFlag) & ...
                            (rand(length(IDsSR),1) < ScreeningTest(preferences(screenRecto),3)); %compliance
                        if any(additionalColonoscopy)
                            Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(additionalColonoscopy);
                            %ScreeningPreference(ismember(SubjectIDs,IDsSR(additionalColonoscopy))) = 1; % according to paper by Zauber et al. we need to continue with colonoscopy screening
                            Colonoscopy(IDsSR(additionalColonoscopy),'Scre');
                        end
                        
                    end
                    
                    %other test
                    otherTest = preferences > 2 & dcurrentYear-Last.ScreenTest(IDs)' >= ScreeningTest(preferences,6) & compliance;
                    
                    if any(otherTest) %if there is anyone to perform another test
                        IDsSR = IDs(otherTest);
                        Nother = sum(otherTest);
                        Last.ScreenTest(IDsSR) = dcurrentYear;
                        
                        TestedPolyps = ismember(Polyp.SubjectID, IDsSR);
                        TestedCancers = ismember(Ca.SubjectID, IDsSR);
                        
                        PID = Polyp.SubjectID(TestedPolyps);
                        CID = Ca.SubjectID(TestedCancers);
                        Pstage = Polyp.Polyps(TestedPolyps);
                        Cstage = uint16(Ca.Cancer(TestedCancers));
                        
                        preferencesOther = preferences(otherTest);
                        
                        Limit = zeros(Nother,1);
                        for kk = 1:length(IDsSR)
                            MC = max(Cstage(CID == IDsSR(kk)));
                            MP = max(Pstage(PID == IDsSR(kk)));
                            if isempty(MC)
                               MC = -1; 
                            end
                            if isempty(MP)
                               MP = -1; 
                            end
                            M = max(MC, MP);
                            if M > 0 %if anything to screen
                               Limit(kk) = Sensitivity(preferencesOther(kk),M);
                            end
                        end
                        Limit = max(Limit,1-ScreeningTest(preferencesOther,8));
                        
                        positiveAndFollowup = rand(Nother,1) < Limit & rand(Nother,1) < ScreeningTest(preferencesOther, 3);
                        if any(positiveAndFollowup)
                           Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(positiveAndFollowup);
                           %ScreeningPreference(ismember(SubjectIDs,IDsSR(additionalColonoscopy))) = 1; % according to paper by Zauber et al. we need to continue with colonoscopy screening
                           Colonoscopy(IDsSR(positiveAndFollowup),'Scre'); 
                        end
                        
                        NFOBT = sum(preferencesOther == 3);
                        if NFOBT
                            Number.FOBT(currentYear) = Number.FOBT(currentYear) + NFOBT;
                            Money.Screening(currentYear, IDsSR(preferencesOther == 3)) = Money.Screening(currentYear, IDsSR(preferencesOther == 3)) + Cost.FOBT;
                            PaymentType.FOBT(1, currentYear) = PaymentType.FOBT(1, currentYear) + NFOBT;
                        end
                        
                        NI_FOBT = sum(preferencesOther == 4);
                        if NI_FOBT
                            Number.I_FOBT(currentYear)   = Number.I_FOBT(currentYear) +NI_FOBT;
                            Money.Screening(currentYear, IDsSR(preferencesOther == 4)) = Money.Screening(currentYear, IDsSR(preferencesOther == 4)) + Cost.I_FOBT;
                            PaymentType.I_FOBT(1, currentYear) = PaymentType.I_FOBT(1, currentYear) +NI_FOBT;
                        end
                        
                        NSept9_HighSens = sum(preferencesOther == 5);
                        if NSept9_HighSens
                            Number.Sept9(currentYear)    = Number.Sept9(currentYear) +NSept9_HighSens;
                            Money.Screening(currentYear, IDsSR(preferencesOther == 5)) = Money.Screening(currentYear, IDsSR(preferencesOther == 5)) + Cost.Sept9_HighSens;
                            PaymentType.Sept9_HighSens(1, currentYear) = PaymentType.Sept9_HighSens(1, currentYear) +NSept9_HighSens;
                        end
                        
                        
                        NSept9_HighSpec = sum(preferencesOther == 6);
                        if NSept9_HighSpec
                            Number.Sept9(currentYear)    = Number.Sept9(currentYear) + NSept9_HighSpec;
                            Money.Screening(currentYear, IDsSR(preferencesOther == 6)) = Money.Screening(currentYear, IDsSR(preferencesOther == 6)) + Cost.Sept9_HighSpec;
                            PaymentType.Sept9_HighSpec(1, currentYear) = PaymentType.Sept9_HighSpec(1, currentYear) + NSept9_HighSpec;
                        end
                        
                        NTestOther = sum(preferencesOther == 7);
                        if NTestOther
                            Number.other(currentYear)    = Number.other(currentYear) + NTestOther;
                            Money.Screening(currentYear, IDsSR(preferencesOther == 7)) = Money.Screening(currentYear, IDsSR(preferencesOther == 7)) + Cost.other;
                            PaymentType.Other(1, currentYear) = PaymentType.Other(1, currentYear) + NTestOther;
                        end

                    end
                    
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %    special scenarios              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if flag.SpecialFlag
            
             if flag.Atkin 
                 if currentYear == 1
                     % randomly one test year between 55 and 64
                     tmp=55:64;
                     Ntmp = size(Last.Included,2); %initial population size
                     Last.Included = tmp(randi(length(tmp),Ntmp,1));
                     adh = rand(1,Ntmp) < 0.71;% adherence to first screening
                     Last.TestYear(adh) = Last.Included(adh);
                 else
                     dcurrentYear = double(currentYear); %convert to double
                     screen = Last.Included == dcurrentYear;
                     if any(screen)
                        % we need to check inclusion criteria
                         StudyFlag = dcurrentYear-Last.Colonoscopy(screen) > 3;
                         StudyFlag = StudyFlag & Last.Cancer(screen) == -100;
                         StudyFlag = StudyFlag & Last.Polyp(screen) == -100;
                         StudyFlag = StudyFlag & Last.AdvPolyp(screen) == -100;
                         
                         if any(~StudyFlag) % we exclude the patient by setting the years to -1
                             ex = find(screen);
                             ex = ex(~StudyFlag);%those will be excluded
                             Last.TestYear(ex)  = -1;
                             Last.TestYear2(ex) = -1;
                             Last.Included(ex)  = -1;
                         end
                     end
                     
                     testYear = Last.TestYear == dcurrentYear;
                     if any(testYear)
                         Last.TestDone(testYear) = 1;
                         if ~flag.Mock
                             Number.RectoSigmo(currentYear) = Number.RectoSigmo(currentYear) + sum(testYear);
                             IDsSR = find(testYear);
                             %make sure that the patients with given ID are
                             %alive
                             IDsSR = IDsSR(ismember(IDsSR, SubjectIDs));
                             [PolypFlag, AdvPolypFlag, CancerFlag] = RectoSigmo(IDsSR);
                             if any(AdvPolypFlag)
                                Last.Polyp(IDsSR(AdvPolypFlag ~= 0)) = dcurrentYear;
                             end
                             indxLoc = PolypFlag & AdvPolypFlag == 0;
                             if any(indxLoc)
                                Last.Polyp(IDsSR(indxLoc)) = dcurrentYear; 
                             end
                             
                             indxLoc = AdvPolypFlag | CancerFlag;
                             if any(indxLoc)
                                  Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(indxLoc);
                                  Colonoscopy(IDsSR(indxLoc),'Scre');
                             end
                                 
                         end
                     end
                     
                 end

             end
            
            if flag.PBP % the special scenario with poor bowel preparation
                if currentYear == PBP.Year
                    cond1 = dcurrentYear-Last.Colonoscopy(SubjectIDs) >= 10;
                    if any(cond1) %any patient fullfilling criteria
                        IDs = SubjectIDs(cond1);
                        PBP_Doc.Screening(IDs) = true;
                        tmp = StageVariables.Colo_Detection; % we stored the colo-characteristics of PBP in this variable
                        StageVariables.Colo_Detection = StageVariables.RectoSigmo_Detection;
                        
                        if isequal(PBP.Mock, 1)
                            % mock mode, nothing will be changed by
                            % this colonoscopy
                            Colonoscopy_Mock(IDs); %perform mock colonoscopy
                        else
                            Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(cond1);
                            Colonoscopy(IDs,'PBPx');
                        end
                        
                        StageVariables.Colo_Detection = tmp;
                    end
                end
                if PBP.RepeatYear > -1 % if repeat year not xx (i.e. not planned)
                   if currentYear == PBP.Year + uint8(PBP.RepeatYear)
                       cond1 = Last.Colonoscopy(SubjectIDs) == double(PBP.Year);
                       
                       if any(cond1)
                           IDs = SubjectIDs(cond1);
                           Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + sum(cond1);
                           Colonoscopy(IDs,'Scre');
                       end
                   end
                end
            end
            
            if flag.Kolo1
                if dcurrentYear == ScreeningTest(1, 4)
                    Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + length(SubjectIDs);
                    Colonoscopy(SubjectIDs,'Scre'); %screening everyone
                end
            elseif flag.Kolo2
                if dcurrentYear == ScreeningTest(1, 4) || dcurrentYear == ScreeningTest(1, 5)
                    Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + length(SubjectIDs);
                    Colonoscopy(SubjectIDs,'Scre'); %screening everyone
                end
            elseif flag.Kolo3
                if dcurrentYear == ScreeningTest(1, 4) || dcurrentYear == ScreeningTest(1, 5)|| dcurrentYear == ScreeningTest(1, 6)
                    Number.Screening_Colonoscopy(currentYear) = Number.Screening_Colonoscopy(currentYear) + length(SubjectIDs);
                    Colonoscopy(SubjectIDs,'Scre'); %screening everyone
                end
            end
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %    summarizing polyps             %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % before a polyp can be detected and removed for screening we
        % summarize the prevalence of all polyps and cancers
        if ~isempty(Polyp.Polyps)
            A = [Polyp.SubjectID Polyp.Polyps];
            A = sortrows(A);
            aux = find(diff([A(:,1); NumIndividualsToSimulate+1]));
            idxIDs = unique(A(:,1));
            NumPolyps(idxIDs, currentYear) = diff([0; aux]);
            MaxPolyps(idxIDs, currentYear) = A(aux,2);
            
            AllPolyps(unique(Polyp.Polyps), currentYear) = diff([0; find(diff([sort(Polyp.Polyps); 12]))]);
        end
        
        
        fprintf('Calculating year %d\n', currentYear);
    end
    
end

%% modyfing output arguments for compability with old CMOST
currentYear = double(currentYear);
DeathCause = double(DeathCause');
idxA = NaturalDeathYear == 0;
NaturalDeathYear = double(NaturalDeathYear')/double(numPeriods) + 0.75;
NaturalDeathYear(idxA) = double(yearsToSimulate);
YearIncluded = YearIncluded';
YearAlive    = YearAlive';
idxA = DeathYear == 0;
DeathYear = double(DeathYear')/double(numPeriods) + 0.75;
DeathYear(idxA) = 0;

TumorRecord.Time = double(TumorRecord.Time)/double(numPeriods) + 0.75;

HasCancerOut = zeros(yearsToSimulate, length(GenderOut));
for i = 1:length(GenderOut)
   HasCancerOut((HasCancer(i)+1):end,i) = 1; 
end

EarlyPolypsRemoved = double(EarlyPolypsRemoved);
AdvancedPolypsRemoved = double(AdvancedPolypsRemoved);

DirectCancer = double(DirectCancer)';
DirectCancerR = double(DirectCancerR)';
DirectCancer2 = double(DirectCancer2)';
DirectCancer2R = double(DirectCancer2R)';
ProgressedCancer = double(ProgressedCancer)';
ProgressedCancerR = double(ProgressedCancerR)';

NumPolyps = double(NumPolyps');
MaxPolyps = double(MaxPolyps');
AllPolyps = double(AllPolyps);

NumCancer = double(NumCancer');
MaxCancer = double(MaxCancer');

DiagnosedCancer = double(DiagnosedCancer');

DwellTimeProgressionOut = zeros(yearsToSimulate, 10000);
for i = 1:length(DwellTimeProgression)
    %removing zeros to be consistent with old CMOST
    aux = DwellTimeProgression{i}; aux(aux==0) = [];
    DwellTimeProgressionOut(i,1:length(aux)) = aux;
end
DwellTimeProgressionOut = DwellTimeProgressionOut/double(numPeriods);

DwellTimeFastCancerOut = zeros(yearsToSimulate, 10000);
for i = 1:length(DwellTimeFastCancer)
    %removing zeros to be consistent with old CMOST
    aux = DwellTimeFastCancer{i}; aux(aux==0) = [];
    DwellTimeFastCancerOut(i,1:length(aux)) = aux;
end
DwellTimeFastCancerOut = DwellTimeFastCancerOut/double(numPeriods);


TumorRecordOut.Stage = zeros(10000, yearsToSimulate);
TumorRecordOut.Location = zeros(10000, yearsToSimulate);
TumorRecordOut.Sojourn = zeros(10000, yearsToSimulate);
TumorRecordOut.DwellTime = zeros(10000, yearsToSimulate);
TumorRecordOut.Gender = zeros(10000, yearsToSimulate);
TumorRecordOut.Detection = zeros(10000, yearsToSimulate);
TumorRecordOut.PatientNumber = zeros(10000, yearsToSimulate);
TumorRecordOut.Time = zeros(10000, yearsToSimulate); % FIX BM 27.10.2018 

for i = 1:yearsToSimulate
    idxTmp = (TumorRecord.Year == i);
    if any(idxTmp)
        Nrec = sum(idxTmp);
        TumorRecordOut.Stage(1:Nrec,i) = TumorRecord.Stage(idxTmp);
        TumorRecordOut.Location(1:Nrec,i) = TumorRecord.Location(idxTmp);
        TumorRecordOut.Sojourn(1:Nrec,i) = double(TumorRecord.Sojourn(idxTmp))/double(numPeriods);
        TumorRecordOut.DwellTime(1:Nrec,i) = double(TumorRecord.DwellTime(idxTmp))/double(numPeriods);
        TumorRecordOut.Gender(1:Nrec,i) = TumorRecord.Gender(idxTmp);
        TumorRecordOut.Detection(1:Nrec,i) = TumorRecord.Detection(idxTmp);
        TumorRecordOut.PatientNumber(1:Nrec,i) = TumorRecord.SubjectID(idxTmp);
        TumorRecordOut.Time(1:Nrec,i) = TumorRecord.Time(idxTmp); % FIX BM 27.10.2018 
    end
end

flds = fields(TumorRecordOut);
for i = 1:length(flds)
    TumorRecordOut.(flds{i}) = TumorRecordOut.(flds{i})';
end

Money.AllCost       = Money.Treatment + Money.Screening + Money.FollowUp + Money.Other; 
Money.AllCostFuture = Money.FutureTreatment + Money.Screening + Money.FollowUp + Money.Other; 

%comment out to be consistent with previous code
% Mf = fields(Money);
% for i = 1:length(Mf)
%    Money.(Mf{i}) = sum(Money.(Mf{i}),2); 
% end

flds = fields(PBP_Doc);
for i = 1:length(flds)
    PBP_Doc.(flds{i}) = double(PBP_Doc.(flds{i}));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NESTED FUNCTIONS DEFINITIONS            %
% it is crucial to have them nested, i.e. defined before the last end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function death(whichSubjects, keep)
        if nargin < 2
            keep = true; %default value is to keep for further calculations
        end
        %removing all associated polyps
        IDsToDelete = SubjectIDs(whichSubjects);
        indx = ismember(Polyp.SubjectID, IDsToDelete);
        deletePolyps(indx);
        
        %removing all associated cancers
        indx = ismember(Ca.SubjectID, IDsToDelete);
        deleteCancers(indx);
        
        %removing all associated detected cancers
        indx = ismember(Detected.SubjectID, IDsToDelete);
        deleteDetectedCancers(indx);
        
        if keep %if too keep individuals for further, Included substitute
            SubjectsIDWouldBeAlive = [SubjectsIDWouldBeAlive; SubjectIDs(whichSubjects)];
            GenderWouldBeAlive     = [GenderWouldBeAlive; Gender(whichSubjects)];
        end
        
        %making variable consitent with CMOST old codes
        for ii = 1:length(IDsToDelete)
            NumCancer(IDsToDelete(ii), currentYear:end) = NumCancer(IDsToDelete(ii), currentYear);
            MaxCancer(IDsToDelete(ii), currentYear:end) = MaxCancer(IDsToDelete(ii), currentYear);
        end
        
        %removing individuals from simulation when they die
        whichSubjects = ~whichSubjects; 
        
        SubjectIDs = SubjectIDs(whichSubjects);
        Gender = Gender(whichSubjects);
        NAlive = sum(whichSubjects);
        IndividualRisk = IndividualRisk(whichSubjects);
        PolypRate = PolypRate(whichSubjects);
        BlockFromDeath = BlockFromDeath(whichSubjects);
        
        ScreeningPreference = ScreeningPreference(whichSubjects);
    end

    function deletePolyps(indx)

        if ~islogical(indx)
           indxN = true(size(Polyp.SubjectID));
           indxN(indx) = false;
           indx = indxN;
        else
           indx = ~indx;
        end
                
        Polyp.SubjectID = Polyp.SubjectID(indx);
        Polyp.Polyps = Polyp.Polyps(indx);
        Polyp.PolypYear = Polyp.PolypYear(indx);
        Polyp.PolypLocation = Polyp.PolypLocation(indx);
        Polyp.EarlyProgression = Polyp.EarlyProgression(indx);
        Polyp.AdvProgression = Polyp.AdvProgression(indx);
        Polyp.ProgressionProb = Polyp.ProgressionProb(indx);
        Polyp.DirectProgressionProb = Polyp.DirectProgressionProb(indx);
        Polyp.OwnersGender = Polyp.OwnersGender(indx);
%         end
    end

    function deleteCancers(indx)
        
         if ~islogical(indx)
           indxN = true(size(Ca.Cancer));
           indxN(indx) = false;
           indx = indxN;
        else
           indx = ~indx;
         end
        
        Ca.Cancer               = Ca.Cancer(indx);
        Ca.CancerYear           = Ca.CancerYear(indx);
        Ca.CancerLocation       = Ca.CancerLocation(indx);
        Ca.DwellTime            = Ca.DwellTime(indx);
        Ca.SympTime             = Ca.SympTime(indx);
        Ca.SympStage            = Ca.SympStage(indx);
        Ca.TimeStage_I          = Ca.TimeStage_I(indx);
        Ca.TimeStage_II         = Ca.TimeStage_II(indx);
        Ca.TimeStage_III        = Ca.TimeStage_III(indx);
        Ca.SubjectID            = Ca.SubjectID(indx);
        Ca.OwnersGender         = Ca.OwnersGender(indx);
    end

    function deleteDetectedCancers(indx)
        if ~islogical(indx)
            indxN = true(size(Detected.Cancer));
            indxN(indx) = false;
            indx = indxN;
        else
            indx = ~indx;
        end
        
        Detected.Cancer               = Detected.Cancer(indx);
        Detected.CancerYear           = Detected.CancerYear(indx);
        Detected.CancerLocation       = Detected.CancerLocation(indx);
        Detected.MortTime             = Detected.MortTime(indx);
        Detected.SubjectID            = Detected.SubjectID(indx);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         COLONOSCOPY MOCK                           %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Colonoscopy_Mock(SelectedSubjectID)
        
        Ncolo = length(SelectedSubjectID); %number of colonoscopies to perform
        
        [ScreenedPolyps, LocP] = ismember(Polyp.SubjectID, SelectedSubjectID);
        [ScreenedCancers, LocC] = ismember(Ca.SubjectID, SelectedSubjectID);
        LocP(LocP==0) = 1; %taking care of zero indexing that would throw an error
        LocC(LocC==0) = 1; %taking care of zero indexing that would throw an error
        
        %select only those polyps and cancers that are reached by
        %colonoscopy (cecum = 1, rectum = 13))
        CurrentReach = ColoReachRandomGenerator(rand(Ncolo,1));
        ScreenedPolyps = ScreenedPolyps & (Polyp.PolypLocation >= CurrentReach(LocP));
        ScreenedCancers = ScreenedCancers & (Ca.CancerLocation >= CurrentReach(LocC));
        
        nScreenedPolyps = sum(ScreenedPolyps);
        nScreenedCancers = sum(ScreenedCancers);
        
        Fpolyps = find(ScreenedPolyps);
        detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.Colo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
            Location.ColoDetection(Polyp.PolypLocation(ScreenedPolyps));
        
        counterAdvanced = uint8(zeros(Ncolo,1)); %number of detected advanced polyps per patient
        counterEarly    = uint8(zeros(Ncolo,1)); %number of detected early polyps per patient
        
        if any(detectedPolyps)
            idx = Fpolyps(detectedPolyps);
            X = LocP(idx);
            advanced = Polyp.Polyps(idx)>4;
            U = unique(X);
            for ii = 1:length(U)
                counterAdvanced(U(ii)) = sum(X == U(ii) & advanced);
                counterEarly(U(ii)) = sum(X == U(ii) & ~advanced);
            end 
        end
        
        PBP_Doc.Early(SelectedSubjectID) = counterEarly;
        PBP_Doc.Advanced(SelectedSubjectID) = counterAdvanced;
        
        Fcancers = find(ScreenedCancers);
        detectedCancers = rand(nScreenedCancers,1) < StageVariables.Colo_Detection(Ca.Cancer(ScreenedCancers));
        
        counterCancer    = uint8(zeros(Ncolo,1)); %number of detected cancers per patient
        
        if any(detectedCancers)
            % in case of detecion we mark cancer as detected and remove it
            idx = Fcancers(detectedCancers);
            
            X = LocC(idx);
            U = unique(X);
            for ii = 1:length(U)
                counterCancer(U(ii)) = sum(X == U(ii));
            end
        end
        
        PBP_Doc.Cancer(SelectedSubjectID) = counterCancer;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         COLONOSCOPY                               %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Colonoscopy(SelectedSubjectID, Modus)
        
        %check whether it is PBP mode
        PBPudpate = any(strcmpi(Modus,{'PBPx','PBPm'}));
        
        Ncolo = length(SelectedSubjectID); %number of colonoscopies to perform
        
        [ScreenedPolyps, LocP] = ismember(Polyp.SubjectID, SelectedSubjectID);
        [ScreenedCancers, LocC] = ismember(Ca.SubjectID, SelectedSubjectID);
        LocP(LocP==0) = 1; %taking care of zero indexing that would throw an error
        LocC(LocC==0) = 1; %taking care of zero indexing that would throw an error
        
        %select only those polyps and cancers that are reached by
        %colonoscopy (cecum = 1, rectum = 13))
        CurrentReach = ColoReachRandomGenerator(rand(Ncolo,1));
        ScreenedPolyps = ScreenedPolyps & (Polyp.PolypLocation >= CurrentReach(LocP));
        ScreenedCancers = ScreenedCancers & (Ca.CancerLocation >= CurrentReach(LocC));
        
        nScreenedPolyps = sum(ScreenedPolyps);
        nScreenedCancers = sum(ScreenedCancers);
        
        Fpolyps = find(ScreenedPolyps);
        detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.Colo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
            Location.ColoDetection(Polyp.PolypLocation(ScreenedPolyps));
        
        
        counterAdvanced = uint8(zeros(Ncolo,1)); %number of detected advanced polyps per patient
        counterEarly    = uint8(zeros(Ncolo,1)); %number of detected early polyps per patient
        
        if any(detectedPolyps)
            idx = Fpolyps(detectedPolyps);
            X = LocP(idx);
            advanced = Polyp.Polyps(idx)>4;
            U = unique(X);
            for ii = 1:length(U)
                counterAdvanced(U(ii)) = sum(X == U(ii) & advanced);
                counterEarly(U(ii)) = sum(X == U(ii) & ~advanced);
            end
            
            %updating the output varible with number of removed polyps
            AdvancedPolypsRemoved(currentYear) = AdvancedPolypsRemoved(currentYear) + sum(counterAdvanced);
            EarlyPolypsRemoved(currentYear) = EarlyPolypsRemoved(currentYear) + sum(counterEarly);
            
            Last.Polyp(SelectedSubjectID(counterEarly > 0)) = currentYear;
            Last.AdvPolyp(SelectedSubjectID(counterAdvanced > 0 | counterEarly > 2)) = currentYear;% 3 polyps counts as an advanced polyp
            
            % in case of detecion we remove the polyp
            deletePolyps(idx); %deleting detected polyps
        end
        
        %PBP udpate
        if PBPudpate
            PBP_Doc.Early(SelectedSubjectID) = counterEarly;
            PBP_Doc.Advanced(SelectedSubjectID) = counterAdvanced;
        end
        
        [~, m] = ismember(Modus,{'Scre','Symp','Foll','Base'});
        m = uint8(m);
        if PBPudpate
           m = uint8(1); 
        end
        
        Fcancers = find(ScreenedCancers);
        detectedCancers = rand(nScreenedCancers,1) < StageVariables.Colo_Detection(Ca.Cancer(ScreenedCancers));
        
        counterCancer    = uint8(zeros(Ncolo,1)); %number of detected cancers per patient
        
        if any(detectedCancers)
            % in case of detecion we mark cancer as detected and remove it
            idx = Fcancers(detectedCancers);
            
            X = LocC(idx);
            U = unique(X);
            for ii = 1:length(U)
                counterCancer(U(ii)) = sum(X == U(ii));
            end
            
            Detected.Cancer         = [Detected.Cancer; Ca.Cancer(idx)];
            Detected.CancerYear     = [Detected.CancerYear; repmat(stepCounter, length(idx),1)];
            Detected.CancerLocation = [Detected.CancerLocation; Ca.CancerLocation(idx)];
            %MortTime = MortalityRandomGenerator(double(Ca.Cancer(idx)),rand(length(idx),1));%+4;
            MortTime = zeros(length(idx),1);
            malesLoc = Ca.OwnersGender(idx) == 1;
            MortTime(malesLoc) = MortalityRandomGeneratorMale(double(Ca.Cancer(idx(malesLoc))),rand(sum(malesLoc),1));%+4;
            MortTime(~malesLoc) = MortalityRandomGeneratorFemale(double(Ca.Cancer(idx(~malesLoc))),rand(sum(~malesLoc),1));%+4;
            
            %we need to block the patient from dying before the MortTime
            %first I need to locate the patients in the whole cohort
            [im, LocC] = ismember(unique(Ca.SubjectID(idx(MortTime < ni*numPeriods+1))), SubjectIDs);
            if ~all(im)
                disp('Grave error #ID colonoscopyBlockPatient');
            else
                %finding which patients to block
                %disp('Blocking')
                
                BlockFromDeath(LocC) = true;
            end
            
            Detected.MortTime       = [Detected.MortTime; MortTime];
            Detected.SubjectID      = [Detected.SubjectID; Ca.SubjectID(idx)];
            
            % we need keep track of key parameters
            % Stage Location SojournTime Sex DetectionMode
            X = Ca.SubjectID(idx);%IDs of the patients with detected cancers
            U = unique(X);
            N = sum(counterCancer > 0);
            idxFin = zeros(N,1);
            for ii = 1:length(U) %for each patient find the one with the most advanced stage
                idxF = idx(X == U(ii));
                [~, whichMax] = max(Ca.Cancer(idxF));
                idxFin(ii) = idxF(whichMax(end)); %this cancer will be saved
            end
            
            TumorRecord.Stage = [TumorRecord.Stage; Ca.Cancer(idxFin)];
            TumorRecord.Location  = [TumorRecord.Location; Ca.CancerLocation(idxFin)];
            TumorRecord.DwellTime = [TumorRecord.DwellTime; Ca.DwellTime(idxFin)];
            TumorRecord.Sojourn   = [TumorRecord.Sojourn; stepCounter - Ca.CancerYear(idxFin)];
            TumorRecord.Gender    = [TumorRecord.Gender; Ca.OwnersGender(idxFin)];
            TumorRecord.Detection = [TumorRecord.Detection; repmat(m,N,1)];
            TumorRecord.SubjectID = [TumorRecord.SubjectID; Ca.SubjectID(idxFin)];
            TumorRecord.Year      = [TumorRecord.Year; repmat(currentYear,N,1)];
            TumorRecord.Time      = [TumorRecord.Time; repmat(stepCounter,N,1)];
            
            DiagnosedCancer(Ca.SubjectID(idxFin), currentYear) = max(DiagnosedCancer(Ca.SubjectID(idxFin), currentYear),...
                                                                       Ca.Cancer(idxFin));
            
            Last.Cancer(SelectedSubjectID(counterCancer > 0)) = currentYear;
            
            deleteCancers(idx); %deleting deetcted cancers from the array
        end
        
        if PBPudpate
            PBP_Doc.Cancer(SelectedSubjectID) = counterCancer;
        end
        
        Last.Colonoscopy(SelectedSubjectID) = currentYear;
        
        moneyspent = Cost.Colonoscopy_Polyp*ones(Ncolo,1);
        factor = 1.5*ones(Ncolo,1);
        noTumorAndNoPolyps = counterCancer == 0 & counterAdvanced == 0 & counterEarly == 0;
        moneyspent(noTumorAndNoPolyps) = Cost.Colonoscopy;
        factor(noTumorAndNoPolyps) = 0.75;
        PaymentType.Colonoscopy(m,currentYear) = PaymentType.Colonoscopy(m,currentYear) + sum(noTumorAndNoPolyps);
        
        TumorAndNoPolyps = counterCancer > 0  & counterAdvanced == 0 & counterEarly == 0;
        moneyspent(TumorAndNoPolyps) = Cost.Colonoscopy_Cancer;
        PaymentType.Colonoscopy_Cancer(m,currentYear) = PaymentType.Colonoscopy_Cancer(m,currentYear) + sum(TumorAndNoPolyps);
        
        PaymentType.ColonoscopyPolyp(m,currentYear) = PaymentType.ColonoscopyPolyp(m,currentYear) + sum(~TumorAndNoPolyps & ~noTumorAndNoPolyps);
        
        %moneyspent = sum(moneyspent);
        
        %%%% Complications
        Rand = rand(Ncolo,6); %generating random numbers in advance
        
        perforation  = Rand(:,1) < risc.Colonoscopy_RiscPerforation.*factor;
        if any(perforation)% a perforation happend
            Nperfo = sum(perforation);
            moneyspent = moneyspent + perforation*Cost.Colonoscopy_Perforation;
            PaymentType.Perforation(m,currentYear) = PaymentType.Perforation(m,currentYear) + Nperfo; 
            deathPerforation        = perforation & Rand(:,2) < risc.DeathPerforation;
            if any(deathPerforation) % patient died during colonoscopy from a perforation
                DeathCause(SelectedSubjectID(deathPerforation))= 3;
                DeathYear(SelectedSubjectID(deathPerforation)) = stepCounter;
                
                % we add the costs
                AddCosts(SelectedSubjectID(deathPerforation), 'oc');
                
                death(ismember(SubjectIDs, SelectedSubjectID(deathPerforation)));
            end
        end
        serosaBurn = ~perforation & Rand(:,3) < risc.Colonoscopy_RiscSerosaBurn.*factor;
        if any(serosaBurn)% serosal burn
            NserosaBurn = sum(serosaBurn);
            moneyspent = moneyspent + serosaBurn*Cost.Colonoscopy_Serosal_burn;
            PaymentType.Serosa(m,currentYear) = PaymentType.Serosa(m,currentYear) + NserosaBurn; 
        end
        bleeding = ~serosaBurn & ~perforation & Rand(:,4) < risc.Colonoscopy_RiscBleeding.*factor;
        if any(bleeding) % a bleeding episode (no transfusion)
            Nbleeding = sum(bleeding);
            moneyspent = moneyspent + bleeding*Cost.Colonoscopy_bleed;
            PaymentType.Bleeding(m,currentYear) = PaymentType.Bleeding(m,currentYear) + Nbleeding; 
        end
        bleedingTransfusion     = ~bleeding & ~serosaBurn & ~perforation  &  Rand(:,5) < risc.Colonoscopy_RiscBleedingTransfusion.*factor;
        if any(bleedingTransfusion)% bleeding recquiring transfusion
            NbleedingTransfusion = sum(bleedingTransfusion);
            moneyspent = moneyspent + bleedingTransfusion*Cost.Colonoscopy_bleed_transfusion;
            PaymentType.BleedingTransf(m,currentYear) = PaymentType.BleedingTransf(m,currentYear) + NbleedingTransfusion; 
            
            deathBleedingTransfusion = bleedingTransfusion & Rand(:,6) < risc.DeathBleedingTransfusion;
            if any(deathBleedingTransfusion) % patient died during colonoscopy from a bleeding complication
                DeathCause(SelectedSubjectID(deathBleedingTransfusion))= 3;
                DeathYear(SelectedSubjectID(deathBleedingTransfusion)) = stepCounter;
                
                % we add the costs
                AddCosts(SelectedSubjectID(deathBleedingTransfusion), 'oc');
                
                death(ismember(SubjectIDs, SelectedSubjectID(deathBleedingTransfusion)));
            end
        
        end
        
        switch Modus
            case 'Scre' % Screening
                Money.Screening(currentYear,SelectedSubjectID)    = Money.Screening(currentYear,SelectedSubjectID) + moneyspent';
            case 'PBPx' % poor bowel preparation
                Money.Screening(currentYear,SelectedSubjectID)    = Money.Screening(currentYear,SelectedSubjectID) + moneyspent';          
            case 'Symp' % Symptoms
                Money.Treatment(currentYear,SelectedSubjectID)    = Money.Treatment(currentYear,SelectedSubjectID) + moneyspent';
            case 'Foll' % Follow-up
                Money.FollowUp(currentYear,SelectedSubjectID)     = Money.FollowUp(currentYear,SelectedSubjectID) + moneyspent';
            case 'Base' % Baseline
                Money.Other(currentYear,SelectedSubjectID)        = Money.Other(currentYear,SelectedSubjectID) + moneyspent';
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         Rectosigmoidoscpy                         %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [PolypFlag, AdvPolypFlag, CancerFlag] = RectoSigmo(SelectedSubjectID)
        
        %z, y, Polyp, Ca, Included, DeathCause, DeathYear, PaymentType, Money,...
        %    StageVariables, Cost, Location, risc, RectoSigmoReachMatrix, flag)
        
        % in this function we do a rectosigmoidoscopy for the respective
        % patients (SelectedSubjectID). We just note whether a polyp or a cancer was found and pass the
        % information back to the calling function
                
        Nrsigmo = length(SelectedSubjectID); %number of rectosigmoidoscopies to perform
        
        [ScreenedPolyps, LocP] = ismember(Polyp.SubjectID, SelectedSubjectID);
        LocP(LocP==0) = 1; %taking care of zero indexing that would throw an error
        
        %select only those polyps that are reached by
        %rectosigmoidoscopy (cecum = 1, rectum = 13))
        CurrentReach = RectoSigmoReachRandomGenerator(rand(Nrsigmo,1));
        ScreenedPolyps = ScreenedPolyps & (Polyp.PolypLocation >= CurrentReach(LocP));
        
        nScreenedPolyps = sum(ScreenedPolyps); %number of polyps in reach
        Fpolyps = find(ScreenedPolyps); %indoces to which polyps are in reach
        
        counter = uint8(zeros(Nrsigmo,1)); %number of detected polyps per patient
        PolypFlag = uint8(zeros(Nrsigmo,1));
        CancerFlag = uint8(zeros(Nrsigmo,1));
        PolypMax = uint8(zeros(Nrsigmo,1));
        
        if flag.Schoen
            
            detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.RectoSigmo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
                             Location.RectoSigmoDetection(Polyp.PolypLocation(ScreenedPolyps));
            % we record the polyp
            % in this scenario we only do follow up for larger polyps
            idx = Fpolyps(detectedPolyps); %which polyps are detected
            X = LocP(idx); %to which patient the polyp is assigned
            detectedPolypSize = Polyp.Polyps(idx); %size of the detected polyp
            U = unique(X);
            for ii = 1:length(U) %goes through the patients that have detected polyps
                PolypFlag(U(ii)) = 1+any(detectedPolypSize(X == U(ii))>2); %1 - if all detected <= 2 in size
                PolypMax(U(ii)) = max(detectedPolypSize(X == U(ii)));
                counter(U(ii)) = sum(X == U(ii));
            end
            
        elseif flag.Atkin
            
            detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.RectoSigmo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
                             Location.RectoSigmoDetection(Polyp.PolypLocation(ScreenedPolyps));
            % we record the polyp
            idx = Fpolyps(detectedPolyps); %which polyps are detected
            X = LocP(idx); %to which patient the polyp is assigned
            detectedPolypSize = Polyp.Polyps(idx); %size of the detected polyp
            U = unique(X);
            for ii = 1:length(U) %goes through the patients that have detected polyps
                PolypFlag(U(ii)) = any(detectedPolypSize(X == U(ii))>2); %1 - if detected is >2 in size
                PolypMax(U(ii)) = max(detectedPolypSize(X == U(ii)));
                counter(U(ii)) = sum(X == U(ii));
            end
            
            % we delete the current polyp only in the Atkins study. outside this
            % study we would remove the polyp during colonoscopy
            deletePolyps(idx(Polyp.Polyps(idx)>2));
            
            
        elseif flag.Segnan
            
            detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.RectoSigmo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
                             Location.RectoSigmoDetection(Polyp.PolypLocation(ScreenedPolyps));
            % we record the polyp
            idx = Fpolyps(detectedPolyps); %which polyps are detected
            X = LocP(idx); %to which patient the polyp is assigned
            detectedPolypSize = Polyp.Polyps(idx); %size of the detected polyp
            small = Polyp.Polyps(idx)<=2;
            U = unique(X);
            for ii = 1:length(U) %goes through the patients that have detected polyps
                PolypFlag(U(ii)) = any(detectedPolypSize(X == U(ii) & ~small)); %1 - if detected is >2 in size
                if PolypFlag(U(ii))
                    PolypMax(U(ii)) = max(detectedPolypSize(X == U(ii) & ~small));
                end
                counter(U(ii)) = sum(X == U(ii));
            end
            
            % in this study we only delete small polyps; larger polyps are referred to colonoscopy
            deletePolyps(idx(small));
            
        else
            
            detectedPolyps = rand(nScreenedPolyps,1) < StageVariables.RectoSigmo_Detection(Polyp.Polyps(ScreenedPolyps)).*...
                             Location.RectoSigmoDetection(Polyp.PolypLocation(ScreenedPolyps));
            % we record the polyp
            idx = Fpolyps(detectedPolyps); %which polyps are detected
            X = LocP(idx); %to which patient the polyp is assigned
            detectedPolypSize = Polyp.Polyps(idx); %size of the detected polyp
            U = unique(X);
            for ii = 1:length(U) %goes through the patients that have detected polyps
                PolypFlag(U(ii)) = 1; %1 - detected
                PolypMax(U(ii)) = max(detectedPolypSize(X == U(ii)));
                counter(U(ii)) = sum(X == U(ii));
            end
            
        end
        
        AdvPolypFlag = PolypMax > 4 | counter > 2;
        
        %cancer detection
        [ScreenedCancers, LocC] = ismember(Ca.SubjectID, SelectedSubjectID);
        LocC(LocC==0) = 1; %taking care of zero indexing that would throw an error
        ScreenedCancers = ScreenedCancers & (Ca.CancerLocation >= CurrentReach(LocC));
        nScreenedCancers = sum(ScreenedCancers);
        
        Fcancers = find(ScreenedCancers);
        detectedCancers = rand(nScreenedCancers,1) < StageVariables.RectoSigmo_Detection(Ca.Cancer(ScreenedCancers));
        % we record the cancer
        idx = Fcancers(detectedCancers); %which cancers are detected
        X = LocC(idx); %to which patient the cancer is assigned
        U = unique(X);
        for ii = 1:length(U) %goes through the patients that have detected cancers
           CancerFlag(U(ii)) = 1; %1 - detected
           counter(U(ii)) = counter(U(ii)) + sum(X == U(ii));
        end
        
        Nc = (counter == 0);
        Money.Screening(currentYear, SelectedSubjectID(Nc)) = Money.Screening(currentYear, SelectedSubjectID(Nc)) + Cost.Sigmoidoscopy;
        PaymentType.RS(1,currentYear)= PaymentType.RS(1,currentYear)+sum(Nc);  %m2 assumption. RS is only done for screening. not for followup or treatment
        
        Money.Screening(currentYear, SelectedSubjectID(~Nc)) = Money.Screening(currentYear, SelectedSubjectID(~Nc)) + Cost.Sigmoidoscopy_Polyp;
        PaymentType.RSPolyp(1,currentYear)= PaymentType.RSPolyp(1,currentYear)+sum(~Nc); %m2 assumption. RS is only done for screening. not for followup or treatment

        %%%% Complications
        Rand = rand(Nrsigmo,2); %generating random numbers in advance
        perforation = Rand(:,1) < risc.Rectosigmo_Perforation;
        %add cost of perforation
        Money.Screening(currentYear, SelectedSubjectID(perforation)) = Money.Screening(currentYear, SelectedSubjectID(perforation)) + Cost.Colonoscopy_Perforation;
        PaymentType.Perforation(1,currentYear)= PaymentType.Perforation(1,currentYear) + sum(perforation);
        deathPerforation = perforation & Rand(:,2) < risc.DeathPerforation;
        if any(deathPerforation)
            DeathCause(SelectedSubjectID(deathPerforation))= 3;
            DeathYear(SelectedSubjectID(deathPerforation)) = stepCounter;

            death(ismember(SubjectIDs, SelectedSubjectID(deathPerforation)));
            % we add the costs
            AddCosts(SelectedSubjectID(deathPerforation), 'oc');
                
            % we set these flags to zero to prevent colonoscopy on a deceased
            % patient
            CancerFlag(deathPerforation) = 0;
            PolypFlag(deathPerforation) = 0;
        end
    end

    function AddCosts(IDs,mode)
        
        %logical variable indicated which of the detected cancers are to be
        %considered in adding the cost
        cancersToAccount = ismember(Detected.SubjectID, IDs);
        
        if any(cancersToAccount) %if there are cancers to be accounted for
            
            
            NcancersToAccount = sum(cancersToAccount); %how many cancers to account for
            Start = Detected.CancerYear(cancersToAccount); %time when the cancer was detected
            IDsToAccount = Detected.SubjectID(cancersToAccount); %IDs of patients
            Stage = Detected.Cancer(cancersToAccount) - 6; %stage of the cancers that will be accounted for
            
            
            for ii = 1:NcancersToAccount %go through each cancer
                
                %variable for temporary calculations
                SubCost       = zeros(1, yearsToSimulate*numPeriods);
                SubCostFut    = zeros(1, yearsToSimulate*numPeriods);
            
                %first: insert the continous costs from cancer diagnosis
                %till min(death moment, 5 years since diagnosis)
                %stepCounter is the current moment, 5*numPeriods is 5 years
                range = Start(ii):min(stepCounter, Start(ii)+5*numPeriods);
                SubCost(range) = SubCost(range) + 1/4*CostStage.Cont(Stage(ii)); % CONT;
                SubCostFut(range) = SubCostFut(range) + 1/4*CostStage.FutCont(Stage(ii)); % CONT;
               
                %define the length of the initial and terminal intervals
                %(12 months), 12 months = numPeriods
                minRange = min(numPeriods,stepCounter-Start(ii)+1); 
                
                %second: insert the initial cost (overlap with continous
                %cost will be overwritten)
                range = Start(ii):(Start(ii)+(minRange-1)); %interval from the moment of diagnosis, unitl the next 12 months
                SubCost(range) = SubCost(range) + 1/4*CostStage.Initial(Stage(ii)); % CONT;
                SubCostFut(range) = SubCostFut(range) + 1/4*CostStage.FutInitial(Stage(ii)); % CONT;
                
                
                %if the patient died within 5 years from diagnosis, there
                %will be final costs
                if stepCounter - Start(ii) <= 5*numPeriods
                    
                    if isequal(mode, 'oc') %if the patient died from other causes
                        %I take into account another variable for the last 12
                        %months, Final oc
                        range = (stepCounter-(minRange-1)):stepCounter; %last year range
                        SubCost(range) = SubCost(range) + 1/4*CostStage.Final_oc(Stage(ii)); % CONT;
                        SubCostFut(range) = SubCostFut(range) + 1/4*CostStage.Final_oc(Stage(ii)); % CONT;
                    else
                        %third: insert the final cost (overlap with continous and
                        %initial cost will be overwritten)
                        range = (stepCounter-(minRange-1)):stepCounter; %last year range
                        SubCost(range) = SubCost(range) + 1/4*CostStage.Final(Stage(ii)); % CONT;
                        SubCostFut(range) = SubCostFut(range) + 1/4*CostStage.FutFinal(Stage(ii)); % CONT;
                    end
                end
                
                Money.Treatment(:,IDsToAccount(ii)) = Money.Treatment(:,IDsToAccount(ii)) + sum(reshape(SubCost,numPeriods,[]))';
                Money.FutureTreatment(:,IDsToAccount(ii)) = Money.FutureTreatment(:,IDsToAccount(ii)) + sum(reshape(SubCostFut,numPeriods,[]))';
            end 
            
        end
    end

end


