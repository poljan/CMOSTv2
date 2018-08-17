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

function DifferentialPolypEvaluation (data, Variables)

n=data.n;

% we will compare the 20 year cancer incidence after for individuals with
% polyps/ cancer and without polyps/ cancer at age 55.
NumberPolypCancer = 0; NumberNoPolypCancer = 0;
NumberPolyp = 0; NumberNoPolyp = 0;

for z=1:n
    if isequal(data.Last.TestDone(z), 1) % this patient had been included...
        NumberPolyp    = NumberPolyp +1;
        for y = 57:86
            if ~isempty(find(data.TumorRecord.PatientNumber(y,:)==z, 1))
                NumberPolypCancer = NumberPolypCancer + 1;
                break
            end
        end
    elseif isequal(data.Last.TestDone(z), 2)
        NumberNoPolyp  = NumberNoPolyp +1;
        for y = 57:86
            if ~isempty(find(data.TumorRecord.PatientNumber(y,:)==z, 1))
                NumberNoPolypCancer = NumberNoPolypCancer + 1;
                break
            end
        end
    end
end
DiffResults.NumberPolyp         = NumberPolyp;
DiffResults.NumberNoPolyp       = NumberNoPolyp;
DiffResults.NumberPolypCancer   = NumberPolypCancer;
DiffResults.NumberNoPolypCancer = NumberNoPolypCancer;

% we will draw a graph after "maximum clinical incidence reduction" intervention 
% at age 65 ("perfect" intervention)
PatientArray        = zeros(n, 100);
PatientArrayCancer  = zeros(n, 100);
for z=1:n
    for f=57:100
        if and(data.DeathYear(z) > (f-1), data.NaturalDeathYear(z) > (f-1))
            PatientArray(z,f) = 1; % here the patient is still alive
            if ~isempty(find(data.TumorRecord.PatientNumber(f, :) == z, 1))
                % at that year a new cancer for this patient has been
                % diagnosed
                PatientArrayCancer(z,f) = 1;
                break
            end
        else
            break
        end
    end
end
% these variables are saved as a graph
DiffResults.PerfectInterventionPatients = sum(PatientArray, 1);
DiffResults.PerfectInterventionCancer   = sum(PatientArrayCancer, 1);
                
% we summarize sojourn time and dwell time        
SojournTime = cell(1, 90); DwellTime = cell(1, 90); OverallTime = cell(1, 90);
for g = 40:90
    tmp = find(data.TumorRecord.Stage(g+1, :) > 0);
    for f=tmp
        SojournTime{g} = cat(1, SojournTime{g}, data.TumorRecord.Sojourn(g+1, f));
        DwellTime{g}   = cat(1, DwellTime{g},   data.TumorRecord.DwellTime(g+1, f));
        OverallTime{g} = cat(1, OverallTime{g}, data.TumorRecord.Sojourn(g+1, f) + data.TumorRecord.DwellTime(g+1, f));
    end
end

FileName = fullfile(Variables.ResultsPath, [Variables.Settings_Name '_ModComp']);

DiffResults.SojournTime = SojournTime;
DiffResults.DwellTime   = DwellTime;
DiffResults.OverallTime = OverallTime;

save(FileName, 'DiffResults')

return
