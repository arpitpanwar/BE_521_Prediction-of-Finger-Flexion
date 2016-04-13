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

NumWins = @(xLen,fs,winLen,winDisp) ((1/fs)*xLen - winLen +winDisp)/winDisp;
wins = NumWins(length(traindata_ecog_sub1),sr,0.1,0.05);
featureMat = zeros([int64(wins),62*6]);

% Generating features

for i=0:61
    %Mean voltage in time domain
    curr = traindata_ecog_sub1(:,i+1);
    featureMat(:,i*6+1) = MovingWinFeats(curr,sr,0.1,0.05,@(x)mean(x));
    
    % Converting in frequency domain
    [s,w] = spectrogram(curr,hamming(100),50,[],2e3,'yaxis');
    
    %5-15 hz frequency
    num1 = find(w>=5 & w<15);
    featureMat(1:length(s),i*6+2) =mean(abs(s(num1,:)),1)';
    
    %20-25 hz frequency
    num1 = find(w>=20 & w<25);
    featureMat(1:length(s),i*6+3) = mean(abs(s(num1,:)),1)';

    %75-115 hz frequency
    num1 = find(w>=75 & w<115);
    featureMat(1:length(s),i*6+4) = mean(abs(s(num1,:)),1)';

    %125-160 hz frequency
    num1 = find(w>=125 & w<160);
    featureMat(1:length(s),i*6+5) = mean(abs(s(num1,:)),1)';
    
    %160-175 hz frequency
    num1 = find(w>=160 & w<175);
    featureMat(1:length(s),i*6+6) = mean(abs(s(num1,:)),1)';

end

clearvars curr;

%Train labels
trainlabels_sub_1 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

%Decimate the training labels
trainlabels_sub1_decimated = zeros([int64(length(trainlabels_sub_1)/50),5]);

for i=1:5
    trainlabels_sub1_decimated(:,i) = decimate(trainlabels_sub_1(:,i),50);
end

trainlabels_sub1_decimated = trainlabels_sub1_decimated(1:end-1,:);

%Generating weight matrix
weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_sub1_decimated); 

%Predicting
pred = featureMat*weight_mat;

% Spline function takes in the time that y occured and what time y should
% occur
pred_splined = zeros([length(traindata_ecog_sub1),5]);

for i=1:5
    pred_splined(:,i) = spline((0:0.05:309.9),pred(:,i),(0:0.001:309.998));
end

%Rounding
pred_rounded = round(pred_splined);

%Setting limits
for i=1:5
    minimum = min(trainlabels_sub_1(:,i));
    pred_remove = find(pred_rounded < minimum);
    pred_rounded(pred_remove) = minimum;
    
    maximum = max(trainlabels_sub_1(:,i));
    pred_remove = find(pred_rounded > maximum);
    pred_rounded(pred_remove) = maximum;
    
end

%Checking the correlation
correlation = mean(diag(corr(pred_rounded,trainlabels_sub_1)));