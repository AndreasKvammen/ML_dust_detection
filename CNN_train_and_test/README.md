The folder "CNN_train_and_test" contains the JupyterLab (Tensorflow) code to train and test the Convolutional Neural Network (CNN) classifier, proposed for time series classification in Wang et al. (2017). The folder contain the following files:
  1. CNN_dust_detection.ipynb - Jupyter Notebook that import the training and testing data and runs the training and testing of the CNN classifier. 
  2. run_GitHub.h5 - is the trained model in .h5 format 
  3. model_run_GitHub - is a folder containing the trained model in .pb format 

The CNN achieved a 96\%± 1\% overall classification accuracy and a 94\%± 2\% precision, trained and tested over 10 runs with randomly selected training and testing data sets.
