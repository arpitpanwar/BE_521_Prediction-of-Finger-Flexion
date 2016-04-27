function [ weight_mat, chosenFeatures, featureMat, ranks ] = LinearRegressionModel( train_ecog_data, ...
                train_labels,samplingRate,windowSize,displ,subject,history)

    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    disp 'Generating feature matrix in linear regression model';          

    if exist(strcat('trainfeatures_subject_',num2str(subject),'_v8.mat'),'file')
        load(strcat('trainfeatures_subject_',num2str(subject),'_v8.mat'));
    else
        featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
    end 
     switch subject
         case 1
%           load 'features_emp1_k15.mat';
%           load('ranks_emp1_k15.mat');
             divisor = 43;
        case 2
%           load 'features_emp2_k15.mat';
%           load('ranks_emp2_k15.mat');
             divisor = 20;
        case 3
%           load 'features_emp3_k15.mat';
%           load('ranks_emp3_k15.mat');
            divisor = 60;
     end
     save(strcat('trainfeatures_subject_',num2str(subject),'_v8.mat'));

     clearvars curr;
    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
     
    disp 'Selecting features';
    features=[];
 	if exist(strcat('training_ranks',num2str(subject),'_v5.mat'),'file')
        load(strcat('training_ranks',num2str(subject),'_v5.mat'))
        for i = 1:5
            features = [features , ranks(i,1:round(length(ranks(i,:))*1/divisor))];
        end 
    else

        K = 15;
        features = [];
        ranks = [];
        for i=1:5
            disp(strcat('--',num2str(i),'--'))
            [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
            features = [features , rnk(1:round(length(rnk)*1/divisor))];
            ranks = [ranks;rnk];
        end
    end
    

    chosenFeatures = unique(features);

    featureMat = featureMat(:,chosenFeatures);

    disp 'Generating feature history';

    featureMat = FeatureHistoryGeneration( featureMat,history );

    featureMat = [ones([size(featureMat,1),1]),featureMat];

    %trainlabels_decimated = round(trainlabels_decimated);
    %     weight_mat = zeros([size(featureMat,2),5]);
    %     
    %     for i=1:5
    %         c = zeros([100,1]);
    %         B = lasso(featureMat,trainlabels_decimated(:,i));
    %         for j=1:100
    %             c(j) = corr(featureMat*B(:,j),trainlabels_decimated(:,1));
    %         end
    %         weight_mat(:,i) = B(:,find(max(c)));
    %     end


    %Generating weight matrix
    disp 'Generating weight matrix';
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 

end

