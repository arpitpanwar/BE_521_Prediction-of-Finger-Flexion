function [ weight_mat,chosenFeatures ] = LinearRegressionModel( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject )

    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    disp 'Generating feature matrix in linear regression model';
%      featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
%      save(strcat('features',num2str(fix(clock)),'_k15.mat'),'featureMat');
    
    switch subject
        case 1
            load 'features_emp1_k15.mat';
%            load 'ranks_emp1.mat';
            divisor = 50;
        case 2
            load 'features_emp2_k15.mat';
%            load 'ranks_emp2.mat';
            divisor = 45;
        case 3
            load 'features_emp3_k15.mat';
%            load 'ranks_emp3.mat';
            divisor = 45;
    end

    clearvars curr;
    

    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
     
     disp 'Selecting features';
      K = 25;
      features = [];
      ranks = [];
     for i=1:5
        [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
%        features = [features , ranks(i,1:round(length(ranks(i,:))*1/divisor))];
        features = [features , rnk(1:round(length(rnk)*1/55))];
        ranks = [ranks;rnk];
     end
         
     save(strcat('ranks_emp',num2str(subject),'_k',num2str(K),'.mat'),'ranks');

     chosenFeatures = unique(features);
     
     featureMat = featureMat(:,chosenFeatures);
         featureMat = [ones([size(featureMat,1),1]),featureMat];

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
    
    
    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_decimated); 

end

