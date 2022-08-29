  %% function to perform coil compression using pca
  % size of Kspace should be Readouts x rays x ch; the last dimension is
  % coils; 
  % no_comp is the number of principal components youd like after compression

function [compressed_data]= coil_compress_withpca(kSpace,no_comp)
data=double(squeeze(kSpace));
[nreadouts,ntotalrays,nch]=size(kSpace);
    data=reshape(data,[nreadouts*ntotalrays nch]);
    coeff =pca(data);
    compressed_data=data*coeff(:,1:no_comp);
    compressed_data=reshape(compressed_data,[nreadouts ntotalrays no_comp]);
    
    end