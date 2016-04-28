function [weight_mat] = reductionLasso(featureMat, trainlabels)
    weight_mat = zeros([size(featureMat,2),5]);
    
    for i= 1:size(trainlabels,2)
        c = zeros([100,1]);
        B = lasso(featureMat,trainlabels(:,i));
        for j=1:100
            c(j) = corr(featureMat*B(:,j),trainlabels(:,1));
        end
        weight_mat(:,i) = B(:,find(max(c)));
    end
    
end