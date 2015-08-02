library(dplyr)

# TODO. The Date fields are not detected.
vaersdata <- read.csv('2014VAERSDATA.CSV')
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

