% written by Yiyuan Han, Essex BCI-NE Lab, 05/02/2020
% getFeatureLabel: Get the channel labels of the selected features and
% determining the relationship between selected channel pairs and
% conditions
% Input:
% -folderpath: The folder path which stores the data of all classifiers in
% obtained with specific test terms
% -thre: the threshold for selecting features (mode 0), the number of
% targetting selected features (mode 1)
% -mode: 0 for threshold, 1 for max thre features
% Output:
% -featureLabels: The labels of the channels in the selected features
% -selectFeatureMat: The significant features stored in the channel x
% channel matrix
% -conditionFeature: The features represent the information for each
% specific condition

function [featureLabels,selectFeatureMat,conditionFeature,conditionFeatureMat,featureLabelIndex,classifierClassLabelMat] = getFeatureLabel(folderpath,thre,mode)
% Get the matrix representing the significant features
load('electrodes.mat');
files = ['OvsC';'OvsH';'OvsW';'CvsH';'CvsW';'HvsW'];
selectFeatureMat = zeros(62);
conditionFeature = cell(4,1);%The order of 4 cells are 'O','H','S','W'
conditionFeatureMat = zeros(62,62,4);

%% Project the channel labels into channel pairs' indices
channelPairs = {};

indices = zeros(62);
k = 1;
for m = 1:62
    for n = m+1:62
        channelPairs{1,end+1} = electrodes(m);
        channelPairs{2,end} = electrodes(n);
        indices(m,n) = k;
        k = k+1;
    end
end
% Read the selected features labels from all conditions
classifierLabelMat = zeros(62,62,6); % The matrix storing the selected features in all classifiers
classifierClassLabelMat = zeros(62,62,4,4);

for f = 1:6
    load(strcat(folderpath,'/',files(f,:),'.mat'))
    % Store the average results
    weightMatA = zeros(62);
    numberMatA = zeros(62);
    for par = 1:size(sFeatures,3)
        sFeatures0 = sFeatures(:,:,par);
        fWeights0 = fWeights(:,:,par);
        
        sFeatures0 = sFeatures0(:);
        fWeights0 = fWeights0(:);
        
        
        % Intialize the matrices to store the values
        weightMat = zeros(62);
        for l = 1:length(sFeatures0)
            [a,b] = find(indices == sFeatures0(l));
            weightMat(a,b) = weightMat(a,b) + fWeights0(l); %Because the number of existences of one channel pair as a selected feature also decided the weight in classification, here the numerical sum is used to represent the cumulative weights
            weightMat(b,a) = weightMat(a,b);
        end
        weightMatA = weightMatA + weightMat;
        
    end
    weightMatA0 = weightMatA/max(weightMatA(:));% Normalize the distribution of the weights in the range between 0 and 1
    weightMatABin = zeros(62);
    
    if mode == 0
        weightMatABin(weightMatA0>thre) = 1;
    elseif mode == 1
        
        selidxvalueMax = maxk(weightMatA0(:),thre(2));
        selidxvalueExe = maxk(weightMatA0(:),thre(1));
        
        selidxvalue = selidxvalueMax(~ismember(selidxvalueMax,selidxvalueExe));
        
        weightMatABin(ismember(weightMatA0,selidxvalue)) = 1;
        weightMatAS = weightMatA0;
        weightMatAS(~ismember(weightMatA0,selidxvalue)) = 0;
    end
        
    
    % Add the binary matrix representing the selected features in the main
    % binary matrix
    if mode ==0 
    selectFeatureMat = selectFeatureMat + weightMatABin;
    else
        selectFeatureMat = selectFeatureMat + weightMatAS;
    end
    
    % Get the matrix storing the pairs shared by two classifiers with one
    % same condition
    classifierLabelMat(:,:,f) = classifierLabelMat(:,:,f) + weightMatABin;
    switch f
        case 1
            conditionFeatureMat(:,:,1) = conditionFeatureMat(:,:,1) + weightMatABin;
            conditionFeatureMat(:,:,2) = conditionFeatureMat(:,:,2) + weightMatABin;
            
        case 2
            conditionFeatureMat(:,:,1) = conditionFeatureMat(:,:,1) + weightMatABin;
            conditionFeatureMat(:,:,3) = conditionFeatureMat(:,:,3) + weightMatABin;
            
        case 3
            conditionFeatureMat(:,:,1) = conditionFeatureMat(:,:,1) + weightMatABin;
            conditionFeatureMat(:,:,4) = conditionFeatureMat(:,:,4) + weightMatABin;
            
        case 4
            conditionFeatureMat(:,:,2) = conditionFeatureMat(:,:,2) + weightMatABin;
            conditionFeatureMat(:,:,3) = conditionFeatureMat(:,:,3) + weightMatABin;
            
        case 5
            conditionFeatureMat(:,:,2) = conditionFeatureMat(:,:,2) + weightMatABin;
            conditionFeatureMat(:,:,4) = conditionFeatureMat(:,:,4) + weightMatABin;
           
        case 6
            conditionFeatureMat(:,:,4) = conditionFeatureMat(:,:,4) + weightMatABin;
            conditionFeatureMat(:,:,3) = conditionFeatureMat(:,:,3) + weightMatABin;
            
    end
