function Automatic_RS_Screen(handles)

PathName = uigetdir(handles.Variables.ResultsPath, 'Select folder to save files');
if isequal(PathName, 0) 
    return
end    
BaseName = handles.Variables.Settings_Name;
answer = inputdlg({'Please select base name for files!', 'Number replicas'}, 'Write settings repetitively', 1, {BaseName, num2str(25)});
if isempty(answer)
    return
end
BaseName = answer{1};
[NumberReplicas, status] = str2num(answer{2});
if ~status
    return
end

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


for f= 1:15
    if f<10
        fString = ['0' num2str(f)];
    else
        fString = num2str(f);
    end
    handles.Variables.DirectCancerSpeed = f/10000000;
    
    % these are the settings for the Atkin study, Lancet
    handles.Variables.SpecialText = 'RS-RCT';
    WriteSettings(handles.Variables, PathName, [BaseName '_RS-Atkin_' fString], NumberReplicas)
    
    handles.Variables.SpecialText = 'RS-RCT_Mock';
    WriteSettings(handles.Variables, PathName, [BaseName '_RS-Atkin_Mock' fString], NumberReplicas)
    
  %  these are the settings for the Schoen study, NEJM
%    handles.Variables.SpecialText = 'RS-RCT-Validation';
%    WriteSettings(handles.Variables, PathName, [BaseName '_RS-Schoen_' fString], NumberReplicas)
%     
%    handles.Variables.SpecialText = 'RS-RCT-Validation_Mock';
%    WriteSettings(handles.Variables, PathName, [BaseName '_RS-Schoen_Mock_' fString], NumberReplicas)
    
    % these are the settings for the Holme study, JAMA
%     handles.Variables.SpecialText = 'RS-Holme';
%     WriteSettings(handles.Variables, PathName, [BaseName '_RS-Holme_' fString], NumberReplicas)
%     
%     handles.Variables.SpecialText = 'RS-Holme_Mock';
%     WriteSettings(handles.Variables, PathName, [BaseName '_RS-Holme_Mock_' fString], NumberReplicas)
    
    % these are the settings for the Segnan study, JNCI 2011
%     handles.Variables.SpecialText = 'RS-Segnan';
%     WriteSettings(handles.Variables, PathName, [BaseName '_RS-Segnan_' fString], NumberReplicas)
%     
%     handles.Variables.SpecialText = 'RS-Segnan_Mock';
%     WriteSettings(handles.Variables, PathName, [BaseName '_RS-Segnan_Mock_' fString], NumberReplicas)
    
end
msgbox('files have been written')

function WriteSettings(Variables, PathName, BaseName, NumberReplicas) %#ok<INUSL>
for f= 1:NumberReplicas
    if f<10
        NumberString = ['0' num2str(f)];
    else
        NumberString = num2str(f);
    end
    SettingsName = [BaseName '__' NumberString];
    save(fullfile(PathName, SettingsName), 'Variables');
end


