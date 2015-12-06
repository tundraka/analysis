# init.R will do the data loading.
setwd('~/Documents/code/analysis/bank')
library(ggplot2)

source('./init.R')
transactions <- initialize('../data/bank/2015', '*/DEBIT.csv')

# Adding a colum that contain the YYYY-mm
transactions[,ym:=format(date, '%Y-%m')]
deb <- transactions[category %in% c('ccpayments', 'recurring', 'income',
                                    'withdraw', 'checks', 'utilities'),
                    .(total=sum(amount)), .(category, ym)]
ggplot(deb, aes(ym, total, group=category)) +
    geom_line(aes(color=category, width=3)) +
    scale_y_continuous(breaks=c(-20000, -10000, -5000, -2500, -1000, -500, 0,
                                500, 1000, 2500, 5000, 10000, 20000))
