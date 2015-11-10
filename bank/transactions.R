# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

statement <- function(timePeriod) {
    # TODO. validate timePeriod

    configuration <- list(
        filePath = 'data/bank/',
        filePrefix = paste0(timePeriod, '-'),
        extension = '.csv',
        dateFormat = '%m/%d/%Y'
    )

    conf <- function(newConf) {
    }

    fileName <- function(acctFile) {
        paste0(filePath, filePrefix, acctFile, configuration$extension)
    }

    # Col names/classes for the CC/debit statements
    colNames<- c('type', 'date', 'description', 'amount', 'account')
    debitClasses <- c(rep('character', 4), 'numeric')
    ccClasses <- c(rep('character', 3), 'numeric', rep('character', 4))

    # The col selected are:
    # 1: Type
    # 2: Transaction date
    # 4: Description
    # 5: Amount
    ccColSelected <- c(1, 2, 4, 5)

    readStatements <- function(period) {
        # Reading both CC statements
        cc1Data <- fread(fileName(period, 1), header=T, colClasses=ccClasses,
                         select=ccColSelected)
        cc1Data[,account:='CC1']

        cc2Data <- fread(fileName(period, 2), header=T, colClasses=ccClasses,
                         select=ccColSelected)
        cc2Data[,account:='CC2']

        # Reading the debit account statement
        debit <- fread(fileName(3), header=T, colClasses=debClasses, select=1:4)
        debit[,account:='DEBIT']

        transactions <- rbindlist(list(cc1Data, cc2Data, debit))

        # Removing temp variables.
        remove(cc1Data, cc2Data, debit)

        setnames(transactions, names(transactions), colNames)
        transactions[,`:=`(description=gsub(' +', ' ', description),
                           date=as.Date(date, format=dateFormat),
                           type=as.factor(tolower(type)))]

        return(transactions)
    }

    list(
         conf=conf
         fileName=fileName,
         readStatements=readStatements
    )
}

