function [weight_mat,predictions] = GenerateMovementReduction(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject, history, pre, post)
    
    disp 'Generating Movement Reduction'
    disp(strcat('Subject: ', num2str(subject)))
    
    runningTimes = [];
    runningCells = {};
    trainlabels = sum(trainlabels,2);
    onset_labels = [];
    [ movement_inds ] = MovementDetection(trainlabels, pre, post);

    t = trainlabels;    
    for i = 1:length(movement_inds)
        t(movement_inds{i}(1):movement_inds{i}(end)) = 2;
    end

        [weight_mat, chosenFeatures] = LogisticRegressionModel(traindata,t, ...
        sr,windowSize,displ,subject,history);       
        save(strcat('LogRegMovementWeights_',num2str(subject)','_pre8002.mat'));  

	predictions_log{1} = Prediction_LogReg(weight_mat,[0, 1],traindata,...
             sr,310,windowSize,displ,chosenFeatures,subject, history);
          
   predictions_log{2} = Prediction_LogReg(weight_mat,[0, 1],testdata,...
            sr,147.5,windowSize,displ,chosenFeatures,subject, history);
    save(strcat('Predict_MovementReductionLogReg_',num2str(subject)','.mat'),'predictions_log');  

predictions = predictions_log;
end

function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);
    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end

