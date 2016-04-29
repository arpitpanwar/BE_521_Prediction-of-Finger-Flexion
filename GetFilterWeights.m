function [filtered,weights] = GetFilterWeights(signal,modifiedsignal)

weights = [];
filtered = [];
lmsf = dsp.LMSFilter('Method','Sign-Sign LMS','Length',15);

for i=1:size(signal,2)
    [f,~,w] = step(lmsf,signal(:,i),modifiedsignal(:,i));
    filtered = [filtered,f];
    weights = [weights,w];
    
end

end