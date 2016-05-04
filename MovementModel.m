addpath(genpath('/ieeg-matlab-1.13.2/'));

warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 2;
tduration = 147.5;

%[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
% testDuration = length(traindata_sub1)/sr;
%
% %linear regression
% %Cross validation
% [weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,...
%     trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,15);

% [weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,...
%     trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,1,25);

[weights_sub1_logMove,pred_logregMove_sub1]= GenerateMovementReduction(traindata_ecog_sub1,...
        trainlabels,sr,windowSize,displ,testdata_ecog_sub1,tduration,1,3, 800,400);
    

    

    
%% Generate predictions for subject 2

%Get data
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

% linear regression
%  [weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,...
%      trainlabels_sub2,sr,windowSize,displ,testdata_sub2,testduration_sub2,2,15);
[weights_logMove_sub2,pred_logregMove_sub2]= GenerateMovementReduction(traindata_ecog_sub2,...
        trainlabels_sub2,sr,windowSize,displ,testdata_ecog_sub2,tduration,2,3, 400,400);


%% Generate predictions for subject 3

%Get data
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

% %linear regression
% 
%   [weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,...
%      trainlabels_sub3,sr,windowSize,displ,testdata_sub3,testduration_sub3,3,25);

[weights_logMove_sub3,pred_logregMove_sub3]= GenerateMovementReduction(traindata_ecog_sub3,...
        trainlabels_sub3,sr,windowSize,displ,testdata_ecog_sub3,tduration,3,3, 400,400);