## Rapid dynamic speech imaging at 3 Tesla using combination of a custom vocal tract coil, variable density spirals and manifold regularization

This code is based on the  spiral-STORM open source code developed first by A. H. Ahmed and colleagues ( https://github.com/ahaseebahmed/SpiralSToRM ). Code by A.H. Ahmed is included in this repository to be self contained. In addition, it depends on the gpuNUFFT library (https://github.com/andyschwarzl/gpuNUFFT). If users use this code, we would appreciate citing the below two references:

[1] R.Z. Rusho et al, "Rapid dynamic speech imaging at 3 Tesla using combination of a custom vocal tract coil, variable density spirals and manifold regularization" (submitted to MRM)

[2] A.H. Ahmed et al "Free-Breathing and Ungated Dynamic MRI Using Navigator-Less spiral SToRM," IEEE Trans. Med. Imaging, 2020 doi: 10.1109/tmi.2020.3008329

### The framework of proposed pseudo-3D dynamic speech MRI
<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/FF2.png" width=80% height=80%>
Fig. 1: The proposed pseudo-3D variational manifold speech MRI reconstrruct scheme.     
  
  
We propose to recover t
<img src="https://github.com/rushdi-rusho/manifold_speech/blob/main/images/Slice2ofFig8.png" width=60% height=60%>

### Main advantages of our method
 


 

### Output of speech MR reconstruction
We reconstructed two different speech tasks from two different speakers at 18 ms temporal resolution:  


### Dataset
An open source speech MR dataset is publishied:

### File description
`manifold_speech_main.m` : This is the main file to run the manifold speech reconstruction.  
 
### How to run the code

Ensure that gpuNUFFT is properly installed in your machine. After that, specify the parametes and data path in the `manifold_speech_main.m` file and run it accordingly. Feel free to play with the reconstruction parameters e.g. number of arms fer frame, number of frames to keep,number of smallest basis etc.

###### Contact
The code is meant for reproducible research. In case of any difficulty, please open an issue or directly email me at rushdizahid-rusho@uiowa.edu


