function [ models ] = SVMModels( train_ecog_data,train_labels,samplingRate,windowSize,displ )

    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
    
    clearvars curr;

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
    train_labl_test = trainlabels_decimated;

    trainlabels_decimated = round([train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)]);
          
    %Generating weight matrix
    models = cell(size(trainlabels_decimated,2),1);
    
    for i=1:size(models,1)
       models{i} = fitcsvm(featureMat,trainlabels_decimated(:,i),'Standardize',true);
       models{i} = compact(models{i});
    end
end

