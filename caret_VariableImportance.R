### Variable Importance

# 分为用模型和不用模型
# 如果不用模型或模型没有评价importance的指标，则用filter的方法

# varImp利用模型指标来测定变量重要度
gbmImp <- varImp(gbmFit3, scale = FALSE)
gbmImp

# 得到ROC曲线
roc_imp <- filterVarImp(x = training[, -ncol(training)], y = training$Class)
head(roc_imp)

# 画出重要度的图
plot(gbmImp, top = 20)



