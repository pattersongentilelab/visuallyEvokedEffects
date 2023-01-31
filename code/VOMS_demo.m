function [] = VOMS_demo(VOMS_Tbl,Tbl)

VOMS_var = {'pursuitsReps','HorSacReps','VertSacReps','HorVorReps','VertVorReps','VMS_reps','npcBreak'};
MCAcat = {'None','Eye sx','Brain sx','Both'};

    for x=1:length(VOMS_var)
        VOM = table2array(VOMS_Tbl(:,x+1));
        caseVOMS_none = VOM(Tbl.MCAtype==0 & Tbl.Type == 'Case');
        caseVOMS_eye = VOM(Tbl.MCAtype==1 & Tbl.Type == 'Case');
        caseVOMS_brain = VOM(Tbl.MCAtype==2 & Tbl.Type == 'Case');
        
        case_Vn = calc95boot(caseVOMS_none,1);
        case_Ve = calc95boot(caseVOMS_eye,1);
        case_Vbr = calc95boot(caseVOMS_brain,1);
        
        if unique(Tbl.MCAtype)>3
            caseVOMS_both = VOM(Tbl.MCAtype==3 & Tbl.Type == 'Case');
            case_Vbo = calc95boot(caseVOMS_both,1);
        end

        contVOMS_none = VOM(Tbl.MCAtype==0 & Tbl.Type == 'Control');
        contVOMS_eye = VOM(Tbl.MCAtype==1 & Tbl.Type == 'Control');
        contVOMS_br = VOM(Tbl.MCAtype==2 & Tbl.Type == 'Control');

        cont_Vn = calc95boot(contVOMS_none,1);
        cont_Ve = calc95boot(contVOMS_eye,1);
        cont_Vbr = [contVOMS_br;contVOMS_br;contVOMS_br];
        

        
        figure(101)
        [p,tbl,stats] = anovan(VOM,{Tbl.MCAtype, Tbl.Type},'model','interaction','varnames',{'MCAtype','controlVconc'});
        multcompare(stats,'Dimension',[1 2])
        format_spec = 'Effects F = %2.2g, p = %0.2g \n Concussion F = %2.2g, p = %0.2g \n Interaction F = %2.2g, p = %0.2g';
        stats = sprintf(format_spec,tbl{2,6},p(1),tbl{3,6},p(2),tbl{4,6},p(3));
        
    
        switch x
            case 1
                figure(100)
                subplot(2,3,1)
                hold on
                ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:length(MCAcat);
                ax.XTickLabel = MCAcat; ax.XLim = [0 3.9]; ax.YLim = [4 6];
                title('Smooth pursuit reps')
                xlabel(stats)
                errorbar(0.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
                errorbar(1.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
                plot(2.8,cont_Vbr(2,:),'x','Color',[1 0.1 0.1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(1.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
                errorbar(2.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
                errorbar(3.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                if unique(Tbl.MCAtype)>3
                    errorbar(4.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                end

            case 7
                figure(100)
                subplot(2,3,2)
                hold on
                ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:length(MCAcat);
                ax.XTickLabel = MCAcat; ax.XLim = [0 3.9]; ax.YLim = [2 10];
                title('Near point convergence')
                xlabel(stats)
                errorbar(0.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
                errorbar(1.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
                plot(2.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(1.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
                errorbar(2.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
                errorbar(3.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                if unique(Tbl.MCAtype)>3
                    errorbar(4.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                    ax.XLim = [0 5];
                end
            case 2
                figure(100)
                subplot(2,3,4)
                hold on
                ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:2:length(MCAcat)*2;
                ax.XTickLabel = MCAcat; ax.XLim = [0 6.5]; ax.YLim = [5 32];
                xlabel(stats)
                title('Saccade reps')
                errorbar(0.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[1 1 1])
                errorbar(2.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[1 1 1])
                plot(4.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(1.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 1 1])
                errorbar(3.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 1 1])
                errorbar(5.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 1 1])
                if unique(Tbl.MCAtype)>3
                    errorbar(7.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 1 1])
                    ax.XLim = [0 9];
                end
            case 3
                figure(100)
                ylabel(stats)
                errorbar(1.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
                errorbar(3.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
                plot(5.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(2.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
                errorbar(4.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
                errorbar(6.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                if unique(Tbl.MCAtype)>3
                    errorbar(8.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                    ax.XLim = [0 9];
                end
            case 4
                figure(100)
                subplot(2,3,5)
                hold on
                xlabel(stats)
                ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:2:length(MCAcat)*2;
                ax.XTickLabel = MCAcat; ax.XLim = [0 6.5]; ax.YLim = [5 32];
                title('VOR reps')
                errorbar(0.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[1 1 1])
                errorbar(2.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[1 1 1])
                plot(4.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(1.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 1 1])
                errorbar(3.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 1 1])
                errorbar(5.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 1 1])
                if unique(Tbl.MCAtype)>3
                    errorbar(7.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 1 1])
                    ax.XLim = [0 9];
                end
                
            case 5
                figure(100)
                ylabel(stats)
                errorbar(1.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
                errorbar(3.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
                plot(5.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(2.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
                errorbar(4.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
                errorbar(6.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                if unique(Tbl.MCAtype)>3
                    errorbar(8.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                    ax.XLim = [0 9];
                end

            case 6
                figure(100)
                subplot(2,3,6)
                hold on
                xlabel(stats)
                ax = gca; ax.TickDir = 'out'; ax.Box = 'off'; ax.XTick = 1:length(MCAcat);
                ax.XTickLabel = MCAcat; ax.XLim = [0 3.9]; ax.YLim = [3 6];
                title('VMS reps')
                errorbar(0.8,cont_Vn(2,:),abs(diff(cont_Vn(1:2,:))),abs(diff(cont_Vn(2:3,:))),'o','Color',[0.7 0.7 1],'MarkerFaceColor',[0.7 0.7 1])
                errorbar(1.8,cont_Ve(2,:),abs(diff(cont_Ve(1:2,:))),abs(diff(cont_Ve(2:3,:))),'o','Color',[0.4 0.4 1],'MarkerFaceColor',[0.4 0.4 1])
                plot(2.8,cont_Vbr(2,:),'x','Color',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1])

                errorbar(1.2,case_Vn(2,:),abs(diff(case_Vn(1:2,:))),abs(diff(case_Vn(2:3,:))),'o','Color',[1 0.7 0.7],'MarkerFaceColor',[1 0.7 0.7])
                errorbar(2.2,case_Ve(2,:),abs(diff(case_Ve(1:2,:))),abs(diff(case_Ve(2:3,:))),'o','Color',[1 0.4 0.4],'MarkerFaceColor',[1 0.4 0.4])
                errorbar(3.2,case_Vbr(2,:),abs(diff(case_Vbr(1:2,:))),abs(diff(case_Vbr(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                if unique(Tbl.MCAtype)>3
                    errorbar(4.2,case_Vbo(2,:),abs(diff(case_Vbo(1:2,:))),abs(diff(case_Vbo(2:3,:))),'o','Color',[1 0.1 0.1],'MarkerFaceColor',[1 0.1 0.1])
                    ax.XLim = [0 5];
                end
        end

    end
end
