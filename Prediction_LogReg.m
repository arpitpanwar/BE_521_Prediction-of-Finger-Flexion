function [ pred_rounded ] = Prediction_LogReg( weight_mat,train_limits,... 
        test_data,samplingRate,duration,windowSize,displ,chosenFeatures,subject, history )
    
    wins = NumWins(length(test_data),samplingRate,windowSize,displ);
    savefile = strcat('Testing_features_sub',num2str(subject),'.mat');

        disp 'Generating features while prediction';
        featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
        featureMat = zscore(featureMat);
      %  save(strcat('Testing_features_sub',num2str(subject),'.mat'),'featureMat');
   
    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeatureHistoryGeneration( featureMat,history );    

    pred = zeros([size(featureMat,1),size(weight_mat,2)]);
    disp 'Predicting logregg';
    for i=1:size(weight_mat,2)
     i
     p = mnrval(weight_mat(:,i),featureMat,'confidence',0.95);
     [~,id] = max(p,[],2);
     pred(:,i) = id-1;
    end
   % pred = round(pred);
    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(test_data),size(weight_mat,2)]);
    len = length(pred);
    stepval = (duration)/len;
    for i=1:size(weight_mat,2)
        pred_splined(:,i) = spline((stepval:stepval:duration),pred(:,i),(0.001:0.001:duration));
    end

%     %Rounding
%     pred_rounded = round(pred_splined);
    pred_rounded = pred_splined;
    %Setting limits
    
    train_limits = [zeros(size(weight_mat,2),1), ones(size(weight_mat,2),1)];
    for i=1:size(weight_mat,2)
        minimum = train_limits(i,1);
        pred_remove = find(pred_rounded < minimum);
        pred_rounded(pred_remove) = minimum;

        maximum = train_limits(i,2);
        pred_remove = find(pred_rounded > maximum);
        pred_rounded(pred_remove) = maximum;
    end


end

