function [ movement_inds ] = MovementDetection(trainlabels, pre, post)
    
t = trainlabels;
t( t >= 1/5*max(t,2)) = 1;
t( t < 1/5*max(t,2)) = 0;
x = 1:length(trainlabels);

[peaks, inds, width] = findpeaks(t,'MinPeakDistance',50);
inds = inds(inds>pre);
W = median(width,'omitnan');


count = 1;
i = 1;
while i < length(inds)
    curr = inds(i:end);
    sel = curr(curr >= inds(i) & curr <= inds(i)+post );
    movement_inds{count} = sel(1)-pre:sel(end)+post;
    count = count+1;    
    i = i+length(sel);   
end
end