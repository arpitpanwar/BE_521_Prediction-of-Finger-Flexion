function [weights, newElectrodes, trainPredictions, testPredictions] = GenerateElectrodeReduction(traindata,trainlabels, trainduration, testdata, testduration, sr,windowSize,displ, subject,history)
    wins = NumWins(length(traindata),sr,windowSize,displ);
    trainlabels_decimated = zeros([int64(length(trainlabels)/(displ*10^3)),5]);
    chosenElectrode = zeros(size(traindata,2)*3,5);
    newElectrodes = cell(5,1);
    weights = cell(5,1);
    testPredictions = cell(5,1);
    trainPredictions = cell(5,1);
    fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
    for i = 1:5
        trainlabels_decimated(:,i) = decimate(trainlabels(:,i),displ*10^3);
    end  
    if exist(strcat('electrodeFeatures',num2str(subject),'v7.mat'),'file')
        disp(strcat('Loading electrode model for subject: ',num2str(subject)));
        load(strcat('electrodeFeatures',num2str(subject),'v6.mat'))
    else

%        trainlabels_decimated = trainlabels_decimated(1:end-1,:);
        disp ' -- '
        disp(strcat('Generating electrode reduction model: Subject ',num2str(subject)));
        electrode_featureMat = ElectrodeReduction(traindata,wins,sr,windowSize,displ,subject);
        for i = 1:5
            disp(strcat('Modeling features for each finger', num2str(i)));
            %[~, ~,~, chosenElectrode(:,i)] = stepwisefit(electrode_featureMat,trainlabels_decimated(:,i),'scale','on');      
            %newElectrodes{i} = find(sum(reshape(chosenElectrode(:,i),3,length(chosenElectrode(:,i))/3)));             
            [inModel] = sequentialfs(fun, electrode_featureMat, trainlabels_decimated(:,i));
        end
        disp ' __ '
        save(strcat('electrodeFeatures',num2str(subject),'v6.mat'), 'electrode_featureMat','newElectrodes');
    end

    
    for i = 1:5
        [weights{i}, train_limits(i,:), chosenFeatures,featureMat]= GenerateLinearRegression(traindata(:,newElectrodes{i}),trainlabels(:,i),sr,windowSize,displ,0 ,0 ,subject,history, i); 
        [trainPredictions{i}] = Prediction_LinearReg(weights{i},train_limits(i,:),featureMat,sr,trainduration,windowSize, displ,chosenFeatures,subject,history,i);
        [testPredictions{i}] = Prediction_LinearReg(weights{i},train_limits(i,:), testdata(:,newElectrodes{i}),sr,testduration,windowSize,displ,chosenFeatures,subject,history,i);
    end

%         feats = floor((new_electrodes{i}-1) * numFeatures *
%         numElectrodeFeatures+1); 
%         for j = 1:length(feats)
%             sel = feats(j):feats(j)+numFeatures * numElectrodeFeatures-1;
%             reducedfeatures{i} = [reducedfeatures{i} fullfeatureMat(:,sel)];
%         end
   
end