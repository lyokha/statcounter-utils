library(leaflet)
library(htmltools)
library(plyr)

cities <- function(gcities, geocode, len = as.integer(.Machine$integer.max),
                   FUN = function(x) TRUE) {
    if (!is.data.frame(gcities)) {
        gcities <- read.csv(gcities, header = TRUE, sep = ";", as.is = TRUE)
    }
    geocodes <- read.csv(geocode, header = TRUE, sep = ";", as.is = TRUE,
                         na.strings = "null")

    d <- merge(gcities, geocodes, 1:3)
    d <- d[order(-d$Count), ]
    d <- d[!is.na(d$Longitude) & FUN(d), ]

    m <- leaflet()
    m <- addTiles(m)

    dh <- head(d, len)

    nrow <- nrow(dh)
    if (nrow == 0) {
        print("No cities to render", quote = FALSE)
        return(m)
    }

    for (x in 1:nrow) {
        l <- list(c(dh[x, 3], "#03F"), c(dh[x, 2], "#F90"), c(dh[x, 1], "#F30"),
                  c("<UNKNOWN LOCATION>", "#666"))

        for (v in l) {
            if (v[1] != "") {
                v[1] <- htmlEscape(v[1])
                break
            }
        }

        m <- addCircleMarkers(m, lng = dh[x, 5], lat = dh[x, 6], color = v[2],
                              radius = 5 * log(dh[x, 4], 10),
                              popup = paste(v[1], ",", dh[x, 4]))
    }

    print(paste(nrow, "cities rendered"), quote = FALSE)

    return(m)
}

cities_df <- function(statcounter_log_csv, cities_spells_filter_awk = "",
                      type = "page view") {
    df <- read.csv(`if`(cities_spells_filter_awk == "",
                        statcounter_log_csv,
                        pipe(paste("awk -f", cities_spells_filter_awk,
                                   statcounter_log_csv))),
                   header = TRUE, sep = ",", quote = "\"", as.is = TRUE)

    if (type != "") {
        df <- df[df$Type == type, ]
    }

    return(df)
}

gcities <- function(cs) {
    d <- count(cs, c("Country", "Region", "City"))
    names(d)[4] <- "Count"

    return(d[order(-d$Count), ])
}

