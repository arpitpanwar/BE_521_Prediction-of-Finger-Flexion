function [ranks, features] = reductionRanks(featureMat, trainlabels, divisor, K) 
    disp 'Generating ranks';
    K = 25;
    features = [];
    ranks = [];
    for i=1:size(trainlabels,2)
        disp(strcat('--',num2str(i),'--'));
        [rnk,~] = relieff(featureMat,trainlabels(:,i),K);
        % features = [features , ranks(i,1:round(length(ranks(i,:))*1/divisor))];
        features = [features , rnk(1:round(length(rnk)*1/divisor))];
    	ranks = [ranks;rnk];
    end
