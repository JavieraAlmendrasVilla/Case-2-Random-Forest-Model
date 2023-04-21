library(randomForest)
library(tidyverse) 
library(lubridate)
library(data.table)
library(magrittr)
library(tidyr)
library(plotROC)

x_train <-  fread("extdata\\x_train.csv")
y_train <-  fread("extdata\\y_train.csv")
x_test <- fread("extdata\\x_test.csv")
y_test <-  fread("extdata\\y_test.csv")

# Training data

#### Check for NA

sum(is.na(x_train))
head(x_train)

# Change columns names

colnames(x_train)[4] <- 'height_cm'
colnames(x_train)[5] <- 'weight_kg'
colnames(x_train)[6] <- 'waist_cm'
colnames(x_train)[7] <- 'eyesight_left'
colnames(x_train)[8] <- 'eyesight_right'
colnames(x_train)[9] <- 'hearing_left'
colnames(x_train)[10] <- 'hearing_right'
colnames(x_train)[13] <- 'fasting_blood_sugar'
colnames(x_train)[19] <- 'urine_protein'
colnames(x_train)[20] <- 'serum_creatinine'
colnames(x_train)[25] <- 'caries'


#### Change labels
x_train <- x_train %>% mutate(
  gender = factor(gender, labels = c('M'= 0, 'F' = 1)),
  tartar = factor(tartar, labels = c('N' = 0,'Y'= 1)))
head(x_train)

# Select a subset of columns
x_train <- subset(x_train, select = -c(height_cm, weight_kg, waist_cm, eyesight_left, eyesight_right, hearing_left, hearing_right, oral))
head(x_train)



#### Change from factor to numeric
x_train <- as.data.frame(apply(x_train, 2, as.numeric))
sapply(x_train, class) # Corroborate
head(x_train)


### Output (Y)
y_train <- as.data.frame(apply(y_train, 2, as.numeric))
sapply(y_train, class)


#############################################################################################
## Test data

### Inputs (X)

#### Check for NA

sum(is.na(x_test))

# Change column names

colnames(x_test)[4] <- 'height_cm'
colnames(x_test)[5] <- 'weight_kg'
colnames(x_test)[6] <- 'waist_cm'
colnames(x_test)[7] <- 'eyesight_left'
colnames(x_test)[8] <- 'eyesight_right'
colnames(x_test)[9] <- 'hearing_left'
colnames(x_test)[10] <- 'hearing_right'
colnames(x_test)[13] <- 'fasting_blood_sugar'
colnames(x_test)[19] <- 'urine_protein'
colnames(x_test)[20] <- 'serum_creatinine'
colnames(x_test)[25] <- 'caries'


#### Change labels
x_test <- x_test %>% mutate(
  gender = factor(gender, labels = c('M'= 0, 'F' = 1)),
  tartar = factor(tartar, labels = c('N' = 0,'Y'= 1)))

#### Select a subset of columns

x_test <- subset(x_test, select = -c(height_cm, weight_kg, waist_cm, eyesight_left, eyesight_right, hearing_left, hearing_right, oral))
head(x_test)


#### Change from factor to numeric
x_test <- as.data.frame(apply(x_test, 2, as.numeric))
sapply(x_train, class) # Corroborate
head(x_test)


### Output (Y)
y_test <- as.data.frame(apply(y_test, 2, as.numeric))
sapply(y_test, class)


# Merge X and Y and remove column ID

smoking_test <- merge(x_test, y_test, by = 'ID')
smoking_test <- subset(smoking_test, select = -ID)

smoking_train <- merge(x_train, y_train, by ='ID')
smoking_train <- subset(smoking_train, select = -c(ID))


# Preparing for random forest

smoking_train_dt <- as.data.table(smoking_train)
smoking_train_dt[,Smoking := as.factor(smoking)][,smoking := NULL]
smoking_train_dt[,dataset := "train"]
head(smoking_train_dt)


smoking_test_dt <- as.data.table(smoking_test)
smoking_test_dt[,Smoking := as.factor(smoking)]
smoking_test_dt[,dataset := "test"][,smoking := NULL]
head(smoking_test_dt)

# Random forest

# Columns I will use for the prediction

feature_vars <- colnames(smoking_train_dt[,-c("Smoking")])

# Formula definition
full_formula <- as.formula(paste(c("Smoking ~ ",
                                   paste(feature_vars, collapse = " + ")),
                                 collapse = ""))

# Model on training data


rf_train <- randomForest(## Define formula and data
  full_formula,
  data= smoking_train_dt,
  
  ## Hyper parameters
  ntree= 500,     # Define number of trees
  nodesize = 5,  # Minimum size of leaf nodes
  maxnodes = 50, # Maximum number of leaf nodes
  mtry = 17, # Number of feature variables as candidates for each split
  sampsize=length(smoking_train_dt$dataset),
)

rf_train

#Add predicted values to the table

smoking_train_dt[, preds_rf := predict(rf_train, type="prob",
                                  ## Predict on all data
                                  newdata=smoking_train_dt)[,2]]

# Plot ROC curves for each model

ggroc <- ggplot(smoking_train_dt, aes(d=as.numeric(Smoking), m=preds_rf, color = dataset)) +
  geom_roc() +
  geom_abline()
ggroc 
calc_auc(ggroc)

# Accuracy = 74.74693%

accuracy_train <- (21144 + 12158) / (21144 + 12158 + 4194 + 7057)
accuracy_train*100

# test data 

rf_test <-  randomForest(## Define formula and data
  full_formula,
  data= smoking_test_dt,
  ## Hyper parameters
  ntree= 500,     # Define number of trees
  nodesize = 5,  # Minimum size of leaf nodes
  maxnodes = 50, # Maximum number of leaf nodes
  mtry = 17, # Number of feature variables as candidates for each split
  sampsize=length(smoking_test_dt$dataset),
)

rf_test


smoking_test_dt[, preds_rf := predict(rf_test, type="prob",
                                       ## Predict on all data
                                       newdata=smoking_test_dt)[,2]]

ggroc <- ggplot(smoking_test_dt, aes(d=as.numeric(Smoking), m=preds_rf, color = dataset)) +
  geom_roc() +
  geom_abline()
ggroc 
calc_auc(ggroc)

# Accuracy = 75.01571%

accuracy_test <- (5329 + 3027)/(5329 + 3027 + 1707 + 1076)
accuracy_test*100

# Both

smoking_dt <- rbindlist(list(smoking_train_dt, smoking_test_dt))

ggroc <- ggplot(smoking_dt, aes(d=as.numeric(Smoking), m=preds_rf, color= dataset )) +
  geom_roc() +
  geom_abline()
ggroc 
calc_auc(ggroc)

