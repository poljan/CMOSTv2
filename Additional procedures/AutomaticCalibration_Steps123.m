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

function handles = AutomaticCalibration_Steps123(handles, mod)

% if the user wants we do bootstrapping
if isequal(mod, 'bootstrapping')
    handles = bootstrapping(handles);
end

% we backup the flags
DispFlagBackup       = handles.Variables.DispFlag;
ResultsFlagBackup    = handles.Variables.ResultsFlag;
ExcelFlagBackup      = handles.Variables.ExcelFlag;
VariablesBackup      = handles.Variables;
NumberPatientsBackup = handles.Variables.Number_patients;

handles.Variables.DispFlag     = 0;
handles.Variables.ResultsFlag  = 0;
handles.Variables.ExcelFlag    = 0;

handles.Variables.Number_patients = 25000;
handles = Step1_Subfunction(handles, 10, 30); %10, 30

handles.Variables.Number_patients = 50000;
handles = Step2_Subfunction(handles, 30, 60); %30, 60

handles.Variables.Number_patients = 100000;
handles = Step3_Subfunction(handles, 30, 60); % 50, 60

handles.Variables.Number_patients = 100000;
handles = Step23_Subfunction(handles, 100); % 100

% we get back the flags
handles.Variables.DispFlag        = DispFlagBackup;
handles.Variables.ResultsFlag     = ResultsFlagBackup;
handles.Variables.ExcelFlag       = ExcelFlagBackup;
handles.Variables.Number_patients = NumberPatientsBackup;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1, early adenomas       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Step1_Subfunction(handles, NumberFirstIteration, NumberSecondIteration)

RMSYPop = 0;
RMSMPop = 0;
RMSOPop = 0;
RMSE    = 0;
RMSP    = 0;
BMEarlyy      = cell(1,1);
BMPop         = cell(1,1);
BMMPop        = cell(1,1);
BMProgression = cell(1,1);
index_age=1:20;

% we get the benchmarks for adenoma prevalence
BM_Early_year = handles.Variables.Benchmarks.EarlyPolyp.Ov_y;  %#ok<NASGU>
BM_Early_perc  = handles.Variables.Benchmarks.EarlyPolyp.Ov_perc; %#ok<NASGU>

% we get the benchmarks for adenoma distribution
BM_YPop   = handles.Variables.Benchmarks.MultiplePolypsYoung;
BM_MPop   = handles.Variables.Benchmarks.MultiplePolyp;
BM_OPop   = handles.Variables.Benchmarks.MultiplePolypsOld;
BM_OvPop  = 1/3*(BM_YPop+BM_MPop+BM_OPop);

i=1;
for j=1:length(BM_MPop)
    CoeffsPop{i}(j) = 0.5*BM_MPop(6-j);
end
% transform to logarithmic scale
handles.Variables.IndividualRisk = logscale(CoeffsPop{i});

% we transform the graph described by the benchmarks into a vector of
% parameters, a sigmoid function is assumed
B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y, handles.Variables.Benchmarks.EarlyPolyp.Ov_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
CoeffsEarly{1} = B;
EEarly{20} = B;

handles = AdjustRates_Step1(handles, CoeffsEarly{i}, CoeffsPop{i}, index_age, i);

% the first iteration...
[~, BM]=CalculateSub(handles);

[BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
    CalculateRMS_Step1(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i);

B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
CoeffsEarly{i} = B;
EEarly{i}      = B;

% we save the correction factor
FemFactor(1) = handles.Variables.new_polyp_female;

% we save the start values for the adenoma progression
BMProgression{i} = handles.Variables.Progression;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1: First runs greedy algorithm     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=2:NumberFirstIteration
    
    % we adjust early polyp parameters
    B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i-1},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
    
    CoeffsEarly{i}(1) = CoeffsEarly{i-1}(1)*exp(-0.10*(EEarly{i-1}(1)-EEarly{20}(1))) * exp(-0.1*BM_OvPop(1)/BMPop{i-1}(1)) ;
    CoeffsEarly{i}(2) = CoeffsEarly{i-1}(2)-1*(EEarly{i-1}(2)-EEarly{20}(2)) ;
    CoeffsEarly{i}(3) = CoeffsEarly{i-1}(3)-0.5*(EEarly{i-1}(3)-EEarly{20}(3)) ;
    
    B(2) = CoeffsEarly{i}(2);
    B(3) = CoeffsEarly{i}(3); %#ok<NASGU>
    
    % we adjust adenoma ditribution parameters
    for j=1:5
        CoeffsPop{i}(j) = CoeffsPop{i-1}(j) * (BM_MPop(j)/BMMPop{i-1}(j))^0.5;
    end
    
    % we adjust male/ female ratios
    MaleSum = 0; FemaleSum = 0;
    for f = 1:length(handles.Variables.Benchmarks.EarlyPolyp.Male_y)
        % we check, how much the male prevalence for early adenoma remains
        % above benchmarks
        MaleSum = MaleSum + (BM.OutputValues.EarlyAdenoma_Male(f) - handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f))/...
            handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f);
    end
    for f = 1:length(handles.Variables.Benchmarks.EarlyPolyp.Female_y)
        % we check, how much the female prevalence for early adenoma remains
        % above benchmarks
        FemaleSum = FemaleSum + (BM.OutputValues.EarlyAdenoma_Female(f) - handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f))/...
            handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f);
    end
    FemaleSum = FemaleSum/length(handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f));
    MaleSum   = MaleSum/length(handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f));
    
    Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
    handles.Variables.new_polyp_female = handles.Variables.new_polyp_female * Factor;
    
    FemFactor(i) = handles.Variables.new_polyp_female;
    handles = AdjustRates_Step1(handles, CoeffsEarly{i}, CoeffsPop{i}, index_age, i);
    
    % we adjust adenoma stage ditribution parameters
    if mod(i, 2)
        for f=2:2:4
            Factor = (BM.Polyp_early(f)/BM.BM_value_early(f))^(1/3);
            handles.Variables.Progression(f-1) = handles.Variables.Progression(f-1) /Factor;
        end
    else
        for f=3:2:4
            Factor = (BM.Polyp_early(f)/BM.BM_value_early(f))^(1/3);
            handles.Variables.Progression(f-1) = handles.Variables.Progression(f-1) /Factor;
        end
    end
    BMProgression{i} = handles.Variables.Progression;
    
    % the next iteration
    [~, BM] = CalculateSub(handles);
    
    % we use subfunction to calculate the RMS
    [BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
        CalculateRMS_Step1(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i);
    
    B=nlinfit(handles.Variables.Benchmarks.EarlyPolyp.Ov_y,BMEarlyy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))))),[50 1 50]);
    EEarly{i} = B;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1: Second run Nelder-Mead Simplex algorithm     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display('Step 1, starting Nelder-Mead')
% the next step will be fminsearch
% we look for the best coefficients
% we look for the best coefficients
tmp1 = sort(RMSE);
for f=1:length(RMSE), tmp1R(f)=find(tmp1==RMSE(f), 1); end
tmp2 = sort(RMSMPop);
for f=1:length(RMSMPop), tmp2R(f)=find(tmp2==RMSMPop(f), 1); end
tmp3 = sort(RMSP);
for f=1:length(RMSP), tmp3R(f)=find(tmp3==RMSP(f), 1); end

tmp     = tmp1R + tmp2R + tmp3R;
MinAll  = find(tmp     == min(tmp(1:(i-1))), 1);

CoeffEarly_Start = CoeffsEarly{MinAll}; % sum minimum was best
CoeffPop_Start   = CoeffsPop{MinAll};
handles.Variables.new_polyp_female = FemFactor(MinAll);
handles.Variables.Progression      = BMProgression{MinAll};

