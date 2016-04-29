function [ corrs_] = corrs
[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(2);
traindata = traindata_sub1;
trainlabels = trainlabels_sub1;
numFeatures = 1;

windowsize = .08;
displ = .04;
samplingRate = 1000;
for i = 0:size(traindata,2)-1
    curr = traindata(:,i+1);
    traindata_avg(:,i+1) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)mean(x));    
end

trainlabels_decimated = trainlabelsPreload(trainlabels, displ);
for i = 1:size(traindata,2)
    for j = 1:size(trainlabels,2)
        corrs_(i,j) = corr(traindata_avg(:,i), trainlabels_decimated(:,j));
    end
end
end


    trainlabels_avg = MovingWinFeats(trainlabels(:,1),samplingRate,windowsize,displ,@(x)mean(x));    



function trainlabels_decimated = trainlabelsPreload(train_labels, displ)
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),size(train_labels,2)]);

    for i=1:size(train_labels,2)
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
 end