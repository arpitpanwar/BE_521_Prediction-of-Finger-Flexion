function [features] = FeaturesNormalized(featureMat)
    features = bsxfun(@minus, featureMat, mean(featureMat)./(max(featureMat,2)-min(featureMat,2)));
end