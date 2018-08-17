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

function [RMS_output] = Auto_Calib_3_TempFunction(varargin) %, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5)

C(1) = varargin{1};
C(2) = varargin{2};
C(3) = varargin{3};

index_age=1:20;

%%% the path were this proggram is stored, this must be the CMOST path
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
CurrentPath = Path(1:pos-1);
cd (fullfile(CurrentPath, 'Temp'))
load ('Calibration_3_temp');

handles.Variables = Calibration_3_temp.Variables; %#ok<NODEF>
Calibration_3_temp.Flow.Iteration = Calibration_3_temp.Flow.Iteration + 1;

i    = Calibration_3_temp.Flow.Iteration;
RMSI = Calibration_3_temp.Flow.RMSI;

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
RMSI(i)=0;
for j=5:length(handles.Variables.Benchmarks.Cancer.Ov_y)
    if ~isequal(handles.Variables.Benchmarks.Cancer.Ov_inc(j),0)
        RMSI(i) = RMSI(i) + (1 - BM.OutputValues.Cancer_Ov(j)/handles.Variables.Benchmarks.Cancer.Ov_inc(j))^2;
    end
end
RMS_output = RMSI(i);

Calibration_3_temp.BM        = BM;
Calibration_3_temp.Variables = handles.Variables;

Calibration_3_temp.Flow.Iteration = Calibration_3_temp.Flow.Iteration;
Calibration_3_temp.Flow.RMSI      = RMSI;

cd(fullfile(CurrentPath, 'Temp'))
save('Calibration_3_temp', 'Calibration_3_temp')
