% VisuallyEvokedEffects_figures generates figures for comparison of healthy
% youth athletes and post-concussion youth (age 13 to 20) across visually evoked 
% effects (including MCA), PCSI scores, and visual-ocular-motor task repetitions. 
% Includes statistical analysis.

load visuallyEvokedEffects_data

%% Multiple correspondence analysis of signs and symptoms

% Extract VEP symptoms and signs
vepSx=table2array(subject_VOMS(:,[49:54 58:62]));

% Remove subjects with NaN values
temp=find(~isnan(mean(vepSx,2)));
vepSx=vepSx(temp,:);
subject_VOMS=subject_VOMS(temp,:);

% reconfigure data so they can be used in the MCA function, mcorran2. The
% syntax is all variables need to be converted to binary

binary_hx=cell(size(vepSx));
binary_struct=NaN*ones(size(vepSx,2),1);
for x=1:size(vepSx,2)
    temp=vepSx(:,x);
    outcome=unique(temp);
        for y=1:size(vepSx,1)
            binary_struct(x,:)=2;
                switch temp(y)
                    case outcome(1)
                        binary_hx{y,x}=[1 0];
                    case outcome(2)
                        binary_hx{y,x}=[0 1];
                end
        end
end

variables=char('eye fatigue','dizziness','headache','nausea','eye pain','other symptom',...
    'eyes slowing','eyes watering','eyes reddening','eyes moving in circular motion','other sign',...
    'category');

% Remove variables that did not have at least 2 outcomes
% good_var=find(binary_struct~=0);
good_var=[1:5 8:9]; % this will eliminate 'other symptom' from the model
binary_hx=binary_hx(:,good_var);
binary_struct=binary_struct(good_var,:);
variables=variables(good_var,:);

% concatonate each subjects binary outcomes
binary_Hx=NaN*ones(size(binary_hx,1),size(variables,1)*2);
temp=[];
for x=1:size(binary_hx,1)
    for y=1:size(binary_hx,2)
        temp=cat(2,temp,cell2mat(binary_hx(x,y)));
    end
    binary_Hx(x,:)=temp;
    temp=[];
end