% second iteration, we use Nelder-Mead simplex algorithm
options = optimset('MaxFunEvals', NumberSecondIteration);
tmpff = @(x)Auto_Calib123_1_TempFunction(x(1), x(2), x(3), x(4), x(5), x(6), x(7), x(8), handles.Variables);
[x] = fminsearch(tmpff,[CoeffEarly_Start(1), CoeffEarly_Start(2), CoeffEarly_Start(3),...
    CoeffPop_Start(1), CoeffPop_Start(2), CoeffPop_Start(3), CoeffPop_Start(4), CoeffPop_Start(5)], options);

CoeffsEarlyFinal(1:3) = x(1:3);
CoeffsPopFinal(1:5)   = x(4:8);
            
handles = AdjustRates_Step1(handles, CoeffsEarlyFinal, CoeffsPopFinal, index_age, i);
handles.Variables.new_polyp_female = FemFactor(MinAll);

% we run the calculations againd
[~, BM] = CalculateSub(handles);

% we use subfunction to calculate the RMS
[BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
    CalculateRMS_Step1(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i); %#ok<ASGLU>

handles.Variables.Calibration.RMSE    = RMSE(end);
handles.Variables.Calibration.RMSP1   = RMSP(end);
handles.Variables.Calibration.RMSMPop = RMSMPop(end);
handles.Variables.Calibration.CoeffEar  = CoeffsEarlyFinal;

display(sprintf('Calibration Step 1 finished'))  
display(sprintf('RMS early adenoma prevalence %.4f', RMSE(end)))
display(sprintf('RMS early adenoma distribution %.4f', RMSP(end)))
display(sprintf('RMS distribution multiple adenoma %.4f', RMSMPop(end)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2, advanced adenomas                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Step2_Subfunction(handles, NumberFirstIteration, NumberSecondIteration)

index_age=1:20;
AdFlag   = true; % for now we leave the ability to turn this off
DistFlag = true;

% we initialize variables for tracking RMS
RMSA = 0; % for advanced adenoma
RMSP = 0; % for adenoma distribution

EAdv = cell(1,1);
BMAdvx = cell(1,1); BMAdvy = cell(1,1); BMIncx = cell(1,1); BMIncy = cell(1,1);

i=1; % first iteration

Benchmark_AdvAd_y    = 1/5 * handles.Variables.Benchmarks.AdvPolyp.Ov_y;
Benchmark_AdvAd_perc = handles.Variables.Benchmarks.AdvPolyp.Ov_perc;

CoeffsAdv{1} = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
EAdv_Start   = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);

if AdFlag
    handles.Variables.EarlyProgressionRate = 0.04*CoeffsAdv{1}(1).*exp(-0.01*CoeffsAdv{1}(2)*( index_age - CoeffsAdv{1}(3) ).^2); %mmmm 4*
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
                handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);
end

% first run
[~, BM]=CalculateSub(handles);

% we get the RMS values
[RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS_Step2(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i, AdFlag, DistFlag);

lastwarn('')
B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
if ~isempty(lastwarn)
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
end
EAdv{i}=B;

CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.06*(EAdv{i}(1)-EAdv_Start(1)));
CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));

% we save the factors by which adjustments for females are made
FemFactorAdv(i) = handles.Variables.early_progression_female;

% we save the start vectors for adenoma progression
CoeffPStage{i}         = handles.Variables.Progression;
ProgressionCoefficient = handles.Variables.Progression(5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2: first run with educated guesses        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=2:NumberFirstIteration
    if DistFlag
        % we adjust progression rates for individual adenoma stages
        FactorP5(i) = 1; % (BM.BM_value_adv(5) / BM.Polyp_adv(5))^(1/4); %#ok<AGROW>
        handles.Variables.Progression(5)= handles.Variables.Progression(5) / FactorP5(i);
    end
    CoeffPStage{i} = handles.Variables.Progression;
    
    % adjusting rates for sdv adenoma and carcinoma is in a subroutine
    if AdFlag
        handles = AdjustRates_Step2(handles, CoeffsAdv, index_age, i, AdFlag);
    end
    
    % the next run
    [~, BM]=CalculateSub(handles);
    
    % we save the early progression rate (for debugging)  
    EarlyProgressionRate{i} = handles.Variables.EarlyProgression;
    
    % and we get the rms results
    [RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS_Step2(handles, BM, BMAdvx,...
        BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i, AdFlag, DistFlag);
    
    % the new coefficients for adenoma progression adenoma
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
    EAdv{i}=B;

    CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.19*(EAdv{i}(1)-EAdv_Start(1))); %m -0.06*  %m 0.19
    CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
    CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));
    
    if AdFlag
        % we make adjustments ADVANCED ADENOMAS for females
        MaleSum = 0; FemaleSum = 0;
        for f = 1:length(handles.Variables.Benchmarks.AdvPolyp.Male_y)
            % we check, how much the male prevalence for early adenoma remains
            % above benchmarks
            MaleSum = MaleSum + (BM.OutputValues.AdvAdenoma_Male(f) - handles.Variables.Benchmarks.AdvPolyp.Male_perc(f))/...
                handles.Variables.Benchmarks.AdvPolyp.Male_perc(f);
        end
        for f = 1:length(handles.Variables.Benchmarks.AdvPolyp.Female_y)
            % we check, how much the female prevalence for early adenoma remains
            % above benchmarks
            FemaleSum = FemaleSum + (BM.OutputValues.AdvAdenoma_Female(f) - handles.Variables.Benchmarks.AdvPolyp.Female_perc(f))/...
                handles.Variables.Benchmarks.AdvPolyp.Female_perc(f);
        end
        FemaleSum = FemaleSum/length(handles.Variables.Benchmarks.AdvPolyp.Female_perc(f));
        MaleSum   = MaleSum/length(handles.Variables.Benchmarks.AdvPolyp.Male_perc(f));
        
        Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
        handles.Variables.early_progression_female = handles.Variables.early_progression_female * Factor;
        
        FemFactorAdv(i) = handles.Variables.early_progression_female;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2 second run Nelder Mead algorithm        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display('Step 2, starting Nelder-Mead')

% we look for the best coefficients
tmp1 = sort(RMSA);
for f=1:length(RMSA), tmp1R(f)=find(tmp1==RMSA(f), 1); end
tmp2 = sort(RMSP);
for f=1:length(RMSP), tmp2R(f)=find(tmp2==RMSP(f), 1); end

tmp     = tmp1R + tmp2R;
if i>2
    MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
else
    MinAll  = find(tmp == min(tmp), 1);
end
CoeffsAdv_Final                     = CoeffsAdv{MinAll};
ProgressionCoefficient              = CoeffPStage{MinAll}(5);
display(sprintf('using calculations from run %.1f', MinAll))
display(sprintf('starting coefficients %.4f %.4f %.4f', CoeffsAdv_Final(1), CoeffsAdv_Final(2), CoeffsAdv_Final(3)))

if AdFlag
    handles.Variables.early_progression_female    = FemFactorAdv(MinAll);
end
if DistFlag
    handles.Variables.Progression = CoeffPStage{MinAll};
end

if and(AdFlag, DistFlag)
    Mod = 'Both';
elseif isequal(AdFlag, true)
    Mod = 'Ad';
elseif isequal(DistFlag, true)
    Mod = 'Dist';
end

% for the second optimization we use the fminsearch function
options = optimset('MaxFunEvals', NumberSecondIteration);
if and(AdFlag, DistFlag) % we optimize adv. adenoma
    tmpff = @(x)Auto_Calib123_2_TempFunction(x(1), x(2), x(3), x(4), handles.Variables, Mod);
    [output] = fminsearch(tmpff,[CoeffsAdv_Final(1), CoeffsAdv_Final(2), CoeffsAdv_Final(3), ...
        ProgressionCoefficient], options);
