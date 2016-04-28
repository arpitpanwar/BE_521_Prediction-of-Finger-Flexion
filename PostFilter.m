function [filtered] = PostFilter(inputSignal,weights)
    filtered = [];
    for i=1:size(inputSignal,2)
        f = filter(weights(:,i),1,inputSignal(:,i));
        filtered = [filtered,f];
    end
end