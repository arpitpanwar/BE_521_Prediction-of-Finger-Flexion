function [weight_mat,predictions] = GenerateMovementReduction(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject, history, pre, post)
    
    disp 'Generating Movement Reduction'
    disp(strcat('Subject: ', num2str(subject)))
    
    runningTimes = [];
    runningCells = {};
    %trainlabels = sum(trainlabels,2);
    for i = 1:size(trainlabels,2)
        [ Times allTimes ] = MovementDetection(trainlabels(:,i), traindata, displ, pre, post);
        runningCells{length(runningCells)+1} = Times;
        runningTimes = [runningTimes; allTimes];
    end
    
    %% BINARY MOVEMENT ONSET VS OFFSET
    train_movements = traindata;
    
%     [weight_mat,chosenFeatures, featureMat, ranks] = LinearRegressionModel(traindata_movements,trainlabels, ...
%         sr,windowSize,displ,subject,history);
    
    running{1} = runningCells;
    running{2} = runningTimes;
    
    save_version = 3;
    weightFile = strcat('LogReg2_',num2str(subject)','_2.mat');
    if ~savefileExists(weightFile)
%         [weight_mat, chosenFeatures] = LogisticRegressionModel(train_movements,trainlabels, ...
%         sr,windowSize,displ,subject,running); 
%         save(strcat('LogReg1_',num2str(subject)','_2.mat'),'weight_mat','chosenFeatures');  

        [weight_mat, chosenFeatures] = LogisticRegressionModel(train_movements,sum(trainlabels,2), ...
        sr,windowSize,displ,subject,running);       
        save(strcat('LogReg2_',num2str(subject)','_2.mat'),'weight_mat','chosenFeatures');  
    else
        load(weightFile)        
    end
% 
	predictions_log{1} = Prediction_LogReg(weight_mat,0,train_movements,...
             sr,310,windowSize,displ,chosenFeatures,subject, history);
%        
    predictions_log{2} = Prediction_LogReg(weight_mat,0,testdata,...
            sr,testDuration,windowSize,displ,chosenFeatures,subject, history);
        
%     save(strcat('Predict_MovementReductionLogReg_',num2str(subject)','.mat'),'predictions_log');  
% %%
%     save_version = 2;
%     weightFile = strcat('Model_MovementReductionSVM',num2str(subject)','v',num2str(save_version),'.mat');
%     if ~savefileExists(weightFile)
%         [models, chosenFeatures] = SVMModels(train_movements,trainlabels, ...
%         sr,windowSize,displ,subject,running);          
%                     save(strcat('SVM1_',num2str(subject)','.mat'),'models','chosenFeatures');  
% 
%             [models, chosenFeatures] = SVMModels(train_movements,sum(trainlabels,2), ...
%         sr,windowSize,displ,subject,running); 
%                 save(strcat('SVM2_',num2str(subject)','.mat'),'models','chosenFeatures');  
% 
%     else
%         load(weightFile)           
%     end
%     load(strcat('Model_MovementReductionSVM',num2str(subject)','_',num2str(1),'.mat'), 'models', 'chosenFeatures')
% 
% 
% 	predictions{1} = Prediction_SVM(models,0,train_movements,...
%             sr,310,windowSize,displ,chosenFeatures,subject, history);
%        
%     predictions{2} = Prediction_SVM(models,0,testdata,...        
%             sr,testDuration,windowSize,displ,chosenFeatures,subject, history);
%         
%     save(strcat('Predict_MovementReductionSVM_',num2str(subject)','.mat'),'predictions');      

predictions = predictions_log;%
end

function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);
    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end