elseif isequal(AdFlag, true) % we optimize adv adenoma
    tmpff = @(x)Auto_Calib123_2_TempFunction(x(1), x(2), handles.Variables, Mod);
    [output] = fminsearch(tmpff, [CoeffsAdv_Final(1), CoeffsAdv_Final(2), CoeffsAdv_Final(3)], options); %,...
elseif isequal(DistFlag, true)
    tmpff = @(x)Auto_Calib123_2_TempFunction(x(1), handles.Variables, Mod);
    [output] = fminsearch(tmpff, ProgressionCoefficient, options);
end

if and(AdFlag, DistFlag)
    CoeffsAdv_Final(1:3) = output(1:3);
    ProgressionCoefficient = output(4);
elseif isequal(AdFlag, true)
    CoeffsAdv_Final(1:3) = output(1:3);
elseif isequal(DistFlag, true)
    ProgressionCoefficient = output(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step2 final run optimized parameters           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear tmp1
tmp1{1} = CoeffsAdv_Final;
if AdFlag
    handles = AdjustRates_Step2(handles, tmp1, index_age, 1, AdFlag);
    handles.Variables.early_progression_female = FemFactorAdv(MinAll);
end
if DistFlag
    handles.Variables.Progression(5) = ProgressionCoefficient;
end

% we run the calculations againd
[~, BM] = CalculateSub(handles);

% we use subfunction to calculate the RMS
[RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS_Step2(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i, AdFlag, DistFlag); %#ok<ASGLU>

handles.Variables.Calibration.RMSA    = RMSA;
handles.Variables.Calibration.RMSP1   = RMSP; 
handles.Variables.Calibration.CoeffAdv  = CoeffsAdv_Final;

display(sprintf('Calibration Step 2 finished'))  
display(sprintf('RMS advanced adenoma prevalence %.4f', RMSA(end)))
display(sprintf('RMS advanced adenoma distribution %.4f', RMSP(end)))
display(sprintf('final coefficients %.4f %.4f %.4f', CoeffsAdv_Final(1), CoeffsAdv_Final(2), CoeffsAdv_Final(3)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3: Carcinoma       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Step3_Subfunction(handles, NumberFirstIteration, NumberSecondIteration)

CaFlag                = true;
AdjFractionRectumFlag = true;
RelDangerFlag         = true;
RMSI=100; RMSD=0; RMSR=0;
index_age=1:20;

IterationCounter = 0;
handles.Variables.Number_patients = 50000;
while min(RMSI) >5 % here we keep trying until a good initial guess is reached
    IterationCounter = IterationCounter +1;
    EAdv = cell(1,1);
    BMAdvx = cell(1,1); BMAdvy = cell(1,1); BMIncx = cell(1,1); BMIncy = cell(1,1);
    
    i=1; % first iteration
    Benchmark_Ca_y     = 1/5 * handles.Variables.Benchmarks.Cancer.Ov_y;
    Benchmark_Ca_inc   =       handles.Variables.Benchmarks.Cancer.Ov_inc;
    
    % The ca-incidence curve is coupled to the adenoma
    % prevalence curve so we need to keep some calculations for advanced
    % adenomas
    Benchmark_AdvAd_y    = 1/5 * handles.Variables.Benchmarks.AdvPolyp.Ov_y;
    Benchmark_AdvAd_perc = handles.Variables.Benchmarks.AdvPolyp.Ov_perc;
    
    CoeffsAdv{1} = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    EAdv_Start   = nlinfit(Benchmark_AdvAd_y,Benchmark_AdvAd_perc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    
    CoeffsInc{i} = nlinfit(Benchmark_Ca_y,Benchmark_Ca_inc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    EInc_Start   = nlinfit(Benchmark_Ca_y,Benchmark_Ca_inc,@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))  ))),[10 1 10]);
    
    % first run
    [~, BM]=CalculateSub(handles);
    
    % we get the RMS values
    [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS_Step3(handles, BM,...
        BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i, CaFlag, RelDangerFlag, AdjFractionRectumFlag);
    
    % The cancer incidence calculations are coupled to the advanced adenoma curve
    lastwarn('')
    B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
    if ~isempty(lastwarn)
        B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
    end
    EAdv{i}=B;
    CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.06*(EAdv{i}(1)-EAdv_Start(1)));
    CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
    CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));
    
    lastwarn('')
    B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 1 10]);
    if ~isempty(lastwarn)
        B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(-(u*A(2)-A(3))   ))),[10 -1 -10]);
    end
    
    EInc{i}=B;
    CoeffsInc{i+1}(1) = CoeffsInc{i}(1)*exp(-0.0005*(EInc{i}(1)-EInc_Start(1)));
    CoeffsInc{i+1}(2) = CoeffsInc{i}(2)-0.1*(EInc{i}(2)-EInc_Start(2));
    CoeffsInc{i+1}(3) = CoeffsInc{i}(3)-0.5*(EInc{i}(3)-EInc_Start(3));
    
    % we save the factors by which adjustments for females are made
    FemFactorCa(i)  = handles.Variables.advanced_progression_female;
    
    % we save the start vectors for relative danger and fraction rectum
    CoeffRelDanger{i} = handles.Variables.FastCancer;
    CoeffRectum{i}    = [handles.Variables.Location_EarlyProgression(13)...
        handles.Variables.Location_AdvancedProgression(13)];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % STEP 3: first run with educated guesses        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i=2:NumberFirstIteration
        if RelDangerFlag
            % we adjust relative danger of adenoma stages
            if isequal(mod(i,2),1)
                for j=2:2:5
                    handles.Variables.FastCancer(j) = handles.Variables.FastCancer(j)*...
                        sqrt(handles.Variables.Benchmarks.Rel_Danger(j)/BM.CancerOriginValue(j));
                end
            else
                for j=1:2:5
                    handles.Variables.FastCancer(j) = handles.Variables.FastCancer(j)*...
                        sqrt(handles.Variables.Benchmarks.Rel_Danger(j)/BM.CancerOriginValue(j));
                end
            end
        end
        CoeffRelDanger{i} = handles.Variables.FastCancer;
        
        % adjusting fraction of rectum carcinoma
        if AdjFractionRectumFlag
            Factor1 = (BM.LocBenchmark(2)/ BM.LocationRectum(2))^(1/3);
            Factor2 = (BM.LocBenchmark(3)/ BM.LocationRectum(3))^(1/3);
            handles.Variables.Location_EarlyProgression(13) = ...
                handles.Variables.Location_EarlyProgression(13) * Factor1 * Factor2;
            handles.Variables.Location_AdvancedProgression(13) = ...
                handles.Variables.Location_AdvancedProgression(13) * Factor1 * Factor2;
        end
        CoeffRectum{i} = [handles.Variables.Location_EarlyProgression(13)...
            handles.Variables.Location_AdvancedProgression(13)];
        
        % adjusting rates for sdv adenoma and carcinoma is in a subroutine
        handles = AdjustRates_Step3(handles, CoeffsInc, index_age, i, CaFlag);
        
        % the next run
        [~, BM]=CalculateSub(handles);
        
        % and we get the rms results
        [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS_Step3(handles, BM,...
            BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i, CaFlag, RelDangerFlag, AdjFractionRectumFlag);
        
        % the new coefficients for adenoma progression adenoma
        B=nlinfit(BMAdvx{i},BMAdvy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
        EAdv{i}=B;
        
        CoeffsAdv{i+1}(1) = CoeffsAdv{i}(1)*exp(-0.19*(EAdv{i}(1)-EAdv_Start(1))); %m -0.06*  %m 0.19
        CoeffsAdv{i+1}(2) = CoeffsAdv{i}(2)-0.1*(EAdv{i}(2)-EAdv_Start(2));
        CoeffsAdv{i+1}(3) = CoeffsAdv{i}(3)+0.1*(EAdv{i}(3)-EAdv_Start(3));
        
        % the new coefficients for advanced adenoma progression adenoma/
        % carcinoma incidence
        B=nlinfit(BMIncx{i},BMIncy{i},@(A, u)(A(1)./(1 + exp(- (u*A(2)-A(3)) ))),[10 1 10]);
        EInc{i}=B;
        
        CoeffsInc{i+1}(1) = CoeffsInc{i}(1)*exp(-0.002*2*EAdv_Start(1)/EAdv{i}(1)*(EInc{i}(1)-EInc_Start(1))); % coupled  %0.002*2
        CoeffsInc{i+1}(2) = CoeffsInc{i}(2)-0.1*(EInc{i}(2)-EInc_Start(2));
        CoeffsInc{i+1}(3) = CoeffsInc{i}(3)-0.5*(EInc{i}(3)-EInc_Start(3));
        
        if CaFlag
            % we make adjustments CARCINOMAS for females
            MaleSum = 0; FemaleSum = 0;
            for f = 9:15 % 5:length(handles.Variables.Benchmarks.Cancer.Male_y)
                % we check, how much the male prevalence for early adenoma remains
                % above benchmarks
                MaleSum = MaleSum + (BM.OutputValues.Cancer_Male(f) - handles.Variables.Benchmarks.Cancer.Male_inc(f))/...
                    handles.Variables.Benchmarks.Cancer.Male_inc(f);
            end
            for f = 9:15 % 5:length(handles.Variables.Benchmarks.Cancer.Female_y)
                % we check, how much the female prevalence for early adenoma remains
                % above benchmarks
                FemaleSum = FemaleSum + (BM.OutputValues.Cancer_Female(f) - handles.Variables.Benchmarks.Cancer.Female_inc(f))/...
                    handles.Variables.Benchmarks.Cancer.Female_inc(f);
            end
            FemaleSum = FemaleSum/(length(handles.Variables.Benchmarks.Cancer.Female_inc(9:15)));
            MaleSum   = MaleSum/  (length(handles.Variables.Benchmarks.Cancer.Male_inc  (9:15)));
            
            Factor = ((100-(FemaleSum - MaleSum))/100)^0.5; % correction factor
            handles.Variables.advanced_progression_female = handles.Variables.advanced_progression_female * Factor;
            FemFactorCa(i) = handles.Variables.advanced_progression_female;
        end
    end
    if min(RMSI) > 5
        display(sprintf('RMSI too high; iteration %d,another iteration', IterationCounter))
    end
end
handles.Variables.Number_patients = 100000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3: second run Nelder Mead algorithm       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

display('Step 3, starting Nelder-Mead')
% the next step will be fminsearch
% we look for the best coefficients

% we look for the best coefficients
tmp1 = sort(RMSI);
for f=1:length(RMSI), tmp1R(f)=find(tmp1==RMSI(f), 1); end
tmp2 = sort(RMSD);
for f=1:length(RMSD), tmp2R(f)=find(tmp2==RMSD(f), 1); end
tmp3 = sort(RMSR);
for f=1:length(RMSR), tmp3R(f)=find(tmp3==RMSR(f), 1); end

tmp     = tmp1R + tmp2R + tmp3R;
if i>2
    MinAll  = find(tmp == min(tmp(2:(i-1))), 1);
else
    MinAll  = find(tmp == min(tmp), 1);
end

CoeffsInc_Final                     = CoeffsInc{MinAll};
CoeffRelDanger_Final                = CoeffRelDanger{MinAll}; %#ok<NASGU>

if CaFlag
    handles.Variables.advanced_progression_female = FemFactorCa(MinAll);
end
if RelDangerFlag
    handles.Variables.FastCancer = CoeffRelDanger{MinAll};
end
if AdjFractionRectumFlag
    handles.Variables.Location_EarlyProgression(13)    = CoeffRectum{MinAll}(1);
    handles.Variables.Location_AdvancedProgression(13) = CoeffRectum{MinAll}(2);
end

% for the second optimization we use the misearch function
options = optimset('MaxFunEvals', NumberSecondIteration);
if CaFlag % we optimize carcinoma
    tmpff = @(x)Auto_Calib123_3_TempFunction(x(1), x(2), x(3), handles.Variables);
    [output] = fminsearch(tmpff,[CoeffsInc_Final(1), CoeffsInc_Final(2), CoeffsInc_Final(3)], options); %,...
    CoeffsInc_Final(1:3) = output(1:3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3 final run optimized parameters          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear tmp2
tmp2{1} = CoeffsInc_Final;
if CaFlag
    handles = AdjustRates_Step3(handles, tmp2, index_age, 1, CaFlag);
    handles.Variables.advanced_progression_female = FemFactorCa(MinAll);
end
handles.Variables.Calibration.CoeffsInc = CoeffsInc_Final;

% we run the calculations againd
[~, BM] = CalculateSub(handles);

% we use subfunction to calculate the RMS
[RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS_Step3(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i, CaFlag, RelDangerFlag, AdjFractionRectumFlag); %#ok<ASGLU>

% we let the user know
handles.Variables.Calibration.RMSI = RMSI(end);
handles.Variables.Calibration.RMSD = RMSD(end);
handles.Variables.Calibration.RMSR = RMSR(end);

display(sprintf('Calibration Step 3 finished'))  
display(sprintf('RMS carcinoma incidence %.4f', RMSI(end)))
display(sprintf('RMS danger adenoma %.4f', RMSD(end)))
display(sprintf('RMS rectum cancer %.4f', RMSR(end)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADJUST RATES                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% ADJUST RATES, STEP 1 %%%%%
function handles = AdjustRates_Step1(handles, CoeffsEarly, CoeffsPop, index_age, i)
if isequal(i, 1)
    handles.Variables.NewPolypRate  = 0.1*0.90*0.07/50*exp(-0.0*...
        (handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(end)))*...
        CoeffsEarly(1)./(1 + exp(-((index_age*5*CoeffsEarly(2))-14*CoeffsEarly(2)-CoeffsEarly(3))));
else
    handles.Variables.NewPolypRate = 0.3*0.90*0.07/50*exp(-0.0*...
        (handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(end)))*...
        CoeffsEarly(1)./(1 + exp(-((index_age*5*CoeffsEarly(2))-14*CoeffsEarly(2)-CoeffsEarly(3))));
end
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.NewPolyp(counter) = (handles.Variables.NewPolypRate(x1) * (5-x2) + ...
            handles.Variables.NewPolypRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.NewPolyp(counter : 150) = handles.Variables.NewPolypRate(end);

handles.Variables.IndividualRisk = logscale(CoeffsPop);
handles.Variables.IndividualRisk = sort(handles.Variables.IndividualRisk);

if isequal(i, 1)
    handles.Variables.IndividualRisk = 25*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(450));
else
    handles.Variables.IndividualRisk = 5*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(480));
end

%%%% ADJUST RATES, STEP 2 %%%%%
function handles = AdjustRates_Step2(handles, CoeffsAdv, index_age, i, AdFlag)
if AdFlag
    % we adjust the early adenoma progression rates
    handles.Variables.EarlyProgressionRate = 1.5*0.04*CoeffsAdv{i}(1).*exp(-0.01*CoeffsAdv{i}(2)*( index_age - CoeffsAdv{i}(3) ).^2);
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
                handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);
end

%%%% ADJUST RATES, STEP 3 %%%%%
function handles = AdjustRates_Step3(handles, CoeffsInc, index_age, i, CaFlag)
if CaFlag
    % we adjust advanced adenoma progression rates
    handles.Variables.AdvancedProgressionRate = 8*5.1/6.5*0.3e-4*CoeffsInc{i}(1).*exp(-0.01*CoeffsInc{i}(2)*( index_age - CoeffsInc{i}(3) ).^2);
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
                handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE RMS                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% CALCULATE RMS, STEP 1 %%%%%
function [BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP] =...
    CalculateRMS_Step1(BM, handles, RMSE, RMSYPop, RMSMPop, RMSOPop, BMEarlyy, BM_YPop, BM_MPop, BM_OPop, BMPop, BMMPop, RMSP, i)

BMEarlyy{i} = BM.OutputValues.EarlyAdenoma_Ov;
BMMPop{i} = BM.OutputValues.MidPop;

for f=1:length(BM.OutputValues.EarlyAdenoma_Ov)
    Ear.BM{f} = BM.OutputValues.EarlyAdenoma_Ov(f);
end

BMMPop{i} = BM.OutputValues.MidPop; %?????
for j=1:(length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y))
    BMEarlyy{i}(j) = Ear.BM{j}; %mod BM
end

RMSE(i) = 0;
for j=1:length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y)
    RMSE(i) = RMSE(i) +(1 - BMEarlyy{i}(j)/handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(j))^2;
end

BMPop{i}  = 1/3*(BM.OutputValues.YoungPop+BM.OutputValues.MidPop+BM.OutputValues.OldPop);

RMSYPop(i)=0; RMSMPop(i)=0; RMSOPop(i)=0;
for j=1:length(BM.OutputValues.YoungPop)
    if ~isequal(BM_YPop(j),0)
        RMSYPop(i) = RMSYPop(i) + (1 - BM.OutputValues.YoungPop(j)/BM_YPop(j))^2;
        RMSMPop(i) = RMSMPop(i) + (1 - BM.OutputValues.MidPop(j)/BM_MPop(j))^2;
        RMSOPop(i) = RMSOPop(i) + (1 - BM.OutputValues.OldPop(j)/BM_OPop(j))^2;
    end
end

RMSP(i) = 0;
for f=1:4
    RMSP(i) = ((BM.Polyp_early(f) - BM.BM_value_early(f))/BM.Polyp_early(f))^2;
end

%%%% CALCULATE RMS, STEP 2 %%%%%
function [RMSA, RMSP, BMAdvx, BMAdvy] = CalculateRMS_Step2(handles, BM, BMAdvx,...
    BMAdvy, Benchmark_AdvAd_perc, RMSA, RMSP, i, AdFlag, DistFlag)

% RMS for advanced adenoma
BMAdvx{i}   = 1/5*handles.Variables.Benchmarks.AdvPolyp.Ov_y; %corr BM
BMAdvy{i}   = BM.OutputValues.AdvAdenoma_Ov;
if AdFlag
    RMStemp=0;
    for j=1:length(BMAdvx{1})
        RMStemp = RMStemp +(1 - BMAdvy{i}(j)/Benchmark_AdvAd_perc(j))^2;
    end
    RMSA(i) = RMStemp;
end

if DistFlag
    % RMS for advanced adenoma distribution
    RMSP(i) = 0;
    for f=5:6
        RMSP(i) = RMSP(i) + ((BM.Polyp_adv(f) - BM.BM_value_adv(f))/BM.BM_value_adv(f))^2;
    end
end

%%%% CALCULATE RMS, STEP 3 %%%%%
function [RMSI, RMSD, RMSR, BMAdvx, BMAdvy, BMIncx, BMIncy] = CalculateRMS_Step3(handles, BM,...
    BMAdvx, BMAdvy, BMIncx, BMIncy, Benchmark_Ca_inc, RMSI, RMSD, RMSR, i, CaFlag, RelDangerFlag, AdjFractionRectumFlag)

% RMS for advanced adenoma
BMAdvx{i}   = 1/5*handles.Variables.Benchmarks.AdvPolyp.Ov_y; %corr BM
BMAdvy{i}   = BM.OutputValues.AdvAdenoma_Ov;

% RMS for carcinoma
BMIncx{i}   = 1/5*handles.Variables.Benchmarks.Cancer.Ov_y; %corr BM
BMIncy{i}   = BM.OutputValues.Cancer_Ov;
if CaFlag
    RMStemp=0;
    for j=5:length(BMIncx{1})
        if ~isequal(Benchmark_Ca_inc(j),0)
            RMStemp = RMStemp + (1 - BMIncy{i}(j)/Benchmark_Ca_inc(j))^2;
        end
    end
    RMSI(i) = RMStemp;
end

if RelDangerFlag
    % RMS for relative danger
    RMSD(i) = 0;
    for f=1:5
        RMSD(i) = RMSD(i) + (1 - BM.CancerOriginValue(f)/handles.Variables.Benchmarks.Rel_Danger(f))^2;
    end
end
if AdjFractionRectumFlag
    RMSR(i) = 0;
    for f=2:3
        RMSR(i) = RMSR(i) + ((BM.LocationRectum(f) - BM.LocBenchmark(f))/ BM.LocBenchmark(f))^2;
    end
end

function uy = logscale(Coeff)%,BMref,BMout)
ur = zeros(1,500);
Coeff = sort(Coeff); % new
for j=1:5
    %m    CoeffsPop{i}(j) = 0.5*BMPop{50}(6-j);
    %ur0(j)  = 1/(6-j)*CoeffsPop{i}(j);
    ur0(j*100)  = Coeff(j);
    %ur(j*100) = 0.5*BMPop{50}(6-j);
end

for j=1:100
    ur(0  +j) = ur0(100)*j/100;
end
for j=101:430
    ur(j) = ur0(100) + (ur0(200)-ur0(100))*(j-100)/330;
end
for j=431:470
    ur(j) = ur0(200) + (ur0(300)-ur0(200))*(j-430)/40;
end
for j=471:496
    ur(j) = ur0(300) + (ur0(400)-ur0(300))*(j-470)/25;
end
for j=496:500
    ur(j) = ur0(400) + (ur0(500)-ur0(400))*(j-495)/5;
end

u1 = 1:1:500;

u2 = 500/6.21416*log(u1); %new

for i=1:21
    ux(i) = 500*(i-1)/(21-1); %#ok<*AGROW>
    tmp = abs(u2-ux(i));
    [idx, idx] = min(tmp);  %#ok<ASGLU>
    ux2(i) = u2(idx);
    uy2(i) = ur(idx); %new
end

for i=1:20
    for j=1:25
        ux3((i-1)*25+j) =  ux2(i) + (ux2(i+1)-ux2(i)) * (j/25); %#ok<NASGU>
        uy3((i-1)*25+j) =  uy2(i) + (uy2(i+1)-uy2(i)) * (j/25);
    end
end

uy = uy3;

%%%%%%%%%%%%%%%%%%%%%%
% Temp_Functions     %
%%%%%%%%%%%%%%%%%%%%%%

%%%% STEP 1 %%%%%
function [RMS_output] = Auto_Calib123_1_TempFunction(B1, B2, B3, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5, Variables)
% function [RMS_output] = Auto_Calib123_1_TempFunction(Varargin)

B(1) = B1;
B(2) = B2;
B(3) = B3;
Coeff(1) = Coeff1;
Coeff(2) = Coeff2;
Coeff(3) = Coeff3;
Coeff(4) = Coeff4;
Coeff(5) = Coeff5;

index_age=1:20;

%%% we load the variables
% load(fullfile(PathName, FileName))
% handles.Variables = Calibration_1_temp.Variables;
handles.Variables = Variables;

% we adjust the polyp rate according to the sigmoid function
handles.Variables.NewPolypRate = 0.3*0.90*0.07/50*exp(-0.0*...
        (handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(end)))*...
        B(1)./(1 + exp(-((index_age*5*B(2))-14*B(2)-B(3))));
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.NewPolyp(counter) = (handles.Variables.NewPolypRate(x1) * (5-x2) + ...
            handles.Variables.NewPolypRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.NewPolyp(counter : 150) = handles.Variables.NewPolyp(counter - 1);

% we adjust the individual risk according to the coefficients
handles.Variables.IndividualRisk = logscale(Coeff);
handles.Variables.IndividualRisk = sort(handles.Variables.IndividualRisk);
handles.Variables.IndividualRisk = 5*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(480));

% the first run...
[~, BM]=CalculateSub(handles);

BMEarlyy = BM.OutputValues.EarlyAdenoma_Ov;

% we calculate RMS for early adenomas
RMSE = 0;
for j=1:length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y)
    RMSE = RMSE + (1 - BMEarlyy(j)/handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(j))^2;
