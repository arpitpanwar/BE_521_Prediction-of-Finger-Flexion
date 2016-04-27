function [ weighted_electrodes, chosenElectrodeFeatures, pred_linreg_sub] = GenerateElectrodeReduction(train_ecog_data,train_labels,samplingRate,windowSize,displ)
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
electrode_featureMat = ElectrodeReduction(train_ecog_data,wins,samplingRate,windowSize,displ);
save(strcat('features_BP_nohistory',num2str(fix(clock)),'_k15.mat'),'featureMat');

featureMat = FeatureGeneration(test_data,wins,samplingRate,windowSize,displ);

    featureMat = featureMat(:,chosenFeatures);
       featureMat = [ones([size(electrodeMat,1),1]),electrodeMat];

    
    trainlabels_decimated = zeros([int64(length(train_labels)/(displ*10^3)),5]);

    for i = 1:5
    disp(strcat('Reducing features for finger', num2str(i))
    [weighted_features_without_relieff(:,i), ~,~, chosenElectrodeFeatures(:,i), STATS_without_relief{i}] = stepwisefit(electrode_featureMat,trainlabels_decimated(:,i),'scale','on') ;;

    new_electrodes{i} = unique(floor(find(electrode_featureMat(:,i))/3)+1);
    feats = floor((new_electrodes{i}-1) * numFeatures * numElectrodeFeatures+1);
    for j = 1:length(feats)
        sel = feats(j):feats(j)+numFeatures * numElectrodeFeatures-1;
        reducedfeatures{i} = [reducedfeatures{i} fullfeatureMat(:,sel)];
    end

    
for finger = 1:5
    disp(strcat('Predicting finger ', num2str(finger))).
    [weights_sub{finger},pred_linreg_sub{finger}, pred_splined_sub{finger}]= GenerateLinearRegression(traindata_sub1,trainlabels_sub1,sr,windowSize,displ,testdata_sub1,testduration_sub1,finger);
    trainlabels_decimated(:,i) = decimate(train_labels(:,i),displ*10^3);
     trainlabels_decimated = trainlabels_decimated(1:end-1,:);

end
%     load 'features_k15.mat'
save(strcat('linregsub',num2str(fix(clock)),'_k15.mat'),'pred_linreg_sub');

clearvars curr;

%Decimate the training labels


% train_labl_test = trainlabels_decimated;

%trainlabels_decimated = [train_labl_test(1:end-2,:);train_labl_test(length(trainlabels_decimated),:)];

 %fun = @(XT,YT,xt,yt)LinearRegressionForPrediction(XT,YT,xt,yt);
disp '';
disp 'Selecting features';
disp 'Generating weight matrix';

% reducedfeatures = cell(1);
% new_electrodes = cell(1);
% numFeatures = 9;
% numElectrodeFeatures = 3;
% 
% history = 3;
% for i=1:5

%     disp(strcat('Finger ',str2num(i)))
%     [weighted_electrodes{i} STATS{i}] = stepwisefit( chosenElectrodes_relieff ,trainlabels_decimated(:,i),'scale','on') ; 
%     reducedElectrodes{i} =  chosenElectrodes_relieff (:,weight_mat{i})
%     save(strcat('reducedElectrodes',num2str(i),num2str(fix(clock)),'_k15.mat'),'reducedElectrodes');

        
%     [weighted_features_without_relieff(:,i), ~,~, chosenElectrodeFeatures(:,i), STATS_without_relief{i}] = stepwisefit(electrode_featureMat,trainlabels_decimated(:,i),'scale','on') ;;
%     new_electrodes{i} = unique(new_electrodes{i});
%     feats = floor((new_electrodes{i}-1) * numFeatures * numElectrodeFeatures+1);
%     for j = 1:length(feats)
%         sel = feats(j):feats(j)+numFeatures * numElectrodeFeatures-1;
%         reducedfeatures{i} = [reducedfeatures{i} fullfeatureMat(:,sel)];
%     end
% end


save(strcat('electrodeFeatures',num2str(fix(clock)),'_k15.mat'),'chosenElectrodeFeatures');


% red_featuresMat = zeros(7749, 61 * numElectrodeFeatures * history);
% for i = 1:5
%     new_electrodes{i} = floor(find(chosenElectrodeFeatures(:,i))/numElectrodeFeatures)+1;
%     feature_reduction{i} = new_electrode{i} * numFeatures * numElectrodeFeatures
%   %  red_featuresMat{i} = fullfeatureMat(:, floor((new_electrodes(i}-1) * numFeatures * numElectrodeFeatures+1:floor((new_electrodes{i})*9));
%     red_featuresMat{i} = fullfeatureMat(:, floor((new_electrodes{i}-1) * numFeatures * numElectrodeFeatures+1)));
% 
% end





%reducedFeatures = red_featuresMat{1}(red_featuresMat{1} > 0); 




