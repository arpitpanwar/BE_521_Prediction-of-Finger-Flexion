function [ pred_rounded ] = Prediction_LinearReg( weight_mat,train_limits,test_data,samplingRate,duration,windowSize,displ,chosenFeatures )

    wins = NumWins(length(test_data),samplingRate,windowSize,displ);

    disp 'Generating features while prediction';
    featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);

    featureMat = featureMat(:,chosenFeatures);
        featureMat = [ones([size(featureMat,1),1]),featureMat];

    pred = featureMat*weight_mat;
    
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

