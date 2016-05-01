warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;
limit = 100;
start = 50;
l = 50;
maxcor = 0.00;
maxNumFeatures = [];
[traindata_sub3,trainlabels_sub3,testdata_sub3,testduration_sub3] = GetDataForSubject3(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
testDuration = length(traindata_sub3)/sr;

for i=start:limit
    for j=start:limit
        
        for k=start:limit
            
                
                for m=start:limit
                    numFeatures = [i,j,k,l,m];
                    [weights_sub3,pred_ridreg_sub3]= GenerateRidgeRegression(traindata_sub3,...
                        trainlabels_sub3,sr,windowSize,displ,traindata_sub3,testDuration,3,25,numFeatures);
                    
                    [~,filterWeights] = GetFilterWeights(trainlabels_sub3,pred_ridreg_sub3);
                    
                    pred_ridreg_sub3 = PostFilter(pred_ridreg_sub3,filterWeights);
                    
                    sub3 = mean(diag(corr(pred_ridreg_sub3(:,[1,2,3,5]),trainlabels_sub3(:,[1,2,3,5]))));
                    
                    if sub3 > maxcor
                       maxcor = sub3;
                       disp 'Max correlatio found';
                       maxcor
                       maxNumFeatures = numFeatures;
                       save('MaxNumFeatures_sub3.mat','maxNumFeatures','maxcor');
                    end
                end
                
            
            
        end
        
    end
    
end

