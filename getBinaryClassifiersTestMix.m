function getBinaryClassifiersTestMix(blockTagsAC,features,folderpath,nameTag,featureNum)
classes = ['OC';'OH';'OW';'CH';'CW';'HW'];
numType = zeros(6,4);
for cla = 1:6
    class1 = classes(cla,1);
    class2 = classes(cla,2);
    
    [perfMat,numType0] = binaryClassTestMix(class1,class2,blockTagsAC,features,folderpath,nameTag,featureNum);
    
    numType(cla,:) = mean(numType0);
end
writematrix(numType,strcat(folderpath,'/','NumbersFeatureType1.xlsx'),'Sheet',num2str(featureNum));
end