end

% we get the benchmarks for adenoma distribution
BM_MPop   = handles.Variables.Benchmarks.MultiplePolyp;

% we calculate RMS for population
RMSMPop=0; 
for j=1:length(BM.OutputValues.YoungPop)
    if ~isequal(BM_MPop(j),0)
        RMSMPop = RMSMPop + (1 - BM.OutputValues.MidPop(j)/BM_MPop(j))^2;
    end
end  

% this value is passed back
RMS_output = RMSE + RMSMPop;

%%%% STEP 2 %%%%%
function [RMS_output] = Auto_Calib123_2_TempFunction(varargin) %, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5)

if isequal(length(varargin), 3)
    P                 = varargin{1};
    handles.Variables = varargin{2};
    Mod               = varargin{3};
elseif isequal(length(varargin), 5)
    B(1)              = varargin{1};
    B(2)              = varargin{2};
    B(3)              = varargin{3};
    handles.Variables = varargin{4};
    Mod               = varargin{5};
elseif isequal(length(varargin), 6)
    B(1)              = varargin{1};
    B(2)              = varargin{2};
    B(3)              = varargin{3};
    P                 = varargin{4};
    handles.Variables = varargin{5};
    Mod = varargin{6};
end
index_age=1:20;

if or(isequal(Mod, 'Ad'), isequal(Mod, 'Both'))
    % we adjust the early adenoma progression rate according to the sigmoid function
    handles.Variables.EarlyProgressionRate = 1.5*0.04*B(1).*exp(-0.01*B(2)*( index_age - B(3) ).^2);
    counter = 1;
    for x1=1:19
        for x2=1:5
            handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
                handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
            counter = counter + 1;
        end
    end
    handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);
