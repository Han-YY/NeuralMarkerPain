% % written by Yiyuan Han, Essex BCI-NE Lab
classes = ['O' 'H' 'W' 'S'];
classNum = length(classes);
parIndices = find((ismember(blockTagsAC(:,1),validParticipants))&(ismember(blockTagsAC(:,2),classes)));
classTrials = blockDatasetAC(:,:,parIndices);
classtags = blockTagsAC(parIndices,:);
%% Extract the features in four types
% Connectivity
alphadata = permute(EEGfilter(permute(classTrials,[2 1 3]),[8 12],'BP',5,'all',500),[2 1 3]);


powerAlpha = permute(abs(hilbert(permute(alphadata,[2 1 3]))),[2 1 3]);
phaseAlpha = permute(angle(hilbert(permute(alphadata,[2 1 3]))),[2 1 3]);
% Phase
[featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1] = getFeatureLabel(folderpathP1,20,1);
feature1 = zeros(size(featureLabels1,2),size(alphadata,3));
for k = 1:size(featureLabels1,2)
    channel1 = featureLabels1(1,k);
    channel2 = featureLabels1(2,k);
    
    feature1(k,:) = getISPCchannel(phaseAlpha,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
    
    
end
% Power
[featureLabels2,selectFeatureMat2,conditionFeature2,conditionFeatureMat2,featureLabelIndex2] = getFeatureLabel(folderpathP2,20,1);
feature2 = zeros(size(featureLabels2,2),size(alphadata,3));
for k = 1:size(featureLabels2,2)
    channel1 = featureLabels2(1,k);
    channel2 = featureLabels2(2,k);
    
    feature2(k,:) = getCOHchannel(powerAlpha,phaseAlpha,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
    
    
end

% Coupling
% Phase Coupling
[featureLabels3,selectFeatureMat3,conditionFeature3,conditionFeatureMat3,featureLabelIndex3] = getFeatureLabelCFC(folderpathP3,10,bandRefInd,bandRef);

feature3 = CFCdataISPC(featureLabelIndex3,parIndices);
% Power Coupling
[featureLabels4,selectFeatureMat4,conditionFeature4,conditionFeatureMat4,featureLabelIndex4] = getFeatureLabelCFC(folderpathP4,10,bandRefInd,bandRef);

feature4 = CFCdataCOH(featureLabelIndex4,parIndices);

%% Select features in the specific mode
% Mix all features
featureAll = [feature1;feature2;feature3;feature4];

% Build the features
 featureTest = featureAll(indControl,:);

%% Train and test the classifier
perfMat = {};

for par = 1:length(validParticipants)
    participant = validParticipants(par);
    % Get the data for current par ticipant
    parIndex = find(classtags(:,1) == participant);
    
%     classTrialsPTrain = classTrialsTrain(:,parIndex);
%     classTagsPTrain = classtagsTrain(parIndex,:);
    
    
    classTagsP = classtags(parIndex,:);
   
%     CFCfeaturesTrain = classTrialsPTrain(featureLabelIndex,:);
    Features = featureTest(:,parIndex);
    
    % Build and test the performances of the classifiers
    SVMmodel = fitcecoc(Features',classTagsP(:,2));
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
