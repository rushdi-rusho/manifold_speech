
function [K, X, A] = estimateLapKernelLR(nav, sigSq, lambda,gamma)

nf = size(nav,2);
nav=double(nav);

p = 1;
q = 1-p/2;
eta = 2;

X2 = double(sum(nav.*conj(nav),1));
X3 = (nav')*nav;
dsq = abs(repmat(X2,nf,1)+repmat(X2',1,nf)-2*real(X3));

% Changes
%============
medvalue = median(dsq(:));
maxvalue = medvalue;%./sigSq;
nav = nav./sqrt(maxvalue);
dsq = dsq./maxvalue;
%============
tt=dsq/sigSq;
K = exp(-tt);

[V,S,~] = svd(K);
nn=1;
if (nargin <= 3)
gamma = 100;
nn=80;
end

for i=1:nn    
    W = V*((S+gamma*eye(nf))^(-q))*V';
    
    A = W.*K;
    A = -diag(sum(A))+A;
    
     X = nav*inv(eye(nf) + (lambda)*A);
%      X = nav*(eye(nf) + lambda*A);

    
    gamma = gamma/eta;
    
    X2 = sum(X.*conj(X),1);
    X3 = (X')*X;
    dsq = abs(repmat(X2,nf,1)+repmat(X2',1,nf)-2*real(X3));
    K = exp(-dsq/sigSq);
    
    [V,S,~] = svd(K);
    
end

