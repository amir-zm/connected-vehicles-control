%%
clc;
%close all;
ift_num = 9;
eq_check = ones(40,40);
for i = 1:ift_num
    if i<ift_num
        eq_check = eq_check.*double(Tag_CGs(:,:,i) == Tag_CGs(:,:,i+1));
    end
end
common_tag = Tag_CGs(:,:,1).*eq_check;
for bt = 1:40
    for kt = 1:40
        k = (kt-1)*0.5+0.1;
        b = (bt-1)*0.5+0.1;
        if common_tag(bt,kt) == 4
            % plot(k,b,'y.','MarkerSize',12);
            % hold on
        elseif common_tag(bt,kt) == 3
            % plot(k,b,'r.','MarkerSize',12);
            % hold on;
        elseif common_tag(bt,kt) == 2
            plot(k,b,'b.','MarkerSize',12);
            hold on;
        elseif common_tag(bt,kt) == 1
            plot(k,b,'g.','MarkerSize',12);
            hold on;
        else
        end
    end
end
% xlim([0 cgu_upper]);
% ylim([0,cgu_upper]);
% xlabel('k', 'Interpreter','latex');
% ylabel('b', 'Interpreter','latex');
% xticks([0 5 10 15 20]);
% xticklabels({'0','5','10','15','20'});
% set(gca, 'TickLabelInterpreter', 'Latex');
% set(gca,'FontSize',18);
% grid;
%title('Common Control Gains', 'Interpreter','latex','fontweight','bold','Fontsize',20);
NC_common_tag = double(common_tag == 1*ones(40,40))+double(common_tag == 2*ones(40,40));
save('common_CGs');
