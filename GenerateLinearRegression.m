function [weight_mat, predictions, stats] = GenerateLinearRegression(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject,history)
    
    [weight_mat,chosenFeatures,featureMat, ranks] = LinearRegressionModel(traindata,trainlabels, ...
        sr,windowSize,displ,subject,history);
   
    save(strcat('training_ranks',num2str(subject),'_v6.mat'),'ranks','featureMat');

    stats = struct();
    stats.weight = weight_mat;
    stats.chosenFeatures = chosenFeatures;
    stats.featureMat = featureMat;
    
    save(strcat('model_linreg_',num2str(subject),'.mat'),'weight_mat','featureMat');
       
    train_limits = zeros([5,2]);
    
    for i=1:5
        train_limits(i,1)=min(trainlabels(:,i));
        train_limits(i,2)=max(trainlabels(:,i));
    end

    %Predicting
    predictions{1} = Prediction_LinearReg(weight_mat,train_limits,traindata,...
            sr,testDuration,windowSize,displ,chosenFeatures,history,subject);
        
    predictions{2} = Prediction_LinearReg(weight_mat,train_limits,testdata,...
            sr,testDuration,windowSize,displ,chosenFeatures,history,subject);
    save(strcat('predict_linreg_',num2str(subject)','.mat'),'weight_mat','chosenFeatures','train_limits');
end