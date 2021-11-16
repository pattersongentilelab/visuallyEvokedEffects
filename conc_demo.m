function [Tbl_demographics] = conc_demo(Tbl)

    sx_control = 100*length(Tbl.Type(Tbl.Sex == 1 & Tbl.Type=='Control'))./length(Tbl.Sex(Tbl.Type=='Control'));
    sx_case = 100*length(Tbl.Sex(Tbl.Sex == 1 & Tbl.Type=='Case'))./length(Tbl.Sex(Tbl.Type=='Case'));
    Ncontrol = ['n = ' num2str(size(Tbl.Sex(Tbl.Type=='Control'),1)) ' (' num2str(sx_control) '% Female)'];
    Ncase = ['n = ' num2str(size(Tbl.Sex(Tbl.Type=='Case'),1)) ' (' num2str(sx_case) '% Female)'];
    [p,tbl,~] = kruskalwallis(Tbl.Sex,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    Nstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    age_control = Tbl.Age(Tbl.Type=='Control');
    age_case = Tbl.Age(Tbl.Type=='Case');
    Acontrol = [num2str(mean(age_control)) ' [' num2str(min(age_control)) ' - ' num2str(max(age_control)) ']'];
    Acase = [num2str(mean(age_case)) ' [' num2str(min(age_case)) ' - ' num2str(max(age_case)) ']'];
    [~,p] = ttest2(Tbl.Age(Tbl.Type=='Control'),Tbl.Age(Tbl.Type=='Case'));
    Astats = ['p = ' num2str(p)];

    dayspost_case = Tbl.DaysPostInjury(Tbl.Type=='Case');
    Dcontrol = '--';
    Dcase = [num2str(mean(dayspost_case)) ' [' num2str(min(dayspost_case)) ' - ' num2str(max(dayspost_case)) ']'];
    Dstats = '--';

    Mhx_control = 100*length(Tbl.Type(Tbl.Migraine_Hx == 1 & Tbl.Type=='Control'))./length(Tbl.Migraine_Hx(Tbl.Type=='Control'));
    Mhx_case = 100*length(Tbl.Migraine_Hx(Tbl.Migraine_Hx == 1 & Tbl.Type=='Case'))./length(Tbl.Migraine_Hx(Tbl.Type=='Case'));
    Mcontrol = [num2str(size(Tbl.Migraine_Hx(Tbl.Type=='Control' & Tbl.Migraine_Hx == 1),1)) ' (' num2str(Mhx_control) '%)'];
    Mcase = [num2str(size(Tbl.Migraine_Hx(Tbl.Type=='Case' & Tbl.Migraine_Hx == 1),1)) ' (' num2str(Mhx_case) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_Hx,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    Mstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];

    MFhx_control = 100*length(Tbl.Type(Tbl.Migraine_FamHx == 1 & Tbl.Type=='Control'))./length(Tbl.Migraine_FamHx(Tbl.Type=='Control'));
    MFhx_case = 100*length(Tbl.Migraine_FamHx(Tbl.Migraine_FamHx == 1 & Tbl.Type=='Case'))./length(Tbl.Migraine_FamHx(Tbl.Type=='Case'));
    MFcontrol = [num2str(size(Tbl.Migraine_FamHx(Tbl.Type=='Control' & Tbl.Migraine_FamHx == 1),1)) ' (' num2str(MFhx_control) '%)'];
    MFcase = [num2str(size(Tbl.Migraine_FamHx(Tbl.Type=='Case' & Tbl.Migraine_FamHx == 1),1)) ' (' num2str(MFhx_case) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.Migraine_FamHx,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    MFstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    W_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 1),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 1),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    B_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 2),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 2),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    H_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 3),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 3),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    A_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 4),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 4),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    Mo_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 5),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 5),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    Oth_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 6),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & Tbl.Race_Ethnicity == 6),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    NR_control = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & isnan(Tbl.Race_Ethnicity)),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Control' & isnan(Tbl.Race_Ethnicity)),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Control'),1)) '%)'];
    
    W_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 1),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 1),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    B_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 2),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 2),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    H_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 3),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 3),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    A_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 4),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 4),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    Mo_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 5),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 5),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    Oth_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 6),1)) ' (' num2str(100*size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & Tbl.Race_Ethnicity == 6),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    NR_case = [num2str(size(Tbl.Race_Ethnicity(Tbl.Type=='Case' & isnan(Tbl.Race_Ethnicity)),1)) ' (' num2str(size(100*Tbl.Race_Ethnicity(Tbl.Type=='Case' & isnan(Tbl.Race_Ethnicity)),1)./size(Tbl.Race_Ethnicity(Tbl.Type=='Case'),1)) '%)'];
    
    [p,tbl,~] = kruskalwallis(Tbl.Race_Ethnicity,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    REstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    CHcontrol = [num2str(size(Tbl.ConcussionHistory(Tbl.Type=='Control' & Tbl.ConcussionHistory==1),1)) ' (' num2str(100*size(Tbl.ConcussionHistory(Tbl.Type=='Control' & Tbl.ConcussionHistory==1),1)./size(Tbl.ConcussionHistory(Tbl.Type=='Control'),1)) '%)'];
    CHcase = [num2str(size(Tbl.ConcussionHistory(Tbl.Type=='Case' & Tbl.ConcussionHistory==1),1)) ' (' num2str(100*size(Tbl.ConcussionHistory(Tbl.Type=='Case' & Tbl.ConcussionHistory==1),1)./size(Tbl.ConcussionHistory(Tbl.Type=='Case'),1)) '%)'];
    [p,tbl,~] = kruskalwallis(Tbl.ConcussionHistory,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    CHstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    PCSI_control = Tbl.PCSI_score_total(Tbl.Type=='Control');
    PCSI_case = Tbl.PCSI_score_total(Tbl.Type=='Case');
    PCSI95_control = calc95Boot(PCSI_control,2); 
    PCSI95_case = calc95Boot(PCSI_case,2);
    PCSIcontrol = [num2str(PCSI95_control(2,:)) ' [' num2str(PCSI95_control(1,:)) ' - ' num2str(PCSI95_control(3,:)) ']'];
    PCSIcase = [num2str(PCSI95_case(2,:)) ' [' num2str(PCSI95_case(1,:)) ' - ' num2str(PCSI95_case(3,:)) ']'];
    [p,tbl,~] = kruskalwallis(Tbl.PCSI_score_total,Tbl.Type,'off');
    chi = cell2mat(tbl(2,5));
    PCSIstats = ['chi squared = ' num2str(chi) ', p = ' num2str(p)];
    
    Control = {Ncontrol;Acontrol;'--';W_control;B_control;H_control;A_control;Mo_control;Oth_control;NR_control;CHcontrol;Dcontrol;Mcontrol;MFcontrol;PCSIcontrol};
    Case = {Ncase;Acase;'--';W_case;B_case;H_case;A_case;Mo_case;Oth_case;NR_case;CHcase;Dcase;Mcase;MFcase;PCSIcase};
    Stats = {Nstats;Astats;REstats;'--';'--';'--';'--';'--';'--';'--';CHstats;Dstats;Mstats;MFstats;PCSIstats};
    
    
    Tbl_demographics = table(Control,Case,Stats,'RowNames',{'Subjects';'Age';'Race/ethnicity';'non Hispanic White';'non Hispanic Black';'Hispanic';...
        'non Hispanic Asian';'More than 1 race';'Other';'Not reported';'Concussion history';'Days post injury';'Migraine history'; 'Migraine family history';'Total_PCSI_score'});

    
    figure
    TString = evalc('disp(Tbl_demographics)');
    TString = strrep(TString,'<strong>','\bf');
    TString = strrep(TString,'</strong>','\rm');
    TString = strrep(TString,'_','\_');
    FixedWidth = get(0,'FixedWidthFontName');
    annotation(gcf,'Textbox','String',TString,'Interpreter','Tex','FontName',FixedWidth,'Units','Normalized','Position',[0 0 1 1]);
end