% MCA was calculated using the following function that is publically available:
% Antonio Trujillo-Ortiz (2021). Multiple Correspondence Analysis Based on the Indicator Matrix. 
% (https://www.mathworks.com/matlabcentral/fileexchange/22154-multiple-correspondence-analysis-based-on-the-indicator-matrix), 
% MATLAB Central File Exchange.

load MCAmodel_No_othsx092421_voms % File that contains MCA model

% Calculate MCA scores
MCA_no=2;
MCA_score=NaN*ones(size(binary_Hx,1),MCA_no);
for x=1:size(binary_Hx,1)
    for y=1:MCA_no
        temp1=binary_Hx(x,:);
        temp2=MCA_corr(:,y);
        r=temp1*temp2;
        MCA_score(x,y)=r;
    end
end

MCA_score = MCA_score.*-1;

clear binary*
%% Organize demographic data, PCSI, evoked symptoms, and VEP data into a table


% Create table of subject info and PCSI data

Tbl=table(subject_VOMS.uniqueID*-1,subject_VOMS.subjecttype,subject_VOMS.sex_master,subject_VOMS.race_ethn,subject_VOMS.age_at_visit,...
    subject_VOMS.med_hx___1,subject_VOMS.family_hx___1,subject_VOMS.conc_hx_yn,subject_VOMS.day_since_injury,subject_VOMS.teenPCSI_headache,...
    subject_VOMS.teenPCSI_nausea,subject_VOMS.teenPCSI_balance,subject_VOMS.teenPCSI_dizziness,subject_VOMS.teenPCSI_fatigue,...
    subject_VOMS.teenPCSI_sleepmore,subject_VOMS.teenPCSI_drowsiness,subject_VOMS.teenPCSI_senslight,subject_VOMS.teenPCSI_sensnoise,...
    subject_VOMS.teenPCSI_irritability,subject_VOMS.teenPCSI_sadness,subject_VOMS.teenPCSI_nervous,subject_VOMS.teenPCSI_emotional,...
    subject_VOMS.teenPCSI_slowed,subject_VOMS.teenPCSI_mentfoggy,subject_VOMS.teenPCSI_diffconc,subject_VOMS.teenPCSI_diffremem,...
    subject_VOMS.teenPCSI_visualprob,subject_VOMS.teenPCSI_confused,subject_VOMS.teenPCSI_clumsy,subject_VOMS.teenPCSI_answslow,...
    subject_VOMS.teenPCSI_different,subject_VOMS.PCSIc_total,subject_VOMS.vep_symp_type___1,subject_VOMS.vep_symp_type___3,...
    subject_VOMS.vep_symp_type___4,subject_VOMS.vep_symp_type___5,subject_VOMS.vep_symp_type___2,subject_VOMS.vep_physigns_type___1,...
    subject_VOMS.vep_physigns_type___2,subject_VOMS.vep_physigns_type___3,MCA_score(:,1),MCA_score(:,2),...
    'VariableNames',{'Subject','Type','Sex','Race_Ethnicity','Age','Migraine_Hx','Migraine_FamHx',...
    'ConcussionHistory','DaysPostInjury','Headache','Nausea','Balance','Dizziness','Fatigue','SleepMore','Drowsiness','LightSensitivity',...
    'SoundSensitivity','Irritability','Sadness','Nervous','Emotional','Slowed','MentallyFoggy','DifferentConcentration','DifferentRemembering',...
    'VisualProblems','Confused','Clumsy','AnswerSlow','Different','PCSI_score_total','EyeFatigue','eDizziness','eHeadache','eNausea','EyePain',...
    'EyesSlowing','EyesWatering','EyesReddening','MCAsxPresent','MCAsxEyeBrain'});

VOMS_Tbl=table(subject_VOMS.uniqueID*-1,subject_VOMS.ce_pursuits_reps,subject_VOMS.ce_horsacc_reps,subject_VOMS.ce_vertsacc_reps,...
    subject_VOMS.ce_horvor_reps,subject_VOMS.ce_vertvor_reps,subject_VOMS.ce_vms_reps,subject_VOMS.ce_npc_break,...
    'VariableNames',{'Subject','pursuitsReps','HorSacReps','VertSacReps','HorVorReps','VertVorReps','VMS_reps','npcBreak'});


Tbl.TypeBinary=ones(size(Tbl,1),1);
Tbl.TypeBinary(Tbl.Type=='Case')=2;

Tbl.MCAtype = zeros(size(Tbl,1),1);
Tbl.MCAtype(Tbl.MCAsxPresent>-1 & Tbl.MCAsxEyeBrain<0.1) = 1;
Tbl.MCAtype(Tbl.MCAsxPresent>-1 & Tbl.MCAsxEyeBrain>=0.1) = 2;

Tbl.MCAtype2 = 2*ones(size(Tbl,1),1);
Tbl.MCAtype2(Tbl.MCAsxPresent>-1 & Tbl.MCAsxEyeBrain<0.1) = 1;
Tbl.MCAtype2(Tbl.MCAsxPresent>-1 & Tbl.MCAsxEyeBrain>=0.1) = 0;

% Remove invalid numbers 
VOMS_Tbl.VMS_reps(VOMS_Tbl.VMS_reps ==-999) = NaN;
VOMS_Tbl.npcBreak(VOMS_Tbl.npcBreak ==-999) = NaN;
VOMS_Tbl.pursuitsReps(VOMS_Tbl.pursuitsReps>5) = 5; % one subject performed 10 repetitions

%% Plotting


% Compare total PCSI and MCA in cases vs. controls
subplot(1,3,1)
hold on
plot(Tbl.MCAsxPresent(Tbl.Type=='Case'),Tbl.MCAsxEyeBrain(Tbl.Type=='Case'),'or','MarkerFaceColor','r','MarkerSize',6)
plot(Tbl.MCAsxPresent(Tbl.Type=='Control'),Tbl.MCAsxEyeBrain(Tbl.Type=='Control'),'ob','MarkerFaceColor','b','MarkerSize',6)
plot([-2 6],[0 0],'--b')
plot([0 0],[-4 6],'--b')
MCA1_case = calc95Boot(Tbl.MCAsxPresent(Tbl.Type=='Case'),1);
MCA1_control = calc95Boot(Tbl.MCAsxPresent(Tbl.Type=='Control'),1);
MCA2_case = calc95Boot(Tbl.MCAsxEyeBrain(Tbl.Type=='Case'),1);
MCA2_control = calc95Boot(Tbl.MCAsxEyeBrain(Tbl.Type=='Control'),1);
errorbar(MCA1_case(2,:),MCA2_case(2,:),abs(diff(MCA2_case(1:2,:))),abs(diff(MCA2_case(2:3,:))),abs(diff(MCA1_case(1:2,:))),abs(diff(MCA1_case(2:3,:))),'or','MarkerFaceColor','r')
errorbar(MCA1_control(2,:),MCA2_control(2,:),abs(diff(MCA2_control(1:2,:))),abs(diff(MCA2_control(2:3,:))),abs(diff(MCA1_control(1:2,:))),abs(diff(MCA1_control(2:3,:))),'ob','MarkerFaceColor','b')
ax = gca; ax.TickDir = 'out'; ax.Box = 'off';

subplot(1,3,2)
hold on
bins = -2:0.5:6;
histogram(Tbl.MCAsxPresent(Tbl.Type=='Case'),bins,'Normalization','probability')
histogram(Tbl.MCAsxPresent(Tbl.Type=='Control'),bins,'Normalization','probability')
title('Dimension 1')
ax = gca; ax.TickDir = 'out'; ax.Box = 'off';

subplot(1,3,3)
hold on
bins = -4:0.5:6;
histogram(Tbl.MCAsxEyeBrain(Tbl.Type=='Case'),bins,'Normalization','probability')
histogram(Tbl.MCAsxEyeBrain(Tbl.Type=='Control'),bins,'Normalization','probability')
title('Dimension 2')
ax = gca; ax.TickDir = 'out'; ax.Box = 'off';

%% Create a table with demographic info for case/controls and by MCA categories
Tbl_demographics = conc_demo(Tbl);
[Tbl_demographics2, PCSI_Case_stats] = conc_demo2(Tbl);
multcompare(PCSI_Case_stats);
Tbl_demographics_case = conc_demo4(Tbl(Tbl.Type == 'Case',:));
Tbl_demographics_control = conc_demo4(Tbl(Tbl.Type == 'Control',:));

%% VOMS repetitions plot and statistics
VOMS_demo(VOMS_Tbl,Tbl);





