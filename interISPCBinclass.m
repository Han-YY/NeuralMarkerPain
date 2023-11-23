% written by Yiyuan Han, Essex BCI-NE Lab, 11/12/2019
% Inter-subject classification
% interISPCBinclass: Using ISPC as the feature to create SVM classfier for
% classifying conditions in the binary mode
% Input:
% -datatrial: the segmented EEG data with same length
% -trailtag: confition tags of the input data trials
% -fold: the number of folds in cross-validation
% -featureRatio: the ratio of selected features from the all features
% Output:
% -cp: classifier performance of this classification
% -selectFeature: features selected for classification
% -featureWeight: the weight in classification of each selected feature
% -featureISPC: the values of ISPC of the selected channel pairs, which is
% the mean value among all extracted training groups


function [cp,selectFeature,featureWeight,featureISPC] = interISPCBinclass(datatrial,trialtag,fold,featureNumber,freBand)
alphaTrainset = permute(EEGfilter(permute(datatrial,[2 1 3]),freBand,'BP',5,'all',500),[2 1 3]);
% Measure the ISPC
alphaISPC = zeros(sum(1:61),size(alphaTrainset,3));% The array to store the ISPCs
phaseAlpha = permute(angle(hilbert(permute(alphaTrainset,[2 1 3]))),[2 1 3]);
k = 1;
for m = 1:62
    phase1 = phaseAlpha(m,:,:);
    for n = m+1:62
        phase2 = phaseAlpha(n,:,:);
        dphase = phase1-phase2;
        alphaISPC(k,:) = abs(mean(exp(1i.*dphase),2));
        k = k+1;
    end
end
alphaISPC = alphaISPC';

cp = classperf(trialtag);
crossInd = crossvalind('Kfold',trialtag,fold);
selectFeature = [];
featureWeight = [];
featureISPC = [];
for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    % Selecting features from the train group
    nca = fscnca(alphaISPC(trainGroup,:),trialtag(trainGroup));
    % The ratio 'featureRatio' was changed to 'featureNumber' in 21/06/2020
    %selidxvalue = maxk(nca.FeatureWeights,floor(featureRatio*length(nca.FeatureWeights)));
    %selidx = zeros(floor(featureRatio*length(nca.FeatureWeights)),1);
    % The same part use 'featureNumber"
    selidxvalue = maxk(nca.FeatureWeights,featureNumber);
    selidx = zeros(featureNumber,1);
    nnn = 1;
    for w = 1:length(selidx)
        indf = find(nca.FeatureWeights==selidxvalue(w));
        if length(indf)>1 && nnn == length(indf)
            selidx(w,1) = indf(nnn);
            nnn = 1;
        elseif length(indf)>1 && nnn ~= length(indf)
            selidx(w,1) = indf(nnn);
            nnn = nnn+1;
        else
        selidx(w,1) = indf;%Selected features above the weight threshold
        end
        
    end
    
    selectFeature(:,end+1) = selidx;
    featureWeight(:,end+1) = nca.FeatureWeights(selidx);
    
    trainISPC = alphaISPC(trainGroup,selidx);
    featureISPC(:,end+1) = (mean(trainISPC))';
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC,trialtag(trainGroup));
    [prediction,prescores] = predict(SVMmodel,alphaISPC(testGroup,selidx));
    
    classperf(cp,prediction,testGroup);
    
end

end