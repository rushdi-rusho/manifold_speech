function [CSM_SOS] = sos_rzr(coilImages)


im_rss_lowres = sqrt(sum(abs(coilImages).^2,3));

for i = 1:size(coilImages,3)
CSM_SOS(:,:,i) = (coilImages(:,:,i))./(im_rss_lowres);
end
end