# init.R will do the data loading.
setwd('~/Documents/code/analysis/bank')
library(ggplot2)

source('./init.R')
transactions <- initialize('../data/bank/2015', '*/CC.\\.csv')

# Adding a colum that contain the YYYY-mm
transactions[,ym:=format(date, '%Y-%m')]
deb <- transactions[!(category %in% c('payment', 'other', 'unknown')),
                    .(total=abs(sum(amount))),
                    .(category, ym)]
ggplot(deb, aes(ym, total, group=category)) +
    geom_line(aes(color=category, width=3))
