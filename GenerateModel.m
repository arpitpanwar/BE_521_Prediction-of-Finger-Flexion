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

traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

%% Generating features
NumWins = @(xLen,fs,winLen,winDisp) ((1/fs)*xLen - winLen +winDisp)/winDisp;
wins = NumWins(length(traindata_ecog_sub1),sr,0.1,0.05);
featureMat = zeros([int64(wins),62*6]);

% Average Time domain voltage and Frequency Domain voltage
fft_sub1 = fft(traindata_ecog_sub1);
magnitude_fft_sub1 = abs(fft_sub1);

for i=0:61
    curr = traindata_ecog_sub1(:,i+1);
    featureMat(:,i*6+1) = MovingWinFeats(curr,sr,0.1,0.05,@(x)mean(x));
    
    curr = magnitude_fft_sub1(:,i+1);
    num1 = FilterDesign_IIR(5,15);
    featureMat(:,i*6+2) = MovingWinFeats(filtfilt(num1.coefficients{1},num1.coefficients{2},curr),sr,0.1,0.05,@(x)mean(x));
    
    num1 = FilterDesign_IIR(20,25);
    featureMat(:,i*6+3) = MovingWinFeats(filtfilt(num1.coefficients{1},num1.coefficients{2},curr),sr,0.1,0.05,@(x)mean(x));

    num1 = FilterDesign_IIR(75,115);
    featureMat(:,i*6+4) = MovingWinFeats(filtfilt(num1.coefficients{1},num1.coefficients{2},curr),sr,0.1,0.05,@(x)mean(x));

    num1 = FilterDesign_IIR(125,160);
    featureMat(:,i*6+5) = MovingWinFeats(filtfilt(num1.coefficients{1},num1.coefficients{2},curr),sr,0.1,0.05,@(x)mean(x));
    
    num1 = FilterDesign_IIR(160,175);
    featureMat(:,i*6+6) = MovingWinFeats(filtfilt(num1.coefficients{1},num1.coefficients{2},curr),sr,0.1,0.05,@(x)mean(x));

end

clearvars curr;

trainlabels_sub_1= zeros([sr*totalDuration,5]);

for i=1:5
    trainlabels_sub_1(:,i) = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),i);
end

trainlabels_sub1_decimated = decimate(trainlabels_sub_1,50);

trainlabels_sub1_decimated = trainlabels_sub1_decimated(1:end-1);

weight_mat = inv(featureMat'*featureMat) * (featureMat'*trainlabels_sub1_decimated'); 

pred = featureMat*weight_mat;

% Spline function takes in the time that y occured and what time y should
% occur

pred_splined = spline((0:0.05:309.9),pred,(0:0.001:309.998));