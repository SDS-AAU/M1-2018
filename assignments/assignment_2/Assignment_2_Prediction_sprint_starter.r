############################################################################
# Preamble
############################################################################

### set working directory
# This will set your working rirectory to the place where the scipt is. Note: Only relevant for 
# r-script files ()endlng with .r). R-Notebooks ()ending with .rmd) by default take 
setwd("folder1/foler2/final_folder") # Change that. Copy&Past your directory path, for example ""


### Cleaning the workspace, meaning deleting all previously loaded data (optimal step)
rm(list=ls())

### Loading packages
library(tidyverse) # loads the whole tidyverse, including dplyr, readr, ggplot, etc
library(data.table) # loads the data.table package, in case you use the fread() 
library(caret) # for classification and regression
library(skimr) # for nice summary descriptives

set.seed(1337)

############################################################################
# Load data
############################################################################

### Loading the data (we will now load the Data directly from the web)
# If you want you can still use the usual way, downloading the data first manually
cities_url = 'https://github.com/SDS-AAU/M1-2018/raw/master/assignments/assignment_2/cities_predict.csv'

data <- fread(cities_url, data.table = F) %>% as_data_frame()
rm(cities_url)

############################################################################
# data inspection
############################################################################

# Checking the variables
glimpse(data)

# Exploring the data (a bit)
skim(data)

# factorize
data <- data %>%
  mutate(country = make.names(country) %>% as.factor(),
         region = make.names(region) %>% as.factor()) %>%
  select(-place_slug)
# Note: makenames to get rid of the spaces in the countries / regions.. could cause problems otherwise

############################################################################
############################################################################
# data preprocessing for classification
############################################################################
############################################################################

# Split in training and test
index <- createDataPartition(y = data %>% pull(region), p = 0.8, list = FALSE)
training <- data[index,] %>% select(-country)
test <- data[-index,] %>% select(-country)

# Do the preprocessing recipe
library(recipes)
reci <- recipe(region ~ ., data = training) %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  prep(data = training)

# Split in x/y & train/test
x_train <- bake(reci, newdata = training) %>% select(-region)
x_test  <- bake(reci, newdata = test) %>% select(-region)
y_train <- training %>% pull(region) 
y_test  <- test %>% pull(region) 

# Remove what we dont need anymore
rm(index, reci)

############################################################################
# Predicting the region ( classification)
############################################################################

### Define carets traincontrol object
ctrl.class <- trainControl(method = "cv", 
                           number = 5, # Number of CV's
                           classProbs = TRUE, # Include probability of class prediction
                           summaryFunction = multiClassSummary) # Which type of summary statistics to deliver


### Predict (multinomial logit)
fit.multinom <- train(x = x_train, 
                   y = y_train, 
                   trControl = ctrl.class, 
                   method = "multinom",
                   tuneLength = 5) 
fit.multinom
ggplot(fit.multinom)

### Prediction & Confusion matrix
pred.multinom <- predict(fit.multinom, newdata = x_test)

table(y_test, pred.multinom)
confusionMatrix(y_test, pred.multinom)


############################################################################
############################################################################
# data preprocessing for regression
############################################################################
############################################################################

# Split in training and test
index <- createDataPartition(y = data %>% pull(nomad_score), p = 0.8, list = FALSE)
training <- data[index,] 
test <- data[-index,] 

# Do the preprocessing recipe
library(recipes)
reci <- recipe(nomad_score ~ ., data = training) %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_zv(all_predictors(), -all_outcomes()) %>%
  prep(data = training)

# Split in x/y & train/test
x_train <- reci %>% bake(newdata = training) %>% select(-nomad_score)
x_test  <- reci %>% bake(newdata = test) %>% select(-nomad_score)
y_train <- training %>% pull(nomad_score)  
y_test  <- test %>% pull(nomad_score) 

# Remove what we dont need anymore
rm(index, reci)

############################################################################
# Predicting the nomad score(regression)
############################################################################

### Define carets traincontrol object
ctrl.reg<- trainControl(method = "cv", 
                        number = 5) 

### Predict (linear model lm)
fit.lm <- train(x = x_train, 
                y = y_train, 
                trControl = ctrl.reg, 
                method = "glm",
                family = "gaussian") 
fit.lm

# RMSE LM
pred.lm <- predict(fit.lm, newdata = x_test)
sqrt(mean( (y_test - pred.lm ) ^ 2)) # Ignore the warning...

