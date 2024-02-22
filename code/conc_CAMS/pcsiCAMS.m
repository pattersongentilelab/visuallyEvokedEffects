% CAMS analysis for Minds Matter Concussion
addpath /Users/pattersonc/Documents/MATLAB/commonFx

% cams variables
var_aSx=char('nausea','balance problems','dizziness','light sensitivity','sound sensitivity','visual problems',...
    'difficulty thinking');

var_aSx_abs=char('no nausea','no balance problems','no dizziness','no light sensitivity','no sound sensitivity','no visual problems',...
    'no difficulty thinking');

MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/processedPCSI'],'all')

MCA_no = size(var_aSx,1);

mca_num = 4;

%% Calculate CAMS scores
% CAMS was calculated through MCA using the following function that is publically available:
% Antonio Trujillo-Ortiz (2021). Multiple Correspondence Analysis Based on the Indicator Matrix. 
% (https://www.mathworks.com/matlabcentral/fileexchange/22154-multiple-correspondence-analysis-based-on-the-indicator-matrix), 
% MATLAB Central File Exchange.

% reconfigure data so they can be used in the MCA function, mcorran2. The
% syntax is all variables need to be converted to binary


% calculate MCA pre-post
PrePost = all((all.Group=='pre-injury'|all.Group=='post-injury') & all.ConcNum==0 & all.HAdx=='none',:);
CAMSprepost = runCAMS(PrePost(:,11:17),var_aSx,var_aSx_abs,'Sn',[1 1 1]);
PrePost.MCA1_aSx = CAMSprepost.MCA_score(:,1);
PrePost.MCA2_aSx = CAMSprepost.MCA_score(:,2);
PrePost.MCA3_aSx = CAMSprepost.MCA_score(:,3);
PrePost.MCA4_aSx = CAMSprepost.MCA_score(:,4);

% calculate MCA headache and pre-injury
HA = all((all.Group=='pre-injury' & all.ConcNum==0 & all.HAdx=='none')|all.Group=='headache',:);
CAMSha = runCAMS(HA(:,11:17),var_aSx,var_aSx_abs);
HA.MCA1_aSx = CAMSha.MCA_score(:,1);
HA.MCA2_aSx = CAMSha.MCA_score(:,2);
HA.MCA3_aSx = CAMSha.MCA_score(:,3);
HA.MCA4_aSx = CAMSha.MCA_score(:,4);

% calculate combined MCA
Train = all(all.model=='train',:);
CAMStrain = runCAMS(Train(:,11:17),var_aSx,var_aSx_abs,'Sn',[1 -1 1]);
Train.MCA1_aSx = CAMStrain.MCA_score(:,1);
Train.MCA2_aSx = CAMStrain.MCA_score(:,2);
Train.MCA3_aSx = CAMStrain.MCA_score(:,3);
Train.MCA4_aSx = CAMStrain.MCA_score(:,4);

%% Calculate MCA scores for everyone based on train MCA
Sx = table2array(all(:,11:17));

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

MCA_score = NaN*ones(size(binary_Hx,1),MCA_no);
for x = 1:size(binary_Hx,1)
    for y = 1:mca_num
        temp1 = binary_Hx(x,:);
        temp2 = CAMStrain.MCA_model(:,y);
        r=temp1*temp2;
        MCA_score(x,y) = r;
    end
end

all.MCA1_aSx = MCA_score(:,1);
all.MCA2_aSx = MCA_score(:,2);
all.MCA3_aSx = MCA_score(:,3);
all.MCA4_aSx = MCA_score(:,4);

% 3D plot

plot3(all.MCA1_aSx(all.Group=='headache')+0.5*rand(height(all(all.Group=='headache',:)),1),all.MCA2_aSx(all.Group=='headache')+0.5*rand(height(all(all.Group=='headache',:)),1),all.MCA3_aSx(all.Group=='headache')+0.5*rand(height(all(all.Group=='headache',:)),1),'ok','MarkerFaceColor','r')
hold on
plot3(all.MCA1_aSx(all.Group=='pre-injury')+0.5*rand(height(all(all.Group=='pre-injury',:)),1),all.MCA2_aSx(all.Group=='pre-injury')+0.5*rand(height(all(all.Group=='pre-injury',:)),1),all.MCA3_aSx(all.Group=='pre-injury')+0.5*rand(height(all(all.Group=='pre-injury',:)),1),'ok','MarkerFaceColor','w')
plot3(all.MCA1_aSx(all.Group=='post-injury')+0.5*rand(height(all(all.Group=='post-injury',:)),1),all.MCA2_aSx(all.Group=='post-injury')+0.5*rand(height(all(all.Group=='post-injury',:)),1),all.MCA3_aSx(all.Group=='post-injury')+0.5*rand(height(all(all.Group=='post-injury',:)),1),'ok','MarkerFaceColor','k')

%% SVM classifier

all.Dx = zeros(height(all),1);
all.Dx(all.Group=='pre-injury' & all.HAdx=='none' & all.ConcNum==0) = 1;
all.Dx(all.Group=='pre-injury' & all.HAdx=='none' & all.ConcNum>0) = 2;
all.Dx(all.Group=='pre-injury' & (all.HAdx=='migraine'|all.HAdx=='chronic_migraine')) = 3;
all.Dx(all.Group=='headache' & (all.HAdx=='migraine'|all.HAdx=='chronic_migraine')) = 3;
all.Dx(all.Group=='headache' & all.HAdx=='prob_migraine') = 4;
all.Dx(all.Group=='headache' & (all.HAdx=='tth'|all.HAdx=='chronic_tth')) = 5;
all.Dx(all.Group=='post-injury') = 6;

all.Dx = categorical(all.Dx,[1:6 0],{'none','remote concussion','migraine','probable migraine',...
    'tension type headache','post injury','undefined'});

Mdl = fitcecoc(all(all.model=='train',:),'Dx~MCA1_aSx+MCA2_aSx+MCA3_aSx');

all.Classify = predict(Mdl,all);


Mdl_dx = fitcecoc([all.MCA1_aSx all.MCA2_aSx all.MCA3_aSx],all.Dx,'Learners',T,...
    'FitPosterior',true,'Verbose',2);

[label,~,~,Posterior] = resubPredict(Mdl_dx,'Verbose',1);

all.ClassifyDx = categorical(label);