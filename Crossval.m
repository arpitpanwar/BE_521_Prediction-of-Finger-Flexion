
warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;

%Get data
[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
testDuration = length(traindata_sub1)/sr;

%linear regression
%Cross validation
% [weights_sub1,pred_linreg_sub1]= GenerateLinearRegression(traindata_sub1,...
%     trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,15);

[weights_sub1,pred_ridreg_sub1]= GenerateRidgeRegression(traindata_sub1,...
   trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,45);


sub1 = mean(diag(corr(pred_ridreg_sub1(:,[1,2,3,5]),trainlabels_sub1(:,[1,2,3,5]))));
clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1;

%Get data
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

%linear regression
%Cross validation
% [weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,...
%     trainlabels_sub2,sr,windowSize,displ,traindata_sub2,length(traindata_sub2)/sr,2,15);

[weights_sub2,pred_ridreg_sub2]= ...
GenerateRidgeRegression(traindata_sub2,...
   trainlabels_sub2,sr,windowSize,displ,traindata_sub2,testDuration,2,25);

sub2 = mean(diag(corr(pred_ridreg_sub2(:,[1,2,3,5]),trainlabels_sub2(:,[1,2,3,5]))));

clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2;

%Get data
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

%linear regression
%Cross validation
%  [weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,...
%     trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);

[weights_sub3,pred_ridreg_sub3]= ...
GenerateRidgeRegression(traindata_sub3,...
   trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);

sub3 = mean(diag(corr(pred_ridreg_sub3(:,[1,2,3,5]),trainlabels_sub3(:,[1,2,3,5]))));
clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3;


finalcorr = mean([sub1,sub2,sub3]);
