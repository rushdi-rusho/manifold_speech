function data = l2Recont(kdata,FT,csm,lambda,N,w)
%function data = l2Recont(kdata,FT,csm,lambda,N)
%
% Arguments:
%   kdata   [np nv nf nc]   complex
%   FT      Fourier operator
%   csm     coil sens map
%   lambda      threshold
%   N               reconstucted image size
%
% Optional Arguments:

%
% Outputs:
%   data     [N N N Nt]      complex


[~,~,nFrames,nCh] = size(kdata); 
Atb = zeros(N,N,nFrames);

for ii=1:nCh
    tmp=bsxfun(@times,kdata(:,:,:,ii),(w).^0);
    %tmp=kdata(:,:,:,ii);
    Atb = Atb + bsxfun(@times,FT'*tmp,conj(csm(:,:,ii)));
end
lambda=max(abs(Atb(:)))*lambda;

ATA = @(x) SenseATA(x,FT,csm,N,nFrames,nCh) + lambda*x;
data = pcg(ATA,Atb(:),1e-10,40,[],[],Atb(:));
data = reshape(data,[N,N,nFrames]);

end