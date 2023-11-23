% written by Yiyuan Han, Essex BCI-NE Lab, 23/06/2020
% The Final Experiment
%% Load data
%load('/Users/yiyuan/OneDrive - University of Essex/RobustDataset.mat')


%% 
%%%%%%%%%%%%%% Classification Performance %%%%%%%%%%%%%%%
% mainfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/1_Binary Clssifiers/';
%% Phase-based connectivity
mode = 1;
folderpathP1 = string([mainfolder '/1_PhaseConn']);
getBinaryClassifiers(blockTagsACTrain,blockDatasetACTrain,mode,folderpathP1,200);
 
%[featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1] = getFeatureLabel(folderpathP1,featureNum.*2,1);

%% Power-based connecivity
mode = 0;
folderpathP2 = string([mainfolder '/2_PowerConn']);
getBinaryClassifiers(blockTagsACTrain,blockDatasetACTrain,mode,folderpathP2,200);
%[featureLabels2,selectFeatureMat2,conditionFeature2,conditionFeatureMat2,featureLabelIndex2] = getFeatureLabel(folderpathP2,featureNum.*2,1);


%% Phase-based coupling
mode = 1;
folderpathP3 = string([mainfolder '/3_PhaseCoup']);
[CFCdata,bandRef,bandRefInd] = getBinaryClassifiersCFC(blockTagsACTrain,blockDatasetACTrain,mode,folderpathP3,100);
%[featureLabels3,selectFeatureMat3,conditionFeature3,conditionFeatureMat3,featureLabelIndex3] = getFeatureLabelCFC(folderpathP3,featureNum,bandRefInd,bandRef);

%% Power-based coupling
mode = 0;
folderpathP4 = string([mainfolder '/4_PowerCoup']);
[CFCdata,bandRef,bandRefInd] = getBinaryClassifiersCFC(blockTagsACTrain,blockDatasetACTrain,mode,folderpathP4,100);
%[featureLabels4,selectFeatureMat4,conditionFeature4,conditionFeatureMat4,featureLabelIndex4] = getFeatureLabelCFC(folderpathP4,featureNum,bandRefInd,bandRef);


