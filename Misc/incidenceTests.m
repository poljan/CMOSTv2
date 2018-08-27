clear variables;

load dump.mat;

%% original calculations
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
IncidenceOld = Incidence;
%% corrected calculations
%the idea is that I remove duplicated records
clear i j SumCa SumPat Incidence;
U = unique(data.TumorRecord.PatientNumber(data.TumorRecord.PatientNumber > 0));

%length(U)
%sum(sum(data.TumorRecord.Stage > 0))
for i = 1:length(U)
    %get the year when the patient got cancer
    [row, col] = find(data.TumorRecord.PatientNumber == U(i));
    if length(row) > 1 %erase the second occurence
        for j = 2:length(row)
            data.TumorRecord.Stage(row(j),col(j)) = 0;
        end
        data.YearIncluded((row(1)+1):end,U(i)) = false; %don't include patient afterwards
    end
end

%% original calculations
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

%% plotting
figure(1)
clf
hold on
plot(IncidenceOld,'b')
plot(Incidence,'r')
hold off