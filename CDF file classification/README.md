The folder "CDF file classification" contain the trained CNN classifier and the MatLab code to classify the Triggered Snapshot WaveForm (TSWF) data product (.cdf files). A sample script and the needed functions are included in order to classify a sample (.cdf) file "solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf". The folder contain the following files: 
  1. model_run_GitHub - is a folder containing the trained model in .pb format
  2. solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf - is a sample file containing all triggered waveforms from October 4th, 2021, downloaded from https://rpw.lesia.obspm.fr/roc/data/pub/solo/rpw/data/L2/tds_wf_e/
  2. cdf_CNN_classifier.m - is a MatLab script that automatically classifies the triggered waveforms, contained in file "solo_L2_rpw-tds-surv-tswf-e_20211004_V01.cdf", and plots the classifycation results using the trained CNN classifier in folder "model_run_GitHub" 
  3. classify_file.m - is a MatLab function that classifies a .cdf file 
  4. preprocess_cdf.m - is a MatLab function that import the .cdf file and pre-process it for classification
  5. preprocess_signal.m - is a MatLab function that performs the 4-step pre-processing procedure 
  6. cdf_CNN_classifier.pdf - presents the MatLab code and resulting plots in pdf format
