function [cp,selectFeature,featureWeight,featureCOH] = interCOHBinclass(datatrial,trialtag,fold,featureNumber,freBand)
alphaTrainset = permute(EEGfilter(permute(datatrial,[2 1 3]),freBand,'BP',5,'all',500),[2 1 3]);
% Measure the coherence
alphaCOH = zeros(sum(1:61),size(alphaTrainset,3));% The array to store the ISPCs
powerAlpha = permute(abs(hilbert(permute(alphaTrainset,[2 1 3]))),[2 1 3]);
phaseAlpha = permute(angle(hilbert(permute(alphaTrainset,[2 1 3]))),[2 1 3]);
k = 1;
for m = 1:62
    power1 = powerAlpha(m,:,:);
    phase1 = phaseAlpha(m,:,:);
    for n = m+1:62
        power2 = powerAlpha(n,:,:);
        phase2 = phaseAlpha(n,:,:);
        dphase = phase1-phase2;
        alphaCOH(k,:) = (abs(mean(abs(power1).*abs(power2).*exp(1i.*dphase),2)));
        k = k+1;
    end
end
alphaCOH = alphaCOH';
% Project the coherences into the range of 0-1
% alphaCOH = (alphaCOH-min(alphaCOH(:)))/(max(alphaCOH(:))-min(alphaCOH(:)));

cp = classperf(trialtag);
crossInd = crossvalind('Kfold',trialtag,fold);
selectFeature = [];
featureWeight = [];
featureCOH = [];
for r = 1:10
    testGroup = (crossInd == r);
    trainGroup = ~testGroup;
    % Selecting features from the train group
    nca = fscnca(alphaCOH(trainGroup,:),trialtag(trainGroup));
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
    
    trainISPC = alphaCOH(trainGroup,selidx);
    featureCOH(:,end+1) = (mean(trainISPC))';
    % Train and test the classification model
    SVMmodel = fitcsvm(trainISPC,trialtag(trainGroup));
    [prediction,prescores] = predict(SVMmodel,alphaCOH(testGroup,selidx));
    
    classperf(cp,prediction,testGroup);
    
end

end