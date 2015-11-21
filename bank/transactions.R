# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

statement <- function() {
    dateFormat = '%m/%d/%Y'

    readStatements <- function(fileName, conf, acct) {

        transactions <- fread(fileName, header=T, colClasses=conf$cols, select=conf$sel)

        colNames<- c('type', 'date', 'description', 'amount')
        setnames(transactions, names(transactions), colNames)
        transactions[,`:=`(description=gsub(' +', ' ', description),
                           date=as.Date(date, format=dateFormat),
                           type=as.factor(tolower(type)),
                           account=acct)]

        return(transactions)
    }

    list(
         readStatements=readStatements
    )
}

