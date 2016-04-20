function [ weight_mat ] = StepwiseRegressionModel(train_ecog_data,train_labels,samplingRate,windowSize,displ )
    
    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
    
    clearvars curr;

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
    trainlabels_decimated = trainlabels_decimated(1:end-1,:);

    %Generating weight matrix
    weight_mat = zeros([size(featureMat,2),5]);
    for i=1:5
        weight_mat(:,i) = stepwisefit(featureMat,trainlabels_decimated(:,i),'scale','on','penter',0.04) ; 
    end

end

