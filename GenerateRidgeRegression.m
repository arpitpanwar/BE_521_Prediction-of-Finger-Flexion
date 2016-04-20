function [ weights,predictions ] = GenerateRidgeRegression( traindata,trainlabels,sr,windowSize,displ,testdata,testDuration,subject )
    

    [weights,chosenFeatures] = RidgeRegressionModel(traindata,trainlabels,sr,windowSize,displ,subject);
       
    train_limits = zeros([5,2]);
    
    for i=1:5
        train_limits(i,1)=min(trainlabels(:,i));
        train_limits(i,2)=max(trainlabels(:,i));
    end

    %Predicting
    predictions = Prediction_Ridge(weights,train_limits,testdata,sr,testDuration,windowSize,displ,chosenFeatures);


end

