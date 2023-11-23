% written by Yiyuan Han, Essex BCI-NE Lab, 03/03/2020
% Use ISPCs to measure the cross-frequency coupling
% getISPCCFC: Calculating the CFC measures with the ISPCs
% Input:
% - data: The input data for analysis, which is channel-by-time-by-trial
% - bin: the length of each bin for calculating the CFC across bins in the
% unit of Hz.
% - band1: The range of the first targetted frequency band, which is in the
% format of [min max]
% - band2: The range of the second targetted frequency band (Optional)
% Output:
% - CFCdata: Outputting CFC measures.


function CFCdata = getISPCCFC(data,bin,band1,band2)
%% Cut each trial into frequency bins
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

% The actual total frequency range of each bin should be 2*bin so that
% there would be proper overlaps among the neighborhood bins
bins = zeros(size(data,1),size(data,2),length(bands));

if nargin == 2
    for f0 = 1:size(bands,1)
        fband = bands(f0,:); % The band width is 2*bin, with overlap of 0.5*bin with the neighborhood bins
    filteredData = permute(EEGfilter(permute(data,[2 1 3]),fband,'BP',5,'all',500),[2 1 3]);
    bins(:,:,f0) = permute(angle(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
    end
else
for f0 = 1:length(bands)
    fband = bands; % The band width is 2*bin, with overlap of 0.5*bin with the neighborhood bins
    filteredData = permute(EEGfilter(permute(data,[2 1 3]),fband,'BP',5,'all',500),[2 1 3]);
    bins(:,:,f0) = permute(angle(hilbert(permute(filteredData,[2 1 3]))),[2 1 3]);
end
end

%% Measuring the coupling with ISPC
CFCdata = zeros(sum(1:length(bands)-1)*62,1);

k = 1;
for m = 1:length(bands)
    phase1 = bins(:,:,m);
    for n = m+1:length(bands)
      
        % Calculate the ISPCs as the CFC measures
        phase2 = bins(:,:,n);
        dphase = phase1 - phase2;
        CFCdata0 = abs(mean(exp(1i.*dphase),2));% Computing the coupling by ISPC
        CFCdata((k-1)*62+1:k*62,1) = CFCdata0';% Reshape the ISPCs and write them in the matrix
        k = k+1;
    end
end
    
end