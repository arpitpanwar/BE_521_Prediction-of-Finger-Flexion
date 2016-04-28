function [ weight_mat,chosenFeatures, featureMat] = LogisticRegressionModel( train_ecog_data,... 
            train_labels,samplingRate,windowSize,displ,subject,history )
 
    numFeatures = [25, 25, 15];
    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);  
    disp ' ----- '
    disp(strcat('Generating Logistic Regression Model for subject: ',num2str(subject)))

    save_version = 4;  
    featureFile = strcat('featuresMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    features = [];
    if ~savefileExists(featureFile)
        [featureMat] = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
        save(strcat('featuresMovement_',num2str(subject),'_v',num2str(save_version),'.mat'),'featureMat');
    else
        load(featureFile);
    end


%% Decimate the training labels

    train_labels(train_labels>=0.5) = 2;
    train_labels(train_labels<0.5) = 1; 
    
    trainlabels_decimated = trainlabelsPreload(train_labels,displ);    
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
    %%  Feature Selection   
    K = 15;
    features = [];
    ranks = [];
    
    save_version = 1;  
    ranksFile = strcat('reductionRanksMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    disp 'Selecting features from ranks';
    
    
    if ~savefileExists(ranksFile)
        [ranks, features] = reductionRanks(featureMat, trainlabels_decimated, numFeatures(subject), K)
        save(strcat('reductionRanksMovement_',num2str(subject),'_v',num2str(save_version),'.mat'),'ranks');  
    else
       load(file(ranksFile));
    end
    
    for i=1:size(train_labels,2) 
        features = [features , ranks(i,1:numFeatures(subject))];
    end
    
    chosenFeatures = unique(features);

    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeaturesNormalized(features);
    featureMat = FeatureHistoryGeneration( featureMat,history );

    trainlabels_decimated(trainlabels_decimated>=1) = 2;
    trainlabels_decimated(trainlabels_decimated<1) = 1;
     trainlabels_decimated = round(trainlabels_decimated);
%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

    weight_mat = zeros([size(featureMat,2)+1,5]);
    
%% Generating weight matrix   
    for i=1:5
    w = mnrfit(featureMat,trainlabels_decimated(:,i),'EstDisp','on');
       weight_mat(:,i) = w;
        disp 'Done for one finger';
     end
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


