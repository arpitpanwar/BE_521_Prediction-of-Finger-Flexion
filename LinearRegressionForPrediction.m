function [ val ] = LinearRegressionForPrediction(XTrain,YTrain,XTest,YTest )
	
	wMat = (XTrain'*XTrain)\(XTrain'*YTrain);
	pred = XTest*wMat;
	val = mean(diag(corr(pred,YTest)));
end

