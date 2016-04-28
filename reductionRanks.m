function [ranks, features] = reductionRanks(featureMat, trainlabels, numFeatures, K) 
    disp 'Generating ranks';
    K = 15;
    features = [];
    ranks = [];
    for i=1:size(trainlabels,2)
        disp(strcat('--',num2str(i),'--'));
        [rnk,~] = relieff(featureMat,trainlabels(:,i),K);
        features = [features , ranks(i,1:numFeatures(subject))];
    	ranks = [ranks;rnk];
                %inmodel = sequentialfs(fun,featureMat,trainlabels_decimated(:,i),'keepin',ranks(i,1:numFeatures))
    end
