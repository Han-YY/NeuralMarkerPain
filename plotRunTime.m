% Read time data and reorganize them

% Reorganize the data to fit the catplot function
folder = ("C:\Users\yh19218\OneDrive - University of Essex\OneDrive - University of Essex\PG Research\0A_Journal\202004_unknown Journal_Probability Score\1_Results\0_Final Results\TimeNew\");
classes = ['OvsC';'HvsW';'OvsH';'OvsW';'CvsH';'CvsW'];
timeLengthLabel = {'1';'2.5';'5';'10'};
timeLength = [1 2.5 5 10];
mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
featureNumber = (1:5)*20;

xs=.4/4; %the best half width for a 'group or catagory' is .4 and there are 4 big states
width=xs*.85;% width of each box with a small gap between subgroups
sgxs=[-0.3 -0.1 0.1 0.3];% SubGroups X Shift (twice the half width)
cc={[0.2 0.2 0.2],[0.4 0.4 0.4],[.6 .6 .6], [.8 .8 .8]};% subgroups color (blue orange red)


XTickLabels = {'Phase Connectivity','Power Connectivity','Phase CFC','Power CFC'};
XTick = {'AN','ON','AF','OF'};
TimeAll = [];
close all
figure
for numIndex = 1:5
    subplot(5,1,numIndex)
    featureNum0 = featureNumber(numIndex);
    title(strcat(num2str(featureNum0),' features'));
    for featureNum=1:4
        
        for lengthIndex=1:4

            filename = strcat(folder,'TimeTotal',mainfolderlist{lengthIndex},'.xlsx');
            trainname = strcat(folder,'TimeFeature',mainfolderlist{lengthIndex},'.xlsx');
           timeData = readmatrix(filename,'Sheet',strcat('Sheet',num2str(featureNum0/10))) + readmatrix(trainname,'Sheet',strcat('Sheet',num2str(featureNum0/10)));
%             timeData = readmatrix(filename,'Sheet',strcat('Sheet',num2str(featureNum0/10)));
            TimeAll = [TimeAll;timeData];
            timePlot =timeData(:,featureNum);
            h1{featureNum}=whisker_boxplot(lengthIndex+sgxs(featureNum),log(timePlot), cc{featureNum},'width',width);

        end
    end
set(gca,'XTick',1:4,'XTickLabels',timeLengthLabel)

xlabel('Trial Length (sec)','FontWeight','bold','FontSize',6)
ylabel('ln(T)','FontWeight','bold','FontSize',6)
end

lgd = legend([h1{1}(1) h1{2}(1) h1{3}(1) h1{4}(1)],XTickLabels,'Orientation','horizontal');
title(lgd,'Feature Type')
set( findall(gcf, '-property', 'fontsize'), 'fontsize', 14)