library(knitr)

setwd('~/Documents/code/analysis/bank')
knit2html('statement.Rmd', quiet=T) #, output='./output/statement.html')
