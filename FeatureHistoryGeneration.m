function [ R ] = FeatureHistoryGeneration( featureMat,history )
    if history == 0
        R = featureMat; 
        return
    end
    N = history;
    R = zeros([length(featureMat),size(featureMat,2)*N]);
    
    for i=1:size(featureMat,1)
        for j=0:size(featureMat,2)-1
            if i<=N
                R(i,j*N+1:j*N+N) = [zeros([1,N-i]),featureMat(1:i,j+1)'];
            else
                    R(i,j*N+1:j*N+N) = featureMat(i-N+1:i,j+1)';
            end
        end
    end

end

