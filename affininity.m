function [R] = affininity(X,Y,sigm)
    [num_train,~]=size(X);
    R = zeros(num_train,num_train);
    p_idx=find(Y(:)==1);
    n_idx=setdiff([1:num_train],p_idx);

    W = ones(num_train,num_train);
    W(p_idx,n_idx)=0;
    W(n_idx,p_idx)=0;
    tempA = repmat(sum(X.^2,2),1,num_train);
    tempB = tempA';
    tempC = X*X';
    edu_dis = tempA+tempB-2*tempC;
    edu_new = exp((-(edu_dis.^2))/2*sigm^2);
    R=edu_new.*W;
end
