addpath(genpath('../ieeg-matlab-1.13.2/'));

warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;
getdata = 1;
%% Generate predictions for subject 1

%Get data
disp '  '
disp ' -- '
disp 'Generate predictions for subject 1'

if getdata == 1
    [traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);
end

% electrode reduction
[weights_sub1, reduced_feats_sub1]= GenerateElectrodeReduction(traindata_sub1,trainlabels_sub1,sr,windowSize,displ);

% Testing electrode reduction using 100 ms nonoverlapping windows as
% described in sanchez paper

% windowSize = .1;
% disp = .1;
% [weights_sub1b, reduced_feats_sub1b]= GenerateElectrodeReduction(traindata_sub1,trainlabels_sub1,sr,windowSize,displ);

% traindata_sub1 = traindata_sub1(:,weights_sub1);
% testdata_sub1 = reduced_test_sub1;

%prefilter
%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);

%linear regression
[weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

%SVM
%[models_sub1,pred_svm_sub1]= GenerateSVM(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1);

%Ridge
%[weights_sub1,pred_ridreg_sub1]= GenerateRidgeRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

%Stepwise
%[weights_sub1,pred_stepreg_sub1]= GenerateStepwiseRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

%LogisticRegression
%[weights_sub1_log,pred_logreg_sub1]= GenerateLogisticRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

pred_sub1 = pred_linreg_sub1;%.* pred_logreg_sub1;

clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1;

%% Generate predictions for subject 2

%Get data
disp '  '
disp ' -- '
disp 'Generate predictions for subject 2'

if getdata == 1
    [traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);
end

%electrode reduction
[weights_sub2, reduced_feats_sub2]= GenerateElectrodeReduction(traindata_sub2,trainlabels_sub2,sr,windowSize,displ);

% traindata_sub2 = traindata_sub2(:,weights_sub2);
% testdata_sub2 = reduced_test_sub2;


%linear regression
[weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

%SVM
%[models_sub2,pred_svm_sub2]= GenerateSVM(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2);

%Ridge
%[weights_sub2,pred_ridreg_sub2]= GenerateRidgeRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

%Stepwise
%[weights_sub2,pred_stepreg_sub2]= GenerateStepwiseRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

%Logistic Regression
%[weights_sub2_log,pred_logreg_sub2]= GenerateLogisticRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);


pred_sub2 = pred_linreg_sub2;%.* pred_logreg_sub2;


clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2;

%% Generate predictions for subject 3
%Get data

disp '  '
disp ' -- '
disp 'Generate predictions for subject 3'

if getdata==1
    [traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);
end

% Electrode reduction
[weights_sub3, reduced_feats_sub3]= GenerateElectrodeReduction(traindata_sub3,trainlabels_sub3,sr,windowSize,displ);


% traindata_sub3 = traindata_sub2(:,weights_sub3);
% testdata_sub3 = reduced_test_sub2;

%linear regression
[weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

%SVM
%[models_sub3,pred_svm_sub3]= GenerateSVM(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3);

%Ridge
%[weights_sub3,pred_ridreg_sub3]= GenerateRidgeRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

%Stepwise
%[weights_sub3,pred_stepreg_sub3]= GenerateStepwiseRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

%Logistic Regression
%[weights_sub3_log,pred_logreg_sub3]= GenerateLogisticRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

pred_sub3 = pred_linreg_sub3;%.* pred_logreg_sub3;

clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3;

%[model_ensemble_learning,predictions_ensemble] = GenerateEnsembleLearning();
%[model_logistic_regression,predictions_logistic_reg] = GenerateLogisticRegression();

%% Gather predictions
predicted_dg = cell(3,1);
predicted_dg{1} = pred_sub1;
predicted_dg{2} = pred_sub2;
predicted_dg{3} = pred_sub3;

%save('LeaderboardPrediction_logisticReg.mat','predicted_dg');