warning('off','all');
windowSize = 0.08;
displ = 0.04;
sr = 10^3;
user = 1;
limit = 100;
start = 50;
l=50;
maxcor = 0.00;
maxNumFeatures = [];
[traindata_sub2,trainlabels_sub2,testdata_sub2,testduration_sub2] = GetDataForSubject2(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
testDuration = length(traindata_sub2)/sr;

for i=start:limit
    for j=start:limit
        
        for k=start:limit
            
                
                for m=start:limit
                    numFeatures = [i,j,k,l,m];
                    [weights_sub2,pred_ridreg_sub2]= GenerateRidgeRegression(traindata_sub2,...
                        trainlabels_sub2,sr,windowSize,displ,traindata_sub2,testDuration,2,25,numFeatures);
                    
                    [~,filterWeights] = GetFilterWeights(trainlabels_sub2,pred_ridreg_sub2);
                    
                    pred_ridreg_sub2 = PostFilter(pred_ridreg_sub2,filterWeights);
                    
                    sub2 = mean(diag(corr(pred_ridreg_sub2(:,[1,2,3,5]),trainlabels_sub2(:,[1,2,3,5]))));
                    
                    if sub2 > maxcor
                       maxcor = sub2;
                       disp 'Max correlatio found';
                       maxcor
                       maxNumFeatures = numFeatures;
                       save('MaxNumFeatures_sub2.mat','maxNumFeatures','maxcor');
                    end
                end
                
            
        end
        
    end
    
end

