function [weight_mat,predictions,stats] = GenerateMovementReduction(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject, ~, pre, post)
    
    [ Times ] = MovementDetection(trainlabels, pre, post);
    
    traindata_movements = zeros(size(traindata));
    for i = 1:13
        traindata_movements(Times{i},:) = traindata(Times{i},:);
    end
    
    if exist(strcat('MovementReductionLinRegModel_',num2str(subject)','.mat'),'file')
        load(strcat('MovementReductionLinRegModel_',num2str(subject)','.mat'))
    else
        
    for i=1:5
            train_limits(i,1)=min(trainlabels(:,i));
            train_limits(i,2)=max(trainlabels(:,i));
        end
        
    end
%     
%     [weight_mat,chosenFeatures, featureMat, ranks] = LinearRegressionModel(traindata_movements,trainlabels, ...
%         sr,windowSize,displ,subject,history);

            
            
    [weight_mat,chosenFeatures, featureMat, ranks_log] = LogisticRegressionModel(traindata_movements,trainlabels, ...
                sr,windowSize,displ,subject);    
                        
	train_limits = zeros([5,2]);

       
    stats = struct();
    stats.weights = weight_mat;
    stats.chosenFeatures = chosenFeatures;
    stats.featureMat = featureMat;
    stats.ranks = ranks_log;
    
    save(strcat('training_logranks_Movement',num2str(subject),'_v6.mat'));
   
    save(strcat('Model_MovementReductionLinReg_',num2str(subject)','.mat'),'weights','chosenFeatures','train_limits');
    
    %Predicting

	predictions{1} = Prediction_LogReg(weight_mat,train_limits,traindata_movements,...
            sr,testDuration,windowSize,displ,chosenFeatures,subject);
        
    predictions{2} = Prediction_LogReg(weight_mat,train_limits,testdata,...
            sr,testDuration,windowSize,displ,chosenFeatures,subject);
        
        
    save(strcat('Predict_MovementReductionLinReg_',num2str(subject)','.mat'),'weights','chosenFeatures','train_limits');
        
    
end