function [ traindata,trainlabels,testdata,testDuration ] = GetDataForSubject1(user)

% if user == 1
%     session_sub1_ecog = IEEGSession('I521_A0012_D001','arpitpanwar','../arp_ieeglogin.bin');
%     session_sub1_dglov = IEEGSession('I521_A0012_D002','arpitpanwar','../arp_ieeglogin.bin');
%     session_sub1_test = IEEGSession('I521_A0012_D003','arpitpanwar','../arp_ieeglogin.bin');
% else
%     session_sub1_ecog = IEEGSession('I521_A0012_D001','jburrell','../jbu_ieeglogin.bin');
%     session_sub1_dglov = IEEGSession('I521_A0012_D002','jburrell','../jbu_ieeglogin.bin');
%     session_sub1_test = IEEGSession('I521_A0012_D003','jburrell','../jbu_ieeglogin.bin');
% end
%     
% totalDuration = (session_sub1_ecog.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;
% 
% testDuration = (session_sub1_test.data.rawChannels(1).get_tsdetails.getDuration/10^6)+0.001;
% 
% sr = session_sub1_ecog.data.sampleRate;
% 
% traindata_ecog_sub1 = session_sub1_ecog.data.getvalues(1:round(sr*totalDuration),1:62);
% 
% traindata_ecog_sub1 = [traindata_ecog_sub1(:,1:54),traindata_ecog_sub1(:,56:end)];
% 
% traindata = Preprocess(traindata_ecog_sub1);
% 
% trainlabels = session_sub1_dglov.data.getvalues(1:round(sr*totalDuration),1:5);
% 
% testdata_ecog_sub1 = session_sub1_test.data.getvalues(1:round(sr*testDuration),1:62);
% 
% testdata_ecog_sub1 = [testdata_ecog_sub1(:,1:54),testdata_ecog_sub1(:,56:end)];
% testdata = Preprocess(testdata_ecog_sub1);
% 
% save('Subject1_data.mat','testdata','trainlabels','traindata','testDuration');

    load 'Subject1_data.mat';

end

