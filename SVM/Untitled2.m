clc
clear all;
load traindata.mat
groups = ismember(type,'T'); 
% 8 samples. thus 4 groups of 2 samples each. train with 3. test with 1.
k=4;

cvFolds = crossvalind('Kfold', groups, k);   %# get indices of 10-fold CV
cp = classperf(groups);    

for i = 1:k                                       %# for each fold
        testIdx = (cvFolds == i);                %# get indices of test instances
        trainIdx = ~testIdx;                     %# get indices training instances
        
        %# train an SVM model over training instances
        svmModel = svmtrain(featuresmat(trainIdx,:), groups(trainIdx), ...
            'Autoscale',true, 'Showplot',false, 'Method','QP', ...
            'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'RBF_Sigma',1);
        
        %# test using test instances
        pred = svmclassify(svmModel, featuresmat(testIdx,:), 'Showplot',false);
        
        %# evaluate and update performance object
        cp = classperf(cp, pred, testIdx);
end
    
 %# get accuracy
    cp.CorrectRate