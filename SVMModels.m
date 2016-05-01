function [ models,chosenFeatures ] = SVMModels( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject,history )

      wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);

disp 'Generating feature matrix in ridge regression model';
featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
save(strcat('features_svm_sub',num2str(subject),'.mat'),'featureMat');

switch subject
    case 1
        %         load 'features_emp1_k15.mat';
        %         load('ranks_emp1_k15.mat');
        numFeatures = 25;
    case 2
        %         load 'features_emp2_k15.mat';
        %         load('ranks_emp2_k15.mat');
        numFeatures = 25;
    case 3
        %         load 'features_emp3_k15.mat';
        %         load('ranks_emp3_k15.mat');
        numFeatures = 15;
end

clearvars curr;


%Decimate the training labels
trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

for i=1:5
    trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
end

%train_labl_test = trainlabels_decimated;

%trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
split_at = 0.4;
trainlabels_decimated = trainlabels_decimated(1:end-1,:);
trainlabels_decimated(trainlabels_decimated>=split_at) = 2;
trainlabels_decimated(trainlabels_decimated<split_at) = -1;

%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

disp 'Selecting features';
K = 15;
features = [];
ranks = [];
for i=1:5
    [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
    %      inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures));
    %      features = [features , ranks(i,1:numFeatures)];
    features = [features , rnk(1:numFeatures)];
    ranks = [ranks;rnk];
end

save(strcat('ranks_svm_sub',num2str(subject),'.mat'),'ranks');

chosenFeatures = unique(features);

save(strcat('chosenfeatures_svm_sub',num2str(subject),'.mat'),'chosenFeatures');

%    load(strcat('chosenfeatures_k25_sub',num2str(subject),'.mat'));

featureMat = featureMat(:,chosenFeatures);

disp 'Generating feature history';

featureMat = FeatureHistoryGeneration( featureMat,history );
          
    %Generating weight matrix
    models = cell(size(trainlabels_decimated,2),1);
    disp 'Generating models';
    for i=1:size(models,1)
       models{i} = fitcsvm(featureMat,trainlabels_decimated(:,i),'Standardize',true);
       models{i} = compact(models{i});
       i
    end
end

