function [ out ] = Preprocess( data )
	
   % out = (data - mean(mean(data)));%/(std(std(data)));
   out = zeros(size(data));
   for i=1:size(data,2)
	out(:,i) = smooth(data(:,i),'lowess'); % - mean(mean(data));
   end
end

