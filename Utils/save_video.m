function save_video (fname, data, TR, narms)

outputVideo = VideoWriter(fname,'Grayscale AVI');
outputVideo.FrameRate = 1/(narms*TR);
open(outputVideo);

abs_im = abs(data);
% imt = (1/1.75);
% abs_im(abs_im>imt) =imt;
abs_im = abs_im./max(abs_im(:));

for ii = 1:size(data,3)
   writeVideo(outputVideo,imadjust(abs_im(:,:,ii)));
end

close(outputVideo);

end