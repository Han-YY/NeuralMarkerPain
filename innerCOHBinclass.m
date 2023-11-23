function [cp,selectFeature,featureWeight,featureCOH] = innerCOHBinclass(CFCdata,trialtag,fold,featureNumber)
CFCdata = CFCdata';

cp = classperf(trialtag);
crossInd = crossvalind('Kfold',trialtag,fold);
selectFeature = [];
featureWeight = [];
featureCOH = [];
for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    % Selecting features from the train group
    nca = fscnca(CFCdata(trainGroup,:),trialtag(trainGroup));
    % Changing 'featureRatio' to 'featureNumber', 23/06/2020
%     selidxvalue = maxk(nca.FeatureWeights,floor(featureRatio*length(nca.FeatureWeights)));
%     selidx = zeros(floor(featureRatio*length(nca.FeatureWeights)),1);
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
    featureCOH(:,end+1) = (mean(trainISPC))';
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC,trialtag(trainGroup));
    [prediction,prescores] = predict(SVMmodel,CFCdata(testGroup,selidx));
    
    classperf(cp,prediction,testGroup);
    
end

end