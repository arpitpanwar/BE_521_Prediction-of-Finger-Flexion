function [ featureMat ] = normalizeFeatures(features)

featureMat = bsxfun(@minus,features,mean(features))./(max(features,2)-min(features,2));

end