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


function [cp,selectFeature,featureWeight,featureISPC] = innerISPCBinclass(CFCdata,trialtag,fold,featureNumber)
CFCdata = CFCdata';

cp = classperf(trialtag);
crossInd = crossvalind('Kfold',trialtag,fold);
selectFeature = [];
featureWeight = [];
featureISPC = [];
for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    % Selecting features from the train group
    nca = fscnca(CFCdata(trainGroup,:),trialtag(trainGroup));
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
    
    trainISPC = CFCdata(trainGroup,selidx);
    featureISPC(:,end+1) = (mean(trainISPC))';
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC,trialtag(trainGroup));
    [prediction,prescores] = predict(SVMmodel,CFCdata(testGroup,selidx));
    
    classperf(cp,prediction,testGroup);
    
end

end