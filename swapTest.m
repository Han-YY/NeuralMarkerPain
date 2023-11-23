
folderpathP = strcat(writeFolder,'/');
mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main_new/',foldername);
folderpathP1 = string([mainfolder '/1_PhaseConn']);
folderpathP2 = string([mainfolder '/2_PowerConn']);
folderpathP3 = string([mainfolder '/3_PhaseCoup']);
folderpathP4 = string([mainfolder '/4_PowerCoup']);
multiFeaturesTest;

% Swap the data for test
swapdata = blockDatasetAC;
swaptags = blockTagsAC;
blockDatasetAC = blockDatasetACTrain;
blockTagsAC = blockTagsACTrain;
clear blockDatasetACTrain blockTagsACTrain;
blockDatasetACTrain = swapdata;
blockTagsACTrain = swaptags;
clear swapdata swaptags;



% Test after swapping
folderpathP = strcat(writeFolder,'_Swap/');
mainfolder = strcat('/home/yh19218/Code_IF_2020/Results/Results_Main_new/',foldername,'_Swap');
folderpathP1 = string([mainfolder '/1_PhaseConn']);
folderpathP2 = string([mainfolder '/2_PowerConn']);
folderpathP3 = string([mainfolder '/3_PhaseCoup']);
folderpathP4 = string([mainfolder '/4_PowerCoup']);
multiFeaturesTest;


