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

function handles = Default_Benchmarks(handles)

% Early Polyp
handles.Variables.Benchmarks.EarlyPolyp.Ov_y          = [25 35 45 60 70 80];
handles.Variables.Benchmarks.EarlyPolyp.Ov_perc       = [4.52 7.25 9.43 27.05 39.55 42.6];
handles.Variables.Benchmarks.EarlyPolyp.Male_y        = [25 35 45 60 70 80];
handles.Variables.Benchmarks.EarlyPolyp.Male_perc     = [5.6980    9.1396   11.8877   34.1000   49.8579   53.7028];
handles.Variables.Benchmarks.EarlyPolyp.Female_y      = [25 35 45 60 70 80];
handles.Variables.Benchmarks.EarlyPolyp.Female_perc   = [3.3420    5.3604    6.9723   20.0000   29.2421   31.4972];

% Multiple Polyps
handles.Variables.Benchmarks.MultiplePolyp            = [36 16 5 4 3];

handles.Variables.Benchmarks.MultiplePolypsYoung = [18 5  3  3 2];
handles.Variables.Benchmarks.MultiplePolypsOld   = [40 24 10 8 4];

% Advanced Adenoma
handles.Variables.Benchmarks = handles.Variables.Benchmarks;
handles.Variables.Benchmarks.AdvPolyp.Ov_y          = [57 62 67 72 77 85];
handles.Variables.Benchmarks.AdvPolyp.Ov_perc       = [4.8 5.85 6.6 7.5 8.1 8.4];
handles.Variables.Benchmarks.AdvPolyp.Male_y        = [57 62 67 72 77 85];
handles.Variables.Benchmarks.AdvPolyp.Male_perc     = [6.2 7.5 8.4 9.2 9.7 9.5];
handles.Variables.Benchmarks.AdvPolyp.Female_y      = [57 62 67 72 77 85];
handles.Variables.Benchmarks.AdvPolyp.Female_perc   = [3.4 4.2 4.8 5.8 6.5 7.3];

% Distribution of Polyp Size
handles.Variables.Benchmarks.Polyp_Distr            = [34.95 27 21 7.9 7.3 1.85];

% Cancer
handles.Variables.Benchmarks.Cancer.Ov_y          = [1.5  5.5     12      17      22      27      32      37      42      47      52      57      62      67      72      77      82     87];
handles.Variables.Benchmarks.Cancer.Ov_inc        = [0    0       0       0.3     0.9     2.1     4.5     8.4     16.6   29.3     57.2    76.1    107.3   160.9   209.2   262.5   313.4  343.4];
handles.Variables.Benchmarks.Cancer.Male_y        = [1.5  5.5     12      17      22      27      32      37      42      47      52      57      62      67      72      77      82     87];
handles.Variables.Benchmarks.Cancer.Male_inc      = [0    0       0       0.3     0.9     2.1     4.5     8.7     17.1    32.2    64      90      129.5   194.7   252.8   308.3   362.7  395.4];
handles.Variables.Benchmarks.Cancer.Female_y      = [1.5  5.5     12      17      22      27      32      37      42      47      52      57      62      67      72      77      82     87];
handles.Variables.Benchmarks.Cancer.Female_inc    = [0    0       0       0.3     0.9     2       4.4     8.2     16      26.4    50.6    63.1    86.9    131.3   173.6   228.5   282.2  319.5];
handles.Variables.Benchmarks.RMS.Cancer           = 30;

% relative danger polyps, modified 10.5.2016 BM
handles.Variables.Benchmarks.Rel_Danger           = [0.07    0.07    0.42    0.42   13.23  85.8];

% fraction rectum carcinoma
handles.Variables.Benchmarks.Cancer.LocationRectumMale   = [41.2     34.1      28.6     23.8];
handles.Variables.Benchmarks.Cancer.LocationRectumFemale = [37.2     28.3      23.0     19.0];
handles.Variables.Benchmarks.Cancer.LocationRectumYear   = {[51 55], [61 65], [71 75], [81 85]};  % year adapted
                                                          % age 52,   62     72        82.

