function [CFCdata,time] = getISPCCFCchannelTime(deltaphase,thetaphase,alphaphase,betaphase,featureLabel)
% Get the bands phase
switch featureLabel(1)
    case 0.5
        phase1 = deltaphase(featureLabel(3),:,:);
    case 4
        phase1 = thetaphase(featureLabel(3),:,:);
    case 8
        phase1 = alphaphase(featureLabel(3),:,:);
    case 12.5
        phase1 = betaphase(featureLabel(3),:,:);
end

switch featureLabel(2)
    case 0.5
        phase2 = deltaphase(featureLabel(3),:,:);
    case 4
        phase2 = thetaphase(featureLabel(3),:,:);
    case 8
        phase2 = alphaphase(featureLabel(3),:,:);
    case 12.5
        phase2 = betaphase(featureLabel(3),:,:);
end
time = zeros(size(phase1,3),1);
CFCdata = zeros(size(phase1,3),1);
for p = 1:size(phase1,3)
tic;
dphase = phase1(:,:,p) - phase2(:,:,p);
CFCdata(p,1) = abs(mean(exp(1i.*dphase),2));
time(p,1) = toc;
end

        
end