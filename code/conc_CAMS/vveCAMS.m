% look at VVE with CAMS data

%% Load CAMS data
MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/allCAMS'],'all')



% Select only mind's matter post-injury participants (because they have VVE)
CAMS = all(all.Group=='post-injury',:);

%% Load and organize VVE data

% load and organize minds matter data
MindsMatter_dataBasePath = getpref('visuallyEvokedEffects','MindsMatter_DataPath');
load([MindsMatter_dataBasePath '/cams/pcsi_data2024'],'data')

% remove records collected prior to Jan-1-2020
data = data(data.date_visit>='01/01/2020',:);



% separate out participants with multiple entries
[~,b,~] = unique(data.PAT_MRN_ID);
data = data(b,:);
data.uniqueID = categorical(1:1:height(data))'; % unique ID assigned prior to inclusion criteria

% impose inclusion criteria
data = data(data.doi_to_visit<=360 & data.AGE_AT_VISIT>=13 & data.AGE_AT_VISIT<=18 & (~isnan(data.teen_current)|~isnan(data.teen_baseline)),:);

clear b

CAMS.vve_horsac = data.horsac_20rep;
CAMS.vve_horsac(CAMS.vve_horsac=='-999') = '<undefined>';
CAMS.vve_horsac = removecats(CAMS.vve_horsac);
CAMS.vve_horsac = reordercats(CAMS.vve_horsac,{'normal','abnormal'});
CAMS.vve_vertsac = data.vertsac_20rep;
CAMS.vve_vertsac(CAMS.vve_vertsac=='-999') = '<undefined>';
CAMS.vve_vertsac = removecats(CAMS.vve_vertsac);
CAMS.vve_vertsac = reordercats(CAMS.vve_vertsac,{'normal','abnormal'});
CAMS.vve_horvor = data.horvor_20reps;
CAMS.vve_horvor(CAMS.vve_horvor=='-999') = '<undefined>';
CAMS.vve_horvor = removecats(CAMS.vve_horvor);
CAMS.vve_horvor = reordercats(CAMS.vve_horvor,{'normal','abnormal'});
CAMS.vve_vertvor = data.vertvor_20rep;
CAMS.vve_vertvor(CAMS.vve_vertvor=='-999') = '<undefined>';
CAMS.vve_vertvor = removecats(CAMS.vve_vertvor);
CAMS.vve_vertvor = reordercats(CAMS.vve_vertvor,{'normal','abnormal'});
CAMS.vve_pursuits = data.pursuits_abnlsignssymp;
CAMS.vve_pursuits(CAMS.vve_pursuits=='-999') = '<undefined>';
CAMS.vve_pursuits = removecats(CAMS.vve_pursuits);
CAMS.vve_pursuits = reordercats(CAMS.vve_pursuits,{'normal','abnormal'});
CAMS.vve_npc = data.npc;
CAMS.vve_npc(CAMS.vve_npc=='-999') = '<undefined>';
CAMS.vve_npc = removecats(CAMS.vve_npc);
CAMS.vve_npc = reordercats(CAMS.vve_npc,{'normal','abnormal'});
CAMS.vve_horsac2 = NaN*ones(height(CAMS),1);
CAMS.vve_horsac2(CAMS.vve_horsac=='normal') = 0;
CAMS.vve_horsac2(CAMS.vve_horsac=='abnormal') = 1;
CAMS.vve_vertsac2 = NaN*ones(height(CAMS),1);
CAMS.vve_vertsac2(CAMS.vve_vertsac=='normal') = 0;
CAMS.vve_vertsac2(CAMS.vve_vertsac=='abnormal') = 1;
CAMS.vve_horvor2 = NaN*ones(height(CAMS),1);
CAMS.vve_horvor2(CAMS.vve_horvor=='normal') = 0;
CAMS.vve_horvor2(CAMS.vve_horvor=='abnormal') = 1;
CAMS.vve_vertvor2 = NaN*ones(height(CAMS),1);
CAMS.vve_vertvor2(CAMS.vve_vertvor=='normal') = 0;
CAMS.vve_vertvor2(CAMS.vve_vertvor=='abnormal') = 1;
CAMS.vve_pursuits2 = NaN*ones(height(CAMS),1);
CAMS.vve_pursuits2(CAMS.vve_pursuits=='normal') = 0;
CAMS.vve_pursuits2(CAMS.vve_pursuits=='abnormal') = 1;
CAMS.vve_npc2 = NaN*ones(height(CAMS),1);
CAMS.vve_npc2(CAMS.vve_npc=='normal') = 0;
CAMS.vve_npc2(CAMS.vve_npc=='abnormal') = 1;

