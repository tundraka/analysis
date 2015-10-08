library(data.table)
library(stringr)
library(ggplot2)

vaersDataFile <- 'data/VAERS/2014/2014VAERSDATA.CSV'

datesAs <- 'character'
colClasses <- c('numeric', datesAs, 'factor', rep('numeric', 3), 'factor', datesAs,
                'character', 'factor', datesAs, rep('factor', 3), 'numeric',
                rep('factor', 3), rep(datesAs, 2), 'numeric', 'character',
                rep('factor', 2), rep('character', 5))

colNames <- c('vaersid', 'datereceived', , 'state', 'age', 'ageyears', 'agemonths',
              'sex', 'reportdate', 'symptoms', 'died', 'datedied',
              'lifethreateningeffect', 'ervisit', 'hospitalized',
              'hospitalizeddays', 'prolongedhospitalization', 'disable',
              'recovered', 

# According to the VAERS code book, the age fields represent:
#
# The values for this variable range from 0 to <1. It is only calculated for
# patients age 2 years or less. The variables CAGE_YR and CAGE_MO work in
# conjunction to specify the calculated age of a person. For example, if
# CAGE_YR=1 and CAGE_MO=.5 then the age of the individual is 1.5 years or 1 year
# 6 months.
ageDifference <- vaersdata[(age != (ageyears + agemonths)), .N]
if (ageDifference > 0) {
    print('The reported age in "age" and the sum of "ageyears" + "agemonths" is')
    print(paste('different in:', ageDifference, 'records'))
}

# fread is reading string fields that contain a , as different fields, looks like
# this is a know issue.
vaersdata <- as.data.table(read.csv(vaersDataFile, colClasses=colClasses))

# TODO set better column names.
currentColNames <- names(vaersdata)
setnames(vaersdata, currentColNames, tolower(gsub('_', '', currentColNames)))

totsByState <- vaersdata[,.(tot=.N), .(state)][order(-tot)]
topTot <- 20
ggplot(totsByState[1:topTot], aes(state, tot)) +
       geom_bar(stat='identity') +
       labs(title=paste('2014 VAERS: Reports by top', topTot, 'states'))

# Let's select only the top 10 states.
# TODO. I need to order based on the total. Right now it's ordering by the state
# and sex since the total by state is divided between male/female/unknown. Probably
# what I'll need to do is some melt/dcast
topTot <- 10
totsBySexState <- vaersdata[state==totsByState[1:topTot, .(state)]$state,
                            .(tot=.N),
                            .(state, sex)][order(state, sex)]

ggplot(totsBySexState, aes(state, tot, fill=sex)) +
    geom_bar(stat='identity') +
    labs(title=paste('2014 VAERS: Top', topTot, 'states with more reports'))

# What's the age distribution in the VAERS reports?
ageDist <- vaersdata[!is.na(ageyrs),.(tot=.N),.(ageyrs)][order(ageyrs)]
ggplot(ageDist, aes(ageyrs, tot)) +
    geom_bar(stat='identity') +
    labs(title='2014 VAERS: Age distribution')

ageBreaks <- c(0, 1, 5, 10, 20, 30, 40, 1000)
breakLabels <- c('0-1', '1-5', '5-10', '10-20', '20-30', '30-40', '40+')
table(cut(vaersdata[!is.na(ageyrs), .(ageyrs)]$ageyrs, ageBreaks,
         labels=breakLabels))
