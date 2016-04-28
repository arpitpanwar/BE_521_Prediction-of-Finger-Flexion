addpath(genpath('../ieeg-matlab-1.13.2/'));

warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;
%% Generate predictions for subject 1

%Get data
[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);

history = 45;

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
% testDuration = length(traindata_sub1)/sr;
%
% %linear regression
% %Cross validation
% [weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,...
%     trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,15);

% [weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,...
%     trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,15);

%SVM
%[models_sub1,pred_svm_sub1]= GenerateSVM(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1, subject, history);

% trainlen = length(traindata_sub1);
% testdata_sub1 = traindata_sub1(1:(round(trainlen/2)),:);
% traindata_sub1 = traindata_sub1((round(trainlen/2)+1):end,:);
%
% trainlabels_sub1 = trainlabels_sub1((round(trainlen/2)+1):end,:);
% testlabels_sub1 = trainlabels_sub1(1:(round(trainlen/2)),:);
% testduration_sub1 = length(testdata_sub1)/1e3;

% %Ridge
[weights_sub1,pred_ridreg_sub1]= GenerateRidgeRegression(traindata_sub1,...
    trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,25);

%Stepwise
%[weights_sub1,pred_stepreg_sub1]= GenerateStepwiseRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

%LogisticRegression
% [weights_sub1_log,pred_logreg_sub1]= GenerateLogisticRegression(traindata_sub1,...
%         trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,45);

%Ensemble Learning
%[models_sub1,pred_ensem_sub1]= GenerateEnsembleLearning(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);


pred_sub1 = pred_ridreg_sub1;%.* pred_logreg_sub1;

load('FilterWeights_sub1.mat');

%pred_sub1 = PostFilter(pred_sub1,filterWeights);

clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1 filterWeights;

%% Generate predictions for subject 2

%Get data
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

%linear regression
%  [weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,...
%      trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2,15);

%SVM
%[models_sub2,pred_svm_sub2]= GenerateSVM(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,subject, history);

% Ridge
[weights_sub2,pred_ridreg_sub2]= ...
    GenerateRidgeRegression(traindata_sub2,...
    trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2,25);

%Stepwise
%[weights_sub2,pred_stepreg_sub2]= GenerateStepwiseRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

%Logistic Regression
% [weights_sub2_log,pred_logreg_sub2]= ...
%     GenerateLogisticRegression(traindata_sub2,trainlabels_sub2,sr,...
%         windowSize,displ,testdata_sub2,testduration_sub2,2,25);

%Ensemble Learning
%[models_sub2,pred_ensem_sub2]= GenerateEnsembleLearning(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

pred_sub2 = pred_ridreg_sub2;%.* pred_logreg_sub2;

load('FilterWeights_sub2.mat');

%pred_sub2 = PostFilter(pred_sub2,filterWeights);

clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2 filterWeights;

%% Generate predictions for subject 3

%Get data
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

%linear regression

%   [weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,...
%      trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3,25);

%SVM
%[models_sub3,pred_svm_sub3]= GenerateSVM(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,subject, history);

%Ridge
[weights_sub3,pred_ridreg_sub3]= ...
    GenerateRidgeRegression(traindata_sub3,...
    trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3,25);

%Stepwise
%[weights_sub3,pred_stepreg_sub3]= GenerateStepwiseRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

%Logistic Regression
% [weights_sub3_log,pred_logreg_sub3]= GenerateLogisticRegression(traindata_sub3,...
%         trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3,25);


%Ensemble Learning
%[model_sub3,pred_ensem_sub3]= GenerateEnsembleLearning(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

pred_sub3 = pred_ridreg_sub3;%.* pred_logreg_sub3;

load('FilterWeights_sub3.mat');

%pred_sub3 = GetFilterWeights(trainlabels_sub3,pred_sub3);

clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3 filterWeights;

%[model_ensemble_learning,predictions_ensemble] = GenerateEnsembleLearning();
%[model_logistic_regression,predictions_logistic_reg] = GenerateLogisticRegression();

%% Gather predictions
predicted_dg = cell(3,1);
predicted_dg{1} = pred_sub1;
predicted_dg{2} = pred_sub2;
predicted_dg{3} = pred_sub3;

weights_pred_linreg = cell(3,1);
weights_pred_linreg{1} = weights_sub1;
weights_pred_linreg{2} = weights_sub2;
weights_pred_linreg{3} = weights_sub3;


save('LeaderboardPrediction_ridge_postfilter.mat','predicted_dg');