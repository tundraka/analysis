# Bank names are organized like mmyyyy-bankid.csv
library(data.table)

source('./modules/fileconf.R')

statement <- function(path, filesExp) {
    dateFormat = '%m/%d/%Y'
    transactions <- data.table()
    FileConf <- FileConfiguration()

    readStatements <- function(fileName, conf, acct) {

        transactions <- fread(fileName, header=conf$header, colClasses=conf$cols,
                              select=conf$sel)

        colNames<- c('type', 'date', 'description', 'amount')
        setnames(transactions, names(transactions), colNames)
        transactions[,`:=`(description=gsub(' +', ' ', description),
                           date=as.Date(date, format=dateFormat),
                           type=as.factor(tolower(type)),
                           account=acct)]

        return(transactions)
    }

    getSelectedFiles <- function() {
        files <- list.files(path, all.files=T, full.names=T, recursive=T)
        files <- files[grep(filesExp, files)]

        files
    }

    readTransactions <- function(fileName) {
        trx <- data.table()
        fileNameParts <- unlist(strsplit(basename(fileName), "\\."))
        if (length(fileNameParts) == 2) {
            acct <- fileNameParts[1]
            conf <- FileConf$getFileConf(acct)
            if (! is.null(conf)) {
                trx <- readStatements(fileName, conf, acct)
            }
        } else {
            print(paste('unable to read file', fileName))
        }

        transactions <<- rbind(transactions, trx)
    }
    

    load <- function() {
        files <- getSelectedFiles()
        lapply(files, readTransactions)

        transactions
    }

    list(
         load=load
    )
}

