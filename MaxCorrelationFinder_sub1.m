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
[traindata_sub1,trainlabels_sub1,testdata_sub1,testduration_sub1] = GetDataForSubject1(user);

%[filteredlabels,filterWeights] = PreFilter(trainlabels_sub1);
testDuration = length(traindata_sub1)/sr;

for i=start:limit
    for j=start:limit
        
        for k=start:limit
            
                
                for m=start:limit
                    numFeatures = [i,j,k,l,m];
                    [weights_sub1,pred_ridreg_sub1]= GenerateRidgeRegression(traindata_sub1,...
                        trainlabels_sub1,sr,windowSize,displ,traindata_sub1,testDuration,1,25,numFeatures);
                    
                    [~,filterWeights] = GetFilterWeights(trainlabels_sub1,pred_ridreg_sub1);
                    
                    pred_ridreg_sub1 = PostFilter(pred_ridreg_sub1,filterWeights);
                    
                    sub1 = mean(diag(corr(pred_ridreg_sub1(:,[1,2,3,5]),trainlabels_sub1(:,[1,2,3,5]))));
                    
                    if sub1 > maxcor
                       maxcor = sub1;
                       disp 'Max correlatio found';
                       maxcor
                       maxNumFeatures = numFeatures;
                       save('MaxNumFeatures_sub1.mat','maxNumFeatures','maxcor');
                    end
                end
                            
        end
        
    end
    
end

