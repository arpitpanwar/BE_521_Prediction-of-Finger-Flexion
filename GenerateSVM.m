function [models,predictions] = GenerateSVM(traindata,trainlabels,sr,windowSize,displ,testdata,testDuration,subject)

    [models] = SVMModels(traindata,trainlabels,sr,windowSize,displ,subject);
       
    train_limits = zeros([5,2]);
    
    
        train_limits(1,1)=min(trainlabels);
        train_limits(1,2)=max(trainlabels);
    

    %Predicting
    predictions = Prediction_SVM(models,train_limits,testdata,sr,testDuration,windowSize,displ);
    
end