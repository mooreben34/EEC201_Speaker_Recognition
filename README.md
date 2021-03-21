# EEC201_Speaker_Recognition
## Team TwoB or not TooB

<p align="center">
  <img width="800" height="300" src="https://i.pinimg.com/originals/1b/e1/b8/1be1b8df06dd6c392696589402cf26af.jpg">
</p>

## Instructions to run project##
To run our project, download the file **final_project_run_this.zip** and run the **TwoB_or_NotTooB.m** script. Make sure to add the training folder to the path.

## Abstract
Our project implements a speaker recognition system through text-based MFCC feature extraction. For speaker classification, we utilized the LBG algorithm, which is an extension of K-Means clustering that iteratively generates clusters starting from a single centroid. For each speaker, this involves the following process: 

1.Preprocessing the data in order to better extract the formants, or key features, of the speaker's voiced signal. 
2.Generating MFC coefficients for all training and test speaker
-generating training and test codebooks through the LBG algorithm
-performing accuracy testing through matching training and testing codebooks in multiple testing environmnets.

## Background
Our overall objective is to build a system that can identify a speaker’s voice given training information about that speaker. Our system is text-based - that is, speakers are trained through specific codewords, or short training phrases. This process is complicated by the fact that our speech signals contain extraneous information outside of the formant's of each speaker's voice, which can interfere with the process of training and classification.

In order to understand what hindering information to remove from our signal (preprocessing), we must first understand the composition of the human voice from a signal processing standpoint.

### The Human Voice
<p align="center">
  <img width="300" height="300" src="https://user-images.githubusercontent.com/55825582/111892986-f576e980-89bc-11eb-9ce8-ba3a821ec428.png">
</p>
<p align="center">
  The shown labels identify all components that contribute to the production of speech
</p>

The formant's of a speaker's voice are most affected by the frequency response of each speaker’s vocal tract. The other components involved in speech are difficult to identify, and can obscure the information obtained in the vocal tract We can simplify this process through viewing speech through two components: a glottal pulse and a voiced signal.

In fact, the voice can be modelled as a convolution of the glottal pulse and the voiced signal that each speaker produces. Because convolution in time domain is equivalent to multiplication in frequency domain, we can use a logarithm can separate these two components, which will be used to later extract features. However, since this is not a perfect model we still want to remove as much of the non-voiced signal as possible before separating the voiced and glottal signals through preprocessing.

<p align="center">
  <img width="300" height="100" src= "https://user-images.githubusercontent.com/55825582/111893573-e4c87280-89c0-11eb-9499-55e3d35986fd.png">
</p>
<p align="center">
  Breakdown of the voice convolution model.
</p>

## Preprocessing

### Windowing
All of our preprocessing techniques take advantage of windowing, which divides our time-domain speech signal into parallel batches, or frames. The most popular window for windowing is the hamming window, which creates a narrower “impulse” in frequency domain for frequency selective analysis when compared to just rectangular truncation. Before windowing, we normalize the signal so that it has a maximum amplitude of 1.

### Silence Removal (Method 1: Amplitude Threshold)
After framing our signal, we can begin to remove both silence and unvoiced components from the signal, which tend to be much lower in amplitude than the voiced components.
We do this by analyzing the maximum value in every frame; if it is less than our threshold of .03, then we simply remove the frame through matrix indexing.
This method is very effective in removing the initial silence that we might observe when a speaker has delayed speech.

### Silence Removal (Method2: ZCR)
Further silence removal can be achieved by removing frames based on their Zero Crossing Rate, or ZCR. ZCR is defined as the rate at which a signal crosses zero or a selected amplitude threshold. In general, non-voiced signals are lower in amplitude and exhibit noise-like characteristics; in other words, the ZCR will be much higher for non-voiced signals than voiced-signals, which oscillate at a lower frequency. ZCR is effective in removing silence and unvoiced signals within the speech itself.

