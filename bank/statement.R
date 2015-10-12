# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

bankStatementFile <- 'data/bank/092015-1.csv'
itemsFile <- 'bank/items.csv'

#
# READING DATA
#
colClasses <- c('factor', rep('character', 3), 'numeric')
transactions <- as.data.table(read.csv(bankStatementFile, header=T,
                                       colClasses=colClasses))

colClasses <- c('factor', 'character', 'logical', 'factor')
items <- fread(itemsFile, header=T, colClasses=colClasses)
items$id <- as.factor(items$id)
items$category <- as.factor(items$category)
items$id <- as.factor(items$id)

#
# SET UP DATA
#
colNames<- c('type', 'date', 'postdate', 'description', 'amount')
setnames(transactions, names(transactions), colNames)

dateFormat <- '%m/%d/%Y'
transactions$date <- as.Date(transactions$date, format=dateFormat)
transactions$postdate <- as.Date(transactions$postdate, format=dateFormat)

#
# CLEANING DATA
#

