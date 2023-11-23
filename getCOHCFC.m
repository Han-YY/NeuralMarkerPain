% written by Yiyuan Han, Essex BCI-NE Lab, 12/03/2020
% use coherences to measure the cross-frequency coupling
% Input:
% - data: The input data for analysis, which is channel-by-time-by-trial
% - bin: the length of each bin for calculating the CFC across bins in the
% unit of Hz.
% - band1: The range of the first targetted frequency band, which is in the
% format of [min max]
% - band2: The range of the second targetted frequency band (Optional)
% Output:
% - CFCdata: Outputting CFC measures.

function CFCdata = getCOHCFC(data,bin,band1,band2)
%% Cut the trials into particular frequency bins
% There are two modes, band vs band (4 input arguments), and inner-band (3
% input arguments)
% Firstly, an array containing all frequency bins should be created
if nargin == 4
    bands = [band1(1):bin:band1(2)-bin band2(1):bin:band2(2)-bin];
elseif nargin == 3
    bands = band1(1):bin:band1(2)-bin;
else
    bands = bin;
end

% The bandwidth of each bin is 2*bin, which contains the part before and
% after the boundaries with the length of 0.5*bin

bins = zeros(size(data,1),size(data,2),length(bands));
if nargin == 2
for f0 = 1:size(bands,1)
    fband = bands(f0,:); % The band width is 2*bin, with overlap of 0.5*bin with the neighborhood bins
    filteredData = permute(EEGfilter(permute(data,[2 1 3]),fband,'BP',5,'all',500),[2 1 3]);
    bins(:,:,f0) = permute(abs(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
    binsPh(:,:,f0) = permute(angle(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
end
else
for f0 = 1:length(bands)
    fband = [bands(f0)-0.5*bin bands(f0)+1.5*bin]; % The band width is 2*bin, with overlap of 0.5*bin with the neighborhood bins
    filteredData = permute(EEGfilter(permute(data,[2 1 3]),fband,'BP',5,'all',500),[2 1 3]);
    bins(:,:,f0) = permute(abs(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
    binsPh(:,:,f0) = permute(angle(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
end
end

%% Measuring the coupling with ISPC
CFCdata = zeros(sum(1:length(bands)-1)*62,1);

k = 1;
for m = 1:length(bands)
    power1 = (bins(:,:,m));
    phase1 = (binsPh(:,:,m));
    for n = m+1:length(bands)
      
        % Calculate the ISPCs as the CFC measures
        power2 = (bins(:,:,n));
        phase2 = (bins(:,:,n));
        dphase = phase1-phase2;
        
        COHdata0 = (abs(mean(abs(power1).*abs(power2).*exp(1i.*dphase),2)));% Computing the coupling by ISPC
        CFCdata((k-1)*62+1:k*62,1) = COHdata0';% Reshape the ISPCs and write them in the matrix
        k = k+1;
    end
end
    
end