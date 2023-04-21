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
|--------|-----|----------|------------|---------------------|---------------|----------------|-----|-----|-------------|-----------------|-------------------|-----|-----|-----|--------|--------|---------|---------|
| 1      | 80  | 120      | 80         | 112                 | 169           | 67           | 61  | 94  | 14.5       | 1             | 1.0               | 29  | 19  | 39  | 0      | 0      | 1       |
| 1      | 30  | 136      | 83         | 96                  | 243          | 100          | 58  | 165 | 15.6       | 1             | 0.9               | 20  | 37  | 34  | 0      | 0      | 0       |
| 1      | 40  | 138      | 86         | 92                  | 163          | 215          | 37  | 98  | 16.4       | 1             | 0.7               | 25  | 32  | 73  | 0      | 0      | 1       |
| 1      | 35  | 160      | 100        | 100                 | 248          | 175          | 53  | 160 | 15.3       | 1             | 0.7               | 30  | 55  | 50  | 0      | 0      | 0       |
| 1      | 35  | 125      | 80         | 117                 | 213          | 113          | 58  | 132 | 14.7       | 1             | 1.1               | 35  | 58  | 56  | 0      | 0      | 0       |
| 1      | 40  | 122      | 75         | 89                  | 175          | 50           | 54  | 111 | 15.3       | 1             | 0.9               | 27  | 24  | 32  | 0      | 0      | 0       |

