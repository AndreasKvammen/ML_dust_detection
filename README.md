# Machine Learning Detection of Dust Impact Signals Observed by The Solar Orbiter
This repository contains the code and data to reproduce some of the main results from the paper "Machine Learning Detection of Dust Impact Signals Observed by The Solar Orbiter", freely accessible at https://www.annales.com/

### Abstract
This article present results from automatic detection of dust impact signals observed by the Solar Orbiter - Radio and Plasma Waves instrument. 

A sharp and characteristic electric field signal is observed by the Radio and Plasma Waves instrument when a dust particle impact the spacecraft at high velocity. In this way, ~5-20 dust impacts are daily detected as the Solar Orbiter travels through the interstellar medium. The dust distribution in the inner solar system is largely uncharted and statistical studies of the detected dust impacts will enhance our understanding of the role of dust in the solar system. 

It is however challenging to automatically detect and separate dust signals from the plural of other signal shapes for two main reasons. Firstly, since the spacecraft charging causes variable shapes of the impact signals and secondly because electromagnetic waves (such as solitary waves) may induce resembling electric field signals.

In this article, we propose a novel machine learning-based framework for detection of dust impacts. We consider two different supervised machine learning approaches: the support vector machine classifier and the convolutional neural network classifier. Furthermore, we compare the performance of the machine learning classifiers to the currently used on-board classification algorithm and analyze one and a half year of Radio and Plasma Waves instrument data.

Overall, we conclude that classification of dust impact signals is a suitable task for supervised machine learning techniques. In particular, the convolutional neural network achieves a 96% $\pm$ 1% overall classification accuracy and 94\% $\pm$ 2\% dust detection precision, a significant improvement to the currently used on-board classifier with 85\% overall classification accuracy and 75\% dust detection precision. In addition, both the support vector machine and the convolutional neural network detects more dust particles (on average) than the on-board classification algorithm, with 14\% $\pm$ 1\% and 16\% $\pm$ 7\% detection enhancement respectively.

The proposed convolutional neural network classifier (or similar tools) should therefore be considered for post-processing of the electric field signals observed by the Solar Orbiter.  

## Support Vector Machine (SVM) 

## Convolutional Neural Network (CNN)

## Solar Orbiter Data Classification Using the CNN 
