function [ weights,filteredData ] = PreFilter( data )
    mu = 0.8;
    lms = dsp.LMSFilter('StepSize',mu,'WeightsOutputPort',true);
    filterParams = FilterDesign_Lowpass_FIR();
    filteredData = filter(filterParams.coefficients{1},1,data);
    
    weights = zeros([lms.Length,size(data,2)]);
    
    for i=1:size(data,2)
       
        [~,~,weights(:,i)] = step(lms,data(:,i),filteredData(:,i));
        
    end
    
    
end

