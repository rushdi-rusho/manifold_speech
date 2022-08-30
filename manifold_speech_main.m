clear all
close all
clc
addpath('./csm');
addpath('./Utils');
addpath('./nufft_toolbox_cpu');
addpath(genpath('./gpuNUFFT-master/gpuNUFFT'));
addpath('./SpeechDataset'); % please specify data path (expected: kdata: )
DR=pwd;
%% ==============================================================
% % Load the data
% % ============================================================== 
SpiralData=load('/SpeechMRI.mat');
slice =2; 

kdata=SpiralData.kdata;

kdata=squeeze(kdata(:,:,:,slice));
%  kdata= kdata./max(abs(kdata(:)));
%  [nr,nsprl,~]=size(kdata)
 
k=SpiralData.kloc;
dcf=SpiralData.w;
plot(dcf)
pause(1.5)
close all
clear SpiralData nr nsprl;
%% Reconstruction parameters
spiralsToDelete=0;
%numFramesToKeep = 500;
useGPU = 1;
SHRINK_FACTOR = 1.0;
nBasis = 30;
lambdaSmoothness = 0.02;
NsamplesToKeep=60; % number of central q% k-space readout points 
delta=[0.05];
lam=[0.1];
%eig_csm=0.008;
%% ==============================================================
% Compute coil compresession and Compute the coil sensitivity map
% ============================================================== 
PCA = 8;
N=160;
ninterleavesPerFrame = 3
kdatacoilselect = [1:10 14:16]; % coil selection
[coilImages, csm, kdataPCA] = coil_turncatePCA(kdata,k,dcf,N,PCA,kdatacoilselect,ninterleavesPerFrame);
figure(1)
for i=1:PCA; subplot(2,ceil(PCA/2),i); imagesc((abs(coilImages(:,:,i)))); title(i); axis square; end
colormap default;
%%
kdata=permute(kdataPCA,[1,3,2]); % nreadoutxcoilxspiral   
kdata=kdata./max(abs(kdata(:)));
%kdata = 1.4790e3*kdata./max(abs(kdata(:)));
[nFreqEncoding,nCh,numberSpirals]=size(kdata);
nChannelsToChoose=nCh;
cRatioI=1:nChannelsToChoose;
%% =========================================
% -------------Preprocessing Data-------------%
%===========================================
[nFreqEncoding,nCh,numberSpirals]=size(kdata); %  nreadoutxcoilxspiral
numFrames=floor((numberSpirals-spiralsToDelete)/ninterleavesPerFrame);  
numFramesToKeep = numFrames;
kdata=kdata(:,cRatioI(1:nChannelsToChoose),spiralsToDelete+1:numberSpirals);
k = k(:,spiralsToDelete+1:numberSpirals);
dcf = dcf(:,spiralsToDelete+1:numberSpirals);
kdata=kdata(:,:,1:numFrames*ninterleavesPerFrame);
k=k(:,1:numFrames*ninterleavesPerFrame);
dcf = dcf(:,1:numFrames*ninterleavesPerFrame);

kdata = permute(kdata,[1,3,2]); % nreadoutxspiralxcoil
kdata = reshape(kdata,[nFreqEncoding,ninterleavesPerFrame,numFrames,nChannelsToChoose]); 
ktraj=k;clear k;
ktraj = reshape(ktraj,[nFreqEncoding,ninterleavesPerFrame,numFrames]); 
dcf=repmat(dcf(:,1), [1 ninterleavesPerFrame numFrames]);


% Keeping only numFramesToKeep

kdata = kdata(:,:,1:numFramesToKeep,cRatioI(1:nChannelsToChoose));
ktraj = ktraj(:,:,1:numFramesToKeep);
w = repmat(dcf(:,1), [1 ninterleavesPerFrame numFramesToKeep]); 
kdata=reshape(kdata,[nFreqEncoding,ninterleavesPerFrame,numFramesToKeep,nChannelsToChoose]);
%save data kdata ktraj dcf
%% ==============================================================
% Scaling trajectory
% ==============================================================
ktraj_scaled =  SHRINK_FACTOR*ktraj*N;%/(2*max(abs(ktraj(:))));%clear ktraj;
ktraj_scaled=reshape(ktraj_scaled,[nFreqEncoding,ninterleavesPerFrame,numFramesToKeep]);
%% ==============================================================
% % Compute the weight matrix
% % ============================================================= 
kdata_com = reshape(kdata(1:NsamplesToKeep,:,:,:),[NsamplesToKeep,ninterleavesPerFrame,numFramesToKeep,nChannelsToChoose]);
ktraj_com = reshape(ktraj_scaled(1:NsamplesToKeep,:,:,:),[NsamplesToKeep,ninterleavesPerFrame,numFramesToKeep]);
w_l=repmat(w(1:NsamplesToKeep,1,1), [1 ninterleavesPerFrame,1]);

