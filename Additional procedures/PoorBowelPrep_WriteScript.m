function PoorBowelPrep_WriteScript(handles)

% numbers according to Sulz, Kroeger et al. 2016 PLoS One
% detection of early adenomas
% good vs. excellent            1 (0.95 - 1.06)
% fair vs. excellent            0.98 (0.87 - 1.1)
% poor vs. excellent            0.63 (0.44 - 0.91)
% insufficient vs. excellent    0.43 (0.33 - 0.56)
%
% inadequate vs. adequate       0.53 (0.46 ? 0.62)  
% suboptimal vs. optimal        0.81 (0.74 ? 0.89),

% detection of advanced adenomas
% good vs. good/excellent            1 no numbers
% fair vs. good/excellent            1 (0.88 - 1.15)
% poor vs. good/excellent            0.79 (0.53 - 1.19)
% insufficient vs. good/excellent    0.75 (0.27 - 2.14)
%
% Inadequate vs. adequate           0.74 (0.62 - 0.87)
% Suboptimal vs. optimal            0.94 (0.87 ? 1.01)

PathName = '/Users/misselwb/Documents/CRC Screening/_Bowel Prep_2/Data/Data_12082017';
BaseName = 'BowelPrep_12_08_2017';
NumberReplica = 10;

%%% SCENARIO 1 %%%
%%% this is the FIRST scenario: we assume everybody is doing colonoscopy
%%% with the same poor level of preparation all the time, for screening and
%%% for surveillance.

% Baseline, no screening
% screening off
handles.Variables.Screening.Mode      = 'off';
% polyp surveillance, cancer surveillance on
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'off';
handles.Variables.Screening.Mode      = 'off';
handles.Variables.SpecialText = '';
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Baseline_'], NumberReplica)

% Koloskopie for comparison
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'off';
handles.Variables.SpecialText         = '';
handles.Variables.Screening.Mode      = 'on';
%                                     particip adherence folup  start end interval aft_colo spec 
handles.Variables.Screening.Colonoscopy = [1,  1                51    76  10       10       1   ];
handles.Variables.Screening.Rectosigmoidoscopy(1: end)  = 0; 
handles.Variables.Screening.FOBT(1: end)                = 0;
handles.Variables.Screening.I_FOBT(1: end)              = 0;
handles.Variables.Screening.Sept9_HiSens(1: end)        = 0;
handles.Variables.Screening.Sept9_HiSpec(1: end)        = 0;
handles.Variables.Screening.other(1: end)               = 0;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Standard_Screening_'], NumberReplica)

ColoDetection = handles.Variables.Colo_Detection;

% Koloskopie poor bowel preparation Aronchick 01
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'off';
handles.Variables.Screening.Mode      = 'on';
%                                     particip adherence f/up  start end interval aft_colo spec 
handles.Variables.Screening.Colonoscopy = [1,  1                51    76  10       10       1   ];
handles.Variables.Screening.Rectosigmoidoscopy(1: end)  = 0; 
handles.Variables.Screening.FOBT(1: end)                = 0;
handles.Variables.Screening.I_FOBT(1: end)              = 0;
handles.Variables.Screening.Sept9_HiSens(1: end)        = 0;
handles.Variables.Screening.Sept9_HiSpec(1: end)        = 0;
handles.Variables.Screening.other(1: end)               = 0;

% insufficient vs. excellent         0.43 (0.33 - 0.56)
% insufficient vs. good/excellent    0.75 (0.27 - 2.14) advanced
handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.43;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 0.75;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_01_avg_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.33;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 0.27;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_01_low_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.56;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_01_high_'], NumberReplica)

% poor vs. excellent                 0.63 (0.44 - 0.91)
% poor vs. good/excellent            0.79 (0.53 - 1.19) advanced
handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.63;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 0.79;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_02_avg_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.44;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 0.53;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_02_low_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.91;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_02_high_'], NumberReplica)

% fair vs. excellent            0.98 (0.87 - 1.1)
% fair vs. good/excellent       1 (0.88 - 1.15) advanced
handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.98;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_03_avg_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.87;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 0.88;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_03_low_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 1;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_03_high_'], NumberReplica)

% good vs. excellent            1 (0.95 - 1.06)
handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 1;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_04_avg_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 0.95;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_04_low_'], NumberReplica)

handles.Variables.Colo_Detection(1:4) = ColoDetection(1:4) * 1.06;
handles.Variables.Colo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC01_Aronchick_04_high_'], NumberReplica)

