% Pre-process CAMS analysis for Minds Matter Concussion

%% Minds Matter CAMS based on PCSI

% load and organize minds matter data
MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/pcsi_data2024'],'data')

% remove records collected prior to Jan-1-2020
data = data(data.date_visit>='01/01/2020',:);

% separate out participants with multiple entries
[a,b,c] = unique(data.PAT_MRN_ID);
data = data(b,:);

mm = data(:,1);
mm.uniqueID = categorical(1:1:height(data))';
mm = mm(:,2);
mm.Center = categorical(cellstr(repmat('mm',height(mm),1)));
mm.Sex = renamecats(data.SEX,{'Female','Male'},{'female','male'});
mm.Age = data.AGE_AT_VISIT;
% mm.RaceEth = data.race_ethn; 
% mm.RaceEth = categorical(mm.RaceEth,[1 2 4 3 5 6 NaN],{'White','Black','Asian','Hispanic','More than 1 race','Other','NR'});
mm.DaysPost = data.doi_to_visit;
mm.HAdx = zeros(height(mm),1);
mm.HAdx(data.CHRONIC_HEADACHE_MEDHX=='No' & data.MIGRAINES_MEDHX=='Yes') = 1;
mm.HAdx(data.CHRONIC_HEADACHE_MEDHX=='Yes' & data.MIGRAINES_MEDHX=='No') = 2;
mm.HAdx(data.CHRONIC_HEADACHE_MEDHX=='Yes' & data.MIGRAINES_MEDHX=='Yes') = 3;
mm.HAdx = categorical(mm.HAdx,[0 1 2 3],{'none','migraine','chronic_headache','chronic_migraine'});
mm.FamMigraine = zeros(height(mm),1);
mm.FamMigraine(data.MIGRAINES_FHX=='Yes') = 1;
mm.ConcHx = zeros(height(mm),1);
mm.ConcHx(data.conc_hx=='Yes') = 1;

% post-injury
mm.Headache = data.headache;
mm.Headache(isnan(mm.Headache)) = str2double(cellstr(data.had_headaches(isnan(mm.Headache))));
mm.Headache(mm.Headache==1|mm.Headache==2) = 1;
mm.Headache(mm.Headache==3|mm.Headache==4) = 2;
mm.Headache(mm.Headache==5|mm.Headache==6) = 3;
mm.Headache = categorical(mm.Headache,[0 1:3],{'none','mild','moderate','severe'});
mm.Nausea = data.nausea;
mm.Nausea(isnan(mm.Nausea)) = str2double(cellstr(data.felt_sick(isnan(mm.Nausea))));
mm.Nausea(mm.Nausea>0) = 1;
mm.Balance = data.balance_problems;
mm.Balance(isnan(mm.Balance)) = str2double(cellstr(data.having_balance_problems(isnan(mm.Balance))));
mm.Balance(mm.Balance>0) = 1;
mm.Dizziness = data.dizziness;
mm.Dizziness(isnan(mm.Dizziness)) = str2double(cellstr(data.felt_dizzy(isnan(mm.Dizziness))));
mm.Dizziness(mm.Dizziness>0) = 1;
mm.LightSens = data.light_sensitivity;
mm.LightSens(isnan(mm.LightSens)) = str2double(cellstr(data.been_bothered_by_light_more(isnan(mm.LightSens))));
mm.LightSens(mm.LightSens>0) = 1;
mm.SoundSens = data.noise_sensitivity;
mm.SoundSens(isnan(mm.SoundSens)) = str2double(cellstr(data.been_bothered_by_music_more(isnan(mm.SoundSens))));
mm.SoundSens(mm.SoundSens>0) = 1;
mm.VisualProblem = data.visual_problems;
mm.VisualProblem(isnan(mm.VisualProblem)) = str2double(cellstr(data.has_vision_been_blurry(isnan(mm.VisualProblem))));
mm.VisualProblem(mm.VisualProblem>0) = 1;
mm.DifficultyThinking = sum([data.feeling_slowed data.feeling_mentally_foggy...
    data.difficulty_concentrating data.difficulty_remembering data.confusion],2);
mm.DifficultyThinking(isnan(mm.DifficultyThinking)) = sum([str2double(cellstr(data.felt_like_thinking_slowly(isnan(mm.DifficultyThinking)))) str2double(cellstr(data.felt_hard_to_think_clearly(isnan(mm.DifficultyThinking))))...
    str2double(cellstr(data.hart_to_pay_attention(isnan(mm.DifficultyThinking)))) str2double(cellstr(data.felt_hard_to_remember_things(isnan(mm.DifficultyThinking))))],2);
