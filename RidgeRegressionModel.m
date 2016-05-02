function [ weight_mat,chosenFeatures ] = RidgeRegressionModel( train_ecog_data,...
    train_labels,samplingRate,windowSize,displ,subject,history )

wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);

disp 'Generating feature matrix in ridge regression model';
% featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
% save(strcat('features_sub',num2str(subject),'.mat'),'featureMat');

switch subject
    case 1
                load 'features_sub1.mat';
                load('ranks_sub1.mat');
        numFeatures = 25;
    case 2
                load 'features_sub2.mat';
                load('ranks_sub2.mat');
        numFeatures = 25;
    case 3
                load 'features_sub3.mat';
                load('ranks_sub3.mat');
        numFeatures = 15;
end

clearvars curr;


%Decimate the training labels
trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

for i=1:5
    trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
end

train_labl_test = trainlabels_decimated;

trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
%trainlabels_decimated = trainlabels_decimated(1:end-1,:);

%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

disp 'Selecting features';
K = 10;
features = [];
ranks = [];
for i=1:5
    [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
    %      inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures));
    %      features = [features , ranks(i,1:numFeatures)];
    features = [features , rnk(1:numFeatures)];
    ranks = [ranks;rnk];
end

save(strcat('ranks_sub',num2str(subject),'.mat'),'ranks');

chosenFeatures = unique(features);

save(strcat('chosenfeatures_sub',num2str(subject),'.mat'),'chosenFeatures');

%    load(strcat('chosenfeatures_k25_sub',num2str(subject),'.mat'));

featureMat = featureMat(:,chosenFeatures);

disp 'Generating feature history';

featureMat = FeatureHistoryGeneration( featureMat,history );

ridge_coeff = 1e4;
disp 'Generating weight matrix in ridge regression';
%Generating weight matrix
weight_mat = zeros([size(featureMat,2)+1,5]);
for i=1:5
    weight_mat(:,i) = ridge(trainlabels_decimated(:,i),featureMat,ridge_coeff,0) ;
end

end

