### Pre-Processing

## Creating Dummy Variables
library(earth)
data(etitanic)

# convert factor variables to dummy variables
# 将因子变量转为虚拟变量，需要用predict
# 没有截距，用不了lm
dummies <- dummyVars(survived ~ ., data = etitanic)
predict(dummies, newdata = etitanic)


## Zero- and Near Zero-Variance Predictors
# 当只有一个值或者highly unbalance(此时若进行CV或bootstrap，会产生zero-variance的情况)时，需要除去该变量

# nearZeroVar有两个指标
# 1, frequency ratio = 频数最多的值 / 频数第二多的值
# 2, percent of unique values = (unique值的个数 / 样本个数) * 100%
# nearZeroVar(x, freqCut = 95/5, uniqueCut = 10, saveMetrics = FALSE, names = FALSE, foreach = FALSE, allowParallel = TRUE)
# saveMetrics是TRUE，返回一个DataFrame
# freqCut是frequency ratio的阈值
# uniqueCut 是percent of unique values的阈值
# 返回结果的nzv列是判断是否nzv的结果

# 保存计算结果
data(mdrr)
nzv <- nearZeroVar(mdrrDescr, saveMetrics= TRUE)
nzv[nzv$nzv,][1:10,]

# apply the function
# 不保存计算结果
nzv <- nearZeroVar(mdrrDescr)
filteredDescr <- mdrrDescr[, -nzv]


## Identifying Correlated Predictors
# findCorrelation function
# 除去某个阈值以上的成对的列后，得到相关系数均较小的data
highlyCorDescr <- findCorrelation(descrCor, cutoff = .75)
descrCor2 <- cor(filteredDescr[,-highlyCorDescr])
summary(descrCor2[upper.tri(descrCor2)])


## Linear Dependencies
# findLinearCombos 函数用QR分解来列举所有的线性组合
ltfrDesign <- matrix(0, nrow=6, ncol=6)
ltfrDesign[,1] <- c(1, 1, 1, 1, 1, 1)
ltfrDesign[,2] <- c(1, 1, 1, 0, 0, 0)
ltfrDesign[,3] <- c(0, 0, 0, 1, 1, 1)
ltfrDesign[,4] <- c(1, 0, 0, 1, 0, 0)
ltfrDesign[,5] <- c(0, 1, 0, 0, 1, 0)
ltfrDesign[,6] <- c(0, 0, 1, 0, 0, 1)
comboInfo <- findLinearCombos(ltfrDesign)
comboInfo
# 得到去除线性组合之后的data
ltfrDesign[, -comboInfo$remove]



# preProcess Function
# 前处理的综合函数
set.seed(96)
inTrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2)
training <- filteredDescr[inTrain,]
test <- filteredDescr[-inTrain,]
trainMDRR <- mdrrClass[inTrain]
testMDRR <- mdrrClass[-inTrain]
# 首先对训练数据前处理，得到list的对象
preProcValues <- preProcess(training, method = c("center", "scale"))
# 分别对训练数据和test数据运用处理结果
trainTransformed <- predict(preProcValues, training)
testTransformed <- predict(preProcValues, test)
# center: 减去mean
# scale: 除以sd
# ranges： 将data转为0到1


# Imputation
# 可以根据训练数据插值
# knnImpute
# bagImpute               bagged tress，比KNN好，但是耗资源
# medianImpute


## Transforming Predictors
# preProcess函数有很多种method
# "BoxCox"      对大于0的data做Box-Cox变换
# "YeoJohnson"
# "expoTrans"
# "center"
# "scale"
# "range"     将data限定在0~1之间
# "knnImpute"
# "bagImpute"
# "medianImpute"
# "pca"         利用PCA对变量进行处理，会强制对变量scaling(自动将列名变为PC1, PC2)
# "ica"         利用ICA(independent component analysis， 独立因子分析)进行处理
# "spatialSign"
# "zv"               将只有一个值的变量除去，nzv的简化版
# "nzv"               和nearZeroVar一样
# "conditionalX"             和checkConditionalX一样

library(AppliedPredictiveModeling)
transparentTheme(trans = .4)

# example of spatialSign transformation
plotSubset <- data.frame(scale(mdrrDescr[, c("nC", "X4v")])) 
xyplot(nC ~ X4v,
       data = plotSubset,
       groups = mdrrClass, 
       auto.key = list(columns = 2))  

transformed <- spatialSign(plotSubset)
transformed <- as.data.frame(transformed)
xyplot(nC ~ X4v, 
       data = transformed, 
       groups = mdrrClass, 
       auto.key = list(columns = 2)) 

# example of BoxCox transformation
preProcValues2 <- preProcess(training, method = "BoxCox")
trainBC <- predict(preProcValues2, training)
testBC <- predict(preProcValues2, test)


## 3.10 Class Distance Calculations
# 生成基于距离的新变量(马氏距离等)
# classDist function




