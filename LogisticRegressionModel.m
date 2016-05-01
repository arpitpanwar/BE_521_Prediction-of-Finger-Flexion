function [ weight_mat,chosenFeatures ] = LogisticRegressionModel( train_ecog_data,... 
            train_labels,samplingRate,windowSize,displ,subject,history )
    
        wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    disp 'Generating feature matrix in logistic regression model';
        featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
        featureMat = zscore(featureMat);
%        save(strcat('features_emp',num2str(subject),'_k15.mat'),'featureMat');
    
    switch subject
        case 1
%          load 'features_emp1_k15.mat';
%          load('ranks_emp1_k15.mat');
            numFeatures = 25;
        case 2
%          load 'features_emp2_k15.mat';
%          load('ranks_emp2_k15.mat');
            numFeatures = 25;
        case 3
%          load 'features_emp3_k15.mat';
%          load('ranks_emp3_k15.mat');
            numFeatures = 15;
    end

    clearvars curr;
    
    threshold = (1/5)*max(train_labels);
    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
     
     for i=1:length(threshold)
        trainlabels_decimated(trainlabels_decimated(:,i)>=threshold(i),i) = 2;
        trainlabels_decimated(trainlabels_decimated(:,i)<threshold(i),i) = 1; 
     end 
%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
     
    disp 'Selecting features';
   K = 15;
   features = [];
   ranks = [];
    for i=1:5
      [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
%       inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures));
%       features = [features , ranks(i,1:numFeatures)];
      features = [features , rnk(1:numFeatures)];
      ranks = [ranks;rnk];
    end
         
     save(strcat('ranks_logreg_emp',num2str(subject),'_k',num2str(K),'.mat'),'ranks');

     chosenFeatures = unique(features);
     
     save(strcat('chosenfeatures_logreg_sub',num2str(subject),'.mat'),'chosenFeatures');
     
%     load(strcat('chosenfeatures_sub',num2str(subject),'.mat'));
     
     featureMat = featureMat(:,chosenFeatures);
     
     disp 'Generating feature history';
     
     %featureMat = FeatureHistoryGeneration( featureMat,history );
          
%     featureMat = [ones([size(featureMat,1),1]),featureMat];
    
     weight_mat = zeros([size(featureMat,2)+1,5]);
    
     for i=1:5
    %Generating weight matrix
       w = mnrfit(featureMat,trainlabels_decimated(:,i));
       weight_mat(:,i) = w;
        disp 'Done for one finger';
     end
end

