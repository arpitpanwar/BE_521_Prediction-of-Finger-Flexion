addpath(genpath('../ieeg-matlab-1.13.2/'));

warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;
%% Generate predictions for subject 1

%Get data
[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
%linear regression
[weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1);

%SVM
%[models_sub1,pred_svm_sub1]= GenerateSVM(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1);

pred_sub1 = pred_linreg_sub1; % .* pred_svm_sub1;

clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1;

%% Generate predictions for subject 2

%Get data
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

%linear regression
[weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2);

%SVM
%[models_sub2,pred_svm_sub2]= GenerateSVM(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2);

pred_sub2 = pred_linreg_sub2 ;% .* pred_svm_sub2;

clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2;

%% Generate predictions for subject 3
%Get data
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

%linear regression
[weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3);

%SVM
%[models_sub3,pred_svm_sub3]= GenerateSVM(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3);

pred_sub3 = pred_linreg_sub3 ;%.* pred_svm_sub3;

clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3;

%[model_ensemble_learning,predictions_ensemble] = GenerateEnsembleLearning();
%[model_logistic_regression,predictions_logistic_reg] = GenerateLogisticRegression();

%% Gather predictions
predicted_dg = cell(3,1);
predicted_dg{1} = pred_sub1;
predicted_dg{2} = pred_sub2;
predicted_dg{3} = pred_sub3;

%save('SVM_and_LinReg_pred.mat','predicted_dg');