![image](https://user-images.githubusercontent.com/55825582/111896276-a4bfba80-89d5-11eb-82ff-3f4b39272fb2.png)

## Feature Extraction

### The Mel Scale
Human hearing does not operate on a linear frequency scale; although they are not used for speaker recognition, pitches are the easiest way to visual this. The musical note A4 corresponds to a frequency of 440 Hz, A5 corresponds to 880 Hz, and A6 corresponds to 1760. This means that in order to increase a note by one octave, or 12 semitones, we must double it's frequency across the entire scale. Such a scale can be modelled logarithmiclly.

<p align="center">
  <img width = "400" height = "200" src= "https://dt7v1i9vyp3mf.cloudfront.net/styles/news_large/s3/imagelibrary/E/Ear_06-mCzyLXNvnCn26ZWLVvGj5qmO7bkUM6LO.jpg">
</p>


Although not operating on the same scale as pitches, the Mel Scale is another was to convert the frequency scale to be linearly perceptual - that is, to make equal distances on the scale contain the same perceptual distances in terms of frequency. We define the Mel scale through the following relationship:

<p align="center">
  <img width = "500" height = "100" src= "https://miro.medium.com/max/1440/1*64Wucrt-BeUH9ZVyOHyi2A.jpeg">
</p>

<p align="center">
  <img width = "500" height = "200" src= "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Mel-Hz_plot.svg/450px-Mel-Hz_plot.svg.png">
</p>

### The Mel Spectrogram
The Mel Scale is the basis of Mel Filter Banks, which are filters that are used for extracting features from the human voice. When a speaker's voice is represented his or her individual spectrogram, this spectrogram can be made further unique to the individual by converting its amplitude to a logarithmic scale and converting its frequency to mels. We call the resulting matrix the Mel Spectrogram. 

<p align="center">
  <img width = "500" height = "200" src= "https://user-images.githubusercontent.com/55825582/111896462-ffa5e180-89d6-11eb-8d0f-e0021d45b715.png">
</p>

### Designing the Mel Filter Bank
The Mel Filter Bank can be viewed as a sequence of overlapping triangular filters that linearly connect to their next bands, or Mel bands. Although this looks linear for lower frequencies and logarithmic for higher frequencies, the peaks of these filters are completely linearly spaced on the Mel Scale. In this way, we can emphasize and place equal weight on the main features of the spectrogram, increasing its usability for featuer extraction. Specifically, we can further manipulate this Mel Spectrogram to extract each individual's MFCC coefficients, which are the key components of the human voice neccesary for speaker identification.

The Mel filter bank can be composed of any number of Mel bands. However, we typically expect the most useful number of Mel Bands to lie in the range of 40-120. In order to form the Mel Spectrogram, we simply multiply the speaker's spectrogram by the designed Mel Filter Bank.

### Extracting MFCCs
Mel Frequency Cepstral Coefficients (MFCCs) are the basis of automatic speaker recognition (ASR) based on clustering techniques. The Cepstrum, although originally developed for studying echoes in seismic signals, is the audio feature of choice for speach identification. It is also useful in fields such as music genre classification and isntrument isolation.

The Cepstrum of a signal is defined by the Inverse Fourier Transform of the logarithm of the logarithm of its phase unwrapped spectrum. In order to clearly separate this domain from its Spectrum (since it is really the spectrum of a spectrum) we use the following terms in place of their signal processing equivalents:
- Cepstrum now defines spectrum
- Quefrency now describes frequency
- Liftering describes Filtering
- Harmonics describe Rhamonics

### Why Use MFCCs?
MFFCs accurately represent the formant's, or primary voiced timbres, of a speaker's voice. Speech can be modelled as the convolution of the speaker's vocal tract frequency response with the glottal pulse. The glottal pulse contains very little information in terms of speaker identification, so we ideally would like to completely remove the glottal pulse before attempting to form unique codebooks for each speaker during the learning phase of automatic speaker recognition.

The process of MFCC feature extraction is effective at emulating this process. Taking the logarithm of the Mel Spectrogram allows for the convolution os the speaker's vocal tract and glotal pulse, (or its multiplication if frequency domain) to be written as a summation in the two pulses in teh freqeuncy domain. The resulting DFT of the logarithm of the Mel Spectrogram can represent the speaker's vocal tract frequency response accurately, which allows for extraction of the features that strongly correlate to each individual. In fact, speakers can be classified uniquely only utilizing a fraction of the length of the complete MFC coefficient set; usually only 12-13 MFCC coefficients are needed for accurate speaker identification. After this, clustering can be performed in order to form codebooks for each speaker.

## Feature Matching: K-Means clustering and the LBG algorithm
The next step after feature extraction is feature matching. Using vector quantization (VQ), we can derive the centers of data, or centroids, that the Speaker's MFCCs are closest to. In other words, by measuring the distortion, or the total distance from all matched speaker data to to the defined code words, we can come up with a "clustering" of the data defined by the positions of these centroids. 

In normal K-Means clustering, we start and finish with a predefined number of centroids, that will iteratevly change position based on distortion measurements between the speaker's training set. However, in this project, we implement K-means iteratively through the LBG algorithm.

In the LBG algorithm, we start with 1 centroid poisitioned at the mean of all speaker data across all MFCCs, and then split the centroid iteratively until a minimum distortion is met or the number of maximum splits has been defined.

## K-Means Clustering vs LBG Clustering
**K-Means Clustering:** First, we choose K arbitrary clusters to represent the feature space X, which can be a random assignment or based off of a mean distance average to all points. We then classify points by assigning them to their closest centroids. Aftrer this, we correct the locations of the centroids by re-mapping the centroids at the mean Euclidian center of the data points now classified as being members of these clusters. We then compute the mean distances from the points to their new cluster centers: if the terminating threshold is met, we abort the process. If not we, repeat the process starting from the from the reclassification of points.

**LBG Algorithm:** The LBG algorithm is an iterative approach to K-Means clustering. We start with a single centroid that is positioned at the mean of all points in the feature set. We then split this centroid into two centroids, by shifting them by a defined distance (we used 0.01). We then ru the K-means algorithm with the two starting clusters.
If the termination conditions of the K-means algorithm are not met, we repeat from the centroid splitting process (the second iteration will have 4 centroids).
Termination can now also occur if the maximum desired number of splits have been reached. We chose to stop at 16 clusters since accuracy gains were not seen above this threshold.

## Comparing the training codebook with the testing codewords
After the completion of the LBG algorithm, we have a codebook that contains every speaker’s testing data. In order to now identify each speaker, we simply take the difference of the testing data’s codebook with each training set’s codebook section that corresponds to each individual speaker. The smallest difference is the resulting match! If the distance is above a certain threshold (for us 0.5), this means that the tested speaker does not exist in the training codebook.

## Sumarry of Results:
The following tables show a summary of our results, including testing with our own voices added to the testing and training set. This test also tested for 3 speakers not present in the codebook (speakers 9, 10, and 11), to make sure that we did not have false positives.

**Test #1: Provided Test Speakers and Training Data**
| Test ID | Matched Speaker ID | Deviation |
| --- | --- | --- |
| s1_test | s1 | .257 |
| s2_test | s2 | .158 |
| s3_test | s3 | .181 |
| s4_test | s4 | .145 |
| s5_test | s5 | .215 |
| s6_test | s6 | .153 |
| s7_test | s7 | .222 |
| s8_test | s1 | .205 |
Overall Accuracy of this test: 87.5% (7/8)

**Test #1: Provided Test Speakers, 3 False Positive Tests, and 3 New Training Speakers**
| Test ID | Matched Speaker ID | Deviation |
| --- | --- | --- |
| s1_test | s1 | .257 |
| s2_test | s2 | .158 |
| s3_test | s3 | .181 |
| s4_test | s4 | .145 |
| s5_test | s5 | .215 |
| s6_test | s6 | .153 |
| s7_test | s7 | .222 |
| s8_test | s1 | .205 |
| s9_test | 0 | .638 |
| s10_test | 0 | .693 |
| s11_test | 0 | .737 |
| s12_test | 12 | .293 |
| s13_test | 4 | .70 |
| s14_test | 14 | .133 |
Overall Accuracy of this Test: 86% (12/14)
Rejection of false positives: 100%

**Test #3: Performance Against Additive Noise**

**Test #4: Performance Against Notch Filters**

## Project Tasks

### Test 1:
We were able to distinguish voices based on differing speaking, rates and pitches, but it was difficult to distinguish speakers that spoke with the same cadance or general pitch.
| Team Member | Recognition Rate | 
| --- | --- |
| Ben | 3/8 |
| Christian | 4/8 |

### Test 2:
**Sampling rate = 12,500 Hz**. Ms of speech per 256 sample block: 256/12500 * 1000 = **20.48 ms**

### Tests 3 and 4: All steps visualized for MFCCs:
<p align="center">
  <img width="500" height="300" src= "https://user-images.githubusercontent.com/55825582/111895582-e0a45100-89d0-11eb-9f4f-4985e027e3bd.png">
</p>
<p align="center">
  Generated MFCCs for an individual Speaker.
</p>

### Test 5 and 6: Demonstration of MFCCs forming clusters and centroids forming:
<p align="center">
  <img width="500" height="300" src= "https://user-images.githubusercontent.com/55825582/111895609-18ab9400-89d1-11eb-86da-7a45a5254ccd.png">
</p>
<p align="center">
  Strong clustering can be seen from the dataset.
</p>

### Test 7, 8, and 9: Results
(See Results Section)

## Function Descriptions
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
| MFCC_own | MFCCs extracted from melfb_own. |
| MFCC_MATLAB | MFCCs extracted from MATLAB |

### Outputs:
| Output | Definition | 
| --- | --- |
| clusters | Codebook for specific speaker's MFCCs |

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

### 3. TwoB_or_NotTooB.m
### Function Definition: 
Main function for classification. Returns speaker identification

### Dependencies:
| Input | Definition | 
| --- | --- |
| melfb_own.m | Used to generate MFCC inputs |
| lbg | Used to generate codebooks |

#### Brief summary:
Includes both training and testing (work in progress; plan to separate).

## Preliminary Results - Screenshots
<a href="https://ibb.co/KynnNsq"><img src="https://i.ibb.co/s37751w/MFCC.png" alt="MFCC" border="0"></a>

**Plots from melfb_own**

<a href="https://ibb.co/QYftwMx"><img src="https://i.ibb.co/Yf3wshV/Clustering-Example.png" alt="Clustering-Example" border="0"></a>

**Example of clustering from MFCCs**

<a href="https://imgbb.com/"><img src="https://i.ibb.co/JctpcWT/Matching.png" alt="Matching" border="0"></a>


