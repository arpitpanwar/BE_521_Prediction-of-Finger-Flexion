function [ featureMat ] = FeatureGeneration( input_mat,windows,samplingRate )
%FEATUREGENERATION Summary of this function goes here
%   Detailed explanation goes here
    len = size(input_mat,2);
    featureMat = zeros([int64(windows),len*6]);

    % Generating features

    for i=0:len-1
        %Mean voltage in time domain
        curr = input_mat(:,i+1);
        featureMat(:,i*6+1) = MovingWinFeats(curr,samplingRate,0.1,0.05,@(x)mean(x));

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

end

