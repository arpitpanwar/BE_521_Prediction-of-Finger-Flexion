function [ featureMat ] = FeatureGeneration( input_mat,windows,samplingRate,windowsize,displ )

    numFeatures = 3;
    len = size(input_mat,2);
    featureMat = zeros([int64(windows),len*numFeatures]);
    Hd = FilterDesign_Equiripple_FIR(1, 60);
    signal_1_60 = filter(Hd.coefficients{1}, 1,input_mat);
    Hd = FilterDesign_Equiripple_FIR(60, 100);
    signal_60_100 = filter(Hd.coefficients{1}, 1, input_mat);
    Hd = FilterDesign_Equiripple_FIR(100, 200);
    signal_100_200 = filter(Hd.coefficients{1}, 1, input_mat);    

    save(
    
    % Generating features
    for i=0:len-1
        %Mean voltage in time domain
        disp(strcat('-- ', num2str(i), '/', num2str(len),' --'))

        counter =1;
        curr = input_mat(:,i+1);
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)mean(x));
        disp(strcat(num2str(i),':', num2str(counter)))
% 
%         counter = counter+1;
%         % Converting in frequency domain
%         [s,w,~] = spectrogram(curr,windowsize*10^3,displ*10^3,[],2*samplingRate);
%         disp(strcat(num2str(i),':', num2str(counter)))
% % 
%         %5-15 hz frequency
%         num1 = find(w>=5 & w<=15);
%         featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) =mean(abs(s(num1,:)),1)';        
%         counter = counter+1;
%         disp(strcat(num2str(i),':', num2str(counter)))
%         
%         %20-25 hz frequency
%         num1 = find(w>=20 & w<=25);
%         featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
% 
%         counter = counter+1;
%         disp(strcat(num2str(i),':', num2str(counter)))
%         
%         %75-115 hz frequency
%         num1 = find(w>=75 & w<=115);
%         featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
% 
%         counter = counter+1;
%         disp(strcat(num2str(i),':', num2str(counter)))
%         
%         %125-160 hz frequency
%         num1 = find(w>=125 & w<160);
%         featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
%                 counter=counter+1;
% 
%         counter = counter+1;
%         disp(strcat(num2str(i),':', num2str(counter)))
%                 counter=counter+1;
% 
%         %160-175 hz frequency
%         num1 = find(w>=160 & w<175);
%         featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
%        
        counter = counter+1;
        disp(strcat(num2str(i),':', num2str(counter)))
        %Energy
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)Energy(x));
        
        
        counter = counter+1;
        disp(strcat(num2str(i),':', num2str(counter))l;
        % Energy 1-60
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[1,60]));
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(signal_1_60,samplingRate,windowsize,displ,@(x)Energy(x));

        
counter=counter+1;
        disp(strcat(num2str(i),':', num2str(counter)))

         %Bandpower
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[60,100]));
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(signal_60_100,samplingRate,windowsize,displ,@(x)Energy(x));

        counter = counter+1;
        disp(strcat(num2str(i),':', num2str(counter)))

        
        %Bandpower
        %featureMat(:,i*numFeatures+numFeatures) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[100,300]));
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(signal_100_200,samplingRate,windowsize,displ,@(x)Energy(x));

    end
    
featureMat = bsxfun(@minus,featureMat,mean(featureMat))./(max(featureMat,2)-min(featureMat,2));
end