function [data] = PostProcess(input)
    
    data = zeros(size(input));
    for i=1:size(input,2)
        data(:,i) = smooth(input(:,i),15,'rloess');
    end

end