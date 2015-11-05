# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

filePath <- 'data/bank/'
filePrefix <- paste0(timePeriod, '-')
fileExtension <- '.csv'
dateFormat <- '%m/%d/%Y'

fileName <- function(actFile) {
    paste0(filePath, filePrefix, actFile, fileExtension)
}

#
# READING DATA
#

itemsFile <- 'bank/items.csv'
privateItemsFile <- 'data/bank/private-items.csv'
colClasses <- c('factor', 'character', 'logical', 'factor', 'character')
itemsPublic <- fread(itemsFile, header=T, colClasses=colClasses)
itemsPrivate <- fread(privateItemsFile, header=T, colClasses=colClasses)

items <- rbindlist(list(itemsPublic, itemsPrivate))
remove(itemsPublic, itemsPrivate)

items[, c('itemid', 'category'):=list(as.factor(itemid), as.factor(category))]
nItems <- nrow(items)

# Col names/classes for the CC statements
colNames<- c('type', 'date', 'description', 'amount', 'account')
colClasses <- c(rep('character', 4), 'numeric')

# The col selected are:
# 1: Type
# 2: Transaction date
# 4: Description
# 5: Amount
colSelected <- c(1, 2, 4, 5)

# Reading both CC statements
cc1Data <- fread(fileName(1), header=T, colClasses=colClasses, select=colSelected)
cc1Data[,account:='CC1']

cc2Data <- fread(fileName(2), header=T, colClasses=colClasses, select=colSelected)
cc2Data[,account:='CC2']

# Reading the debit account statement
colClasses <- c(rep('character', 3), 'numeric', rep('character', 4))
debit <- fread(fileName(3), header=T, colClasses=colClasses, select=1:4)
debit[,account:='DEBIT']

transactions <- rbindlist(list(cc1Data, cc2Data, debit))

# Removing temp variables.
remove(cc1Data, cc2Data, debit)

setnames(transactions, names(transactions), colNames)
transactions[,`:=`(description=gsub(' +', ' ', description),
                   date=as.Date(date, format=dateFormat),
                   type=as.factor(tolower(type)))]

#
# CLASSIFYING DATA
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

transactions[, c('itemid', 'day'):=
             list(sapply(description, classifyItem), weekdays(date))]
transactions <- merge(transactions, items[,.(itemid, category, name)], by='itemid')
