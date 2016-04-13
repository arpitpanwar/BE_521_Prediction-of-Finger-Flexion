function [ pred_rounded ] = LinearRegressionPred( train_ecog_data,train_labels )

    NumWins = @(xLen,fs,winLen,winDisp) ((1/fs)*xLen - winLen +winDisp)/winDisp;
    wins = NumWins(length(train_ecog_data),sr,0.1,0.05);
    featureMat = zeros([int64(wins),62*6]);

    % Generating features

    for i=0:61
        %Mean voltage in time domain
        curr = train_ecog_data(:,i+1);
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

    %Decimate the training labels
    trainlabels_sub1_decimated = zeros([int64(length(train_labels)/50),5]);

    for i=1:5
        trainlabels_sub1_decimated(:,i) = decimate(train_labels(:,i),50);
    end

    trainlabels_sub1_decimated = trainlabels_sub1_decimated(1:end-1,:);

    %Generating weight matrix
    weight_mat = (featureMat'*featureMat) \ (featureMat'*trainlabels_sub1_decimated); 

    %Predicting
    pred = featureMat*weight_mat;

    % Spline function takes in the time that y occured and what time y should
    % occur
    pred_splined = zeros([length(train_ecog_data),5]);

    for i=1:5
        pred_splined(:,i) = spline((0:0.05:309.9),pred(:,i),(0:0.001:309.998));
    end

    %Rounding
    pred_rounded = round(pred_splined);

    %Setting limits
    for i=1:5
        minimum = min(train_labels(:,i));
        pred_remove = find(pred_rounded < minimum);
        pred_rounded(pred_remove) = minimum;

        maximum = max(train_labels(:,i));
        pred_remove = find(pred_rounded > maximum);
        pred_rounded(pred_remove) = maximum;

    end

end

