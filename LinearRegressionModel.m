function [ weight_mat, chosenFeatures ] = LinearRegressionModel( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject,history)
   
   wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);  
   disp ' ----- '
   disp(strcat('Generating Linear Regression Model for subject: ',num2str(subject)))
   
   disp 'Generating feature matrix in svm model';
   
   version = 1;  
   featureFile = strcat('features_reduced_', num2str(subject), '_v',num2str(version), '.mat');
   
   if ~savefileExists(featureFile)
      featureMat = FeatureGenerationReduced(train_ecog_data,wins,samplingRate,windowSize,displ,history);
      save(strcat('features_reduced_',num2str(subject),'_v1.mat'),'featureMat');
   end
   
   divisor = [5, 25, 20];

    %% Decimate the training labels
    
    trainlabels_decimated = trainlabelsPreload(train_labels);    
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
    
    %% Ranks Reduction
    K = 25;
    features = [];
    ranks = [];
    
    version = 1;  
    ranksFile = strcat('reductionRanks_reduced_', num2str(subject), '_v',num2str(version), '.mat');
    disp 'Selecting features from ranks';
    
    if ~savefileExists(ranksFile)
        reductionRanks(featureMat, trainlabels_decimated, divisor(subject), K)
        save(strcat('reductionRanks_reduced_',num2str(subject),'_v',num2str(version),'.mat'),'ranks');  
    end
    
    for i=1:size(train_labels,2) 
        features = [features , rnk(1:round(length(rnk)*1/divisor(subject)))];
        ranks = [ranks;rnk];       
    end
    chosenFeatures = unique(features);     
    featureMat = featureMat(:,chosenFeatures);

   %% Lasso Reduction
   
   version = 1;
   lassoFile = strcat('reductionLasso_reduced_', num2str(subject), '_v',num2str(version), '.mat');
   weight_mat = zeros([size(featureMat,2),size(train_labels,2)]);
   if ~savefileExists(lassoFile) && 1 == 0;
        weight_mat = reductionLasso(featureMat, trainlabels_decimated);
        save(strcat('reductionLasso_reduced_',num2str(subject),'_v',num2str(version),'.mat'),'weight_mat');  
   end
   %% 

    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 
end


 function trainlabels_decimated = trainlabelPreload(train_labels)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end
