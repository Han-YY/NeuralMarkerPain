% Plot the spent time
time_table = readmatrix('TimeCount0.xlsx','Sheet',3);
% time_table = time_table/ans;
feature_number = 10:10:100;
figure
plot(feature_number,time_table(1,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','s')
hold on
plot(feature_number,time_table(2,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-.','Marker','s')
hold on
plot(feature_number,time_table(3,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','o')
hold on
plot(feature_number,time_table(4,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-.','Marker','o')
hold on

xlabel('Number of features')
ylabel('Time (sec)')
legend('Alpha-phase Connectivity','Alpha-power Connectivity','Phase-based CFC','Power-based CFC')
fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', 14)

box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on
set(gca,'DefaultTextFontSize',18)