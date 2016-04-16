function [ out ] = Preprocess( data )
	
	out = data - mean(mean(data));
   
end

