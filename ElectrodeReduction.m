function [ featureMat ] = ElectrodeReduction(train_ecog,windows,samplingRate,windowsize,displ,subject)

    numFeatures = 3;
    len = size(train_ecog,2);
    featureMat = zeros([int64(windows),len*numFeatures]);
    % Generating features
    Hd = FilterDesign_Equiripple_FIR(1, 60);
    signal_1_60 = filter(Hd.coefficients{1}, 1, train_ecog);
    Hd = FilterDesign_Equiripple_FIR(60, 100);
    signal_60_100 = filter(Hd.coefficients{1}, 1, train_ecog);
    Hd = FilterDesign_Equiripple_FIR(100, 200);
    signal_100_200 = filter(Hd.coefficients{1}, 1, train_ecog);
    for i=0:len-1
        %Mean voltage in time domain
        disp(strcat(' -- ', num2str(i), ' -- '));
        BP = @(x,F) pyulear(x,100, F, 1000);
        curr = train_ecog(:,i+1);

        %Bandpower 1-60 hz
%        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[1,60]));
        counter = 1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));
       %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats2(curr,samplingRate,windowsize,displ,@(x)BP(x,[1 60]));            
%         featureMat(:,i*numFeatures+counter) = MovingWinFeats2(curr,samplingRate,windowsize,displ,@(x)BP(x,[1 60]));      
        featureMat(:,i*numFeatures+counter) = MovingWinFeats(signal_1_60,samplingRate,windowsize,displ,@(x)Energy(x));      
        %Bandpower 60-100hz
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[60,100]));            
        counter=counter+1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats2(curr,samplingRate,windowsize,displ,@(x)BP(x,[60 100]));      
        featureMat(:,i*numFeatures+counter) = MovingWinFeats(signal_60_100,samplingRate,windowsize,displ,@(x)Energy(x));      

        %Bandpower 100-200hz
        %featureMat(:,i*numFeatures+numFeatures) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[100,200]));
        counter = counter+1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));
        %featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats2(curr,samplingRate,windowsize,displ,@(x)BP(x,[100 200]));      
        featureMat(:,i*numFeatures+counter) = MovingWinFeats(signal_100_200,samplingRate,windowsize,displ,@(x)Energy(x));      
    end
    
 featureMat = bsxfun(@minus, featureMat, mean(featureMat))./(max(featureMat,2)-min(featureMat,2));
end
    
         
%     N = 3;
%     R = zeros([length(featureMat),size(featureMat,2)*N]);
%     
%     for i=1:size(featureMat,1)
%         for j=0:size(featureMat,2)-1
%             if i<=N
%                 R(i,j*N+1:j*N+N) = [zeros([1,N-i]),featureMat(1:i,j+1)'];
%             else
%                     R(i,j*N+1:j*N+N) = featureMat(i-N+1:i,j+1)';
%             end
%         end
%     end

