
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
    trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,25);
    
%LogisticRegression
[weights_sub1_log,pred_logreg_sub1]= GenerateLogisticRegression(traindata_sub1,...
        trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,25);

%Ensemble Learning
[models_sub1,pred_ensem_sub1]= GenerateEnsembleLearning(traindata_sub1, ...
    trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,25);

%SVM
% [models_svm_sub1,pred_svm_sub1]= GenerateSVM(traindata_sub1,trainlabels_sub1,...
%         sr,windowSize,displ,traindata_sub1,testDuration, 1, 25);

pred_classifier_sub1 = zeros(size(pred_logreg_sub1));
for i=1:5    
    pred_classifier_sub1(:,i) = mean([(pred_logreg_sub1(:,i)),(pred_ensem_sub1(:,i))],2);
end

pred_cv_sub1 = pred_ridreg_sub1.*pred_classifier_sub1;

	
[~,filterWeights] = GetFilterWeights(trainlabels_sub1,pred_cv_sub1);
save('FilterWeights_sub1.mat','filterWeights');


pred_cv_sub1 = PostFilter(pred_cv_sub1,filterWeights);

sub1 = mean(diag(corr(pred_cv_sub1(:,[1,2,3,5]),trainlabels_sub1(:,[1,2,3,5]))));


clearvars traindata_sub1 trainlabels_sub1 testdata_sub1 testduration_sub1 filterWeights train_limits;

%% Sub 2
%Get data
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

%linear regression
%Cross validation
% [weights_sub2,pred_linreg_sub2]= GenerateLinearRegression(traindata_sub2,...
%     trainlabels_sub2,sr,windowSize,displ,traindata_sub2,length(traindata_sub2)/sr,2,15);

[weights_sub2,pred_ridreg_sub2]= ...
GenerateRidgeRegression(traindata_sub2,...
   trainlabels_sub2,sr,windowSize,displ,traindata_sub2,testDuration,2,25);

%Logistic Regression   
[weights_sub2_log,pred_logreg_sub2]= ...
    GenerateLogisticRegression(traindata_sub2,trainlabels_sub2,sr,...
        windowSize,displ,traindata_sub2,testDuration,2,25);
	
%Ensemble Learning
[models_sub2,pred_ensem_sub2]= GenerateEnsembleLearning(traindata_sub2, ...
        trainlabels_sub2,sr,windowSize,displ,traindata_sub2,testDuration,2,25);

%SVM
% [models_svm_sub2,pred_svm_sub2]= GenerateSVM(traindata_sub2,trainlabels_sub2,...
%         sr,windowSize,displ,traindata_sub2,testDuration,2, 25);

pred_classifier_sub2 = zeros(size(pred_logreg_sub2));

for i=1:5    
    pred_classifier_sub2(:,i) = mean([(pred_logreg_sub2(:,i)),(pred_ensem_sub2(:,i))],2);
end

pred_cv_sub2 = pred_ridreg_sub2.*pred_classifier_sub2;

[~,filterWeights] = GetFilterWeights(trainlabels_sub2,pred_cv_sub2);
save('FilterWeights_sub2.mat','filterWeights');

pred_cv_sub2 = PostFilter(pred_cv_sub2,filterWeights);


sub2 = mean(diag(corr(pred_cv_sub2(:,[1,2,3,5]),trainlabels_sub2(:,[1,2,3,5]))));

clearvars traindata_sub2 trainlabels_sub2 testdata_sub2 testduration_sub2 filterWeights;

%Get data
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

%linear regression
%Cross validation
%  [weights_sub3,pred_linreg_sub3]= GenerateLinearRegression(traindata_sub3,...
%     trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);

[weights_sub3,pred_ridreg_sub3]= ...
GenerateRidgeRegression(traindata_sub3,...
   trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);
   
[weights_sub3_log,pred_logreg_sub3]= GenerateLogisticRegression(traindata_sub3,...
        trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);
	
%Ensemble Learning
[model_sub3,pred_ensem_sub3]= GenerateEnsembleLearning(traindata_sub3,... 
        trainlabels_sub3,sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3,25);

%SVM
% [models_svm_sub3,pred_svm_sub3]= GenerateSVM(traindata_sub3,trainlabels_sub3,...
%         sr,windowSize,displ,traindata_sub3,length(traindata_sub3)/sr,3, 25);
	

pred_classifier_sub2 = zeros(size(pred_logreg_sub2));
for i=1:5    
    pred_classifier_sub2(:,i) = mean([(pred_logreg_sub2(:,i)),(pred_ensem_sub2(:,i))],2);
end
    
pred_cv_sub3 = pred_ridreg_sub3.*pred_classifier_sub3;

[~,filterWeights] = GetFilterWeights(trainlabels_sub3,pred_cv_sub3);
save('FilterWeights_sub3.mat','filterWeights');

pred_cv_sub3 = PostFilter(pred_cv_sub3,filterWeights);

sub3 = mean(diag(corr(pred_cv_sub3(:,[1,2,3,5]),trainlabels_sub3(:,[1,2,3,5]))));

clearvars traindata_sub3 trainlabels_sub3 testdata_sub3 testduration_sub3 filterWeights;

finalcorr = mean([sub1,sub2,sub3]);


weights_logreg = cell(3,1);
weights_logreg{1} = weights_sub1_log;
weights_logreg{2} = weights_sub2_log;
weights_logreg{3} = weights_sub3_log;


weights_pred_ridreg = cell(3,1);
weights_pred_ridreg{1} = weights_sub1;
weights_pred_ridreg{2} = weights_sub2;
weights_pred_ridreg{3} = weights_sub3;

models_ensemble = cell(3,1);
models_ensemble{1} = model_sub1;
models_ensemble{2} = model_sub2;
models_ensemble{3} = model_sub3;

save('SavedModels.mat','weights_logreg','weights_pred_ridreg','models_ensemble');