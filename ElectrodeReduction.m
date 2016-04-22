function [ R ] = ElectrodeReduction(input_mat,windows,samplingRate,windowsize,displ )

    numFeatures = 3;
    len = size(input_mat,2);
    featureMat = zeros([int64(windows),len*numFeatures]);
    % Generating features
    for i=0:len-1
        %Mean voltage in time domain
        disp(strcat(' -- ', num2str(i), ' -- '));
        counter =1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));

        curr = input_mat(:,i+1);
        %Bandpower 1-60 hz
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[1,60]));
        counter=counter+1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));

        %Bandpower 60-100hz
        featureMat(:,i*numFeatures+(mod(counter,numFeatures))) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[60,100]));        
        counter = counter+1;
        disp(strcat('Feature: ',num2str(i),'.',num2str(counter)));

        %Bandpower 100-200hz
        featureMat(:,i*numFeatures+numFeatures) = MovingWinFeats(curr,samplingRate,windowsize,displ,@(x)bandpower(x,samplingRate,[100,200]));
        counter = counter+1;
        disp(strcat('Feature ',num2str(i),'.',num2str(counter)));

    end
    save(strcat('features_BP_nohistoryA',num2str(fix(clock)),'_k15.mat'),'featureMat');

    R = featureMat;
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

end