mm.DifficultyThinking(mm.DifficultyThinking>0) = 1;
mm.Fatigue = data.fatigue;
mm.Fatigue(isnan(mm.Fatigue)) = str2double(cellstr(data.felt_more_tired(isnan(mm.Fatigue))));
mm.Fatigue(mm.Fatigue>0) = 1;
mm.aSx = sum([mm.Nausea mm.Balance mm.Dizziness mm.LightSens mm.SoundSens mm.VisualProblem mm.DifficultyThinking mm.Fatigue],2);
mm.TotalPCSI = data.teen_current;
mm.TotalPCSI(isnan(mm.TotalPCSI)) = str2double(cellstr(data.child_current(isnan(mm.TotalPCSI))));

% pre-injury
mm.Headache2 = data.headache_b4;
mm.Headache2(isnan(mm.Headache2)) = data.had_headaches_b4_inj(isnan(mm.Headache2));
mm.Headache2(mm.Headache2==1|mm.Headache2==2) = 1;
mm.Headache2(mm.Headache2==3|mm.Headache2==4) = 2;
mm.Headache2(mm.Headache2==5|mm.Headache2==6) = 3;
mm.Headache2 = categorical(mm.Headache2,[0 1:3],{'none','mild','moderate','severe'});
mm.Nausea2 = data.NAUSEA_B4;
mm.Nausea2(isnan(mm.Nausea2)) = data.felt_nauseous_b4_inj(isnan(mm.Nausea2));
mm.Nausea2(mm.Nausea2>0) = 1;
mm.Balance2 = data.balance_problems_b4;
mm.Balance2(isnan(mm.Balance2)) = data.balance_problems_b4_inj(isnan(mm.Balance2));
mm.Balance2(mm.Balance2>0) = 1;
mm.Dizziness2 = data.DIZZINESS_B4;
mm.Dizziness2(isnan(mm.Dizziness2)) = data.felt_dizzy_b4_inj(isnan(mm.Dizziness2));
mm.Dizziness2(mm.Dizziness2>0) = 1;
mm.LightSens2 = data.LIGHT_SENSITIVITY_B4;
mm.LightSens2(isnan(mm.LightSens2)) = data.bother_by_light_b4_inj(isnan(mm.LightSens2));
mm.LightSens2(mm.LightSens2>0) = 1;
mm.SoundSens2 = data.NOISE_SENSITIVITY_B4;
mm.SoundSens2(isnan(mm.SoundSens2)) = data.bother_by_noise_b4_inj(isnan(mm.SoundSens2));
mm.SoundSens2(mm.SoundSens2>0) = 1;
mm.VisualProblem2 = data.VISUAL_PROBLEMS_B4;
mm.VisualProblem2(isnan(mm.VisualProblem2)) = data.vision_blurry_b4_inj(isnan(mm.VisualProblem2));
mm.VisualProblem2(mm.VisualProblem2>0) = 1;
mm.DifficultyThinking2 = sum([data.FEELING_SLOWED_DOWN_B4 data.MENTALLY_FOGGY_B4...
    data.DIFFICULTY_CONCENTRATING_B4 data.DIFFICULTY_REMEMBERING_B4 data.CONFUSED_B4],2);
mm.DifficultyThinking2(isnan(mm.DifficultyThinking2)) = sum([data.thinking_slower_b4_inj(isnan(mm.DifficultyThinking2)) data.hard_to_think_clear_b4_inj(isnan(mm.DifficultyThinking2))...
    data.attention_difficult_b4_inj(isnan(mm.DifficultyThinking2)) data.hard_to_remember_b4_inj(isnan(mm.DifficultyThinking2))],2);
mm.DifficultyThinking2(mm.DifficultyThinking2>0) = 1;
mm.Fatigue2 = data.FATIGUE_B4;
mm.Fatigue2(isnan(mm.Fatigue2)) = data.felt_tired_b4_inj(isnan(mm.Fatigue2));
mm.Fatigue2(mm.Fatigue2>0) = 1;
mm.aSx2 = sum([mm.Nausea2 mm.Balance2 mm.Dizziness2 mm.LightSens2 mm.SoundSens2 mm.VisualProblem2 mm.DifficultyThinking2 mm.Fatigue2],2);
mm.TotalPCSI2 = data.teen_baseline;
mm.TotalPCSI2(isnan(mm.TotalPCSI)) = str2double(cellstr(data.child_baseline(isnan(mm.TotalPCSI))));

% Select participants
mm = mm(mm.DaysPost<=360 & mm.Age>=13 & mm.Age<=18 & (~isnan(mm.TotalPCSI)|~isnan(mm.TotalPCSI2)),:);

mmPre = mm(:,[1:8 20:30]);
mmPre = mmPre(~isnan(mm.TotalPCSI2),:);
mmPre.Group = categorical(cellstr(repmat('pre-injury',height(mmPre),1)));

