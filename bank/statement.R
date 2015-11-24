# init.R will do the data loading.
setwd('~/Documents/code/analysis')
library(ggplot2)

source('bank/init.R')
transactions <- initialize('data/bank/2015', '*/0[89]/*')

# 
#
# Explore
#
sales <- transactions[type=='sale',
                      .(description, category, name, amount=amount*-1, day)]

sales[, .(tot=sum(amount)), .(category)][order(-tot)]
sales[, .(tot=sum(amount), visits=.N), .(name, category)
      ][order(category, -tot)]

# Some specifics.
printCategory <- function(cat) {
    sales[category==cat, .(tot=sum(amount), visits=.N),
                 .(name)][,.(name, tot, visits,
                             totpvisit=round(tot/visits, digits=2))][
                 order(-tot, visits)]
}

cats <- c('groceries', 'restaurant')
lapply(cats, printCategory)

# Draw a boxplot for each day and category
ggplot(sales, aes(day, amount)) + geom_boxplot()
ggplot(sales, aes(category, amount)) + geom_boxplot()
ggplot(sales, aes(x=day, y=category)) + geom_bin2d() +
    scale_fill_gradient(low="green", high="red")
