function [cp,selectFeature,featureWeight] = interCFCBinclass(datatrial,trialtag,fold,featureRatio)

datatrial = datatrial';

cp = classperf(trialtag);
crossInd = crossvalind('Kfold',trialtag,fold);
selectFeature = [];
featureWeight = [];

for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    % Selecting features from the train group
    nca = fscnca(datatrial(trainGroup,:),trialtag(trainGroup));
    selidxvalue = unique(maxk(nca.FeatureWeights,floor(featureRatio*length(nca.FeatureWeights))));
    selidx = zeros(floor(featureRatio*length(nca.FeatureWeights)),1);
    nn = length(selidxvalue~=0);
    
    k = 1;
    w = 1;
    while w<=nn
         indSel = find(nca.FeatureWeights==selidxvalue(w),1);%Selected features above the weight threshold
         
         selidx(k:k+length(indSel)-1,1) = indSel;
         k = k+length(indSel);
         w = w+1;
    end
    selidx = selidx(1:floor(featureRatio*length(nca.FeatureWeights)),1);
    selectFeature(:,end+1) = selidx;
    featureWeight(:,end+1) = nca.FeatureWeights(selidx);
    
    trainISPC = datatrial(trainGroup,selidx);
    
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC,trialtag(trainGroup));
    [prediction,prescores] = predict(SVMmodel,datatrial(testGroup,selidx));
    
    classperf(cp,prediction,testGroup);
    
end

end