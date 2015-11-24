library(knitr)

setwd('~/Documents/code/analysis')
knit2html('bank/statement.Rmd', output='bank/output/statement.html', quiet=T)
