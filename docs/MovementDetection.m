function [ Times, alltimes ] = MovementDetection(trainlabels, data, displ, pre, post)
    
    [peaks, inds] = findpeaks(trainlabels,'MinPeakHeight',max(trainlabels)/5);

    inds = inds(inds>1001);
    times = find(diff(inds) > 600); % Ignore first 2200 samples

    Times{1} = inds(1)-pre:inds(times(1))+post;
    alltimes = Times{1}(:);
    for i = 2:length(times)
        Times{i} = inds(times(i-1)+1)-pre:inds(times(i))+post;   
        alltimes = [alltimes; Times{i}(:)];
    end
end


    

function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end
