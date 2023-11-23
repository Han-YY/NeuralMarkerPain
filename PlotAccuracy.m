accuracyData = num_lengthAccuracy;
weights = 10:10:100;

plot(weights,accuracyData(1,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','s','Color',[0 0.4470 0.7410])
hold on
plot(weights,accuracyData(2,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-.','Marker','o','Color',[0.9290 0.6940 0.1250])
hold on
plot(weights,accuracyData(3,:)*100,'LineWidth',1.5,'Color','k','LineStyle','--','Marker','^','Color',[0.4660 0.6740 0.1880])
hold on
plot(weights,accuracyData(4,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','s','Color',[0.9290 0.6940 0.1250])
hold on
plot(weights,accuracyData(5,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-.','Marker','o','Color',[0.4660 0.6740 0.1880])
hold on
plot(weights,accuracyData(6,:)*100,'LineWidth',1.5,'Color','k','LineStyle','--','Marker','^','Color',[0 0.4470 0.7410])
hold on
legend('OvsC','OvsH','OvsW','CvsH','CvsW','HvsW','Location','best')
xlabel('Feature Number','FontWeight','Bold')
ylabel('Prediction Accuracy (%)','FontWeight','Bold')
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

set(gca,'DefaultTextFontSize',18)
