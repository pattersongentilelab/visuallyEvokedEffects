% CAMS analysis for Minds Matter Concussion
addpath /Users/pattersonc/Documents/MATLAB/commonFx

% cams variables
var_aSx = char('nausea','balance problems','dizziness','light sensitivity','sound sensitivity','visual problems',...
    'difficulty thinking');

var_aSx_abs = char('no nausea','no balance problems','no dizziness','no light sensitivity','no sound sensitivity','no visual problems',...
    'no difficulty thinking');

MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/processedPCSI24'],'all')

MCA_no = size(var_aSx,1);

mca_num = 6;

Sn = [1 -1 1];

all.Headache2 = zeros(height(all),1);
all.Headache2(all.Headache=='mild') = 1;
all.Headache2(all.Headache=='moderate') = 2;
all.Headache2(all.Headache=='severe') = 3;

all.HAdx = removecats(all.HAdx);

%% Calculate CAMS scores
% CAMS was calculated through MCA using the following function that is publically available:
% Antonio Trujillo-Ortiz (2021). Multiple Correspondence Analysis Based on the Indicator Matrix. 
% (https://www.mathworks.com/matlabcentral/fileexchange/22154-multiple-correspondence-analysis-based-on-the-indicator-matrix), 
% MATLAB Central File Exchange.

% reconfigure data so they can be used in the MCA function, mcorran2. The
% syntax is all variables need to be converted to binary


% calculate MCA pre-post
PrePost = all((all.Group=='pre-injury'|all.Group=='post-injury') & all.ConcHx==0 & all.HAdx=='none',:);
CAMSprepost = runCAMS(PrePost(:,10:16),var_aSx,var_aSx_abs,'Sn',[1 1 1],'MCA_no',mca_num);
PrePost.MCA1_aSx = CAMSprepost.MCA_score(:,1);
PrePost.MCA2_aSx = CAMSprepost.MCA_score(:,2);
PrePost.MCA3_aSx = CAMSprepost.MCA_score(:,3);
PrePost.MCA4_aSx = CAMSprepost.MCA_score(:,4);
PrePost.MCA5_aSx = CAMSprepost.MCA_score(:,5);
PrePost.MCA6_aSx = CAMSprepost.MCA_score(:,6);

% calculate MCA headache and pre-injury
HA = all((all.Group=='pre-injury' & all.ConcHx==0 & all.HAdx=='none')|all.Group=='headache',:);
CAMSha = runCAMS(HA(:,10:16),var_aSx,var_aSx_abs,'MCA_no',mca_num,'xColor',0.6);
HA.MCA1_aSx = CAMSha.MCA_score(:,1);
HA.MCA2_aSx = CAMSha.MCA_score(:,2);
HA.MCA3_aSx = CAMSha.MCA_score(:,3);
HA.MCA4_aSx = CAMSha.MCA_score(:,4);
HA.MCA5_aSx = CAMSha.MCA_score(:,5);
HA.MCA6_aSx = CAMSha.MCA_score(:,6);

% calculate combined MCA
Train = all(all.model=='train',:);
CAMStrain = runCAMS(Train(:,10:16),var_aSx,var_aSx_abs,'Sn',Sn,'MCA_no',mca_num,'xBubble',100);
Train.MCA1_aSx = CAMStrain.MCA_score(:,1);
Train.MCA2_aSx = CAMStrain.MCA_score(:,2);
Train.MCA3_aSx = CAMStrain.MCA_score(:,3);
Train.MCA4_aSx = CAMStrain.MCA_score(:,4);
Train.MCA5_aSx = CAMStrain.MCA_score(:,5);
Train.MCA6_aSx = CAMStrain.MCA_score(:,6);

figure
bar(1:7,sum(table2array(Train(Train.Group=='pre-injury',10:16)),1)./200)
hold on
bar(1:7,sum(table2array(Train(Train.Group=='post-injury',10:16)),1)./200)
bar(1:7,sum(table2array(Train(Train.Group=='headache',10:16)),1)./200)
ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:7; ax.XTickLabels = var_aSx;

figure
histogram(Train.Headache(Train.Group=='pre-injury'),'Normalization','probability')
hold on
histogram(Train.Headache(Train.Group=='post-injury'),'Normalization','probability')
histogram(Train.Headache(Train.Group=='headache'),'Normalization','probability')
ax = gca; ax.TickDir = 'out'; ax.Box = 'off';

%% plot MCA as a function of headache severity


figure
no_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='none' & Train.Group=='post-injury')));
mild_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='mild' & Train.Group=='post-injury')));
mod_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='moderate' & Train.Group=='post-injury')));
sev_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='severe' & Train.Group=='post-injury')));
no_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='none' & Train.Group=='post-injury')));
mild_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='mild' & Train.Group=='post-injury')));
mod_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='moderate' & Train.Group=='post-injury')));
sev_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='severe' & Train.Group=='post-injury')));

