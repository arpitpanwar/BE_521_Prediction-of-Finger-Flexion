function [normalized_feature, mu, stddev] = featureNormalize(X)
% Declare variables
normalized_feature = X;
mu = zeros(1, size(X, 2));
stddev = zeros(1, size(X, 2));

% Calculates mean and std dev for each feature
for i=1:size(mu,2)
    mu(1,i) = mean(X(:,i)); 
    stddev(1,i) = std(X(:,i));
    normalized_feature(:,i) = (X(:,i)-mu(1,i))/stddev(1,i);
end
