% written by Yiyuan Han, Essex BCI-NE Lab, 01/06/2020
% getEEGmap: mark the connections between different EEG chennels accroding
% to the connectivity matrix
% Input:
% -connMat: the matrix storing the connectivity parameters between each
% pair of channels, whose dimension should be channel x channel
% channelPos: the positions of all channels in the EEG map image
% map: the image of EEG map

function connMap = getEEGmap(connMat0,channelPos,electrodes,map,color)
if length(size(connMat0)) == 2
    connMat(:,:,1) = connMat0;
else
    connMat = connMat0;
end

connMap = map;

% Create all reference nodes
for node = 1:size(channelPos,2)
    connMap = insertShape(connMap,'FilledCircle',[channelPos(1,node) channelPos(2,node) 5],'Color',[0 0 0]);
end



for cIndex = 1:size(connMat,3)
[x,y]= find(connMat(:,:,cIndex)~=0);% Locate the pairs with strong connections
channelPos = floor(channelPos);%Transform coordinates to int

nodes = unique([x;y]);% Get all channels' indices existing in the pairs as the selected classification features

% Highlight the nodes with strong connectivity
for k = 1:length(nodes)
     a = channelPos(1,nodes(k));
     b = channelPos(2,nodes(k));
%     
     connMap(b-20:b+20,a-20:a+20) = connMap(b-20:b+20,a-20:a+20) - 100;
     connMap = insertShape(connMap,'FilledCircle',[a,b,10],'Color',[0 127 127]);
     connMap = insertText(connMap,[a b-20],electrodes{nodes(k)},'TextColor',[0 0 0],'BoxColor','white','FontSize',28,'Font','LucidaSansDemiBold');
    
end

for r = 1:size(x,1)
    p1 = channelPos(:,x(r));
    p2 = channelPos(:,y(r));
%     lw = round((connMat(x(r),y(r))-0.9)*100);%Line width
%     if lw < 1
%         lw = 1;
%     end


    connMap = insertShape(connMap,'Line',[p1' p2'],'LineWidth',3,'Color',color(cIndex,:));
    
end
end

connMap = connMap(60:size(connMap,1)-60,60:size(connMap,2)-60,:);

end