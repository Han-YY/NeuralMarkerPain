mainfolder0 = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_Main/';
figurefolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_figures_New_Test/';
mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
classes = 'OCHW';
featureNum = [0 40];
perc = 1;
exempt = 0;
tl = 4;
    lengthName = mainfolderlist{tl};
    lengthName = lengthName(3:end);
mainfolder = strcat(mainfolder0,mainfolderlist{tl});

folderpathP1 = string([mainfolder '/1_PhaseConn']);
folderpathP2 = string([mainfolder '/2_PowerConn']);
folderpathP3 = string([mainfolder '/3_PhaseCoup']);
folderpathP4 = string([mainfolder '/4_PowerCoup']);

[featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1] = getFeatureLabel(folderpathP1,featureNum,1);
[featureLabels2,selectFeatureMat2,conditionFeature2,conditionFeatureMat2,featureLabelIndex2] = getFeatureLabel(folderpathP2,featureNum,1);
[featureLabels3,selectFeatureMat3,conditionFeature3,conditionFeatureMat3,featureLabelIndex3] = getFeatureLabelCFC(folderpathP3,featureNum,bandRefInd,bandRef);
[featureLabels4,selectFeatureMat4,conditionFeature4,conditionFeatureMat4,featureLabelIndex4] = getFeatureLabelCFC(folderpathP4,featureNum,bandRefInd,bandRef);

figure

     
     conn1 = (conditionFeatureMat(:,:)~=0) & ((selectFeatureMat1~=0));

%conn1 = conditionFeatureMat1(:,:,c);
%conn2 = conditionFeatureMat2(:,:,c);
   
     connMap1 = getEEGmap(conn1,channelPos,electrodes,imread('Empty.tiff'),[0 127 127]);
    


imshow(connMap1)
