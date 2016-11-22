### Note for caret

## Visualizations
# data vasualization with featurePlot function

# library AppliedPredictiveModeling package to set the transparency of Lattice Themes
library(AppliedPredictiveModeling)
transparentTheme(trans = .4)

# classification data sets
# 分类问题的数据

# Scatterplot Matrix of all variables
# 变量散点图
library(caret)
featurePlot(x = iris[, 1:4], 
            y = iris$Species, 
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = 3))
# x: a matrix or data frame of continuous feature/probe/spectra data.
# y: a factor indicating class membership

# Scatterplot Matrix with Ellipses
# 变量散点图(椭圆线)
featurePlot(x = iris[, 1:4], 
            y = iris$Species, 
            plot = "ellipse",
            ## Add a key at the top
            auto.key = list(columns = 3))

# Overlayed Density Plots
# 密度图
transparentTheme(trans = .9)
featurePlot(x = iris[, 1:4], 
            y = iris$Species,
            plot = "density", 
            ## Pass in options to xyplot() to 
            ## make it prettier
            scales = list(x = list(relation="free"), 
                          y = list(relation="free")), 
            adjust = 1.5, 
            pch = "|", 
            layout = c(4, 1), 
            auto.key = list(columns = 3))

# Box Plots
featurePlot(x = iris[, 1:4], 
            y = iris$Species, 
            plot = "box", 
            ## Pass in options to bwplot() 
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),  
            layout = c(4,1 ), 
            auto.key = list(columns = 2))


# regression data sets
# 回归问题的数据
library(mlbench)
data(BostonHousing)
regVar <- c("age", "lstat", "tax")

# Scatter Plots
# 散点图
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 2
trellis.par.set(theme1)

featurePlot(x = BostonHousing[, regVar], 
            y = BostonHousing$medv, 
            plot = "scatter", 
            layout = c(3, 1))
# plot a smooth line
# 画出smooth的线
featurePlot(x = BostonHousing[, regVar], 
            y = BostonHousing$medv, 
            plot = "scatter",
            type = c("p", "smooth"),
            span = .5,
            layout = c(3, 1))