CAMS.vve_sac = sum([CAMS.vve_horsac2 CAMS.vve_vertsac2],2);
CAMS.vve_sac2 = CAMS.vve_sac;
CAMS.vve_sac2(CAMS.vve_sac==2) = 1;
CAMS.vve_sac = categorical(CAMS.vve_sac,[0 1 2],{'normal','abnormal','abnormal'});
CAMS.vve_vor = sum([CAMS.vve_horvor2 CAMS.vve_vertvor2],2);
CAMS.vve_vor2 = CAMS.vve_vor;
CAMS.vve_vor2(CAMS.vve_vor==2) = 1;
CAMS.vve_vor = categorical(CAMS.vve_vor,[0 1 2],{'normal','abnormal','abnormal'});

CAMS.vve_all = sum([CAMS.vve_sac2 CAMS.vve_vor2 CAMS.vve_pursuits2 CAMS.vve_npc2],2);

mdl_vveCAMS1 = fitlm(CAMS,'MCA1_aSx ~ vve_sac + vve_vor + vve_pursuits + vve_npc');
tbl_vveCAMS1 = lm_tbl_plot(mdl_vveCAMS1);

mdl_vveCAMS2 = fitlm(CAMS(CAMS.MCA1_aSx>-4.7,:),'MCA2_aSx ~ vve_sac + vve_vor + vve_pursuits + vve_npc');
tbl_vveCAMS2 = lm_tbl_plot(mdl_vveCAMS2);

CAMS.ClassifyBin = NaN*ones(height(CAMS),1);
CAMS.ClassifyBin(CAMS.Classify=='post-injury') = 1;
CAMS.ClassifyBin(CAMS.Classify=='headache') = 0;
mdl_vveClassify = fitglm(CAMS(CAMS.Classify~='pre-injury',:),'ClassifyBin ~ vve_sac + vve_vor + vve_pursuits + vve_npc','Distribution','binomial');
tbl_vveClassify = brm_tbl_plot(mdl_vveClassify);

CAMS.ClassifyBin2 = NaN*ones(height(CAMS),1);
CAMS.ClassifyBin2(CAMS.Classify=='post-injury') = 1;
CAMS.ClassifyBin2(CAMS.Classify=='pre-injury') = 0;
mdl_vveClassify2 = fitglm(CAMS(CAMS.Classify~='headache',:),'ClassifyBin ~ vve_sac + vve_vor + vve_pursuits + vve_npc','Distribution','binomial');
tbl_vveClassify2 = brm_tbl_plot(mdl_vveClassify2);


var_abnl = char('horsac abnl','vertsac abnl','horvor abnl','vertvor abnl','pursuits abnl','npc abnl');
var_nl = char('horsac nl','vertsac nl','horvor nl','vertvor nl','pursuits nl','npc nl');

MCAvve = runCAMS(CAMS(~isnan(CAMS.vve_horsac2) & ~isnan(CAMS.vve_vertsac2) & ~isnan(CAMS.vve_horvor2)...
    & ~isnan(CAMS.vve_vertvor2) & ~isnan(CAMS.vve_pursuits2) & ~isnan(CAMS.vve_npc2),36:41),var_abnl,var_nl,'Sn',[1 1 1],'xColor',0.5);