x_val = [no_ha1(500) mild_ha1(500) mod_ha1(500) sev_ha1(500)];
x_errLo = [abs(diff(no_ha1([25 500]))) abs(diff(mild_ha1([25 500]))) abs(diff(mod_ha1([25 500]))) abs(diff(sev_ha1([25 500])))];
x_errHi = [abs(diff(no_ha1([500 975]))) abs(diff(mild_ha1([500 975]))) abs(diff(mod_ha1([500 975]))) abs(diff(sev_ha1([500 975])))];

y_val = [no_ha2(500) mild_ha2(500) mod_ha2(500) sev_ha2(500)];
y_errLo = [abs(diff(no_ha2([25 500]))) abs(diff(mild_ha2([25 500]))) abs(diff(mod_ha2([25 500]))) abs(diff(sev_ha2([25 500])))];
y_errHi = [abs(diff(no_ha2([500 975]))) abs(diff(mild_ha2([500 975]))) abs(diff(mod_ha2([500 975]))) abs(diff(sev_ha2([500 975])))];

errorbar(x_val,y_val,y_errLo,y_errHi,x_errLo,x_errHi,'-*b')
ax = gca; ax.TickDir = 'out'; ax.Box = 'off';
hold on

mild_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='mild' & Train.Group=='headache')));
mod_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='moderate' & Train.Group=='headache')));
sev_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='severe' & Train.Group=='headache')));
mild_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='mild' & Train.Group=='headache')));
mod_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='moderate' & Train.Group=='headache')));
sev_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='severe' & Train.Group=='headache')));

x_val = [mild_ha1(500) mod_ha1(500) sev_ha1(500)];
x_errLo = [abs(diff(mild_ha1([25 500]))) abs(diff(mod_ha1([25 500]))) abs(diff(sev_ha1([25 500])))];
x_errHi = [abs(diff(mild_ha1([500 975]))) abs(diff(mod_ha1([500 975]))) abs(diff(sev_ha1([500 975])))];

y_val = [mild_ha2(500) mod_ha2(500) sev_ha2(500)];
y_errLo = [abs(diff(mild_ha2([25 500]))) abs(diff(mod_ha2([25 500]))) abs(diff(sev_ha2([25 500])))];
y_errHi = [abs(diff(mild_ha2([500 975]))) abs(diff(mod_ha2([500 975]))) abs(diff(sev_ha2([500 975])))];

errorbar(x_val,y_val,y_errLo,y_errHi,x_errLo,x_errHi,'-xr')

no_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='none' & Train.Group=='pre-injury')));
mild_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='mild' & Train.Group=='pre-injury')));
mod_ha1 = sort(bootstrp(1000,@mean,Train.MCA1_aSx(Train.Headache=='moderate' & Train.Group=='pre-injury')));
no_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='none' & Train.Group=='pre-injury')));
mild_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='mild' & Train.Group=='pre-injury')));
mod_ha2 = sort(bootstrp(1000,@mean,Train.MCA2_aSx(Train.Headache=='moderate' & Train.Group=='pre-injury')));

x_val = [no_ha1(500) mild_ha1(500) mod_ha1(500)];
x_errLo = [abs(diff(no_ha1([25 500]))) abs(diff(mild_ha1([25 500]))) abs(diff(mod_ha1([25 500])))];
x_errHi = [abs(diff(no_ha1([500 975]))) abs(diff(mild_ha1([500 975]))) abs(diff(mod_ha1([500 975])))];

y_val = [no_ha2(500) mild_ha2(500) mod_ha2(500)];
y_errLo = [abs(diff(no_ha2([25 500]))) abs(diff(mild_ha2([25 500]))) abs(diff(mod_ha2([25 500])))];
y_errHi = [abs(diff(no_ha2([500 975]))) abs(diff(mild_ha2([500 975]))) abs(diff(mod_ha2([500 975])))];

