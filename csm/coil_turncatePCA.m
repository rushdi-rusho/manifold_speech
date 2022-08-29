function [coilImages, csm, kdataPCA] = coil_turncatePCA(kdata,kloc,w,N,PCA,kdatacoilselect,ninterleavesPerFrame)

kdatacoilturncate = kdata(:,:,kdatacoilselect);
nChannelsToChoose=PCA;
kdatacompress=coil_compress_withpca(kdatacoilturncate,nChannelsToChoose);
kdataPCA = kdatacompress;
[nr,nsprl,nch]=size(kdataPCA);
spiralsToDelete=0;
numFrames=floor((nsprl-spiralsToDelete)/ninterleavesPerFrame);  

kdataFramed=kdataPCA(:,spiralsToDelete+1:nsprl,:); %first 200 spiral gone, 16 channel select
klocF=kloc(:,spiralsToDelete+1:nsprl);
wF=w(:,spiralsToDelete+1:nsprl);

kdataFramed=kdataFramed(:,1:numFrames*ninterleavesPerFrame,:);
klocF=klocF(:,1:numFrames*ninterleavesPerFrame);
wF=wF(:,1:numFrames*ninterleavesPerFrame);

kdataFramed=reshape(kdataFramed, [nr,ninterleavesPerFrame,numFrames,nch]);
klocF = reshape(klocF, [nr,ninterleavesPerFrame,numFrames]);
wF =reshape(wF, [nr,ninterleavesPerFrame,numFrames]);
% Keeping only numFramesToKeep
numFramesToKeep=numFrames;
kdataFramed = kdataFramed(:,:,1:numFramesToKeep,:);
klocF = klocF(:,:,1:numFramesToKeep);
wF = wF(:,:,1:numFramesToKeep);
useGPU=1;
coilImages = coil_sens_map_NUFFT(kdataFramed,klocF*N,wF,N,useGPU);
%% CSM Walsh method
Smoothing=30;
csm=ismrm_estimate_csm_walsh(coilImages,Smoothing);
fprintf('%sx%s Coilimages and CSMs estimated \n',num2str(N),num2str(N));
end



