% written by Yiyuan Han, Essex BCI-NE Lab, 04/03/2020
% Build the binary clssifiers using the CFC as features

function [sFeatures,fWeights,perfMat] = binaryClassCFC(class1,class2,blockTagsAC,CFCdata,mode,folderpath,featureNum)
%% Extract the data in specific conditions
indices = find(char(blockTagsAC(:,2))==class1|char(blockTagsAC(:,2))==class2);
featureTrials = CFCdata(:,indices);
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
for k = 1:size(featureTrials,2)
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
        featureTrials(:,pRemove) = [];
    classTags(pRemove,:) = [];
    blockTags(pRemove) = [];
    % Reset the detecting index array
    pRemove = [];
    end
   
end
participant(parRemove) = [];

%% Classification of every participant's data
len = 5000;
rl = 5000/len;
perfMat = {};% Matrix to record the performance of the classifiers

for p = 1:length(participant)
    % Get the samples from one participant
    samples = featureTrials(:,find(classTags(:,1)==participant(p)));
    sampleTags = blockTags(find(classTags(:,1)==participant(p)));
    % Segment the trials into shorter ones  
    
    sampleTags = sampleTags';
    if mode == 1
   [cp,selectFeature,featureWeight,featureISPC] = innerISPCBinclass(samples,sampleTags,10,featureNum);%Get the performance of the classifier to this condition
    else
   [cp,selectFeature,featureWeight,featureCOH] = innerCOHBinclass(samples,sampleTags,10,featureNum);
    end
    
    if p == 1
        sFeatures = zeros(size(selectFeature,1),size(selectFeature,2),length(participant));
        fWeights = zeros(size(featureWeight,1),size(featureWeight,2),length(participant));
        
    end
    sFeatures(:,:,p) = selectFeature;
    fWeights(:,:,p) = featureWeight;
   
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
    confMat = cp.CountingMatrix;
    if size(classlabel,1)<2
        confMat(size(confMat,1)+1:2,:)=0;
        confMat(:,size(confMat,2)+1:2)=0;
    end
    confMat = confMat';
    confMat = confMat(:);
    for m = 1:2
        for n = 1:2
            perfMat{row+1,2*m+n+2} = confMat(2*(m-1)+n)/sum(confMat(2*m-1:2*m));
        end
    end
    perfMat{row+1,9} = size(selectFeature,1);
end

save(strcat(folderpath, '/',class1,'vs',class2,'.mat'),'fWeights','sFeatures','perfMat')
end