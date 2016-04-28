function [filtered,weights] = GetFilterWeights(signal,modifiedsignal)

   lmsf = dsp.LMSFilter('Length',10,'Method','Normalized LMS', ...
       'StepSize',1);
   weights = [];
   filtered = [];
   for i=1:size(signal,2)
   
   [f,~,w] = step(lmsf,signal(:,i),modifiedsignal(:,i));
   
  % plot(filtered);
   filtered = [filtered,f];
   weights = [weights,w];
   
   end

end