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

    fileName <- function(acctFile) {
        paste0(
               configuration$filePath,
               configuration$filePrefix,
               acctFile,
               configuration$extension)
    }

    readStatements <- function() {

        readFile <- function(fileName, classes, cols, label) {
            data <- fread(fileName, header=T, colClasses=classes, select=cols)
            data[,account:=label]

            data
        }

        # Col names/classes for the CC/debit statements
        debClasses <- c(rep('character', 3), 'numeric', rep('character', 4))
        ccClasses <- c(rep('character', 4), 'numeric');

        # The col selected are:
        # 1: Type
        # 2: Transaction date
        # 4: Description
        # 5: Amount
        ccColSelected <- c(1, 2, 4, 5)

        cc1 <- readFile(fileName(1), ccClasses, ccColSelected, 'CC1')
        cc2 <- readFile(fileName(2), ccClasses, ccColSelected, 'CC2')
        debit <- readFile(fileName(3), debClasses, 1:4, 'DEBIT')

        transactions <- rbindlist(list(cc1, cc2, debit))

        # Removing temp variables.
        remove(cc1, cc2, debit)

        colNames<- c('type', 'date', 'description', 'amount', 'account')
        setnames(transactions, names(transactions), colNames)
        transactions[,`:=`(description=gsub(' +', ' ', description),
                           date=as.Date(date, format=configuration$dateFormat),
                           type=as.factor(tolower(type)))]

        return(transactions)
    }

    list(
         fileName=fileName,
         readStatements=readStatements
    )
}

