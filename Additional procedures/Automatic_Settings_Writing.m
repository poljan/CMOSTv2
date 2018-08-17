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

function Automatic_Settings_Writing(handles)

PathName = uigetdir(handles.Variables.ResultsPath, 'Select folder to save files');
if isequal(PathName, 0) 
    return
end    

BaseName = handles.Variables.Settings_Name;
answer = inputdlg({'Please select base name for files!', 'Number replicas'}, 'Write settings repetitively', 1, {BaseName, num2str(10)});
if isempty(answer)
    return
end
BaseName = answer{1};
[NumberReplica, status] = str2num(answer{2}); %#ok<ST2NM>
if ~status
    return
end

% meeting benchmarks
% screening off
% polyp surveillance, cancer surveillance on
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'off';
handles.Variables.Screening.Mode      = 'off';
handles.Variables.SpecialText = '';
WriteSettings(handles.Variables, PathName, [BaseName '_Benchmarks_'], NumberReplica)

% Koloskopie for comparison
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'off';
handles.Variables.Screening.Mode      = 'on';
%                                     particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.Colonoscopy = [1,  1                51    76  10       10       1   ];
handles.Variables.Screening.Rectosigmoidoscopy(1: end)  = 0; 
handles.Variables.Screening.FOBT(1: end)                = 0;
handles.Variables.Screening.I_FOBT(1: end)              = 0;
handles.Variables.Screening.Sept9_HiSens(1: end)        = 0;
handles.Variables.Screening.Sept9_HiSpec(1: end)        = 0;
handles.Variables.Screening.other(1: end)               = 0;

handles.Variables.SpecialText = 'AllPolypFollowUp';
WriteSettings(handles.Variables, PathName, [BaseName '_Kolo_special_'], NumberReplica)

%%%%% COLONOSCOPY %%%%%
handles.Variables.SpecialText = '';
WriteSettings(handles.Variables, PathName, [BaseName '_Screening_Kolo_'], NumberReplica)

%%%%% RECTOSIGMOIDOSCOPY %%%%%
handles.Variables.Screening.Colonoscopy(1:end) = 0;
%                                            particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.Rectosigmoidoscopy = [1,  1         1      51    76  5        5        1   ]; 
WriteSettings(handles.Variables, PathName, [BaseName '_Screening_RectoSigmo_'], NumberReplica)

%%%%% FOBT HEMOCCULT II %%%%%
handles.Variables.Screening.Rectosigmoidoscopy(1:end) = 0;
%                                            particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.FOBT =                 [1,  1         1      51    76  1        5        0.98   ]; 
handles.Variables.Screening.FOBT_Sens         = [0.02,  0.02,  0.05,  0.05,  0.12,  0.12,  0.4,  0.4,  0.4,  0.4];
WriteSettings(handles.Variables, PathName, [BaseName '_Screening_Hemocc_II_'], NumberReplica)

%%%%% I-FOBT %%%%%
handles.Variables.Screening.FOBT(1:end) = 0;
%                                            particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.I_FOBT =               [1,  1         1      51    76  1        5      0.95   ]; 
handles.Variables.Screening.I_FOBT_Sens       = [0.05,  0.05,  0.101, 0.101, 0.22,  0.22,  0.7,  0.7,  0.7,  0.7];
WriteSettings(handles.Variables, PathName, [BaseName '_Screening_I_FOBT_'], NumberReplica)

%%%%% HEMOCCULT SENSA %%%%%
handles.Variables.Screening.I_FOBT(1:end) = 0;
%                                            particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.other =                [1,  1         1      51    76  1        5      0.925   ]; 
handles.Variables.Screening.other_Sens        = [0.075, 0.075, 0.124, 0.124, 0.239, 0.239, 0.7,  0.7,  0.7,  0.7];
WriteSettings(handles.Variables, PathName, [BaseName '_Screening_Hemocc_Sensa_'], NumberReplica)


%%%%% RS-STUDY %%%%%
handles.Variables.Screening.Colonoscopy(1: end)         = 0; 
handles.Variables.Screening.Rectosigmoidoscopy(1: end)  = 0; 
handles.Variables.Screening.FOBT(1: end)                = 0;
handles.Variables.Screening.I_FOBT(1: end)              = 0;
handles.Variables.Screening.Sept9_HiSens(1: end)        = 0;
handles.Variables.Screening.Sept9_HiSpec(1: end)        = 0;
handles.Variables.Screening.other(1: end)               = 0;

handles.Variables.Polyp_Surveillance  = 'off';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'on';
handles.Variables.Screening.Mode      = 'off';

% these are the settings for the Atkin study, Lancet
handles.Variables.SpecialText = 'RS-Atkin';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Atkin_'], NumberReplica)

handles.Variables.SpecialText = 'RS-Atkin_Mock';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Atkin_Mock_'], NumberReplica)

% these are the settings for the Schoen study, NEJM
handles.Variables.SpecialText = 'RS-Schoen';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Schoen_'], NumberReplica)

handles.Variables.SpecialText = 'RS-Schoen_Mock';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Schoen_Mock_'], NumberReplica)

% these are the settings for the Holme study, JAMA
handles.Variables.SpecialText = 'RS-Holme';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Holme_'], NumberReplica)

handles.Variables.SpecialText = 'RS-Holme_Mock';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Holme_Mock_'], NumberReplica)

% these are the settings for the Segnan study, JNCI
handles.Variables.SpecialText = 'RS-Segnan';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Segnan_'], NumberReplica)

handles.Variables.SpecialText = 'RS-Segnan_Mock';
WriteSettings(handles.Variables, PathName, [BaseName '_RS-Segnan_Mock_'], NumberReplica)

%%%%% POLYP EVALUATION %%%%%
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.SpecialText = 'Po+-55';
WriteSettings(handles.Variables, PathName, [BaseName '_Po+-55_'], NumberReplica)
handles.Variables.SpecialText = 'Po+-55treated';
WriteSettings(handles.Variables, PathName, [BaseName '_Po+-55treated_'], NumberReplica)

%%%%% PERFECT INTERVENTION %%%%% 
handles.Variables.SpecialText = 'perfect';
WriteSettings(handles.Variables, PathName, [BaseName '_perfect_'], NumberReplica)

%%%%% NO INTERVENTION %%%%% 
handles.Variables.SpecialFlag         = 'off';
handles.Variables.SpecialText = '_no_intervention_';
WriteSettings(handles.Variables, PathName, [BaseName '_no_intervention_'], NumberReplica)

msgbox('Files have been written')

function WriteSettings(Variables, PathName, BaseName, NumberReplica) %#ok<INUSL>
for f= 1:NumberReplica
    if f<10 
        SettingsName = [BaseName '0' num2str(f)];
    else
        SettingsName = [BaseName num2str(f)];
    end
    save(fullfile(PathName, SettingsName), 'Variables');
end