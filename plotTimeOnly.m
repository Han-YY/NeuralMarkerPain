% Read time data and reorganize them

% Reorganize the data to fit the catplot function
folder = ("C:\Users\yh19218\OneDrive - University of Essex\OneDrive - University of Essex\PG Research\0A_Journal\202004_unknown Journal_Probability Score\1_Results\0_Final Results\TimeDT\");
classes = ['OvsC';'HvsW';'OvsH';'OvsW';'CvsH';'CvsW'];
timeLengthLabel = {'1';'2.5';'5';'10'};
timeLength = 10;
mainfolderlist = {'4_10s'};
featureNumber = (1:10)*10;

xs=.4/4; %the best half width for a 'group or catagory' is .4 and there are 4 big states
width=xs*.85;% width of each box with a small gap between subgroups
sgxs=[-0.3 -0.1 0.1 0.3];% SubGroups X Shift (twice the half width)
cc={[0.1 0.1 0.1],[0.2 0.2 0.2],[.3 .3 .3], [.4 .4 .4], [.5 .5 .5]};% subgroups color (blue orange red)
TimeAll = [];
for numIndex = 2:2:10
    
    featureNum0 = featureNumber(numIndex);
    featureNum=4;

    lengthIndex=1;

    filename = strcat(folder,'TimeClass',mainfolderlist{lengthIndex},'.xlsx');
    trainname = strcat(folder,'TimeFeature',mainfolderlist{lengthIndex},'.xlsx');
    timeData = readmatrix(filename,'Sheet',strcat('Sheet',num2str(featureNum0/10))) + readmatrix(trainname,'Sheet',strcat('Sheet',num2str(featureNum0/10)));
    TimeAll = [TimeAll timeData(:,featureNum)];
%     timePlot =timeData(:,featureNum);
        
    

end

XTickLabels={20, 40, 60, 80, 100};
xs=0.25; %the best half width for a 'group or catagory' is .4 and there are 4 big states
sgxs=[-0.5, -0.25, 0.0, 0.25, 0.5];% SubGroups X Shift (twice the half width); %the best half width for a 'group or catagory' is .4 and there are 2 subgroups (male/female)
width=xs*0.5;% width of each box with a small gap between subgroups

adjusted_boxplot(1:5, TimeAll, cc);
xlabel('Feature Number','FontWeight','bold','FontSize',6)
ylabel('Time Cost (sec)','FontWeight','bold','FontSize',6)
set(gca,'XTick',1:5,'XTickLabels',XTickLabels)
xticklabels(XTickLabels)

set( findall(gcf, '-property', 'fontsize'), 'fontsize', 14)