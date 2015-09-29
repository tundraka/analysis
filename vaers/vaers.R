library(data.table)

# TODO. The Date fields are not detected.
colClasses <- c('numeric', 'date', 'factor', rep('numeric', 3), 'factor', 'date',
                'character', 'logical', 'date', rep('logical', 3), 'numeric',
                rep('logical', 3)
vaersdata <- fread('../data/VAERS/2014/2014VAERSDATA.CSV')
vaersdata <- rename(vaersdata,
                    ReportDate = RECVDATE,
                    State = STATE,
                    Age = AGE_YRS,
                    Years = CAGE_YR,
                    Months = CAGE_MO)

# Or without dplyr
# names(vaersdata)[1] <- "ReportDate"
# names(vaersdata)[2] <- "State"
# names(vaersdata)[3] <- "Age"
# etc.

# Some commands
# head
# summary(vaersdata$STATE)
# tail
# str
# dim
#

