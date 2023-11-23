% written by Yiyuan Han, Essex BCI-NE Lab, 13/12/2019
% binary classification between two specific conditions
function perfMat = binaryClassTest(class1,class2,blockTagsAC,features,folderpath,nameTag)
%% Extract the data in specific conditions
% These two classes should be modified according to each requirement

indices = find(char(blockTagsAC(:,2))==class1|char(blockTagsAC(:,2))==class2);
classTrials = features(:,indices);
classTags = blockTagsAC(indices,:);

%% Get all essential information
% get all participant numbers
participant = [];
for k = 1:size(classTags,1)
    if ~ismember(classTags(k,1),participant)
        participant = [participant,classTags(k,1)];
    end
end
blockTags = [];
for k = 1:size(classTrials,2)
    blockTags(1,end+1) = classTags(k,2);
end

% Remove the participants only contaning one class
pnum = length(participant);
parRemove = [];%The indices of participants for removal
for p = 1:pnum
    pClasses = classTags(classTags(:,1) == participant(p),:);
    if ~ismember(class1,char(pClasses(:,2))) || ~ismember(class2,char(pClasses(:,2)))
        pRemove = find(classTags(:,1) == participant(p));
        parRemove = [parRemove p];
         classTrials(:,pRemove) = [];
    
         classTags(pRemove,:) = [];
    blockTags(pRemove) = [];
    % Reset the detecting index array
    pRemove = [];
    end
   
end
participant(parRemove) = [];

%% Classification of every participant's data
len = 1250;
rl = 1250/len;
perfMat = {};% Matrix to record the performance of the classifiers

for p = 1:length(participant)
    % Get the samples from one participant
    samples = classTrials(:,find(classTags(:,1)==participant(p)));
    sampleTags = blockTags(find(classTags(:,1)==participant(p)));
    % Segment the trials into shorter ones  
%     samplesNew = zeros(size(samples,1),len,rl*size(samples,3));
%     for k = 1:size(samples,2)
%         for r = 1:rl
%             samplesNew(:,rl*k+r-rl) = samples(:,k);
%         end
%     end
%     % Adjust the tags
%     sampleNewTags = {};
%     for r = 1:length(sampleTags)
%         
%         for k = 1:rl
%             sampleNewTags{end+1} = char(sampleTags(1,r));
%             
%         end
%     end
%     sampleNewTags = sampleNewTags';
%     if mode == 1
%    [cp,selectFeature,featureWeight,featureISPC] = interISPCBinclass(samplesNew,sampleNewTags,10,20,[8 12]);%Get the performance of the classifier to this condition
%    %[cp,selectFeature,featureWeight,featureISPC] = interPSDBinclass(samplesNew,sampleNewTags,10,0.04,[8 12]);
%    
%     else
%         [cp,selectFeature,featureWeight,featureISPC] = interCOHBinclass(samplesNew,sampleNewTags,10,20,[8 12]);
%     end

% Train and test the classifiers with cross-validation (10-fold)
cp = classperf(sampleTags);
crossInd = crossvalind('Kfold',sampleTags,10);
predictRes = [];% Store the actual tags and predicted tags for calculating the average accuracy, the first column is the actual tags while the second one is the prediction
for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    
    trainISPC = samples(:,trainGroup);
    
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC',(sampleTags(trainGroup))');
    [prediction,prescores] = predict(SVMmodel,(samples(:,testGroup))');
    
    predictRes = [predictRes;(sampleTags(:,testGroup))' prediction];
    classperf(cp,prediction,testGroup);
end
    
    % Write the information of cp into the matrix
    row = size(perfMat,1);
    perfMat{row+1,1} = participant(p);
    perfMat{row+1,2} = cp.correctRate;
    classlabel = cp.ClassLabels;
    for m = 1:2
        if size(classlabel,1)>=m
            perfMat{row+1,m+2} = classlabel(m,1);
        else
            perfMat{row+1,m+2} = 'U';
        end
    end

% perfMat{row+1,3} = class1;
% perfMat{row+1,4} = class2;

    confMat = cp.CountingMatrix;
    confMat = confMat(1:2,1:2);
    if size(classlabel,1)<2
        confMat(size(confMat,1)+1:2,:)=0;
        confMat(:,size(confMat,2)+1:2)=0;
    end
        
    
    confMat = confMat';
    confMat = confMat(:);
    
    if char(classlabel(1,1)) ~= class1
        confMat = flipud(confMat);
    end
    

% confMat(1) = length(find(char(predictRes(:,2)) == class1))/length(find(char(predictRes(:,1)) == class1));
% confMat(2) = length(find(char(predictRes(:,2)) == class2))/length(find(char(predictRes(:,1)) == class1));
% confMat(3) = length(find(char(predictRes(:,2)) == class1))/length(find(char(predictRes(:,1)) == class2));
% confMat(4) = length(find(char(predictRes(:,2)) == class2))/length(find(char(predictRes(:,1)) == class2));

    for m = 1:2
        for n = 1:2
            
            perfMat{row+1,2*m+n+2} = confMat(2*(m-1)+n)/sum(confMat(2*m-1:2*m));
        end
    end
    
end
perfMatFinal = {};
perfMatFinal(1,:) = {'No' 'Accuracy' 'Class 1' 'Class 2' '11' '10' '01' '00' };
perfMatFinal(2:size(perfMat,1)+1,:) = perfMat;
%save(strcat(folderpath, '/',class1,'vs',class2,'.mat'),'perfMat')
writecell(perfMatFinal,strcat(folderpath,'/','binaryTest',nameTag,'.xlsx'),'Sheet',strcat(class1,'vs',class2));
end