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

fileTypeConf <- list(
    DEBIT = list(
        cols=c(rep('character', 3), 'numeric', rep('character', 4)),
        sel=1:4),
    CC1 = list(
        cols=c(rep('character', 4), 'numeric'),
        sel=c(1, 2, 4, 5)),
    CC2 = list(
        cols=c(rep('character', 4), 'numeric'),
        sel=c(1, 2, 4, 5))
    )

readTransactions <- function(fileName) {
    trx <- data.table()
    fileNameParts <- unlist(strsplit(basename(fileName), "\\."))
    if (length(fileNameParts) == 2) {
        acct <- fileNameParts[1]
        conf <- fileTypeConf[[acct]]
        trx <- statementLoader$readStatements(fileName, conf, acct)
    } else {
        print(paste('unable to read file', fileName))
    }

    transactions <<- rbind(transactions, trx)
}
files <- list.files('data/bank/2015/08', pattern="*.csv", all.files=T,
                    full.names=T)
transactions <- data.table()
lapply(files, readTransactions)

#transactions <- statementLoader$readStatements('201510')
#transactions <- classifier$classify(transactions)

# 
#
# Explore
#
#sales <- transactions[type=='sale',
                      #.(description, category, name, amount=amount*-1, day)]

#sales[, .(tot=sum(amount)), .(category)][order(-tot)]
#sales[, .(tot=sum(amount), visits=.N), .(name, category)
      #][order(category, -tot)]

## Some specifics.
#printCategory <- function(cat) {
    #sales[category==cat, .(tot=sum(amount), visits=.N),
                 #.(name)][,.(name, tot, visits,
                             #totpvisit=round(tot/visits, digits=2))][
                 #order(-tot, visits)]
#}

#cats <- c('groceries', 'restaurant')
#lapply(cats, printCategory)

## Draw a boxplot for each day and category
#ggplot(sales, aes(day, amount)) + geom_boxplot()
#ggplot(sales, aes(category, amount)) + geom_boxplot()
#ggplot(sales, aes(x=day, y=category)) + geom_bin2d() +
    #scale_fill_gradient(low="green", high="red")
