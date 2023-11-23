function [classPredictions,scoreP]=getBinaryClassifiers(blockTagsAC,blockDatasetAC,mode,folderpath,featureNum)
classes = ['OC';'OH';'OW';'CH';'CW';'HW'];

for cla = 1:6
    class1 = classes(cla,1);
    class2 = classes(cla,2);
    
    [sFeatures,fWeights,perfMat] = binaryClass(class1,class2,blockTagsAC,blockDatasetAC,mode,folderpath,featureNum);
    
end
end