errorbar(x_val,y_val,y_errLo,y_errHi,x_errLo,x_errHi,'-+g')
%% SVM classifier

Temp = templateSVM('Standardize',true);
Mdl1 = fitcecoc(Train,'Group~MCA1_aSx','Learners',Temp,'FitPosterior',true);
CVmdl1 = crossval(Mdl1);
genErr1 = kfoldLoss(CVmdl1);

Mdl2 = fitcecoc(Train,'Group~MCA1_aSx+MCA2_aSx','Learners',Temp,'FitPosterior',true);
CVmdl2 = crossval(Mdl2);
genErr2 = kfoldLoss(CVmdl2);

Mdl3 = fitcecoc(Train,'Group~MCA1_aSx+MCA2_aSx+MCA3_aSx','Learners',Temp,'FitPosterior',true);
CVmdl3 = crossval(Mdl3);
genErr3 = kfoldLoss(CVmdl3);

Mdl4 = fitcecoc(Train,'Group~MCA1_aSx+MCA2_aSx+MCA3_aSx+MCA4_aSx','Learners',Temp,'FitPosterior',true);
CVmdl4 = crossval(Mdl4);
genErr4 = kfoldLoss(CVmdl4);



Train.Classify = predict(Mdl2,Train);

% Graph classification space
x1Pts = linspace(min(Train.MCA1_aSx)-0.2,max(Train.MCA1_aSx)+0.2);
x2Pts = linspace(min(Train.MCA2_aSx)-0.2,max(Train.MCA2_aSx)+0.2);
[x1Grid,x2Grid] = meshgrid(x1Pts,x2Pts);

[~,~,~,PosteriorRegion] = predict(Mdl2,[x1Grid(:),x2Grid(:)]);

figure
maxPosterior = max(PosteriorRegion(:,1:3),[],2);
maxPosterior = reshape(maxPosterior,size(x1Grid));
contourf(x1Grid,x2Grid,maxPosterior);
h = colorbar;
h.YLabel.String = 'Maximum posterior';
hold on
gh = gscatter(Train.MCA1_aSx+0.1*rand(length(Train.MCA1_aSx),1),Train.MCA2_aSx+0.1*rand(length(Train.MCA2_aSx),1),Train.Group,'gbr','x*+',10);

ax = gca; ax.TickDir = 'out'; ax.Box = 'off';

%% Validate model

Sx = table2array(all(:,10:16));

binary_hx = cell(size(Sx));
binary_struct = NaN*ones(size(Sx,2),1);
for x = 1:size(Sx,2)
    temp = Sx(:,x);
    outcome=unique(temp);
        for y=1:size(Sx,1)
            binary_struct(x,:) = 2;
                switch temp(y)
                    case outcome(1)
                        binary_hx{y,x} = [1 0];
                    case outcome(2)
                        binary_hx{y,x} = [0 1];
                end
        end
end


% concatonate each subjects binary outcomes
binary_Hx = NaN*ones(size(binary_hx,1),size(var_aSx,1)*2);
temp = [];
for x=1:size(binary_hx,1)
    for y=1:size(binary_hx,2)
        temp = cat(2,temp,cell2mat(binary_hx(x,y)));
    end
    binary_Hx(x,:) = temp;
    temp=[];
end

MCA_score = NaN*ones(size(binary_Hx,1),mca_num);
for x = 1:size(binary_Hx,1)
    for y = 1:mca_num
        temp1 = binary_Hx(x,:);
        temp2 = CAMStrain.MCA_model(:,y);
        r=temp1*temp2;
        MCA_score(x,y) = r;
    end
end

all.MCA1_aSx = Sn(1)*MCA_score(:,1);
all.MCA2_aSx = Sn(2)*MCA_score(:,2);
all.MCA3_aSx = Sn(3)*MCA_score(:,3);


all.Classify = predict(Mdl2,[all.MCA1_aSx all.MCA2_aSx]);

% subclassify participants

all.HAdxSimple = mergecats(all.HAdx,{'migraine','chronic_migraine'});
all.HAdxSimple = mergecats(all.HAdxSimple,{'tth','chronic_tth'});
all.PCSIbin = NaN*ones(height(all),1);
all.PCSIbin(all.TotalPCSI<7)  = 0;
all.PCSIbin(all.TotalPCSI>=7)  = 1;
all.PCSIbin = categorical(all.PCSIbin,[0 1],{'asympt','sympt'});

