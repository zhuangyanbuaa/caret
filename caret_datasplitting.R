### Data Splitting

## Simple Splitting Based on the Outcome
## Splitting Based on the Predictors
## Data Splitting for Time Series

## Simple Splitting Based on the Outcome
# createDataPartition 
# 将数据分为训练，测试两部分
# 可以设置是否输出list以及重采样的次数
library(caret)
set.seed(3456)
trainIndex <- createDataPartition(iris$Species, p = .8, 
                                  list = FALSE, 
                                  times = 1)
# createResample: bootstrap samples
# createFolds: cross–validation groupings
# createMultiFolds: 多次的CV

## Splitting Based on the Predictors
# maxDissim: 首先选取一个sub-sample，基于与这个sub-sample的Dissimilarity最大，从samplePool中取一个sample
library(mlbench)
data(BostonHousing)

testing <- scale(BostonHousing[, c("age", "nox")])
set.seed(5)
## A random sample of 5 data points
startSet <- sample(1:dim(testing)[1], 5)
samplePool <- testing[-startSet,]
start <- testing[startSet,]
newSamp <- maxDissim(start, samplePool, n = 50)


## Data Splitting for Time Series
# createTimeSlices





