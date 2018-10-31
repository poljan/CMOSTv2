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

function stats = readBenchmarkStatistics(inputFolder, whichSet)
%inputFolder is a variable holding the name of the folder conatinig files with SEER analysis
%whichSet is a variable describing which time period to take, 1 -
%1988-2000, 2 - 2004+

if nargin < 1
    %inputFolder = 'SEER analysis';
    tmp = mfilename('fullpath');
    tmp2= tmp(1:strfind(tmp, 'Additional')-1);
    inputFolder = fullfile(tmp2,'SEER analysis');
end

if nargin < 2
   whichSet = 1; 
end

fileEndName = '88-00';
if whichSet == 2
    fileEndName = '2004+';
end


%read incidence first
incidenceFile = [inputFolder '/incidence' fileEndName '.xlsx'];
stats.incidence = readtable(incidenceFile);

%read mortality
mortalityFile = [inputFolder '/Mortality' fileEndName '.xlsx'];
stats.mortality = readtable(mortalityFile);

%read stage distribution
stageDistributionFile = [inputFolder '/StageAtDiagnosis'  fileEndName '.xlsx'];
stats.stageDistribution = readtable(stageDistributionFile);

%read overall survival by gender only
osfile = [inputFolder '/OverallSurvivalBySexCOD'  fileEndName '.xlsx'];
stats.osByGender = readtable(osfile);

%read overall survival by gender, age, and stage
osfile = [inputFolder '/OverallSurvivalBySexAgeStageCOD'  fileEndName '.xlsx'];
stats.osByGenderAgeStage = readtable(osfile);

end