addpath(genpath('../ieeg-matlab-1.13.2/'));

w = warning('off','all');

session_sub1_ecog = IEEGSession('I521_A0012_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub1_dglov = IEEGSession('I521_A0012_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub1_test = IEEGSession('I521_A0012_D003','arpitpanwar','../arp_ieeglogin.bin');

session_sub2_ecog = IEEGSession('I521_A0013_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub2_dglov = IEEGSession('I521_A0013_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub2_test = IEEGSession('I521_A0013_D003','arpitpanwar','../arp_ieeglogin.bin');

session_sub3_ecog = IEEGSession('I521_A0014_D001','arpitpanwar','../arp_ieeglogin.bin');
session_sub3_dglov = IEEGSession('I521_A0014_D002','arpitpanwar','../arp_ieeglogin.bin');
session_sub3_test = IEEGSession('I521_A0014_D003','arpitpanwar','../arp_ieeglogin.bin');


[model_linear_regression,predictions_linear_reg] = GenerateLinearRegression(); 