end

if or(isequal(Mod, 'Dist'), isequal(Mod, 'Both'))
    handles.Variables.Progression(5) = P;
end
    
% the next run...
[~, BM]=CalculateSub(handles);

BMAdvy = BM.OutputValues.AdvAdenoma_Ov;

if or(isequal(Mod, 'Ad'), isequal(Mod, 'Both'))
    % we calculate RMS for advanced adenomas
    RMSA = 0;
    for j=1:length(handles.Variables.Benchmarks.AdvPolyp.Ov_y)
        RMSA = RMSA + (1 - BMAdvy(j)/handles.Variables.Benchmarks.AdvPolyp.Ov_perc(j))^2;
    end
    RMS_output = RMSA; % this value is passed back
else
    RMS_output = 0;
end

if or(isequal(Mod, 'Dist'), isequal(Mod, 'Both'))
    RMSP = 0;
    for f=5:6
        RMSP = RMSP + ((BM.Polyp_adv(f) - BM.BM_value_adv(f))/BM.BM_value_adv(f))^2;
    end
    RMS_output = RMS_output + RMSP;
end

%%%% STEP 3 %%%%%
function [RMS_output] = Auto_Calib123_3_TempFunction(varargin) %, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5)

C(1)              = varargin{1};
C(2)              = varargin{2};
C(3)              = varargin{3};
handles.Variables = varargin{4};
index_age=1:20;

