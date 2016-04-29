function [ models,chosenFeatures ] = SVMModels( train_ecog_data,train_labels,...
                    samplingRate,windowSize,displ,subject, history)
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

    train_labels(train_labels>=1/5*max(train_labels,2)) = 1;
    train_labels(train_labels<1/5*max(train_labels,2)) = 0; 
    
    train2_labels = train_labels;
    
    train2_labels(find(train_labels(runningTimes))) = 1;    
    train2_labels(find(train_labels(~runningTimes))) = 0;

    train2_labels = sum(train2_labels,2);
    train3_labels = train2_labels;
    train3_labels(train2_labels>=1) = 1;
   
    train_labels = train3_labels;
    trainlabels_decimated = trainlabelsPreload(train_labels,displ);
    
    trainlabels_decimated = logical(trainlabels_decimated);
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
    %%  Feature Selection   
    K = 15;
    features = [];
    ranks = [];
    
    save_version = 2;  
    ranksFile = strcat('reductionRanksMovement_', num2str(subject), '_train3_labels_v',num2str(save_version), '.mat');
    disp 'Selecting features from ranks';
    
%     trainlabels_decimated(trainlabels_decimated>=1) = 1;
%     trainlabels_decimated(trainlabels_decimated<1) = 0; 

    
    trainlabels_decimated = logical(trainlabels_decimated); 
    
    if ~savefileExists(ranksFile)
        [ranks, features] = reductionRanks(featureMat, trainlabels_decimated, numFeatures(subject), K)
        save(strcat('reductionRanksMovement_',num2str(subject),'_train3_labels_v',num2str(save_version),'.mat'),'ranks');  
    else
       load(ranksFile);
    end
    
    for i=1:size(train_labels,2) 
        features = [features , ranks(i,1:numFeatures(subject))];
    end
    
    chosenFeatures = unique(features);

    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeatureHistoryGeneration( featureMat,history );

%     fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);

%% Generating weight matrix   



    %Generating weight matrix
    models = cell(size(trainlabels_decimated,2),1);
    disp 'Generating models';
    for i=1:size(models,1)
       models{i} = fitrsvm(featureMat,real(trainlabels_decimated(:,i)),'Standardize',true);
       models{i} = compact(models{i});
       i
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
