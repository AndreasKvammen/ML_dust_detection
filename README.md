## Machine learning detection of dust impact signals observed by the Solar Orbiter
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7404457.svg)](https://doi.org/10.5281/zenodo.7404457)

This repository contains the code and data to reproduce some of the main results from the paper "Machine learning detection of dust impact signals observed by the Solar Orbiter", freely accessible at https://angeo.copernicus.org/articles/41/69/2023/angeo-41-69-2023.html

<img src="https://angeo.copernicus.org/articles/41/69/2023/angeo-41-69-2023-f09.png" width="300" height="300">
 
### Article Abstract
This article present results from automatic detection of dust impact signals observed by the Solar Orbiter - Radio and Plasma Waves instrument. 

A sharp and characteristic electric field signal is observed by the Radio and Plasma Waves instrument when a dust particle impact the spacecraft at high velocity. In this way, ~5-20 dust impacts are daily detected as the Solar Orbiter travels through the interstellar medium. The dust distribution in the inner solar system is largely uncharted and statistical studies of the detected dust impacts will enhance our understanding of the role of dust in the solar system. 

It is however challenging to automatically detect and separate dust signals from the plural of other signal shapes for two main reasons. Firstly, since the spacecraft charging causes variable shapes of the impact signals and secondly because electromagnetic waves (such as solitary waves) may induce resembling electric field signals.

In this article, we propose a novel machine learning-based framework for detection of dust impacts. We consider two different supervised machine learning approaches: the support vector machine classifier and the convolutional neural network classifier. Furthermore, we compare the performance of the machine learning classifiers to the currently used on-board classification algorithm and analyze one and a half year of Radio and Plasma Waves instrument data.

Overall, we conclude that classification of dust impact signals is a suitable task for supervised machine learning techniques. In particular, the convolutional neural network achieves a 96% $\pm$ 1% overall classification accuracy and 94\% $\pm$ 2\% dust detection precision, a significant improvement to the currently used on-board classifier with 85\% overall classification accuracy and 75\% dust detection precision. In addition, both the support vector machine and the convolutional neural network detects more dust particles (on average) than the on-board classification algorithm, with 14\% $\pm$ 1\% and 16\% $\pm$ 7\% detection enhancement respectively.

The proposed convolutional neural network classifier (or similar tools) should therefore be considered for post-processing of the electric field signals observed by the Solar Orbiter.  

## Installation 
The scripts and functions in this repository can be used on you local machine by downloading a clone of this repository using: git clone https://github.com/AndreasKvammen/ML_dust_detection.git

This recuires: 
 - GitHub (for cloning the repository)
 - Python, Jupyter and Tensorflow working together on you local machine (for Convolutional Neural Network (CNN) Classification)
 - MatLab (for Support Vector Machine (SVM) Classification, CNN Classification Triggered Snapshot WaveForm (TSWF) data and Dust impact rates), including the additional function subplot_tight that can be downloaded at: https://www.mathworks.com/matlabcentral/fileexchange/30884-controllable-tight-subplot

## Training and Testing Data
The folder "Data train and test" contain the training and testing data in .csv format:
  1. Test_data.csv - is the testing data with dimension (600 x 12288), 600 observations consisting of 12288 (3x4096) measurements - 4096 time steps observed at 3 antennas. 
  2. Test_labels.csv - is the binary testing labels with dimension (600x1) where the values (1 = dust) and (0 = no dust)
  3. Train_data.csv - is the training data with dimension (2400x12288), 2400 observations consisting of 12288 (3x4096) measurements - 4096 time steps observed at 3 antennas. 
  4. Train_labels.csv - is the binary training labels with dimension (2400x1) where the values (1 = dust) and (0 = no dust)

## Support Vector Machine (SVM) Classification
The folder "SVM train and test" contain the MatLab code to train and test the Support Vector Machine (SVM) classifier. The folder contain the following files:
  1. extract_SVM_features.m - is the MatLab code to extract the 2D feature vector from the training and testing data.
  2. SVM_dust_detection.m - is the MatLab script to run the training and testing of the SVM, based on the extracted feature vectors. 
  3. SVM_dust_detection.pdf - presents the MatLab code and resulting plots in pdf format 

The SVM achieved a 94\%± 1\% average class-wise accuracy and a 90\%± 3\% precision, trained and tested over 10 runs with randomly selected training and testing data sets. 

## Convolutional Neural Network (CNN) Classification
The folder "CNN train and test" contain the data and JupyterLab (Tensorflow) code to train and test the Convolutional Neural Network (CNN) classifier, proposed for time series classification in Wang et al. (2017). The folder contain the following files:
  1. CNN_dust_detection.ipynb - Jupyter Notebook that import the training and testing data and runs the training and testing of the CNN classifier. 
  2. run_GitHub.h5 - is the trained model in .h5 format 
  3. model_run_GitHub - is a folder containing the trained model in .pb format 

The CNN achieved a 96\%± 1\% overall classification accuracy and a 94\%± 2\% precision, trained and tested over 10 runs with randomly selected training and testing data sets.

## CNN Classification Triggered Snapshot WaveForm (TSWF) data 
The folder "CDF file classification" contain the trained CNN classifier and the MatLab code to classify the Triggered Snapshot WaveForm (TSWF) data product (.cdf files). A sample script and the needed functions are included in order to classify a sample (.cdf) file "solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf". The folder contain the following files: 
  1. model_run_GitHub - is a folder containing the trained model in .pb format
  2. solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf - is a sample file containing all triggered waveforms from October 4th, 2021, downloaded from https://rpw.lesia.obspm.fr/roc/data/pub/solo/rpw/data/L2/tds_wf_e/
  2. cdf_CNN_classifier.m - is a MatLab script that automatically classifies the triggered waveforms, contained in file "solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf", and plots the classifycation results using the trained CNN classifier in folder "model_run_GitHub" 
  3. classify_file.m - is a MatLab function that classifies a .cdf file 
  4. preprocess_cdf.m - is a MatLab function that import the .cdf file and pre-process it for classification
  5. preprocess_signal.m - is a MatLab function that performs the 4-step pre-processing procedure 
  6. cdf_CNN_classifier.pdf - presents the MatLab code and resulting plots in pdf format

## Dust Impact Rates 
The folder "Dust impact rates" contain the MatLab script and files to reproduce the daily dust impact rates (Figure 11 from the article)
  1. dust_impact_rates.m - is a MatLab script to read the daily dust count (classified by the TDS, SVM and CNN approach) and convert it to impact rates using the RPW-TDS duty cycle. The script plots the daily impact rates along with the associated fit using the dust flux
model from Zaslavsky et al. (2021) with an included offset
  2. TDS_ddc.txt - is a table containing the date and the daily dust count using the TDS approach
  3. SVM_ddc.txt - is a table containing the date, the median of the daily dust count (using the SVM approach) and the standard deviation of the daily dust count (calculated using 10 different training/testing data splits)
  4. CNN_ddc.txt - is a table containing the date, the median of the daily dust count (using the CNN approach) and the standard deviation of the daily dust count (calculated using 10 different training/testing data splits)
  5. fits.csv - is a table containing the date, the RPW-TDS duty cycle and the TDS/SVM/CNN fit to data using the dust flux model from Zaslavsky et al. (2021) with an included offset
  6. dust_impact_rates.pdf - presents the MatLab code and resulting plots in pdf format

## References
Wang, Z., Yan,W., and Oates, T.: Time series classification from scratch with deep neural networks: A strong baseline, in: 2017 International
joint conference on neural networks (IJCNN), pp. 1578–1585, IEEE, 2017.

Zaslavsky, A., Mann, I., Soucek, J., Czechowski, A., Píša, D., Vaverka, J., Meyer-Vernet, N., Maksimovic, M., Lorfèvre, E., Issautier, K., et al.: First dust measurements with the Solar Orbiter Radio and Plasma Wave instrument, Astronomy & Astrophysics, 656, A30, 2021.
