function [ out ] = Preprocess( data )
	
    out = data - mean(mean(data));
	%out = sgolayfilt(data,3,5); % - mean(mean(data));
   
end

