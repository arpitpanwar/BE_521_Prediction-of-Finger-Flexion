function [ weight_mat ] = RidgeRegressionModel( train_ecog_data,train_labels,samplingRate,windowSize,displ )
    
    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
    
    clearvars curr;

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
%     weight_mat = zeros([size(featureMat,2),5]);
%     
%     for i=1:5
%         c = zeros([100,1]);
%         B = lasso(featureMat,trainlabels_decimated(:,i));
%         for j=1:100
%             c(j) = corr(featureMat*B(:,j),trainlabels_decimated(:,1));
%         end
%         weight_mat(:,i) = B(:,find(max(c)));
%     end
    
    ridge_coeff = 1000;
    
    %Generating weight matrix
    weight_mat = zeros([size(featureMat,2),5]);
    for i=1:5
        weight_mat(:,i) = ridge(trainlabels_decimated(:,i),featureMat,ridge_coeff) ; 
    end
    
end

