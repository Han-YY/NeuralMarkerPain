% written by Yiyuan Han, Essex BCI-NE Lab, 05/03/2020
% It's just a modified version of multiClassPar for CFC
% Multi-class classifiers for each participant based on the CFC as the
% selected features

%% Only remain the participants with complete data in all of 4 classes
classes = ['O' 'H' 'W' 'S'];
bands = [0.5 4;4 7.5;8 12;12.5 16] ;
classNum = length(classes);
parIndices = find((ismember(blockTagsAC(:,1),validParticipants))&(ismember(blockTagsAC(:,2),classes)));% Indices of the participants with all classes' data and only keep the 4 classes for classification
% Select 1000 samples randomly from all valid data for testing the
% classifier
if mode == 0
CFCdata = CFCdataISPC;
else
CFCdata = CFCdataCOH;
end
%CFCdata = (CFCdata-min(CFCdata(:)))/(max(CFCdata(:))-min(CFCdata(:)));

% classTrialsTrain = CFCdataTrain(:,parIndices);
% classtagsTrain = blockTagsACTrain(parIndices,:);

classTrials = CFCdata(:,parIndices);
classtags = blockTagsAC(parIndices,:);

%% Build a matrix to store all scores
classPredictions = zeros(size(classtags,1),7);% The first two columns are as same as them in classtags, the 3rd is the predicted classes, the 4th to the 7th are the probablity scores
classPredictions(:,1:2) = classtags;

%% Build classifiers with ISPCs extracted from these channel pairs for each participant
% Measure the ISPCs
perfMat = {};

for par = 1:length(validParticipants)
    participant = validParticipants(par);
    % Get the data for current participant
    parIndex = find(classtags(:,1) == participant);
    
%     classTrialsPTrain = classTrialsTrain(:,parIndex);
%     classTagsPTrain = classtagsTrain(parIndex,:);
    
    classTrialsP = classTrials(:,parIndex);
    classTagsP = classtags(parIndex,:);
   
%     CFCfeaturesTrain = classTrialsPTrain(featureLabelIndex,:);
    CFCfeatures = classTrialsP(featureLabelIndex,:);
    
    % Build and test the performances of the classifiers
    SVMmodel = fitcecoc(CFCfeatures',classTagsP(:,2));
    CVSVMmodel = crossval(SVMmodel,'kfold',10);
    %ScoreSVMModel = fitSVMPosterior(CVSVMmodel);
    CVSVMmodel.ScoreTransform = 'symmetricismax';
    [label,NegLoss,score] = kfoldPredict(CVSVMmodel);
    
    cp = classperf(classTagsP(:,2),label);
    
    % Plot the scores
    classLabelOrder = char(CVSVMmodel.ClassNames);
    codingMat = CVSVMmodel.CodingMatrix;
    
    % Write the performance measurement into the performance matrix
    row = size(perfMat,1);
    perfMat{row+1,1} = participant;
    perfMat{row+1,2} = sum(classTagsP(:,2) == label)/size(label,1);
    classlabel = cp.ClassLabels;
    
    for m = 1:classNum
        if size(classlabel,1)>=m
            perfMat{row+1,m+2} = char(classLabelOrder(m));
        else
            perfMat{row+1,m+2} = 'U';
        end
    end
    confMat = cp.CountingMatrix;
    confMat = confMat(1:classNum,1:classNum);
    if size(classLabelOrder,1)<classNum
        confMat(size(confMat,1)+1:2,:)=0;
        confMat(:,size(confMat,2)+1:2)=0;
    end
    confMat = confMat';
    confMat = confMat(:);
    for m = 1:classNum
        for n = 1:classNum
            perfMat{row+1,m*classNum+n+2} = confMat(classNum*(m-1)+n)/sum(confMat(classNum*(m-1)+1:classNum*m));
        end
    end
    
    scoreP = getProbScore(score,codingMat);
%     plotScoreCurve(scoreP,classTagsP,classLabelOrder,codingMat);
    classPredictions(parIndex,3) = label;
    classPredictions(parIndex,4:4+classNum-1) = scoreP;
%     saveas(gcf,[ 'Score' num2str(participant) '.png'])
%     close all
end