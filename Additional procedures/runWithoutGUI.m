clear variables;

addpath('Core procedures')
addpath('Additional procedures')

% load default settings
load(fullfile(pwd(), 'Settings', 'CMOST13.mat')) 
handles.Variables=temp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Life Table                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% we load the saved variable
load (fullfile(pwd(),'Settings', 'LifeTable.mat'))
handles.Variables.LifeTable = LifeTable;

%define number of patients
handles.Variables.Number_patients = 250000;

%%
[handles, BM] = CalculateSub(handles);
data = handles.data;
stats = handles.stats;

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
clf
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


