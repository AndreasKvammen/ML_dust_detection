# Machine Learning Detection of Dust Impact Signals Observed by The Solar Orbiter
This repository contains the code and data to reproduce some of the main results from the paper "Machine Learning Detection of Dust Impact Signals Observed by The Solar Orbiter", freely accessible at https://www.annales.com/

### Article Abstract
This article present results from automatic detection of dust impact signals observed by the Solar Orbiter - Radio and Plasma Waves instrument. 

A sharp and characteristic electric field signal is observed by the Radio and Plasma Waves instrument when a dust particle impact the spacecraft at high velocity. In this way, ~5-20 dust impacts are daily detected as the Solar Orbiter travels through the interstellar medium. The dust distribution in the inner solar system is largely uncharted and statistical studies of the detected dust impacts will enhance our understanding of the role of dust in the solar system. 

It is however challenging to automatically detect and separate dust signals from the plural of other signal shapes for two main reasons. Firstly, since the spacecraft charging causes variable shapes of the impact signals and secondly because electromagnetic waves (such as solitary waves) may induce resembling electric field signals.

In this article, we propose a novel machine learning-based framework for detection of dust impacts. We consider two different supervised machine learning approaches: the support vector machine classifier and the convolutional neural network classifier. Furthermore, we compare the performance of the machine learning classifiers to the currently used on-board classification algorithm and analyze one and a half year of Radio and Plasma Waves instrument data.

Overall, we conclude that classification of dust impact signals is a suitable task for supervised machine learning techniques. In particular, the convolutional neural network achieves a 96% $\pm$ 1% overall classification accuracy and 94\% $\pm$ 2\% dust detection precision, a significant improvement to the currently used on-board classifier with 85\% overall classification accuracy and 75\% dust detection precision. In addition, both the support vector machine and the convolutional neural network detects more dust particles (on average) than the on-board classification algorithm, with 14\% $\pm$ 1\% and 16\% $\pm$ 7\% detection enhancement respectively.

The proposed convolutional neural network classifier (or similar tools) should therefore be considered for post-processing of the electric field signals observed by the Solar Orbiter.  

## Training and Testing Data
The folder "Data train and test" contain the training and testing data in .csv format.  

## Support Vector Machine (SVM) Classification
The folder "SVM train and test" contain the MatLab code to train and test the Support Vector Machine (SVM) classifier. The folder contain the following files:
  1. extract_SVM_features.m - is the MatLab code to extact the 2D feature vector from the training and testing data.
  2. SVM_dust_detection.m - is the MatLab script to run the training and testing of the SVM, based on the extracted feature vectors. 
  3. SVM_dust_detection.pdf - presents the MatLab code and resulting plots in pdf format 

The SVM acheived a 94\%± 1\% average class-wise accuracy and a 90\%± 3\% percision, trained and tested over 10 runs with randomly selected training and testing data sets. 

## Convolutional Neural Network (CNN) Classification
The folder "CNN train and test" contain the data and JupyterLab (Tensorflow) code to train and test the Convolutional Neural Network (CNN) classifier, proposed for time series classification in Wang et al. (2017). The folder contain the following files:
  1. CNN_dust_detection.ipynb - Jupyter Notebook that import the training and testing data and runs the training and testing of the CNN classifier. 
  2. run_GitHub.h5 - is the trained model in .h5 format 
  3. model_run_GitHub - is a folder containing the trained model in .pb format 

The CNN acheived a 96\%± 1\% overall classification accuracy and a 94\%± 2\% percision, trained and tested over 10 runs with randomly selected training and testing data sets.

## CNN Classification Triggered Snapshot WaveForm (TSWF) data 
The folder "SVM train and test" contain the MatLab code to

## Dust Impact Rates 
