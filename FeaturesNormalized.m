function [features] = FeaturesNormalized(featureMat)
    %features = bsxfun(@minus, featureMat, mean(featureMat,1))./(max(featureMat,1)-min(featureMat,1));
    
    %for i = 1:size(featureMat,2)
    %    features(:,i) = (featureMat(:,i) - mean(featureMat(:,i)))./(max(featureMat(:,i))-min(featureMat(:,i))); 
    %end
    
    features = zscore(featureMat);
    
end