all.Subclass = NaN*ones(height(all),1);
all.Subclass(all.PCSIbin == 'asympt' & all.Group == 'pre-injury') = 0;
all.Subclass(all.PCSIbin == 'asympt' & all.Group == 'post-injury') = 1;
all.Subclass(all.PCSIbin == 'sympt' & all.Group == 'pre-injury') = 2;
all.Subclass(all.PCSIbin == 'sympt' & all.Group == 'post-injury') = 3;
all.Subclass(all.HAdxSimple=='tth' & all.Group == 'headache') = 4;
all.Subclass(all.HAdxSimple=='prob_migraine' & all.Group == 'headache') = 5;
all.Subclass(all.HAdxSimple=='migraine' & all.Group == 'headache') = 6;

all.Subclass = categorical(all.Subclass,0:1:6,{'uninjured asymptomatic','concussion asymptomatic',...
    'uninjured symptomatic','concussion symptomatic','tth','probable migraine','migraine'});


%% plot MCA as a function of headache severity for train + validate sample

figure
hold on
conc_noHAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdxSimple=='none' & all.Group=='post-injury')));
conc_noHAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdxSimple=='none' & all.Group=='post-injury')));
errorbar(conc_noHAhx1(500),conc_noHAhx2(500),abs(diff(conc_noHAhx2([25 500]))),abs(diff(conc_noHAhx2([500 975]))),abs(diff(conc_noHAhx1([25 500]))),abs(diff(conc_noHAhx1([500 975]))),'+g')

conc_HAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdxSimple~='none' & all.Group=='post-injury')));
conc_HAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdxSimple~='none' & all.Group=='post-injury')));
errorbar(conc_HAhx1(500),conc_HAhx2(500),abs(diff(conc_HAhx2([25 500]))),abs(diff(conc_HAhx2([500 975]))),abs(diff(conc_HAhx1([25 500]))),abs(diff(conc_HAhx1([500 975]))),'+m')

unI_noHAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdxSimple=='none' & all.Group=='pre-injury')));
unI_noHAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdxSimple=='none' & all.Group=='pre-injury')));
errorbar(unI_noHAhx1(500),unI_noHAhx2(500),abs(diff(unI_noHAhx2([25 500]))),abs(diff(unI_noHAhx2([500 975]))),abs(diff(unI_noHAhx1([25 500]))),abs(diff(unI_noHAhx1([500 975]))),'+b')

unI_HAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdxSimple~='none' & all.Group=='pre-injury')));
unI_HAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdxSimple~='none' & all.Group=='pre-injury')));
errorbar(unI_HAhx1(500),unI_HAhx2(500),abs(diff(unI_HAhx2([25 500]))),abs(diff(unI_HAhx2([500 975]))),abs(diff(unI_HAhx1([25 500]))),abs(diff(unI_HAhx1([500 975]))),'+c')

mig_HAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdx=='migraine' & all.Group=='headache')));
mig_HAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdx=='migraine' & all.Group=='headache')));
errorbar(mig_HAhx1(500),mig_HAhx2(500),abs(diff(mig_HAhx2([25 500]))),abs(diff(mig_HAhx2([500 975]))),abs(diff(mig_HAhx1([25 500]))),abs(diff(mig_HAhx1([500 975]))),'+r')

pmig_HAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdx=='prob_migraine' & all.Group=='headache')));
pmig_HAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdx=='prob_migraine' & all.Group=='headache')));
errorbar(pmig_HAhx1(500),pmig_HAhx2(500),abs(diff(pmig_HAhx2([25 500]))),abs(diff(pmig_HAhx2([500 975]))),abs(diff(pmig_HAhx1([25 500]))),abs(diff(pmig_HAhx1([500 975]))),'+k')

tth_HAhx1 = sort(bootstrp(1000,@mean,all.MCA1_aSx(all.HAdxSimple=='tth' & all.Group=='headache')));
tth_HAhx2 = sort(bootstrp(1000,@mean,all.MCA2_aSx(all.HAdxSimple=='tth' & all.Group=='headache')));
errorbar(tth_HAhx1(500),tth_HAhx2(500),abs(diff(tth_HAhx2([25 500]))),abs(diff(tth_HAhx2([500 975]))),abs(diff(tth_HAhx1([25 500]))),abs(diff(tth_HAhx1([500 975]))),'+y')

ax = gca; ax.TickDir = 'out'; ax.Box = 'off';