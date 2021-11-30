function [Tbl_demographics] = conc_demo4(Tbl)
    
    sx_none = 100*length(Tbl.Type(Tbl.Sex == 1 & Tbl.MCAtype==0))./length(Tbl.Sex(Tbl.MCAtype==0));
    sx_eye = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.MCAtype==1))./length(Tbl.Sex(Tbl.MCAtype==1));
    sx_brain = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.MCAtype==2))./length(Tbl.Sex(Tbl.MCAtype==2));
    Nnone = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==0),1)) ' (' num2str(sx_none) '% Female)'];
    Neye = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==1),1)) ' (' num2str(sx_eye) '% Female)'];
    Nbrain = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==2),1)) ' (' num2str(sx_brain) '% Female)'];

    
    if length(unique(Tbl.MCAtype))>3
        sx_both = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.MCAtype==3))./length(Tbl.Sex(Tbl.MCAtype==3));
        Nboth = ['n = ' num2str(size(Tbl.Sex(Tbl.MCAtype==3),1)) ' (' num2str(sx_both) '% Female)'];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.Sex,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Nstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    age_none = Tbl.Age(Tbl.MCAtype==0);
    age_eye = Tbl.Age(Tbl.MCAtype==1);
    age_brain = Tbl.Age(Tbl.MCAtype==2);
    
    Anone = [num2str(median(age_none)) ' [' num2str(min(age_none)) ' - ' num2str(max(age_none)) ']'];
    Aeye = [num2str(median(age_eye)) ' [' num2str(min(age_eye)) ' - ' num2str(max(age_eye)) ']'];
    Abrain = [num2str(median(age_brain)) ' [' num2str(min(age_brain)) ' - ' num2str(max(age_brain)) ']'];
    
    if length(unique(Tbl.MCAtype))>3
        age_both = Tbl.Age(Tbl.MCAtype==3);
        Aboth = [num2str(median(age_both)) ' [' num2str(min(age_both)) ' - ' num2str(max(age_both)) ']'];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.Age,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Astats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];

    Per_none = 100*length(Tbl.Type(Tbl.MCAtype==0))./length(Tbl.Type);
    Per_eye = 100*length(Tbl.Type(Tbl.MCAtype==1))./length(Tbl.Type);
    Per_brain = 100*length(Tbl.Type(Tbl.MCAtype==2))./length(Tbl.Type);

    Cnone = ['N = ' num2str(size(Tbl.MCAtype(Tbl.MCAtype==0),1)) ' (' num2str(Per_none) '% '];
    Ceye = ['N = ' num2str(size(Tbl.MCAtype(Tbl.MCAtype==1),1)) ' (' num2str(Per_eye) '% '];
    Cbrain = ['N = ' num2str(size(Tbl.MCAtype(Tbl.MCAtype==2),1)) ' (' num2str(Per_brain) '% '];
    
    if length(unique(Tbl.MCAtype))>3
        Per_both = 100*length(Tbl.Type(Tbl.MCAtype==3))./length(Tbl.Type);
        Cboth = ['N = ' num2str(size(Tbl.MCAtype(Tbl.MCAtype==3),1)) ' (' num2str(Per_both) '% '];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.TypeBinary,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Cstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    if ~isempty(Tbl(Tbl.Type=='Case',:))
        dayspost_none = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==0);
        dayspost_eye = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==1);
        dayspost_brain = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==2);
        
        Dnone = [num2str(median(dayspost_none)) ' [' num2str(min(dayspost_none)) ' - ' num2str(max(dayspost_none)) ']'];
        Deye = [num2str(median(dayspost_eye)) ' [' num2str(min(dayspost_eye)) ' - ' num2str(max(dayspost_eye)) ']'];
        Dbrain = [num2str(median(dayspost_brain)) ' [' num2str(min(dayspost_brain)) ' - ' num2str(max(dayspost_brain)) ']'];
        
        if length(unique(Tbl.MCAtype))>3
            dayspost_both = Tbl.DaysPostInjury(Tbl.Type=='Case' & Tbl.MCAtype==3);
            Dboth = [num2str(median(dayspost_both)) ' [' num2str(min(dayspost_both)) ' - ' num2str(max(dayspost_both)) ']'];
        end
        
        [p,tbl,~] = kruskalwallis(Tbl.DaysPostInjury,Tbl.MCAtype,'off');
        chi = cell2mat(tbl(2,5));
        Dstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    else
        Dnone = '--';
        Deye = '--';
        Dbrain = '--';
        if length(unique(Tbl.MCAtype))>3
            Dboth = '--';
        end
        Dstats = '--';
    end
    
    Mhx_none = 100*length(Tbl.Type(Tbl.Migraine_Hx==1 & Tbl.MCAtype==0))./length(Tbl.Migraine_Hx(Tbl.MCAtype==0));
    Mhx_eye = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx==1 & Tbl.MCAtype==1))./length(Tbl.Migraine_Hx(Tbl.MCAtype==1));
    Mhx_brain = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx==1 & Tbl.MCAtype==2))./length(Tbl.Migraine_Hx(Tbl.MCAtype==2));
    
    Mnone = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==0 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_none) '%)'];
    Meye = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==1 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_eye) '%)'];
    Mbrain = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==2 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_brain) '%)'];
    
    if length(unique(Tbl.MCAtype))>3
        Mhx_both = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx==1 & Tbl.MCAtype==3))./length(Tbl.Migraine_Hx(Tbl.MCAtype==3));
        Mboth = [num2str(size(Tbl.Migraine_Hx(Tbl.MCAtype==3 & Tbl.Migraine_Hx==1),1)) ' (' num2str(Mhx_both) '%)'];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_Hx,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    Mstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    MFhx_none = 100*length(Tbl.Type(Tbl.Migraine_FamHx == 1 & Tbl.MCAtype==0))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==0));
    MFhx_eye = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx==1 & Tbl.MCAtype==1))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==1));
    MFhx_brain = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx==1 & Tbl.MCAtype==2))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==2));

    MFnone = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==0 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_none) '%)'];
    MFeye = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==1 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_eye) '%)'];
    MFbrain = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==2 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_brain) '%)'];
    if length(unique(Tbl.MCAtype))>3
        MFhx_both = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx==1 & Tbl.MCAtype==3))./length(Tbl.Migraine_FamHx(Tbl.MCAtype==3));
        MFboth = [num2str(size(Tbl.Migraine_FamHx(Tbl.MCAtype==3 & Tbl.Migraine_FamHx==1),1)) ' (' num2str(MFhx_both) '%)'];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_FamHx,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    MFstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    Chx_none = 100*length(Tbl.Type(Tbl.ConcussionHistory == 1 & Tbl.MCAtype==0))./length(Tbl.ConcussionHistory(Tbl.MCAtype==0));
    Chx_eye = 100*length(Tbl.ConcussionHistory(Tbl.ConcussionHistory==1 & Tbl.MCAtype==1))./length(Tbl.ConcussionHistory(Tbl.MCAtype==1));
    Chx_brain = 100*length(Tbl.ConcussionHistory(Tbl.ConcussionHistory==1 & Tbl.MCAtype==2))./length(Tbl.ConcussionHistory(Tbl.MCAtype==2));
    
    CHnone = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==0 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_none) '%)'];
    CHeye = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==1 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_eye) '%)'];
    CHbrain = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==2 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_brain) '%)'];
    if length(unique(Tbl.MCAtype))>3
        Chx_both = 100*length(Tbl.ConcussionHistory(Tbl.ConcussionHistory==1 & Tbl.MCAtype==3))./length(Tbl.ConcussionHistory(Tbl.MCAtype==3));
        CHboth = [num2str(size(Tbl.ConcussionHistory(Tbl.MCAtype==3 & Tbl.ConcussionHistory==1),1)) ' (' num2str(Chx_both) '%)'];
    end
    
    [p,tbl,~] = kruskalwallis(Tbl.ConcussionHistory,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    CHstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    [p,tbl,~] = kruskalwallis(Tbl.PCSI_score_total,Tbl.MCAtype,'off');
    chi = cell2mat(tbl(2,5));
    PCSI_stats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    
    
    
    % Create figure
    figure
    subplot(3,3,1)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    
    if length(unique(Tbl.MCAtype))>3
        bar(1:4,[sx_none sx_eye sx_brain sx_both])
    else
        bar(1:3,[sx_none sx_eye sx_brain])
    end
    title(Nstats)
    ylabel('% Female')
    
    subplot(3,3,2)
    hold on
    none = calc95Boot(Tbl.Age(Tbl.MCAtype==0),2);
    eye = calc95Boot(Tbl.Age(Tbl.MCAtype==1),2);
    if length(Tbl.Age(Tbl.MCAtype==2))>1
        brain = calc95Boot(Tbl.Age(Tbl.MCAtype==2),2);
    else
        brain = [Tbl.Age(Tbl.MCAtype==2);Tbl.Age(Tbl.MCAtype==2);Tbl.Age(Tbl.MCAtype==2)];
    end
    errorbar(1,none(2,:),abs(diff(none(1:2,:))),abs(diff(none(2:3,:))),'o','Color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
    errorbar(2,eye(2,:),abs(diff(eye(1:2,:))),abs(diff(eye(2:3,:))),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])
    errorbar(3,brain(2,:),abs(diff(brain(1:2,:))),abs(diff(brain(2:3,:))),'o','Color',[0.1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 0.1])
    if length(unique(Tbl.MCAtype))>3
        both = calc95Boot(Tbl.Age(Tbl.MCAtype==3),2);
        errorbar(4,both(2,:),abs(diff(both(1:2,:))),abs(diff(both(2:3,:))),'o','Color',[0 0 0],'MarkerFaceColor',[0 0 0])
    end
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    title(Astats)
    ylabel('Age [years]')
    
    
    subplot(3,3,4)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    if length(unique(Tbl.MCAtype))>3
        bar(1:4,[Mhx_none Mhx_eye Mhx_brain Mhx_both])
    else
        bar(1:3,[Mhx_none Mhx_eye Mhx_brain])
    end
    title(Mstats)
    ylabel('% History of migraine')
    
    subplot(3,3,5)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    if length(unique(Tbl.MCAtype))>3
        bar(1:4,[MFhx_none MFhx_eye MFhx_brain MFhx_both])
    else
        bar(1:3,[MFhx_none MFhx_eye MFhx_brain])
    end
    title(MFstats)
    ylabel('% Family history of migraine')
    
    subplot(3,3,6)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    if length(unique(Tbl.MCAtype))>3
        bar(1:4,[Chx_none Chx_eye Chx_brain Chx_both])
    else
        bar(1:3,[Chx_none Chx_eye Chx_brain])
    end
    title(CHstats)
    ylabel('% History of concussion')
    
    subplot(3,3,7)
    hold on
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    if length(unique(Tbl.MCAtype))>3
        bar(1:4,[Per_none Per_eye Per_brain Per_both])
    else
        bar(1:3,[Per_none Per_eye Per_brain])
    end
    title(Cstats)
    ylabel('% Subjects')
    
if ~isempty(Tbl(Tbl.Type=='Case',:))    
    subplot(3,3,8)
    hold on
    none = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==0 & Tbl.Type=='Case'),2);
    eye = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==1 & Tbl.Type=='Case'),2);
    brain = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==2 & Tbl.Type=='Case'),2);
    
    errorbar(1,none(2,:),abs(diff(none(1:2,:))),abs(diff(none(2:3,:))),'o','Color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
    errorbar(2,eye(2,:),abs(diff(eye(1:2,:))),abs(diff(eye(2:3,:))),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])
    errorbar(3,brain(2,:),abs(diff(brain(1:2,:))),abs(diff(brain(2:3,:))),'o','Color',[0.1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 0.1])
    
    if length(unique(Tbl.MCAtype))>3
        both = calc95Boot(Tbl.DaysPostInjury(Tbl.MCAtype==3 & Tbl.Type=='Case'),2);
        errorbar(4,both(2,:),abs(diff(both(1:2,:))),abs(diff(both(2:3,:))),'o','Color',[0 0 0],'MarkerFaceColor',[0 0 0])
    end
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    title(Dstats)
    ylabel('Days post injury')
