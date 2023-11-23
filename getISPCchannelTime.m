% written by Yiyuan Han, Essex BCI-NE Lab, 09/01/2020
% getISPCchannel: Measure the ISPC between two specific channels from a
% EEG data series
% Input:
% -phase: the input phase data series
% -channel1: the label of channel 1
% -channel2: the label of channel 2
% -electrodes: the electrode map between channel labels and indices
% Output:
% -ISPC: the ISPC value between 2 channels from the data

function [ISPC,time] = getISPCchannelTime(phase,channel1,channel2,electrodes)
% Get the indices of two channels
for k = 1:size(electrodes,2)
    if isequal(cell2mat(electrodes(1,k)),channel1)
        m = k;
        break;
    end
end

for k = 1:size(electrodes,2)
    if isequal(cell2mat(electrodes(1,k)),channel2)
        n = k;
        break;
    end
end
time = zeros(size(phase,3),1);
ISPC = zeros(size(phase,3),1);
for p = 1:size(phase,3)
phase1 = phase(m,:,p);
phase2 = phase(n,:,p);
tic;
dphase = phase1-phase2;
ISPC(p,1) = abs(mean(exp(1i.*dphase),2));
time(p,1) = toc;
end


end