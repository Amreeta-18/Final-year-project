clc
clear all;
load traindata.mat

% inds = ~strcmp(C,'T');
% X = featuresmat(inds,1:4);
% y = C(inds);

SVMModel = fitcsvm(featuresmat,C);

classOrder = SVMModel.ClassNames

sv = SVMModel.SupportVectors;
figure
gscatter(featuresmat(:,1),featuresmat(:,2),C)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('N','T','Support Vector')
hold off

%testing

load testdata.mat

label = predict(SVMModel,featuresmat);
