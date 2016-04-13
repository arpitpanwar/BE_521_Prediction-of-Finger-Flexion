function [ weight_mat ] = LinearRegressionPred( train_ecog_data,train_labels,samplingRate )

    wins = NumWins(length(train_ecog_data),samplingRate,0.1,0.05);
    
    featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate);

    clearvars curr;

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/50),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),50);
    end

    trainlabels_decimated = trainlabels_decimated(1:end-1,:);

    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 

end

