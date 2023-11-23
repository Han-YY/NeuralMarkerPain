function [CFCdata,time] = getCOHCFCchannelTime(deltaphase,thetaphase,alphaphase,betaphase,deltapower,thetapower,alphapower,betapower,featureLabel)
% Get the bands phase
switch featureLabel(1)
    case 0.5
        phase1 = deltaphase(featureLabel(3),:,:);
        power1 = deltapower(featureLabel(3),:,:);
        
    case 4
        phase1 = thetaphase(featureLabel(3),:,:);
        power1 = thetapower(featureLabel(3),:,:);
    case 8
        phase1 = alphaphase(featureLabel(3),:,:);
        power1 = alphapower(featureLabel(3),:,:);
    case 12.5
        phase1 = betaphase(featureLabel(3),:,:);
        power1 = betapower(featureLabel(3),:,:);
end

switch featureLabel(2)
    case 0.5
        phase2 = deltaphase(featureLabel(3),:,:);
        power2 = deltapower(featureLabel(3),:,:);
        
    case 4
        phase2 = thetaphase(featureLabel(3),:,:);
        power2 = thetapower(featureLabel(3),:,:);
    case 8
        phase2 = alphaphase(featureLabel(3),:,:);
        power2 = alphapower(featureLabel(3),:,:);
    case 12.5
        phase2 = betaphase(featureLabel(3),:,:);
        power2 = betapower(featureLabel(3),:,:);
end

time = zeros(size(phase1,3),1);
CFCdata = zeros(size(phase1,3),1);
for p = 1:size(phase1,3)
tic;
dphase = phase1(:,:,p) - phase2(:,:,p);
CFCdata(p,1) = (abs(mean(abs(power1(:,:,p)).*abs(power2(:,:,p)).*exp(1i.*dphase),2)));
time(p,1) = toc;
end
        
end