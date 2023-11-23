mainfolderlist = {'1_1s';'2_2s5';'3_5s';'4_10s'};
mainfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_';
resultfolder = '/Users/yiyuan/OneDrive - University of Essex/PG Research/0A_Journal/202004_unknown Journal_Probability Score/1_Results/0_Final Results/Results_tables/';
featureNum = {'10features','20features','30features','40features','50features','60features','70features','80features','90features','100features'};
nametag = {'_PhaseConn','_PowerConn','_PhaseCoup','_PowerCoup'};

classes = {'OvsC','OvsH','OvsW','CvsH','CvsW','HvsW'};

num_lengthAccuracy = zeros(6,10);
    num_lengthSTD = zeros(6,10);
for classifier = 1:6
    
    tl = 4;
    lengthName = mainfolderlist{tl};
    lengthName = lengthName(3:end);
    for fn = 1:10%Feature Number
        conf_length = zeros(4,4);
        nt = 1;%Name Tag
            
            folderpath1 = strcat(mainfolder,featureNum{fn},'/', mainfolderlist{tl},'/binaryTest',nametag{nt},'.xlsx');
            folderpath2 = strcat(mainfolder,featureNum{fn},'/', mainfolderlist{tl},'_Swap/binaryTest',nametag{nt},'.xlsx');
             if isfile(folderpath1) && isfile(folderpath2)
                 try
                dataRead = [readmatrix(folderpath1,'Sheet',classes{classifier});readmatrix(folderpath2,'Sheet',classes{classifier})];
                 catch
                     dataRead = NaN(1,8);
                 end
             else
                 dataRead = NaN(1,8);
             end
            num_lengthAccuracy(classifier,fn) = mean(dataRead(:,2));
            num_lengthSTD(classifier,fn) = std(dataRead(:,2));
            
            for cm = 1:4%For cancelling the effects of NaN
                currData = dataRead(:,cm+4);
            conf_length(nt,cm) = mean(currData(~isnan(currData)));
            end
            
        
        writematrix(conf_length,strcat(resultfolder,'CM_',classes{classifier},'_',lengthName,'.xlsx'),'Sheet',strcat(featureNum{fn}));
    end
    
    
writematrix(num_lengthAccuracy,strcat(resultfolder,'Accuracy.xlsx'),'Sheet',classes{classifier});
    writematrix(num_lengthSTD,strcat(resultfolder,'STD.xlsx'),'Sheet',classes{classifier});
end


