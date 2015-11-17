# statement.R will do the data loading.
source('bank/transactions.R')
source('bank/classification.R')

library(ggplot2)

# TODO Load the list of time periods
# Event though I try to make this generic, like specifyng where the data is, what
# are the file naming conventions, seems to me that the R code is linked so
# closely to the data and formats of the files that will read. For example, I set
# a conf for the data paths following a specific pattern. Then I can say for those
# files, read the columns X, Y, Z, and so on keep adding specifics, but a generic
# way cannot be defined, unless I impose that a pattern, put things here, name
# them like this, make sure this column represents this, and so on.
statementLoader <- statement()
classifier <- classification()

transactions <- statementLoader$readStatements('201510')
transactions <- classifier$classify(transactions)

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
