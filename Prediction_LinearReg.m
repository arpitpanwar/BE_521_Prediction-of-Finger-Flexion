function [ pred_rounded ] = Prediction_LinearReg( weight_mat,train_limits,...
        test_data,samplingRate,~,windowSize,displ,chosenFeatures,history,subject )
    
    testing=0;
    duration = length(test_data)/1000;
    if duration ~= 310
        testing = 1;
    end
        disp(strcat('Generating features for prediction:',num2str(subject)));
        file = strcat('linreg_electrodes_movement_pred_featureMat_','_subject_',num2str(subject),'_',num2str(testing),'v8.mat');
        if exist(file,'file')
            load(file);
        else
            wins = NumWins(length(test_data),samplingRate,windowSize,displ);
            
            featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
            save(strcat('linreg_electrodes_movement_pred_featureMat',num2str(testing),'_subject_',num2str(subject),'_',num2str(testing),'v8.mat'), 'featureMat');
        end

        %         weight_mat = weight_mat(find(weight_mat));
%         pred2 = featureMat*weight_mat;  
%        Same predictions when I compared pred2 vs pred

        %load('predictions_subject',num2str(subject),'_finger',num2str(i),'.mat');
        %featureMat = [ones([size(featureMat,1),1]),featureMat];       

    featureMat = featureMat(:,chosenFeatures);
    featureMat = FeatureHistoryGeneration( featureMat,history );
    featureMat = [ones([size(featureMat,1),1]),featureMat];   
    pred = featureMat*weight_mat;

    disp(strcat('Calculating predictions:',num2str(subject)));    

    disp 'Generating features while prediction';
%     featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);
%     save(strcat('Testing_features',num2str(clock)),'featureMat');
   
    
   % pred = round(pred);
    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(test_data),5]);
    len = length(pred);
    stepval = (duration)/len;
    for i=1:5
        pred_splined(:,i) = spline((stepval:stepval:duration),pred(:,i),(0.001:0.001:duration));
    end

%     %Rounding
%     pred_rounded = round(pred_splined);
    pred_rounded = pred_splined;
    %Setting limits
    for i=1:5
        minimum = train_limits(i,1);
        pred_remove = find(pred_rounded < minimum);
        pred_rounded(pred_remove) = minimum;

        maximum = train_limits(i,2);
        pred_remove = find(pred_rounded > maximum);
        pred_rounded(pred_remove) = maximum;
    end
end