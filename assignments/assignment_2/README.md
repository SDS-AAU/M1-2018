# Predicting Regions and the Nomad Score 

In the first assignment you were working with the city and trips data from Nomadlist, exploring city-characteristics, latent grouping and popularity of resulting clusters over time.

In this assignment you are going to work again with the city data, however now you will be exploring supervised learning to predict the Region (aka. continent given city-characteristics) and the Nomad Score.

- The first is a classification problem like in the wine-presentation in class (there are a number of descrete classes and you need to predict which one it is)
- The second is a regression problem where you will have to estimate a continuous value.

Data has been preprocessed for you and you don't have to worry about that. We also imputed missing values and handled outliers.

However, you will have to perform feature scaling (normalization, standardization).

**While the outputs are preserved, many parts of the starter code have been replaced with \*\*\*\* that you have to complete **

You tasks are (Aside from completing this notebook):

- Add min 2 further algorithms (2 for classification, 2 for regression)
- Can you increase the accuracy on the test-set (classification to aroung 90% and regression to R2 ~ 0.55)
- Explain what you observe and what that means. 
- Interpret the results. 
- You may add visualisations if you find it helpful.
