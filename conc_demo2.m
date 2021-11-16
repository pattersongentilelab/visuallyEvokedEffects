function [Tbl_demographics,stats_PCSIcase] = conc_demo2(Tbl)
    
  sx_none = 100*length(Tbl.Type(Tbl.Sex == 1 & Tbl.MCAtype==0))./length(Tbl.Sex(Tbl.MCAtype==0));
    sx_eye = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.MCAtype==1))./length(Tbl.Sex(Tbl.MCAtype==1));
    sx_brain = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.MCAtype==2))./length(Tbl.Sex(Tbl.MCAtype==2));
    Nnone = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==0),1)) ' (' num2str(sx_none) '% Female)'];
    Neye = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==1),1)) ' (' num2str(sx_eye) '% Female)'];
    Nbrain = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==2),1)) ' (' num2str(sx_brain) '% Female)'];
    [p,tbl,~] = kruskalwallis(Tbl.Sex,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Nstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    age_none = Tbl.Age(Tbl.MCAtype==0);
    age_eye = Tbl.Age(Tbl.MCAtype==1);
    age_brain = Tbl.Age(Tbl.MCAtype==2);
    Anone = [num2str(mean(age_none)) ' [' num2str(min(age_none)) ' - ' num2str(max(age_none)) ']'];
    Aeye = [num2str(mean(age_eye)) ' [' num2str(min(age_eye)) ' - ' num2str(max(age_eye)) ']'];
    Abrain = [num2str(mean(age_brain)) ' [' num2str(min(age_brain)) ' - ' num2str(max(age_brain)) ']'];
    [p,tbl,~] = anova1(Tbl.Age,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Astats = ['F = ' num2str(chi) ', p = ' num2str(p)];

    Cont_none = 100*length(Tbl.Type(Tbl.MCAtype==0 & Tbl.Type=='Control'))./length(Tbl.Type(Tbl.Type=='Control'));
    Cont_eye = 100*length(Tbl.Type(Tbl.MCAtype==1 & Tbl.Type=='Control'))./length(Tbl.Type(Tbl.Type=='Control'));
    Cont_brain = 100*length(Tbl.Type(Tbl.MCAtype==2 & Tbl.Type=='Control'))./length(Tbl.Type(Tbl.Type=='Control'));
    Case_none = 100*length(Tbl.Type(Tbl.MCAtype==0 & Tbl.Type=='Case'))./length(Tbl.Type(Tbl.Type=='Case'));
    Case_eye = 100*length(Tbl.Type(Tbl.MCAtype==1 & Tbl.Type=='Case'))./length(Tbl.Type(Tbl.Type=='Case'));
    Case_brain = 100*length(Tbl.Type(Tbl.MCAtype==2 & Tbl.Type=='Case'))./length(Tbl.Type(Tbl.Type=='Case'));
    Cnone = ['Control = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Control' & Tbl.MCAtype==0),1)) ', Case = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Case' & Tbl.MCAtype==0),1)) ' (' num2str(Cont_none) '% Control; ' num2str(Case_none) '% Case)'];
    Ceye = ['Control = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Control' & Tbl.MCAtype==1),1)) ', Case = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Case' & Tbl.MCAtype==1),1)) ' (' num2str(Cont_eye) '% Control; ' num2str(Case_eye) '% Case)'];
    Cbrain = ['Control = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Control' & Tbl.MCAtype==2),1)) ', Case = ' num2str(size(Tbl.MCAtype(Tbl.Type=='Case' & Tbl.MCAtype==2),1)) ' (' num2str(Cont_brain) '% Control; ' num2str(Case_brain) '% Case)'];
    [p,tbl,~] = kruskalwallis(Tbl.TypeBinary,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Cstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    dayspost_none = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==0);
    dayspost_eye = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==1);
    dayspost_brain = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==2);
    Dnone = [num2str(mean(dayspost_none)) ' [' num2str(min(dayspost_none)) ' - ' num2str(max(dayspost_none)) ']'];
    Deye = [num2str(mean(dayspost_eye)) ' [' num2str(min(dayspost_eye)) ' - ' num2str(max(dayspost_eye)) ']'];
    Dbrain = [num2str(mean(dayspost_brain)) ' [' num2str(min(dayspost_brain)) ' - ' num2str(max(dayspost_brain)) ']'];
    [p,tbl,~] = anova1(Tbl.DaysPostInjury,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Dstats = ['F = ' num2str(chi) ', p = ' num2str(p)];
    
    Mhx_none = 100*length(Tbl.Type(Tbl.Migraine_Hx==1 & Tbl.MCAtype==0))./length(Tbl.Migraine_Hx(Tbl.MCAtype==0));
    Mhx_eye = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx==1 & Tbl.MCAtype==1))./length(Tbl.Migraine_Hx(Tbl.MCAtype==1));
    Mhx_brain = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx==1 & Tbl.MCAtype==2))./length(Tbl.Migraine_Hx(Tbl.MCAtype==2));
    Mnone = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==0 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_none) '%)'];
    Meye = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==1 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_eye) '%)'];
    Mbrain = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==2 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_brain) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_Hx,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Mstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    MFhx_none = 100*length(Tbl.Type(Tbl.Migraine_FamHx == 1 & Tbl.MCAtype==0))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==0));
    MFhx_eye = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx==1 & Tbl.MCAtype==1))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==1));
    MFhx_brain = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx==1 & Tbl.MCAtype==2))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==2));
    MFnone = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==0 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_none) '%)'];
    MFeye = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==1 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_eye) '%)'];
    MFbrain = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==2 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_brain) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_FamHx,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    MFstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    Chx_none = 100*length(Tbl.Type(Tbl.ConcussionHistory == 1 & Tbl.MCAtype==0))./length(Tbl.ConcussionHistory(Tbl.MCAtype==0));
    Chx_eye = 100*length(Tbl.ConcussionHistory(Tbl.ConcussionHistory==1 & Tbl.MCAtype==1))./length(Tbl.ConcussionHistory(Tbl.MCAtype==1));
    Chx_brain = 100*length(Tbl.ConcussionHistory(Tbl.ConcussionHistory==1 & Tbl.MCAtype==2))./length(Tbl.ConcussionHistory(Tbl.MCAtype==2));
    CHnone = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==0 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_none) '%)'];
    CHeye = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==1 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_eye) '%)'];
    CHbrain = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==2 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_brain) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.ConcussionHistory,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    CHstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    [p,tbl,~] = kruskalwallis(Tbl.PCSI_score_total(Tbl.Type=='Control'),Tbl.MCAtype(Tbl.Type=='Control'),'off');
    chi = cell2mat(tbl(2,5));
    PCSI_Control_stats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    [p,tbl,stats_PCSIcase] = kruskalwallis(Tbl.PCSI_score_total(Tbl.Type=='Case'),Tbl.MCAtype(Tbl.Type=='Case'),'off');
    chi = cell2mat(tbl(2,5));
    PCSI_Case_stats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    
    
    
    % Create figure
    figure
    subplot(3,3,1)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    bar(1:3,[sx_none sx_eye sx_brain])
    title(Nstats)
    ylabel('% Female')
    
    subplot(3,3,2)
    hold on
    none = calc95Boot(Tbl.Age(Tbl.MCAtype==0),1);
    eye = calc95Boot(Tbl.Age(Tbl.MCAtype==1),1);
    brain = calc95Boot(Tbl.Age(Tbl.MCAtype==2),1);
    errorbar(1,none(2,:),abs(diff(none(1:2,:))),abs(diff(none(2:3,:))),'o','Color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
    errorbar(2,eye(2,:),abs(diff(eye(1:2,:))),abs(diff(eye(2:3,:))),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])
    errorbar(3,brain(2,:),abs(diff(brain(1:2,:))),abs(diff(brain(2:3,:))),'o','Color',[0.1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 0.1])
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    title(Astats)
    ylabel('Age [years]')
    
    
    subplot(3,3,4)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    bar(1:3,[Mhx_none Mhx_eye Mhx_brain])
    title(Mstats)
    ylabel('% History of migraine')
    
    subplot(3,3,5)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    bar(1:3,[MFhx_none MFhx_eye MFhx_brain])
    title(MFstats)
    ylabel('% Family history of migraine')
    
    subplot(3,3,6)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    bar(1:3,[Chx_none Chx_eye Chx_brain])
    title(CHstats)
    ylabel('% History of concussion')
    
    subplot(3,3,7)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    bar(1:3,[Cont_none Cont_eye Cont_brain])
    bar(1:3,[Case_none Case_eye Case_brain])
    title(Cstats)
    ylabel('% of Subjects')
    
    
    subplot(3,3,8)
    hold on
    none = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==0 & Tbl.Type=='Case'),1);
    eye = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==1 & Tbl.Type=='Case'),1);
    brain = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==2 & Tbl.Type=='Case'),1);
    errorbar(1,none(2,:),abs(diff(none(1:2,:))),abs(diff(none(2:3,:))),'o','Color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
    errorbar(2,eye(2,:),abs(diff(eye(1:2,:))),abs(diff(eye(2:3,:))),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])
    errorbar(3,brain(2,:),abs(diff(brain(1:2,:))),abs(diff(brain(2:3,:))),'o','Color',[0.1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 0.1])

    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    title(Dstats)
    ylabel('Days post injury')
    
    subplot(3,3,9)
    hold on
    none_cont = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==0 & Tbl.Type=='Control'),2);
    eye_cont = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==1 & Tbl.Type=='Control'),2);
    if length(Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control'))>1
        brain_cont = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control'),2);
    else
        brain_cont = [Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control');Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control');Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control')];
    end
        
    
    none_case = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==0 & Tbl.Type=='Case'),2);
    eye_case = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==1 & Tbl.Type=='Case'),2);
    brain_case = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Case'),2);
    
    errorbar(0.8,none_cont(2,:),abs(diff(none_cont(1:2,:))),abs(diff(none_cont(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
    errorbar(1.8,eye_cont(2,:),abs(diff(eye_cont(1:2,:))),abs(diff(eye_cont(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
    errorbar(2.8,brain_cont(2,:),abs(diff(brain_cont(1:2,:))),abs(diff(brain_cont(2:3,:))),'o','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])
    
    errorbar(1.2,none_case(2,:),abs(diff(none_case(1:2,:))),abs(diff(none_case(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
    errorbar(2.2,eye_case(2,:),abs(diff(eye_case(1:2,:))),abs(diff(eye_case(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
    errorbar(3.2,brain_case(2,:),abs(diff(brain_case(1:2,:))),abs(diff(brain_case(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])

    
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 4];
    title(PCSI_Case_stats)
    xlabel(PCSI_Control_stats)
    ylabel('PCSI score total')
    
    PCSInone = ['Control = ' num2str(none_cont(2,:)) ' [' num2str(none_cont(1,:)) ' - ' num2str(none_cont(3,:)) '] ; Case = ' num2str(none_case(2,:)) ' [' num2str(none_case(1,:)) ' - ' num2str(none_case(3,:)) ']'];
    PCSIeye = ['Control = ' num2str(eye_cont(2,:)) ' [' num2str(eye_cont(1,:)) ' - ' num2str(eye_cont(3,:)) '] ; Case = ' num2str(eye_case(2,:)) ' [' num2str(eye_case(1,:)) ' - ' num2str(eye_case(3,:)) ']'];
    PCSIbrain = ['Control = ' num2str(brain_cont(2,:)) ' [' num2str(brain_cont(1,:)) ' - ' num2str(brain_cont(3,:)) '] ; Case = ' num2str(brain_case(2,:)) ' [' num2str(brain_case(1,:)) ' - ' num2str(brain_case(3,:)) ']'];
    PCSIstats = ['Control = ' PCSI_Control_stats '; Case = ' PCSI_Case_stats];
    
    NoSymptoms = {Nnone;Anone;Cnone;Dnone;Mnone;MFnone;CHnone;PCSInone};
    EyeSymptoms = {Neye;Aeye;Ceye;Deye;Meye;MFeye;CHeye;PCSIeye};
    BrainSymptoms = {Nbrain;Abrain;Cbrain;Dbrain;Mbrain;MFbrain;CHbrain;PCSIbrain};
    Stats = {Nstats;Astats;Cstats;Dstats;Mstats;MFstats;CHstats;PCSIstats};
    
    
    Tbl_demographics = table(NoSymptoms,EyeSymptoms,BrainSymptoms,Stats,'RowNames',{'Subjects';'Age';'Control vs. Case';'Days post injury';'Migraine history'; 'Migraine family history'; 'Concussion history';'PCSI total'});
    
    % Create table
    figure
    TString = evalc('disp(Tbl_demographics)');
    TString = strrep(TString,'<strong>','\bf');
    TString = strrep(TString,'</strong>','\rm');
    TString = strrep(TString,'_','\_');
    FixedWidth = get(0,'FixedWidthFontName');
    annotation(gcf,'Textbox','String',TString,'Interpreter','Tex','FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
end
