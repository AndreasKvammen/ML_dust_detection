The folder "Dust_impact_rates" contains the MatLab script and files to reproduce the daily dust impact rates (Figure 11 from the article)
  1. dust_impact_rates.m - is a MatLab script to read the daily dust count (classified by the TDS, SVM and CNN approach) and convert it to impact rates using the RPW-TDS duty cycle. The script plots the daily impact rates along with the associated fit using the dust flux
model from Zaslavsky et al. (2021) with an included offset
  2. TDS_ddc.txt - is a table containing the date and the daily dust count using the TDS approach
  3. SVM_ddc.txt - is a table containing the date, the median of the daily dust count (using the SVM approach) and the standard deviation of the daily dust count (calculated using 10 different training/testing data splits)
  4. CNN_ddc.txt - is a table containing the date, the median of the daily dust count (using the CNN approach) and the standard deviation of the daily dust count (calculated using 10 different training/testing data splits)
  5. fits.csv - is a table containing the date, the RPW-TDS duty cycle and the TDS/SVM/CNN fit to data using the dust flux model from Zaslavsky et al. (2021) with an included offset
  6. dust_impact_rates.pdf - presents the MatLab code and resulting plots in pdf format
