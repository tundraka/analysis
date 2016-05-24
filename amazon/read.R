library(data.table)

colClasses <- c('date', rep('character', 2), 'type', rep('character', 3), 'date',
                rep('character', 5), 'numeric', rep('character', 4), 'date',
                rep('character', 15), 'type', 'character')
colSelect <- c(1, 3, 4, 15, 30)
colNames <- c('date', 'description', 'itemtype', 'payment', 'total')

data <- fread('../data/amazon/2016.csv', header=T, colClasses=colClasses, select=colSelect)

setnames(data, names(data), colNames)
data[,`:=`(date=as.Date(date, format='%m/%d/%y'),
           itemtype=as.factor(tolower(gsub(' ', '_', itemtype))),
           total=as.numeric(sub('\\$', '', total))
           )]
