% Pre-process CAMS analysis for Minds Matter Concussion

%% Minds Matter CAMS based on PCSI

% load and organize minds matter data
MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/pcsi_data2021'],'data')

% remove participants with multiple entries
[a,b,c] = unique(data.uniqueID);
data = data(b,:);

mm = data(:,1);
mm.Center = categorical(cellstr(repmat('mm',height(mm),1)));
mm.Sex = data.sex_master;
mm.Sex = categorical(mm.Sex,1:2,{'female','male'});
mm.Age = data.age;
mm.RaceEth = data.race_ethn; 
mm.RaceEth = categorical(mm.RaceEth,[1 2 4 3 5 6 NaN],{'White','Black','Asian','Hispanic','More than 1 race','Other','NR'});
mm.DaysPost = days(data.test_date-data.doi);
mm.HAdx = data.med_hx___1;
mm.HAdx(data.med_hx___2==1 & data.med_hx___1==0) = 2;
mm.HAdx(data.med_hx___2==1 & data.med_hx___1==1) = 3;
mm.HAdx = categorical(mm.HAdx,[0 1 2 3],{'none','migraine','chronic_headache','chronic_migraine'});
mm.FamMigraine = data.family_hx___1;
mm.ConcNum = data.conchx_num;

% post-injury
mm.Headache = data.teenPCSI_headache;
mm.Headache(isnan(mm.Headache)) = data.childPCSI_headache(isnan(mm.Headache));
mm.Headache(mm.Headache==1|mm.Headache==2) = 1;
mm.Headache(mm.Headache==3|mm.Headache==4) = 2;
mm.Headache(mm.Headache==5|mm.Headache==6) = 3;
mm.Headache = categorical(mm.Headache,[0 1:3],{'none','mild','moderate','severe'});
mm.Nausea = data.teenPCSI_nausea;
mm.Nausea(isnan(mm.Nausea)) = data.childPCSI_nausea(isnan(mm.Nausea));
mm.Nausea(mm.Nausea>0) = 1;
mm.Balance = data.teenPCSI_balance;
mm.Balance(isnan(mm.Balance)) = data.childPCSI_balance(isnan(mm.Balance));
mm.Balance(mm.Balance>0) = 1;
mm.Dizziness = data.teenPCSI_dizziness;
mm.Dizziness(isnan(mm.Dizziness)) = data.childPCSI_dizziness(isnan(mm.Dizziness));
mm.Dizziness(mm.Dizziness>0) = 1;
mm.LightSens = data.teenPCSI_senslight;
mm.LightSens(isnan(mm.LightSens)) = data.childPCSI_senslight(isnan(mm.LightSens));
mm.LightSens(mm.LightSens>0) = 1;
mm.SoundSens = data.teenPCSI_sensnoise;
mm.SoundSens(isnan(mm.SoundSens)) = data.childPCSI_senslight(isnan(mm.SoundSens));
mm.SoundSens(mm.SoundSens>0) = 1;
mm.VisualProblem = data.teenPCSI_visualprob;
mm.VisualProblem(isnan(mm.VisualProblem)) = data.childPCSI_visualprob(isnan(mm.VisualProblem));
mm.VisualProblem(mm.VisualProblem>0) = 1;
mm.DifficultyThinking = sum([data.teenPCSI_slowed data.teenPCSI_mentfoggy...
    data.teenPCSI_diffconc data.teenPCSI_diffremem],2);
mm.DifficultyThinking(isnan(mm.DifficultyThinking)) = sum([data.childPCSI_thinkslow(isnan(mm.DifficultyThinking)) data.childPCSI_mentfoggy(isnan(mm.DifficultyThinking))...
    data.childPCSI_diffconc(isnan(mm.DifficultyThinking)) data.childPCSI_diffremem(isnan(mm.DifficultyThinking))],2);
mm.DifficultyThinking(mm.DifficultyThinking>0) = 1;
mm.Fatigue = data.teenPCSI_fatigue;
mm.Fatigue(isnan(mm.Fatigue)) = data.childPCSI_fatigue(isnan(mm.Fatigue));
mm.Fatigue(mm.Fatigue>0) = 1;
mm.aSx = sum([mm.Nausea mm.Balance mm.Dizziness mm.LightSens mm.SoundSens mm.VisualProblem mm.DifficultyThinking mm.Fatigue],2);
mm.TotalPCSI = data.teenPCSI_score_total;
mm.TotalPCSI(isnan(mm.TotalPCSI)) = data.childPCSI_score_total(isnan(mm.TotalPCSI));

