% Reorganize the data to fit the catplot function
file = readtable("/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_tables/AccuracyData.xls");
accuracy = table2array(file(:,1));
length = table2array(file(:,2));
feature = table2array(file(:,3));
classification = table2array(file(:,4));
classes = ['OvsC';'HvsW';'OvsH';'OvsW';'CvsH';'CvsW'];
timeLengthLabel = {'1';'2.5';'5';'10'};
timeLength = [1 2.5 5 10];


xs=.4/6; %the best half width for a 'group or catagory' is .4 and there are 4 big states
width=xs*.85;% width of each box with a small gap between subgroups
sgxs=[-1 -0.6 -0.2 0.2 0.6 1]/2;% SubGroups X Shift (twice the half width)
cc={[40,71,92]/255, [74,108,116]/255, [139,166,147]/255, [240,227,192]/255};% subgroups color (blue orange red)


XTickLabels = 'Phase Connectivity';
XTick = {'OvsH';'OvsW';'CvsH';'CvsW'};
close all
figure
for ii=1:4
    lengthRefIndex = ismember(length,timeLength(ii));
for classIndex = 1:4
    
    class = classes(classIndex,:);
    
    classRefIndex = ismember(classification,class);
    featureClass = feature(classRefIndex);

    
    
        featureRefIndex = ismember(feature,XTickLabels);
        accuracyPlot = 100*accuracy(featureRefIndex&lengthRefIndex&classRefIndex);
        h1{ii}=whisker_boxplot(classIndex+sgxs(ii),accuracyPlot, cc{ii},'width',width);
    
end
set(gca,'XTick',1:4,'XTickLabels',XTick)
ylim([0 100])

xlabel('Binary Classification','FontWeight','bold')
ylabel('Prediction Accuracy (%)','FontWeight','bold')
end

lgd = legend([h1{1}(1) h1{2}(1) h1{3}(1) h1{4}(1)],timeLengthLabel);
set(lgd,'Units','normalized')
title(lgd,'Trial Length (s)')
set( findall(gcf, '-property', 'fontsize'), 'fontsize', 16)