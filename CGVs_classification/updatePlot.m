function updatePlot(x)
    ifts = {'PF', 'MPF', 'TPFL', 'PFL', 'TPF', 'BDL', 'BD', 'TBD', 'TPSF', 'SPTF'};
    hold on;
    cgu_upper = x(7);
    if x(4)
        plot(x(1),x(2),'r.','MarkerSize',12);
        drawnow('limitrate');
        hold on;
        if x(1) == 19.6 && x(2) == 19.6
            xlim([0 cgu_upper]);
            ylim([0, cgu_upper]);
            xlabel('k', 'Interpreter','latex');
            ylabel('b', 'Interpreter','latex');
            xticks([0 5 10 15 20]);
            xticklabels({'0','5','10','15','20'});
            set(gca, 'TickLabelInterpreter', 'Latex');
            set(gca, 'FontSize',18);
            title(ifts{x(5)}, 'Interpreter','latex','fontweight','bold','Fontsize',20);
        end
    elseif x(3)
        plot(x(1),x(2),'b.','MarkerSize',12);
        drawnow('limitrate');
        hold on;
        if x(1) == 19.6 && x(2) == 19.6
            xlim([0 cgu_upper]);
            ylim([0, cgu_upper]);
            xlabel('k', 'Interpreter','latex');
            ylabel('b', 'Interpreter','latex');
            xticks([0 5 10 15 20]);
            xticklabels({'0','5','10','15','20'});
            set(gca, 'TickLabelInterpreter', 'Latex');
            set(gca, 'FontSize',18);
            title(ifts{x(5)}, 'Interpreter','latex','fontweight','bold','Fontsize',20);   
        end
    else
        plot(x(1),x(2),'g.','MarkerSize',12);
        drawnow('limitrate');
        hold on;
        if x(1) == 19.6 && x(2) == 19.6
            xlim([0 cgu_upper]);
            ylim([0, cgu_upper]);
            grid;
            xlabel('k', 'Interpreter','latex');
            ylabel('b', 'Interpreter','latex');
            xticks([0 5 10 15 20]);
            xticklabels({'0','5','10','15','20'});
            set(gca, 'TickLabelInterpreter', 'Latex');
            set(gca, 'FontSize',18);
            title(ifts{x(5)}, 'Interpreter','latex','fontweight','bold','Fontsize',20);
        end
    end
end

