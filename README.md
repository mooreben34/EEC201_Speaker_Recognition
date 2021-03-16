# EEC201_Speaker_Recognition
## Team TwoB or not TooB

![Alt Text](https://i.pinimg.com/originals/1b/e1/b8/1be1b8df06dd6c392696589402cf26af.jpg)

## Abstract
Our project implements a speaker recognition system through text-based MFCC feature extraction. For speaker training and testing, we utilized the LBG algorithm, which is an extension of K-Means clustering that iteratively generates codebooks starting from a single centroid. For each speaker, this involves:
- Performing the STFT on the chosen text (in our case, the word "zero")
- Deriving the Mel Spectrogram by convolving the PSD of the Spectrogram with the chosen Mel Filter Bank
- Generating the MFCC coefficients for training and testing by taking the DCT of the logarithm of the Mel Spectrogram
- Generating codebooks for the training data set through the LBG algorithm
- Matching codebooks of the test data set to the training data set in order to test correct speaker identification.

**Note: The final version of this report will go into much more detail about each of these listed processes, including:**
- Block diagram of the entire speaker recognition system
- Background on why MFCCs are an excellent choice for audio classification, and how they effectively seperate useful voice features from the glottal pulse
- Explanations for all parametric design choices (FFT Size, # Mel Bands, # MFCC coefficients, clustering offset)
- Complete breakdown of all MATLAB functions
- Thourough testing results, including accuracy measurements 

The final report will also include extensive testing for both accuracy and robustness against filters that are intended to make recongition more difficult.

## Preliminary Works - Brief Progress Description
Our group has completed the process of feature extraction, clustering, and the ability to match test speakers with their training data to a certain degree of accuracy.

## Preliminary Works - Function Descriptions
Our group has implemented the following functions through MATLAB:

### 1.  melfb_own.m
#### Function Definition:
Extract the MFCC coefficients needed for speaker classification

#### Inputs:
| Input | Definition | 
| --- | --- |
| audio_file | speaker for which MFCC coefficients will be generated |
| N |Frame Size for STFT (Typical are N=128, 256, 512) |
| p | Number of Mel Filter Banks |
| coefficeints | Number of MFCC coefficients |

#### Outputs:
| Output | Definition |
| --- | --- |
| MFCC_own | MFCCs generated by group implementation |
| MFCC_MATLAB | MFCCs generated by MATLAB built in function mfcc.m |

#### Dependencies:
| Dependency | Description | 
| --- | --- |
| melfb.m | Generates Mel Filter Banks (provided by Professor Ding) |

#### Brief summary:
Given the defined inputs, the program performs the following:
1.  Plots the signal in time domain (which is normalized through audioread())
2.  Finds the Mel Spectrogram by performing an STFT on the signal, calculating its Periodogram, multiplying it by the Mel Filter Bank, and performing Mel Frequency Wrapping
3.  Plots the Mel Spectrogram of the signal using our Method and MATLAB's melSpectrogram() function for verification
4.  Generates MFCCs by finding the DCT of the log Mel spectrogram, removing its mean, and truncating to the first 13 MFCC coefficients for faster clustering during VQ
5.  Plots the MFCCS using our method and MATLAB's mfcc() function for verification

The program includes all plots on a tiled plot, and its MFCC outputs can be used directly for K-means clustering by the LGB algorithm.

### 2. lbg.m
### Function Definition: 
Applys vector quantization to MFCCs using the LBG algorithm

### Inputs:
| Input | Definition | 
| --- | --- |
| MFCC | MFCCs extracted from melfb_own. |
| max_splits | Maximum number of centroid doubling before termination |
| max_iterations | Threshold for max interations |
| min_split_gain | Minimum performance increase before algorithm termination |

### Outputs:
| Input | Definition | 
| --- | --- |
| C | Codebook for specific speaker's MFCCs |

### Dependencies:
| Input | Definition | 
| --- | --- |
| melfb_own.m | Used to generate MFCC inputs |
| disteau | Used to calculate the euclidian distance between MFCCs and all centroids (provided by Professor Ding) |
| kmeans | Iteratively called by the LBG algorithm to perform K-Means clustering |

#### Brief summary:
Given the defined inputs, the program performs the following:
1.  Creates a starting centroid that is positioned at the mean distance between all MFCCs
2.  Splits the starting cluster by duplicating and adding a small offset to each duplicate
3.  Performs K-means clustering
4.  Repeats steps 2 and 3 until either the minimum gain is achieved by splitting or the maximum number of iterations is achieved.

The resulting output of this program is a codebook for the speaker.

**Note: Our current implementation includes our own LBG algorithm, but utilizes MATLAB's built-in kmeans() function for each iteration. This will be replaced with our own implementation of Kmeans for the Final Submission**
