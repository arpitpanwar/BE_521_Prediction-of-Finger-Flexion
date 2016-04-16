function [ pred_rounded ] = Prediction_LogReg( weight_mat,train_limits,test_data,samplingRate,duration )
    
    wins = NumWins(length(test_data),samplingRate,0.1,0.05);

    featureMat = FeatureGeneration(test_data,wins,samplingRate);

    pred = mnrval(weight_mat,featureMat,ones([length(featureMat),1])*8);
    
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

