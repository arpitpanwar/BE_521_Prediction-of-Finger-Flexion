function [ traindata,trainlabels,testdata,testDuration ] = GetDataForSubject2(user)
    
if user == 1
    session_sub2_ecog = IEEGSession('I521_A0013_D001','arpitpanwar','../arp_ieeglogin.bin');
    session_sub2_dglov = IEEGSession('I521_A0013_D002','arpitpanwar','../arp_ieeglogin.bin');
    session_sub2_test = IEEGSession('I521_A0013_D003','arpitpanwar','../arp_ieeglogin.bin');
else
    session_sub2_ecog = IEEGSession('I521_A0013_D001','jburrell','../jbu_ieeglogin.bin');
    session_sub2_dglov = IEEGSession('I521_A0013_D002','jburrell','../jbu_ieeglogin.bin');
    session_sub2_test = IEEGSession('I521_A0013_D003','jburrell','../jbu_ieeglogin.bin');
end

    totalDuration = (session_sub2_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub2_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub2_ecog.data.sampleRate;

    traindata_ecog_sub2 = session_sub2_ecog.data.getvalues(1:round(sr*totalDuration),1:48);
    
    traindata_ecog_sub2=[traindata_ecog_sub2(:,1:20),traindata_ecog_sub2(:,22:37),traindata_ecog_sub2(:,39:end)];
    
    traindata = Preprocess(traindata_ecog_sub2);

    trainlabels = session_sub2_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    testdata_ecog_sub2 = session_sub2_test.data.getvalues(1:round(sr*testDuration),1:48);
	
    testdata_ecog_sub2=[testdata_ecog_sub2(:,1:20),testdata_ecog_sub2(:,22:37),testdata_ecog_sub2(:,39:end)];
    
    testdata = Preprocess(testdata_ecog_sub2);
    
    save('Subject2_data.mat','testdata','trainlabels','traindata','testDuration');


end

