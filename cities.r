library(leaflet)
library(htmltools)

cities <- function(gcities, geocode, len = as.integer(.Machine$integer.max)) {
    gcities <- read.csv(file = gcities, header = TRUE, sep = ";", as.is = TRUE)
    geocodes <- read.csv(file = geocode, header = TRUE, sep = ";", as.is = TRUE)

    d <- merge(gcities, geocodes, by = c(1, 2, 3))
    d <- d[order(-d$Count), ]
    d <- subset(d, d$Longitude != "null")

    m <- leaflet()
    m <- addTiles(m)

    dh <- head(d, len)

    for (x in 1:nrow(dh)) {
        l <- list(c(dh[[x, 3]], "#03F")
                 ,c(dh[[x, 2]], "#F90")
                 ,c(dh[[x, 1]], "#F30")
                 ,c("<UNKNOWN LOCATION>", "#666")
                 )

        for (v in l) {
            if (v[1] != "") {
                v[1] <- htmlEscape(v[1])
                break
            }
        }

        m <- addCircleMarkers(m
                             ,lng = as.numeric(dh[[x, 5]])
                             ,lat = as.numeric(dh[[x, 6]])
                             ,color = v[2]
                             ,radius = 5 * log(as.numeric(dh[[x, 4]]), 10)
                             ,popup = paste(v[1], ", ", dh[[x, 4]])
                             )
    }

    m
}