mmPost = mm(:,1:19);
mmPost = mmPost(~isnan(mm.TotalPCSI),:);
mmPost.Group = categorical(cellstr(repmat('post-injury',height(mmPost),1)));

mmPre.Properties.VariableNames = mmPost.Properties.VariableNames;
mmPrePost = [mmPre;mmPost];

% determine train and validation sets for pre- and post-injury
trainPost = mmPrePost.uniqueID(mmPrePost.ConcHx==0 & mmPrePost.HAdx=='none' & mmPrePost.DaysPost<=28 & mmPrePost.Group=='post-injury' & mmPrePost.TotalPCSI>=7);
rand_select = randperm(length(trainPost));
trainPost = trainPost(rand_select(1:200));
mmPrePost.model = zeros(height(mmPrePost),1);
trainPre = mmPrePost.uniqueID(mmPrePost.ConcHx==0 & mmPrePost.HAdx=='none' & mmPrePost.Group=='pre-injury' & mmPrePost.TotalPCSI<7 & ~ismember(mmPrePost.uniqueID,trainPost));
rand_select = randperm(length(trainPre));
trainPre = trainPre(rand_select(1:200));
mmPrePost.model(ismember(mmPrePost.uniqueID,trainPre)==1 & mmPrePost.Group=='pre-injury') = ones(200,1);
mmPrePost.model(ismember(mmPrePost.uniqueID,trainPost)==1 & mmPrePost.Group=='post-injury') = ones(200,1);
mmPrePost.model = categorical(mmPrePost.model,[1 0],{'train','validate'});

clear data

%% CHOP migraine PCSI

% load chop data
data_path = getpref('assocSxHA','pfizerDataPath');
load([data_path '/PfizerHAdataMay24.mat']);

data.p_sev_overall = categorical(data.p_sev_overall);
data.p_activity = categorical(data.p_activity);
data.p_activity = categorical(data.p_activity);
data.p_sev_dur = categorical(data.p_sev_dur);
data.p_ha_in_lifetime = categorical(data.p_ha_in_lifetime);
data.p_con_pattern_duration = categorical(data.p_con_pattern_duration);
data.p_fre_bad = categorical(data.p_fre_bad);
data.p_epi_fre_dur = categorical(data.p_epi_fre_dur);
data.p_epi_fre = categorical(data.p_epi_fre);
data.p_current_ha_pattern = categorical(data.p_current_ha_pattern);
data.p_sev_dur = categorical(data.p_sev_dur);
data.p_pattern_to_con = categorical(data.p_pattern_to_con);
data.p_con_start_date = datetime(data.p_con_start_date);

ICHD3 = ichd3_Dx(data);

ha = data(:,1);
ha.Properties.VariableNames = {'uniqueID'};
ha.uniqueID = categorical(ha.uniqueID);
ha.Center = categorical(cellstr(repmat('ha',height(ha),1)));
ha.Sex = data.gender;
ha.Sex = categorical(ha.Sex,1:2,{'female','male'});
ha.Age = floor(data.age);
% ha.RaceEth = zeros(height(ha),1); 
% ha.RaceEth(data.race=='white') = 1;
% ha.RaceEth(data.race=='black') = 2;
% ha.RaceEth(data.race=='asian') = 4;
% ha.RaceEth(data.ethnicity=='hisp') = 3;
% ha.RaceEth(data.race=='unk') = 7;
% ha.RaceEth = categorical(ha.RaceEth,[1 2 4 3 5 6 7 0],{'White','Black','Asian','Hispanic','More than 1 race','Other','Unknown','NR'});
ha.DaysPost = NaN*ones(height(ha),1);
ha.HAdx = ICHD3.dx;
ha.FamMigraine = NaN*ones(height(ha),1);
ha.ConcHx =  NaN*ones(height(ha),1);
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

ha = ha(ha.Age>=13 & ha.Age<=18 & data.visit_dt>='2022-11-01' & (ha.HAdx=='migraine'|ha.HAdx=='prob_migraine'|ha.HAdx=='chronic_migraine'|ha.HAdx=='tth'|ha.HAdx=='chronic_tth'),:);


% determine train and validation sets for headache
ha.model = zeros(height(ha),1);
trainHA = ha.uniqueID(ha.HAdx=='migraine');
rand_select = randperm(length(trainHA));
trainHA = trainHA(rand_select(1:200));
ha.model(ismember(ha.uniqueID,trainHA)==1) = ones(200,1);
ha.model = categorical(ha.model,[1 0],{'train','validate'});
clear data

%% combine datasets
all = [mmPrePost(:,1:21);ha(:,1:21)];

save([MindsMatter_dataBasePath '/cams/processedPCSI24'],'all')
