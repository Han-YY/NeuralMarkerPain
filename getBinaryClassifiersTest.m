function getBinaryClassifiersTest(blockTagsAC,features,folderpath,nameTag)
classes = ['OC';'OH';'OW';'CH';'CW';'HW'];

for cla = 1:6
    class1 = classes(cla,1);
    class2 = classes(cla,2);
    
    perfMat = binaryClassTest(class1,class2,blockTagsAC,features,folderpath,nameTag);
    
end
end