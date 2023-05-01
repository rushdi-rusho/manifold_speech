## Prospectively accelerated dynamic speech MRI at 3 Tesla using a self-navigated spiral based manifold regularized scheme
### The framework of proposed manifold speech MRI
 
We propose to recover speech images using manifold regularization

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF3.png" width=60% height=40%>

Fig. 1: : Dynamic images can be modeled as points on a smooth nonlinear manifold embedded in a high dimensional ambient space. Similar images are neigbors on this smooth manifold even if they occur distant in time. Dissimilar images will not be neighbors on this manifold

The graph Laplacian matrix from the manifold captures this neighborhood relationship:

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF4.png" width=60% height=60%>

Fig. 2: Illustration of the graph Laplacian matrix for the speaking task of repeating the phrase “loo-lee-la-za-na-za”. (a) graph Laplacian matrix. (b) representative row (row # 74) of this matrix, where entries that are greater than 10% of the maximum (or minimum) value of that row are highlighted in red color, and superimposed on the remaining entries in blue color. Frame 74 has a raised tongue posture and all the similar frames is detected by red peaks. Similarly, (c) shows a representative row (row # 268) of this matrix, which corresponds to the 268th frame depicting a lowered tongue posture. These relationships are leveraged during reconstruction. 


### Output of speech MR reconstruction


<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/Fig1_reterospective_phantom.png" width=60% height=60%>
Fig. 3: Comparison of various algorithms on the retrospectively under-sampled data at different undersampling factors corresponding to using 2,3, and 4 spiral arms/frame, where the subject was counting numbers indefinitely. The top row show the ground truth fully sampled data. The mean square error (MSE) between the reconstruction and the ground truth were calculated in the yellow marked region of interest containing the moving vocal tract airway. Note, the low-rank reconstruction show pronounced unresolved aliasing in the 3 and 2 arms/frame setting. The view-sharing, XD-sort algorithms demonstrate substantial temporal blurring. TFD show classic temporal stair casing motion artifacts. In contrast, the proposed manifold regularized reconstruction provides improved spatial and temporal fidelity.
   
<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/slice2_loleelazanza_sub2.png" width=55% height=55%>
Fig. 4: Qualitative comparison of various algorithms on the prospectively under-sampled data at undersampling factor of 3 spiral arms/frame where the subject was repeating the phrase “loo-lee-la-za-na-za”. Shown here is reconstuction of slice 2 of three-slice acquisition at 52.2 ms temporal resolution. The vertical yellow lines depicts the timing of the various consonant and vowel sounds. The proposed manifold regularized scheme showed improved reconstruction quality with better motion fidelity, as seen by sharper image time profiles.

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/Dataset6-NormalCount-sub2.gif">
Fig. 5: Reconstruction of first 300 frames (out of 900) of the speech task of fluently counting numbers by subject 2 (played in loop, temporal resolution: 17.4 ms, single-sagittal slice orientation). First row: Low rank, Second row: View share, Third row: XD-sort (extra dimension based) Fourth row: Temporal finite difference, Fifth row: Manifold (proposed) reconstruction.

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/Dataset3-looleelazanaza-sub1.gif">
Fig. 6: Similar to Fig. 5, a three-slice reconstruction of the speech task of uttering repeated phrase "loo-lee-la-za-na-za" by subject 2 (played in loop,temporal resolution: 52.2 ms). First row: Low rank, Second row: View share, Third row: XD-sort (extra dimension based) Fourth row: Temporal finite difference, Fifth row: Manifold (proposed) reconstruction.

### Dataset
An open source speech MR dataset is publishied: https://doi.org/10.6084/m9.figshare.20816914.v2

### File description
`manifold_speech_main.m` : This is the main file to run the manifold speech reconstruction.  
 
### How to run the code

Ensure that gpuNUFFT is properly installed in your machine. After that, specify the parametes and data path in the `manifold_speech_main.m` file and run it accordingly. Feel free to play with the reconstruction parameters e.g. number of arms fer frame, number of frames to keep,number of smallest basis etc.

This code is based on the  spiral-STORM open source code developed first by A. H. Ahmed and colleagues ( https://github.com/ahaseebahmed/SpiralSToRM ). Code by A.H. Ahmed is included in this repository to be self contained. In addition, it depends on the gpuNUFFT library (https://github.com/andyschwarzl/gpuNUFFT). If users use this code, we would appreciate citing the below two references:

[1] R.Z. Rusho et al, "Rapid dynamic speech imaging at 3 Tesla using combination of a custom vocal tract coil, variable density spirals and manifold regularization" (submitted to MRM)

[2] A.H. Ahmed et al "Free-Breathing and Ungated Dynamic MRI Using Navigator-Less spiral SToRM," IEEE Trans. Med. Imaging, 2020 doi: 10.1109/tmi.2020.3008329

###### Contact
The code is meant for reproducible research. In case of any difficulty, please open an issue or directly email me at rushdizahid-rusho@uiowa.edu


