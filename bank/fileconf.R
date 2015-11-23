FileConfiguration <- function() {
    ccs <- list(
        cols=c(rep('character', 4), 'numeric'),
        sel=c(1, 2, 4, 5),
        header=T)

    confs <- list(
        DEBIT = list(
            cols=c(rep('character', 3), 'numeric', rep('character', 4)),
            sel=1:4,
            header=T),
        CC1 = ccs,
        CC2 = ccs)
    
    getFileConf <- function(fileName) {
        conf <- NULL
        if (fileName %in% names(confs)) {
            conf <- confs[[fileName]]
        }

        conf
    }

    return list(
        getFileConf=getFileConf
    )
}
