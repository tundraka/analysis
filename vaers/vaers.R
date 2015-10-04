library(data.table)

vaersDataFile <- '../data/VAERS/2014/2014VAERSDATA.CSV'
#vaersDataFile <- '2014VAERSDATA.CSV'
datesAs <- 'character'
colClasses <- c('numeric', datesAs, 'factor', rep('numeric', 3), 'factor', datesAs,
                'character', 'factor', datesAs, rep('factor', 3), 'numeric',
                rep('factor', 3), rep(datesAs, 2), 'numeric', 'character',
                rep('factor', 2), rep('character', 5))

# fread is reading string fields that contain a , as different fields, looks like
# this is a know issue.
vaersdata <- as.data.table(read.csv(vaersDataFile, colClasses=colClasses))

# TODO. The Date fields are not detected.
