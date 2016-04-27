function [weight_mat,predictions,stats] = GenerateMovementReduction(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject, ~, pre, post)
    
    [movements Times ] = MovementDetection(trainlabels, traindata, pre, post);
    
    
%     if exist(strcat('MovementReductionLinRegModel_',num2str(subject)','.mat'),'file')
%         load(strcat('MovementReductionLinRegModel_',num2str(subject)','.mat'))
%     else
        
        train_limits = zeros([5,2]);
        
        for i=1:5
            train_limits(i,1)=min(trainlabels(:,i));
            train_limits(i,2)=max(trainlabels(:,i));
        end
    
    
    %
%     [weight_mat,chosenFeatures, featureMat, ranks] = LinearRegressionModel(traindata_movements,trainlabels, ...
%         sr,windowSize,displ,subject,history);

            
    if exist(strcat('Model_MovementReductionLinReg_',num2str(subject)','.mat'),'file')
        load(strcat('Model_MovementReductionLinReg_',num2str(subject)','.mat'));
        load(strcat('training_logranks_Movement',num2str(subject),'_v6.mat'));
    else
       % [weight_mat,chosenFeatures, featureMat, ranks_log] = LogisticRegressionModel(traindata_movements,trainlabels, ...
        %        sr,windowSize,displ,subject);    
    end
   
           [models,chosenFeatures] = SVMModels(movements,trainlabels,sr,windowSize,displ,subject);

%     stats = struct();
%     stats.weights = weight_mat;
%     stats.chosenFeatures = chosenFeatures;
%     stats.featureMat = featureMat;
%     stats.ranks = ranks_log;
%     
    save(strcat('training_logranks_Movement',num2str(subject),'.mat'),'ranks_log');
   
    save(strcat('Model_MovementReductionLogReg_',num2str(subject)','.mat'),'weight_mat','chosenFeatures');
    
    %Predicting

% 	predictions{1} = Prediction_LogReg(weight_mat,train_limits,traindata_movements,...
%             sr,testDuration,windowSize,displ,chosenFeatures,subject);
%        
%     predictions{2} = Prediction_LogReg(weight_mat,train_limits,testdata,...
%             sr,testDuration,windowSize,displ,chosenFeatures,subject);
%         
    predictions{1} = Prediction_SVM(models,train_limits,movements,sr,testDuration,windowSize,displ,chosenFeatures,subject);
    predictions{1} = Prediction_SVM(models,train_limits,testdata,sr,testDuration,windowSize,displ,chosenFeatures,subject);
        
    save(strcat('Predict_MovementReductionLinReg_',num2str(subject)','.mat'),'weight_mat','chosenFeatures');
       
    
end