% pre-injury
mm.Headache2 = data.pcsi_headache_p1;
mm.Headache2(isnan(mm.Headache2)) = str2double(data.cpcsi_headache_p1(isnan(mm.Headache2)));
mm.Headache2(mm.Headache2==1|mm.Headache2==2) = 1;
mm.Headache2(mm.Headache2==3|mm.Headache2==4) = 2;
mm.Headache2(mm.Headache2==5|mm.Headache2==6) = 3;
mm.Headache2 = categorical(mm.Headache2,[0 1:3],{'none','mild','moderate','severe'});
mm.Nausea2 = data.pcsi_nausea_p2;
mm.Nausea2(isnan(mm.Nausea2)) = str2double(data.cpcsi_nausea_p2(isnan(mm.Nausea2)));
mm.Nausea2(mm.Nausea2>0) = 1;
mm.Balance2 = data.pcsi_balance_p3;
mm.Balance2(isnan(mm.Balance2)) = str2double(data.cpcsi_balance_p9(isnan(mm.Balance2)));
mm.Balance2(mm.Balance2>0) = 1;
mm.Dizziness2 = data.pcsi_dizziness_p4;
mm.Dizziness2(isnan(mm.Dizziness2)) = str2double(data.cpcsi_dizziness_p3(isnan(mm.Dizziness2)));
mm.Dizziness2(mm.Dizziness2>0) = 1;
mm.LightSens2 = data.pcsi_senslight_p8;
mm.LightSens2(isnan(mm.LightSens2)) = str2double(data.cpcsi_senslight_p7(isnan(mm.LightSens2)));
mm.LightSens2(mm.LightSens2>0) = 1;
mm.SoundSens2 = data.pcsi_sensnoise_p9;
mm.SoundSens2(isnan(mm.SoundSens2)) = str2double(data.cpcsi_sensnoise_p8(isnan(mm.SoundSens2)));
mm.SoundSens2(mm.SoundSens2>0) = 1;
mm.VisualProblem2 = data.pcsi_visualprob_p18;
mm.VisualProblem2(isnan(mm.VisualProblem2)) = str2double(data.cpcsi_visualprob_p17(isnan(mm.VisualProblem2)));
mm.VisualProblem2(mm.VisualProblem2>0) = 1;
mm.DifficultyThinking2 = sum([data.pcsi_slowed_p14 data.pcsi_mentfoggy_p15...
    data.pcsi_diffconc_p16 data.pcsi_diffremem_p17],2);
mm.DifficultyThinking2(isnan(mm.DifficultyThinking2)) = sum([str2double(data.cpcsi_thinkslow_p13(isnan(mm.DifficultyThinking2))) str2double(data.cpcsi_mentfoggy_p14(isnan(mm.DifficultyThinking2)))...
    str2double(data.cpcsi_diffconc_p5(isnan(mm.DifficultyThinking2))) str2double(data.cpcsi_diffremem_p16(isnan(mm.DifficultyThinking2)))],2);
mm.DifficultyThinking2(mm.DifficultyThinking2>0) = 1;
mm.Fatigue2 = data.pcsi_fatigue_p5;
mm.Fatigue2(isnan(mm.Fatigue2)) = str2double(data.cpcsi_fatigue_p15(isnan(mm.Fatigue2)));
mm.Fatigue2(mm.Fatigue2>0) = 1;
mm.aSx2 = sum([mm.Nausea2 mm.Balance2 mm.Dizziness2 mm.LightSens2 mm.SoundSens2 mm.VisualProblem2 mm.DifficultyThinking2 mm.Fatigue2],2);
mm.TotalPCSI2 = data.pcsi_total_preinj;
mm.TotalPCSI2(isnan(mm.TotalPCSI)) = str2double(data.cpcsi_score_preinjury(isnan(mm.TotalPCSI)));

% Select participants
mm = mm(mm.DaysPost<=360 & mm.Age>=7 & mm.Age<22,:);

mmPre = mm(:,[1:9 21:31]);
mmPre = mmPre(~isnan(mmPre.aSx2),:);
mmPre.Group = categorical(cellstr(repmat('pre-injury',height(mmPre),1)));

mmPost = mm(:,1:20);
mmPost = mmPost(~isnan(mmPost.aSx),:);
mmPost.Group = categorical(cellstr(repmat('post-injury',height(mmPost),1)));

mmPre.Properties.VariableNames = mmPost.Properties.VariableNames;
mmPrePost = [mmPre;mmPost];

