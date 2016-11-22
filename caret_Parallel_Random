### Parallel Processing

## 只要设置好多核就自动并行处理
library(doMC)
registerDoMC(cores = 5)
## All subsequent models are then run in parallel
model <- train(y ~ ., data = training, method = "rf")



### Random Hyperparameter Search
# tuning parameter时默认是grid search，当parameter太多时，可以用random search

library(mlbench)
data(Sonar)

library(caret)
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]
fitControl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 10,
                           classProbs = TRUE,
                           summaryFunction = twoClassSummary,
                           search = "random")
set.seed(825)
rda_fit <- train(Class ~ ., data = training, 
                 method = "rda",
                 metric = "ROC",
                 tuneLength = 30,
                 trControl = fitControl)
# plot
ggplot(rda_fit) + theme(legend.position = "top")

