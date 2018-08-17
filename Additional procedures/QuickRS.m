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

function [Tumor, Counter, SurvivalMatrix, CancerMortality, Survival, PatientsAtRisk] = QuickRS...
    (DeathYear, Included, PatientNumber, Location, DeathCause, n)

SurvivalMatrix  = zeros(100000, 100);
CancerMortality = zeros(1, 100);
PatientsAtRisk  = zeros(1, 100);
Survival        = zeros(1, n);
Tumor = zeros(70, 13);
Counter = 1;

for z=1:n
    TestYear = Included(z);
    if DeathYear(z) > TestYear % if the patient had been alive during the test period
        if ~isequal(TestYear, -1) % if the patient had not been excluded
            PatientsAtRisk(1: (round(DeathYear(z)) - TestYear +1)) = PatientsAtRisk(1: (round(DeathYear(z)) - TestYear +1)) + 1;
            for y=(TestYear-1):100
                pos = find(PatientNumber(y,:)==z, 1);
                if ~isempty(pos)
                    Location2 = Location(y, pos);
                    Tumor(y-TestYear+2, Location2) = Tumor(y-TestYear+2, Location2) +1;
                end
                if isequal(DeathYear(z), y)
                    if isequal(DeathCause(z), 2) % CRC specific mortality
                        CancerMortality(y-TestYear+2) = CancerMortality(y-TestYear+2) +1;
                    end
                end
            end
            
            Survival(Counter)     = DeathYear(z)-TestYear;
            SurvivalMatrix(Counter, 1:round(DeathYear(z))-TestYear) =1;
            Counter = Counter + 1;
        end
        %     end
    end
end
