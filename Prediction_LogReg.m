function [ pred_rounded ] = Prediction_LogReg( weight_mat,train_limits,... 
        test_data,samplingRate,duration,windowSize,displ,chosenFeatures,subject, history )
    
    wins = NumWins(length(test_data),samplingRate,windowSize,displ);

    disp 'Generating features while prediction';
    featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
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
    
     
     pred = zeros([size(featureMat,1),1]);
     disp 'Predicting logregg';
     for i=1:size(pred,2)
         p = mnrval(weight_mat(:,i),featureMat);
         [~,id] = max(p,[],2);
         pred(:,i) = id-1;
     end

   % pred = round(pred);
    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(test_data),size(pred,2)]);
    len = length(pred);
    stepval = (duration)/len;
    
    for i=1:size(pred,2)
        pred_splined(:,i) = spline((stepval:stepval:duration),pred(:,i),(0.001:0.001:duration));
    end

%     %Rounding
%     pred_rounded = round(pred_splined);

    pred_rounded = pred_splined;
    train_limits = [0, 1];
    %Setting limits
    for i=1:size(pred,2)
        minimum = train_limits(i,1);
        pred_remove = find(pred_rounded < minimum);
        pred_rounded(pred_remove) = minimum;

        maximum = train_limits(i,2);
        pred_remove = find(pred_rounded > maximum);
        pred_rounded(pred_remove) = maximum;
    end


end

