function  x = solveUVdcf(ktraj,kdata,dcf,csm, V, N, nIterations,SBasis,useGPU)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[nSamplesPerFrame,numFrames,~,~] = size(kdata);
[~,nbasis] = size(V);

if(useGPU)
    osf = 2; wg = 3; sw = 8;
    fprintf('inside')
    %w=ones(nSamplesPerFrame*numFrames,1);
    %w=repmat(dcf,[1 5*numFrames]);
    ktraj_gpu = [real(ktraj(:)),imag(ktraj(:))]';
    FT = gpuNUFFT(ktraj_gpu/N,dcf(:),osf,wg,sw,[N,N],[],true);
    Atb = Atb_UV(FT,kdata,V,csm,N,true);
    Reg = @(x) reshape(reshape(x,[N*N,nbasis])*SBasis,[N*N*nbasis,1]);
    AtA = @(x) AtA_UV(FT,x,V,csm,N,nSamplesPerFrame) + Reg(x);
else
    FT= NUFFT(ktraj/N,1,0,0,[N,N]);
    Atb = Atb_UV(FT,kdata,V,csm,N,false);
    Reg = @(x) reshape(reshape(x,[N*N,nbasis])*SBasis,[N*N*nbasis,1]);
    AtA = @(x) AtA_UV(FT,x,V,csm,nSamplesPerFrame)+Reg(x);
end

x = pcg(AtA,Atb(:),1e-5,nIterations);
x = reshape(x,[N,N,nbasis]);

end

