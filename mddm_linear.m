function [P lambda] = mddm_linear(X, L, projtype, mu, dim_para)
[D N] = size(X);

tmpL = L - repmat(mean(L,1),N,1);       %Æ½ÆÌ¾ØÕó
HLH = tmpL - repmat(mean(tmpL,2),1,N);

S = X * HLH * X';

if strcmp(projtype,'proj')
    B = eye(D);
else
    B = mu * X * X' + (1 - mu) * eye(D);
end

clear X L;


[tmp_P, tmp_lambda] = eig(S, B);
tmp_P = real(tmp_P);
tmp_lambda = real(diag(tmp_lambda));
[lambda, order] = sort(tmp_lambda, 'descend');
P = tmp_P(:,order);

proper_dim = getProperDim(lambda, dim_para);
P = P(:,1:proper_dim);
lambda = lambda(1:proper_dim);
