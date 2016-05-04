function K = Kernel_Intersection(X, X2)

X_new=transpose(X);
X2_new=transpose(X2);
 for i=1:n
 
         K(i,:)=sum(bsxfun(@min,X_new(:,i),X2_new),1);
 end

K=transpose(K);
