function [weight_mat,predictions] = GenerateMovementReduction(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject, history, pre, post)
    
    runningTimes = [];
    runningCells = {};
    for i = 1:size(trainlabels,2)
        [ Times allTimes ] = MovementDetection(trainlabels(:,i), traindata, displ, pre, post);
        runningCells{length(runningCells)+1} = Times;
        runningTimes = [runningTimes; allTimes];
    end
    
    %% BINARY MOVEMENT ONSET VS OFFSET
    train_movements = zeros(size(traindata));
    trainlabels_decimated = trainlabelsPreload(trainlabels(:,1), displ);
    
    trainlabels_decimated(runningTimes) = 1;
    trainlabels_decimated(~runningTimes) = 0;

    train_limits = zeros([5,2]);

    for i=1:5
        train_limits(i,1)=min(trainlabels(:,i));
        train_limits(i,2)=max(trainlabels(:,i));
    end
    
%     [weight_mat,chosenFeatures, featureMat, ranks] = LinearRegressionModel(traindata_movements,trainlabels, ...
%         sr,windowSize,displ,subject,history);

            
    if exist(strcat('Model_MovementReductionLinReg_',num2str(subject)','.mat'),'file')
        load(strcat('Model_MovementReductionLinReg_',num2str(subject)','.mat'));
        load(strcat('training_logranks_Movement',num2str(subject),'_v6.mat'));
    else
        
            [weight_mat,chosenFeatures, featureMat] = LogisticRegressionModel(train_movements,trainlabels, ...
               sr,windowSize,displ,subject,history);    
    end
   
    save(strcat('training_logranks_Movement',num2str(subject),'.mat'),'ranks_log');
   
    save(strcat('Model_MovementReductionLogReg_',num2str(subject)','.mat'),'weight_mat','chosenFeatures');
    
    %Predicting

	predictions{1} = Prediction_LogReg(weight_mat,train_limits,train_movements,...
            sr,testDuration,windowSize,displ,chosenFeatures,subject);
       
    predictions{2} = Prediction_LogReg(weight_mat,train_limits,testdata,...
            sr,testDuration,windowSize,displ,chosenFeatures,subject);
        
        
    save(strcat('Predict_MovementReductionLinReg_',num2str(subject)','.mat'),'weight_mat','chosenFeatures');      
end

function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);
    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end

