addpath(genpath('../ieeg-matlab-1.13.2/'));

w = warning('off','all');

session_sub1_ecog = IEEGSession('I521_A0012_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub1_dglov = IEEGSession('I521_A0012_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub1_test = IEEGSession('I521_A0012_D003','arpitpanwar','../arp_ieeglogin.bin');

session_sub2_ecog = IEEGSession('I521_A0013_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub2_dglov = IEEGSession('I521_A0013_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub2_test = IEEGSession('I521_A0013_D003','arpitpanwar','../arp_ieeglogin.bin');

session_sub3_ecog = IEEGSession('I521_A0014_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub3_dglov = IEEGSession('I521_A0014_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub3_test = IEEGSession('I521_A0014_D003','arpitpanwar','../arp_ieeglogin.bin');

totalDuration = session_sub1_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6;

sr = session_sub1_ecog.data.sampleRate;

%% Predicting for subject 1

traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

trainlabels_sub_1 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

weight_sub1 = LinearRegressionModel(traindata_ecog_sub1,trainlabels_sub_1,sr);

%Predicting
pred_rounded_sub1 = Prediction_LinearReg(weight_sub1,trainlabels_sub_1,traindata_ecog_sub1,sr);   

%Checking the correlation
correlation_sub1 = mean(diag(corr(pred_rounded_sub1,trainlabels_sub_1)));

clearvars traindata_ecog_sub1 trainlabels_sub_1;

%% Predicting for subject 2

traindata_ecog_sub2 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

trainlabels_sub_2 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

weight_sub2 = LinearRegressionModel(traindata_ecog_sub2,trainlabels_sub_2,sr);

%Predicting
pred_rounded_sub2 = Prediction_LinearReg(weight_sub2,trainlabels_sub_2,traindata_ecog_sub2,sr);   

%Checking the correlation
correlation_sub2 = mean(diag(corr(pred_rounded_sub2,trainlabels_sub_2)));
clearvars traindata_ecog_sub2 trainlabels_sub_2;

%% Predicting for subject 3

traindata_ecog_sub3 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

trainlabels_sub_3 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

weight_sub3 = LinearRegressionModel(traindata_ecog_sub3,trainlabels_sub_3,sr);

%Predicting
pred_rounded_sub3 = Prediction_LinearReg(weight_sub3,trainlabels_sub_3,traindata_ecog_sub3,sr);   

%Checking the correlation
correlation_sub3 = mean(diag(corr(pred_rounded_sub3,trainlabels_sub_3)));
clearvars traindata_ecog_sub3 trainlabels_sub_3;


%% Average Correlation

avg_corr = mean([correlation_sub1,correlation_sub2,correlation_sub3]);