% rectosigmoidoscopy study
% according to Atkin et al., Lancet 2010
handles.Variables.Benchmarks.RSRCTRef.IncRedOverall = 21;

% cancer mortality
%SEER 2000 - 2009
handles.Variables.Benchmarks.Cancer.Ov_y_mort  = [1.5  5.5     12    17      22      27      32      37      42      47      52      57      62      67      72      77      82       87];
handles.Variables.Benchmarks.Cancer.Ov_mort     = [0   0   0    0.0529  0.1655  0.4638  0.9891  2.0413  3.975   7.777   13.83   22.59   35.925  54.36   78.43   108.39  150.077  228.69];
handles.Variables.Benchmarks.Cancer.Male_mort   = [0   0   0    0.064   0.1897  0.5012  1.0565  2.2269  4.3208  8.6845  16.1    27.34   44.515  68.54   97.71   133.57  182.49   266.34];
handles.Variables.Benchmarks.Cancer.Female_mort = [0   0   0    0.0412  0.14    0.425   0.9203  1.8546  3.6327  6.8927  11.67   18.13   28.085  42.01   62.81   90.097  129.93   212.28];

% some additional variables
handles.Variables.DirectCancerRate(1,1:20)    = [0,0, 0, 0,     0.6,    1.5,    3.3,    6.6,    12.9,   25,     48,     77,     110,    162.5,  223.75, 280.6,  335.5,  379.1  395.4, 395.4];
handles.Variables.DirectCancerRate(2,1:20)    = [0,0, 0, 0,     0.6,    1.5,    3.2,    6.3,    12.1,   21.2,   38.5,   56.9,   75,     109.1,  152.5,  201.1,  255.35, 300.85 319.5, 319.5];
handles.Variables.Location_DirectCa           = [0.9985,  0.9959, 0.989, 0.9707, 0.9241, 0.8176, 0.6225, 0.3775, 0.1824, 0.0759, 0.0293, 0.011, 0.0041];

% some hacks
handles.Variables.Cost.Colonoscopy_Cancer   = 1000;
handles.Variables.MaxIterations    = 20;

% P1, P2, P3, P4, P5, P6, Ca1, Ca2, Ca3, Ca4 
handles.Variables.Screening.FOBT_Sens         = [0.02,  0.02,  0.05,  0.05,  0.12,  0.12,  0.4,  0.4,  0.4,  0.4];
handles.Variables.Screening.I_FOBT_Sens       = [0.05,  0.05,  0.101, 0.101, 0.22,  0.22,  0.7,  0.7,  0.7,  0.7];
handles.Variables.Screening.Sept9_HiSens_Sens = [0,     0,     0,     0,     0,     0,     0.89, 0.93, 0.99, 0.99];
handles.Variables.Screening.Sept9_HiSpec_Sens = [0,     0,     0,     0,     0,     0,     0.67, 0.86, 0.87, 0.82];
handles.Variables.Screening.other_Sens        = [0.075, 0.075, 0.124, 0.124, 0.239, 0.239, 0.7,  0.7,  0.7,  0.7];
% numbers quoted from zauber, annals 2008. 

% screening settings
handles.Variables.Screening.Colonoscopy = [0,... Follow up is missing, specificity pointless
    0.75,      50, 81, 10, 5, 0];
handles.Variables.Screening.Rectosigmoidoscopy = [0,... specificity pointless
    0.75, 0.9, 50, 81, 5, 5, 0];
handles.Variables.Screening.FOBT = [0,...
    0.5,  0.9, 50, 81, 1, 5, 0.98];
handles.Variables.Screening.I_FOBT = [0,...
    0.5,  0.9, 50, 81, 1, 5, 0.95];
handles.Variables.Screening.Sept9_HiSens = [0,...
    0.9,  0.9, 50, 81, 1, 5, 0.85];
handles.Variables.Screening.Sept9_HiSpec = [0,...
    0.9,  0.9, 50, 81, 1, 5, 0.99];
handles.Variables.Screening.other = [0,...
    0,    0,   50, 81, 1, 5, 0.925];
