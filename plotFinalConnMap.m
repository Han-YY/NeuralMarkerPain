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
for c = 1:4
     
     conn1 = (conditionFeatureMat1(:,:,c)~=0) & ((selectFeatureMat1~=0));
     conn2 = (conditionFeatureMat2(:,:,c)~=0) &((selectFeatureMat2~=0));
%conn1 = conditionFeatureMat1(:,:,c);
%conn2 = conditionFeatureMat2(:,:,c);
    connMap1 = getEEGmap(conn1,channelPos,electrodes,imread('Empty.tiff'),[0 127 127]);
    connMap2 = getEEGmap(conn2,channelPos,electrodes,imread('Empty.tiff'),[127 0 127]);
 
    conn3 = (conditionFeatureMat3(:,:,c) ~= 0)&(selectFeatureMat3 ~= 0);
    indfl1 = unique(bandRefInd.*conn3);
    indfl1 = indfl1(find(indfl1~=0));
    feaLa1 = (bandRef(indfl1,:))';
    
    conn4 = (conditionFeatureMat4(:,:,c) ~= 0)&(selectFeatureMat4 ~= 0);
    indfl2 = unique(bandRefInd.*conn4);
    indfl2 = indfl2(find(indfl2~=0));
    feaLa2 = (bandRef(indfl2,:))';
    coupMap3= getEEGmapCFC(feaLa1,channelPos,electrodes,'Empty.tiff');
    coupMap4= getEEGmapCFC(feaLa2,channelPos,electrodes,'Empty.tiff');
    
    imwrite(connMap1,strcat(figurefolder,'Pan_',lengthName,'_',classes(c),'.png'))
    imwrite(connMap2,strcat(figurefolder,'Pon_',lengthName,'_',classes(c),'.png'))
    imwrite(coupMap3,strcat(figurefolder,'Pau_',lengthName,'_',classes(c),'.png'))
    imwrite(coupMap4,strcat(figurefolder,'Pou_',lengthName,'_',classes(c),'.png'))
    
    if c == 1
        mapAll = ones(size(connMap1,1) + 400, size(connMap1,2) + 400, 3) * 255;
        xcooda = 1 + size(connMap1,1) * (0:3) + 200;
        xcoodb = size(connMap1,1) * (1:4) + 200;
        ycooda = 1 + size(connMap1,2) * (0:3) + 400;
        ycoodb = size(connMap1,2) * (1:4) + 400;
    end
    
    
    mapAll(xcooda(c):xcoodb(c), ycooda(1):ycoodb(1), :) = connMap1;
    mapAll(xcooda(c):xcoodb(c), ycooda(2):ycoodb(2), :) = connMap2;
    mapAll(xcooda(c):xcoodb(c), ycooda(3):ycoodb(3), :) = coupMap3;
    mapAll(xcooda(c):xcoodb(c), ycooda(4):ycoodb(4), :) = coupMap4;
    
end

xcood = [xcooda xcoodb(end)-1];
ycood = [ycooda ycoodb(end)-1];

mapAll(1:200,1:ycood(5),:) = 255;
mapAll(1:xcood(5),1:400,:) = 255;
for a = 1:5

mapAll = insertShape(mapAll,'Line',[1,xcood(a),ycood(5),xcood(a)],'LineWidth',5,'Color',[0 0 0]);
mapAll = insertShape(mapAll,'Line',[ycood(a),1,ycood(a),xcood(5)],'LineWidth',5,'Color',[0 0 0]);

end

mapAll = insertShape(mapAll,'Line',[1,1,1,xcood(5)],'LineWidth',5,'Color',[0 0 0]);
mapAll = insertShape(mapAll,'Line',[1,1,ycood(5),1],'LineWidth',5,'Color',[0 0 0]);
mapAll = insertShape(mapAll,'Line',[ycood(5),1,ycood(5),xcood(5)],'LineWidth',5,'Color',[0 0 0]);
mapAll = insertShape(mapAll,'Line',[1,xcood(5),ycood(5),xcood(5)],'LineWidth',5,'Color',[0 0 0]);


imshow(uint8(mapAll))



