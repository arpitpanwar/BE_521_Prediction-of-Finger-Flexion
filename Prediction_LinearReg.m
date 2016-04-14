function [ pred_rounded ] = Prediction_LinearReg( weight_mat,train_limits,test_data,samplingRate,duration )

    wins = NumWins(length(test_data),samplingRate,0.1,0.05);

    featureMat = FeatureGeneration(test_data,wins,samplingRate);

    pred = featureMat*weight_mat;

    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(test_data),5]);
    len = length(pred);
    stepval = (309.9)/len;
    for i=1:5
        pred_splined(:,i) = spline((0:stepval:309.9-stepval),pred(:,i),(0:0.001:duration-0.001));
    end

    %Rounding
    pred_rounded = round(pred_splined);

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