% we adjust advanced adenoma progression rates
handles.Variables.AdvancedProgressionRate = 8*5.1/6.5*0.3e-4*C(1).*exp(-0.01*C(2)*( index_age - C(3) ).^2);
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
            handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);
    
% the next run...
[~, BM]=CalculateSub(handles);

% we calculate RMS for carcinoma incidence
RMSI=0;
for j=5:length(handles.Variables.Benchmarks.Cancer.Ov_y)
    if ~isequal(handles.Variables.Benchmarks.Cancer.Ov_inc(j),0)
        RMSI = RMSI + (1 - BM.OutputValues.Cancer_Ov(j)/handles.Variables.Benchmarks.Cancer.Ov_inc(j))^2;
    end
end
RMS_output = RMSI;

function handles = bootstrapping(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% STEP 1: bootstrapping early adenoma %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Early adenoma prevalence
% we assume 50% male/ female.
% within the age group 20-29: 144 cases
cases = [144 334 523 558 652 80];
Benchmark_ov     = zeros(size(cases));
Benchmark_male   = zeros(size(cases));
Benchmark_female = zeros(size(cases));

for f=1:length(cases)
    clear tmp_ov
    tmp_ov   = zeros(cases(f), 1);
    PosCases = round(handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(f) * cases(f)/100);
    tmp_ov(1:PosCases) = 1;
    
    tmp_male = zeros(round(cases(f)/2), 1);
    PosCases = round(handles.Variables.Benchmarks.EarlyPolyp.Male_perc(f) * cases(f)/2/100);
    tmp_male(1:PosCases) = 1;
    
    tmp_female = zeros(round(cases(f)/2), 1);
    PosCases = round(handles.Variables.Benchmarks.EarlyPolyp.Female_perc(f) * cases(f)/2/100);
    tmp_female(1:PosCases) = 1;
    
    for g=1:cases(f)
        Benchmark_ov(f) = Benchmark_ov(f) + tmp_ov(round(rand*(cases(f)-1)+1));
    end
    
    for g=1:round(cases(f)/2)
        Benchmark_male(f) = Benchmark_male(f) + tmp_male(round(rand*(round(cases(f)/2)-1)+1));
    end
    
    for g=1:round(cases(f)/2)
        Benchmark_female(f) = Benchmark_female(f) + tmp_female(round(rand*(round(cases(f)/2)-1)+1));
    end
end
Benchmark_ov     = Benchmark_ov./cases *100;
Benchmark_male   = Benchmark_male./round(cases/2)*100;
Benchmark_female = Benchmark_female./round(cases/2)*100;

handles.Variables.Benchmarks.EarlyPolyp.Ov_perc       = Benchmark_ov;
handles.Variables.Benchmarks.EarlyPolyp.Male_perc     = Benchmark_male;
handles.Variables.Benchmarks.EarlyPolyp.Female_perc   = Benchmark_female;

clear Benchmark_ov Benchmark_male Benchmark_female cases tmp_ov tmp_male tmp_female PosCases

% multiple adenoma distribution
AllCases = 177; tmp_ov1 = [];
for f=1:length(handles.Variables.Benchmarks.MultiplePolyp) % [36 16 5 4 3];
    PosCases = round(AllCases * handles.Variables.Benchmarks.MultiplePolyp(f)/100);
    tmp_ov1 = cat(1, (ones(PosCases, 1)*f), tmp_ov1);
end
tmp_ov2 = zeros(AllCases, 1);
tmp_ov2(1:length(tmp_ov1)) = tmp_ov1;

for f=1:AllCases
    CasePos = round(rand*(AllCases-1)+1);
    Benchmark_ov(f) = tmp_ov2(CasePos);
end
for f=1:length(handles.Variables.Benchmarks.MultiplePolyp)
    Benchmark_MultiplePolyp(f) = round(length(find(Benchmark_ov==f))/AllCases*100);
end
handles.Variables.Benchmarks.MultiplePolyp = Benchmark_MultiplePolyp;
clear AllCases tmp_ov1  tmp_ov2 CasePos Benchmark_ov Benchmark_MultiplePolyp

% adenoma stage distribution
% AllEarlyPolyps    = [213  165  12 8  48]; % benchmark multiplied by 554 polyps in pickhard
AllEarlyPolyps    = round(handles.Variables.Benchmarks.Polyp_Distr(1:4)/sum(handles.Variables.Benchmarks.Polyp_Distr(1:4))*554);

% AllAdvancedPolyps = [124 31]; % Odom et al, 2005
AllAdvancedPolyps = round(handles.Variables.Benchmarks.Polyp_Distr(5:6)/sum(handles.Variables.Benchmarks.Polyp_Distr(5:6))*155);

tmp_ov1 = []; tmp_ov2 = [];
for f=1:4
    tmp_ov1 = cat(1, (ones(AllEarlyPolyps(f), 1)*f), tmp_ov1);
end
AllEarlyCases = sum(AllEarlyPolyps);
for f=1:round(AllEarlyCases)
    tmp_early(f) = tmp_ov1(round(rand*(AllEarlyCases-1)+1));
end
for f=5:6
    tmp_ov2 = cat(1, (ones(AllAdvancedPolyps(f-4), 1)*f), tmp_ov2);
end
AllAdvancedCases = sum(AllAdvancedPolyps);
for f=1:round(AllAdvancedCases)
    tmp_advanced(f) = tmp_ov2(round(rand*(AllAdvancedCases-1)+1));
end
for f=1:4
    Benchmark_ov(f) = sum(length(find(tmp_early == f)));
end
for f=5:6
    Benchmark_ov(f) = sum(length(find(tmp_advanced == f)));
end
handles.Variables.Benchmarks.Polyp_Distr = Benchmark_ov;
clear AllEarlyPolyps AllAdvancedPolyps tmp_ov1 tmp_ov2 AllEarlyCases AllAdvancedCases Benchmark_ov tmp_early 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% STEP 2: bootstrapping advanced adenoma %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% advanced adenoma prevalence
% data by Brenner et al., Gut 2007 56:1558.
% 55-59: female 112399; male: 66330
% 60-64: female 160880; male: 97411
% 70-74: female 55582; male: 47018;
% 80+ 9492; 6683

CasesMale   = [66330 110597 97411 47018 21220 6673];
AdvAdMale   = [4130  8321   8217  4336  2051  632];
CasesFemale = [112399 160880 125133 55582 27414 9492];
AdvAdFemale = [3866  6773   6005  3219  1785  691];

for f=1:length(CasesMale)
    tmp_male{f} = zeros(CasesMale(f), 1);
    tmp_male{f}(1:AdvAdMale(f)) = 1;
    
    tmp_female{f} = zeros(CasesFemale(f), 1);
    tmp_female{f}(1:AdvAdFemale(f)) = 1;
    
    tmp2_male(f) = 0;
    for g=1:length(tmp_male{f})
        tmp2_male(f) = tmp2_male(f) + tmp_male{f}(round(rand*(CasesMale(f)-1)+1)); 
    end
    
    tmp2_female(f) = 0;
    for g=1:length(tmp_female{f})
        tmp2_female(f) = tmp2_female(f) + tmp_female{f}(round(rand*(CasesFemale(f)-1)+1)); 
    end
end
benchmark_male   = tmp2_male./ CasesMale*100;
benchmark_female = tmp2_female./ CasesFemale*100;

% handles.Variables.Benchmarks.AdvPolyp.Ov_perc       = [4.8 5.85 6.6 7.5 8.1 8.4];
handles.Variables.Benchmarks.AdvPolyp.Ov_perc       = (benchmark_male + benchmark_female)/2;
% handles.Variables.Benchmarks.AdvPolyp.Male_perc     = [6.2 7.5 8.4 9.2 9.7 9.5];
handles.Variables.Benchmarks.AdvPolyp.Male_perc     = benchmark_male;
% handles.Variables.Benchmarks.AdvPolyp.Female_perc   = [3.4 4.2 4.8 5.8 6.5 7.3];
handles.Variables.Benchmarks.AdvPolyp.Female_perc   = benchmark_female;

clear benchmark_male benchmark_female CasesMale CasesFemale tmp_male tmp_female tmp2_male tmp2_female AdvAdMale AdvAdFemale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% STEP 3: bootstrapping carcinoma        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% relative danger adenoma
% according to the Odom study
% P1: 1/2851
% P2: 1/2851
% P3 and P4: 1/152  
% P5: 3/124 
% P6: 6/31  
% handles.Variables.Benchmarks.Rel_Danger = [0.07    0.07    0.42    0.42   13.2  85.8];
benchmark_ov(1) = handles.Variables.Benchmarks.Rel_Danger(1);
Cases    = [7232 7232 818 818 1868 1543];
PosCases = [3    3    2   2   145   776];

for f=1:6
    tmp = zeros(Cases(f), 1);
    tmp(1:PosCases(f)) = 1;
    benchmark_ov(f) = 0;
    for g=1:Cases(f)
        benchmark_ov(f) = benchmark_ov(f) + tmp(round(rand*(Cases(f)-1)+1));
    end
end
benchmark_ov    = benchmark_ov./Cases;
benchmark_ov    = benchmark_ov/sum(benchmark_ov)*100;
benchmark_ov(1) = benchmark_ov(2); % these rely on a single set of data
benchmark_ov(3) = benchmark_ov(4); % these rely on a single set of data
handles.Variables.Benchmarks.Rel_Danger = benchmark_ov;
clear benchmark_ov Cases PosCases tmp 

%%% SEER %%%%
SEER_Patients = 86355485;
%                     1.5y   7.5   12     17   22    27     32    37   42    47    52    57    62    67    72    77     82   85+
StandardPopulation = [55317 72533 73032 72169 66478 64529 71044 80762 81851 72118 62716 48454 38793 34264 31773 26999 17842 15508];
% number of patients per age group, found on webpage from SEER database

SEER_Population        = StandardPopulation * SEER_Patients / 1000000;
Gender_SEER_Population = round(SEER_Population/2);

% handles.Variables.Benchmarks.Cancer.Ov_y        = [1.5  5.5     12      17      22      27      32      37      42      47      52      57      62      67      72      77      82     87];
% Cancer_Ov_inc        = [0    0       0       0.3     0.9     2.1     4.5     8.4     16.6   29.3     57.2    76.1    107.3   160.9   209.2   262.5   313.4  343.4];
% Cancer_Male_inc      = [0    0       0       0.3     0.9     2.1     4.5     8.7     17.1    32.2    64      90      129.5   194.7   252.8   308.3   362.7  395.4];
% Cancer_Female_inc    = [0    0       0       0.3     0.9     2       4.4     8.2     16      26.4    50.6    63.1    86.9    131.3   173.6   228.5   282.2  319.5];
% 
% LocationRectumMale   = [41.2     34.1      28.6     23.8];
% LocationRectumFemale = [37.2     28.3      23.0     19.0];

Cancer_Ov_inc        = handles.Variables.Benchmarks.Cancer.Ov_inc;
Cancer_Male_inc      = handles.Variables.Benchmarks.Cancer.Male_inc;
Cancer_Female_inc    = handles.Variables.Benchmarks.Cancer.Female_inc;

LocationRectumMale   = handles.Variables.Benchmarks.Cancer.LocationRectumMale;
LocationRectumFemale = handles.Variables.Benchmarks.Cancer.LocationRectumFemale;

% LocationRectumYear   = {[51 55], [61 65], [71 75], [81 85]};  % year adapted

counter = 1;
for f= [11 13 15 17] % years in SEER database    
    Male_Cases(counter)   = round(Gender_SEER_Population(f)/100000 * Cancer_Male_inc(f));
    Female_Cases(counter) = round(Gender_SEER_Population(f)/100000 * Cancer_Female_inc(f));
       
    Male_RectumCases(counter)   = round(Male_Cases(counter) * LocationRectumMale(counter) / 100);
    Female_RectumCases(counter) = round(Female_Cases(counter) * LocationRectumFemale(counter)/100);
    
    pop_male   = zeros(Male_Cases(counter), 1);
    pop_male(1:Male_RectumCases(counter)) = 1;
    pop_female = zeros(Female_Cases(counter), 1);
    pop_female(1:Female_RectumCases(counter)) = 1;
    
    benchmark_male (counter) = 0;
    for g=1:Male_Cases(counter)
        benchmark_male(counter) = benchmark_male(counter) + pop_male(round(rand*(Male_Cases(counter)-1)+1));
    end
    benchmark_female (counter) = 0;
    for g=1:Female_Cases(counter)
        benchmark_female(counter) = benchmark_female(counter) + pop_female(round(rand*(Female_Cases(counter)-1)+1));
    end
    
    counter = counter +1;
end
benchmark_male   = benchmark_male./Male_Cases*100;
benchmark_female = benchmark_female./Female_Cases*100;

handles.Variables.Benchmarks.Cancer.LocationRectumMale   = benchmark_male;
handles.Variables.Benchmarks.Cancer.LocationRectumFemale = benchmark_female;
clear benchmark_male benchmark_female counter Male_Cases Female_Cases benchmark_male benchmark_female pop_male pop_female Male_RectumCases Female_RectumCases

% carcinoma incidence according to SEER
for f=1:length(StandardPopulation)
    display(sprintf('calculating period %d', f))
    Ov_Pop     = zeros(round(SEER_Population(f)), 1);
    Male_Pop   = zeros(round(Gender_SEER_Population(f)), 1);
    Female_Pop = zeros(round(Gender_SEER_Population(f)), 1);
    
    Ov_Cases     = round(SEER_Population(f)/100000 * Cancer_Ov_inc(f));
    Male_Cases   = round(Gender_SEER_Population(f)/100000 * Cancer_Male_inc(f));
    Female_Cases = round(Gender_SEER_Population(f)/100000 * Cancer_Female_inc(f));
    
    Ov_Pop(1:Ov_Cases) = 1;
    Male_Pop(1:Male_Cases) = 1;
    Female_Pop(1:Female_Cases) = 1;
    
    benchmark_ov(f)= 0;
    for g=1:length(Ov_Pop)
        benchmark_ov(f) = benchmark_ov(f) + Ov_Pop(round(rand * (SEER_Population(f) -1)) +1);
    end
    
    benchmark_male(f)= 0;
    for g=1:length(Male_Pop)
        benchmark_male(f) = benchmark_male(f) + Male_Pop(round(rand * (Gender_SEER_Population(f) -1)) +1);
    end
    
    benchmark_female(f)= 0;
    for g=1:length(Female_Pop)
        benchmark_female(f) = benchmark_female(f) + Female_Pop(round(rand * (Gender_SEER_Population(f) -1)) +1);
    end
end
 
benchmark_ov     = benchmark_ov ./SEER_Population *100000;
benchmark_male   = benchmark_male ./Gender_SEER_Population *100000;
benchmark_female = benchmark_female ./Gender_SEER_Population *100000;

handles.Variables.Benchmarks.Cancer.Ov_inc        = benchmark_ov;
handles.Variables.Benchmarks.Cancer.Male_inc      = benchmark_male;
handles.Variables.Benchmarks.Cancer.Female_inc    = benchmark_female;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% STEP 4: Rectosigmoidoscopy study       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

% we use Atkin et al.
ControlGroup       = 112939;
InterventionGroup  = 57099;
ControlCancer      = 1818;
InterventionCancer = 706;

ControlPop = zeros(ControlGroup, 1);
ControlPop(1:ControlCancer) = 1;
InterventionPop = zeros(InterventionGroup, 1);
InterventionPop(1:InterventionCancer) = 1;

tmp1 = 0; tmp2=0;
for g=1:ControlGroup
    tmp1 = tmp1 + ControlPop(round(rand*(ControlGroup-1)+1));
end
for g=1:InterventionGroup
    tmp2 = tmp2 + InterventionPop(round(rand*(InterventionGroup-1)+1));
end
tmp1 = tmp1/ControlGroup;
tmp2 = tmp2/InterventionGroup;
IncRed = (1-tmp2/tmp1)*100;
handles.Variables.Benchmarks.RSRCTRef.IncRedOverall = IncRed;
clear ControlGroup InterventionGroup ControlCancer InterventionCancer ControlPop InterventionPop tmp1 tmp2 IncRed

function handles = Step23_Subfunction(handles, NumberIterations)

CoeffsAdv = handles.Variables.Calibration.CoeffAdv;
CoeffsInc = handles.Variables.Calibration.CoeffsInc;

% for the second optimization we use the misearch function
options = optimset('MaxFunEvals', NumberIterations);
tmpff = @(x)Auto_Calib123_23_TempFunction(x(1), x(2), x(3), x(4), x(5), x(6), handles.Variables);
[output] = fminsearch(tmpff,[CoeffsAdv(1), CoeffsAdv(2), CoeffsAdv(3), CoeffsInc(1), CoeffsInc(2), CoeffsInc(3)], options); %,...
B(1:3) = output(1:3);
C(1:3) = output(4:6);
handles.Variables.Calibration.CoeffAdv  = B;
handles.Variables.Calibration.CoeffsInc = C;

index_age=1:20;
% we adjust the early adenoma progression rate according to the sigmoid function
handles.Variables.EarlyProgressionRate = 1.5*0.04*B(1).*exp(-0.01*B(2)*( index_age - B(3) ).^2);
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
            handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);