% determine train and validation sets for pre- and post-injury
trainPost = mmPrePost.uniqueID(mmPrePost.ConcNum==0 & mmPrePost.HAdx=='none' & mmPrePost.Group=='post-injury');
rand_select = randperm(length(trainPost));
trainPost = trainPost(rand_select(1:85));
mmPrePost.model = zeros(height(mmPrePost),1);
trainPre = mmPrePost.uniqueID(mmPrePost.ConcNum==0 & mmPrePost.HAdx=='none' & mmPrePost.Group=='pre-injury' & ~ismember(mmPrePost.uniqueID,trainPost));
rand_select = randperm(length(trainPre));
trainPre = trainPre(rand_select(1:85));
mmPrePost.model(ismember(mmPrePost.uniqueID,trainPre)==1 & mmPrePost.Group=='pre-injury') = ones(85,1);
mmPrePost.model(ismember(mmPrePost.uniqueID,trainPost)==1 & mmPrePost.Group=='post-injury') = ones(85,1);
mmPrePost.model = categorical(mmPrePost.model,[1 0],{'train','validate'});

clear data

%% CHOP migraine PCSI

% load chop data
data_path = getpref('assocSxHA','pfizerDataPath');
load([data_path '/PfizerHAdataDec23.mat']);

ICHD3 = ichd3_Dx(data);

ha = data(:,1);
ha.Properties.VariableNames = {'uniqueID'};
ha.uniqueID = categorical(ha.uniqueID);
ha.Center = categorical(cellstr(repmat('ha',height(ha),1)));
ha.Sex = data.gender;
ha.Sex = categorical(ha.Sex,1:2,{'female','male'});
ha.Age = floor(data.age);
ha.RaceEth = zeros(height(ha),1); 
ha.RaceEth(data.race=='white') = 1;
ha.RaceEth(data.race=='black') = 2;
ha.RaceEth(data.race=='asian') = 4;
ha.RaceEth(data.ethnicity=='hisp') = 3;
ha.RaceEth(data.race=='unk') = 7;
ha.RaceEth = categorical(ha.RaceEth,[1 2 4 3 5 6 7 0],{'White','Black','Asian','Hispanic','More than 1 race','Other','Unknown','NR'});
ha.DaysPost = NaN*ones(height(ha),1);
ha.HAdx = ICHD3.dx;
ha.FamMigraine = NaN*ones(height(ha),1);
ha.ConcNum =  NaN*ones(height(ha),1);
ha.Headache = data.p_sev_overall;
ha.Headache = renamecats(ha.Headache,{'mild','mod','sev'},{'mild','moderate','severe'});
ha.Nausea = data.p_assoc_sx_gi___naus;
ha.Balance = data.p_assoc_sx_oth_sx___balance;
ha.Dizziness = data.p_assoc_sx_oth_sx___lighthead;
ha.Dizziness(data.p_assoc_sx_oth_sx___spinning==1) = 1;
ha.LightSens = data.p_assoc_sx_oth_sx___light;
ha.LightSens(data.p_trigger___light==1) = 1;
ha.SoundSens = data.p_assoc_sx_oth_sx___sound;
ha.SoundSens(data.p_trigger___noises==1) = 1;
ha.VisualProblem = data.p_assoc_sx_vis___blur;
ha.VisualProblem(data.p_assoc_sx_vis___double_vis==1) = 1;
ha.DifficultyThinking = data.p_assoc_sx_oth_sx___think;
ha.Fatigue = data.p_overall_prob___fatigue;
ha.aSx = sum([ha.Nausea ha.Balance ha.Dizziness ha.LightSens ha.SoundSens ha.VisualProblem ha.DifficultyThinking ha.Fatigue],2);
ha.TotalPCSI = NaN*ones(height(ha),1);
ha.Group = categorical(cellstr(repmat('headache',height(ha),1)));

ha = ha(ha.Age>=7 & ha.Age<22 & data.visit_dt>='2022-11-01' & (ha.HAdx=='migraine'|ha.HAdx=='prob_migraine'|ha.HAdx=='chronic_migraine'|ha.HAdx=='tth'|ha.HAdx=='chronic_tth'),:);


% determine train and validation sets for headache
ha.model = zeros(height(ha),1);
trainHA = ha.uniqueID(ha.HAdx=='migraine'|ha.HAdx=='prob_migraine');
rand_select = randperm(length(trainHA));
trainHA = trainHA(rand_select(1:85));
ha.model(ismember(ha.uniqueID,trainHA)==1) = ones(85,1);
ha.model = categorical(ha.model,[1 0],{'train','validate'});
clear data

%% combine datasets
all = [mmPrePost(:,1:22);ha(:,1:22)];

save([MindsMatter_dataBasePath '/cams/processedPCSI'],'all')
