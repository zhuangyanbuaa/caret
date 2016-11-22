### Model Training and Tuning

## Basic Parameter Tuning
## Notes on Reproducibility
## Customizing the Tuning Process
## Pre-Processing Options
## Alternate Tuning Grids
## Plotting the Resampling Profile
## The trainControl Function
## Alternate Performance Metrics
## Choosing the Final Model
## Extracting Predictions and Class Probabilities
## Exploring and Comparing Resampling Distributions
## Within-Model
## Between-Models
## Fitting Models Without Parameter Tuning


## Basic Parameter Tuning
library(mlbench)
data(Sonar)

library(caret)
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

# trainControl函数，控制train函数的参数
fitControl <- trainControl(
    ## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10)

# 用train 函数调参选最优模型
# 对gbm算法tuning
set.seed(825)
gbmFit1 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE)

# 列出train函数所有的method
names(getModelInfo())


# 只tuning默认的parameter，并非所有的parameter
# 用expand.grid来tuning指定的parameter(列名必须和tuning的参数名一致)
# 各个模型的可用parameter可以在此查询
# http://topepo.github.io/caret/train-models-by-tag.html#Accepts_Case_Weights
gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (1:30)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
set.seed(825)
gbmFit2 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 ## Now specify the exact models 
                 ## to evaluate:
                 tuneGrid = gbmGrid)


# Plotting the Resampling Profile
# 对tuning结果进行可视化
trellis.par.set(caretTheme())
plot(gbmFit2)  
# 改变metric
plot(gbmFit2, metric = "Kappa")

# 也可以用ggplot
ggplot(gbmFit2)

# 用?plot.train可以查看更多模型可视化options
# 观察tuning的图时，可能想要增加tuning的combination，此时不用全部重新跑一遍，只要更新train的model就可以
update.train


# The trainControl Function
# method: "boot", "cv", "LOOCV", "LGOCV", "repeatedcv", "timeslice", "none" and "oob"(only for bagged models)
# number: K-fold的K
# repeats: 几次CV
# verboseIter: 是否输出training log


# Alternate Performance Metrics
# 默认是计算RMSE和R2(regression)/accuracy和Kappa(classification)
# parameter经由RMSE(regression)和accuracy(classification)
# 当分类问题中某个类别只有很少的percentage时，可以指定train函数的metric = "kappa"
# 另外，当使用其他的metirc时，可以使用trainControl的summaryFunction
# twoClassSummary：ROC curve(metric: ROC)
# prSummary： precision and recall(metric: AUC)
fitControl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 10,
                           ## Estimate class probabilities
                           classProbs = TRUE,
                           ## Evaluate performance using 
                           ## the following function
                           summaryFunction = twoClassSummary)

set.seed(825)
gbmFit3 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 tuneGrid = gbmGrid,
                 ## Specify which metric to optimize
                 metric = "ROC")


## 修改trainControl函数的selectionFunction选项，可以修改选取模型的标准(best, oneSE, tolerance)
whichTwoPct <- tolerance(gbmFit3$results, metric = "ROC", 
                         tol = 2, maximize = TRUE)  
# oneSE: Breiman提出的one standard error rule，
# 对于tree-based models，可以利用resampling来估计standard error
# 最好的模型是同best model差one standard error的模型中最简单的那个
# 可以防止overfit


## Extracting Predictions and Class Probabilities
predict(gbmFit3, newdata = head(testing))
predict(gbmFit3, newdata = head(testing), type = "prob")


## Exploring and Comparing Resampling Distributions
# 比较不同模型
set.seed(825)
svmFit <- train(Class ~ ., data = training, 
                method = "svmRadial", 
                trControl = fitControl, 
                preProc = c("center", "scale"),
                tuneLength = 8,
                metric = "ROC")
svmFit
set.seed(825)
rdaFit <- train(Class ~ ., data = training, 
                method = "rda", 
                trControl = fitControl, 
                tuneLength = 4,
                metric = "ROC")
rdaFit
resamps <- resamples(list(GBM = gbmFit3,
                          SVM = svmFit,
                          RDA = rdaFit))
resamps
summary(resamps)

# plot
trellis.par.set(theme1)
bwplot(resamps, layout = c(3, 1))

# 只画ROC
trellis.par.set(caretTheme())
dotplot(resamps, metric = "ROC")

trellis.par.set(theme1)
xyplot(resamps, what = "BlandAltman")

splom(resamps)

# 用t检验来计算不同模型所得metric的差是否显著
difValues <- diff(resamps)
summary(difValues)

trellis.par.set(theme1)
bwplot(difValues, layout = c(3, 1))

# 只画ROC
trellis.par.set(caretTheme())
dotplot(difValues)


## Fitting Models Without Parameter Tuning
fitControl <- trainControl(method = "none", classProbs = TRUE)
set.seed(825)
gbmFit4 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 ## Only a single model can be passed to the
                 ## function when no resampling is used:
                 tuneGrid = data.frame(interaction.depth = 4,
                                       n.trees = 100,
                                       shrinkage = .1,
                                       n.minobsinnode = 20),
                 metric = "ROC")