N1 = (2*ceil(max(abs(ktraj_com(:)))));
csm_lowRes = giveEspiritMapsSmall(coilImages,N1,N1);
figure(2) 
imagesc(abs(reshape(csm_lowRes,[N1,N1*nChannelsToChoose])));colorbar; title('Low res Coil sensitivity maps (magnitude) by Espirit method');
ktraj_com = reshape(ktraj_com,[size(ktraj_com,1),size(ktraj_com,2),numFramesToKeep]);
kdata_com = reshape(kdata_com, [size(kdata_com,1),size(ktraj_com,2),numFramesToKeep,nChannelsToChoose]);

FT_LR= NUFFT(ktraj_com/N1,w_l,0,0,[N1,N1]);

tic;lowResRecons = l2Recont(kdata_com,FT_LR,csm_lowRes,0.05,N1,w_l);toc
lowResRecons=reshape(lowResRecons,[N1*N1,numFramesToKeep]);
[~,~,L]=estimateLapKernelLR(lowResRecons,delta,lam);
[ tmp, L] = iterative_est_laplacian(L,FT_LR,kdata_com,csm_lowRes, N1,delta, lam);

%% ==============================================================
% % Final Reconstruction
% % ============================================================= 
narms=ninterleavesPerFrame;

fnL = sprintf('slice%s_%sArms%sPts%sIter%sLlam%sLSig_PCA%s_Oct29_manifoldSpeech_slices_N%s',num2str(slice),num2str(narms),num2str(NsamplesToKeep),num2str(10),num2str(lam),num2str(delta),num2str(PCA),num2str(N));

cd(DR)
saved_results = sprintf('Manifold_Speech_PCA%s_%sSToRM_L',num2str(PCA),num2str(N));
% saving L-matrix
mkdir( saved_results )
save(['./' saved_results '/' fnL '_LAPLACIAN.mat'],'L');

% SVD of L-matrix
[Utemp,Sbasis,V]=svd(L);
V=V(:,end-nBasis+1:end);
Sbasis=Sbasis(end-nBasis+1:end,end-nBasis+1:end);


ktraj_scaled=reshape(ktraj_scaled,[nFreqEncoding*ninterleavesPerFrame,numFramesToKeep]);
kdata=reshape(kdata,[nFreqEncoding*ninterleavesPerFrame,numFramesToKeep,nChannelsToChoose]);

fprintf('Entering final Recon \n');
tic; x = solveUV(ktraj_scaled,kdata,csm, V, N, 60,lambdaSmoothness*Sbasis,useGPU);toc
y = reshape(reshape(x,[N*N,nBasis])*V',[N,N,numFramesToKeep]);

% % ==============================================================
% % Save and Display results
% ============================================================= 
close all;
cut_hor=55; 
cut_vert=90;
tframe =2;
figure(1);
set(gcf,'color','w'); colormap gray
yy=y;yy(cut_hor,:,:)=1;
subplot(2,2,1); imagesc(imadjust(abs(squeeze(yy(:,:,tframe))))); colormap gray; axis off; axis image; title('SToRM recon horizontal cut');
clear yy
yy=y; yy(:,cut_vert,:)=1;
subplot(2,2,2); imagesc(imadjust(abs(squeeze(y(cut_hor,:,:))))); colormap gray; axis off; title('SToRM recon temporal profile (Horizonal cut)');
subplot(2,2,3); imagesc(imadjust(abs(squeeze(yy(:,:,tframe))))); colormap gray; axis off; axis image; title('SToRM recon vertical cut');
clear yy
subplot(2,2,4); imagesc(imadjust(abs(squeeze(y(:,cut_vert,:))))); colormap gray; axis off; title('SToRM recon temporal profile (Vertical cut)');

foldr = sprintf('Manifold_Speech_PCA%s_%sSToRM_RESULTS',num2str(PCA),num2str(N));
fn = sprintf('slice%s_%sArms%sPts%sIter%sLlam%sLSig%snBas%sLsmth_PCA%s_Manifold_Speech_N%s',num2str(slice),num2str(narms),num2str(NsamplesToKeep),num2str(10),num2str(lam),num2str(delta),num2str(nBasis),num2str(lambdaSmoothness),num2str(PCA),num2str(N));

mkdir( foldr )
cd(foldr);

narms=ninterleavesPerFrame;
cd(DR)

mkdir( foldr )
save (['./' foldr '/' fn '.mat'], 'y','x','-v7.3');

% TR= 3 * 5.8*1e-3;
TR = 5.8*1e-3;
save_video(['./' foldr '/' fn '.avi'], y, TR, narms);