addpath(genpath('../ieeg-matlab-1.13.2/'));

warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 2;
getdata = 1;
if ~exist('run_all', 'var')
    run_all = 1;
end
if ~exist('subject','var')
    subject = 0; % Set in command line for running individual subjects per eniac slice 
end
%% Generate predictions for subject 1

%Get data
disp '  '
disp ' -- '
disp 'Generate predictions for subject 1'

if  run_all == 1 || subject == 1
    subject = 1;
    [traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1, trainduration_sub1, ] = GetDataForSubject1(user);


    % electrode reductionget
    %[weights_sub1, newElectrodes_sub1, trainPredictions_sub1, testPredictions_sub1]= GenerateElectrodeReduction(traindata_sub1,trainlabels_sub1, trainduration_sub1, testdata_sub1, testduration_sub1, sr, .1,.1,1,1);

    % Testing electrode reduction using 100 ms nonoverlapping windows as
    % described in sanchez paper


    %prefilter
    %[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);

    %Logistic regression / movement
    [weights_log_sub1,pred_train_svm_sub1, stats]= GenerateMovementReduction(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1, 25,1000,1200);
    
    %linear regression
    
  %  [weights_sub1,pred_linreg_sub1, stats]= GenerateLinearRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,25);
    
 %   save('pred_linreg_sub1')

    %SVM
    % for i = 1:1    
    %[models_sub1,pred_svm_sub1]= GenerateSVM(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);
    % end

    %load(strcat('pred_svm',num2str(subject),'.mat'));
    %Ridge
    %[weights_sub1,pred_ridreg_sub1]= GenerateRidgeRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

    %Stepwise
    %[weights_sub1,pred_stepreg_sub1]= GenerateStepwiseRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1);

    %LogisticRegression
   % [weights_sub1_log,pred_logreg_sub1]= GenerateLogisticRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,25);

    pred_train_sub1 = pred_linreg_sub1{1};%.* pred_logreg_sub1;
    pred_test_sub1 = pred_linreg_sub1{2};%.* pred_logreg_sub1;

    corr_train{1} = corr([pred_train_sub1(:,1:3), pred_train_sub1(:,5)], [trainlabels_sub1(:,1:3) trainlabels_sub1(:,5)]);
    
    %pred_sub1 = pred_linreg_sub1;%.* pred_logreg_sub1;

    clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1 trainduration_sub1 weights_sub1 stats;
end
%% Generate predictions for subject 2

%Get data

if run_all == 1 || subject == 2
    subject = 2;

    disp '  '
    disp ' -- '
    disp 'Generate predictions for subject 2'

    if getdata == 1
        [traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2, trainduration_sub2] = GetDataForSubject2(user);
    end

    %electrode reduction
    %[weights_electrode_sub2, newElectrodes_sub2 trainPredictions_sub2, testPredictions_sub2]= GenerateElectrodeReduction(traindata_sub2,trainlabels_sub2, trainduration_sub2, testdata_sub2, testduration_sub2, sr,.1,.1,2,1);

    %Logistic regression / movement
    [weights_log_sub2,pred_train_log_sub2, stats]= GenerateMovementReduction(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2, 2, 25,1000,1200);
    
    %linear regression
  %  [weights_sub2,pred_linreg_sub2, stats]= GenerateLinearRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2,25);

    % for i = 1:1    
    %     [models_sub2,pred_svm_sub2]= GenerateSVM(traindata_sub2(:,newElectrodes_sub2{i}),trainlabels_sub2,sr,windowSize,displ,testdata_sub2(:,newElectrodes_sub2{i}),testduration_sub2,2);
    % end

    %save(strcat('pred_svm',num2str(subject),'.mat'),'pred_svm');
    %[weights_sub2,pred_stepreg_sub2]= GenerateStepwiseRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2);

    %Logistic Regression
   % [weights_sub2_log,pred_logreg_sub2]= GenerateLogisticRegression(traindata_sub2,trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2,25);


    %pred_sub2 = pred_linreg_sub2;%.* pred_logreg_sub2;
    pred_train_sub2 = pred_linreg_sub2{1};%.* pred_logreg_sub1;
    pred_test_sub2 = pred_linreg_sub2{2};%.* pred_logreg_sub1;

    corr_train{2} = corr([pred_train_sub2(:,1:3), pred_train_sub2(:,5)], [trainlabels_sub2(:,1:3) trainlabels_sub2(:,5)]);

    clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2  weights_sub2 stats;
end
%% Generate predictions for subject 3
%Get data
if run_all == 1 || subject == 3
    subject = 3;
    disp '  '
    disp ' -- '
    disp 'Generate predictions for subject 3'

    if getdata==1
        [traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3,trainduration_sub3] = GetDataForSubject3(user);
    end

    % Electrode reduction
%     [weights_electrode_sub3, newElectrodes_sub3, trainPredictions_sub3, testPredictions_sub3]= GenerateElectrodeReduction(traindata_sub3,trainlabels_sub3, trainduration_sub3,testdata_sub3,testduration_sub3, sr,.1,.1,3,1);
%      save(strcat('pred_svm',num2str(subject),'.mat'),'pred_svm');

    % traindata_sub3 = traindata_sub2(:,weights_sub3);
    % testdata_sub3 = reduced_test_sub2;

    %linear regression
   
    
    [weights_sub3,pred_linreg_sub3, stats]= GenerateLinearRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3,25);

    % SVM
%     for i = 1:1    
%         [models_sub1,pred_svm_sub3]= GenerateSVM(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3(:,newElectrodes_sub3{i}),testduration_sub3,3);
%     end

    %save(strcat('pred_svm',num2str(subject),'.mat'),'pred_svm');
    %Ridge
    %[weights_sub3,pred_ridreg_sub3]= GenerateRidgeRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

    %Stepwise
    %[weights_sub3,pred_stepreg_sub3]= GenerateStepwiseRegression(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3);

    %Logistic Regression
    [weights_log_sub3,pred_train_log_sub3, stats]= GenerateMovementReduction(traindata_sub3,trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3, 3, 25,1000,1200);

    %pred_sub3 = pred_linreg_sub3;%.* pred_logreg_sub3;
   
    pred_train_sub3 = pred_linreg_sub3{1};%.* pred_logreg_sub1;
    pred_test_sub3 = pred_linreg_sub3{2};%.* pred_logreg_sub1;

    corr_train{3} = corr([pred_train_sub3(:,1:3), pred_train_sub3(:,5)], [trainlabels_sub3(:,1:3) trainlabels_sub3(:,5)]);

    
    clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3 stats;

    %[model_ensemble_learning,predictions_ensemble] = GenerateEnsembleLearning();
    %[model_logistic_regression,predictions_logistic_reg] = GenerateLogisticRegression();
end
%% Gather predictions
predicted_dg = cell(3,1);

averaged_train_corr = size(3,1);
for i = 1:3
    averaged_train_corr(i) = mean(diag(corr_train{i}))
end

averaged_train_corr = mean(averaged_train_corr)

predicted_dg{1} = pred_test_sub1;
predicted_dg{2} = pred_test_sub2;
predicted_dg{3} = pred_test_sub3;

save(strcat('LeaderboardPrediction_LinReg_',num2str(averaged_train_corr),'.mat'),'predicted_dg');