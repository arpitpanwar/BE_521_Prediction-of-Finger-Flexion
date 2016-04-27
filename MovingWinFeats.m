function [ featurevals ] = MovingWinFeats(x,fs,winLen,winDisp,featFn)
    windowval = round(((1/fs)*length(x) - winLen+winDisp)/winDisp);
    values_per_window = floor(length(x)/windowval);
    start = 1;
    values = cell(windowval,1);
    i=1;
    while windowval >0
       values{i} = featFn(x(start:start+values_per_window));
       start = start+values_per_window;
       windowval = windowval-1;
       i=i+1;
    end
   featurevals = cell2mat(values);
end

