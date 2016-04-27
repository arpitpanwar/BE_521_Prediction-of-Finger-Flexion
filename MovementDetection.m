function [ Times ] = MovementDetection(trainlabels, pre, post)

[peaks, inds] = findpeaks(trainlabels(:,1),'MinPeakHeight',max(trainlabels(:,1)/5));

inds = inds(inds>1001);
times = find(diff(inds) > 600); % Ignore first 2200 samples

Times{1} = inds(1)-pre:inds(times(1))+post;
for i = 2:length(times)
Times{i} = inds(times(i-1)+1)-pre:inds(times(i))+post;       
end

end