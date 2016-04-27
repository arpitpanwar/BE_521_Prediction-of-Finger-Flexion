function [ models,chosenFeatures ] = SVMModels( train_ecog_data,train_labels,samplingRate,windowSize,displ,subject )

   wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    
    disp 'Generating feature matrix in svm model';
    
    file = strcat('trainfeature_SVM_movement','_subject_',num2str(subject),'_v1.mat');
    if exist(file,'file')
        load(file);    
    else        
      featureMat = FeatureGeneration(train_ecog_data,wins,samplingRate,windowSize,displ);
      save(strcat('trainfeature_SVM_movement','_subject_',num2str(subject),'_','v1.mat'), 'featureMat');
    end
%     switch subject
%         case 1
%             load 'features_emp1_k15.mat';
%             load('ranks_emp1_k25.mat');
%             divisor = 25;
%         case 2
%             load 'features_emp2_k15.mat';
%             load('ranks_emp2_k25.mat');
%             divisor = 25;
%         case 3
%             load 'features_emp3_k15.mat';
%             load('ranks_emp3_k25.mat');
%             divisor = 20;
%     end

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
% %      K = 25;
%       features = [];
% %      ranks = [];
%      for i=1:5
% %        [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
%         features = [features , ranks(i,1:round(length(ranks(i,:))*1/divisor))];
% %        features = [features , rnk(1:round(length(rnk)*1/55))];
% %        ranks = [ranks;rnk];
%      end
%          
%     save(strcat('ranks_emp',num2str(subject),'_k',num2str(K),'.mat'),'ranks');

  %   chosenFeatures = unique(features);
     
   %  featureMat = featureMat(:,chosenFeatures);
    
     trainlabels_decimated = round(trainlabels_decimated);
    weight_mat = zeros([size(featureMat,2),5]);
    
    for i=1:5
        c = zeros([100,1]);
        B = lasso(featureMat,trainlabels_decimated(:,i));
        for j=1:100
            c(j) = corr(featureMat*B(:,j),trainlabels_decimated(:,1));
        end
        weight_mat(:,i) = B(:,find(max(c)));
    end
          
    %Generating weight matrix
    models = cell(size(trainlabels_decimated,2),1);
    disp 'Generating models';
    for i=1:size(models,1)
       disp(strcat('Generating Model: ',num2str(i)))
       models{i} = fitrsvm(featureMat,trainlabels_decimated(:,i),'Standardize',true);
       models{i} = compact(models{i});
        disp(strcat('Done Model: ',num2str(i)))

    end
end

