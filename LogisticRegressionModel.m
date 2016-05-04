function [ weight_mat,chosenFeatures ] = LogisticRegressionModel( train_ecog_data,... 
            train_labels,samplingRate,windowSize,displ,subject,history )
    if ~isnumeric(history)           
        runningCells = history{1};
        runningTimes = history{2};
        history = 0;
    end
            wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);

    if ~savefileExists(strcat('features_log',num2str(subject),'.mat'));
        disp 'Generating feature matrix in logistic regression model';
        featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
        featureMat = zscore(featureMat);
        save(strcat('features_log',num2str(subject),'.mat'),'featureMat');
    else
        load(strcat('features_log',num2str(subject),'.mat'));
    end
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
    disp(strcat('Generating Logistic Regression Model for subject: ',num2str(subject)))

    clearvars curr;
   %% 
    %Decimate the training labels
    
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);

    trainlabels_decimated = trainlabelsPreload(train_labels,displ);

    train_labels = trainlabels_decimated; 
    
    train_labels1 = train_labels;
    train_labels1(train_labels>=1/5*max(train_labels,2)) = 2;
    train_labels1(train_labels<1/5*max(train_labels,2)) = 1; 
    
    trainlabels_decimated = train_labels1;
    % train2_labels(find(train_labels(runningTimes))) = 2;    
    % train2_labels(find(train_labels(~runningTimes))) = 1;

    %train2_labels = sum(train2_labels,2);
    %train3_labels = train2_labels;
    %train3_labels(train2_labels>=1) = 2;
    %train3_labels(train2_labels<1) = 1;
   
%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
     
    disp 'Selecting features from ranks';
    %load('ranks_sub1')
        K = 15;

    rankfile = strcat('rankMovement',num2str(subject),'_pre8002.mat');
    features = [];
    ranks = [];
       if ~savefileExists(rankfile)
        for i=1:size(train_labels,2)
            i
            [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
            features = [features , rnk(1:numFeatures)];
            ranks = [ranks;rnk];
        end
       else
           load(rankfile)
           for i=1:size(train_labels,2)
               features = [features , ranks(i,1:numFeatures)];
           end
       end
         
     save(strcat('rankMovement',num2str(subject),'_pre8002.mat'),'ranks');

     chosenFeatures = unique(features);
     
     save(strcat('chosenfeaturesMovement',num2str(subject),'_pre8002.mat'),'chosenFeatures');
     
%     load(strcat('chosenfeatures_sub',num2str(subject),'.mat'));
     
     featureMat = featureMat(:,chosenFeatures);
     
     disp 'Generating feature history';
     
     featureMat = FeatureHistoryGeneration( featureMat,history );
          
%     featureMat = [ones([size(featureMat,1),1]),featureMat];
    
     weight_mat = zeros([size(featureMat,2)+1,size(train_labels,2)]);
    disp 'Generating weight matrix'
     for i=1:size(train_labels,2)
    
       w = mnrfit(featureMat,trainlabels_decimated(:,i));
       weight_mat(:,i) = w;
        disp 'Done for one finger';
     end
     
    end
%%
 function trainlabels_decimated = trainlabelsPreload(train_labels, displ)

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end



