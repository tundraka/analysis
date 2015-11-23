fileConf <- list(
    DEBIT = list(
        cols=c(rep('character', 3), 'numeric', rep('character', 4)),
        sel=1:4,
        header=T),
    CC1 = list(
        cols=c(rep('character', 4), 'numeric'),
        sel=c(1, 2, 4, 5),
        header=T),
    CC2 = list(
        cols=c(rep('character', 4), 'numeric'),
        sel=c(1, 2, 4, 5),
        header=T)
    )
