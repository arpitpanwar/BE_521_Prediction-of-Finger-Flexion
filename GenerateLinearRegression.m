function [weights,predictions] = GenerateLinearRegression(traindata, ...
        trainlabels,sr,windowSize,displ,testdata,testDuration,subject,history)
    
%     train_limits = zeros([5,2]);
%     
%     for i=1:5
%         train_limits(i,1)=min(trainlabels(:,i));
%         train_limits(i,2)=max(trainlabels(:,i));
%     end
%     
%     save(strcat('Trainlimits_sub',num2str(subject),'.mat'),'train_limits');
    
    load(strcat('Trainlimits_sub',num2str(subject),'.mat'));
        
    [weights,chosenFeatures] = LinearRegressionModel(traindata,trainlabels, ...
            sr,windowSize,displ,subject,history);
       

    %Predicting
    predictions = Prediction_LinearReg(weights,train_limits,testdata,...
            sr,testDuration,windowSize,displ,chosenFeatures,history,subject);
    
end
