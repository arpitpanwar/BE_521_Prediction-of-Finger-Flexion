function [predicted_dg] = make_predictions(test_ecog)

% Inputs: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.
% Outputs: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)

% Run time: The script has to run less than 1 hour. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following is a sample script.

% Load Model. The variable models contains weights for each person,
% each channel, and each finger.

load 'SavedModels.mat';

% Predict using linear predictor for each subject
%create cell array with one element for each subject
predicted_dg = cell(3,1);
history = 25;
windowSize = 0.08;
displ = 0.04;
%for each subject
for subj = 1:3 
    
    %get the testing ecog
    testset = test_ecog{subj}; 
    
    sr = 1000;
    
    duration = length(testset)/10^3;
    
    testset = Preprocess(testset);
    
    weight = weights_pred_ridreg{subj};
    
    load(strcat('Trainlimits_sub',num2str(subj),'.mat'));
    load(strcat('chosenfeatures_sub',num2str(subj),'.mat'));
    
    switch subj
        case 1
            history = 15;
        case 2
            history = 10;
        case 3
            history = 25;
    end
    
    predictions = Prediction_Ridge(weight,train_limits, testset,sr,duration,...
                    windowSize,displ,chosenFeatures,history,subj);
    
    load(strcat('FilterWeights_sub',num2str(subj),'.mat'));
    
   % predictions = PostFilter(predictions,filterWeights);
    
    clearvars filterWeights train_limits weight chosenFeatures;
    
    predicted_dg{subj} = predictions;
end