% we adjust advanced adenoma progression rates
handles.Variables.AdvancedProgressionRate = 8*5.1/6.5*0.3e-4*C(1).*exp(-0.01*C(2)*( index_age - C(3) ).^2);
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
            handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);

%%%% STEP 2 and 3 %%%%%
function [RMS_output] = Auto_Calib123_23_TempFunction(varargin) 
B(1)              = varargin{1};
B(2)              = varargin{2};
B(3)              = varargin{3};

C(1)              = varargin{4};
C(2)              = varargin{5};
C(3)              = varargin{6};
handles.Variables = varargin{7};

index_age=1:20;

% we adjust the early adenoma progression rate according to the sigmoid function
handles.Variables.EarlyProgressionRate = 1.5*0.04*B(1).*exp(-0.01*B(2)*( index_age - B(3) ).^2);
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.EarlyProgression(counter) = (handles.Variables.EarlyProgressionRate(x1) * (5-x2) + ...
            handles.Variables.EarlyProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.EarlyProgression(counter : 150) = handles.Variables.EarlyProgressionRate(end);

% we adjust advanced adenoma progression rates
handles.Variables.AdvancedProgressionRate = 8*5.1/6.5*0.3e-4*C(1).*exp(-0.01*C(2)*( index_age - C(3) ).^2);
counter = 1;
for x1=1:19
    for x2=1:5
        handles.Variables.AdvancedProgression(counter) = (handles.Variables.AdvancedProgressionRate(x1) * (5-x2) + ...
            handles.Variables.AdvancedProgressionRate(x1+1) * (x2-1))/4;
        counter = counter + 1;
    end
end
handles.Variables.AdvancedProgression(counter : 150) = handles.Variables.AdvancedProgressionRate(end);
    
% the next run...
[~, BM]=CalculateSub(handles);

% we calculate RMS for carcinoma incidence
RMSI=0;
for j=5:length(handles.Variables.Benchmarks.Cancer.Ov_y)
    if ~isequal(handles.Variables.Benchmarks.Cancer.Ov_inc(j),0)
        RMSI = RMSI + (1 - BM.OutputValues.Cancer_Ov(j)/handles.Variables.Benchmarks.Cancer.Ov_inc(j))^2;
    end
end

% we calculate RMS for advanced adenoma prevalence
BMAdvy = BM.OutputValues.AdvAdenoma_Ov;
RMSA = 0;
for j=1:length(handles.Variables.Benchmarks.AdvPolyp.Ov_y)
    RMSA = RMSA + (1 - BMAdvy(j)/handles.Variables.Benchmarks.AdvPolyp.Ov_perc(j))^2;
end
RMS_output = RMSA + RMSI; % this value is passed back

