function [ pred_rounded ] = Prediction_SVM( models,train_limits,...
    test_data,samplingRate,duration,windowSize,displ,chosenFeatures, subject, history)

    wins = NumWins(length(test_data),samplingRate,windowSize,displ);
    disp '-- SVM Prediction --'
    disp 'Generating features for prediction';
    
    save_version = 5;  

    if duration == 310
        featureFile = strcat('featuresMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    else
        featureFile = strcat('featuresPredictMovement_', num2str(subject), '_v',num2str(save_version), '.mat');
    end
    if ~savefileExists(featureFile)
        [featureMat] = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
        save(featureFile,'featureMat');
    else
        load(featureFile)
    end
        
    
    
    %save(strcat('Testing_features_sub',num2str(subject),'.mat'),'featureMat');
    %load(strcat('Testing_features_sub',num2str(subject),'.mat'));

%     switch subject
%     
%         case 1
%             load('Testing_features_sub1.mat');
%         case 2 
%             load('Testing_features_sub2.mat');
%         case 3
%             load('Testing_features_sub3.mat');
%         
%     end
        
    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeaturesNormalized(featureMat);

    featureMat = FeatureHistoryGeneration( featureMat,history );
    
    disp 'Predicting SVM';    
    pred = zeros([length(featureMat),size(models,1)]);
    
    for i=1:size(pred,2)
       
        pred(:,i) = predict(models{i},featureMat);
        
    end
    
   % pred = round(pred);
    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(test_data),size(models,1)]);
    len = length(pred);
    stepval = (duration)/len;
    for i=1:size(pred,2)
        pred_splined(:,i) = spline((stepval:stepval:duration),pred(:,i),(0.001:0.001:duration));
    end
    pred_rounded = pred_splined;    

    pred_rounded(pred_rounded >=1 ) = 2; 

    pred_rounded(pred_rounded <1 ) = 1; 
end