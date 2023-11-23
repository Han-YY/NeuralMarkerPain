function TimeTest = getBinaryClassifiersTestTime(blockTagsAC,features,folderpath,nameTag)
classes = ['OC';'OH';'OW';'CH';'CW';'HW'];
TimeTest = zeros(size(features,3),1);
for cla = 1:6
    class1 = classes(cla,1);
    class2 = classes(cla,2);
    
    [perfMat,TimeTest0] = binaryClassTestTime(class1,class2,blockTagsAC,features,folderpath,nameTag);
    TimeTest = TimeTest+TimeTest0;
end
end