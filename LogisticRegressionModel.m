function [ weight_mat,chosenFeatures, featureMat, ranks ] = LogisticRegressionModel( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject )

        wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);

        disp 'Generating feature matrix in logistic regression model';
   
    if exist(strcat('trainfeatures_movement_subject_',num2str(subject),'.mat'),'file')
        load(strcat('trainfeatures_movement_subject_',num2str(subject),'.mat'));
    else
        featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
        save(strcat('trainfeatures_movement_subject_',num2str(subject),'.mat'));

    end
    switch subject
        case 1
                %load 'features_emp1_k15.mat';
                %load 'ranks_emp1_k15.mat';
                divisor = 45;
            case 2
               % load 'features_emp2_k15.mat';
               % load 'ranks_emp2_k15.mat';
                divisor = 40;
            case 3
                %load 'features_emp3_k15.mat';
                %load 'ranks_emp3_k15.mat';
                divisor = 45;
    end

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
 	if exist(strcat('training_logranks_movement',num2str(subject),'.mat'),'file')
        load(strcat('training_logranks_movement',num2str(subject),'.mat'))
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
    
         
%     save(strcat('ranks',num2str(fix(clock)),'_k15.mat'),'ranks');

     chosenFeatures = unique(features);
     
     featureMat = featureMat(:,chosenFeatures);
    
     trainlabels_decimated(trainlabels_decimated >= max(train_labels/5)) = 1;
     trainlabels_decimated(trainlabels_decimated < max(train_labels/5)) = 0;
     
     weight_mat = zeros([size(featureMat,2)+1,5]);
    
     for i=1:5
    %Generating weight matrix
       w = mnrfit(featureMat,trainlabels_decimated(:,i),'EstDisp','on');
       weight_mat(:,i) = w;
        disp 'Done for one finger';
     end
end

