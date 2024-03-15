% CAMS analysis for Minds Matter Concussion
addpath /Users/pattersonc/Documents/MATLAB/commonFx

MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/processedAllHA'],'ha')

% cams variables
var_aSx=char('nausea and vomiting','balance problems','lightheadedness','spinning','light sensitivity','sound sensitivity','smell sensitivity',...
    'blurry vision','double vision','difficulty thinking','ear ringing','neck pain');

var_aSx_abs=char('no nausea or vomiting','no balance problems','no lightheadedness','no spinning','no light sensitivity','no sound sensitivity',...
    'no smell sensitivity','no blurry vision','no double vision','no difficulty thinking','no ear ringing','no neck pain');

MCA_no = size(var_aSx,1);

mca_num = 4;

%% Calculate CAMS scores
% CAMS was calculated through MCA using the following function that is publically available:
% Antonio Trujillo-Ortiz (2021). Multiple Correspondence Analysis Based on the Indicator Matrix. 
% (https://www.mathworks.com/matlabcentral/fileexchange/22154-multiple-correspondence-analysis-based-on-the-indicator-matrix), 
% MATLAB Central File Exchange.

% reconfigure data so they can be used in the MCA function, mcorran2. The
% syntax is all variables need to be converted to binary



% calculate MCA headache
HA = ha;
CAMSha = runCAMS(HA(:,11:22),var_aSx,var_aSx_abs,'xColor',0.35,'xBubble',100,'Sn',[-1 1 -1]);
HA.MCA1_aSx = CAMSha.MCA_score(:,1);
HA.MCA2_aSx = CAMSha.MCA_score(:,2);
HA.MCA3_aSx = CAMSha.MCA_score(:,3);
HA.MCA4_aSx = CAMSha.MCA_score(:,4);
