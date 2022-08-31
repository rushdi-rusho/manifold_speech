## Rapid dynamic speech imaging at 3 Tesla using combination of a custom vocal tract coil, variable density spirals and manifold regularization

This code is based on the  spiral-STORM open source code developed first by A. H. Ahmed and colleagues ( https://github.com/ahaseebahmed/SpiralSToRM ). Code by A.H. Ahmed is included in this repository to be self contained. In addition, it depends on the gpuNUFFT library (https://github.com/andyschwarzl/gpuNUFFT). If users use this code, we would appreciate citing the below two references:

[1] R.Z. Rusho et al, "Rapid dynamic speech imaging at 3 Tesla using combination of a custom vocal tract coil, variable density spirals and manifold regularization" (submitted to MRM)

[2] A.H. Ahmed et al "Free-Breathing and Ungated Dynamic MRI Using Navigator-Less spiral SToRM," IEEE Trans. Med. Imaging, 2020 doi: 10.1109/tmi.2020.3008329

### The framework of proposed manifold speech MRI
Variable Density Spirals (VDS)

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF2.png" width=30% height=60%>
Fig. 1: Specifications of the 13 arm UDS (left column) and the 27 arm VDS (right column) design. Top row shows FOV v/s normalized k-space radius. Middle row shows the generated sampling trajectories, where the UDS trajectories had a readout duration of 2.69 ms, and VDS trajectories had a readout duration of 1.3 ms. Manifold regularized reconstructions using 13 arms/frame and 27 arms/frame respectively for UDS and VDS schemes are shown in the bottom row.      
  
  
  
We propose to recover speech images using manifold regularization

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF3.png" width=60% height=40%>

Fig. 2: : Dynamic images can be modeled as points on a smooth nonlinear manifold embedded in a high dimensional ambient space. Similar images are neigbors on this smooth manifold even if they occur distant in time. Dissimilar images will not be neighbors on this manifold

The graph Laplacian matrix from the manifold captures this neighborhood relationship:

<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF4.png" width=60% height=60%>

Fig. 3: Illustration of the graph Laplacian matrix for the speaking task of repeating the phrase “loo-lee-la-za-na-za”. (a) graph Laplacian matrix. (b) representative row (row # 74) of this matrix, where entries that are greater than 10% of the maximum (or minimum) value of that row are highlighted in red color, and superimposed on the remaining entries in blue color. Frame 74 has a raised tongue posture and all the similar frames is detected by red peaks. Similarly, (c) shows a representative row (row # 268) of this matrix, which corresponds to the 268th frame depicting a lowered tongue posture. These relationships are leveraged during reconstruction. 


### Output of speech MR reconstruction
 
<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/Slice2ofFig8.png" width=60% height=60%>

### Dataset
An open source speech MR dataset is publishied:

### File description
`manifold_speech_main.m` : This is the main file to run the manifold speech reconstruction.  
 
### How to run the code

Ensure that gpuNUFFT is properly installed in your machine. After that, specify the parametes and data path in the `manifold_speech_main.m` file and run it accordingly. Feel free to play with the reconstruction parameters e.g. number of arms fer frame, number of frames to keep,number of smallest basis etc.

###### Contact
The code is meant for reproducible research. In case of any difficulty, please open an issue or directly email me at rushdizahid-rusho@uiowa.edu


