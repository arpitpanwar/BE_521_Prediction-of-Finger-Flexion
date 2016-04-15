function [ weight_mat ] = LinearRegressionModel( train_ecog_data,train_labels,samplingRate )

    wins = NumWins(length(train_ecog_data),samplingRate,0.1,0.05);
    
    featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate);

    clearvars curr;

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/50),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),50);
    end
    
    train_labl_test = trainlabels_decimated;

    trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];

    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 

end

