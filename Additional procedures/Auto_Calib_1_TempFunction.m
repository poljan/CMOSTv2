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

function [RMS_output] = Auto_Calib_1_TempFunction(B1, B2, B3, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5)

B(1) = B1;
B(2) = B2;
B(3) = B3;
Coeff(1) = Coeff1;
Coeff(2) = Coeff2;
Coeff(3) = Coeff3;
Coeff(4) = Coeff4;
Coeff(5) = Coeff5;

index_age=1:20;

%%% the path were this proggram is stored, this must be the CMOST path
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
CurrentPath = Path(1:pos-1);
cd (fullfile(CurrentPath, 'Temp'))
load ('Calibration_1_temp');

handles.Variables = Calibration_1_temp.Variables;
i                 = Calibration_1_temp.Flow.Iteration;
RMSE              = Calibration_1_temp.BM.RMSE;
RMSMPop           = Calibration_1_temp.BM.RMSMPop;
RMSP              = Calibration_1_temp.BM.RMSP;

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


% we adjust the individual risk accordin to the coefficients
handles.Variables.IndividualRisk = logscale(Coeff);
handles.Variables.IndividualRisk = sort(handles.Variables.IndividualRisk);
handles.Variables.IndividualRisk = 5*2.84*(handles.Variables.IndividualRisk)/(handles.Variables.IndividualRisk(480));

% the first run...
[~, BM]=CalculateSub(handles);

BMEarlyy = BM.OutputValues.EarlyAdenoma_Ov;

% we calculate RMS for early adenomas
RMSE(i) = 0;
for j=1:length(handles.Variables.Benchmarks.EarlyPolyp.Ov_y)
    RMSE(i) = RMSE(i) + (1 - BMEarlyy(j)/handles.Variables.Benchmarks.EarlyPolyp.Ov_perc(j))^2;
end

% we get the benchmarks for adenoma distribution
BM_YPop   = handles.Variables.Benchmarks.MultiplePolypsYoung;
BM_MPop   = handles.Variables.Benchmarks.MultiplePolyp;
BM_OPop   = handles.Variables.Benchmarks.MultiplePolypsOld;

% we calculate RMS for population
RMSYPop(i)=0; RMSMPop(i)=0; RMSOPop(i)=0;
for j=1:length(BM.OutputValues.YoungPop)
    if ~isequal(BM_YPop(j),0)
        RMSYPop(i) = RMSYPop(i) + (1 - BM.OutputValues.YoungPop(j)/BM_YPop(j))^2;
        RMSMPop(i) = RMSMPop(i) + (1 - BM.OutputValues.MidPop(j)/BM_MPop(j))^2;
        RMSOPop(i) = RMSOPop(i) + (1 - BM.OutputValues.OldPop(j)/BM_OPop(j))^2;
    end
end  

% this value is passed back
RMS_output = RMSE(i) + RMSMPop(i);
    
BM.RMSMPop = RMSMPop;
BM.RMSE    = RMSE;
BM.RMSP    = RMSP;

Calibration_1_temp.BM        = BM;
Calibration_1_temp.Variables = handles.Variables;

Calibration_1_temp.Flow.Iteration = Calibration_1_temp.Flow.Iteration + 1;
Calibration_1_temp.Flow.RMSMPop   = RMSMPop;
Calibration_1_temp.Flow.RMSE      = RMSE;
cd(fullfile(CurrentPath, 'Temp'))
save('Calibration_1_temp', 'Calibration_1_temp')

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
ux(i) = 500*(i-1)/(21-1);
tmp = abs(u2-ux(i));
[idx idx] = min(tmp); 
ux2(i) = u2(idx);
uy2(i) = ur(idx); %new 
end

for i=1:20
    for j=1:25
     ux3((i-1)*25+j) =  ux2(i) + (ux2(i+1)-ux2(i)) * (j/25);   
     uy3((i-1)*25+j) =  uy2(i) + (uy2(i+1)-uy2(i)) * (j/25);
    end
end

uy = uy3;