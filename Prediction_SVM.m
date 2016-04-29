function [ pred_rounded ] = Prediction_SVM( models,train_limits,...
    test_data,samplingRate,duration,windowSize,displ,chosenFeatures, subject, history)

    wins = NumWins(length(test_data),samplingRate,windowSize,displ);
    saveversion = 2;
    
    featureFile = strcat('featureTest_movement',num2str(subject),'_v',num2str(saveversion),'.mat');
    if ~savefileExists(featureFile)
        featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
        save(strcat('featureTest_movement',num2str(subject),'_v',num2str(saveversion),'.mat'),'featureMat');
    else
        load(featureFile);
    
    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeaturesNormalized(featureMat);
    
    
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


end