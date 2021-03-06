function [ R ] = FeatureGeneration( input_mat,windows,samplingRate,windowsize,displ )

    numFeatures = 9;
    len = size(input_mat,2);
    featureMat = zeros([int64(windows),len*numFeatures]);
    
    % Generating features
    for i=0:len-1
        %Mean voltage in time domain
        counter =1;
        curr = input_mat(:,i+1);
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)mean(x));
        
        counter = counter+1;
        % Converting in frequency domain
        [s,w,~] = spectrogram(curr,windowsize*10^3,displ*10^3,[],2*samplingRate);

        %5-15 hz frequency
        num1 = find(w>=5 & w<=15);
        featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) =mean(abs(s(num1,:)),1)';
        
        counter = counter+1;
        %20-25 hz frequency
        num1 = find(w>=20 & w<=25);
        featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';

        counter = counter+1;
        %75-115 hz frequency
        num1 = find(w>=75 & w<=115);
        featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';

        counter = counter+1;
        %125-160 hz frequency
        num1 = find(w>=125 & w<160);
        featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
        
        counter = counter+1;
        %160-175 hz frequency
        num1 = find(w>=160 & w<175);
        featureMat(1:length(s),i*numFeatures+(mod(counter,numFeatures))) = mean(abs(s(num1,:)),1)';
       
        counter = counter+1;
        %Line Length
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)LineLength(x));
        counter = counter+1;
        %Energy
        %featureMat(:,i*numFeatures+8) = MovingWinFeats(curr,samplingRate,0.1,0.05,@(x)Energy(x));
        
        %Variance
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)var(x));

        %Area
        featureMat(:,i*numFeatures+numFeatures) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)Area(x));
        
        %Bandpower
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[1,60]));

        %counter=counter+1;
         %Bandpower
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[60,100]));
        
        %counter = counter+1;
        
         %Bandpower
        %featureMat(:,i*numFeatures+numFeatures) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[100,200]));

    end
    
    N = 3;
    R = zeros([length(featureMat),size(featureMat,2)*N]);
    
    for i=1:size(featureMat,1)
        for j=0:size(featureMat,2)-1
            if i<=N
                R(i,j*N+1:j*N+N) = [zeros([1,N-i]),featureMat(1:i,j+1)'];
            else
                    R(i,j*N+1:j*N+N) = featureMat(i-N+1:i,j+1)';
            end
        end
    end

end

