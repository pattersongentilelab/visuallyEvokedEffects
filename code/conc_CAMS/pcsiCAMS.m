% CAMS analysis for Minds Matter Concussion
addpath /Users/pattersonc/Documents/MATLAB/commonFx

% cams variables
var_aSx = char('nausea','balance problems','dizziness','light sensitivity','sound sensitivity','visual problems',...
    'difficulty thinking');

var_aSx_abs = char('no nausea','no balance problems','no dizziness','no light sensitivity','no sound sensitivity','no visual problems',...
    'no difficulty thinking');

MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/processedPCSI'],'all')

MCA_no = size(var_aSx,1);

mca_num = 6;

all.Headache2 = zeros(height(all),1);
all.Headache2(all.Headache=='mild') = 1;
all.Headache2(all.Headache=='moderate') = 2;
all.Headache2(all.Headache=='severe') = 3;

%% Calculate CAMS scores
% CAMS was calculated through MCA using the following function that is publically available:
% Antonio Trujillo-Ortiz (2021). Multiple Correspondence Analysis Based on the Indicator Matrix. 
% (https://www.mathworks.com/matlabcentral/fileexchange/22154-multiple-correspondence-analysis-based-on-the-indicator-matrix), 
% MATLAB Central File Exchange.

% reconfigure data so they can be used in the MCA function, mcorran2. The
% syntax is all variables need to be converted to binary


% calculate MCA pre-post
PrePost = all((all.Group=='pre-injury'|all.Group=='post-injury') & all.ConcNum==0 & all.HAdx=='none',:);
CAMSprepost = runCAMS(PrePost(:,11:17),var_aSx,var_aSx_abs,'Sn',[1 1 1],'MCA_no',mca_num);
PrePost.MCA1_aSx = CAMSprepost.MCA_score(:,1);
PrePost.MCA2_aSx = CAMSprepost.MCA_score(:,2);
PrePost.MCA3_aSx = CAMSprepost.MCA_score(:,3);
PrePost.MCA4_aSx = CAMSprepost.MCA_score(:,4);
PrePost.MCA5_aSx = CAMSprepost.MCA_score(:,5);
PrePost.MCA6_aSx = CAMSprepost.MCA_score(:,6);

% calculate MCA headache and pre-injury
HA = all((all.Group=='pre-injury' & all.ConcNum==0 & all.HAdx=='none')|all.Group=='headache',:);
CAMSha = runCAMS(HA(:,11:17),var_aSx,var_aSx_abs,'MCA_no',mca_num);
HA.MCA1_aSx = CAMSha.MCA_score(:,1);
HA.MCA2_aSx = CAMSha.MCA_score(:,2);
HA.MCA3_aSx = CAMSha.MCA_score(:,3);
HA.MCA4_aSx = CAMSha.MCA_score(:,4);
HA.MCA5_aSx = CAMSha.MCA_score(:,5);
HA.MCA6_aSx = CAMSha.MCA_score(:,6);

% calculate combined MCA
Train = all(all.model=='train',:);
CAMStrain = runCAMS(Train(:,11:17),var_aSx,var_aSx_abs,'Sn',[1 -1 1],'MCA_no',mca_num);
Train.MCA1_aSx = CAMStrain.MCA_score(:,1);
Train.MCA2_aSx = CAMStrain.MCA_score(:,2);
Train.MCA3_aSx = CAMStrain.MCA_score(:,3);
Train.MCA4_aSx = CAMStrain.MCA_score(:,4);
Train.MCA5_aSx = CAMStrain.MCA_score(:,5);
Train.MCA6_aSx = CAMStrain.MCA_score(:,6);

%% adding additional grouping options

Train.Group2 = NaN*ones(height(Train),1);
Train.Group2(Train.Group=='pre-injury' & Train.TotalPCSI<=7) = 1;
Train.Group2(Train.Group=='pre-injury' & Train.TotalPCSI>7) = 2;
Train.Group2(Train.Group=='post-injury' & Train.TotalPCSI<=7) = 3;
Train.Group2(Train.Group=='post-injury' & Train.TotalPCSI>7) = 4;
Train.Group2(Train.Group=='headache' & Train.HAdx=='migraine') = 5;
Train.Group2(Train.Group=='headache' & Train.HAdx=='prob_migraine') = 6;
Train.Group2 = categorical(Train.Group2,1:6,{'pre-injury asymptomatic','pre-injury symptomatic','post-injury asymptomatic','post-injury symptomatic','migraine','probable migraine'});

Train.Group3 = NaN*ones(height(Train),1);
Train.Group3(Train.Group=='pre-injury' & Train.TotalPCSI<=7) = 1;
Train.Group3(Train.Group=='post-injury' & Train.TotalPCSI>7) = 2;
Train.Group3(Train.Group=='headache' & Train.HAdx=='migraine') = 3;
Train.Group3 = categorical(Train.Group3,1:3,{'pre-injury','post-injury symptomatic','migraine'});

figure
bar(1:8,sum(table2array(Train(Train.Group=='pre-injury',11:18)),1)./85)
hold on
bar(1:8,sum(table2array(Train(Train.Group=='post-injury',11:18)),1)./85)
bar(1:8,sum(table2array(Train(Train.Group=='headache',11:18)),1)./85)
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:8; ax.XTickLabels = var_aSx;

%% SVM classifier

Temp = templateSVM('Standardize',true);
Mdl = fitcecoc(Train,'Group3~MCA1_aSx+MCA2_aSx+MCA3_aSx','Learners',Temp,'FitPosterior',true);
CVmdl = crossval(Mdl);
genErr = kfoldLoss(CVmdl);

Train.Classify = predict(Mdl,Train);

% Graph classification space
x1Pts = linspace(min(Train.MCA1_aSx)-0.2,max(Train.MCA1_aSx)+0.2);
x2Pts = linspace(min(Train.MCA2_aSx)-0.2,max(Train.MCA2_aSx)+0.2);
x3Pts = linspace(min(Train.MCA3_aSx)-0.2,max(Train.MCA3_aSx)+0.2);
[x1Grid,x2Grid] = meshgrid(x1Pts,x2Pts);
[~,x3Grid] = meshgrid(x2Pts,x3Pts);

[~,~,~,PosteriorRegion] = predict(Mdl,[x1Grid(:),x2Grid(:),x3Grid(:)]);

figure
maxPosterior = max(PosteriorRegion,[],2);
maxPosterior = reshape(maxPosterior,size(x1Grid));
contourf(x1Grid,x2Grid,maxPosterior);
h = colorbar;
h.YLabel.String = 'Maximum posterior';
hold on
gh = gscatter(Train.MCA1_aSx+0.1*rand(length(Train.MCA1_aSx),1),Train.MCA2_aSx+0.1*rand(length(Train.MCA1_aSx),1),Train.Group3,'kkk','x*d',8);

figure
plot(1:6,[0.30 0.28 0.18 0.19 0.22 0.19],'o-','MarkerFaceColor','b') % group 3
hold on
plot(1:6,[0.41 0.42 0.33 0.35 0.38 0.35],'or-','MarkerFaceColor','r') % group
plot(1:6,[0.43 0.49 0.42 0.41 0.42 0.39],'og-','MarkerFaceColor','g') % group 2
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0.5 6.5]; ax.YLim = [0 0.5];