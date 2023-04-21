# Case 2: Random Forest Model: Prediction of smoking based on the body signals

*data:* [Smoking-data](https://github.com/JavieraAlmendrasVilla/Case-1-Body-effects-of-smoking/blob/main/smoking.R)<br>
*source:* [Goverment of South Korea](https://www.kaggle.com/datasets/kukuroo3/body-signal-of-smoking)<br>
*code:* [Random Forest Model](https://github.com/JavieraAlmendrasVilla/Case-2-Random-Forest-Model/blob/main/rf%20smoking.R)

**Description:** The entire dataset contains health data with a total of 55692 observations and 27 variables. For this project, I specifically investigated the variables relevant to predct smoking.<br>

*ID:* index
*age*: 5-years gap<br>
*gender*: femenine / masculine<br>
*caries*: dental caries<br>
*tartar*: tartar status<br>
*smoking*: smoking status<br>
*systolic:* Blood pressure<br>
*relaxation:* Blood pressure<br>
*fasting blood sugar*<br>
*Cholesterol:* total<br>
*triglyceride*<br>
*HDL:* cholesterol type<br>
*LDL:* cholesterol type<br>
*hemoglobin*<br>
*Urine protein*<br>
*serum creatinine*<br>
*AST:* glutamic oxaloacetic transaminase type<br>
*ALT:* glutamic oxaloacetic transaminase type<br>
*Gtp:* γ-GTP<br>

**Skills:** Data cleansing, data visualization, descriptive statistics, Machine Learning, Random Forest Ensemble Method, method evaluation. <br>
**Technology:** R programming language using tidyr, magrittr, data.table, tidyverse, and lubridate packages for data manipulation, randomForest package to build the model, and ggroc package for visualization and evaluation.<br>
**Results:** The model predicts smoking with ~ 71% accuracy in the training and testing data. <br>
**Analysis:**<br>

| gender | age | systolic | relaxation | fasting_blood_sugar | Cholesterol | triglyceride | HDL | LDL | hemoglobin | urine_protein | serum_creatinine | AST | ALT | Gtp | caries | tartar | Smoking |
|--------|-----|----------|------------|---------------------|---------------|----------------|-----|-----|-------------|-----------------|-------------------|-----|-----|-----|--------|--------|---------|
| 1      | 80  | 120      | 80         | 112                 | 169           | 67           | 61  | 94  | 14.5       | 1             | 1.0               | 29  | 19  | 39  | 0      | 0      | 1       |
| 1      | 30  | 136      | 83         | 96                  | 243          | 100          | 58  | 165 | 15.6       | 1             | 0.9               | 20  | 37  | 34  | 0      | 0      | 0       |
| 1      | 40  | 138      | 86         | 92                  | 163          | 215          | 37  | 98  | 16.4       | 1             | 0.7               | 25  | 32  | 73  | 0      | 0      | 1       |
| 1      | 35  | 160      | 100        | 100                 | 248          | 175          | 53  | 160 | 15.3       | 1             | 0.7               | 30  | 55  | 50  | 0      | 0      | 0       |
| 1      | 35  | 125      | 80         | 117                 | 213          | 113          | 58  | 132 | 14.7       | 1             | 1.1               | 35  | 58  | 56  | 0      | 0      | 0       |
| 1      | 40  | 122      | 75         | 89                  | 175          | 50           | 54  | 111 | 15.3       | 1             | 0.9               | 27  | 24  | 32  | 0      | 0      | 0       |


### Random Forest Model

```r
# Random forest

# Variables relevant for the prediction

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
  nodesize = 5,   # Minimum size of leaf nodes
  maxnodes = 50,  # Maximum number of leaf nodes
  mtry = 17,      # Number of feature variables as candidates for each split
  sampsize=length(smoking_train_dt$dataset),
)

rf_train

#Add predicted values to the table

smoking_train_dt[, preds_rf := predict(rf_train, type="prob",
                                  ## Predict on all data
                                  newdata=smoking_train_dt)[,2]]
```
Results of the Training Model
```r
Call:
 randomForest(formula = full_formula, data = smoking_train_dt,      ntree = 500, nodesize = 5, maxnodes = 50, mtry = 17, sampsize = length(smoking_train_dt$dataset),      ) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 17

        OOB estimate of  error rate: 25.35%
Confusion matrix:
      0     1 class.error
0 21176  7025   0.2491046
1  4269 12083   0.2610690
```

Results of the Testing Model

```r
Call:
 randomForest(formula = full_formula, data = smoking_test_dt,      ntree = 500, nodesize = 5, maxnodes = 50, mtry = 17, sampsize = length(smoking_test_dt$dataset),      ) 
               Type of random forest: classification
                     Number of trees: 500
No. of variables tried at each split: 17

        OOB estimate of  error rate: 24.87%
Confusion matrix:
     0    1 class.error
0 5319 1717   0.2440307
1 1053 3050   0.2566415
```

## Evaluation

### Accuracy

```r
# Accuracy of the training model = 74.74693%

accuracy_train <- (21144 + 12158) / (21144 + 12158 + 4194 + 7057)
accuracy_train*100


# Accuracy of the testing model = 75.01571%

accuracy_test <- (5329 + 3027)/(5329 + 3027 + 1707 + 1076)
accuracy_test*100

```

### ROC Curve

```r
ggroc <- ggplot(smoking_dt, aes(d=as.numeric(Smoking), m=preds_rf, color= dataset )) +
  geom_roc() +
  geom_abline()
ggroc 
calc_auc(ggroc)

# Area Under the Curve (AUC) 
PANEL group dataset       AUC
1     1     1    test 0.8638996
2     1     2   train 0.8399098

```

![ROC Curve](https://github.com/JavieraAlmendrasVilla/Case-2-Random-Forest-Model/blob/main/ROC%20curve.jpeg)
