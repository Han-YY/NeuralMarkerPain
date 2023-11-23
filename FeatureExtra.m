addpath('/home/yh19218/Code_IF_2020/Connectivity Measure Toolbox/');
addpath('/usr/local/eeglab/')
load('validParticipants.mat')
load('electrodes.mat')
load('bandReference.mat')
bands = [0.5 4;4 7.5;8 12;12.5 16] ;
mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};

% Read the data
for fileIndex = 1:4
foldername = mainfolderlist{fileIndex};
mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main_new/',foldername);
loadFile = strcat('/home/yh19218/Code_IF_2020/Dataset_',foldername(3:end),'.mat');
load(loadFile);
% mainfolder = strcat('/Users/yiyuan/MATLAB-Drive/PG/2_Codes/2019 Autumn/Task 1_Measure Classification/Code_Integrative/',foldername);
% loadFile = strcat('/Users/yiyuan/MATLAB-Drive/PG/2_Codes/2019 Autumn/Task 1_Measure Classification/Dataset_',foldername(3:end),'.mat');
% 
% Train the classifiers
Main;

% Swap the dataset and train the classifiers again
mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main_new/',foldername,'_Swap');
% Swap
swapdata = blockDatasetAC;
swaptags = blockTagsAC;
blockDatasetAC = blockDatasetACTrain;
blockTagsAC = blockTagsACTrain;
clear blockDatasetACTrain blockTagsACTrain;
blockDatasetACTrain = swapdata;
blockTagsACTrain = swaptags;
clear swapdata swaptags;
% Train classifiers based on the swapped data
Main;

end





