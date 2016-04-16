function [ mdl_log_reg,predicted_dg ] = GenerateLogisticRegression()
    
   

    traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);
    
    traindata_ecog_sub1 = [traindata_ecog_sub1(:,1:54),traindata_ecog_sub1(:,56:end)];
    
    traindata_ecog_sub1 = Preprocess(traindata_ecog_sub1);

    trainlabels_sub_1 = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);

    trainlabels_sub_1(trainlabels_sub_1 <=1) = 0;
    trainlabels_sub_1(trainlabels_sub_1>1) = 1;
    
    weight_sub1 = LogisticRegressionModel(traindata_ecog_sub1,trainlabels_sub_1,sr,windowSize,displ);

    testdata_ecog_sub1 = session_sub1_test.data.getvalues(1:round(sr*testDuration),1:62);
    
    testdata_ecog_sub1 = [testdata_ecog_sub1(:,1:54),testdata_ecog_sub1(:,56:end)];

   testdata_ecog_sub1 = Preprocess(testdata_ecog_sub1);

    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_1(:,i));
	train_limits(i,2)=max(trainlabels_sub_1(:,i));
    end

    %Predicting
    pred_rounded_sub1 = Prediction_LogReg(weight_sub1,train_limits,testdata_ecog_sub1,sr,testDuration,windowSize,displ);

    %Checking the correlation
    %correlation_sub1 = mean(diag(corr(pred_rounded_sub1,trainlabels_sub_1)));

    clearvars traindata_ecog_sub1 trainlabels_sub_1 testdata_ecog_sub1;

    %% Predicting for subject 2

    totalDuration = (session_sub2_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub2_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub2_ecog.data.sampleRate;

    traindata_ecog_sub2 = session_sub2_ecog.data.getvalues(1:round(sr*totalDuration),1:48);
    
    traindata_ecog_sub2=[traindata_ecog_sub2(:,1:20),traindata_ecog_sub2(:,22:37),traindata_ecog_sub2(:,39:end)];
    
    traindata_ecog_sub2 = Preprocess(traindata_ecog_sub2);

    trainlabels_sub_2 = session_sub2_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    trainlabels_sub_2(trainlabels_sub_2 <=1) = 0;
    trainlabels_sub_2(trainlabels_sub_2>1) = 1;

    weight_sub2 = LogisticRegressionModel(traindata_ecog_sub2,trainlabels_sub_2,sr,windowSize,displ);

    testdata_ecog_sub2 = session_sub2_test.data.getvalues(1:round(sr*testDuration),1:48);
	
    testdata_ecog_sub2=[testdata_ecog_sub2(:,1:20),testdata_ecog_sub2(:,22:37),testdata_ecog_sub2(:,39:end)];
    
    testdata_ecog_sub2 = Preprocess(testdata_ecog_sub2);

    
    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_2(:,i));
	train_limits(i,2)=max(trainlabels_sub_2(:,i));
    end
    
    %Predicting
    pred_rounded_sub2 = Prediction_LogReg(weight_sub2,train_limits,testdata_ecog_sub2,sr,testDuration,windowSize,displ);

    %Checking the correlation
    %correlation_sub2 = mean(diag(corr(pred_rounded_sub2,trainlabels_sub_2)));

    clearvars traindata_ecog_sub2 trainlabels_sub_2 testdata_ecog_sub2;

    %% Predicting for subject 3

    totalDuration = (session_sub3_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub3_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub3_ecog.data.sampleRate;

    traindata_ecog_sub3 = session_sub3_ecog.data.getvalues(1:round(sr*totalDuration),1:64);
    
    traindata_ecog_sub3 = Preprocess(traindata_ecog_sub3);

    trainlabels_sub_3 = session_sub3_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    trainlabels_sub_3(trainlabels_sub_3 <=1) = 0;
    trainlabels_sub_3(trainlabels_sub_3>1) = 1;

    weight_sub3 = LogisticRegressionModel(traindata_ecog_sub3,trainlabels_sub_3,sr,windowSize,displ);

    testdata_ecog_sub3 = session_sub3_test.data.getvalues(1:round(sr*testDuration),1:64);
	
    testdata_ecog_sub3 = Preprocess(testdata_ecog_sub3);
    
    train_limits = zeros([5,2]);
    
    for i=1:5
	train_limits(i,1)=min(trainlabels_sub_3(:,i));
	train_limits(i,2)=max(trainlabels_sub_3(:,i));
    end
	
    %Predicting
    pred_rounded_sub3 = Prediction_LogReg(weight_sub3,train_limits,testdata_ecog_sub3,sr,testDuration,windowSize,displ);

    %Checking the correlation
    %correlation_sub3 = mean(diag(corr(pred_rounded_sub3,trainlabels_sub_3)));

    clearvars traindata_ecog_sub3 trainlabels_sub_3 testdata_ecog_sub3;


    %% Average Correlation

    %avg_corr = mean([correlation_sub1,correlation_sub2,correlation_sub3]);

    %% Generating output cell matrix


    predicted_dg = cell(3,1);
    predicted_dg{1} = pred_rounded_sub1;
    predicted_dg{2} = pred_rounded_sub2;
    predicted_dg{3} = pred_rounded_sub3;

    save('LeaderBoardSubmission.mat','predicted_dg');

    mdl_log_reg = cell(3,1);
    mdl_log_reg{1} = weight_sub1;
    mdl_log_reg{2} = weight_sub2;
    mdl_log_reg{3} = weight_sub3;


end

