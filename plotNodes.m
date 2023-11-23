
connMap = imread('Empty.tiff');

% Create all reference nodes
for node = 1:size(channelPos,2)
    if sum(contains(electroSele, electrodes{node})) ~= 0
    connMap = insertShape(connMap,'FilledCircle',[channelPos(1,node) channelPos(2,node) 5],'Color',[0 127 127]);
    connMap = insertText(connMap, [channelPos(1,node)+5 channelPos(2,node)+5], electrodes{node}, 'FontSize', 16, 'BoxColor', 'white');
    else
        connMap = insertShape(connMap,'FilledCircle',[channelPos(1,node) channelPos(2,node) 5],'Color',[0 0 0]);
    end
end

imshow(connMap)
saveas(gcf,'/Users/yiyuan/OneDrive - University of Essex/PG Research/0B_Conference/202110_EMBC 2022/Fig1','epsc')

