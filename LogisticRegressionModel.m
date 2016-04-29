function [ weight_mat,chosenFeatures, featureMat] = LogisticRegressionModel( train_ecog_data,... 
            train_labels,samplingRate,windowSize,displ,subject,history )
 
    if ~isnumeric(history)           
        runningCells = history{1};
        runningTimes = history{2};
        history = 0;
    end
        
    numFeatures = [25, 25, 15];
    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);  
    disp ' ----- '
    disp(strcat('Generating Logistic Regression Model for subject: ',num2str(subject)))

    save_version = 5;  
    featureFile = strcat('featuresMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    features = [];
    if ~savefileExists(featureFile)
        [featureMat] = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
        save(strcat('featuresMovement_',num2str(subject),'_v',num2str(save_version),'.mat'),'featureMat');
    else
        load(featureFile);
    end
    
    featureMat = FeaturesNormalized(featureMat);


%% Decimate the training labels
    runningTimes = unique(runningTimes);
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);

    trainlabels_decimated = trainlabelsPreload(train_labels,displ);

    train_labels = trainlabels_decimated; 
    
    train_labels1 = train_labels;
    train_labels1(train_labels>=1/5*max(train_labels,2)) = 2;
    train_labels1(train_labels<1/5*max(train_labels,2)) = 1; 
    
    train2_labels = train_labels;
    
    % train2_labels(find(train_labels(runningTimes))) = 2;    
    % train2_labels(find(train_labels(~runningTimes))) = 1;

    train2_labels = sum(train2_labels,2);
    train3_labels = train2_labels;
    train3_labels(train2_labels>=1) = 2;
    train3_labels(train2_labels<1) = 1;%

    trainlabels_decimated{1} = train_labels1;
    trainlabels_decimated{2} = train_labels3;
   
   
%   train_labels = train3_labels;

     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
    %%  Feature Selection   
    K = 15;
    features = [];
    ranks = [];
    
    save_version = 4;  
    ranksFile = strcat('reductionRanksMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    disp 'Selecting features from ranks';
    for i = 1:2
        if ~savefileExists(ranksFile)
            [ranks, features] = reductionRanks(featureMat, trainlabels_decimated{i}, numFeatures(subject), K)
            save(strcat('reductionRanksMovement_',num2str(subject),'_v',num2str(save_version),'.mat'),'ranks');  
        else
            load(ranksFile);
            for i=1:size(trainlabels_decimated{i},2) 
                features = [features , ranks(i,1:numFeatures(subject))];
            end
        end
    end
    

    chosenFeatures = unique(features);
    save(strcat('reductionRanksMovement_',num2str(subject),'_v',num2str(save_version),'.mat'),'ranks','chosenFeatures');  

    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeatureHistoryGeneration( featureMat,history );

%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

    weight_mat = zeros([size(featureMat,2)+1,size(trainlabels_decimated,2)]);
    
%% Generating weight matrix   

    for i=1:size(trainlabels_decimated,2)
        w = mnrfit(featureMat,round(trainlabels_decimated(:,i)))
        weight_mat(:,i) = w;
        disp 'Done for one finger';
     end
end

 function trainlabels_decimated = trainlabelsPreload(train_labels, displ)

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end