%%% SCENARIO 2 %%%
%%% this is the SECOND scenario: we do a single colonoscopy at age 65 with
%%% the respective level of preparation. We now see how many interval cancer 
%%% will develop subsequently in individuals with 0, 1, 2 etc. polyps
%%% detected at this colonoscopy (this requires hacks). 

% general settings for comparison
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'on';
handles.Variables.SpecialText         = 'PBP_66_WWxx';
handles.Variables.Screening.Mode      = 'off';
handles.Variables.Colo_Detection = ColoDetection;

% insufficient vs. excellent         0.43 (0.33 - 0.56)
% insufficient vs. good/excellent    0.75 (0.27 - 2.14) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.43;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 0.75;
WriteSettings(handles.Variables, PathName, [BaseName '_SC02_PBP_66_WWxx_Aronchick_01_avg_'], NumberReplica)

% poor vs. excellent                 0.63 (0.44 - 0.91)
% poor vs. good/excellent            0.79 (0.53 - 1.19) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.63;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 0.79;
WriteSettings(handles.Variables, PathName, [BaseName '_SC02_PBP_66_WWxx_Aronchick_02_avg_'], NumberReplica)

% fair vs. excellent            0.98 (0.87 - 1.1)
% fair vs. good/excellent       1 (0.88 - 1.15) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.98;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC02_PBP_66_WWxx_Aronchick_03_avg_'], NumberReplica)

% good vs. excellent            1 (0.95 - 1.06)
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 1;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC02_PBP_66_WWxx_Aronchick_04_avg_'], NumberReplica)

% excellent                     1 
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 1;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 1;
WriteSettings(handles.Variables, PathName, [BaseName '_SC02_PBP_66_WWxx_Aronchick_05_avg_'], NumberReplica)

%%% SCENARIO 3 %%%
%%% this is the THIRD scenario: we do a single colonoscopy at age 65 with
%%% the respective level of preparation. We now repeat colonoscopy every X
%%% years and see how many interval carcinoma develop and whether screening
%%% remains cost-efficient. 
%%% We will mark individuals with 0, 1, 2 etc. polyps
%%% detected at this colonoscopy (this requires hacks). 

% general settings for comparison
handles.Variables.Polyp_Surveillance  = 'on';
handles.Variables.Cancer_Surveillance = 'on';
handles.Variables.SpecialFlag         = 'on';
handles.Variables.SpecialText         = 'PBP_66_WWxx';
handles.Variables.Screening.Mode      = 'off';
handles.Variables.Colo_Detection = ColoDetection;

% insufficient vs. excellent         0.43 (0.33 - 0.56)
% insufficient vs. good/excellent    0.75 (0.27 - 2.14) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.43;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 0.75;
handles.Variables.SpecialText         = 'PBP_66_WW00';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW00_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW01';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW01_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW02';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW02_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW03';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW03_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW04';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW04_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW05';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW05_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW06';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW06_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW07';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW07_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW08';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW08_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW09';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW09_Aronchick_01_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW10';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW10_Aronchick_01_avg_'], NumberReplica)

% poor vs. excellent                 0.63 (0.44 - 0.91)
% poor vs. good/excellent            0.79 (0.53 - 1.19) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.63;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 0.79;
handles.Variables.SpecialText         = 'PBP_66_WW00';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW00_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW01';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW01_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW02';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW02_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW03';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW03_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW04';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW04_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW05';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW05_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW06';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW06_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW07';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW07_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW08';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW08_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW09';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW09_Aronchick_02_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW10';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW10_Aronchick_02_avg_'], NumberReplica)

% fair vs. excellent            0.98 (0.87 - 1.1)
% fair vs. good/excellent       1 (0.88 - 1.15) advanced
handles.Variables.RectoSigmo_Detection(1:4) = ColoDetection(1:4) * 0.98;
handles.Variables.RectoSigmo_Detection(5:6) = ColoDetection(5:6) * 1;
handles.Variables.SpecialText         = 'PBP_66_WW00';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW00_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW01';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW01_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW02';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW02_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW03';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW03_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW04';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW04_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW05';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW05_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW06';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW06_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW07';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW07_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW08';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW08_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW09';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW09_Aronchick_03_avg_'], NumberReplica)
handles.Variables.SpecialText         = 'PBP_66_WW10';
WriteSettings(handles.Variables, PathName, [BaseName '_SC03_PBP_66_WW10_Aronchick_03_avg_'], NumberReplica)

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