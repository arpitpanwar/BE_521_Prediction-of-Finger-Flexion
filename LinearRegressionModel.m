function [ weight_mat, chosenFeatures ] = LinearRegressionModel( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject,history)
   
   wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);  
   disp ' ----- '
   disp(strcat('Generating Linear Regression Model for subject: ',num2str(subject)))
      
   save_version = 4;  
   featureFile = strcat('features_', num2str(subject), '_v',num2str(save_version), '.mat');
   features = [];
   if ~savefileExists(featureFile)
      [features, featureMat] = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ,history);
      save(strcat('features_',num2str(subject),'_v',num2str(save_version),'.mat'),'features');
   else
      load(featureFile);

    end
   
   numFeatures = [10, 20, 10];

    %% Decimate the training labels
    
    trainlabels_decimated = trainlabelsPreload(train_labels,displ);    
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

    %%  Feature Selection   
    disp 'Selecting features';
%    K = 15;
    features = [];
%    ranks = [];
     for i=1:5
%       [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
%        inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures));
        features = [features , ranks(i,1:numFeatures)];
%       features = [features , rnk(1:numFeatures)];
%       ranks = [ranks;rnk];
     end
         
%     save(strcat('ranks_emp',num2str(subject),'_k',num2str(K),'.mat'),'ranks');

     chosenFeatures = unique(features);
     
     save(strcat('chosenfeatures_sub',num2str(subject),'.mat'),'chosenFeatures');
     
     featureMat = featureMat(:,chosenFeatures);
     
     disp 'Generating feature history';
     featureMat = FeaturesNormalized(features);

     featureMat = FeatureHistoryGeneration( featureMat,history );
     
     featureMat = [ones([size(featureMat,1),1]),featureMat];
     featureMat = FeatureHistoryGeneration(featureMat, history);   

    
    %% Ranks Reduction
    K = 25;
    features = [];
    ranks = [];
    
    save_version = 1;  
    ranksFile = strcat('reductionRanks_reduced_', num2str(subject), '_v',num2str(save_version), '.mat');
    disp 'Selecting features from ranks';
    
      
    if ~savefileExists(ranksFile)
        [ranks, features] = reductionRanks(featureMat, trainlabels_decimated, divisor(subject), K)
        save(strcat('reductionRanks_',num2str(subject),'_v',num2str(save_version),'.mat'),'ranks');  
    else
       load(file(ranksFile));
        for i=1:size(train_labels,2) 
            features = [features , ranks(i,1:round(length(ranks(i,:))*1/divisor))];
        end
    end
    
    chosenFeatures = unique(features);     
    featureMat = featureMat(:,chosenFeatures);

   %% Lasso Reduction
   
   save_version = 1;
   lassoFile = strcat('reductionLasso_reduced_', num2str(subject), '_v',num2str(save_version), '.mat');
   weight_mat = zeros([size(featureMat,2),size(train_labels,2)]);
   if ~savefileExists(lassoFile) && 1 == 0;
        weight_mat = reductionLasso(featureMat, trainlabels_decimated);
        save(strcat('reductionLasso_reduced_',num2str(subject),'_v',num2str(save_version),'.mat'),'weight_mat');  
   else if savefileExists(lassoFile)
       load(lassoFile)
       
       end
   end
   %% 

    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 
end


 function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end
