function [ weighted_electrodes, chosenElectrodeFeatures] = GenerateElectrodeReduction(train_ecog_data,train_labels,samplingRate,windowSize,displ)
    %function [ weighted_electrodes, reducedElectrodes, chosenElectrodes] = GenerateElectrodeReduction(train_ecog_data,train_labels,samplingRate,windowSize,displ,subject )
%    switch subject
%         case 1
%              load 'features1_k15.mat';
%             load 'ranks_emp1_k15.mat';
%         case 2
%             load 'features_emp2_k15.mat';
%             load 'ranks_emp2_k15.mat';
%         case 3
%             load 'features_emp3_k15.mat';
%             load 'ranks_emp3_k15.mat';
%     end
    
    
    wins = NumWins(length(train_ecog_data),samplingRate,windowSize,displ);
    disp ' -- '
    disp 'Generating electrode reduction model';

    featureMat = ElectrodeReduction(train_ecog_data,wins,samplingRate,windowSize,displ);
    save(strcat('features_BP_nohistory',num2str(fix(clock)),'_k15.mat'),'featureMat');

%     load 'features_k15.mat'

    clearvars curr;
    
    %Decimate the training labels
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i=1:5
        trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
    end
    
   % train_labl_test = trainlabels_decimated;

    %trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);
     
     %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
     disp '';
     disp 'Selecting features';

%% COMMENTING TO SAVE TIME     
%      
%      K = 15;
%      features = [];
%      ranks = [];
%      for i=1:5
%          disp(strcat('Finger ',str2num(i)));
%         [rnk,~] = relieff(featureMat,trainlabels_decimated(:,i),K);
%      %   features = [features , ranks(i,1:round(length(ranks(i,:))*1/45))];
%         features = [features , rnk(1:round(length(rnk)*1/55))];
%         ranks = [ranks;rnk];
%      end
%          
%      save(strcat('ranks',num2str(fix(clock)),'_k15.mat'),'ranks');
%      chosenElectrodes = unique(features);
%%     
%      chosenElectrodes_relieff = featureMat(:,chosenElectrodes);
%      save(strcat('chosenElectrodes_relieff',num2str(fix(clock)),'_k15.mat'),' chosenElectrodes_relieff ');
     
  
    % featureMat = [ones([size(featureMat,1),1]),featureMat];
    % Not needed for stepwise fit, see documentation
 
    
    
    %Generating weight matrix
    disp ''
    disp 'Generating weight matrix';
    for i=1:5
%%     
%         disp(strcat('Finger ',str2num(i)))
%         [weighted_electrodes{i} STATS{i}] = stepwisefit( chosenElectrodes_relieff ,trainlabels_decimated(:,i),'scale','on') ; 
%         reducedElectrodes{i} =  chosenElectrodes_relieff (:,weight_mat{i})
%         save(strcat('reducedElectrodes',num2str(i),num2str(fix(clock)),'_k15.mat'),'reducedElectrodes');
%      
        
        [weighted_features_without_relieff(:,i), ~,~, chosenElectrodeFeatures(:,i), STATS_without_relief{i}] = stepwisefit(featureMat,trainlabels_decimated(:,i),'scale','on') ;;
        save(strcat('electrodeFeatures',num2str(i),'_-_',num2str(fix(clock)),'_k15.mat'),'chosenElectrodeFeatures');

    end
    
new_electrodes = cell(1);
numFeatures = 9;
numElectrodeFeatures = 3;

history = 3;
red_featuresMat = zeros(7749, 61 * numElectrodeFeatures * history);
for i = 1:5
    new_electrodes{i} = floor(find(chosenElectrodeFeatures(:,i))/numElectrodeFeatures)+1;
    feature_reduction{i} = new_electrode{i} * numFeatures * numElectrodeFeatures
  %  red_featuresMat{i} = fullfeatureMat(:, floor((new_electrodes(i}-1) * numFeatures * numElectrodeFeatures+1:floor((new_electrodes{i})*9));
    red_featuresMat{i} = fullfeatureMat(:, floor((new_electrodes{i}-1) * numFeatures * numElectrodeFeatures+1)));

end

for i = 1:5
red_featuresMat{i} = fullfeatureMat(:,floor((new_electrodes{i}-1) * numFeatures * numElectrodeFeatures+1));
end

traindata_sub1_finger1 = traindata_sub1(:,new_electrodes{1});
traindata_sub1_finger2 = traindata_sub1(:,new_electrodes{2});
traindata_sub1_finger3 = traindata_sub1(:,new_electrodes{3});
traindata_sub1_finger4 = traindata_sub1(:,new_electrodes{4});
traindata_sub1_finger5 = traindata_sub1(:,new_electrodes{5});


electrode_features = elect
end

