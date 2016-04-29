function [ranks, features] = reductionRanks(featureMat, trainlabels, numFeatures, K)
    K = 15;
    features = [];
    ranks = [];
    for i=1:size(trainlabels,2)
        disp(strcat('--',num2str(i),'--'));
        [rnk,~] = relieff(featureMat,trainlabels(:,i),K);
        features = [features , rnk(1:numFeatures)];
    	ranks = [ranks;rnk];
                %inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures))
    end
