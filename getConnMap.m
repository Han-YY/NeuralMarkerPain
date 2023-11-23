% Get the visual connectivity for each condition
%[featureLabels,selectFeatureMat,conditionFeature,conditionFeatureMat,featureLabelIndex] = getFeatureLabel('C:\Users\yh19218\MATLAB Drive\PG\2_Codes\2019 Autumn\Task 1_Measure Classification\Alpha(LOO)',0.5);
map = imread('Empty.tiff');
load('channelPositions.mat')
classes = 'OHSW';

%% Connectivity map
[featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1] = getFeatureLabel(folderpathP1,40,1);
[featureLabels2,selectFeatureMat2,conditionFeature2,conditionFeatureMat2,featureLabelIndex2] = getFeatureLabel(folderpathP2,40,1);

for c = 1:4
    
    conn1 = (conditionFeatureMat1(:,:,c) ~= 0)&(conditionFeatureMat1(:,:,c) == selectFeatureMat1);
    %conn2 = (conditionFeatureMat2(:,:,c) ~= 0)&(conditionFeatureMat2(:,:,c) == selectFeatureMat2);
% conn1 = conditionFeatureMat1(:,:,c);
 conn2 = conditionFeatureMat2(:,:,c);
    connMap1 = getEEGmap(conn1,channelPos,map,[0 127 127]);
    connMap2 = getEEGmap(conn2,channelPos,map,[127 0 127]);
    
    imwrite(connMap1,[mainfolder '/Connectivity map (Phase) ' classes(c) '.png'])
    imwrite(connMap2,[mainfolder '/Connectivity map (Power) ' classes(c) '.png'])
end

connMap1 = getEEGmap(selectFeatureMat1,channelPos,map,[0 127 127]);
connMap2 = getEEGmap(selectFeatureMat2,channelPos,map,[127 0 127]);
imwrite(connMap1,[mainfolder '/Connectivity map (Phase).png'])
imwrite(connMap2,[mainfolder '/Connectivity map (Power).png'])

%% Coupling map
[featureLabels3,selectFeatureMat3,conditionFeature3,conditionFeatureMat3,featureLabelIndex3] = getFeatureLabelCFC(folderpathP3,20,bandRefInd,bandRef);
[featureLabels4,selectFeatureMat4,conditionFeature4,conditionFeatureMat4,featureLabelIndex4] = getFeatureLabelCFC(folderpathP4,20,bandRefInd,bandRef);
for c = 1:4
    
    conn1 = (conditionFeatureMat3(:,:,c) ~= 0)&(selectFeatureMat3 ~= 0);
    indfl1 = unique(bandRefInd.*conn1);
    indfl1 = indfl1(find(indfl1~=0));
    feaLa1 = (bandRef(indfl1,:))';
    
    conn2 = (conditionFeatureMat4(:,:,c) ~= 0)&(selectFeatureMat4 ~= 0);
    indfl2 = unique(bandRefInd.*conn2);
    indfl2 = indfl2(find(indfl2~=0));
    feaLa2 = (bandRef(indfl2,:))';
    
    coupMap1= getEEGmapCFC(feaLa1,channelPos,'Empty.tiff');
    coupMap2= getEEGmapCFC(feaLa2,channelPos,'Empty.tiff');
    
    imwrite(coupMap1,[mainfolder '/CFC map (Phase) ' classes(c) '.png'])
    imwrite(coupMap2,[mainfolder '/CFC map (Power) ' classes(c) '.png'])
end

CFCmap1 = getEEGmapCFC(featureLabels3,channelPos,'Empty.tiff');
imwrite(CFCmap1,[mainfolder '/CFC map (phase).png']);
CFCmap2 = getEEGmapCFC(featureLabels4,channelPos,'Empty.tiff');
imwrite(CFCmap1,[mainfolder '/CFC map (power).png']);