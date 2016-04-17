function [weights,predictions] = GenerateLinearRegression(traindata,trainlabels,sr,windowSize,displ,testdata,testDuration)
    
    weights = LinearRegressionModel(traindata,trainlabels,sr,windowSize,displ);
       
    train_limits = zeros([5,2]);
    
    for i=1:5
        train_limits(i,1)=min(trainlabels(:,i));
        train_limits(i,2)=max(trainlabels(:,i));
    end

    %Predicting
    predictions = Prediction_LinearReg(weights,train_limits,testdata,sr,testDuration,windowSize,displ);
    
end
