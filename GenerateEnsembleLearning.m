function [ mdl_ensemble_learning,pred_ensemble ] = GenerateEnsembleLearning(  )

     warning('off','all');
    
    session_sub1_ecog = IEEGSession('I521_A0012_D001','arpitpanwar','../arp_ieeglogin.bin');
    session_sub1_dglov = IEEGSession('I521_A0012_D002','arpitpanwar','../arp_ieeglogin.bin');
    session_sub1_test = IEEGSession('I521_A0012_D003','arpitpanwar','../arp_ieeglogin.bin');

    session_sub2_ecog = IEEGSession('I521_A0013_D001','arpitpanwar','../arp_ieeglogin.bin');
    session_sub2_dglov = IEEGSession('I521_A0013_D002','arpitpanwar','../arp_ieeglogin.bin');
    session_sub2_test = IEEGSession('I521_A0013_D003','arpitpanwar','../arp_ieeglogin.bin');

    session_sub3_ecog = IEEGSession('I521_A0014_D001','arpitpanwar','../arp_ieeglogin.bin');
    session_sub3_dglov = IEEGSession('I521_A0014_D002','arpitpanwar','../arp_ieeglogin.bin');
    session_sub3_test = IEEGSession('I521_A0014_D003','arpitpanwar','../arp_ieeglogin.bin');
    
    %% Subject 1 prediction
    totalDuration = (session_sub1_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub1_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub1_ecog.data.sampleRate;

    traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

    trainlabels_sub_1 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    models_sub1 = EnsembleLearningModel(traindata_ecog_sub1,trainlabels_sub_1,sr);
    
    pred_rounded_sub1 = Prediction_Ensemble(models_sub1,trainlabels_sub_1,traindata_ecog_sub1,sr,totalDuration);
    
    correlation_sub1 = mean(diag(corr(pred_rounded_sub1,trainlabels_sub_1)));
    
    %% Subject 2 Predictions
    
    totalDuration = session_sub2_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6;

    testDuration = session_sub2_test.data.rawChannels(1).get_tsdetails.getDuration/10^6;

    sr = session_sub2_ecog.data.sampleRate;

    traindata_ecog_sub2 = session_sub2_ecog.data.getvalues(1:round(sr*totalDuration),1:48);

    trainlabels_sub_2 = session_sub2_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    models_sub2 = EnsembleLearningModel(traindata_ecog_sub2,trainlabels_sub_2,sr);
    
    pred_rounded_sub2 = Prediction_Ensemble(models_sub2,trainlabels_sub_2,traindata_ecog_sub2,sr,totalDuration);

    
    %% Subject 3 Predictions
    
    totalDuration = session_sub3_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6;

    testDuration = session_sub3_test.data.rawChannels(1).get_tsdetails.getDuration/10^6;

    sr = session_sub3_ecog.data.sampleRate;

    traindata_ecog_sub3 = session_sub3_ecog.data.getvalues(1:round(sr*totalDuration),1:64);

    trainlabels_sub_3 = session_sub3_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    models_sub3 = EnsembleLearningModel(traindata_ecog_sub3,trainlabels_sub_3,sr);
    
    pred_rounded_sub3 = Prediction_Ensemble(models_sub3,trainlabels_sub_3,traindata_ecog_sub3,sr,totalDuration);
    
%% Assimilating models and predictions
    
    pred_ensemble = cell(3,1);
    pred_ensemble{1} = pred_rounded_sub1;
    pred_ensemble{2} = pred_rounded_sub2;
    pred_ensemble{3} = pred_rounded_sub3;
    
    mdl_ensemble_learning = cell(3,1);
    mdl_ensemble_learning{1} = models_sub1;
    mdl_ensemble_learning{2} = models_sub2;
    mdl_ensemble_learning{3} = models_sub3;

end

