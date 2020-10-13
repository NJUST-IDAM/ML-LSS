function [model] = ML_LSS( X, Y, optmParameter)
   %% optimization parameters
    lam1            = optmParameter.lam1;
    lam2             = optmParameter.lam2;
    lam3            = optmParameter.lam3;
    lam4              = optmParameter.lam4;
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;

   %% initializtion
    num_dim = size(X,2);
    num_class = size(Y,2);
    XTX = X'*X;
    XTY = X'*Y;
    W_s = (XTX + lam3*eye(num_dim)) \ (XTY);
    W_s_1 = W_s;
    
    Q=Y*Y';
    [p,~] = mddm_linear(X', Q, 'spc', lam4,0.85);
    new_X = X*p;
    R = affininity(new_X,Y,0.9);
    D = diag(sum(R, 1));
    L = D - R;
    
    XLX=X'*L*X;
    
    iter    = 1;
    oldloss = 0;
    
    tic;
    Lip = sqrt(2*(norm(XTX)^2 + norm(lam1*2*XLX)^2));
    bk = 1;
    bk_1 = 1;
   %% proximal gradient
    while iter <= maxIter
%        tic;
       W_s_k  = W_s + (bk_1 - 1)/bk * (W_s - W_s_1);
       G_curr_pre = XTX*W_s_k;
       G_curr_pre_L = XLX * W_s_k;
       Gw_s_k = W_s_k - 1/Lip * ((G_curr_pre - XTY) + 2*lam1*G_curr_pre_L);
       
       bk_1 = bk;
       bk = (1 + sqrt(4*bk^2 + 1))/2;
       W_s_1 = W_s;
       W_s = softthres(Gw_s_k,lam2/Lip);
       
       O_curr_pre = X*W_s;
       predictionLoss = trace((O_curr_pre - Y)'*(O_curr_pre - Y));
       correlation = trace(O_curr_pre'*L*O_curr_pre);
       sparsity = sum(abs(W_s));
       totalloss = predictionLoss/2 + lam1*correlation + lam2*sparsity;
       if abs(oldloss - totalloss) <= miniLossMargin
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       
       iter=iter+1;
    end
    model = W_s;
end


%% soft thresholding operator
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0); 
end



  
