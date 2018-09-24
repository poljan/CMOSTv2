clear variables;

%% load data dump to perform simulation
load dump.mat;

%DirectCancerSpeed = DirectCancerSpeed*2;
stats = readBenchmarkStatistics();

%adjusting variabels to hwo they are being used inside the NumbersCrunching
%function
Gender = uint16(Gender);

%% first I want to make sure that the random number generators are working properly
%this is old generator
% Stage 1: 5%, Stage 2: 35%, Stage 3: 40%, Stage 4: 20% - THIS IS NOT TRUE
StageProbability = [0 cumsum([150 356 279 215]/1000)];
StageRandomGenerator = griddedInterpolant(StageProbability,7:11,'previous');
%%this will be definition of new generator, new generator will take into
%%account gender and age
%I will do the same as in the case of mortality, i.e. I will update the
%random number generator each year
ageGroups = uint8([0 (19:5:85)+1]);
currentYear = uint8(100);

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
StageRandomGenerator = @(Gender, R)(uint16(floor(Fstage(Gender,R))));

%just checking if the random number generator is working properly
stage = StageRandomGenerator(double(Gender), rand(size(Gender)));
simM = histcounts(stage(Gender == 1)); simM = simM/sum(simM);
simF = histcounts(stage(Gender == 2)); simF = simF/sum(simF);

%plotting figure
figure(1)
clf
subplot(2,2,1)
pie(dataM)
title('Data male')

subplot(2,2,2)
pie(dataF)
title('Data female')

subplot(2,2,3)
pie(simM)
title('Sim male')

subplot(2,2,4)
pie(simF)
title('Sim female')






%% perform simulations
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
                    LocationMatrix, StageDuration, tx1, DirectCancerRate, DirectCancerSpeed,DwellSpeed, PBP,SurvivalNew, stats);

%% evaluate statistics for comparison
%I want to compare the incidence, mortality, stage distribution, and
%overall survival (by sex)

%first I will calculate incidence and compare it with the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Cancer Incidence All  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y = data.y;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Cancer Mortality All/ Male/ Female   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear i j
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

figure(1)
subplot(1,2,1)
hold on
plot(Incidence,'r')
plot(stats.incidence.Overall,'b')
hold off

%second will be comparizon to mortality
subplot(1,2,2)
hold on
plot(Mortality{1},'r')
plot(stats.mortality.MaleAndFemale,'b')
hold off


