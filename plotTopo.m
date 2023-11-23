% eeglab
%foldername = 'C:\Users\yh19218\OneDrive - University of Essex\PG Research\3_Data\Rename';%For Windows
foldername = '/Users/yiyuan/OneDrive - University of Essex/PG Research/3_Data/Rename';%For MacOS
fileDetail = dir(foldername);
filename = {};
% Read al file names conteined in the targeted folder
for r = 3:size(fileDetail,1)
    filename{end+1} = fileDetail(r).name;
end

% setFileList = filename(contains(filename,'set'));%Get all set files for loading the data
%% Load the data into workspace
% Create the matrix to store the tags describing the conditions in each
% data bundle (including the numbers of each participant's order and the
% condition (i.e. H,W,C,O)
tags = zeros(size(setFileList,2),2);
for order = 1:size(setFileList,2)
    file0 = setFileList{1,order};%Read current filename
    tags(order,1) = str2num(file0(1:2));
    tags(order,2) = file0(end-4);%The condition was stored as integers, which can be transformed into chars with the function char()
end

powerData = zeros(4,62);
fre = [0.5 4; 4 7; 8 12; 12.5 16;30 80];
figure

for fIndex = 1:5
for order = 1:size(setFileList,2)
    if char(tags(order,2)) ~= 'S'
    dataSet0 = pop_loadset(setFileList{1,order},'/Users/yiyuan/OneDrive - University of Essex/PG Research/3_Data/Rename');
    dataSet0 = pop_interp(dataSet0, [55,58], 'spherical');
    sr0 = dataSet0.srate;%The sampling rate
    data0 = laplacian_perrinX(dataSet0.data,extractfield(dataSet0.chanlocs,'X'),extractfield(dataSet0.chanlocs,'Y'),extractfield(dataSet0.chanlocs,'Z'));% The tested data
    if fIndex == 5
        power0 = mean(pwelch(data0',5000,1000,fre(fIndex,1):2:fre(fIndex,2),500));
    else
        power0 = mean(pwelch(data0',5000,1000,fre(fIndex,1):0.2:fre(fIndex,2),500));
    end
    % power0 = (power0-mean(power0))/std(power0);
    

    switch char(tags(order,2))
        case 'O'
            powerData(1,:) = powerData(1,:) + power0;
        case 'C'
            powerData(2,:) = powerData(2,:) + power0;
        case 'H'
            powerData(3,:) = powerData(3,:) + power0;
        case 'W'
            powerData(4,:) = powerData(4,:) + power0;
    end
        
    end
end

powerDataTopo(1,:) = powerData(1,:)/length(find(tags(:,2) == 'O'));
powerDataTopo(2,:) = powerData(2,:)/length(find(tags(:,2) == 'C'));
powerDataTopo(3,:) = powerData(3,:)/length(find(tags(:,2) == 'H'));
powerDataTopo(4,:) = powerData(4,:)/length(find(tags(:,2) == 'W'));

%  for r = 1:4
% 
%  end
% powerDataTopo = abs(powerDataTopo);

subplot(5,4,1+4*(fIndex-1))
topoplot(powerDataTopo(1,:),dataSet0.chanlocs);
% title('Eyes-open','FontSize',16)
colorbar;
subplot(5,4,2+4*(fIndex-1))
topoplot(powerDataTopo(2,:),dataSet0.chanlocs);

% title('Eyes-closed','FontSize',16)
colorbar;
subplot(5,4,3+4*(fIndex-1))
topoplot(powerDataTopo(3,:),dataSet0.chanlocs);

% title('Hot','FontSize',16)
colorbar;
subplot(5,4,4+4*(fIndex-1))
%topoplot(powerDataTopo(4,:),dataSet0.chanlocs,'maplimits',[-0.75 0.75]);
topoplot(powerDataTopo(4,:),dataSet0.chanlocs);
% title('Warm','FontSize',16)
colorbar;
colormap default
set(gca,'DefaultTextFontSize',18)
c = colorbar('southoutside');
c.Label.String = 'z-score';
c.Label.FontSize = 12;


end
