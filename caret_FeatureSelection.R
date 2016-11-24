### Feature Selection Overview

## Models with Built-In Feature Selection
## Feature Selection Methods
## External Validation


## Models with Built-In Feature Selection
# 可以通过train函数直接进行变量选择的模型
# ada, bagEarth, bagFDA, bstLs, bstSm, C5.0,C5.0Cost, C5.0Rules, C5.0Tree, 
# cforest, ctree, ctree2, cubist, earth, enet, evtree, extraTrees, fda, 
# gamboost, gbm, gcvEarth,glmnet, glmStepAIC, J48, JRip, lars, lars2, lasso, 
# LMT, LogitBoost, M5, M5Rules, nodeHarvest, oblique.tree, OneR, ORFlog, ORFpls, 
# ORFridge, ORFsvm, pam, parRF, PART, penalized, PenalizedLDA, qrf, 
# relaxo, rf, rFerns, rpart, rpart2, rpartCost, RRF,RRFglobal, smda, sparseLDA


## Feature Selection Methods
# wrapper方法：将predictor作为input，将model performance作为output进行优化。caret的wrapper方法
# 基于recursive feature elimination, genetic algorithms, and simulated annealing。
# filter方法：先选择满足一定条件(独立于模型)的predictor，之后再建模。
# caret的filter方法基于univariate filters。

