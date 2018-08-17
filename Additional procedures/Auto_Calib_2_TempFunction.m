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

function [RMS_output] = Auto_Calib_2_TempFunction(varargin) %, Coeff1, Coeff2, Coeff3, Coeff4, Coeff5)

if isequal(length(varargin), 1)
    P    = varargin{1};
elseif isequal(length(varargin), 3)
    B(1) = varargin{1};
    B(2) = varargin{2};
    B(3) = varargin{3};
elseif isequal(length(varargin), 4)
    B(1) = varargin{1};
    B(2) = varargin{2};
    B(3) = varargin{3};
    P    = varargin{4};
end
index_age=1:20;

%%% the path were this proggram is stored, this must be the CMOST path
Path = mfilename('fullpath');
pos = regexp(Path, [mfilename, '$']);
CurrentPath = Path(1:pos-1);
cd (fullfile(CurrentPath, 'Temp'))
load ('Calibration_2_temp');

handles.Variables = Calibration_2_temp.Variables; %#ok<NODEF>
Calibration_2_temp.Flow.Iteration = Calibration_2_temp.Flow.Iteration + 1;

i    = Calibration_2_temp.Flow.Iteration;
RMSA = Calibration_2_temp.Flow.RMSA;
RMSP = Calibration_2_temp.Flow.RMSP;

if and(Calibration_2_temp.Flow.AdFlag, Calibration_2_temp.Flow.DistFlag)
    Mod = 'Both';
elseif Calibration_2_temp.Flow.AdFlag
    Mod = 'Ad';
elseif Calibration_2_temp.Flow.DistFlag
    Mod = 'Dist';
end

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
    RMSA(i) = 0;
    for j=1:length(handles.Variables.Benchmarks.AdvPolyp.Ov_y)
        RMSA(i) = RMSA(i) + (1 - BMAdvy(j)/handles.Variables.Benchmarks.AdvPolyp.Ov_perc(j))^2;
    end
    RMS_output = RMSA(i); % this value is passed back
else
    RMS_output = 0;
end

if or(isequal(Mod, 'Dist'), isequal(Mod, 'Both'))
    RMSP(i) = 0;
    for f=5:6
        RMSP(i) = RMSP(i) + ((BM.Polyp_adv(f) - BM.BM_value_adv(f))/BM.BM_value_adv(f))^2;
    end
    RMS_output = RMS_output + RMSP(i);
end

Calibration_2_temp.P(i) = P;
Calibration_2_temp.BM        = BM;
Calibration_2_temp.Variables = handles.Variables;

Calibration_2_temp.Flow.Iteration = Calibration_2_temp.Flow.Iteration;
Calibration_2_temp.Flow.RMSA      = RMSA;
Calibration_2_temp.Flow.RMSP      = RMSP;
cd(fullfile(CurrentPath, 'Temp'))
save('Calibration_2_temp', 'Calibration_2_temp')

