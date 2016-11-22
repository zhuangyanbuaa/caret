### Subsampling For Class Imbalances

## Subsampling Techniques
## Subsampling During Resampling
## Complications
## Using Custom Subsampling Techniques


## Subsampling Techniques
library(caret)
set.seed(2969)
imbal_train <- twoClassSim(10000, intercept = -20, linearVars = 20)
imbal_test  <- twoClassSim(10000, intercept = -20, linearVars = 20)
table(imbal_train$Class)

# downSample 和 upSample 就是简单采样使得两个类别平衡
# downSample
set.seed(9560)
down_train <- downSample(x = imbal_train[, -ncol(imbal_train)],
                         y = imbal_train$Class)
table(down_train$Class)
# upSample
set.seed(9560)
up_train <- upSample(x = imbal_train[, -ncol(imbal_train)],
                     y = imbal_train$Class)                         
table(up_train$Class)

# SMOTE是利用最近邻原则生成minority class;同时对majority class进行under-sampled
library(DMwR)
set.seed(9560)
smote_train <- SMOTE(Class ~ ., data  = imbal_train)                         
table(smote_train$Class)
# ROSE是利用smoothed-bootstrap(conditional kernel density estimate)生成minority class和majority class
library(ROSE)
set.seed(9560)
rose_train <- ROSE(Class ~ ., data  = imbal_train)$data                         
table(rose_train$Class)


## 重采样和CV的关系: 可以先在外层重采样，再CV;也可以先CV，在每次CV里重采样.

# 若在CV里重采样，可以用trainControl控制
# trainControl 的 sampling 可以选择"down", "up", "smote", or "rose"

ctrl <- trainControl(method = "repeatedcv", repeats = 5,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary,
                     ## new option here:
                     sampling = "down")
set.seed(5627)
down_inside <- train(Class ~ ., data = imbal_train,
                     method = "treebag",
                     nbagg = 50,
                     metric = "ROC",
                     trControl = ctrl)


# !!! 在CV里重采样效果更好
