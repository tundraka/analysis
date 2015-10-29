# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

bankStatementFile <- 'data/bank/201509-2.csv'
itemsFile <- 'bank/items.csv'

#
# READING DATA
#
colClasses <- c('factor', rep('character', 3), 'numeric')
transactions <- as.data.table(read.csv(bankStatementFile, header=T,
                                       colClasses=colClasses))

colClasses <- c('factor', 'character', 'logical', 'factor', 'character')
items <- fread(itemsFile, header=T, colClasses=colClasses)
items$itemid <- as.factor(items$itemid)
items$category <- as.factor(items$category)
nItems <- nrow(items)

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

classifyItem <- function(description) {
    for (i in 1:nItems) {
        item <- items[i]
        if (item$regexp & grepl(item$description, description, ignore.case=T)) {
            return(item$itemid)
        }
    }

    as.factor('UNK')
}

transactions[,itemid:=sapply(description, classifyItem)]

#
# Explore
#
summarySales <- merge(transactions[type=='Sale',
                      .(description, amount=amount*-1, itemid)
                      ], items[,.(itemid, category, name)],
                 by='itemid')

summarySales[, .(tot=sum(amount), visits=.N), .(name, category)][order(category, -tot)]
summarySales[, .(tot=sum(amount)), .(category)][order(-tot)]
