# ITEMS

itemsFile <- 'bank/items.csv'
privateItemsFile <- 'data/bank/private-items.csv'
colClasses <- c('factor', 'character', 'logical', 'factor', 'character')
itemsPublic <- fread(itemsFile, header=T, colClasses=colClasses)
itemsPrivate <- fread(privateItemsFile, header=T, colClasses=colClasses)

items <- rbindlist(list(itemsPublic, itemsPrivate))
remove(itemsPublic, itemsPrivate)

items[, c('itemid', 'category'):=list(as.factor(itemid), as.factor(category))]
nItems <- nrow(items)

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

