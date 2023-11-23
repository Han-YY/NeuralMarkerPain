% mainfolder0 = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_Main/';
% figurefolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_figures_New_Test/';
mainfolder0 = 'C:\Users\yh19218\OneDrive - University of Essex\PG Research\0A_Journal\202004_unknown Journal_Probability Score\1_Results\0_Final Results\Results_Main\';
figurefolder = 'C:\Users\yh19218\OneDrive - University of Essex\PG Research\0A_Journal\202004_unknown Journal_Probability Score\1_Results\0_Final Results\Results_figures_New_Test\';
mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
load('channelPositions.mat')
load('electrodes.mat')
classes = 'OCHW';
featureNum = [0 40];
perc = 1;
exempt = 0;
tl = 4;

 lengthName = mainfolderlist{tl};
    lengthName = lengthName(3:end);
mainfolder = strcat(mainfolder0,mainfolderlist{tl});

folderpathP1 = string([mainfolder '\1_PhaseConn']);

[featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1,classifierMat1] = getFeatureLabel(folderpathP1,featureNum,1);

k = 1;
% for aclass = 1:4
%     connAll = classifierMat1(:,:,aclass,aclass);
%     for bclass = 1:4
%         if aclass ~= bclass
%             conn1 = classifierMat1(:,:,aclass,bclass) & (~connAll);
%             conn2 = classifierMat1(:,:,aclass,bclass) & connAll;
%             connMapN(:,:,1) = conn1;
%             connMapN(:,:,2) = conn2;
%         else
%             conn1 = zeros(62);
%             conn2 = connAll;
%             connMapN(:,:,1) = conn1;
%             connMapN(:,:,2) = conn2;
%         end    
%         connMap1 = double(getEEGmap(connMapN,channelPos,electrodes,imread('Empty.tiff'),[0 0 255;255 0 0]));% + double(getEEGmap(conn2,channelPos,electrodes,imread('Empty.tiff'),[127 0 0]));
%         imwrite(uint8(connMap1),strcat(figurefolder,classes(aclass),classes(bclass),'.png'))
%         
%         % Plot them in the same figure
%         if aclass == 1 && bclass==1
%             mapAll = ones(size(connMap1,1) + 400, size(connMap1,2) + 400, 3) * 255;
%             xcooda = 1 + size(connMap1,1) * (0:3) + 200;
%             xcoodb = size(connMap1,1) * (1:4) + 200;
%             ycooda = 1 + size(connMap1,2) * (0:3) + 400;
%             ycoodb = size(connMap1,2) * (1:4) + 400;
%         end
%         
%         mapAll(xcooda(aclass):xcoodb(aclass), ycooda(bclass):ycoodb(bclass), :) = connMap1;
%              
%      end
% 

% end
for aclass = 1:4
    connAll = classifierMat1(:,:,aclass,aclass);
    for bclass = 1:4
        if aclass ~= bclass
            conn1 = classifierMat1(:,:,aclass,bclass) & (~connAll);
            conn2 = classifierMat1(:,:,aclass,bclass) & connAll;
            connMapN(:,:,1) = conn1;
            connMapN(:,:,2) = conn2;
        else
            conn1 = zeros(62);
            conn2 = connAll;
            connMapN(:,:,1) = conn1;
            connMapN(:,:,2) = conn2;
        end    
        connMap1 = double(getEEGmap(connMapN,channelPos,electrodes,imread('Empty.tiff'),[0 0 255;255 0 0]));% + double(getEEGmap(conn2,channelPos,electrodes,imread('Empty.tiff'),[127 0 0]));
        imwrite(uint8(connMap1),strcat(figurefolder,classes(aclass),classes(bclass),'.png'))
        
        % Plot them in the same figure
        if aclass == 1 && bclass==1
            mapAll = ones(size(connMap1,1) + 400, size(connMap1,2) + 400, 3) * 255;
        end
        if aclass == 1 && bclass ==1
            connMap = connMap1;
        else
            connMap = connMap+connMap1;
        end
             
     end

end
% xcood = [xcooda xcoodb(end)-1];
% ycood = [ycooda ycoodb(end)-1];
% 
% mapAll(1:200,1:ycood(5),:) = 255;
% mapAll(1:xcood(5),1:400,:) = 255;
% for a = 1:5
% 
% mapAll = insertShape(mapAll,'Line',[1,xcood(a),ycood(5),xcood(a)],'LineWidth',5,'Color',[0 0 0]);
% mapAll = insertShape(mapAll,'Line',[ycood(a),1,ycood(a),xcood(5)],'LineWidth',5,'Color',[0 0 0]);
% 
% end
% 
% mapAll = insertShape(mapAll,'Line',[1,1,1,xcood(5)],'LineWidth',5,'Color',[0 0 0]);
% mapAll = insertShape(mapAll,'Line',[1,1,ycood(5),1],'LineWidth',5,'Color',[0 0 0]);
% mapAll = insertShape(mapAll,'Line',[ycood(5),1,ycood(5),xcood(5)],'LineWidth',5,'Color',[0 0 0]);
% mapAll = insertShape(mapAll,'Line',[1,xcood(5),ycood(5),xcood(5)],'LineWidth',5,'Color',[0 0 0]);
% 
% % Insert the labels
% % for condi = 1:4
% %     Xc = (xcood(condi) + xcood(condi+1)) / 2;
% %     Yc = (ycood(condi) + ycood(condi+1)) / 2;
% %     X0 = 50;
% %     Y0 = 100;
% %     
% %     switch condi
% %         case 1
% %             text = 'Eyes-open';
% %         case 2
% %             text = 'Eyes-closed';
% %         case 3
% %             text = 'Hot';
% %         case 4
% %             text = 'Warm';
% %     end
% %     
% %     mapAll = insertText(mapAll, [Y0,Xc], text, 'FontSize', 64, 'TextColor', 'black', 'BoxColor', 'white', 'BoxOpacity', 0 );
% %     mapAll = insertText(mapAll, [Yc,X0], text, 'FontSize', 64, 'TextColor', 'black', 'BoxColor', 'white', 'BoxOpacity', 0 );
% % end
%             
% imshow(uint8(mapAll))

