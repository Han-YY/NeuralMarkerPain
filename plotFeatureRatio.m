mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
mainfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_';
resultfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_tables/';
featureNum = {'10features','20features','30features','40features','50features','60features','70features','80features','90features','100features'};


classes = {'OvsC','OvsH','OvsW','CvsH','CvsW','HvsW'};

ratio_Feature = zeros(4,10);
tl = 4;
     

         for fn = 1:10%Feature Number
             %conf_length = zeros(4,4);
             
             
             folderpath1 = strcat(mainfolder,featureNum{fn},'/', mainfolderlist{tl},'/NumbersFeatures.xlsx');
             folderpath2 = strcat(mainfolder,featureNum{fn},'/', mainfolderlist{tl},'_Swap/NumbersFeatures.xlsx');
             
                 try
                     dataRead = [readmatrix(folderpath1);readmatrix(folderpath2)];
                 catch
                     dataRead = NaN(12,4);
                 end
             
             ratio_Feature(:,fn) = (mean(dataRead,1)/sum(mean(dataRead,1)))';
             
             
             %             for cm = 1:4%For cancelling the effects of NaN
             %                 currData = dataRead(:,cm+4);
             %             conf_length(nt,cm) = mean(currData(~isnan(currData)));
             %             end
             
         end

         %% Plot the ratios
         accuracyData = ratio_Feature;
weights = 10:10:100;
figure
plot(weights,accuracyData(1,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-','Marker','o')
hold on
plot(weights,accuracyData(2,:)*100,'LineWidth',1.5,'Color','k','LineStyle','--','Marker','o')
hold on
plot(weights,accuracyData(3,:)*100,'LineWidth',1.5,'Color','k','LineStyle','-.','Marker','o')
hold on
plot(weights,accuracyData(4,:)*100,'LineWidth',1.5,'Color','k','LineStyle',':','Marker','o')
hold on

legend('Phase Connectivity','Power Connectivity','Phase CFC','Power CFC')
xlabel('Number of features')
ylabel('Ratio of each feature (%)')
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
