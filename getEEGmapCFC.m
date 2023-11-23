% written by Yiyuan Han, Essex BCI-NE Lab, 03/09/2020
% getEEGmapCFC: get the map of the channels with CFC as the selected
% features
function CFCmap = getEEGmapCFC(featureLabels,channelPos,electrodes,map)
CFCmap = imread(map);
indices = unique(featureLabels(3,:));
for node = 1:size(channelPos,2)
    CFCmap = insertShape(CFCmap,'FilledCircle',[channelPos(1,node) channelPos(2,node) 5],'Color',[0 0 0]);
end
for k = 1:length(indices)
    index = indices(k);
    findex = find(featureLabels(3,:) == index);
    a = channelPos(1,index);
    b = channelPos(2,index);
    
    CFCmap = insertShape(CFCmap,'FilledCircle',[channelPos(1,node) channelPos(2,node) 10],'Color',[0 127 12]);
    CFCmap = insertText(CFCmap,[a b-20],electrodes{index},'TextColor',[0 0 0],'BoxColor','white','FontSize',28,'Font','LucidaSansDemiBold');
    
    f1 = featureLabels(1,findex);
    f2 = featureLabels(2,findex);
%     fre1 = num2str(f1);
%     fre2 = num2str(f2);
%     CFCmap = insertShape(CFCmap,[a b+10],fre1,'TextColor',[0 1 1],);
%     CFCmap = insertText(CFCmap,[a b+30],fre2,'BoxColor','white);
    if ismember(0.5,[f1,f2])
    CFCmap = insertShape(CFCmap,'FilledRectangle',[a-20 b-20 20 20],'Color',[255 0 0]);
    end
    if ismember(4,[f1,f2])
    CFCmap = insertShape(CFCmap,'FilledRectangle',[a b-20 20 20],'Color',[0 255 0]);
    end
    if ismember(8,[f1,f2])
    CFCmap = insertShape(CFCmap,'FilledRectangle',[a-20 b 20 20],'Color',[0 0 255]);
    end
    if ismember(12.5,[f1,f2])
    CFCmap = insertShape(CFCmap,'FilledRectangle',[a b 20 20],'Color',[255,255,0]);
    end
end
CFCmap = CFCmap(60:size(CFCmap,1)-60,60:size(CFCmap,2)-60,:);
end