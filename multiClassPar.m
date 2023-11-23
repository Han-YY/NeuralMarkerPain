% written by Yiyuan Han, Essex BCI-NE Lab, 10/01/2020
% Multi-class classifiers for each participant

%% Only remain the participants with complete data in all of 4 classes

classes = ['O' 'H' 'W' 'S'];
classNum = length(classes);
parIndices = find((ismember(blockTagsAC(:,1),validParticipants))&(ismember(blockTagsAC(:,2),classes)));% Indices of the participants with all classes' data and only keep the 4 classes for classification
% Select 1000 samples randomly from all valid data for testing the
% classifier

% classTrialsTrain = blockDatasetACTrain(:,:,parIndices);
% classtagsTrain = blockTagsACTrain(parIndices,:);

% Testing set
classTrials = blockDatasetAC(:,:,parIndices);
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
    
%     classTrialsPTrain = classTrialsTrain(:,:,parIndex);
%     classTagsPTrain = classtagsTrain(parIndex,:);
    
    classTrialsP = classTrials(:,:,parIndex);
    classTagsP = classtags(parIndex,:);
%     alphadataTrain = permute(EEGfilter(permute(classTrialsPTrain,[2 1 3]),[8 12],'BP',5,'all',500),[2 1 3]);
    alphadata = permute(EEGfilter(permute(classTrialsP,[2 1 3]),[8 12],'BP',5,'all',500),[2 1 3]);
    if mode ==1
%     alphaISPCTrain = zeros(size(featureLabels,2),size(alphadataTrain,3));
    alphaISPC = zeros(size(featureLabels,2),size(alphadata,3));
%     phaseAlphaTrain = permute(angle(hilbert(permute(alphadataTrain,[2 1 3]))),[2 1 3]);
    phaseAlpha = permute(angle(hilbert(permute(alphadata,[2 1 3]))),[2 1 3]);
    else
%     alphaCOHTrain = zeros(size(featureLabels,2),size(alphadataTrain,3));
    alphaCOH = zeros(size(featureLabels,2),size(alphadata,3));
%     powerAlphaTrain = (permute(abs(hilbert(permute(alphadataTrain,[2 1 3]))),[2 1 3]));
    powerAlpha = permute(abs(hilbert(permute(alphadata,[2 1 3]))),[2 1 3]);
    phaseAlpha = permute(angle(hilbert(permute(alphadata,[2 1 3]))),[2 1 3]);
    end
    for k = 1:size(featureLabels,2)
        channel1 = featureLabels(1,k);
        channel2 = featureLabels(2,k);
        if mode == 1
%         alphaISPCTrain(k,:) = getISPCchannel(phaseAlphaTrain,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
        alphaISPC(k,:) = getISPCchannel(phaseAlpha,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
        else
%         alphaCOHTrain(k,:) = getCOHchannel(powerAlphaTrain,phaseAlphaTrain,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
        alphaCOH(k,:) = getCOHchannel(powerAlpha,phaseAlpha,cell2mat(channel1{1,1}),cell2mat(channel2{1,1}),electrodes);
        end
    end
    
    % Build and test the performances of the classifiers
    if mode == 1
    SVMmodel = fitcecoc(alphaISPC',classTagsP(:,2));
    CVSVMmodel = crossval(SVMmodel,'kfold',10);
    else
    SVMmodel = fitcecoc(alphaCOH',classTagsP(:,2));
    CVSVMmodel = crossval(SVMmodel,'kfold',10);
    end
    
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
    perfMat{row+1,2} = cp.correctRate;
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

    
