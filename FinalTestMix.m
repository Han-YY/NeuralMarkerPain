addpath('/home/yh19218/Code_IF_2020/Connectivity Measure Toolbox/');
addpath('/usr/local/eeglab/')
load('validParticipants.mat')
load('electrodes.mat')
load('bandReference.mat')
bands = [0.5 4;4 7.5;8 12;12.5 16] ;
mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};

% Read the data
fileIndex = 4;
foldername = mainfolderlist{fileIndex};
% mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main/',foldername);
% loadFile = strcat('/home/yh19218/Code_IF_2020/Dataset_',foldername(3:end),'.mat');
% load(loadFile);
mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main/',foldername);
loadFile = strcat('/home/yh19218/Code_IF_2020/Dataset_',foldername(3:end),'.mat');
load(loadFile)
% % Train the classifiers
% Main;
% 
% % Swap the dataset and train the classifiers again
% mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main/',foldername,'_Swap');
% % Swap
% swapdata = blockDatasetAC;
% swaptags = blockTagsAC;
% blockDatasetAC = blockDatasetACTrain;
% blockTagsAC = blockTagsACTrain;
% clear blockDatasetACTrain blockTagsACTrain;
% blockDatasetACTrain = swapdata;
% blockTagsACTrain = swaptags;
% clear swapdata swaptags;
% % Train classifiers based on the swapped data
% Main;

% Get all features for 
swapTestMix;
% Test the classifiers with different numbers of features

featureNumType = 10;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_10features/',foldername);
getBinaryClassifiersTestMix(classtags,features,folderpathP,'_Mix1',featureNumType);


featureNumType = 20;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_20features/',foldername);
swapTestMix;

featureNumType = 30;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_30features/',foldername);
swapTestMix;

featureNumType = 40;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_40features/',foldername);
swapTestMix;

featureNumType = 50;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_50features/',foldername);
swapTestMix;

featureNumType = 60;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_60features/',foldername);
swapTestMix;

featureNumType = 70;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_70features/',foldername);
swapTestMix;

featureNumType = 80;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_80features/',foldername);
swapTestMix;

featureNumType = 90;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_90features/',foldername);
swapTestMix;

featureNumType = 100;
featureNum = [0 featureNumType];
writeFolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_100features/',foldername);
swapTestMix;

    