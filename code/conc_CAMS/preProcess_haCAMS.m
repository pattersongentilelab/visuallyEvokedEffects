% Pre-process CAMS analysis for headache compare to adult data

%% CHOP migraine

% load chop data
data_path = getpref('assocSxHA','pfizerDataPath');
load([data_path '/PfizerHAdataDec23.mat']);
MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');

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
ha.NauseaVomit = data.p_assoc_sx_gi___naus;
ha.NauseaVomit(data.p_assoc_sx_gi___vomiting==1) = 1;
ha.Balance = data.p_assoc_sx_oth_sx___balance;
ha.LightHead = data.p_assoc_sx_oth_sx___lighthead;
ha.Spinning = data.p_assoc_sx_oth_sx___spinning;
ha.LightSens = data.p_assoc_sx_oth_sx___light;
ha.LightSens(data.p_trigger___light==1) = 1;
ha.SoundSens = data.p_assoc_sx_oth_sx___sound;
ha.SoundSens(data.p_trigger___noises==1) = 1;
ha.SmellSens = data.p_assoc_sx_oth_sx___smell;
ha.SmellSens(data.p_trigger___smells==1) = 1;
ha.BlurryVis = data.p_assoc_sx_vis___blur;
ha.DoubleVis = data.p_assoc_sx_vis___double_vis;
ha.DifficultyThinking = data.p_assoc_sx_oth_sx___think;
ha.Ringing = data.p_assoc_sx_oth_sx___ringing;
ha.NeckPain = data.p_assoc_sx_oth_sx___neck_pain;
ha.aSx = sum([ha.NauseaVomit ha.Balance ha.LightHead ha.Spinning ha.LightSens ha.SoundSens ha.SmellSens ha.BlurryVis ha.DoubleVis ha.DifficultyThinking ha.Ringing ha.NeckPain],2);
ha.TotalPCSI = NaN*ones(height(ha),1);
ha.Dx

ha = ha(ha.Age>=7 & ha.Age<22 & data.visit_dt>='2022-11-01',:);% & (ha.HAdx=='migraine'|ha.HAdx=='prob_migraine'|ha.HAdx=='chronic_migraine'|ha.HAdx=='tth'|ha.HAdx=='chronic_tth'),:);


save([MindsMatter_dataBasePath '/cams/processedAllHA'],'ha')
