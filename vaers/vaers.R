# Information about the data needed in this script can be found in the README.
# https://github.com/tundraka/analysis/blob/master/vaers/README.md
#
library(data.table)
library(stringr)
library(ggplot2)

dataLabel <- '2014 VAERS'
datesAs <- 'character'

#
# READING VAERS DATA
#
vaersDataFile <- 'data/VAERS/2014/2014VAERSDATA.CSV'
vaersColClasses <- c('numeric', datesAs, 'factor', rep('numeric', 3), 'factor',
                     datesAs, 'character', 'factor', datesAs, rep('factor', 3),
                     'numeric', rep('factor', 3), rep(datesAs, 2), 'numeric',
                     'character', rep('factor', 2), rep('character', 5))

vaersColNames <- c('vaersid', 'datereceived', , 'state', 'age', 'ageyears',
                   'agemonths', 'sex', 'reportdate', 'symptoms', 'died',
                   'datedied', 'lifethreateningeffect', 'ervisit', 'hospitalized',
                   'hospitalizeddays', 'prolongedhospitalization', 'disable',
                   'recovered', 'vaccinationdate', ...)

# fread is reading string fields that contain a , as different fields, looks like
# this is a know issue.
vaersdata <- as.data.table(read.csv(vaersDataFile, colClasses=colClasses))

# TODO set better column names.
currentColNames <- names(vaersdata)
setnames(vaersdata, currentColNames, tolower(gsub('_', '', currentColNames)))

#
# READING VAERSVAX DATA
#

vaxDataFile <- 'data/VAERS/2014/2014VAERSVAX.csv'
vaxColClasses <- c('numeric', 'factor', rep('character', 3), rep('factor', 2),
                   'character')
vaxColNames <- c('vaersid', 'type', 'manufacturer', 'lot', 'dose', 'route',
                 'site', 'name')
vaxdata <- fread(vaxDataFile, colClasses=vaxColClasses)
setnames(vaxdata, names(vaxdata), vaxColNames)

#
# PROCESSING
#

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

#
# Reports created by state. What are the states that report the most cases.
#

totsByState <- vaersdata[,.(tot=.N), .(state)][order(-tot)]
topTot <- 20
ggplot(totsByState[1:topTot], aes(state, tot)) +
       geom_bar(stat='identity') +
       labs(title=paste(paste(dataLabel, ': Reports by top', topTot, 'states')))

# Let's select only the top 10 states.
#
# TODO. I need to order based on the total. Right now it's ordering by the state
# and sex since the total by state is divided between male/female/unknown. Probably
# what I'll need to do is some melt/dcast
topTot <- 10
totsBySexState <- vaersdata[state %in% totsByState[1:topTot, .(state)]$state,
                            .(tot=.N),
                            .(state, sex)][order(state, sex)]

ggplot(totsBySexState, aes(state, tot, fill=sex)) +
    geom_bar(stat='identity') +
    labs(title=paste(dataLabel, ': Top', topTot, 'states with more reports'))

# What's the age distribution in the VAERS reports?
ageDist <- vaersdata[!is.na(ageyrs),.(tot=.N),.(ageyrs)][order(ageyrs)]
ggplot(ageDist, aes(ageyrs, tot)) +
    geom_bar(stat='identity') +
    labs(title=paste(dataLabel, ': Age distribution'))

# What's the age distribution and sex?
ageBreaks <- c(-1, 1, 5, seq(10, 100, by=10), 2000)
#ageLabels <- c('0-1', '1-5', '5-10', '10-20', '20-30', '30-40', '40-60', '60+')
ages <- vaersdata[!is.na(ageyrs), .(ageyrs, sex)]
ages[,agesegment:=cut(ages$ageyrs, ageBreaks)]#, labels=ageLabels)]
ggplot(ages, aes(agesegment, fill=sex)) +
    geom_bar() + 
    labs(title=paste(dataLabel, ': Reports by age.')) +
    labs(x='Age group') +
    labs(y='Total')

# What are the vaccines that generated the most reports by state
vaxinfo <- merge(vaersdata[, .(vaersid, state, sex, ageyrs)],
                 vaxdata[,.(vaersid, type, manufacturer, name)],
                 by='vaersid')
topStatesVaxInfo <- vaxinfo[state %in% totsByState[1:topTot, .(state)]$state &
                            ageyrs < 2.5
                            .(tot=.N),
                            .(sex, state, type)]
# todo, this needs to be refined.
ggplot(topStatesVaxInfo, aes(state, tot, fill=type)) +
    geom_bar(stat='identity') +
    facet_grid(sex ~ .)

# Most commons reported vaccines for <5 yrs

# If we will be working with ages, let's remove the NAs.
vaxinfoages <- vaxinfo[!is.na(ageyrs)]
ageSegments <- cut(vaxinfoages$ageyrs, c(-1, 1, 2.5, 5, 12, 15, 22, 35, 50, 60, 1000))
vaxinfoages[,agesegment:=ageSegments]

vax25 <- vaxinfoages[ageyrs<=5,
                 .(tot=.N),
                 .(type, sex, agesegment)][order(-tot)]
ggplot(vax25, aes(type, tot, fill=sex)) +
    geom_bar(stat='identity') +
    facet_grid(agesegment ~ .) +
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
    labs(title=paste(dataLabel, ':<=5 yrs old, vaccines most reported by gender')) +
    labs(x='Vaccine') +
    labs(y='Reports/Age group')

vax522 <- vaxinfoages[ageyrs>5 & ageyrs<=22,
                 .(tot=.N),
                 .(type, sex, agesegment)][order(-tot)]
ggplot(vax522, aes(type, tot, fill=sex)) +
    geom_bar(stat='identity') +
    facet_grid(agesegment ~ .) +
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
    labs(title=paste(dataLabel,
                     ':22>=age>5 yrs old, vaccines most reported by gender')) +
    labs(x='Vaccine') +
    labs(y='Reports/Age group')

vax22p <- vaxinfoages[ageyrs>22,
                 .(tot=.N),
                 .(type, sex, agesegment)][order(-tot)]
ggplot(vax22p, aes(type, tot, fill=sex)) +
    geom_bar(stat='identity') +
    facet_grid(agesegment ~ .) +
    theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) +
    labs(title=paste(dataLabel,
                     ':>22 yrs old, vaccines most reported by gender')) +
    labs(x='Vaccine') +
    labs(y='Reports/Age group')


# What are the vaccine reports by age?