end

% Set the matrix storing the feature for each condition with only the
% shared features

    conditionFeatureMat(conditionFeatureMat<2) = 0;


% The features for each class versus all other classes
classifierClassLabelMat(:,:,1,2) = (conditionFeatureMat(:,:,1)>0) & (conditionFeatureMat(:,:,2) == 0) & (classifierLabelMat(:,:,1));
classifierClassLabelMat(:,:,1,3) = (conditionFeatureMat(:,:,1)>0) & (conditionFeatureMat(:,:,3) == 0) & (classifierLabelMat(:,:,2));
classifierClassLabelMat(:,:,1,4) = (conditionFeatureMat(:,:,1)>0) & (conditionFeatureMat(:,:,4) == 0) & (classifierLabelMat(:,:,3));
classifierClassLabelMat(:,:,2,1) = (conditionFeatureMat(:,:,2)>0) & (conditionFeatureMat(:,:,1) == 0) & (classifierLabelMat(:,:,1));
classifierClassLabelMat(:,:,2,3) = (conditionFeatureMat(:,:,2)>0) & (conditionFeatureMat(:,:,3) == 0) & (classifierLabelMat(:,:,4));
classifierClassLabelMat(:,:,2,4) = (conditionFeatureMat(:,:,2)>0) & (conditionFeatureMat(:,:,4) == 0) & (classifierLabelMat(:,:,5));
classifierClassLabelMat(:,:,3,1) = (conditionFeatureMat(:,:,3)>0) & (conditionFeatureMat(:,:,1) == 0) & (classifierLabelMat(:,:,2));
classifierClassLabelMat(:,:,3,2) = (conditionFeatureMat(:,:,3)>0) & (conditionFeatureMat(:,:,2) == 0) & (classifierLabelMat(:,:,4));
classifierClassLabelMat(:,:,3,4) = (conditionFeatureMat(:,:,3)>0) & (conditionFeatureMat(:,:,4) == 0) & (classifierLabelMat(:,:,6));  
classifierClassLabelMat(:,:,4,1) = (conditionFeatureMat(:,:,4)>0) & (conditionFeatureMat(:,:,1) == 0) & (classifierLabelMat(:,:,3));
classifierClassLabelMat(:,:,4,2) = (conditionFeatureMat(:,:,4)>0) & (conditionFeatureMat(:,:,2) == 0) & (classifierLabelMat(:,:,5));
classifierClassLabelMat(:,:,4,3) = (conditionFeatureMat(:,:,4)>0) & (conditionFeatureMat(:,:,3) == 0) & (classifierLabelMat(:,:,6));

classifierClassLabelMat(:,:,1,1) = classifierClassLabelMat(:,:,1,2) & classifierClassLabelMat(:,:,1,3) & classifierClassLabelMat(:,:,1,4);
classifierClassLabelMat(:,:,2,2) = classifierClassLabelMat(:,:,2,1) & classifierClassLabelMat(:,:,2,3) & classifierClassLabelMat(:,:,2,4);
classifierClassLabelMat(:,:,3,3) = classifierClassLabelMat(:,:,3,1) & classifierClassLabelMat(:,:,3,2) & classifierClassLabelMat(:,:,3,4);
classifierClassLabelMat(:,:,4,4) = classifierClassLabelMat(:,:,4,1) & classifierClassLabelMat(:,:,4,2) & classifierClassLabelMat(:,:,4,3);

selectFeatureMat1 = zeros(62);
for a = 1:62
    for b = a+1:62
        weightAB = selectFeatureMat(a,b) + selectFeatureMat(b,a);
        selectFeatureMat1(a,b) = weightAB;
    end
end




%% Get the feature labels and condition features
featureLabels = {};
featureLabelIndex = [];
[X,Y] = find(selectFeatureMat1 ~= 0);%Find the indices of all electrodes as selected features
if mode == 0
for m = 1:62
    for n = m+1:62
        if selectFeatureMat(m,n) ~= 0
            featureLabels{1,end+1} = electrodes(m);
            featureLabels{2,end} = electrodes(n);
            featureLabelIndex = [featureLabelIndex,indices(m,n)];
        end
        
            
        for c = 1:4
            if conditionFeatureMat(m,n,c) ~= 0
                conditionFeature{c,1}{1,end+1} = electrodes(m);
                conditionFeature{c,1}{2,end} = electrodes(n);
            end
        end
    end
end
else
    for r = 1:thre(2)-thre(1)
        try
            m = X(r,1);
            n = Y(r,1);
            if indices(m,n) ~= 0
                featureLabels{1,end+1} = electrodes(m);
                featureLabels{2,end} = electrodes(n);
                featureLabelIndex = [featureLabelIndex,indices(m,n)];
                for c = 1:4
                    if conditionFeatureMat(m,n,c) ~= 0
                        conditionFeature{c,1}{1,end+1} = electrodes(m);
                        conditionFeature{c,1}{2,end} = electrodes(n);
                    end
                end
            end
        end
    end
end


end