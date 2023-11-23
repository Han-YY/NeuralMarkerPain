function [CFCdata,bandRef,bandRefInd] = getBinaryClassifiersCFC(blockTagsAC,blockDatasetAC,mode,folderpath,featureNum)
classes = ['OC';'OH';'OW';'CH';'CW';'HW'];
if mode == 0%Power
    [CFCdata,bandRef,bandRefInd] = CFCwithCOH(blockDatasetAC);
else%Phase
    [CFCdata,bandRef,bandRefInd] = CFCwithISPC(blockDatasetAC);
end

for cla = 1:6
    class1 = classes(cla,1);
    class2 = classes(cla,2);
    
    [sFeatures,fWeights,perfMat] = binaryClassCFC(class1,class2,blockTagsAC,CFCdata,mode,folderpath,featureNum);
    
end
end