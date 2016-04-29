function [ out ] = Preprocess( data )

   data = (data - mean(mean(data)));%/(std(std(data)));
   out = zeros(size(data));
   for i=1:size(data,2)
	out(:,i) = smooth(data(:,i),9,'loess'); % - mean(mean(data));
   end
   
end
    
