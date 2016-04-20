function [ traindata,trainlabels,testdata,testDuration ] = GetDataForSubject3(user )
        
if user == 1
    session_sub3_ecog = IEEGSession('I521_A0014_D001','arpitpanwar','../arp_ieeglogin.bin');
    session_sub3_dglov = IEEGSession('I521_A0014_D002','arpitpanwar','../arp_ieeglogin.bin');
    session_sub3_test = IEEGSession('I521_A0014_D003','arpitpanwar','../arp_ieeglogin.bin');
else
    session_sub3_ecog = IEEGSession('I521_A0014_D001','jburrell','../jbu_ieeglogin.bin');
    session_sub3_dglov = IEEGSession('I521_A0014_D002','jburrell','../jbu_ieeglogin.bin');
    session_sub3_test = IEEGSession('I521_A0014_D003','jburrell','../jbu_ieeglogin.bin');
end

    totalDuration = (session_sub3_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    testDuration = (session_sub3_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;

    sr = session_sub3_ecog.data.sampleRate;

    traindata_ecog_sub3 = session_sub3_ecog.data.getvalues(1:round(sr*totalDuration),1:64);
    
    traindata = Preprocess(traindata_ecog_sub3);

    trainlabels = session_sub3_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
    
    testdata_ecog_sub3 = session_sub3_test.data.getvalues(1:round(sr*testDuration),1:64);
	
    testdata = Preprocess(testdata_ecog_sub3);
    
    save('Subject3_data.mat','testdata','trainlabels','traindata','testDuration');


end

