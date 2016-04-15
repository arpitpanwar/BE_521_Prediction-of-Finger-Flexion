function [mdl_lin_reg,predicted_dg] = GenerateLinearRegression()

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
    
    
    totalDuration = (session_sub1_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub1_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub1_ecog.data.sampleRate;

    traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);

    trainlabels_sub_1 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

    weight_sub1 = LinearRegressionModel(traindata_ecog_sub1,trainlabels_sub_1,sr);

    testdata_ecog_sub1 = session_sub1_test.data.getvalues(1:round(sr*testDuration),1:62);
    
    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_1(:,i));
	train_limits(i,2)=max(trainlabels_sub_1(:,i));
    end

    %Predicting
    pred_rounded_sub1 = Prediction_LinearReg(weight_sub1,train_limits,traindata_ecog_sub1,sr,totalDuration);

    %Checking the correlation
    correlation_sub1 = mean(diag(corr(pred_rounded_sub1,trainlabels_sub_1)));

    clearvars traindata_ecog_sub1 trainlabels_sub_1 testdata_ecog_sub1;

    %% Predicting for subject 2

    totalDuration = (session_sub2_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub2_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub2_ecog.data.sampleRate;

    traindata_ecog_sub2 = session_sub2_ecog.data.getvalues(1:round(sr*totalDuration),1:48);

    trainlabels_sub_2 = session_sub2_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

    weight_sub2 = LinearRegressionModel(traindata_ecog_sub2,trainlabels_sub_2,sr);

    testdata_ecog_sub2 = session_sub2_test.data.getvalues(1:round(sr*testDuration),1:48);
	
    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_2(:,i));
	train_limits(i,2)=max(trainlabels_sub_2(:,i));
    end
    
    %Predicting
    pred_rounded_sub2 = Prediction_LinearReg(weight_sub2,train_limits,traindata_ecog_sub2,sr,totalDuration);

    %Checking the correlation
    correlation_sub2 = mean(diag(corr(pred_rounded_sub2,trainlabels_sub_2)));

    clearvars traindata_ecog_sub2 trainlabels_sub_2 testdata_ecog_sub2;

    %% Predicting for subject 3

    totalDuration = (session_sub3_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub3_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub3_ecog.data.sampleRate;

    traindata_ecog_sub3 = session_sub3_ecog.data.getvalues(1:round(sr*totalDuration),1:64);

    trainlabels_sub_3 = session_sub3_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

    weight_sub3 = LinearRegressionModel(traindata_ecog_sub3,trainlabels_sub_3,sr);

    testdata_ecog_sub3 = session_sub3_test.data.getvalues(1:round(sr*testDuration),1:64);
	
    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_3(:,i));
	train_limits(i,2)=max(trainlabels_sub_3(:,i));
    end
	
    %Predicting
    pred_rounded_sub3 = Prediction_LinearReg(weight_sub3,train_limits,traindata_ecog_sub3,sr,totalDuration);

    %Checking the correlation
    correlation_sub3 = mean(diag(corr(pred_rounded_sub3,trainlabels_sub_3)));

    clearvars traindata_ecog_sub3 trainlabels_sub_3 testdata_ecog_sub3;


    %% Average Correlation

    avg_corr = mean([correlation_sub1,correlation_sub2,correlation_sub3]);

    %% Generating output cell matrix


    predicted_dg = cell(3,1);
    predicted_dg{1} = pred_rounded_sub1;
    predicted_dg{2} = pred_rounded_sub2;
    predicted_dg{3} = pred_rounded_sub3;

    save('LeaderBoardSubmission.mat','predicted_dg');

    mdl_lin_reg = cell(3,1);
    mdl_lin_reg{1} = weight_sub1;
    mdl_lin_reg{2} = weight_sub2;
    mdl_lin_reg{3} = weight_sub3;

end
