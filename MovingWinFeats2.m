function [ featurevals ] = MovingWinFeats2(x,fs,winLen,winDisp,featFn)
    windowval = round(((1/fs)*length(x) - winLen+winDisp)/winDisp);
    values_per_window = floor(length(x)/windowval);
    start = 1;
    values = zeros(windowval,1);
    for i = 0:windowval-1
        [val1, val2] =  featFn(x(start:start+values_per_window-1));        
        values(i+1) = val1*val2;
        start = start + winDisp*fs;
        
    end
    %featurevals = values;
 
%     while windowval >0
%      
%        values{i} = val1*val2;
%        start = start+values_per_window;
%        windowval = windowval-1;
%        i=i+1;
%     end
   featurevals = values;
end
% % 
% Ly = (length(x))/fs;
% ni = rem((Ly - winLen + winDisp),winDisp);
% 
% windowval = round(((1/fs)*length(x) - winLen+winDisp)/winDisp);
% % features = zeros(winLen*fs+1, NumWins-1);
% featuresvals = zeros(1, windowval);
% ind =[];
% val =[];
% 
% %rem(length(y))-L+d,d))
% 
% for i = 0:windowval-1
%     window_start = floor((i*winDisp*fs)+1);
%     window_end = (window_start+winLen*fs);
%     change = window_start:window_start+winLen*fs;
%     featurevals(i+1) = feval(featFn, x(change));       
% end