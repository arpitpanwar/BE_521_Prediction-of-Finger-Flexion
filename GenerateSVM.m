function [models,predictions] = GenerateSVM(traindata,trainlabels,sr,windowSize,displ,testdata,testDuration)
    
    trainlabels(trainlabels <=1) = 0;
    trainlabels(trainlabels >1) = 1;

    models = SVMModels(traindata,trainlabels,sr,windowSize,displ);
       
    train_limits = zeros([5,2]);
    
    for i=1:5
        train_limits(i,1)=min(trainlabels(:,i));
        train_limits(i,2)=max(trainlabels(:,i));
    end

    %Predicting
    predictions = Prediction_SVM(models,train_limits,testdata,sr,testDuration,windowSize,displ);
    
end