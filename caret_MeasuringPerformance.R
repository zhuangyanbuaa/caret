### Measuring Performance

## Measures for Regression
## Measures for Predicted Classes
## Measures for Class Probabilities
## Lift Curves
## Calibration Curves

## Measures for Regression
# 用postResample来测定RMSE和R2

library(mlbench)
data(BostonHousing)
set.seed(280)
bh_index <- createDataPartition(BostonHousing$medv, p = .75, list = FALSE)
bh_tr <- BostonHousing[ bh_index, ]
bh_te <- BostonHousing[-bh_index, ]
set.seed(7279)
lm_fit <- train(medv ~ . + rm:lstat,
                data = bh_tr, 
                method = "lm")
bh_pred <- predict(lm_fit, bh_te)
    
postResample(pred = bh_pred, obs = bh_te$medv)
RMSE(pred = bh_pred, obs = bh_te$medv)
R2(pred = bh_pred, obs = bh_te$medv)


## Measures for Predicted Classes

set.seed(144)
true_class <- factor(sample(paste0("Class", 1:2), 
                            size = 1000,
                            prob = c(.2, .8), replace = TRUE))
true_class <- sort(true_class)
class1_probs <- rbeta(sum(true_class == "Class1"), 4, 1)
class2_probs <- rbeta(sum(true_class == "Class2"), 1, 2.5)
test_set <- data.frame(obs = true_class,
                       Class1 = c(class1_probs, class2_probs))
test_set$Class2 <- 1 - test_set$Class1
test_set$pred <- factor(ifelse(test_set$Class1 >= .5, "Class1", "Class2"))
ggplot(test_set, aes(x = Class1)) + 
    geom_histogram(binwidth = .05) + 
    facet_wrap(~obs) + 
    xlab("Probability of Class #1")

# 用confusionMatrix显示分类结果
confusionMatrix(data = test_set$pred, reference = test_set$obs)
# 如果用precision和recall的话
confusionMatrix(data = test_set$pred, reference = test_set$obs, mode = "prec_recall")
# 另外还有sensitivity, specificity, posPredValue, negPredValue, precision, recall, F_meas
# 还可以用postResample来测定
postResample(pred = test_set$pred, obs = test_set$obs)

## Measures for Class Probabilities
twoClassSummary(test_set, lev = levels(test_set$obs))
prSummary(test_set, lev = levels(test_set$obs))
mnLogLoss(test_set, lev = levels(test_set$obs))
# multiClassSummary 


## Lift Curves
set.seed(2)
lift_training <- twoClassSim(1000)
lift_testing  <- twoClassSim(1000)

ctrl <- trainControl(method = "cv", classProbs = TRUE,
                     summaryFunction = twoClassSummary)

set.seed(1045)
fda_lift <- train(Class ~ ., data = lift_training,
                  method = "fda", metric = "ROC",
                  tuneLength = 20,
                  trControl = ctrl)
set.seed(1045)
lda_lift <- train(Class ~ ., data = lift_training,
                  method = "lda", metric = "ROC",
                  trControl = ctrl)

set.seed(1045)
c5_lift <- train(Class ~ ., data = lift_training,
                 method = "C5.0", metric = "ROC",
                 tuneLength = 10,
                 trControl = ctrl,
                 control = C5.0Control(earlyStopping = FALSE))

## Generate the test set results
lift_results <- data.frame(Class = lift_testing$Class)
lift_results$FDA <- predict(fda_lift, lift_testing, type = "prob")[,"Class1"]
lift_results$LDA <- predict(lda_lift, lift_testing, type = "prob")[,"Class1"]
lift_results$C5.0 <- predict(c5_lift, lift_testing, type = "prob")[,"Class1"]
head(lift_results)
# 画出曲线
trellis.par.set(caretTheme())
lift_obj <- lift(Class ~ FDA + LDA + C5.0, data = lift_results)
plot(lift_obj, values = 60, auto.key = list(columns = 3,
                                            lines = TRUE,
                                            points = FALSE))

