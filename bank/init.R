source('bank/modules/transactions.R')
source('bank/modules/classification.R')
source('bank/fileconf.R')

# TODO Load the list of time periods
# Event though I try to make this generic, like specifyng where the data is, what
# are the file naming conventions, seems to me that the R code is linked so
# closely to the data and formats of the files that will read. For example, I set
# a conf for the data paths following a specific pattern. Then I can say for those
# files, read the columns X, Y, Z, and so on keep adding specifics, but a generic
# way cannot be defined, unless I impose that a pattern, put things here, name
# them like this, make sure this column represents this, and so on.

initialize <- function(path, files) {
    statements <- statement(path, files)
    classifier <- classification()

    # TODO. classification as part of loading?
    transactions <- statements$load()
    transactions <- classifier$classify(transactions)

    transactions
}