end
    
    subplot(3,3,9)
    hold on
    nonePCSI = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==0),2);
    eyePCSI = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==1),2);
    if length(Tbl.Type(Tbl.MCAtype==2))>1
        brainPCSI = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==2),2);
    else
        brainPCSI = [Tbl.PCSI_score_total(Tbl.MCAtype==2);Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control');Tbl.PCSI_score_total(Tbl.MCAtype==2 & Tbl.Type=='Control')];
    end
    
    
    errorbar(0.8,nonePCSI(2,:),abs(diff(nonePCSI(1:2,:))),abs(diff(nonePCSI(2:3,:))),'o','Color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7])
    errorbar(1.8,eyePCSI(2,:),abs(diff(eyePCSI(1:2,:))),abs(diff(eyePCSI(2:3,:))),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])
    errorbar(2.8,brainPCSI(2,:),abs(diff(brainPCSI(1:2,:))),abs(diff(brainPCSI(2:3,:))),'o','Color',[0.1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 0.1])
    if length(unique(Tbl.MCAtype))>3
        bothPCSI = calc95Boot(Tbl.PCSI_score_total(Tbl.MCAtype==3),2);
        errorbar(3.8,bothPCSI(2,:),abs(diff(bothPCSI(1:2,:))),abs(diff(bothPCSI(2:3,:))),'o','Color',[0 0 0],'MarkerFaceColor',[0 0 0])
    end
    ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XLim = [0 5];
    title(PCSI_stats)
    ylabel('PCSI score total')
    
    PCSInone = [num2str(nonePCSI(2,:)) ' [' num2str(nonePCSI(1,:)) ' - ' num2str(nonePCSI(3,:)) '] '];
    PCSIeye = [num2str(eyePCSI(2,:)) ' [' num2str(eyePCSI(1,:)) ' - ' num2str(eyePCSI(3,:)) '] '];
    PCSIbrain = [num2str(brainPCSI(2,:)) ' [' num2str(brainPCSI(1,:)) ' - ' num2str(brainPCSI(3,:)) '] '];
    if length(unique(Tbl.MCAtype))>3
        PCSIboth = [num2str(bothPCSI(2,:)) ' [' num2str(bothPCSI(1,:)) ' - ' num2str(bothPCSI(3,:)) '] '];
    end
    PCSIstats = PCSI_stats;
    
    NoSymptoms = {Nnone;Anone;Cnone;Dnone;Mnone;MFnone;CHnone;PCSInone};
    EyeSymptoms = {Neye;Aeye;Ceye;Deye;Meye;MFeye;CHeye;PCSIeye};
    BrainSymptoms = {Nbrain;Abrain;Cbrain;Dbrain;Mbrain;MFbrain;CHbrain;PCSIbrain};
    if length(unique(Tbl.MCAtype))>3
        BothSymptoms = {Nboth;Aboth;Cboth;Dboth;Mboth;MFboth;CHboth;PCSIboth};
        Stats = {Nstats;Astats;Cstats;Dstats;Mstats;MFstats;CHstats;PCSIstats};
        Tbl_demographics = table(NoSymptoms,EyeSymptoms,BrainSymptoms,BothSymptoms,Stats,'RowNames',{'Subjects';'Age';'Control vs. Case';'Days post injury';'Migraine history'; 'Migraine family history'; 'Concussion history';'PCSI total'});
    else
        Stats = {Nstats;Astats;Cstats;Dstats;Mstats;MFstats;CHstats;PCSIstats};
        Tbl_demographics = table(NoSymptoms,EyeSymptoms,BrainSymptoms,Stats,'RowNames',{'Subjects';'Age';'Control vs. Case';'Days post injury';'Migraine history'; 'Migraine family history'; 'Concussion history';'PCSI total'});
    end
    
    
    
    % Create table
    figure
    TString = evalc('disp(Tbl_demographics)');
    TString = strrep(TString,'<strong>','\bf');
    TString = strrep(TString,'</strong>','\rm');
    TString = strrep(TString,'_','\_');
    FixedWidth = get(0,'FixedWidthFontName');
    annotation(gcf,'Textbox','String',TString,'Interpreter','Tex','FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
   
end
