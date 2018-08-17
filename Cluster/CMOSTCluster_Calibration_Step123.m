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

function handles = CMOSTCluster_Calibration_Step123(InputFile)

% replace with CMOST pat on your folder on the Linux cluster
addpath('/cluster/home/misselwb/CMOST_28_May_2016')
try
    handles.Variables = importdata(InputFile);
catch
    try
        handles.Variables = importdata(InputFile);
    catch
        try
            handles.Variables = importdata(InputFile);
        catch
            rethrow(lasterror) %#ok<LERR>
        end
    end
end

% no Excelfile and not pdf files from cluster
handles.Variables.DispFlag    = false;
handles.Variables.ResultsFlag = true;
handles.Variables.ExcelFlag   = false;

% we make sure randomization yields in different results on each run
s=feature('getpid');
display(['using the following pid ' num2str(s)])
RandStream('mt19937ar','seed',sum(s*clock));

x = RandStream('mt19937ar','Seed', sum(s*clock));
RandStream.setGlobalStream(x);

% we set pathname and filename right
[pathstr, name, ~] = fileparts(InputFile);
handles.Variables.Settings_Name = name;
handles.Variables.ResultsPath   = pathstr;

% we start the job on the cluster
handles = AutomaticCalibration_Steps123(handles, 'standard');

% we are back with the results
Variables = handles.Variables;
NewName = [name '_calibrated'];
save(fullfile(pathstr, NewName), 'Variables')

