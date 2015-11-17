# ITEMS

classification <- function() {
    config <- list(
        itemsFile = 'bank/items.csv',
        privateItemsFile = 'data/bank/private-items.csv',
        colClasses = c('factor', 'character', 'logical', 'factor', 'character')
    )

    items <- list(
        items = NULL,
        total = NULL
    )

    classifyItem <- function(description) {
        for (i in 1:items$total) {
            item <- items$items[i]
            if (item$regexp & grepl(item$description, description, ignore.case=T)) {
                return(item$itemid)
            }
        }

        as.factor('UNK')
    }

    loadItems <- function() {
        print(config$itemsFile)
        items <- rbindlist(list(
            fread(config$itemsFile, header=T, colClasses=config$colClasses),
            fread(config$privateItemsFile, header=T, colClasses=config$colClasses)
        ))

        items[, c('itemid', 'category'):=list(as.factor(itemid),
                                              as.factor(category))]
        items$items <<- items
        items$total <<- nrow(items)

        remove(items)
    }

    classify <- function(transactions) {
        if (is.null(items$items)) loadItems()

        transactions[, c('itemid', 'day'):=list(
                            sapply(description, classifyItem), weekdays(date))]
        print(class(transactions))
        print(class(items$items))

        transactions <- merge(transactions,
                              items$items[,.(itemid, category, name)],
                              by='itemid')

        return(transactions)
    }

    return(list(
        classify=classify
    ))
}
