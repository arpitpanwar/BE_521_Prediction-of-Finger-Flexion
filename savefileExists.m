function [ exists ] = savefileExists(filename)
    % type:
        % featureMat
        % weights (ranking, lasso)
        % model
    if exist(filename)
        exists = 1;
        load(filename)
    else
        exists = 0;
    end
end