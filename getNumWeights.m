mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
mainfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_Main/';
resultfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_tables/';
nametag = {'_PhaseConn','_PowerConn','_PhaseCoup','_PowerCoup'};

classes = {'OvsC','OvsH','OvsW','CvsH','CvsW','HvsW'};
% Read the data
fileIndex = 4;
featureNum = [0 100];
numMat = zeros(1,5);
currPerfMat = zeros(1,5);
weights = [0.1 0.25 0.5 0.9 1];


     
    tl = 4;
    lengthName = mainfolderlist{tl};
    lengthName = lengthName(3:end);
    foldername = mainfolderlist{fileIndex};
    for swap = 1:2
        
        if swap ==1
            folderPath = strcat(mainfolder,foldername);
        else
            folderPath = strcat(mainfolder,foldername,'_Swap');
        end
        
        folderpathP1 = string([folderPath '/1_PhaseConn']);
        
        for w = 1:5
        [featureLabels1,selectFeatureMat1,conditionFeature1,conditionFeatureMat1,featureLabelIndex1,currPerc1] = getFeatureLabelPerc(folderpathP1,featureNum.*2,1,weights(w),0);
        
        numMat(classifier,w) = numMat(classifier,w) + length(featureLabelIndex1);
        currPerfMat(classifier,w) = currPerfMat(classifier,w) + currPerc1;

        end
    end
    




numMat2 = numMat/2;
currPerfMat2 = currPerfMat/2;